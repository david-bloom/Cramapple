# AP Calculus AB topics 3.4 to 3.6: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (exact fractions, dual numbers for table items, finite differences for formula items).
Scope: replace the one-step arctangent/arcsin/arccos family (apcalcab-mcq-u3n-011, 4 items) and add depth to 3.4 to 3.6, which hold only R2 computation items. Families containing teaching items (u3n-010, u3n-012, oht-3.6) are kept, as are the R2 families u3n-013 and u3n-015.
Target level: inverse trigonometric derivatives with chain-factor traps, procedure diagnosis in worked derivations, multi-rule differentiation with tabulated unspecified functions, and second derivatives of composites and implicit curves.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.4-A | 3.4 | 011 family |
| N-3.4-B | 3.4 | new |
| N-3.5-A | 3.5 | new |
| N-3.5-B | 3.5 | new |
| N-3.6-A | 3.6 | new |
| N-3.6-B | 3.6 | new |

---

## Seed N-3.4-A (replaces 011 family) — Topic 3.4 Differentiating Inverse Trigonometric Functions
**Skill:** differentiate sums of inverse trigonometric functions whose chain factors cancel or add.

For x > 0, let f(x) = tan⁻¹(x) + tan⁻¹(1/x). What is f′(2)?

- A. 2/5
- B. 1
- **C. 0**
- D. 1/5

Check: d/dx tan⁻¹(1/x) = [1/(1 + 1/x²)]·(−1/x²) = −1/(x² + 1), which cancels 1/(1 + x²), so f′(x) = 0 (f is constant, π/2, for x > 0).
Rationales: A: This loses the minus sign from the chain factor −1/x² when differentiating tan⁻¹(1/x), so the two terms 1/5 and 1/5 are added. B: This omits the chain factor −1/x² on the second term, giving 1/(1 + 1/4) = 4/5 for it, and then 1/5 + 4/5 = 1. D: This differentiates only the first term and treats tan⁻¹(1/x) as if it were constant.

**N-3.4-A-v1.** For x > 0, let g(x) = tan⁻¹(x) − tan⁻¹(1/x). What is g′(2)?

- **A. 2/5**
- B. 0
- C. −3/5
- D. 1/5

Check: g′(x) = 1/(1 + x²) − [−1/(x² + 1)] = 2/(1 + x²), so g′(2) = 2/5.
Rationales: B: This assumes the expression is the constant identity tan⁻¹(x) + tan⁻¹(1/x), but the minus sign makes the two derivative terms add rather than cancel. C: This omits the chain factor −1/x² on the second term, giving 1/5 − 4/5 instead of 1/5 + 1/5. D: This keeps only the derivative of tan⁻¹(x) and drops the derivative of the second term entirely.

**N-3.4-A-v2.** Let f(x) = 3sin⁻¹(x) + 3cos⁻¹(x) + x² for −1 < x < 1. What is f′(1/2)?

- A. 4√3 + 1
- B. 2√3 + 1
- C. 0
- **D. 1**

Check: 3/√(1 − x²) − 3/√(1 − x²) = 0, so f′(x) = 2x and f′(1/2) = 1.
Rationales: A: This uses +1/√(1 − x²) for the derivative of cos⁻¹(x), so the two inverse trigonometric terms add instead of cancelling. B: This keeps the derivative of 3sin⁻¹(x) and drops the derivative of 3cos⁻¹(x), so no cancellation occurs. C: This correctly cancels the two inverse trigonometric derivatives but drops the derivative 2x of x², which equals 1 at x = 1/2.

**N-3.4-A-v3.** For x > 0, let f(x) = tan⁻¹(2x) + tan⁻¹(1/(2x)). What is f′(1)?

- A. 4/5
- **B. 0**
- C. 2/5
- D. 1

