# AP Calculus BC topics 3.1 to 3.6: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (exact fractions, dual numbers for table items, finite differences for formula items).
Scope: BC is a separate pool that copied the old AB items (cos(3x²), e^(sin x), x² + y² = 25 and similar). Retire the one-step and duplicated families and replace them with R3 or strong R2 seeds. Families containing teaching items (u3n-004, u3n-006, np1-009, u3n-010, u3n-012, oht-3.6) are kept, as are the R2 families u3n-002, u3n-009, u3n-013, u3n-015 and the singles np1-007 and mcq-002.
Target level: nested chains with tables, composite rates with units, horizontal tangents and tangent-line intercepts on implicit curves, inverse derivatives (including the second derivative of an inverse), inverse trigonometric derivatives on restricted domains, logarithmic differentiation, and second derivatives and concavity of composites.
Note: seed N-3.3-B asks for (f⁻¹)″, which goes slightly beyond the strict CED wording of topic 3.3 but uses only the derivative of 1/f′.


| Seed | Topic | Replaces |
|---|---|---|
| N-3.1-A | 3.1 | apcalcbc-mcq-ab-029, apcalcbc-mcq-ab-007, apcalcbc-mcq-ab-u3n-001, apcalcbc-mcq-ab-u3n-003 |
| N-3.1-B | 3.1 | apcalcbc-mcq-np1-005 |
| N-3.2-A | 3.2 | apcalcbc-mcq-ab-030, apcalcbc-mcq-ab-008 |
| N-3.2-B | 3.2 | apcalcbc-mcq-ab-u3n-005, apcalcbc-mcq-np1-010 |
| N-3.3-A | 3.3 | apcalcbc-mcq-ab-u3n-008, apcalcbc-mcq-026 |
| N-3.3-B | 3.3 | new |
| N-3.4-A | 3.4 | apcalcbc-mcq-ab-u3n-011 |
| N-3.4-B | 3.4 | new |
| N-3.5-A | 3.5 | new |
| N-3.5-B | 3.5 | new |
| N-3.6-A | 3.6 | apcalcbc-mcq-024 |
| N-3.6-B | 3.6 | new |

---

## Seed N-3.1-A (replaces apcalcbc-mcq-ab-029, apcalcbc-mcq-ab-007, apcalcbc-mcq-ab-u3n-001, apcalcbc-mcq-ab-u3n-003) — Topic 3.1 The Chain Rule
**Skill:** apply the chain rule to nested compositions of unspecified functions, evaluating each derivative at the correct input from a table.

The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 2 | 3 | 5 | 4
2 | 0 | −3 | 3 | −1
3 | 1 | 2 | 0 | 6

Let h(x) = f(g(f(x))). What is h′(1)?

- A. 36
- B. −2
- **C. −6**
- D. 9

Check: h′(x) = f′(g(f(x)))·g′(f(x))·f′(x). At x = 1: f(1) = 2, g(2) = 3, so h′(1) = f′(3)·g′(2)·f′(1) = 2·(−1)·3 = −6.
Rationales: A: This evaluates every derivative at x = 1, but the chain rule needs f′ and g′ at the values of the inner functions. B: This leaves out the innermost factor f′(1) from the chain rule for the three nested functions. D: This takes the outer derivative f′ at f(1) = 2 instead of at g(f(1)) = 3, so the wrong table row is used for f′.

**N-3.1-A-v1.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 5 | 1 | 2 | −2
2 | −1 | 4 | 3 | 6

Let h(x) = (f(g(x)))³. What is h′(1)?

- **A. −24**
- B. −8
- C. 12
- D. −6

Check: h′(x) = 3(f(g(x)))²·f′(g(x))·g′(x). At x = 1: g(1) = 2, f(2) = −1, so h′(1) = 3·1·f′(2)·g′(1) = 3·4·(−2) = −24.
Rationales: B: This drops the outer power-rule factor 3(f(g(x)))² and keeps only f′(g(x))·g′(x). C: This omits the inner derivative g′(1) from the chain rule applied to f(g(x)). D: This evaluates f′ at x = 1 instead of at g(1) = 2, so the wrong table row is used for the middle derivative.

**N-3.1-A-v2.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 4 | −3 | 2 | 5
2 | 1 | 3 | 0 | −1

Let h(x) = f(g(x²)). What is h′(1)?

- A. −30
- B. 15
- C. −6
- **D. 30**

Check: h′(x) = f′(g(x²))·g′(x²)·2x. At x = 1: g(1) = 2, so h′(1) = f′(2)·g′(1)·2 = 3·5·2 = 30.
Rationales: A: This evaluates the outer derivative f′ at x = 1 instead of at g(1) = 2. B: This omits the innermost derivative 2x from the chain rule for x², so the factor 2 is missing. C: This evaluates g′ at g(1) = 2 instead of at x² = 1, so the middle derivative is taken at the wrong input.

**N-3.1-A-v3.** The differentiable function f has the values below.

x | f(x) | f′(x)
1 | 2 | 2
2 | 3 | −1
3 | 1 | 4

Let h(x) = f(f(f(x))). What is h′(1)?

- A. 8
- **B. −8**
- C. 5
- D. −4

Check: h′(x) = f′(f(f(x)))·f′(f(x))·f′(x). At x = 1: f(1) = 2, f(2) = 3, so h′(1) = f′(3)·f′(2)·f′(1) = 4·(−1)·2 = −8.
Rationales: A: This evaluates f′ at x = 1 for all three factors, but each f′ must be taken at the value of the function inside it. C: This adds the three derivatives; the chain rule multiplies the derivatives of the nested functions. D: This leaves out the innermost factor f′(1), using only the two outer derivatives.

---

## Seed N-3.1-B (replaces apcalcbc-mcq-np1-005) — Topic 3.1 The Chain Rule
**Skill:** interpret the chain rule as a rate of change of a composite quantity, tracking sign and units.

