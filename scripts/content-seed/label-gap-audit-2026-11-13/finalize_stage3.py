#!/usr/bin/env python3
"""Stage 3 finalize (no DB access): hold out items whose vote moves the unit away from the unit on record, split resolved decisions
into per-subject load files, write the cost summary. Inputs stage3/resolved.json, residue.json, cost_ledger.jsonl."""
import json, os, collections as C
H = os.path.dirname(os.path.abspath(__file__)); S = lambda f: os.path.join(H, 'stage3', f)
R = json.load(open(S('resolved.json'))); X = json.load(open(S('residue.json')))
keep = []
for o in R:
    if o['unit_before'] is not None and o['unit_before'] != o['primary_unit']:
        X.append(dict(o, reason='vote_moves_unit_away_from_recorded_unit')); continue
    keep.append(o)
json.dump(keep, open(S('resolved_final.json'), 'w'), indent=0); json.dump(X, open(S('residue_final.json'), 'w'), indent=0)
by = C.defaultdict(list)
for o in keep: by[o['subject']].append(o)
for sub, items in by.items(): json.dump(sorted(items, key=lambda o: o['content_key']), open(S(f'load_{sub}.json'), 'w'), indent=0)
L = [json.loads(l) for l in open(S('cost_ledger.jsonl'))]
cost = {'calls': len(L), 'failed_calls': sum(not x['ok'] for x in L), 'usd': round(sum(x['usd'] for x in L), 4),
        'by_model': {m: {'calls': sum(x['model'] == m for x in L), 'usd': round(sum(x['usd'] for x in L if x['model'] == m), 4), 'in': sum(x['in'] for x in L if x['model'] == m), 'out': sum(x['out'] for x in L if x['model'] == m)} for m in sorted({x['model'] for x in L})}}
json.dump(cost, open(S('cost_summary.json'), 'w'), indent=1)
print(json.dumps(cost)); print(len(keep), 'load rows;', len(X), 'residue;', C.Counter(x['reason'] for x in X))
print({s: len(v) for s, v in by.items()})
print('cells', C.Counter(o['cell_action'] for o in keep), 'labels', C.Counter(o['label_action'] for o in keep))
