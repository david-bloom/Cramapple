#!/usr/bin/env python3
"""Stage 4: write the Stage 3 labels (validated primary topic cells + validated serving labels) to Production, one transaction per subject.
Labels only: no item text, version, status, difficulty or skill is touched. Additive for validated rows: only non-validated rows are changed
(provisional_model/authored primary cells are promoted in place; non-validated serving labels get superseded_by).
  python3 -I publish_labels.py preflight  [--subject S]        read-only: pre-state snapshot (stage4/pre_state.json) and drift checks
  python3 -I publish_labels.py rehearse   [--subject S]        full transaction, raises REHEARSAL OK and rolls back
  python3 -I publish_labels.py publish    --approval APPROVAL-NNNN --confirm-production [--subject S]
  python3 -I publish_labels.py verify     [--subject S]        read-only independent check against the plan
Production only (ref asserted). Transport: Supabase Management API with the CLI token (publish_mcq_batch.query)."""
import argparse, hashlib, importlib.util, json, os, sys, glob
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; assert REF == 'pcntajvbdfqhbeewmdry'
OWNER = pmb.DEFAULT_OWNER; SRC = 'label_gap_fill_u1_5_2026_11_13'
def load(sub): return sorted(json.load(open(os.path.join(HERE, 'stage3', f'load_{sub}.json'))), key=lambda r: r['content_key'])
SUBJECTS = sorted(os.path.basename(f)[5:-5] for f in glob.glob(os.path.join(HERE, 'stage3', 'load_*.json')))
def ph(rs): return hashlib.md5('\n'.join(f"{r['content_key']}:{r['topic']}:{r['max_required_unit']}:{r['cell_action']}:{r['label_action']}" for r in rs).encode()).hexdigest()
def payload(rs):
    return [{'k': r['content_key'], 'vid': r['vid'], 'topic': r['topic'], 'pu': r['primary_unit'], 'ru': r['required_units'], 'mx': r['max_required_unit'],
             'ca': r['cell_action'], 'cid': r.get('cell_id'), 'la': r['label_action'], 'lv': r.get('label_version'), 'sup': r.get('supersedes') or [],
             'method': r['method'], 'hold': r.get('hold_reason'), 'votes': r.get('topic_votes'), 'uv': r.get('unit_votes'), 'basis': r.get('basis_note')} for r in rs]
def sql(sub, rs, approval, mode):
    N = len(rs); NC = sum(1 for r in rs if r['cell_action'] in ('insert','promote_in_place')); NI = sum(1 for r in rs if r['cell_action'] == 'insert'); NP = sum(1 for r in rs if r['cell_action'] == 'promote_in_place'); NL = sum(1 for r in rs if r['label_action'])
    body = f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-{SRC}'));
create temporary table w on commit drop as
select r.*, ci.id item_id, v.id version_id, tsv.taxonomy_source_version tsv, gen_random_uuid() label_id, gen_random_uuid() vd_id,
  case when r.ca is not null or r.la is not null then {pmb.lit(SRC)} end src
