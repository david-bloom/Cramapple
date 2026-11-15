# AP Calculus AB topics 3.1 to 3.3: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (scratchpad).
Scope: replace three one-step families (apcalcab-mcq-007, -029, -030, 18 items; 029 also repeats two functions) with R3 seeds and variants, and add conceptual depth to topic 3.3 (8 items, all table or formula lookups). The R2 computation families (u3n-001 to u3n-009 and 008) are kept.
Target level: multi-rule differentiation with unspecified functions, interpretation of a composite rate, tangent-line geometry of implicit curves, and failure cases of inverse derivatives.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.1-A | 3.1 Chain rule | 007 and 029 families (product, chain and unspecified f) |
| N-3.1-B | 3.1 Chain rule | new: interpret a composite rate with units |
| N-3.2-A | 3.2 Implicit differentiation | 030 family: horizontal tangents |
| N-3.2-B | 3.2 Implicit differentiation | 030 family: vertical tangents and undefined dy/dx |
| N-3.3-A | 3.3 Inverse derivatives | tangent line to an inverse function |
| N-3.3-B | 3.3 Inverse derivatives | when the inverse is not differentiable |

---

## Seed N-3.1-A (replaces 007 and 029 families) — Topic 3.1 The Chain Rule
**Skill:** combine the product and chain rules when the outer function is unspecified.

Let f be a differentiable function and let h(x) = x²·f(3x). Which expression gives h′(x)?

- A. 2x·f(3x) + x²·f′(3x)
- B. 6x·f′(3x)
- **C. 2x·f(3x) + 3x²·f′(3x)**
- D. 2x·f(3x) + 3x²·f′(x)

Check: product rule gives 2x·f(3x) + x²·d/dx[f(3x)], and d/dx[f(3x)] = 3f′(3x).
Rationales: A: this forgets the inner derivative 3 from the chain rule when differentiating f(3x). B: this multiplies the derivatives of the two factors instead of using the product rule. D: the derivative of f must be evaluated at the inner function 3x, not at x.

**N-3.1-A-v1.** Let f be a differentiable function and let h(x) = (x + 1)·f(x²). Which expression gives h′(x)?

- A. f(x²) + (x + 1)·f′(x²)
- B. f′(x²)·2x
- **C. f(x²) + 2x(x + 1)·f′(x²)**
- D. f(x²) + (x + 1)·2x·f′(x)

Check: product rule gives 1·f(x²) + (x + 1)·2x·f′(x²).
Rationales: A: this drops the inner derivative 2x when differentiating f(x²). B: this differentiates only the factor f(x²) and ignores the product rule. D: f′ must be evaluated at the inner function x², not at x.

**N-3.1-A-v2.** Let f be a differentiable function and let h(x) = f(eˣ)/x for x > 0. Which expression gives h′(x)?

- A. (x·f′(eˣ) − f(eˣ))/x²
- B. (x·eˣ·f′(eˣ) + f(eˣ))/x²
- **C. (x·eˣ·f′(eˣ) − f(eˣ))/x²**
- D. (eˣ·f′(eˣ) − f(eˣ))/x

Check: quotient rule: [x·d/dx f(eˣ) − f(eˣ)·1]/x², with d/dx f(eˣ) = eˣ·f′(eˣ).
Rationales: A: this omits the factor eˣ from the chain rule applied to f(eˣ). B: this has a sign error in the numerator of the quotient rule. D: the quotient rule divides by the square of the denominator, x², not by x.

**N-3.1-A-v3.** Let f be a differentiable function and let h(x) = (f(x² + 1))². Which expression gives h′(x)?

- A. 2f(x² + 1)·f′(x² + 1)
- B. 4x·f′(x² + 1)
- C. 4x·f(x² + 1)
- **D. 4x·f(x² + 1)·f′(x² + 1)**

Check: outer square gives 2f(x² + 1), then f′(x² + 1), then the inner derivative 2x: 2·f·f′·2x = 4x·f(x² + 1)·f′(x² + 1).
Rationales: A: this omits the derivative of the innermost function x² + 1, which is 2x. B: this loses the factor f(x² + 1) that comes from differentiating the square. C: this loses the factor f′(x² + 1) that comes from differentiating f.

---

## Seed N-3.1-B (new) — Topic 3.1
**Skill:** interpret the chain rule as a rate of change of a rate, with units.

