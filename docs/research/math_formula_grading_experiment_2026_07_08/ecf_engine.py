#!/usr/bin/env python3
"""
Error-Carried-Forward (ECF / "consistency points") state machine — prototype
reference for Codex to integrate into the production Structured Multi-Modal
engine (Engine 3).

Sits on top of the symbolic checker (`formula_checker.py`, same folder): reuses
its `parse` and `equivalent` helpers for algebraic-equivalence and structural
checks. The ECF engine adds the thing the plain checker lacks — grading a
multi-part answer where a wrong value in an early part propagates downstream, so
later parts computed correctly on the student's OWN wrong number still earn full
credit (AP "Substitute and Solve" rule: never penalize the same error twice).

Two universes are maintained as parts are walked in order:
  - canonical_answers[part]  = correct value recomputed from the key
  - student_answers[part]    = the value the student declared

Per part, with canonical formula f, canonical value c, student stated formula s,
the student's shown substitutions, and declared answer y:

  Test 1 (Canonical): y == c ?
  Test 2 (ECF):       f(this part's canonical givens + STUDENT's upstream
                        answers) == y ?

Verdicts (each carries a point award and a point-maximizing feedback string):
  CORRECT               Test 1 true, work supports the number.
  CORRECT_VIA_ECF       Test 1 false, Test 2 true, principle sound, work
                        supports — full credit here; penalty stays upstream.
  CONCEPTUAL_COLLAPSE   s is NOT structurally equivalent to f (wrong principle)
                        -> ECF chain broken; 0 for this part regardless of number.
  COINCIDENTAL          Number matches (canonical or ECF) but the student's own
                        shown work does not produce it -> unsupported; 0/flag.
  NAKED_ANSWER          No formula/work shown -> ECF cannot be assumed. Per owner
                        decision (2026-07-08): do NOT apply ECF AND trigger the
                        "help"/scaffolding feature.
  INCORRECT             New error introduced in this part.

Scope: this is the DETERMINISTIC ECF layer. It assumes each part has already
been transcribed/extracted into {stated_formula, shown_subs, student_answer}
(the LLM/vision extraction pass, Engine 3's other half). Transcription fidelity
is the dominant upstream risk (see hand_drawn_formula_assessment.md); on low
extraction confidence the caller should ABSTAIN to the LLM/human, not feed a
guess in here.
"""
import json
import math
import os

import sympy as sp
from formula_checker import parse, equivalent  # reuse the checker's engine

HERE = os.path.dirname(os.path.abspath(__file__))
# Tolerance must accommodate students rounding intermediate values (AP grades
# "consistent with the student's work"). 0.1% is a reasonable prototype default;
# production should set it per item in the verification_profile.
REL_TOL = 1e-3


def eval_formula(formula, subs, variables):
    expr = parse(formula, variables)
    val = expr.evalf(subs={sp.Symbol(k): v for k, v in subs.items()})
    return float(val)


def isclose(a, b):
    return math.isclose(a, b, rel_tol=REL_TOL, abs_tol=1e-9)


