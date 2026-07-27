#!/usr/bin/env python3
"""
Deterministic (zero-API-cost) SYMBOLIC formula checker — the numeric checker's
sibling for math-heavy subjects (Calculus AB/BC, Precalculus, Physics 1/2,
Physics C Mech/E&M, Macro/Micro Econ, Statistics).

Extends the deterministic-check layer (DECISION-0034, Takeaways Lesson 3) from
numeric-presence checking to algebraic-equivalence checking:

  - kind "expression":     is the student's expression algebraically equivalent
                           to the keyed canonical expression? Any equivalent
                           form passes (factored, expanded, unsimplified,
                           identity-rewritten) — AP accepts unsimplified answers.
  - kind "antiderivative": does d/dx(response) equal the keyed integrand, and
                           is an arbitrary constant (+C) present?
  - kind "numeric":        does the response evaluate to the keyed value within
                           tolerance? (Same scope as checker.py, via sympy.)
  - kind "conceptual":     no key -> ABSTAIN (the LLM grader's job).

Equivalence = sympy simplify(a-b)==0, with a seeded random-sampling fallback
(simplify alone misses e.g. trig identities). Sampling requires agreement at
many points, so single-point coincidences (tangent-line at the point of
tangency) do not fool it. Parse failures FLAG conservatively and are reported
separately. Verdicts: PASS / FLAG / ABSTAIN, matching checker.py.

Out of scope by design (see report.md): unit checking, prose extraction,
inequality/interval answers, "wrong root shown alongside right one".
"""
import json
import os
import random
import cmath
import sympy as sp
from sympy.parsing.sympy_parser import (
    parse_expr, standard_transformations, implicit_multiplication_application,
    convert_xor,
)

HERE = os.path.dirname(os.path.abspath(__file__))
TRANS = standard_transformations + (convert_xor, implicit_multiplication_application)
CONST_NAMES = ("C", "c")          # accepted arbitrary-constant spellings
SEED = 20260708
DEFAULT_TOL = 1e-8
DEFAULT_NUM_TOL = 0.01            # relative, for kind "numeric"
DEFAULT_DOMAIN = (0.5, 2.5)       # positive band avoids most singularities
MIN_AGREE = 12                    # sample points that must agree for PASS


def make_locals(variables):
    d = {v: sp.Symbol(v) for v in variables}
    d.setdefault("e", sp.E)
    for name in CONST_NAMES:
        d.setdefault(name, sp.Symbol(name))
    return d


def parse(text, variables):
    return parse_expr(text, transformations=TRANS, local_dict=make_locals(variables))


def equivalent(a, b, domain=None, tol=DEFAULT_TOL):
    """True iff a == b as functions of their shared free symbols."""
    diff = a - b
    try:
        if sp.simplify(diff) == 0:
            return True
    except Exception:
        pass
    syms = sorted(diff.free_symbols, key=lambda s: s.name)
    if not syms:
        try:
            return abs(complex(diff.evalf())) <= tol
        except Exception:
            return False
    rng = random.Random(SEED)
    lo, hi = domain or DEFAULT_DOMAIN
    agree = 0
    for _ in range(80):
        subs = {s: rng.uniform(lo, hi) for s in syms}
        try:
            va = complex(a.evalf(subs=subs))
            vb = complex(b.evalf(subs=subs))
        except Exception:
            continue
        if any(cmath.isnan(v.real) or cmath.isinf(v.real) for v in (va, vb)):
            continue
        if abs(va - vb) > tol * (1 + abs(va) + abs(vb)):
            return False
        agree += 1
        if agree >= MIN_AGREE:
            return True
    return False  # inconclusive -> conservative non-equivalence


def check_case(case):
    """Return (verdict, reason)."""
    kind = case["kind"]
    if kind == "conceptual" or case.get("canonical") is None:
        return "ABSTAIN", None
    variables = case.get("variables", [])
    domain = tuple(case["domain"]) if "domain" in case else None
    try:
        resp = parse(case["response"], variables)
    except Exception as exc:
        return "FLAG", f"parse_error: {exc}"
    canon = parse(case["canonical"], variables)

    if kind == "expression":
        if equivalent(resp, canon, domain):
            return "PASS", None
        return "FLAG", "not_equivalent"

    if kind == "antiderivative":
        var = sp.Symbol(case["var"])
        if not equivalent(sp.diff(resp, var), canon, domain):
            return "FLAG", "derivative_mismatch"
        consts = {sp.Symbol(n) for n in CONST_NAMES}
        if not (resp.free_symbols & consts):
            return "FLAG", "missing_constant"
        return "PASS", None

    if kind == "numeric":
        tol = case.get("tol", DEFAULT_NUM_TOL)
        try:
            rv = float(resp.evalf())
            cv = float(canon.evalf())
        except Exception as exc:
            return "FLAG", f"numeric_eval_error: {exc}"
        if abs(rv - cv) <= tol * max(1e-12, abs(cv)) + 1e-12:
            return "PASS", None
        return "FLAG", f"numeric_mismatch: got {rv}, want {cv}"

    raise ValueError(f"unknown kind {kind!r}")


def main():
    with open(os.path.join(HERE, "cases.json")) as fh:
        pack = json.load(fh)

    rows, failures = [], []
    for case in pack["cases"]:
        verdict, reason = check_case(case)
        ok = verdict == case["expected"]
        rows.append({"id": case["id"], "subject": case["subject"], "kind": case["kind"],
                     "label": case["label"], "expected": case["expected"],
                     "verdict": verdict, "reason": reason, "ok": ok})
        if not ok:
            failures.append(rows[-1])

    hazard_rows = []
    for case in pack["hazards"]:
        verdict, reason = check_case({**case, "subject": "hazard", "label": "hazard",
                                      "expected": "?"})
        hazard_rows.append({"id": case["id"], "verdict": verdict, "reason": reason,
                            "note": case["note"]})

    correct_pass = [r for r in rows if r["label"] in ("canonical", "equivalent_form")
                    and r["expected"] == "PASS"]
    wrong = [r for r in rows if r["label"] == "wrong"]
    abstain = [r for r in rows if r["expected"] == "ABSTAIN"]
    summary = {
        "battery_size": len(rows),
        "assertions_met": sum(r["ok"] for r in rows),
        "specificity": f"{sum(r['verdict'] == 'PASS' for r in correct_pass)}/{len(correct_pass)}",
        "detection": f"{sum(r['verdict'] == 'FLAG' for r in wrong)}/{len(wrong)}",
        "abstain_correct": f"{sum(r['verdict'] == 'ABSTAIN' for r in abstain)}/{len(abstain)}",
        "failures": failures,
        "hazards": hazard_rows,
    }
    with open(os.path.join(HERE, "summary.json"), "w") as fh:
        json.dump({"summary": summary, "rows": rows}, fh, indent=2)

    for r in rows:
        mark = "ok " if r["ok"] else "XX "
        print(f"{mark}{r['id']:<20} {r['label']:<16} expected={r['expected']:<8} "
              f"got={r['verdict']:<8} {r['reason'] or ''}")
    print("\n-- hazards (observed, not asserted) --")
    for h in hazard_rows:
        print(f"   {h['id']:<16} verdict={h['verdict']:<8} {h['reason'] or ''}  # {h['note']}")
    print(f"\nassertions met: {summary['assertions_met']}/{summary['battery_size']}"
          f" | specificity {summary['specificity']}"
          f" | detection {summary['detection']}"
          f" | abstain {summary['abstain_correct']}")


if __name__ == "__main__":
    main()
