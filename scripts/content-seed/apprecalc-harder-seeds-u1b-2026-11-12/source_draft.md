# AP Precalculus Unit 1, topics 1.8 to 1.14: harder new seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every key and distractor value was recomputed in Python (exact fractions) while writing.
Scope: topics 1.8 to 1.14 only (1.1 to 1.7 are covered by another author). Two new seeds per topic, each with three variants, written at R3 level (multi-step reasoning, interpretation, error analysis). Seed A and Seed B of a topic test different skills; none reuses the stems or skills of the existing published items.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.8-A | 1.8 Rational Functions and Zeros | new: find the sum of the real zeros of a rational function after recognizing that a numerator zero shared with the denominator is a hole, and that a quadratic denominator factor adds no real roots |
| N-1.8-B | 1.8 Rational Functions and Zeros | new: find where the difference of two rational expressions is zero by clearing denominators and distributing correctly, then check the value is allowed |
| N-1.9-A | 1.9 Rational Functions and Vertical Asymptotes | new: describe the unbounded behavior of a rational function at a vertical asymptote from an even-multiplicity factor and at one from an odd-multiplicity factor, using signs of the remaining factors |
| N-1.9-B | 1.9 Rational Functions and Vertical Asymptotes | new: determine the parameter values that make a vertical asymptote disappear (become a hole) so the graph has exactly one asymptote, and combine them |
| N-1.10-A | 1.10 Rational Functions and Holes | new: locate the hole of a rational function given in expanded form by factoring, cancelling the common factor, and finding the height from the reduced function |
| N-1.10-B | 1.10 Rational Functions and Holes | new: choose the rule of a rational function from its hole, asymptote and intercept, using the hole height to set the leading constant |
| N-1.11-A | 1.11 Equivalent Representations | new: work backward from an equivalent quotient-plus-remainder form to the polynomial numerator and combine its coefficients |
| N-1.11-B | 1.11 Equivalent Representations | new: factor a cubic numerator by grouping to see that a rational function equals a line with holes, and find the holes' heights from the simplified form |
| N-1.12-A | 1.12 Transformations of Functions | new: find the image of a point under a combined horizontal and vertical transformation by solving the input rule for x and applying the output rule in order |
| N-1.12-B | 1.12 Transformations of Functions | new: determine how a combination of reflections and shifts changes the interval, the increasing/decreasing behavior and the concavity of a function |
| N-1.13-A | 1.13 Function Model Selection and Assumption Articulation | new: use repeated differences on equally spaced data to find the lowest degree of a polynomial that fits exactly, rather than stopping early or using the number of points |
| N-1.13-B | 1.13 Function Model Selection and Assumption Articulation | new: decide the valid input interval for a quadratic model in context by finding where the output stops being meaningful, not using the vertex or both zeros |
| N-1.14-A | 1.14 Function Model Construction and Application | new: build a quadratic model from its vertex and one other point, find the stretch factor, and use the model to make a prediction |
| N-1.14-B | 1.14 Function Model Construction and Application | new: construct an average-cost model with a fixed amount and a per-person amount, solve an inequality for the number of people, and round to a whole number correctly |

---

## Seed N-1.8-A (new) — Topic 1.8 Rational Functions and Zeros
**Skill:** find the sum of the real zeros of a rational function after recognizing that a numerator zero shared with the denominator is a hole, and that a quadratic denominator factor adds no real roots.

Consider the rational function f(x) = (x − 4)(x + 2)(x + 5) / [(x + 2)(x² + 9)] for real x in its domain. What is the sum of all real zeros of f?

- **A. −1**
- B. −3
- C. 1
- D. −20

Check: The factor (x + 2) cancels, so the numerator zero x = −2 is a hole, not a zero; x² + 9 has no real roots. The zeros are x = 4 and x = −5, with sum −1.
Rationales: B: This adds every zero of the numerator, 4, −2 and −5. But x = −2 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero. C: This reads each factor with the wrong sign, taking (x − 4) to mean x = −4 and so on. The factor (x − 4) is zero when x = 4, so the zeros are 4 and −5. D: This multiplies the zeros 4 and −5 instead of adding them, giving −20. The question asks for their sum, which is −1.

**N-1.8-A-v1.** A signal model is f(x) = (x − 6)(x + 1)(x + 4) / [(x + 1)(x² + 2)] for real x in its domain. What is the sum of all real zeros of f?

- A. 1
- **B. 2**
- C. −2
- D. −24

Check: The factor (x + 1) cancels, so the numerator zero x = −1 is a hole, not a zero; x² + 2 has no real roots. The zeros are x = 6 and x = −4, with sum 2.
Rationales: A: This adds every zero of the numerator, 6, −1 and −4. But x = −1 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero. C: This reads each factor with the wrong sign, taking (x − 6) to mean x = −6 and so on. The factor (x − 6) is zero when x = 6, so the zeros are 6 and −4. D: This multiplies the zeros 6 and −4 instead of adding them, giving −24. The question asks for their sum, which is 2.

**N-1.8-A-v2.** Let f(x) = (x + 2)(x − 3)(x − 7) / [(x − 3)(x² + 5)] for real x in its domain. What is the sum of all real zeros of f?

- A. 8
- B. −5
- **C. 5**
- D. −14

Check: The factor (x − 3) cancels, so the numerator zero x = 3 is a hole, not a zero; x² + 5 has no real roots. The zeros are x = −2 and x = 7, with sum 5.
Rationales: A: This adds every zero of the numerator, −2, 3 and 7. But x = 3 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero. B: This reads each factor with the wrong sign, taking (x + 2) to mean x = 2 and so on. The factor (x + 2) is zero when x = −2, so the zeros are −2 and 7. D: This multiplies the zeros −2 and 7 instead of adding them, giving −14. The question asks for their sum, which is 5.

**N-1.8-A-v3.** A rational model is f(x) = (x − 1)(x + 6)(x + 3) / [(x + 6)(x² + 8)] for real x in its domain. What is the sum of all real zeros of f?

- A. −8
- B. 2
- C. −3
- **D. −2**

Check: The factor (x + 6) cancels, so the numerator zero x = −6 is a hole, not a zero; x² + 8 has no real roots. The zeros are x = 1 and x = −3, with sum −2.
Rationales: A: This adds every zero of the numerator, 1, −6 and −3. But x = −6 makes the denominator zero as well, so f is undefined there and it is a hole rather than a zero. B: This reads each factor with the wrong sign, taking (x − 1) to mean x = −1 and so on. The factor (x − 1) is zero when x = 1, so the zeros are 1 and −3. C: This multiplies the zeros 1 and −3 instead of adding them, giving −3. The question asks for their sum, which is −2.

---

## Seed N-1.8-B (new) — Topic 1.8 Rational Functions and Zeros
**Skill:** find where the difference of two rational expressions is zero by clearing denominators and distributing correctly, then check the value is allowed.

Let g(x) = 2/(x − 1) − 3/(x + 2). For which value of x is g(x) = 0?

- A. −8
- **B. 7**
- C. −1/5
- D. 3

Check: Setting 2/(x − 1) = 3/(x + 2) and cross-multiplying gives 2(x + 2) = 3(x − 1), so x = (2·(−2) − 3·1)/(2 − 3) = 7, which is not 1 or −2, so it is allowed.
Rationales: A: This pairs each numerator with its own denominator when cross-multiplying, writing 2(x − 1) = 3(x + 2). Clearing fractions requires 2 times the other denominator, (x + 2), on the left side. C: This changes the sign on 3 when clearing denominators, as if the equation were 2/(x − 1) + 3/(x + 2) = 0. The equation is a difference, so the two fractions must be equal. D: This forgets to distribute 2 and 3 across the factors, writing 2x + 2 = 3x − 1. Each constant must multiply the whole factor, giving 7.

