#!/usr/bin/env python3
"""
Engine 3 harness — fixture generator.

Builds structured `response_parts` fixtures that drive EVERY verdict of the
production ECF state machine (supabase/functions/_shared/math-verifier.ts),
with the expected verdict known BY CONSTRUCTION rather than by judgement.

Deliberate design choice: canonical values are evaluated with SymPy here, NOT
with the TypeScript parser that is under test. If the TS parser has a bug, it
shows up as a fixture/actual disagreement instead of being silently baked into
both sides. Using the TS parser to compute expectations would be circular.

Verdict conditions, read from math-verifier.ts buildEcfResult():
  NAKED_ANSWER        part missing | no stated_formula AND no shown_subs | parse failure
  CONCEPTUAL_COLLAPSE stated_formula not symbolically equivalent to canonical_formula
  COINCIDENTAL        answer matches canonical BUT shown work does not produce it
  INCORRECT           shown work does not produce the stated answer (arithmetic slip)
                      | shown_subs disagree with givens / own earlier answers
  CORRECT             answer matches canonical (within ECF_REL_TOL = 1e-3)
  CORRECT_VIA_ECF     answer != canonical, but stated formula is right AND the
                      answer is exactly what that formula yields on the student's
                      OWN upstream value
"""
from __future__ import annotations
import json, math, pathlib, sys
import sympy as sp

ROOT = pathlib.Path("/Users/davidbloom/Documents/Cramapple")
KEYS = ROOT / "docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json"
OUT = pathlib.Path(__file__).parent / "fixtures.json"

ECF_REL_TOL = 1e-3  # must match math-verifier.ts

SYM_NS = {
    "sqrt": sp.sqrt, "factorial": sp.factorial, "erf": sp.erf,
    "exp": sp.exp, "log": sp.log, "ln": sp.log, "abs": sp.Abs,
}


def evaluate(formula: str, subs: dict) -> float:
    """Independent evaluation via SymPy. Raises on anything unparseable.

    Variable names are bound as explicit Symbols BEFORE sympify so they cannot
    collide with SymPy builtins. Without this, a given named `beta` resolves to
    the Beta *function* and `1 - beta` fails. Real profiles use names like beta,
    gamma, and E, so this guard is required, not defensive."""
    ns = dict(SYM_NS)
    for k in subs:
        ns[k] = sp.Symbol(k)
    expr = sp.sympify(formula, locals=ns)
    val = expr.subs({sp.Symbol(k): sp.Float(v) for k, v in subs.items()})
    val = sp.N(val)
    if not val.is_real:
        raise ValueError(f"non-real result for {formula}")
    return float(val)


def close(a: float, b: float, rel=ECF_REL_TOL) -> bool:
    if a == b:
        return True
    denom = max(abs(a), abs(b), 1e-12)
    return abs(a - b) / denom <= rel


def _ns_for(formula: str) -> dict:
    """Namespace binding every bare identifier in `formula` as a Symbol, so
    names like beta/gamma/E do not resolve to SymPy builtins."""
    import re
    ns = dict(SYM_NS)
    for name in set(re.findall(r"[A-Za-z_][A-Za-z_0-9]*", formula)):
        if name not in SYM_NS:
            ns[name] = sp.Symbol(name)
    return ns


def non_equivalent_formula(canonical: str) -> str | None:
    """Produce a structurally WRONG but parseable formula for CONCEPTUAL_COLLAPSE.
    Verified non-equivalent by SymPy sampling before being returned."""
    candidates = []
    if "sqrt(" in canonical:
        candidates.append(canonical.replace("sqrt(", "(", 1))      # drop the root
    if "/" in canonical:
        candidates.append(canonical.replace("/", "*", 1))           # invert the operation
    if "-" in canonical:
        candidates.append(canonical.replace("-", "+", 1))
    if "+" in canonical:
        candidates.append(canonical.replace("+", "-", 1))
    for cand in candidates:
        try:
            a = sp.sympify(canonical, locals=_ns_for(canonical))
            b = sp.sympify(cand, locals=_ns_for(cand))
            if a.free_symbols != b.free_symbols:
                continue
            # sample on the TS default domain [0.5, 2.5]
            pts = [0.7, 1.3, 2.1]
            differs = False
            for p in pts:
                s = {sym: sp.Float(p) for sym in a.free_symbols}
                try:
                    if abs(float(sp.N(a.subs(s))) - float(sp.N(b.subs(s)))) > 1e-6:
                        differs = True
                        break
                except Exception:
                    continue
            if differs:
                return cand
        except Exception:
            continue
    return None


