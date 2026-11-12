# AP Calculus AB topics 1.9 to 1.16: harder second seeds (Unit 1, second half)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key recomputed in Python (limits, factorisations, sign tables, interval endpoint values). Calculator-free; no images; graphs and tables described in words.
Target level: R3 interpretation, multi-step reasoning and error analysis. Seed A and seed B in each topic test different skills; variants keep the skill with new functions, contexts and wrong-answer structures.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.9-A | 1.9 Connecting Multiple Representations of L | new |
| N-1.9-B | 1.9 Connecting Multiple Representations of L | new |
| N-1.10-A | 1.10 Exploring Types of Discontinuities | new |
| N-1.10-B | 1.10 Exploring Types of Discontinuities | new |
| N-1.11-A | 1.11 Defining Continuity at a Point | new |
| N-1.11-B | 1.11 Defining Continuity at a Point | new |
| N-1.12-A | 1.12 Confirming Continuity over an Interval | new |
| N-1.12-B | 1.12 Confirming Continuity over an Interval | new |
| N-1.13-A | 1.13 Removing Discontinuities | new |
| N-1.13-B | 1.13 Removing Discontinuities | new |
| N-1.14-A | 1.14 Connecting Infinite Limits and Vertical  | new |
| N-1.14-B | 1.14 Connecting Infinite Limits and Vertical  | new |
| N-1.15-A | 1.15 Connecting Limits at Infinity and Horizo | new |
| N-1.15-B | 1.15 Connecting Limits at Infinity and Horizo | new |
| N-1.16-A | 1.16 Working with the Intermediate Value Theo | new |
| N-1.16-B | 1.16 Working with the Intermediate Value Theo | new |

---

## Seed N-1.9-A (new) — Topic 1.9 Connecting Multiple Representations of Limits
**Skill:** evaluate a limit of a composite g(f(x)) by combining a verbally described graph of f with a piecewise rule for g, tracking the side from which f(x) approaches the inner limit.

The graph of f near x = 2 is described as follows: as x approaches 2 from either side, f(x) increases toward 3 but always stays below 3, and the point on the graph at x = 2 is (2, 5). The function g is defined by g(u) = 2u + 1 for u < 3 and g(u) = u² − 1 for u ≥ 3. What is lim(x→2) g(f(x))?

- **A. 7**
- B. 8
- C. The limit does not exist
- D. 24
Check: Since f(x) → 3 from below, g(f(x)) → lim(u→3−) g(u) = 2(3) + 1 = 7. The values g(3) = 8 and g(f(2)) = g(5) = 24 are not what the limit follows.
Rationales: B: This evaluates the piece of g that applies at u = 3 itself, u² − 1 = 8, but the inputs f(x) stay below 3, so the left-hand piece of g governs the limit. C: g has different one-sided limits at u = 3, but here the inputs f(x) approach 3 only from below, so only the left-hand piece matters and the limit does exist. D: This substitutes f(2) = 5 into g. The limit depends on how f(x) behaves near x = 2, not on the single value f(2).

**N-1.9-A-v1.** A graph of f near x = 4 is described as follows: as x approaches 4 from either side, f(x) decreases toward −1 but always stays above −1, and the point on the graph at x = 4 is (4, 2). The function g is defined by g(u) = u + 5 for u ≤ −1 and g(u) = u² + 2 for u > −1. What is lim(x→4) g(f(x))?

- A. 4
- **B. 3**
- C. The limit does not exist
- D. 6
Check: f(x) → −1 from above, so g(f(x)) → lim(u→−1+) (u² + 2) = 3.
Rationales: A: This uses the piece u + 5 that applies at u = −1 itself, giving 4, but the inputs f(x) stay above −1, so the right-hand piece u² + 2 governs. C: g has a jump at u = −1, but the inputs f(x) approach −1 only from above, so only one piece matters and the limit exists. D: This substitutes f(4) = 2 into g to get g(2) = 6. The limit depends on the behaviour of f near x = 4, not on the value f(4).

**N-1.9-A-v2.** Near x = −3 the function f satisfies f(x) > 2 for every x ≠ −3, f(x) approaches 2 as x → −3, and f(−3) = 2. The function g is given by g(u) = (u² − 4)/(u − 2) for u ≠ 2 and g(2) = 7. What is lim(x→−3) g(f(x))?

- A. 7
- B. 2
- **C. 4**
- D. The limit does not exist
Check: For u ≠ 2, g(u) = u + 2, and f(x) ≠ 2 near −3, so g(f(x)) = f(x) + 2 → 4.
Rationales: A: This uses g(2) = 7. The inputs f(x) approach 2 but are never equal to 2 for x ≠ −3, so the limit follows the formula (u² − 4)/(u − 2) = u + 2, not the single value g(2). B: This is lim f(x), the inner limit, not the limit of g(f(x)). The inner limit must still be fed through g. D: After cancelling, g(u) = u + 2 for u ≠ 2, which is continuous near 2 in the limit sense, so the limit exists and the answer is not DNE.

**N-1.9-A-v3.** A graph of f near x = 0 is described as follows: as x approaches 0 from either side, f(x) increases toward 1 but always stays below 1, and f(0) = 4. The function g is defined by g(u) = |u − 1|/(u − 1) for u ≠ 1. What is lim(x→0) g(f(x))?

- A. 1
- B. 0
- C. The limit does not exist
- **D. −1**
Check: f(x) < 1 near 0, so |f(x) − 1| = −(f(x) − 1) and g(f(x)) = −1 for every x near 0, giving −1.
Rationales: A: This is the value of g for u > 1 (and also g(f(0)) = g(4) = 1). The inputs f(x) approach 1 from below, where |u − 1| = −(u − 1), so the quotient is −1. B: This averages the one-sided limits −1 and 1 of g at u = 1. Limits are not averaged, and here the inputs reach 1 only from below, so only −1 matters. C: g has different one-sided limits at u = 1, but f(x) approaches 1 only from below, so only the left-hand limit is used and the limit exists.

---

## Seed N-1.9-B (new) — Topic 1.9 Connecting Multiple Representations of Limits
**Skill:** evaluate a one-sided limit of f(c − x) or f(c·x) from limits of f at a point, recognising that a negative inside factor swaps the side of approach.

A function f satisfies lim(x→2−) f(x) = 5, lim(x→2+) f(x) = −1, and f(2) = 3. What is lim(x→−2+) f(−x)?

- A. −1
- **B. 5**
- C. 3
- D. The limit does not exist
Check: If x → −2+, then x > −2, so −x < 2 and −x → 2−. So the limit is lim(u→2−) f(u) = 5.
Rationales: A: This reads the right-hand limit of f at 2. As x → −2 from the right, −x approaches 2 from the left, so the left-hand limit 5 is the one needed. C: This is f(2), the function value. The limit depends on the nearby values, not on the value at the point. D: The two-sided limit of f at 2 does not exist, but the question asks about one side only, which is determined.

**N-1.9-B-v1.** A function f satisfies lim(x→2−) f(x) = 4, lim(x→2+) f(x) = 0, and f(2) = 7. What is lim(x→1−) f(3 − x)?

