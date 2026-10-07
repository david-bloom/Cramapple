"""Method test: build the blind review set from the three arms plus the planted defects.

Arms: legacy (fresh, legacy/final.json), pipeline (pipeline/batch/accepted.json), shipped (shipped_items.json,
the items live in Production for the same topics). Only student-facing fields are kept; ids are random and
the order is shuffled with a fixed seed. Provenance goes to judging/review_key.json, which the judges never see.
"""
import json, random, os
HERE = os.path.dirname(os.path.abspath(__file__))
FIELDS = ("subject_key", "unit_number", "topic_code", "topic_title", "stem", "choices")
CH = ("choice_key", "choice_text", "is_correct", "rationale")

def clean(it):
    out = {k: it[k] for k in FIELDS if k != "choices"}
    out["choices"] = [{k: c[k] for k in CH} for c in sorted(it["choices"], key=lambda c: c["choice_key"])]
    return out

arms = {
    "legacy": json.load(open(os.path.join(HERE, "legacy/final.json"))),
    "pipeline": json.load(open(os.path.join(HERE, "pipeline/batch/accepted.json"))),
    "shipped": json.load(open(os.path.join(HERE, "shipped_items.json"))),
}
planted = json.load(open(os.path.join(HERE, "judging/planted.json")))
rng = random.Random(4242)
rows, key = [], {}
for arm, items in arms.items():
    for it in items:
        rows.append((arm, f'{it["subject_key"]}:{it["topic_code"]}', clean(it)))
for p in planted:
    rows.append(("planted", p["plant_id"], clean(p["item"])))
rng.shuffle(rows)
ids = rng.sample(range(1000, 9999), len(rows))
review = []
for (arm, ref, it), n in zip(rows, ids):
    rid = f"R{n}"
    review.append({"id": rid, **it})
    key[rid] = {"arm": arm, "ref": ref}
json.dump(review, open(os.path.join(HERE, "judging/review_set.json"), "w"), indent=1, ensure_ascii=False)
json.dump(key, open(os.path.join(HERE, "judging/review_key.json"), "w"), indent=1)
print({a: sum(1 for v in key.values() if v["arm"] == a) for a in ("legacy", "pipeline", "shipped", "planted")}, "total", len(review))
