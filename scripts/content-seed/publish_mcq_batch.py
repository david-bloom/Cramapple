#!/usr/bin/env python3
"""Publish a batch of generate-and-select MCQs (protocol v0.6 section 0) to Development or Production.

Replaces hand-carried SQL: the script sends each chunk to the Supabase Management API
(POST /v1/projects/{ref}/database/query, the endpoint behind `supabase db query --linked` and the
Supabase MCP) using the CLI's stored access token (~/.supabase/access-token or SUPABASE_ACCESS_TOKEN).
No database password is needed and the CLI link is not touched. The token is never printed.

Each chunk is ONE transaction that inserts the drafts and walks the whole publish path, so a failure
leaves nothing behind:
  drafts -> text hash check against the local plan -> owner review assignment + approve decision ->
  structural QA -> reviewed_approved -> serving label (validated) -> primary topic cell (validated) ->
  skill cell (when the plan has one) -> difficulty row -> published -> post-checks.
`rehearse` runs the same transaction and rolls it back; `publish` commits it. Re-running `publish`
skips chunks that are already published with matching text and stops on any partial or mismatched state.

Commands
  plan-from-seed-batch  build plan.json from a seed_pipeline.mjs batch (seeds + variants)
  preflight             read-only: pack, taxonomy, owner, key collisions, topics, skills
  rehearse              full transaction per chunk, rolled back (expects REHEARSAL OK)
  publish               full transaction per chunk, committed (Production needs --approval and --confirm-production)
  verify                read-only: independent post-publish check of every item
  republish             existing retired MCQs, content copied verbatim into a new version and published
                        (rehearse only unless --commit; Production commit needs --approval and --confirm-production)

  python3 publish_mcq_batch.py plan-from-seed-batch --batch DIR --key-prefix APBIO-MCQ --first-seed 122 --source TAG --out plan.json
  python3 publish_mcq_batch.py rehearse --plan plan.json --env dev --owner <uuid>
  python3 publish_mcq_batch.py publish  --plan plan.json --env prod --approval APPROVAL-0132 --confirm-production

Plan format (plan.json):
  {"subject_key": "biology", "source": "<tag>", "run_note": "<text>", "items": [
     {"content_key", "kind": "seed"|"variant"|"item", "seed_key", "unit", "topic", "title",
      "skill": code|null, "skill_status": "validated"|"provisional_model"|null, "skill_note",
      "difficulty": "Easy"|"Medium"|"Hard", "difficulty_note",
      "stem", "choices": [{"choice_key", "choice_text", "is_correct", "rationale"}] }]}
Variants take difficulty basis `translated` from their seed (DECISION-0096); seeds and plain items take
`calibrated_judgement` with confidence low (DECISION-0101). No human review (DECISION-0102).
"""
import argparse, collections, glob, hashlib, json, os, secrets, sys, time, urllib.error, urllib.request

ENVS = {'dev': 'wmgjsdkphcyhngaffbqf', 'prod': 'pcntajvbdfqhbeewmdry'}
DEFAULT_OWNER = 'f5a26c6b-3566-4d58-9e97-979fbb947564'  # David Bloom (Product Owner) in Production


# ---------------------------------------------------------------- API
def token():
    t = os.environ.get('SUPABASE_ACCESS_TOKEN') or open(os.path.expanduser('~/.supabase/access-token')).read().strip()
    if not t.startswith('sbp_'):
        sys.exit('access token missing or malformed (run `supabase login`)')
    return t


def query(ref, sql, expect_error=False):
    """Run SQL on project `ref`. Returns rows, or (for expect_error) the error message text."""
    req = urllib.request.Request(f'https://api.supabase.com/v1/projects/{ref}/database/query',
                                 data=json.dumps({'query': sql}).encode(), method='POST',
                                 headers={'Authorization': f'Bearer {token()}', 'Content-Type': 'application/json',
                                          'User-Agent': 'cramapple-publish-mcq-batch/1'})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=300) as r:
                rows = json.loads(r.read())
            if expect_error:
                raise RuntimeError('expected the transaction to raise, but it succeeded')
            return rows
        except urllib.error.HTTPError as e:
            body = e.read().decode(errors='replace')
            if e.code in (429, 502, 503, 504) and attempt < 2:
                time.sleep(5 * (attempt + 1)); continue
            try:
                msg = json.loads(body).get('message', body)
            except ValueError:
                msg = body
            if expect_error:
                return msg
            raise RuntimeError(f'HTTP {e.code}: {msg[:2000]}')


def lit(s):
    return 'null' if s is None else "'" + str(s).replace("'", "''") + "'"


