# AP Precalculus Unit 2, topics 2.1 to 2.8: harder new seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key and distractor value was recomputed in Python (exact fractions) while writing.
Scope: topics 2.1 to 2.8 only (2.9 to 2.15 are covered by another author). Two new seeds per topic, each with three variants, written at R3 level (multi-step reasoning, interpretation, error analysis). Seed A and Seed B of a topic test different skills; none reuses the stems or skills of the existing published items.

| Seed | Topic | Replaces |
|---|---|---|
| N-2.1-A | 2.1 Change in Arithmetic and Geometric Sequences | new: compare an arithmetic and a geometric sequence term by term to find when the geometric one first overtakes, avoiding index-shift and step-size errors |
| N-2.1-B | 2.1 Change in Arithmetic and Geometric Sequences | new: recover the common ratio of a geometric sequence from two non-adjacent terms (including its sign) and extend the sequence, rejecting arithmetic and exponent-span errors |
| N-2.2-A | 2.2 Change in Linear and Exponential Functions | new: decide where an exponential function lies relative to the line through two of its points, using concavity rather than the rule that exponentials grow faster |
| N-2.2-B | 2.2 Change in Linear and Exponential Functions | new: use the fact that average rates of change of an exponential over equal-length intervals form a geometric pattern with ratio bʰ, to extend a pattern of rates |
| N-2.3-A | 2.3 Exponential Functions | new: work back from two non-adjacent values of an exponential function to its initial value, resisting linear extrapolation and off-by-one exponents |
| N-2.3-B | 2.3 Exponential Functions | new: combine the sign of the coefficient, the size of the base, and a vertical shift to describe monotonicity, range and y-intercept of a transformed exponential |
| N-2.4-A | 2.4 Exponential Function Manipulation | new: rewrite an exponential with a fractional exponent and a horizontal shift in the form a·bᵗ, tracking both the new base and the new coefficient |
| N-2.4-B | 2.4 Exponential Function Manipulation | new: see that a horizontal translation of an exponential graph equals a vertical scaling, and find the scale factor as a power of the base with the correct sign |
| N-2.5-A | 2.5 Exponential Function Context and Data Modeling | new: build an exponential model from two measurements taken three units apart, backing out the initial value and the per-unit percent change instead of using the totals |
| N-2.5-B | 2.5 Exponential Function Context and Data Modeling | new: convert a yearly growth or decay factor to the factor and percent change for a shorter period by taking a root, not by dividing the percent or the factor |
| N-2.6-A | 2.6 Competing Function Model Validation | new: judge a regression model by residuals on the data range, then recognize that a prediction far outside that range can violate the context even though the residuals are random |
| N-2.6-B | 2.6 Competing Function Model Validation | new: choose between linear, quadratic and exponential models from a table by checking first differences, second differences and ratios, rejecting 'differences are not constant, so exponential' |
| N-2.7-A | 2.7 Composition of Functions | new: find the domain of a composition by requiring the inner output to lie in the outer function's domain, rather than using either function's domain separately |
| N-2.7-B | 2.7 Composition of Functions | new: solve an equation that sets two different compositions of the same functions equal, expanding the square of a linear expression correctly |
| N-2.8-A | 2.8 Inverse Functions | new: find the inverse of a rational function by swapping and solving, and reject the reciprocal and sign-slip answers by composing |
| N-2.8-B | 2.8 Inverse Functions | new: evaluate an expression combining an inverse with function values from a table, applying the inverse to the combined output and not distributing it |

---

## Seed N-2.1-A (new) — Topic 2.1 Change in Arithmetic and Geometric Sequences
**Skill:** compare an arithmetic and a geometric sequence term by term to find when the geometric one first overtakes, avoiding index-shift and step-size errors.

Two savings plans are tracked by month number n. Plan X's balance in dollars is an arithmetic sequence aₙ with a₁ = 200 and common difference 30. Plan Y's balance in dollars is a geometric sequence bₙ with b₁ = 50 and common ratio 1.4. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?

- A. 6
- **B. 8**
- C. 4
- D. 7

Check: aₙ = 200 + 30(n − 1) and bₙ = 50·1.4ⁿ⁻¹. Comparing term by term, b₇ = 376.5 < a₇ = 380, and b₈ = 527.1 > a₈ = 410, so the smallest n is 8.
Rationales: A: This uses bₙ = 50·1.4ⁿ, one term ahead of the sequence described. Since b₁ = 50 is the first term the exponent must be n − 1, and at n = 6 the correct value is b₆ = 268.9, still below a₆ = 350. C: This compares the size of each step of bₙ with the constant step 30 of aₙ. The step in bₙ first exceeds 30 at n = 4, but the question is about the values themselves: b₄ = 137.2 is still below a₄ = 290. D: This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₇ = 376.5 is still below a₇ = 380, so Y has not yet passed X at n = 7.

**N-2.1-A-v1.** Two streaming channels are tracked by week number n. Channel X's subscriber count is an arithmetic sequence aₙ with a₁ = 500 and common difference 60. Channel Y's subscriber count is a geometric sequence bₙ with b₁ = 100 and common ratio 1.5. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?

- **A. 7**
- B. 5
- C. 3
- D. 6

Check: aₙ = 500 + 60(n − 1) and bₙ = 100·1.5ⁿ⁻¹. Comparing term by term, b₆ = 759.4 < a₆ = 800, and b₇ = 1139.1 > a₇ = 860, so the smallest n is 7.
Rationales: B: This uses bₙ = 100·1.5ⁿ, one term ahead of the sequence described. Since b₁ = 100 is the first term the exponent must be n − 1, and at n = 5 the correct value is b₅ = 506.3, still below a₅ = 740. C: This compares the size of each step of bₙ with the constant step 60 of aₙ. The step in bₙ first exceeds 60 at n = 3, but the question is about the values themselves: b₃ = 225 is still below a₃ = 620. D: This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₆ = 759.4 is still below a₆ = 800, so Y has not yet passed X at n = 6.

**N-2.1-A-v2.** Two rental programs are tracked by day number n. Program X's total number of bookings is an arithmetic sequence aₙ with a₁ = 150 and common difference 20. Program Y's total number of bookings is a geometric sequence bₙ with b₁ = 60 and common ratio 1.25. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?

- A. 7
- B. 4
- **C. 9**
- D. 8

Check: aₙ = 150 + 20(n − 1) and bₙ = 60·1.25ⁿ⁻¹. Comparing term by term, b₈ = 286.1 < a₈ = 290, and b₉ = 357.6 > a₉ = 310, so the smallest n is 9.
Rationales: A: This uses bₙ = 60·1.25ⁿ, one term ahead of the sequence described. Since b₁ = 60 is the first term the exponent must be n − 1, and at n = 7 the correct value is b₇ = 228.9, still below a₇ = 270. B: This compares the size of each step of bₙ with the constant step 20 of aₙ. The step in bₙ first exceeds 20 at n = 4, but the question is about the values themselves: b₄ = 117.2 is still below a₄ = 210. D: This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₈ = 286.1 is still below a₈ = 290, so Y has not yet passed X at n = 8.

**N-2.1-A-v3.** Two water tanks are tracked by hour number n. Tank X's volume in liters is an arithmetic sequence aₙ with a₁ = 400 and common difference 80. Tank Y's volume in liters is a geometric sequence bₙ with b₁ = 40 and common ratio 1.5. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?

- A. 8
- B. 6
- C. 9
- **D. 10**

Check: aₙ = 400 + 80(n − 1) and bₙ = 40·1.5ⁿ⁻¹. Comparing term by term, b₉ = 1025.2 < a₉ = 1040, and b₁₀ = 1537.7 > a₁₀ = 1120, so the smallest n is 10.
Rationales: A: This uses bₙ = 40·1.5ⁿ, one term ahead of the sequence described. Since b₁ = 40 is the first term the exponent must be n − 1, and at n = 8 the correct value is b₈ = 683.4, still below a₈ = 960. B: This compares the size of each step of bₙ with the constant step 80 of aₙ. The step in bₙ first exceeds 80 at n = 6, but the question is about the values themselves: b₆ = 303.8 is still below a₆ = 800. C: This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₉ = 1025.2 is still below a₉ = 1040, so Y has not yet passed X at n = 9.

---

## Seed N-2.1-B (new) — Topic 2.1 Change in Arithmetic and Geometric Sequences
**Skill:** recover the common ratio of a geometric sequence from two non-adjacent terms (including its sign) and extend the sequence, rejecting arithmetic and exponent-span errors.

A geometric sequence g has real terms. Its terms are g₂ = 12 and g₅ = −96. What is g₈?

- A. −768
- **B. 768**
- C. −204
- D. −6144