- **A. 0**
- B. 4
- C. 7
- D. The limit does not exist
Check: x → 1− gives 3 − x → 2+, so the limit is lim(u→2+) f(u) = 0.
Rationales: B: This reads the left-hand limit at 2. As x → 1 from the left, x < 1, so 3 − x > 2 and the input approaches 2 from the right. C: This is f(2), the function value. The limit depends on nearby values only. D: The two-sided limit of f at 2 does not exist, but only one side is involved here, so the one-sided limit exists.

**N-1.9-B-v2.** A function f satisfies lim(x→6−) f(x) = −3, lim(x→6+) f(x) = 2, and f(6) = 1. What is lim(x→−3+) f(−2x)?

- A. 2
- B. 1
- C. The limit does not exist
- **D. −3**
Check: x > −3 gives −2x < 6, so −2x → 6−. The limit is lim(u→6−) f(u) = −3.
Rationales: A: This reads the right-hand limit at 6. As x → −3 from the right, x > −3, so −2x < 6 and the input approaches 6 from the left. B: This is f(6), the function value, which does not determine the limit. C: f has no two-sided limit at 6, but the one-sided approach here is fixed from the left, so the limit exists.

**N-1.9-B-v3.** A function f satisfies lim(x→2−) f(x) = 6, lim(x→2+) f(x) = 2, and f(2) = 4. What is lim(x→−1) f(1 − x)?

- A. 6
- B. 2
- **C. The limit does not exist**
- D. 4
Check: x → −1 from either side makes 1 − x approach 2 from both sides, and the one-sided limits 6 and 2 differ, so the limit does not exist.
Rationales: A: This uses only the left-hand limit. As x → −1 from the left, 1 − x approaches 2 from the right, giving 2; from the right it gives 6. The two sides disagree. B: This uses only one side. The inputs 1 − x approach 2 from both sides as x → −1, so both one-sided limits of f at 2 are involved. D: This is f(2), the function value. The limit is decided by nearby values, which give 6 and 2.

---

## Seed N-1.10-A (new) — Topic 1.10 Exploring Types of Discontinuities
**Skill:** classify discontinuities of a rational function containing an absolute value by comparing one-sided limits, distinguishing jump from removable and infinite types.

Let f(x) = |x − 3|/(x² − 9). Which of the following correctly describes the discontinuities of f?

- A. A removable discontinuity at x = 3 and an infinite discontinuity at x = −3
- B. Infinite discontinuities at both x = 3 and x = −3
- **C. A jump discontinuity at x = 3 and an infinite discontinuity at x = −3**
- D. A jump discontinuity at x = 3 and a removable discontinuity at x = −3
Check: At x = 3 the one-sided limits are −1/6 and 1/6 (jump); at x = −3 the numerator is 6 and the denominator tends to 0 (infinite).
Rationales: A: This cancels x − 3 without handling the absolute value. For x > 3 the quotient is 1/(x + 3), but for x < 3 it is −1/(x + 3), so the one-sided limits are 1/6 and −1/6, not equal. B: At x = 3 the factor x − 3 cancels in magnitude, leaving finite one-sided limits ±1/6. Only x = −3 makes the quotient unbounded. D: At x = −3 the numerator is |−6| = 6, which is not 0, while the denominator tends to 0, so the quotient is unbounded rather than approaching a finite limit.

**N-1.10-A-v1.** Let g(x) = |x + 2|/(x² + x − 2). Which of the following correctly describes the discontinuities of g?

- **A. A jump discontinuity at x = −2 and an infinite discontinuity at x = 1**
- B. A removable discontinuity at x = −2 and an infinite discontinuity at x = 1
- C. Infinite discontinuities at both x = −2 and x = 1
- D. A jump discontinuity at x = 1 and an infinite discontinuity at x = −2
Check: Near −2 the one-sided limits are 1/3 (left) and −1/3 (right); near 1 the numerator is 3 and the denominator tends to 0.
Rationales: B: Cancelling x + 2 requires |x + 2| = x + 2, true only for x > −2. For x < −2 the quotient is −1/(x − 1), so the one-sided limits 1/3 and −1/3 differ. C: At x = −2 the factor x + 2 cancels in magnitude, so the one-sided limits are finite, ±1/3. Only x = 1 is an infinite discontinuity. D: The roles are reversed. At x = 1 the numerator is 3 and the denominator tends to 0, which is infinite. At x = −2 the one-sided limits are finite and unequal, a jump.

**N-1.10-A-v2.** Let h(x) = |2x − 6|/(x² − 2x − 3). Which of the following correctly describes the discontinuities of h?

- A. A removable discontinuity at x = 3 and an infinite discontinuity at x = −1
- **B. A jump discontinuity at x = 3 and an infinite discontinuity at x = −1**
- C. A jump discontinuity at x = −1 and an infinite discontinuity at x = 3
- D. Jump discontinuities at both x = 3 and x = −1
Check: At x = 3 the one-sided limits are −1/2 and 1/2; at x = −1 the numerator is 8 and the denominator tends to 0.
Rationales: A: The absolute value makes the quotient equal 2/(x + 1) for x > 3 but −2/(x + 1) for x < 3, so the one-sided limits at 3 are 1/2 and −1/2, which differ. C: At x = −1 the numerator is |−8| = 8 and the denominator tends to 0, so that point is infinite. The finite, unequal one-sided limits occur at x = 3. D: At x = −1 the numerator is 8 and the denominator tends to 0, so the one-sided limits are unbounded, not finite and unequal.

**N-1.10-A-v3.** Let q(x) = (x² − 9)/|x + 3|. Which of the following correctly describes the discontinuities of q?

- A. Only a removable discontinuity, at x = −3
- B. An infinite discontinuity at x = −3
- C. A jump discontinuity at x = −3 and an infinite discontinuity at x = 3
- **D. Only a jump discontinuity, at x = −3, with one-sided limits 6 and −6**
Check: For x < −3, q(x) = −(x − 3) → 6; for x > −3, q(x) = x − 3 → −6. The denominator is nonzero away from −3, so there is no other discontinuity.
Rationales: A: Cancelling x + 3 with |x + 3| works on one side only. From the left the quotient equals −(x − 3), approaching 6, from the right it equals x − 3, approaching −6, so there is no single limit. B: The factor x + 3 in the numerator offsets the factor in |x + 3| in the denominator, so the quotient stays bounded near −3. C: The point x = 3 makes the numerator 0, not the denominator. q(3) = 0 and q is continuous there, so there is no infinite discontinuity.

---

## Seed N-1.10-B (new) — Topic 1.10 Exploring Types of Discontinuities
**Skill:** choose the parameter that turns a discontinuity at a break point into a removable one rather than a jump, using one-sided limits and a given point value.

A function f is defined by f(x) = 3x + 1 for x < 2, f(2) = 10, and f(x) = x² + k for x > 2, where k is a constant. For which value of k does f have a removable discontinuity at x = 2?