def build_for_profile(prof: dict) -> list[dict]:
    ck = prof["content_key"]
    parts = prof.get("ecf_parts") or []
    if not parts:
        return []

    # canonical universe: resolve deps in declaration order
    canon: dict[str, float] = {}
    for p in parts:
        subs = dict(p.get("givens") or {})
        for sym, src in (p.get("deps") or {}).items():
            if src not in canon:
                return []  # dep declared out of order; skip profile
            subs[sym] = canon[src]
        try:
            canon[p["id"]] = evaluate(p["canonical_formula"], subs)
        except Exception as e:
            print(f"  !! {ck}/{p['id']}: canonical eval failed ({e}) — profile skipped", file=sys.stderr)
            return []

    def student_subs(p, own: dict) -> dict:
        s = dict(p.get("givens") or {})
        for sym, src in (p.get("deps") or {}).items():
            s[sym] = own[src]
        return s

    cases = []

    def emit(case_id, desc, per_part):
        cases.append({
            "content_key": ck, "case_id": case_id, "description": desc,
            "student": {pid: v["student"] for pid, v in per_part.items()},
            "expected": {pid: v["expected"] for pid, v in per_part.items()},
        })

    # ---- CASE 1: all correct ----
    pp = {}
    for p in parts:
        subs = student_subs(p, canon)
        pp[p["id"]] = {
            "student": {"stated_formula": p["canonical_formula"], "shown_subs": subs,
                        "student_answer": canon[p["id"]]},
            "expected": "CORRECT"}
    emit("all_correct", "Every part correct with canonical formula and givens", pp)

    # ---- CASE 2: naked answer (no work shown) ----
    pp = {}
    for p in parts:
        pp[p["id"]] = {
            "student": {"stated_formula": None, "shown_subs": None,
                        "student_answer": canon[p["id"]]},
            "expected": "NAKED_ANSWER"}
    emit("naked_answer", "Correct numbers, zero work shown -> no ECF, help triggered", pp)

    # ---- CASE 3: conceptual collapse on the first part ----
    wrong = non_equivalent_formula(parts[0]["canonical_formula"])
    if wrong:
        pp = {}
        for i, p in enumerate(parts):
            subs = student_subs(p, canon)
            if i == 0:
                pp[p["id"]] = {
                    "student": {"stated_formula": wrong, "shown_subs": subs,
                                "student_answer": canon[p["id"]]},
                    "expected": "CONCEPTUAL_COLLAPSE"}
            else:
                pp[p["id"]] = {
                    "student": {"stated_formula": p["canonical_formula"], "shown_subs": subs,
                                "student_answer": canon[p["id"]]},
                    "expected": "CORRECT"}
        emit("conceptual_collapse", f"Part 1 uses non-equivalent formula '{wrong}'", pp)

    # ---- CASE 4: coincidental (right number, work does not produce it) ----
    p0 = parts[0]
    g0 = dict(p0.get("givens") or {})
    if g0:
        k = sorted(g0)[0]
        tampered = dict(g0)
        tampered[k] = g0[k] * 1.7 if g0[k] else 1.7
        for sym, src in (p0.get("deps") or {}).items():
            tampered[sym] = canon[src]
        try:
            wv = evaluate(p0["canonical_formula"], tampered)
            if not close(wv, canon[p0["id"]]):
                pp = {}
                for i, p in enumerate(parts):
                    if i == 0:
                        pp[p["id"]] = {
                            "student": {"stated_formula": p["canonical_formula"],
                                        "shown_subs": tampered,
                                        "student_answer": canon[p["id"]]},
                            "expected": "COINCIDENTAL"}
                    else:
                        subs = student_subs(p, canon)
                        pp[p["id"]] = {
                            "student": {"stated_formula": p["canonical_formula"],
                                        "shown_subs": subs,
                                        "student_answer": canon[p["id"]]},
                            "expected": "CORRECT"}
                emit("coincidental", f"Part 1 answer is canonical but shown_subs['{k}'] tampered", pp)
        except Exception:
            pass

    # ---- CASE 5: arithmetic slip, then INCONSISTENT self-reference downstream ----
    # Part 1 slips. Downstream parts then silently use the CANONICAL upstream value
    # instead of their own. The checker requires shown_subs deps to match the
    # student's OWN earlier answer, so downstream is expected INCORRECT, not CORRECT
    # -- it is internally inconsistent work. (Corrected 2026-07-28: the original
    # fixture expected CORRECT here, which was a fixture bug, not a checker bug.)
    pp = {}
    slipped_ids = set()
    for i, p in enumerate(parts):
        subs = student_subs(p, canon)
        if i == 0:
            slipped = canon[p["id"]] * 1.35 + 0.7
            slipped_ids.add(p["id"])
            pp[p["id"]] = {
                "student": {"stated_formula": p["canonical_formula"], "shown_subs": subs,
                            "student_answer": slipped},
                "expected": "INCORRECT"}
        else:
            refs_slipped = any(src in slipped_ids for src in (p.get("deps") or {}).values())
            pp[p["id"]] = {
                "student": {"stated_formula": p["canonical_formula"], "shown_subs": subs,
                            "student_answer": canon[p["id"]]},
                "expected": "INCORRECT" if refs_slipped else "CORRECT"}
    emit("inconsistent_upstream_reference",
         "Part 1 arithmetic slip; downstream silently reuses the canonical upstream value", pp)

    # ---- CASE 6: ECF — wrong upstream, downstream correct on the STUDENT'S OWN value ----
    dependents = [p for p in parts if p.get("deps")]
    if dependents:
        own: dict[str, float] = {}
        pp = {}
        for i, p in enumerate(parts):
            if i == 0:
                slipped = canon[p["id"]] * 1.35 + 0.7
                own[p["id"]] = slipped
                pp[p["id"]] = {
                    "student": {"stated_formula": p["canonical_formula"],
                                "shown_subs": student_subs(p, canon),
                                "student_answer": slipped},
                    "expected": "INCORRECT"}
            else:
                subs = student_subs(p, own)          # student's OWN upstream value
                try:
                    y = evaluate(p["canonical_formula"], subs)
                except Exception:
                    own[p["id"]] = canon[p["id"]]
                    continue
                own[p["id"]] = y
                depends_on_slip = any(src in own and not close(own[src], canon[src])
                                      for src in (p.get("deps") or {}).values())
                exp = "CORRECT_VIA_ECF" if (depends_on_slip and not close(y, canon[p["id"]])) else "CORRECT"
                pp[p["id"]] = {
                    "student": {"stated_formula": p["canonical_formula"], "shown_subs": subs,
                                "student_answer": y},
                    "expected": exp}
        if any(v["expected"] == "CORRECT_VIA_ECF" for v in pp.values()):
            emit("ecf_chain", "Wrong upstream value, downstream computed correctly on it -> ECF credit", pp)

    return cases


