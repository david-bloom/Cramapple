# AP Calculus BC topics 2.1 to 2.10: harder seed drafts (second batch)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (exact fractions, finite differences, numerical limits).
Scope: 20 new seeds, 80 items, two per topic 2.1 to 2.10, mostly R3 (interpretation, multi-step reasoning, error analysis). Emphasis on average-rate bookkeeping, scaled difference quotients, differentiability diagnosis, tangent lines through external points, tables of f, g, f′, g′ with product and quotient rules, and identity-based trig derivatives.

| Seed | Topic | Replaces |
|---|---|---|
| N-2.1-A | 2.1 Defining Average and Instantaneous Rates of Change at a Point | new |
| N-2.1-B | 2.1 Defining Average and Instantaneous Rates of Change at a Point | new |
| N-2.2-A | 2.2 Defining the Derivative of a Function and Using Derivative Notation | new |
| N-2.2-B | 2.2 Defining the Derivative of a Function and Using Derivative Notation | new |
| N-2.3-A | 2.3 Estimating Derivatives of a Function at a Point | new |
| N-2.3-B | 2.3 Estimating Derivatives of a Function at a Point | new |
| N-2.4-A | 2.4 Connecting Differentiability and Continuity | new |
| N-2.4-B | 2.4 Connecting Differentiability and Continuity | new |
| N-2.5-A | 2.5 Applying the Power Rule | new |
| N-2.5-B | 2.5 Applying the Power Rule | new |
| N-2.6-A | 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple | new |
| N-2.6-B | 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple | new |
| N-2.7-A | 2.7 Derivatives of cos x, sin x, e^x, and ln x | new |
| N-2.7-B | 2.7 Derivatives of cos x, sin x, e^x, and ln x | new |
| N-2.8-A | 2.8 The Product Rule | new |
| N-2.8-B | 2.8 The Product Rule | new |
| N-2.9-A | 2.9 The Quotient Rule | new |
| N-2.9-B | 2.9 The Quotient Rule | new |
| N-2.10-A | 2.10 Derivatives of tan x, cot x, sec x, and csc x | new |
| N-2.10-B | 2.10 Derivatives of tan x, cot x, sec x, and csc x | new |

---

## Seed N-2.1-A (new) — Topic 2.1 Defining Average and Instantaneous Rates of Change at a Point
**Skill:** combine average rates of change over adjacent intervals using total change, not by averaging or subtracting the rates.

A differentiable function f has average rate of change 4 over the interval [2, 5] and average rate of change 6 over the interval [2, 3]. What is the average rate of change of f over [3, 5]?

- A. 5
- B. 2
- C. 6
- **D. 3**

Check: f(5) − f(2) = 4·3 = 12 and f(3) − f(2) = 6·1 = 6, so f(5) − f(3) = 6 and the average rate over [3, 5] is 6/2 = 3.
Rationales: A: Averaging the two given rates, (4 + 6)/2, treats the intervals as if they had equal width, but [2, 3] and [3, 5] have widths 1 and 2 and the intervals overlap differently. B: Subtracting the rates, 6 − 4, is not meaningful; average rates combine through total changes f(5) − f(2) = 12 and f(3) − f(2) = 6, not through the rates themselves. C: The change f(5) − f(3) is 12 − 6 = 6, but this is a change in f and must still be divided by the width 5 − 3 = 2 to give a rate.

**N-2.1-A-v1.** The temperature of a sample is T(t) degrees Celsius at time t minutes. The average rate of change of T over [0, 4] is 3 degrees per minute, and the average rate of change of T over [0, 1] is −2 degrees per minute. What is the average rate of change of T over [1, 4], in degrees per minute?

- A. 1/2
- B. 5
- **C. 14/3**
- D. 14

Check: T(4) − T(0) = 12 and T(1) − T(0) = −2, so T(4) − T(1) = 14 over a width of 3 gives 14/3.
Rationales: A: Averaging 3 and −2 gives 1/2, but the average over [1, 4] is not the mean of the other two rates because the three intervals have different widths. B: Subtracting the rates, 3 − (−2), mixes rates with totals; the correct step is to subtract the changes T(4) − T(0) = 12 and T(1) − T(0) = −2 and then divide. D: The change T(4) − T(1) = 12 − (−2) = 14 is correct, but it is a change in temperature, and it must be divided by the width 3 of [1, 4].

**N-2.1-A-v2.** A store's cumulative revenue is R(t) thousand dollars after t weeks. The average rate of change of R over [1, 7] is 5 thousand dollars per week, and the average rate of change of R over [4, 7] is 2 thousand dollars per week. What is the average rate of change of R over [1, 4]?

- **A. 8**
- B. 7/2
- C. 3
- D. 4

Check: R(7) − R(1) = 30 and R(7) − R(4) = 6, so R(4) − R(1) = 24 and the average rate over [1, 4] is 24/3 = 8.
Rationales: B: The mean of 5 and 2 is 7/2, but the average over [1, 4] is not their mean; [1, 7] and [4, 7] overlap and have different widths, so the rates cannot simply be averaged. C: Subtracting 5 − 2 treats the rates as if they were changes; the right step is R(7) − R(1) = 30 minus R(7) − R(4) = 6, which gives the change over [1, 4]. D: The change over [1, 4] is 30 − 6 = 24, but dividing by 6, the width of [1, 7], is wrong; the width of [1, 4] is 3.

**N-2.1-A-v3.** A function f has average rate of change 2 over [1, 3] and average rate of change 5 over [3, 7]. What is the average rate of change of f over [1, 7]?

- A. 7/2
- B. 7
- **C. 4**
- D. 24

Check: f(3) − f(1) = 2·2 = 4 and f(7) − f(3) = 5·4 = 20, so the average rate over [1, 7] is 24/6 = 4.
Rationales: A: The mean of 2 and 5 is 7/2, but the two intervals have widths 2 and 4, so the rate over [1, 7] is a weighted average, not a plain one. B: Adding the rates 2 + 5 treats rates as if they were changes; over [1, 7] the changes 4 and 20 are added and then divided by the total width. D: The total change is 4 + 20 = 24, but a rate over [1, 7] requires dividing by the width 6, which gives 4.

---

## Seed N-2.1-B (new) — Topic 2.1 Defining Average and Instantaneous Rates of Change at a Point
**Skill:** decide which conclusions follow from an average rate of change over an interval, separating net change from pointwise or monotonic claims.

A differentiable function f has average rate of change 0 over the interval [1, 5]. Which of the following must be true?  I. f(1) = f(5).  II. f′(x) = 0 for every x in (1, 5).  III. f′(3) = 0.

- A. I and II only
- B. I and III only
- **C. I only**
- D. II and III only

Check: Zero average rate means (f(5) − f(1))/4 = 0, so only I is forced; f(x) = (x − 1)²(x − 5) satisfies I but has f′(3) = −4.
Rationales: A: Statement II confuses an average of zero with zero at every point; for example, f(x) = (x − 1)²(x − 5) has f(1) = f(5) but f′(x) is not zero throughout (1, 5). B: Statement III picks out a single point, the midpoint, but an average of zero does not force f′(3) = 0; for f(x) = (x − 1)²(x − 5) we get f′(3) = −4. D: Both II and III claim values of f′, which an average rate over an interval does not determine; only the net change f(5) − f(1) = 0 is forced, as in statement I.

**N-2.1-B-v1.** The temperature T(t) of a metal rod is differentiable, and its average rate of change over [2, 6] is −3 degrees per minute. Which of the following must be true?  I. T(6) = T(2) − 12.  II. T′(4) = −3.  III. T is decreasing at every time in [2, 6].

- A. I and II only
- B. II only
- **C. I only**
- D. I and III only

Check: (T(6) − T(2))/4 = −3 gives T(6) − T(2) = −12; II and III need extra information about T between the endpoints.
Rationales: A: Statement II treats the average rate as the instantaneous rate at the midpoint; that works for a linear or quadratic T but not for every differentiable T. B: Statement II is not forced, and statement I is: an average rate of −3 over a length-4 interval means T drops by 3·4 = 12 in total. D: Statement III is false because T can rise for part of the interval and still have a negative average rate; only the net change over [2, 6] is determined.

**N-2.1-B-v2.** A differentiable function f has average rate of change 2 over [1, 3] and average rate of change 2 over [3, 7]. Which of the following must be true?  I. The average rate of change of f over [1, 7] is 2.  II. f(7) − f(1) = 12.  III. f′(3) = 2.

- A. I only
- **B. I and II only**
- C. I, II, and III
- D. II and III only