from jsonb_to_recordset({pmb.dollar(json.dumps(payload(rs), ensure_ascii=False))}::jsonb) as r(k text, vid uuid, topic text, pu int, ru int[], mx int, ca text, cid uuid, la text, lv int, sup uuid[], method text, hold text, votes jsonb, uv jsonb, basis text)
join app.content_items ci on ci.content_key=r.k and ci.status='published'
join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by x.version_num desc limit 1) v on true
join app.taxonomy_source_versions tsv on tsv.subject_key={pmb.lit(sub)};
do $g$ declare n int; begin
 select count(*) into n from w; if n<>{N} then raise exception 'resolved rows % expected {N}', n; end if;
 select count(*) into n from w where version_id<>vid; if n<>0 then raise exception '% latest versions differ from the plan (drift)', n; end if;
 select count(*) into n from w join app.content_item_versions v on v.id=w.version_id where v.status<>'published'; if n<>0 then raise exception '% latest versions not published', n; end if;
 select count(*) into n from w left join app.taxonomy_topics t on t.taxonomy_source_version=w.tsv and t.topic_code=w.topic and t.unit_number=w.pu where t.topic_code is null; if n<>0 then raise exception '% topics not in taxonomy at stated unit', n; end if;
 select count(*) into n from w where not (pu=any(ru)) or mx<>(select max(u) from unnest(ru) u); if n<>0 then raise exception '% unit arrays inconsistent', n; end if;
 select count(*) into n from w where ca='insert' and exists (select 1 from app.content_item_cells c where c.content_item_version_id=w.version_id and c.is_primary and c.superseded_by is null); if n<>0 then raise exception '% insert targets already have a primary cell', n; end if;
 select count(*) into n from w where ca='promote_in_place' and not exists (select 1 from app.content_item_cells c where c.content_item_cell_id=w.cid and c.content_item_version_id=w.version_id and c.is_primary and c.superseded_by is null and c.skill_code is null and c.topic_code=w.topic and c.assignment_status in ('provisional_model','authored')); if n<>0 then raise exception '% promote targets are not the expected non-validated primary cell', n; end if;
 select count(*) into n from w where la is not null and exists (select 1 from app.content_taxonomy_labels l where l.content_item_id=w.item_id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated'); if n<>0 then raise exception '% label targets already have an active validated label', n; end if;
 select count(*) into n from w where la is not null and w.lv<>(select coalesce(max(l.label_version),0)+1 from app.content_taxonomy_labels l where l.content_item_id=w.item_id and l.label_scope='serving'); if n<>0 then raise exception '% label_version drift', n; end if;
 select count(*) into n from w where la is not null and coalesce((select array_agg(l.content_taxonomy_label_id order by l.content_taxonomy_label_id) from app.content_taxonomy_labels l where l.content_item_id=w.item_id and l.label_scope='serving' and l.superseded_by is null),array[]::uuid[]) is distinct from coalesce((select array_agg(u order by u) from unnest(w.sup) u),array[]::uuid[]); if n<>0 then raise exception '% active-label set differs from plan', n; end if;
 select count(*) into n from w where ca is null and not exists (select 1 from app.content_item_cells c where c.content_item_version_id=w.version_id and c.is_primary and c.superseded_by is null and c.assignment_status='validated' and c.topic_code=w.topic); if n<>0 then raise exception '% no-cell-action rows lack the validated cell with the voted topic', n; end if;
 select count(*) into n from w where ca='keep_authored' and not exists (select 1 from app.content_item_cells c where c.content_item_version_id=w.version_id and c.is_primary and c.superseded_by is null and c.assignment_status='authored' and c.topic_code=w.topic); if n<>0 then raise exception '% keep_authored rows lack the authored cell with the voted topic', n; end if;
end $g$;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', src||':'||method, 'label gap fill U1-5 six-vote topic probe (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol; topic agreement >= 5 of 6) [{approval}]', null, now(), gen_random_uuid() from w where ca='insert';
update app.content_item_cells c set assignment_status='validated', validated_at=now(), validation_decision_id=gen_random_uuid(),
  source=src||':'||w.method||':promoted_from_'||c.assignment_status, model_run_id='label gap fill U1-5 six-vote topic probe agrees with the existing '||c.assignment_status||' cell; promoted in place [{approval}]; previously '||coalesce(c.source,'')
from w where w.ca='promote_in_place' and c.content_item_cell_id=w.cid;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, lv, 'serving', ru, mx, pu, array[]::text[], tsv, 'provisional', 'provisional_model', src,
 jsonb_build_object('topic', topic, 'method', method, 'topic_votes', votes, 'unit_votes', uv, 'basis_note', basis, 'released_from_hold', hold, 'units_source','units named by >= 4 of 6 votes','approval','{approval}'),
 'label gap fill U1-5 ('||method||') [{approval}]', {pmb.lit(OWNER)}::uuid from w where la='insert_validated';
update app.content_taxonomy_labels l set superseded_by=w.label_id from w, unnest(w.sup) s where w.la='insert_validated' and l.content_taxonomy_label_id=s;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, {pmb.lit(OWNER)}::uuid, 'confirmed', 'automated_spot_check', pu, ru, 'Hard-Gate approval {approval}. Topic at >= 5 of 6 votes (or recorded provenance); required units named by >= 4 of 6.' from w where la='insert_validated';
update app.content_taxonomy_labels l set label_status='validated', validated_by={pmb.lit(OWNER)}::uuid, validated_at=now(), validation_decision_id=w.vd_id,
 validated_against_version_id=w.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(w.version_id) from w where l.content_taxonomy_label_id=w.label_id;
do $g$ declare n int; h text; begin
 select count(*) into n from w where exists (select 1 from app.content_item_cells c where c.content_item_version_id=w.version_id and c.is_primary and c.superseded_by is null and c.topic_code=w.topic and ((c.assignment_status='validated' and c.skill_code is null) or (w.ca='keep_authored' and c.assignment_status='authored'))); if n<>{N} then raise exception 'post-check topic cells % <> {N}', n; end if;
 select count(*) into n from app.content_item_cells c join w on w.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null; if n<>{N} then raise exception 'primary cells % <> {N} (duplicate primary)', n; end if;
 select count(*) into n from w where la is not null and exists (select 1 from app.content_taxonomy_labels l where l.content_item_id=w.item_id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.content_taxonomy_label_id=w.label_id and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(w.version_id) and l.max_required_unit=w.mx); if n<>{NL} then raise exception 'fresh validated labels % <> {NL}', n; end if;
 select count(*) into n from w where exists (select 1 from app.content_taxonomy_labels l where l.content_item_id=w.item_id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(w.version_id)); if n<>{N} then raise exception 'items with a servable label % <> {N}', n; end if;
 select md5(string_agg(w.k||':'||w.topic||':'||w.mx||':'||coalesce(w.ca,'None')||':'||coalesce(w.la,'None'), E'\\n' order by w.k collate "C")) into h from w; if h<>{pmb.lit(ph(rs))} then raise exception 'plan hash % <> {ph(rs)}', h; end if;
end $g$;
"""
    if mode == 'rehearse': return body + f"do $g$ begin raise exception 'REHEARSAL OK: {sub} items={N} cells={NC} (insert {NI}, promote {NP}) labels={NL} hash={ph(rs)}'; end $g$;\nrollback;\n"
    return body + "commit;\n"
def preflight(sub, rs):
    ids = ','.join(pmb.lit(r['vid']) for r in rs)
    cells = pmb.query(REF, f"select content_item_cell_id::text id, content_item_version_id::text vid, topic_code, assignment_status, source, model_run_id from app.content_item_cells where content_item_version_id in ({ids}) and is_primary and superseded_by is null")
    labs = pmb.query(REF, f"select l.content_taxonomy_label_id::text id, l.content_item_id::text iid, l.label_version, l.label_status, l.superseded_by::text from app.content_taxonomy_labels l where l.label_scope='serving' and l.content_item_id in (select content_item_id from app.content_item_versions where id in ({ids}))")
    return {'cells': cells, 'labels': labs}
def verify(sub, rs):
    keys = ','.join(pmb.lit(r['content_key']) for r in rs)
    got = pmb.query(REF, f"""select ci.content_key k, c.topic_code t, l.max_required_unit mx,
      (l.validated_against_taxo_hash=app.taxonomy_relevant_hash(v.id)) fresh
      from app.content_items ci join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by version_num desc limit 1) v on true
      left join app.content_item_cells c on c.content_item_version_id=v.id and c.is_primary and c.superseded_by is null and ((c.assignment_status='validated' and c.skill_code is null) or c.assignment_status='authored')
      left join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated'
      where ci.content_key in ({keys}) and ci.status='published' order by ci.content_key""")
    exp = {r['content_key']: r for r in rs}
    bad = [g['k'] for g in got if g['t'] != exp[g['k']]['topic'] or (exp[g['k']]['label_action'] and g['mx'] != exp[g['k']]['max_required_unit']) or not g['fresh']]
    ok = len(got) == len(rs) and not bad
    print(f"verify {sub}: {len(got)}/{len(rs)} items with validated topic cell + fresh validated serving label matching plan; mismatches {len(bad)} {bad[:5]} -> {'MATCH' if ok else 'MISMATCH'}")
    return ok
def main():
    a = argparse.ArgumentParser(); a.add_argument('cmd', choices=['preflight', 'rehearse', 'publish', 'verify']); a.add_argument('--subject'); a.add_argument('--approval', default='')
    a.add_argument('--confirm-production', action='store_true'); a = a.parse_args()
    subs = [a.subject] if a.subject else SUBJECTS; rc = 0
    for sub in subs:
        rs = load(sub)
        if a.cmd == 'preflight':
            pre = preflight(sub, rs); os.makedirs(os.path.join(HERE, 'stage4'), exist_ok=True)
            json.dump(pre, open(os.path.join(HERE, 'stage4', f'pre_state_{sub}.json'), 'w'), indent=0); print(sub, len(rs), 'items; pre-state cells', len(pre['cells']), 'labels', len(pre['labels']))
        elif a.cmd == 'verify': rc |= 0 if verify(sub, rs) else 1
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
