#!/usr/bin/env python3
"""Stage 3 step 3 (read-only on Production): turn votes + deterministic provenance into per-item label decisions and per-subject load files.
Rules (Stage 2 plan, approved): topic accepted at >=5 of 6 votes (both families necessarily present); required units = units named by >=4 of 6;
never change a validated cell/label; Calc AB / Statistics non-validated (provisional/authored) primary cells are promoted in place only when the vote agrees;
held labels: held for rubric_preflight_failure / ab_bc_only_content / other / exam-scoring stay held; model_call_failure / empty_required_units / model_unit_disagreement are released only on a >=5/6 vote.
  python3 -I resolve.py
"""
import importlib.util, json, os, collections, glob, re
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py'))
pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']
d = json.load(open(os.path.join(HERE, '../../../docs/qa/LABEL_GAP_AUDIT_UNITS_6PLUS_2026_11_13_ITEMS.json')))
G = [i for i in d['items'] if i['f']['vstatus'] == 'published' and i['in_scope'] and (not i['f']['topic_validated'] or i['f']['serving'] != 'ok') ]
tax = json.load(open(os.path.join(HERE, 'raw', '_taxonomy_topics.json')))
tunit = {(t['subject_key'], t['topic_code']): t['unit_number'] for t in tax}
tsv = {t['subject_key']: t['tsv'] for t in tax}
votes = collections.defaultdict(list)
for l in open(os.path.join(HERE, 'stage3/votes.jsonl')):
    v = json.loads(l)
    if v['ok']: votes[v['key']].append(v)
# existing state from Production
vids = ','.join("'%s'" % i['vid'] for i in G)
cells = {r['vid']: r for r in pmb.query(REF, f"select c.content_item_version_id::text vid, c.content_item_cell_id::text cid, c.topic_code t, c.assignment_status st from app.content_item_cells c where c.content_item_version_id in ({vids}) and c.is_primary and c.superseded_by is null")}
labs = collections.defaultdict(list)
for r in pmb.query(REF, f"""select l.content_item_id::text iid, l.content_taxonomy_label_id::text lid, l.label_version lv, l.label_status st,
   coalesce(l.source_payload->>'hold_reason', l.source_payload->>'reason', l.source_payload->>'held_reason', left(l.source_payload::text,80)) why
   from app.content_taxonomy_labels l where l.label_scope='serving' and l.superseded_by is null and l.content_item_id in (select content_item_id from app.content_item_versions where id in ({vids})) order by l.label_version"""):
    labs[r['iid']].append(r)
maxlv = {r['iid']: r['m'] for r in pmb.query(REF, f"select content_item_id::text iid, max(label_version) m from app.content_taxonomy_labels where label_scope='serving' and content_item_id in (select content_item_id from app.content_item_versions where id in ({vids})) group by 1")}
BLOCK = ('rubric_preflight_failure', 'ab_bc_only_content', 'exam-scoring')
out, residue = [], []
def decide(i):
    f = i['f']; sub = i['subject']; key = i['content_key']; vs = votes.get(key, [])
    base = {'content_key': key, 'subject': sub, 'item_id': i['item_id'], 'vid': i['vid'], 'item_type': i['item_type'], 'kind': f['kind'], 'unit_before': f['unit']}
    if len(vs) < 5: return None, dict(base, reason='no_majority_after_cheap_votes' if len(vs) >= 4 else 'votes_missing', n_votes=len(vs), tally=dict(collections.Counter(v['label']['primary_topic_code'] for v in vs)))
    tally = collections.Counter(v['label']['primary_topic_code'] for v in vs if (sub, v['label']['primary_topic_code']) in tunit)
    top, n = (tally.most_common(1) or [(None, 0)])[0]
    if n < 5: return None, dict(base, reason='topic_below_5_of_6', tally=dict(collections.Counter(v['label']['primary_topic_code'] for v in vs)))
    uc = collections.Counter(u for v in vs for u in set(v['label']['required_units']))
    ru = sorted(u for u, c in uc.items() if c >= 4); pu = tunit[(sub, top)]
    if not ru or pu not in ru: return None, dict(base, reason='required_units_unusable', topic=top, units=dict(uc))
    return dict(base, topic=top, primary_unit=pu, required_units=ru, max_required_unit=max(ru), method='model_vote_6', topic_votes=dict(tally), unit_votes={str(k): v for k, v in uc.items()}), None
