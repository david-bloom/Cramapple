# AP Calculus BC topics 1.1 to 1.8: harder seed drafts (Unit 1, first half)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (exact values, tables from the stated formulas, numerical limits).
Scope: 16 new seeds, 64 items, two per topic 1.1 to 1.8, mostly R3 (interpretation, multi-step reasoning, error analysis). Emphasis on one-sided and composite limits, tables and described graphs, parameter-fitting limits, trig identities in limits, squeeze at infinity, and worked-solution error analysis.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.1-A | 1.1 Introducing Calculus: Can Change Occur at an Instant? | new |
| N-1.1-B | 1.1 Introducing Calculus: Can Change Occur at an Instant? | new |
| N-1.2-A | 1.2 Defining Limits and Using Limit Notation | new |
| N-1.2-B | 1.2 Defining Limits and Using Limit Notation | new |
| N-1.3-A | 1.3 Estimating Limit Values from Graphs | new |
| N-1.3-B | 1.3 Estimating Limit Values from Graphs | new |
| N-1.4-A | 1.4 Estimating Limit Values from Tables | new |
| N-1.4-B | 1.4 Estimating Limit Values from Tables | new |
| N-1.5-A | 1.5 Determining Limits Using Algebraic Properties of Limits | new |
| N-1.5-B | 1.5 Determining Limits Using Algebraic Properties of Limits | new |
| N-1.6-A | 1.6 Determining Limits Using Algebraic Manipulation | new |
| N-1.6-B | 1.6 Determining Limits Using Algebraic Manipulation | new |
| N-1.7-A | 1.7 Selecting Procedures for Determining Limits | new |
| N-1.7-B | 1.7 Selecting Procedures for Determining Limits | new |
| N-1.8-A | 1.8 Determining Limits Using the Squeeze Theorem | new |
| N-1.8-B | 1.8 Determining Limits Using the Squeeze Theorem | new |

---

## Seed N-1.1-A (new) — Topic 1.1 Introducing Calculus: Can Change Occur at an Instant?
**Skill:** recover the instantaneous rate as the limit of an average-rate expression, and evaluate that same expression at a fixed h for a longer interval.

For a function f, the average rate of change of f over the interval [2, 2 + h] is 5 + 3h + h² for every h > 0. What is the instantaneous rate of change of f at x = 2, and what is the average rate of change of f over [2, 4]?

- A. Instantaneous rate 5; average rate over [2, 4] is 5
- **B. Instantaneous rate 5; average rate over [2, 4] is 15**
- C. Instantaneous rate 15; average rate over [2, 4] is 5
- D. Instantaneous rate 5; average rate over [2, 4] is 11

Check: As h → 0, 5 + 3h + h² → 5; the interval [2, 4] is h = 2, so the average rate is 5 + 6 + 4 = 15.
Rationales: A: The instantaneous rate 5 is the limit of the expression as h approaches 0, but the average over [2, 4] corresponds to h = 2 and must use the whole expression, not only its limit. C: The values are swapped: the instantaneous rate is the limit of 5 + 3h + h² as h approaches 0, which is 5, while the interval [2, 4] has h = 2 and gives 15. D: The average over [2, 4] uses h = 2 in 5 + 3h + h², giving 5 + 6 + 4 = 15; the value 11 comes from dropping the h² term, which is negligible only as h approaches 0.

**N-1.1-A-v1.** A quantity Q changes with time t in hours. Its average rate of change over [1, 1 + h] is 8 − 2h + h² units per hour for every h > 0. What is the instantaneous rate of change of Q at t = 1, and what is the average rate of change of Q over [1, 4]?

- **A. Instantaneous rate 8; average rate over [1, 4] is 11**
- B. Instantaneous rate 8; average rate over [1, 4] is 8
- C. Instantaneous rate 11; average rate over [1, 4] is 8
- D. Instantaneous rate 8; average rate over [1, 4] is 2

Check: As h → 0, 8 − 2h + h² → 8; for [1, 4], h = 3 and 8 − 6 + 9 = 11.
Rationales: B: The instantaneous rate is the limit 8, but an average over [1, 4] is not that limit; it equals the expression evaluated at h = 3, which is 8 − 6 + 9. C: The values are swapped: letting h approach 0 gives the instantaneous rate 8, while the interval [1, 4] has h = 3 and gives 11. D: At h = 3 the expression is 8 − 6 + 9 = 11; the value 2 comes from dropping the h² term, which cannot be ignored when h is as large as 3.

**N-1.1-A-v2.** A store's cumulative revenue R, in thousands of dollars, has average rate of change 6 + 4h − h² thousand dollars per week over the interval [0, h] weeks, for every h > 0. What is the instantaneous rate of change of R at t = 0, and what is the average rate of change of R over [0, 2]?

- A. Instantaneous rate 6; average rate over [0, 2] is 6
- B. Instantaneous rate 10; average rate over [0, 2] is 6
- **C. Instantaneous rate 6; average rate over [0, 2] is 10**
- D. Instantaneous rate 6; average rate over [0, 2] is 14

Check: The limit as h → 0 is 6; for [0, 2], h = 2 and 6 + 8 − 4 = 10.
Rationales: A: The instantaneous rate 6 is the limit as h approaches 0, but [0, 2] corresponds to h = 2, where the expression gives 6 + 8 − 4, not its limit. B: These are swapped: the limit as h approaches 0 gives the instantaneous rate 6, and h = 2 gives the average rate 10 over [0, 2]. D: At h = 2 the h² term is −4, so the average is 6 + 8 − 4 = 10; 14 comes from ignoring the h² term, which does not vanish at h = 2.

**N-1.1-A-v3.** For a function p, the average rate of change over [4, 4 + h] is 3 + h + 2h² for every h > 0. What is the instantaneous rate of change of p at x = 4, and what is the average rate of change of p over [4, 6]?

- A. Instantaneous rate 3; average rate over [4, 6] is 3
- B. Instantaneous rate 13; average rate over [4, 6] is 3
- C. Instantaneous rate 3; average rate over [4, 6] is 5
- **D. Instantaneous rate 3; average rate over [4, 6] is 13**

Check: As h → 0 the expression tends to 3; for [4, 6], h = 2 and 3 + 2 + 8 = 13.
Rationales: A: The limit 3 is the instantaneous rate at x = 4, but the interval [4, 6] has h = 2 and the average rate is the full expression there, 3 + 2 + 8. B: The two answers are interchanged: h approaching 0 gives the instantaneous rate 3, and h = 2 gives the average rate 13 for [4, 6]. C: At h = 2 the expression is 3 + 2 + 2·4 = 13; the value 5 results from omitting the 2h² term, which is not small when h = 2.

---

## Seed N-1.1-B (new) — Topic 1.1 Introducing Calculus: Can Change Occur at an Instant?
**Skill:** decide whether an instantaneous rate exists from one-sided average rates over shrinking intervals.

A continuous function g has the following average rates of change. Over [1 − h, 1] the average rate is 1.9 for h = 0.1, 1.99 for h = 0.01, and 1.999 for h = 0.001. Over [1, 1 + h] the average rate is 3 for each of these three values of h. Which is the best conclusion about the instantaneous rate of change of g at x = 1?

- A. It equals 2, the value approached by the left-hand average rates
- B. It equals 3, because the right-hand average rates are constant
- C. It equals 5/2, the mean of the two one-sided values
- **D. It does not exist, because the average rates approach 2 from the left and 3 from the right**

Check: Left-hand rates tend to 2, right-hand rates equal 3; the two sides disagree, so the limit of the average rates does not exist.
Rationales: A: The left-hand rates approach 2, but the instantaneous rate requires average rates from both sides to approach the same value, and the right-hand rates stay at 3. B: The right-hand rates are 3, but a constant list does not outweigh the left-hand rates, which approach 2; both sides must agree for the instantaneous rate to exist. C: Averaging 2 and 3 has no meaning here; the instantaneous rate is a limit of average rates and exists only if the left and right limits are equal.

