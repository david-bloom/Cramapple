# AP Precalculus Unit 2 topics 2.9 to 2.15: harder seed drafts (second author)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key and each distractor was recomputed in Python (no distractor equals the key).
Target level: R3 reasoning (error analysis, multi-step solving, modeling, interpretation). Two seeds per topic testing different skills, each with three variants. Topics 2.1 to 2.8 are covered by another author.

| Seed | Topic | Replaces |
|---|---|---|
| N-2.9-A | 2.9 Logarithmic Expressions | new |
| N-2.9-B | 2.9 Logarithmic Expressions | new |
| N-2.10-A | 2.10 Inverses of Exponential Functions | new |
| N-2.10-B | 2.10 Inverses of Exponential Functions | new |
| N-2.11-A | 2.11 Logarithmic Functions | new |
| N-2.11-B | 2.11 Logarithmic Functions | new |
| N-2.12-A | 2.12 Logarithmic Function Manipulation | new |
| N-2.12-B | 2.12 Logarithmic Function Manipulation | new |
| N-2.13-A | 2.13 Exponential and Logarithmic Equations and Inequalities | new |
| N-2.13-B | 2.13 Exponential and Logarithmic Equations and Inequalities | new |
| N-2.14-A | 2.14 Logarithmic Function Context and Data Modeling | new |
| N-2.14-B | 2.14 Logarithmic Function Context and Data Modeling | new |
| N-2.15-A | 2.15 Semi-log Plots | new |
| N-2.15-B | 2.15 Semi-log Plots | new |

---

## Seed N-2.9-A (new) — Topic 2.9 Logarithmic Expressions
**Skill:** order logarithms with different bases and arguments by estimating each value against benchmarks, rather than by the size of the base or the argument alone.

Which list orders the numbers log₄(8), log₂(5), log₃(30) from least to greatest?

- **A. log₄(8) < log₂(5) < log₃(30)**
- B. log₂(5) < log₄(8) < log₃(30)
- C. log₂(5) < log₃(30) < log₄(8)
- D. log₃(30) < log₂(5) < log₄(8)

Check: Compare each to benchmarks or compute it: log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10. Least to greatest is log₄(8) < log₂(5) < log₃(30).
Rationales: B: This sorts by the size of the number inside each logarithm (5, 8, 30), but the base matters just as much. The actual values are log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10. C: This sorts by the size of the base (2, 3, 4), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10. D: This is the order from greatest to least. Estimating each value gives log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10, so the list must run the other way.

**N-2.9-A-v1.** Which list orders the numbers log₃(6), log₅(25), log₂(12) from least to greatest?

- A. log₃(6) < log₂(12) < log₅(25)
- B. log₂(12) < log₃(6) < log₅(25)
- C. log₂(12) < log₅(25) < log₃(6)
- **D. log₃(6) < log₅(25) < log₂(12)**

Check: Compare each to benchmarks or compute it: log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58. Least to greatest is log₃(6) < log₅(25) < log₂(12).
Rationales: A: This sorts by the size of the number inside each logarithm (6, 12, 25), but the base matters just as much. The actual values are log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58. B: This sorts by the size of the base (2, 3, 5), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58. C: This is the order from greatest to least. Estimating each value gives log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58, so the list must run the other way.

**N-2.9-A-v2.** Which list orders the numbers log₃(5), log₂(9), log₅(40) from least to greatest?

- A. log₃(5) < log₂(9) < log₅(40)
- B. log₂(9) < log₃(5) < log₅(40)
- **C. log₃(5) < log₅(40) < log₂(9)**
- D. log₂(9) < log₅(40) < log₃(5)

Check: Compare each to benchmarks or compute it: log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17. Least to greatest is log₃(5) < log₅(40) < log₂(9).
Rationales: A: This sorts by the size of the number inside each logarithm (5, 9, 40), but the base matters just as much. The actual values are log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17. B: This sorts by the size of the base (2, 3, 5), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17. D: This is the order from greatest to least. Estimating each value gives log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17, so the list must run the other way.

**N-2.9-A-v3.** Which list orders the numbers log₄(3), log₆(36), log₂(6) from least to greatest?

- A. log₄(3) < log₂(6) < log₆(36)
- **B. log₄(3) < log₆(36) < log₂(6)**
- C. log₂(6) < log₄(3) < log₆(36)
- D. log₂(6) < log₆(36) < log₄(3)

Check: Compare each to benchmarks or compute it: log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58. Least to greatest is log₄(3) < log₆(36) < log₂(6).
Rationales: A: This sorts by the size of the number inside each logarithm (3, 6, 36), but the base matters just as much. The actual values are log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58. C: This sorts by the size of the base (2, 4, 6), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58. D: This is the order from greatest to least. Estimating each value gives log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58, so the list must run the other way.

---

## Seed N-2.9-B (new) — Topic 2.9 Logarithmic Expressions
**Skill:** solve a nested logarithmic equation by undoing the outer logarithm first and then the inner one, keeping track of which base goes with which step.

If log₂(log₃(x)) = 1, what is x?

- A. 8
- B. 3
- **C. 9**
- D. 6

Check: The outer log gives log₃(x) = 2^1 = 2; then x = 3^2 = 9. Check: log₃(9) = 2 and log₂(2) = 1.
Rationales: A: This undoes the logarithms in the wrong order or with the wrong bases: log₃(x) = 2^1 = 2, so x is a power of 3, not a power of 2. B: This ignores the outer logarithm and treats log₃(x) as if it equalled 1, so it stops after one step. D: This finds log₃(x) = 2 correctly but then multiplies 3 by 2 instead of raising 3 to the power 2.

**N-2.9-B-v1.** If log₂(log₃(x)) = 2, what is x?

- A. 512
- **B. 81**
- C. 9
- D. 12

Check: The outer log gives log₃(x) = 2^2 = 4; then x = 3^4 = 81. Check: log₃(81) = 4 and log₂(4) = 2.
Rationales: A: This undoes the logarithms in the wrong order or with the wrong bases: log₃(x) = 2^2 = 4, so x is a power of 3, not a power of 2. C: This ignores the outer logarithm and treats log₃(x) as if it equalled 2, so it stops after one step. D: This finds log₃(x) = 4 correctly but then multiplies 3 by 4 instead of raising 3 to the power 4.

**N-2.9-B-v2.** If log₃(log₂(x)) = 1, what is x?

- **A. 8**
- B. 9
- C. 2
- D. 6

Check: The outer log gives log₂(x) = 3^1 = 3; then x = 2^3 = 8. Check: log₂(8) = 3 and log₃(3) = 1.
Rationales: B: This undoes the logarithms in the wrong order or with the wrong bases: log₂(x) = 3^1 = 3, so x is a power of 2, not a power of 3. C: This ignores the outer logarithm and treats log₂(x) as if it equalled 1, so it stops after one step. D: This finds log₂(x) = 3 correctly but then multiplies 2 by 3 instead of raising 2 to the power 3.