- A. k = 6
- B. k = 7
- C. k = 10
- **D. k = 3**
Check: The left limit is 3(2) + 1 = 7. A removable discontinuity needs the right limit 4 + k = 7, so k = 3, and f(2) = 10 ≠ 7 keeps it discontinuous.
Rationales: A: This makes the right-hand limit 4 + k equal to f(2) = 10, but the left-hand limit is 7, so the two-sided limit still fails to exist, giving a jump. B: This sets k equal to the left-hand limit 7, forgetting that the right-hand limit is 2² + k = 4 + k. C: This sets k equal to f(2). The right-hand limit is 4 + k, so k = 10 gives 14, which does not match the left-hand limit 7.

**N-1.10-B-v1.** A function g is defined by g(x) = x² + 2x for x < 1, g(1) = 0, and g(x) = kx + 5 for x > 1, where k is a constant. For which value of k does g have a removable discontinuity at x = 1?

- A. k = −5
- **B. k = −2**
- C. k = 8
- D. k = 3
Check: The left limit is 1 + 2 = 3. A removable discontinuity needs k + 5 = 3, so k = −2, and g(1) = 0 ≠ 3.
Rationales: A: This sets kx + 5 = g(1) = 0 at x = 1. The limit must match the left-hand limit 3, not the point value. C: This solves k + 5 = 3 with a sign slip, moving +5 across the equation as +5. D: This sets k equal to the left-hand limit 3. The right-hand limit is k(1) + 5 = k + 5.

**N-1.10-B-v2.** A function f is defined by f(x) = (x² − 9)/(x − 3) for x < 3, f(3) = 1, and f(x) = kx − 12 for x > 3, where k is a constant. For which value of k does f have a removable discontinuity at x = 3?

- **A. k = 6**
- B. k = 13/3
- C. k = 4
- D. k = 18
Check: For x < 3, f(x) = x + 3 → 6. Need 3k − 12 = 6, so k = 6; f(3) = 1 ≠ 6.
Rationales: B: This sets kx − 12 equal to f(3) = 1 at x = 3. The limit from the right must equal the limit from the left, which is 6. C: This sets 3k − 12 = 0, matching nothing in the problem. The left-hand limit is 6, not 0. D: This stops after finding 3k = 18, forgetting to divide by 3.

**N-1.10-B-v3.** A function f is defined by f(x) = x² + 3x for x < −1, f(−1) = 5, and f(x) = k − x for x > −1, where k is a constant. For which value of k does f have a removable discontinuity at x = −1?

- A. k = −1
- B. k = 4
- **C. k = −3**
- D. k = −2
Check: The left limit is 1 − 3 = −2. Need k − (−1) = k + 1 = −2, so k = −3, and f(−1) = 5 ≠ −2.
Rationales: A: This evaluates k − x at x = −1 as k − 1 instead of k + 1. B: This sets k + 1 = f(−1) = 5. The right-hand limit must match the left-hand limit −2, not the point value. D: This sets k equal to the left-hand limit −2, ignoring the −x term, which contributes +1 at x = −1.

---

## Seed N-1.11-A (new) — Topic 1.11 Defining Continuity at a Point
**Skill:** apply the three-part definition of continuity at two junctions of a three-piece function, writing and solving two linear equations for the middle piece's coefficients.

A function f is defined by f(x) = x + 1 for x < 1, f(x) = ax + b for 1 ≤ x ≤ 3, and f(x) = x² − 2 for x > 3, where a and b are constants. For what value of a is f continuous for all real x?

- **A. a = 5/2**
- B. a = 5
- C. a = 2
- D. a = 7/3
Check: Continuity at 1 gives a + b = 2, at 3 gives 3a + b = 7. Subtracting gives 2a = 5.
Rationales: B: This subtracts the two matching values (7 − 2) without dividing by the interval length 2. C: This uses only the condition at x = 1, a + b = 2, and assumes b = 0. D: This assumes b = 0 in the condition at x = 3, 3a = 7, and ignores the condition at x = 1.

**N-1.11-A-v1.** A function f is defined by f(x) = 2x − 1 for x < −2, f(x) = ax + b for −2 ≤ x ≤ 1, and f(x) = x² + 3 for x > 1, where a and b are constants. For what value of b is f continuous for all real x?

- A. b = 4
- **B. b = 1**
- C. b = −5
- D. b = 2
Check: At −2: −2a + b = −5. At 1: a + b = 4. Subtracting gives 3a = 9, a = 3, so b = 1.
Rationales: A: This assumes a = 0 in the condition at x = 1, a + b = 4, and ignores the other junction. C: This takes b equal to the matching value −5 at x = −2, ignoring the term −2a. D: This takes a = 2 and uses a + b = 4 without checking the condition at x = −2.

**N-1.11-A-v2.** A function f is defined by f(x) = x² for x < 2, f(x) = ax + b for 2 ≤ x ≤ 4, and f(x) = 16 − x for x > 4, where a and b are constants. For what value of a is f continuous for all real x?

- A. a = 8
- B. a = 3
- **C. a = 4**
- D. a = 2
Check: At 2: 2a + b = 4. At 4: 4a + b = 12. Subtracting gives 2a = 8, so a = 4 (and b = −4).
Rationales: A: This subtracts the matching values 12 − 4 without dividing by the interval length 2. B: This assumes b = 0 in the condition at x = 4, 4a = 12, and ignores x = 2. D: This assumes b = 0 in the condition at x = 2, 2a = 4, and ignores x = 4.

**N-1.11-A-v3.** A function f is defined by f(x) = x³ for x < 1, f(x) = ax + b for 1 ≤ x ≤ 2, and f(x) = 12 − x² for x > 2, where a and b are constants. For what value of b is f continuous for all real x?

- A. b = 6
- B. b = 1
- C. b = 7
- **D. b = −6**
Check: At 1: a + b = 1. At 2: 2a + b = 8. Subtracting gives a = 7, so b = 1 − 7 = −6.
Rationales: A: This finds a = 7 correctly but makes a sign error in b = 1 − a. B: This assumes a = 0 in the condition at x = 1, a + b = 1. C: This reports a = 7, the slope, instead of the intercept b.

---

## Seed N-1.11-B (new) — Topic 1.11 Defining Continuity at a Point
**Skill:** find the parameter values that make a piecewise function continuous at a point when the matching condition is a quadratic equation in the parameter.

A function f is defined by f(x) = kx − 3 for x < 3 and f(x) = x + k² − 4 for x ≥ 3, where k is a constant. For which values of k is f continuous at x = 3?

- A. k = −1 or k = −2
- **B. k = 1 or k = 2**
- C. k = 2/3
- D. k = 0 or k = 3
Check: Left limit 3k − 3, f(3) = 3 + k² − 4 = k² − 1. Setting equal: k² − 3k + 2 = 0, so k = 1 or 2.
Rationales: A: This solves k² − 3k + 2 = 0 with the signs of the roots reversed. C: This drops the k² term from the right-hand piece, leaving 3k − 3 = −1. D: This drops the constant 2 and solves k² − 3k = 0.

**N-1.11-B-v1.** A function f is defined by f(x) = kx + 2 for x < 2 and f(x) = x + k² − 8 for x ≥ 2, where k is a constant. For which values of k is f continuous at x = 2?