def grade_part(part, student, student_answers):
    """Return (verdict, points_awarded, feedback).

    Verdict is decided on the CHAIN OF CUSTODY, not on re-comparing recomputed
    floats: (1) does the student's own shown work produce their own answer;
    (2) is the principle (formula structure) correct; (3) do the inputs they used
    trace to correct givens + their OWN upstream answers. This is robust to a
    student rounding intermediate values, which output-vs-output float comparison
    is not.
    """
    pid = part["id"]
    pts = part["points"]
    f = part["canonical_formula"]
    givens = part.get("givens", {})
    deps = part.get("deps", {})
    variables = list(givens) + list(deps)

    # canonical value for this part (its number, for the CORRECT vs ECF split)
    canon_inputs = {**givens, **{sym: part["_canon_dep_vals"][sym] for sym in deps}}
    c = eval_formula(f, canon_inputs, variables)

    stated = student.get("stated_formula")
    shown = student.get("shown_subs") or {}
    y = student["student_answer"]

    # --- Guardrail: naked answer (no chain of custody) ---
    if not stated and not shown:
        return ("NAKED_ANSWER", 0,
                f"No work shown for part {pid}, so we can't trace how you reached "
                f"{y}. Consistency (ECF) credit can't be applied without shown "
                f"work — opening the help walkthrough for this step.")

    # (1) Does the student's OWN shown work produce the number they wrote?
    work_val = eval_formula(stated, shown, list(shown)) if (stated and shown) else None
    work_supports = isclose(work_val, y) if work_val is not None else None
    number_matches_canonical = isclose(y, c)

    # --- Guardrail: conceptual collapse (wrong principle) ---
    structural_ok = True
    if stated:
        try:
            structural_ok = equivalent(parse(stated, variables), parse(f, variables))
        except Exception:
            structural_ok = False
    if not structural_ok:
        return ("CONCEPTUAL_COLLAPSE", 0,
                f"Part {pid} uses the wrong relationship: you wrote `{stated}`, but "
                f"this step needs `{f}`. That's a new conceptual error, so "
                f"error-carried-forward doesn't rescue it.")

    # --- Guardrail: coincidental correct number ("unbelievably lucky") ---
    if number_matches_canonical and work_supports is False:
        return ("COINCIDENTAL", 0,
                f"Your final number for part {pid} matches, but your shown work "
                f"(`{stated}` with your values) gives {round(work_val, 4)}, not {y}. "
                f"The number isn't supported by the work, so it can't earn the point.")

    # (1b) student's own arithmetic within this part is internally wrong
    if work_supports is False:
        return ("INCORRECT", 0,
                f"Arithmetic error in part {pid}: `{stated}` with your values "
                f"({fmt_subs(shown)}) gives {round(work_val, 4)}, but you wrote {y}.")

    # (3) chain of custody: correct fresh givens + student's OWN upstream answers
    if shown:
        givens_ok = all(g in shown and isclose(shown[g], gv) for g, gv in givens.items())
        deps_ok = all(sym in shown and isclose(shown[sym], student_answers[src])
                      for sym, src in deps.items())
        if not givens_ok:
            return ("INCORRECT", 0,
                    f"Part {pid} uses a value that doesn't match the problem's "
                    f"givens — that's a new error, not carried forward.")
        if not deps_ok:
            return ("INCORRECT", 0,
                    f"Part {pid} didn't carry your own earlier result forward, so "
                    f"the chain breaks here — treated as a new error.")

    # principle right, work supports, inputs traced -> CORRECT if the number is
    # canonical (upstream was right), else full credit via ECF (penalty upstream).
    if number_matches_canonical:
        return ("CORRECT", pts, f"Part {pid} correct.")
    dep_list = ", ".join(f"part {src}" for src in deps.values()) or "an earlier part"
    return ("CORRECT_VIA_ECF", pts,
            f"Your value from {dep_list} was off, but your setup for part {pid} "
            f"(`{stated}`) is the right relationship and you computed it correctly on "
            f"your own number — full credit for part {pid}. Fix {dep_list} and this "
            f"stays correct.")


def fmt_subs(subs):
    return ", ".join(f"{k}={round(v, 4)}" for k, v in subs.items())


def grade_question(question):
    """Walk parts in order; return per-part results + totals."""
    student_answers = {}
    canon_answers = {}
    results = []
    total_pts = sum(p["points"] for p in question["parts"])
    earned = 0
    for part in question["parts"]:
        deps = part.get("deps", {})
        part["_canon_dep_vals"] = {sym: canon_answers[src] for sym, src in deps.items()}
        student = question["student"][part["id"]]
        verdict, pts, feedback = grade_part(part, student, student_answers)
        # record canonical + student states for downstream parts
        canon_inputs = {**part.get("givens", {}),
                        **{sym: canon_answers[src] for sym, src in deps.items()}}
        canon_answers[part["id"]] = eval_formula(
            part["canonical_formula"], canon_inputs,
            list(part.get("givens", {})) + list(deps))
        student_answers[part["id"]] = student["student_answer"]
        earned += pts
        results.append({"part": part["id"], "verdict": verdict,
                        "points": f"{pts}/{part['points']}", "feedback": feedback})
    return {"earned": earned, "possible": total_pts, "parts": results}