**N-2.9-B-v3.** If log₂(log₅(x)) = 1, what is x?

- A. 32
- B. 5
- C. 10
- **D. 25**

Check: The outer log gives log₅(x) = 2^1 = 2; then x = 5^2 = 25. Check: log₅(25) = 2 and log₂(2) = 1.
Rationales: A: This undoes the logarithms in the wrong order or with the wrong bases: log₅(x) = 2^1 = 2, so x is a power of 5, not a power of 2. B: This ignores the outer logarithm and treats log₅(x) as if it equalled 1, so it stops after one step. C: This finds log₅(x) = 2 correctly but then multiplies 5 by 2 instead of raising 5 to the power 2.

---

## Seed N-2.10-A (new) — Topic 2.10 Inverses of Exponential Functions
**Skill:** evaluate the inverse of a shifted and scaled exponential function at a given output by undoing the shift, the scale, and then the exponential in order.

Let f(x) = 3·2ˣ − 5. What is f⁻¹(19)?

- A. 8
- B. log₂(14/3)
- **C. 3**
- D. log₂(19/3) + 5

Check: Solve 3·2ˣ − 5 = 19: 2ˣ = 8, so x = log₂(8) = 3. Check: 3·2^(3) + (-5) = 19.
Rationales: A: This isolates the exponential, 2ˣ = 8, and stops there. The inverse value is the exponent x, so one more step, log₂(8) = 3, is needed. B: The constant must be removed by subtracting c: 19 − (-5) = 24. This uses 19 + (-5) = 14 instead, so the shift is moved the wrong way. D: This takes the logarithm of 19 divided by 3 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 19 first.

**N-2.10-A-v1.** Let g(x) = 2·3ˣ + 1. What is g⁻¹(55)?

- A. 27
- **B. 3**
- C. log₃(28)
- D. log₃(55/2) − 1

Check: Solve 2·3ˣ + 1 = 55: 3ˣ = 27, so x = log₃(27) = 3. Check: 2·3^(3) + (1) = 55.
Rationales: A: This isolates the exponential, 3ˣ = 27, and stops there. The inverse value is the exponent x, so one more step, log₃(27) = 3, is needed. C: The constant must be removed by subtracting c: 55 − (1) = 54. This uses 55 + (1) = 56 instead, so the shift is moved the wrong way. D: This takes the logarithm of 55 divided by 2 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 55 first.

**N-2.10-A-v2.** Let h(x) = 1/2·4ˣ − 2. What is h⁻¹(6)?

- **A. 2**
- B. 16
- C. log₄(8)
- D. log₄(12) + 2

Check: Solve 1/2·4ˣ − 2 = 6: 4ˣ = 16, so x = log₄(16) = 2. Check: 1/2·4^(2) + (-2) = 6.
Rationales: B: This isolates the exponential, 4ˣ = 16, and stops there. The inverse value is the exponent x, so one more step, log₄(16) = 2, is needed. C: The constant must be removed by subtracting c: 6 − (-2) = 8. This uses 6 + (-2) = 4 instead, so the shift is moved the wrong way. D: This takes the logarithm of 6 divided by 1/2 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 6 first.

**N-2.10-A-v3.** Let p(x) = 3·(1/2)ˣ + 4. What is p⁻¹(10)?

- A. 2
- B. log_(1/2)(14/3)
- C. log_(1/2)(10/3) − 4
- **D. -1**

Check: Solve 3·(1/2)ˣ + 4 = 10: (1/2)ˣ = 2, so x = log_(1/2)(2) = -1. Check: 3·1/2^(-1) + (4) = 10.
Rationales: A: This isolates the exponential, (1/2)ˣ = 2, and stops there. The inverse value is the exponent x, so one more step, log_(1/2)(2) = -1, is needed. B: The constant must be removed by subtracting c: 10 − (4) = 6. This uses 10 + (4) = 14 instead, so the shift is moved the wrong way. C: This takes the logarithm of 10 divided by 3 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 10 first.

---

## Seed N-2.10-B (new) — Topic 2.10 Inverses of Exponential Functions
**Skill:** determine the domain and asymptote of an inverse exponential function from the range and horizontal asymptote of the original, including reflected and shifted cases.

Let g(x) = 2·3ˣ + 4. Which statement about the inverse function g⁻¹ is true?

- **A. The domain of g⁻¹ is x > 4, and its graph has a vertical asymptote at x = 4.**
- B. The domain of g⁻¹ is x > 0, and its graph has a vertical asymptote at x = 0.
- C. The domain of g⁻¹ is x > 4, and its graph has a horizontal asymptote at y = 4.
- D. The domain of g⁻¹ is all real numbers, and its range is y > 4.

Check: The horizontal asymptote y = 4 and range of g become the vertical asymptote x = 4 and domain x > 4 of the inverse, while the range of g⁻¹ is all real numbers.
Rationales: B: This treats the inverse of any exponential as having domain x > 0, ignoring the vertical shift. The domain of the inverse is the range of g, so the boundary moves to x = 4. C: The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = 4, not a horizontal asymptote. D: This describes the original function: the range of g is y > 4, and its domain is all reals. For the inverse the roles swap, so the domain is x > 4 and the range is all reals.

**N-2.10-B-v1.** Let g(x) = 3·2ˣ − 1. Which statement about the inverse function g⁻¹ is true?

- A. The domain of g⁻¹ is x > 0, and its graph has a vertical asymptote at x = 0.
- B. The domain of g⁻¹ is x > −1, and its graph has a horizontal asymptote at y = −1.
- C. The domain of g⁻¹ is all real numbers, and its range is y > −1.
- **D. The domain of g⁻¹ is x > −1, and its graph has a vertical asymptote at x = −1.**

Check: The horizontal asymptote y = −1 and range of g become the vertical asymptote x = −1 and domain x > −1 of the inverse, while the range of g⁻¹ is all real numbers.
Rationales: A: This treats the inverse of any exponential as having domain x > 0, ignoring the vertical shift. The domain of the inverse is the range of g, so the boundary moves to x = −1. B: The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = −1, not a horizontal asymptote. C: This describes the original function: the range of g is y > −1, and its domain is all reals. For the inverse the roles swap, so the domain is x > −1 and the range is all reals.

**N-2.10-B-v2.** Let h(x) = −2·3ˣ + 6. Which statement about the inverse function h⁻¹ is true?

