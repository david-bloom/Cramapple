#!/usr/bin/env python3
"""Export the variants for the independent MATH check (blind solve + rationale audit).
Writes <out>.json. Choice order is re-shuffled per item with OS entropy so checkers never see the build's letters.
Usage: python3 export_math_items.py <out.json> [--originals]"""
import importlib, json, secrets, sys
from items import MCQS, FRQS

out = sys.argv[1]
with_orig = "--originals" in sys.argv or "--originals-only" in sys.argv
only_orig = "--originals-only" in sys.argv
rng = secrets.SystemRandom()
L = "ABCD"
rows = []
mods = ["variants_mcq_a", "variants_mcq_b", "variants_mcq_c", "variants_frq"]
vs = []
for n in mods:
    vs += importlib.import_module(n).VARIANTS
def mcq_row(key, stem, correct, wrong):
    ch = [("correct", correct)] + [("wrong", w) for w in wrong]
    rng.shuffle(ch)
    return dict(key=key, kind="mcq", stem=stem,
                choices=[dict(label=L[i], text=t[1][0]) for i, t in enumerate(ch)],
                keyed_label=next(L[i] for i, t in enumerate(ch) if t[0] == "correct"),
                rationales={L[i]: t[1][1] for i, t in enumerate(ch)})
for v in ([] if only_orig else vs):
    if v["kind"] == "mcq":
        rows.append(mcq_row(f"apcalcab-mcq-u1v-{v['id']}", v["stem"], v["correct"], v["wrong"]))
    else:
        rows.append(dict(key=f"apcalcab-frq-u1v-{v['id']}", kind="frq", stem=v["stem"], stimulus=v["stimulus"],
                         criteria=[dict(key=c[0], text=c[1], points=c[2], evidence=c[3]) for c in v["criteria"]]))
if with_orig:
    for m in MCQS:
        rows.append(mcq_row(f"apcalcab-mcq-u1n-{m['id']}", m["stem"], m["correct"], m["wrong"]))
    for f in FRQS:
        rows.append(dict(key=f"apcalcab-frq-u1n-{f['id']}", kind="frq", stem=f["stem"],
                         stimulus=f["stimulus"].replace("TABLE_H1", "0.16713").replace("TABLE_H2", "0.16671").replace("TABLE_H3", "0.16667").replace("TABLE_H4", "0.16666").replace("TABLE_H5", "0.16662").replace("TABLE_H6", "0.16621"),
                         criteria=[dict(key=c[0], text=c[1], points=c[2], evidence=c[3]) for c in f["criteria"]]))
json.dump(rows, open(out, "w"), indent=1)
print(len(rows), "items exported;", sum(r["kind"] == "mcq" for r in rows), "MCQ,", sum(r["kind"] == "frq" for r in rows), "FRQ")