def main():
    profiles = json.loads(KEYS.read_text())["items"]
    firing = [p for p in profiles if p.get("ecf_parts")]
    all_cases, skipped = [], []
    for prof in firing:
        cs = build_for_profile(prof)
        if not cs:
            skipped.append(prof["content_key"])
        all_cases.extend(cs)

    by_verdict: dict[str, int] = {}
    for c in all_cases:
        for v in c["expected"].values():
            by_verdict[v] = by_verdict.get(v, 0) + 1

    OUT.write_text(json.dumps({
        "generated_by": "scripts/engine3-harness/build_fixtures.py",
        "expectation_engine": f"sympy {sp.__version__} (independent of the TypeScript parser under test)",
        "ecf_rel_tol": ECF_REL_TOL,
        "profiles_firing_capable": len(firing),
        "profiles_covered": len({c['content_key'] for c in all_cases}),
        "profiles_skipped": skipped,
        "cases": all_cases,
    }, indent=1))

    print(f"firing-capable profiles : {len(firing)}")
    print(f"profiles covered        : {len({c['content_key'] for c in all_cases})}")
    if skipped:
        print(f"profiles skipped        : {len(skipped)} -> {skipped}")
    print(f"cases generated         : {len(all_cases)}")
    print(f"part-level expectations : {sum(len(c['expected']) for c in all_cases)}")
    print("\nexpected verdict coverage:")
    for v, n in sorted(by_verdict.items(), key=lambda x: -x[1]):
        print(f"  {v:20s} {n}")
    print(f"\nwrote {OUT}")


if __name__ == "__main__":
    main()