- A. The domain of h⁻¹ is x > 6, and its graph has a vertical asymptote at x = 6.
- B. The domain of h⁻¹ is x < 6, and its graph has a horizontal asymptote at y = 6.
- **C. The domain of h⁻¹ is x < 6, and its graph has a vertical asymptote at x = 6.**
- D. The domain of h⁻¹ is all real numbers, and its range is y < 6.

Check: The horizontal asymptote y = 6 and range of h become the vertical asymptote x = 6 and domain x < 6 of the inverse, while the range of h⁻¹ is all real numbers.
Rationales: A: The coefficient −2 reflects the graph below its asymptote, so h takes only values below 6. The inverse's inputs are those outputs, so its domain is x < 6, not x > 6. B: The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = 6, not a horizontal asymptote. D: This describes the original function: the range of h is y < 6, and its domain is all reals. For the inverse the roles swap, so the domain is x < 6 and the range is all reals.

**N-2.10-B-v3.** Let k(x) = 4·(1/2)ˣ − 3. Which statement about the inverse function k⁻¹ is true?

- A. The domain of k⁻¹ is x > 0, and its graph has a vertical asymptote at x = 0.
- **B. The domain of k⁻¹ is x > −3, and its graph has a vertical asymptote at x = −3.**
- C. The domain of k⁻¹ is x > −3, and its graph has a horizontal asymptote at y = −3.
- D. The domain of k⁻¹ is all real numbers, and its range is y > −3.

Check: The horizontal asymptote y = −3 and range of k become the vertical asymptote x = −3 and domain x > −3 of the inverse, while the range of k⁻¹ is all real numbers.
Rationales: A: This treats the inverse of any exponential as having domain x > 0, ignoring the vertical shift. The domain of the inverse is the range of k, so the boundary moves to x = −3. C: The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = −3, not a horizontal asymptote. D: This describes the original function: the range of k is y > −3, and its domain is all reals. For the inverse the roles swap, so the domain is x > −3 and the range is all reals.

---

## Seed N-2.11-A (new) — Topic 2.11 Logarithmic Functions
**Skill:** describe increasing or decreasing behavior, concavity, and the vertical asymptote of a transformed logarithmic function from its equation, including a reflection.

Which statement correctly describes f(x) on its domain, where f(x) = −log₂(x + 3) + 1?

- **A. It is decreasing and concave up, with vertical asymptote x = −3.**
- B. It is decreasing and concave down, with vertical asymptote x = −3.
- C. It is decreasing and concave up, with vertical asymptote x = 3.
- D. It is increasing and concave down, with vertical asymptote x = −3.

Check: x + 3 > 0 gives asymptote x = −3. For −log₂(u), the derivative is −1/((x+3) ln 2) < 0 and the second derivative is 1/((x+3)² ln 2) > 0.
Rationales: B: A reflection in the x-axis reverses the direction of change and also the concavity: log₂ is concave down, so −log₂ is concave up. C: The input is x + 3, which is zero at x = −3, not x = 3, so the vertical asymptote is at x = −3. D: This ignores the negative sign in front of the logarithm; with it the function decreases and is concave up.

**N-2.11-A-v1.** Which statement correctly describes g(x) on its domain, where g(x) = −3·log₂(x − 4) + 5?

- A. It is decreasing and concave down, with vertical asymptote x = 4.
- B. It is decreasing and concave up, with vertical asymptote x = −4.
- C. It is increasing and concave down, with vertical asymptote x = 4.
- **D. It is decreasing and concave up, with vertical asymptote x = 4.**

Check: x − 4 > 0 gives asymptote x = 4. The derivative −3/((x−4) ln 2) is negative and the second derivative 3/((x−4)² ln 2) is positive.
Rationales: A: The negative multiplier reverses the direction and the concavity; log₂ is concave down, so −3·log₂ is concave up. B: The input is x − 4, which is zero at x = 4, not x = −4, so the asymptote is at x = 4. C: This overlooks the factor −3: the negative multiplier makes the function decrease and be concave up.

**N-2.11-A-v2.** Which statement correctly describes h(x) on its domain, where h(x) = 2·ln(5 − x) + 1?

- A. It is increasing and concave down, with vertical asymptote x = 5.
- B. It is decreasing and concave up, with vertical asymptote x = 5.
- **C. It is decreasing and concave down, with vertical asymptote x = 5.**
- D. It is decreasing and concave down, with vertical asymptote x = −5.

Check: 5 − x > 0 gives x < 5 and asymptote x = 5. h′(x) = −2/(5 − x) < 0 and h″(x) = −2/(5 − x)² < 0 there.
Rationales: A: As x increases, 5 − x decreases, so ln(5 − x) falls; the function cannot increase, even though ln itself is an increasing function. B: The second derivative is −2/(5 − x)², which is negative, so the graph is concave down; the reflection in the input does not flip the concavity. D: The input 5 − x is zero at x = 5, so the vertical asymptote is x = 5; the function is defined for x < 5.

**N-2.11-A-v3.** Which statement correctly describes k(x) on its domain, where k(x) = log_(1/2)(x − 2) + 3?

- A. It is increasing and concave down, with vertical asymptote x = 2.
- **B. It is decreasing and concave up, with vertical asymptote x = 2.**
- C. It is decreasing and concave down, with vertical asymptote x = 2.
- D. It is decreasing and concave up, with vertical asymptote x = −2.

Check: log_(1/2)(u) = −log₂(u), so k decreases and is concave up on x > 2, with vertical asymptote x = 2 from x − 2 > 0.
Rationales: A: A base between 0 and 1 gives a decreasing logarithm, since log_(1/2)(x) = −log₂(x); it is not increasing. C: Because log_(1/2)(x) = −log₂(x), the concavity flips along with the direction: it is concave up, not concave down. D: The input is x − 2, which is zero at x = 2, not x = −2, so the vertical asymptote is at x = 2.

---

## Seed N-2.11-B (new) — Topic 2.11 Logarithmic Functions
**Skill:** interpret the coefficient of a logarithmic model as a change per multiplication of the input, and find the factor that produces a given increase in the output.

A loudness meter produces a calibration reading modeled by g(x) = 5 + 4log₂(x) for x > 0. By what factor must x be multiplied for g(x) to increase by 10?

- A. 5/2
- B. 256
- **C. 4√2**
- D. 1024

Check: g(kx) − g(x) = 4log₂(k) = 10, so log₂(k) = 5/2 and k = 2^(5/2) = 4√2 ≈ 5.66.
Rationales: A: This treats 10/4 = 5/2 as the multiplier of x. Multiplying x by a factor k adds 4·log₂(k) to the output, so 4log₂(k) = 10 must be solved for k. B: This computes 2^10 ÷ 4. The exponent must be divided by 4 first: log₂(k) = 5/2, so k = 2^(5/2), not 2^10 ÷ 4. D: This sets log₂(k) = 10 and ignores the coefficient 4. The increase is 4log₂(k), so log₂(k) = 5/2, not 10.