A weather balloon rises so that its altitude after t hours is h(t) kilometers. The air temperature at altitude h is T(h) degrees Celsius. At t = 2, h(2) = 3, h′(2) = 0.5, T(3) = −12 and T′(3) = −6.5. Which statement is correct about the temperature the balloon experiences, T(h(t)), at t = 2?

- A. It is decreasing at 6.5 degrees Celsius per hour.
- B. It is decreasing at 13 degrees Celsius per hour.
- C. It is decreasing at 3.25 degrees Celsius per kilometer.
- **D. It is decreasing at 3.25 degrees Celsius per hour.**

Check: d/dt T(h(t)) = T′(h(2))·h′(2) = (−6.5)(0.5) = −3.25 degrees Celsius per hour.
Rationales: A: this uses T′(3) alone, which is the rate per kilometer of altitude, and ignores how fast the balloon is rising. B: this divides by h′(2) instead of multiplying. C: the units of the composite rate are degrees per hour, since the derivative is with respect to time.

**N-3.1-B-v1.** The fuel economy of a car is E(v) kilometers per liter when it travels at v kilometers per hour. At t = 1 hour, the car's speed is v(1) = 60 and its speed is increasing at v′(1) = 5 kilometers per hour per hour, and E′(60) = −0.04 kilometers per liter per (kilometer per hour). Which statement is correct about d/dt E(v(t)) at t = 1?

- A. Fuel economy is decreasing at 0.04 kilometers per liter per hour.
- B. Fuel economy is decreasing at 0.008 kilometers per liter per hour.
- C. Fuel economy is increasing at 0.2 kilometers per liter per hour.
- **D. Fuel economy is decreasing at 0.2 kilometers per liter per hour.**

Check: E′(60)·v′(1) = (−0.04)(5) = −0.2 kilometers per liter per hour.
Rationales: A: this uses E′(60) alone and ignores that the speed is changing over time. B: this divides E′(60) by v′(1) instead of multiplying them. C: the product is negative, so fuel economy is decreasing, not increasing.

**N-3.1-B-v2.** The volume of water in a tank is V(h) liters when the depth is h centimeters, and V′(h) = 12 liters per centimeter at the current depth. The depth after t minutes is h(t), and h′(t) = −0.5 centimeters per minute at that moment. Which statement is correct?

- A. The volume is decreasing at 12 liters per minute.
- B. The volume is decreasing at 24 liters per minute.
- C. The volume is increasing at 6 liters per minute.
- **D. The volume is decreasing at 6 liters per minute.**

Check: d/dt V(h(t)) = V′(h)·h′(t) = (12)(−0.5) = −6 liters per minute.
Rationales: A: this uses V′(h) alone, which is per centimeter of depth and ignores the falling depth. B: this divides 12 by 0.5 instead of multiplying. C: the depth is falling, so the product is negative and the volume is decreasing.

**N-3.1-B-v3.** The pressure on a diver is P(d) atmospheres at depth d meters, and P′(d) = 0.1 atmospheres per meter at the diver's current depth. The diver is ascending, so the depth d(t) is changing at d′(t) = −3 meters per minute. Which statement is correct about the pressure on the diver?

- A. It is increasing at 0.1 atmospheres per minute.
- B. It is increasing at 0.3 atmospheres per minute.
- C. It is decreasing at 0.03 atmospheres per minute.
- **D. It is decreasing at 0.3 atmospheres per minute.**

Check: P′(d)·d′(t) = (0.1)(−3) = −0.3 atmospheres per minute.
Rationales: A: this uses P′(d) alone and ignores the diver's change in depth. B: ascending reduces depth, so the pressure falls and the rate is negative. C: this divides instead of multiplying the two rates.

---

## Seed N-3.2-A (replaces 030 family) — Topic 3.2 Implicit Differentiation
**Skill:** find where an implicitly defined curve has a horizontal tangent line.

At which points does the graph of x² + xy + y² = 7 have a horizontal tangent line?

- A. (±√7, 0)
- B. (0, ±√7)
- **C. (√21/3, −2√21/3) and (−√21/3, 2√21/3)**
- D. (−2√21/3, √21/3) and (2√21/3, −√21/3)