def dollar(s):
    tag = 'p' + secrets.token_hex(6)
    assert f'${tag}$' not in s
    return f'${tag}${s}${tag}$'


def item_hash(stem, choices):
    cs = sorted(choices, key=lambda c: c['choice_key'])
    return hashlib.md5((stem + '|' + '|'.join(
        f"{c['choice_key']}:{c['choice_text']}:{str(bool(c['is_correct'])).lower()}:{c['rationale']}" for c in cs)).encode()).hexdigest()


# ---------------------------------------------------------------- plan
def load_plan(path):
    plan = json.load(open(path))
    keys = [it['content_key'] for it in plan['items']]
    assert len(keys) == len(set(keys)), 'duplicate content_key in plan'
    for it in plan['items']:
        k = it['content_key']
        assert it['kind'] in ('seed', 'variant', 'item'), k
        assert it['kind'] != 'variant' or it.get('seed_key'), f'{k}: variant without seed_key'
        assert it['difficulty'] in ('Easy', 'Medium', 'Hard'), f'{k}: difficulty'
        assert (it.get('skill') is None) == (it.get('skill_status') in (None, 'none')), f'{k}: skill/status mismatch'
        assert it.get('skill_status') in (None, 'none', 'validated', 'provisional_model'), f'{k}: skill_status'
        ch = it['choices']
        assert sorted(c['choice_key'] for c in ch) == ['A', 'B', 'C', 'D'], f'{k}: choice keys'
        assert sum(bool(c['is_correct']) for c in ch) == 1, f'{k}: exactly one correct choice'
        assert len({c['choice_text'].strip().lower() for c in ch}) == 4, f'{k}: duplicate choice text'
        assert it['stem'].strip() and all(c['rationale'].strip() for c in ch), f'{k}: blank stem or rationale'
        assert int(it['unit']) > 0 and it['topic'].split('.')[0] == str(it['unit']), f'{k}: topic {it["topic"]} not in unit {it["unit"]}'
        it['hash'] = item_hash(it['stem'], ch)
        it['keyed'] = next(c['choice_key'] for c in ch if c['is_correct'])
    seeds = {it['content_key']: it for it in plan['items'] if it['kind'] == 'seed'}
    for it in plan['items']:
        if it['kind'] == 'variant' and it['seed_key'] in seeds:
            s = seeds[it['seed_key']]
            assert (it['skill'], it['difficulty'], it['topic']) == (s['skill'], s['difficulty'], s['topic']), \
                f"{it['content_key']}: variant labels must equal its seed's (DECISION-0101)"
    return plan


def cmd_plan_from_seed_batch(a):
    """Seeds keyed <prefix>-<n>, variants <prefix>-SV-<n>-v<k> (DECISION-0096 key rules), in topic order."""
    topics = sorted((json.load(open(f)) for f in glob.glob(os.path.join(a.batch, 'topics/*.json'))),
                    key=lambda st: [int(x) for x in st['topic']['topic_code'].split('.')])
    items, n = [], a.first_seed
    for st in topics:
        t = st['topic']
        for s in sorted(st['seeds'], key=lambda s: s['slot']['slot']):
            if not s.get('seed'):
                print(f"skip {t['topic_code']} slot {s['slot']['slot']}: no accepted seed"); continue
            L = s['seed']['label']
            has_skill = L['skill_status'] in ('validated', 'provisional_model')
            base = dict(seed_key=f'{a.key_prefix}-{n:03d}', unit=t['unit_number'], topic=t['topic_code'], title=t['topic_title'],
                        skill=L['skill'] if has_skill else None, skill_status=L['skill_status'] if has_skill else None,
                        difficulty=L['difficulty'])
            tally = lambda k: ', '.join(f'{x} {c}' for x, c in L.get(k) or [])
            def row(key, kind, it, pid):
                it = dict(it)
                return dict(base, content_key=key, kind=kind, pipeline_id=pid, stem=it['stem'],
                            choices=[{x: c[x] for x in ('choice_key', 'choice_text', 'is_correct', 'rationale')} for c in it['choices']],
                            skill_note=(f'four non-author families voted (validated at 3 or more of 4); tally {tally("skill_tally")}' if kind == 'seed'
                                        else f"inherits seed {base['seed_key']} (DECISION-0101)"),
                            difficulty_note=(f'Four non-author model families voted; tally {tally("difficulty_tally")}. Provisional until recalibrated from student attempts (DECISION-0101).' if kind == 'seed'
                                             else f"Inherited from seed {base['seed_key']} (DECISION-0096)."))
            items.append(row(base['seed_key'], 'seed', s['seed']['item'], s['seed']['id']))
            for v in s['variants']:
                if v.get('accepted'):
                    items.append(row(f"{a.key_prefix}-SV-{n:03d}-v{v['v']}", 'variant', v['accepted']['item'], v['accepted']['id']))
            n += 1
    subj = {it['item']['subject_key'] for st in topics for s in st['seeds'] if s.get('seed') for it in [s['seed']]}
    assert len(subj) == 1, f'batch spans subjects {subj}'
    plan = {'subject_key': subj.pop(), 'source': a.source, 'run_note': a.run_note or a.source, 'items': items}
    json.dump(plan, open(a.out, 'w'), indent=1, ensure_ascii=False)
    load_plan(a.out)  # validate
    c = collections.Counter(it['kind'] for it in items)
    print(f"wrote {a.out}: {len(items)} items ({c['seed']} seeds, {c['variant']} variants), keys {items[0]['content_key']} .. {base['seed_key']}")


