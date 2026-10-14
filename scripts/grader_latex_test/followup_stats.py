#!/usr/bin/env python3
"""TASK-0074 follow-up checks on the Gateway ledger. Read-only; no model calls.
Usage: python3 followup_stats.py results-2026-10-14-attempt-2.jsonl
1. Exact permutation test: could the plain-vs-LaTeX difference be run-to-run noise? Form labels are shuffled within
   each (item, response) cell; the statistic is the number of cross-form disagreeing decision pairs.
2. Where does any variation live (which cells and which form arms)?
3. Scan every model-written string for backslashes, '$' and control characters (C0 controls except tab/newline, and DEL).
"""
import json, itertools, math, re, sys
rows = [json.loads(l) for l in open(sys.argv[1])]
ok = [r for r in rows if r["result"].get("parsed")]
print("ledger lines:", len(rows), "| valid graded calls:", len(ok))
dec = lambda r: (r["result"]["parsed"]["status"], r["result"]["parsed"]["points_awarded"])
cells = {}
for r in ok: cells.setdefault((r["item"], r["resp"]), []).append((r["form"], dec(r)))

def stat(cell):
    p = [d for f, d in cell if f == "plain"]; l = [d for f, d in cell if f == "latex"]
    return sum(1 for a in p for b in l if a != b)
obs = sum(stat(c) for c in cells.values())

def cell_dist(cell):
    forms = [f for f, _ in cell]; ds = [d for _, d in cell]; n = len(cell); k = forms.count("plain"); out = {}
    for idx in itertools.combinations(range(n), k):
        p = [ds[i] for i in idx]; l = [ds[i] for i in range(n) if i not in idx]
        s = sum(1 for a in p for b in l if a != b); out[s] = out.get(s, 0) + 1
    t = sum(out.values()); return {a: v / t for a, v in out.items()}
dist = {0: 1.0}
for c in cells.values():
    d = cell_dist(c); new = {}
    for a, pa in dist.items():
        for b, pb in d.items(): new[a + b] = new.get(a + b, 0) + pa * pb
    dist = new
p = sum(v for k, v in dist.items() if k >= obs)
print("cross-form disagreeing pairs observed:", obs, "| permutation p (>= observed):", round(p, 4))
print("cells with any decision variation:", [k for k, c in cells.items() if len({d for _, d in c}) > 1])
print("form arms with run-to-run variation:", [(k, f) for k, c in cells.items() for f in ("plain", "latex") if len({d for ff, d in c if ff == f}) > 1])
c = cells[("com", "vague")]
pe = sum(1 for f, d in c if f == "plain" and d[0] == "earned"); le = sum(1 for f, d in c if f == "latex" and d[0] == "earned")
nl = sum(1 for f, _ in c if f == "latex")
print(f"com/vague earned: plain {pe}/3, latex {le}/{nl}")
H = lambda k, K, n, N: math.comb(K, k) * math.comb(N - K, n - k) / math.comb(N, n)
N = 3 + nl; K = pe + le; po = H(pe, K, 3, N)
print("Fisher exact two-sided p (com/vague earned, plain vs latex):", round(sum(H(k, K, 3, N) for k in range(0, min(K, 3) + 1) if H(k, K, 3, N) <= po + 1e-12), 4))

pat = re.compile(r"[\x00-\x08\x0b-\x1f\x7f]")
fields = {"plain": 0, "latex": 0}; flagged = []
for r in ok:
    for f in ("evidence_quote", "decision_explanation", "minimum_fix"):
        s = r["result"]["parsed"].get(f); fields[r["form"]] += 1
        if isinstance(s, str) and (pat.search(s) or "\\" in s or "$" in s):
            flagged.append((r["form"], r["item"], r["resp"], r["rep"], f, [hex(ord(m)) for m in pat.findall(s)], "\\" in s))
print("fields scanned:", fields)
for x in flagged: print("FLAG form=%s %s/%s rep%s %s ctrl=%s backslash=%s" % x)
print("calls with a flagged field, by form:", {fm: len({(x[1], x[2], x[3]) for x in flagged if x[0] == fm}) for fm in ("plain", "latex")})
