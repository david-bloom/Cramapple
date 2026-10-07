"""Seed pilot analysis: acceptance, rejection stages, similarity, label agreement, cost. Writes analysis.json."""
import json, glob, os, collections, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "task0065-cost-test-2026-10-07"))
topics = [json.load(open(f)) for f in sorted(glob.glob(os.path.join(HERE, "batch/topics/*.json")))]
out = {"topics": len(topics), "seeds": {"slots": 0, "accepted": 0, "candidates": 0}, "variants": {"slots": 0, "accepted": 0, "candidates": 0},
       "reject_stages": collections.Counter(), "seed_skill_match": 0, "seed_band_match": 0, "seed_skill_status": collections.Counter(),
       "variant_skill_same_as_seed": 0, "variant_band_same_as_seed": 0, "variant_skill_status": collections.Counter(), "sim_to_seed": [],
       "per_topic": {}, "accepted_items": []}
for st in topics:
    t = st["topic"]; pt = {"seeds": 0, "variants": 0}
    for s in st["seeds"]:
        out["seeds"]["slots"] += 1; out["seeds"]["candidates"] += len(s["seed_candidates"])
        for c in s["seed_candidates"]:
            if c.get("gen_ok") and c["eval"]["verdict"] != "accepted": out["reject_stages"][("seed", c["eval"]["stage"])] += 1
        if not s.get("seed"): continue
        out["seeds"]["accepted"] += 1; pt["seeds"] += 1
        lab = s["seed"]["label"]; slot = s["slot"]
        out["seed_skill_match"] += lab["skill"] == slot["skill"]; out["seed_band_match"] += lab["difficulty"] == slot["band"]
        out["seed_skill_status"][lab["skill_status"]] += 1
        out["accepted_items"].append({"kind": "seed", "id": s["seed"]["id"], "slot": slot, "label": {k: lab[k] for k in ("skill", "skill_status", "difficulty")}, "item": s["seed"]["item"]})
        for v in s["variants"]:
            out["variants"]["slots"] += 1; out["variants"]["candidates"] += len(v["candidates"])
            for c in v["candidates"]:
                if c.get("gen_ok") and c["eval"]["verdict"] != "accepted": out["reject_stages"][("variant", c["eval"]["stage"])] += 1
            a = v.get("accepted")
            if not a: continue
            out["variants"]["accepted"] += 1; pt["variants"] += 1
            out["variant_skill_same_as_seed"] += a["label"]["skill"] == lab["skill"]
            out["variant_band_same_as_seed"] += a["label"]["difficulty"] == lab["difficulty"]
            out["variant_skill_status"][a["label"]["skill_status"]] += 1
            out["sim_to_seed"].append(round(a["sim_to_seed"], 3))
            out["accepted_items"].append({"kind": "variant", "id": a["id"], "seed_id": s["seed"]["id"], "slot": slot, "label": {k: a["label"][k] for k in ("skill", "skill_status", "difficulty")}, "sim_to_seed": a["sim_to_seed"], "item": a["item"]})
    out["per_topic"][t["topic_code"]] = pt
out["reject_stages"] = {f"{k[0]}:{k[1]}": v for k, v in out["reject_stages"].items()}
for k in ("seed_skill_status", "variant_skill_status"): out[k] = dict(out[k])
sims = out["sim_to_seed"]; out["sim_to_seed"] = {"n": len(sims), "max": max(sims or [0]), "mean": round(sum(sims) / max(1, len(sims)), 3)}
json.dump(out, open(os.path.join(HERE, "analysis.json"), "w"), indent=1, ensure_ascii=False)
summary = {k: v for k, v in out.items() if k != "accepted_items"}
print(json.dumps(summary, indent=1))