Check: f(3) − f(1) = 4 and f(7) − f(3) = 8, so f(7) − f(1) = 12 and the average over [1, 7] is 2; f′(3) is not determined.
Rationales: A: Statement II follows from I: an average rate of 2 over an interval of width 6 gives f(7) − f(1) = 12, so it is also forced. C: Statement III is not forced; equal average rates on both sides of 3 say nothing about the slope at 3 itself, since f may bend and still have the same net changes. D: Statement I is also forced, since f(7) − f(1) = 4 + 8 = 12 gives average 12/6 = 2, and statement III is not forced by average rates alone.

**N-2.1-B-v3.** Let f(x) = x³. The average rate of change of f over [0, 6] is 36. Which of the following must be true?  I. f′(3) = 36.  II. f′(x) = 36 for some x in (0, 6).  III. f′(x) < 36 for every x in (0, 6).

- A. I only
- **B. II only**
- C. I and III only
- D. III only

Check: (216 − 0)/6 = 36; f′(x) = 3x² = 36 at x = 2√3 ≈ 3.46 in (0, 6), while f′(3) = 27 and f′(5) = 75.
Rationales: A: Statement I treats the average rate as the slope at the midpoint, but for a cubic f′(3) = 27, which differs from 36. C: Statement III is false: f′(x) = 3x² exceeds 36 for x > 2√3, for example f′(5) = 75, and statement I is false because f′(3) = 27. D: Statement III fails because f′(x) = 3x² is larger than 36 near x = 6, and statement II holds at x = 2√3, which lies in (0, 6).

---

## Seed N-2.2-A (new) — Topic 2.2 Defining the Derivative of a Function and Using Derivative Notation
**Skill:** evaluate a scaled or offset difference quotient as a multiple of f′(a), tracking the coefficients of h in both terms.

Let f be a differentiable function with f′(3) = 5. What is lim as h→0 of [f(3 + 2h) − f(3 − h)]/h?

- A. 5
- **B. 15**
- C. 10
- D. 3

Check: f(3 + 2h) − f(3 − h) ≈ f′(3)(2h − (−h)) = 3h f′(3), so the limit is 3·5 = 15.
Rationales: A: Subtracting the coefficients 2 − 1 = 1 ignores that the second point lies below 3, so the total horizontal gap is 2h − (−h) = 3h and the limit is 3f′(3). C: This keeps only the shift of 2h from the first term and treats f(3 − h) as f(3), missing the extra h of separation on the other side. D: The total gap is 3h, which does give the factor 3, but the limit is that factor times the derivative f′(3) = 5, not the factor alone.

**N-2.2-A-v1.** Let f be a differentiable function with f′(2) = −4. What is lim as h→0 of [f(2 + 3h) − f(2 − h)]/h?

- A. −12
- B. −8
- **C. −16**
- D. 16

Check: The inputs differ by 3h − (−h) = 4h, so the limit is 4f′(2) = 4·(−4) = −16.
Rationales: A: This counts only the 3h shift on the upper side and treats f(2 − h) as f(2), so it gives 3·(−4) and misses the extra h below 2. B: Subtracting the coefficients 3 − 1 = 2 treats the lower point as if it lay above 2; the actual gap between the inputs is 3h − (−h) = 4h. D: The magnitude 4·4 comes from the gap 4h, but the derivative f′(2) = −4 is negative, so the limit must be negative.

**N-2.2-A-v2.** Let f be a differentiable function with f′(1) = 6. What is lim as h→0 of [f(1 + h) − f(1 − 2h)]/(3h)?

- A. 18
- B. 2
- C. 4
- **D. 6**

Check: f(1 + h) − f(1 − 2h) ≈ 3h f′(1), so dividing by 3h leaves f′(1) = 6.
Rationales: A: This finds that the numerator behaves like 3h·f′(1) = 18h but forgets to divide by the 3 in the denominator 3h. B: Dividing f′(1) = 6 by 3 treats the 3h in the denominator as if it were not already matched by the 3h gap in the numerator. C: This counts only the 2h shift of the lower term and divides by 3, giving 2·6/3, and it ignores the h shift of the first term.

**N-2.2-A-v3.** Let f be a differentiable function with f′(5) = −2. What is lim as h→0 of [f(5 − h) − f(5 + 2h)]/h?

- A. −6
- **B. 6**
- C. −2
- D. 2

Check: The first input is 3h below the second, so the numerator ≈ −3h f′(5) and the limit is −3·(−2) = 6.
Rationales: A: Reversing the order of the terms, this computes the limit of [f(5 + 2h) − f(5 − h)]/h, which is 3f′(5), but the given numerator is f(5 − h) − f(5 + 2h), the opposite. C: This reports f′(5) alone, taking the combination as a single derivative and ignoring that the inputs are 3h apart and in decreasing order. D: This keeps only the −h shift, (−1)(−2), and ignores the 2h shift in the second term, which adds another factor from the same direction.

---

## Seed N-2.2-B (new) — Topic 2.2 Defining the Derivative of a Function and Using Derivative Notation
**Skill:** recognize a limit of the form (g(x) − g(a))/(x² − a²) as a derivative divided by (x + a), evaluating the extra factor.

What is the value of lim as x→e of (ln x − 1)/(x² − e²)?

- A. 1/e
- B. 1/(2e)
- **C. 1/(2e²)**
- D. 1/e²

Check: (ln x − 1)/(x − e) → (ln)′(e) = 1/e and 1/(x + e) → 1/(2e), so the limit is 1/(2e²).
Rationales: A: This is the derivative of ln x at x = e alone; the denominator x² − e² = (x − e)(x + e) contributes an extra factor x + e that tends to 2e. B: The factor x + e tends to 2e, not to 2, so dividing 1/e by 2 leaves out the e in the denominator. D: This replaces the factor x + e by e instead of 2e, so the second factor is only half of what it should be.

**N-2.2-B-v1.** What is the value of lim as x→1 of (eˣ − e)/(x² − 1)?

- A. e
- B. 2e
- C. 1/2
- **D. e/2**

Check: (eˣ − e)/(x − 1) → e and 1/(x + 1) → 1/2, so the limit is e/2.
Rationales: A: This is the derivative of eˣ at x = 1 alone; the factor 1/(x + 1) in the denominator still has to be applied and tends to 1/2. B: This multiplies by x + 1 = 2 instead of dividing by it, since x² − 1 = (x − 1)(x + 1) sits in the denominator. C: This takes the derivative of eˣ at 1 to be 1, which is the derivative at 0, and then divides by 2 as required.

**N-2.2-B-v2.** What is the value of lim as x→π/6 of (sin x − 1/2)/(x² − π²/36)?

- A. √3/2
- **B. 3√3/(2π)**
- C. 3/(2π)
- D. √3π/6

Check: (sin x − 1/2)/(x − π/6) → cos(π/6) = √3/2 and 1/(x + π/6) → 3/π, so the limit is 3√3/(2π).
Rationales: A: This is cos(π/6), the derivative of sin x at π/6 alone; it ignores the factor 1/(x + π/6), which tends to 3/π. C: This uses sin(π/6) = 1/2 in place of the derivative cos(π/6) = √3/2, then correctly divides by x + π/6 = π/3. D: This multiplies cos(π/6) by x + π/6 = π/3 instead of dividing by it, so the factor from the denominator is inverted.

**N-2.2-B-v3.** What is the value of lim as x→4 of (√x − 2)/(x² − 16)?

- A. 1/4
- B. 1/16
- **C. 1/32**
- D. 2

Check: (√x − 2)/(x − 4) → 1/(2√4) = 1/4 and 1/(x + 4) → 1/8, so the limit is 1/32.
Rationales: A: This is the derivative of √x at x = 4 alone; the denominator x² − 16 = (x − 4)(x + 4) also supplies a factor 1/8. B: This divides 1/4 by 4, using 4 for the factor x + 4 instead of 4 + 4 = 8. D: This multiplies 1/4 by x + 4 = 8 instead of dividing by it, so the factor from the denominator is inverted.

---

## Seed N-2.3-A (new) — Topic 2.3 Estimating Derivatives of a Function at a Point
**Skill:** use monotonic f′ to place f′ at a point strictly between the adjacent secant slopes, rather than treating the centered estimate as exact.

A differentiable function f has a strictly increasing derivative on [3, 5]. The values f(3) = 10, f(4) = 12.5, and f(5) = 17 are known. Which statement about f′(4) must be true?

- **A. f′(4) is strictly between 2.5 and 4.5.**
- B. f′(4) = 3.5 exactly.
- C. f′(4) > 4.5.
- D. f′(4) < 2.5.

Check: Average slopes are (12.5 − 10)/1 = 2.5 on [3, 4] and (17 − 12.5)/1 = 4.5 on [4, 5]; with f′ increasing, 2.5 < f′(4) < 4.5.
Rationales: B: The centered estimate (17 − 10)/2 = 3.5 is only an approximation; it equals f′(4) only for special functions such as quadratics. C: Increasing f′ makes f′(4) smaller than the average slope on [4, 5], which is 4.5, because f′ keeps growing past x = 4. D: Increasing f′ makes f′(4) larger than the average slope on [3, 4], which is 2.5, because f′ was smaller before x = 4.