**N-1.8-B-v1.** The net rate of two processes is modeled by g(x) = 3/(x + 1) − 4/(x − 2). For which value of x is g(x) = 0?

- **A. −10**
- B. 11
- C. 2/7
- D. −3

Check: Setting 3/(x + 1) = 4/(x − 2) and cross-multiplying gives 3(x − 2) = 4(x + 1), so x = (3·2 − 4·(−1))/(3 − 4) = −10, which is not −1 or 2, so it is allowed.
Rationales: B: This pairs each numerator with its own denominator when cross-multiplying, writing 3(x + 1) = 4(x − 2). Clearing fractions requires 3 times the other denominator, (x − 2), on the left side. C: This changes the sign on 4 when clearing denominators, as if the equation were 3/(x + 1) + 4/(x − 2) = 0. The equation is a difference, so the two fractions must be equal. D: This forgets to distribute 3 and 4 across the factors, writing 3x − 2 = 4x + 1. Each constant must multiply the whole factor, giving −10.

**N-1.8-B-v2.** Consider g(x) = 5/(x − 2) − 2/(x + 3). For which value of x is g(x) = 0?

- A. 16/3
- B. −11/7
- **C. −19/3**
- D. −5/3

Check: Setting 5/(x − 2) = 2/(x + 3) and cross-multiplying gives 5(x + 3) = 2(x − 2), so x = (5·(−3) − 2·2)/(5 − 2) = −19/3, which is not 2 or −3, so it is allowed.
Rationales: A: This pairs each numerator with its own denominator when cross-multiplying, writing 5(x − 2) = 2(x + 3). Clearing fractions requires 5 times the other denominator, (x + 3), on the left side. B: This changes the sign on 2 when clearing denominators, as if the equation were 5/(x − 2) + 2/(x + 3) = 0. The equation is a difference, so the two fractions must be equal. D: This forgets to distribute 5 and 2 across the factors, writing 5x + 3 = 2x − 2. Each constant must multiply the whole factor, giving −19/3.

**N-1.8-B-v3.** A difference of two rates is g(x) = 4/(x − 3) − 6/(x + 1). For which value of x is g(x) = 0?

- A. −9
- B. 7/5
- C. 2
- **D. 11**

Check: Setting 4/(x − 3) = 6/(x + 1) and cross-multiplying gives 4(x + 1) = 6(x − 3), so x = (4·(−1) − 6·3)/(4 − 6) = 11, which is not 3 or −1, so it is allowed.
Rationales: A: This pairs each numerator with its own denominator when cross-multiplying, writing 4(x − 3) = 6(x + 1). Clearing fractions requires 4 times the other denominator, (x + 1), on the left side. B: This changes the sign on 6 when clearing denominators, as if the equation were 4/(x − 3) + 6/(x + 1) = 0. The equation is a difference, so the two fractions must be equal. C: This forgets to distribute 4 and 6 across the factors, writing 4x + 1 = 6x − 3. Each constant must multiply the whole factor, giving 11.

---

## Seed N-1.9-A (new) — Topic 1.9 Rational Functions and Vertical Asymptotes
**Skill:** describe the unbounded behavior of a rational function at a vertical asymptote from an even-multiplicity factor and at one from an odd-multiplicity factor, using signs of the remaining factors.

Let f(x) = (x − 1)/[(x + 2)²(x − 3)]. Which statement correctly describes the graph of f near its two vertical asymptotes?

- **A. f(x) → ∞ as x → −2 from either side, and f(x) → −∞ as x → 3 from the left**
- B. f(x) → −∞ as x → −2 from either side, and f(x) → −∞ as x → 3 from the left
- C. f(x) → ∞ as x → −2 from either side, and f(x) → ∞ as x → 3 from the left
- D. f(x) → −∞ as x → −2 from either side, and f(x) → ∞ as x → 3 from the left

Check: Near x = −2: the squared factor is positive, and the other factors have the sign of (−2 − 1)/(−2 − 3) = −3/−5, which is positive, so f → ∞ from both sides. Near x = 3 from the left: numerator sign +, squared factor +, and (x − 3) is negative, so f → −∞.
Rationales: B: This treats the squared factor as if it changed sign across x = −2, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → ∞. C: This gives the right behavior at x = −2 but takes the sign on the wrong side of x = 3. The factor (x − 3) is negative on the left, which makes f → −∞ there. D: This reverses the sign of f at both asymptotes, as if the numerator (x − 1) were evaluated with the wrong sign. At x = −2 the sign is positive and just left of x = 3 it is negative.

**N-1.9-A-v1.** Consider f(x) = (x + 4)/[(x − 2)²(x + 1)]. Which statement correctly describes the graph of f near its two vertical asymptotes?

- A. f(x) → −∞ as x → 2 from either side, and f(x) → ∞ as x → −1 from the right
- B. f(x) → ∞ as x → 2 from either side, and f(x) → −∞ as x → −1 from the right
- C. f(x) → −∞ as x → 2 from either side, and f(x) → −∞ as x → −1 from the right
- **D. f(x) → ∞ as x → 2 from either side, and f(x) → ∞ as x → −1 from the right**

Check: Near x = 2: the squared factor is positive, and the other factors have the sign of (2 − (−4))/(2 − (−1)) = 6/3, which is positive, so f → ∞ from both sides. Near x = −1 from the right: numerator sign +, squared factor +, and (x + 1) is positive, so f → ∞.
Rationales: A: This treats the squared factor as if it changed sign across x = 2, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → ∞. B: This gives the right behavior at x = 2 but takes the sign on the wrong side of x = −1. The factor (x + 1) is positive on the right, which makes f → ∞ there. C: This reverses the sign of f at both asymptotes, as if the numerator (x + 4) were evaluated with the wrong sign. At x = 2 the sign is positive and just right of x = −1 it is positive.

**N-1.9-A-v2.** Let f(x) = (x − 5)/[(x − 1)²(x + 3)]. Which statement correctly describes the graph of f near its two vertical asymptotes?

- A. f(x) → ∞ as x → 1 from either side, and f(x) → ∞ as x → −3 from the left
- B. f(x) → −∞ as x → 1 from either side, and f(x) → −∞ as x → −3 from the left
- **C. f(x) → −∞ as x → 1 from either side, and f(x) → ∞ as x → −3 from the left**
- D. f(x) → ∞ as x → 1 from either side, and f(x) → −∞ as x → −3 from the left

Check: Near x = 1: the squared factor is positive, and the other factors have the sign of (1 − 5)/(1 − (−3)) = −4/4, which is negative, so f → −∞ from both sides. Near x = −3 from the left: numerator sign −, squared factor +, and (x + 3) is negative, so f → ∞.
Rationales: A: This treats the squared factor as if it changed sign across x = 1, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → −∞. B: This gives the right behavior at x = 1 but takes the sign on the wrong side of x = −3. The factor (x + 3) is negative on the left, which makes f → ∞ there. D: This reverses the sign of f at both asymptotes, as if the numerator (x − 5) were evaluated with the wrong sign. At x = 1 the sign is negative and just left of x = −3 it is positive.

**N-1.9-A-v3.** Consider the rational function f(x) = (x + 2)/[(x − 4)²(x − 1)]. Which statement correctly describes the graph of f near its two vertical asymptotes?

