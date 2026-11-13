#!/usr/bin/env python3 -I
"""Phase 2 load files for the 16 repaired FRQs: topic/units from the existing blind six-vote probe (prompt text is unchanged, so the votes still apply;
stage3_rerun supersedes stage3 where present). Read-only on Production (current version ids, label versions). Writes stage6/r3/load_<subject>.json."""
import importlib.util, json, os, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.join(HERE, '..')
spec = importlib.util.spec_from_file_location('pmb', os.path.join(ROOT, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; assert REF == 'pcntajvbdfqhbeewmdry'
SUBJ = {'apcalcab':'ap_calculus_ab','apcalcbc':'ap_calculus_bc','apphy1':'ap_physics_1','apphy2':'ap_physics_2','apphycem':'ap_physics_c_em','apphycm':'ap_physics_c_mechanics','apprecalc':'ap_precalculus'}
plan = json.load(open(os.path.join(HERE, os.environ.get('PLAN_FILE', 'plan.json')))); keys = [p['content_key'] for p in plan]
def load(f):
    d = collections.defaultdict(list)
    if os.path.exists(f):
        for l in open(f):
            v = json.loads(l)
            if v['ok']: d[v['key']].append(v)
    return d
a = load(os.path.join(ROOT, 'stage3/votes.jsonl')); b = load(os.path.join(ROOT, os.environ.get('VOTES', 'stage3_rerun/votes.jsonl')))
tax = json.load(open(os.path.join(ROOT, 'raw/_taxonomy_topics.json'))); tunit = {(t['subject_key'], t['topic_code']): t['unit_number'] for t in tax}
inl = ','.join(pmb.lit(k) for k in keys)
st = pmb.query(REF, f"""select ci.content_key k, ci.id::text iid, v.id::text vid, v.status vs,
  (select coalesce(max(label_version),0) from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving') maxlv,
  (select coalesce(jsonb_agg(l.content_taxonomy_label_id::text),'[]'::jsonb) from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null) active_labels,
  (select string_agg(distinct l.label_status,',') from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null) active_status
  from app.content_items ci join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by version_num desc limit 1) v on true where ci.content_key in ({inl})""")
S = {r['k']: r for r in st}; out = collections.defaultdict(list)
for k in keys:
    sub = SUBJ[k.split('-')[0]]; vs = b.get(k) or a.get(k); assert vs, k; n = len(vs)
    t = collections.Counter(v['label']['primary_topic_code'] for v in vs); topic, tv = t.most_common(1)[0]; assert tv >= 5 and tv / max(n, 6) >= 5 / 6 - 1e-9 or tv >= 5, (k, t)
    uc = collections.Counter(u for v in vs for u in set(v['label']['required_units'])); ru = sorted(u for u, c in uc.items() if c >= 4)
    pu = tunit[(sub, topic)]; assert pu in ru and max(ru) <= 99, (k, pu, ru)
    s = S[k]; assert s['vs'] == 'published' and s['active_status'] in ('held', None, 'stale', 'held,stale'), (k, s)
    out[sub].append({'content_key': k, 'subject': sub, 'item_id': s['iid'], 'vid': s['vid'], 'item_type': 'frq', 'kind': 'seed', 'unit_before': pu, 'topic': topic, 'primary_unit': pu,
      'required_units': ru, 'max_required_unit': max(ru), 'method': 'six_vote_probe_rubric_repair', 'basis_note': 'Blind six-vote probe on the unchanged prompt text (topic >= 5 of 6; units named by >= 4); rubric repaired under APPROVAL-0269 so the held rubric_preflight_failure no longer applies',
      'topic_votes': dict(t), 'unit_votes': {str(u): c for u, c in uc.items()}, 'cell_action': 'insert', 'cell_id': None, 'label_action': 'insert_validated', 'label_version': s['maxlv'] + 1,
      'supersedes': s['active_labels'], 'prior_label_status': s['active_status'], 'hold_reason': 'rubric_preflight_failure'})
for sub, rs in out.items(): json.dump(rs, open(os.path.join(HERE, os.environ.get('OUT_DIR', 'r3'), f'load_{sub}.json'), 'w'), indent=1); print(sub, len(rs), [(r['content_key'], r['topic'], r['required_units']) for r in rs])