- **A. k = 4 or k = −2**
- B. k = −4 or k = 2
- C. k = 4 only
- D. No value of k
Check: Left limit 2k + 2; f(2) = 2 + k² − 8 = k² − 6. So k² − 2k − 8 = 0, giving k = 4 or k = −2.
Rationales: B: This solves k² − 2k − 8 = 0 with the signs of the roots reversed. C: This keeps one root of k² − 2k − 8 = 0 and discards k = −2. Both roots work, since k can be any constant. D: This follows from a sign slip that gives k² − 2k + 8 = 0, which has no real roots. The correct equation k² − 2k − 8 = 0 has two.

**N-1.11-B-v2.** A function f is defined by f(x) = kx + 3 for x < 2 and f(x) = x² − 4 + k² for x ≥ 2, where k is a constant. For which values of k is f continuous at x = 2?

- A. k = −3 or k = 1
- B. k = 3 only
- C. No value of k
- **D. k = 3 or k = −1**
Check: Left limit 2k + 3; f(2) = 4 − 4 + k² = k². So k² − 2k − 3 = 0, giving k = 3 or k = −1.
Rationales: A: This solves k² − 2k − 3 = 0 with the signs of the roots reversed. B: This keeps one root and discards k = −1. Both roots work. C: This follows from a sign slip that gives k² − 2k + 3 = 0, which has no real roots. The correct equation k² − 2k − 3 = 0 has two.

**N-1.11-B-v3.** A function f is defined by f(x) = 3kx + 10 for x < 1 and f(x) = k²x for x ≥ 1, where k is a constant. For which values of k is f continuous at x = 1?

- A. k = −5 or k = 2
- B. k = 5 only
- **C. k = 5 or k = −2**
- D. No value of k
Check: Left limit 3k + 10, f(1) = k². So k² − 3k − 10 = 0, giving k = 5 or k = −2.
Rationales: A: This solves k² − 3k − 10 = 0 with the signs of the roots reversed. B: This keeps one root and discards k = −2. Both roots work. D: This follows from a sign slip that gives k² − 3k + 10 = 0, which has no real roots. The correct equation k² − 3k − 10 = 0 has two.

---

## Seed N-1.12-A (new) — Topic 1.12 Confirming Continuity over an Interval
**Skill:** decide on which closed interval a function with a radical or logarithm and a rational factor is continuous, checking the domain and the points where the denominator vanishes.

Let f(x) = √(x² − 4x)/(x − 5). On which of the following closed intervals is f continuous?

- A. [4, 6]
- B. [0, 4]
- **C. [−3, 0]**
- D. [5, 8]
Check: x² − 4x ≥ 0 for x ≤ 0 or x ≥ 4, and x ≠ 5. On [−3, 0] f is defined and continuous (one-sided at the endpoint 0).
Rationales: A: This interval contains x = 5, where the denominator is 0 and f is undefined. B: For 0 < x < 4 the radicand x² − 4x is negative, so f is undefined at most points of this interval. D: The left endpoint x = 5 makes the denominator 0, so f is not defined or continuous at 5.

**N-1.12-A-v1.** Let f(x) = ln(x² − 9)/(x − 5). On which of the following closed intervals is f continuous?

- **A. [−6, −4]**
- B. [4, 6]
- C. [−5, −3]
- D. [−4, 4]
Check: x² − 9 > 0 requires |x| > 3, and x ≠ 5. All of [−6, −4] satisfies this.
Rationales: B: This contains x = 5, where the denominator is 0. C: The endpoint x = −3 gives ln 0, which is undefined, so f is not defined at −3 and cannot be continuous there. D: For −3 ≤ x ≤ 3 the argument x² − 9 is not positive, so f is undefined on much of this interval.

**N-1.12-A-v2.** Let f(x) = 1/(√(x − 1) − 2). On which of the following closed intervals is f continuous?

- A. [1, 5]
- **B. [1, 4]**
- C. [0, 4]
- D. [2, 6]
Check: The radical needs x ≥ 1 and the denominator is zero only at x = 5, so f is continuous on [1, 4] (one-sided at 1).
Rationales: A: At x = 5, √4 − 2 = 0, so the denominator vanishes and f is undefined. C: For x < 1 the radical √(x − 1) is not defined, so f is not defined at x = 0. D: This contains x = 5, where the denominator is 0.

**N-1.12-A-v3.** Let f(x) = sin x/(2cos x − 1). On which of the following closed intervals is f continuous?

- A. [0, π/2]
- B. [−π/3, 0]
- C. [π/6, π/2]
- **D. [−π/6, π/6]**
Check: The denominator is zero when cos x = 1/2, that is x = ±π/3 + 2πn. [−π/6, π/6] contains none of these.
Rationales: A: This contains x = π/3, where cos x = 1/2 and the denominator is 0. B: The endpoint x = −π/3 has cos x = 1/2, so the denominator is 0 there and f is undefined. C: This contains x = π/3, where the denominator is 0.

---

## Seed N-1.12-B (new) — Topic 1.12 Confirming Continuity over an Interval
**Skill:** use a verbal description of limits and values at specific points to decide on which interval a function is continuous, applying one-sided continuity at endpoints.

A function f is defined on [0, 8]. It is known that lim(x→3−) f(x) = 2, lim(x→3+) f(x) = 2, and f(3) = 2; that lim(x→6−) f(x) = 4, lim(x→6+) f(x) = 1, and f(6) = 1; and that f is continuous at every other point of [0, 8] (one-sided at the endpoints). On which of the following sets is f continuous?

- A. [0, 6]
- B. [3, 8]
- C. (0, 8)
- **D. [0, 6)**
Check: f is continuous at 3 and everywhere except at 6, so it is continuous on [0, 6) and on [6, 8].
Rationales: A: At x = 6 the left-hand limit 4 does not equal f(6) = 1, so f is not continuous from the left at 6, and 6 cannot be the right endpoint of an interval of continuity. B: This contains x = 6, where the limit from the left differs from the limit from the right. C: This contains x = 6 as an interior point, where f has a jump.

**N-1.12-B-v1.** A function f is defined on [−4, 4]. It is known that lim(x→−1−) f(x) = 5, lim(x→−1+) f(x) = 5, and f(−1) = 5; that lim(x→2−) f(x) = 3, lim(x→2+) f(x) = 3, and f(2) = 0; and that f is continuous at every other point of [−4, 4] (one-sided at the endpoints). On which of the following sets is f continuous?

- A. [−4, 4]
- **B. [−4, 2) ∪ (2, 4]**
- C. [−4, 2]
- D. (−4, −1) ∪ (−1, 4)
Check: The only point of discontinuity is x = 2, so f is continuous on [−4, 2) ∪ (2, 4].
Rationales: A: At x = 2 the limit is 3 but f(2) = 0, so f has a removable discontinuity at 2. C: The right endpoint x = 2 fails continuity from the left, since the limit 3 differs from f(2) = 0. D: This wrongly removes x = −1, where the limit and the value are both 5, so f is continuous there.

**N-1.12-B-v2.** A function f is defined on [1, 9] except at x = 7, where f is undefined and lim(x→7) f(x) = ∞ from both sides. Also lim(x→3−) f(x) = 2, lim(x→3+) f(x) = 5, and f(3) = 5, and f is continuous at every other point of its domain (one-sided at the endpoints). Which of the following is the longest interval on which f is continuous?

