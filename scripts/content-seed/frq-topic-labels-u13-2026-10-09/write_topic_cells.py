#!/usr/bin/env python3
"""Write validated primary topic cells for published FRQs whose six-vote topic probe lands in Units 1-3.

Source of the labels: docs/qa/FRQ_UNITS_1_3_TOPIC_COVERAGE_AUDIT_2026_10_09.md (runbook topic probe, accepted at
>= 5 of 6; six CED-text tiebreaks). Input: write_candidates.json (181 rows). Two topic/unit-label mismatches are held
out in unit_mismatch.json and are NOT written.

  python3 write_topic_cells.py rehearse --env prod
  python3 write_topic_cells.py commit   --env prod --approval APPROVAL-0143 --confirm-production
  python3 write_topic_cells.py verify   --env prod
Transport: publish_mcq_batch.query (Supabase Management API, CLI access token). One transaction; a rehearsal raises
and rolls back. A re-run of commit refuses if any target version already has an active primary cell.
"""
import argparse, hashlib, importlib.util, json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)

RUN = 'frq_topic_probe_2026_10_09'
PREFIX = {'ap_calculus_bc': 'apcalcbc', 'ap_chemistry': 'apchem', 'ap_physics_1': 'apphy1', 'ap_physics_2': 'apphy2',
          'ap_physics_c_em': 'apphycem', 'ap_physics_c_mechanics': 'apphycm', 'ap_precalculus': 'apprecalc',
          'ap_calculus_ab': 'apcalcab', 'ap_biology': 'apbio'}
U13 = {'ap_physics_2': [9, 10, 11], 'ap_physics_c_em': [8, 9, 10]}

INPUT = 'write_candidates.json'

def rows():
    out = []
    for c in json.load(open(os.path.join(HERE, INPUT))):
        p = PREFIX[c['sk']]
        if c['src'] == 'course_pdf_unit_resolution':
            src = f"{p}_{RUN}:course_pdf_unit_resolution"
            note = (f"{p}-frq-topic-probe-2026-10-09 (six-vote probe {c['votes_note']}; held for a unit-label conflict, then "
                    f"resolved by Claude reading the official course and exam description PDF in subject packs/)")
        elif c['src'] == 'ced_text_tiebreak':
            src = f"{p}_{RUN}:ced_text_tiebreak"
            note = f"{p}-frq-topic-probe-2026-10-09 (six-vote probe below 5 of 6; tiebreak by Claude reading the item against the CED topic text)"
        else:
            n = c['src'].split('_')[1].replace('of', '/')  # probe_6of6 -> 6/6
            src = f"{p}_{RUN}:{n}"
            note = f"{p}-frq-topic-probe-2026-10-09 (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6)"
        out.append({'k': c['k'], 'sk': c['sk'], 'topic': c['topic'], 'unit': c['unit'], 'src': src, 'note': note,
                    'units': U13.get(c['sk'], [1, 2, 3])})
    return sorted(out, key=lambda r: r['k'])

def plan_hash(rs):
    return hashlib.md5('\n'.join(f"{r['k']}:{r['topic']}" for r in rs).encode()).hexdigest()

