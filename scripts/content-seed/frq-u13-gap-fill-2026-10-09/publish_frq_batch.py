#!/usr/bin/env python3
"""Publish accepted FRQs from the Units 1-3 gap-fill batch (one per zero-FRQ topic).

  python3 publish_frq_batch.py plan
  python3 publish_frq_batch.py preflight --env prod
  python3 publish_frq_batch.py rehearse  --env prod
  python3 publish_frq_batch.py publish   --env prod --approval APPROVAL-NNNN --confirm-production
  python3 publish_frq_batch.py verify    --env prod

One transaction per subject (advisory lock). Guards: the exam pack is the subject's serving pack; no content_key exists;
the topic still has ZERO published FRQs with a primary topic cell (Product Owner rule: never add an FRQ to a topic that
already has one); topic/unit are in the taxonomy. Stored text is hashed against the local plan before anything is
approved. Path: draft -> owner approval decision (human review waived) -> serving label (six-vote probe required units)
validated hash-fresh -> validated primary topic cell -> difficulty -> published. A rehearsal raises and rolls back.
Transport: publish_mcq_batch.query (Supabase Management API, CLI token).
"""
import argparse, hashlib, importlib.util, json, os, sys, time, glob
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
lit, dollar, query = pmb.lit, pmb.dollar, pmb.query
OWNER = pmb.DEFAULT_OWNER
SRC = 'frq_u13_gap_fill_2026_10_09'
PREFIX = {'ap_biology': 'apbio', 'ap_calculus_ab': 'apcalcab', 'ap_calculus_bc': 'apcalcbc', 'ap_chemistry': 'apchem',
          'ap_physics_1': 'apphy1', 'ap_physics_2': 'apphy2', 'ap_physics_c_em': 'apphycem', 'ap_physics_c_mechanics': 'apphycm',
          'ap_precalculus': 'apprecalc', 'ap_statistics': 'apstats'}
CALC_LINE = {'not_permitted': 'No calculator is permitted.', 'permitted': 'A calculator is permitted.', 'not_applicable': ''}
PLAN = os.path.join(HERE, 'plan.json')


def item_hash(stem, stimulus, criteria):
    body = stem + '\n' + (stimulus or '') + '\n' + '\n'.join(
        f"{c['key']}|{c['text']}|{c['evidence']}|{c['fix']}|{json.dumps(c['variants'], ensure_ascii=False)}" for c in criteria)
    return hashlib.md5(body.encode()).hexdigest()


def cmd_plan(a):
    epv = json.load(open(os.path.join(HERE, 'inputs', 'exam_pack_versions.json')))
    rows = []
    for f in sorted(glob.glob(os.path.join(HERE, 'slots', '*.json'))):
        st = json.load(open(f))
        if st['status'] != 'accepted':
            continue
        sl = st['slot']; c = next(x for x in st['candidates'] if x['stage'] == 'accepted'); it = c['item']
        if sl.get('existing'):
            sys.exit(f"{st['id']}: plan row for a topic that already had an FRQ; refusing")
        key = f"{PREFIX[sl['subject_key']]}-frq-u13g-{sl['topic_code'].replace('.', '-')}"
        letters = 'abcdefgh'; crit = []; parts_json = []; lines = []
        for i, p in enumerate(it['parts']):
            pk = f'part-{letters[i]}'; pc = []
            for j, cr in enumerate(p['criteria'], 1):
                ck = f'{pk}-criterion-{j:02d}'
                crit.append({'key': ck, 'text': cr['text'], 'evidence': cr['evidence'], 'fix': cr['fix'], 'variants': cr.get('accepted_variants') or []})
                pc.append({'criterion_key': ck, 'points': 1})
            parts_json.append({'part_key': pk, 'points': len(p['criteria']), 'prompt': p['prompt'], 'criteria': pc})
            lines.append(f"({letters[i]}) {p['prompt']}")
        head = ' '.join(x for x in [CALC_LINE[it['calculator']], 'Answer all parts of the following question.'] if x)
        stem = head + '\n\n' + '\n\n'.join(lines)
        probe = c['probe']
        prompt_json = {'unit': sl['unit'], 'topic': f"{sl['topic_code']} {sl['topic_title']}", 'subject': sl['subject_key'],
                       'frq_form': 'short', 'calculator': it['calculator'], 'parts': parts_json, 'content_key': key,
                       'content_version': 1, 'source_policy': 'Original Cramapple authorship; CED structure and scope only.',
                       'provenance': {'batch': SRC, 'author': 'anthropic/claude-opus-5.5',
                                      'checkers': ['openai/gpt-6.1-sol', 'deepseek/deepseek-v4-pro'],
                                      'topic_votes': probe['votes'], 'accepted_round': c['round']}}
        rows.append({'k': key, 'sk': sl['subject_key'], 'pack': epv[sl['subject_key']], 'tsv': sl['tsv'], 'unit': sl['unit'],
                     'topic': sl['topic_code'], 'title': it['title'], 'stem': stem, 'stimulus': it['stimulus'],
                     'answer': it['model_answer'], 'criteria': crit, 'prompt_json': prompt_json,
                     'required_units': probe['required_units'], 'votes': probe['onTarget'], 'difficulty': c['difficulty'],
                     'h': item_hash(stem, it['stimulus'], crit)})
    json.dump({'source': SRC, 'items': rows}, open(PLAN, 'w'), indent=1, ensure_ascii=False)
    by = {}
    for r in rows: by[r['sk']] = by.get(r['sk'], 0) + 1
    print(f'{len(rows)} FRQs planned:', by)


