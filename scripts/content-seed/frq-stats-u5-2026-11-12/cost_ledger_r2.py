#!/usr/bin/env python3
"""r2 (difficulty rewrite) cost ledger: r2/calls.jsonl + r2/cost/answer_grade_calls.jsonl, priced with cost/price_snapshot.json."""
import json, csv, os, re, collections
H = os.path.dirname(os.path.abspath(__file__)); R = os.path.join(H, 'r2'); P = json.load(open(os.path.join(H, 'cost', 'price_snapshot.json')))['usd_per_token']
rows = []
for src, path in (('calls', os.path.join(R, 'calls.jsonl')), ('answer_grade', os.path.join(R, 'cost', 'answer_grade_calls.jsonl'))):
    if not os.path.exists(path): continue
    for l in open(path):
        r = json.loads(l); u = r.get('usage') or {}; p = P[r['model']]
        inp = u.get('inputTokens', 0); cr = (u.get('inputTokenDetails') or {}).get('cacheReadTokens', 0) or u.get('cachedInputTokens', 0) or 0; out = u.get('outputTokens', 0)
        usd = (inp - cr) * float(p['input']) + cr * float(p.get('cachedInputTokens', p['input'])) + out * float(p['output'])
        tag = r['tag']; m = re.match(r'(?:variant:)?(ap_statistics__(\d\.\d+)__(1|v1))', tag)
        topic = m.group(2) if m else '?'; kind = 'variant' if (tag.startswith('variant:') or (m and m.group(3) == 'v1')) else 'seed'
        stage = 'model_answer_grade' if src == 'answer_grade' else ('variant_diff_check' + (':resample' if 'resample' in tag else '') if tag.startswith('variant:') else tag.split(':')[-1])
        rows.append(dict(source=src, at=r['at'], tag=tag, item=f'{kind}:{topic}', kind=kind, topic=topic, unit=topic.split('.')[0], stage=stage, model=r['model'], ok=r['ok'], input_tokens=inp, cached_read_tokens=cr, output_tokens=out, usd=round(usd, 6)))
os.makedirs(os.path.join(R, 'cost'), exist_ok=True)
with open(os.path.join(R, 'cost', 'ledger.csv'), 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
agg = collections.defaultdict(float); n = collections.Counter(); unit = collections.defaultdict(lambda: collections.defaultdict(float))
for r in rows: agg[r['item']] += r['usd']; n[r['item']] += 1; unit[r['unit']][r['kind']] += r['usd']
S = dict(calls=len(rows), computed_usd=round(sum(r['usd'] for r in rows), 4), per_item_usd={k: round(v, 4) for k, v in sorted(agg.items())},
         per_unit_usd={u: {k: round(v, 4) for k, v in d.items()} for u, d in sorted(unit.items())},
         seed_total=round(sum(v for k, v in agg.items() if k.startswith('seed:')), 4), variant_total=round(sum(v for k, v in agg.items() if k.startswith('variant:')), 4),
         n_seed_items=sum(1 for k in agg if k.startswith('seed:')), n_variant_items=sum(1 for k in agg if k.startswith('variant:')))
S['seed_avg'] = round(S['seed_total'] / S['n_seed_items'], 4); S['variant_avg'] = round(S['variant_total'] / max(1, S['n_variant_items']), 4)
json.dump(S, open(os.path.join(R, 'cost', 'cost_summary.json'), 'w'), indent=1); print(json.dumps(S, indent=1))