# --------------------------------------------------------------------------
# Development battery. Each case declares the expected per-part verdicts so the
# run self-checks (integrity gate). NOT a gold corpus — mechanics only.
# --------------------------------------------------------------------------
BATTERY = [
    {
        "name": "physics_cascade_arithmetic_ecf",
        "desc": "a=F/m wrong (20/4=4), then v=at and KE=0.5mv^2 correct on a=4",
        "parts": [
            {"id": "A", "points": 1, "canonical_formula": "F/m",
             "givens": {"F": 20, "m": 4}, "canonical_answer": 5},
            {"id": "B", "points": 2, "canonical_formula": "a*t",
             "givens": {"t": 3}, "deps": {"a": "A"}, "canonical_answer": 15},
            {"id": "C", "points": 1, "canonical_formula": "0.5*m*v**2",
             "givens": {"m": 4}, "deps": {"v": "B"}, "canonical_answer": 450},
        ],
        "student": {
            "A": {"stated_formula": "F/m", "shown_subs": {"F": 20, "m": 4}, "student_answer": 4},
            "B": {"stated_formula": "a*t", "shown_subs": {"a": 4, "t": 3}, "student_answer": 12},
            "C": {"stated_formula": "0.5*m*v**2", "shown_subs": {"m": 4, "v": 12}, "student_answer": 288},
        },
        "expect": ["INCORRECT", "CORRECT_VIA_ECF", "CORRECT_VIA_ECF"],
    },
    {
        "name": "physics_cascade_conceptual_collapse",
        "desc": "A correct; B uses v=a/t (wrong principle); C still ECF on B's value",
        "parts": [
            {"id": "A", "points": 1, "canonical_formula": "F/m",
             "givens": {"F": 20, "m": 4}, "canonical_answer": 5},
            {"id": "B", "points": 2, "canonical_formula": "a*t",
             "givens": {"t": 3}, "deps": {"a": "A"}, "canonical_answer": 15},
            {"id": "C", "points": 1, "canonical_formula": "0.5*m*v**2",
             "givens": {"m": 4}, "deps": {"v": "B"}, "canonical_answer": 450},
        ],
        "student": {
            "A": {"stated_formula": "F/m", "shown_subs": {"F": 20, "m": 4}, "student_answer": 5},
            "B": {"stated_formula": "a/t", "shown_subs": {"a": 5, "t": 3}, "student_answer": 5 / 3},
            "C": {"stated_formula": "0.5*m*v**2", "shown_subs": {"m": 4, "v": 5 / 3}, "student_answer": 0.5 * 4 * (5 / 3) ** 2},
        },
        "expect": ["CORRECT", "CONCEPTUAL_COLLAPSE", "CORRECT_VIA_ECF"],
    },
    {
        "name": "single_part_coincidental_canonical",
        "desc": "writes '2*2=5'; 5 is the canonical number but work gives 4",
        "parts": [
            {"id": "A", "points": 1, "canonical_formula": "x*y",
             "givens": {"x": 2.5, "y": 2}, "canonical_answer": 5},
        ],
        "student": {
            "A": {"stated_formula": "x*y", "shown_subs": {"x": 2, "y": 2}, "student_answer": 5},
        },
        "expect": ["COINCIDENTAL"],
    },
    {
        "name": "single_part_naked_answer",
        "desc": "declares 5 with no formula/work -> no ECF + trigger help",
        "parts": [
            {"id": "A", "points": 1, "canonical_formula": "F/m",
             "givens": {"F": 20, "m": 4}, "canonical_answer": 5},
        ],
        "student": {
            "A": {"stated_formula": None, "shown_subs": None, "student_answer": 5},
        },
        "expect": ["NAKED_ANSWER"],
    },
    {
        "name": "calculus_related_rates_ecf",
        "desc": "r wrong (=2, should be 3); dV/dt=4*pi*r^2*(dr/dt) correct on r=2",
        "parts": [
            {"id": "A", "points": 1, "canonical_formula": "(3*V/(4*pi))**(1/3)",
             "givens": {"V": 36 * math.pi}, "canonical_answer": 3},
            {"id": "B", "points": 2, "canonical_formula": "4*pi*r**2*drdt",
             "givens": {"drdt": 2}, "deps": {"r": "A"}, "canonical_answer": 4 * math.pi * 9 * 2},
        ],
        "student": {
            "A": {"stated_formula": "(3*V/(4*pi))**(1/3)", "shown_subs": {"V": 36 * math.pi}, "student_answer": 2},
            "B": {"stated_formula": "4*pi*r**2*drdt", "shown_subs": {"r": 2, "drdt": 2}, "student_answer": 4 * math.pi * 4 * 2},
        },
        "expect": ["INCORRECT", "CORRECT_VIA_ECF"],
    },
    {
        "name": "all_correct_cascade_no_false_ecf",
        "desc": "specificity: everything correct -> all CORRECT, no spurious ECF",
        "parts": [
            {"id": "A", "points": 1, "canonical_formula": "F/m",
             "givens": {"F": 20, "m": 4}, "canonical_answer": 5},
            {"id": "B", "points": 2, "canonical_formula": "a*t",
             "givens": {"t": 3}, "deps": {"a": "A"}, "canonical_answer": 15},
        ],
        "student": {
            "A": {"stated_formula": "F/m", "shown_subs": {"F": 20, "m": 4}, "student_answer": 5},
            "B": {"stated_formula": "a*t", "shown_subs": {"a": 5, "t": 3}, "student_answer": 15},
        },
        "expect": ["CORRECT", "CORRECT"],
    },
]


def main():
    passed = 0
    out = []
    for case in BATTERY:
        result = grade_question(case)
        got = [p["verdict"] for p in result["parts"]]
        ok = got == case["expect"]
        passed += ok
        print(f"{'ok ' if ok else 'XX '}{case['name']:<40} "
              f"{result['earned']}/{result['possible']}  {got}")
        for p in result["parts"]:
            print(f"      [{p['part']}] {p['verdict']:<20} {p['points']}  {p['feedback']}")
        out.append({"name": case["name"], "expected": case["expect"], "got": got,
                    "ok": ok, "result": result})
    print(f"\nassertions met: {passed}/{len(BATTERY)}")
    with open(os.path.join(HERE, "ecf_summary.json"), "w") as fh:
        json.dump({"passed": f"{passed}/{len(BATTERY)}", "cases": out}, fh, indent=2)


if __name__ == "__main__":
    main()