**N-2.11-B-v1.** A sensor produces a sensor value modeled by h(x) = 2 + 4log₃(x) for x > 0. By what factor must x be multiplied for h(x) to increase by 6?

- A. 3/2
- **B. 3√3**
- C. 729/4
- D. 729

Check: h(kx) − h(x) = 4log₃(k) = 6, so log₃(k) = 3/2 and k = 3^(3/2) = 3√3 ≈ 5.20.
Rationales: A: This treats 6/4 = 3/2 as the multiplier of x. Multiplying x by a factor k adds 4·log₃(k) to the output, so 4log₃(k) = 6 must be solved for k. C: This computes 3^6 ÷ 4. The exponent must be divided by 4 first: log₃(k) = 3/2, so k = 3^(3/2), not 3^6 ÷ 4. D: This sets log₃(k) = 6 and ignores the coefficient 4. The increase is 4log₃(k), so log₃(k) = 3/2, not 6.

**N-2.11-B-v2.** A rating system produces a rating modeled by R(x) = 7 + 6log₂(x) for x > 0. By what factor must x be multiplied for R(x) to increase by 9?

- **A. 2√2**
- B. 3/2
- C. 256/3
- D. 512

Check: R(kx) − R(x) = 6log₂(k) = 9, so log₂(k) = 3/2 and k = 2^(3/2) = 2√2 ≈ 2.83.
Rationales: B: This treats 9/6 = 3/2 as the multiplier of x. Multiplying x by a factor k adds 6·log₂(k) to the output, so 6log₂(k) = 9 must be solved for k. C: This computes 2^9 ÷ 6. The exponent must be divided by 6 first: log₂(k) = 3/2, so k = 2^(3/2), not 2^9 ÷ 6. D: This sets log₂(k) = 9 and ignores the coefficient 6. The increase is 6log₂(k), so log₂(k) = 3/2, not 9.

**N-2.11-B-v3.** A receiver produces a signal level modeled by S(x) = 1 + 2log₁₀(x) for x > 0. By what factor must x be multiplied for S(x) to increase by 5?

- A. 5/2
- B. 50000
- C. 100000
- **D. 100√10**

Check: S(kx) − S(x) = 2log₁₀(k) = 5, so log₁₀(k) = 5/2 and k = 10^(5/2) = 100√10 ≈ 316.23.
Rationales: A: This treats 5/2 = 5/2 as the multiplier of x. Multiplying x by a factor k adds 2·log₁₀(k) to the output, so 2log₁₀(k) = 5 must be solved for k. B: This computes 10^5 ÷ 2. The exponent must be divided by 2 first: log₁₀(k) = 5/2, so k = 10^(5/2), not 10^5 ÷ 2. C: This sets log₁₀(k) = 5 and ignores the coefficient 2. The increase is 2log₁₀(k), so log₁₀(k) = 5/2, not 5.

---

## Seed N-2.12-A (new) — Topic 2.12 Logarithmic Function Manipulation
**Skill:** decide which logarithm-property rewrite is valid for every x in the domain of the original expression, recognizing that a power rule applied to an even power needs an absolute value.

Consider the expression log₂(x²). Which equation is true for every real number x for which log₂(x²) is defined?

- A. log₂(x²) = 2log₂(x)
- B. log₂(x²) = (log₂ x)²
- **C. log₂(x²) = 2log₂|x|**
- D. log₂(x²) = log₂(2x)

Check: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -3 and x = 8.
Rationales: A: At x = −3, log₂(x²) = log₂(9) is defined, but log₂(−3) does not exist, so 2log₂(x) cannot match for negative x. B: At x = 8, log₂(64) = 6, but (log₂ 8)² = 9. D: At x = 8, log₂(64) = 6, but log₂(16) = 4.

**N-2.12-A-v1.** Consider the expression log₃(x⁴). Which equation is true for every real number x for which log₃(x⁴) is defined?

- A. log₃(x⁴) = 4log₃(x)
- **B. log₃(x⁴) = 4log₃|x|**
- C. log₃(x⁴) = (log₃ x)⁴
- D. log₃(x⁴) = log₃(4x)

Check: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -2 and x = 27.
Rationales: A: At x = −2, log₃(x⁴) = log₃(16) is defined, but log₃(−2) does not exist, so 4log₃(x) cannot match for negative x. C: At x = 27, log₃(27⁴) = 12, but (log₃ 27)⁴ = 81. D: At x = 27, log₃(27⁴) = 12, but log₃(108) ≈ 4.27.

**N-2.12-A-v2.** Consider the expression log₂((x − 1)²). Which equation is true for every real number x for which log₂((x − 1)²) is defined?

- **A. log₂((x − 1)²) = 2log₂|x − 1|**
- B. log₂((x − 1)²) = 2log₂(x − 1)
- C. log₂((x − 1)²) = (log₂(x − 1))²
- D. log₂((x − 1)²) = log₂(2x − 2)

Check: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -1 and x = 9.
Rationales: B: At x = −1, log₂((x − 1)²) = log₂(4) is defined, but log₂(−2) does not exist, so 2log₂(x − 1) cannot match for x < 1. C: At x = 9, log₂(64) = 6, but (log₂ 8)² = 9. D: At x = 9, log₂(64) = 6, but log₂(16) = 4.

**N-2.12-A-v3.** Consider the expression log₂(16x²). Which equation is true for every real number x for which log₂(16x²) is defined?

- A. log₂(16x²) = 4 + 2log₂(x)
- B. log₂(16x²) = log₂(16)·log₂(x²)
- C. log₂(16x²) = 4 + (log₂ x)²
- **D. log₂(16x²) = 4 + 2log₂|x|**

Check: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -2 and x = 8.
Rationales: A: At x = −2, log₂(16x²) = log₂(64) is defined, but log₂(−2) does not exist, so 4 + 2log₂(x) cannot match for negative x. B: At x = 8, log₂(1024) = 10, but 4·log₂(64) = 24. C: At x = 8, log₂(1024) = 10, but 4 + (log₂ 8)² = 13.

---

## Seed N-2.12-B (new) — Topic 2.12 Logarithmic Function Manipulation
**Skill:** write the logarithm of a quotient involving a root in terms of given logarithms, using log₁₀(5) = 1 − log₁₀(2) and the product, quotient and power properties.

Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(√12 / 5)?

- **A. 2a + b/2 − 1**
- B. 3a + b − 1
- C. (a + b/2)/(−a + 1)
- D. b/2 + 1