The water level in a reservoir is L(V) meters when the stored volume is V million cubic meters. At t = 3 months the volume is V(3) = 25 million cubic meters and V′(3) = −1.5 million cubic meters per month, and L′(25) = 0.4 meters per million cubic meters. Which statement about the water level at t = 3 is correct?

- A. The level is falling at 0.4 meters per month.
- B. The level is falling at 0.6 meters per million cubic meters.
- C. The level is rising at 0.6 meters per month.
- **D. The level is falling at 0.6 meters per month.**

Check: d/dt L(V(t)) = L′(V(3))·V′(3) = (0.4)(−1.5) = −0.6 meters per month, so the level is falling.
Rationales: A: This uses L′(25) alone and ignores how fast the volume is changing, so the chain-rule factor V′(3) is missing. B: This has the correct size but the wrong units; a rate with respect to time is in meters per month, not per volume. C: This has the correct size but the wrong direction: L′(25) is positive and V′(3) is negative, so the product is negative.

**N-3.1-B-v1.** The cost of producing q thousand units is C(q) million dollars. At t = 10 weeks, production is q(10) = 40 thousand units and is increasing at q′(10) = 3 thousand units per week, and C′(40) = 0.8 million dollars per thousand units. Which statement about the cost at t = 10 is correct?

- A. The cost is increasing at 0.8 million dollars per week.
- **B. The cost is increasing at 2.4 million dollars per week.**
- C. The cost is increasing at 2.4 million dollars per thousand units.
- D. The cost is increasing at about 0.27 million dollars per week.

Check: d/dt C(q(t)) = C′(q(10))·q′(10) = (0.8)(3) = 2.4 million dollars per week.
Rationales: A: This uses C′(40) alone and ignores how fast production is rising, so the chain-rule factor q′(10) is missing. C: This has the correct size but the wrong units; the composite rate is with respect to time, so it is in million dollars per week. D: This divides C′(40) by q′(10) instead of multiplying the two rates.

**N-3.1-B-v2.** The pressure on a diver is P(d) kilopascals at a depth of d meters. At t = 2 minutes the diver is at depth d(2) = 30 meters and is rising toward the surface at d′(2) = −0.5 meters per minute, and P′(30) = 10 kilopascals per meter. Which statement about the pressure at t = 2 is correct?

- A. The pressure is decreasing at 10 kilopascals per minute.
- B. The pressure is increasing at 5 kilopascals per minute.
- **C. The pressure is decreasing at 5 kilopascals per minute.**
- D. The pressure is decreasing at 5 kilopascals per meter.

Check: d/dt P(d(t)) = P′(d(2))·d′(2) = (10)(−0.5) = −5 kilopascals per minute.
Rationales: A: This uses P′(30) alone, treating the depth as changing by one meter per minute and ignoring d′(2). B: This has the correct size but the wrong direction: the depth is decreasing, so the pressure is decreasing. D: This has the correct size but the wrong units; the rate with respect to time is in kilopascals per minute.

**N-3.1-B-v3.** The number of tickets sold per week is D(p) when the price is p dollars. At t = 8 weeks the price is p(8) = 12 dollars and is falling at p′(8) = −0.5 dollars per week, and D′(12) = −30 tickets per week per dollar. Which statement about the weekly ticket sales at t = 8 is correct?

- **A. Weekly sales are increasing at 15 tickets per week each week.**
- B. Weekly sales are decreasing at 15 tickets per week each week.
- C. Weekly sales are decreasing at 30 tickets per week each week.
- D. Weekly sales are increasing at 15 tickets per week per dollar.

Check: d/dt D(p(t)) = D′(12)·p′(8) = (−30)(−0.5) = +15 tickets per week each week, so sales are increasing.
Rationales: B: This has the correct size but the wrong direction: both D′(12) and p′(8) are negative, so their product is positive. C: This uses D′(12) alone and ignores that the price is changing, so the factor p′(8) is missing. D: This has the correct size but the wrong units; the composite rate is with respect to time, not price.

---

## Seed N-3.2-A (replaces apcalcbc-mcq-ab-030, apcalcbc-mcq-ab-008) — Topic 3.2 Implicit Differentiation
**Skill:** locate points of horizontal tangency on an implicitly defined curve by setting the numerator of dy/dx to zero and substituting into the curve.

At which points does the graph of x² + xy + y² = 12 have a horizontal tangent line?

- A. (−4, 2) and (4, −2)
- **B. (2, −4) and (−2, 4)**
- C. (2, 2) and (−2, −2)
- D. Only (2, −4)

Check: Differentiating gives dy/dx = −(2x + y)/(x + 2y). Horizontal tangents need 2x + y = 0, so y = −2x; substituting gives 3x² = 12, x = ±2, and the points are (2, −4) and (−2, 4), where x + 2y ≠ 0.
Rationales: A: These are the points where the denominator x + 2y is zero, so the tangent is vertical; a horizontal tangent needs the numerator 2x + y to be zero. C: These come from setting x − y = 0 instead of 2x + y = 0, which is not the condition dy/dx = 0 for this curve. D: This finds one solution but misses (−2, 4), which also lies on the curve with 2x + y = 0.

**N-3.2-A-v1.** At which points does the graph of x² − xy + y² = 3 have a horizontal tangent line?

- A. (2, 1) and (−2, −1)
- B. (√3, √3) and (−√3, −√3)
- C. Only (1, 2)
- **D. (1, 2) and (−1, −2)**

Check: Differentiating gives dy/dx = (y − 2x)/(2y − x). Horizontal tangents need y = 2x; substituting gives 3x² = 3, x = ±1, and the points are (1, 2) and (−1, −2), where 2y − x ≠ 0.
Rationales: A: These are the points where 2y − x = 0, so the tangent is vertical; a horizontal tangent needs 2x − y = 0. B: These come from setting x − y = 0, which is not the condition dy/dx = 0 for this curve. C: This finds one solution but misses (−1, −2), which also lies on the curve with 2x − y = 0.

