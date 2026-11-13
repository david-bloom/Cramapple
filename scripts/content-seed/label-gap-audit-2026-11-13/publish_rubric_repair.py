#!/usr/bin/env python3
"""Phase 1 of the rubric-held FRQ repair: publish a NEW VERSION (rubric-side edits, prompt text unchanged) of each item in stage6/plan.json.
Old version -> retired; new version walks draft -> reviewed_approved -> published (item likewise); difficulty rows are carried to the new version.
No label or cell is written here (phase 2 = publish_labels_r3.py). One rehearsable transaction per subject, advisory lock.
  python3 -I publish_rubric_repair.py preflight|rehearse|publish|verify [--subject S] [--approval APPROVAL-NNNN --confirm-production]"""
import argparse, hashlib, importlib.util, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; assert REF == 'pcntajvbdfqhbeewmdry'
OWNER = pmb.DEFAULT_OWNER; SRC = 'rubric_preflight_repair_2026_11_13'
SUBJ = lambda k: {'apcalcab':'ap_calculus_ab','apcalcbc':'ap_calculus_bc','apphy1':'ap_physics_1','apphy2':'ap_physics_2','apphycem':'ap_physics_c_em','apphycm':'ap_physics_c_mechanics','apprecalc':'ap_precalculus'}[k.split('-')[0]]
PLAN = json.load(open(os.path.join(HERE, 'stage6', 'plan.json')))
def chash(crit): return hashlib.md5('\n'.join(f"{c['criterion_key']}|{c['learner_facing_text']}|{c['evidence_requirements']}|{c['minimum_fix']}|{c['points_possible']}" for c in sorted(crit, key=lambda c: c['criterion_key'])).encode()).hexdigest()
def rows(sub): return sorted([p for p in PLAN if SUBJ(p['content_key']) == sub], key=lambda p: p['content_key'])
SUBJECTS = sorted({SUBJ(p['content_key']) for p in PLAN})
def ph(rs): return hashlib.md5('\n'.join(f"{p['content_key']}:{p['old_version_num']}:{p['new_total']}:{chash(p['criteria'])}" for p in rs).encode()).hexdigest()
def payload(rs): return [{'k': p['content_key'], 'ov': p['old_version_id'], 'onum': p['old_version_num'], 'pj': p['prompt_json'], 'tot': p['new_total'], 'nc': len(p['criteria']), 'h': chash(p['criteria']),
                          'crit': [{'key': c['criterion_key'], 'text': c['learner_facing_text'], 'ev': c['evidence_requirements'], 'fix': c['minimum_fix'], 'pts': c['points_possible'], 'jk': c.get('judgement_kind') or 'text', 'var': c.get('accepted_variants') or []} for c in sorted(p['criteria'], key=lambda c: c['criterion_key'])]} for p in rs]
def sql(sub, rs, approval, mode):
    N = len(rs); note = f"Rubric preflight repair ({SRC}): criteria aligned to the operations the prompt asks; prompt text unchanged. Checked by GPT-6.1 Sol and DeepSeek V4 Pro / Gemini 3.8 Flash. Hard-Gate approval {approval}."
    body = f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-{SRC}'));
