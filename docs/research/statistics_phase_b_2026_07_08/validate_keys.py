#!/usr/bin/env python3
"""
Validate the AP Statistics deterministic keys + ECF templates
(`statistics_item_keys.json`) WITHOUT any model call:

  1. Canonical integrity — every ecf_part's declared canonical_answer must equal
     the value recomputed from its formula + givens + upstream canonical answers
     (the same integrity gate the numeric-checker experiment used).
  2. ECF behavior — for each multi-part item, inject a wrong value at the ROOT
     part and confirm the downstream parts, computed correctly on the student's
     own wrong value, are awarded via ECF by the shared ecf_engine. This proves
     the authored templates actually drive the consistency-point logic.

Run: python3 validate_keys.py   (no network, SymPy only)
"""
import json
import math
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
# import the ECF engine + eval helper from the math-formula experiment folder
sys.path.insert(0, os.path.join(HERE, "..", "math_formula_grading_experiment_2026_07_08"))
from ecf_engine import eval_formula, grade_question  # noqa: E402

KEYS = json.load(open(os.path.join(HERE, "statistics_item_keys.json")))
REL_TOL = 1e-3


def isclose(a, b):
    return math.isclose(a, b, rel_tol=REL_TOL, abs_tol=1e-9)


def recompute_canonicals(parts):
    """Recompute each part's canonical value from formula + givens + upstream."""
    canon = {}
    for p in parts:
        deps = p.get("deps", {})
        inputs = {**p.get("givens", {}), **{sym: canon[src] for sym, src in deps.items()}}
        canon[p["id"]] = eval_formula(p["canonical_formula"], inputs,
                                      list(p.get("givens", {})) + list(deps))
    return canon


def check_integrity():
    print("== 1. Canonical integrity (declared vs recomputed) ==")
    ok = 0
    total = 0
    for item in KEYS["items"]:
        parts = item["ecf_parts"]
        if not parts:
            continue
        canon = recompute_canonicals(parts)
        for p in parts:
            total += 1
            # Mirrors runtime matchesTarget: sign is only enforced when a part
            # is explicitly sign_sensitive; otherwise compare magnitude.
            if p.get("sign_sensitive"):
                good = isclose(canon[p["id"]], p["canonical_answer"])
            else:
                good = isclose(abs(canon[p["id"]]), abs(p["canonical_answer"]))
            ok += good
            mark = "ok " if good else "XX "
            print(f"  {mark}{item['content_key']:<22} {p['id']:<8} "
                  f"declared={p['canonical_answer']:<12} recomputed={round(canon[p['id']],5)}")
    print(f"  -> {ok}/{total} keys internally consistent\n")
    return ok == total


def build_ecf_scenario(item):
    """Root part gets a deliberately wrong student answer; downstream parts are
    recomputed CORRECTLY on that wrong value (the ECF case). Returns a question
    dict in ecf_engine's shape + the expected verdicts."""
    parts = item["ecf_parts"]
    root = parts[0]["id"]
    # student's wrong root value: canonical * 0.5 (a clean, clearly-wrong slip)
    canon = recompute_canonicals(parts)
    student_vals = dict(canon)
    student_vals[root] = round(canon[root] * 0.5, 5)
    # recompute downstream parts on the student's own (wrong) upstream values
    for p in parts[1:]:
        deps = p.get("deps", {})
        inputs = {**p.get("givens", {}),
                  **{sym: student_vals[src] for sym, src in deps.items()}}
        student_vals[p["id"]] = round(
            eval_formula(p["canonical_formula"], inputs,
                         list(p.get("givens", {})) + list(deps)), 5)

    q = {"parts": [], "student": {}}
    expected = []
    for p in parts:
        q["parts"].append(p)
        deps = p.get("deps", {})
        shown = {**p.get("givens", {}),
                 **{sym: student_vals[src] for sym, src in deps.items()}}
        q["student"][p["id"]] = {
            "stated_formula": p["canonical_formula"],
            "shown_subs": shown,
            "student_answer": student_vals[p["id"]],
        }
        # root: student's own work (formula on correct givens) yields canonical,
        # but they DECLARED half -> internally inconsistent -> INCORRECT.
        expected.append("INCORRECT" if p["id"] == root else "CORRECT_VIA_ECF")
    return q, expected


def check_ecf():
    print("== 2. ECF behavior (inject wrong root, expect downstream ECF) ==")
    ok = 0
    total = 0
    for item in KEYS["items"]:
        parts = item["ecf_parts"]
        # This scenario only makes sense for a genuine dependency chain
        # (a part whose `deps` points at another part). Items with 2+
        # independent constants/givens (no part depends on another) have
        # nothing for ECF to carry forward, so skip them here.
        if len(parts) < 2 or not any(p.get("deps") for p in parts):
            continue
        total += 1
        q, expected = build_ecf_scenario(item)
        result = grade_question(q)
        got = [p["verdict"] for p in result["parts"]]
        good = got == expected
        ok += good
        print(f"  {'ok ' if good else 'XX '}{item['content_key']:<22} "
              f"{result['earned']}/{result['possible']}  {got}")
    print(f"  -> {ok}/{total} ECF templates behave correctly\n")
    return ok == total


if __name__ == "__main__":
    a = check_integrity()
    b = check_ecf()
    print("ALL CHECKS PASS" if (a and b) else "FAILURES ABOVE")
    sys.exit(0 if (a and b) else 1)