Check: f′(x) = 2/(1 + 4x²) + [1/(1 + 1/(4x²))]·(−1/(2x²)) = 2/(1 + 4x²) − 2/(4x² + 1) = 0; at x = 1 the terms are 2/5 and −2/5.
Rationales: A: This takes the derivative of tan⁻¹(1/(2x)) with the wrong sign, so its term 2/5 is added to 2/5 instead of cancelling it. C: This differentiates only tan⁻¹(2x), whose derivative at 1 is 2/5, and ignores the second term. D: This applies the arctangent rule without the chain factors: 1/(1 + 4) + 1/(1 + 1/4) = 1/5 + 4/5.

---

## Seed N-3.4-B (new) — Topic 3.4 Differentiating Inverse Trigonometric Functions
**Skill:** apply an inverse trigonometric derivative to an unspecified inner function given only values of g and g′.

The differentiable function g satisfies g(2) = 3 and g′(2) = 10. Let h(x) = sin⁻¹(g(x)/5). What is h′(2)?

- A. 25/2
- B. −5/2
- C. 25/8
- **D. 5/2**

Check: h′(2) = [g′(2)/5]/√(1 − (3/5)²) = 2/(4/5) = 5/2.
Rationales: A: This forgets that the inner function is g(x)/5, so the factor 1/5 is missing from the chain-rule derivative of the argument. B: This uses the derivative of cos⁻¹, which carries a minus sign, instead of the derivative of sin⁻¹. C: This leaves out the square root: the sin⁻¹ derivative is 1/√(1 − u²), not 1/(1 − u²).

**N-3.4-B-v1.** The differentiable function g satisfies g(1) = 4 and g′(1) = −3. Let h(x) = tan⁻¹(g(x)/2). What is h′(1)?

- A. −3/5
- **B. −3/10**
- C. −3/34
- D. −3/(2√5)

Check: h′(1) = [g′(1)/2]/(1 + (g(1)/2)²) = (−3/2)/(1 + 4) = −3/10.
Rationales: A: This omits the factor 1/2 from the derivative of g(x)/2, so g′(1) is used in place of g′(1)/2. C: This puts g(1) = 4 instead of g(1)/2 = 2 into the denominator 1 + u², so the arctangent rule is evaluated at the wrong argument. D: This uses 1/√(1 + u²) instead of 1/(1 + u²); the arctangent derivative has no square root.

**N-3.4-B-v2.** The differentiable function g satisfies g(3) = 2 and g′(3) = 6. Let h(x) = cos⁻¹(g(x)/4). What is h′(3)?

- A. √3
- B. −4√3
- **C. −√3**
- D. −2

Check: h′(3) = −[g′(3)/4]/√(1 − (2/4)²) = −(3/2)/(√3/2) = −√3.
Rationales: A: This drops the minus sign from the derivative of cos⁻¹, which is −1/√(1 − u²). B: This omits the factor 1/4 from the derivative of g(x)/4, so g′(3) = 6 is used unscaled. D: This leaves out the square root and uses −u′/(1 − u²) instead of −u′/√(1 − u²).

**N-3.4-B-v3.** The differentiable function g satisfies g(1) = 3/4 and g′(1) = −2. Let h(x) = sin⁻¹(1 − g(x)). What is h′(1)?

- **A. 8/√15**
- B. −8/√15
- C. 32/15
- D. 8/√7

Check: h′(1) = −g′(1)/√(1 − (1 − g(1))²) = 2/√(1 − 1/16) = 2/(√15/4) = 8/√15.
Rationales: B: This forgets that the derivative of 1 − g(x) is −g′(x), so the minus sign from the inner function is lost. C: This leaves out the square root, using 1/(1 − u²) in place of 1/√(1 − u²). D: This evaluates the square root at g(1) = 3/4 instead of at the argument 1 − g(1) = 1/4.

---

## Seed N-3.5-A (new) — Topic 3.5 Selecting Procedures for Calculating Derivatives
**Skill:** diagnose the first incorrect step in a worked derivative that mixes product, quotient and chain rules.