# ---------------------------------------------------------------- environment
def resolve(ref, plan, owner):
    rows = query(ref, f"""
select epv.id pack,
 (select json_agg(distinct c.taxonomy_source_version) from app.content_item_cells c join app.content_items ci on ci.id=c.content_item_id
   where ci.exam_pack_version_id=epv.id and c.superseded_by is null) tsvs,
 exists(select 1 from app.profiles where user_id={lit(owner)}::uuid) owner_ok
from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id
where s.subject_key={lit(plan['subject_key'])} and epv.status='published' and epv.retired_at is null""")
    if len(rows) != 1:
        sys.exit(f"expected exactly one live pack for {plan['subject_key']}, found {len(rows)}")
    r = rows[0]
    if not r['owner_ok']:
        sys.exit(f'owner {owner} has no app.profiles row in this environment (pass --owner)')
    tsvs = r['tsvs'] or []
    if len(tsvs) != 1:
        sys.exit(f'cannot resolve one taxonomy source version for the pack (found {tsvs})')
    return r['pack'], tsvs[0]


def chunk_state(ref, pack, part):
    """'absent' (no keys exist), 'published' (all exist, published, text matches), else a description."""
    exp = ','.join(f"({lit(it['content_key'])},{lit(it['hash'])})" for it in part)
    r = query(ref, f"""
with exp(k,h) as (values {exp}), got as (
 select ci.content_key k, ci.status s, civ.status vs,
   md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
 from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
 left join app.mcq_choices c on c.content_item_version_id=civ.id
 where ci.exam_pack_version_id={lit(pack)} and ci.content_key in (select k from exp) group by 1,2,3, civ.stem)
select (select count(*) from got) n, (select count(*) from got join exp using(k) where got.h=exp.h and s='published' and vs='published') ok,
 (select string_agg(k||':'||s, ', ') from got) found""")[0]
    if r['n'] == 0:
        return 'absent'
    if r['ok'] == len(part):
        return 'published'
    return f"partial or mismatched ({r['n']} of {len(part)} keys exist: {r['found']})"


