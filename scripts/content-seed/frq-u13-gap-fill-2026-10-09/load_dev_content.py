#!/usr/bin/env python3
"""Content-only load of accepted FRQs into DEVELOPMENT (Product Owner choice 2026-10-10: "Content-only load").

Development lags Production: only Biology and Statistics have published exam packs, and it has no
content_item_difficulty table, no content_taxonomy_validation_decisions table and no taxonomy_relevant_hash().
So this loader:
  1. ensure-packs: creates a published exam pack version for each subject that lacks one, copying Production's
     exam_code / exam_name / school_year / official_exam_date / source_uri (data only, no schema change);
  2. load: per subject, one transaction: item -> version -> frq_criteria -> stored-text hash check against plan.json ->
     owner approval (assignment + decision) -> reviewed_approved -> validated primary topic cell -> published.
     Unit (serving) labels and difficulty are skipped (tables/function missing in Development).
Rows already present in Development (same content_key) are skipped. Never touches Production.

  python3 load_dev_content.py ensure-packs [--rehearse]
  python3 load_dev_content.py load [--rehearse]
  python3 load_dev_content.py verify
"""
import argparse, hashlib, importlib.util, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
lit, dollar, query = pmb.lit, pmb.dollar, pmb.query
DEV, PROD = pmb.ENVS['dev'], pmb.ENVS['prod']
SRC = 'frq_u13_gap_fill_2026_10_09'
REGISTRY = lambda sk: 'biology' if sk == 'ap_biology' else sk.replace('_', '-')
# Development packs to use where one already exists and is published (the WS3 evidence pack is not a real subject pack).
DEV_PACK_OVERRIDE = {'ap-statistics': '4e54bb4f-695f-41be-ac06-745fe9ad8bcc'}


def dev_owner():
    r = query(DEV, f"select user_id from app.profiles where user_id = {lit(pmb.DEFAULT_OWNER)}")
    if r: return pmb.DEFAULT_OWNER
    r = query(DEV, "select user_id from app.profiles where role = 'admin' order by created_at limit 1")  # owner approval needs an admin
    return r[0]['user_id']


def dev_packs():
    rows = query(DEV, """select s.subject_key, epv.id from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id
      join app.subjects s on s.id=ep.subject_id where epv.status='published' and ep.exam_code not like 'WS3-%' order by epv.official_exam_date desc""")
    out = {}
    for r in rows: out.setdefault(r['subject_key'], r['id'])
    out.update(DEV_PACK_OVERRIDE)
    return out


def cmd_ensure_packs(a):
    have = dev_packs(); owner = dev_owner()
    prod = query(PROD, """select s.subject_key, ep.exam_code, ep.exam_name, v.school_year, v.official_exam_date::text d, v.source_uri
      from app.exam_packs ep join app.subjects s on s.id=ep.subject_id join app.exam_pack_versions v on v.exam_pack_id=ep.id and v.status='published'
      where v.id <> '7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada'""")
    need = [p for p in prod if p['subject_key'] not in have]
    if not need: print('every subject already has a published Development pack'); return
    sql = "begin;\n"
    for p in need:
        sql += f"""insert into app.exam_packs (exam_code, exam_name, subject_id)
select {lit(p['exam_code'])}, {lit(p['exam_name'])}, s.id from app.subjects s where s.subject_key = {lit(p['subject_key'])}
  and not exists (select 1 from app.exam_packs ep where ep.exam_code = {lit(p['exam_code'])});
insert into app.exam_pack_versions (exam_pack_id, school_year, official_exam_date, status, source_uri, released_at, created_by)
select ep.id, case when exists (select 1 from app.exam_pack_versions x where x.exam_pack_id = ep.id and x.school_year = {lit(p['school_year'])}) then '2026-27' else {lit(p['school_year'])} end,
  {lit(p['d'])}::date, 'published', {lit(p['source_uri'])}, now(), {lit(owner)}::uuid
from app.exam_packs ep where ep.exam_code = {lit(p['exam_code'])};
"""
    sql += f"""do $g$ declare n int; begin
 select count(distinct s.subject_key) into n from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id
  where epv.status='published' and s.subject_key in ({','.join(lit(p['subject_key']) for p in need)});
 if n <> {len(need)} then raise exception 'packs created for % of {len(need)} subjects', n; end if;
end $g$;
"""
    if a.rehearse:
        msg = query(DEV, sql + "do $g$ begin raise exception 'REHEARSAL OK: packs'; end $g$;\nrollback;\n", expect_error=True)
        print(msg[msg.index('REHEARSAL OK'):].splitlines()[0] if 'REHEARSAL OK' in msg else 'REHEARSAL FAILED: ' + msg[:1500]); return
    query(DEV, sql + "commit;\n"); print('created Development packs for:', [p['subject_key'] for p in need])