Check: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result 2a + b/2 − 1 ≈ -0.1594, matching log₁₀(√12 / 5) ≈ -0.1594.
Rationales: B: This leaves out the factor ½ that the square root contributes to the numerator's logarithm, using the whole of log₁₀ of the radicand instead of half of it. C: This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms. D: This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator's logarithm must be subtracted, not added.

**N-2.12-B-v1.** Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(√45 / 8)?

- A. −4a + 2b + 1
- B. (−a/2 + b + 1/2)/(3a)
- C. 5a/2 + b + 1/2
- **D. −7a/2 + b + 1/2**

Check: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result −7a/2 + b + 1/2 ≈ -0.0765, matching log₁₀(√45 / 8) ≈ -0.0765.
Rationales: A: This leaves out the factor ½ that the square root contributes to the numerator's logarithm, using the whole of log₁₀ of the radicand instead of half of it. B: This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms. C: This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator's logarithm must be subtracted, not added.

**N-2.12-B-v2.** Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(75 / √8)?

- A. −5a + b + 2
- B. (−2a + b + 2)/(3a/2)
- **C. −7a/2 + b + 2**
- D. −a/2 + b + 2

Check: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result −7a/2 + b + 2 ≈ 1.4235, matching log₁₀(75 / √8) ≈ 1.4235.
Rationales: A: This leaves out the factor ½ that the square root contributes to the denominator's logarithm, using the whole of log₁₀(8) instead of half of it. B: This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms. D: This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator's logarithm must be subtracted, not added.

**N-2.12-B-v3.** Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(√48 / 15)?

- A. 5a − 1
- **B. 3a − b/2 − 1**
- C. (2a + b/2)/(−a + b + 1)
- D. a + 3b/2 + 1

Check: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result 3a − b/2 − 1 ≈ -0.3355, matching log₁₀(√48 / 15) ≈ -0.3355.
Rationales: A: This leaves out the factor ½ that the square root contributes to the numerator's logarithm, using the whole of log₁₀ of the radicand instead of half of it. C: This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms. D: This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator's logarithm must be subtracted, not added.

---

## Seed N-2.13-A (new) — Topic 2.13 Exponential and Logarithmic Equations and Inequalities
**Skill:** solve a logarithmic inequality by combining the exponential rewrite with the domain requirement that the argument is positive, and by checking when the inequality direction reverses.

What is the solution set of log₃(2x − 4) ≤ 2?

- **A. 2 < x ≤ 13/2**
- B. x ≤ 13/2
- C. 2 < x ≤ 5
- D. x ≥ 13/2

Check: Need 2x − 4 > 0, so x > 2, and log₃(2x − 4) ≤ 2 gives 2x − 4 ≤ 9, so x ≤ 13/2. Together 2 < x ≤ 13/2.
Rationales: B: This solves 2x − 4 ≤ 9 but ignores that the argument of the logarithm must be positive, so x must also be greater than 2. C: This writes the exponential form as 2x − 4 ≤ 3·2 = 6 instead of 3² = 9, so the upper bound comes out wrong. D: This reverses the inequality, but the base 3 is greater than 1, so log₃ is increasing and the direction is kept; the domain x > 2 is also lost.

**N-2.13-A-v1.** What is the solution set of log₂(3x − 6) ≤ 3?

- A. x ≤ 14/3
- B. 2 < x ≤ 4
- C. x ≥ 14/3
- **D. 2 < x ≤ 14/3**

Check: Need 3x − 6 > 0, so x > 2, and log₂(3x − 6) ≤ 3 gives 3x − 6 ≤ 8, so x ≤ 14/3. Together 2 < x ≤ 14/3.
Rationales: A: This solves 3x − 6 ≤ 8 but ignores that the argument of the logarithm must be positive, so x must also be greater than 2. B: This writes the exponential form as 3x − 6 ≤ 2·3 = 6 instead of 2³ = 8, so the upper bound comes out wrong. C: This reverses the inequality, but the base 2 is greater than 1, so log₂ is increasing and the direction is kept; the domain x > 2 is also lost.

**N-2.13-A-v2.** What is the solution set of log₅(4 − x) < 1?

- A. x > −1
- B. x < 4
- **C. −1 < x < 4**
- D. x < −1

Check: Need 4 − x > 0, so x < 4, and log₅(4 − x) < 1 gives 4 − x < 5, so x > −1. Together −1 < x < 4.
Rationales: A: This solves 4 − x < 5 correctly for x > −1 but ignores that the argument 4 − x must be positive, which requires x < 4. B: This uses only the domain condition 4 − x > 0 and never applies the inequality log₅(4 − x) < 1, which requires 4 − x < 5. D: This forgets to reverse the inequality when moving from 4 − x < 5 to the condition on x: subtracting 4 and multiplying by −1 flips the sign.

**N-2.13-A-v3.** What is the solution set of log_(1/2)(x + 1) ≥ −2?

- A. x ≥ 3
- **B. −1 < x ≤ 3**
- C. x ≤ 3
- D. −1 < x ≤ −3/4

Check: Need x + 1 > 0, so x > −1. Since the base is 1/2, the inequality flips: x + 1 ≤ (1/2)⁻² = 4, so x ≤ 3. Together −1 < x ≤ 3.
Rationales: A: This does not reverse the inequality; since the base 1/2 is between 0 and 1, the logarithm is decreasing and the inequality flips to x + 1 ≤ 4. C: This reverses the inequality correctly to x ≤ 3 but ignores that the argument x + 1 must be positive, so x must be greater than −1. D: This computes (1/2)⁻² as 1/4 instead of 4, which gives x + 1 ≤ 1/4; a negative exponent makes the power larger than 1.

---

## Seed N-2.13-B (new) — Topic 2.13 Exponential and Logarithmic Equations and Inequalities
**Skill:** model when two exponential quantities become equal and write the solution time as a logarithmic expression, handling both growth and decay.

Two accounts are modeled, with t the time and values in dollars, by P(t) = 1000·1.05ᵗ and Q(t) = 1500·1.03ᵗ. Which expression gives the time t at which the two quantities are equal?

- A. ln(1.5) / ln(1.02)
- B. ln(1.5) / (ln 1.05 + ln 1.03)
- **C. ln(1.5) / (ln 1.05 − ln 1.03)**
- D. ln(1.5) / ln(1.05)

Check: 1000·1.05ᵗ = 1500·1.03ᵗ gives (1.05/1.03)ᵗ = 1.5, so t = ln(1.5)/(ln 1.05 − ln 1.03) ≈ 21.1 years.
Rationales: A: This subtracts the growth rates, 1.05 − 1.03 = 0.02, to get a 1.02 factor. The relative growth is the ratio 1.05/1.03, so the denominator is ln(1.05/1.03) = ln 1.05 − ln 1.03. B: This adds the logarithms of the growth factors. Dividing both sides by 1.03ᵗ gives (1.05/1.03)ᵗ = 1.5, so the logarithms are subtracted. D: This lets P grow by the factor 1.5 alone and ignores that Q is growing at the same time, at 3% per year.