Check: From g₅/g₂ = r³ = −8 we get r = −2. Then g₈ = g₅·r³ = −96·(−8) = 768.
Rationales: A: This takes the common ratio to be 2 instead of −2. The terms g₂ = 12 and g₅ = −96 have opposite signs over three steps, so r³ = −8 forces a negative ratio, and the sign of g₈ follows from it. C: This treats the sequence as arithmetic, with common difference (−96 − 12)/3 = −36. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition. D: This multiplies g₅ by r over 6 steps, but g₈ is only three steps after g₅. The exponent must be the difference of the indices, 8 − 5 = 3, not 8 − 2.

**N-2.1-B-v1.** A geometric sequence h has real terms. Its terms are h₁ = 2 and h₄ = −54. What is h₇?

- A. −1458
- B. −110
- **C. 1458**
- D. −39366

Check: From h₄/h₁ = r³ = −27 we get r = −3. Then h₇ = h₄·r³ = −54·(−27) = 1458.
Rationales: A: This takes the common ratio to be 3 instead of −3. The terms h₁ = 2 and h₄ = −54 have opposite signs over three steps, so r³ = −27 forces a negative ratio, and the sign of h₇ follows from it. B: This treats the sequence as arithmetic, with common difference (−54 − 2)/3 = −56/3. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition. D: This multiplies h₄ by r over 6 steps, but h₇ is only three steps after h₄. The exponent must be the difference of the indices, 7 − 4 = 3, not 7 − 1.

**N-2.1-B-v2.** A geometric sequence u has real terms. Its terms are u₂ = 48 and u₅ = −6. What is u₈?

- A. −0.75
- B. −60
- C. −0.09375
- **D. 0.75**

Check: From u₅/u₂ = r³ = −0.125 we get r = −0.5. Then u₈ = u₅·r³ = −6·(−0.125) = 0.75.
Rationales: A: This takes the common ratio to be 0.5 instead of −0.5. The terms u₂ = 48 and u₅ = −6 have opposite signs over three steps, so r³ = −0.125 forces a negative ratio, and the sign of u₈ follows from it. B: This treats the sequence as arithmetic, with common difference (−6 − 48)/3 = −18. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition. C: This multiplies u₅ by r over 6 steps, but u₈ is only three steps after u₅. The exponent must be the difference of the indices, 8 − 5 = 3, not 8 − 2.

**N-2.1-B-v3.** A geometric sequence w has real terms. Its terms are w₃ = −5 and w₆ = 40. What is w₉?

- **A. −320**
- B. 320
- C. 85
- D. 2560

Check: From w₆/w₃ = r³ = −8 we get r = −2. Then w₉ = w₆·r³ = 40·(−8) = −320.
Rationales: B: This takes the common ratio to be 2 instead of −2. The terms w₃ = −5 and w₆ = 40 have opposite signs over three steps, so r³ = −8 forces a negative ratio, and the sign of w₉ follows from it. C: This treats the sequence as arithmetic, with common difference (40 − −5)/3 = 15. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition. D: This multiplies w₆ by r over 6 steps, but w₉ is only three steps after w₆. The exponent must be the difference of the indices, 9 − 6 = 3, not 9 − 3.

---

## Seed N-2.2-A (new) — Topic 2.2 Change in Linear and Exponential Functions
**Skill:** decide where an exponential function lies relative to the line through two of its points, using concavity rather than the rule that exponentials grow faster.

A linear function L and an exponential function E satisfy L(0) = E(0) = 4 and L(2) = E(2) = 36. Which statement about their values at x = 1 and x = 3 is true?

- A. E(1) > L(1) and E(3) > L(3)
- **B. E(1) < L(1) and E(3) > L(3)**
- C. E(1) > L(1) and E(3) < L(3)
- D. E(1) = L(1) and E(3) > L(3)

Check: E(x) = 4·3ˣ and L(x) = 16x + 4. E(1) = 12 < L(1) = 20, and E(3) = 108 > L(3) = 52.
Rationales: A: This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 0 and x = 2, the concave-up exponential lies below the line between those points: E(1) = 12 is less than L(1) = 20. C: This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(3) = 108 exceeds L(3) = 52. D: This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(1) = 12 while L(1) = 20, so they differ even though they agree at x = 0 and x = 2.

**N-2.2-A-v1.** A linear function L and an exponential function E satisfy L(0) = E(0) = 100 and L(2) = E(2) = 25. Which statement about their values at x = 1 and x = 3 is true?

- A. E(1) > L(1) and E(3) > L(3)
- B. E(1) > L(1) and E(3) < L(3)
- **C. E(1) < L(1) and E(3) > L(3)**
- D. E(1) = L(1) and E(3) > L(3)

Check: E(x) = 100·(1/2)ˣ and L(x) = (−75/2)x + 100. E(1) = 50 < L(1) = 62.5, and E(3) = 12.5 > L(3) = −12.5.
Rationales: A: This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 0 and x = 2, the concave-up exponential lies below the line between those points: E(1) = 50 is less than L(1) = 62.5. B: This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(3) = 12.5 exceeds L(3) = −12.5. D: This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(1) = 50 while L(1) = 62.5, so they differ even though they agree at x = 0 and x = 2.

**N-2.2-A-v2.** A linear function L and an exponential function E satisfy L(0) = E(0) = 5 and L(3) = E(3) = 40. Which statement about their values at x = 1 and x = 4 is true?

- **A. E(1) < L(1) and E(4) > L(4)**
- B. E(1) > L(1) and E(4) > L(4)
- C. E(1) > L(1) and E(4) < L(4)
- D. E(1) = L(1) and E(4) > L(4)

Check: E(x) = 5·2ˣ and L(x) = (35/3)x + 5. E(1) = 10 < L(1) = 16.7, and E(4) = 80 > L(4) = 51.7.
Rationales: B: This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 0 and x = 3, the concave-up exponential lies below the line between those points: E(1) = 10 is less than L(1) = 16.7. C: This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(4) = 80 exceeds L(4) = 51.7. D: This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(1) = 10 while L(1) = 16.7, so they differ even though they agree at x = 0 and x = 3.

**N-2.2-A-v3.** A linear function L and an exponential function E satisfy L(1) = E(1) = 12 and L(3) = E(3) = 48. Which statement about their values at x = 2 and x = 4 is true?

- A. E(2) > L(2) and E(4) > L(4)
- B. E(2) > L(2) and E(4) < L(4)
- C. E(2) = L(2) and E(4) > L(4)
- **D. E(2) < L(2) and E(4) > L(4)**

Check: E(x) = 6·2ˣ and L(x) = 18x − 6. E(2) = 24 < L(2) = 30, and E(4) = 96 > L(4) = 66.
Rationales: A: This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 1 and x = 3, the concave-up exponential lies below the line between those points: E(2) = 24 is less than L(2) = 30. B: This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(4) = 96 exceeds L(4) = 66. C: This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(2) = 24 while L(2) = 30, so they differ even though they agree at x = 1 and x = 3.

---

## Seed N-2.2-B (new) — Topic 2.2 Change in Linear and Exponential Functions
**Skill:** use the fact that average rates of change of an exponential over equal-length intervals form a geometric pattern with ratio bʰ, to extend a pattern of rates.

An exponential function f is defined for all real x. The average rate of change of f over the interval [0, 2] is 6, and over [2, 4] it is 54. What is the average rate of change of f over [4, 6]?

- **A. 486**
- B. 102
- C. 162
- D. 63

Check: Each average rate is ab^x(b^2 − 1)/2 evaluated at the left end, so over consecutive intervals of length 2 the rates are multiplied by b^2. Here 54/6 = 9, so the next rate is 54·9 = 486.
Rationales: B: This continues an arithmetic pattern, adding the same amount (48) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 9, not increased by a constant amount. C: This multiplies by the growth factor per unit input, 3, but the intervals have length 2. Over 2 units the rates are multiplied by 3^2 = 9, which is the ratio 54/6 already shown. D: This adds the ratio 9 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 9, so the next rate is 54 times 9.

**N-2.2-B-v1.** An exponential function f models a quantity measured in thousands, with input in hours. The average rate of change of f over the interval [0, 3] is 5, and over [3, 6] it is 40. What is the average rate of change of f over [6, 9]?

- A. 75
- **B. 320**
- C. 80
- D. 48

Check: Each average rate is ab^x(b^3 − 1)/3 evaluated at the left end, so over consecutive intervals of length 3 the rates are multiplied by b^3. Here 40/5 = 8, so the next rate is 40·8 = 320.
Rationales: A: This continues an arithmetic pattern, adding the same amount (35) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 8, not increased by a constant amount. C: This multiplies by the growth factor per unit input, 2, but the intervals have length 3. Over 3 units the rates are multiplied by 2^3 = 8, which is the ratio 40/5 already shown. D: This adds the ratio 8 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 8, so the next rate is 40 times 8.

**N-2.2-B-v2.** A decaying exponential function f is defined for all real x. The average rate of change of f over the interval [0, 2] is −48, and over [2, 4] it is −12. What is the average rate of change of f over [4, 6]?

- A. 24
- B. −6
- **C. −3**
- D. −11.75