A student differentiates h(x) = x²·sin(x³) as follows.
Step 1: By the product rule, h′(x) = (x²)′·sin(x³) + x²·(sin(x³))′.
Step 2: (x²)′ = 2x.
Step 3: (sin(x³))′ = cos(x³).
Step 4: Therefore h′(x) = 2x·sin(x³) + x²·cos(x³).
Which statement identifies the first incorrect step?

- A. Step 1 is incorrect: the product rule requires multiplying the derivatives of the two factors.
- **B. Step 3 is incorrect: the chain rule requires the factor 3x², so (sin(x³))′ = 3x²cos(x³).**
- C. Step 2 is incorrect: the derivative of x² is x.
- D. Step 4 is incorrect: the two terms of the product rule should be multiplied, not added.

Check: The derivative of sin(x³) is cos(x³)·3x², so Step 3 is the first wrong step; the correct result is h′(x) = 2x sin(x³) + 3x⁴cos(x³).
Rationales: A: The product rule adds two terms, each differentiating one factor, so Step 1 is correct as written. C: The power rule gives (x²)′ = 2x, so Step 2 is correct. D: Step 4 correctly adds the two product-rule terms from Steps 1 to 3; its only flaw is inherited from Step 3.

**N-3.5-A-v1.** A student differentiates g(x) = e²ˣ/(x² + 1) as follows.
Step 1: By the quotient rule, g′(x) = [(x² + 1)·(e²ˣ)′ − e²ˣ·(x² + 1)′]/(x² + 1).
Step 2: (e²ˣ)′ = 2e²ˣ.
Step 3: (x² + 1)′ = 2x.
Step 4: Therefore g′(x) = [2e²ˣ(x² + 1) − 2x·e²ˣ]/(x² + 1).
Which statement identifies the first incorrect step?

- A. Step 2 is incorrect: the derivative of e²ˣ is e²ˣ.
- B. Step 3 is incorrect: the derivative of x² + 1 is x².
- C. Step 4 is incorrect: the numerator should add the two products rather than subtract them.
- **D. Step 1 is incorrect: the denominator of the quotient rule must be (x² + 1)².**

Check: The quotient rule divides by the square of the denominator, so Step 1 is wrong; the correct result is g′(x) = e²ˣ(2x² − 2x + 2)/(x² + 1)².
Rationales: A: The chain rule gives (e²ˣ)′ = 2e²ˣ, so Step 2 is correct. B: The derivative of x² + 1 is 2x, so Step 3 is correct. C: The quotient rule subtracts in the numerator, and Step 4 follows that pattern correctly from Steps 1 to 3.

**N-3.5-A-v2.** A student differentiates p(x) = x³(2x − 5)⁴ as follows.
Step 1: By the product rule, p′(x) = (x³)′·(2x − 5)⁴ + x³·((2x − 5)⁴)′.
Step 2: ((2x − 5)⁴)′ = 4(2x − 5)³.
Step 3: (x³)′ = 3x².
Step 4: Therefore p′(x) = 3x²(2x − 5)⁴ + 4x³(2x − 5)³.
Which statement identifies the first incorrect step?

- **A. Step 2 is incorrect: the chain rule requires the factor 2, so ((2x − 5)⁴)′ = 8(2x − 5)³.**
- B. Step 1 is incorrect: the product rule should multiply (x³)′ by ((2x − 5)⁴)′.
- C. Step 3 is incorrect: the derivative of x³ is 3x.
- D. Step 4 is incorrect: the exponent 3 in the second term should be 4.

Check: The derivative of (2x − 5)⁴ is 4(2x − 5)³·2 = 8(2x − 5)³, so Step 2 is the first wrong step.
Rationales: B: The product rule adds two terms; it never multiplies the two derivatives, so Step 1 is correct. C: The power rule gives (x³)′ = 3x², so Step 3 is correct. D: Step 4 only combines the earlier steps; the exponent 3 in the second term is correct, and the flaw lies earlier in Step 2.