**N-2.13-B-v1.** Two accounts are modeled, with t the time and values in dollars, by P(t) = 800·1.09ᵗ and Q(t) = 2000·1.05ᵗ. Which expression gives the time t at which the two quantities are equal?

- A. ln(2.5) / ln(1.04)
- **B. ln(2.5) / (ln 1.09 − ln 1.05)**
- C. ln(2.5) / (ln 1.09 + ln 1.05)
- D. ln(2.5) / ln(1.09)

Check: 800·1.09ᵗ = 2000·1.05ᵗ gives (1.09/1.05)ᵗ = 2.5, so t = ln(2.5)/(ln 1.09 − ln 1.05) ≈ 24.1 years.
Rationales: A: This subtracts the growth rates, 1.09 − 1.05 = 0.04, to get a 1.04 factor. The relative growth is the ratio 1.09/1.05, so the denominator is ln 1.09 − ln 1.05. C: This adds the logarithms of the growth factors. Dividing both sides by 1.05ᵗ gives (1.09/1.05)ᵗ = 2.5, so the logarithms are subtracted. D: This lets P grow by the factor 2.5 alone and ignores that Q is growing at the same time, at 5% per year.

**N-2.13-B-v2.** Two drug concentrations are modeled, with t the time and values in mg per liter, by A(t) = 500·0.9ᵗ and B(t) = 200·0.95ᵗ. Which expression gives the time t at which the two quantities are equal?

- **A. ln(0.4) / (ln 0.9 − ln 0.95)**
- B. ln(2.5) / (ln 0.9 − ln 0.95)
- C. ln(0.4) / (ln 0.9 + ln 0.95)
- D. ln(0.4) / ln(0.9)

Check: 500·0.9ᵗ = 200·0.95ᵗ gives (0.9/0.95)ᵗ = 0.4, so t = ln(0.4)/(ln 0.9 − ln 0.95) ≈ 16.9.
Rationales: B: This inverts the ratio of the starting values: dividing 200ᵗ-side by 500 gives 200/500 = 0.4, not 2.5, and the inverted ratio leads to a negative time. C: This adds the logarithms of the decay factors. Dividing both sides by 0.95ᵗ gives (0.9/0.95)ᵗ = 0.4, so the logarithms are subtracted. D: This lets A decay alone to 40% of its value and ignores that B is decaying too, at 5% per unit time.

**N-2.13-B-v3.** Two populations are modeled, with t the time and values in individuals, by V(t) = 120e^(0.04t) and W(t) = 300e^(0.01t). Which expression gives the time t at which the two quantities are equal?

- A. ln(2.5) / 0.05
- B. ln(2.5) / 0.04
- C. ln(0.4) / 0.03
- **D. ln(2.5) / 0.03**

Check: 120e^(0.04t) = 300e^(0.01t) gives e^(0.03t) = 2.5, so t = ln(2.5)/0.03 ≈ 30.5.
Rationales: A: This adds the growth rates 0.04 + 0.01. Dividing both sides by e^(0.01t) gives e^(0.03t) = 2.5, so the rates are subtracted. B: This lets V grow alone by the factor 2.5 and ignores that W is also growing at rate 0.01. C: This inverts the ratio of the starting values: 120e^(0.04t) = 300e^(0.01t) leads to e^(0.03t) = 300/120 = 2.5, not 0.4, which would give a negative time.

---

## Seed N-2.14-A (new) — Topic 2.14 Logarithmic Function Context and Data Modeling
**Skill:** use residuals (observed minus predicted) from a logarithmic model to decide where, and by how much, the model overestimates the data.

A study group's quiz scores (score) are compared with the model N(t) = 6 + 4log₂(t). The observed values are (t, value): t = 1, 6.5; t = 2, 9; t = 4, 14; t = 8, 17.5. Residual means observed minus predicted. Which statement is correct?

- A. The model overestimates the most at t = 1, by 0.5.
- B. The model underestimates the most at t = 2, by 1.
- **C. The model overestimates the most at t = 2, by 1.**
- D. The model is exact at t = 4, so it does not overestimate at any input.

Check: Predictions: 6, 10, 14, 18. Residuals (observed − predicted): 0.5, -1, 0, -0.5. The most negative residual is -1 at t = 2, an overestimate of 1.
Rationales: A: This picks the largest positive residual (0.5 at t = 1), but a positive residual means the model underestimates; the overestimates are the negative residuals. B: A residual of -1 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign. D: The model is exact at t = 4, but residuals at other inputs are negative, which means the model overestimates there; an exact fit at one point does not rule out overestimates elsewhere.

**N-2.14-A-v1.** A cooling experiment's readings (temperature (degrees)) are compared with the model T(d) = 10 + 3log₂(d). The observed values are (d, value): d = 1, 9; d = 2, 14.5; d = 4, 16; d = 8, 17. Residual means observed minus predicted. Which statement is correct?

- A. The model overestimates the most at d = 2, by 1.5.
- **B. The model overestimates the most at d = 8, by 2.**
- C. The model underestimates the most at d = 8, by 2.
- D. The model is exact at d = 4, so it does not overestimate at any input.

Check: Predictions: 10, 13, 16, 19. Residuals (observed − predicted): -1, 1.5, 0, -2. The most negative residual is -2 at d = 8, an overestimate of 2.
Rationales: A: This picks the largest positive residual (1.5 at d = 2), but a positive residual means the model underestimates; the overestimates are the negative residuals. C: A residual of -2 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign. D: The model is exact at d = 4, but residuals at other inputs are negative, which means the model overestimates there; an exact fit at one point does not rule out overestimates elsewhere.

**N-2.14-A-v2.** A growth study's measurements (weight (kg)) are compared with the model W(h) = 4 + 5log₃(h). The observed values are (h, value): h = 1, 5; h = 3, 8; h = 9, 15.5; h = 27, 18.5. Residual means observed minus predicted. Which statement is correct?

- **A. The model overestimates the most at h = 3, by 1.**
- B. The model overestimates the most at h = 9, by 1.5.
- C. The model underestimates the most at h = 3, by 1.
- D. The model overestimates the most at h = 27, by 0.5.

Check: Predictions: 4, 9, 14, 19. Residuals (observed − predicted): 1, -1, 1.5, -0.5. The most negative residual is -1 at h = 3, an overestimate of 1.
Rationales: B: This picks the largest positive residual (1.5 at h = 9), but a positive residual means the model underestimates; the overestimates are the negative residuals. C: A residual of -1 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign. D: The residual at h = 27 is -0.5, an overestimate of only 0.5, which is smaller than the overestimate of 1 at h = 3.