**N-1.1-B-v1.** The temperature T(t) of a metal part is continuous. Its average rate of change over [2 − h, 2] is −2.1 for h = 0.1, −2.01 for h = 0.01, and −2.001 for h = 0.001, and its average rate of change over [2, 2 + h] is 3 for each of these h. Which is the best conclusion about the instantaneous rate of change of T at t = 2?

- **A. It does not exist, because the average rates approach −2 from the left and 3 from the right**
- B. It equals −2, the value approached by the left-hand average rates
- C. It equals 3, the constant right-hand average rate
- D. It equals 1/2, the mean of −2 and 3

Check: Left-hand rates tend to −2 and right-hand rates equal 3; the one-sided limits differ, so no instantaneous rate exists.
Rationales: B: The left-hand rates approach −2, but the right-hand rates stay at 3, so the average rates do not settle on one value as h shrinks. C: The right-hand rates are 3, yet the left-hand rates approach −2; an instantaneous rate needs both one-sided limits to agree. D: The mean of −2 and 3 is 1/2, but the instantaneous rate is not an average of one-sided values; it exists only when both one-sided limits are equal.

**N-1.1-B-v2.** A continuous function p has average rate of change over [4 − h, 4] equal to 4.2 for h = 0.1, 4.02 for h = 0.01, and 4.002 for h = 0.001, and average rate of change over [4, 4 + h] equal to 3.8, 3.98, and 3.998 for the same three values of h. Which is the best conclusion about the instantaneous rate of change of p at x = 4?

- A. It does not exist, because the left-hand rates are all above 4 and the right-hand rates are all below 4
- **B. It equals 4, because the average rates from both sides approach 4**
- C. It equals 4.002, the last left-hand value listed
- D. It equals 3.998, the last right-hand value listed

Check: Left-hand rates 4 + 2h and right-hand rates 4 − 2h both approach 4 as h → 0, so the instantaneous rate is 4.
Rationales: A: Rates lying on opposite sides of 4 do not prevent a limit; what matters is that both lists approach the same number, 4. C: A listed value is only an estimate that still contains error; the limit is the number the rates approach as h shrinks, which is 4. D: The last tabulated rate is not the limit; the right-hand rates approach 4 and the left-hand rates approach 4, so the instantaneous rate is 4.

**N-1.1-B-v3.** A continuous function q has average rate of change 0.5 over [4 − h, 4] for h = 0.1, 0.01, and 0.001, and average rate of change −0.5 over [4, 4 + h] for the same values of h. Which is the best conclusion about the instantaneous rate of change of q at x = 4?

- A. It equals 0, because 0.5 and −0.5 cancel
- B. It equals 0.5, the left-hand rate
- **C. It does not exist, because the average rates from the two sides approach different values**
- D. It equals −0.5, the right-hand rate

Check: One-sided limits of the average rates are 0.5 and −0.5, which differ, so the instantaneous rate does not exist.
Rationales: A: Cancelling the one-sided values is not a valid way to combine them; the instantaneous rate exists only when both sides approach the same number. B: The left-hand rates are 0.5, but the right-hand rates are −0.5, so the average rates do not approach a single value. D: The right-hand rates are −0.5, but the left-hand rates are 0.5; the rates must agree from both sides for the instantaneous rate to exist.

---

## Seed N-1.2-A (new) — Topic 1.2 Defining Limits and Using Limit Notation
**Skill:** evaluate a limit of a composite h(f(x)) by tracking the side from which the inner function approaches its limit.

Let f be a function with lim(x→0⁻) f(x) = 2, where f(x) < 2 for x < 0 near 0. Let h be a function with lim(u→2⁻) h(u) = 7, lim(u→2⁺) h(u) = −1, and h(2) = 4. What is lim(x→0⁻) h(f(x))?

- **A. 7**
- B. −1
- C. 4
- D. The limit does not exist

Check: As x → 0⁻, f(x) → 2 from below, so h(f(x)) → lim(u→2⁻) h(u) = 7.
Rationales: B: The value −1 is the right-hand limit of h at 2, but f(x) approaches 2 from below as x approaches 0 from the left, so the left-hand limit of h is the one that applies. C: The value 4 is h(2); a limit depends on the values of h near 2, not at 2, and f(x) never needs to equal 2. D: The two-sided limit of h at 2 does not exist, but h(f(x)) only sees inputs below 2 as x approaches 0 from the left, so a single limit does exist.

**N-1.2-A-v1.** Let f satisfy lim(x→3⁺) f(x) = −1, where f(x) > −1 for x > 3 near 3. Let h satisfy lim(u→−1⁻) h(u) = 6, lim(u→−1⁺) h(u) = 2, and h(−1) = 0. What is lim(x→3⁺) h(f(x))?

- A. 6
- B. 0
- **C. 2**
- D. The limit does not exist

Check: As x → 3⁺, f(x) → −1 from above, so h(f(x)) → lim(u→−1⁺) h(u) = 2.
Rationales: A: The value 6 is the left-hand limit of h, but f(x) approaches −1 from above, so the inputs to h are greater than −1 and the right-hand limit applies. B: The value 0 is h(−1); limits describe nearby behavior, and f(x) stays above −1 so the inputs never need to be −1. D: h has no two-sided limit at −1, but the inputs f(x) approach −1 only from above, so only the right-hand limit of h matters and the composite limit exists.

**N-1.2-A-v2.** Let f satisfy lim(x→4) f(x) = 1, with f(x) > 1 for x < 4 and f(x) < 1 for x > 4. Let h satisfy lim(u→1⁻) h(u) = 3, lim(u→1⁺) h(u) = 8, and h(1) = 3. What is lim(x→4) h(f(x))?

- A. 3
- B. 8
- C. 11/2
- **D. The limit does not exist**

Check: For x < 4, f(x) → 1⁺ so h(f(x)) → 8; for x > 4, f(x) → 1⁻ so h(f(x)) → 3. The one-sided limits differ.
Rationales: A: The value 3 equals h(1) and the left-hand limit of h, but it describes only the right side x > 4, where f(x) is below 1. B: The value 8 is the right-hand limit of h, which governs only x < 4 where f(x) is above 1; for x > 4 the composite approaches 3. C: The mean of 3 and 8 is not a limit of anything here; as x approaches 4 the composite approaches 8 from the left and 3 from the right.

**N-1.2-A-v3.** Let f satisfy lim(x→−2⁻) f(x) = 0, with f(x) > 0 for x < −2 near −2. Let h satisfy lim(u→0⁻) h(u) = −4, lim(u→0⁺) h(u) = 1, and h(0) = 3. What is lim(x→−2⁻) h(f(x))?

- A. −4
- **B. 1**
- C. 3
- D. The limit does not exist

Check: As x → −2⁻, f(x) → 0 from above, so h(f(x)) → lim(u→0⁺) h(u) = 1.
Rationales: A: The value −4 is the left-hand limit of h, but f(x) approaches 0 from above, so the right-hand limit of h applies. C: The value 3 is h(0); the composite limit depends on h near 0 on the side the inputs come from, not on h(0). D: h has different one-sided limits at 0, but f(x) approaches 0 only from above here, so only the right-hand limit is relevant and the composite limit exists.

---

## Seed N-1.2-B (new) — Topic 1.2 Defining Limits and Using Limit Notation
**Skill:** judge which limit statements, including infinite and one-sided limits, are written correctly.

Which of the following is a correct statement?

- **A. lim(x→0) ln|x| = −∞**
- B. lim(x→0) 1/x = ∞
- C. lim(x→0⁺) ln x = 0
- D. lim(x→0) (−1/x²) = ∞

Check: ln|x| → −∞ from both sides of 0; 1/x has opposite one-sided limits; ln x → −∞ as x → 0⁺; −1/x² → −∞.
Rationales: B: The one-sided limits of 1/x at 0 are ∞ from the right and −∞ from the left, so the two-sided limit cannot be written as ∞. C: The value ln 1 = 0 belongs to x approaching 1; as x approaches 0 from the right, ln x decreases without bound to −∞. D: Since 1/x² grows without bound and −1/x² is its opposite, the limit is −∞, not ∞.