- **A. [3, 7)**
- B. [1, 7)
- C. [3, 7]
- D. [1, 3]
Check: f is continuous from the right at 3 (limit 5 = f(3)) and continuous up to but not including 7, so [3, 7) has length 4, longer than [1, 3) or (7, 9].
Rationales: B: This contains x = 3 as an interior point, where the one-sided limits 2 and 5 differ. C: f is not defined at 7, so 7 cannot belong to an interval of continuity. D: The right endpoint x = 3 requires continuity from the left, but the left-hand limit 2 differs from f(3) = 5.

**N-1.12-B-v3.** A function f is defined on [0, 10]. The graph has a sharp corner at x = 5, but lim(x→5) f(x) = f(5) = 2. At x = 8, lim(x→8−) f(x) = 4 = f(8) and lim(x→8+) f(x) = 1. At every other point f is continuous (one-sided at the endpoints). Which of the following is the longest interval on which f is continuous?

- A. [0, 10]
- B. [5, 10]
- **C. [0, 8]**
- D. [0, 5]
Check: f is continuous at 5 (limit equals value) and left-continuous at 8, so f is continuous on [0, 8], which has length 8.
Rationales: A: This contains x = 8 as an interior point, where the right-hand limit 1 differs from f(8) = 4. B: This also contains x = 8 as an interior point, where f has a jump. D: f is continuous on this interval, but it stops short because the corner at 5 is mistaken for a discontinuity. A corner does not break continuity.

---

## Seed N-1.13-A (new) — Topic 1.13 Removing Discontinuities
**Skill:** find the value that removes a discontinuity of a complex fraction by combining the fractions, factoring and cancelling to find the limit.

Let g(x) = (1/x − 1/2)/(x − 2) for x ≠ 0 and x ≠ 2. What value should be assigned to g(2) so that g is continuous at x = 2?

- **A. −1/4**
- B. 1/4
- C. −1/2
- D. 0
Check: (1/x − 1/2)/(x − 2) = ((2 − x)/(2x))/(x − 2) = −1/(2x), which tends to −1/4 as x → 2.
Rationales: B: This has a sign error. 1/x − 1/2 = (2 − x)/(2x), whose factor 2 − x is −(x − 2), so the quotient is −1/(2x). C: This drops the 2 in the denominator, simplifying to −1/x and evaluating at x = 2. D: This substitutes into the numerator, where 1/2 − 1/2 = 0, and ignores that the denominator is also 0.

**N-1.13-A-v1.** Let g(x) = (1/(x + 1) − 1/4)/(x − 3) for x ≠ −1 and x ≠ 3. What value should be assigned to g(3) so that g is continuous at x = 3?

- A. 1/16
- **B. −1/16**
- C. −1/4
- D. 0
Check: 1/(x + 1) − 1/4 = (3 − x)/(4(x + 1)), so g(x) = −1/(4(x + 1)) → −1/16.
Rationales: A: This has a sign error. The numerator combines to (3 − x)/(4(x + 1)), and 3 − x is −(x − 3). C: This forgets the factor x + 1 in the denominator, leaving −1/4 instead of −1/(4(x + 1)). D: This substitutes into the numerator, getting 1/4 − 1/4 = 0, and ignores the zero in the denominator.

**N-1.13-A-v2.** Let g(x) = (1/x² − 1/9)/(x − 3) for x ≠ 0 and x ≠ 3. What value should be assigned to g(3) so that g is continuous at x = 3?

- A. 2/27
- B. −2/3
- **C. −2/27**
- D. 0
Check: 1/x² − 1/9 = (9 − x²)/(9x²), so g(x) = −(x + 3)/(9x²) → −6/81 = −2/27.
Rationales: A: This has a sign error. 9 − x² = −(x − 3)(x + 3), so the quotient is −(x + 3)/(9x²). B: This forgets the x² in the denominator and evaluates −(x + 3)/9. D: This substitutes into the numerator, getting 1/9 − 1/9 = 0, and ignores the zero in the denominator.

**N-1.13-A-v3.** Let g(x) = (1/(2x − 1) − 1)/(x − 1) for x ≠ 1/2 and x ≠ 1. What value should be assigned to g(1) so that g is continuous at x = 1?

- A. 2
- B. −1
- C. 0
- **D. −2**
Check: 1/(2x − 1) − 1 = (2 − 2x)/(2x − 1) = −2(x − 1)/(2x − 1), so g(x) = −2/(2x − 1) → −2.
Rationales: A: This has a sign error. 1 − (2x − 1) = 2 − 2x = −2(x − 1). B: This loses the factor 2 from 2 − 2x and evaluates −1/(2x − 1). C: This substitutes into the numerator, getting 1 − 1 = 0, and ignores the zero in the denominator.

---

## Seed N-1.13-B (new) — Topic 1.13 Removing Discontinuities
**Skill:** combine a given function value with continuity at a point to determine unknown coefficients in the numerator of a rational function, using that the numerator must vanish at the removed point.

The function f is defined by f(x) = (x² + ax + b)/(x − 3) for x ≠ 3 and f(3) = 5, where a and b are constants. If f is continuous at x = 3, what is the value of b?

- A. 6
- **B. −6**
- C. −15
- D. −9
Check: The numerator must be (x − 3)(x + c) with limit 3 + c = 5, so c = 2 and the numerator is x² − x − 6, giving b = −6.
Rationales: A: This has a sign error. The numerator (x − 3)(x + 2) = x² − x − 6 has constant term −6, not +6. C: This takes the remaining factor as x + 5, using the limit 5 as the second constant instead of 5 − 3 = 2. D: This uses −3 × 3, treating the second factor's constant as 3.

**N-1.13-B-v1.** The function f is defined by f(x) = (x² + ax + b)/(x − 2) for x ≠ 2 and f(2) = 7, where a and b are constants. If f is continuous at x = 2, what is the value of a?

- **A. a = 3**
- B. a = 5
- C. a = −3
- D. a = 7
Check: The numerator must be (x − 2)(x + c) with limit 2 + c = 7, so c = 5, and (x − 2)(x + 5) = x² + 3x − 10, so a = 3.
Rationales: B: This reports the second constant c = 5 in (x − 2)(x + c) rather than a = c − 2. C: This has a sign error when expanding (x − 2)(x + 5) = x² + 3x − 10. D: This takes a equal to the given value f(2).

**N-1.13-B-v2.** The function f is defined by f(x) = (x² + ax + b)/(x + 1) for x ≠ −1 and f(−1) = −4, where a and b are constants. If f is continuous at x = −1, what is the value of b?

- A. b = 3
- B. b = −4
- C. b = −2
- **D. b = −3**
Check: The numerator must be (x + 1)(x + c) with limit −1 + c = −4, so c = −3, and (x + 1)(x − 3) = x² − 2x − 3, giving b = −3.
Rationales: A: This has a sign error. With c = −3, (x + 1)(x − 3) has constant term −3. B: This takes b equal to the given value f(−1). C: This reports a = −2 instead of the constant term b = −3.

**N-1.13-B-v3.** The function f is defined by f(x) = (x² + ax + b)/(x − 4) for x ≠ 4 and f(4) = −2, where a and b are constants. If f is continuous at x = 4, what is the value of a?