**N-2.14-A-v3.** A rating panel's observations (rating) are compared with the model R(x) = 2 + 6log₂(x). The observed values are (x, value): x = 1, 1; x = 2, 9; x = 4, 12.5; x = 8, 20.5. Residual means observed minus predicted. Which statement is correct?

- A. The model overestimates the most at x = 2, by 1.
- B. The model underestimates the most at x = 4, by 1.5.
- C. The model overestimates the most at x = 1, by 1.
- **D. The model overestimates the most at x = 4, by 1.5.**

Check: Predictions: 2, 8, 14, 20. Residuals (observed − predicted): -1, 1, -1.5, 0.5. The most negative residual is -1.5 at x = 4, an overestimate of 1.5.
Rationales: A: This picks the largest positive residual (1 at x = 2), but a positive residual means the model underestimates; the overestimates are the negative residuals. B: A residual of -1.5 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign. C: The residual at x = 1 is -1, an overestimate of only 1, which is smaller than the overestimate of 1.5 at x = 4.

---

## Seed N-2.14-B (new) — Topic 2.14 Logarithmic Function Context and Data Modeling
**Skill:** compare average rates of change of a logarithmic model on two intervals that each span one multiplication of the input, and interpret why the rate slows.

A model gives score S(t) = 10 + 8log₂(t), t in hours of practice, in points. Which pair correctly gives the average rates of change of S over [1, 2] and over [4, 8]?

- **A. 8 points per hour on [1, 2] and 2 points per hour on [4, 8]**
- B. 8 points per hour on [1, 2] and 8 points per hour on [4, 8]
- C. 2 points per hour on [1, 2] and 8 points per hour on [4, 8]
- D. 8 points per hour on [1, 2] and 1 points per hour on [4, 8]

Check: Each interval multiplies the input by 2, so the output rises by 8. Rates: 8/1 = 8 and 8/4 = 2; the rate falls as the interval moves right.
Rationales: B: Over each interval the output rises by 8, because the input is multiplied by 2 each time, but a rate divides that change by the interval width: 1 and 4, which are different. C: This swaps the two rates. The later interval is wider (4 units) for the same rise of 8, so its rate must be the smaller of the two. D: The rate on [4, 8] divides the rise 8 by the interval's width, 8 − 4 = 4, not by its right endpoint 8.

**N-2.14-B-v1.** A model gives depth D(t) = 3 + 6log₃(t), t in minutes, in meters. Which pair correctly gives the average rates of change of D over [1, 3] and over [9, 27]?

- A. 6 meters per minute on [1, 3] and 6 meters per minute on [9, 27]
- B. 1/3 meters per minute on [1, 3] and 3 meters per minute on [9, 27]
- C. 3 meters per minute on [1, 3] and 2/9 meters per minute on [9, 27]
- **D. 3 meters per minute on [1, 3] and 1/3 meters per minute on [9, 27]**

Check: Each interval multiplies the input by 3, so the output rises by 6. Rates: 6/2 = 3 and 6/18 = 1/3; the rate falls as the interval moves right.
Rationales: A: Over each interval the output rises by 6, because the input is multiplied by 3 each time, but a rate divides that change by the interval width: 2 and 18, which are different. B: This swaps the two rates. The later interval is wider (18 units) for the same rise of 6, so its rate must be the smaller of the two. C: The rate on [9, 27] divides the rise 6 by the interval's width, 27 − 9 = 18, not by its right endpoint 27.

**N-2.14-B-v2.** A model gives signal M(t) = 5 + 12log₂(t), t in seconds, in units. Which pair correctly gives the average rates of change of M over [2, 4] and over [8, 16]?

- A. 12 units per second on [2, 4] and 12 units per second on [8, 16]
- B. 3/2 units per second on [2, 4] and 6 units per second on [8, 16]
- **C. 6 units per second on [2, 4] and 3/2 units per second on [8, 16]**
- D. 6 units per second on [2, 4] and 3/4 units per second on [8, 16]

Check: Each interval multiplies the input by 2, so the output rises by 12. Rates: 12/2 = 6 and 12/8 = 3/2; the rate falls as the interval moves right.
Rationales: A: Over each interval the output rises by 12, because the input is multiplied by 2 each time, but a rate divides that change by the interval width: 2 and 8, which are different. B: This swaps the two rates. The later interval is wider (8 units) for the same rise of 12, so its rate must be the smaller of the two. D: The rate on [8, 16] divides the rise 12 by the interval's width, 16 − 8 = 8, not by its right endpoint 16.

**N-2.14-B-v3.** A model gives reading E(t) = 1 + 6log₄(t), t in days, in units. Which pair correctly gives the average rates of change of E over [1, 4] and over [4, 16]?

- A. 6 units per day on [1, 4] and 6 units per day on [4, 16]
- **B. 2 units per day on [1, 4] and 1/2 units per day on [4, 16]**
- C. 1/2 units per day on [1, 4] and 2 units per day on [4, 16]
- D. 2 units per day on [1, 4] and 3/8 units per day on [4, 16]

Check: Each interval multiplies the input by 4, so the output rises by 6. Rates: 6/3 = 2 and 6/12 = 1/2; the rate falls as the interval moves right.
Rationales: A: Over each interval the output rises by 6, because the input is multiplied by 4 each time, but a rate divides that change by the interval width: 3 and 12, which are different. C: This swaps the two rates. The later interval is wider (12 units) for the same rise of 6, so its rate must be the smaller of the two. D: The rate on [4, 16] divides the rise 6 by the interval's width, 16 − 4 = 12, not by its right endpoint 16.

---

## Seed N-2.15-A (new) — Topic 2.15 Semi-log Plots
**Skill:** recover the exponential model y = a·bˣ from two points on a semi-log line, using the slope for b and the vertical intercept (as an exponent) for a.

A semi-log plot of log₂(y) against x is a straight line through the points (1, 5) and (4, 11). Which exponential function y = f(x) do the data follow?

- **A. 8·4ˣ**
- B. 3·4ˣ
- C. 32·4ˣ
- D. 8·2ˣ

Check: Slope = (11 − 5)/(4 − 1) = 2, so b = 2^2 = 4. Intercept 3 gives a = 2^3 = 8. Check: f(1) = 8·4^1 = 2^5.
Rationales: B: The base is right, but a is the value of y at x = 0, which is 2 raised to the vertical intercept, not the intercept itself; here a = 8, not 3. C: This uses the given value 5 at x = 1 (2⁵ = 32) as a. The constant a is found at x = 0 from the line's intercept, not from a data point at a nonzero x. D: This uses the slope of the line as b. The slope is the exponent of the base, so b = 2^slope = 4, not the slope itself.