**N-1.2-B-v1.** Which of the following is a correct statement?

- A. lim(x→2) 3/(x − 2) = ∞
- **B. lim(x→2) −3/(x − 2)² = −∞**
- C. lim(x→2⁺) 1/(x − 2) = −∞
- D. lim(x→2) 3/(x − 2)² = 0

Check: (x − 2)² is a small positive number near 2, so −3/(x − 2)² is large and negative from both sides.
Rationales: A: The function 3/(x − 2) tends to ∞ from the right of 2 but to −∞ from the left, so the two-sided limit is not ∞. C: For x slightly greater than 2, x − 2 is a small positive number, so 1/(x − 2) is large and positive, giving ∞ rather than −∞. D: As x approaches 2 the denominator (x − 2)² approaches 0, making the quotient grow without bound; a limit of 0 would belong to x approaching infinity.

**N-1.2-B-v2.** Which of the following is a correct statement?

- A. lim(x→0) e^(1/x) = ∞
- B. lim(x→0⁺) e^(1/x) = 1
- **C. lim(x→0⁻) e^(1/x) = 0**
- D. lim(x→0) e^(1/x) = 0

Check: From the left 1/x → −∞ so e^(1/x) → 0; from the right it → ∞, so only the left-hand statement is correct.
Rationales: A: As x approaches 0 from the left, 1/x → −∞ and e^(1/x) → 0, so the two-sided limit cannot be ∞. B: The value e⁰ = 1 would arise if 1/x approached 0; as x approaches 0 from the right, 1/x → ∞ and e^(1/x) grows without bound. D: The left-hand limit is 0, but from the right e^(1/x) → ∞, so the two-sided limit does not equal 0.

**N-1.2-B-v3.** Which of the following is a correct statement?

- A. lim(x→−3) 1/(x + 3)³ = −∞
- B. lim(x→−3⁺) 1/(x + 3)³ = −∞
- C. lim(x→−3) 1/(x + 3)³ = 0
- **D. lim(x→−3⁻) 1/(x + 3)³ = −∞**

Check: For x < −3, (x + 3)³ is a small negative number, so 1/(x + 3)³ is large and negative.
Rationales: A: Left of −3 the cube is a small negative number, giving −∞, but right of −3 it is a small positive number, giving ∞, so the two-sided limit is not −∞. B: For x slightly greater than −3, x + 3 is positive and so is its cube, making the quotient large and positive. C: The denominator approaches 0, so the quotient grows in magnitude; a limit of 0 would arise as x approaches infinity.

---

## Seed N-1.3-A (new) — Topic 1.3 Estimating Limit Values from Graphs
**Skill:** transform one-sided limits read from a graph through a reflection, shift, or scaling of the input, tracking which side is approached.

The graph of f has lim(x→2⁻) f(x) = 3, lim(x→2⁺) f(x) = −1, and f(2) = 1. Let g(x) = f(−x). What is lim(x→−2⁺) g(x)?

- **A. 3**
- B. −1
- C. 1
- D. The limit does not exist

Check: For x > −2 near −2, −x < 2 near 2, so g(x) = f(−x) → lim(u→2⁻) f(u) = 3.
Rationales: B: This keeps the same side, but when x approaches −2 from the right, −x approaches 2 from the left, where f approaches 3. C: The value 1 is f(2); a limit is determined by nearby values of f, not by the value at the point. D: f has no two-sided limit at 2, but g sees only inputs −x that are less than 2 as x approaches −2 from the right, so a one-sided value is determined.

**N-1.3-A-v1.** The graph of f has lim(x→1⁻) f(x) = −2, lim(x→1⁺) f(x) = 5, and f(1) = 3. Let g(x) = f(2 − x). What is lim(x→1⁺) g(x)?

- A. 5
- **B. −2**
- C. 3
- D. The limit does not exist

Check: For x > 1 near 1, 2 − x < 1 near 1, so g(x) = f(2 − x) → lim(u→1⁻) f(u) = −2.
Rationales: A: This keeps the right-hand side, but for x > 1 the input 2 − x is less than 1, so the left-hand limit of f applies. C: The value 3 is f(1); the limit depends on values near 1, not at 1. D: f has different one-sided limits at 1, but as x approaches 1 from the right, 2 − x approaches 1 only from the left, so g has a right-hand limit.

**N-1.3-A-v2.** The graph of f has lim(x→6⁻) f(x) = 2, lim(x→6⁺) f(x) = −3, and f(6) = 0. Let g(x) = f(3x). What is lim(x→2⁺) g(x)?

- A. 2
- B. 0
- **C. −3**
- D. −1

Check: For x > 2 near 2, 3x > 6 near 6, so g(x) → lim(u→6⁺) f(u) = −3.
Rationales: A: The value 2 is the left-hand limit of f at 6, but for x > 2 the input 3x is greater than 6, so the right-hand limit applies. B: The value 0 is f(6), which does not determine a limit. D: Dividing −3 by 3 treats the scaling as acting on the output; replacing x by 3x changes where f is evaluated, not the values f takes.

**N-1.3-A-v3.** The graph of f has lim(x→2⁻) f(x) = 6, lim(x→2⁺) f(x) = 1, and f(2) = 3. Let g(x) = −f(x + 4). What is lim(x→−2⁻) g(x)?

- A. 6
- B. −1
- C. −3
- **D. −6**

Check: For x < −2 near −2, x + 4 < 2 near 2, so f(x + 4) → 6 and g(x) → −6.
Rationales: A: As x approaches −2 from the left, x + 4 approaches 2 from the left and f approaches 6, but the leading minus sign in g makes the value −6. B: As x approaches −2 from the left, x + 4 is less than 2, so the left-hand limit 6 applies, not the right-hand limit 1. C: The value −3 is −f(2); a limit depends on values of f near 2, not at 2.

---

## Seed N-1.3-B (new) — Topic 1.3 Estimating Limit Values from Graphs
**Skill:** count points where a limit exists but differs from the function value or the value is undefined, from a verbal description of a graph.

A function f is defined on (−3, 4) with this behavior. At x = −2: f(−2) = 3 and lim(x→−2) f(x) = 1. At x = 0: f(0) = 2, lim(x→0⁻) f(x) = 2, and lim(x→0⁺) f(x) = −2. At x = 1: f(1) is undefined and lim(x→1) f(x) = 0. At x = 3: f(3) = 4 and lim(x→3) f(x) = 4. Elsewhere on (−3, 4), f is continuous. At how many values of c in (−3, 4) does lim(x→c) f(x) exist but not equal f(c), including the case where f(c) is undefined?

- A. 1
- **B. 2**
- C. 3
- D. 4

Check: Count x = −2 (limit 1, value 3) and x = 1 (limit 0, no value); x = 0 has no limit and x = 3 has limit equal to f(3).
Rationales: A: Only x = −2 has a defined value different from the limit; the limit at x = 1 also exists and does not equal an undefined f(1), so it counts as well. C: The point x = 0 has a jump, so lim(x→0) f(x) does not exist, and the question counts only points where the limit exists. D: The points x = 0 and x = 3 should not be counted: the limit at 0 does not exist and at 3 the limit equals f(3).

**N-1.3-B-v1.** A function g is defined on (−2, 5) with this behavior. At x = −1: g(−1) = −2 and lim(x→−1) g(x) = 0. At x = 0: g(0) = −3 and lim(x→0) g(x) = 2. At x = 1: g(1) = 3 and lim(x→1) g(x) = 3. At x = 2: lim(x→2⁻) g(x) = 1, lim(x→2⁺) g(x) = 4, and g(2) = 1. At x = 3: g(3) is undefined and lim(x→3) g(x) = 2. Elsewhere on (−2, 5), g is continuous. At how many values of c in (−2, 5) does lim(x→c) g(x) exist but not equal g(c), including the case where g(c) is undefined?