Check: Each average rate is ab^x(b^2 − 1)/2 evaluated at the left end, so over consecutive intervals of length 2 the rates are multiplied by b^2. Here −12/−48 = 0.25, so the next rate is −12·0.25 = −3.
Rationales: A: This continues an arithmetic pattern, adding the same amount (36) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 0.25, not increased by a constant amount. B: This multiplies by the growth factor per unit input, 0.5, but the intervals have length 2. Over 2 units the rates are multiplied by 0.5^2 = 0.25, which is the ratio −12/−48 already shown. D: This adds the ratio 0.25 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 0.25, so the next rate is −12 times 0.25.

**N-2.2-B-v3.** An exponential function f models the height of a plant in centimeters, with input in weeks. The average rate of change of f over the interval [0, 2] is 8, and over [2, 4] it is 18. What is the average rate of change of f over [4, 6]?

- A. 28
- B. 27
- C. 20.25
- **D. 40.5**

Check: Each average rate is ab^x(b^2 − 1)/2 evaluated at the left end, so over consecutive intervals of length 2 the rates are multiplied by b^2. Here 18/8 = 2.25, so the next rate is 18·2.25 = 40.5.
Rationales: A: This continues an arithmetic pattern, adding the same amount (10) again. Average rates of change of an exponential function over equal-length intervals are multiplied by a constant factor, here 2.25, not increased by a constant amount. B: This multiplies by the growth factor per unit input, 1.5, but the intervals have length 2. Over 2 units the rates are multiplied by 1.5^2 = 2.25, which is the ratio 18/8 already shown. C: This adds the ratio 2.25 to the previous rate instead of multiplying by it. The two given rates differ by a factor of 2.25, so the next rate is 18 times 2.25.

---

## Seed N-2.3-A (new) — Topic 2.3 Exponential Functions
**Skill:** work back from two non-adjacent values of an exponential function to its initial value, resisting linear extrapolation and off-by-one exponents.

A function has the form f(x) = a·bˣ with b > 0, f(2) = 18, and f(5) = 486. What is f(0)?

- A. 6
- **B. 2**
- C. 2/3
- D. −294

Check: f(5)/f(2) = b^3 = 27, so b = 3. Then a = f(2)/b^2 = 18/9 = 2, so f(0) = 2.
Rationales: A: This divides f(2) by b^1, which only steps back to x = 1, not to x = 0. Since f(2) = a·b^2, the initial value a requires dividing by b^2, and a·b = 6 is the value of f(1). C: This divides f(2) by b^3, going one step past x = 0. Since f(2) = a·b^2, dividing by b^2 gives a, while dividing by b^3 gives a/b, which is f(−1). D: This extends a straight line through the two given points, with a constant change of 156 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.

**N-2.3-A-v1.** Let f be a function of the form f(x) = a·bˣ with b > 0, f(1) = −12, and f(4) = −324. What is f(0)?

- A. −12
- B. −4/3
- **C. −4**
- D. 92

Check: f(4)/f(1) = b^3 = 27, so b = 3. Then a = f(1)/b^1 = −12/3 = −4, so f(0) = −4.
Rationales: A: This divides f(1) by b^0, which only steps back to x = 1, not to x = 0. Since f(1) = a·b^1, the initial value a requires dividing by b^1, and a·b = −12 is the value of f(1). B: This divides f(1) by b^2, going one step past x = 0. Since f(1) = a·b^1, dividing by b^1 gives a, while dividing by b^2 gives a/b, which is f(−1). D: This extends a straight line through the two given points, with a constant change of −104 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.

**N-2.3-A-v2.** An exponential function has the form f(x) = a·bˣ with b > 0, f(1) = 20, and f(4) = 2.5. What is f(0)?

- **A. 40**
- B. 20
- C. 80
- D. 155/6

Check: f(4)/f(1) = b^3 = 0.125, so b = 0.5. Then a = f(1)/b^1 = 20/0.5 = 40, so f(0) = 40.
Rationales: B: This divides f(1) by b^0, which only steps back to x = 1, not to x = 0. Since f(1) = a·b^1, the initial value a requires dividing by b^1, and a·b = 20 is the value of f(1). C: This divides f(1) by b^2, going one step past x = 0. Since f(1) = a·b^1, dividing by b^1 gives a, while dividing by b^2 gives a/b, which is f(−1). D: This extends a straight line through the two given points, with a constant change of −35/6 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.

**N-2.3-A-v3.** A function has the form f(x) = a·bˣ with b > 0, f(3) = 24, and f(5) = 96. What is f(0)?

- A. 6
- B. 1.5
- C. −84
- **D. 3**

Check: f(5)/f(3) = b^2 = 4, so b = 2. Then a = f(3)/b^3 = 24/8 = 3, so f(0) = 3.
Rationales: A: This divides f(3) by b^2, which only steps back to x = 1, not to x = 0. Since f(3) = a·b^3, the initial value a requires dividing by b^3, and a·b = 6 is the value of f(1). B: This divides f(3) by b^4, going one step past x = 0. Since f(3) = a·b^3, dividing by b^3 gives a, while dividing by b^4 gives a/b, which is f(−1). C: This extends a straight line through the two given points, with a constant change of 36 per unit. An exponential function changes by a constant factor, not a constant amount, so its value at x = 0 is found by dividing out powers of b.

---

## Seed N-2.3-B (new) — Topic 2.3 Exponential Functions
**Skill:** combine the sign of the coefficient, the size of the base, and a vertical shift to describe monotonicity, range and y-intercept of a transformed exponential.

Consider g(x) = −3·(1/2)ˣ + 5. Which statement about g is true?

- **A. g is increasing, its range is y < 5, and its y-intercept is (0, 2)**
- B. g is decreasing, its range is y < 5, and its y-intercept is (0, 2)
- C. g is increasing, its range is y > 5, and its y-intercept is (0, 2)
- D. g is increasing, its range is y < 5, and its y-intercept is (0, −3)

Check: The asymptote is y = 5. The sign of the coefficient −3 and the base 0.5 make g increasing, and g stays below the asymptote. g(0) = −3 + 5 = 2.
Rationales: B: This decides increasing or decreasing from the base alone. Here the base is 0.5 and the coefficient is −3, so the negative coefficient reverses the usual behavior and g is increasing. C: This puts the range on the wrong side of the horizontal asymptote y = 5. Since the coefficient −3 is negative, the exponential part is negative and g stays below y = 5. D: This reads the y-intercept as (0, −3) by forgetting the vertical shift. At x = 0 the exponential part equals −3, and adding the shift 5 gives g(0) = 2.

**N-2.3-B-v1.** Consider g(x) = −2·3ˣ + 7. Which statement about g is true?

- A. g is increasing, its range is y < 7, and its y-intercept is (0, 5)
- B. g is decreasing, its range is y > 7, and its y-intercept is (0, 5)
- **C. g is decreasing, its range is y < 7, and its y-intercept is (0, 5)**
- D. g is decreasing, its range is y < 7, and its y-intercept is (0, −2)

Check: The asymptote is y = 7. The sign of the coefficient −2 and the base 3 make g decreasing, and g stays below the asymptote. g(0) = −2 + 7 = 5.
Rationales: A: This decides increasing or decreasing from the base alone. Here the base is 3 and the coefficient is −2, so the negative coefficient reverses the usual behavior and g is decreasing. B: This puts the range on the wrong side of the horizontal asymptote y = 7. Since the coefficient −2 is negative, the exponential part is negative and g stays below y = 7. D: This reads the y-intercept as (0, −2) by forgetting the vertical shift. At x = 0 the exponential part equals −2, and adding the shift 7 gives g(0) = 5.

**N-2.3-B-v2.** Consider g(x) = 4·(1/3)ˣ + 1. Which statement about g is true?

- A. g is increasing, its range is y > 1, and its y-intercept is (0, 5)
- **B. g is decreasing, its range is y > 1, and its y-intercept is (0, 5)**
- C. g is decreasing, its range is y < 1, and its y-intercept is (0, 5)
- D. g is decreasing, its range is y > 1, and its y-intercept is (0, 4)

Check: The asymptote is y = 1. The sign of the coefficient 4 and the base 1/3 make g decreasing, and g stays above the asymptote. g(0) = 4 + 1 = 5.
Rationales: A: This decides increasing or decreasing from the sign of the coefficient alone. Here the coefficient is 4 and the base is 1/3, which is less than 1, and the two together make g decreasing. C: This puts the range on the wrong side of the horizontal asymptote y = 1. Since the coefficient 4 is positive, the exponential part is positive and g stays above y = 1. D: This reads the y-intercept as (0, 4) by forgetting the vertical shift. At x = 0 the exponential part equals 4, and adding the shift 1 gives g(0) = 5.

**N-2.3-B-v3.** Consider g(x) = −5·(1/3)ˣ − 2. Which statement about g is true?