**N-2.3-A-v1.** A function f is differentiable and concave down on [1, 3]. The values f(1) = 7, f(2) = 12, and f(3) = 15 are known. Which statement about f′(2) must be true?

- A. f′(2) = 4 exactly.
- B. f′(2) > 5.
- C. f′(2) < 3.
- **D. f′(2) is strictly between 3 and 5.**

Check: Average slopes are 12 − 7 = 5 on [1, 2] and 15 − 12 = 3 on [2, 3]; with f′ decreasing, 3 < f′(2) < 5.
Rationales: A: The centered estimate (15 − 7)/2 = 4 is only an approximation; concave down does not make the central slope exact. B: With f′ decreasing, f′(2) is smaller than the average slope on [1, 2], which is 5, so it cannot exceed 5. C: With f′ decreasing, f′(2) is larger than the average slope on [2, 3], which is 3, so it cannot be smaller than 3.

**N-2.3-A-v2.** A differentiable function f has a strictly increasing derivative on [2, 7]. The values f(2) = 1, f(4) = 5, and f(7) = 17 are known. Which statement about f′(4) must be true?

- **A. f′(4) is strictly between 2 and 4.**
- B. f′(4) = 3.2 exactly.
- C. f′(4) > 4.
- D. f′(4) < 2.

Check: Average slopes are (5 − 1)/2 = 2 on [2, 4] and (17 − 5)/3 = 4 on [4, 7]; with f′ increasing, 2 < f′(4) < 4.
Rationales: B: The quotient (17 − 1)/(7 − 2) = 3.2 is only an estimate, and with the unequal spacing it need not equal f′(4). C: Increasing f′ places f′(4) below the average slope on [4, 7], which is 4, since f′ keeps growing after x = 4. D: Increasing f′ places f′(4) above the average slope on [2, 4], which is 2, since f′ was smaller before x = 4.

**N-2.3-A-v3.** The price index P(t) is differentiable and is increasing at an increasing rate on [0, 6]. The values P(0) = 20, P(2) = 26, and P(6) = 50 are known. Which statement about P′(2) must be true?

- A. P′(2) = 5 exactly.
- B. P′(2) > 6.
- C. P′(2) < 3.
- **D. P′(2) is strictly between 3 and 6.**

Check: Average rates are (26 − 20)/2 = 3 on [0, 2] and (50 − 26)/4 = 6 on [2, 6]; with P′ increasing, 3 < P′(2) < 6.
Rationales: A: The quotient (50 − 20)/6 = 5 is the average rate over all of [0, 6], not the instantaneous rate at t = 2. B: Because P′ is increasing, P′(2) lies below the average rate on [2, 6], which is 6, not above it. C: Because P′ is increasing, P′(2) lies above the average rate on [0, 2], which is 3, not below it.

---

## Seed N-2.3-B (new) — Topic 2.3 Estimating Derivatives of a Function at a Point
**Skill:** estimate the derivative of a linear combination of two tabulated functions by applying the same difference quotient to the combination, keeping coefficients and signs.

Differentiable functions f and g have the values f(3) = 9, f(5) = 15, g(3) = 4, g(5) = 8 (x = 3 and x = 5 are the table inputs closest to 4 on either side). Let h(x) = f(x) − 2g(x). Estimate h′(4) with a difference quotient built from these values.

- A. 1
- B. −2
- C. 7
- **D. −1**

Check: h(3) = 9 − 8 = 1 and h(5) = 15 − 16 = −1, so h′(4) ≈ (−1 − 1)/(5 − 3) = −1.
Rationales: A: This subtracts the derivative estimates without the factor 2: f′ ≈ 3 and g′ ≈ 2 give 3 − 2, but the coefficient of g is 2. B: The change h(5) − h(3) = −1 − 1 = −2 is correct but is a change, not a rate; dividing by the width 2 gives −1. C: This adds 2g′ ≈ 4 to f′ ≈ 3, using the wrong sign for the subtracted function.

**N-2.3-B-v1.** Differentiable functions f and g have the values f(5) = 11, f(9) = 31, g(5) = 20, g(9) = 12 (x = 5 and x = 9 are the table inputs closest to 6 on either side). Let h(x) = 2f(x) + g(x). Estimate h′(6) with a difference quotient built from these values.

- A. 3
- **B. 8**
- C. 32
- D. 12

Check: h(5) = 22 + 20 = 42 and h(9) = 62 + 12 = 74, so h′(6) ≈ (74 − 42)/4 = 8.
Rationales: A: This forgets the coefficient 2 on f: f′ ≈ 5 and g′ ≈ −2 give 5 + (−2) = 3, but h = 2f + g gives 2·5 + (−2). C: The change h(9) − h(5) = 2·20 + (−8) = 32 is correct but is a total change; dividing by the width 4 gives the rate. D: This subtracts g′ ≈ −2 from 2f′ ≈ 10, which gives 12, but h = 2f + g adds g.

**N-2.3-B-v2.** Cumulative amounts f(t) and g(t) are differentiable. The table values are f(6) = 18, f(12) = 36, g(6) = 15, g(12) = 21 (t = 6 and t = 12 are the table inputs closest to 10 on either side). Let h(t) = f(t) − g(t). Estimate h′(10) with a difference quotient built from these values.

- **A. 2**
- B. 4
- C. 12
- D. 3

Check: h(6) = 18 − 15 = 3 and h(12) = 36 − 21 = 15, so h′(10) ≈ (15 − 3)/6 = 2.
Rationales: B: This adds the rate estimates 3 and 1, but h = f − g subtracts them. C: The change h(12) − h(6) = 18 − 6 = 12 is correct but is a total change; it must be divided by the width 6. D: This estimates only f′ ≈ 3 and omits the contribution of g, which must be subtracted.

**N-2.3-B-v3.** Differentiable functions f and g have the values f(1) = 8, f(3) = 2, g(1) = −1, g(3) = 5 (x = 1 and x = 3 are the table inputs closest to 2 on either side). Let h(x) = 5f(x) − 2g(x). Estimate h′(2) with a difference quotient built from these values.

- A. −6
- B. −9
- C. −42
- **D. −21**

Check: f′ ≈ (2 − 8)/2 = −3 and g′ ≈ (5 − (−1))/2 = 3, so h′(2) ≈ 5(−3) − 2(3) = −21.
Rationales: A: This combines the rate estimates −3 and 3 without the coefficients 5 and 2, so it adds them with the wrong weights. B: This computes 5(−3) + 2(3) = −9, using the wrong sign on the 2g term even though h subtracts it. C: The change h(3) − h(1) = 5(−6) − 2(6) = −42 is correct but is a total change; dividing by the width 2 gives −21.

---

## Seed N-2.4-A (new) — Topic 2.4 Connecting Differentiability and Continuity
**Skill:** identify which function is differentiable at a point by diagnosing corners, cusps, and vertical tangents among similar-looking formulas.

Which of the following functions is differentiable at x = 2?

- **A. f(x) = (x − 2)|x − 2|**
- B. f(x) = |x − 2|
- C. f(x) = (x − 2)^(2/3)
- D. f(x) = (x − 2)^(1/3)

Check: For f(x) = (x − 2)|x − 2| the quotient (f(2 + h) − f(2))/h = |h|, which tends to 0, so f′(2) exists and equals 0.
Rationales: B: This has a corner at x = 2: the one-sided difference quotients are −1 and +1, so the limit does not exist. C: This is continuous but has a cusp at x = 2; the difference quotient h^(−1/3) is unbounded as h approaches 0. D: This is continuous but has a vertical tangent at x = 2; the difference quotient h^(−2/3) grows without bound.

**N-2.4-A-v1.** Which of the following functions is differentiable at x = 0?

- **A. f(x) = x^(4/3)**
- B. f(x) = x^(1/3) + x²
- C. f(x) = |x| + x²
- D. f(x) = x^(2/3) + x

Check: For f(x) = x^(4/3) the quotient (f(h) − f(0))/h = h^(1/3), which tends to 0, so f′(0) = 0 (matching (4/3)x^(1/3) at 0).
Rationales: B: The term x^(1/3) has a vertical tangent at 0, so the difference quotient grows without bound and f is not differentiable. C: The term |x| has a corner at 0, so the one-sided quotients are −1 and +1 and the limit does not exist. D: The term x^(2/3) has a cusp at 0, since its difference quotient h^(−1/3) is unbounded.

**N-2.4-A-v2.** Which of the following piecewise functions is differentiable at x = 0?

- A. f(x) = eˣ for x < 0 and f(x) = 2x + 1 for x ≥ 0
- B. f(x) = eˣ for x < 0 and f(x) = x + 2 for x ≥ 0
- **C. f(x) = eˣ for x < 0 and f(x) = x + 1 for x ≥ 0**
- D. f(x) = eˣ for x < 0 and f(x) = 1 + x² for x ≥ 0