- A. 2
- B. 4
- **C. 3**
- D. 5

Check: Count x = −1 (0 vs −2), x = 0 (2 vs −3), and x = 3 (2 vs undefined); x = 1 matches and x = 2 has no limit.
Rationales: A: The limit at x = 3 exists and g(3) is undefined, so the limit does not equal g(3) and the point counts; omitting it gives 2. B: The point x = 2 has a jump, so the limit there does not exist and it should not be counted. D: Counting all listed points includes x = 1, where the limit equals g(1), and x = 2, where the limit does not exist.

**N-1.3-B-v2.** A function h is defined on (−4, 3) with this behavior. At x = −2: h(−2) = 1, lim(x→−2⁻) h(x) = 1, and lim(x→−2⁺) h(x) = −1. At x = 0: h(0) is undefined and lim(x→0) h(x) = 2. At x = 1: h(1) = 0 and lim(x→1) h(x) = 0. At x = 2: lim(x→2⁻) h(x) = ∞. Elsewhere on (−4, 3), h is continuous. At how many values of c in (−4, 3) does lim(x→c) h(x) exist as a real number but not equal h(c), including the case where h(c) is undefined?

- **A. 1**
- B. 0
- C. 2
- D. 3

Check: Only x = 0 qualifies; x = −2 has a jump, x = 1 has limit equal to h(1), and x = 2 has an infinite limit.
Rationales: B: A limit can exist where the function is undefined; at x = 0 the limit is 2 and h(0) does not exist, so the point counts. C: The point x = −2 has a jump, so there is no limit there, and it should not be counted. D: Counting x = −2, 0, and 2 includes a jump and an infinite limit, where the limit does not exist as a real number.

**N-1.3-B-v3.** A function k is defined on (−3, 4) with this behavior. At x = −2: k(−2) = 5 and lim(x→−2) k(x) = 5. At x = −1: k(−1) = 0 and lim(x→−1) k(x) = 3. At x = 1/2: k(1/2) is undefined and lim(x→1/2) k(x) = −1. At x = 2: lim(x→2⁻) k(x) = 0 and lim(x→2⁺) k(x) = 3. At x = 3: k(3) = 2 and lim(x→3) k(x) = 2. Elsewhere on (−3, 4), k is continuous. At how many values of c in (−3, 4) does lim(x→c) k(x) exist but not equal k(c), including the case where k(c) is undefined?

- A. 1
- B. 3
- C. 5
- **D. 2**

Check: Count x = −1 (3 vs 0) and x = 1/2 (−1 vs undefined); x = −2 and x = 3 match, and x = 2 has no limit.
Rationales: A: The limit at x = 1/2 exists and k(1/2) is undefined, so the limit does not equal k(1/2) and the point counts; omitting it gives 1. B: The point x = 2 has a jump so no limit exists there, and it must not be counted. C: Counting all five listed points includes x = −2 and x = 3, where the limit equals the function value, and x = 2, where no limit exists.

---

## Seed N-1.4-A (new) — Topic 1.4 Estimating Limit Values from Tables
**Skill:** estimate a limit from a two-sided table, then transform it algebraically while ignoring the defined value at the point.

The table shows values of f(x) = (e^(2x) − 1)/x near x = 0, and f(0) is defined to be 1. f(-0.1) = 1.8127; f(-0.01) = 1.9801; f(-0.001) = 1.9980; f(0.001) = 2.0020; f(0.01) = 2.0201; f(0.1) = 2.2140. Based on the table, what is the best estimate of lim(x→0) (3f(x) − 1)?

- A. 2
- B. 3
- **C. 5**
- D. 6

Check: Values of f approach 2 from both sides, so 3f(x) − 1 approaches 3·2 − 1 = 5.
Rationales: A: This uses f(0) = 1, giving 3·1 − 1 = 2, but a limit is determined by the values of f near 0, which approach 2, not by f(0). B: This computes 3(f − 1) with f approaching 2, which puts the 1 inside the multiple; the expression is 3f(x) minus 1. D: The table gives f(x) → 2, so 3f(x) → 6, but the expression also subtracts 1, giving 5.

**N-1.4-A-v1.** The table shows values of f(x) = ln(1 + 4x)/x near x = 0, and f(0) is defined to be 6. f(-0.1) = 5.1083; f(-0.01) = 4.0822; f(-0.001) = 4.0080; f(0.001) = 3.9920; f(0.01) = 3.9221; f(0.1) = 3.3647. Based on the table, what is the best estimate of lim(x→0) (f(x)/2 + 1)?

- **A. 3**
- B. 4
- C. 2
- D. 5

Check: Values of f approach 4 from both sides, so f(x)/2 + 1 approaches 4/2 + 1 = 3.
Rationales: B: This uses f(0) = 6, giving 6/2 + 1 = 4, but the limit depends on values of f near 0, which approach 4, not on f(0). C: The table gives f(x)/2 approaching 2, but the expression also adds 1, so the limit is 3. D: This adds 1 to f(x) but never halves it, giving 4 + 1 = 5; the expression is f(x)/2 + 1, which tends to 2 + 1.

**N-1.4-A-v2.** The table shows values of f(x) = (1 − cos 2x)/x² near x = 0, and f(0) is defined to be 0. f(-0.1) = 1.9933; f(-0.01) = 1.9999; f(-0.001) = 2.0000; f(0.001) = 2.0000; f(0.01) = 1.9999; f(0.1) = 1.9933. Based on the table, what is the best estimate of lim(x→0) (f(x)² − 1)?

- A. −1
- **B. 3**
- C. 1
- D. 4

Check: Values of f approach 2 from both sides, so f(x)² − 1 approaches 4 − 1 = 3.
Rationales: A: This uses f(0) = 0, giving 0² − 1 = −1, but the limit depends on values near 0, which approach 2. C: This computes f(x) − 1 with f approaching 2; the expression squares f(x) first, so the limit is 2² − 1. D: The table gives f(x)² → 4, but the expression also subtracts 1, so the limit is 3.

**N-1.4-A-v3.** The table shows values of f(x) = sin(3x)/x near x = 0, and f(0) is defined to be 0. f(-0.1) = 2.9552; f(-0.01) = 2.9996; f(-0.001) = 3.0000; f(0.001) = 3.0000; f(0.01) = 2.9996; f(0.1) = 2.9552. Based on the table, what is the best estimate of lim(x→0) (2f(x) + 1)?

- A. 1
- B. 6
- C. 4
- **D. 7**

Check: Values of f approach 3 from both sides, so 2f(x) + 1 approaches 7.
Rationales: A: This uses f(0) = 0, giving 2·0 + 1 = 1, but the limit depends on values of f near 0, which approach 3. B: The table gives 2f(x) → 6, but the expression also adds 1, so the limit is 7. C: This computes f(x) + 1 and ignores the factor 2; the expression is 2f(x) + 1, which tends to 2·3 + 1.

---

## Seed N-1.4-B (new) — Topic 1.4 Estimating Limit Values from Tables
**Skill:** recognize that a table sampled at special inputs cannot establish a limit when the function oscillates.

A student evaluates g(x) = sin(π/x) at x = 0.1, 0.01, 0.001, and 0.0001 and finds g(x) = 0 at every input (up to rounding). Which is the best conclusion?

- A. lim(x→0) g(x) = 0, because g(x) = 0 at every input checked and the inputs approach 0
- **B. The table does not justify a limit of 0: g takes the value 1 at inputs x = 2/(4n + 1) arbitrarily close to 0, so lim(x→0) g(x) does not exist**
- C. lim(x→0) g(x) = 1, because the sine of a very large angle reaches its maximum
- D. lim(x→0) g(x) does not exist only because g(0) is undefined

Check: At x = 2/(4n + 1), π/x = (4n + 1)π/2 and g = 1, while g = 0 at the tabulated inputs, so g has no limit at 0.
Rationales: A: Values that are 0 at selected inputs do not determine the limit; these inputs were chosen so that π/x is a multiple of π, which hides the oscillation. C: The sine of a large angle takes every value in [−1, 1] repeatedly, so it does not settle at its maximum 1. D: A function being undefined at a point does not prevent a limit; the limit fails to exist here because g oscillates between −1 and 1.