def load_sql(rows, pack, tsv, owner, mode):
    N = len(rows); payload = dollar(json.dumps(rows, ensure_ascii=False))
    note = f"FRQ gap fill Units 1-3 ({SRC}), Development content-only load. Same text as the Production plan; human review waived by the Product Owner."
    body = f"""begin;
select pg_advisory_xact_lock(hashtext({lit('cramapple-dev-' + SRC)}));
create temporary table lab on commit drop as
select x.*, gen_random_uuid() item_id, gen_random_uuid() version_id, gen_random_uuid() assignment_id
from jsonb_to_recordset({payload}::jsonb) as x(k text, unit int, topic text, title text, stem text, stimulus text, answer text, criteria jsonb, prompt_json jsonb, difficulty text, h text, cell_basis text);
do $g$ begin
 if exists (select 1 from app.content_items ci join lab on lab.k=ci.content_key) then raise exception 'a content_key already exists'; end if;
 if exists (select 1 from lab where not exists (select 1 from app.taxonomy_topics t where t.taxonomy_source_version={lit(tsv)} and t.topic_code=lab.topic and t.unit_number=lab.unit)) then raise exception 'topic/unit not in taxonomy'; end if;
end $g$;
insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
select item_id, {lit(pack)}::uuid, k, 'frq', title, 'draft', 'short', 'targeted_drill', null from lab;
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
   then raise exception 'stored text does not match the plan hashes'; end if;
end $g$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, {lit(owner)}::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', {lit(owner)}::uuid from lab;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, decision_payload, decision_hash, created_by)
select assignment_id, version_id, {lit(owner)}::uuid, 'tutor_question', 1, difficulty, false, array[]::text[], {lit(note)},
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_gap_fill_dev_content_load','content_key',k),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_gap_fill_dev_content_load','content_key',k)::text), {lit(owner)}::uuid from lab;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by={lit(owner)}::uuid, approved_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from lab where ci.id=lab.item_id;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, {lit(tsv)}::uuid, topic, null, true, 'validated', {lit(SRC)}||':'||cell_basis, {lit(SRC + ' six-vote topic probe or CED-text ruling (Development copy)')}, {lit(owner)}::uuid, now(), gen_random_uuid() from lab;
update app.content_item_versions civ set status='published', published_at=now(), updated_at=now() from lab where civ.id=lab.version_id;
update app.content_items ci set status='published', updated_at=now() from lab where ci.id=lab.item_id;
do $g$ declare n int; begin
 select count(*) into n from app.content_items ci join lab on lab.item_id=ci.id join app.content_item_versions civ on civ.id=lab.version_id where ci.status='published' and civ.status='published'; if n<>{N} then raise exception 'published %', n; end if;
 select count(*) into n from app.content_item_cells c join lab on lab.version_id=c.content_item_version_id where c.is_primary and c.topic_code=lab.topic; if n<>{N} then raise exception 'topic cells %', n; end if;
end $g$;
"""
    if mode == 'rehearse':
        return body + f"do $g$ begin raise exception 'REHEARSAL OK: {N} FRQs'; end $g$;\nrollback;\n"
    return body + "commit;\n"


def cmd_load(a):
    plan = json.load(open(os.path.join(HERE, 'plan.json')))['items']; packs = dev_packs(); owner = dev_owner()
    tsvs = {r['subject_key']: r['taxonomy_source_version'] for r in query(DEV, "select subject_key, taxonomy_source_version from app.taxonomy_source_versions")}
    present = {r['content_key'] for r in query(DEV, f"select content_key from app.content_items where content_key in ({','.join(lit(r['k']) for r in plan)})")}
    by = {}
    for r in plan:
        if r['k'] not in present: by.setdefault(r['sk'], []).append(r)
    if not by: print('nothing to load: every planned FRQ is already in Development'); return
    for sk, rs in sorted(by.items()):
        pack = packs.get(REGISTRY(sk))
        if not pack: sys.exit(f'{sk}: no published Development pack; run ensure-packs first')
        rows = [{k: r[k] for k in ('k', 'unit', 'topic', 'title', 'stem', 'stimulus', 'answer', 'criteria', 'prompt_json', 'difficulty', 'h')} | {'cell_basis': r.get('cell_basis') or f"{r['votes']}/6"} for r in rs]
        msg = query(DEV, load_sql(rows, pack, tsvs[sk], owner, 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg: sys.exit(f'{sk}: Development rehearsal FAILED: {msg[:1500]}')
        if a.rehearse: print(f'{sk}: rehearsal OK ({len(rows)})'); continue
        query(DEV, load_sql(rows, pack, tsvs[sk], owner, 'commit')); print(f'{sk}: loaded and published in Development ({len(rows)})')
    if not a.rehearse: cmd_verify(a)


def cmd_verify(a):
    plan = json.load(open(os.path.join(HERE, 'plan.json')))['items']; keys = ','.join(lit(r['k']) for r in plan)
    got = query(DEV, f"""select ci.content_key k, v.stem, v.stimulus,
      (select string_agg(fc.criterion_key||'|'||fc.learner_facing_text||'|'||fc.evidence_requirements||'|'||fc.minimum_fix||'|'||
         (select coalesce('['||string_agg(to_json(e)::text, ', ' order by o)||']','[]') from jsonb_array_elements_text(fc.accepted_variants) with ordinality as t(e,o)),
         E'\\n' order by fc.criterion_key) from app.frq_criteria fc where fc.content_item_version_id=v.id) crit
      from app.content_items ci join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
      where ci.content_key in ({keys}) and ci.status='published'""")
    want = {r['k']: r['h'] for r in plan}
    ok = sum(1 for g in got if hashlib.md5((g['stem'] + '\n' + (g['stimulus'] or '') + '\n' + (g['crit'] or '')).encode()).hexdigest() == want.get(g['k']))
    print(f'Development verify: {ok}/{len(plan)} planned FRQs published with text matching the plan')


def main():
    p = argparse.ArgumentParser(); p.add_argument('cmd', choices=['ensure-packs', 'load', 'verify']); p.add_argument('--rehearse', action='store_true')
    a = p.parse_args(); {'ensure-packs': cmd_ensure_packs, 'load': cmd_load, 'verify': cmd_verify}[a.cmd](a)


if __name__ == '__main__':
    main()
