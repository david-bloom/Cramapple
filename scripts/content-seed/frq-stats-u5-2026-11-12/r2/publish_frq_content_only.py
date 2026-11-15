#!/usr/bin/env python3
"""Publish the AP Statistics Units 4-5 round-2 FRQs (10 seeds + 20 variants) as CONTENT ONLY.

Adapted from frq-u13-gap-fill-2026-10-09/publish_frq_batch.py with the owner's direction (2026-11-12): labels OUT.
No serving label, no topic cell, no difficulty row is written; a separate labeling task does those. Guards kept: exam pack
published, no content_key exists, topic/unit exist in the taxonomy, stored text hashed against the local plan. The one-FRQ-per-topic
guard of the Units 1-3 batch is dropped (the owner asked for several FRQs per topic here). Variant lineage is recorded in prompt_json.provenance.
Path: draft -> owner approval decision -> reviewed_approved -> published. A rehearsal raises and rolls back.

  python3 publish_frq_content_only.py plan
  python3 publish_frq_content_only.py preflight --env prod
  python3 publish_frq_content_only.py rehearse  --env prod
  python3 publish_frq_content_only.py publish   --env prod --approval APPROVAL-NNNN --confirm-production
  python3 publish_frq_content_only.py verify    --env prod
"""
import argparse, hashlib, importlib.util, json, os, sys, time, glob
HERE = os.path.dirname(os.path.abspath(__file__)); BATCH = os.path.dirname(HERE)
spec = importlib.util.spec_from_file_location('pmb', os.path.join(BATCH, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
lit, dollar, query = pmb.lit, pmb.dollar, pmb.query
OWNER = pmb.DEFAULT_OWNER
SRC = 'frq_stats_u4_u5_r2_2026_11_12'
SK = 'ap_statistics'; REGISTRY = 'ap-statistics'
CALC_LINE = {'not_permitted': 'No calculator is permitted.', 'permitted': 'A calculator is permitted.', 'not_applicable': ''}
PLAN = os.path.join(HERE, 'plan.json')
LETTERS = 'abcdefgh'


def item_hash(stem, stimulus, criteria):
    body = stem + '\n' + (stimulus or '') + '\n' + '\n'.join(
        f"{c['key']}|{c['text']}|{c['evidence']}|{c['fix']}|{json.dumps(c['variants'], ensure_ascii=False)}" for c in sorted(criteria, key=lambda c: c['key']))
    return hashlib.md5(body.encode()).hexdigest()


def build_row(key, it, slot, epv, prov):
    crit, parts_json, lines = [], [], []
    for i, p in enumerate(it['parts']):
        pk = f'part-{LETTERS[i]}'; pc = []
        for j, cr in enumerate(p['criteria'], 1):
            ck = f'{pk}-criterion-{j:02d}'
            crit.append({'key': ck, 'text': cr['text'], 'evidence': cr['evidence'], 'fix': cr['fix'], 'variants': cr.get('accepted_variants') or []})
            pc.append({'criterion_key': ck, 'points': 1})
        parts_json.append({'part_key': pk, 'points': len(p['criteria']), 'prompt': p['prompt'], 'criteria': pc})
        lines.append(f"({LETTERS[i]}) {p['prompt']}")
    head = ' '.join(x for x in [CALC_LINE[it['calculator']], 'Answer all parts of the following question.'] if x)
    stem = head + '\n\n' + '\n\n'.join(lines)
    prompt_json = {'unit': slot['unit'], 'topic': f"{slot['topic_code']} {slot['topic_title']}", 'subject': SK, 'frq_form': 'short', 'calculator': it['calculator'],
                   'parts': parts_json, 'content_key': key, 'content_version': 1, 'source_policy': 'Original Cramapple authorship; CED structure and scope only.',
                   'provenance': prov}
    return {'k': key, 'sk': SK, 'pack': epv, 'tsv': slot['tsv'], 'unit': slot['unit'], 'topic': slot['topic_code'], 'title': it['title'], 'stem': stem,
            'stimulus': it['stimulus'], 'answer': it['model_answer'], 'criteria': crit, 'prompt_json': prompt_json, 'h': item_hash(stem, it['stimulus'], crit)}


def cmd_plan(a):
    epv = json.load(open(os.path.join(HERE, 'inputs', 'exam_pack_versions.json')))[REGISTRY]
    rows = []
    for f in sorted(glob.glob(os.path.join(HERE, 'slots', '*.json'))):
        st = json.load(open(f)); sl = st['slot']; code = sl['topic_code']
        c = st['candidates'][-1]
        assert st['status'] == 'accepted' or code == '5.3', (st['id'], st['status'])
        it = c['item']; diffs = [ch.get('difficulty') for ch in c.get('checks', [])]
        skey = f"apstats-frq-u45r2-{code.replace('.', '-')}-s"
        base = {'batch': SRC, 'checkers': ['openai/gpt-6.1-sol', 'deepseek/deepseek-v4-pro'], 'author': 'Claude (in session)',
                'round': 'r2 difficulty rewrite (Medium target)', 'topic_votes': c.get('probe', {}).get('votes'), 'topic_ruling': (c.get('probe') or {}).get('overridden_by')}
        prov = dict(base, kind='seed', checker_difficulty_labels=diffs)
        if code == '5.3': prov['exception'] = 'owner-accepted exception 2026-11-12: checkers split Medium/Easy'
        rows.append(build_row(skey, it, sl, epv, prov))
        for vid in ('v1', 'v2'):
            vf = os.path.join(HERE, 'variants', f"ap_statistics__{code}__{vid}.json")
            v = json.load(open(vf)); assert v['status'] == 'accepted', (vf, v['status'])
            rows.append(build_row(f"apstats-frq-u45r2-{code.replace('.', '-')}-{vid}", v['item'], sl, epv,
                                  dict(base, kind='variant', seed_key=skey, variant_of=skey, check='diff-style variant check (both checker families)',
                                       inherits_topic_votes_from=skey)))
    json.dump({'source': SRC, 'items': rows}, open(PLAN, 'w'), indent=1, ensure_ascii=False)
    print(len(rows), 'FRQs planned:', sum(1 for r in rows if r['k'].endswith('-s')), 'seeds,', sum(1 for r in rows if not r['k'].endswith('-s')), 'variants')


def load_plan():
    return json.load(open(PLAN))['items']


def txn_sql(rows, approval, mode):
    N = len(rows); pack = rows[0]['pack']; tsv = rows[0]['tsv']
    assert all(r['pack'] == pack and r['tsv'] == tsv for r in rows)
    payload = dollar(json.dumps(rows, ensure_ascii=False))
    note = (f"AP Statistics Units 4-5 FRQs, round 2 ({SRC}): authored by Claude in session from a rubric pattern library; seeds checked by GPT-6.1 Sol and "
            f"DeepSeek V4 Pro (blind solve, scope and rubric re-derivation, six-vote topic probe, difficulty gate: no checker rated Easy except the owner-accepted 5.3 exception); "
            f"variants by a diff-style check of both families; exact recompute; model answers graded by a third family. Labels not written (separate labeling task). Hard-Gate approval {approval}.")
    body = f"""begin;
select pg_advisory_xact_lock(hashtext({lit('cramapple-' + SRC)}));
create temporary table lab on commit drop as
select x.*, gen_random_uuid() item_id, gen_random_uuid() version_id, gen_random_uuid() assignment_id
from jsonb_to_recordset({payload}::jsonb) as x(k text, sk text, pack uuid, tsv uuid, unit int, topic text, title text, stem text, stimulus text,
  answer text, criteria jsonb, prompt_json jsonb, h text);
do $g$ begin
 if (select count(*) from lab)<>{N} then raise exception 'payload size'; end if;
 if not exists (select 1 from app.exam_pack_versions where id={lit(pack)} and status='published') then raise exception 'pack not published'; end if;
 if exists (select 1 from app.content_items ci join lab on lab.k=ci.content_key) then raise exception 'a content_key already exists'; end if;
 if exists (select 1 from lab where not exists (select 1 from app.taxonomy_topics t where t.taxonomy_source_version=lab.tsv and t.topic_code=lab.topic and t.unit_number=lab.unit))
   then raise exception 'topic/unit not in taxonomy'; end if;
end $g$;
insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
select item_id, pack, k, 'frq', title, 'draft', 'short', 'targeted_drill', null from lab;
insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, rubric_type, evaluator_strategy, canonical_answer_1)
select version_id, item_id, 1, stem, stimulus, prompt_json, md5(coalesce(stem,'')||E'\\n'||coalesce(stimulus,'')), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text', answer from lab;
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select lab.version_id, c->>'key', c->>'text', 1, c->>'evidence', c->>'fix', coalesce(c->'variants','[]'::jsonb) from lab cross join lateral jsonb_array_elements(lab.criteria) c;
do $g$ begin
 if (select count(*) from lab where md5(
      (select v.stem from app.content_item_versions v where v.id=lab.version_id)||E'\\n'||coalesce((select v.stimulus from app.content_item_versions v where v.id=lab.version_id),'')||E'\\n'||
      (select string_agg(fc.criterion_key||'|'||fc.learner_facing_text||'|'||fc.evidence_requirements||'|'||fc.minimum_fix||'|'||
         (select coalesce('['||string_agg(to_json(e)::text, ', ' order by o)||']','[]') from jsonb_array_elements_text(fc.accepted_variants) with ordinality as t(e,o)),
         E'\\n' order by fc.criterion_key) from app.frq_criteria fc where fc.content_item_version_id=lab.version_id)) = lab.h)<>{N}
   then raise exception 'stored text does not match the local plan hashes'; end if;
 if (select count(*) from app.frq_criteria fc join lab on lab.version_id=fc.content_item_version_id) <> (select sum(jsonb_array_length(criteria)) from lab) then raise exception 'criteria count'; end if;
end $g$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, {lit(OWNER)}::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', {lit(OWNER)}::uuid from lab;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, {lit(OWNER)}::uuid, 'tutor_question', 1, 'Medium', false, array[]::text[], {lit(note)}, 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_po_waiver_labels_out','approval',{lit(approval)},'content_key',k),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_po_waiver_labels_out','approval',{lit(approval)},'content_key',k)::text),
 {lit(OWNER)}::uuid from lab;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by={lit(OWNER)}::uuid, approved_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from lab where ci.id=lab.item_id;
update app.content_item_versions civ set status='published', published_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='published', updated_at=now() from lab where ci.id=lab.item_id;
do $g$ declare n int; begin
 select count(*) into n from app.content_items ci join lab on lab.item_id=ci.id join app.content_item_versions civ on civ.id=lab.version_id where ci.status='published' and civ.status='published' and ci.item_type='frq'; if n<>{N} then raise exception 'published %', n; end if;
 select count(*) into n from lab join app.content_item_versions v on v.id=lab.version_id where nullif(btrim(v.canonical_answer_1),'') is null; if n<>0 then raise exception 'missing model answer %', n; end if;
end $g$;
"""
    if mode == 'rehearse':
        return body + f"do $g$ begin raise exception 'REHEARSAL OK: {SK} published={N}'; end $g$;\nrollback;\n"
    return body + "commit;\n"


def state(ref, rows):
    keys = ','.join(lit(r['k']) for r in rows)
    got = query(ref, f"select ci.content_key k, ci.status s from app.content_items ci where ci.content_key in ({keys})")
    if not got: return 'absent'
    if len(got) == len(rows) and all(g['s'] == 'published' for g in got): return 'published'
    return f'partial ({len(got)} of {len(rows)})'


def cmd_preflight(a):
    rows = load_plan(); ref = pmb.ENVS[a.env]
    ex = query(ref, f"select content_key from app.content_items where content_key like 'apstats-frq-u45r2-%'")
    pk = query(ref, f"select status from app.exam_pack_versions where id={lit(rows[0]['pack'])}")
    print(f"{len(rows)} planned; state {state(ref, rows)}; existing keys with this prefix: {len(ex)}; pack status {pk}")


def cmd_rehearse(a):
    rows = load_plan(); ref = pmb.ENVS[a.env]
    msg = query(ref, txn_sql(rows, a.approval or 'REHEARSAL', 'rehearse'), expect_error=True)
    if 'REHEARSAL OK' not in msg: sys.exit(f'rehearsal FAILED: {msg[:2500]}')
    print(msg[msg.index('REHEARSAL OK'):].splitlines()[0], '(rolled back)')


def cmd_publish(a):
    if a.env == 'prod' and not (a.approval.startswith('APPROVAL-') and a.confirm_production):
        sys.exit('Production publish needs --approval APPROVAL-NNNN (recorded first) and --confirm-production')
    rows = load_plan(); ref = pmb.ENVS[a.env]
    st = state(ref, rows)
    if st == 'published': print('already published, skipped'); return cmd_verify(a)
    if st != 'absent': sys.exit(f'{st}; stop and investigate')
    msg = query(ref, txn_sql(rows, a.approval, 'rehearse'), expect_error=True)
    if 'REHEARSAL OK' not in msg: sys.exit(f'rehearsal FAILED, nothing committed: {msg[:2500]}')
    query(ref, txn_sql(rows, a.approval, 'commit'))
    st = state(ref, rows)
    if st != 'published': sys.exit(f'committed but reads "{st}"; stop and investigate')
    json.dump({'env': a.env, 'approval': a.approval, 'keys': [r['k'] for r in rows], 'at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())}, open(os.path.join(HERE, f'publish_{a.env}.json'), 'w'), indent=1)
    print(f'rehearsed, committed, verified state: {len(rows)} FRQs'); cmd_verify(a)


def cmd_verify(a):
    rows = load_plan(); ref = pmb.ENVS[a.env]; keys = ','.join(lit(r['k']) for r in rows)
    got = query(ref, f"""select ci.content_key k, v.stem, v.stimulus,
      (select string_agg(fc.criterion_key||'|'||fc.learner_facing_text||'|'||fc.evidence_requirements||'|'||fc.minimum_fix||'|'||
         (select coalesce('['||string_agg(to_json(e)::text, ', ' order by o)||']','[]') from jsonb_array_elements_text(fc.accepted_variants) with ordinality as t(e,o)),
         E'\\n' order by fc.criterion_key) from app.frq_criteria fc where fc.content_item_version_id=v.id) crit,
      nullif(btrim(v.canonical_answer_1),'') is not null has_answer
      from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
      where ci.content_key in ({keys}) and ci.status='published'""")
    want = {r['k']: r['h'] for r in rows}; ok = 0; bad = []
    for g in got:
        h = hashlib.md5((g['stem'] + '\n' + (g['stimulus'] or '') + '\n' + (g['crit'] or '')).encode()).hexdigest()
        if h == want.get(g['k']) and g['has_answer']: ok += 1
        else: bad.append(g['k'])
    print(f'verify: {ok}/{len(rows)} published with matching text and a model answer' + (f'; problems: {bad}' if bad else ''))
    return ok == len(rows)


def main():
    p = argparse.ArgumentParser(); p.add_argument('cmd', choices=['plan', 'preflight', 'rehearse', 'publish', 'verify'])
    p.add_argument('--env', choices=['dev', 'prod'], default='prod'); p.add_argument('--approval', default='')
    p.add_argument('--confirm-production', action='store_true'); a = p.parse_args()
    {'plan': cmd_plan, 'preflight': cmd_preflight, 'rehearse': cmd_rehearse, 'publish': cmd_publish, 'verify': cmd_verify}[a.cmd](a)


if __name__ == '__main__':
    main()
