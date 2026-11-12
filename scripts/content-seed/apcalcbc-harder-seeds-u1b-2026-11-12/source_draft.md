# AP Calculus BC topics 1.9 to 1.16: harder seed drafts (Unit 1, second half)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (exact fractions, numerical limits, sign tests).
Scope: 16 new seeds, 64 items, two per topic 1.9 to 1.16, mostly R3 (interpretation, multi-step reasoning, error analysis). Emphasis on one-sided limits of combined functions, oscillation traps in tables, classification of discontinuities with ln/exp/inverse-trig, definitions of continuity, parameter matching in piecewise functions, indeterminate-form cancellation, limits at infinity with exponentials and radicals, and what the Intermediate Value Theorem does and does not guarantee.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.9-A | 1.9 Connecting Multiple Representations of Limits | new |
| N-1.9-B | 1.9 Connecting Multiple Representations of Limits | new |
| N-1.10-A | 1.10 Exploring Types of Discontinuities | new |
| N-1.10-B | 1.10 Exploring Types of Discontinuities | new |
| N-1.11-A | 1.11 Defining Continuity at a Point | new |
| N-1.11-B | 1.11 Defining Continuity at a Point | new |
| N-1.12-A | 1.12 Confirming Continuity over an Interval | new |
| N-1.12-B | 1.12 Confirming Continuity over an Interval | new |
| N-1.13-A | 1.13 Removing Discontinuities | new |
| N-1.13-B | 1.13 Removing Discontinuities | new |
| N-1.14-A | 1.14 Connecting Infinite Limits and Vertical Asymptotes | new |
| N-1.14-B | 1.14 Connecting Infinite Limits and Vertical Asymptotes | new |
| N-1.15-A | 1.15 Connecting Limits at Infinity and Horizontal Asymptotes | new |
| N-1.15-B | 1.15 Connecting Limits at Infinity and Horizontal Asymptotes | new |
| N-1.16-A | 1.16 Working with the Intermediate Value Theorem | new |
| N-1.16-B | 1.16 Working with the Intermediate Value Theorem | new |

---

## Seed N-1.9-A (new) — Topic 1.9 Connecting Multiple Representations of Limits
**Skill:** decide whether limits of sums and products exist from one-sided limits read off two described graphs, without using the function values at the point.

The graph of f near x = 1 has these features: as x approaches 1 from the left, y approaches 2; as x approaches 1 from the right, y approaches 5; and f(1) = 3. The graph of g near x = 1 has these features: as x approaches 1 from the left, y approaches 3; as x approaches 1 from the right, y approaches 0; and g(1) = 4. Which of the following is true?

- A. Neither lim(x→1) [f(x) + g(x)] nor lim(x→1) [f(x)·g(x)] exists, because neither f nor g has a limit at x = 1.
- **B. lim(x→1) [f(x) + g(x)] exists and equals 5, but lim(x→1) [f(x)·g(x)] does not exist.**
- C. lim(x→1) [f(x)·g(x)] exists and equals 0, but lim(x→1) [f(x) + g(x)] does not exist.
- D. Both limits exist: lim(x→1) [f(x) + g(x)] = 7 and lim(x→1) [f(x)·g(x)] = 12.

Check: Left side: sum 2 + 3 = 5, product 2·3 = 6. Right side: sum 5 + 0 = 5, product 5·0 = 0. The sum has equal one-sided limits 5; the product has 6 and 0.
Rationales: A: A sum can have a limit even when each term has none; here the one-sided sums are 2 + 3 = 5 from the left and 5 + 0 = 5 from the right, so the sum does have a limit. C: The one-sided product limits are 2·3 = 6 from the left and 5·0 = 0 from the right, which disagree, so the product has no limit; 0 is only the right-hand value. D: Adding and multiplying f(1) = 3 and g(1) = 4 uses function values, but a limit depends only on the behavior near x = 1, not on the value at 1.

**N-1.9-A-v1.** The graph of f near x = 2 has these features: from the left, y approaches 4; from the right, y approaches −1; and f(2) = 1. The graph of g near x = 2: from the left, y approaches −2; from the right, y approaches 3; and g(2) = 0. Which of the following is true?

- A. Both limits exist: lim(x→2) [f(x) + g(x)] = 1 and lim(x→2) [f(x) − g(x)] = 1.
- B. lim(x→2) [f(x) − g(x)] exists and equals 6, but lim(x→2) [f(x) + g(x)] does not exist.
- **C. lim(x→2) [f(x) + g(x)] exists and equals 2, but lim(x→2) [f(x) − g(x)] does not exist.**
- D. Neither limit exists, because f and g do not have limits at x = 2.

Check: Left: f + g → 4 + (−2) = 2 and f − g → 4 − (−2) = 6. Right: f + g → −1 + 3 = 2 and f − g → −1 − 3 = −4. The sum agrees (2) and the difference does not (6 versus −4).
Rationales: A: This substitutes f(2) = 1 and g(2) = 0, but a limit is determined by nearby values, not by the value at the point. B: The value 6 is only the left-hand limit of the difference; the right-hand limit is −1 − 3 = −4, so the difference has no limit, while the sum, whose one-sided limits are both 2, does. D: Individual limits failing to exist does not prevent a combination from having one; the left and right sums are both 2.

**N-1.9-A-v2.** The graph of f near x = −1 has these features: from the left, y approaches 2; from the right, y approaches −2; and f(−1) = 0. The graph of g near x = −1: from the left, y approaches 3; from the right, y approaches −3; and g(−1) = 1. Which of the following is true?

- A. lim(x→−1) [f(x)·g(x)] = 0 and lim(x→−1) [f(x) + g(x)] = 1.
- B. lim(x→−1) [f(x) + g(x)] exists, but lim(x→−1) [f(x)·g(x)] does not exist.
- C. Neither lim(x→−1) [f(x) + g(x)] nor lim(x→−1) [f(x)·g(x)] exists.
- **D. lim(x→−1) [f(x)·g(x)] exists and equals 6, but lim(x→−1) [f(x) + g(x)] does not exist.**

Check: Left: product 2·3 = 6, sum 2 + 3 = 5. Right: product (−2)(−3) = 6, sum −2 + (−3) = −5. The product has limit 6; the sum has one-sided limits 5 and −5.
Rationales: A: This multiplies and adds the function values f(−1) = 0 and g(−1) = 1, which do not determine a limit at all. B: The sum is the combination that fails: its one-sided limits are 5 from the left and −5 from the right, so it has no limit; the product is the one that exists. C: The product does exist because both one-sided products equal 6, even though f and g individually have jump behavior at x = −1.

**N-1.9-A-v3.** The graph of f near x = 0 has these features: from the left, y approaches 3; from the right, y approaches 1; and f(0) = 2. The graph of g near x = 0: from the left, y approaches 1; from the right, y approaches 3; and g(0) = 2. Which of the following is true?

- **A. lim(x→0) [f(x) + g(x)] = 4 and lim(x→0) [f(x)·g(x)] = 3 both exist, but lim(x→0) [f(x)/g(x)] does not exist.**
- B. All three limits (sum, product, and quotient) exist.
- C. Only the limit of the product exists.
- D. The sum, the product, and the quotient all fail to have limits at x = 0.

Check: Left: f + g → 4, f·g → 3, f/g → 3/1 = 3. Right: f + g → 4, f·g → 3, f/g → 1/3. The quotient has one-sided limits 3 and 1/3.
Rationales: B: The quotient has left limit 3/1 = 3 and right limit 1/3, which differ, so the quotient has no limit even though the sum and product do. C: The sum also has a limit: both one-sided sums are 3 + 1 = 1 + 3 = 4, so the product is not the only combination that exists. D: Although neither f nor g has a limit at 0, the sum (4 on both sides) and the product (3 on both sides) both do.

---

## Seed N-1.9-B (new) — Topic 1.9 Connecting Multiple Representations of Limits
**Skill:** recognize that a table of values on a special sequence of inputs can mislead, and use an algebraic or graphical description to decide whether a limit exists.

A table lists values of f(x) = sin(π/x) at x = 1/2, 1/4, 1/10, 1/100, and 1/1000, and also at the negatives of these numbers. Every value in the table is 0. A student writes, "lim(x→0) f(x) = 0, because the table values are all 0." Which statement best evaluates the student's conclusion?

- A. The conclusion is correct: ten different inputs close to 0 on both sides all give 0, so the limit is 0.
- B. The conclusion is incorrect: the limit is +∞, because π/x grows without bound as x approaches 0.
- **C. The conclusion is incorrect: the limit does not exist, because f(x) = 1 at x = 2/5, 2/9, 2/13, ..., which also approach 0.**
- D. The conclusion is incorrect: the limit is 1, because f reaches its maximum value 1 arbitrarily close to 0.