- A. f(x) → −∞ as x → 4 from either side, and f(x) → ∞ as x → 1 from the right
- **B. f(x) → ∞ as x → 4 from either side, and f(x) → ∞ as x → 1 from the right**
- C. f(x) → ∞ as x → 4 from either side, and f(x) → −∞ as x → 1 from the right
- D. f(x) → −∞ as x → 4 from either side, and f(x) → −∞ as x → 1 from the right

Check: Near x = 4: the squared factor is positive, and the other factors have the sign of (4 − (−2))/(4 − 1) = 6/3, which is positive, so f → ∞ from both sides. Near x = 1 from the right: numerator sign +, squared factor +, and (x − 1) is positive, so f → ∞.
Rationales: A: This treats the squared factor as if it changed sign across x = 4, so the sign at that asymptote is reversed. A squared factor is positive on both sides, so the sign there is set by the remaining factors and f → ∞. C: This gives the right behavior at x = 4 but takes the sign on the wrong side of x = 1. The factor (x − 1) is positive on the right, which makes f → ∞ there. D: This reverses the sign of f at both asymptotes, as if the numerator (x + 2) were evaluated with the wrong sign. At x = 4 the sign is positive and just right of x = 1 it is positive.

---

## Seed N-1.9-B (new) — Topic 1.9 Rational Functions and Vertical Asymptotes
**Skill:** determine the parameter values that make a vertical asymptote disappear (become a hole) so the graph has exactly one asymptote, and combine them.

For a real constant k, let f(x) = (x² + kx − 12)/(x² − x − 6). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?

- A. −4
- B. 1
- **C. −3**
- D. 3

Check: The denominator is (x − 3)(x + 2). Exactly one asymptote needs the numerator to vanish at x = 3 (k = 1) or at x = −2 (k = −4), but the numerator cannot vanish at both. The sum is −3.
Rationales: A: This multiplies the two valid values 1 and −4 instead of adding them. The question asks for their sum, which is −3. B: This finds only one of the two values of k, the larger one, 1. Cancelling the factor at x = 3 and cancelling the factor at x = −2 each give a different valid k, and both must be included. D: This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 3 and x = −2 gives k = 1 and k = −4, whose sum is −3.

**N-1.9-B-v1.** For a real constant k, let f(x) = (x² + kx + 6)/(x² + 4x − 12). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?

- A. −35
- B. 7
- C. −2
- **D. 2**

Check: The denominator is (x − 2)(x + 6). Exactly one asymptote needs the numerator to vanish at x = 2 (k = −5) or at x = −6 (k = 7), but the numerator cannot vanish at both. The sum is 2.
Rationales: A: This multiplies the two valid values −5 and 7 instead of adding them. The question asks for their sum, which is 2. B: This finds only one of the two values of k, the larger one, 7. Cancelling the factor at x = 2 and cancelling the factor at x = −6 each give a different valid k, and both must be included. C: This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 2 and x = −6 gives k = −5 and k = 7, whose sum is 2.

**N-1.9-B-v2.** For a real constant k, let f(x) = (x² + kx − 40)/(x² + 4x − 32). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?

- **A. 9**
- B. 18
- C. 6
- D. −9

Check: The denominator is (x − 4)(x + 8). Exactly one asymptote needs the numerator to vanish at x = 4 (k = 6) or at x = −8 (k = 3), but the numerator cannot vanish at both. The sum is 9.
Rationales: B: This multiplies the two valid values 6 and 3 instead of adding them. The question asks for their sum, which is 9. C: This finds only one of the two values of k, the larger one, 6. Cancelling the factor at x = 4 and cancelling the factor at x = −8 each give a different valid k, and both must be included. D: This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 4 and x = −8 gives k = 6 and k = 3, whose sum is 9.

**N-1.9-B-v3.** For a real constant k, let f(x) = (x² + kx − 24)/(x² − 3x − 18). What is the sum of all values of k for which the graph of f has exactly one vertical asymptote?

- A. 10
- **B. −7**
- C. −2
- D. 7

Check: The denominator is (x − 6)(x + 3). Exactly one asymptote needs the numerator to vanish at x = 6 (k = −2) or at x = −3 (k = −5), but the numerator cannot vanish at both. The sum is −7.
Rationales: A: This multiplies the two valid values −2 and −5 instead of adding them. The question asks for their sum, which is −7. C: This finds only one of the two values of k, the larger one, −2. Cancelling the factor at x = 6 and cancelling the factor at x = −3 each give a different valid k, and both must be included. D: This finds both values of k but then reports the opposite of their sum. Requiring the numerator to be zero at x = 6 and x = −3 gives k = −2 and k = −5, whose sum is −7.

---

## Seed N-1.10-A (new) — Topic 1.10 Rational Functions and Holes
**Skill:** locate the hole of a rational function given in expanded form by factoring, cancelling the common factor, and finding the height from the reduced function.

Let f(x) = (x² − 2x − 15)/(x² − 4x − 5). Which ordered pair is the location of the hole in the graph of f?

- A. (5, 0)
- **B. (5, 4/3)**
- C. (5, 3/4)
- D. (−1, 4/3)

Check: Factoring gives f(x) = (x − 5)(x + 3)/[(x − 5)(x + 1)], so the common factor (x − 5) produces a hole at x = 5. The reduced function (x + 3)/(x + 1) at x = 5 equals 4/3.
Rationales: A: This notices the hole at x = 5 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x + 3) is not zero at x = 5; the height is 4/3. C: This evaluates the reduced function upside down, using (5 − (−1))/(5 − (−3)). The numerator of the reduced function is (x + 3) and the denominator is (x + 1), so the height is 4/3. D: This puts the hole at the zero of the leftover denominator factor, x = −1. That factor is not cancelled, so x = −1 is a vertical asymptote; the hole is where the common factor (x − 5) is zero, at x = 5.

**N-1.10-A-v1.** Consider f(x) = (x² − 8x + 12)/(x² + 2x − 8). Which ordered pair is the location of the hole in the graph of f?

- A. (2, 0)
- B. (2, −3/2)
- C. (−4, −2/3)
- **D. (2, −2/3)**

Check: Factoring gives f(x) = (x − 2)(x − 6)/[(x − 2)(x + 4)], so the common factor (x − 2) produces a hole at x = 2. The reduced function (x − 6)/(x + 4) at x = 2 equals −2/3.
Rationales: A: This notices the hole at x = 2 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x − 6) is not zero at x = 2; the height is −2/3. B: This evaluates the reduced function upside down, using (2 − (−4))/(2 − 6). The numerator of the reduced function is (x − 6) and the denominator is (x + 4), so the height is −2/3. C: This puts the hole at the zero of the leftover denominator factor, x = −4. That factor is not cancelled, so x = −4 is a vertical asymptote; the hole is where the common factor (x − 2) is zero, at x = 2.

**N-1.10-A-v2.** Let f(x) = (x² + 2x − 3)/(x² − x − 12). Which ordered pair is the location of the hole in the graph of f?

- **A. (−3, 4/7)**
- B. (−3, 0)
- C. (−3, 7/4)
- D. (4, 4/7)