**N-3.2-A-v2.** At which points does the graph of 3x² + 2xy + y² = 6 have a horizontal tangent line?

- **A. (1, −3) and (−1, 3)**
- B. (√3, −√3) and (−√3, √3)
- C. Only (1, −3)
- D. There are no points with a horizontal tangent line.

Check: Differentiating gives dy/dx = −(3x + y)/(x + y). Horizontal tangents need y = −3x; substituting gives 6x² = 6, x = ±1, and the points are (1, −3) and (−1, 3), where x + y ≠ 0.
Rationales: B: These are the points where 2x + 2y = 0, so the tangent is vertical; a horizontal tangent needs 6x + 2y = 0. C: This finds one solution but misses (−1, 3), which also lies on the curve with 3x + y = 0. D: Setting 3x + y = 0 and substituting into the equation gives 6x² = 6, which has real solutions, so horizontal tangents exist.

**N-3.2-A-v3.** At which points does the graph of x² + y² − 4x = 0 have a horizontal tangent line?

- A. (0, 0) and (4, 0)
- B. Only (2, 2)
- **C. (2, 2) and (2, −2)**
- D. (2, 0)

Check: Differentiating gives dy/dx = (4 − 2x)/(2y) = (2 − x)/y. Horizontal tangents need x = 2; substituting gives y² = 4, so the points are (2, 2) and (2, −2), where y ≠ 0.
Rationales: A: These are the points where y = 0, so the tangent is vertical; a horizontal tangent needs the numerator 2x − 4 to be zero. B: This finds one solution but misses (2, −2), which also lies on the circle with x = 2. D: The point (2, 0) is the center of the circle, not a point on the graph, since 4 + 0 − 8 ≠ 0.

---

## Seed N-3.2-B (replaces apcalcbc-mcq-ab-u3n-005, apcalcbc-mcq-np1-010) — Topic 3.2 Implicit Differentiation
**Skill:** build the tangent line to an implicit curve at a point and use it to find an intercept.

The point (0, 2) lies on the curve y² − xy = 4. The line tangent to the curve at (0, 2) crosses the x-axis at what value of x?

- A. 4
- B. 1
- **C. −4**
- D. −1

Check: Differentiating gives 2y·y′ − y − x·y′ = 0, so y′ = y/(2y − x) = 2/4 = 1/2 at (0, 2). The tangent y = 2 + x/2 meets y = 0 at x = −4.
Rationales: A: This uses the slope −1/2, the negative of dy/dx, so the tangent line is reflected and crosses the axis on the wrong side. B: This uses the normal line, with slope −2, instead of the tangent line with slope 1/2. D: This uses 2 as the slope, which is the reciprocal of dy/dx = 1/2, and so describes a different line.

**N-3.2-B-v1.** The point (1, 2) lies on the curve x² + xy + y² = 7. The line tangent to the curve at (1, 2) crosses the x-axis at what value of x?

- **A. 7/2**
- B. −3/2
- C. −3/5
- D. 13/5

Check: Differentiating gives 2x + y + (x + 2y)y′ = 0, so y′ = −(2x + y)/(x + 2y) = −4/5 at (1, 2). The tangent y − 2 = −(4/5)(x − 1) meets y = 0 at x = 7/2.
Rationales: B: This uses the slope +4/5, the negative of dy/dx, so the line is reflected and crosses the axis on the wrong side of x = 1. C: This uses the normal line, with slope 5/4, instead of the tangent line with slope −4/5. D: This uses −5/4 as the slope, which inverts dy/dx = −Fx/Fy to −Fy/Fx.

**N-3.2-B-v2.** The point (1, 2) lies on the curve y³ + xy = 10. The line tangent to the curve at (1, 2) crosses the x-axis at what value of x?

- A. −12
- B. 9/13
- C. 17/13
- **D. 14**

Check: Differentiating gives 3y²·y′ + y + x·y′ = 0, so y′ = −y/(3y² + x) = −2/13 at (1, 2). The tangent y − 2 = −(2/13)(x − 1) meets y = 0 at x = 14.
Rationales: A: This uses the slope +2/13, the negative of dy/dx, so the line is reflected and crosses the axis on the wrong side of x = 1. B: This uses the normal line, with slope 13/2, instead of the tangent line with slope −2/13. C: This uses −13/2 as the slope, which inverts dy/dx = −Fx/Fy to −Fy/Fx.

**N-3.2-B-v3.** The point (1, 2) lies on the curve xy² + y = 6. The line tangent to the curve at (1, 2) crosses the y-axis at what value of y?

- A. 6/5
- **B. 14/5**
- C. 3/4
- D. 4/5

Check: Differentiating gives y² + (2xy + 1)y′ = 0, so y′ = −y²/(2xy + 1) = −4/5 at (1, 2). The tangent y − 2 = −(4/5)(x − 1) has y-intercept 2 + 4/5 = 14/5.
Rationales: A: This uses the slope +4/5, the negative of dy/dx, so the line is reflected and the intercept is on the wrong side of y = 2. C: This uses the normal line, with slope 5/4, instead of the tangent line with slope −4/5. D: This computes the slope times the x-distance, −(4/5)(0 − 1), but forgets to add the y-coordinate 2 of the point.

---

## Seed N-3.3-A (replaces apcalcbc-mcq-ab-u3n-008, apcalcbc-mcq-026) — Topic 3.3 Differentiating Inverse Functions
**Skill:** differentiate a composition or product involving an inverse function, using table values of f only.

The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = g(2x + 1).

x | f(x) | f′(x)
1 | 3 | 4
2 | 5 | 6
3 | 8 | 7

What is h′(1)?

- A. 1/4
- B. 8
- C. 2/7
- **D. 1/2**