- A. g is decreasing, its range is y < −2, and its y-intercept is (0, −7)
- B. g is increasing, its range is y > −2, and its y-intercept is (0, −7)
- C. g is increasing, its range is y < −2, and its y-intercept is (0, −5)
- **D. g is increasing, its range is y < −2, and its y-intercept is (0, −7)**

Check: The asymptote is y = −2. The sign of the coefficient −5 and the base 1/3 make g increasing, and g stays below the asymptote. g(0) = −5 − 2 = −7.
Rationales: A: This decides increasing or decreasing from the base alone. Here the base is 1/3 and the coefficient is −5, so the negative coefficient reverses the usual behavior and g is increasing. B: This puts the range on the wrong side of the horizontal asymptote y = −2. Since the coefficient −5 is negative, the exponential part is negative and g stays below y = −2. C: This reads the y-intercept as (0, −5) by forgetting the vertical shift. At x = 0 the exponential part equals −5, and adding the shift −2 gives g(0) = −7.

---

## Seed N-2.4-A (new) — Topic 2.4 Exponential Function Manipulation
**Skill:** rewrite an exponential with a fractional exponent and a horizontal shift in the form a·bᵗ, tracking both the new base and the new coefficient.

For all real t, N(t) = 40·8^((t − 6)/3). Which expression is equivalent to N(t) for every real t?

- A. 40·2ᵗ
- **B. (5/8)·2ᵗ**
- C. 2560·2ᵗ
- D. (5/8)·8ᵗ

Check: 8^(1/3) = 2, so N(t) = 40·2^(t − 6) = 40·2^(−6)·2ᵗ = 5/8·2ᵗ.
Rationales: A: This takes the root correctly, 8^(1/3) = 2, but drops the shift in the exponent. Writing 2^(t − 6) = 2ᵗ·2^(−6) changes the coefficient from 40 to 5/8. C: This applies the shift in the wrong direction. Since 2^(t − 6) = 2ᵗ·2^(−6), the coefficient is multiplied by 2^(−6) = 1/64, not by 64. D: This gets the coefficient right but keeps the base 8 instead of reducing it. Because the exponent is divided by 3, the factor per unit of t is 8^(1/3) = 2, not 8.

**N-2.4-A-v1.** For all real t, N(t) = 162·9^((t − 4)/2). Which expression is equivalent to N(t) for every real t?

- A. 162·3ᵗ
- B. 13122·3ᵗ
- C. 2·9ᵗ
- **D. 2·3ᵗ**

Check: 9^(1/2) = 3, so N(t) = 162·3^(t − 4) = 162·3^(−4)·3ᵗ = 2·3ᵗ.
Rationales: A: This takes the root correctly, 9^(1/2) = 3, but drops the shift in the exponent. Writing 3^(t − 4) = 3ᵗ·3^(−4) changes the coefficient from 162 to 2. B: This applies the shift in the wrong direction. Since 3^(t − 4) = 3ᵗ·3^(−4), the coefficient is multiplied by 3^(−4) = 1/81, not by 81. C: This gets the coefficient right but keeps the base 9 instead of reducing it. Because the exponent is divided by 2, the factor per unit of t is 9^(1/2) = 3, not 9.

**N-2.4-A-v2.** For all real t, N(t) = 5·(1/8)^((t − 2)/3). Which expression is equivalent to N(t) for every real t?

- **A. 20·(1/2)ᵗ**
- B. 5·(1/2)ᵗ
- C. (5/4)·(1/2)ᵗ
- D. 20·(1/8)ᵗ

Check: 1/8^(1/3) = 1/2, so N(t) = 5·1/2^(t − 2) = 5·1/2^(−2)·1/2ᵗ = 20·1/2ᵗ.
Rationales: B: This takes the root correctly, (1/8)^(1/3) = 1/2, but drops the shift in the exponent. Writing 1/2^(t − 2) = 1/2ᵗ·1/2^(−2) changes the coefficient from 5 to 20. C: This applies the shift in the wrong direction. Since 1/2^(t − 2) = 1/2ᵗ·1/2^(−2), the coefficient is multiplied by 1/2^(−2) = 4, not by 1/4. D: This gets the coefficient right but keeps the base 1/8 instead of reducing it. Because the exponent is divided by 3, the factor per unit of t is 1/8^(1/3) = 1/2, not 1/8.

**N-2.4-A-v3.** For all real t, N(t) = 3·4^((t + 2)/2). Which expression is equivalent to N(t) for every real t?

- A. 3·2ᵗ
- B. (3/4)·2ᵗ
- **C. 12·2ᵗ**
- D. 12·4ᵗ

Check: 4^(1/2) = 2, so N(t) = 3·2^(t + 2) = 3·2^(2)·2ᵗ = 12·2ᵗ.
Rationales: A: This takes the root correctly, 4^(1/2) = 2, but drops the shift in the exponent. Writing 2^(t + 2) = 2ᵗ·2^(2) changes the coefficient from 3 to 12. B: This applies the shift in the wrong direction. Since 2^(t + 2) = 2ᵗ·2^(2), the coefficient is multiplied by 2^(2) = 4, not by 1/4. D: This gets the coefficient right but keeps the base 4 instead of reducing it. Because the exponent is divided by 2, the factor per unit of t is 4^(1/2) = 2, not 4.

---

## Seed N-2.4-B (new) — Topic 2.4 Exponential Function Manipulation
**Skill:** see that a horizontal translation of an exponential graph equals a vertical scaling, and find the scale factor as a power of the base with the correct sign.

The graph of f(x) = 6·2ˣ is translated 3 units to the right. Which single vertical transformation of the graph of f produces exactly the same graph?

- A. a vertical stretch by a factor of 8
- **B. a vertical compression by a factor of 1/8**
- C. a vertical compression by a factor of 1/2
- D. a vertical compression by a factor of 1/3

Check: f(x − 3) = 6·2^(x − 3) = [6·2^(−3)]·2ˣ = 3/4·2ˣ, so the coefficient is multiplied by 1/8.
Rationales: A: This reverses the direction of the factor. Translating 3 units to the right gives f(x − 3) = 6·2^(x − 3), which equals 6·2^(−3)·2ˣ, so the factor is 1/8, not 8. C: This uses the factor for a shift of one unit. A shift of 3 units multiplies the coefficient by 2^(−3) = 1/8, because each unit of shift contributes one factor of 2^(-1). D: This uses the size of the shift, 3, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 2^(−3), not by the number of units shifted.

**N-2.4-B-v1.** The graph of f(x) = 5·3ˣ is translated 2 units to the left. Which single vertical transformation of the graph of f produces exactly the same graph?

- A. a vertical compression by a factor of 1/9
- B. a vertical stretch by a factor of 3
- C. a vertical stretch by a factor of 2
- **D. a vertical stretch by a factor of 9**

Check: f(x + 2) = 5·3^(x + 2) = [5·3^(2)]·3ˣ = 45·3ˣ, so the coefficient is multiplied by 9.
Rationales: A: This reverses the direction of the factor. Translating 2 units to the left gives f(x + 2) = 5·3^(x + 2), which equals 5·3^(2)·3ˣ, so the factor is 9, not 1/9. B: This uses the factor for a shift of one unit. A shift of 2 units multiplies the coefficient by 3^(2) = 9, because each unit of shift contributes one factor of 3^(1). C: This uses the size of the shift, 2, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 3^(2), not by the number of units shifted.

**N-2.4-B-v2.** The graph of f(x) = 4·(1/2)ˣ is translated 3 units to the right. Which single vertical transformation of the graph of f produces exactly the same graph?

- A. a vertical compression by a factor of 1/8
- B. a vertical stretch by a factor of 2
- **C. a vertical stretch by a factor of 8**
- D. a vertical stretch by a factor of 3

Check: f(x − 3) = 4·1/2^(x − 3) = [4·1/2^(−3)]·1/2ˣ = 32·1/2ˣ, so the coefficient is multiplied by 8.
Rationales: A: This reverses the direction of the factor. Translating 3 units to the right gives f(x − 3) = 4·1/2^(x − 3), which equals 4·1/2^(−3)·1/2ˣ, so the factor is 8, not 1/8. B: This uses the factor for a shift of one unit. A shift of 3 units multiplies the coefficient by 1/2^(−3) = 8, because each unit of shift contributes one factor of 1/2^(-1). D: This uses the size of the shift, 3, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 1/2^(−3), not by the number of units shifted.

**N-2.4-B-v3.** The graph of f(x) = 12·(1/3)ˣ is translated 2 units to the left. Which single vertical transformation of the graph of f produces exactly the same graph?

- **A. a vertical compression by a factor of 1/9**
- B. a vertical stretch by a factor of 9
- C. a vertical compression by a factor of 1/3
- D. a vertical compression by a factor of 1/2

