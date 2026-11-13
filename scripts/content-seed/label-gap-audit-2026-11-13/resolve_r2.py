#!/usr/bin/env python3
"""Round 2: apply the owner-approved CED-text rulings (83 residue items reviewed) -> stage3/r2/load_<subject>.json. Read-only on Production."""
import importlib.util, json, os, collections as C, sys
HERE = os.path.dirname(os.path.abspath(__file__)); S = lambda f: os.path.join(HERE, 'stage3', f)
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']
sys.path.insert(0, HERE); import rulings_ap_calculus_ab as AB, rulings_other as OT
RUL = dict(AB.R); RUL.update(OT.R)
tax = json.load(open(os.path.join(HERE, 'raw', '_taxonomy_topics.json'))); tunit = {(t['subject_key'], t['topic_code']): t['unit_number'] for t in tax}
gap = {i['content_key']: i for i in json.load(open(os.path.join(HERE, '../../../docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_2026_11_13_ITEMS.json')))['items']}
items = [d for f in os.listdir(S('review')) for d in json.load(open(S('review/' + f)))]
votes = C.defaultdict(list)
for fn in (S('votes.jsonl'), os.path.join(HERE, 'stage3_rerun/votes.jsonl')):
    seen = set()
    for l in open(fn):
        v = json.loads(l)
        if v['ok']:
            if fn.endswith('stage3_rerun/votes.jsonl'):
                if v['key'] not in seen: votes[v['key']] = []; seen.add(v['key'])  # parts-informed votes replace the title-only votes for those keys
            votes[v['key']].append(v['label']) if (fn.endswith('stage3_rerun/votes.jsonl') or v['key'] not in seen) else None
vids = ','.join("'%s'" % d['vid'] for d in items)
cells = {r['vid']: r for r in pmb.query(REF, f"select content_item_version_id::text vid, content_item_cell_id::text cid, topic_code t, skill_code s, assignment_status st from app.content_item_cells where content_item_version_id in ({vids}) and is_primary and superseded_by is null")}
labs = C.defaultdict(list)
for r in pmb.query(REF, f"select l.content_item_id::text iid, l.content_taxonomy_label_id::text lid, l.label_version lv, l.label_status st, coalesce(l.source_payload->>'hold_reason', left(l.source_payload::text,60)) why from app.content_taxonomy_labels l where l.label_scope='serving' and l.superseded_by is null and l.content_item_id in (select content_item_id from app.content_item_versions where id in ({vids})) order by l.label_version"): labs[r['iid']].append(r)
maxlv = {r['iid']: r['m'] for r in pmb.query(REF, f"select content_item_id::text iid, max(label_version) m from app.content_taxonomy_labels where label_scope='serving' and content_item_id in (select content_item_id from app.content_item_versions where id in ({vids})) group by 1")}
out, left, log = [], [], []
for d in items:
    k, sub = d['key'], d['subject']; r = RUL.get(k) or (OT.stats(k) if sub == 'ap_statistics' else None)
    if k in OT.SKIP: left.append(dict(d, why=OT.SKIP[k])); continue
    if r is None: left.append(dict(d, why='NO RULING WRITTEN')); continue
    topic, reason = r[0], r[1]; ru_override = r[2] if len(r) > 2 else None
    c = cells.get(d['vid']); f = gap[k]['f']; pu = tunit[(sub, topic)]
    uc = C.Counter(u for v in votes.get(k, []) for u in set(v['required_units'])); ru = sorted(u for u, n in uc.items() if n >= 4)
    if ru_override: ru = ru_override
    if pu not in ru: ru = sorted(set(ru) | {pu})
    row = {'content_key': k, 'subject': sub, 'item_id': d['item_id'], 'vid': d['vid'], 'item_type': d['type'], 'kind': d['kind'], 'unit_before': d['unit_before'], 'topic': topic, 'primary_unit': pu,
           'required_units': ru, 'max_required_unit': max(ru), 'method': 'ced_text_ruling', 'basis_note': 'CED-text ruling by Claude (owner-approved 2026-11-13): ' + reason, 'topic_votes': dict(C.Counter(v['primary_topic_code'] for v in votes.get(k, [])))}
    if f['topic_validated']:
        assert c and c['t'] == topic, (k, c, topic); row['cell_action'] = None
    elif c is None: row['cell_action'] = 'insert'
    elif c['t'] == topic and c['s'] is None and c['st'] in ('provisional_model', 'authored'): row['cell_action'] = 'promote_in_place'; row['cell_id'] = c['cid']
    elif c['t'] == topic: row['cell_action'] = 'keep_authored'; row['cell_id'] = c['cid']
    else: row['cell_action'] = 'replace_nonvalidated'; row['cell_id'] = c['cid']; row['replaces'] = f"{c['t']} x {c['s']} [{c['st']}]"
    if f['serving'] == 'ok': row['label_action'] = None
    else:
        ls = labs.get(d['item_id'], []); held = [l for l in ls if l['st'] == 'held']
        row.update(label_action='insert_validated', label_version=maxlv.get(d['item_id'], 0) + 1, supersedes=[l['lid'] for l in ls], prior_label_status=ls[-1]['st'] if ls else 'none', hold_reason=(None if not held else ('other (released by owner approval 2026-11-13)' if d['reason'] == 'held_stays_held' else 'model_unit_disagreement (released after CED-text ruling)')))
    out.append(row)
by = C.defaultdict(list)
for r in out: by[r['subject']].append(r)
os.makedirs(S('r2'), exist_ok=True)
for s, rs in by.items(): json.dump(sorted(rs, key=lambda r: r['content_key']), open(S(f'r2/load_{s}.json'), 'w'), indent=0)
json.dump(left, open(S('r2/left_unresolved.json'), 'w'), indent=0)
print(len(items), 'reviewed;', len(out), 'ruled;', len(left), 'left:', [(l['key'], l['why']) for l in left])
print({s: len(v) for s, v in by.items()}); print('cells', C.Counter(o['cell_action'] for o in out), 'labels', C.Counter(o['label_action'] for o in out))
print('held released', sum(1 for o in out if o.get('hold_reason')))