Check: g(3) = 1 because f(1) = 3, so g′(3) = 1/f′(1) = 1/4. Then h′(1) = g′(3)·2 = 2/4 = 1/2.
Rationales: A: This finds g′(3) but omits the chain-rule factor 2 from the inner function 2x + 1. B: This multiplies by f′(1) instead of dividing: the inverse derivative is the reciprocal 1/f′(g(3)). C: This evaluates f′ at 3 instead of at g(3) = 1; the inverse derivative uses f′ at the point where f equals 3.

**N-3.3-A-v1.** The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = x·g(x).

x | f(x) | f′(x)
1 | 2 | 5
2 | 6 | 3
4 | 9 | 2

What is h′(6)?

- A. 20
- **B. 4**
- C. 2
- D. 2/3

Check: g(6) = 2 because f(2) = 6, and g′(6) = 1/f′(2) = 1/3. Then h′(6) = g(6) + 6·g′(6) = 2 + 2 = 4.
Rationales: A: This uses f′(2) = 3 where g′(6) = 1/f′(2) belongs, treating the inverse derivative as f′ instead of its reciprocal. C: This drops the product-rule term g(6) and keeps only x·g′(x). D: This multiplies g(6) by g′(6) instead of applying the product rule to x·g(x).

**N-3.3-A-v2.** The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = (g(x))².

x | f(x) | f′(x)
1 | 3 | 4
2 | 5 | 6

What is h′(5)?

- A. 24
- B. 1/6
- **C. 2/3**
- D. 1/3

Check: g(5) = 2 because f(2) = 5, and g′(5) = 1/f′(2) = 1/6. Then h′(5) = 2·g(5)·g′(5) = 2·2/6 = 2/3.
Rationales: A: This replaces g′(5) by f′(2) = 6, so the inverse derivative is not taken as a reciprocal. B: This gives g′(5) alone and omits the power-rule factor 2g(5) from differentiating the square. D: This keeps the factor 2 and g′(5) but omits the factor g(5) = 2 from the power rule.

**N-3.3-A-v3.** The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = g(x²).

x | f(x) | f′(x)
2 | 4 | 5
3 | 7 | 3

What is h′(2)?

- **A. 4/5**
- B. 1/5
- C. 20
- D. 4/3

Check: g(4) = 2 because f(2) = 4, so g′(4) = 1/f′(2) = 1/5. Then h′(2) = g′(2²)·2·2 = 4/5.
Rationales: B: This finds g′(4) but omits the chain-rule factor 2x = 4 from the inner function x². C: This multiplies by f′(2) instead of dividing: the inverse derivative is the reciprocal 1/f′(g(4)). D: This evaluates f′ at 3 instead of at g(4) = 2, so the wrong table row is used.

---

## Seed N-3.3-B (new) — Topic 3.3 Differentiating Inverse Functions
**Skill:** find the second derivative of an inverse function, differentiating 1/f′(x) again with respect to y.

Let f(x) = x³ + x, which is one-to-one. What is (f⁻¹)″(2)?

- A. 3/32
- **B. −3/32**
- C. −3/8
- D. 1/6

Check: f(1) = 2, f′(1) = 4, f″(1) = 6. (f⁻¹)′(y) = 1/f′(x), so (f⁻¹)″(y) = −f″(x)·(dx/dy)/(f′(x))² = −f″(x)/(f′(x))³ = −6/64 = −3/32.
Rationales: A: This loses the minus sign: differentiating 1/f′(x) with respect to y gives −f″(x)/(f′(x))³, which is negative here. C: This uses −f″/(f′)² and forgets that a second factor of 1/f′ comes from the chain rule through x = f⁻¹(y). D: This takes 1/f″(1) as if the second derivative of the inverse were the reciprocal of the second derivative.

**N-3.3-B-v1.** Let f(x) = x³ + 2x, which is one-to-one. What is (f⁻¹)″(3)?

- A. 6/125
- B. −6/25
- C. 1/5
- **D. −6/125**

Check: f(1) = 3, f′(1) = 5, f″(1) = 6. Then (f⁻¹)″(3) = −f″(1)/(f′(1))³ = −6/125.
Rationales: A: This loses the minus sign: the derivative of 1/f′(x) with respect to y is −f″/(f′)³. B: This uses −f″/(f′)² and omits the extra factor 1/f′ that arises because x depends on y. C: This is the first derivative (f⁻¹)′(3) = 1/f′(1), not the second derivative.

**N-3.3-B-v2.** Let f(x) = eˣ + x, which is one-to-one. What is (f⁻¹)″(1)?

- **A. −1/8**
- B. 1/8
- C. −1/4
- D. 1/2

Check: f(0) = 1, f′(0) = e⁰ + 1 = 2, f″(0) = e⁰ = 1. Then (f⁻¹)″(1) = −f″(0)/(f′(0))³ = −1/8.
Rationales: B: This loses the minus sign from differentiating 1/f′(x): the second derivative of the inverse is −f″/(f′)³. C: This uses −f″/(f′)² and forgets the extra factor 1/f′ from the chain rule through x = f⁻¹(y). D: This is the first derivative (f⁻¹)′(1) = 1/f′(0), not the second derivative.

**N-3.3-B-v3.** The function f is twice differentiable and one-to-one, with f(2) = 7, f′(2) = 4 and f″(2) = −2. What is (f⁻¹)″(7)?

- A. −1/32
- B. 1/8
- **C. 1/32**
- D. 1/4

Check: (f⁻¹)′(y) = 1/f′(x), so (f⁻¹)″(y) = −f″(x)/(f′(x))³ with x = f⁻¹(7) = 2: −(−2)/64 = 1/32.
Rationales: A: This loses the minus sign: the formula is (f⁻¹)″ = −f″/(f′)³, and f″(2) is itself negative, so the result is positive. B: This uses −f″/(f′)² and forgets the extra factor 1/f′ that comes from the chain rule through x = f⁻¹(y). D: This is the first derivative (f⁻¹)′(7) = 1/f′(2), not the second derivative.

---