Check: Both pieces equal 1 at 0, and the one-sided derivatives are e⁰ = 1 on the left and 1 on the right, so f′(0) = 1.
Rationales: A: The pieces meet at 1, so f is continuous, but the slopes are 1 from the left and 2 from the right, a corner. B: The left limit is 1 and f(0) = 2, so f is not even continuous at 0, and it cannot be differentiable there. D: The pieces meet at 1, but the slope from the left is 1 and from the right is 0, a corner.

**N-2.4-A-v3.** Which of the following functions is differentiable at x = 0?

- A. f(x) = |sin x|
- **B. f(x) = x|x|**
- C. f(x) = x^(1/3)
- D. f(x) = x^(2/5)

Check: For f(x) = x|x| the quotient (f(h) − f(0))/h = |h|, which tends to 0, so f′(0) = 0.
Rationales: A: Near 0, |sin x| behaves like |x|: the one-sided slopes are −1 and +1, a corner. C: The difference quotient h^(−2/3) grows without bound, so there is a vertical tangent and no derivative. D: The difference quotient h^(−3/5) is unbounded and changes sign across 0, a cusp, so f′(0) does not exist.

---

## Seed N-2.4-B (new) — Topic 2.4 Connecting Differentiability and Continuity
**Skill:** conclude correctly about continuity and differentiability from one-sided information, avoiding the converse and averaging errors.

Let f be a function with f(2) = 5 and lim as x→2 of f(x) = 5. Also, lim as h→0⁺ of [f(2 + h) − 5]/h = 3 and lim as h→0⁻ of [f(2 + h) − 5]/h = −3. Which statement must be true?

- **A. f is continuous at x = 2 but not differentiable at x = 2.**
- B. f is differentiable at x = 2 with f′(2) = 0.
- C. f is not continuous at x = 2.
- D. f is differentiable at x = 2 because f is continuous at x = 2.

Check: Continuity holds since the limit equals f(2); the one-sided derivatives 3 and −3 differ, so f′(2) does not exist.
Rationales: B: Averaging the one-sided slopes 3 and −3 is not how derivatives work; the derivative exists only if the two one-sided limits are equal. C: The values f(2) = 5 and the limit 5 agree, so f is continuous; failing to be differentiable does not imply failing to be continuous. D: Continuity does not imply differentiability; the unequal one-sided slopes 3 and −3 give a corner.

**N-2.4-B-v1.** Let f be a function with f(4) = 1 and lim as x→4 of f(x) = 2. Which statement must be true?

- A. f is continuous at x = 4, but f might not be differentiable there.
- B. f is differentiable at x = 4 because the limit of f(x) exists there.
- C. f could be differentiable at x = 4 even though f is not continuous there.
- **D. f is not differentiable at x = 4.**

Check: The limit 2 differs from f(4) = 1, so f is discontinuous at 4, and a discontinuous function cannot be differentiable there.
Rationales: A: The limit exists but equals 2, while f(4) = 1, so f is not continuous at 4. B: Existence of the limit is not enough; differentiability requires continuity, which needs the limit to equal f(4). C: Differentiability at a point implies continuity there, so a function with a jump at 4 cannot be differentiable at 4.

**N-2.4-B-v2.** Let f be continuous at x = 4, and suppose lim as h→0⁺ of [f(4 + h) − f(4)]/h = 1/4 and lim as h→0⁻ of [f(4 + h) − f(4)]/h = 1/4. Which statement must be true?

- **A. f is differentiable at x = 4 with f′(4) = 1/4.**
- B. f is differentiable at x = 4 with f′(4) = 1/2.
- C. f is not differentiable at x = 4 because continuity alone does not guarantee a derivative.
- D. f is differentiable at x = 4 with f′(4) = 0.

Check: Equal one-sided limits of the difference quotient mean the two-sided limit exists and equals 1/4, so f′(4) = 1/4.
Rationales: B: The derivative is the common value of the one-sided limits, not their sum, so it is 1/4. C: Here the two one-sided limits exist and agree, so the two-sided limit exists, which is the definition of differentiability. D: The limit of the difference quotient is 1/4, not 0; a value of 0 would require both one-sided limits to be 0.

**N-2.4-B-v3.** Let f be continuous at x = 1, and suppose lim as h→0⁺ of [f(1 + h) − f(1)]/h = ∞ and lim as h→0⁻ of [f(1 + h) − f(1)]/h = ∞. Which statement must be true?

- A. f is differentiable at x = 1 with f′(1) = ∞.
- B. f is not continuous at x = 1 because the difference quotient is unbounded.
- **C. f is continuous at x = 1 but not differentiable at x = 1.**
- D. f is differentiable at x = 1 with f′(1) = 0 because the one-sided limits agree.

Check: A difference quotient that tends to infinity means the derivative does not exist (vertical tangent), though f remains continuous.
Rationales: A: A derivative must be a finite number; an infinite limit means a vertical tangent, where f′(1) does not exist. B: Continuity is given in the stem; an unbounded difference quotient indicates a vertical tangent, not a jump. D: Agreement of the one-sided limits only gives differentiability when the common value is a finite real number; here it is infinite.

---

## Seed N-2.5-A (new) — Topic 2.5 Applying the Power Rule
**Skill:** find the point of tangency for a tangent line to a power curve that passes through a given external point, by setting up and solving the tangent-line condition.

The tangent line to the graph of y = 1/x at the point where x = a (a > 0) passes through the point (0, 4). What is a?

- A. 1/3
- **B. 1/2**
- C. 1/4
- D. 2

Check: The tangent at a is y = 1/a − (x − a)/a²; at x = 0 it gives 2/a = 4, so a = 1/2.
Rationales: A: This differentiates 1/x as −1/x, forgetting to lower the exponent to −2, so the tangent slope is −1/a and the equation becomes 1/a + 1 = 4. C: This sets the height of the curve, 1/a, equal to 4, which finds where the curve reaches height 4 and ignores the tangent line altogether. D: The correct equation 2/a = 4 gives a = 1/2; solving it as a = 2 inverts the fraction.

**N-2.5-A-v1.** The tangent line to the graph of y = x^(3/2) at the point where x = a (a > 0) passes through the point (1, 0). What is a?

- **A. 3**
- B. 5/3
- C. 3/5
- D. 1

Check: The tangent at a is y = a^(3/2) + (3/2)a^(1/2)(x − a); at (1, 0) this gives a + (3/2)(1 − a) = 0, so a = 3.
Rationales: B: This differentiates x^(3/2) as (3/2)x^(3/2), forgetting to lower the exponent, so the condition becomes 1 + (3/2)(1 − a) = 0. C: This writes the run from (1, 0) to (a, a^(3/2)) as 1 − a instead of a − 1, a sign slip that turns a/(a − 1) = 3/2 into a/(1 − a) = 3/2. D: This uses the x-coordinate of the given point as the point of tangency, but the tangent at x = 1 is y = (3/2)(x − 1) + 1, which does not pass through (1, 0).

**N-2.5-A-v2.** The tangent line to the graph of y = 1/x at the point where x = a (a > 0) passes through the point (3, 0). What is a?

- **A. 3/2**
- B. 2
- C. 3
- D. 1/3

Check: The tangent at a is y = 1/a − (x − a)/a²; setting y = 0 at x = 3 gives a − (3 − a) = 0, so a = 3/2.
Rationales: B: This differentiates 1/x as −1/x, so the tangent slope is −1/a and the condition becomes 1 − 3 + a = 0. C: This uses the x-coordinate of the given point as the point of tangency, but the tangent at x = 3 passes through (3, 1/3) on the curve, not through (3, 0). D: This sets 1/a = 3, which is where the curve reaches height 3, and does not use the tangent condition.

**N-2.5-A-v3.** The tangent line to the graph of y = ∛x at the point where x = a (a > 0) passes through the point (0, 2). What is a?

- A. 8
- B. 27/8
- **C. 27**
- D. 3

Check: The tangent at a is y = a^(1/3) + (1/3)a^(−2/3)(x − a); at x = 0 it gives (2/3)a^(1/3) = 2, so a^(1/3) = 3 and a = 27.
Rationales: A: This sets the height of the curve ∛a equal to 2, which finds where the curve reaches height 2 and ignores the tangent line. B: This adds the tangent term instead of subtracting it, giving (4/3)∛a = 2 in place of (2/3)∛a = 2. D: This solves (2/3)∛a = 2 correctly for the cube root ∛a = 3 but reports that value instead of a itself.

---

## Seed N-2.5-B (new) — Topic 2.5 Applying the Power Rule
**Skill:** rewrite a product or quotient of radicals as a single power before differentiating, and avoid differentiating each factor separately or mishandling exponents.

