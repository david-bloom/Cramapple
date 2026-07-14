# Fact Pack FP-CALCBC-10.13-01 — Convergence of Infinite Series

**Pack ID:** FP-CALCBC-10.13-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** CALCBC
**Applies to:** [CALCBC]  *(BC-only: infinite sequences and series are not in the
AB scope)*
**Unit / Topic:** Unit 10 (Infinite Sequences and Series) — convergence tests and
intervals of convergence *(confirm exact official topic id against the current AP
Calculus CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain calculus
in original wording; no official question text or scoring material used
**Status note:** Illustrative Draft demonstrating the fact-pack format. NOT
production content, NOT calibration evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4. This pack
> also exercises the Calc AB/BC subset model: it is `applies_to: [CALCBC]` only,
> whereas shared differentiation content (`FP-CALCAB-2.1-01`) is reused by BC.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

An infinite series `Σ aₙ` converges if its sequence of partial sums approaches a
finite limit. Convergence tests let you decide this without summing every term.
Choosing the right test from the series' form is the core skill.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **nth-term (divergence) test:** if `lim(n→∞) aₙ ≠ 0`, the series diverges. (If
  the limit is 0, the test is inconclusive.)
- **Geometric series:** `Σ(n=0→∞) a·rⁿ` converges to `a / (1 − r)` iff `|r| < 1`.
- **p-series:** `Σ 1/nᵖ` converges iff `p > 1`. (`p = 1` is the divergent
  harmonic series.)
- **Ratio test:** let `L = lim |aₙ₊₁ / aₙ|`. Converges (absolutely) if `L < 1`,
  diverges if `L > 1`, inconclusive if `L = 1`.
- **Alternating series test:** `Σ(−1)ⁿ bₙ` with `bₙ > 0` converges if `bₙ` is
  decreasing and `lim bₙ = 0`.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

Interval of convergence of a power series, ordered procedure:

```text
1. Apply the ratio test to |aₙ₊₁ / aₙ|; set the limit < 1.
2. Solve for x to get the radius of convergence R and the open interval.
3. Test EACH endpoint separately by substituting it into the series.
4. Include an endpoint only if the resulting numeric series converges.
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student treats `lim aₙ = 0` as proof of
  convergence.
- **Response signal:** concludes a series converges "because the terms go to 0"
  (e.g. claims the harmonic series converges).
- **Discriminating probe:** ask about `Σ 1/n`.
- **Repair move:** "`lim aₙ = 0` is necessary but not sufficient — it only rules
  out divergence by the nth-term test; you still need a convergence test."
- **Minimum fix:** apply a valid convergence test (p-series/integral/comparison).

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** endpoints of a power series' interval are not
  checked.
- **Response signal:** reports an open interval `(−R, R)` (shifted) without
  testing the endpoints.
- **Repair move:** "Substitute each endpoint into the series and test it
  separately."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "endpoints tested and included correctly"

- **Required evidence:** each endpoint is substituted into the series and the
  resulting numeric series is tested; inclusion/exclusion matches the result.
- **Accepted:** correct endpoint behavior justified by a named test (e.g.
  alternating series test at one end, p-series/harmonic at the other).
- **Insufficient:** stating the interval with no endpoint work shown; asserting
  inclusion without a test; testing only one endpoint.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt) — the concept, the test reference,
  and the interval-of-convergence procedure; excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6 — test rules plus boundary/misconception
  entries; adds no criterion beyond the rubric.