# ---------------------------------------------------------------- the transaction
def txn_sql(plan, part, pack, tsv, owner, approval, mode):
    N = len(part)
    rows = [{'k': it['content_key'], 'kind': it['kind'], 'seed': it.get('seed_key') or it['content_key'], 'unit': int(it['unit']),
             'topic': it['topic'], 'title': it['title'], 'stem': it['stem'], 'keyed': it['keyed'], 'h': it['hash'],
             'skill': it.get('skill'), 'sstat': it.get('skill_status'), 'snote': it.get('skill_note') or '',
             'diff': it['difficulty'], 'dnote': it.get('difficulty_note') or '',
             'ch': [[c['choice_key'], c['choice_text'], bool(c['is_correct']), c['rationale']]
                    for c in sorted(it['choices'], key=lambda c: c['choice_key'])]} for it in part]
    n_skill = sum(1 for r in rows if r['skill'])
    src, run, note = plan['source'], f"{plan['source']} ({approval})", plan.get('run_note') or plan['source']
    payload = dollar(json.dumps(rows, ensure_ascii=False))
    lock = f"cramapple-publish-mcq-batch-{plan['source']}"
    body = f"""begin;
select pg_advisory_xact_lock(hashtext({lit(lock)}));
create temporary table lab on commit drop as
select x.*, gen_random_uuid() item_id, gen_random_uuid() version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from jsonb_to_recordset({payload}::jsonb) as x(k text, kind text, seed text, unit int, topic text, title text, stem text, keyed text, h text,
  skill text, sstat text, snote text, diff text, dnote text, ch jsonb);
do $g$ begin
 if (select count(*) from lab)<>{N} then raise exception 'payload size'; end if;
 if exists (select 1 from app.content_items ci join lab on lab.k=ci.content_key where ci.exam_pack_version_id={lit(pack)}) then raise exception 'a content_key already exists in the pack'; end if;
 if exists (select 1 from lab where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version={lit(tsv)} and tt.topic_code=lab.topic and tt.unit_number=lab.unit))
   then raise exception 'topic/unit not in taxonomy: %', (select string_agg(k||' '||topic, ', ') from lab where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version={lit(tsv)} and tt.topic_code=lab.topic and tt.unit_number=lab.unit)); end if;
 if exists (select 1 from lab where skill is not null and not exists (select 1 from app.taxonomy_cells tc where tc.taxonomy_source_version={lit(tsv)} and tc.topic_code=lab.topic and tc.skill_code=lab.skill))
   then raise exception 'skill not in topic grid: %', (select string_agg(k||' '||topic||'/'||skill, ', ') from lab where skill is not null and not exists (select 1 from app.taxonomy_cells tc where tc.taxonomy_source_version={lit(tsv)} and tc.topic_code=lab.topic and tc.skill_code=lab.skill)); end if;
end $g$;
insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
select item_id, {lit(pack)}::uuid, k, 'mcq', title, 'draft' from lab;
insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
select version_id, item_id, 1, stem, null, md5(k), 'draft', 'tutor_review_pending', keyed from lab;
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select lab.version_id, c->>0, c->>1, (c->>2)::boolean, c->>3 from lab cross join lateral jsonb_array_elements(lab.ch) c;
do $g$ begin
 if (select count(*) from (select lab.k from lab join app.content_item_versions civ on civ.id=lab.version_id join app.mcq_choices c on c.content_item_version_id=civ.id
     group by lab.k, civ.stem, lab.h having count(*)=4 and md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=lab.h) z)<>{N}
   then raise exception 'stored text does not match the local plan hashes'; end if;
end $g$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, {lit(owner)}::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', {lit(owner)}::uuid from lab;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, {lit(owner)}::uuid, 'tutor_question', 1, null, false, array[]::text[],
 {lit(f'{note}. Generate-and-select (protocol v0.6 section 0, DECISION-0099): no hand edits; four non-author checker families plus own-family veto; planted-defect controls. No human review (DECISION-0102). Hard-Gate approval {approval}.')},
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','generate_select_po_approval','approval',{lit(approval)},'content_key',k,'kind',kind,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','generate_select_po_approval','approval',{lit(approval)},'content_key',k,'kind',kind,'seed',seed)::text),
 {lit(owner)}::uuid from lab;
do $g$ begin
 if exists (select 1 from lab join app.content_item_versions civ on civ.id=lab.version_id
   where civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct))
   then raise exception 'canonical letter mismatch'; end if;
end $g$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by={lit(owner)}::uuid, approved_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from lab where ci.id=lab.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', array[unit], unit, unit, array[]::text[], {lit(tsv)}::uuid, 'provisional', 'provisional_model', {lit(src)},
 jsonb_build_object('origin', kind, 'seed', seed, 'topic', topic, 'units_source', 'designated topic; four non-author checkers passed the on_topic rule'),
 {lit(run)}, {lit(owner)}::uuid from lab;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, {lit(owner)}::uuid, 'confirmed', 'automated_spot_check', unit, array[unit],
 {lit(f'Hard-Gate approval {approval}. Generated for its designated topic; four non-author checker families passed the on_topic rule.')} from lab;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, {lit(tsv)}::uuid, topic, null, true, 'validated', {lit(src + ':topic')}, {lit(run + ': designated topic, four-family on_topic check')}, null, now(), gen_random_uuid() from lab;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, {lit(tsv)}::uuid, topic, skill, false, sstat, {lit(src + ':skill:')}||case when kind='variant' then 'inherit' else 'vote' end,
 {lit(run + ': ')}||snote, null, case when sstat='validated' then now() end, case when sstat='validated' then gen_random_uuid() end
from lab where skill is not null;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select version_id, diff, case when kind='variant' then 'translated' else 'calibrated_judgement' end, case when kind='variant' then seed end, dnote, 'low', {lit(src)} from lab;
update app.content_taxonomy_labels l set label_status='validated', validated_by={lit(owner)}::uuid, validated_at=now(), validation_decision_id=lab.vd_id,
 validated_against_version_id=lab.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(lab.version_id) from lab where l.content_taxonomy_label_id=lab.label_id;
update app.content_item_versions civ set status='published', published_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='published', updated_at=now() from lab where ci.id=lab.item_id;
do $g$ declare n int; begin
 select count(*) into n from app.content_items ci join lab on lab.item_id=ci.id join app.content_item_versions civ on civ.id=lab.version_id where ci.status='published' and civ.status='published'; if n<>{N} then raise exception 'published %', n; end if;
 select count(*) into n from app.content_taxonomy_labels l join lab on lab.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(lab.version_id); if n<>{N} then raise exception 'labels %', n; end if;
 select count(*) into n from app.content_item_cells c join lab on lab.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated'; if n<>{N} then raise exception 'topic cells %', n; end if;
 select count(*) into n from app.content_item_cells c join lab on lab.version_id=c.content_item_version_id where not c.is_primary and c.skill_code is not null and c.superseded_by is null; if n<>{n_skill} then raise exception 'skill cells %', n; end if;
 select count(*) into n from app.content_item_difficulty d join lab on lab.version_id=d.content_item_version_id; if n<>{N} then raise exception 'difficulty %', n; end if;
end $g$;
"""
    if mode == 'rehearse':
        return body + f"do $g$ begin raise exception 'REHEARSAL OK: published={N} skill_cells={n_skill}'; end $g$;\nrollback;\n"
    return body + "commit;\n"