Let f(x) = √x · ∛x for x > 0. What is f′(64)?

- A. 1/768
- B. 1/192
- C. 80/3
- **D. 5/12**

Check: f(x) = x^(5/6), so f′(x) = (5/6)x^(−1/6) and f′(64) = (5/6)(1/2) = 5/12.
Rationales: A: This multiplies the two derivatives (1/(2√x))·(1/(3x^(2/3))) instead of using the product rule, giving (1/16)(1/48). B: This multiplies the exponents instead of adding them, writing f(x) = x^(1/6), and then differentiates that. C: This writes f(x) = x^(5/6) correctly but forgets to lower the exponent in the derivative, giving (5/6)x^(5/6) = (5/6)(32).

**N-2.5-B-v1.** Let f(x) = x²/∛x for x > 0. What is f′(8)?

- A. 192
- B. 112/3
- **C. 20/3**
- D. 10/3

Check: f(x) = x^(5/3), so f′(x) = (5/3)x^(2/3) and f′(8) = (5/3)(4) = 20/3.
Rationales: A: This divides the derivative of the numerator by the derivative of the denominator, 2x/((1/3)x^(−2/3)), instead of simplifying or using the quotient rule. B: This adds 1/3 to the exponent 2 instead of subtracting it, writing f(x) = x^(7/3). D: This writes the derivative correctly as (5/3)x^(2/3) but evaluates x^(2/3) at 8 as 2 instead of 4.

**N-2.5-B-v2.** Let f(x) = 1/(x√x) for x > 0. What is f′(4)?

- A. −3/16
- B. 3/64
- **C. −3/64**
- D. 1/256

Check: f(x) = x^(−3/2), so f′(x) = (−3/2)x^(−5/2) and f′(4) = (−3/2)(1/32) = −3/64.
Rationales: A: This differentiates x^(−3/2) as (−3/2)x^(−3/2), forgetting to lower the exponent, which gives (−3/2)(1/8). B: The magnitude is right, but the exponent −3/2 is negative, so the derivative is negative. D: This multiplies the derivatives of the two factors x^(−1) and x^(−1/2) instead of combining them into x^(−3/2).

**N-2.5-B-v3.** Let f(x) = ∛(x²) · √x for x > 0. What is f′(64)?

- **A. 7/3**
- B. 7/6
- C. 1/48
- D. 448/3

Check: f(x) = x^(2/3 + 1/2) = x^(7/6), so f′(x) = (7/6)x^(1/6) and f′(64) = (7/6)(2) = 7/3.
Rationales: B: This forgets the factor x^(1/6) in f′(x) = (7/6)x^(1/6); at x = 64 that factor is 2. C: This multiplies the exponents 2/3 and 1/2 to get x^(1/3), instead of adding them, and then differentiates that. D: This writes f(x) = x^(7/6) but forgets to lower the exponent, giving (7/6)x^(7/6) = (7/6)(128).

---

## Seed N-2.6-A (new) — Topic 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple
**Skill:** find the tangent line to a linear combination of functions from the tangent lines of the pieces, combining slopes and values with the coefficients.

The tangent line to the graph of f at x = 2 is y = 3x − 1, and the tangent line to the graph of g at x = 2 is y = −x + 5. Let h(x) = 2f(x) − g(x). Which is an equation of the tangent line to the graph of h at x = 2?

- **A. y = 7x − 7**
- B. y = 7x − 12
- C. y = 5x − 3
- D. y = 7x − 6

Check: f(2) = 5, f′(2) = 3, g(2) = 3, g′(2) = −1, so h(2) = 7 and h′(2) = 6 + 1 = 7; the tangent is y − 7 = 7(x − 2).
Rationales: B: The slope 7 is right, but this uses h(2) = f(2) − g(2) = 2 and forgets to double f(2) = 5. C: This computes the slope as 2(3) − 1 = 5, using g′(2) = −1 with the wrong sign for a subtracted function. D: This doubles the 3x in f's tangent line but not its constant −1, writing 2(3x) − 1 − (−x + 5).

**N-2.6-A-v1.** The tangent line to the graph of f at x = 3 is y = −2x + 9, and the tangent line to the graph of g at x = 3 is y = x − 1. Let h(x) = 3f(x) + 2g(x). Which is an equation of the tangent line to the graph of h at x = 3?

- A. y = −5x + 28
- **B. y = −4x + 25**
- C. y = −4x + 17
- D. y = −x + 8

Check: f(3) = 3, f′(3) = −2, g(3) = 2, g′(3) = 1, so h(3) = 13 and h′(3) = −6 + 2 = −4; the tangent is y − 13 = −4(x − 3).
Rationales: A: This forgets to double g′(3): 3(−2) + 1 = −5 gives the slope, and the line is then built through (3, 13). C: The slope −4 is right, but this uses h(3) = f(3) + g(3) = 5 and ignores the coefficients 3 and 2 on the values. D: This adds the two tangent line equations without the coefficients, (−2x + 9) + (x − 1).

**N-2.6-A-v2.** The tangent line to the graph of f at x = 1 is y = 4x + 2, and the tangent line to the graph of g at x = 1 is y = −2x + 3. Let h(x) = f(x) − 3g(x) + x². Which is an equation of the tangent line to the graph of h at x = 1?

- A. y = 10x − 6
- B. y = 12x − 9
- **C. y = 12x − 8**
- D. y = 4

Check: f(1) = 6, f′(1) = 4, g(1) = 1, g′(1) = −2, so h(1) = 6 − 3 + 1 = 4 and h′(1) = 4 + 6 + 2 = 12; the tangent is y − 4 = 12(x − 1).
Rationales: A: This treats x² as a constant in the derivative, so the 2x term is left out and the slope is 4 + 6 = 10. B: The slope 12 is right, but this uses h(1) = f(1) − 3g(1) = 3 and leaves out the value 1² = 1. D: This adds 3g′(1) instead of subtracting it, so the slope becomes 4 − 6 + 2 = 0.

**N-2.6-A-v3.** The tangent line to the graph of f at x = 0 is y = 2x + 1, and the tangent line to the graph of g at x = 0 is y = −x + 4. Let h(x) = g(x) − 2f(x) + 3eˣ. Which is an equation of the tangent line to the graph of h at x = 0?

- **A. y = −2x + 5**
- B. y = 5
- C. y = 6x + 5
- D. y = −2x + 2

Check: f(0) = 1, f′(0) = 2, g(0) = 4, g′(0) = −1, so h(0) = 4 − 2 + 3 = 5 and h′(0) = −1 − 4 + 3 = −2; the tangent is y = −2x + 5.
Rationales: B: This forgets to double f′(0): the slope becomes −1 − 2 + 3 = 0 instead of −1 − 4 + 3 = −2. C: This adds 2f′(0) instead of subtracting it, so the slope becomes −1 + 4 + 3 = 6. D: The slope is right, but this leaves out the 3e⁰ = 3 in h(0), using h(0) = g(0) − 2f(0) = 2.

---

## Seed N-2.6-B (new) — Topic 2.6 Derivative Rules: Constant, Sum, Difference, and Constant Multiple
**Skill:** use f′ = c·g′ (or f′ = g′ + k) to conclude that a related combination of f and g is constant, rather than that f and g are equal.

The functions f and g are differentiable for all real x, and f′(x) = g′(x) for all x. Which statement must be true?

- A. f(x) = g(x) for all x.
- **B. f(x) − g(x) is constant.**
- C. f and g have the same zeros.
- D. f(0) = g(0).

Check: (f − g)′ = f′ − g′ = 0 for all x, so f − g is constant, but that constant need not be 0.
Rationales: A: Functions with the same derivative can differ by a vertical shift; for example f(x) = x² and g(x) = x² + 1. C: A vertical shift moves the zeros; x² has a zero at 0, but x² + 1 has none. D: Equal derivatives do not force equal values at any point, for example f(x) = x and g(x) = x + 5.

**N-2.6-B-v1.** The functions f and g are differentiable for all real x, and f′(x) = g′(x) + 3 for all x. Which statement must be true?

- A. f(x) = g(x) + 3 for all x.
- **B. f(x) − g(x) − 3x is constant.**
- C. f(x) − g(x) is constant.
- D. f(x) = g(x) + 3x for all x.

Check: (f − g − 3x)′ = f′ − g′ − 3 = 0 for all x, so f(x) − g(x) − 3x is constant.
Rationales: A: The derivative of g(x) + 3 is g′(x), not g′(x) + 3, so adding the constant 3 to g does not produce the extra 3 in the derivative. C: The difference f − g has derivative 3, not 0, so it changes at a constant rate rather than staying constant. D: This is the right growth rate, but it omits the possible constant: f(x) = g(x) + 3x + 7 also has f′ = g′ + 3.