Check: dy/dx = −(2x + y)/(x + 2y). A horizontal tangent needs 2x + y = 0, so y = −2x, and then x² − 2x² + 4x² = 3x² = 7, so x = ±√21/3.
Rationales: A: these are the points where y = 0, which is not the condition for dy/dx = 0. B: these are the points where x = 0, which is not the condition for dy/dx = 0. D: these are the points where x + 2y = 0, where the tangent line is vertical rather than horizontal.

**N-3.2-A-v1.** At which points does the graph of x² − xy + y² = 3 have a horizontal tangent line?

- A. (±√3, 0)
- B. (0, ±√3)
- C. (2, 1) and (−2, −1)
- **D. (1, 2) and (−1, −2)**

Check: dy/dx = (y − 2x)/(2y − x). A horizontal tangent needs y = 2x, and then x² − 2x² + 4x² = 3x² = 3, so x = ±1.
Rationales: A: these are the points where y = 0, which is not the condition for dy/dx = 0. B: these are the points where x = 0, which is not the condition for dy/dx = 0. C: these are the points where x = 2y, where the tangent is vertical.

**N-3.2-A-v2.** Which statement about the graph of x² + 4y² = 16 is correct?

- A. It has horizontal tangent lines at (±4, 0).
- B. It has horizontal tangent lines at (±2√2, ±√2).
- C. It has no horizontal tangent line, because dy/dx = −x/(4y) is undefined whenever y = 0.
- **D. It has horizontal tangent lines at (0, ±2).**

Check: dy/dx = −x/(4y) equals 0 when x = 0, and then 4y² = 16 gives y = ±2.
Rationales: A: at (±4, 0) the denominator 4y is 0, so the tangent lines are vertical. B: these points lie on the curve, but dy/dx there is −1/2 or 1/2, not 0. C: dy/dx = 0 requires only that the numerator be 0, and the denominator being 0 elsewhere does not remove other points.

**N-3.2-A-v3.** At which points does the graph of y² = x³ − 3x have a horizontal tangent line?

- A. (0, 0)
- B. (1, ±√2)
- C. (−1, ±√2) and (1, ±√2)
- **D. (−1, √2) and (−1, −√2)**

Check: 2y·y′ = 3x² − 3, so y′ = (3x² − 3)/(2y) = 0 at x = ±1; y² = x³ − 3x gives y² = 2 at x = −1 but y² = −2 at x = 1, so only x = −1 is on the curve.
Rationales: A: at (0, 0) the denominator 2y is 0, so dy/dx is not 0 there. B: x = 1 gives y² = 1 − 3 = −2, so these points are not on the curve. C: only the points with x = −1 lie on the curve, and the points with x = 1 do not.

---

## Seed N-3.2-B (replaces 030 family) — Topic 3.2
**Skill:** interpret a point where dy/dx is undefined.

For the circle x² + y² = 25, which statement is correct?

- A. dy/dx is undefined at (0, 5) and (0, −5), where the tangent lines are vertical.
- B. dy/dx is undefined at (5, 0) and (−5, 0), so the circle has no tangent line at those points.
- C. dy/dx = 0 at (5, 0) and (−5, 0), where the tangent lines are horizontal.
- **D. dy/dx is undefined at (5, 0) and (−5, 0), where the tangent lines are vertical.**

Check: dy/dx = −x/y is undefined when y = 0, which gives (±5, 0); there the tangent lines are x = ±5.
Rationales: A: dy/dx = −x/y at (0, 5) equals 0, so the tangent line there is horizontal. B: an undefined derivative formula at a point on a smooth curve signals a vertical tangent, not the absence of one. C: at (5, 0) the denominator y is 0, so the slope is not 0.

**N-3.2-B-v1.** At which points does the graph of x² − 2xy + 2y² = 4 have a vertical tangent line?

- A. (2, 2) and (−2, −2)
- B. (±2, 0)
- C. (0, ±√2)
- **D. (2√2, √2) and (−2√2, −√2)**

Check: dy/dx = (x − y)/(x − 2y). A vertical tangent needs x = 2y, and then 4y² − 4y² + 2y² = 2y² = 4, so y = ±√2 and x = ±2√2.
Rationales: A: these are the points where x = y, which makes the numerator 0 and the tangent horizontal. B: the points (±2, 0) lie on the curve, but there x − 2y = ±2 is not 0, so the tangent is not vertical; these come from setting y = 0. C: the points (0, ±√2) lie on the curve, but there x − 2y is not 0, so the tangent is not vertical; these come from setting x = 0.