Check: Factoring gives f(x) = (x + 3)(x − 1)/[(x + 3)(x − 4)], so the common factor (x + 3) produces a hole at x = −3. The reduced function (x − 1)/(x − 4) at x = −3 equals 4/7.
Rationales: B: This notices the hole at x = −3 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x − 1) is not zero at x = −3; the height is 4/7. C: This evaluates the reduced function upside down, using (−3 − 4)/(−3 − 1). The numerator of the reduced function is (x − 1) and the denominator is (x − 4), so the height is 4/7. D: This puts the hole at the zero of the leftover denominator factor, x = 4. That factor is not cancelled, so x = 4 is a vertical asymptote; the hole is where the common factor (x + 3) is zero, at x = −3.

**N-1.10-A-v3.** Consider f(x) = (x² − 2x − 8)/(x² − 11x + 28). Which ordered pair is the location of the hole in the graph of f?

- A. (4, 0)
- B. (4, −1/2)
- **C. (4, −2)**
- D. (7, −2)

Check: Factoring gives f(x) = (x − 4)(x + 2)/[(x − 4)(x − 7)], so the common factor (x − 4) produces a hole at x = 4. The reduced function (x + 2)/(x − 7) at x = 4 equals −2.
Rationales: A: This notices the hole at x = 4 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x + 2) is not zero at x = 4; the height is −2. B: This evaluates the reduced function upside down, using (4 − 7)/(4 − (−2)). The numerator of the reduced function is (x + 2) and the denominator is (x − 7), so the height is −2. D: This puts the hole at the zero of the leftover denominator factor, x = 7. That factor is not cancelled, so x = 7 is a vertical asymptote; the hole is where the common factor (x − 4) is zero, at x = 4.

---

## Seed N-1.10-B (new) — Topic 1.10 Rational Functions and Holes
**Skill:** choose the rule of a rational function from its hole, asymptote and intercept, using the hole height to set the leading constant.

A rational function f has a hole at (3, −8), a vertical asymptote at x = 4, and exactly one x-intercept, at x = −1. It has no other features. Which rule could define f?

- A. f(x) = −8(x − 3)(x + 1) / [(x − 3)(x − 4)]
- B. f(x) = 2(x + 1) / (x − 4)
- C. f(x) = 2(x − 3)(x + 1) / [(x − 3)(x + 4)]
- **D. f(x) = 2(x − 3)(x + 1) / [(x − 3)(x − 4)]**

Check: The factor (x − 3) in both numerator and denominator makes the hole at x = 3, (x + 1) gives the intercept, and (x − 4) gives the asymptote. The hole height is 2(3 − (−1))/(3 − 4) = −8, which fixes the leading constant at 2.
Rationales: A: This sets the leading constant equal to the hole height −8. The hole height is that constant times (3 − (−1))/(3 − 4), so the constant needed is 2, not −8. B: This drops the common factor (x − 3). Without it the graph has no hole at x = 3, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator. C: This writes the asymptote factor as (x + 4), which puts the vertical asymptote at x = −4. An asymptote at x = 4 needs the factor (x − 4), and the cancelled factor (x − 3) still has to appear above and below.

**N-1.10-B-v1.** A rational function f has a hole at (2, 3), a vertical asymptote at x = −2, and exactly one x-intercept, at x = 6. It has no other features. Which rule could define f?

- A. f(x) = 3(x − 2)(x − 6) / [(x − 2)(x + 2)]
- **B. f(x) = −3(x − 2)(x − 6) / [(x − 2)(x + 2)]**
- C. f(x) = −3(x − 6) / (x + 2)
- D. f(x) = −3(x − 2)(x − 6) / [(x − 2)(x − 2)]

Check: The factor (x − 2) in both numerator and denominator makes the hole at x = 2, (x − 6) gives the intercept, and (x + 2) gives the asymptote. The hole height is −3(2 − 6)/(2 − (−2)) = 3, which fixes the leading constant at −3.
Rationales: A: This sets the leading constant equal to the hole height 3. The hole height is that constant times (2 − 6)/(2 − (−2)), so the constant needed is −3, not 3. C: This drops the common factor (x − 2). Without it the graph has no hole at x = 2, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator. D: This writes the asymptote factor as (x − 2), which puts the vertical asymptote at x = 2. An asymptote at x = −2 needs the factor (x + 2), and the cancelled factor (x − 2) still has to appear above and below.

**N-1.10-B-v2.** A rational function f has a hole at (−1, 2), a vertical asymptote at x = 5, and exactly one x-intercept, at x = 2. It has no other features. Which rule could define f?

- A. f(x) = 2(x + 1)(x − 2) / [(x + 1)(x − 5)]
- B. f(x) = 4(x − 2) / (x − 5)
- **C. f(x) = 4(x + 1)(x − 2) / [(x + 1)(x − 5)]**
- D. f(x) = 4(x + 1)(x − 2) / [(x + 1)(x + 5)]

Check: The factor (x + 1) in both numerator and denominator makes the hole at x = −1, (x − 2) gives the intercept, and (x − 5) gives the asymptote. The hole height is 4(−1 − 2)/(−1 − 5) = 2, which fixes the leading constant at 4.
Rationales: A: This sets the leading constant equal to the hole height 2. The hole height is that constant times (−1 − 2)/(−1 − 5), so the constant needed is 4, not 2. B: This drops the common factor (x + 1). Without it the graph has no hole at x = −1, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator. D: This writes the asymptote factor as (x + 5), which puts the vertical asymptote at x = −5. An asymptote at x = 5 needs the factor (x − 5), and the cancelled factor (x + 1) still has to appear above and below.

**N-1.10-B-v3.** A rational function f has a hole at (5, 21/4), a vertical asymptote at x = 1, and exactly one x-intercept, at x = −2. It has no other features. Which rule could define f?

- **A. f(x) = 3(x − 5)(x + 2) / [(x − 5)(x − 1)]**
- B. f(x) = (21/4)(x − 5)(x + 2) / [(x − 5)(x − 1)]
- C. f(x) = 3(x + 2) / (x − 1)
- D. f(x) = 3(x − 5)(x + 2) / [(x − 5)(x + 1)]

Check: The factor (x − 5) in both numerator and denominator makes the hole at x = 5, (x + 2) gives the intercept, and (x − 1) gives the asymptote. The hole height is 3(5 − (−2))/(5 − 1) = 21/4, which fixes the leading constant at 3.
Rationales: B: This sets the leading constant equal to the hole height 21/4. The hole height is that constant times (5 − (−2))/(5 − 1), so the constant needed is 3, not 21/4. C: This drops the common factor (x − 5). Without it the graph has no hole at x = 5, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator. D: This writes the asymptote factor as (x + 1), which puts the vertical asymptote at x = −1. An asymptote at x = 1 needs the factor (x − 1), and the cancelled factor (x − 5) still has to appear above and below.

---

## Seed N-1.11-A (new) — Topic 1.11 Equivalent Representations
**Skill:** work backward from an equivalent quotient-plus-remainder form to the polynomial numerator and combine its coefficients.

For x ≠ 2, the expression (x² + bx + c)/(x − 2) is equivalent to x + 3 + 4/(x − 2), where b and c are constants. What is the value of b + c?

- A. 15
- **B. −1**
- C. −5
- D. −9

Check: Multiply by (x − 2): x² + bx + c = (x + 3)(x − 2) + 4 = x² + x − 2. So b = 1, c = −2, and b + c = −1.
Rationales: A: This expands (x + 3)(x + 2) + 4, using the wrong sign on the divisor's constant. The divisor is (x − 2), so the product to expand is (x + 3)(x − 2) + 4. C: This multiplies the quotient by the divisor but leaves out the remainder term 4. The remainder over (x − 2) is part of the expression, so it must be added to the constant term, which gives c = −2. D: This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains + 4/(x − 2), the product must be adjusted by 4, making c = −2.