create temporary table w on commit drop as
select r.*, ci.id item_id, v.id old_vid, gen_random_uuid() nvid, gen_random_uuid() aid, v.stem, v.stimulus, v.explanation, v.help_text, v.canonical_answer_1, v.canonical_answer_2, v.rubric_type, v.evaluator_strategy, v.stimulus_image_path
from jsonb_to_recordset({pmb.dollar(json.dumps(payload(rs), ensure_ascii=False))}::jsonb) as r(k text, ov uuid, onum int, pj jsonb, tot int, nc int, h text, crit jsonb)
join app.content_items ci on ci.content_key=r.k and ci.status='published' and ci.item_type='frq'
join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by x.version_num desc limit 1) v on true;
do $g$ declare n int; begin
 select count(*) into n from w; if n<>{N} then raise exception 'resolved rows % expected {N}', n; end if;
 select count(*) into n from w where old_vid<>ov; if n<>0 then raise exception '% latest versions differ from the plan (drift)', n; end if;
 select count(*) into n from w join app.content_item_versions v on v.id=w.old_vid where v.status<>'published' or v.version_num<>w.onum; if n<>0 then raise exception '% old versions not published/num drift', n; end if;
 select count(*) into n from w where (select count(*) from app.content_item_versions x where x.content_item_id=w.item_id and x.status='published')<>1; if n<>0 then raise exception '% items without exactly one published version', n; end if;
 select count(*) into n from w where exists (select 1 from app.content_taxonomy_labels l where l.content_item_id=w.item_id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated'); if n<>0 then raise exception '% items already have a validated serving label', n; end if;
end $g$;
update app.content_item_versions v set status='retired', updated_at=now() from w where v.id=w.old_vid;
insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, explanation, help_text, content_hash, status, created_by, canonical_answer_1, canonical_answer_2, review_status, rubric_type, evaluator_strategy, stimulus_image_path)
select nvid, item_id, onum+1, stem, stimulus, pj, explanation, help_text, md5(k||'-rubric-repair-v'||(onum+1)), 'draft', {pmb.lit(OWNER)}::uuid, canonical_answer_1, canonical_answer_2, null, rubric_type, evaluator_strategy, stimulus_image_path from w;
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants, judgement_kind)
select w.nvid, c->>'key', c->>'text', (c->>'pts')::int, c->>'ev', c->>'fix', coalesce(c->'var','[]'::jsonb), c->>'jk' from w cross join lateral jsonb_array_elements(w.crit) c;
do $g$ declare n int; begin
 select count(*) into n from w where md5((select string_agg(f.criterion_key||'|'||f.learner_facing_text||'|'||f.evidence_requirements||'|'||f.minimum_fix||'|'||f.points_possible::text, E'\\n' order by f.criterion_key collate "C") from app.frq_criteria f where f.content_item_version_id=w.nvid))=w.h; if n<>{N} then raise exception 'stored rubric hash mismatch (% of {N})', n; end if;
 select count(*) into n from w where (select sum(points_possible) from app.frq_criteria f where f.content_item_version_id=w.nvid)<>w.tot; if n<>0 then raise exception 'point totals'; end if;
end $g$;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, attainment_ratio, ratio_source, subject_cut_points, source_value, rationale, confidence, proposal_run)
select w.nvid, d.difficulty, d.basis, d.attainment_ratio, d.ratio_source, d.subject_cut_points, d.source_value, d.rationale, d.confidence, d.proposal_run from w join app.content_item_difficulty d on d.content_item_version_id=w.old_vid;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select aid, nvid, {pmb.lit(OWNER)}::uuid, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', {pmb.lit(OWNER)}::uuid from w;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select aid, nvid, {pmb.lit(OWNER)}::uuid, 'tutor_question', 1, 'Medium', false, array[]::text[], {pmb.lit(note)}, 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','rubric_preflight_repair_po_direction','approval',{pmb.lit(approval)},'content_key',k),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','rubric_preflight_repair_po_direction','approval',{pmb.lit(approval)},'content_key',k)::text), {pmb.lit(OWNER)}::uuid from w;
update app.content_item_versions v set status='reviewed_approved', review_status='question_review_approved', approved_by={pmb.lit(OWNER)}::uuid, approved_at=now(), updated_at=now() from w where v.id=w.nvid;
update app.content_items ci set status='reviewed_approved', updated_at=now() from w where ci.id=w.item_id;
update app.content_item_versions v set status='published', published_at=now(), updated_at=now() from w where v.id=w.nvid;
update app.content_items ci set status='published', updated_at=now() from w where ci.id=w.item_id;
do $g$ declare n int; begin
 select count(*) into n from w join app.content_items ci on ci.id=w.item_id join app.content_item_versions v on v.id=w.nvid where ci.status='published' and v.status='published'; if n<>{N} then raise exception 'published %', n; end if;
 select count(*) into n from w join app.content_item_versions v on v.id=w.old_vid where v.status='retired'; if n<>{N} then raise exception 'old versions retired %', n; end if;
 select count(*) into n from w where (select count(*) from app.content_item_versions x where x.content_item_id=w.item_id and x.status='published')<>1; if n<>0 then raise exception 'not exactly one published version %', n; end if;
 select count(*) into n from w join app.content_item_difficulty d on d.content_item_version_id=w.nvid; if n<{N} then raise exception 'difficulty rows carried %', n; end if;