- A. a = −6
- B. a = 10
- **C. a = −10**
- D. a = −2
Check: The numerator must be (x − 4)(x + c) with limit 4 + c = −2, so c = −6, and (x − 4)(x − 6) = x² − 10x + 24, so a = −10.
Rationales: A: This reports the second constant c = −6 in (x − 4)(x + c) rather than a = c − 4. B: This has a sign error when expanding (x − 4)(x − 6) = x² − 10x + 24. D: This takes a equal to the given value f(4).

---

## Seed N-1.14-A (new) — Topic 1.14 Connecting Infinite Limits and Vertical Asymptotes
**Skill:** determine the parameter values for which a rational function has exactly one vertical asymptote, using that a numerator zero cancelling one denominator factor removes that asymptote.

Let f(x) = (x² + kx − 6)/(x² − x − 2), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?

- A. k = −1 or k = 5
- B. k = 2 or k = −1
- **C. k = 1 or k = −5**
- D. k = 1 only
Check: The denominator is (x − 2)(x + 1). The numerator vanishes at 2 when k = 1 (leaving an asymptote at −1) and at −1 when k = −5 (leaving an asymptote at 2).
Rationales: A: This reverses the signs of the correct values. Substituting x = 2 into the numerator gives 2k − 2, so k = 1, not −1. B: These are the zeros of the denominator, not values of the parameter. The parameter must make the numerator vanish at one of them. D: This finds the value that cancels x − 2 but misses that k = −5 cancels x + 1, which also leaves exactly one asymptote.

**N-1.14-A-v1.** Let f(x) = (x² + kx + 6)/(x² − 3x + 2), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?

- **A. k = −7 or k = −5**
- B. k = 7 or k = 5
- C. k = 1 or k = 2
- D. k = −5 only
Check: The denominator is (x − 1)(x − 2). The numerator vanishes at 1 when k = −7 and at 2 when k = −5; either removes one asymptote and leaves one.
Rationales: B: This reverses the signs. Substituting x = 1 gives 7 + k, so k = −7, not 7. C: These are the zeros of the denominator, not values of the parameter. D: This finds the value that cancels x − 2 but misses that k = −7 cancels x − 1.

**N-1.14-A-v2.** Let f(x) = (x² + kx − 12)/(x² − x − 6), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?

- A. k = −1 or k = 4
- **B. k = 1 or k = −4**
- C. k = 3 or k = −2
- D. k = −4 only
Check: The denominator is (x − 3)(x + 2). The numerator vanishes at 3 when k = 1 and at −2 when k = −4.
Rationales: A: This reverses the signs. Substituting x = 3 gives 3k − 3, so k = 1, not −1. C: These are the zeros of the denominator, not values of the parameter. D: This finds the value that cancels x + 2 but misses that k = 1 cancels x − 3.

**N-1.14-A-v3.** Let f(x) = (x² + kx − 6)/(x² + 2x − 3), where k is a constant. For which values of k does the graph of f have exactly one vertical asymptote?

- A. k = −1 or k = −5
- B. k = 1 or k = −3
- C. k = 5 only
- **D. k = 1 or k = 5**
Check: The denominator is (x − 1)(x + 3). The numerator vanishes at 1 when k = 5 and at −3 when k = 1.
Rationales: A: This reverses the signs. Substituting x = 1 gives k − 5, so k = 5, not −5. B: The value −3 is a zero of the denominator, not a value of the parameter that works. C: This finds the value that cancels x − 1 but misses that k = 1 cancels x + 3.

---

## Seed N-1.14-B (new) — Topic 1.14 Connecting Infinite Limits and Vertical Asymptotes
**Skill:** analyse the sign of each factor to decide whether the one-sided limits at two vertical asymptotes agree, distinguishing an even-power factor from an odd-power factor.

Let f(x) = (x + 1)/((x − 2)²(x + 3)). Which of the following is true?

- A. Both lim(x→2) f(x) = ∞ and lim(x→−3) f(x) = ∞
- B. Neither limit exists, because the one-sided limits at 2 have opposite signs
- C. lim(x→2) f(x) = −∞ and lim(x→−3) f(x) does not exist
- **D. lim(x→2) f(x) = ∞, but lim(x→−3) f(x) does not exist**
Check: Near 2: numerator 3 > 0, x + 3 = 5 > 0, (x − 2)² > 0 gives +∞ both sides. Near −3: numerator −2 and the sign of x + 3 flips, so the one-sided limits are +∞ and −∞.
Rationales: A: The factor x + 3 changes sign at −3, so the one-sided limits there are +∞ from the left and −∞ from the right, which do not agree. B: The squared factor (x − 2)² is positive on both sides of 2, so the signs agree and f tends to ∞ on both sides. C: Near 2 the numerator is 3 and x + 3 is 5, both positive, and (x − 2)² is positive, so f is positive, tending to +∞, not −∞.

**N-1.14-B-v1.** Let g(x) = (x − 4)/((x + 1)(x − 3)²). Which of the following is true?

- A. lim(x→3) g(x) = ∞, but lim(x→−1) g(x) does not exist
- **B. lim(x→3) g(x) = −∞, but lim(x→−1) g(x) does not exist**
- C. lim(x→3) g(x) = −∞ and lim(x→−1) g(x) = −∞
- D. lim(x→3) g(x) does not exist, and lim(x→−1) g(x) = −∞
Check: Near 3: numerator −1, x + 1 = 4, (x − 3)² > 0, so −∞ both sides. Near −1: numerator −5, (x − 3)² = 16, and x + 1 changes sign, so the one-sided limits are +∞ and −∞.
Rationales: A: Near 3 the numerator is −1 and x + 1 is 4, so the quotient is negative and tends to −∞, not +∞. C: The factor x + 1 changes sign at −1, so the one-sided limits there are +∞ from the left and −∞ from the right, not equal. D: This assigns the sign change to the squared factor and the single sign to the linear one, reversing the roles. The squared factor does not change sign.

**N-1.14-B-v2.** Let h(x) = (2 − x)/((x − 5)(x + 1)²). Which of the following is true?

- **A. lim(x→−1) h(x) = −∞, but lim(x→5) h(x) does not exist**
- B. lim(x→−1) h(x) = ∞, but lim(x→5) h(x) does not exist
- C. lim(x→−1) h(x) = −∞ and lim(x→5) h(x) = −∞
- D. lim(x→−1) h(x) does not exist, and lim(x→5) h(x) = −∞
Check: Near −1: numerator 3, x − 5 = −6, (x + 1)² > 0 gives −∞ both sides. Near 5: numerator −3 and x − 5 changes sign, giving +∞ from the left and −∞ from the right.
Rationales: B: Near −1 the numerator is 3 and x − 5 is −6, so the quotient is negative and tends to −∞. C: The factor x − 5 changes sign at 5, so the one-sided limits there are +∞ from the left and −∞ from the right. D: This reverses the roles. The squared factor (x + 1)² is positive on both sides of −1, so the limit there exists as −∞.

**N-1.14-B-v3.** Let k(x) = (2 − x)/((x + 4)³(x − 1)²). Which of the following is true?