Check: f(x + 2) = 12·1/3^(x + 2) = [12·1/3^(2)]·1/3ˣ = 4/3·1/3ˣ, so the coefficient is multiplied by 1/9.
Rationales: B: This reverses the direction of the factor. Translating 2 units to the left gives f(x + 2) = 12·1/3^(x + 2), which equals 12·1/3^(2)·1/3ˣ, so the factor is 1/9, not 9. C: This uses the factor for a shift of one unit. A shift of 2 units multiplies the coefficient by 1/3^(2) = 1/9, because each unit of shift contributes one factor of 1/3^(1). D: This uses the size of the shift, 2, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 1/3^(2), not by the number of units shifted.

---

## Seed N-2.5-A (new) — Topic 2.5 Exponential Function Context and Data Modeling
**Skill:** build an exponential model from two measurements taken three units apart, backing out the initial value and the per-unit percent change instead of using the totals.

A bacteria culture is growing in a lab. The model Q(t) = a·bᵗ, with t in hours, is built from two measurements: Q(1) = 1200 and Q(4) = 2073.6. Which choice gives the initial value Q(0) and the percent change of Q per hour?

- A. Q(0) = 1200; Q increases by 20% each hour
- B. Q(0) = 1000; Q increases by 72.8% each hour
- **C. Q(0) = 1000; Q increases by 20% each hour**
- D. Q(0) = 908.8; Q increases by 24.3% each hour

Check: 2073.6/1200 = b³ = 1.728, so b = 1.2, a 20% increase per hour. Then Q(0) = 1200/1.2 = 1000.
Rationales: A: This reports the first measurement, Q(1) = 1200, as the initial value. That measurement was taken at t = 1, so going back 1 hour with the factor 1.2 gives Q(0) = 1000. B: This reports the percent change across all three hours between the measurements, 72.8%, as the change per hour. The ratio 2073.6/1200 = 1.728 equals b³, so the per-hour factor is b = 1.2. D: This treats the two measurements as a straight line, with a constant change of 291.2 per hour. The model is exponential, so it is the percent change, not the amount of change, that stays constant from hour to hour.

**N-2.5-A-v1.** The area covered by algae in a pond, in square meters, is growing. The model Q(t) = a·bᵗ, with t in days, is built from two measurements: Q(2) = 180 and Q(5) = 607.5. Which choice gives the initial value Q(0) and the percent change of Q per day?

- **A. Q(0) = 80; Q increases by 50% each day**
- B. Q(0) = 180; Q increases by 50% each day
- C. Q(0) = 80; Q increases by 237.5% each day
- D. Q(0) = 37.5; Q increases by 79.2% each day

Check: 607.5/180 = b³ = 3.375, so b = 1.5, a 50% increase per day. Then Q(0) = 180/2.25 = 80.
Rationales: B: This reports the first measurement, Q(2) = 180, as the initial value. That measurement was taken at t = 2, so going back 2 days with the factor 1.5 gives Q(0) = 80. C: This reports the percent change across all three days between the measurements, 237.5%, as the change per day. The ratio 607.5/180 = 3.375 equals b³, so the per-day factor is b = 1.5. D: This treats the two measurements as a straight line, with a constant change of 142.5 per day. The model is exponential, so it is the percent change, not the amount of change, that stays constant from day to day.

**N-2.5-A-v2.** The amount of a medicine in a patient's blood, in milligrams, is decreasing. The model Q(t) = a·bᵗ, with t in hours, is built from two measurements: Q(1) = 200 and Q(4) = 102.4. Which choice gives the initial value Q(0) and the percent change of Q per hour?

- A. Q(0) = 200; Q decreases by 20% each hour
- **B. Q(0) = 250; Q decreases by 20% each hour**
- C. Q(0) = 250; Q decreases by 48.8% each hour
- D. Q(0) = 232.5; Q decreases by 16.3% each hour

Check: 102.4/200 = b³ = 0.512, so b = 0.8, a 20% decrease per hour. Then Q(0) = 200/0.8 = 250.
Rationales: A: This reports the first measurement, Q(1) = 200, as the initial value. That measurement was taken at t = 1, so going back 1 hour with the factor 0.8 gives Q(0) = 250. C: This reports the percent change across all three hours between the measurements, 48.8%, as the change per hour. The ratio 102.4/200 = 0.512 equals b³, so the per-hour factor is b = 0.8. D: This treats the two measurements as a straight line, with a constant change of −32.5 per hour. The model is exponential, so it is the percent change, not the amount of change, that stays constant from hour to hour.

**N-2.5-A-v3.** The resale value of a machine, in dollars, is decreasing. The model Q(t) = a·bᵗ, with t in years, is built from two measurements: Q(2) = 810 and Q(5) = 590.49. Which choice gives the initial value Q(0) and the percent change of Q per year?

- A. Q(0) = 810; Q decreases by 10% each year
- B. Q(0) = 1000; Q decreases by 27.1% each year
- C. Q(0) = 883.2; Q decreases by 9% each year
- **D. Q(0) = 1000; Q decreases by 10% each year**

Check: 590.49/810 = b³ = 0.729, so b = 0.9, a 10% decrease per year. Then Q(0) = 810/0.81 = 1000.
Rationales: A: This reports the first measurement, Q(2) = 810, as the initial value. That measurement was taken at t = 2, so going back 2 years with the factor 0.9 gives Q(0) = 1000. B: This reports the percent change across all three years between the measurements, 27.1%, as the change per year. The ratio 590.49/810 = 0.729 equals b³, so the per-year factor is b = 0.9. C: This treats the two measurements as a straight line, with a constant change of −73.2 per year. The model is exponential, so it is the percent change, not the amount of change, that stays constant from year to year.

---

## Seed N-2.5-B (new) — Topic 2.5 Exponential Function Context and Data Modeling
**Skill:** convert a yearly growth or decay factor to the factor and percent change for a shorter period by taking a root, not by dividing the percent or the factor.

The view count of a viral video is modeled by an exponential function of time t in years. Each full year, the view count is multiplied by 9. By what percent does the view count change over any 6-month period?

- A. The view count increases by 400%
- B. The view count increases by 350%
- **C. The view count increases by 200%**
- D. The view count increases by 300%

Check: Let c be the factor per 6 months. Then c^2 = 9, so c = 3. The view count is multiplied by 3 every 6 months, a change of (3 − 1)·100% = 200%.
Rationales: A: This divides the full-year percent change, 800%, by 2. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period's change is applied to the already-changed amount. B: This divides the yearly factor 9 by 2 to get a factor of 9/2 per 6 months. Factors combine by multiplication, so 2 equal periods must multiply to 9, which requires the factor to be a square root of 9. D: This reports the 6-month factor 3 as if it were the percent change. A factor of 3 means the amount is multiplied by 3, which is a change of 200%, not 300%.

**N-2.5-B-v1.** The population of a bacteria culture is modeled by an exponential function of time t in years. Each full year, the population is multiplied by 16. By what percent does the population change over any 3-month period?

- A. The population increases by 375%
- B. The population increases by 300%
- C. The population increases by 200%
- **D. The population increases by 100%**

Check: Let c be the factor per 3 months. Then c^4 = 16, so c = 2. The population is multiplied by 2 every 3 months, a change of (2 − 1)·100% = 100%.
Rationales: A: This divides the full-year percent change, 1500%, by 4. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period's change is applied to the already-changed amount. B: This divides the yearly factor 16 by 4 to get a factor of 4 per 3 months. Factors combine by multiplication, so 4 equal periods must multiply to 16, which requires the factor to be a 4th root of 16. C: This reports the 3-month factor 2 as if it were the percent change. A factor of 2 means the amount is multiplied by 2, which is a change of 100%, not 200%.

**N-2.5-B-v2.** The mass of a radioactive sample is modeled by an exponential function of time t in years. Each full year, the mass is multiplied by 1/25. By what percent does the mass change over any 6-month period?

- **A. The mass decreases by 80%**
- B. The mass decreases by 48%
- C. The mass decreases by 98%
- D. The mass decreases by 20%

Check: Let c be the factor per 6 months. Then c^2 = 1/25, so c = 1/5. The mass is multiplied by 1/5 every 6 months, a change of (1/5 − 1)·100% = −80%.
Rationales: B: This divides the full-year percent change, 96%, by 2. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period's change is applied to the already-changed amount. C: This divides the yearly factor 1/25 by 2 to get a factor of 1/50 per 6 months. Factors combine by multiplication, so 2 equal periods must multiply to 1/25, which requires the factor to be a square root of 1/25. D: This reports the 6-month factor 1/5 as if it were the percent change. A factor of 1/5 means the amount is multiplied by 1/5, which is a change of 80%, not 20%.

**N-2.5-B-v3.** The number of seedlings of a tree farm is modeled by an exponential function of time t in years. Each full year, the number of seedlings is multiplied by 9/4. By what percent does the number of seedlings change over any 6-month period?

- A. The number of seedlings increases by 62.5%
- **B. The number of seedlings increases by 50%**
- C. The number of seedlings increases by 12.5%
- D. The number of seedlings increases by 150%