# ---------------------------------------------------------------- republish (existing items, content unchanged)
def legacy_hash(stimulus, stem, choices):
    """Hash of an existing version's student-visible content, including the stimulus."""
    return hashlib.md5(((stimulus or '') + '#' + item_hash(stem, choices)).encode()).hexdigest()


def republish_sql(part, pack, tsv, owner, approval, source, run_note, mode):
    """Add a new version that copies the item's latest version verbatim (content and choices; canonical_answer_1 is
    re-derived from the correct choice, since some legacy versions left it null), then publish it with a
    fresh serving label (superseding the old ones), a topic cell, an optional skill cell and a difficulty row. The
    latest version's content must hash to the value that was re-checked (expect_hash), so nothing unchecked is published."""
    N = len(part)
    rows = [{'k': it['content_key'], 'topic': it['topic'], 'unit': int(it['unit']), 'h': it['expect_hash'],
             'skill': it.get('skill'), 'sstat': it.get('skill_status'), 'snote': it.get('skill_note') or '',
             'diff': it.get('difficulty'), 'dnote': it.get('difficulty_note') or ''} for it in part]
    n_skill = sum(1 for r in rows if r['skill'])
    run = f'{source} ({approval})'
    payload = dollar(json.dumps(rows, ensure_ascii=False))
    body = f"""begin;
select pg_advisory_xact_lock(hashtext({lit('cramapple-republish-' + source)}));
create temporary table lab on commit drop as
select x.*, ci.id item_id, ci.status item_status, old.id old_version_id, old.version_num old_num, gen_random_uuid() version_id,
  gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
  (select coalesce(max(l.label_version),0)+1 from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving') label_version,
  coalesce(x.diff, (select d.difficulty from app.content_item_difficulty d join app.content_item_versions v on v.id=d.content_item_version_id
     where v.content_item_id=ci.id order by v.version_num desc, d.created_at desc limit 1)) difficulty,
  (x.diff is null) diff_carried
from jsonb_to_recordset({payload}::jsonb) as x(k text, topic text, unit int, h text, skill text, sstat text, snote text, diff text, dnote text)
join app.content_items ci on ci.content_key=x.k and ci.exam_pack_version_id={lit(pack)} and ci.item_type='mcq'
join lateral (select * from app.content_item_versions v where v.content_item_id=ci.id order by v.version_num desc limit 1) old on true;
do $g$ begin
 if (select count(*) from lab)<>{N} then raise exception 'found % of {N} items in the pack', (select count(*) from lab); end if;
 if exists (select 1 from lab join app.content_item_versions v on v.content_item_id=lab.item_id where v.status='published') then raise exception 'an item already has a published version'; end if;
 if exists (select 1 from lab where difficulty is null) then raise exception 'no difficulty to carry forward: %', (select string_agg(k, ', ') from lab where difficulty is null); end if;
 if exists (select 1 from lab where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version={lit(tsv)} and tt.topic_code=lab.topic and tt.unit_number=lab.unit)) then raise exception 'topic/unit not in taxonomy'; end if;
 if exists (select 1 from lab where skill is not null and not exists (select 1 from app.taxonomy_cells tc where tc.taxonomy_source_version={lit(tsv)} and tc.topic_code=lab.topic and tc.skill_code=lab.skill)) then raise exception 'skill not in topic grid'; end if;
 if (select count(*) from (select lab.k from lab join app.content_item_versions old on old.id=lab.old_version_id join app.mcq_choices c on c.content_item_version_id=old.id
     group by lab.k, old.stimulus, old.stem, lab.h having count(*)=4 and md5(coalesce(old.stimulus,'')||'#'||md5(old.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)))=lab.h) z)<>{N}
   then raise exception 'latest version content differs from what was re-checked'; end if;
end $g$;
insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, explanation, help_text, content_hash, status, review_status,
  canonical_answer_1, canonical_answer_2, rubric_type, evaluator_strategy, stimulus_image_path, item_package_schema_version, item_package_payload, item_package_sha256, created_by)
select lab.version_id, lab.item_id, lab.old_num+1, old.stem, old.stimulus, old.prompt_json, old.explanation, old.help_text, md5(lab.k||':v'||(lab.old_num+1)), 'draft', 'tutor_review_pending',
  (select m.choice_key from app.mcq_choices m where m.content_item_version_id=old.id and m.is_correct), old.canonical_answer_2, old.rubric_type, old.evaluator_strategy, old.stimulus_image_path, old.item_package_schema_version, old.item_package_payload, old.item_package_sha256, {lit(owner)}::uuid
from lab join app.content_item_versions old on old.id=lab.old_version_id;
insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
select lab.version_id, c.choice_key, c.choice_text, c.is_correct, c.rationale from lab join app.mcq_choices c on c.content_item_version_id=lab.old_version_id;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, {lit(owner)}::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', {lit(owner)}::uuid from lab;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, {lit(owner)}::uuid, 'tutor_question', 1, null, false, array[]::text[],
 {lit(f'{run_note}. Republished unchanged after a correctness re-check by five model families (blind solve and audit, re-sample rule), all passing. No human review (DECISION-0102). Hard-Gate approval {approval}.')},
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','legacy_recheck_po_approval','approval',{lit(approval)},'content_key',k,'copied_from_version',old_num),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','legacy_recheck_po_approval','approval',{lit(approval)},'content_key',k,'copied_from_version',old_num)::text),
 {lit(owner)}::uuid from lab;
do $g$ begin
 if exists (select 1 from lab join app.content_item_versions civ on civ.id=lab.version_id
   where (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4
      or civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct))
   then raise exception 'copied version fails structural QA'; end if;
end $g$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by={lit(owner)}::uuid, approved_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from lab where ci.id=lab.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, label_version, 'serving', array[unit], unit, unit, array[]::text[], {lit(tsv)}::uuid, 'provisional', 'provisional_model', {lit(source)},
 jsonb_build_object('origin','legacy_republish','topic',topic,'copied_from_version',old_num,'units_source','five-family topic vote (at least 4 of 5)'), {lit(run)}, {lit(owner)}::uuid from lab;
update app.content_taxonomy_labels l set superseded_by=lab.label_id from lab
 where l.content_item_id=lab.item_id and l.label_scope='serving' and l.superseded_by is null and l.content_taxonomy_label_id<>lab.label_id;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, {lit(owner)}::uuid, 'confirmed', 'automated_spot_check', unit, array[unit],
 {lit(f'Hard-Gate approval {approval}. Topic from a five-family vote (at least 4 of 5); correctness re-check passed by all five families.')} from lab;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, {lit(tsv)}::uuid, topic, null, true, 'validated', {lit(source + ':topic')}, {lit(run + ': five-family topic vote')}, null, now(), gen_random_uuid() from lab;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, {lit(tsv)}::uuid, topic, skill, false, sstat, {lit(source + ':skill:vote')}, {lit(run + ': ')}||snote, null,
 case when sstat='validated' then now() end, case when sstat='validated' then gen_random_uuid() end from lab where skill is not null;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select version_id, difficulty, case when diff_carried then 'translated' else 'calibrated_judgement' end, case when diff_carried then k||':v'||old_num end,
 case when diff_carried then 'Carried forward unchanged from version '||old_num||' (content copied verbatim).' else dnote end, 'low', {lit(source)} from lab;
update app.content_taxonomy_labels l set label_status='validated', validated_by={lit(owner)}::uuid, validated_at=now(), validation_decision_id=lab.vd_id,
 validated_against_version_id=lab.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(lab.version_id) from lab where l.content_taxonomy_label_id=lab.label_id;
update app.content_item_versions civ set status='published', published_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='published', updated_at=now() from lab where ci.id=lab.item_id;
do $g$ declare n int; begin
 select count(*) into n from (select v.content_item_id from app.content_item_versions v join lab on lab.item_id=v.content_item_id where v.status='published' group by 1 having count(*)=1) z; if n<>{N} then raise exception 'published versions %', n; end if;
 select count(*) into n from app.content_items ci join lab on lab.item_id=ci.id where ci.status='published'; if n<>{N} then raise exception 'published items %', n; end if;
 select count(*) into n from app.content_taxonomy_labels l join lab on lab.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_version_id=lab.version_id; if n<>{N} then raise exception 'current labels %', n; end if;
 select count(*) into n from app.content_item_cells c join lab on lab.version_id=c.content_item_version_id where c.is_primary and c.assignment_status='validated'; if n<>{N} then raise exception 'topic cells %', n; end if;
 select count(*) into n from app.content_item_cells c join lab on lab.version_id=c.content_item_version_id where not c.is_primary; if n<>{n_skill} then raise exception 'skill cells %', n; end if;
 select count(*) into n from app.content_item_difficulty d join lab on lab.version_id=d.content_item_version_id; if n<>{N} then raise exception 'difficulty %', n; end if;
end $g$;
"""
    if mode == 'rehearse':
        return body + f"do $g$ begin raise exception 'REHEARSAL OK: republished={N} skill_cells={n_skill}'; end $g$;\nrollback;\n"
    return body + "commit;\n"


