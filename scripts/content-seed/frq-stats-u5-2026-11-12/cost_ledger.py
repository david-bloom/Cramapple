#!/usr/bin/env python3
"""Cost ledger for the Stats Unit 5 FRQ run. Reads every paid-call log, prices tokens with the gateway price snapshot,
attributes each call to an item, and writes cost/ledger.csv + cost/cost_summary.json. Measured vs estimated is explicit."""
import json, csv, os, re, collections
H = os.path.dirname(os.path.abspath(__file__)); C = os.path.join(H, 'cost')
P = json.load(open(os.path.join(C, 'price_snapshot.json')))['usd_per_token']
SRC = [('calls.jsonl', os.path.join(H, 'calls.jsonl')), ('variant_controls', os.path.join(C, 'variant_controls_calls.jsonl')),
       ('answer_grade', os.path.join(C, 'answer_grade_calls.jsonl'))]
rows = []
for src, path in SRC:
    for l in open(path):
        r = json.loads(l); u = r.get('usage') or {}; p = P[r['model']]
        inp = u.get('inputTokens', 0); cr = (u.get('inputTokenDetails') or {}).get('cacheReadTokens', 0) or u.get('cachedInputTokens', 0) or 0
        out = u.get('outputTokens', 0)
        usd = (inp - cr) * float(p['input']) + cr * float(p.get('cachedInputTokens', p['input'])) + out * float(p['output'])
        tag = r['tag']; m = re.match(r'(?:variant:)?(ap_statistics__(5\.\d)__(1|v1))', tag)
        topic = m.group(2) if m else '?'
        kind = 'variant' if (tag.startswith('variant:') or (m and m.group(3) == 'v1')) else 'seed'
        if src == 'variant_controls': kind, stage = 'tool_validation', 'variant_check_planted_defect_control'
        elif src == 'answer_grade': stage = 'model_answer_grade'
        elif tag.startswith('variant:'): stage = 'variant_diff_check' + (':resample' if 'resample' in tag else '')
        else: stage = tag.split(':')[-1] if not tag.endswith(':resample') else 'resample'
        rows.append(dict(source=src, at=r['at'], tag=tag, item=f'{kind}:{topic}', kind=kind, topic=topic, stage=stage, model=r['model'], ok=r['ok'],
                         input_tokens=inp, cached_read_tokens=cr, output_tokens=out, usd=round(usd, 6)))
with open(os.path.join(C, 'ledger.csv'), 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
agg = collections.defaultdict(float); n = collections.Counter()
for r in rows: agg[r['item']] += r['usd']; n[r['item']] += 1
tot = sum(r['usd'] for r in rows)
bal = [json.loads(l) for l in open(os.path.join(C, 'gateway_balance.jsonl'))]
measured = float(bal[0]['balance']) - float(bal[-1]['balance'])
seeds = {k: v for k, v in agg.items() if k.startswith('seed:')}; vars_ = {k: v for k, v in agg.items() if k.startswith('variant:')}
S = dict(calls=len(rows), computed_usd=round(tot, 4), measured_gateway_balance_delta_usd=round(measured, 4),
         per_item_usd={k: round(v, 4) for k, v in sorted(agg.items())}, calls_per_item=dict(n),
         seed_avg=round(sum(seeds.values()) / len(seeds), 4), variant_avg=round(sum(vars_.values()) / len(vars_), 4),
         seed_total=round(sum(seeds.values()), 4), variant_total=round(sum(vars_.values()), 4),
         tool_validation_total=round(sum(v for k, v in agg.items() if k.startswith('tool_validation')), 4),
         )
st = collections.defaultdict(float)
for r in rows: st[(r['kind'], r['stage'])] += r['usd']
S['by_kind_stage'] = {f'{k}|{s}': round(v, 4) for (k, s), v in sorted(st.items())}
json.dump(S, open(os.path.join(C, 'cost_summary.json'), 'w'), indent=1); print(json.dumps(S, indent=1))

# ---- in-session Claude authoring cost: ESTIMATE (Max plan = no per-token bill; figures are list-price equivalents,
# Sonnet 5.5 at $2/M input, $10/M output, $0.10/M cached read, $2.50/M cache write, from the gateway price list).
A = json.load(open(os.path.join(C, 'authoring_size_chars.json'))); TOK = 3.5  # chars per token for dense code/JSON/unicode
OUT = 10e-6
seed_chars = [v['seed_cfg'] + v['template_fn'] for v in A['per_topic_chars'].values()]
var_chars = [v['variant_cfg'] for v in A['per_topic_chars'].values()]
fixed = sum(A['fixed_chars'].values())
E = dict(method='output tokens = authored characters / 3.5 (measured by file size); context re-reads are NOT per-item measurable, see session_total_estimate',
         marginal_output_usd=dict(seed_avg=round(sum(seed_chars) / 5 / TOK * OUT, 4), variant_avg=round(sum(var_chars) / 5 / TOK * OUT, 4)),
         fixed_infrastructure_output_usd=round(fixed / TOK * OUT, 4), fixed_infrastructure_amortized_per_item=round(fixed / TOK * OUT / 10, 4),
         session_total_estimate_usd=dict(
             cache_write=round(283000 * 2.5e-6, 2), cache_reads=round(70 * 220000 * 0.1e-6, 2), output=round(45000 * OUT, 2),
             total=round(283000 * 2.5e-6 + 70 * 220000 * 0.1e-6 + 45000 * OUT, 2),
             assumptions='final context 283k tokens (get_usage), about 70 tool rounds at an average 220k cached context, about 45k output tokens; whole session including protocol reading, exploration, debugging and this report; plus or minus 40 percent'))
S['authoring_estimate'] = E
json.dump(S, open(os.path.join(C, 'cost_summary.json'), 'w'), indent=1); print(json.dumps(E, indent=1))