def sql(rs, approval, mode):
    N = len(rs); payload = pmb.dollar(json.dumps(rs, ensure_ascii=False))
    body = f"""begin;
select pg_advisory_xact_lock(hashtext('cramapple-{RUN}'));
create temporary table w on commit drop as
select r.k, r.sk, r.topic, r.unit, r.src, r.note || ' [' || {pmb.lit(approval)} || ']' as note, r.units,
       ci.id item_id, v.id version_id, tsv.taxonomy_source_version tsv
from jsonb_to_recordset({payload}::jsonb) as r(k text, sk text, topic text, unit int, src text, note text, units int[])
left join app.content_items ci on ci.content_key = r.k and ci.item_type = 'frq' and ci.status = 'published'
left join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published'
left join app.taxonomy_source_versions tsv on tsv.subject_key = r.sk;
do $g$ declare n int; begin
 select count(*) into n from w; if n<>{N} then raise exception 'resolved rows % (expected {N}; a key has 0 or >1 published versions)', n; end if;
 select count(*) into n from w where item_id is null or version_id is null or tsv is null; if n<>0 then raise exception '% rows did not resolve to a published FRQ version and taxonomy', n; end if;
 select count(*) into n from (select k from w group by k having count(*)>1) d; if n<>0 then raise exception 'duplicate keys %', n; end if;
 select count(*) into n from w left join app.taxonomy_topics t on t.taxonomy_source_version=w.tsv and t.topic_code=w.topic and t.unit_number=w.unit where t.topic_code is null; if n<>0 then raise exception '% topics not in taxonomy at the stated unit', n; end if;
 select count(*) into n from w where not (w.unit = any(w.units)); if n<>0 then raise exception '% rows outside Units 1-3', n; end if;
 select count(*) into n from w join app.content_item_cells c on c.content_item_version_id=w.version_id and c.superseded_by is null and c.skill_code is null; if n<>0 then raise exception '% target versions already have a topic cell', n; end if;
 select count(*) into n from w join app.content_item_cells c on c.content_item_version_id=w.version_id and c.is_primary and c.superseded_by is null; if n<>0 then raise exception '% target versions already have a primary cell', n; end if;
end $g$;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary,
  assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', src, note, null, now(), gen_random_uuid() from w;
do $g$ declare n int; h text; begin
 select count(*) into n from app.content_item_cells c join w on w.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated' and c.source like '%{RUN}%'; if n<>{N} then raise exception 'post-check cells %', n; end if;
 select md5(string_agg(w.k||':'||c.topic_code, E'\\n' order by w.k)) into h from w join app.content_item_cells c on c.content_item_version_id=w.version_id and c.source like '%{RUN}%' and c.superseded_by is null;
 if h<>{pmb.lit(plan_hash(rs))} then raise exception 'post-check hash % <> plan', h; end if;
end $g$;
"""
    if mode == 'rehearse':
        return body + f"do $g$ begin raise exception 'REHEARSAL OK: topic_cells={N} hash={plan_hash(rs)}'; end $g$;\nrollback;\n"
    return body + "commit;\n"

def verify(ref, rs):
    keys = ','.join(pmb.lit(r['k']) for r in rs)
    got = pmb.query(ref, f"""select ci.content_key k, c.topic_code t, c.assignment_status s, c.is_primary p, c.source src
      from app.content_item_cells c join app.content_items ci on ci.id=c.content_item_id
      join app.content_item_versions v on v.id=c.content_item_version_id and v.status='published'
      where c.source like '%{RUN}%' and c.superseded_by is null and ci.content_key in ({keys}) order by ci.content_key""")
    h = hashlib.md5('\n'.join(f"{g['k']}:{g['t']}" for g in got).encode()).hexdigest()
    ok = h == plan_hash(rs) and len(got) == len(rs) and all(g['s'] == 'validated' and g['p'] for g in got)
    print(f"verify: {len(got)} cells on published versions, hash {h}, plan {plan_hash(rs)} -> {'MATCH' if ok else 'MISMATCH'}")
    return ok

def main():
    a = argparse.ArgumentParser(); a.add_argument('cmd', choices=['plan', 'rehearse', 'commit', 'verify'])
    a.add_argument('--env', choices=['dev', 'prod'], default='prod'); a.add_argument('--approval', default='')
    a.add_argument('--confirm-production', action='store_true'); a.add_argument('--input', default='write_candidates.json')
    a = a.parse_args(); global INPUT; INPUT = a.input
    rs = rows(); ref = pmb.ENVS[a.env]
    if a.cmd == 'plan':
        print(f"{len(rs)} rows, plan hash {plan_hash(rs)}"); return
    if a.cmd == 'verify':
        sys.exit(0 if verify(ref, rs) else 1)
    if a.cmd == 'rehearse':
        msg = pmb.query(ref, sql(rs, a.approval or 'REHEARSAL', 'rehearse'), expect_error=True)
        if 'REHEARSAL OK' not in msg: sys.exit(f'rehearsal FAILED: {msg[:2000]}')
        print(msg[msg.index('REHEARSAL OK'):].splitlines()[0], '(rolled back)'); return
    if a.env == 'prod' and not (a.approval.startswith('APPROVAL-') and a.confirm_production):
        sys.exit('Production commit needs --approval APPROVAL-NNNN (recorded first) and --confirm-production')
    msg = pmb.query(ref, sql(rs, a.approval, 'rehearse'), expect_error=True)
    if 'REHEARSAL OK' not in msg: sys.exit(f'pre-commit rehearsal FAILED, nothing committed: {msg[:2000]}')
    pmb.query(ref, sql(rs, a.approval, 'commit'))
    sys.exit(0 if verify(ref, rs) else 1)

if __name__ == '__main__':
    main()