**N-3.5-A-v3.** A student differentiates q(x) = x·cos(x²) as follows.
Step 1: By the product rule, q′(x) = (x)′·cos(x²) + x·(cos(x²))′.
Step 2: (x)′ = 1.
Step 3: (cos(x²))′ = −sin(x²)·2x.
Step 4: Therefore q′(x) = cos(x²) − 2x·sin(x²).
Which statement identifies the first incorrect step?

- A. Step 3 is incorrect: the derivative of cos(x²) is +sin(x²)·2x.
- B. Step 1 is incorrect: the product rule should differentiate only the second factor.
- **C. Step 4 is incorrect: the second term must also be multiplied by the factor x, giving −2x²sin(x²).**
- D. Step 2 is incorrect: the derivative of x is x.

Check: Steps 1 to 3 are right, but x·(−2x sin(x²)) = −2x² sin(x²), so Step 4 drops a factor of x; q′(x) = cos(x²) − 2x² sin(x²).
Rationales: A: The derivative of cos u is −sin u, so Step 3 correctly includes the minus sign and the factor 2x. B: The product rule differentiates each factor in turn, so Step 1 is correct as written. D: The derivative of x is 1, so Step 2 is correct.

---

## Seed N-3.5-B (new) — Topic 3.5 Selecting Procedures for Calculating Derivatives
**Skill:** combine product, quotient and chain rules with tabulated values of unspecified functions, evaluating each derivative at the correct input.

The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 3 | −2 | 4 | 5
4 | −1 | 2 | 6 | 3

Let h(x) = x²·f(g(x)). What is h′(1)?

- A. 10
- B. −12
- **C. 8**
- D. 0

Check: h′(x) = 2x·f(g(x)) + x²·f′(g(x))·g′(x). At x = 1: 2·f(4) + f′(4)·g′(1) = 2(−1) + 2·5 = 8.
Rationales: A: This drops the product-rule term 2x·f(g(x)) and keeps only x²·f′(g(x))·g′(x). B: This evaluates f′ at x = 1 instead of at g(1) = 4, so the outer derivative is taken at the wrong input. D: This omits the inner derivative g′(1) in the chain rule for f(g(x)).

**N-3.5-B-v1.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 2 | 3 | 6 | 1
2 | 0 | 1 | 5 | −4

Let h(x) = x³·g(f(x)). What is h′(1)?

- **A. 3**
- B. −12
- C. 18
- D. 11

Check: h′(x) = 3x²·g(f(x)) + x³·g′(f(x))·f′(x). At x = 1: 3·g(2) + g′(2)·f′(1) = 3·5 + (−4)·3 = 3.
Rationales: B: This drops the product-rule term 3x²·g(f(x)) and keeps only the term containing g′(f(x))·f′(x). C: This evaluates g′ at x = 1 instead of at f(1) = 2, so the outer derivative uses the wrong input. D: This omits the inner derivative f′(1) in the chain rule for g(f(x)).

**N-3.5-B-v2.** The differentiable function f has the values below.

x | f(x) | f′(x)
2 | 6 | −1
4 | 5 | 3

Let h(x) = f(x²)/x. What is h′(2)?

- A. 1/4
- B. −7/2
- C. 29/4
- **D. 19/4**

Check: h′(x) = [2x·f′(x²)·x − f(x²)]/x². At x = 2: (4·3·2 − 5)/4 = 19/4.
Rationales: A: This omits the inner derivative 2x when differentiating f(x²) in the numerator of the quotient rule. B: This evaluates f and f′ at x = 2 instead of at x² = 4, so the table row used is wrong. C: This adds f(x²) in the quotient-rule numerator, but the quotient rule subtracts numerator-derivative terms.

**N-3.5-B-v3.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 3 | 4 | −2 | 1
2 | 0 | 5 | 3 | −6

Let h(x) = f(x)·g(2x). What is h′(1)?

- A. −6
- **B. −24**
- C. −2
- D. −36

