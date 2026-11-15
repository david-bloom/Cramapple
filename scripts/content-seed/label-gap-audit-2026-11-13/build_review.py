import importlib.util, json, os, collections as C
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; S = lambda f: os.path.join(HERE, 'stage3', f)
X = json.load(open(S('residue_final.json')))
tax = {(t['subject_key'], t['topic_code']): t['topic_title'] for t in json.load(open(os.path.join(HERE, 'raw', '_taxonomy_topics.json')))}
votes = C.defaultdict(list)
for l in open(S('votes.jsonl')):
    v = json.loads(l)
    if v['ok']: votes[v['key']].append(v['label']['primary_topic_code'])
pk = {}
for f in os.listdir(S('')):
    if f.startswith('packets_'):
        for p in json.load(open(S(f))): pk[p['content_key']] = p
tgt = [x for x in X if x['reason'] in ('no_majority_after_cheap_votes', 'topic_below_5_of_6', 'vote_disagrees_with_existing_authored_cell', 'vote_disagrees_with_existing_provisional_model_cell') or (x['reason'] == 'held_stays_held' and x['hold_reason'] == 'other')]
vids = ','.join("'%s'" % x['vid'] for x in tgt)
cells = {r['vid']: r for r in pmb.query(REF, f"select content_item_version_id::text vid, topic_code t, skill_code s, assignment_status st from app.content_item_cells where content_item_version_id in ({vids}) and is_primary and superseded_by is null")}
held = {r['iid']: r['why'] for r in pmb.query(REF, f"select l.content_item_id::text iid, left(l.source_payload::text,400) why from app.content_taxonomy_labels l where l.label_scope='serving' and l.label_status='held' and l.superseded_by is null and l.content_item_id in (select content_item_id from app.content_item_versions where id in ({vids}))")}
out = C.defaultdict(list)
for x in tgt:
    k = x['content_key']; sub = x['subject']; t = C.Counter(votes[k]); c = cells.get(x['vid'])
    d = {'key': k, 'subject': sub, 'reason': x['reason'], 'type': x['item_type'], 'kind': x['kind'], 'unit_before': x['unit_before'], 'item_id': x['item_id'], 'vid': x['vid'],
         'tally': {f"{a} {tax.get((sub, a), '?')}": n for a, n in t.most_common()}, 'cell': (f"{c['t']} x {c['s']} [{c['st']}] {tax.get((sub, c['t']), '')}" if c else None), 'hold': held.get(x['item_id']) if x['reason'] == 'held_stays_held' else None,
         'text': pk[k]['body'][:1100] if k in pk else None}
    out[sub].append(d)
for sub, L in out.items(): json.dump(L, open(S(f'review/{sub}.json'), 'w'), indent=1)
print({s: len(l) for s, l in out.items()}, sum(len(l) for l in out.values()))
