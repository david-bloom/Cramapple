# Short Question Set QS-CALCBC-10.13-01 — Series Convergence

**Set ID:** QS-CALCBC-10.13-01
**Set-Version:** v01
**State:** Drafted
**Subject:** CALCBC
**Applies to:** [CALCBC]
**Unit / Topic:** Unit 10 (Infinite Sequences and Series) — convergence tests,
interval of convergence
**Intended use:** diagnostic
**Linked fact pack:** FP-CALCBC-10.13-01
**Status note:** Illustrative Draft items demonstrating the short-question-set
format. NOT production content, NOT calibration evidence. Each item would resolve
to a full package before any production release, authored by a qualified tutor
and independently reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Easy · Calculate)

What is the sum of the geometric series `Σ(n=0→∞) (1/2)ⁿ`?

- A. 1
- **B. 2** ✔
- C. 1/2
- D. The series diverges.

*Key:* B. `a / (1 − r) = 1 / (1 − 1/2) = 2`.

### Item 2 — MCQ (Medium · Determine)

Which series **converges**?

- A. `Σ(n=1→∞) 1/n`
- **B. `Σ(n=1→∞) 1/n²`** ✔
- C. `Σ(n=1→∞) n/(n+1)`
- D. `Σ(n=1→∞) (−1)ⁿ`

*Key:* B, a p-series with `p = 2 > 1`.
*Distractor logic:* A is the harmonic series (p = 1, diverges); C fails the
nth-term test (terms → 1, guards FP E4); D fails the nth-term test (terms do not
approach 0).

### Item 3 — MCQ (Medium · Justify)

Why does `Σ(n=1→∞) n/(2n+1)` diverge?

- **A. The terms approach 1/2, not 0, so it fails the nth-term test.** ✔
- B. It is a geometric series with `r > 1`.
- C. It is a p-series with `p < 1`.
- D. The ratio test gives `L > 1`.

*Key:* A. `lim n/(2n+1) = 1/2 ≠ 0`, so the nth-term (divergence) test applies.

### Item 4 — Short FRQ (Hard · Calculate, Justify)

Find the interval of convergence of `Σ(n=1→∞) xⁿ / n`, showing endpoint work.

*Expected response (development fixture, not a gold label):*
- Ratio test: `lim |x^(n+1)/(n+1) · n/xⁿ| = |x|·lim n/(n+1) = |x|`. Converges for
  `|x| < 1`, so radius `R = 1` and the open interval is `(−1, 1)`.
- Endpoint `x = 1`: `Σ 1/n` is the harmonic series — **diverges**, exclude.
- Endpoint `x = −1`: `Σ (−1)ⁿ/n` converges by the alternating series test —
  **include**.
- **Interval of convergence: `[−1, 1)`.**

*Criterion sketch:* C1 — ratio test gives `R = 1` / interval `(−1, 1)`;
C2 — both endpoints tested separately (guards the FP E6 boundary); C3 — correct
final interval `[−1, 1)`.