for i in G:
    if i['f']['kind'] == 'variant': continue
    f = i['f']; dec, res = decide(i)
    if res: residue.append(res); continue
    c = cells.get(i['vid']); ls = labs.get(i['item_id'], [])
    # topic cell action
    if f['topic_validated']:
        if c and c['t'] != dec['topic']: residue.append(dict(dec, reason='vote_disagrees_with_validated_cell', cell_topic=c['t'])); continue
        dec['cell_action'] = None
    elif c is None: dec['cell_action'] = 'insert'
    elif c['t'] == dec['topic']: dec['cell_action'] = 'promote_in_place'; dec['cell_id'] = c['cid']; dec['cell_status_before'] = c['st']
    else: residue.append(dict(dec, reason='vote_disagrees_with_existing_%s_cell' % c['st'], cell_topic=c['t'])); continue
    # serving label action
    if f['serving'] == 'ok': dec['label_action'] = None
    else:
        held = [l for l in ls if l['st'] == 'held']
        if held and any(b in (held[-1]['why'] or '') for b in BLOCK) or (held and held[-1]['why'] and not any(k in held[-1]['why'] for k in ('model_unit_disagreement', 'model_call_failure', 'empty_required_units'))):
            residue.append(dict(dec, reason='held_stays_held', hold_reason=held[-1]['why'])); continue
        dec['label_action'] = 'insert_validated'; dec['label_version'] = maxlv.get(i['item_id'], 0) + 1
        dec['supersedes'] = [l['lid'] for l in ls]; dec['prior_label_status'] = ls[-1]['st'] if ls else 'none'
        dec['hold_reason'] = held[-1]['why'] if held else None
    out.append(dec)
# variants inherit from their seed's decision
seedmap = {o['content_key']: o for o in out}
for i in [x for x in G if x['f']['kind'] == 'variant']:
    import re as _re
    sk = _re.sub(r'-sv-', '-', _re.sub(r'-v\d+$', '', i['content_key']))
    sd = seedmap.get(sk)
    if not sd: residue.append({'content_key': i['content_key'], 'subject': i['subject'], 'reason': 'seed_not_resolved', 'seed': sk}); continue
    f = i['f']; dec = dict(sd, content_key=i['content_key'], item_id=i['item_id'], vid=i['vid'], kind='variant', method='inherit_from_seed', unit_before=f['unit'])
    c = cells.get(i['vid']); ls = labs.get(i['item_id'], [])
    dec['cell_action'] = None if f['topic_validated'] else ('insert' if c is None else ('promote_in_place' if c['t'] == dec['topic'] else 'CONFLICT'))
    if c: dec['cell_id'] = c['cid']; dec['cell_status_before'] = c['st']
    if dec['cell_action'] == 'CONFLICT': residue.append(dict(dec, reason='vote_disagrees_with_existing_cell', cell_topic=c['t'])); continue
    if f['serving'] == 'ok': dec['label_action'] = None
    else: dec['label_action'] = 'insert_validated'; dec['label_version'] = maxlv.get(i['item_id'], 0) + 1; dec['supersedes'] = [l['lid'] for l in ls]; dec['prior_label_status'] = ls[-1]['st'] if ls else 'none'; dec['hold_reason'] = None
    out.append(dec)
# owner-call guard: a new cell must not contradict an existing VALIDATED serving label's unit (item is served today)
_keep = []
for o in out:
    if o['label_action'] is None and o['unit_before'] is not None and o['primary_unit'] != o['unit_before']:
        residue.append(dict(o, reason='vote_unit_differs_from_validated_label_unit_owner_call'))
    else: _keep.append(o)
out = _keep
json.dump(out, open(os.path.join(HERE, 'stage3/resolved.json'), 'w'), indent=0)
json.dump(residue, open(os.path.join(HERE, 'stage3/residue.json'), 'w'), indent=0)
print(len(G), 'items;', len(out), 'resolved;', len(residue), 'residue')
print(collections.Counter(r['reason'] for r in residue))
print('cell actions', collections.Counter(o['cell_action'] for o in out), 'label actions', collections.Counter(o['label_action'] for o in out))
