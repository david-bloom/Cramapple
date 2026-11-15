#!/usr/bin/env python3
"""Build load files (stage11/load/load_<subject>.json) for the unit-less set from resolved_unitless.json (>= 5 of 6 votes) plus rulings_unitless.py. Reads Production state (read-only)."""
import importlib.util, json, os, collections as C, glob
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; exec(open(os.path.join(HERE, 'rulings_unitless.py')).read())
res = {r['content_key']: r for r in json.load(open(os.path.join(HERE, 'resolved_unitless.json')))}; rej = {r['content_key']: r for r in json.load(open(os.path.join(HERE, 'residue_unitless.json')))}
tax = {}
for f in glob.glob(os.path.join(HERE, 'stage8', 'taxonomy_*.json')): tax[os.path.basename(f)[9:-5]] = {t['code'] for t in json.load(open(f))['topics']}
rows = []
for k, r in res.items(): rows.append(dict(r, method='model_vote_6', basis_note='Six-vote topic probe: topic named by >= 5 of the votes cast, required units named by >= 4 (units-1-5/6+ unit-less set, 2026-11-14).'))
for k, (t, ru, basis) in RULINGS.items():
    r = rej[k]; assert t in tax[r['subject']], (k, t); pu = int(t.split('.')[0]); ru = sorted(set(ru) | {pu}); assert pu in ru
    rows.append(dict(r, topic=t, primary_unit=pu, required_units=ru, max_required_unit=max(ru), method='ced_ruling', basis_note=basis))
assert len(rows) == 75 and len({r['content_key'] for r in rows}) == 75
ks = ','.join(pmb.lit(r['content_key']) for r in rows)
st = pmb.query(REF, f"""select ci.content_key k, ci.id::text iid, ci.status ist, v.id::text vid, v.status vs, v.version_num vn,
  coalesce((select jsonb_agg(jsonb_build_object('id',c.content_item_cell_id::text,'t',c.topic_code,'st',c.assignment_status,'s',c.skill_code,'p',c.is_primary)) from app.content_item_cells c where c.content_item_version_id=v.id and c.superseded_by is null and c.is_primary),'[]'::jsonb) cells,
  coalesce((select jsonb_agg(jsonb_build_object('id',l.content_taxonomy_label_id::text,'lv',l.label_version,'st',l.label_status,'sup',l.superseded_by is not null,'reason',l.source_payload->>'reason') order by l.label_version) from app.content_taxonomy_labels l where l.content_item_id=ci.id and l.label_scope='serving'),'[]'::jsonb) labels
  from app.content_items ci join lateral (select * from app.content_item_versions x where x.content_item_id=ci.id order by version_num desc limit 1) v on true where ci.content_key in ({ks})""")
S = {s['k']: s for s in st}; out = C.defaultdict(list); flags = []
for r in rows:
    s = S[r['content_key']]; assert s['ist'] == 'published' and s['vs'] == 'published' and s['vid'] == r['vid'], (r['content_key'], s['vid'], r['vid'])
    cells = [c for c in s['cells'] if c['s'] is None]; act = [l for l in s['labels'] if not l['sup']]
    assert not any(l['st'] == 'validated' for l in act), ('active validated label', r['content_key'])
    if not cells: ca, cid = 'insert', None
    elif len(cells) == 1 and cells[0]['st'] in ('provisional_model', 'authored'):
        c = cells[0]; cid = c['id']
        if c['t'] == r['topic']: ca = 'promote_in_place'
        else: ca = 'replace_nonvalidated'; flags.append((r['content_key'], 'existing', c['st'], c['t'], 'new', r['topic']))
    else: raise SystemExit(('unexpected cells', r['content_key'], cells))
    hold = next((l['reason'] or l['st'] for l in reversed(act)), None)
    row = dict(content_key=r['content_key'], subject=r['subject'], item_id=s['iid'], vid=r['vid'], item_type=r['item_type'], kind='seed', topic=r['topic'], primary_unit=r['primary_unit'], required_units=r['required_units'], max_required_unit=r['max_required_unit'],
               method=r['method'], topic_votes=r['topic_votes'], unit_votes=r['unit_votes'], cell_action=ca, cell_id=cid, label_action='insert_validated', label_version=max([l['lv'] for l in s['labels']] or [0]) + 1,
               supersedes=[l['id'] for l in act], prior_label_status=','.join(l['st'] for l in act), hold_reason=hold, basis_note=r['basis_note'])
    out[r['subject']].append(row)
os.makedirs(os.path.join(HERE, 'stage11', 'load'), exist_ok=True)
for sub, rs in out.items(): json.dump(rs, open(os.path.join(HERE, 'stage11', 'load', f'load_{sub}.json'), 'w'), indent=1)
print({s: len(v) for s, v in out.items()}); print(C.Counter(r['cell_action'] for v in out.values() for r in v), 'method', C.Counter(r['method'] for v in out.values() for r in v))
for f in flags: print('FLAG', f)