def load_plan():
    return json.load(open(PLAN))['items']


def txn_sql(rows, approval, mode):
    N = len(rows); sk = rows[0]['sk']; pack = rows[0]['pack']; tsv = rows[0]['tsv']
    assert all(r['sk'] == sk and r['pack'] == pack and r['tsv'] == tsv for r in rows)
    payload = dollar(json.dumps(rows, ensure_ascii=False))
    note = (f"FRQ gap fill Units 1-3 ({SRC}): authored by Claude Opus 5.5; scope and rubric re-derived by GPT-6.1 Sol and "
            f"DeepSeek V4 Pro (protocol sections 4 and 9); sympy recompute; six-vote topic probe; planted-defect controls 8/8. "
            f"Human review waived by the Product Owner. Hard-Gate approval {approval}.")
    body = f"""begin;
select pg_advisory_xact_lock(hashtext({lit('cramapple-' + SRC)}));
create temporary table lab on commit drop as
select x.*, gen_random_uuid() item_id, gen_random_uuid() version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from jsonb_to_recordset({payload}::jsonb) as x(k text, sk text, pack uuid, tsv uuid, unit int, topic text, title text, stem text, stimulus text,
  answer text, criteria jsonb, prompt_json jsonb, required_units int[], votes int, difficulty text, h text);
do $g$ begin
 if (select count(*) from lab)<>{N} then raise exception 'payload size'; end if;
 if not exists (select 1 from app.exam_pack_versions where id={lit(pack)} and status='published') then raise exception 'pack not published'; end if;
 if exists (select 1 from app.content_items ci join lab on lab.k=ci.content_key) then raise exception 'a content_key already exists'; end if;
 if exists (select 1 from lab where not exists (select 1 from app.taxonomy_topics t where t.taxonomy_source_version=lab.tsv and t.topic_code=lab.topic and t.unit_number=lab.unit))
   then raise exception 'topic/unit not in taxonomy'; end if;
 if exists (select 1 from lab where exists (select 1 from app.content_item_cells c join app.content_items ci on ci.id=c.content_item_id
     join app.content_item_versions v on v.id=c.content_item_version_id and v.status='published'
     where ci.item_type='frq' and ci.status='published' and c.is_primary and c.superseded_by is null and c.skill_code is null
       and c.taxonomy_source_version=lab.tsv and c.topic_code=lab.topic))
   then raise exception 'topic already has a published FRQ: %', (select string_agg(lab.k, ', ') from lab where exists (select 1 from app.content_item_cells c join app.content_items ci on ci.id=c.content_item_id
     join app.content_item_versions v on v.id=c.content_item_version_id and v.status='published'
     where ci.item_type='frq' and ci.status='published' and c.is_primary and c.superseded_by is null and c.skill_code is null and c.taxonomy_source_version=lab.tsv and c.topic_code=lab.topic)); end if;
 if exists (select 1 from lab where max_required_unit_bad(lab.required_units, lab.unit)) then raise exception 'required unit later than topic unit'; end if;
end $g$;
"""
    # helper replaced inline below (no function creation in Production)
    body = body.replace("if exists (select 1 from lab where max_required_unit_bad(lab.required_units, lab.unit)) then raise exception 'required unit later than topic unit'; end if;\n",
                        "if exists (select 1 from lab where (select max(u) from unnest(lab.required_units) u) > lab.unit or not (lab.unit = any(lab.required_units))) then raise exception 'required units inconsistent with topic unit'; end if;\n")
    body += f"""insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
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
select assignment_id, version_id, {lit(OWNER)}::uuid, 'tutor_question', 1, difficulty, false, array[]::text[], {lit(note)}, 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_gap_fill_po_waiver','approval',{lit(approval)},'content_key',k),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_gap_fill_po_waiver','approval',{lit(approval)},'content_key',k)::text),
 {lit(OWNER)}::uuid from lab;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by={lit(OWNER)}::uuid, approved_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from lab where ci.id=lab.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', required_units, (select max(u) from unnest(required_units) u), unit, array[topic]::text[], tsv, 'provisional', 'provisional_model', {lit(SRC)},
 jsonb_build_object('topic', topic, 'topic_votes_on_target', votes, 'units_source', 'six-vote probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2): units named by >= 4 of 6'),
 {lit(SRC + ' six-vote probe (' + approval + ')')}, {lit(OWNER)}::uuid from lab;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, {lit(OWNER)}::uuid, 'confirmed', 'automated_spot_check', unit, required_units,
 {lit('Hard-Gate approval ' + approval + '. Six-vote topic probe on target at >= 5 of 6; required units named by >= 4 of 6.')} from lab;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', {lit(SRC)}||':'||votes||'/6',
 {lit(SRC + ' six-vote topic probe (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6) [' + approval + ']')}, null, now(), gen_random_uuid() from lab;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select version_id, difficulty, 'calibrated_judgement', null, 'Majority of the two checker ratings (GPT-6.1 Sol, DeepSeek V4 Pro) for a student who has just studied the topic; provisional until attempts exist.', 'low', {lit(SRC)} from lab;
update app.content_taxonomy_labels l set label_status='validated', validated_by={lit(OWNER)}::uuid, validated_at=now(), validation_decision_id=lab.vd_id,
 validated_against_version_id=lab.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(lab.version_id) from lab where l.content_taxonomy_label_id=lab.label_id;
update app.content_item_versions civ set status='published', published_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='published', updated_at=now() from lab where ci.id=lab.item_id;
do $g$ declare n int; begin
 select count(*) into n from app.content_items ci join lab on lab.item_id=ci.id join app.content_item_versions civ on civ.id=lab.version_id where ci.status='published' and civ.status='published' and ci.item_type='frq'; if n<>{N} then raise exception 'published %', n; end if;
 select count(*) into n from app.content_taxonomy_labels l join lab on lab.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(lab.version_id); if n<>{N} then raise exception 'labels %', n; end if;
 select count(*) into n from app.content_item_cells c join lab on lab.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated' and c.topic_code=lab.topic; if n<>{N} then raise exception 'topic cells %', n; end if;
 select count(*) into n from app.content_item_difficulty d join lab on lab.version_id=d.content_item_version_id; if n<>{N} then raise exception 'difficulty %', n; end if;
 select count(*) into n from lab join app.content_item_versions v on v.id=lab.version_id where nullif(btrim(v.canonical_answer_1),'') is null; if n<>0 then raise exception 'missing model answer %', n; end if;
end $g$;
"""
    if mode == 'rehearse':
        return body + f"do $g$ begin raise exception 'REHEARSAL OK: {sk} published={N}'; end $g$;\nrollback;\n"
    return body + "commit;\n"


