"""Cache-aware cost for a pipeline batch: uncached input, cache reads, cache writes and output are priced separately.
usage: python3 cost.py <calls.jsonl> <pricing.json> [<accepted.json>]"""
import json, sys, collections
calls, pricing = sys.argv[1], sys.argv[2]
M = {m["id"]: m.get("pricing", {}) for m in json.load(open(pricing))["data"]}
f = lambda p, k: float(p.get(k) or 0)
by_model = collections.defaultdict(lambda: [0.0, 0, 0, 0]); by_stage = collections.defaultdict(float); ctrl = 0.0
for l in open(calls):
    r = json.loads(l)
    if not r["ok"]: continue
    u = r.get("usage") or {}; d = u.get("inputTokenDetails") or {}; p = M.get(r["model"], {})
    tin = u.get("inputTokens") or 0; read = d.get("cacheReadTokens") or 0; write = d.get("cacheWriteTokens") or 0
    plain = d.get("noCacheTokens"); plain = (tin - read - write) if plain is None else plain
    c = plain * f(p, "input") + read * f(p, "input_cache_read") + write * f(p, "input_cache_write") + (u.get("outputTokens") or 0) * f(p, "output")
    if r["tag"].startswith("ctrl"): ctrl += c; continue
    m = by_model[r["model"]]; m[0] += c; m[1] += tin; m[2] += read; m[3] += 1
    t = r["tag"]; by_stage["author" if t.endswith("author") else next((s for s in ("solve", "audit", "veto") if f" {s}" in t), "other")] += c
tot = sum(v[0] for v in by_model.values())
out = {"usd_topics": round(tot, 2), "usd_controls": round(ctrl, 2),
       "by_model": {k: {"usd": round(v[0], 2), "calls": v[3], "cache_hit_pct": round(100 * v[2] / max(v[1], 1))} for k, v in by_model.items()},
       "by_stage": {k: round(v, 2) for k, v in by_stage.items()}}
if len(sys.argv) > 3:
    n = len(json.load(open(sys.argv[3]))); out["accepted"] = n; out["usd_per_accepted"] = round(tot / n, 3)
print(json.dumps(out, indent=1))