**N-3.2-B-v2.** What is an equation of the line tangent to the graph of x² + 4y² = 16 at the point (4, 0)?

- A. y = 0
- B. y = −(x − 4)/4
- C. There is no tangent line, because dy/dx is undefined at (4, 0).
- **D. x = 4**

Check: dy/dx = −x/(4y) is undefined at (4, 0), and the tangent there is the vertical line x = 4.
Rationales: A: y = 0 is a horizontal line, but the slope at (4, 0) is infinite, not 0. B: this uses a finite slope that does not come from dy/dx at this point. C: a curve can have a vertical tangent line where dy/dx is undefined, and the ellipse is smooth at (4, 0).

**N-3.2-B-v3.** A student differentiates x² + y² = 25 to get dy/dx = −x/y and concludes that the circle has no tangent line at (5, 0) because the slope is undefined. Which statement best describes the error?

- A. The derivative is wrong, because dy/dx should be x/y.
- B. A tangent line exists only where dy/dx = 0.
- C. The point (5, 0) is not on the circle.
- **D. An undefined slope here means the tangent line is vertical (x = 5), not that no tangent line exists.**

Check: (5, 0) satisfies 25 = 25, and the tangent there is x = 5.
Rationales: A: the derivative −x/y is correct for this circle. B: a tangent line exists wherever the curve is smooth, whether the slope is 0, finite, or infinite. C: the point (5, 0) satisfies the equation, since 25 + 0 = 25.

---

## Seed N-3.3-A (new) — Topic 3.3 Differentiating Inverse Functions
**Skill:** write the tangent line to an inverse function from the original function's values.

The function f is differentiable and increasing, with f(2) = 5 and f′(2) = 1/3. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = 5?

- A. y − 5 = 3(x − 2)
- B. y − 2 = (1/3)(x − 5)
- C. y − 2 = −3(x − 5)
- **D. y − 2 = 3(x − 5)**

Check: f⁻¹(5) = 2 and (f⁻¹)′(5) = 1/f′(2) = 3, so y − 2 = 3(x − 5).
Rationales: A: this swaps the coordinates, using the point (2, 5), which lies on f and not on f⁻¹. B: this uses the slope of f instead of its reciprocal. C: the slope of the inverse is the reciprocal of f′, not the negative reciprocal.

**N-3.3-A-v1.** The function f is differentiable and one-to-one, with f(1) = 4 and f′(1) = −2. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = 4?

- A. y − 4 = −(1/2)(x − 1)
- B. y − 1 = −2(x − 4)
- C. y − 1 = (1/2)(x − 4)
- **D. y − 1 = −(1/2)(x − 4)**

Check: f⁻¹(4) = 1 and (f⁻¹)′(4) = 1/f′(1) = −1/2, so y − 1 = −(1/2)(x − 4).
Rationales: A: this swaps the coordinates and uses the point (1, 4) on f instead of (4, 1) on f⁻¹. B: this uses the slope of f instead of its reciprocal. C: this drops the negative sign when taking the reciprocal of −2.

**N-3.3-A-v2.** Let f(x) = x³ + x, which is one-to-one. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = 2?

- A. y − 2 = (1/4)(x − 1)
- B. y − 1 = 4(x − 2)
- C. y − 1 = (1/4)(x − 1)
- **D. y − 1 = (1/4)(x − 2)**

Check: f(1) = 2, so f⁻¹(2) = 1; f′(1) = 4, so (f⁻¹)′(2) = 1/4 and y − 1 = (1/4)(x − 2).
Rationales: A: this swaps the coordinates, using (1, 2) on f instead of (2, 1) on f⁻¹. B: this uses the slope of f instead of its reciprocal. C: the tangent is at x = 2 on the inverse, so the point is (2, 1), not x = 1.

**N-3.3-A-v3.** The function f is differentiable and one-to-one, with f(3) = −1 and f′(3) = 5. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = −1?

- A. y + 1 = (1/5)(x − 3)
- B. y − 3 = 5(x + 1)
- C. y − 3 = (1/5)(x − 1)
- **D. y − 3 = (1/5)(x + 1)**