**N-1.4-B-v1.** A student evaluates g(x) = sin(2π/x) at x = 0.5, 0.25, 0.2, and 0.1 and finds g(x) = 0 at every input. Which is the best conclusion?

- A. lim(x→0) g(x) = 0, because every tabulated value is 0
- B. lim(x→0) g(x) = 1, because sin reaches 1 at some inputs
- **C. The table does not justify a limit of 0: g takes the value 1 at inputs x = 4/(4n + 1) arbitrarily close to 0, so lim(x→0) g(x) does not exist**
- D. lim(x→0) g(x) does not exist only because g(0) is undefined

Check: At x = 4/(4n + 1), 2π/x = (4n + 1)π/2 so g = 1, while the tabulated inputs give 0; no single limit exists.
Rationales: A: Tabulated zeros come from inputs where 2π/x is a multiple of π; other inputs near 0 give values up to 1, so the table is misleading. B: Reaching 1 at some inputs does not make 1 the limit, since g also reaches −1 and 0 at inputs arbitrarily close to 0. D: The undefined value at 0 is irrelevant to a limit; the limit fails because g keeps oscillating between −1 and 1.

**N-1.4-B-v2.** A student evaluates g(x) = sin(4π/x) at x = 0.5, 0.25, 0.125, and 0.0625 and finds g(x) = 0 at every input. Which is the best conclusion?

- **A. The table does not justify a limit of 0: g takes the value 1 at inputs x = 8/(4n + 1) arbitrarily close to 0, so lim(x→0) g(x) does not exist**
- B. lim(x→0) g(x) = 0, since the values stay at 0 as x gets smaller
- C. lim(x→0) g(x) = 4π, since the numerator of the argument is 4π
- D. lim(x→0) g(x) does not exist only because g(0) is undefined

Check: At x = 8/(4n + 1), 4π/x = (4n + 1)π/2 so g = 1, yet g = 0 at the tabulated inputs.
Rationales: B: Zeros at four chosen inputs do not control the behavior at all inputs near 0; g oscillates infinitely often. C: The constant 4π is part of the argument of the sine, not the value of the function, which always lies in [−1, 1]. D: A limit can exist where a function is undefined; this one fails because g oscillates between −1 and 1 near 0.

**N-1.4-B-v3.** A student evaluates g(x) = x sin(π/x) at x = 0.1, 0.01, 0.001, and 0.0001 and finds g(x) = 0 at every input (up to rounding). Which is the best conclusion?

- A. lim(x→0) g(x) does not exist, because sin(π/x) oscillates infinitely often near 0
- B. lim(x→0) g(x) = 1, because sin(π/x) takes the value 1 arbitrarily close to 0
- C. lim(x→0) g(x) does not exist, because g(0) is undefined
- **D. The table alone proves nothing, but lim(x→0) g(x) = 0 is correct because |g(x)| ≤ |x| for all x ≠ 0**

Check: −|x| ≤ x sin(π/x) ≤ |x| for x ≠ 0, so by the Squeeze Theorem the limit is 0, which the table cannot prove.
Rationales: A: The sine factor oscillates, but it is multiplied by x, which forces g toward 0; oscillation of a factor does not by itself rule out a limit. B: When sin(π/x) = 1, g(x) = x, which is small; the factor x pulls every value of g toward 0. C: A function can have a limit at a point where it is undefined; here the limit exists and equals 0.

---

## Seed N-1.5-A (new) — Topic 1.5 Determining Limits Using Algebraic Properties of Limits
**Skill:** use a limit of a difference quotient to deduce lim f, then apply product laws.

The function f satisfies lim(x→2) (f(x) − 5)/(x − 2) = 4. What is lim(x→2) f(x)(x² + 1)?

- A. 20
- **B. 25**
- C. 0
- D. It cannot be determined without a formula for f

Check: f(x) − 5 = [(f(x) − 5)/(x − 2)]·(x − 2) → 4·0 = 0, so f → 5 and f(x)(x² + 1) → 5·5 = 25.
Rationales: A: The value 4 is the limit of the difference quotient, not of f; the quotient has a limit and a denominator tending to 0, so f(x) − 5 → 0 and f(x) → 5, giving 5·5. C: The numerator f(x) − 5 tends to 0, but f(x) itself tends to 5, so f(x)(x² + 1) tends to 5·5, not 0. D: The given limit forces lim f(x) = 5, since f(x) − 5 = [(f(x) − 5)/(x − 2)]·(x − 2) → 4·0 = 0, so the product limit can be found.

**N-1.5-A-v1.** The function g satisfies lim(x→3) (g(x) + 2)/(x − 3) = 7. What is lim(x→3) g(x)(x − 1)?

- A. 14
- B. 0
- **C. −4**
- D. It cannot be determined without a formula for g

Check: g(x) + 2 → 7·0 = 0, so g → −2 and g(x)(x − 1) → (−2)(2) = −4.
Rationales: A: The value 7 is the limit of the quotient, not of g; the quotient forces g(x) + 2 → 0 so g → −2, and the product limit is −2·2. B: The numerator g(x) + 2 tends to 0, but g itself tends to −2, so g(x)(x − 1) → (−2)(2) = −4, not 0. D: Since g(x) + 2 = [(g(x) + 2)/(x − 3)]·(x − 3) → 7·0 = 0, we know lim g = −2, which is enough to evaluate the product.

**N-1.5-A-v2.** The function h satisfies lim(x→−1) (h(x) − 1)/(x + 1) = −3. What is lim(x→−1) h(x)(x − 4)?

- **A. −5**
- B. 15
- C. 0
- D. It cannot be determined without a formula for h

Check: h(x) − 1 → (−3)(0) = 0, so h → 1 and h(x)(x − 4) → 1·(−5) = −5.
Rationales: B: The value −3 is the limit of the quotient; using it as lim h gives (−3)(−5) = 15, but the quotient forces h → 1. C: The numerator h(x) − 1 tends to 0, but h(x) itself tends to 1, so h(x)(x − 4) → 1·(−5), not 0. D: From h(x) − 1 = [(h(x) − 1)/(x + 1)]·(x + 1) → (−3)·0 = 0 we get lim h = 1, so the product limit is 1·(−5).

**N-1.5-A-v3.** A cost function C(t), in dollars, satisfies lim(t→4) (C(t) − 20)/(t − 4) = 1.5. What is lim(t→4) t·C(t)?

- A. 6
- B. 20
- C. 0
- **D. 80**

Check: C(t) − 20 → 1.5·0 = 0, so C → 20 and t·C(t) → 4·20 = 80.
Rationales: A: The value 1.5 is the limit of the quotient, and 4·1.5 = 6 uses it as lim C, but the quotient forces C → 20. B: The quotient forces lim C(t) = 20, but the product t·C(t) also includes the factor t → 4, so the limit is 4·20. C: The numerator C(t) − 20 tends to 0, but C itself tends to 20, so t·C(t) → 4·20, not 0.

---

## Seed N-1.5-B (new) — Topic 1.5 Determining Limits Using Algebraic Properties of Limits
**Skill:** decide what algebraic limit laws guarantee when one limit is infinite, zero, or nonexistent, using the converse-style argument.

Suppose lim(x→0) f(x) = 0 and lim(x→0) |g(x)| = ∞. Which statement about lim(x→0) f(x)g(x) is true?

- A. It must equal 0, because the product of 0 and any quantity is 0
- B. It must equal ∞, because g grows without bound
- **C. It cannot be determined from this information; f(x) = x with g(x) = 1/x gives 1, while f(x) = x² with g(x) = 1/x gives 0**
- D. It does not exist, because 0·∞ is undefined

