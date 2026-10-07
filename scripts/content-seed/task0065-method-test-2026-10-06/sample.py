"""Draw the method-test sample: 6 topics per subject, units 1-3, from the TASK-0065 scope (fixed seed)."""
import json, random
scope = json.load(open("scripts/vercel-gateway-check/teaching_pipeline/inputs/scope_u1-3.json"))
rng = random.Random(20261006)
out = []
for s in ["biology", "ap-statistics", "ap-chemistry", "ap-calculus-ab"]:
    pool = [t for t in scope if t["subject_key"] == s and t["unit_number"] <= 3]
    out += sorted(rng.sample(pool, 6), key=lambda t: [int(p) for p in t["topic_code"].split(".")])
json.dump(out, open("scripts/content-seed/task0065-method-test-2026-10-06/sample.json", "w"), indent=1)
for t in out: print(t["subject_key"], t["topic_code"], t["topic_title"])