## Seed N-3.4-A (replaces apcalcbc-mcq-ab-u3n-011) — Topic 3.4 Differentiating Inverse Trigonometric Functions
**Skill:** differentiate an inverse trigonometric function of a reciprocal or quadratic on a restricted domain, keeping the correct sign.

For x < −1, let f(x) = cos⁻¹(1/x). What is f′(−2)?

- A. −√3/6
- B. −2/√3
- **C. √3/6**
- D. 2/√3

Check: f′(x) = [−1/√(1 − 1/x²)]·(−1/x²) = 1/(x²√(1 − 1/x²)). At x = −2: 1/(4·√(3/4)) = 1/(2√3) = √3/6, which is positive because the factor −1/x² is negative and cos⁻¹ is decreasing.
Rationales: A: This applies the simplified formula 1/(x√(x² − 1)) at x = −2; that formula holds for x > 1, and for x < −1 the correct form has |x|, so the sign is wrong. B: This omits the chain-rule factor −1/x² from the inner function 1/x, so only the outer derivative −1/√(1 − 1/4) is evaluated. D: This omits the chain-rule factor −1/x² and also uses the derivative of sin⁻¹ instead of the negative derivative of cos⁻¹.

**N-3.4-A-v1.** For x < −1, let f(x) = sin⁻¹(1/x). What is f′(−3)?

- **A. −√2/12**
- B. √2/12
- C. 3√2/4
- D. −1/9

Check: f′(x) = [1/√(1 − 1/x²)]·(−1/x²). At x = −3: (1/√(8/9))·(−1/9) = (3/(2√2))(−1/9) = −1/(6√2) = −√2/12.
Rationales: B: This applies −1/(x√(x² − 1)), which is valid only for x > 1; at x = −3 it gives the wrong sign because the correct form uses |x|. C: This omits the chain-rule factor −1/x² and keeps only the outer derivative 1/√(1 − 1/9). D: This keeps the chain factor −1/x² but leaves out the outer factor 1/√(1 − 1/x²).

**N-3.4-A-v2.** For −√2 < x < 0, let f(x) = cos⁻¹(x² − 1). Which expression equals f′(x)?

- A. −2/√(2 − x²)
- B. 2x/√(2 − x²)
- C. 2/√(1 − x²)
- **D. 2/√(2 − x²)**

Check: f′(x) = −2x/√(1 − (x² − 1)²) = −2x/√(2x² − x⁴) = −2x/(|x|√(2 − x²)). For x < 0, |x| = −x, so f′(x) = 2/√(2 − x²), which is positive.
Rationales: A: This simplifies √(2x² − x⁴) as x√(2 − x²), but x is negative here, so √(x²) = −x and the sign is wrong. B: This drops the factor x in the denominator when simplifying but keeps the factor 2x from the chain rule, so x does not cancel. C: This forgets that 1 − (x² − 1)² = 2x² − x⁴, not 1 − x²; the radicand is 2 − x² after factoring out x².

**N-3.4-A-v3.** For x < −2, let f(x) = cos⁻¹(2/x). What is f′(−4)?

- A. −√3/12
- **B. √3/12**
- C. −2/√3
- D. 2/√3

Check: f′(x) = [−1/√(1 − 4/x²)]·(−2/x²). At x = −4: [1/√(3/4)]·(2/16) = (2/√3)(1/8) = 1/(4√3) = √3/12.
Rationales: A: This applies 2/(x√(x² − 4)), which holds for x > 2; at x = −4 the correct form has |x|, so the sign is wrong. C: This omits the chain-rule factor −2/x² from the inner function 2/x and keeps only −1/√(1 − 1/4). D: This omits the chain-rule factor and also uses the derivative of sin⁻¹ rather than the negative derivative of cos⁻¹.

---

## Seed N-3.4-B (new) — Topic 3.4 Differentiating Inverse Trigonometric Functions
**Skill:** find the rate of change of an angle defined by an inverse trigonometric function of a changing length, with the correct units.

A camera is 40 meters from the base of a launch pad and films a rocket rising vertically. When the rocket is h meters high, the camera's angle of elevation is θ = tan⁻¹(h/40). At the moment h = 30 meters, the rocket is rising at 12 meters per second. How fast is θ changing at that moment?

- A. 7.68 radians per second
- B. 0.3 radians per second
- C. 0.0133 radians per second
- **D. 0.192 radians per second**

Check: dθ/dt = [1/(1 + (h/40)²)]·(1/40)·dh/dt = [1/(1 + 9/16)]·(12/40) = (16/25)(0.3) = 0.192 radians per second.
Rationales: A: This omits the chain-rule factor 1/40 from the argument h/40, so the rate of h is used as if the argument were h itself. B: This uses only the inner derivative (12/40) and leaves out the factor 1/(1 + (h/40)²) from the arctangent derivative. C: This applies the arctangent derivative to h instead of h/40, giving 12/(1 + 900) and ignoring the scale factor 40.

**N-3.4-B-v1.** A 13-meter ladder leans against a wall. The angle θ between the ladder and the ground satisfies θ = cos⁻¹(x/13), where x is the distance in meters from the wall to the foot of the ladder. The foot slides away from the wall at 0.5 meters per second. How fast is θ changing when x = 5 meters?

- A. 1/24 radians per second
- **B. −1/24 radians per second**
- C. −13/24 radians per second
- D. −13/288 radians per second

Check: dθ/dt = −[1/√(1 − (x/13)²)]·(1/13)·dx/dt = −[1/√(144/169)]·(1/13)(0.5) = −(13/12)(1/26) = −1/24 radians per second.
Rationales: A: This drops the minus sign from the derivative of cos⁻¹; the angle decreases as the foot slides out. C: This omits the chain-rule factor 1/13 from the argument x/13. D: This leaves out the square root and uses 1/(1 − (x/13)²) in place of 1/√(1 − (x/13)²).