def by_subject(rows):
    out = {}
    for r in rows: out.setdefault(r['sk'], []).append(r)
    return out


def state(ref, rows):
    keys = ','.join(lit(r['k']) for r in rows)
    got = query(ref, f"select ci.content_key k, ci.status s from app.content_items ci where ci.content_key in ({keys})")
    if not got: return 'absent'
    if len(got) == len(rows) and all(g['s'] == 'published' for g in got): return 'published'
    return f'partial ({len(got)} of {len(rows)})'


def cmd_preflight(a):
    rows = load_plan(); ref = pmb.ENVS[a.env]
    for sk, rs in by_subject(rows).items():
        topics = ','.join(lit(r['topic']) for r in rs)
        taken = query(ref, f"""select c.topic_code from app.content_item_cells c join app.content_items ci on ci.id=c.content_item_id
          join app.content_item_versions v on v.id=c.content_item_version_id and v.status='published'
          where ci.item_type='frq' and ci.status='published' and c.is_primary and c.superseded_by is null and c.skill_code is null
          and c.taxonomy_source_version={lit(rs[0]['tsv'])} and c.topic_code in ({topics})""")
        print(f"{sk}: {len(rs)} planned, state {state(ref, rs)}, topics that already have an FRQ: {sorted({t['topic_code'] for t in taken}) or 'none'}")