**N-2.6-B-v2.** The functions f and g are differentiable for all real x, and f′(x) = 2g′(x) for all x. Which statement must be true?

- A. f(x) = 2g(x) for all x.
- B. f(x) − g(x) is constant.
- C. f(0) = 2g(0).
- **D. f(x) − 2g(x) is constant.**

Check: (f − 2g)′ = f′ − 2g′ = 0 for all x, so f(x) − 2g(x) is constant.
Rationales: A: Equal derivatives of f and 2g allow a constant offset, for example g(x) = x and f(x) = 2x + 1. B: The difference f − g has derivative 2g′ − g′ = g′, which is not zero in general. C: Doubling the derivative does not force the values to match at any point, as with g(x) = x and f(x) = 2x + 1.

**N-2.6-B-v3.** The functions f and g are differentiable for all real x, and f′(x) = −g′(x) for all x. Which statement must be true?

- A. f(x) = −g(x) for all x.
- B. f(x) − g(x) is constant.
- C. f(x)·g(x) is constant.
- **D. f(x) + g(x) is constant.**

Check: (f + g)′ = f′ + g′ = 0 for all x, so f(x) + g(x) is constant.
Rationales: A: Opposite derivatives allow a constant offset, for example f(x) = x and g(x) = −x + 4. B: The difference f − g has derivative f′ + f′ = 2f′, which is not zero in general. C: Opposite derivatives say nothing about products; f(x) = x and g(x) = −x give a product −x², which is not constant.

---

## Seed N-2.7-A (new) — Topic 2.7 Derivatives of cos x, sin x, e^x, and ln x
**Skill:** find the slope of a tangent line to y = ln x or y = eˣ that passes through a given external point, by solving the tangent-line condition for the point of tangency.

A line through the origin is tangent to the graph of y = ln x. What is the slope of this line?

- A. 1
- **B. 1/e**
- C. e
- D. 1/(e − 1)

Check: The tangent at a is y = ln a + (x − a)/a; passing through (0, 0) gives ln a = 1, so a = e and the slope is 1/e.
Rationales: A: This is the slope of the tangent at x = 1, where the curve meets the x-axis, but that line does not pass through the origin. C: This reports the point of tangency x = e, found from ln a − 1 = 0, instead of the slope 1/a at that point. D: This is the slope of the line through (1, 0) and (e, 1), which uses the x-intercept instead of the origin and is not tangent.

**N-2.7-A-v1.** A line through the point (2, 0) is tangent to the graph of y = eˣ. What is the slope of this line?

- A. e²
- B. e
- **C. e³**
- D. 3

Check: The tangent at a is y = eᵃ + eᵃ(x − a); passing through (2, 0) gives 1 + 2 − a = 0, so a = 3 and the slope is e³.
Rationales: A: This is the slope of the tangent at x = 2, but that line is y = e²(x − 1) and does not pass through (2, 0). B: This reverses (x − a) as (a − x) in the tangent equation, giving 1 + (a − 2) = 0 and a = 1. D: This reports the point of tangency a = 3 instead of the slope e^a = e³.

**N-2.7-A-v2.** A line through the point (0, −2) is tangent to the graph of y = ln x. What is the slope of this line?

- A. 1/e
- B. e²
- C. 1/e²
- **D. e**

Check: The tangent at a is y = ln a + (x − a)/a; at x = 0 it gives ln a − 1 = −2, so a = 1/e and the slope is 1/a = e.
Rationales: A: This reports the point of tangency a = 1/e instead of the slope 1/a = e. B: This sets ln a = −2 and ignores the −1 contributed by the tangent term, giving a = e⁻² and slope e². C: This reports the point a = e⁻² from setting ln a = −2, not the slope, and it also drops the −1 from the tangent term.

**N-2.7-A-v3.** A line through the point (−2, 0) is tangent to the graph of y = eˣ. What is the slope of this line?

- **A. 1/e**
- B. e⁻²
- C. −1
- D. e

Check: The tangent at a is y = eᵃ + eᵃ(x − a); at (−2, 0) it gives 1 + (−2 − a) = 0, so a = −1 and the slope is e⁻¹.
Rationales: B: This is the slope of the tangent at x = −2 itself, but that line does not pass through (−2, 0) because it meets the curve there. C: This reports the point of tangency a = −1 instead of the slope e^a = 1/e. D: This writes 1 + (−2 + a) = 0 with a sign slip on a, giving a = 1 and slope e instead of a = −1 and slope 1/e.

---

## Seed N-2.7-B (new) — Topic 2.7 Derivatives of cos x, sin x, e^x, and ln x
**Skill:** evaluate a high-order derivative of sin x, cos x, and eˣ by identifying the cycle of length four and the remainder of the order.

Let f(x) = sin x. What is the 2025th derivative of f at x = π/3?

- A. √3/2
- **B. 1/2**
- C. −√3/2
- D. −1/2

Check: The derivatives of sin x cycle sin, cos, −sin, −cos; 2025 = 4·506 + 1, so f^(2025)(x) = cos x and the value is cos(π/3) = 1/2.
Rationales: A: This treats 2025 as a multiple of 4, where the derivative returns to sin x, but 2025 leaves remainder 1, which gives cos x. C: This uses the cycle position for remainder 2, which gives −sin x, but 2025 leaves remainder 1. D: This uses the cycle position for remainder 3, which gives −cos x, but 2025 leaves remainder 1.

**N-2.7-B-v1.** Let f(x) = cos x. What is the 43rd derivative of f at x = π/6?

- A. −1/2
- **B. 1/2**
- C. √3/2
- D. −√3/2

Check: The derivatives of cos x cycle cos, −sin, −cos, sin; 43 = 4·10 + 3, so f^(43)(x) = sin x and the value is sin(π/6) = 1/2.
Rationales: A: This takes the 43rd derivative as −sin x, the first derivative in the cycle, but 43 = 4·10 + 3 gives sin x. C: This treats 43 as a multiple of 4, where the derivative returns to cos x, but 43 leaves remainder 3. D: This uses the cycle position for remainder 2, which gives −cos x, but 43 leaves remainder 3.

**N-2.7-B-v2.** Let f(x) = 2cos x + 5eˣ. What is the 102nd derivative of f at x = 0?

- **A. 3**
- B. 7
- C. 5
- D. −2

Check: 102 = 4·25 + 2, so the cosine term gives −2cos x, and 5eˣ stays 5eˣ; at 0 the value is −2 + 5 = 3.
Rationales: B: This treats 102 as a multiple of 4, where 2cos x returns to itself with value 2, but 102 leaves remainder 2 and gives −2cos x. C: This drops the contribution of the cosine term, as happens at an odd order, but 102 is even and gives −2cos 0 = −2. D: This differentiates the cosine term correctly but treats 5eˣ as vanishing, when every derivative of eˣ is eˣ and contributes 5e⁰ = 5.

**N-2.7-B-v3.** Let f(x) = 2 sin x − cos x. What is the 7th derivative of f at x = π?

- A. −2
- B. 1
- **C. 2**
- D. −1

Check: 7 = 4 + 3, so f^(7) is the third derivative: (2 sin x)‴ = −2cos x and (−cos x)‴ = −sin x; at π this is 2 − 0 = 2.
Rationales: A: This uses the first derivative of f, 2cos x + sin x, whose value at π is −2, but 7 = 4 + 3 requires the third derivative. B: This treats 7 as a multiple of 4, where f returns to itself with value 2 sin π − cos π = 1, but 7 leaves remainder 3. D: This uses the second derivative of f, −2 sin x + cos x, whose value at π is −1, but 7 leaves remainder 3.

---

## Seed N-2.8-A (new) — Topic 2.8 The Product Rule
**Skill:** differentiate a product of three factors, one given only by table values, tracking every term of the product rule.

Differentiable functions f and g satisfy f(2) = 3, f′(2) = −1, g(2) = 2, and g′(2) = 4. Let h(x) = x·f(x)·g(x). What is h′(2)?

- A. 20
- B. −4
- **C. 26**
- D. 16

Check: h′ = f g + x f′ g + x f g′ = 6 + 2(−1)(2) + 2(3)(4) = 6 − 4 + 24 = 26.
Rationales: A: This leaves out the term from differentiating the factor x, which contributes f(2)g(2) = 6. B: This multiplies the three derivatives, 1·(−1)·4, instead of using the product rule. D: This keeps all three terms but drops the multiplying factor x = 2 from the two terms that keep x: 6 − 2 + 12.

**N-2.8-A-v1.** Differentiable functions f and g satisfy f(ln 2) = 2, f′(ln 2) = 3, g(ln 2) = −1, and g′(ln 2) = 5. Let h(x) = eˣ·f(x)·g(x). What is h′(ln 2)?

- A. 14
- B. 30
- **C. 10**
- D. 12

