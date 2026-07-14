#!/usr/bin/env python3
"""
Transcription-fidelity scorer (credential-free) for the TASK-0016 Phase B
bake-off. Scores model transcriptions of hand-drawn math against human reference
transcriptions. The MODEL RUN (producing the transcriptions) needs gateway
creds; THIS scoring step does not — it compares already-produced outputs.

Input: JSONL, one record per line of student work:
  {"item_key","line_id","human_transcription","model_transcription",
   "human_grades_correct": true|false, "variables": ["s","n",...]}

Per line, the model transcription is:
  ABSTAIN    - did not parse (safe: routes to human)
  FAITHFUL   - parses AND is algebraically equivalent to the human reference
               (equivalent-but-different form counts as faithful, not corrupted)
  CORRUPTED  - parses BUT is NOT equivalent to the human reference (dangerous)

Headline gate = SILENT-CORRUPTION RATE: among lines whose human reference grades
correct, the fraction the model CORRUPTED (the checker would then flag correct
work as wrong). See transcription_bakeoff_protocol.md.

Run: python3 bakeoff_scorer.py [records.jsonl]
     (no arg -> runs the synthetic self-test fixture, proving the mechanics)
"""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                "..", "math_formula_grading_experiment_2026_07_08"))
from formula_checker import parse, equivalent  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))


def classify(rec):
    variables = rec.get("variables", [])
    try:
        model = parse(rec["model_transcription"], variables)
    except Exception:
        return "ABSTAIN"
    try:
        human = parse(rec["human_transcription"], variables)
    except Exception:
        return "ABSTAIN"  # can't adjudicate without a parseable reference
    return "FAITHFUL" if equivalent(model, human) else "CORRUPTED"


def score(records):
    n = len(records)
    counts = {"FAITHFUL": 0, "CORRUPTED": 0, "ABSTAIN": 0}
    correct_lines = 0
    silent_corruptions = 0
    rows = []
    for rec in records:
        verdict = classify(rec)
        counts[verdict] += 1
        if rec.get("human_grades_correct"):
            correct_lines += 1
            if verdict == "CORRUPTED":
                silent_corruptions += 1
        rows.append({"item": rec["item_key"], "line": rec["line_id"], "verdict": verdict})
    summary = {
        "lines": n,
        "parse_rate": round((counts["FAITHFUL"] + counts["CORRUPTED"]) / n, 4),
        "faithful_rate": round(counts["FAITHFUL"] / n, 4),
        "corrupted_rate": round(counts["CORRUPTED"] / n, 4),
        "abstain_rate": round(counts["ABSTAIN"] / n, 4),
        "correct_work_lines": correct_lines,
        "silent_corruption_rate_on_correct_work": (
            round(silent_corruptions / correct_lines, 4) if correct_lines else None),
        "counts": counts,
    }
    return summary, rows


# Synthetic self-test: proves the scorer distinguishes the four outcomes. NOT
# model output and NOT fidelity evidence — mechanics only.
SELF_TEST = [
    {"item_key": "MOD3", "line_id": "SE", "variables": ["s", "n"],
     "human_transcription": "s/sqrt(n)", "model_transcription": "s/sqrt(n)",
     "human_grades_correct": True},                       # FAITHFUL
    {"item_key": "MOD3", "line_id": "SE_altform", "variables": ["s", "n"],
     "human_transcription": "s/sqrt(n)", "model_transcription": "s*n**(-1/2)",
     "human_grades_correct": True},                       # FAITHFUL (equiv form)
    {"item_key": "MOD3", "line_id": "SE_corrupt", "variables": ["s", "n"],
     "human_transcription": "s/sqrt(n)", "model_transcription": "s/n",
     "human_grades_correct": True},                       # CORRUPTED -> silent
    {"item_key": "MOD7", "line_id": "PD", "variables": ["pda", "pa", "pdb", "pb"],
     "human_transcription": "pda*pa + pdb*pb", "model_transcription": "pda*pa + pdb*pb",
     "human_grades_correct": True},                       # FAITHFUL
    {"item_key": "MOD3", "line_id": "messy", "variables": ["t"],
     "human_transcription": "3*t/2", "model_transcription": "3t^^/2t~",
     "human_grades_correct": True},                       # ABSTAIN (unparseable)
    {"item_key": "MOD6", "line_id": "t_wrongwork", "variables": ["m1", "m2", "SEd"],
     "human_transcription": "(m1-m2)/SEd", "model_transcription": "(m1+m2)/SEd",
     "human_grades_correct": False},                      # CORRUPTED (not correct-work)
]


def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1]) as fh:
            records = [json.loads(line) for line in fh if line.strip()]
        label = sys.argv[1]
    else:
        records = SELF_TEST
        label = "SYNTHETIC SELF-TEST (mechanics only — not fidelity evidence)"

    summary, rows = score(records)
    print(f"== Transcription-fidelity scorer :: {label} ==")
    for r in rows:
        print(f"  {r['item']:<8} {r['line']:<14} {r['verdict']}")
    print("\nsummary:")
    print(json.dumps(summary, indent=2))
    with open(os.path.join(HERE, "bakeoff_selftest_summary.json"), "w") as fh:
        json.dump({"label": label, "summary": summary, "rows": rows}, fh, indent=2)

    if len(sys.argv) == 1:
        expect = {"FAITHFUL": 3, "CORRUPTED": 2, "ABSTAIN": 1}
        assert summary["counts"] == expect, (summary["counts"], expect)
        # 5 correct-work lines (all but t_wrongwork); 1 of them CORRUPTED -> 0.2.
        # The correct-work ABSTAIN (messy) is SAFE, not counted as corruption.
        assert summary["silent_corruption_rate_on_correct_work"] == round(1 / 5, 4)
        print("\nself-test OK: 3 faithful (incl. 1 equivalent form), 2 corrupted, "
              "1 abstain; of 5 correct-work lines, 1 silently corrupted (0.2), "
              "and the 1 abstain is safe (routes to human).")


if __name__ == "__main__":
    main()