def cmd_rehearse(a):
    rows = load_plan(); ref = pmb.ENVS[a.env]
    for sk, rs in by_subject(rows).items():
        msg = query(ref, txn_sql(rs, a.approval or 'REHEARSAL', 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg: sys.exit(f'{sk}: rehearsal FAILED: {msg[:2000]}')
        print(msg[msg.index('REHEARSAL OK'):].splitlines()[0], '(rolled back)')


def cmd_publish(a):
    if a.env == 'prod' and not (a.approval.startswith('APPROVAL-') and a.confirm_production):
        sys.exit('Production publish needs --approval APPROVAL-NNNN (recorded first) and --confirm-production')
    rows = load_plan(); ref = pmb.ENVS[a.env]; log = []
    for sk, rs in by_subject(rows).items():
        st = state(ref, rs)
        if st == 'published': print(f'{sk}: already published, skipped'); continue
        if st != 'absent': sys.exit(f'{sk}: {st}; stop and investigate')
        msg = query(ref, txn_sql(rs, a.approval, 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg: sys.exit(f'{sk}: rehearsal FAILED, nothing committed for this subject: {msg[:2000]}')
        query(ref, txn_sql(rs, a.approval, 'commit'))
        st = state(ref, rs)
        if st != 'published': sys.exit(f'{sk}: committed but reads "{st}"; stop and investigate')
        print(f'{sk}: rehearsed, committed, verified ({len(rs)} FRQs)')
        log.append({'subject': sk, 'keys': [r['k'] for r in rs], 'at': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())})
    json.dump({'env': a.env, 'approval': a.approval, 'committed': log}, open(os.path.join(HERE, f'publish_{a.env}.json'), 'w'), indent=1)
    cmd_verify(a)


def cmd_verify(a):
    rows = load_plan(); ref = pmb.ENVS[a.env]; keys = ','.join(lit(r['k']) for r in rows)
    got = query(ref, f"""select ci.content_key k, v.stem, v.stimulus,
      (select string_agg(fc.criterion_key||'|'||fc.learner_facing_text||'|'||fc.evidence_requirements||'|'||fc.minimum_fix||'|'||
         (select coalesce('['||string_agg(to_json(e)::text, ', ' order by o)||']','[]') from jsonb_array_elements_text(fc.accepted_variants) with ordinality as t(e,o)),
         E'\\n' order by fc.criterion_key) from app.frq_criteria fc where fc.content_item_version_id=v.id) crit,
      exists (select 1 from app.content_item_topic_resolution r where r.content_item_version_id=v.id and r.is_primary) has_topic,
      exists (select 1 from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
              and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(v.id)) fresh_label
      from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
      where ci.content_key in ({keys}) and ci.status='published'""")
    want = {r['k']: r['h'] for r in rows}; ok = 0; bad = []
    for g in got:
        h = hashlib.md5((g['stem'] + '\n' + (g['stimulus'] or '') + '\n' + (g['crit'] or '')).encode()).hexdigest()
        if h == want.get(g['k']) and g['has_topic'] and g['fresh_label']: ok += 1
        else: bad.append(g['k'])
    print(f'verify: {ok}/{len(rows)} published with matching text, a primary topic and a fresh validated label' + (f'; problems: {bad}' if bad else ''))
    return ok == len(rows)


def main():
    p = argparse.ArgumentParser(); p.add_argument('cmd', choices=['plan', 'preflight', 'rehearse', 'publish', 'verify'])
    p.add_argument('--env', choices=['dev', 'prod'], default='prod'); p.add_argument('--approval', default='')
    p.add_argument('--confirm-production', action='store_true'); a = p.parse_args()
    {'plan': cmd_plan, 'preflight': cmd_preflight, 'rehearse': cmd_rehearse, 'publish': cmd_publish, 'verify': cmd_verify}[a.cmd](a)


if __name__ == '__main__':
    main()
