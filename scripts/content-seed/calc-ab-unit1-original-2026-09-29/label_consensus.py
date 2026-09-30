#!/usr/bin/env python3
"""Consensus labels from three blind model runs (two proposers + adjudicator, all run on every item).
A dimension is 'agreed' when >=2 of 3 models give the same value; otherwise 'held'.
Usage: python3 label_consensus.py <out.json> <labels.jsonl> [<labels.jsonl> ...]"""
import collections, json, sys
from items import MCQS, FRQS
out, files = sys.argv[1], sys.argv[2:]
per = collections.defaultdict(dict)   # key -> model -> label
for f in files:
    for l in open(f):
        r = json.loads(l)
        if r["ok"]: per[r["key"]][r["model"]] = r["label"]
mine = {f"apcalcab-mcq-u1n-{m['id']}": (m["topic"], m["diff"]) for m in MCQS}
mine.update({f"apcalcab-frq-u1n-{f['id']}": (f["topic"], f["diff"]) for f in FRQS})
def pick(vals):
    c = collections.Counter(vals).most_common()
    return (c[0][0], "unanimous" if c[0][1] == len(vals) else "majority") if c[0][1] >= 2 else (None, "held")
res = {}
for k, ms in sorted(per.items()):
    r = {"n_models": len(ms)}
    for d in ("primary_topic_code", "skill_code", "difficulty"):
        r[d] = pick([m[d] for m in ms.values()])
    units = [tuple(sorted(m["required_units"])) for m in ms.values()]
    r["required_units"] = pick(units)
    r["mine"] = mine.get(k)
    r["raw"] = {m.split("/")[1]: dict(topic=v["primary_topic_code"], units=v["required_units"], skill=v["skill_code"], diff=v["difficulty"]) for m, v in ms.items()}
    res[k] = r
json.dump(res, open(out, "w"), indent=1, default=list)
tot = collections.Counter()
for k, r in res.items():
    for d in ("primary_topic_code", "skill_code", "difficulty", "required_units"):
        tot[(d, r[d][1])] += 1
print(len(res), "items;", {f"{d}:{t}": n for (d, t), n in sorted(tot.items())})
agree_topic = sum(1 for r in res.values() if r["primary_topic_code"][0] and r["mine"] and r["primary_topic_code"][0] == r["mine"][0])
agree_diff = sum(1 for r in res.values() if r["difficulty"][0] and r["mine"] and r["difficulty"][0].lower() == r["mine"][1])
print("consensus topic == my authored topic:", agree_topic, "/", len(res), "; consensus difficulty == my authored:", agree_diff, "/", len(res))
