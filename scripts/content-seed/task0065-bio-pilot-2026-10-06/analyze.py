"""TASK-0065 pilot scoring. Rule: an item fails a check if EITHER checker flags it (union of flags);
C5 needs >= 5 of 6 votes for the designated topic. Writes analysis.json and prints the matrix."""
import json, glob, collections
items = {i["key"]: i for i in json.load(open("items.json"))}
controls = json.load(open("controls.json"))
lint = json.load(open("out_lint.json"))
rows = lambda f: [json.loads(l) for l in open(f) if l.strip()]
R = collections.defaultdict(lambda: collections.defaultdict(list))  # R[key][check] -> [(model, ok, note)]
for r in rows("out_c1c2/results.jsonl"):
    o = r.get("object") or {}
    if not r["ok"]: R[r["key"]][r["pass"]].append((r["model"], False, "call failed")); continue
    if r["pass"] == "solve":
        ok = o["chosen_label"].strip().upper()[:1] == r["keyed_label"] and not o["defect"].strip()
        R[r["key"]]["C1"].append((r["model"], ok, f'chose {o["chosen_label"]}' + (f'; defect: {o["defect"]}' if o["defect"].strip() else "")))
    else:
        bad = [f'{p["label"]}: {p["issue"]}' for p in o["per_choice"] if not p["rationale_accurate"]]
        ok = o["keyed_choice_correct"] and not bad
        note = "; ".join((["key judged wrong"] if not o["keyed_choice_correct"] else []) + bad)
        if o.get("other_defects"): note += (" | other: " + "; ".join(o["other_defects"]))
        R[r["key"]]["C2"].append((r["model"], ok, note))
for r in rows("out_c3c6/results.jsonl"):
    chk = "C3" if r["pass"] == "trap" else "C6"
    if not r["ok"]: R[r["key"]][chk].append((r["model"], False, "call failed")); continue
    o = r["object"]
    if chk == "C3": note = "; ".join([f'{d["label"]}: {d["issue"]}' for d in o["distractors"] if d["issue"].strip()] + ([f'keyed: {o["keyed"]["issue"]}'] if o["keyed"]["issue"].strip() else []))
    else: note = "; ".join([f'{l["list"]}[{l["index"]}]: {l["issue"]}' for l in o["lines"] if l["issue"].strip()] + ([] if o["pairs_with_item"] else ["not paired with item"]) + ([] if o["brief_shares_a_move"] else ["shares no move with brief"]))
    R[r["key"]][chk].append((r["model"], r["derived_verdict"] == "pass", note))
for r in rows("out_c4/results.jsonl"):
    o = r.get("result") or {}
    ok = r["ok"] and o.get("scope_verdict") == "fully_in_scope"
    R[r["content_key"]]["C4"].append((r["model"], ok, "; ".join(o.get("out_of_scope_concepts", []) + o.get("internal_consistency_issues", [])) if r["ok"] else "call failed"))
votes = collections.defaultdict(list)
for f in glob.glob("out_c5_*/labels.jsonl"):
    for r in rows(f): votes[r["key"]].append((r["model"], r["label"]["primary_topic_code"] if r["ok"] else None))
out = {}
for k, it in items.items():
    v = votes[k]; hit = sum(1 for _, t in v if t == it["topic_code"])
    c5 = (hit >= 5, f'{hit}/{len(v)} for {it["topic_code"]}; votes {collections.Counter(t for _, t in v).most_common()}')
    res = {"L": (not lint[k], "; ".join(lint[k]))}
    for c in ["C1", "C2", "C3", "C4", "C6"]: res[c] = (all(ok for _, ok, _ in R[k][c]) and len(R[k][c]) == 2, " || ".join(f"{m.split('/')[1]}: {n}" for m, ok, n in R[k][c] if not ok))
    res["C5"] = c5
    out[k] = {"designated_topic": it["topic_code"], "control": controls.get(k), "checks": {c: {"pass": p, "flags": n} for c, (p, n) in res.items()},
              "publishable": all(p for p, _ in res.values())}
json.dump(out, open("analysis.json", "w"), indent=1)
cols = ["L", "C1", "C2", "C3", "C4", "C5", "C6"]
print(f'{"item":14}' + "".join(f"{c:>5}" for c in cols) + "  verdict")
for k, o in out.items():
    print(f"{k:14}" + "".join(f'{"ok" if o["checks"][c]["pass"] else "FAIL":>5}' for c in cols) + ("  PASS" if o["publishable"] else "  BLOCKED") + (f'   [control: {o["control"]}]' if o["control"] else ""))