**N-1.11-A-v1.** For x ≠ 3, the expression (x² + bx + c)/(x − 3) is equivalent to x − 2 + 5/(x − 3), where b and c are constants. What is the value of b + c?

- **A. 6**
- B. 0
- C. 1
- D. −4

Check: Multiply by (x − 3): x² + bx + c = (x − 2)(x − 3) + 5 = x² − 5x + 11. So b = −5, c = 11, and b + c = 6.
Rationales: B: This expands (x − 2)(x + 3) + 5, using the wrong sign on the divisor's constant. The divisor is (x − 3), so the product to expand is (x − 2)(x − 3) + 5. C: This multiplies the quotient by the divisor but leaves out the remainder term 5. The remainder over (x − 3) is part of the expression, so it must be added to the constant term, which gives c = 11. D: This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains + 5/(x − 3), the product must be adjusted by 5, making c = 11.

**N-1.11-A-v2.** For x ≠ −1, the expression (x² + bx + c)/(x + 1) is equivalent to x + 4 + 7/(x + 1), where b and c are constants. What is the value of b + c?

- A. 6
- B. 9
- **C. 16**
- D. 2

Check: Multiply by (x + 1): x² + bx + c = (x + 4)(x + 1) + 7 = x² + 5x + 11. So b = 5, c = 11, and b + c = 16.
Rationales: A: This expands (x + 4)(x − 1) + 7, using the wrong sign on the divisor's constant. The divisor is (x + 1), so the product to expand is (x + 4)(x + 1) + 7. B: This multiplies the quotient by the divisor but leaves out the remainder term 7. The remainder over (x + 1) is part of the expression, so it must be added to the constant term, which gives c = 11. D: This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains + 7/(x + 1), the product must be adjusted by 7, making c = 11.

**N-1.11-A-v3.** For x ≠ 4, the expression (x² + bx + c)/(x − 4) is equivalent to x + 5 − 3/(x − 4), where b and c are constants. What is the value of b + c?

- A. 26
- B. −19
- C. −16
- **D. −22**

Check: Multiply by (x − 4): x² + bx + c = (x + 5)(x − 4) − 3 = x² + x − 23. So b = 1, c = −23, and b + c = −22.
Rationales: A: This expands (x + 5)(x + 4) − 3, using the wrong sign on the divisor's constant. The divisor is (x − 4), so the product to expand is (x + 5)(x − 4) − 3. B: This multiplies the quotient by the divisor but leaves out the remainder term 3. The remainder over (x − 4) is part of the expression, so it must be added to the constant term, which gives c = −23. C: This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains − 3/(x − 4), the product must be adjusted by −3, making c = −23.

---

## Seed N-1.11-B (new) — Topic 1.11 Equivalent Representations
**Skill:** factor a cubic numerator by grouping to see that a rational function equals a line with holes, and find the holes' heights from the simplified form.

Consider f(x) = (x³ + 2x² − 9x − 18)/(x² − 9). Which statement correctly describes the graph of f?

- A. It is the line y = x + 2 with vertical asymptotes at x = 3 and x = −3.
- **B. It is the line y = x + 2 with holes at (3, 5) and (−3, −1).**
- C. It is the line y = x + 2 with holes at (3, 1) and (−3, −5).
- D. It is the line y = x + 2 with no breaks, so f is defined for every real x.

Check: Grouping gives x³ + 2x² − 9x − 18 = (x + 2)(x² − 9), so f(x) = x + 2 for x ≠ ±3. The cancelled factors give holes at heights 5 and −1.
Rationales: A: This treats the zeros of the denominator as vertical asymptotes. The factor x² − 9 also appears in the numerator and cancels, so those x-values are holes, not asymptotes. C: This finds the holes at the right x-values but computes their heights using the wrong sign on 2. Substituting x = 3 and x = −3 into x + 2 gives 5 and −1. D: This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 3 and x = −3, so the line has a hole at each of those values.

**N-1.11-B-v1.** Let f(x) = (x³ − x² − 16x + 16)/(x² − 16). Which statement correctly describes the graph of f?

- A. It is the line y = x − 1 with vertical asymptotes at x = 4 and x = −4.
- B. It is the line y = x − 1 with holes at (4, 5) and (−4, −3).
- C. It is the line y = x − 1 with no breaks, so f is defined for every real x.
- **D. It is the line y = x − 1 with holes at (4, 3) and (−4, −5).**

Check: Grouping gives x³ − x² − 16x + 16 = (x − 1)(x² − 16), so f(x) = x − 1 for x ≠ ±4. The cancelled factors give holes at heights 3 and −5.
Rationales: A: This treats the zeros of the denominator as vertical asymptotes. The factor x² − 16 also appears in the numerator and cancels, so those x-values are holes, not asymptotes. B: This finds the holes at the right x-values but computes their heights using the wrong sign on 1. Substituting x = 4 and x = −4 into x − 1 gives 3 and −5. C: This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 4 and x = −4, so the line has a hole at each of those values.

**N-1.11-B-v2.** Let f(x) = (x³ + 3x² − 4x − 12)/(x² − 4). Which statement correctly describes the graph of f?

- A. It is the line y = x + 3 with vertical asymptotes at x = 2 and x = −2.
- B. It is the line y = x + 3 with holes at (2, −1) and (−2, −5).
- **C. It is the line y = x + 3 with holes at (2, 5) and (−2, 1).**
- D. It is the line y = x + 3 with no breaks, so f is defined for every real x.

Check: Grouping gives x³ + 3x² − 4x − 12 = (x + 3)(x² − 4), so f(x) = x + 3 for x ≠ ±2. The cancelled factors give holes at heights 5 and 1.
Rationales: A: This treats the zeros of the denominator as vertical asymptotes. The factor x² − 4 also appears in the numerator and cancels, so those x-values are holes, not asymptotes. B: This finds the holes at the right x-values but computes their heights using the wrong sign on 3. Substituting x = 2 and x = −2 into x + 3 gives 5 and 1. D: This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 2 and x = −2, so the line has a hole at each of those values.

**N-1.11-B-v3.** Consider f(x) = (x³ − 2x² − 25x + 50)/(x² − 25). Which statement correctly describes the graph of f?

- **A. It is the line y = x − 2 with holes at (5, 3) and (−5, −7).**
- B. It is the line y = x − 2 with vertical asymptotes at x = 5 and x = −5.
- C. It is the line y = x − 2 with holes at (5, 7) and (−5, −3).
- D. It is the line y = x − 2 with no breaks, so f is defined for every real x.

Check: Grouping gives x³ − 2x² − 25x + 50 = (x − 2)(x² − 25), so f(x) = x − 2 for x ≠ ±5. The cancelled factors give holes at heights 3 and −7.
Rationales: B: This treats the zeros of the denominator as vertical asymptotes. The factor x² − 25 also appears in the numerator and cancels, so those x-values are holes, not asymptotes. C: This finds the holes at the right x-values but computes their heights using the wrong sign on 2. Substituting x = 5 and x = −5 into x − 2 gives 3 and −7. D: This cancels the common factor and then forgets the original domain restriction. The original expression is undefined at x = 5 and x = −5, so the line has a hole at each of those values.

---

## Seed N-1.12-A (new) — Topic 1.12 Transformations of Functions
**Skill:** find the image of a point under a combined horizontal and vertical transformation by solving the input rule for x and applying the output rule in order.