Check: f⁻¹(−1) = 3 and (f⁻¹)′(−1) = 1/f′(3) = 1/5, so y − 3 = (1/5)(x + 1).
Rationales: A: this swaps the coordinates and uses the point (3, −1) on f. B: this uses the slope of f instead of its reciprocal. C: this has the wrong x value; the point on the inverse has x = −1, so the factor is (x + 1).

---

## Seed N-3.3-B (new) — Topic 3.3
**Skill:** recognize when an inverse function is not differentiable.

The function f(x) = x³ is one-to-one. Which statement about (f⁻¹)′(0) is correct?

- A. (f⁻¹)′(0) = 0, because f(0) = 0.
- B. (f⁻¹)′(0) = 1/3, because f⁻¹(x) = x^(1/3).
- C. (f⁻¹)′(0) = 1, because an inverse function reflects the graph across y = x.
- **D. (f⁻¹)′(0) does not exist, because f′(0) = 0 and the formula 1/f′(0) is undefined.**

Check: (f⁻¹)′(0) = 1/f′(f⁻¹(0)) = 1/f′(0) = 1/0; the graph of x^(1/3) has a vertical tangent at the origin.
Rationales: A: f(0) = 0 does not make the derivative of the inverse 0; the derivative of the inverse is the reciprocal of f′. B: the power rule gives (1/3)x^(−2/3), which is undefined at x = 0. C: reflection across y = x swaps slopes into reciprocals, and the slope of f at 0 is 0, so the reciprocal is not 1.

**N-3.3-B-v1.** The function f(x) = (x − 1)³ + 2 is one-to-one. Which statement about (f⁻¹)′(2) is correct?

- A. (f⁻¹)′(2) = 0, because f′(2) = 3.
- B. (f⁻¹)′(2) = 1/3, because f′(2) = 3.
- C. (f⁻¹)′(2) = 1, because f(1) = 2.
- **D. (f⁻¹)′(2) does not exist, because f⁻¹(2) = 1 and f′(1) = 0.**

Check: f(1) = 2, so f⁻¹(2) = 1; f′(1) = 3(1 − 1)² = 0, so 1/f′(1) is undefined.
Rationales: A: f′ must be evaluated at f⁻¹(2) = 1 and not at 2, and the reciprocal of its value is not 0. B: this evaluates f′ at 2 instead of at f⁻¹(2) = 1. C: f(1) = 2 identifies the point, but the derivative is a reciprocal of f′(1), which is 0.

**N-3.3-B-v2.** The function f(x) = x³ + 3x is one-to-one. Which statement about (f⁻¹)′(0) is correct?

- A. (f⁻¹)′(0) does not exist, because f is a cubic and cubics have a vertical tangent at the origin.
- B. (f⁻¹)′(0) = 0, because f(0) = 0.
- C. (f⁻¹)′(0) = 3, because f′(0) = 3.
- **D. (f⁻¹)′(0) = 1/3, because f⁻¹(0) = 0 and f′(0) = 3.**

Check: f(0) = 0 and f′(0) = 3(0)² + 3 = 3, so (f⁻¹)′(0) = 1/3.
Rationales: A: this version of the cubic has f′(0) = 3, which is not 0, so the inverse is differentiable at 0. B: f(0) = 0 locates the point, and the derivative is a reciprocal of f′(0). C: this forgets to take the reciprocal of f′(0).

**N-3.3-B-v3.** Let f(x) = sin x on the interval −π/2 ≤ x ≤ π/2, so f is one-to-one. Which statement about (f⁻¹)′(1) is correct?

- A. (f⁻¹)′(1) = 1, because f(π/2) = 1.
- B. (f⁻¹)′(1) = cos 1, because f′(x) = cos x.
- C. (f⁻¹)′(1) = 0, because the sine function has a maximum at x = π/2.
- **D. (f⁻¹)′(1) does not exist, because f⁻¹(1) = π/2 and f′(π/2) = cos(π/2) = 0.**

Check: f⁻¹(1) = π/2; f′(π/2) = 0, so 1/f′(π/2) is undefined; the arcsine graph has a vertical tangent at x = 1.
Rationales: A: f(π/2) = 1 locates the point, but the derivative of the inverse is the reciprocal of f′(π/2), which is 0. B: this evaluates f′ at 1 instead of at f⁻¹(1) = π/2. C: the maximum of f makes f′(π/2) = 0, but the derivative of the inverse is then undefined, not 0.