def cmd_republish(a):
    """Republish existing retired MCQs unchanged. Plan: {source, run_note, items: [{content_key, subject_key, topic, unit,
    expect_hash, skill, skill_status, skill_note, difficulty (null = carry forward), difficulty_note}]}."""
    plan = json.load(open(a.plan))
    ref = ENVS[a.env]
    if a.commit and a.env == 'prod' and not (a.approval and a.approval.startswith('APPROVAL-') and a.confirm_production):
        sys.exit('Production republish needs --approval APPROVAL-NNNN (recorded first) and --confirm-production')
    by_subject = collections.defaultdict(list)
    for it in plan['items']:
        by_subject[it['subject_key']].append(it)
    for subj, items in by_subject.items():
        pack, tsv = resolve(ref, {'subject_key': subj}, a.owner)
        print(f'{a.env}: {subj} pack {pack}, taxonomy {tsv}, {len(items)} items')
        args = (items, pack, tsv, a.owner, a.approval or 'REHEARSAL', plan['source'], plan.get('run_note') or plan['source'])
        msg = query(ref, republish_sql(*args, 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg:
            sys.exit(f'{subj}: rehearsal FAILED: {msg[:2000]}')
        print(f"{subj}: {msg[msg.index('REHEARSAL OK'):].splitlines()[0]} (rolled back)")
        if a.commit:
            query(ref, republish_sql(*args, 'commit'))
            print(f'{subj}: committed')


def chunks(items, size):
    return [items[i:i + size] for i in range(0, len(items), size)]


def setup(a):
    plan = load_plan(a.plan)
    ref = ENVS[a.env]
    pack, tsv = resolve(ref, plan, a.owner)
    print(f"{a.env}: {plan['subject_key']} pack {pack}, taxonomy {tsv}, {len(plan['items'])} items, owner ok")
    return plan, ref, pack, tsv


def cmd_preflight(a):
    plan, ref, pack, tsv = setup(a)
    for i, part in enumerate(chunks(plan['items'], a.chunk), 1):
        print(f'chunk {i} ({len(part)} items): {chunk_state(ref, pack, part)}')
    return plan, ref, pack, tsv


def cmd_rehearse(a):
    plan, ref, pack, tsv = setup(a)
    for i, part in enumerate(chunks(plan['items'], a.chunk), 1):
        st = chunk_state(ref, pack, part)
        if st != 'absent':
            print(f'chunk {i}: {st}; not rehearsed'); continue
        msg = query(ref, txn_sql(plan, part, pack, tsv, a.owner, a.approval or 'REHEARSAL', 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg:
            sys.exit(f'chunk {i}: rehearsal FAILED: {msg[:2000]}')
        print(f"chunk {i}: {msg[msg.index('REHEARSAL OK'):].splitlines()[0]} (rolled back)")


def cmd_publish(a):
    if a.env == 'prod' and not (a.approval and a.approval.startswith('APPROVAL-') and a.confirm_production):
        sys.exit('Production publish needs --approval APPROVAL-NNNN (recorded first) and --confirm-production')
    plan, ref, pack, tsv = setup(a)
    states = [chunk_state(ref, pack, part) for part in chunks(plan['items'], a.chunk)]
    bad = [f'chunk {i}: {s}' for i, s in enumerate(states, 1) if s not in ('absent', 'published')]
    if bad:
        sys.exit('refusing to publish; resolve first:\n' + '\n'.join(bad))
    log = []
    for i, (part, st) in enumerate(zip(chunks(plan['items'], a.chunk), states), 1):
        if st == 'published':
            print(f'chunk {i}: already published, skipped'); continue
        msg = query(ref, txn_sql(plan, part, pack, tsv, a.owner, a.approval, 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg:
            sys.exit(f'chunk {i}: rehearsal FAILED, nothing committed for this chunk: {msg[:2000]}')
        query(ref, txn_sql(plan, part, pack, tsv, a.owner, a.approval, 'commit'))
        st = chunk_state(ref, pack, part)
        if st != 'published':
            sys.exit(f'chunk {i}: committed but verification reads "{st}"; stop and investigate')
        print(f'chunk {i}: rehearsed, committed, verified ({len(part)} items)')
        log.append({'chunk': i, 'keys': [it['content_key'] for it in part], 'at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())})
    out = os.path.splitext(a.plan)[0] + f'.publish_{a.env}.json'
    json.dump({'env': a.env, 'approval': a.approval, 'pack': pack, 'committed': log}, open(out, 'w'), indent=1)
    cmd_verify(a)
    print(f'log: {out}')


def cmd_verify(a):
    plan, ref, pack, tsv = setup(a) if not hasattr(a, '_ctx') else a._ctx
    keys = ','.join(lit(it['content_key']) for it in plan['items'])
    exp = ','.join(f"({lit(it['content_key'])},{lit(it['hash'])})" for it in plan['items'])
    n_skill = sum(1 for it in plan['items'] if it.get('skill'))
    r = query(ref, f"""
with exp(k,h) as (values {exp}), t as (
 select ci.id, ci.content_key k, ci.status s, civ.id civ, civ.status vs,
   md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key)) h
 from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
 join app.mcq_choices c on c.content_item_version_id=civ.id
 where ci.exam_pack_version_id={lit(pack)} and ci.content_key in ({keys}) group by 1,2,3,4,5, civ.stem)
select (select count(*) from t) found, (select count(*) from t join exp using(k) where t.h=exp.h) text_match,
 (select count(*) from t where s='published' and vs='published') published,
 (select count(*) from app.content_taxonomy_labels l join t on t.id=l.content_item_id where l.label_status='validated' and l.superseded_by is null and l.label_scope='serving') labels,
 (select count(*) from app.content_item_cells c join t on t.civ=c.content_item_version_id where c.is_primary and c.assignment_status='validated' and c.superseded_by is null) topic_cells,
 (select count(*) from app.content_item_cells c join t on t.civ=c.content_item_version_id where not c.is_primary and c.superseded_by is null) skill_cells,
 (select count(*) from app.content_item_difficulty d join t on t.civ=d.content_item_version_id) difficulty""")[0]
    N = len(plan['items'])
    want = {'found': N, 'text_match': N, 'published': N, 'labels': N, 'topic_cells': N, 'skill_cells': n_skill, 'difficulty': N}
    ok = all(r[k] == v for k, v in want.items())
    print('verify:', ', '.join(f'{k} {r[k]}/{v}' for k, v in want.items()), '-> OK' if ok else '-> MISMATCH')
    if not ok:
        sys.exit(1)


def main():
    p = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    sub = p.add_subparsers(dest='cmd', required=True)
    g = sub.add_parser('plan-from-seed-batch')
    g.add_argument('--batch', required=True); g.add_argument('--key-prefix', required=True)
    g.add_argument('--first-seed', type=int, required=True); g.add_argument('--source', required=True)
    g.add_argument('--run-note'); g.add_argument('--out', required=True)
    r = sub.add_parser('republish')
    r.add_argument('--plan', required=True); r.add_argument('--env', choices=ENVS, required=True)
    r.add_argument('--owner', default=DEFAULT_OWNER); r.add_argument('--approval'); r.add_argument('--confirm-production', action='store_true')
    r.add_argument('--commit', action='store_true', help='commit after a passing rehearsal (default: rehearse only)')
    for name in ('preflight', 'rehearse', 'publish', 'verify'):
        s = sub.add_parser(name)
        s.add_argument('--plan', required=True); s.add_argument('--env', choices=ENVS, required=True)
        s.add_argument('--owner', default=DEFAULT_OWNER); s.add_argument('--chunk', type=int, default=40)
        s.add_argument('--approval'); s.add_argument('--confirm-production', action='store_true')
    a = p.parse_args()
    {'plan-from-seed-batch': cmd_plan_from_seed_batch, 'preflight': cmd_preflight, 'rehearse': cmd_rehearse,
     'publish': cmd_publish, 'verify': cmd_verify, 'republish': cmd_republish}[a.cmd](a)


if __name__ == '__main__':
    main()