Check: Let c be the factor per 6 months. Then c^2 = 9/4, so c = 3/2. The number of seedlings is multiplied by 3/2 every 6 months, a change of (3/2 − 1)·100% = 50%.
Rationales: A: This divides the full-year percent change, 125%, by 2. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period's change is applied to the already-changed amount. C: This divides the yearly factor 9/4 by 2 to get a factor of 9/8 per 6 months. Factors combine by multiplication, so 2 equal periods must multiply to 9/4, which requires the factor to be a square root of 9/4. D: This reports the 6-month factor 3/2 as if it were the percent change. A factor of 3/2 means the amount is multiplied by 3/2, which is a change of 50%, not 150%.

---

## Seed N-2.6-A (new) — Topic 2.6 Competing Function Model Validation
**Skill:** judge a regression model by residuals on the data range, then recognize that a prediction far outside that range can violate the context even though the residuals are random.

A town has 40 thousand residents. Over the 9 months after a local app launched, its number of active users U (in thousands) was recorded each month, and the exponential regression is U(t) = 2.1·1.38ᵗ, where t is months since launch. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 24. Which conclusion is best supported?

- A. The random residuals show the exponential model fits at every value of t, so the prediction U(24) ≈ 4,779 can be trusted.
- B. Because U(24) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 9, despite its random residuals.
- C. Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.
- **D. The model fits the data for 0 ≤ t ≤ 9, but the prediction U(24) ≈ 4,779 thousand, far above the town's 40 thousand residents, so it should not be trusted at t = 24.**

Check: U(24) = 2.1·1.38^24 ≈ 4,779, and this is far above the town's 40 thousand residents. The data cover only 0 ≤ t ≤ 9, so the random residuals support the model only on that range.
Rationales: A: Random residuals support the model only over the range of the data, 0 ≤ t ≤ 9. They say nothing about t = 24, which is far outside that range, and the predicted value is far above the town's 40 thousand residents. B: A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 9 the random residuals show a good fit; the limit applies to extrapolation beyond that range. C: Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.

**N-2.6-A-v1.** A lab dish can hold at most 5 million bacteria. Over the first 6 hours, the count B (in millions) was recorded each hour, and the exponential regression is B(t) = 0.08·1.9ᵗ, where t is hours. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 20. Which conclusion is best supported?

- **A. The model fits the data for 0 ≤ t ≤ 6, but the prediction B(20) ≈ 30,072 million, far above the dish's capacity of 5 million, so it should not be trusted at t = 20.**
- B. The random residuals show the exponential model fits at every value of t, so the prediction B(20) ≈ 30,072 can be trusted.
- C. Because B(20) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 6, despite its random residuals.
- D. Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.

Check: B(20) = 0.08·1.9^20 ≈ 30,072, and this is far above the dish's capacity of 5 million. The data cover only 0 ≤ t ≤ 6, so the random residuals support the model only on that range.
Rationales: B: Random residuals support the model only over the range of the data, 0 ≤ t ≤ 6. They say nothing about t = 20, which is far outside that range, and the predicted value is far above the dish's capacity of 5 million. C: A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 6 the random residuals show a good fit; the limit applies to extrapolation beyond that range. D: Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.

**N-2.6-A-v2.** A cup of coffee cools in a room kept at 21°C. Over the first 10 minutes, its temperature T (in °C) was recorded each minute, and the exponential regression is T(t) = 80·0.93ᵗ, where t is minutes. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 40. Which conclusion is best supported?

- A. The random residuals show the exponential model fits at every value of t, so the prediction T(40) ≈ 4.4 can be trusted.
- B. Because T(40) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 10, despite its random residuals.
- **C. The model fits the data for 0 ≤ t ≤ 10, but the prediction T(40) ≈ 4.4°C, below the room temperature of 21°C, which the coffee cannot reach, so it should not be trusted at t = 40.**
- D. Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.

Check: T(40) = 80·0.93^40 ≈ 4.4, and this is below the room temperature of 21°C, which the coffee cannot reach. The data cover only 0 ≤ t ≤ 10, so the random residuals support the model only on that range.
Rationales: A: Random residuals support the model only over the range of the data, 0 ≤ t ≤ 10. They say nothing about t = 40, which is far outside that range, and the predicted value is below the room temperature of 21°C, which the coffee cannot reach. B: A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 10 the random residuals show a good fit; the limit applies to extrapolation beyond that range. D: Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.

**N-2.6-A-v3.** The tallest tree species in a region reaches about 115 m. For a young tree of that region, its height h (in meters) was recorded each year for 8 years, and the exponential regression is h(t) = 0.5·1.25ᵗ, where t is years. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 40. Which conclusion is best supported?

- A. The random residuals show the exponential model fits at every value of t, so the prediction h(40) ≈ 3,762 can be trusted.
- **B. The model fits the data for 0 ≤ t ≤ 8, but the prediction h(40) ≈ 3,762 m, far above the 115 m that trees in the region can reach, so it should not be trusted at t = 40.**
- C. Because h(40) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 8, despite its random residuals.
- D. Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.

Check: h(40) = 0.5·1.25^40 ≈ 3,762, and this is far above the 115 m that trees in the region can reach. The data cover only 0 ≤ t ≤ 8, so the random residuals support the model only on that range.
Rationales: A: Random residuals support the model only over the range of the data, 0 ≤ t ≤ 8. They say nothing about t = 40, which is far outside that range, and the predicted value is far above the 115 m that trees in the region can reach. C: A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 8 the random residuals show a good fit; the limit applies to extrapolation beyond that range. D: Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.

---

## Seed N-2.6-B (new) — Topic 2.6 Competing Function Model Validation
**Skill:** choose between linear, quadratic and exponential models from a table by checking first differences, second differences and ratios, rejecting 'differences are not constant, so exponential'.

The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 1, 6, 15, 28, 45, 66, respectively. Which model is best supported by these values?

- A. An exponential model, because the first differences are not constant
- B. A linear model, because the outputs always increase
- C. An exponential model with growth factor 6, because f(1)/f(0) = 6
- **D. A quadratic model, because the second differences are constant at 4**

Check: First differences: 5, 9, 13, 17, 21. Second differences: 4, 4, 4, 4, all equal to 4. The ratios of consecutive outputs (6.00, 2.50, 1.87, 1.61, 1.47) are not constant, so the data match a quadratic, not an exponential or linear model.
Rationales: A: The first differences (5, 9, 13, 17, 21) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (6.00, 2.50, 1.87, 1.61, 1.47) are not constant. B: This does not show the first differences are constant, which is what a linear model needs. The first differences are 5, 9, 13, 17, 21, so the rate of change is different from one step to the next. C: This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 5/2, which is different from 6.

**N-2.6-B-v1.** The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 5, 23, 37, 47, 53, 55, respectively. Which model is best supported by these values?

- **A. A quadratic model, because the second differences are constant at −4**
- B. An exponential model, because the first differences are not constant
- C. A linear model, because the outputs always increase
- D. An exponential model with growth factor 23/5, because f(1)/f(0) = 23/5

Check: First differences: 18, 14, 10, 6, 2. Second differences: −4, −4, −4, −4, all equal to −4. The ratios of consecutive outputs (4.60, 1.61, 1.27, 1.13, 1.04) are not constant, so the data match a quadratic, not an exponential or linear model.
Rationales: B: The first differences (18, 14, 10, 6, 2) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (4.60, 1.61, 1.27, 1.13, 1.04) are not constant. C: This does not show the first differences are constant, which is what a linear model needs. The first differences are 18, 14, 10, 6, 2, so the rate of change is different from one step to the next. D: This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 37/23, which is different from 23/5.

**N-2.6-B-v2.** The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 13, 4, 1, 4, 13, 28, respectively. Which model is best supported by these values?

- A. An exponential model, because the first differences are not constant
- **B. A quadratic model, because the second differences are constant at 6**
- C. A linear model, because the average rate of change from x = 0 to x = 5, which is 3, is positive
- D. An exponential model with growth factor 4/13, because f(1)/f(0) = 4/13

Check: First differences: −9, −3, 3, 9, 15. Second differences: 6, 6, 6, 6, all equal to 6. The ratios of consecutive outputs (0.31, 0.25, 4.00, 3.25, 2.15) are not constant, so the data match a quadratic, not an exponential or linear model.
Rationales: A: The first differences (−9, −3, 3, 9, 15) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (0.31, 0.25, 4.00, 3.25, 2.15) are not constant. C: This does not show the first differences are constant, which is what a linear model needs. The first differences are −9, −3, 3, 9, 15, so the rate of change is different from one step to the next. D: This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 1/4, which is different from 4/13.

**N-2.6-B-v3.** The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 30, 29, 26, 21, 14, 5, respectively. Which model is best supported by these values?

- A. An exponential model, because the first differences are not constant
- B. A linear model, because the outputs always decrease
- **C. A quadratic model, because the second differences are constant at −2**
- D. An exponential model with growth factor 29/30, because f(1)/f(0) = 29/30