Check: h′ = eˣ(f g + f′g + f g′) = 2(−2 − 3 + 10) = 10 at x = ln 2.
Rationales: A: This leaves out the term from differentiating eˣ, which contributes eˣf g, so only the terms with f′ and g′ remain. B: This multiplies the three derivatives, e^(ln 2)·3·5, instead of using the product rule. D: This treats the derivative of eˣ as 1 instead of eˣ, so the first term is f g = −2 rather than eˣ f g = −4.

**N-2.8-A-v2.** Differentiable functions f and g satisfy f(1) = 4, f′(1) = 2, g(1) = 3, and g′(1) = −2. Let h(x) = (f(x) + x)(g(x) − x²). What is h′(1)?

- A. −12
- B. −6
- C. 26
- **D. −14**

Check: (f + x) = 5 with derivative 3, and (g − x²) = 2 with derivative −2 − 2 = −4, so h′(1) = 3·2 + 5·(−4) = −14.
Rationales: A: This multiplies the derivatives of the two factors, (f′ + 1)(g′ − 2x) = 3·(−4), instead of using the product rule. B: This differentiates the two factors without the terms from x and x², so it uses f′ and g′ alone. C: This subtracts the second product-rule term instead of adding it, 3·2 − 5·(−4).

**N-2.8-A-v3.** Differentiable functions f and g satisfy f(π) = 2, f′(π) = 4, g(π) = −3, and g′(π) = 5. Let h(x) = sin x·f(x)·g(x). What is h′(π)?

- A. −6
- B. −2
- C. −20
- **D. 6**

Check: Since sin π = 0, only the term from differentiating sin x survives: h′(π) = cos π · f(π)·g(π) = (−1)(2)(−3) = 6.
Rationales: A: This uses cos π = +1 in the only surviving term, but cos π = −1. B: This differentiates only the product f·g, giving f′g + fg′, and ignores the factor sin x entirely. C: This multiplies the derivatives cos π, f′, and g′, instead of using the product rule.

---

## Seed N-2.8-B (new) — Topic 2.8 The Product Rule
**Skill:** locate horizontal tangent lines of a product by solving f′ = 0, separating critical points from zeros of f and from errors in the product rule.

For 0 < x ≤ π, at what value of x does the graph of f(x) = eˣ sin x have a horizontal tangent line?

- A. π/4
- **B. 3π/4**
- C. π/2
- D. π

Check: f′(x) = eˣ(sin x + cos x) = 0 gives tan x = −1, so x = 3π/4 on (0, π].
Rationales: A: This uses f′(x) = eˣ(cos x − sin x), a sign error in the product rule, which gives tan x = 1. C: This multiplies the derivatives eˣ and cos x instead of using the product rule, so it solves cos x = 0. D: This solves f(x) = 0 instead of f′(x) = 0; the zeros of f are not where its tangent is horizontal.

**N-2.8-B-v1.** For 0 < x ≤ π, at what value of x does the graph of f(x) = eˣ cos x have a horizontal tangent line?

- **A. π/4**
- B. 3π/4
- C. π/2
- D. π

Check: f′(x) = eˣ(cos x − sin x) = 0 gives tan x = 1, so x = π/4 on (0, π].
Rationales: B: This writes f′(x) = eˣ(cos x + sin x), a sign error in the derivative of cos x, which gives tan x = −1. C: This solves f(x) = 0 instead of f′(x) = 0. D: This multiplies the derivatives eˣ and −sin x instead of using the product rule, giving sin x = 0.

**N-2.8-B-v2.** For x > 0, at what value of x does the graph of f(x) = x² ln x have a horizontal tangent line?

- A. 1
- **B. e^(−1/2)**
- C. e^(−1)
- D. e^(1/2)

Check: f′(x) = 2x ln x + x²(1/x) = x(2 ln x + 1) = 0 gives ln x = −1/2, so x = e^(−1/2).
Rationales: A: This solves f(x) = 0 instead of f′(x) = 0; the zero of x² ln x is x = 1, where the tangent slope is 1. C: This solves 2 ln x + 1 = 0 as ln x = −1, forgetting to divide by 2. D: This solves 2 ln x + 1 = 0 as ln x = 1/2, a sign slip when isolating ln x.

**N-2.8-B-v3.** At which values of x does the graph of f(x) = x²eˣ have a horizontal tangent line?

- A. x = −2 only
- B. x = 0 and x = 2
- **C. x = 0 and x = −2**
- D. x = 0 only

Check: f′(x) = 2xeˣ + x²eˣ = x(x + 2)eˣ, which is 0 at x = 0 and x = −2.
Rationales: A: This discards x = 0, but f′(x) = eˣ(x² + 2x) = x(x + 2)eˣ is also 0 at x = 0. B: This factors x² + 2x as x(x − 2), a sign error, instead of x(x + 2). D: This multiplies the derivatives 2x and eˣ instead of using the product rule, which gives only x = 0.

---

## Seed N-2.9-A (new) — Topic 2.9 The Quotient Rule
**Skill:** apply the quotient rule when the numerator or denominator is itself a sum or product involving values of f, g, f′, g′, tracking every term and the order of subtraction.

Differentiable functions f and g satisfy f(2) = 3, f′(2) = −1, g(2) = 4, and g′(2) = 2. Let h(x) = f(x)/(x + g(x)). What is h′(2)?

- A. −1/3
- **B. −5/12**
- C. 5/12
- D. −5/2

Check: h′ = (f′(x + g) − f(1 + g′))/(x + g)² = (−1·6 − 3·3)/36 = −15/36 = −5/12.
Rationales: A: This differentiates the denominator as g′(2) = 2 instead of 1 + g′(2) = 3, leaving out the derivative of x. C: This subtracts in the wrong order, using (numerator)(derivative of denominator) minus (derivative of numerator)(denominator). D: This leaves out the square of the denominator and divides by x + g(x) = 6 instead of by 36.

**N-2.9-A-v1.** Differentiable functions f and g satisfy f(1) = 3, f′(1) = −2, g(1) = 2, and g′(1) = 4. Let h(x) = (x² + f(x))/g(x). What is h′(1)?

- A. −5
- B. 4
- C. −8
- **D. −4**

Check: Numerator N = 1 + 3 = 4, N′ = 2 − 2 = 0, so h′ = (0·2 − 4·4)/2² = −16/4 = −4.
Rationales: A: This differentiates the numerator as f′(1) = −2, leaving out the derivative 2x = 2 of x². B: This subtracts in the wrong order: (numerator)(g′) − (numerator′)(g). C: This leaves out the square of the denominator and divides by g(1) = 2 instead of by 4.

**N-2.9-A-v2.** Differentiable functions f and g satisfy f(3) = 2, f′(3) = 1, g(3) = 4, and g′(3) = −2. Let h(x) = x·f(x)/g(x). What is h′(3)?

- A. 5/4
- B. 1
- **C. 2**
- D. 1/2

Check: N = x f = 6 and N′ = f + x f′ = 5, so h′ = (5·4 − 6·(−2))/16 = 32/16 = 2.
Rationales: A: This differentiates the numerator as f(3) alone, leaving out the term x f′ from the product rule. B: This differentiates the numerator as f′(3) alone, treating x f(x) as if only f changed. D: This subtracts with the wrong sign, (20 − 12)/16, instead of 20 − (6)(−2) = 32 in the numerator.

**N-2.9-A-v3.** Differentiable functions f and g satisfy f(1) = 3, f′(1) = 5, g(1) = −4, and g′(1) = 3. Let h(x) = g(x)/(f(x) − x). What is h′(1)?

- A. 13/2
- B. −5/2
- **C. 11/2**
- D. −11/2

Check: D = f − x = 2 and D′ = 5 − 1 = 4, so h′ = (g′D − gD′)/D² = (3·2 − (−4)(4))/4 = 22/4 = 11/2.
Rationales: A: This differentiates the denominator as f′(1) = 5, leaving out the derivative of x, which is 1. B: This subtracts with the wrong sign, 6 − 16 instead of 6 + 16, mishandling g(−4) times the denominator derivative. D: This subtracts in the wrong order, (numerator)(derivative of denominator) − (derivative of numerator)(denominator).

---

## Seed N-2.9-B (new) — Topic 2.9 The Quotient Rule
**Skill:** reverse the quotient rule: from a given tangent-slope condition on f/g (or g/f or xf/g) solve for an unknown derivative value.

Differentiable functions f and g satisfy f(a) = 6, g(a) = 3, and f′(a) = 4, with g(a) ≠ 0. The graph of h(x) = f(x)/g(x) has a horizontal tangent line at x = a. What is g′(a)?

- **A. 2**
- B. 4
- C. 8
- D. −2

