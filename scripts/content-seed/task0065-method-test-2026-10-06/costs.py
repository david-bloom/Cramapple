"""Method test: speed and cost per arm from the logs (gateway prices fetched at run time, models.json)."""
import json, glob, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
M = {m["id"]: m.get("pricing", {}) for m in json.load(open(os.path.join(HERE, "judging/models_pricing.json")))["data"]}
def cost(model, u): p = M.get(model, {}); u = u or {}; return (u.get("inputTokens") or 0) * float(p.get("input", 0)) + (u.get("outputTokens") or 0) * float(p.get("output", 0))
def ts(path, tag): return [int(l.split()[2]) for l in open(path) if l.startswith(tag + " ")]

out = {}
# pipeline arm: all successful calls except the planted-defect controls (reported separately)
calls = [json.loads(l) for l in open(os.path.join(HERE, "pipeline/batch/calls.jsonl"))]
ok = [c for c in calls if c["ok"]]
pt = os.path.join(HERE, "pipeline/timing.log")
seg = (ts(pt, "END")[0] - ts(pt, "START")[0]) + (ts(pt, "RESUME_END")[0] - ts(pt, "RESUME_START")[0])
out["pipeline"] = {"usd_models": round(sum(cost(c["model"], c.get("usage")) for c in ok if not c["tag"].startswith("ctrl")), 2),
                   "usd_controls": round(sum(cost(c["model"], c.get("usage")) for c in ok if c["tag"].startswith("ctrl")), 2),
                   "calls": sum(1 for c in ok if not c["tag"].startswith("ctrl")), "wall_minutes": round(seg / 60, 1),
                   "accepted": len(json.load(open(os.path.join(HERE, "pipeline/batch/accepted.json"))))}
# legacy arm: checker calls are logged; author and fix subagents report total tokens only
lc, n = 0.0, 0
for f in glob.glob(os.path.join(HERE, "legacy/check1_*/results.jsonl")) + glob.glob(os.path.join(HERE, "legacy/recheck/results.jsonl")):
    for l in open(f):
        r = json.loads(l)
        for k in ("solve", "audit"):
            if r[k].get("ok"): lc += cost(r["model"], r[k].get("usage")); n += 1
lt = open(os.path.join(HERE, "legacy/timing.log")).read()
sub = [int(a) for a in re.findall(r"^\S+ (\d+) / \d+ / \d+$", lt, re.M)] + [int(a) for a in re.findall(r"fix subagent: (\d+) tokens", lt)]
dur = [int(a) for a in re.findall(r"/ \d+ / (\d+)$", lt, re.M)]
fix_ms = int(re.search(r"fix subagent: \d+ tokens / \d+ tool uses / (\d+) ms", lt).group(1))
L = os.path.join(HERE, "legacy/timing.log")
check_s = ts(L, "CHECK1_END")[0] - ts(L, "CHECK1_START")[0]
recheck_s = ts(L, "RECHECK_END")[0] - ts(L, "RECHECK_START")[0]
opus = M["anthropic/claude-opus-5.5"]
tok = sum(sub)
# Subagents report only total tokens. Bound the cost: all-input (low) and 15% output (high), at Opus 5.5 list prices.
low = tok * float(opus["input"]); high = tok * 0.85 * float(opus["input"]) + tok * 0.15 * float(opus["output"])
out["legacy"] = {"usd_checkers": round(lc, 2), "checker_calls": n, "subagent_tokens": tok,
                 "usd_subagents_range": [round(low, 2), round(high, 2)],
                 "wall_minutes": round((max(dur) / 1000 + check_s + fix_ms / 1000 + recheck_s) / 60, 1),
                 "accepted": len(json.load(open(os.path.join(HERE, "legacy/final.json"))))}
# judging (charged to neither arm)
jc = [json.loads(l) for l in open(os.path.join(HERE, "judging/run/judgements.jsonl"))]
out["judging"] = {"usd": round(sum(cost(r["judge"], r.get("usage")) for r in jc if r.get("ok")), 2), "calls": len(jc)}
json.dump(out, open(os.path.join(HERE, "judging/costs.json"), "w"), indent=1)
print(json.dumps(out, indent=1))