Check: sin(π/x) = 0 at x = 1/n, but at x = 2/(4k + 1) it equals sin((4k + 1)π/2) = 1; two sequences approaching 0 give different values (0 and 1), so no limit.
Rationales: A: A finite list of values, even on both sides of 0, cannot prove a limit; the tabulated inputs all happen to be of the form 1/n where the sine is 0, and other inputs give other values. B: The argument π/x does grow without bound, but sin of an unbounded argument keeps oscillating between −1 and 1 rather than growing, so the limit is not +∞. D: The function takes the value 1 near 0 but also takes the values 0 and −1 near 0, so it does not settle at 1; a limit requires f to approach a single number.

**N-1.9-B-v1.** A student tabulates g(x) = cos(π/x) at x = 1/2, 1/4, 1/6, 1/8, and 1/100, finds g(x) = 1 every time, and concludes that lim(x→0+) g(x) = 1. Which statement is correct?

- A. The conclusion is correct: the values equal 1 at inputs that get arbitrarily close to 0 from the right.
- **B. The conclusion is incorrect: the limit does not exist, because g(x) = −1 at x = 1/3, 1/5, 1/7, ..., which also approach 0 from the right.**
- C. The conclusion is incorrect: the limit is 0, because cos oscillates between −1 and 1 and the values average out to 0.
- D. The conclusion is incorrect: the limit is −1, because g(1/3) = −1 shows the true value that the table missed.

Check: cos(π/x) at x = 1/(2n) is cos(2nπ) = 1, and at x = 1/(2n + 1) is cos((2n + 1)π) = −1. Two sequences approaching 0+ give 1 and −1, so the limit does not exist.
Rationales: A: All five inputs are even reciprocals 1/(2n), where cos(2nπ) = 1; a sample on one special sequence does not decide the limit, and inputs 1/(2n + 1) give −1. C: Averaging the extreme values is not how limits work; a limit exists only if g approaches one number, and g keeps hitting both 1 and −1 near 0. D: The value −1 on odd reciprocals is equally unrepresentative as the value 1 on even reciprocals; neither one is the limit.

**N-1.9-B-v2.** A table lists values of h(x) = x·sin(π/x) at x = 1/2, 1/4, 1/10, 1/100, and 1/1000, and every value is 0. A student claims lim(x→0) h(x) = 0. Which statement gives the best justification that this claim is true?

- **A. Since −|x| ≤ x·sin(π/x) ≤ |x| for x ≠ 0 and both bounds approach 0, the Squeeze Theorem gives lim(x→0) h(x) = 0.**
- B. The table shows h(x) = 0 at five inputs approaching 0, so the limit is 0.
- C. Since sin(π/x) has no limit at 0, the product x·sin(π/x) has no limit at 0 either.
- D. Since sin(π/x) oscillates between −1 and 1, the limit is the average of these, which is 0, regardless of the factor x.

Check: |x·sin(π/x)| ≤ |x| and |x| → 0, so the Squeeze Theorem gives 0. The table is only suggestive because sin(π/x) = 0 at every 1/n.
Rationales: B: The claim happens to be true, but the table cannot justify it because the sampled inputs all make sin(π/x) = 0; a bound valid for all x near 0 is needed. C: A product can have a limit even if one factor does not; here the factor x → 0 squeezes the bounded oscillation to 0. D: The limit is 0 because the factor x forces the amplitude to 0, not because the oscillation averages out; without the factor x the oscillation would give no limit.

**N-1.9-B-v3.** For f(x) = sin(3π/x), which of the following pairs of sequences of x-values, with both sequences approaching 0 as k = 1, 2, 3, ... increases, shows that lim(x→0) f(x) does not exist?

- A. x_k = 3/k and y_k = 3/(2k)
- B. x_k = 6/(4k + 1) and y_k = 6/(8k + 1)
- C. x_k = 6/(4k + 1) and y_k = 6/(4k + 5)
- **D. x_k = 6/(4k + 1) and y_k = 6/(4k + 3)**

Check: f(3/k) = sin(kπ) = 0 and f(3/(2k)) = sin(2kπ) = 0. For 6/(4k + 1): sin((4k + 1)π/2) = 1; for 6/(8k + 1): sin((8k + 1)π/2) = 1; for 6/(4k + 5): sin((4k + 5)π/2) = 1; for 6/(4k + 3): sin((4k + 3)π/2) = −1.
Rationales: A: On both sequences f equals sin(kπ) = 0 and sin(2kπ) = 0, so the function values agree and this pair does not contradict a limit of 0. B: On both sequences the argument is an odd multiple of π/2 that gives sine equal to 1 (since 4k + 1 and 8k + 1 are both 1 more than a multiple of 4), so both give 1. C: Both 4k + 1 and 4k + 5 are 1 more than a multiple of 4, so both sequences give sin = 1, again no disagreement. Only mixing 4k + 1 (value 1) with 4k + 3 (value −1) shows two different limits.

---

## Seed N-1.10-A (new) — Topic 1.10 Exploring Types of Discontinuities
**Skill:** classify a discontinuity from one-sided limits of an inverse-trigonometric expression and reject an argument that confuses f(a) with a limit.

Let f(x) = arctan(1/(x − 2)) for x ≠ 2, and let f(2) = 0. A student argues, "f has a removable discontinuity at x = 2, because the one-sided limits are −π/2 and π/2, which average to f(2) = 0." Which statement is correct?

- A. The student is correct: the discontinuity is removable.
- B. The discontinuity is infinite, because 1/(x − 2) is unbounded near x = 2.
- **C. The discontinuity is a jump: the one-sided limits are −π/2 and π/2, so the jump has size π.**
- D. The discontinuity is a jump of size π/2, which is the distance from f(2) = 0 to either one-sided limit.

Check: As x → 2−, 1/(x − 2) → −∞ and arctan → −π/2. As x → 2+, arctan → π/2. The one-sided limits are finite and unequal, so this is a jump of π/2 − (−π/2) = π.
Rationales: A: A removable discontinuity requires the two-sided limit to exist, and here the one-sided limits differ; f(2) being their average does not make the limit exist. B: The inner expression is unbounded, but arctan is bounded, so f itself stays between −π/2 and π/2 and the one-sided limits are finite, which excludes an infinite discontinuity. D: The size of a jump is the difference between the two one-sided limits, π/2 − (−π/2) = π, not the distance from f(2) to one side.

**N-1.10-A-v1.** Let g(x) = 1/(1 + e^(1/(x − 1))) for x ≠ 1, and let g(1) = 1/2. Which statement correctly describes g at x = 1?

- A. It is a removable discontinuity, because g(1) = 1/2 lies halfway between the one-sided limits.
- **B. It is a jump discontinuity, of size 1.**
- C. It is an infinite discontinuity, because the exponent 1/(x − 1) is unbounded near 1.
- D. It is a jump discontinuity, of size 1/2.

Check: As x → 1+, the exponent → +∞, e^(…) → ∞, so g → 0. As x → 1−, the exponent → −∞, e^(…) → 0, so g → 1. Finite, unequal one-sided limits 1 and 0 give a jump of size 1.
Rationales: A: Removable requires lim g to exist; the one-sided limits are 1 and 0, so no two-sided limit exists, regardless of where g(1) is placed. C: The exponent is unbounded, but g itself is squeezed between 0 and 1 near x = 1, so its one-sided limits are finite and the discontinuity is not infinite. D: The jump size is the difference of the one-sided limits, 1 − 0 = 1; the value 1/2 is only the defined value g(1).

**N-1.10-A-v2.** Let h(x) = e^(1/(x + 1)) for x ≠ −1. Which statement correctly describes the discontinuity of h at x = −1?

- A. It is removable, because lim(x→−1−) h(x) = 0 exists.
- B. It is a jump, because the one-sided limits 0 and ∞ are different.
- C. It is oscillating, because the exponent 1/(x + 1) changes sign at x = −1.
- **D. It is infinite, because lim(x→−1+) h(x) = +∞.**

Check: As x → −1−, the exponent → −∞ so h → 0. As x → −1+, the exponent → +∞ so h → +∞. One side is unbounded, so the discontinuity is infinite.
Rationales: A: Removable needs the two-sided limit to exist, and the right-hand limit is infinite, so the limit does not exist even though the left-hand limit is 0. B: A jump requires both one-sided limits to be finite numbers; here the right-hand one is +∞, which makes it an infinite discontinuity. C: The exponent changes sign but the function does not oscillate; it tends monotonically to 0 on one side and grows without bound on the other.

**N-1.10-A-v3.** Let g(x) = arctan(1/(x − 3)²) for x ≠ 3, and let g(3) = 0. Which statement correctly describes g at x = 3?

