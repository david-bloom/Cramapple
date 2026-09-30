#!/usr/bin/env python3
"""Per-variant agreement check. A variant inherits a dimension from its original only if >=2 of 3 blind model labels of the
VARIANT equal the ORIGINAL's consensus value for that dimension. Otherwise it is held for that dimension.
Usage: python3 variant_inheritance.py <consensus_orig.json> <out.json> <labels.jsonl> [...]"""
import collections, json, sys
orig_path, out, files = sys.argv[1], sys.argv[2], sys.argv[3:]
orig = json.load(open(orig_path))
man = {m["variant_key"]: m["original_key"] for m in json.load(open("variants_manifest.json"))}
per = collections.defaultdict(dict)
for f in files:
    for l in open(f):
        r = json.loads(l)
        if r["ok"]: per[r["key"]][r["model"]] = r["label"]
DIMS = [("required_units", "units"), ("primary_topic_code", "topic"), ("skill_code", "skill"), ("difficulty", "difficulty")]
norm = lambda d, v: tuple(sorted(v)) if d == "required_units" else v
res = {}
tot = collections.Counter()
for vk, ms in sorted(per.items()):
    ok = man[vk]; o = orig[ok]; row = {"original": ok, "n_models": len(ms)}
    for d, short in DIMS:
        ov = o[d][0]
        if d == "required_units" and ov is not None: ov = tuple(ov)
        if ov is None:
            row[short] = ("original_held", None); tot[(short, "original_held")] += 1; continue
        agree = sum(1 for m in ms.values() if norm(d, m[d]) == ov)
        state = "inherit" if agree >= 2 else "held"
        row[short] = (state, ov if state == "inherit" else None, agree)
        tot[(short, state)] += 1
    res[vk] = row
json.dump(res, open(out, "w"), indent=1, default=list)
print(len(res), "variants checked")
for short in ("units", "topic", "skill", "difficulty"):
    print(short.ljust(11), {s: tot[(short, s)] for s in ("inherit", "held", "original_held")})
bad = [(vk, r["original"][-14:], {k: r[k] for k in ("units", "topic", "skill", "difficulty") if r[k][0] == "held"}) for vk, r in res.items() if any(r[k][0] == "held" for k in ("units", "topic"))]
print("\nvariants that FAIL the unit or topic agreement check:", len(bad))
for b in bad: print(" ", b[0][-14:], "of", b[1], b[2])
