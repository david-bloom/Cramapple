#!/usr/bin/env python3
"""Gateway tokens and dollars by stage, from the jsonl result logs under out_<stage>*/ (usage.inputTokens / outputTokens / inputTokenDetails.cacheReadTokens).
List price from pricing.json (per token; no tier/peak surcharges: DeepSeek peak windows are 2x, Gemini 2.5 long-context tier ignored, so treat as a floor).
usage: python3 cost.py   -> prints a table and writes COST_BY_STAGE.json"""
import json, glob, collections, os, re
PR = json.load(open('pricing.json'))
def price(model):
    p = PR.get(model) or {}
    return float(p.get('input', 0)), float(p.get('output', 0)), float(p.get('input_cache_read', p.get('input', 0)))
stages = collections.defaultdict(lambda: collections.defaultdict(lambda: [0, 0, 0, 0.0]))  # stage -> model -> [calls, in, out, $]
for f in glob.glob('out_*/**/*.jsonl', recursive=True):
    stage = re.sub(r'_(google|openai|anthropic|deepseek)_.*$', '', f.split('/')[0])
    for l in open(f):
        try: r = json.loads(l)
        except Exception: continue
        u = r.get('usage') or {}; m = r.get('model') or (r.get('result') or {}).get('model')
        if not m or not u: continue
        i = u.get('inputTokens') or 0; o = u.get('outputTokens') or 0; c = (u.get('inputTokenDetails') or {}).get('cacheReadTokens') or u.get('cachedInputTokens') or 0
        pi, po, pc = price(m); cost = (i - c) * pi + c * pc + o * po
        s = stages[stage][m]; s[0] += 1; s[1] += i; s[2] += o; s[3] += cost
out = {}; tot = [0, 0, 0, 0.0]
for st in sorted(stages):
    row = {m.split('/')[1]: dict(calls=v[0], in_tok=v[1], out_tok=v[2], usd=round(v[3], 4)) for m, v in stages[st].items()}
    out[st] = row
    sc = sum(v[0] for v in stages[st].values()); si = sum(v[1] for v in stages[st].values()); so = sum(v[2] for v in stages[st].values()); sd = sum(v[3] for v in stages[st].values())
    print(f"{st:28s} calls {sc:5d}  in {si:>10,d}  out {so:>9,d}  ${sd:7.3f}"); tot = [tot[0] + sc, tot[1] + si, tot[2] + so, tot[3] + sd]
print(f"{'TOTAL':28s} calls {tot[0]:5d}  in {tot[1]:>10,d}  out {tot[2]:>9,d}  ${tot[3]:7.3f}")
json.dump(out, open('COST_BY_STAGE.json', 'w'), indent=1)