Check: x·(1/x) = 1 and x²·(1/x) = x → 0, so different pairs with the same limit behavior give different results.
Rationales: A: The product law applies only when both limits are finite; here g is unbounded, so the factor tending to 0 can be outweighed. B: The factor f(x) tends to 0 and can cancel the growth of g, as in f(x) = x with g(x) = 1/x, whose product is 1. D: An indeterminate form does not mean the limit fails to exist; the products x·(1/x) and x²·(1/x) have limits 1 and 0.

**N-1.5-B-v1.** Suppose lim(x→1) f(x) = 3 and lim(x→1) g(x) = 0. Which statement about lim(x→1) f(x)/g(x) is true?

- **A. It cannot equal any real number, because f = (f/g)·g would then tend to 0, not 3**
- B. It equals 3, because g contributes nothing in the limit
- C. It equals 0, because the numerator is bounded
- D. It must equal ∞, because the denominator tends to 0

Check: If f/g → L, then f = (f/g)·g → L·0 = 0, contradicting lim f = 3; so no real limit exists.
Rationales: B: The quotient is not f times a vanishing factor; dividing by a quantity near 0 makes the quotient large in magnitude, not close to 3. C: Dividing by a very small g makes the quotient large, not small, so 0 is not possible. D: If g takes both signs near 1, the quotient is large positive on one side and large negative on the other, so the limit may fail to exist rather than equal ∞.

**N-1.5-B-v2.** Suppose lim(x→4) f(x) = −2 and lim(x→4) g(x) does not exist. Which statement about lim(x→4) (f(x) + g(x)) is true?

- A. It equals −2, because a function without a limit contributes nothing
- **B. It does not exist, because if it did, g = (f + g) − f would have a limit**
- C. It cannot be determined, because g is not specified
- D. It equals ∞, because g is unbounded

Check: If f + g had a limit, then g = (f + g) − f would have a limit by the difference law, contradicting the hypothesis.
Rationales: A: A function lacking a limit does not contribute zero; if the sum had a limit, subtracting f would give g a limit, which it lacks. C: Nothing more is needed: the sum having a limit would force g to have one, so the sum fails to have a limit in every case. D: Not having a limit does not mean being unbounded; g may oscillate boundedly, and the argument concludes only that the sum has no limit.

**N-1.5-B-v3.** Suppose lim(x→∞) f(x) = ∞ and lim(x→∞) g(x) = −∞. Which statement about lim(x→∞) (f(x) + g(x)) is true?

- A. It equals 0, because ∞ − ∞ = 0
- B. It equals −∞, because g is negative
- C. It equals ∞, because f is positive
- **D. It cannot be determined; f(x) = x with g(x) = −x gives 0, while f(x) = 2x with g(x) = −x gives ∞**

Check: Different pairs with the same infinite behavior give 0, ∞, or −∞, so the sum is an indeterminate form.
Rationales: A: Infinity is not a number that can be cancelled; x + (−x) = 0 but 2x + (−x) = x grows without bound. B: The sum can be positive, as 2x + (−x) = x, so the sign of g alone does not decide the result. C: The sum can be 0 or even tend to −∞, as in x + (−2x) = −x, so the sign of f alone does not decide the result.

---

## Seed N-1.6-A (new) — Topic 1.6 Determining Limits Using Algebraic Manipulation
**Skill:** choose a parameter so a radical difference quotient has a finite limit, then evaluate it with the conjugate.

For the limit lim(x→1) (√(x + a) − 2)/(x − 1) to exist as a finite number, what must a be, and what is the value of the limit?

- **A. a = 3; limit 1/4**
- B. a = 3; limit 1/2
- C. a = 4; limit 1/4
- D. a = 3; limit 1/8

Check: √(1 + a) = 2 forces a = 3; then (x + 3 − 4)/((x − 1)(√(x + 3) + 2)) = 1/(√(x + 3) + 2) → 1/4.
Rationales: B: Multiplying by the conjugate gives (x − 1)/((x − 1)(√(x + 3) + 2)), so the limit is 1/(2 + 2) = 1/4; 1/2 uses only one of the two terms of the denominator. C: The numerator must vanish at x = 1, requiring √(1 + a) = 2, so a = 3; a = 4 comes from setting √a = 2 and gives a nonzero numerator. D: With a = 3 the conjugate denominator at x = 1 is √4 + 2 = 4, so the limit is 1/4; 1/8 doubles this denominator.

**N-1.6-A-v1.** For the limit lim(x→2) (√(x + a) − 3)/(x − 2) to exist as a finite number, what must a be, and what is the value of the limit?

- A. a = 7; limit 1/3
- **B. a = 7; limit 1/6**
- C. a = 9; limit 1/6
- D. a = 7; limit 1/12

Check: √(2 + a) = 3 forces a = 7; then the quotient becomes 1/(√(x + 7) + 3) → 1/6.
Rationales: A: The conjugate denominator at x = 2 is √9 + 3 = 6, so the limit is 1/6; 1/3 uses only √9 and forgets the added 3. C: The numerator must vanish at x = 2, requiring √(2 + a) = 3, so a = 7; a = 9 comes from setting √a = 3. D: The conjugate denominator at x = 2 is 6, giving 1/6; 1/12 inserts an extra factor of 2.

**N-1.6-A-v2.** For the limit lim(x→4) (√(x + a) − 5)/(x − 4) to exist as a finite number, what must a be, and what is the value of the limit?

- A. a = 21; limit 1/5
- B. a = 25; limit 1/10
- **C. a = 21; limit 1/10**
- D. a = 21; limit 1/20

Check: √(4 + a) = 5 forces a = 21; then the quotient is 1/(√(x + 21) + 5) → 1/10.
Rationales: A: The conjugate denominator at x = 4 is √25 + 5 = 10, so the limit is 1/10; 1/5 uses only √25. B: The numerator must vanish at x = 4, so √(4 + a) = 5 and a = 21; a = 25 sets √a = 5. D: With a = 21 the conjugate denominator is 10, so the limit is 1/10; 1/20 doubles the denominator.

**N-1.6-A-v3.** For the limit lim(x→1) (√(2x + a) − 3)/(x − 1) to exist as a finite number, what must a be, and what is the value of the limit?

- A. a = 7; limit 1/6
- B. a = 9; limit 1/3
- C. a = 7; limit 2/3
- **D. a = 7; limit 1/3**

Check: √(2 + a) = 3 forces a = 7; then 2(x − 1)/((x − 1)(√(2x + 7) + 3)) → 2/6 = 1/3.
Rationales: A: The conjugate numerator is (2x + 7) − 9 = 2(x − 1), so a factor of 2 survives; omitting it gives 1/6 instead of 2/6 = 1/3. B: The numerator must vanish at x = 1, so √(2 + a) = 3 and a = 7; a = 9 sets √a = 3 and ignores the 2x. C: The conjugate denominator at x = 1 is √9 + 3 = 6, so the limit is 2/6 = 1/3; 2/3 uses only √9 = 3.

---

## Seed N-1.6-B (new) — Topic 1.6 Determining Limits Using Algebraic Manipulation
**Skill:** evaluate trigonometric quotients that need a half-angle identity and the sin u / u limit together.

What is lim(x→0) (1 − cos 4x)/(x sin 2x)?

- A. 0
- **B. 4**
- C. 2
- D. 8

Check: 1 − cos 4x = 2 sin² 2x, so the quotient is 2 sin 2x / x = 4 · (sin 2x)/(2x) → 4.
Rationales: A: The numerator tends to 0, but so does the denominator, so substitution gives 0/0 and no conclusion; using 1 − cos 4x = 2 sin² 2x shows the limit is 4. C: This replaces 1 − cos 4x by sin² 2x, but the identity is 1 − cos 4x = 2 sin² 2x, which doubles the result. D: This treats sin 2x as if it were x; the denominator behaves like x·2x = 2x², while 1 − cos 4x behaves like 8x², giving 4.

**N-1.6-B-v1.** What is lim(x→0) (1 − cos 6x)/(x sin 3x)?

- A. 0
- B. 3
- **C. 6**
- D. 18