- A. lim(x→1) k(x) = −∞, but lim(x→−4) k(x) does not exist
- B. lim(x→1) k(x) = ∞ and lim(x→−4) k(x) = ∞
- **C. lim(x→1) k(x) = ∞, but lim(x→−4) k(x) does not exist**
- D. lim(x→1) k(x) does not exist, and lim(x→−4) k(x) = ∞
Check: Near 1: numerator 1, (x + 4)³ = 125, (x − 1)² > 0 gives +∞ both sides. Near −4: numerator 6, (x − 1)² = 25, and (x + 4)³ changes sign, so one-sided limits are −∞ and +∞.
Rationales: A: Near 1 the numerator is 1 and (x + 4)³ is 125, both positive, so k is positive and tends to +∞. B: The factor (x + 4)³ is negative for x < −4 and positive for x > −4, so the one-sided limits at −4 have opposite signs. D: This reverses the roles. The even power (x − 1)² does not change sign at 1, while the odd power (x + 4)³ does change sign at −4.

---

## Seed N-1.15-A (new) — Topic 1.15 Connecting Limits at Infinity and Horizontal Asymptotes
**Skill:** find a horizontal asymptote of a difference of expressions that is infinity minus infinity by multiplying by the conjugate before taking the limit at infinity.

Let f(x) = x − √(x² + 4x) for x ≥ 0. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?

- **A. y = −2**
- B. y = 0
- C. y = −4
- D. y = 2
Check: Multiplying by the conjugate gives −4x/(x + √(x² + 4x)). Dividing by x gives −4/(1 + √(1 + 4/x)) → −4/2 = −2.
Rationales: B: This treats x − √(x² + 4x) as ∞ − ∞ = 0. The difference of two large quantities can approach any value, so the expression must be rewritten. C: This multiplies by the conjugate to get −4x/(x + √(x² + 4x)) but then divides only by x, forgetting that the denominator is about 2x. D: This has a sign error. x is smaller than √(x² + 4x), so the difference is negative.

**N-1.15-A-v1.** Let f(x) = √(x² + 6x) − x for x ≥ 0. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?

- A. y = 0
- **B. y = 3**
- C. y = 6
- D. y = −3
Check: Multiplying by the conjugate gives 6x/(√(x² + 6x) + x) = 6/(√(1 + 6/x) + 1) → 6/2 = 3.
Rationales: A: This treats √(x² + 6x) − x as ∞ − ∞ = 0, which is not a valid conclusion. C: This reduces 6x/(√(x² + 6x) + x) by dividing by x but forgets the denominator tends to 2. D: This has a sign error. √(x² + 6x) exceeds x, so the difference is positive.

**N-1.15-A-v2.** Let f(x) = √(4x² + x) − 2x for x ≥ 0. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?

- A. y = 0
- B. y = 1/2
- **C. y = 1/4**
- D. y = 1
Check: Multiplying by the conjugate gives x/(√(4x² + x) + 2x) = 1/(√(4 + 1/x) + 2) → 1/4.
Rationales: A: This treats √(4x² + x) − 2x as ∞ − ∞ = 0, which is not valid. B: This forgets one term in the denominator after rationalising. The denominator √(4x² + x) + 2x behaves like 4x, not 2x. D: This forgets that the denominator grows. The rationalised form x/(√(4x² + x) + 2x) divided by x has denominator tending to 4.

**N-1.15-A-v3.** Let f(x) = x − √(x² − 10x) for x ≥ 10. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?

- A. y = 0
- B. y = 10
- C. y = −5
- **D. y = 5**
Check: Multiplying by the conjugate gives 10x/(x + √(x² − 10x)) = 10/(1 + √(1 − 10/x)) → 10/2 = 5.
Rationales: A: This treats x − √(x² − 10x) as ∞ − ∞ = 0, which is not valid. B: This forgets the denominator tends to 2 after dividing by x. C: This has a sign error. x exceeds √(x² − 10x), so the difference is positive.

---

## Seed N-1.15-B (new) — Topic 1.15 Connecting Limits at Infinity and Horizontal Asymptotes
**Skill:** find both horizontal asymptotes of a rational expression containing |x| by rewriting |x| as x for x > 0 and −x for x < 0 before comparing leading coefficients.

Let f(x) = (4x + |x|)/(x + 1). Which of the following gives all horizontal asymptotes of the graph of f?

- A. y = 5 only
- **B. y = 5 and y = 3**
- C. y = 4 only
- D. y = 5 and y = −3
Check: As x → ∞, f(x) = 5x/(x + 1) → 5. As x → −∞, |x| = −x, so f(x) = 3x/(x + 1) → 3.
Rationales: A: This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is different. C: This ignores the absolute value and treats it as 0, giving 4x/x = 4. D: This has a sign slip as x → −∞. The numerator becomes 4x − x = 3x and the quotient 3x/(x + 1) tends to +3.

**N-1.15-B-v1.** Let f(x) = (2x − 3|x|)/(x − 4). Which of the following gives all horizontal asymptotes of the graph of f?

- **A. y = −1 and y = 5**
- B. y = −1 only
- C. y = 2 only
- D. y = −1 and y = −5
Check: As x → ∞, f(x) = −x/(x − 4) → −1. As x → −∞, |x| = −x, so f(x) = 5x/(x − 4) → 5.
Rationales: B: This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is 5. C: This ignores the absolute value, treating it as 0 and giving 2x/x = 2. D: This has a sign slip as x → −∞. The numerator becomes 2x + 3x = 5x, giving +5, not −5.

**N-1.15-B-v2.** Let f(x) = (5x − 2|x|)/(2x + 1). Which of the following gives all horizontal asymptotes of the graph of f?

- A. y = 3/2 only
- B. y = 5/2 only
- C. y = 3/2 and y = −7/2
- **D. y = 3/2 and y = 7/2**
Check: As x → ∞, f(x) = 3x/(2x + 1) → 3/2. As x → −∞, |x| = −x, so f(x) = 7x/(2x + 1) → 7/2.
Rationales: A: This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is 7/2. B: This ignores the absolute value and treats it as 0, giving 5x/(2x) = 5/2. C: This has a sign slip as x → −∞. The numerator becomes 5x + 2x = 7x and the quotient tends to +7/2.

**N-1.15-B-v3.** Let f(x) = (|x| − 6x)/(3x − 2). Which of the following gives all horizontal asymptotes of the graph of f?

- A. y = −5/3 only
- B. y = −2 only
- **C. y = −5/3 and y = −7/3**
- D. y = −5/3 and y = 7/3
Check: As x → ∞, f(x) = −5x/(3x − 2) → −5/3. As x → −∞, |x| = −x, so f(x) = −7x/(3x − 2) → −7/3.
Rationales: A: This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is −7/3. B: This ignores the absolute value, treating it as 0 and giving −6x/(3x) = −2. D: This has a sign slip as x → −∞. The numerator becomes −x − 6x = −7x, so the limit is −7/3, not +7/3.

---

## Seed N-1.16-A (new) — Topic 1.16 Working with the Intermediate Value Theorem
**Skill:** use the Intermediate Value Theorem on a table of values of a continuous function to count the zeros guaranteed, including a table entry equal to zero and intervals with no sign change.