The graph of a function f is shifted and stretched to produce another function. The graph of f contains the point (4, 4). The function g is defined by g(x) = −2f(3x − 5) + 1. Which point must lie on the graph of g?

- A. (7, −7)
- **B. (3, −7)**
- C. (−1/3, −7)
- D. (3, −10)

Check: A point on g needs 3x − 5 = 4, so x = (4 + 5)/3 = 3; the output is (−2)·4 + 1 = −7.
Rationales: A: This feeds 4 through the input rule, computing 3·4 − 5. The input of f is 3x − 5, so the x-coordinate of g is the x that makes 3x − 5 equal 4, namely 3. C: This adds −5 to 4 when undoing the input change, instead of subtracting it. Solving 3x − 5 = 4 for x gives 3. D: This applies the vertical shift before the vertical stretch, computing (−2)(4 + 1). The output rule multiplies f by −2 first and then adds 1, so the output is −7.

**N-1.12-A-v1.** Consider a function f and a function g that is built from it. The graph of f contains the point (5, −1). The function g is defined by g(x) = 3f(2x + 1) − 4. Which point must lie on the graph of g?

- A. (11, −7)
- B. (3, −7)
- **C. (2, −7)**
- D. (2, −15)

Check: A point on g needs 2x + 1 = 5, so x = (5 − 1)/2 = 2; the output is 3·(−1) − 4 = −7.
Rationales: A: This feeds 5 through the input rule, computing 2·5 + 1. The input of f is 2x + 1, so the x-coordinate of g is the x that makes 2x + 1 equal 5, namely 2. B: This adds 1 to 5 when undoing the input change, instead of subtracting it. Solving 2x + 1 = 5 for x gives 2. D: This applies the vertical shift before the vertical stretch, computing 3(−1 − 4). The output rule multiplies f by 3 first and then adds −4, so the output is −7.

**N-1.12-A-v2.** A function f models a quantity, and g is a transformed version of it. The graph of f contains the point (6, 3). The function g is defined by g(x) = −f(4x − 6) + 5. Which point must lie on the graph of g?

- A. (18, 2)
- B. (0, 2)
- C. (3, −8)
- **D. (3, 2)**

Check: A point on g needs 4x − 6 = 6, so x = (6 + 6)/4 = 3; the output is (−1)·3 + 5 = 2.
Rationales: A: This feeds 6 through the input rule, computing 4·6 − 6. The input of f is 4x − 6, so the x-coordinate of g is the x that makes 4x − 6 equal 6, namely 3. B: This adds −6 to 6 when undoing the input change, instead of subtracting it. Solving 4x − 6 = 6 for x gives 3. C: This applies the vertical shift before the vertical stretch, computing (−1)(3 + 5). The output rule multiplies f by −1 first and then adds 5, so the output is 2.

**N-1.12-A-v3.** Let f be a function and let g be defined from f. The graph of f contains the point (−1, 5). The function g is defined by g(x) = 2f(−2x + 3) + 4. Which point must lie on the graph of g?

- **A. (2, 14)**
- B. (5, 14)
- C. (−1, 14)
- D. (2, 18)

Check: A point on g needs −2x + 3 = −1, so x = (−1 − 3)/(−2) = 2; the output is 2·5 + 4 = 14.
Rationales: B: This feeds −1 through the input rule, computing (−2)·−1 + 3. The input of f is −2x + 3, so the x-coordinate of g is the x that makes −2x + 3 equal −1, namely 2. C: This adds 3 to −1 when undoing the input change, instead of subtracting it. Solving −2x + 3 = −1 for x gives 2. D: This applies the vertical shift before the vertical stretch, computing 2(5 + 4). The output rule multiplies f by 2 first and then adds 4, so the output is 14.

---

## Seed N-1.12-B (new) — Topic 1.12 Transformations of Functions
**Skill:** determine how a combination of reflections and shifts changes the interval, the increasing/decreasing behavior and the concavity of a function.

Let f and g be functions. The function f is increasing and concave down on the interval (1, 4). The function g is defined by g(x) = −f(x + 3) + 2. Which statement must be true?

- A. g is decreasing and concave up on the interval (4, 7).
- B. g is increasing and concave up on the interval (−2, 1).
- C. g is decreasing and concave down on the interval (−2, 1).
- **D. g is decreasing and concave up on the interval (−2, 1).**

Check: For f(…) on (1, 4) the input x + 3 must lie in (1, 4), so x lies in (−2, 1). There is one reflection (the negative sign in front of f), so g is decreasing; only the sign in front of f affects concavity, so g is concave up.
Rationales: A: This has the right behavior but the wrong interval. Solving x + 3 = 1 and x + 3 = 4 places the endpoints at −2 and 1, not 4 and 7. B: This gets the interval and concavity right but the wrong direction. The graph has one reflection (the negative sign in front of f), and each reflection reverses increasing and decreasing, so g is decreasing. C: This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is negative here, so g is concave up.

**N-1.12-B-v1.** Consider the function f and the function g built from it. The function f is decreasing and concave up on the interval (−2, 3). The function g is defined by g(x) = f(1 − x) + 4. Which statement must be true?

- **A. g is increasing and concave up on the interval (−2, 3).**
- B. g is increasing and concave up on the interval (−1, 4).
- C. g is decreasing and concave up on the interval (−2, 3).
- D. g is increasing and concave down on the interval (−2, 3).

Check: For f(…) on (−2, 3) the input 1 − x must lie in (−2, 3), so x lies in (−2, 3). There is one reflection (the negative sign on x inside f), so g is increasing; only the sign in front of f affects concavity, so g is concave up.
Rationales: B: This has the right behavior but the wrong interval. Solving 1 − x = −2 and 1 − x = 3 places the endpoints at −2 and 3, not −1 and 4. C: This gets the interval and concavity right but the wrong direction. The graph has one reflection (the negative sign on x inside f), and each reflection reverses increasing and decreasing, so g is increasing. D: This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is positive here, so g is concave up.

**N-1.12-B-v2.** A function f is given, and a related function g is defined. The function f is increasing and concave up on the interval (0, 5). The function g is defined by g(x) = −f(2 − x) − 1. Which statement must be true?

- A. g is increasing and concave down on the interval (2, 7).
- B. g is decreasing and concave down on the interval (−3, 2).
- **C. g is increasing and concave down on the interval (−3, 2).**
- D. g is increasing and concave up on the interval (−3, 2).

Check: For f(…) on (0, 5) the input 2 − x must lie in (0, 5), so x lies in (−3, 2). There are two reflections (the negative sign in front of f and the negative sign on x inside f), so g is increasing; only the sign in front of f affects concavity, so g is concave down.
Rationales: A: This has the right behavior but the wrong interval. Solving 2 − x = 0 and 2 − x = 5 places the endpoints at −3 and 2, not 2 and 7. B: This gets the interval and concavity right but the wrong direction. The graph has two reflections (the negative sign in front of f and the negative sign on x inside f), and each reflection reverses increasing and decreasing, so g is increasing. D: This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is negative here, so g is concave down.

**N-1.12-B-v3.** Let f be a function and let g be defined in terms of f. The function f is decreasing and concave down on the interval (2, 6). The function g is defined by g(x) = −f(x − 4). Which statement must be true?

- A. g is increasing and concave up on the interval (−2, 2).
- **B. g is increasing and concave up on the interval (6, 10).**
- C. g is decreasing and concave up on the interval (6, 10).
- D. g is increasing and concave down on the interval (6, 10).

