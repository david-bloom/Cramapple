#!/usr/bin/env python3
"""Dollar and wall-clock metering for pipeline batches: tokens x the Gateway's published per-model prices.
usage: meter_cost.py <batch_dir> [<batch_dir> ...]   (reads <dir>/calls.jsonl; prices fetched from /v1/models)
Estimate, not a bill: base list prices, no peak/regional/tier surcharges (DeepSeek peak hours can double its share)."""
import json, sys, urllib.request, collections, datetime

def prices():
    d = json.load(urllib.request.urlopen('https://ai-gateway.vercel.sh/v1/models', timeout=60))['data']
    return {x['id']: x['pricing'] for x in d if x.get('pricing')}

def stage_of(tag):
    t = tag.split(' ')
    if ' help ' in tag: return 'gate_help' if ' gate ' in tag else 'measure_help'
    if ' check ' in tag: return 'gate_check' if ' gate ' in tag else 'measure_check'
    if tag.endswith(' author') : return 'author'
    if tag.endswith(' author2'): return 'author2'
    for k in ('solve', 'audit', 'veto', 'label'):
        if f' {k}' in tag or tag.endswith(k) or '__' + k in tag: return k
    return 'other'

def cost(u, p):
    inp = u.get('inputTokens', 0) or 0
    det = u.get('inputTokenDetails') or {}
    cr = det.get('cacheReadTokens', u.get('cachedInputTokens', 0)) or 0
    cw = det.get('cacheWriteTokens', 0) or 0
    out = u.get('outputTokens', 0) or 0
    nc = max(inp - cr - cw, 0)
    return (nc * float(p['input']) + cr * float(p.get('input_cache_read', p['input']))
            + cw * float(p.get('input_cache_write', p['input'])) + out * float(p['output']))

def main(dirs):
    P = prices(); res = {}
    for d in dirs:
        by = collections.defaultdict(float); calls = 0; total = 0.0; times = []; ms = 0
        for l in open(f'{d}/calls.jsonl'):
            try: r = json.loads(l)
            except Exception: continue
            p = P.get(r['model'])
            if not p: continue
            c = cost(r.get('usage') or {}, p); by[stage_of(r['tag'])] += c; total += c; calls += 1
            times.append(datetime.datetime.fromisoformat(r['at'].replace('Z', '+00:00'))); ms += r.get('ms') or 0
        wall = (max(times) - min(times)).total_seconds() if times else 0
        res[d] = dict(calls=calls, usd=round(total, 3), wall_minutes=round(wall / 60, 1), summed_call_minutes=round(ms / 60000, 1), by_stage={k: round(v, 3) for k, v in sorted(by.items())})
    print(json.dumps(res, indent=1))

if __name__ == '__main__': main(sys.argv[1:])