**N-3.4-B-v2.** An observer watches a plane fly horizontally at an altitude of 3 kilometers. The angle of elevation is θ = tan⁻¹(3/x), where x is the horizontal distance in kilometers from the observer to the plane. The plane is approaching at 400 kilometers per hour, so dx/dt = −400. How fast is θ changing when x = 4 kilometers?

- A. −48 radians per hour
- B. 75 radians per hour
- **C. 48 radians per hour**
- D. −256 radians per hour

Check: dθ/dt = [1/(1 + (3/x)²)]·(−3/x²)·dx/dt = (16/25)(−3/16)(−400) = (−3/25)(−400) = 48 radians per hour.
Rationales: A: This has the correct size but the wrong sign: the plane is approaching, so the angle of elevation is increasing. B: This keeps the chain factors but drops 1/(1 + (3/x)²) = 16/25 from the arctangent derivative. D: This omits the chain-rule factor −3/x² from the inner function 3/x, using only 1/(1 + (3/x)²)·dx/dt.

**N-3.4-B-v3.** A kite is flown on a 100-meter string held taut at ground level. The angle θ between the string and the ground satisfies θ = sin⁻¹(h/100), where h is the kite's height in meters. The kite is rising at 2 meters per second. How fast is θ changing when h = 60 meters?

- **A. 0.025 radians per second**
- B. 2.5 radians per second
- C. 0.03125 radians per second
- D. 0.02 radians per second

Check: dθ/dt = [1/√(1 − (h/100)²)]·(1/100)·dh/dt = (1/0.8)(0.02) = 0.025 radians per second.
Rationales: B: This omits the chain-rule factor 1/100 from the argument h/100, so dh/dt = 2 is used unscaled. C: This leaves out the square root and uses 1/(1 − (h/100)²) in place of 1/√(1 − (h/100)²). D: This uses only the inner derivative (2/100) and leaves out the factor 1/√(1 − (h/100)²) from the arcsine derivative.

---

## Seed N-3.5-A (new) — Topic 3.5 Selecting Procedures for Calculating Derivatives
**Skill:** recognize that a variable base with a variable exponent needs logarithmic differentiation, and apply it with the product rule.

For x > 0, which expression gives the derivative of y = x³ˣ?

- A. 3x·x³ˣ⁻¹
- **B. 3x³ˣ(ln x + 1)**
- C. 3x³ˣ·ln x
- D. 3x³ˣ/x

Check: ln y = 3x·ln x, so y′/y = 3 ln x + 3x·(1/x) = 3(ln x + 1), and y′ = 3x³ˣ(ln x + 1). At x = 2 this is 192(ln 2 + 1), which differs from each other choice.
Rationales: A: This applies the power rule as if the exponent 3x were a constant, but here both the base and the exponent depend on x. C: This applies the rule for aˣ with a constant base, which gives only part of the answer; it omits the term from differentiating the base x. D: This differentiates ln y = 3x·ln x as 3·(1/x), treating the factor 3x as constant and skipping the product rule.

**N-3.5-A-v1.** For x > 1, which expression gives the derivative of y = (ln x)ˣ?

- A. (ln x)ˣ⁻¹
- B. (ln x)ˣ·ln(ln x)
- C. (ln x)ˣ·[ln(ln x) + 1/(x ln x)]
- **D. (ln x)ˣ·[ln(ln x) + 1/ln x]**

Check: ln y = x·ln(ln x), so y′/y = ln(ln x) + x·[1/(x ln x)] = ln(ln x) + 1/ln x, and y′ = (ln x)ˣ[ln(ln x) + 1/ln x].
Rationales: A: This applies the power rule as if the exponent x were constant; the exponent depends on x, so logarithmic differentiation is needed. B: This applies the rule for aˣ with a constant base, omitting the term that comes from differentiating the base ln x. C: This differentiates x·ln(ln x) but forgets to multiply the derivative 1/(x ln x) of ln(ln x) by the factor x from the product rule.

**N-3.5-A-v2.** For all x, which expression gives the derivative of y = (x² + 1)ˣ?

- **A. (x² + 1)ˣ·[ln(x² + 1) + 2x²/(x² + 1)]**
- B. 2x²(x² + 1)ˣ⁻¹
- C. (x² + 1)ˣ·ln(x² + 1)
- D. (x² + 1)ˣ·[ln(x² + 1) + 2x/(x² + 1)]

Check: ln y = x·ln(x² + 1), so y′/y = ln(x² + 1) + x·2x/(x² + 1), and y′ = (x² + 1)ˣ[ln(x² + 1) + 2x²/(x² + 1)].
Rationales: B: This applies the power rule as if the exponent x were constant, which captures only the term from differentiating the base. C: This applies the rule for aˣ with a constant base, omitting the term that comes from differentiating the base x² + 1. D: This forgets the factor x from the product rule on x·ln(x² + 1), so the second term should be x·2x/(x² + 1).

**N-3.5-A-v3.** For x > 0, which expression gives the derivative of y = x^(cos x)?

- A. (cos x)·x^(cos x − 1)
- B. −sin x·ln x·x^(cos x)
- **C. x^(cos x)·[−sin x·ln x + (cos x)/x]**
- D. x^(cos x)·[sin x·ln x + (cos x)/x]

Check: ln y = cos x·ln x, so y′/y = −sin x·ln x + (cos x)/x, and y′ = x^(cos x)[−sin x·ln x + (cos x)/x].
Rationales: A: This applies the power rule as if the exponent cos x were constant, which captures only the term from differentiating the base. B: This applies the rule for aˣ with a constant base, omitting the term that comes from differentiating the base x. D: This loses the minus sign: the derivative of cos x is −sin x, so the first term must be −sin x·ln x.

---

## Seed N-3.5-B (new) — Topic 3.5 Selecting Procedures for Calculating Derivatives
**Skill:** combine product, quotient, power and chain rules with tabulated values of unspecified functions, evaluating each derivative at the correct input.