Check: 1 − cos 6x = 2 sin² 3x, so the quotient is 2 sin 3x / x = 6 · (sin 3x)/(3x) → 6.
Rationales: A: Direct substitution gives 0/0, which is indeterminate; the identity 1 − cos 6x = 2 sin² 3x shows the limit is 6. B: This drops the 2 in 1 − cos 6x = 2 sin² 3x, giving sin 3x / x → 3 instead of 6. D: This treats sin 3x as x in the denominator, giving 2·9x²/x² = 18 instead of 6.

**N-1.6-B-v2.** What is lim(x→0) tan 6x / sin 4x?

- **A. 3/2**
- B. 2/3
- C. 1
- D. 24

Check: tan 6x / sin 4x = (sin 6x)/(cos 6x · sin 4x) → (6x)/(1 · 4x) = 3/2.
Rationales: B: This inverts the ratio; near 0, tan 6x ≈ 6x and sin 4x ≈ 4x, so the quotient approaches 6/4, not 4/6. C: This treats tan 6x and sin 4x as both approaching the same multiple of x, ignoring the coefficients 6 and 4. D: This multiplies the coefficients 6 and 4 instead of dividing them.

**N-1.6-B-v3.** What is lim(x→0) (1 − cos 2x)/(x tan x)?

- A. 0
- B. 1
- C. 4
- **D. 2**

Check: 1 − cos 2x = 2 sin² x, and tan x ≈ x, so the quotient is 2 sin x cos x / x → 2.
Rationales: A: Substituting gives 0/0, which is indeterminate; the identity 1 − cos 2x = 2 sin² x shows the limit is 2. B: This replaces 1 − cos 2x by sin² x, missing the factor 2 in the identity 1 − cos 2x = 2 sin² x. C: This uses 1 − cos θ ≈ θ², giving 4x²/x² = 4, but the correct approximation is θ²/2, giving 2x²/x² = 2.

---

## Seed N-1.7-A (new) — Topic 1.7 Selecting Procedures for Determining Limits
**Skill:** match each limit with an appropriate procedure and identify which one has the stated value.

Which of the following limits equals 2?

- **A. lim(x→∞) (4x² − x)/(2x² + 1)**
- B. lim(x→0) (√(x + 4) − 2)/x
- C. lim(x→0) sin 6x / (2x)
- D. lim(x→1) (x³ − 1)/(x² − 1)

Check: Dividing by x² gives (4 − 1/x)/(2 + 1/x²) → 2; the other three limits are 1/4, 3, and 3/2.
Rationales: B: Multiplying by the conjugate gives 1/(√(x + 4) + 2), which tends to 1/4, not 2. C: Writing sin 6x/(2x) = 3 · (sin 6x)/(6x) shows the limit is 3, not 2. D: Factoring gives (x² + x + 1)/(x + 1), which tends to 3/2, not 2.

**N-1.7-A-v1.** Which of the following limits equals 3?

- A. lim(x→0) (√(x + 9) − 3)/x
- **B. lim(x→0) sin 6x / (2x)**
- C. lim(x→∞) (9x² + x)/(3x³ − 2)
- D. lim(x→2) (x² − 4)/(x − 2)

Check: sin 6x/(2x) = 3·(sin 6x)/(6x) → 3; the other limits are 1/6, 0, and 4.
Rationales: A: The conjugate gives 1/(√(x + 9) + 3), which tends to 1/6, not 3. C: The denominator has the higher degree, so the quotient tends to 0, not 3. D: Factoring gives x + 2, which tends to 4, not 3.

**N-1.7-A-v2.** Which of the following limits equals 1?

- A. lim(x→0) sin x / (2x)
- B. lim(x→0) (1 − cos x)/x
- **C. lim(x→∞) (x² + sin x)/(x² − cos x)**
- D. lim(x→1) (x² − 1)/(x − 1)

Check: Dividing by x² gives (1 + sin x/x²)/(1 − cos x/x²) → 1 since the sine and cosine terms are bounded; the others are 1/2, 0, and 2.
Rationales: A: Writing sin x/(2x) = (1/2)·(sin x)/x shows the limit is 1/2, not 1. B: Since 1 − cos x behaves like x²/2, the quotient tends to 0, not 1. D: Factoring gives x + 1, which tends to 2, not 1.

**N-1.7-A-v3.** Which of the following limits equals −1?

- A. lim(x→0) |x|/x
- B. lim(x→∞) x/√(x² + 1)
- C. lim(x→0) (cos x − 1)/x²
- **D. lim(x→−∞) x/√(x² + 1)**

Check: For x < 0, √(x² + 1) = |x|√(1 + 1/x²) = −x√(1 + 1/x²), so the quotient tends to −1; the others are DNE, 1, and −1/2.
Rationales: A: The one-sided limits are 1 and −1, so this limit does not exist. B: For x > 0, √(x² + 1)/x → 1, so the limit is +1, not −1. C: Using cos x − 1 ≈ −x²/2 gives −1/2, not −1.

---

## Seed N-1.7-B (new) — Topic 1.7 Selecting Procedures for Determining Limits
**Skill:** locate the first error in a student's worked limit and recognize why the step fails.

A student evaluates lim(x→3) (√(x + 6) − 3)/(x − 3) as follows. Step 1: Substituting x = 3 gives 0/0, so the expression must be rewritten. Step 2: Multiply numerator and denominator by √(x + 6) + 3; the numerator becomes (x + 6) − 9 = x − 3. Step 3: Cancel the factor x − 3 from numerator and denominator, leaving √(x + 6) + 3. Step 4: Substitute x = 3 to get √9 + 3 = 6. In which step does the first error occur?

- A. Step 1
- B. Step 2
- **C. Step 3**
- D. Step 4

Check: Step 3 should leave 1/(√(x + 6) + 3), since the factor x − 3 cancels from the numerator; the limit is 1/6.
Rationales: A: Substitution giving 0/0 is indeterminate, so rewriting the expression is the right move and this step has no error. B: Multiplying by the conjugate gives the numerator (x + 6) − 9 = x − 3, which is correct, and the denominator becomes (x − 3)(√(x + 6) + 3). D: Substituting into √(x + 6) + 3 does give 6, so the arithmetic is right; the wrong answer comes from the cancellation in Step 3, which is earlier.

**N-1.7-B-v1.** A student evaluates lim(x→2) (x² − 4)/(x − 2) as follows. Step 1: Substituting x = 2 gives 0/0, so the expression must be rewritten. Step 2: Factor the numerator as (x − 2)². Step 3: Cancel one factor of x − 2, leaving x − 2. Step 4: Substitute x = 2 to get 0. In which step does the first error occur?

- A. Step 1
- **B. Step 2**
- C. Step 3
- D. Step 4

Check: x² − 4 factors as (x − 2)(x + 2), so the quotient simplifies to x + 2 and the limit is 4; the error is in Step 2.
Rationales: A: Substitution gives 0/0, which signals the need for algebra, so this step is correct. C: Cancelling one factor of x − 2 from (x − 2)²/(x − 2) does leave x − 2, so this step follows from Step 2; the mistake is the factorization before it. D: Substituting x = 2 into x − 2 does give 0, so this step follows correctly from the previous one; the error came earlier.

**N-1.7-B-v2.** A student evaluates lim(x→0) (sin 5x)/(sin 2x) as follows. Step 1: Divide numerator and denominator by x. Step 2: Rewrite the quotient as 5·[sin 5x/(5x)] divided by 2·[sin 2x/(2x)]. Step 3: Each bracket has limit 1, so the numerator tends to 5 and the denominator tends to 2. Step 4: Subtract to get 5 − 2 = 3. In which step does the first error occur?

- A. Step 1
- B. Step 2
- C. Step 3
- **D. Step 4**