Check: For f(…) on (2, 6) the input x − 4 must lie in (2, 6), so x lies in (6, 10). There is one reflection (the negative sign in front of f), so g is increasing; only the sign in front of f affects concavity, so g is concave up.
Rationales: A: This has the right behavior but the wrong interval. Solving x − 4 = 2 and x − 4 = 6 places the endpoints at 6 and 10, not −2 and 2. C: This gets the interval and concavity right but the wrong direction. The graph has one reflection (the negative sign in front of f), and each reflection reverses increasing and decreasing, so g is increasing. D: This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is negative here, so g is concave up.

---

## Seed N-1.13-A (new) — Topic 1.13 Function Model Selection and Assumption Articulation
**Skill:** use repeated differences on equally spaced data to find the lowest degree of a polynomial that fits exactly, rather than stopping early or using the number of points.

A data set from an experiment is recorded. A table gives outputs y for equally spaced inputs x = 0, 1, 2, 3, 4, 5: y = 7, 5, 5, 19, 59, 137. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?

- **A. a polynomial of degree 3**
- B. a polynomial of degree 2
- C. a polynomial of degree 5
- D. an exponential function, since the outputs keep growing in size

Check: Differences of the outputs taken 3 times are all equal to 12, while differences taken 2 times are not constant. So the lowest degree that fits all 6 points is 3.
Rationales: B: This stops one round of differences early. Taking differences 2 times does not give a constant list here, so the data cannot come from a degree 2 polynomial; the constant list appears after 3 rounds. C: This uses the fact that 6 points fit some polynomial of degree 5. The question asks for the lowest degree that fits exactly, and constant differences show that degree 3 is enough. D: This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 3 rounds.

**N-1.13-A-v1.** A technician records measurements. A table gives outputs y for equally spaced inputs x = 0, 1, 2, 3, 4, 5, 6: y = 3, 3, 23, 105, 315, 743, 1503. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?

- A. a polynomial of degree 3
- B. a polynomial of degree 6
- **C. a polynomial of degree 4**
- D. an exponential function, since the outputs keep growing in size

Check: Differences of the outputs taken 4 times are all equal to 24, while differences taken 3 times are not constant. So the lowest degree that fits all 7 points is 4.
Rationales: A: This stops one round of differences early. Taking differences 3 times does not give a constant list here, so the data cannot come from a degree 3 polynomial; the constant list appears after 4 rounds. B: This uses the fact that 7 points fit some polynomial of degree 6. The question asks for the lowest degree that fits exactly, and constant differences show that degree 4 is enough. D: This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 4 rounds.

**N-1.13-A-v2.** A sensor records values at equal steps. A table gives outputs y for equally spaced inputs x = 0, 2, 4, 6, 8, 10: y = −4, −12, −156, −580, −1428, −2844. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?

- A. a polynomial of degree 2
- **B. a polynomial of degree 3**
- C. a polynomial of degree 5
- D. an exponential function, since the outputs keep growing in size

Check: Differences of the outputs taken 3 times are all equal to −144, while differences taken 2 times are not constant. So the lowest degree that fits all 6 points is 3.
Rationales: A: This stops one round of differences early. Taking differences 2 times does not give a constant list here, so the data cannot come from a degree 2 polynomial; the constant list appears after 3 rounds. C: This uses the fact that 6 points fit some polynomial of degree 5. The question asks for the lowest degree that fits exactly, and constant differences show that degree 3 is enough. D: This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 3 rounds.

**N-1.13-A-v3.** A lab logs a quantity. A table gives outputs y for equally spaced inputs x = 0, 1, 2, 3, 4, 5, 6: y = 5, 4, 13, 68, 229, 580, 1229. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?

- A. a polynomial of degree 3
- B. a polynomial of degree 6
- C. an exponential function, since the outputs keep growing in size
- **D. a polynomial of degree 4**

Check: Differences of the outputs taken 4 times are all equal to 24, while differences taken 3 times are not constant. So the lowest degree that fits all 7 points is 4.
Rationales: A: This stops one round of differences early. Taking differences 3 times does not give a constant list here, so the data cannot come from a degree 3 polynomial; the constant list appears after 4 rounds. B: This uses the fact that 7 points fit some polynomial of degree 6. The question asks for the lowest degree that fits exactly, and constant differences show that degree 4 is enough. C: This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 4 rounds.

---

## Seed N-1.13-B (new) — Topic 1.13 Function Model Selection and Assumption Articulation
**Skill:** decide the valid input interval for a quadratic model in context by finding where the output stops being meaningful, not using the vertex or both zeros.

A model for the height h, in feet, of a ball is h(t) = −16t² + 24t + 16, where t is time in seconds after the ball is thrown, starting at t = 0. What is the most appropriate domain for this model in the context of the ball being in the air?

- A. all real numbers t
- B. 0 ≤ t ≤ 3/4
- C. −1/2 ≤ t ≤ 2
- **D. 0 ≤ t ≤ 2**

Check: Factoring gives −16(t + 1/2)(t − 2), so the zeros are −1/2 and 2. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 2.
Rationales: A: This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed seconds and the height cannot be negative, so the model only makes sense while its output stays at or above 0. B: This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 2. C: This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −1/2, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 2.

**N-1.13-B-v1.** A drone's altitude A, in meters, is modeled by A(t) = −8t² + 22t + 6, where t is the number of seconds after launch, starting at t = 0. What input interval is most appropriate for this model while the drone is in flight?

- **A. 0 ≤ t ≤ 3**
- B. all real numbers t
- C. 0 ≤ t ≤ 11/8
- D. −1/4 ≤ t ≤ 3

Check: Factoring gives −8(t + 1/4)(t − 3), so the zeros are −1/4 and 3. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 3.
Rationales: B: This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed seconds and the altitude cannot be negative, so the model only makes sense while its output stays at or above 0. C: This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 3. D: This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −1/4, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 3.

**N-1.13-B-v2.** The profit P, in dollars, from a school event is modeled by P(t) = −3t² + 15t + 18, where t is the number of weeks after tickets go on sale, starting at t = 0. For what interval of t does the model give meaningful, nonnegative profit?

- A. all real numbers t
- B. 0 ≤ t ≤ 5/2
- **C. 0 ≤ t ≤ 6**
- D. −1 ≤ t ≤ 6

Check: Factoring gives −3(t + 1)(t − 6), so the zeros are −1 and 6. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 6.
Rationales: A: This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed weeks and the profit cannot be negative, so the model only makes sense while its output stays at or above 0. B: This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 6. D: This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −1, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 6.

**N-1.13-B-v3.** The depth D, in centimeters, of water in a tank that is first filled and then drained is modeled by D(t) = −4t² + 10t + 24, where t is minutes after the process begins, starting at t = 0. Which input interval is most appropriate for this model?

- A. all real numbers t
- **B. 0 ≤ t ≤ 4**
- C. 0 ≤ t ≤ 5/4
- D. −3/2 ≤ t ≤ 4

Check: Factoring gives −4(t + 3/2)(t − 4), so the zeros are −3/2 and 4. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 4.
Rationales: A: This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed minutes and the depth cannot be negative, so the model only makes sense while its output stays at or above 0. C: This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 4. D: This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −3/2, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 4.

---

## Seed N-1.14-A (new) — Topic 1.14 Function Model Construction and Application
**Skill:** build a quadratic model from its vertex and one other point, find the stretch factor, and use the model to make a prediction.

A quadratic model P gives the height, in feet, of a thrown ball t seconds after release. The model has its maximum value of 20 feet at t = 3 seconds, and P(0) = 2 feet. What does the model predict for the height, in feet, at t = 5 seconds?