The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
2 | 2 | −1 | 1 | 2
4 | 0 | 5 | 6 | −3

Let h(x) = f(x)·g(x²)/x. What is h′(2)?

- A. −9
- B. −12
- **C. −18**
- D. −15

Check: Let N(x) = f(x)·g(x²). N′ = f′(x)g(x²) + f(x)·2x·g′(x²). h′ = (N′·x − N)/x². At x = 2: N = 2·6 = 12, N′ = (−1)(6) + 2·4·(−3) = −30, so h′(2) = (−30·2 − 12)/4 = −18.
Rationales: A: This omits the chain-rule factor 2x when differentiating g(x²) in the numerator. B: This adds f(x)·g(x²) in the quotient-rule numerator, but the quotient rule subtracts numerator·denominator′. D: This treats 1/x as a constant factor and differentiates only the product f(x)·g(x²), ignoring the derivative of 1/x.

**N-3.5-B-v1.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
1 | 5 | 1 | 2 | 3
2 | 4 | −2 | 7 | 1

Let h(x) = g(x)/f(g(x)). What is h′(1)?

- **A. 3/2**
- B. 1
- C. 3/8
- D. 6

Check: With D(x) = f(g(x)): D(1) = f(2) = 4 and D′(1) = f′(2)·g′(1) = −6. Then h′(1) = [g′(1)·D(1) − g(1)·D′(1)]/D(1)² = [12 + 12]/16 = 3/2.
Rationales: B: This omits the inner derivative g′(1) when differentiating f(g(x)) in the denominator. C: This evaluates f′ at x = 1 instead of at g(1) = 2, so the wrong table entry is used for f′. D: This divides by f(g(x)) instead of by its square, forgetting that the quotient rule has denominator squared.

**N-3.5-B-v2.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
2 | 1 | −2 | 5 | −1
4 | 0 | 3 | 3 | 2

Let h(x) = x·f(x)·g(x²). What is h′(2)?

- A. −5
- B. 16
- C. −23
- **D. 7**

Check: Product rule on three factors: h′ = f·g(x²) + x·f′·g(x²) + x·f·2x·g′(x²). At x = 2: (1)(3) + 2(−2)(3) + 2(1)(4)(2) = 3 − 12 + 16 = 7.
Rationales: A: This omits the chain-rule factor 2x when differentiating g(x²), so the last term is 2·1·2 instead of 2·1·4·2. B: This keeps only the term in which g(x²) is differentiated and drops the other two product-rule terms. C: This evaluates g and g′ at x = 2 instead of at x² = 4, so the wrong table row is used.

**N-3.5-B-v3.** The differentiable functions f and g have the values below.

x | f(x) | f′(x) | g(x) | g′(x)
2 | 9 | 6 | 2 | −3

Let h(x) = g(x)·√(f(x)). What is h′(2)?

- A. −5
- **B. −7**
- C. 2
- D. −26/3

Check: h′ = g′·√f + g·f′/(2√f). At x = 2: (−3)(3) + (2)(6)/(2·3) = −9 + 2 = −7.
Rationales: A: This leaves out the factor 1/2 from the derivative of √f(x), using g·f′/√f instead of g·f′/(2√f). C: This drops the product-rule term g′(2)·√f(2) and keeps only g·f′/(2√f). D: This forgets the inner derivative f′(2) when differentiating √f(x), using g/(2√f) in place of g·f′/(2√f).

---

## Seed N-3.6-A (replaces apcalcbc-mcq-024) — Topic 3.6 Calculating Higher-Order Derivatives
**Skill:** find a second derivative of a reciprocal, root, logarithm or product of an unspecified function from its first and second derivative values.

The function f is twice differentiable, with f(1) = 2, f′(1) = 3 and f″(1) = −4. If h(x) = 1/f(x), what is h″(1)?

- A. 1
- B. 5/4
- C. −5/4
- **D. 13/4**

Check: h′ = −f′/f²; h″ = −f″/f² + 2(f′)²/f³. At x = 1: −(−4)/4 + 2(9)/8 = 1 + 9/4 = 13/4.
Rationales: A: This keeps only −f″/f² and drops the term 2(f′)²/f³ that comes from differentiating 1/f² a second time. B: This changes the sign of the first term, using f″/f² + 2(f′)²/f³ instead of −f″/f² + 2(f′)²/f³. C: This subtracts the second term, using −f″/f² − 2(f′)²/f³; the chain-rule term 2(f′)²/f³ is positive.

**N-3.6-A-v1.** The function f is twice differentiable and positive, with f(2) = 4, f′(2) = 2 and f″(2) = 1. If h(x) = √(f(x)), what is h″(2)?

- A. 1/4
- **B. 1/8**
- C. 3/8
- D. 3/16

Check: h′ = f′/(2√f); h″ = f″/(2√f) − (f′)²/(4f^(3/2)). At x = 2: 1/4 − 4/32 = 1/4 − 1/8 = 1/8.
Rationales: A: This keeps only f″/(2√f) and drops the term −(f′)²/(4f^(3/2)) that comes from differentiating 1/√f. C: This adds the second term +(f′)²/(4f^(3/2)) instead of subtracting it; the derivative of f^(−1/2) carries a minus sign. D: This uses f′ instead of (f′)² in the second term, forgetting the chain-rule factor f′ when differentiating f^(−1/2).

**N-3.6-A-v2.** The function f is twice differentiable and positive, with f(1) = 2, f′(1) = −3 and f″(1) = 5. If h(x) = ln(f(x)), what is h″(1)?

- A. 5/2
- B. 19/4
- **C. 1/4**
- D. −1

Check: h′ = f′/f; h″ = [f″·f − (f′)²]/f² = [5·2 − 9]/4 = 1/4.
Rationales: A: This keeps only f″/f and drops the term −(f′)²/f² from differentiating f′/f with the quotient rule. B: This adds (f′)² in the quotient-rule numerator, but the quotient rule subtracts f′·f′ from f″·f. D: This uses f″ − (f′)² in the numerator without the factor f, so the first quotient-rule term f″·f is wrong.