Check: The quotient 5/2 should be formed by dividing, not subtracting; the limit is 5/2.
Rationales: A: Dividing numerator and denominator by x leaves the quotient unchanged for x ≠ 0, so this step is valid. B: Writing sin 5x / x = 5·(sin 5x)/(5x) and sin 2x / x = 2·(sin 2x)/(2x) is correct algebra. C: Since lim(u→0) sin u / u = 1, each bracket tends to 1, so the numerator tends to 5 and the denominator to 2; this step is correct.

**N-1.7-B-v3.** A student evaluates lim(x→−∞) (2x + 1)/√(x² + 1) as follows. Step 1: Divide numerator and denominator by x. Step 2: Since √(x² + 1)/x = √(1 + 1/x²), the expression becomes (2 + 1/x)/√(1 + 1/x²). Step 3: As x → −∞, 1/x → 0. Step 4: The limit is 2/1 = 2. In which step does the first error occur?

- A. Step 1
- **B. Step 2**
- C. Step 3
- D. Step 4

Check: For x < 0, √(x² + 1)/x = −√(1 + 1/x²), so the limit is 2/(−1) = −2; the error is in Step 2.
Rationales: A: Dividing numerator and denominator by x is valid for x ≠ 0, so no error occurs here. C: As x tends to negative infinity, 1/x does tend to 0, so this step is correct. D: Given the expression in Step 2 the limit would be 2/1, so Step 4 follows; the mistake is earlier, in how the radical was divided by a negative x.

---

## Seed N-1.8-A (new) — Topic 1.8 Determining Limits Using the Squeeze Theorem
**Skill:** bound a quotient containing a bounded oscillating term and squeeze at infinity.

What is lim(x→∞) (x + 3 sin x)/(2x + 1)?

- **A. 1/2**
- B. The limit does not exist
- C. 3/2
- D. 1

Check: For x > 0, (x − 3)/(2x + 1) ≤ (x + 3 sin x)/(2x + 1) ≤ (x + 3)/(2x + 1), and both bounds tend to 1/2.
Rationales: B: The sine term oscillates, but it is bounded between −3 and 3 while x grows, so the quotient is squeezed between (x − 3)/(2x + 1) and (x + 3)/(2x + 1), both approaching 1/2. C: This replaces sin x by its maximum 1 and then treats the 3 as a multiple of x; the bounded term is negligible next to x. D: This keeps the coefficient of x in the numerator but ignores the 2 in the denominator; the ratio of leading coefficients is 1/2.

**N-1.8-A-v1.** What is lim(x→∞) (2x − 5 cos x)/(x + 4)?

- A. The limit does not exist
- **B. 2**
- C. −5
- D. 7

Check: (2x − 5)/(x + 4) ≤ (2x − 5 cos x)/(x + 4) ≤ (2x + 5)/(x + 4) for x > −4, and both bounds tend to 2.
Rationales: A: The cosine term oscillates but is bounded, so the quotient is squeezed between (2x − 5)/(x + 4) and (2x + 5)/(x + 4), both tending to 2. C: This reads the oscillating term as dominant; −5 cos x is bounded while 2x grows without bound. D: This adds the maximum of the oscillating term, 5, to the leading coefficient 2, but a bounded term vanishes relative to x.

**N-1.8-A-v2.** What is lim(x→∞) x² sin x / (x³ + 1)?

- **A. 0**
- B. The limit does not exist
- C. 1
- D. ∞

Check: |x² sin x/(x³ + 1)| ≤ x²/(x³ + 1) → 0, so the limit is 0 by the Squeeze Theorem.
Rationales: B: The sine factor oscillates, but its size is at most 1, so the quotient is squeezed between −x²/(x³ + 1) and x²/(x³ + 1), both tending to 0. C: This cancels x² with x³ and lets the sine factor equal 1; the denominator grows faster than the numerator. D: The numerator x² sin x is large in size, but the denominator x³ + 1 grows faster, so the quotient is squeezed toward 0.

**N-1.8-A-v3.** What is lim(x→∞) (4x² − 3x cos x)/(x² + 2)?

- A. The limit does not exist
- B. 7
- C. 1
- **D. 4**

Check: (4x² − 3x)/(x² + 2) ≤ (4x² − 3x cos x)/(x² + 2) ≤ (4x² + 3x)/(x² + 2) for x > 0, and both bounds tend to 4.
Rationales: A: The cosine term oscillates, but it is bounded and multiplied by 3x, which is small next to 4x²; both (4x² − 3x)/(x² + 2) and (4x² + 3x)/(x² + 2) tend to 4. B: This adds the maximum size of the oscillating term, 3, to 4, but that term is dominated by x². C: This divides leading terms without including the coefficient 4 in the numerator; the ratio of leading coefficients is 4/1.

---

## Seed N-1.8-B (new) — Topic 1.8 Determining Limits Using the Squeeze Theorem
**Skill:** use a bound on |f| to squeeze a quotient f(x)/xⁿ, and recognize when the bound is too weak.

A function f satisfies |f(x)| ≤ x² for all x. What is lim(x→0) f(x)/x?

- **A. 0**
- B. 1
- C. The limit does not exist, because f(x)/x is of the form 0/0
- D. It cannot be determined, because f is not given explicitly

Check: |f(x)/x| ≤ x²/|x| = |x| → 0, so f(x)/x → 0.
Rationales: B: Nothing in the bound gives the value 1; dividing |f(x)| ≤ x² by |x| gives |f(x)/x| ≤ |x|, which tends to 0. C: A 0/0 form is indeterminate, not nonexistent; here −|x| ≤ f(x)/x ≤ |x| squeezes the quotient to 0. D: The inequality alone suffices: |f(x)/x| ≤ |x| for x ≠ 0, so the Squeeze Theorem applies without a formula.

**N-1.8-B-v1.** A function g satisfies |g(x) − 3| ≤ 2(x − 1)² for all x. What is lim(x→1) (g(x) − 3)/(x − 1)?

- A. 2
- **B. 0**
- C. 3
- D. The limit does not exist, because both numerator and denominator tend to 0

Check: |(g(x) − 3)/(x − 1)| ≤ 2|x − 1| → 0, so the quotient tends to 0.
Rationales: A: The constant 2 is the coefficient in the bound, but dividing by |x − 1| gives |(g(x) − 3)/(x − 1)| ≤ 2|x − 1|, which tends to 0. C: The value 3 is the limit of g itself, not of the quotient; the quotient is squeezed to 0. D: Both tending to 0 is an indeterminate form, not a proof of nonexistence; the bound squeezes the quotient to 0.

**N-1.8-B-v2.** A function h satisfies |h(x)| ≤ 5x⁴ for all x. What is lim(x→0) h(x)/x²?

- A. 5
- B. The limit does not exist
- **C. 0**
- D. ∞

Check: |h(x)/x²| ≤ 5x⁴/x² = 5x² → 0, so the quotient tends to 0.
Rationales: A: The constant 5 comes from the bound, but dividing by x² gives |h(x)/x²| ≤ 5x², which tends to 0. B: The inequality bounds the quotient by 5x², so it is squeezed between −5x² and 5x², both tending to 0. D: Dividing by x² does not make the quotient grow; the bound |h(x)/x²| ≤ 5x² keeps it small near 0.

**N-1.8-B-v3.** A function k satisfies |k(x)| ≤ 5x² for all x. What can be concluded about lim(x→0) k(x)/x²?

- A. It equals 0, because |k(x)| is squeezed to 0
- B. It equals 5, because the bound is 5x²
- C. It does not exist, because k is not specified
- **D. Nothing definite: k(x) = 3x² gives 3, while k(x) = 5x² sin(1/x) gives no limit**

Check: Both k(x) = 3x² and k(x) = 5x² sin(1/x) satisfy |k(x)| ≤ 5x², yet the quotients tend to 3 and oscillate.
Rationales: A: The bound gives k(x) → 0, but after dividing by x² the bound only says |k(x)/x²| ≤ 5, which does not force a limit of 0. B: The bound is only an upper limit on |k(x)|/x²; k(x) = 3x² satisfies it and gives 3. C: A limit may exist or not depending on k; for k(x) = 3x² it exists and equals 3, so nonexistence is not forced.

---