Check: First differences: −1, −3, −5, −7, −9. Second differences: −2, −2, −2, −2, all equal to −2. The ratios of consecutive outputs (0.97, 0.90, 0.81, 0.67, 0.36) are not constant, so the data match a quadratic, not an exponential or linear model.
Rationales: A: The first differences (−1, −3, −5, −7, −9) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (0.97, 0.90, 0.81, 0.67, 0.36) are not constant. B: This does not show the first differences are constant, which is what a linear model needs. The first differences are −1, −3, −5, −7, −9, so the rate of change is different from one step to the next. D: This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 26/29, which is different from 29/30.

---

## Seed N-2.7-A (new) — Topic 2.7 Composition of Functions
**Skill:** find the domain of a composition by requiring the inner output to lie in the outer function's domain, rather than using either function's domain separately.

Let f(x) = √(x − 3) and g(x) = x² − 7. What is the domain of the composition f(g(x))?

- A. x ≥ 3
- **B. x ≤ −√10 or x ≥ √10**
- C. x ≥ √10
- D. x ≤ −√7 or x ≥ √7

Check: f(g(x)) = √(x² − 7 − 3) = √(x² − 10), which requires x² ≥ 10, so x ≤ −√10 or x ≥ √10. For x = −4, g(−4) = 9 and f(9) = √6 is defined.
Rationales: A: This is the domain of f alone. The inputs to f are the outputs g(x) = x² − 7, so the condition is x² − 7 ≥ 3, not x ≥ 3. For example x = −4 gives g(−4) = 9, and f(9) = √6 is defined, but −4 is not in this set. C: This solves x² − 7 ≥ 3 but keeps only the positive solutions. The inequality x² ≥ 10 also holds for x ≤ −√10, and x = −4 is a valid input since g(−4) = 9 and f(9) = √6 is defined. D: This requires only g(x) ≥ 0, ignoring the −3 inside f. The condition is g(x) − 3 ≥ 0. For example x = 3 gives g(3) = 2, and f(2) = √(−1) is undefined, but 3 is in this set.

**N-2.7-A-v1.** Let f(x) = 1/(x − 5) and g(x) = x² + 1. What is the domain of the composition f(g(x))?

- A. All real x except x = 5
- B. All real x except x = 2
- C. All real x except x = √5 and x = −√5
- **D. All real x except x = 2 and x = −2**

Check: f(g(x)) = 1/(x² + 1 − 5) = 1/(x² − 4), which is undefined exactly when x² = 4, so x = 2 or x = −2. All other real x work.
Rationales: A: This is the excluded value for f alone. The input to f is g(x) = x² + 1, so the excluded x-values are those where x² + 1 = 5. For example x = 2 gives g(2) = 5, and f(5) is undefined, but 2 is allowed by this set. B: This finds x² + 1 = 5 but keeps only the positive solution. The equation x² = 4 also has x = −2, and g(−2) = 5 makes f(g(−2)) undefined. C: This solves x² = 5, forgetting the +1 in g. The excluded values are those where x² + 1 = 5, so x² = 4, and g(√5) = 6 gives f(6) = 1, which is defined.

**N-2.7-A-v2.** Let f(x) = √(6 − x) and g(x) = x² − 10. What is the domain of the composition f(g(x))?

- **A. −4 ≤ x ≤ 4**
- B. x ≤ 6
- C. x ≤ −4 or x ≥ 4
- D. −√6 ≤ x ≤ √6

Check: f(g(x)) = √(6 − (x² − 10)) = √(16 − x²), which requires x² ≤ 16, so −4 ≤ x ≤ 4. For x = 3, g(3) = −1 and f(−1) = √7 is defined.
Rationales: B: This is the domain of f alone. The input to f is g(x) = x² − 10, so the condition is x² − 10 ≤ 6. For example x = 5 gives g(5) = 15, and f(15) = √(−9) is undefined, but 5 is in this set. C: This reverses the inequality. The condition 6 − (x² − 10) ≥ 0 gives x² ≤ 16, so x lies between −4 and 4. For example x = 0 gives g(0) = −10 and f(−10) = √16 = 4, which is defined. D: This solves x² ≤ 6, forgetting the −10 inside g. The condition is 6 − (x² − 10) ≥ 0, so x² ≤ 16. For example x = 3 gives g(3) = −1 and f(−1) = √7, which is defined, but 3 is outside this set.

**N-2.7-A-v3.** Let f(x) = √(x + 4) and g(x) = x² − 13. What is the domain of the composition f(g(x))?

- A. x ≥ −4
- B. −3 ≤ x ≤ 3
- **C. x ≤ −3 or x ≥ 3**
- D. x ≤ −√13 or x ≥ √13

Check: f(g(x)) = √(x² − 13 + 4) = √(x² − 9), which requires x² ≥ 9, so x ≤ −3 or x ≥ 3. For x = 3, g(3) = −4 and f(−4) = 0 is defined.
Rationales: A: This is the domain of f alone. The input to f is g(x) = x² − 13, so the condition is x² − 13 ≥ −4. For example x = 0 gives g(0) = −13, and f(−13) = √(−9) is undefined, but 0 is in this set. B: This reverses the inequality. The condition x² − 13 + 4 ≥ 0 gives x² ≥ 9, which holds for x ≤ −3 or x ≥ 3. For example x = 4 gives g(4) = 3 and f(3) = √7, which is defined, but 4 is outside this set. D: This requires only g(x) ≥ 0, ignoring the +4 inside f. The condition is g(x) + 4 ≥ 0. For example x = 3 gives g(3) = −4 and f(−4) = √0 = 0, which is defined, but 3 is outside this set.

---

## Seed N-2.7-B (new) — Topic 2.7 Composition of Functions
**Skill:** solve an equation that sets two different compositions of the same functions equal, expanding the square of a linear expression correctly.

Let f(x) = 2x + 8 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?

- A. There is no real value of x
- B. x = 2 and x = 14
- **C. x = −14 and x = −2**
- D. x = −16 and x = 0

Check: f(g(x)) = 2x² + 8 and g(f(x)) = (2x + 8)² = 4x² + 32x + 64. Setting them equal: 2x² + 32x + 56 = 0, which factors to give x = −14 or x = −2.
Rationales: A: This drops the middle term when squaring, writing (f(x))² as 4x² + 64. Then f(g(x)) = g(f(x)) reduces to 2x² + 8 = 4x² + 64, which has no real solution, but the correct expansion is (2x + 8)² = 4x² + 32x + 64. B: This has the right size of solutions with the wrong signs. The equation is 2x² + 32x + 56 = 0, and substituting x = 2 gives 128 instead of 0, so these are not solutions. D: This squares the linear expression as 4x² + 32x + 8, using 8 instead of 8² = 64 for the last term. Then the equation is 2x² + 32x = 0, whose solutions are x = 0 and x = −16.

**N-2.7-B-v1.** Let f(x) = 3x + 6 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?

- **A. x = −5 and x = −1**
- B. There is no real value of x
- C. x = 1 and x = 5
- D. x = −6 and x = 0

Check: f(g(x)) = 3x² + 6 and g(f(x)) = (3x + 6)² = 9x² + 36x + 36. Setting them equal: 6x² + 36x + 30 = 0, which factors to give x = −5 or x = −1.
Rationales: B: This drops the middle term when squaring, writing (f(x))² as 9x² + 36. Then f(g(x)) = g(f(x)) reduces to 3x² + 6 = 9x² + 36, which has no real solution, but the correct expansion is (3x + 6)² = 9x² + 36x + 36. C: This has the right size of solutions with the wrong signs. The equation is 6x² + 36x + 30 = 0, and substituting x = 1 gives 72 instead of 0, so these are not solutions. D: This squares the linear expression as 9x² + 36x + 6, using 6 instead of 6² = 36 for the last term. Then the equation is 6x² + 36x = 0, whose solutions are x = 0 and x = −6.

**N-2.7-B-v2.** Let f(x) = 5x + 16 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?

- A. There is no real value of x
- **B. x = −6 and x = −2**
- C. x = 2 and x = 6
- D. x = −8 and x = 0

Check: f(g(x)) = 5x² + 16 and g(f(x)) = (5x + 16)² = 25x² + 160x + 256. Setting them equal: 20x² + 160x + 240 = 0, which factors to give x = −6 or x = −2.
Rationales: A: This drops the middle term when squaring, writing (f(x))² as 25x² + 256. Then f(g(x)) = g(f(x)) reduces to 5x² + 16 = 25x² + 256, which has no real solution, but the correct expansion is (5x + 16)² = 25x² + 160x + 256. C: This has the right size of solutions with the wrong signs. The equation is 20x² + 160x + 240 = 0, and substituting x = 2 gives 640 instead of 0, so these are not solutions. D: This squares the linear expression as 25x² + 160x + 16, using 16 instead of 16² = 256 for the last term. Then the equation is 20x² + 160x = 0, whose solutions are x = 0 and x = −8.

