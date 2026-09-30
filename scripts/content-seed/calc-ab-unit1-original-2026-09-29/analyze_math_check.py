#!/usr/bin/env python3
"""Summarize an independent math-check run. Usage: python3 analyze_math_check.py <items.json> <results.jsonl>
Prints per-model reliability, and every item where a checker disagreed with the key or flagged a rationale/criterion."""
import json, sys, collections, re
items = {r["key"]: r for r in json.load(open(sys.argv[1]))}
rows = [json.loads(l) for l in open(sys.argv[2]) if l.strip()]
norm = lambda s: re.sub(r"\s+", " ", s.strip().lower())
flags = collections.defaultdict(list)   # key -> [(model, kind, detail)]
stats = collections.defaultdict(lambda: collections.Counter())
for r in rows:
    m = r["model"].split("/")[1]
    st = stats[m]
    st[f"{r['pass']}_calls"] += 1
    if not r["ok"]:
        st[f"{r['pass']}_error"] += 1
        flags[r["key"]].append((m, "ERROR", f"{r['pass']}: {r['error'][:120]}"))
        continue
    if r.get("mode") == "text_json":
        st["text_json"] += 1
    o = r["object"]; it = items[r["key"]]
    if r["pass"] == "solve" and r["kind"] == "mcq":
        keyed_text = next(c["text"] for c in it["choices"] if c["label"] == it["keyed_label"])
        chosen = (o["chosen_label"].strip().upper() or "?")[0]
        text_norm = norm(o["final_answer"])
        other_texts = {c["label"]: norm(c["text"]) for c in it["choices"] if c["label"] != it["keyed_label"]}
        text_names_other = next((lab for lab, t in other_texts.items() if t and t == text_norm), None)
        text_is_key = text_norm == norm(keyed_text)
        if chosen == it["keyed_label"]:
            if text_names_other:
                st["solve_label_ok_but_text_names_other"] += 1
                flags[r["key"]].append((m, "SOLVE-INCONSISTENT", f"label {chosen} matches key but its answer text is choice {text_names_other}"))
            else:
                st["solve_agree"] += 1
        elif text_is_key:
            st["solve_label_slip_text_agrees"] += 1
            flags[r["key"]].append((m, "note", f"solve: label {chosen} but its own answer text matches the key (label slip)"))
        else:
            st["solve_DISAGREE"] += 1
            flags[r["key"]].append((m, "SOLVE-DISAGREE", f"chose {chosen} '{o['final_answer'][:60]}' vs key {it['keyed_label']} '{keyed_text[:60]}' | {o['working'][:220]}"))
        if o["defect"].strip() and norm(o["defect"]) not in ("none", "n/a", ""):
            flags[r["key"]].append((m, "defect", "solve: " + o["defect"][:200]))
    elif r["pass"] == "solve":
        if o["defect"].strip() and norm(o["defect"]) not in ("none", "n/a", ""):
            flags[r["key"]].append((m, "defect", "solve: " + o["defect"][:200]))
    elif r["pass"] == "audit" and r["kind"] == "mcq":
        if not o["keyed_choice_correct"]:
            st["audit_key_rejected"] += 1
            flags[r["key"]].append((m, "KEY-REJECTED", "audit says keyed choice is not the single correct answer"))
        for c in o["per_choice"]:
            if not c["rationale_accurate"]:
                st["audit_rationale_flags"] += 1
                flags[r["key"]].append((m, "rationale", f"{c['label']}: {c['issue'][:260]}"))
        for d in o["other_defects"]:
            flags[r["key"]].append((m, "other", d[:200]))
    elif r["pass"] == "audit":
        for c in o["per_criterion"]:
            if not c["claim_correct"]:
                st["audit_criterion_flags"] += 1
                flags[r["key"]].append((m, "criterion", f"{c['key']}: {c['issue'][:260]}"))
        for d in o["stem_rubric_mismatch"] + o["other_defects"]:
            flags[r["key"]].append((m, "other", d[:200]))
print("== per model ==")
for m, st in stats.items():
    print(m, dict(st))
both = [k for k, v in flags.items() if len({x[0] for x in v if x[1] not in ('note', 'ERROR')}) >= 2]
print(f"\n== items flagged by BOTH models (excluding label slips/errors): {len(both)} ==")
for k in sorted(both):
    print(k)
print(f"\n== all flags ({len(flags)} items) ==")
for k in sorted(flags):
    for m, kind, d in flags[k]:
        print(f"{k[-14:]:15} {m[:14]:14} {kind:15} {d}")