**N-3.6-A-v3.** The function f is twice differentiable, with f(0) = 3, f′(0) = 1 and f″(0) = 4. If h(x) = f(x)·e^(−x), what is h″(0)?

- **A. 5**
- B. 9
- C. 6
- D. 4

Check: h′ = e^(−x)(f′ − f); h″ = e^(−x)(f″ − f′) − e^(−x)(f′ − f) = e^(−x)(f″ − 2f′ + f). At x = 0: 4 − 2 + 3 = 5.
Rationales: B: This uses e^(−x)(f″ + 2f′ + f), changing the sign of the middle term; each derivative of e^(−x) contributes a factor of −1. C: This uses f″ − f′ + f, forgetting the factor 2 on the middle term of the product rule applied twice. D: This keeps only f″(0)·e⁰ and drops the terms from differentiating e^(−x).

---

## Seed N-3.6-B (new) — Topic 3.6 Calculating Higher-Order Derivatives
**Skill:** decide the concavity of a composite function from the signs of f′, f″, g′ and g″ using h″ = f″(g)(g′)² + f′(g)g″.

The functions f and g are twice differentiable on the real numbers. For all real t, f′(t) > 0 and f″(t) > 0, and for all real x, g′(x) < 0 and g″(x) > 0. Let h(x) = f(g(x)). Which statement about the graph of h is correct?

- A. h is concave down on the real numbers, because g is decreasing.
- **B. h is concave up on the real numbers, because h″(x) is a sum of two positive terms.**
- C. The concavity of h cannot be determined, because g′ < 0 and f″ > 0 have opposite signs.
- D. h is concave down on the real numbers, because the composition reverses the concavity of f when g′ < 0.

Check: h″(x) = f″(g(x))·(g′(x))² + f′(g(x))·g″(x). The first term is positive because f″ > 0 and the square is positive; the second is positive because f′ > 0 and g″ > 0. So h″ > 0.
Rationales: A: This confuses a decreasing inner function with concave down; concavity depends on the sign of h″, which here is positive. C: This drops the square: h″ contains f″(g(x))·(g′(x))², and the square makes that term positive despite g′ < 0. D: This is not a valid rule; h″ = f″(g)(g′)² + f′(g)g″ is positive here, regardless of the sign of g′.

**N-3.6-B-v1.** The functions f and g are twice differentiable on the real numbers. For all real t, f′(t) < 0 and f″(t) > 0, and for all real x, g′(x) > 0 and g″(x) > 0. Let h(x) = f(g(x)). Which statement is justified by this information alone?

- A. h is concave up on the real numbers, because f and g are both concave up.
- B. h is concave down on the real numbers, because f is decreasing.
- C. h is concave down on the real numbers, because f′(g(x))·g″(x) < 0 outweighs the other term.
- **D. The sign of h″ cannot be determined, because the two terms of h″ can have opposite signs.**

Check: h″ = f″(g)(g′)² + f′(g)g″. Here f″(g)(g′)² > 0 but f′(g)g″ < 0, so the sign of h″ depends on which term is larger, and the information does not decide that.
Rationales: A: Composing two concave up functions does not guarantee concave up; the term f′(g(x))·g″(x) is negative here. B: This confuses decreasing with concave down; h″ = f″(g)(g′)² + f′(g)g″ has a positive and a negative term here. C: Nothing in the information shows that the negative term is larger in size than f″(g(x))(g′(x))² for every x.

**N-3.6-B-v2.** The functions f and g are twice differentiable on the real numbers. For all real t, f′(t) > 0 and f″(t) < 0, and for all real x, g′(x) < 0 and g″(x) < 0. Let h(x) = f(g(x)). Which statement about the graph of h is correct?

- **A. h is concave down on the real numbers, because both terms of h″(x) are negative.**
- B. h is concave up on the real numbers, because g′ and g″ are both negative.
- C. The concavity of h cannot be determined, because g′ < 0 and f″ < 0 have the same sign.
- D. h is concave up on the real numbers, because f′(g(x))·g″(x) is negative and a negative times f″ is positive.

Check: h″(x) = f″(g(x))·(g′(x))² + f′(g(x))·g″(x). First term: (negative)(positive) < 0. Second term: (positive)(negative) < 0. So h″ < 0.
Rationales: B: Two negative signs in g do not produce a positive h″; the terms are f″(g)(g′)² < 0 and f′(g)g″ < 0. C: This drops the square, so f″(g)·g′ would be positive; the actual term f″(g)(g′)² is negative because the square is positive. D: Both terms of h″ are negative, so h″ < 0; multiplying by f″ is not part of the term f′(g)g″.

**N-3.6-B-v3.** The functions f and g are twice differentiable. At x = 1, g′(1) = −1 and g″(1) = 4, and the values f′(g(1)) = −2 and f″(g(1)) = 3 are known. Let h(x) = f(g(x)). Which statement about h at x = 1 is correct?

- A. h″(1) = −11, so the graph of h is concave down at x = 1.
- B. h″(1) = 12, so the graph of h is concave up at x = 1.
- **C. h″(1) = −5, so the graph of h is concave down at x = 1.**
- D. h″(1) = 3, so the graph of h is concave up at x = 1.

Check: h″ = f″(g(x))·(g′(x))² + f′(g(x))·g″(x) = 3·(−1)² + (−2)(4) = 3 − 8 = −5 < 0, so h is concave down at x = 1.
Rationales: A: This does not square g′(1): it uses f″(g)·g′ + f′(g)·g″ = −3 − 8 instead of f″(g)(g′)² + f′(g)g″. B: This multiplies the two second derivatives, f″(g(1))·g″(1), which ignores the chain and product rules. D: This keeps only f″(g(1))·(g′(1))² and drops the term f′(g(1))·g″(1) = −8.

---