- A. 24
- B. −108
- C. −4
- **D. 12**

Check: Write P(t) = a(t − 3)² + 20. Using P(0) = 2: a·9 + 20 = 2, so a = −2. Then P(5) = −2·4 + 20 = 12.
Rationales: A: This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 2, which gives a = −2, so P(5) = 12. B: This uses (t + 3)², putting the vertex at t = −3. A vertex at t = 3 gives the factor (t − 3)², so the value at 5 is 12. C: This finds a by dividing by 3 instead of 3². At t = 0 the squared factor is (3)² = 9, so a = −2, and the prediction at 5 is 12.

**N-1.14-A-v1.** The daily profit P, in hundreds of dollars, of a food truck is modeled by a quadratic function of t, the hours after opening. The maximum profit of 18 occurs at t = 2, and P(0) = 6. What profit does the model predict at t = 3?

- **A. 15**
- B. 19
- C. −57
- D. 12

Check: Write P(t) = a(t − 2)² + 18. Using P(0) = 6: a·4 + 18 = 6, so a = −3. Then P(3) = −3·1 + 18 = 15.
Rationales: B: This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 6, which gives a = −3, so P(3) = 15. C: This uses (t + 2)², putting the vertex at t = −2. A vertex at t = 2 gives the factor (t − 2)², so the value at 3 is 15. D: This finds a by dividing by 2 instead of 2². At t = 0 the squared factor is (2)² = 4, so a = −3, and the prediction at 3 is 15.

**N-1.14-A-v2.** A diver's height P, in meters above the water, is modeled by a quadratic function of the time t in seconds. The highest point of 34 meters occurs at t = 4, and the diver leaves the board at t = 0 with P(0) = 2. What height does the model predict at t = 6?

- A. 38
- **B. 26**
- C. −166
- D. 2

Check: Write P(t) = a(t − 4)² + 34. Using P(0) = 2: a·16 + 34 = 2, so a = −2. Then P(6) = −2·4 + 34 = 26.
Rationales: A: This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 2, which gives a = −2, so P(6) = 26. C: This uses (t + 4)², putting the vertex at t = −4. A vertex at t = 4 gives the factor (t − 4)², so the value at 6 is 26. D: This finds a by dividing by 4 instead of 4². At t = 0 the squared factor is (4)² = 16, so a = −2, and the prediction at 6 is 26.

**N-1.14-A-v3.** A fountain jet's height P, in feet, is modeled by a quadratic function of the horizontal distance t in feet. The peak height of 30 feet occurs at t = 5, and P(0) = 5. What height does the model predict at horizontal distance t = 8?

- A. 39
- B. −139
- **C. 21**
- D. −15

Check: Write P(t) = a(t − 5)² + 30. Using P(0) = 5: a·25 + 30 = 5, so a = −1. Then P(8) = −1·9 + 30 = 21.
Rationales: A: This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 5, which gives a = −1, so P(8) = 21. B: This uses (t + 5)², putting the vertex at t = −5. A vertex at t = 5 gives the factor (t − 5)², so the value at 8 is 21. D: This finds a by dividing by 5 instead of 5². At t = 0 the squared factor is (5)² = 25, so a = −1, and the prediction at 8 is 21.

---

## Seed N-1.14-B (new) — Topic 1.14 Function Model Construction and Application
**Skill:** construct an average-cost model with a fixed amount and a per-person amount, solve an inequality for the number of people, and round to a whole number correctly.

A club orders custom jackets for its members. The one-time design fee is $470 and each jacket costs $6, with the total split equally among n members. The cost per member is A(n) = 6 + 470/n dollars. What is the smallest whole number of members n for which the cost per member is at most $14?

- A. 58
- B. 24
- C. 34
- **D. 59**

Check: The average per member is A(n) = 6 + 470/n. A(n) ≤ 14 gives 470/n ≤ 8, so n ≥ 470/8 ≈ 58.75; n must be a whole number, so the smallest is 59.
Rationales: A: This rounds 235/4 down. At n = 58 the average is 6 + 470/58 ≈ 14.10, which is still above 14, so the goal is not met until the next whole number. B: This adds the per-member cost to the target instead of subtracting it, dividing 470 by 20. The fixed amount only has to be covered by the part of the target left after the per-member cost, 8. C: This divides the fixed cost by the whole target of 14, ignoring that each member also pays 6 directly. Only 8 per member is left to cover the fixed cost, so 470/8 is needed.

**N-1.14-B-v1.** A band presses a record. The one-time studio fee is $900 and each copy costs $5 to press. The cost per copy, if n copies are made, is C(n) = 5 + 900/n dollars. What is the smallest whole number of copies n for which the cost per copy is at most $12?

- A. 128
- B. 53
- **C. 129**
- D. 75

Check: The average per copy is A(n) = 5 + 900/n. A(n) ≤ 12 gives 900/n ≤ 7, so n ≥ 900/7 ≈ 128.57; n must be a whole number, so the smallest is 129.
Rationales: A: This rounds 900/7 down. At n = 128 the average is 5 + 900/128 ≈ 12.03, which is still above 12, so the goal is not met until the next whole number. B: This adds the per-copy cost to the target instead of subtracting it, dividing 900 by 17. The fixed amount only has to be covered by the part of the target left after the per-copy cost, 7. D: This divides the fixed cost by the whole target of 12, ignoring that each copy also pays 5 directly. Only 7 per copy is left to cover the fixed cost, so 900/7 is needed.

**N-1.14-B-v2.** A class trip has a bus fee of $650 plus $8 per student for tickets, so the cost per student for n students is A(n) = 8 + 650/n dollars. What is the smallest whole number of students n for which the cost per student is at most $15?

- A. 92
- **B. 93**
- C. 29
- D. 44

Check: The average per student is A(n) = 8 + 650/n. A(n) ≤ 15 gives 650/n ≤ 7, so n ≥ 650/7 ≈ 92.86; n must be a whole number, so the smallest is 93.
Rationales: A: This rounds 650/7 down. At n = 92 the average is 8 + 650/92 ≈ 15.07, which is still above 15, so the goal is not met until the next whole number. C: This adds the per-student cost to the target instead of subtracting it, dividing 650 by 23. The fixed amount only has to be covered by the part of the target left after the per-student cost, 7. D: This divides the fixed cost by the whole target of 15, ignoring that each student also pays 8 directly. Only 7 per student is left to cover the fixed cost, so 650/7 is needed.

**N-1.14-B-v3.** A bakery buys a mixer for $750 and spends $3 in ingredients per batch. The average cost per batch over n batches is B(n) = 3 + 750/n dollars. What is the smallest whole number of batches n for which the average cost per batch is at most $10?

- **A. 108**
- B. 107
- C. 58
- D. 75

Check: The average per batch is A(n) = 3 + 750/n. A(n) ≤ 10 gives 750/n ≤ 7, so n ≥ 750/7 ≈ 107.14; n must be a whole number, so the smallest is 108.
Rationales: B: This rounds 750/7 down. At n = 107 the average is 3 + 750/107 ≈ 10.01, which is still above 10, so the goal is not met until the next whole number. C: This adds the per-batch cost to the target instead of subtracting it, dividing 750 by 13. The fixed amount only has to be covered by the part of the target left after the per-batch cost, 7. D: This divides the fixed cost by the whole target of 10, ignoring that each batch also pays 3 directly. Only 7 per batch is left to cover the fixed cost, so 750/7 is needed.

---