Check: h′(x) = f′(x)·g(2x) + f(x)·2g′(2x). At x = 1: 4·3 + 3·2·(−6) = −24.
Rationales: A: This omits the inner derivative 2 when differentiating g(2x), so g′(2) is not doubled. C: This evaluates g and g′ at x = 1 instead of at 2x = 2, so the wrong table row is used. D: This drops the product-rule term f′(1)·g(2) and keeps only f(1)·2g′(2).

---

## Seed N-3.6-A (new) — Topic 3.6 Calculating Higher-Order Derivatives
**Skill:** find a second derivative of a composite or product of unspecified functions by applying the chain and product rules twice.

The functions f and g are twice differentiable, with g(1) = 2, g′(1) = 3, g″(1) = −4, f′(2) = 5 and f″(2) = −1. If h(x) = f(g(x)), what is h″(1)?

- A. −23
- B. −9
- C. 4
- **D. −29**

Check: h′(x) = f′(g(x))·g′(x); h″(x) = f″(g(x))·(g′(x))² + f′(g(x))·g″(x) = (−1)(9) + (5)(−4) = −29.
Rationales: A: This forgets to square g′(1) in the term f″(g(x))·(g′(x))², using f″(2)·g′(1) = −3 instead of −9. B: This drops the product-rule term f′(g(x))·g″(x), which contributes 5·(−4) = −20. C: This multiplies the two second derivatives, f″(2)·g″(1), which is not what differentiating twice produces.

**N-3.6-A-v1.** The function f is twice differentiable, with f′(4) = 3 and f″(4) = −1/2. If h(x) = f(x²), what is h″(2)?

- A. −8
- **B. −2**
- C. 4
- D. −14

Check: h′(x) = 2x·f′(x²); h″(x) = 2f′(x²) + 2x·2x·f″(x²) = 2·3 + 16·(−1/2) = −2.
Rationales: A: This drops the term 2f′(x²) that comes from differentiating the factor 2x, keeping only 4x²·f″(x²). C: This omits the inner derivative 2x when differentiating f′(x²), using 2f′(4) + 2x·f″(4) instead of 2f′(4) + 4x²·f″(4). D: This subtracts the product-rule term 2f′(x²) instead of adding it to 4x²·f″(x²).

**N-3.6-A-v2.** The function f is twice differentiable, with f(0) = 0, f′(0) = 2 and f″(0) = −3. If h(x) = e^(f(x)), what is h″(0)?

- A. −3
- B. −1
- **C. 1**
- D. 4

Check: h′ = e^f·f′; h″ = e^f·(f′)² + e^f·f″ = e⁰(4 − 3) = 1.
Rationales: A: This keeps only e^f·f″ and drops the term e^f·(f′)² that arises from differentiating e^f a second time. B: This uses f″ + f′ in place of f″ + (f′)², forgetting to square f′(0). D: This keeps only the term e^f·(f′)² and drops e^f·f″.

**N-3.6-A-v3.** The functions f and g are twice differentiable, with f(1) = 2, f′(1) = 3, f″(1) = −1, g(1) = −2, g′(1) = 4 and g″(1) = 5. If h(x) = f(x)·g(x), what is h″(1)?

- **A. 36**
- B. 24
- C. 12
- D. −5

Check: h″ = f″g + 2f′g′ + f·g″ = (−1)(−2) + 2(3)(4) + (2)(5) = 2 + 24 + 10 = 36.
Rationales: B: This omits the factor 2 on the middle term, using f′g′ instead of 2f′g′. C: This keeps only f″g + f·g″ and drops the cross term 2f′g′. D: This multiplies the two second derivatives, f″(1)·g″(1), which ignores the product rule.

---

## Seed N-3.6-B (new) — Topic 3.6 Calculating Higher-Order Derivatives
**Skill:** find and interpret the second derivative of a function defined implicitly, substituting dy/dx before evaluating.

The curve y² = 4x passes through the point (4, 4), and near that point y is a differentiable function of x. Which statement about d²y/dx² at (4, 4) is correct?