Check: h′(a) = (f′g − fg′)/g² = 0 gives 4·3 − 6g′ = 0, so g′(a) = 2.
Rationales: B: This assumes f′(a) = g′(a), but a horizontal tangent for f/g requires f′g = fg′, not equal derivatives. C: This inverts the ratio, g′ = f′ f/g = 4·6/3, instead of f′ g/f = 4·3/6. D: This sets the numerator f′g + fg′ equal to 0, a sign error, instead of f′g − fg′ = 0.

**N-2.9-B-v1.** Differentiable functions f and g satisfy f(a) = 2, g(a) = −2, and f′(a) = 5. The graph of h(x) = f(x)/g(x) has a tangent line of slope 3 at x = a. What is g′(a)?

- **A. −11**
- B. 11
- C. −2
- D. −13/2

Check: (5(−2) − 2g′)/(−2)² = 3 gives −10 − 2g′ = 12, so g′(a) = −11.
Rationales: B: This writes the numerator as f′g + fg′ with the wrong sign when solving, so it gets +11. C: This sets the numerator equal to 3g(a) = −6 instead of 3g(a)² = 12, dividing by g once instead of squaring it. D: This sets the numerator equal to 3 instead of 3g(a)² = 12, leaving out the square of the denominator.

**N-2.9-B-v2.** Differentiable functions f and g satisfy f(a) = 5, g(a) = −10, and g′(a) = −4. The graph of h(x) = g(x)/f(x) has a horizontal tangent line at x = a. What is f′(a)?

- A. −4
- **B. 2**
- C. 8
- D. −2

Check: h′(a) = (g′f − gf′)/f² = 0 gives (−4)(5) − (−10)f′ = 0, so f′(a) = 2.
Rationales: A: This assumes f′(a) = g′(a), but a horizontal tangent for g/f requires g′f = gf′, not equal derivatives. C: This inverts the ratio, f′ = g′g/f = (−4)(−10)/5, instead of g′f/g = (−4)(5)/(−10). D: This sets g′f + gf′ = 0, a sign error, instead of g′f − gf′ = 0.

**N-2.9-B-v3.** Differentiable functions f and g satisfy f(2) = 3, g(2) = 6, and g′(2) = 4. The graph of h(x) = x f(x)/g(x) has a horizontal tangent line at x = 2. What is f′(2)?

- **A. 1/2**
- B. 4
- C. 2
- D. −7/2

Check: N = x f = 6, N′ = f + x f′ = 3 + 2f′; h′ = 0 gives N′g = N g′, so (3 + 2f′)6 = 6·4 and f′(2) = 1/2.
Rationales: B: This treats the numerator derivative as f′(2) alone, so it solves f′·g = (x f)·g′ and ignores the term f from the product rule. C: This treats the numerator derivative as x f′ alone, leaving out the term f(2) = 3 from the product rule. D: This sets the numerator equal to −(x f)g′, a sign error that turns 3 + 2f′ = 4 into 3 + 2f′ = −4.

---

## Seed N-2.10-A (new) — Topic 2.10 Derivatives of tan x, cot x, sec x, and csc x
**Skill:** write and use the tangent line to y = sec x, csc x, cot x, or tan x at a point to find where that line crosses the x-axis.

What is the x-intercept of the line tangent to the graph of y = sec x at x = π/3?

- A. π/3 + √3/3
- B. π/3 − 1/2
- C. π/3 − 2√3
- **D. π/3 − √3/3**

Check: At π/3, y = 2 and y′ = sec x tan x = 2√3, so 0 = 2 + 2√3(x − π/3) gives x = π/3 − 1/√3 = π/3 − √3/3.
Rationales: A: This reverses the sign: the tangent has positive slope 2√3 at a positive height 2, so it crosses the axis to the left of π/3. B: This uses the slope sec² x = 4 instead of sec x tan x = 2√3, treating the derivative of sec x as that of tan x. C: This uses the slope 2√3 as the horizontal shift instead of dividing the height 2 by the slope.

**N-2.10-A-v1.** What is the x-intercept of the line tangent to the graph of y = csc x at x = π/6?

- A. π/6 − √3/3
- B. π/6 + 1/2
- C. π/6 + 2√3
- **D. π/6 + √3/3**

Check: At π/6, y = 2 and y′ = −csc x cot x = −2√3, so 0 = 2 − 2√3(x − π/6) gives x = π/6 + 1/√3 = π/6 + √3/3.
Rationales: A: This uses the slope +csc x cot x, forgetting the minus sign, so the line crosses on the wrong side. B: This uses the slope −csc² x = −4 instead of −csc x cot x = −2√3, treating the derivative of csc x as that of cot x. C: This uses the magnitude of the slope as the horizontal shift instead of dividing the height 2 by the slope.

**N-2.10-A-v2.** What is the x-intercept of the line tangent to the graph of y = cot x at x = π/4?

- **A. π/4 + 1/2**
- B. π/4 − 1/2
- C. π/4 + √2/2
- D. π/4 + 2

Check: At π/4, y = 1 and y′ = −csc² x = −2, so 0 = 1 − 2(x − π/4) gives x = π/4 + 1/2.
Rationales: B: This uses the slope +csc² x = 2, forgetting the minus sign in the derivative of cot x. C: This uses the slope −csc x cot x = −√2, treating the derivative of cot x as that of csc x. D: This uses the magnitude of the slope as the horizontal shift instead of dividing the height 1 by the slope.

**N-2.10-A-v3.** What is the x-intercept of the line tangent to the graph of y = tan x at x = π/3?

- A. π/3 + √3/4
- **B. π/3 − √3/4**
- C. π/3 − 1/2
- D. π/3 − 4√3

Check: At π/3, y = √3 and y′ = sec² x = 4, so 0 = √3 + 4(x − π/3) gives x = π/3 − √3/4.
Rationales: A: This reverses the sign: the tangent has positive slope 4 at a positive height √3, so it crosses to the left of π/3. C: This uses the slope sec x tan x = 2√3 instead of sec² x = 4, treating the derivative of tan x as that of sec x. D: This multiplies the height √3 by the slope 4 instead of dividing, so the shift is 4√3.

---

## Seed N-2.10-B (new) — Topic 2.10 Derivatives of tan x, cot x, sec x, and csc x
**Skill:** simplify a product of trigonometric functions with an identity before differentiating, and recognize product-rule sign and product-of-derivatives errors.

Let f(x) = tan x · cos x for 0 < x < π/2. What is f′(π/3)?

- A. 7/2
- B. −2√3
- C. √3/2
- **D. 1/2**

Check: tan x cos x = sin x, so f′(x) = cos x and f′(π/3) = 1/2; the product rule gives the same, 2 − 3/2.
Rationales: A: This applies the product rule with the wrong sign, sec² x cos x + tan x sin x, instead of sec² x cos x − tan x sin x. B: This multiplies the derivatives sec² x and −sin x instead of using the product rule. C: This simplifies tan x cos x to sin x correctly but then differentiates sin x as sin x instead of cos x.

**N-2.10-B-v1.** Let f(x) = cot x · sin x for 0 < x < π. What is f′(π/6)?

- A. −2√3
- B. −7/2
- C. 1/2
- **D. −1/2**

Check: cot x sin x = cos x, so f′(x) = −sin x and f′(π/6) = −1/2; the product rule gives −2 + 3/2 = −1/2.
Rationales: A: This multiplies the derivatives −csc² x and cos x instead of using the product rule. B: This applies the product rule with the wrong sign, −csc² x sin x − cot x cos x, instead of adding cot x cos x. C: This simplifies cot x sin x to cos x correctly but then differentiates cos x as sin x, missing the minus sign.

**N-2.10-B-v2.** Let f(x) = sec x · cot x for 0 < x < π/2. What is f′(π/4)?

- A. −2√2
- B. √2
- C. 3√2
- **D. −√2**

Check: sec x cot x = csc x, so f′(x) = −csc x cot x and f′(π/4) = −√2; the product rule gives √2 − 2√2.
Rationales: A: This multiplies the derivatives sec x tan x and −csc² x instead of using the product rule. B: This simplifies sec x cot x to csc x correctly but then differentiates csc x without the minus sign. C: This applies the product rule with the wrong sign, sec x tan x cot x − sec x(−csc² x), so the two terms add instead of partially cancelling.

**N-2.10-B-v3.** Let f(x) = csc x · tan x for 0 < x < π/2. What is f′(π/3)?

- A. −8/3
- **B. 2√3**
- C. 4
- D. −10√3/3

Check: csc x tan x = sec x, so f′(x) = sec x tan x and f′(π/3) = 2√3; the product rule gives −2/√3 + 8/√3 = 6/√3 = 2√3.
Rationales: A: This multiplies the derivatives −csc x cot x and sec² x instead of using the product rule. C: This simplifies csc x tan x to sec x correctly but then differentiates sec x as sec² x instead of sec x tan x. D: This applies the product rule with the wrong sign, so the two terms −2/√3 and 8/√3 are both taken negative.

---