- **A. It is a removable discontinuity, because lim(x→3) g(x) = π/2 exists but is not equal to g(3).**
- B. It is an infinite discontinuity, because 1/(x − 3)² is unbounded near 3.
- C. It is a jump of size π/2, the difference between g(3) = 0 and the value π/2 near 3.
- D. It is not a discontinuity, because g(3) = 0 is a finite number.

Check: As x → 3 from either side, 1/(x − 3)² → +∞ and arctan → π/2. So lim g = π/2, while g(3) = 0 ≠ π/2.
Rationales: B: The inside expression is unbounded, but arctan is bounded, so g stays below π/2 and approaches π/2 from both sides; the limit is finite, which rules out an infinite discontinuity. C: Both one-sided limits equal π/2, so there is no jump between the left and right sides; the mismatch is only with the defined value g(3). D: Continuity requires g(3) to equal the limit π/2, and being finite is not enough; since g(3) = 0 ≠ π/2, g is discontinuous.

---

## Seed N-1.10-B (new) — Topic 1.10 Exploring Types of Discontinuities
**Skill:** read a described graph, sort each special x-value into removable, jump, infinite, or continuous, and count correctly without counting the continuous point.

A function f is described near six x-values. At x = −2, lim f(x) = 1 and f(−2) = 4. At x = 0, the left-hand limit is 2, the right-hand limit is −1, and f(0) = −1. At x = 1, f(x) → +∞ from both sides and f(1) is undefined. At x = 3, lim f(x) = 2 and f(3) = 2. At x = 4, lim f(x) = 5 and f(4) is undefined. At x = 5, the left-hand limit is −∞ and the right-hand limit is +∞. Which row correctly counts the discontinuities of f at these six x-values by type?

- **A. 2 removable, 1 jump, 2 infinite**
- B. 3 removable, 1 jump, 2 infinite
- C. 2 removable, 2 jump, 1 infinite
- D. 1 removable, 2 jump, 2 infinite

