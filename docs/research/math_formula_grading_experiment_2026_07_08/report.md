# Symbolic Formula Checker Experiment — Report, 2026-07-08

**Experiment:** Extension of the deterministic-check layer from numeric-presence
to algebraic-equivalence checking, for the math-heavy subject family
(Calculus AB/BC, Precalculus, Physics 1/2, Physics C Mech/E&M, Macro/Micro
Econ, Statistics).
**Status:** Completed, reproducible
**Related:** DECISION-0034; `../grading_cross_subject_takeaways.md` Lesson 3;
`../deterministic_check_experiment_2026_07_08/` (numeric sibling, same verdict
vocabulary); `requirements.md` (this folder) for the per-subject scoping.

## Run metadata

| Field | Value |
| --- | --- |
| Script | `formula_checker.py` (this folder); deterministic, no API calls; SymPy 1.14 |
| Inputs | `cases.json` — hand-authored battery: 62 asserted cases + 4 quarantined notation hazards |
| Coverage | 10 subjects/SKUs; kinds: expression (38), antiderivative (7), numeric (14), conceptual (3) |
| Read tier | **Development.** The battery is author-constructed to exercise checker mechanics; it is NOT a silver/gold corpus and supports no production quality claim (Takeaways Lesson 7). |
| Cost | $0 (pure Python; battery runs in seconds) |
| Seed | 20260708 (sampling fallback is fully deterministic) |

## What the checker does

Per item, the key carries the **canonical expression** (what a
`verification_profile` would hold), its variable set, and a kind:

- **expression** — PASS iff the response is algebraically equivalent to the
  key: `simplify(a−b)==0`, else a seeded 80-draw numeric-sampling fallback
  requiring ≥12 agreeing points. Any correct form passes (factored, expanded,
  unsimplified, identity-rewritten) — matching AP's acceptance of unsimplified
  answers. It never inspects *what* wrong form the student wrote, so it detects
  any non-equivalence, not pre-known errors.
- **antiderivative** — PASS iff d/dx(response) ≡ keyed integrand **and** an
  arbitrary constant (+C) is present; distinguishes `derivative_mismatch` from
  `missing_constant` (the two are different rubric deductions).
- **numeric** — response evaluates to keyed value within tolerance (numeric
  sibling's scope, via the same parser).
- **conceptual** — no key → ABSTAIN (LLM grader's job).

Student-style typed notation is normalized by the parser: caret powers,
implicit multiplication (`2x cos(x^2)`), `e^x`, `4(x-1)+1`. Parse failures FLAG
conservatively.

## Results (`summary.json`)

| Metric | Value |
| --- | ---: |
| Assertions met | **62/62** |
| Specificity — canonical/equivalent forms PASS | **32/32 = 100%** |
| Detection — wrong formulas FLAG | **27/27 = 100%** |
| Conceptual items ABSTAIN | **3/3** |

Notable cases the design handles:

- **Equivalent-form acceptance:** unsimplified quotient rule, factored
  integration-by-parts, reciprocal parallel-resistance, double-angle-expanded
  range formula, Pythagorean-identity rewrite (defeats `simplify` alone; caught
  by sampling), log-property rewrite under a domain-restricted sample band.
- **Single-point coincidence rejected:** wrong tangent line `3x−2` agrees with
  canonical `4x−3` exactly at the point of tangency; multi-point sampling flags
  it.
- **+C policy:** `2x^3` → `missing_constant`; `2x^3 + 5 + C` → PASS (same
  antiderivative family).
- **Cross-subject error classes caught at the formula level:** Stats `s/n` vs
  `s/√n` (the known SE class, caught before any arithmetic), Physics C sign-in-
  exponent (divergent vs saturating drag solution), inverted RC time constant,
  econ inverted elasticity, forgotten square root on an arc-length integrand.

## Notation hazards (observed, not asserted)

| Hazard | Outcome |
| --- | --- |
| `xe^x` concatenation | correctly split to `x·e^x` — PASS |
| `sin^2 x` | correctly read as `sin(x)²` — PASS |
| `1/2 x` | parser precedence matches student intent — PASS |
| **`3t^2/2t` (typed flat fraction)** | **parses as `(3t²/2)·t` → FALSE FLAG on correct work** |

The flat-fraction hazard is the single biggest production risk: it breaks the
100%-specificity property the deterministic layer's value rests on. See
`requirements.md` "Notation intake position" — the immediate mitigation is to
treat ambiguous/unparseable input as ABSTAIN → LLM grader rather than FLAG.

## Claims supported / not supported

**Supported:** a SymPy-based equivalence checker with a sampling fallback
achieves 100% specificity and 100% detection *on this hand-built development
battery*, at $0, deterministically (seeded); the +C and derivative-mismatch
distinctions are mechanically separable; conceptual items are correctly out of
scope; canonical-expression keys are a concrete, authorable
`verification_profile` payload for every math-heavy subject in the family.

**Not supported:** any production or corpus-level quality claim — the battery
is author-constructed, not student-derived; no claim of robustness to
free-text prose extraction (this battery feeds the checker isolated
expressions; the numeric sibling found two extraction bugs in prose, and
formula extraction from prose is strictly harder); no unit checking (Physics
gap, explicitly unbuilt); no inequality/interval/vector-direction support.

## Recommended follow-through

1. **Decide the notation-intake position** (`requirements.md`) — the ABSTAIN-
   on-ambiguity rule can be adopted now at zero cost; structured math input is
   the durable fix and belongs in the Lovable frontend brief for the first
   math-heavy SKU.
2. **Wire the key schema into the verification profiles** — extend
   `AP_PHYSICS_1_VERIFICATION_PROFILE.json`'s "symbolic manipulation
   consistency" from a named intention to the concrete per-item key format used
   here (expression, variables, kind, domain, tolerance). This is TASK-0015
   Phase 3 content.
3. **First student-derived test:** when a Physics or Calculus pilot batch
   exists (TASK-0015 Phase 4), re-run against real responses to measure prose-
   extraction robustness — the known weak layer — before any criterion is
   assigned to this checker in production.
4. **Do not create synthetic breadth corpora for the other subjects** —
   depth-over-breadth stands (Lesson 7); the battery here is pipeline exercise,
   and the launch gate remains the adjudicated Biology gold set.