A function f is continuous on [0, 6]. Selected values are f(0) = 3, f(2) = −1, f(4) = −1, and f(6) = 5. Which of the following is guaranteed by the Intermediate Value Theorem?

- A. f has exactly two zeros in (0, 6)
- B. f has at least three zeros in (0, 6)
- **C. f has at least two zeros in (0, 6)**
- D. f has exactly one zero in (0, 6)
Check: Sign changes occur on [0, 2] (3 to −1) and [4, 6] (−1 to 5), each giving a zero. No guarantee on [2, 4], so at least two zeros.
Rationales: A: The theorem guarantees a minimum number of zeros only. Between the table values f could cross zero additional times. B: This counts [2, 4] as a sign change, but f(2) and f(4) are both −1, so the theorem gives no guarantee there. D: This counts only one sign change, but there are two, on [0, 2] and on [4, 6], each of which gives a zero.

**N-1.16-A-v1.** A sensor reading R(t) is continuous on [−3, 7]. Selected values are R(−3) = −2, R(−1) = 3, R(1) = −5, R(4) = −5, and R(7) = 1. Which is the strongest statement about the zeros of the function that the Intermediate Value Theorem guarantees?

- **A. R has at least three zeros in (−3, 7)**
- B. R has exactly three zeros in (−3, 7)
- C. R has at least four zeros in (−3, 7)
- D. R has at least two zeros in (−3, 7)
Check: Sign changes occur on [−3, −1], [−1, 1], and [4, 7], and none on [1, 4]. That guarantees at least three zeros.
Rationales: B: The theorem guarantees a minimum only. R could cross zero more often between the listed times. C: This counts [1, 4] as a sign change, but R(1) and R(4) are both −5, so no zero is guaranteed there. D: This misses one of the three sign changes. Sign changes occur on [−3, −1], [−1, 1], and [4, 7].

**N-1.16-A-v2.** A function f is continuous on [0, 6]. Selected values are f(0) = 3, f(2) = 0, f(4) = −2, and f(6) = 4. Which is the strongest statement about the zeros of the function that the Intermediate Value Theorem guarantees?

- A. f has at least three zeros in [0, 6]
- **B. f has at least two zeros in [0, 6]**
- C. f has exactly two zeros in [0, 6]
- D. f has at least one zero in [0, 6]
Check: f(2) = 0 is one zero. On [4, 6] the values go from −2 to 4, giving another zero by the theorem. So at least two zeros.
Rationales: A: This treats the changes 3 to 0 and 0 to −2 as separate sign changes in addition to −2 to 4. The zero at x = 2 is already one zero and counts only once. C: The theorem guarantees a minimum number only; further zeros may exist. D: This counts only the sign change on [4, 6] and ignores that f(2) = 0 is itself a zero.

**N-1.16-A-v3.** A function f is continuous on [−2, 8]. Selected values are f(−2) = 2, f(0) = −1, f(3) = 1, f(5) = −2, and f(8) = 3. Which is the strongest statement about the zeros of the function that the Intermediate Value Theorem guarantees?

- A. f has at least three zeros in (−2, 8)
- B. f has at least five zeros in (−2, 8)
- C. f has exactly four zeros in (−2, 8)
- **D. f has at least four zeros in (−2, 8)**
Check: Consecutive values alternate in sign on all four intervals, giving a zero in each, so at least four zeros.
Rationales: A: This misses one of the four sign changes, which occur on [−2, 0], [0, 3], [3, 5], and [5, 8]. B: There are five table entries but only four consecutive pairs, and each pair gives at most one guaranteed zero. C: The theorem guarantees a minimum only. More zeros may exist between the listed points.

---

## Seed N-1.16-B (new) — Topic 1.16 Working with the Intermediate Value Theorem
**Skill:** decide for which interval the Intermediate Value Theorem, applied to the endpoint values of a polynomial, guarantees a zero, recognising that equal signs at the endpoints give no guarantee even when zeros exist.

Let f(x) = x³ − 3x² + 1, which is continuous for all x. For which of the following intervals do the values of f at the endpoints let the Intermediate Value Theorem guarantee a zero of f in the interval?

- A. [0, 3]
- B. [1, 2]
- C. [3, 4]
- **D. [−1, 0]**
Check: f(−1) = −3 < 0 and f(0) = 1 > 0, so the theorem guarantees a zero in (−1, 0).
Rationales: A: Here f(0) = 1 and f(3) = 1 have the same sign, so the theorem gives no guarantee, even though f does have zeros inside the interval. B: Here f(1) = −1 and f(2) = −3 are both negative, so no sign change is shown. C: Here f(3) = 1 and f(4) = 17 are both positive, so no sign change is shown.

**N-1.16-B-v1.** Let g(x) = x³ − 7x + 3, which is continuous for all x. For which of the following intervals do the values of g at the endpoints let the Intermediate Value Theorem guarantee a zero of g in the interval?

- A. [−4, 1]
- **B. [2, 3]**
- C. [−2, 0]
- D. [1, 2]
Check: g(2) = 8 − 14 + 3 = −3 < 0 and g(3) = 27 − 21 + 3 = 9 > 0, so there is a zero in (2, 3).
Rationales: A: Here g(−4) = −33 and g(1) = −3 are both negative, so the theorem gives no guarantee, even though g has two zeros inside the interval. C: Here g(−2) = 9 and g(0) = 3 are both positive, so no sign change is shown. D: Here g(1) = −3 and g(2) = −3 are both negative, so no sign change is shown.

**N-1.16-B-v2.** Let h(x) = x³ − 3x + 1, which is continuous for all x. For which of the following intervals do the values of h at the endpoints let the Intermediate Value Theorem guarantee a zero of h in the interval?

- **A. [0, 1]**
- B. [−1, 2]
- C. [−1, 0]
- D. [2, 3]
Check: h(0) = 1 > 0 and h(1) = −1 < 0, so the theorem guarantees a zero in (0, 1).
Rationales: B: Here h(−1) = 3 and h(2) = 3 are both positive, so the theorem gives no guarantee, even though h has two zeros inside the interval. C: Here h(−1) = 3 and h(0) = 1 are both positive, so no sign change is shown. D: Here h(2) = 3 and h(3) = 19 are both positive, so no sign change is shown.

**N-1.16-B-v3.** Let p(x) = x⁴ − 5x² + 2, which is continuous for all x. For which of the following intervals do the values of p at the endpoints let the Intermediate Value Theorem guarantee a zero of p in the interval?

- A. [−1, 1]
- B. [−2, −1]
- **C. [2, 3]**
- D. [1, 2]
Check: p(2) = 16 − 20 + 2 = −2 < 0 and p(3) = 81 − 45 + 2 = 38 > 0, so there is a zero in (2, 3).
Rationales: A: Here p(−1) = −2 and p(1) = −2 have the same sign, so the theorem gives no guarantee, even though p has two zeros inside the interval. B: Here p(−2) = −2 and p(−1) = −2 are both negative, so no sign change is shown. D: Here p(1) = −2 and p(2) = −2 are both negative, so no sign change is shown.