- A. d²y/dx² = −1/8, so the curve is concave down at (4, 4).
- **B. d²y/dx² = −1/16, so the curve is concave down at (4, 4).**
- C. d²y/dx² = 1/16, so the curve is concave up at (4, 4).
- D. d²y/dx² = 1/2, so the curve is concave up at (4, 4).

Check: 2y·y′ = 4 gives y′ = 2/y. Then y″ = −2y′/y² = −4/y³. At (4, 4): y′ = 1/2 and y″ = −4/64 = −1/16 < 0.
Rationales: A: This differentiates 2/y as −2/y² and forgets the chain factor dy/dx = 1/2, which gives −1/8 instead of −2(1/2)/16 = −1/16. C: This loses the minus sign when differentiating 2/y; the derivative of 1/y is −y′/y², which is negative here. D: This reports dy/dx = 2/y = 1/2, the first derivative, instead of differentiating a second time.

**N-3.6-B-v1.** Near the point (2, 2) on the curve xy = 4, y is a differentiable function of x. Which statement about d²y/dx² at (2, 2) is correct?

- A. d²y/dx² = −1, so the curve is concave down at (2, 2).
- B. d²y/dx² = 1/2, so the curve is concave up at (2, 2).
- C. d²y/dx² = 2, so the curve is concave up at (2, 2).
- **D. d²y/dx² = 1, so the curve is concave up at (2, 2).**

Check: Differentiating xy = 4 gives y + x·y′ = 0, so y′ = −y/x = −1. Then y″ = −(x·y′ − y)/x² = −(−2 − 2)/4 = 1 > 0.
Rationales: A: This makes a sign error in the quotient step: y″ = −(x·y′ − y)/x² with y′ = −1 equals +1, not −1. B: This drops the term x·y′ and uses only −(−y)/x² = y/x², ignoring that y′ is not zero. C: This forgets to divide by x² and reports 2y/x instead of 2y/x².

**N-3.6-B-v2.** Near the point (3, 4) on the circle x² + y² = 25, y is a differentiable function of x. Which statement about d²y/dx² at (3, 4) is correct?

- **A. d²y/dx² = −25/64, so the curve is concave down at (3, 4).**
- B. d²y/dx² = −1/4, so the curve is concave down at (3, 4).
- C. d²y/dx² = −7/64, so the curve is concave down at (3, 4).
- D. d²y/dx² = −25/16, so the curve is concave down at (3, 4).

Check: y′ = −x/y; y″ = −(y − x·y′)/y² = −(y² + x²)/y³ = −25/y³. At (3, 4): −25/64 < 0.
Rationales: B: This treats y′ as 0 when differentiating −x/y, so the term x·y′ in the quotient rule is lost. C: This substitutes y′ = −x/y with the wrong sign, giving y − x²/y in the numerator instead of y + x²/y. D: This divides by y² instead of y³; the simplified result is −25/y³.

**N-3.6-B-v3.** The curve x = y³ + 2y passes through the point (3, 1), and near that point y is a differentiable function of x. Which statement about d²y/dx² at (3, 1) is correct?

- A. d²y/dx² = 6/125, so the curve is concave up at (3, 1).
- B. d²y/dx² = −6/25, so the curve is concave down at (3, 1).
- **C. d²y/dx² = −6/125, so the curve is concave down at (3, 1).**
- D. d²y/dx² = −1/25, so the curve is concave down at (3, 1).

Check: 1 = (3y² + 2)y′ gives y′ = 1/(3y² + 2) = 1/5. Then y″ = −6y·y′/(3y² + 2)² = −6(1/5)/25 = −6/125 < 0.
Rationales: A: This loses the minus sign: differentiating (3y² + 2)⁻¹ produces −(3y² + 2)⁻²·6y·y′, which is negative here. B: This forgets one factor of dy/dx = 1/5 from the chain rule when differentiating 1/(3y² + 2). D: This treats 3y² + 2 as if it were x, ignoring the chain factor 6y·(dy/dx) from the inner function.

---

