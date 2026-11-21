#!/usr/bin/env python3
"""Validate a v3 proposed.json: caps, marker rules, structure, word counts. Usage: python3 -I validate.py <folder>"""
import json, re, sys, pathlib
d = pathlib.Path(sys.argv[1]); P = json.load(open(d / "proposed.json")); S = json.load(open(d / "source_snapshot.json"))
CAPS = dict(core_idea=360, what_students_need_to_understand=360, how_this_becomes_points=320)
FIELDS = ["core_idea", "what_students_need_to_understand", "how_this_becomes_points", "common_point_loss", "answer_move", "practice_bridge"]
def W(s):
    s = s.replace("|", " "); s = re.sub(r"(?m)^\s*(?:- |\d+\. )", "", s); return len(s.split())
bad = 0; old = new = 0
want = [e["t"] for e in S["ex"]]
for t in want:
    if t not in P: print("MISSING topic", t); bad += 1
for t, f in P.items():
    if t not in want: print("UNKNOWN topic", t); bad += 1
    for k in FIELDS:
        if not f.get(k, "").strip(): print("EMPTY", t, k); bad += 1
    for k, c in CAPS.items():
        if len(f.get(k, "")) > c: print("OVER CAP", t, k, len(f[k]), c); bad += 1
    for k in FIELDS + ["hook"]:
        for p in f.get(k, "").split("\n\n"):
            ls = p.split("\n"); m = [l.startswith(("- ", "|")) or re.match(r"\d+\. ", l) for l in ls]
            if any(m) and not all(m): print("MIXED marker/plain paragraph", t, k); bad += 1
            if all(m) and len(ls) < 2 and k in CAPS: print("SINGLE structured line", t, k); bad += 1
    if not f["common_point_loss"].startswith("Weak:"): print("Weak must start 'Weak:'", t); bad += 1
    if not f["answer_move"].startswith("Full credit:"): print("Full credit must start 'Full credit:'", t); bad += 1
    steps = len(re.findall(r"(?m)^\d+\. ", f["how_this_becomes_points"]))
    if not 2 <= steps <= 3: print("steps must be 2 or 3", t, steps); bad += 1
    labels = set(re.findall(r"\((\d)\)", f["answer_move"]))
    if not labels or not labels <= set(map(str, range(1, steps + 1))): print("Full credit (n) labels must match the steps", t, sorted(labels), steps); bad += 1
    if "quick_take" in f: print("quick_take must not be in proposed.json (retired)", t); bad += 1
    e = next((x for x in S["ex"] if x["t"] == t), None)
    n = sum(W(f[k]) for k in FIELDS) + (W(f["hook"]) if "hook" in f else 0)
    o = (sum(W(e[k]) for k in ("core", "wsu", "hp", "am", "cpl", "pb", "qt")) if e else 0)
    new += n; old += o
    print(t, "words", o, "->", n, "chars", [len(f[k]) for k in CAPS])
print("TOTAL words", old, "->", new, f"({round(100*(old-new)/old) if old else 0}% less)", "PROBLEMS:", bad)
sys.exit(1 if bad else 0)