Check: x = −2 and x = 4 are removable (the limit exists but is not f's value or f is undefined). x = 0 is a jump (2 versus −1). x = 1 and x = 5 are infinite. x = 3 is continuous because lim = f(3) = 2.
Rationales: B: This counts x = 3 as removable, but there lim f = 2 = f(3), so f is continuous at 3. C: This calls x = 5 a jump, but a jump needs both one-sided limits to be finite; here they are −∞ and +∞, so it is infinite. D: This calls x = −2 a jump, but a jump requires different one-sided limits; at −2 the limit exists (equal to 1), so the discontinuity is removable even though f(−2) = 4.

**N-1.10-B-v1.** A function f is described near seven x-values. At x = −3, lim f(x) = 0 and f(−3) = 0. At x = −1, lim f(x) = 4 and f(−1) = 1. At x = 2, the left-hand limit is −1, the right-hand limit is 3, and f(2) = 3. At x = 3, f(x) → +∞ from both sides. At x = 5, lim f(x) = 2 and f(5) is undefined. At x = 6, the left-hand limit is −∞ and the right-hand limit is 7. At x = 7, the left-hand limit is 1, the right-hand limit is 4, and f(7) = 4. Which row correctly counts the discontinuities of f at these seven x-values by type?

- A. 2 removable, 3 jump, 1 infinite
- B. 3 removable, 2 jump, 2 infinite
- **C. 2 removable, 2 jump, 2 infinite**
- D. 1 removable, 3 jump, 2 infinite

Check: Removable: x = −1 and x = 5. Jump: x = 2 and x = 7. Infinite: x = 3 and x = 6 (one infinite one-sided limit suffices). x = −3 is continuous.
Rationales: A: This calls x = 6 a jump because the one-sided limits differ, but a jump needs both finite; the left-hand limit is −∞, so it is infinite. B: This counts x = −3 as removable, but there lim f = f(−3) = 0, so f is continuous at −3. D: This calls x = −1 a jump because f(−1) differs from the limit, but the limit 4 exists, so the discontinuity is removable.

**N-1.10-B-v2.** A function f is described near five x-values. At x = −1, the left-hand limit is 3, the right-hand limit is −2, and f(−1) = −2. At x = 1, lim f(x) = 1 and f(1) = 4. At x = 2, the left-hand limit is 0, the right-hand limit is 6, and f(2) = 6. At x = 4, the left-hand limit is 1, the right-hand limit is −3, and f(4) = −3. At x = 5, lim f(x) = 2 and f(5) = 2. What is the sum of the sizes of the jumps of f at the x-values where f has a jump discontinuity?

- A. 18
- B. −3
- C. 6
- **D. 15**

Check: Jumps at x = −1 (|−2 − 3| = 5), x = 2 (6 − 0 = 6), x = 4 (|−3 − 1| = 4). Total 5 + 6 + 4 = 15. x = 1 is removable (not a jump) and x = 5 is continuous.
Rationales: A: This adds the gap |4 − 1| = 3 at x = 1, but that point is a removable discontinuity with equal one-sided limits, so it contributes no jump. B: This adds signed changes, (−2 − 3) + (6 − 0) + (−3 − 1) = −3, but sizes of jumps are absolute differences so downward jumps must be counted as positive. C: This counts only the one upward jump at x = 2 and ignores the two downward jumps at x = −1 and x = 4.

**N-1.10-B-v3.** Let f(x) = (x² − x − 2)/(x² − 2x). Which statement correctly describes the discontinuities of f?

- A. A jump at x = 0 and a removable discontinuity at x = 2.
- **B. An infinite discontinuity at x = 0 and a removable discontinuity at x = 2.**
- C. Infinite discontinuities at both x = 0 and x = 2.
- D. A removable discontinuity at x = 0 and an infinite discontinuity at x = 2.

Check: f(x) = (x − 2)(x + 1)/(x(x − 2)) = (x + 1)/x for x ≠ 0, 2. At x = 2 the limit is 3/2, finite. Near 0, (x + 1)/x → −∞ from the left and +∞ from the right.
Rationales: A: The one-sided behavior at 0 has opposite signs, but the one-sided limits are −∞ and +∞, not finite numbers, so it is an infinite discontinuity rather than a jump. C: At x = 2 both numerator and denominator vanish, and the factor x − 2 cancels, leaving a finite limit 3/2; the denominator being zero does not by itself make it infinite. D: This swaps the two points; at x = 0 only the denominator vanishes (the numerator 0 − 0 − 2 = −2 is nonzero) so it is infinite there, and at x = 2 the common factor x − 2 cancels so it is removable.

---

## Seed N-1.11-A (new) — Topic 1.11 Defining Continuity at a Point
**Skill:** apply the three-part definition of continuity to a piecewise function with exponential and logarithmic pieces, evaluating ln 1 and e⁰ correctly and including f(2).

Let f be defined by f(x) = ax + b for x < 2, f(2) = 5, and f(x) = a·e^(x − 2) + b·ln(x − 1) for x > 2. If f is continuous at x = 2, what is the value of b?

- A. 0
- **B. −5**
- C. 5
- D. −10

Check: Right limit: a·e⁰ + b·ln 1 = a. Left limit: 2a + b. Continuity needs 2a + b = a = 5, so a = 5 and b = 5 − 10 = −5.
Rationales: A: This evaluates the left piece at x = 1 instead of x = 2, writing a + b = 5, which with a = 5 gives b = 0. C: This takes ln(1) = 1, so the right limit is a + b = 5, which together with 2a + b = 5 gives a = 0 and b = 5; but ln 1 = 0, so the b term vanishes on the right. D: This drops f(2) = 5 from the left-hand equation, writing 2a + b = 0 with a = 5, which gives b = −10.

**N-1.11-A-v1.** Let g be defined by g(x) = ax² + b for x < 1, g(1) = 6, and g(x) = 2a·e^(x − 1) + b·ln x for x > 1. If g is continuous at x = 1, what is the value of b?

- **A. 3**
- B. 6
- C. 9
- D. −3

Check: Right limit: 2a·e⁰ + b·ln 1 = 2a = 6, so a = 3. Left limit: a + b = 6, so b = 3.
Rationales: B: This takes ln 1 = 1, so the right limit is 2a + b = 6; with a + b = 6 this gives a = 0 and b = 6, but ln 1 = 0 removes the b term on the right. C: This writes b = 6 + a with a = 3, adding instead of subtracting when solving a + b = 6. D: This writes b = a − 6 = −3, a sign slip when solving a + b = 6 for b.

**N-1.11-A-v2.** Let h be defined by h(x) = a·e^x + 2b for x < 0, h(0) = 6, and h(x) = 2a·cos x + b·arctan x for x > 0. If h is continuous at x = 0, what is the value of b?

- A. 3
- B. 0
- **C. 3/2**
- D. 9/2

Check: Right limit: 2a·cos 0 + b·arctan 0 = 2a, so 2a = 6 and a = 3. Left limit: a + 2b = 6, so b = 3/2.
Rationales: A: This reads the left limit as a + b instead of a + 2b, which gives b = 3. B: This drops the factor 2 on the right, writing a = 6, and then a + 2b = 6 gives b = 0. D: This solves 2b = 6 + 3 = 9 (adding a instead of subtracting it) and gets b = 9/2.

**N-1.11-A-v3.** Let p be defined by p(x) = ax − b for x < 1, p(1) = 2, and p(x) = b·e^(x − 1) + a·ln x for x > 1. If p is continuous at x = 1, what is the value of a?

- A. 0
- B. 2
- **C. 4**
- D. 6

Check: Right limit: b·e⁰ + a·ln 1 = b, so b = 2. Left limit: a − b = 2, so a = 4.
Rationales: A: This reads the left piece ax − b as ax + b, so the left limit is a + b = 2 and with b = 2 gives a = 0. B: This takes ln 1 = 1, so the right limit is a + b = 2, which with a − b = 2 gives a = 2 and b = 0; but ln 1 = 0, so the right limit is just b = 2. D: This solves a − b = 2 as a = 2 + 2b = 6, adding b twice instead of once.

---

## Seed N-1.11-B (new) — Topic 1.11 Defining Continuity at a Point
**Skill:** translate the definition of continuity into limit notation, separating conditions that only compare the two sides from the condition that links the limit to the function value.

For a function f defined at every real number, which of the following is equivalent to the statement that f is continuous at x = 2?

- A. lim(h→0) [f(2 + h) − f(2 − h)] = 0
- B. lim(x→2) f(x) exists
- **C. lim(h→0) [f(2 + h) − f(2)] = 0**
- D. lim(n→∞) f(2 + 1/n) = f(2)

Check: The definition needs lim(x→2) f(x) = f(2). Setting x = 2 + h, this says f(2 + h) − f(2) → 0 as h → 0 from both sides, which is C.
Rationales: A: This says the values at symmetric points agree in the limit, which is satisfied by a function with f(2) = 7 and f(x) = 0 elsewhere; it never mentions f(2). B: The limit can exist while f(2) is different from it or is not equal; existence of the limit is only one of the three conditions. D: This tests only one sequence of inputs approaching 2 from the right, so it says nothing about the left side or about other sequences.

**N-1.11-B-v1.** For a function f defined at every real number, which of the following is equivalent to the statement that f is continuous at x = 3?

- **A. lim(h→0+) f(3 + h) = f(3) and lim(h→0+) f(3 − h) = f(3)**
- B. lim(h→0+) [f(3 + h) − f(3 − h)] = 0
- C. lim(h→0+) f(3 + h) = lim(h→0+) f(3 − h)
- D. lim(x→3) f(x) exists and f(3) is defined

Check: The first expression is the right-hand limit equal to f(3), the second is the left-hand limit equal to f(3); both together are exactly continuity at 3.
Rationales: B: This only says the two sides approach the same thing in difference; it can hold for a function whose left and right limits do not exist or whose common value differs from f(3). C: The two one-sided limits agree, but their common value is not required to be f(3); a removable discontinuity satisfies C. D: Both parts hold at a removable discontinuity, where the limit exists and f(3) is defined but the two are not equal.

**N-1.11-B-v2.** For a function f defined at every real number, which of the following is equivalent to the statement that f is continuous at x = 1?

- A. For the sequence x_n = 1 + 1/n, f(x_n) approaches f(1) as n increases.
- B. f(1 + 1/n) and f(1 − 1/n) approach the same value as n increases.
- C. |f(x) − f(1)| < 1 for every x sufficiently close to 1.
- **D. For every sequence x_n that approaches 1, f(x_n) approaches f(1).**

Check: Continuity at 1 means lim(x→1) f(x) = f(1), which is equivalent to f(x_n) → f(1) along every sequence x_n → 1.
Rationales: A: This examines one sequence from the right only, which cannot control the left side or other sequences. B: Two sequences giving the same limit show a kind of symmetry but not that this common value equals f(1), and other sequences are not tested. C: This only keeps f within distance 1 of f(1), a bound, whereas continuity requires |f(x) − f(1)| to be made smaller than every positive number.

**N-1.11-B-v3.** A function f satisfies f(5) = 3, lim(h→0+) f(5 + h) = 3, and lim(h→0+) f(5 − h) = 3. Which conclusion is justified?

- A. f is continuous from the right at x = 5 but not necessarily from the left.
- **B. f is continuous at x = 5.**
- C. f is differentiable at x = 5.
- D. f is continuous on an open interval containing x = 5.

Check: The first limit is the right-hand limit at 5, the second is the left-hand limit; both equal f(5) = 3, which is the definition of continuity at 5.
Rationales: A: The second limit, with 5 − h approaching 5 from the left, shows left continuity as well, so nothing is missing on the left. C: Continuity does not imply differentiability; f(x) = |x − 5| + 3 satisfies all the given conditions but has a corner at 5. D: The information concerns only the point x = 5; f could be discontinuous at points arbitrarily close to 5 (for example at every nearby rational), so an interval of continuity is not guaranteed.

---

## Seed N-1.12-A (new) — Topic 1.12 Confirming Continuity over an Interval
**Skill:** find the largest set of continuity for a quotient of inverse-trigonometric and logarithmic expressions by intersecting domain restrictions and removing zeros of the denominator.

What is the largest set of x-values on which f(x) = arcsin(x − 1)/ln x is continuous?

- A. [0, 1) ∪ (1, 2]
- B. (0, 2]
- C. (0, 1) ∪ (1, 2)
- **D. (0, 1) ∪ (1, 2]**

Check: arcsin(x − 1) needs −1 ≤ x − 1 ≤ 1, so 0 ≤ x ≤ 2. ln x needs x > 0, and ln x = 0 at x = 1. Intersecting gives (0, 1) ∪ (1, 2]; the endpoint 2 is allowed since arcsin(1) and ln 2 are defined.
Rationales: A: This keeps x = 0 because arcsin(−1) is defined, but ln 0 is undefined, so f is not defined at 0. B: This keeps x = 1, but ln 1 = 0 makes the denominator zero, so f is not defined at 1. C: This drops the endpoint x = 2, but at x = 2 both arcsin(1) = π/2 and ln 2 are defined and ln 2 ≠ 0, so f is continuous there from the left.

**N-1.12-A-v1.** What is the largest set of x-values on which g(x) = √(4 − x²)/ln(x + 2) is continuous?

- A. [−2, −1) ∪ (−1, 2]
- **B. (−2, −1) ∪ (−1, 2]**
- C. (−2, −1) ∪ (−1, 2)
- D. (−2, 2]

Check: √(4 − x²) needs −2 ≤ x ≤ 2. ln(x + 2) needs x > −2 and equals 0 at x = −1. Intersecting gives (−2, −1) ∪ (−1, 2]; x = 2 gives 0/ln 4, which is defined.
Rationales: A: This keeps x = −2, but there ln(0) is undefined, so g is not defined at −2. C: This drops x = 2, but there the numerator √0 = 0 is defined and ln 4 ≠ 0, so g is defined and continuous from the left at 2. D: This keeps x = −1, where ln 1 = 0 makes the denominator zero, so g is not defined at −1.

**N-1.12-A-v2.** What is the largest set of x-values on which h(x) = ln(9 − x²)/(eˣ − e) is continuous?

- **A. (−3, 1) ∪ (1, 3)**
- B. (−3, 3)
- C. [−3, 1) ∪ (1, 3]
- D. (−3, 0) ∪ (0, 3)

Check: ln(9 − x²) needs 9 − x² > 0, so −3 < x < 3. The denominator eˣ − e = 0 only at x = 1. So h is continuous on (−3, 1) ∪ (1, 3).
Rationales: B: This ignores the denominator, but eˣ − e = 0 at x = 1, where h is not defined. C: This includes the endpoints ±3, but ln 0 is undefined, so the domain stops short of them. D: This removes x = 0 by treating e⁰ = e, but e⁰ = 1, so the denominator is nonzero at 0; the zero of eˣ − e is at x = 1.

**N-1.12-A-v3.** What is the largest set of x-values on which k(x) = arccos(1 − x)/√(x − 1) is continuous?

- A. [1, 2]
- B. [0, 2]
- **C. (1, 2]**
- D. (1, ∞)

Check: arccos(1 − x) needs −1 ≤ 1 − x ≤ 1, so 0 ≤ x ≤ 2. The square root in the denominator needs x − 1 > 0. Intersecting gives (1, 2]; at x = 2, arccos(−1) = π and √1 = 1.
Rationales: A: This includes x = 1, but there √0 = 0 makes the denominator zero, so k is undefined at 1. B: This only uses the arccos restriction and ignores that √(x − 1) is undefined for x < 1 and zero at 1. D: This only uses the square-root restriction x > 1, but arccos(1 − x) is undefined for x > 2 where 1 − x < −1.

---

## Seed N-1.12-B (new) — Topic 1.12 Confirming Continuity over an Interval
**Skill:** make a three-piece function continuous on all real numbers by matching both junction points, tracking how ln(1) and e⁰ remove or keep parameters.

Let f be defined by f(x) = a·eˣ for x < 0, f(x) = bx + 2 for 0 ≤ x ≤ 2, and f(x) = a·ln(x − 1) + 8 for x > 2. For which values of a and b is f continuous for all real numbers?

- A. a = 2, b = 6
- B. a = 2, b = 4
- **C. a = 2, b = 3**
- D. a = 2, b = 5

Check: At x = 0: a·e⁰ = a must equal b·0 + 2, so a = 2. At x = 2: 2b + 2 must equal a·ln 1 + 8 = 8, so b = 3.
Rationales: A: The equation 2b + 2 = 8 gives 2b = 6; this stops there and reports b = 6 without dividing by 2. B: This takes ln 1 = 1, so the right limit at 2 is a + 8 = 10, giving 2b + 2 = 10 and b = 4; but ln 1 = 0 so the right limit is just 8. D: This solves 2b + 2 = 8 by adding 2 instead of subtracting, writing 2b = 10 and b = 5.

**N-1.12-B-v1.** Let g be defined by g(x) = a·e^(x − 1) + bx for x < 1, g(x) = x² for 1 ≤ x ≤ 3, and g(x) = a·ln(x − 2) + 3b for x > 3. For which values of a and b is g continuous for all real numbers?

- A. a = −3, b = 4
- **B. a = −2, b = 3**
- C. a = 2, b = 3
- D. a = −8, b = 9

Check: At x = 3: right piece gives a·ln 1 + 3b = 3b, which must equal 3² = 9, so b = 3. At x = 1: left piece gives a + b, which must equal 1² = 1, so a = −2.
Rationales: A: This takes ln 1 = 1, giving a + 3b = 9 with a + b = 1, which solves to b = 4 and a = −3; but ln 1 = 0, so the right limit at 3 is 3b. C: This gets b = 3 correctly but solves a + 3 = 1 as a = 2, a sign error. D: This writes 3b = 9 and stops at b = 9 without dividing by 3, and then a + 9 = 1 gives a = −8.

**N-1.12-B-v2.** Let h be defined by h(x) = a·eˣ + b for x < 0, h(x) = 2x + 4 for 0 ≤ x ≤ 1, and h(x) = 2b·e^(x − 1) − a·ln x for x > 1. For which values of a and b is h continuous for all real numbers?

- A. a = 3, b = 3
- B. a = 2, b = 2
- C. a = −2, b = 6
- **D. a = 1, b = 3**

Check: At x = 1: the right piece gives 2b·e⁰ − a·ln 1 = 2b, which must equal 2(1) + 4 = 6, so b = 3. At x = 0: the left piece gives a + b, which must equal 4, so a = 1.
Rationales: A: This matches the left junction at 0 to the middle value 6 (its value at x = 1) instead of 4, so a + b = 6 with b = 3 gives a = 3. B: This matches the right junction at 1 to the middle value 4 (its value at x = 0), so 2b = 4 gives b = 2, and then a + b = 4 gives a = 2. C: This forgets the factor 2 on the right, writing b = 6, and then a + 6 = 4 gives a = −2.

**N-1.12-B-v3.** Let f be defined by f(x) = 3e^(x − 2) for x < 2, f(x) = ax − 5 for 2 ≤ x ≤ 3, and f(x) = b + 4 ln(x − 2) for x > 3. If f is continuous for all real numbers, what is a + b?

- **A. 11**
- B. 7
- C. −9
- D. 27

Check: At x = 2: 3e⁰ = 3 = 2a − 5, so a = 4. At x = 3: 3a − 5 = 7 must equal b + 4 ln 1 = b, so b = 7. Then a + b = 11.
Rationales: B: This takes ln 1 = 1, so b + 4 = 7 and b = 3, which gives a + b = 7; but ln 1 = 0, so b = 7. C: This solves 2a − 5 = 3 as a = −1 through a sign slip, then 3a − 5 = −8 gives b = −8, and a + b = −9. D: This solves 2a − 5 = 3 as a = 8 by forgetting to divide by 2, then 3a − 5 = 19 gives b = 19, and a + b = 27.

---

## Seed N-1.13-A (new) — Topic 1.13 Removing Discontinuities
**Skill:** find the value that removes a discontinuity when the limit requires a double-angle identity and the special trigonometric limit sin(u)/u → 1.

The function f is defined by f(x) = (1 − cos 6x)/(x·sin 3x) for x ≠ 0 near 0, and f(0) = k. For what value of k is f continuous at x = 0?

- A. 0
- **B. 6**
- C. 3
- D. 12

Check: 1 − cos 6x = 2sin²3x, so f(x) = 2 sin 3x / x for x near 0, which has limit 2·3 = 6. Numerically f(0.001) ≈ 5.99999.
Rationales: A: This takes (1 − cos u)/u → 0 and concludes the limit is 0, but the denominator here is x·sin 3x, which is of order x², the same order as the numerator. C: This writes 1 − cos 6x = sin²3x, forgetting the factor 2 in the identity 1 − cos 2θ = 2sin²θ, and gets sin 3x/x → 3. D: This approximates 1 − cos 6x by (6x)² = 36x², forgetting the 1/2 in 1 − cos u ≈ u²/2, and gets 36x²/(3x²) = 12.

**N-1.13-A-v1.** The function g is defined by g(x) = (1 − cos 4x)/(x·sin 2x) for x ≠ 0 near 0, and g(0) = k. For what value of k is g continuous at x = 0?

- A. 0
- B. 2
- C. 8
- **D. 4**

Check: 1 − cos 4x = 2sin²2x, so g(x) = 2 sin 2x / x → 2·2 = 4. Numerically g(0.001) ≈ 4.0000.
Rationales: A: This assumes the limit is 0 from (1 − cos u)/u → 0, ignoring that the denominator is also small, of order x². B: This drops the factor 2 in 1 − cos 4x = 2sin²2x and gets sin 2x/x → 2. C: This approximates 1 − cos 4x by (4x)² = 16x², forgetting the 1/2, and gets 16x²/(2x²) = 8.

**N-1.13-A-v2.** The function h is defined by h(x) = (1 − cos 8x)/(x·sin 2x) for x ≠ 0 near 0, and h(0) = k. For what value of k is h continuous at x = 0?

- A. 0
- B. 32
- **C. 16**
- D. 1/16

Check: 1 − cos 8x = 2sin²4x, so h(x) = 2 sin²4x / (x sin 2x). Using sin 4x ≈ 4x and sin 2x ≈ 2x, h(x) ≈ 2·16x²/(2x²) = 16. Numerically h(0.001) ≈ 16.0.
Rationales: A: This treats the 0/0 form as 0 using (1 − cos u)/u → 0, but both numerator and denominator are of order x², so the ratio is a nonzero constant. B: This approximates 1 − cos 8x by (8x)² = 64x², dropping the 1/2, and gets 64x²/(2x²) = 32. D: This inverts the quotient, finding denominator/numerator = 2/32 = 1/16.

**N-1.13-A-v3.** The function p is defined by p(x) = (1 − cos 2x)/(x·tan x) for x ≠ 0 near 0, and p(0) = k. For what value of k is p continuous at x = 0?

- **A. 2**
- B. 0
- C. 4
- D. 1/2

Check: 1 − cos 2x = 2sin²x, so p(x) = 2 sin²x/(x tan x) = 2 sin x cos x / x → 2. Numerically p(0.001) ≈ 2.0000.
Rationales: B: This uses (1 − cos u)/u → 0, but the denominator x·tan x is of order x², so the limit is not 0. C: This approximates 1 − cos 2x by (2x)² = 4x², dropping the 1/2, and gets 4x²/x² = 4. D: This approximates 1 − cos 2x by x²/2 (using u = x instead of u = 2x), which gives 1/2.

---

## Seed N-1.13-B (new) — Topic 1.13 Removing Discontinuities
**Skill:** first find the constant that makes a radical quotient a 0/0 form, then rationalize and find the value that removes the discontinuity.

The function g is defined by g(x) = (√(x + a) − 2)/(x − 3) for x ≠ 3, where a is a constant. The limit of g as x approaches 3 is a finite number, and g(3) is defined so that g is continuous at x = 3. What is g(3)?

- A. 1/2
- B. 1/8
- **C. 1/4**
- D. 4

Check: A finite limit needs the numerator to vanish at 3: √(3 + a) = 2, so a = 1. Then (√(x + 1) − 2)/(x − 3) = 1/(√(x + 1) + 2) → 1/4.
Rationales: A: This rationalizes correctly but then drops the +2 in the denominator, using 1/√4 = 1/2. B: This treats the derivative-like factor as 1/(2(√(x + 1) + 2)) with an extra factor 2 in the denominator, giving 1/8. D: This inverts the simplified quotient, reporting √(x + 1) + 2 = 4 instead of its reciprocal 1/4.

**N-1.13-B-v1.** The function g is defined by g(x) = (√(2x + a) − 3)/(x − 4) for x ≠ 4, where a is a constant. The limit of g as x approaches 4 is a finite number, and g(4) is defined so that g is continuous at x = 4. What is g(4)?

- A. 1/6
- B. 2/3
- C. 3
- **D. 1/3**

Check: Finite limit needs √(8 + a) = 3, so a = 1. Then (√(2x + 1) − 3)/(x − 4) = (2x − 8)/((x − 4)(√(2x + 1) + 3)) = 2/(√(2x + 1) + 3) → 2/6 = 1/3.
Rationales: A: This forgets the factor 2 that comes from 2x + 1 − 9 = 2(x − 4), giving 1/6. B: This drops the +3 from the denominator after rationalizing, giving 2/√9 = 2/3. C: This inverts the simplified quotient, giving 6/2 = 3 instead of 2/6.

**N-1.13-B-v2.** The function g is defined by g(x) = (√(5x + a) − 4)/(x − 2) for x ≠ 2, where a is a constant. The limit of g as x approaches 2 is a finite number, and g(2) is defined so that g is continuous at x = 2. What is g(2)?

- **A. 5/8**
- B. 5/4
- C. 1/8
- D. 8/5

Check: Finite limit needs √(10 + a) = 4, so a = 6. Then (√(5x + 6) − 4)/(x − 2) = 5/(√(5x + 6) + 4) → 5/8.
Rationales: B: This drops the +4 from the denominator, using 5/√16 = 5/4. C: This forgets the factor 5 that comes from 5x + 6 − 16 = 5(x − 2), giving 1/8. D: This inverts the simplified quotient, giving 8/5 instead of 5/8.

**N-1.13-B-v3.** The function g is defined by g(x) = (3 − √(a − x))/(x + 1) for x ≠ −1, where a is a constant. The limit of g as x approaches −1 is a finite number, and g(−1) is defined so that g is continuous at x = −1. What is g(−1)?

- A. 1/3
- **B. 1/6**
- C. −1/6
- D. 6

Check: Finite limit needs √(a + 1) = 3, so a = 8. Then (3 − √(8 − x))/(x + 1) = (9 − (8 − x))/((x + 1)(3 + √(8 − x))) = 1/(3 + √(8 − x)) → 1/6.
Rationales: A: This drops the √(8 − x) term from the denominator, using 1/3. C: This writes the numerator of the rationalized form as (8 − x) − 9 = −(x + 1), a sign error that makes the limit negative. D: This inverts the simplified quotient, reporting 3 + 3 = 6 instead of 1/6.

---

## Seed N-1.14-A (new) — Topic 1.14 Connecting Infinite Limits and Vertical Asymptotes
**Skill:** locate vertical asymptotes of a quotient with a logarithm, rejecting a false asymptote at the edge of the domain, and determine the sign of the one-sided infinite limits.

Let f(x) = (x + 2)/ln x. Which statement correctly describes the vertical asymptotes of the graph of f and the one-sided limits there?

- **A. There is a vertical asymptote at x = 1 only, with lim(x→1−) f(x) = −∞ and lim(x→1+) f(x) = +∞.**
- B. There are vertical asymptotes at x = 0 and x = 1, with lim(x→1−) f(x) = −∞ and lim(x→1+) f(x) = +∞.
- C. There is a vertical asymptote at x = 1 only, with f(x) → +∞ from both sides.
- D. There is a vertical asymptote at x = 0 only, because ln x is undefined at 0.

Check: ln x = 0 at x = 1 with numerator 3 > 0. For x < 1, ln x < 0 so f → −∞; for x > 1, ln x > 0 so f → +∞. As x → 0+, ln x → −∞ and f(x) → 2/(−∞) = 0, not infinity.
Rationales: B: At x = 0 the denominator ln x tends to −∞, making f(x) tend to 0 rather than infinity, so x = 0 is not an asymptote. C: For x slightly less than 1, ln x is negative, so the quotient is negative and the left limit is −∞, not +∞. D: ln x being undefined at 0 does not produce an infinite limit; f(x) approaches 0 as x → 0+, and the true vertical asymptote comes from the zero ln 1 = 0.

**N-1.14-A-v1.** Let f(x) = (x − 3)/(eˣ − e). Which statement correctly describes the vertical asymptotes of the graph of f and the one-sided limits there?

- A. There is a vertical asymptote at x = 1 only, with lim(x→1−) f(x) = −∞ and lim(x→1+) f(x) = +∞.
- B. There is a vertical asymptote at x = 1 only, with f(x) → −∞ from both sides.
- **C. There is a vertical asymptote at x = 1 only, with lim(x→1−) f(x) = +∞ and lim(x→1+) f(x) = −∞.**
- D. There is a vertical asymptote at x = 3 only, because the numerator is zero there.

Check: eˣ − e = 0 at x = 1 and numerator 1 − 3 = −2 < 0. For x < 1, the denominator is negative, so f is (−)/(−) → +∞; for x > 1, the denominator is positive, so f → −∞.
Rationales: A: This reverses both signs: for x < 1 the denominator eˣ − e is negative and the numerator is negative, so the quotient is positive and the left limit is +∞. B: This ignores that the denominator changes sign at x = 1; it is negative on the left and positive on the right, so the infinite limits have opposite signs. D: A zero of the numerator makes f zero there (f(3) = 0), not infinite; the denominator, not the numerator, creates the asymptote.

**N-1.14-A-v2.** Let f(x) = (x² + 4)/ln(x²). How many vertical asymptotes does the graph of f have, and what is lim(x→−1+) f(x)?

- A. Three vertical asymptotes; lim(x→−1+) f(x) = −∞.
- **B. Two vertical asymptotes; lim(x→−1+) f(x) = −∞.**
- C. Two vertical asymptotes; lim(x→−1+) f(x) = +∞.
- D. Three vertical asymptotes; lim(x→−1+) f(x) = +∞.

Check: ln(x²) = 0 at x = ±1; at x = 0, ln(x²) → −∞ so f → 4/(−∞) = 0 (no asymptote). For x slightly greater than −1, x² < 1, so ln(x²) < 0 and the numerator is about 5, so f → −∞.
Rationales: A: This counts x = 0 as an asymptote, but there f(x) tends to 0, not to infinity, so only x = −1 and x = 1 qualify. C: For x just above −1 we have x² slightly less than 1, so ln(x²) is negative and the quotient is negative, giving −∞ rather than +∞. D: Both errors combined: x = 0 is not an asymptote, and the sign near −1 from the right is negative.

**N-1.14-A-v3.** Let f(x) = (2x + 1)/(π − 4·arctan x). Which statement gives all vertical asymptotes of the graph of f and the value of lim(x→1+) f(x)?

- A. There is no vertical asymptote, because arctan x is bounded.
- B. The only vertical asymptote is x = 1, and lim(x→1+) f(x) = +∞.
- C. The only vertical asymptote is x = π/4, and lim(x→1+) f(x) = −∞.
- **D. The only vertical asymptote is x = 1, and lim(x→1+) f(x) = −∞.**

Check: π − 4 arctan x = 0 when arctan x = π/4, i.e., x = 1, and arctan is increasing so the denominator is positive for x < 1 and negative for x > 1. The numerator at x = 1 is 3 > 0, so lim(x→1+) f(x) = −∞ and lim(x→1−) f(x) = +∞.
Rationales: A: A bounded arctan does not prevent the denominator from being zero; π − 4 arctan x equals 0 at x = 1, creating an asymptote. B: For x slightly greater than 1, arctan x > π/4, so the denominator is negative and the quotient is negative, giving −∞. C: The value π/4 is where arctan x equals the critical level, but the asymptote is the x-value that produces it, namely x = tan(π/4) = 1.

---

## Seed N-1.14-B (new) — Topic 1.14 Connecting Infinite Limits and Vertical Asymptotes
**Skill:** evaluate a difference of two unbounded terms by combining them first, deciding which term dominates instead of treating ∞ − ∞ as a number.

What is lim(x→2) [1/(x − 2)² − 1/(x − 2)⁴]?

- A. 0
- B. +∞
- C. −1
- **D. −∞**

Check: Combine: [(x − 2)² − 1]/(x − 2)⁴. As x → 2 the numerator → −1 and the denominator → 0⁺, so the quotient → −∞.
Rationales: A: This treats ∞ − ∞ as 0, but the two terms have different rates of growth, and the second term dominates. B: This keeps the sign of the first term, but 1/(x − 2)⁴ grows faster than 1/(x − 2)² and is subtracted, so the difference is negative. C: This keeps only the numerator (x − 2)² − 1 → −1 and ignores the denominator (x − 2)⁴, which approaches 0.

**N-1.14-B-v1.** What is lim(x→1+) [1/(x − 1) − 1/(x² − 1)]?

- **A. +∞**
- B. 0
- C. −∞
- D. 1/2

Check: 1/(x − 1) − 1/((x − 1)(x + 1)) = ((x + 1) − 1)/((x − 1)(x + 1)) = x/(x² − 1). As x → 1+, the numerator → 1 and the denominator → 0⁺, so the limit is +∞.
Rationales: B: This treats ∞ − ∞ as 0, but the two terms combine to x/(x² − 1), which is unbounded. C: The denominator x² − 1 is positive for x slightly greater than 1, so the combined fraction is positive, not negative. D: This cancels the factor x − 1 from the denominator without a matching numerator factor, evaluating x/(x + 1) at 1, which is not justified.

**N-1.14-B-v2.** What is lim(x→2) [4/(x² − 4) − 1/(x − 2)]?

- A. 0
- B. −∞
- **C. −1/4**
- D. 1/4

Check: 4/((x − 2)(x + 2)) − 1/(x − 2) = (4 − (x + 2))/((x − 2)(x + 2)) = (2 − x)/((x − 2)(x + 2)) = −1/(x + 2) → −1/4.
Rationales: A: This treats ∞ − ∞ as 0, but after combining the fractions the common factor x − 2 cancels and leaves −1/(x + 2). B: Each term is unbounded, but the unbounded parts cancel after combining; the limit is finite. D: This gets the magnitude right but loses the sign: the numerator is 4 − (x + 2) = 2 − x, which is the opposite of x − 2, so the result is −1/(x + 2).

**N-1.14-B-v3.** What is lim(x→0+) [2/x − 1/x²]?

- A. +∞
- **B. −∞**
- C. 0
- D. −1

Check: Combine: (2x − 1)/x². As x → 0+, the numerator → −1 and the denominator → 0⁺, so the quotient → −∞.
Rationales: A: This follows the 2/x term, but 1/x² is larger than 2/x for small x and is subtracted, so the difference is negative. C: This treats ∞ − ∞ as 0, but the terms do not cancel; the 1/x² term dominates. D: This keeps only the numerator 2x − 1 → −1 and drops the denominator x², which approaches 0.

---

## Seed N-1.15-A (new) — Topic 1.15 Connecting Limits at Infinity and Horizontal Asymptotes
**Skill:** evaluate an ∞ − ∞ limit of a radical difference by multiplying by the conjugate, then divide through by the dominant power.

What is lim(x→∞) [√(x² + 6x) − x]?

- **A. 3**
- B. 0
- C. 6
- D. ∞

Check: Multiply by the conjugate: (x² + 6x − x²)/(√(x² + 6x) + x) = 6x/(√(x² + 6x) + x) → 6/(1 + 1) = 3. Numerically at x = 10⁶ the value is about 3.0000.
Rationales: B: This reasons that √(x² + 6x) is about x for large x so the difference is 0, but the leftover 6x inside the root shifts the value by a constant amount. C: This divides 6x by x only, forgetting that the denominator √(x² + 6x) + x is about 2x, not x. D: This treats ∞ − ∞ as ∞, but the two terms are nearly equal and their difference settles at a finite value.

**N-1.15-A-v1.** What is lim(x→∞) [√(4x² + 20x) − 2x]?

- A. 10
- **B. 5**
- C. 0
- D. ∞

Check: (4x² + 20x − 4x²)/(√(4x² + 20x) + 2x) = 20x/(√(4x² + 20x) + 2x) → 20/(2 + 2) = 5.
Rationales: A: This divides 20x by 2x only and forgets that the denominator includes both radical and 2x, each about 2x, so the denominator is about 4x. C: This treats the radical as about 2x so the difference as 0, ignoring the 20x term that remains after multiplying by the conjugate. D: This treats ∞ − ∞ as ∞, but the two terms differ by a bounded amount.

**N-1.15-A-v2.** What is lim(x→∞) [x − √(x² − 8x)]?

- A. −4
- B. 8
- C. 0
- **D. 4**

Check: (x² − (x² − 8x))/(x + √(x² − 8x)) = 8x/(x + √(x² − 8x)) → 8/(1 + 1) = 4.
Rationales: A: This has the wrong sign; x is larger than √(x² − 8x), so the difference x − √(x² − 8x) is positive. B: This divides 8x by x only, forgetting that the denominator x + √(x² − 8x) is about 2x. C: This treats the two terms as equal for large x, ignoring the −8x inside the root.

**N-1.15-A-v3.** What is lim(x→∞) [√(9x² + x) − 3x]?

- A. 0
- B. 1/3
- **C. 1/6**
- D. ∞

Check: (9x² + x − 9x²)/(√(9x² + x) + 3x) = x/(√(9x² + x) + 3x) → 1/(3 + 3) = 1/6.
Rationales: A: This reasons that √(9x² + x) is about 3x so the difference is 0, but the leftover x term gives a nonzero constant. B: This divides x by 3x only and forgets that the denominator contains the radical, which is also about 3x. D: This treats ∞ − ∞ as ∞, but the difference of the two terms stays bounded.

---

## Seed N-1.15-B (new) — Topic 1.15 Connecting Limits at Infinity and Horizontal Asymptotes
**Skill:** find horizontal asymptotes at both ends of an exponential rational function, recognizing which exponential dominates as x → ∞ and as x → −∞.

Let f(x) = (4eˣ − 1)/(eˣ + 2e^(−x)). Which of the following gives all horizontal asymptotes of the graph of f?

- A. y = 4 only
- **B. y = 0 and y = 4**
- C. y = 4 and y = −1/2
- D. y = 0 only

Check: As x → ∞, e^(−x) → 0, so f → 4eˣ/eˣ = 4. As x → −∞, eˣ → 0 and e^(−x) → ∞, so the numerator → −1 and the denominator → ∞, giving f → 0.
Rationales: A: This finds the limit at +∞ but compares the same leading coefficients at −∞ as well; as x → −∞ the denominator grows without bound while the numerator tends to −1. C: This divides −1 by 2 at the left end, ignoring that the denominator is dominated by 2e^(−x), which tends to infinity, so the ratio goes to 0, not −1/2. D: This finds the left-end limit but misses the right end, where eˣ dominates both numerator and denominator and the ratio tends to 4.

**N-1.15-B-v1.** Let f(x) = (6e^(2x) + eˣ)/(2e^(2x) + 3). Which of the following gives all horizontal asymptotes of the graph of f?

- A. y = 3 only
- B. y = 1/3 and y = 3
- C. y = 0 only
- **D. y = 0 and y = 3**

Check: As x → ∞, divide by e^(2x): (6 + e^(−x))/(2 + 3e^(−2x)) → 6/2 = 3. As x → −∞, e^(2x) → 0 and eˣ → 0, so f → 0/3 = 0.
Rationales: A: This finds only the right-end limit; at the left end the numerator tends to 0 while the denominator tends to 3, so y = 0 is also an asymptote. B: This reads the left-end value as 1/3 by using the coefficient of eˣ over 3, but eˣ → 0 as x → −∞, so the numerator tends to 0. C: This finds only the left-end limit; at the right end the e^(2x) terms dominate and the ratio tends to 6/2 = 3.

**N-1.15-B-v2.** Let f(x) = (5 + 2e^(−x))/(1 + e^(−x)). Which of the following gives all horizontal asymptotes of the graph of f?

- A. y = 5 only
- B. y = 2 only
- **C. y = 2 and y = 5**
- D. y = 0 and y = 5

Check: As x → ∞, e^(−x) → 0 and f → 5/1 = 5. As x → −∞, e^(−x) → ∞ and f → 2e^(−x)/e^(−x) = 2.
Rationales: A: This finds only the right-end limit; as x → −∞, e^(−x) is huge, so the constants 5 and 1 become negligible and the ratio tends to 2. B: This finds only the left-end limit; as x → ∞ the exponential terms vanish and the ratio tends to 5/1 = 5. D: This reads the left end as 0, but both numerator and denominator grow like e^(−x) there, so their ratio approaches 2, not 0.

**N-1.15-B-v3.** Let f(x) = (2x + 1)eˣ/(eˣ + 1). Which of the following gives all horizontal asymptotes of the graph of f?

- **A. y = 0 only**
- B. y = 0 and y = 2
- C. y = 2 only
- D. There are no horizontal asymptotes, because f is unbounded.

Check: As x → −∞, eˣ → 0 so the numerator (2x + 1)eˣ → 0 (exponential decay beats the linear factor) and the denominator → 1, so f → 0. As x → ∞, eˣ/(eˣ + 1) → 1, so f(x) ≈ 2x + 1 → ∞, so no horizontal asymptote on the right.
Rationales: B: At the right end, f behaves like 2x + 1, which grows without bound; the coefficient 2 is not a limit value. C: This reads the coefficient 2 as a limit at the right end, but f(x) ≈ 2x + 1 diverges there, and at the left end f tends to 0. D: Being unbounded on the right does not rule out an asymptote on the left; as x → −∞, f tends to 0, so y = 0 is a horizontal asymptote.

---

## Seed N-1.16-A (new) — Topic 1.16 Working with the Intermediate Value Theorem
**Skill:** count the zeros that the Intermediate Value Theorem guarantees from a table by checking each subinterval for a sign change, rather than comparing endpoints or counting every interval.

A function f is continuous on [0, 8]. Selected values are f(0) = 5, f(2) = −2, f(4) = −6, f(6) = −1, and f(8) = 3. What is the greatest number of zeros of f in the interval (0, 8) that the Intermediate Value Theorem guarantees?

- A. 0
- B. 1
- **C. 2**
- D. 4

Check: Sign changes occur on [0, 2] (5 to −2) and [6, 8] (−1 to 3). The values on [2, 4] and [4, 6] are all negative, so no zero is guaranteed there. So at least 2 zeros are guaranteed.
Rationales: A: This compares only f(0) = 5 and f(8) = 3, which have the same sign, but the intermediate values dip below 0 and give sign changes on two subintervals. B: This finds the sign change on [0, 2] but misses the one on [6, 8], where f goes from −1 to 3. D: This counts every subinterval, but on [2, 4] and [4, 6] both endpoint values are negative, so the theorem guarantees nothing there.

**N-1.16-A-v1.** A function f is continuous on [0, 4]. Selected values are f(0) = 0, f(1) = 3, f(2) = −2, f(3) = 4, and f(4) = 1. What is the least number of distinct solutions of f(x) = 1 in [0, 4] that the Intermediate Value Theorem guarantees?

- A. 3
- **B. 4**
- C. 5
- D. 2

Check: The value 1 lies strictly between the endpoint values on (0, 1) (0 to 3), (1, 2) (3 to −2), and (2, 3) (−2 to 4), giving three distinct solutions in the open intervals, and f(4) = 1 is a fourth. On [3, 4] the value 1 is attained only at the endpoint x = 4, which was already counted.
Rationales: A: This counts the three open subintervals but forgets that f(4) = 1 is itself a solution. C: This counts a fifth solution on (3, 4), but the values 4 and 1 on [3, 4] give the level 1 only at the endpoint x = 4, which is already counted. D: This counts only the crossings on (1, 2) and (2, 3) and overlooks both the rise from 0 to 3 on (0, 1), which passes through 1, and the value f(4) = 1.

**N-1.16-A-v2.** A function f is continuous on [1, 7] with f(1) = 2, f(2) = −3, f(5) = −1, and f(7) = 6. Which statement must be true?

- A. f has at least one zero in the interval (2, 5).
- B. f has exactly two zeros in the interval [1, 7].
- C. f(c) = 7 for some c in [1, 7].
- **D. f has at least one zero in (1, 2) and at least one zero in (5, 7).**

Check: Sign change on [1, 2] (2 to −3) and on [5, 7] (−1 to 6) give zeros in (1, 2) and (5, 7). On [2, 5] both values are negative, so no zero is guaranteed there.
Rationales: A: The values f(2) = −3 and f(5) = −1 are both negative, so the theorem does not guarantee a zero between them; f could stay negative. B: The theorem only guarantees at least two zeros; additional zeros could occur, for instance if f crosses 0 and returns in the middle. C: The given values only reach 6, and 7 is not guaranteed to be between any two known values.

**N-1.16-A-v3.** A function f is continuous on [0, 3] with f(0) = 2, f(1) = 0, f(2) = 5, and f(3) = 1. What is the least number of solutions of f(x) = x in the interval (0, 3) that the Intermediate Value Theorem guarantees?

- **A. 3**
- B. 1
- C. 2
- D. 4

Check: Let g(x) = f(x) − x, continuous. g(0) = 2, g(1) = −1, g(2) = 3, g(3) = −2. Sign changes occur on (0, 1), (1, 2), and (2, 3), so at least 3 solutions of g(x) = 0.
Rationales: B: This compares f with x only at the endpoints, f(0) = 2 above x = 0 and f(3) = 1 below x = 3, and finds one crossing, ignoring the interior points. C: This finds the crossings on (0, 1) and (1, 2) but misses the one on (2, 3), where g goes from 3 to −2. D: This counts four solutions, one per given point, but the theorem guarantees solutions on subintervals with a sign change, and there are only three such intervals.

---

## Seed N-1.16-B (new) — Topic 1.16 Working with the Intermediate Value Theorem
**Skill:** choose the interval on which the Intermediate Value Theorem actually applies to an equation, checking both continuity and a sign change of the rewritten function.

Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of eˣ + x² = 4?

- A. [−1, 1]
- B. [0, 1]
- C. [2, 3]
- **D. [1, 2]**

Check: Let h(x) = eˣ + x² − 4, continuous everywhere. h(−1) ≈ −2.63, h(0) = −3, h(1) ≈ −0.28, h(2) = e² ≈ 7.39, h(3) ≈ 25.1. Only [1, 2] has h(1) < 0 < h(2).
Rationales: A: Here h(−1) ≈ −2.63 and h(1) ≈ −0.28 are both negative, so no sign change is shown and the theorem guarantees nothing. B: Here h(0) = −3 and h(1) ≈ −0.28 are both negative, so the theorem gives no solution. C: Here h(2) ≈ 7.39 and h(3) ≈ 25.1 are both positive, so there is no sign change.

**N-1.16-B-v1.** Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of ln x + x² = 3?

- A. [0, 2]
- **B. [1, 2]**
- C. [2, 3]
- D. [1/2, 1]

Check: Let h(x) = ln x + x² − 3, continuous for x > 0. h(1) = −2, h(2) = ln 2 + 1 ≈ 1.69. On [2, 3], h(2) > 0 and h(3) > 0. On [1/2, 1], h(1/2) ≈ −3.44 and h(1) = −2 are both negative. h is not defined at 0.
Rationales: A: The function ln x is not defined at x = 0, so h is not continuous on [0, 2] and the theorem cannot be applied there. C: Here h(2) ≈ 1.69 and h(3) ≈ 7.1 are both positive, so there is no sign change. D: Here h(1/2) ≈ −3.44 and h(1) = −2 are both negative, so the theorem guarantees nothing.

**N-1.16-B-v2.** Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of tan x = −1?

- **A. [2, 3]**
- B. [1, 2]
- C. [0, 1]
- D. [3, 4]

Check: Let g(x) = tan x + 1. g(2) ≈ −1.19, g(3) ≈ 0.86, and g is continuous on [2, 3] since π/2 ≈ 1.57 and 3π/2 ≈ 4.71 lie outside it. On [1, 2], g(1) ≈ 2.56 and g(2) ≈ −1.19 differ in sign but π/2 is inside the interval. On [0, 1], g(0) = 1 and g(1) ≈ 2.56 are positive. On [3, 4], g(3) ≈ 0.86 and g(4) ≈ 2.16 are positive.
Rationales: B: The endpoint values have opposite signs, but tan x is not continuous on [1, 2] because it has a vertical asymptote at π/2 ≈ 1.57, so the theorem does not apply. C: Here g(0) = 1 and g(1) ≈ 2.56 are both positive, so no sign change. D: Here g(3) ≈ 0.86 and g(4) ≈ 2.16 are both positive, so no sign change.

**N-1.16-B-v3.** Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of x·ln x = 3?

- A. [0, 3]
- B. [1, 2]
- **C. [2, 3]**
- D. [3, 4]

Check: Let h(x) = x ln x − 3. h(1) = −3, h(2) ≈ −1.61, h(3) ≈ 0.30, h(4) ≈ 2.55. Only [2, 3] has a sign change; h is continuous for x > 0 and not defined at 0.
Rationales: A: The function x ln x is not defined at x = 0, so h is not continuous on the closed interval [0, 3] and the theorem cannot be used there. B: Here h(1) = −3 and h(2) ≈ −1.61 are both negative, so there is no sign change. D: Here h(3) ≈ 0.30 and h(4) ≈ 2.55 are both positive, so no sign change.
