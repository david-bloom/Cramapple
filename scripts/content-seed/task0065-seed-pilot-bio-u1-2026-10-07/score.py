"""Seed pilot (Biology U1): score the blind judgements per arm.

A judge's verdict on a measure counts only if both of its samples agree. Per item and measure:
  defect   = at least 2 of 3 judges consistently flag it
  disputed = exactly 1 judge consistently flags it (goes to adjudication)
  clean    = no judge consistently flags it
Adjudication results (judging/adjudication.json, {"<id>": {"<measure>": true|false}}, true = defect confirmed)
override disputed and defect statuses. Numeric recompute results (judging/recompute.json, {"<id>": true|false},
false = key wrong) count as a Q1 defect regardless of the panel.
"""
import json, os, collections, re
def real_false(where, key):
    w = (where or "").lower()
    if any(t in w for t in ("rational", "fix", "explan", "stem", "question")): return True
    m = re.search(r"\b([a-d])\b", w)
    return bool(m) and m.group(1).upper() == key
def code(x):
    m = re.search(r"\d+\.\d+", x or ""); return m.group(0) if m else (x or "").strip()
HERE = os.path.dirname(os.path.abspath(__file__))
J = os.path.join(HERE, "judging")
key = json.load(open(f"{J}/review_key.json"))
items = {x["id"]: x for x in json.load(open(f"{J}/review_set.json"))}
adj = json.load(open(f"{J}/adjudication.json")) if os.path.exists(f"{J}/adjudication.json") else {}
recompute = json.load(open(f"{J}/recompute.json")) if os.path.exists(f"{J}/recompute.json") else {}
rows = [json.loads(l) for l in open(f"{J}/run/judgements.jsonl") if l.strip()]
MEASURES = ["Q1_key", "Q2_false_statement", "Q3a_off_topic", "Q3b_beyond_ced", "P_pedagogy", "V_not_publishable"]

per = collections.defaultdict(lambda: collections.defaultdict(dict))  # id -> judge -> sample -> {measure: flag}
for r in rows:
    if not r.get("ok"): continue
    it = items[r["id"]]; k = next(c["choice_key"] for c in it["choices"] if c["is_correct"]); o = r["object"]
    d = per[r["id"]][r["judge"]].setdefault(r["sample"], {})
    if r["call"] == "solve":
        # Q1 uses only the structured answer. The free-text "defect" and "other_defensible" fields were filled with
        # commentary ("None noted.", why each distractor is wrong) by two judges, so they are not used as flags.
        d["solve_key"] = o["answer"].strip().upper()[:1] != k
    else:
        d["audit_key"] = not o["key_correct"]
        # A wrong choice's own text is false by design, and judges listed it. A Q2 defect must sit in the stem, a
        # rationale or fix line, or the keyed choice's text.
        d["Q2_false_statement"] = any(real_false(f["where"], k) for f in o["false_statements"])
        d["Q3a_off_topic"] = code(o["primary_topic_code"]) != it["topic_code"]
        d["Q3b_beyond_ced"] = len(o["beyond_ced"]) > 0
        d["P_pedagogy"] = not (o["traps_named"] and o["fixes_are_actions"])
        d["V_not_publishable"] = o["verdict"] != "publish"

def status(iid, m):
    flags, decided = 0, 0
    for j, samples in per[iid].items():
        vals = []
        for s in samples.values():
            if m == "Q1_key":
                if "solve_key" in s and "audit_key" in s: vals.append(s["solve_key"] or s["audit_key"])
            elif m in s: vals.append(s[m])
        if len(vals) >= 2 and len(set(vals)) == 1:
            decided += 1; flags += vals[0]
    st = "defect" if flags >= 2 else "disputed" if flags == 1 else "clean" if decided >= 2 else "undecided"
    if m == "Q1_key" and recompute.get(iid) is False: st = "defect"
    if m == "Q1_key" and recompute.get(iid) is True and st in ("disputed", "undecided"): st = "clean"  # deterministic recompute settles it
    a = adj.get(iid, {}).get(m)
    if a is not None and st in ("disputed", "defect", "undecided"): st = "defect" if a else "clean"
    return st

table = {iid: {m: status(iid, m) for m in MEASURES} for iid in items}
json.dump(table, open(f"{J}/item_status.json", "w"), indent=1)
out = {}
for arm in ("seed", "variant", "planted"):
    ids = [i for i, v in key.items() if v["arm"] == arm]
    c = {m: collections.Counter(table[i][m] for i in ids) for m in MEASURES}
    any_defect = sum(1 for i in ids if any(table[i][m] == "defect" for m in MEASURES[:4]))
    out[arm] = {"n": len(ids), "measures": {m: dict(c[m]) for m in MEASURES}, "items_with_any_Q1_Q3_defect": any_defect}
json.dump(out, open(f"{J}/scores.json", "w"), indent=1)
disputes = sorted({i for i, v in table.items() for m, s in v.items() if s in ("disputed", "undecided") and m in MEASURES[:4]})
json.dump(disputes, open(f"{J}/disputes.json", "w"), indent=1)
print(json.dumps(out, indent=1)); print("disputed/undecided items (Q1-Q3):", len(disputes))