**N-2.7-B-v3.** Let f(x) = 6x + 10 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?

- A. There is no real value of x
- B. x = 1 and x = 3
- C. x = −4 and x = 0
- **D. x = −3 and x = −1**

Check: f(g(x)) = 6x² + 10 and g(f(x)) = (6x + 10)² = 36x² + 120x + 100. Setting them equal: 30x² + 120x + 90 = 0, which factors to give x = −3 or x = −1.
Rationales: A: This drops the middle term when squaring, writing (f(x))² as 36x² + 100. Then f(g(x)) = g(f(x)) reduces to 6x² + 10 = 36x² + 100, which has no real solution, but the correct expansion is (6x + 10)² = 36x² + 120x + 100. B: This has the right size of solutions with the wrong signs. The equation is 30x² + 120x + 90 = 0, and substituting x = 1 gives 240 instead of 0, so these are not solutions. C: This squares the linear expression as 36x² + 120x + 10, using 10 instead of 10² = 100 for the last term. Then the equation is 30x² + 120x = 0, whose solutions are x = 0 and x = −4.

---

## Seed N-2.8-A (new) — Topic 2.8 Inverse Functions
**Skill:** find the inverse of a rational function by swapping and solving, and reject the reciprocal and sign-slip answers by composing.

Let f(x) = (3x + 2)/(x − 4) for x ≠ 4. Which expression is f⁻¹(x)?

- A. (x − 4)/(3x + 2)
- B. (4x − 2)/(x − 3)
- **C. (4x + 2)/(x − 3)**
- D. (−4x − 2)/(x − 3)

Check: Swap x and y: x = (3y + 2)/(y − 4). Multiplying out gives xy − 4x = 3y + 2, so y(x − 3) = 4x + 2, and y = (4x + 2)/(x − 3). Check: f(f⁻¹(7/3)) = 7/3.
Rationales: A: This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives −39/113. B: This makes a sign error on the constant when collecting terms after swapping x and y: from xy − 4x = 3y + 2 it takes y(x − 3) = 4x − 2 instead of 4x + 2. Applying f to this expression at x = 7/3 gives 31/15, not 7/3. D: This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 3) = −4x − 2 instead of 4x + 2. Applying f to this expression at x = 7/3 gives 53/13, not 7/3.

**N-2.8-A-v1.** Let f(x) = (2x − 1)/(x + 3) for x ≠ −3. Which expression is f⁻¹(x)?

- A. (x + 3)/(2x − 1)
- **B. (−3x − 1)/(x − 2)**
- C. (−3x + 1)/(x − 2)
- D. (3x + 1)/(x − 2)

Check: Swap x and y: x = (2y − 1)/(y + 3). Multiplying out gives xy + 3x = 2y − 1, so y(x − 2) = −3x − 1, and y = (−3x − 1)/(x − 2). Check: f(f⁻¹(7/3)) = 7/3.
Rationales: A: This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives 3/7. C: This makes a sign error on the constant when collecting terms after swapping x and y: from xy + 3x = 2y − 1 it takes y(x − 2) = −3x + 1 instead of −3x − 1. Applying f to this expression at x = 7/3 gives 37/15, not 7/3. D: This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 2) = 3x + 1 instead of −3x − 1. Applying f to this expression at x = 7/3 gives 47/27, not 7/3.

**N-2.8-A-v2.** Let f(x) = (5x − 3)/(x − 1) for x ≠ 1. Which expression is f⁻¹(x)?

- A. (x − 1)/(5x − 3)
- B. (x + 3)/(x − 5)
- C. (−x + 3)/(x − 5)
- **D. (x − 3)/(x − 5)**

Check: Swap x and y: x = (5y − 3)/(y − 1). Multiplying out gives xy − x = 5y − 3, so y(x − 5) = x − 3, and y = (x − 3)/(x − 5). Check: f(f⁻¹(7/3)) = 7/3.
Rationales: A: This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives 29/11. B: This makes a sign error on the constant when collecting terms after swapping x and y: from xy − x = 5y − 3 it takes y(x − 5) = x + 3 instead of x − 3. Applying f to this expression at x = 7/3 gives 13/3, not 7/3. C: This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 5) = −x + 3 instead of x − 3. Applying f to this expression at x = 7/3 gives 17/5, not 7/3.

**N-2.8-A-v3.** Let f(x) = (4x + 1)/(x + 2) for x ≠ −2. Which expression is f⁻¹(x)?

- **A. (−2x + 1)/(x − 4)**
- B. (x + 2)/(4x + 1)
- C. (−2x − 1)/(x − 4)
- D. (2x − 1)/(x − 4)

Check: Swap x and y: x = (4y + 1)/(y + 2). Multiplying out gives xy + 2x = 4y + 1, so y(x − 4) = −2x + 1, and y = (−2x + 1)/(x − 4). Check: f(f⁻¹(7/3)) = 7/3.
Rationales: B: This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives 83/75. C: This makes a sign error on the constant when collecting terms after swapping x and y: from xy + 2x = 4y + 1 it takes y(x − 4) = −2x − 1 instead of −2x + 1. Applying f to this expression at x = 7/3 gives 73/27, not 7/3. D: This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 4) = 2x − 1 instead of −2x + 1. Applying f to this expression at x = 7/3 gives 39, not 7/3.

---

## Seed N-2.8-B (new) — Topic 2.8 Inverse Functions
**Skill:** evaluate an expression combining an inverse with function values from a table, applying the inverse to the combined output and not distributing it.

The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 5, f(2) = 8, f(3) = 2, f(4) = 7, f(5) = 3. What is the value of f⁻¹(f(3) + f(5))?

- A. 3
- B. 8
- C. 5
- **D. 1**

Check: f(3) + f(5) = 2 + 3 = 5. Since f(1) = 5, f⁻¹(5) = 1.
Rationales: A: This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 5, which is 1, not the output f(5) = 3. B: This distributes f⁻¹ over the sum, computing f⁻¹(f(3)) + f⁻¹(f(5)) = 3 + 5. Inverse functions do not distribute over addition: the quantity 2 + 3 = 5 must be computed first, and then f⁻¹ applied to it. C: This stops after combining the outputs, f(3) + f(5) = 2 + 3 = 5. The question asks for f⁻¹ of that value, the input x with f(x) = 5, and that input is 1.

**N-2.8-B-v1.** The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 3, f(2) = 2, f(3) = 6, f(4) = 5, f(5) = 8. What is the value of f⁻¹(f(2) + f(1))?

- A. 8
- B. 3
- **C. 4**
- D. 5

Check: f(2) + f(1) = 2 + 3 = 5. Since f(4) = 5, f⁻¹(5) = 4.
Rationales: A: This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 5, which is 4, not the output f(5) = 8. B: This distributes f⁻¹ over the sum, computing f⁻¹(f(2)) + f⁻¹(f(1)) = 2 + 1. Inverse functions do not distribute over addition: the quantity 2 + 3 = 5 must be computed first, and then f⁻¹ applied to it. D: This stops after combining the outputs, f(2) + f(1) = 2 + 3 = 5. The question asks for f⁻¹ of that value, the input x with f(x) = 5, and that input is 4.

**N-2.8-B-v2.** The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 2, f(2) = 6, f(3) = 4, f(4) = 9, f(5) = 3. What is the value of f⁻¹(f(4) − f(2))?

- A. 4
- **B. 5**
- C. 2
- D. 3

Check: f(4) − f(2) = 9 − 6 = 3. Since f(5) = 3, f⁻¹(3) = 5.
Rationales: A: This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 3, which is 5, not the output f(3) = 4. C: This distributes f⁻¹ over the difference, computing f⁻¹(f(4)) − f⁻¹(f(2)) = 4 − 2. Inverse functions do not distribute over subtraction: the quantity 9 − 6 = 3 must be computed first, and then f⁻¹ applied to it. D: This stops after combining the outputs, f(4) − f(2) = 9 − 6 = 3. The question asks for f⁻¹ of that value, the input x with f(x) = 3, and that input is 5.

**N-2.8-B-v3.** The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 8, f(2) = 4, f(3) = 5, f(4) = 9, f(5) = 6. What is the value of f⁻¹(f(4) − f(3))?

- **A. 2**
- B. 9
- C. 1
- D. 4

Check: f(4) − f(3) = 9 − 5 = 4. Since f(2) = 4, f⁻¹(4) = 2.
Rationales: B: This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 4, which is 2, not the output f(4) = 9. C: This distributes f⁻¹ over the difference, computing f⁻¹(f(4)) − f⁻¹(f(3)) = 4 − 3. Inverse functions do not distribute over subtraction: the quantity 9 − 5 = 4 must be computed first, and then f⁻¹ applied to it. D: This stops after combining the outputs, f(4) − f(3) = 9 − 5 = 4. The question asks for f⁻¹ of that value, the input x with f(x) = 4, and that input is 2.