end $g$;
"""
    if mode == 'rehearse': return body + "set constraints all immediate;\n" + f"do $g$ begin raise exception 'REHEARSAL OK: {sub} items={N} criteria={sum(len(p['criteria']) for p in rs)} hash={ph(rs)}'; end $g$;\nrollback;\n"
    return body + "commit;\n"
def verify(sub, rs):
    keys = ','.join(pmb.lit(p['content_key']) for p in rs)
    got = pmb.query(REF, f"""select ci.content_key k, v.version_num vn, v.status vs, ci.status isx,
      (select md5(string_agg(f.criterion_key||'|'||f.learner_facing_text||'|'||f.evidence_requirements||'|'||f.minimum_fix||'|'||f.points_possible::text, E'\\n' order by f.criterion_key collate "C")) from app.frq_criteria f where f.content_item_version_id=v.id) h,
      (select count(*) from app.content_item_versions x where x.content_item_id=ci.id and x.status='published') npub
      from app.content_items ci join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by version_num desc limit 1) v on true where ci.content_key in ({keys}) order by 1""")
    exp = {p['content_key']: p for p in rs}
    bad = [g['k'] for g in got if g['vn'] != exp[g['k']]['old_version_num'] + 1 or g['vs'] != 'published' or g['isx'] != 'published' or g['h'] != chash(exp[g['k']]['criteria']) or g['npub'] != 1]
    ok = len(got) == len(rs) and not bad; print(f"verify {sub}: {len(got)}/{len(rs)} new versions published with planned rubric; mismatches {bad} -> {'MATCH' if ok else 'MISMATCH'}"); return ok
def main():
    a = argparse.ArgumentParser(); a.add_argument('cmd', choices=['rehearse', 'publish', 'verify']); a.add_argument('--subject'); a.add_argument('--approval', default='')
    a.add_argument('--confirm-production', action='store_true'); a = a.parse_args(); rc = 0
    for sub in ([a.subject] if a.subject else SUBJECTS):
        rs = rows(sub)
        if a.cmd == 'verify': rc |= 0 if verify(sub, rs) else 1
        elif a.cmd == 'rehearse':
            msg = pmb.query(REF, sql(sub, rs, a.approval or 'REHEARSAL', 'rehearse'), expect_error=True)
            if 'REHEARSAL OK' not in msg: print(sub, 'rehearsal FAILED:', msg[:1500]); rc = 1
            else: print(msg[msg.index('REHEARSAL OK'):].splitlines()[0], '(rolled back)')
        else:
            if not (a.approval.startswith('APPROVAL-') and a.confirm_production): sys.exit('needs --approval APPROVAL-NNNN (recorded first) and --confirm-production')
            msg = pmb.query(REF, sql(sub, rs, a.approval, 'rehearse'), expect_error=True)
            if 'REHEARSAL OK' not in msg: sys.exit(f'{sub} pre-commit rehearsal FAILED, nothing committed: {msg[:1500]}')
            pmb.query(REF, sql(sub, rs, a.approval, 'commit')); print(sub, 'COMMITTED'); rc |= 0 if verify(sub, rs) else 1
    sys.exit(rc)
if __name__ == '__main__': main()