**N-2.15-A-v1.** A semi-log plot of log₃(y) against x is a straight line through the points (2, 5) and (4, 9). Which exponential function y = f(x) do the data follow?

- A. 1·9ˣ
- B. 243·9ˣ
- C. 3·2ˣ
- **D. 3·9ˣ**

Check: Slope = (9 − 5)/(4 − 2) = 2, so b = 3^2 = 9. Intercept 1 gives a = 3^1 = 3. Check: f(2) = 3·9^2 = 3^5.
Rationales: A: The base is right, but a is the value of y at x = 0, which is 3 raised to the vertical intercept, not the intercept itself; here a = 3, not 1. B: This uses the given value 5 at x = 2 (3⁵ = 243) as a. The constant a is found at x = 0 from the line's intercept, not from a data point at a nonzero x. C: This uses the slope of the line as b. The slope is the exponent of the base, so b = 3^slope = 9, not the slope itself.

**N-2.15-A-v2.** A semi-log plot of log₂(y) against x is a straight line through the points (1, 4) and (3, 10). Which exponential function y = f(x) do the data follow?

- A. 1·8ˣ
- B. 16·8ˣ
- **C. 2·8ˣ**
- D. 2·3ˣ

Check: Slope = (10 − 4)/(3 − 1) = 3, so b = 2^3 = 8. Intercept 1 gives a = 2^1 = 2. Check: f(1) = 2·8^1 = 2^4.
Rationales: A: The base is right, but a is the value of y at x = 0, which is 2 raised to the vertical intercept, not the intercept itself; here a = 2, not 1. B: This uses the given value 4 at x = 1 (2⁴ = 16) as a. The constant a is found at x = 0 from the line's intercept, not from a data point at a nonzero x. D: This uses the slope of the line as b. The slope is the exponent of the base, so b = 2^slope = 8, not the slope itself.

**N-2.15-A-v3.** A semi-log plot of log₁₀(y) against x is a straight line through the points (2, 1.4) and (5, 2.3). Which exponential function y = f(x) do the data follow?

- A. 0.8·10^(0.3x)
- **B. 10^0.8·10^(0.3x)**
- C. 10^1.4·10^(0.3x)
- D. 10^0.8·0.3ˣ

Check: Slope = (2.3 − 1.4)/(5 − 2) = 0.3, so b = 10^0.3. Intercept = 1.4 − 0.3·2 = 0.8, so a = 10^0.8. Check at x = 2: 10^0.8·10^0.6 = 10^1.4.
Rationales: A: This uses the vertical intercept 0.8 directly as a. The intercept is the value of log₁₀(y) at x = 0, so a = 10^0.8. C: This uses the given log value 1.4 at x = 2 to find a. The constant a must come from the line's intercept at x = 0, which is 0.8. D: This uses the slope 0.3 as the base. The slope is the power of 10 in the base, so b = 10^0.3, not 0.3.

---

## Seed N-2.15-B (new) — Topic 2.15 Semi-log Plots
**Skill:** interpret the slope of a semi-log line as growth per unit of time and use it to find a doubling or tripling time.

A semi-log plot of log₁₀(N) against time in days for a bacterial culture is a straight line with slope 0.15. Using log₁₀(2) ≈ 0.301, about how many days does it take to double?

- A. 0.5
- B. 6.7
- **C. 2.0**
- D. 13.3

Check: The vertical value must rise by log₁₀(2) ≈ 0.301. At 0.15 per day, the time is 0.301/0.15 ≈ 2.0 days.
Rationales: A: This divides the slope by 0.301, which is the reverse of the needed quotient. The time is the required change in the log, 0.301, divided by the slope 0.15. B: This divides 1 by the slope, which would give the time for a tenfold increase. Doubling adds log₁₀(2) ≈ 0.301 to the vertical value, not 1. D: This divides 2 by the slope, using the factor 2 as if it were the change in the logarithm. The required change is log₁₀(2) ≈ 0.301.

**N-2.15-B-v1.** A semi-log plot of log₁₀(F) against time in days for a social media account's followers is a straight line with slope 0.06. Using log₁₀(2) ≈ 0.301, about how many days does it take to double?

- A. 0.2
- **B. 5.0**
- C. 16.7
- D. 33.3

Check: The vertical value must rise by log₁₀(2) ≈ 0.301. At 0.06 per day, the time is 0.301/0.06 ≈ 5.0 days.
Rationales: A: This divides the slope by 0.301, which is the reverse of the needed quotient. The time is the required change in the log, 0.301, divided by the slope 0.06. C: This divides 1 by the slope, which would give the time for a tenfold increase. Doubling adds log₁₀(2) ≈ 0.301 to the vertical value, not 1. D: This divides 2 by the slope, using the factor 2 as if it were the change in the logarithm. The required change is log₁₀(2) ≈ 0.301.

**N-2.15-B-v2.** A semi-log plot of log₂(Q) against time in hours for a quantum sensor's signal is a straight line with slope 0.25. About how many hours does it take to double?

- **A. 4.0**
- B. 0.25
- C. 1.2
- D. 8.0

Check: Doubling adds log₂(2) = 1 to log₂(Q). At 0.25 per hour, the time is 1/0.25 = 4.0 hours.
Rationales: B: This reads the slope itself as the time. The slope is the gain in log₂(Q) per hour, and doubling adds 1 to log₂(Q), so the time is 1 ÷ 0.25. C: This uses log₁₀(2) ≈ 0.301 even though the vertical axis is in base 2. With log₂, doubling adds exactly 1 to log₂(Q), so the time is 1 ÷ slope. D: This divides 2 by the slope, treating the doubling factor 2 as the change in log₂(Q). Doubling adds log₂(2) = 1 to the vertical value, so the time is 1 ÷ 0.25 = 4.

**N-2.15-B-v3.** A semi-log plot of log₁₀(C) against time in years for an invasive plant's coverage is a straight line with slope 0.12. Using log₁₀(3) ≈ 0.477, about how many years does it take to triple?

- A. 0.25
- B. 8.3
- C. 25.0
- **D. 4.0**

Check: The vertical value must rise by log₁₀(3) ≈ 0.477. At 0.12 per year, the time is 0.477/0.12 ≈ 4.0 years.
Rationales: A: This divides the slope by 0.477, which is the reverse of the needed quotient. The time is the required change in the log, 0.477, divided by the slope 0.12. B: This divides 1 by the slope, which would give the time for a tenfold increase. Tripling adds log₁₀(3) ≈ 0.477 to the vertical value, not 1. C: This divides 3 by the slope, using the factor 3 as if it were the change in the logarithm. The required change is log₁₀(3) ≈ 0.477.

---
