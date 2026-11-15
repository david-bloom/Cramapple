# AP Precalculus topics 3.10 to 3.15: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. All counts, solution sets, ranges, conversions and polar properties recomputed in Python (math module) before writing.
Scope: the published practice MCQs for 3.10 to 3.15 that are one-step recall are replaced with R3-level seeds (3 variants each). Families kept as genuinely R2: 071 and 072 in 3.15. Teaching (OHT) items stay, as do the two do-not-retire variants listed in retire_keys.json.
Target level: counting and completeness of trigonometric solutions, inequalities, reciprocal-function ranges and asymptotes, invalid identities and double angles, polar representations and curve features, and the sign logic of polar rates of change.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.10-A | 3.10 Trigonometric Equations and Inequalities | 017 family |
| N-3.10-B | 3.10 Trigonometric Equations and Inequalities | new |
| N-3.11-A | 3.11 The Secant, Cosecant, and Cotangent Functions | np2-010 family |
| N-3.11-B | 3.11 The Secant, Cosecant, and Cotangent Functions | new |
| N-3.12-A | 3.12 Equivalent Representations of Trigonometric Functions | 047 family |
| N-3.12-B | 3.12 Equivalent Representations of Trigonometric Functions | new |
| N-3.13-A | 3.13 Trigonometry and Polar Coordinates | 019 family and np2-008 family |
| N-3.13-B | 3.13 Trigonometry and Polar Coordinates | new |
| N-3.14-A | 3.14 Polar Function Graphs | 049 family |
| N-3.14-B | 3.14 Polar Function Graphs | 020 family |
| N-3.15-A | 3.15 Rates of Change in Polar Functions | new (keeps 071 and 072 families) |
| N-3.15-B | 3.15 Rates of Change in Polar Functions | new (keeps 071 and 072 families) |

---

## Seed N-3.10-A (replaces 017 family) — Topic 3.10 Trigonometric Equations and Inequalities
**Skill:** count the solutions of a trigonometric equation with a changed input coefficient on an interval, avoiding lost or extra solutions (including the single-solution case sin u = 1).

How many solutions does the equation 2 sin(3x) = √3 have on the interval 0 ≤ x < 2π?

- **A. 6**
- B. 2
- C. 3
- D. 12

Check: Let u = 3x, so 0 ≤ u < 6π, three full cycles. sin u = √3/2 has two solutions per cycle (π/3 and 2π/3 plus multiples of 2π), so 2 × 3 = 6 solutions.
Rationales: B: Solving sin x = √3/2 gives only 2 solutions, but 3x runs through three full cycles on this interval, so this count is far too small. C: One solution per cycle is counted, but sin u = √3/2 has two solutions in every cycle (u = π/3 and u = 2π/3), so this is half the true count. D: This lets 3x run to 12π instead of 6π, doubling the number of cycles, so the count is twice too large.

**N-3.10-A-v1.** How many solutions does the equation 2 cos(2x) = −1 have on the interval 0 ≤ x < 2π?

- A. 2
- B. 8
- C. 3
- **D. 4**

Check: Let u = 2x, so 0 ≤ u < 4π, two full cycles. cos u = −1/2 has two solutions per cycle (2π/3 and 4π/3), so 2 × 2 = 4 solutions (x = π/3, 2π/3, 4π/3, 5π/3).
Rationales: A: Solving cos x = −1/2 gives 2 solutions, but 2x runs through two full cycles, so the count must double. B: This counts four solutions per cycle of 2x, but cos u = −1/2 has only two solutions per cycle (2π/3 and 4π/3). C: This drops one of the four solutions as if it fell outside the interval, but x = π/3, 2π/3, 4π/3 and 5π/3 all lie in [0, 2π).

**N-3.10-A-v2.** How many solutions does the equation sin(4x) = 1 have on the interval 0 ≤ x < 2π?

- A. 8
- B. 2
- **C. 4**
- D. 16

Check: Let u = 4x, so 0 ≤ u < 8π, four full cycles. sin u = 1 has exactly one solution per cycle (u = π/2 + 2πk), so 4 solutions (x = π/8, 5π/8, 9π/8, 13π/8).
Rationales: A: This uses two solutions per cycle, as for most values of sine, but sin u = 1 occurs only once per cycle (u = π/2), at the top of the wave. B: This solves sin x = 1 only (one solution per cycle) and forgets that 4x runs through four cycles. D: This multiplies by 4 twice, once for the cycles and once for the coefficient, giving four times the true count.

**N-3.10-A-v3.** How many solutions does the equation cos(3x) = 1/2 have on the interval 0 ≤ x ≤ π?

- A. 6
- **B. 3**
- C. 2
- D. 4

Check: Let u = 3x, so 0 ≤ u ≤ 3π. cos u = 1/2 at u = π/3, 5π/3 and 7π/3 (the next, 11π/3, exceeds 3π), so there are 3 solutions.
Rationales: A: This treats 3x as covering three full cycles, but 0 ≤ 3x ≤ 3π is only one and a half cycles. C: This counts only the two solutions in the first cycle (u = π/3 and 5π/3) and ignores that 3x continues past 2π to 7π/3. D: This lets 3x run to 4π instead of 3π, which picks up solutions at 11π/3 that lie outside the interval.

---

## Seed N-3.10-B (new) — Topic 3.10 Trigonometric Equations and Inequalities
**Skill:** solve a trigonometric inequality on an interval, keeping every arc and reversing the inequality when dividing by a negative.

On the interval 0 ≤ x < 2π, which gives the complete solution set of 2cos x + 1 > 0?

- A. (2π/3, 4π/3)
- **B. [0, 2π/3) ∪ (4π/3, 2π)**
- C. [0, π/3) ∪ (5π/3, 2π)
- D. [0, 2π/3)

Check: 2cos x + 1 > 0 gives cos x > −1/2. Cosine equals −1/2 at 2π/3 and 4π/3 and is larger outside the arc between them, so x is in [0, 2π/3) ∪ (4π/3, 2π).
Rationales: A: This is where cos x < −1/2; the inequality sign was reversed, so it gives the region the inequality excludes. C: This solves cos x > 1/2 by using the reference angle π/3 and ignoring the sign, but the inequality is cos x > −1/2. D: This keeps only the part near 0 and loses the symmetric piece (4π/3, 2π) where cosine is also greater than −1/2.

**N-3.10-B-v1.** On the interval 0 ≤ x < 2π, which gives the complete solution set of sin x ≤ −√2/2?

- **A. [5π/4, 7π/4]**
- B. [0, 5π/4] ∪ [7π/4, 2π)
- C. [π/4, 3π/4]
- D. [7π/6, 11π/6]

Check: sin x = −√2/2 at 5π/4 and 7π/4, and sine is at or below that value between them (down to −1 at 3π/2), so x is in [5π/4, 7π/4].
Rationales: B: This is where sin x ≥ −√2/2; the inequality direction was reversed, so it describes the complement of the solution set. C: This solves sin x ≥ √2/2 and drops the negative sign, so the arc lies in the upper half of the circle where sine is positive. D: This uses the endpoints where sin x = −1/2 (reference angle π/6) instead of −√2/2 (reference angle π/4).

**N-3.10-B-v2.** On the interval 0 ≤ x < 2π, which gives the complete solution set of 2sin x > 1?

- A. [0, π/6) ∪ (5π/6, 2π)
- B. (π/3, 2π/3)
- C. (π/6, π/2)
- **D. (π/6, 5π/6)**

Check: 2sin x > 1 gives sin x > 1/2. Sine equals 1/2 at π/6 and 5π/6 and exceeds it between them, so x is in (π/6, 5π/6).
Rationales: A: This is where sin x < 1/2; it describes the region outside the arc where sine exceeds 1/2. B: This uses the angles where sin x = √3/2 instead of 1/2, so it cuts off part of the solution set. C: This stops at π/2, losing the portion (π/2, 5π/6) in the second quadrant where sine is still greater than 1/2.

**N-3.10-B-v3.** On the interval 0 ≤ x < 2π, which gives the complete solution set of −2cos x > √3?

- A. [0, 5π/6) ∪ (7π/6, 2π)
- B. (π/6, 11π/6)
- **C. (5π/6, 7π/6)**
- D. (3π/4, 5π/4)

Check: Dividing −2cos x > √3 by −2 reverses the inequality: cos x < −√3/2. Cosine equals −√3/2 at 5π/6 and 7π/6 and is smaller between them, so x is in (5π/6, 7π/6).
Rationales: A: This divides by −2 without reversing the inequality, solving cos x > −√3/2 instead of cos x < −√3/2. B: This reverses the inequality correctly but drops the negative sign, solving cos x < √3/2. D: This uses the angles where cos x = −√2/2 instead of −√3/2, so the arc is too wide.

---

## Seed N-3.11-A (replaces np2-010 family) — Topic 3.11 The Secant, Cosecant, and Cotangent Functions
**Skill:** find the range of a transformed secant or cosecant function by combining the |value| ≥ 1 restriction with a stretch, reflection and shift.

What is the range of the function y = 2csc x − 1?

- A. [−3, 1]
- B. (−∞, −2] ∪ [2, ∞)
- **C. (−∞, −3] ∪ [1, ∞)**
- D. (−∞, −1] ∪ [3, ∞)

Check: csc x ≤ −1 or csc x ≥ 1. Doubling gives ≤ −2 or ≥ 2, and subtracting 1 gives y ≤ −3 or y ≥ 1, so the range is (−∞, −3] ∪ [1, ∞).
Rationales: A: This treats csc x like a bounded wave with values between −1 and 1; the cosecant takes every value with magnitude at least 1, so it is unbounded. B: This applies the vertical stretch by 2 but forgets the shift down by 1. D: This shifts the stretched range up by 1 instead of down by 1.

**N-3.11-A-v1.** What is the range of the function y = 3sec x + 2?

- A. [−1, 5]
- **B. (−∞, −1] ∪ [5, ∞)**
- C. (−∞, −3] ∪ [3, ∞)
- D. (−∞, −5] ∪ [1, ∞)

Check: sec x ≤ −1 or sec x ≥ 1. Tripling gives ≤ −3 or ≥ 3, and adding 2 gives y ≤ −1 or y ≥ 5, so the range is (−∞, −1] ∪ [5, ∞).
Rationales: A: This treats sec x like a bounded wave oscillating about the shift; the secant has no maximum or minimum on its two branches, so the range is unbounded. C: This applies the vertical stretch by 3 but forgets the shift up by 2. D: This shifts the stretched range down by 2 instead of up by 2.

**N-3.11-A-v2.** What is the range of the function y = −2csc x + 1?

- **A. (−∞, −1] ∪ [3, ∞)**
- B. [−1, 3]
- C. (−∞, −3] ∪ [1, ∞)
- D. (−∞, −2] ∪ [2, ∞)

Check: csc x ≤ −1 or csc x ≥ 1, so −2csc x ≥ 2 or ≤ −2 (a reflection keeps the same two pieces). Adding 1 gives y ≤ −1 or y ≥ 3, so the range is (−∞, −1] ∪ [3, ∞).
Rationales: B: This treats the values between the two branches as attained, but |csc x| ≥ 1, so the stretched and shifted function never takes values between −1 and 3 and is unbounded. C: This shifts the range down by 1 instead of up by 1; the reflection does not change the symmetric set of magnitudes ≥ 2. D: This applies the stretch and reflection but forgets the shift up by 1.

**N-3.11-A-v3.** What is the range of the function y = (1/2)sec x − 3?

- A. [−7/2, −5/2]
- B. (−∞, −1/2] ∪ [1/2, ∞)
- C. (−∞, −4] ∪ [−2, ∞)
- **D. (−∞, −7/2] ∪ [−5/2, ∞)**

Check: sec x ≤ −1 or sec x ≥ 1. Halving gives ≤ −1/2 or ≥ 1/2, and subtracting 3 gives y ≤ −7/2 or y ≥ −5/2, so the range is (−∞, −7/2] ∪ [−5/2, ∞).
Rationales: A: This takes the endpoints of the two branches as a closed bounded interval; the secant is unbounded on both branches, so the range is not bounded. B: This applies the vertical compression by 1/2 but forgets the shift down by 3. C: This forgets the vertical compression and uses magnitudes of at least 1, then shifts down by 3.

---

## Seed N-3.11-B (new) — Topic 3.11 The Secant, Cosecant, and Cotangent Functions
**Skill:** locate every vertical asymptote of a secant or cosecant graph with a horizontal compression and phase shift, on a given interval.

On the interval 0 ≤ x ≤ π, at which x-values does the graph of y = csc(2x − π/3) have vertical asymptotes?

- A. {π/3, 5π/6}
- B. {0, π/2, π}
- C. {π/6}
- **D. {π/6, 2π/3}**

Check: Asymptotes occur where sin(2x − π/3) = 0, so 2x − π/3 = kπ and x = π/6 + kπ/2. In [0, π] this gives k = 0 and k = 1: x = π/6 and x = 2π/3 (k = 2 gives 7π/6, outside the interval).
Rationales: A: This solves 2x + π/3 = kπ, shifting the wrong way, so every asymptote lands π/3 away from the true location. B: This gives the zeros of sin(2x), ignoring the phase shift of π/3 inside the argument. C: This finds the first asymptote but steps by π instead of π/2 between asymptotes, forgetting that 2x halves the spacing.

**N-3.11-B-v1.** On the interval 0 ≤ x ≤ 2π/3, at which x-values does the graph of y = sec(3x + π/2) have vertical asymptotes?

- A. {π/6, π/2}
- B. {π/3, 2π/3}
- **C. {0, π/3, 2π/3}**
- D. {0, 2π/3}

Check: Asymptotes occur where cos(3x + π/2) = 0, so 3x + π/2 = π/2 + kπ and x = kπ/3. In [0, 2π/3] this gives x = 0, π/3 and 2π/3 (equivalently cos(3x + π/2) = −sin 3x, which is zero at multiples of π/3).
Rationales: A: This gives the zeros of cos(3x), ignoring the phase shift of π/2 inside the argument. B: This solves 3x − π/2 = π/2 + kπ, shifting the wrong way, which loses the asymptote at x = 0. D: This steps by 2π/3 instead of π/3 between asymptotes, treating the spacing as a full period of the argument rather than a half period.

**N-3.11-B-v2.** On the interval 0 ≤ x ≤ 4π, at which x-values does the graph of y = csc(x/2 − π/4) have vertical asymptotes?

- A. {0, 2π, 4π}
- **B. {π/2, 5π/2}**
- C. {3π/2, 7π/2}
- D. {π/2, 3π/2, 5π/2, 7π/2}

Check: Asymptotes occur where sin(x/2 − π/4) = 0, so x/2 − π/4 = kπ and x = π/2 + 2kπ. In [0, 4π] this gives x = π/2 and x = 5π/2 (k = 2 gives 9π/2, outside the interval).
Rationales: A: This gives the zeros of sin(x/2), ignoring the phase shift of π/4 inside the argument. C: This solves x/2 + π/4 = kπ, shifting the wrong way, which moves each asymptote by π. D: This steps by π between asymptotes, forgetting that x/2 stretches the spacing to 2π.

**N-3.11-B-v3.** On the interval 0 ≤ x ≤ 2π, at which x-values does the graph of y = sec(2x − π) have vertical asymptotes?

- **A. {π/4, 3π/4, 5π/4, 7π/4}**
- B. {0, π/2, π, 3π/2, 2π}
- C. {π/2, 3π/2}
- D. {3π/4, 7π/4}

Check: Asymptotes occur where cos(2x − π) = 0, so 2x − π = π/2 + kπ and x = 3π/4 + kπ/2. In [0, 2π] the values are π/4, 3π/4, 5π/4 and 7π/4.
Rationales: B: This gives the zeros of sin(2x), as for a cosecant function; a secant has asymptotes where cosine is zero instead. C: This gives the zeros of cos x, ignoring both the compression by 2 and the phase shift. D: This solves 2x − π = π/2 + kπ but steps by π between asymptotes instead of π/2, so it loses half of them.

---

## Seed N-3.12-A (replaces 047 family) — Topic 3.12 Equivalent Representations of Trigonometric Functions
**Skill:** identify the one invalid identity among four by recognizing which algebraic or trigonometric shortcut fails (square root, sign under a shift, missing cross term, missing factor).

Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?

- **A. √(sin²x) = sin x**
- B. (1 − cos x)(1 + cos x) = sin²x
- C. sec²x − tan²x = 1
- D. csc x · tan x = sec x

Check: For x = 3π/2, the left side √(sin²x) = √1 = 1, but sin x = −1, so the equation fails. The other three simplify to equal expressions.
Rationales: B: This is a true identity: the product is a difference of squares equal to 1 − cos²x, which equals sin²x by the Pythagorean identity. C: This is a true identity: dividing sin²x + cos²x = 1 by cos²x gives tan²x + 1 = sec²x, which rearranges to this. D: This is a true identity: (1/sin x)(sin x/cos x) = 1/cos x, so both sides equal sec x.

**N-3.12-A-v1.** Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?

- A. cos x · tan x = sin x
- B. 1/(1 − sin x) + 1/(1 + sin x) = 2sec²x
- C. sin(x + π) = −sin x
- **D. cos(π − x) = cos x**

Check: Take x = π/3: cos(π − π/3) = cos(2π/3) = −1/2, but cos(π/3) = 1/2, so the equation fails; it holds only with a negative sign.
Rationales: A: This is a true identity: cos x · (sin x/cos x) = sin x wherever tan x is defined. B: This is a true identity: the sum is 2/(1 − sin²x) = 2/cos²x = 2sec²x. C: This is a true identity: a half-turn of π moves the point to the opposite side of the unit circle and negates the sine.

**N-3.12-A-v2.** Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?

- A. (sin x + cos x)² = 1 + 2sin x cos x
- B. cot²x + 1 = csc²x
- **C. (sin x + cos x)² = sin²x + cos²x**
- D. sin(π/2 − x) = cos x

Check: Take x = π/4: (√2/2 + √2/2)² = 2, but sin²x + cos²x = 1, so the equation fails because the cross term 2sin x cos x is missing.
Rationales: A: This is a true identity: expanding gives sin²x + 2sin x cos x + cos²x, and sin²x + cos²x = 1. B: This is a true identity: dividing sin²x + cos²x = 1 by sin²x gives 1 + cot²x = csc²x. D: This is a true identity: sine of the complement equals the cosine, as the cofunction identity states.

**N-3.12-A-v3.** Which of the following equations is NOT an identity (that is, is not true for every x for which both sides are defined)?

- A. cos 2x = 2cos²x − 1
- **B. sin 2x = 2 sin x**
- C. tan x + cot x = sec x csc x
- D. sin²x = (1 − cos 2x)/2

Check: Take x = π/2: sin π = 0 but 2sin(π/2) = 2, so the equation fails; the correct double-angle formula is sin 2x = 2 sin x cos x.
Rationales: A: This is a true identity: it is the double-angle formula cos 2x = cos²x − sin²x with sin²x replaced by 1 − cos²x. C: This is a true identity: sin x/cos x + cos x/sin x = (sin²x + cos²x)/(sin x cos x) = 1/(sin x cos x). D: This is a true identity: it is the double-angle formula cos 2x = 1 − 2sin²x solved for sin²x.

---

## Seed N-3.12-B (new) — Topic 3.12 Equivalent Representations of Trigonometric Functions
**Skill:** apply the double-angle identity after recovering the missing ratio and its sign from the quadrant, avoiding the cos 2θ and missing-factor traps.

The angle θ is in the fourth quadrant and cos θ = 3/5. What is the value of sin 2θ?

- A. 24/25
- **B. −24/25**
- C. −7/25
- D. −12/25

Check: The Pythagorean identity gives sin θ = −4/5 (sign from the fourth quadrant). Then sin 2θ = 2 sin θ cos θ = 2(−4/5)(3/5) = −24/25.
Rationales: A: This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this. C: This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ. D: This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.

**N-3.12-B-v1.** The angle θ is in the second quadrant and sin θ = 5/13. What is the value of sin 2θ?

- **A. −120/169**
- B. 120/169
- C. 119/169
- D. −60/169

Check: The Pythagorean identity gives cos θ = −12/13 (sign from the second quadrant). Then sin 2θ = 2 sin θ cos θ = 2(5/13)(−12/13) = −120/169.
Rationales: B: This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this. C: This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ. D: This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.

**N-3.12-B-v2.** The angle θ is in the third quadrant and cos θ = −4/5. What is the value of sin 2θ?

- A. −24/25
- B. 7/25
- C. 12/25
- **D. 24/25**

Check: The Pythagorean identity gives sin θ = −3/5 (sign from the third quadrant). Then sin 2θ = 2 sin θ cos θ = 2(−3/5)(−4/5) = 24/25.
Rationales: A: This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this. B: This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ. C: This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.

**N-3.12-B-v3.** The angle θ is in the fourth quadrant and sin θ = −8/17. What is the value of sin 2θ?

- A. 240/289
- B. 161/289
- **C. −240/289**
- D. −120/289

Check: The Pythagorean identity gives cos θ = 15/17 (sign from the fourth quadrant). Then sin 2θ = 2 sin θ cos θ = 2(−8/17)(15/17) = −240/289.
Rationales: A: This computes the magnitude correctly but gives it the wrong sign; in this quadrant sin θ and cos θ have signs whose product is the opposite of this. B: This is the value of cos 2θ = cos²θ − sin²θ, not sin 2θ. D: This is sin θ cos θ and omits the factor 2 in the identity sin 2θ = 2 sin θ cos θ.

---

## Seed N-3.13-A (replaces 019 family and np2-008 family) — Topic 3.13 Trigonometry and Polar Coordinates
**Skill:** convert a rectangular point to polar form with a required negative radius, choosing the direction opposite to the point's quadrant.

Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (−3, 3)?

- A. (−3√2, 3π/4)
- B. (−3√2, π/4)
- **C. (−3√2, 7π/4)**
- D. (3√2, 7π/4)

Check: The point is √18 = 3√2 from the pole in direction 3π/4. A negative radius points the opposite way, so use r = −3√2 with θ = 3π/4 + π = 7π/4. Check: x = −3√2 cos(7π/4) = −3 and y = −3√2 sin(7π/4) = 3.
Rationales: A: This uses the actual direction 3π/4 of the point and also makes r negative, which sends the point to the opposite side, at (3, −3). B: This negative radius at angle π/4 lands in the third quadrant at (−3, −3); the reference angle was used without adjusting for the direction. D: This has a positive radius, which violates r < 0, and the angle 7π/4 points to the fourth quadrant, giving (3, −3).

**N-3.13-A-v1.** Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (2√3, −2)?

- A. (−4, 11π/6)
- **B. (−4, 5π/6)**
- C. (−4, π/6)
- D. (−4, 7π/6)

Check: The point is 4 units from the pole in direction 11π/6 (fourth quadrant). A negative radius points the opposite way, so use r = −4 with θ = 11π/6 − π = 5π/6. Check: x = −4 cos(5π/6) = 2√3 and y = −4 sin(5π/6) = −2.
Rationales: A: This uses the actual direction 11π/6 with a negative radius, which lands at (−2√3, 2), the opposite point. C: This uses the reference angle π/6 with a negative radius, giving (−2√3, −2), in the third quadrant. D: This negative radius at 7π/6 gives (2√3, 2), which has the correct x-coordinate but the wrong sign of y.

**N-3.13-A-v2.** Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (−2, −2√3)?

- **A. (−4, π/3)**
- B. (−4, 4π/3)
- C. (−4, 2π/3)
- D. (−4, 5π/3)

Check: The point is 4 units from the pole in direction 4π/3 (third quadrant). A negative radius points the opposite way, so use r = −4 with θ = 4π/3 − π = π/3. Check: x = −4 cos(π/3) = −2 and y = −4 sin(π/3) = −2√3.
Rationales: B: This uses the actual direction 4π/3 with a negative radius, which lands at (2, 2√3), the opposite point. C: This negative radius at 2π/3 gives (2, −2√3), the mirror image across the y-axis. D: This negative radius at 5π/3 gives (−2, 2√3), the mirror image across the x-axis.

**N-3.13-A-v3.** Which polar pair (r, θ) with r < 0 and 0 ≤ θ < 2π names the point with rectangular coordinates (3, 3√3)?

- A. (−6, π/3)
- B. (−6, 2π/3)
- C. (−6, 5π/3)
- **D. (−6, 4π/3)**

Check: The point is 6 units from the pole in direction π/3 (first quadrant). A negative radius points the opposite way, so use r = −6 with θ = π/3 + π = 4π/3. Check: x = −6 cos(4π/3) = 3 and y = −6 sin(4π/3) = 3√3.
Rationales: A: This uses the actual direction π/3 with a negative radius, which lands at (−3, −3√3), the opposite point. B: This negative radius at 2π/3 gives (3, −3√3), the mirror image across the x-axis. C: This negative radius at 5π/3 gives (−3, 3√3), the mirror image across the y-axis.

---

## Seed N-3.13-B (new) — Topic 3.13 Trigonometry and Polar Coordinates
**Skill:** recognize which polar pair names the same point as a given pair with a negative radius, adjusting the angle by π when the sign of r flips.

Which polar pair names the same point as (r, θ) = (−2, 5π/4)?

- A. (2, 5π/4)
- B. (−2, π/4)
- C. (2, −5π/4)
- **D. (2, π/4)**

Check: (−2, 5π/4) is at (−2cos(5π/4), −2sin(5π/4)) = (√2, √2). Flipping the sign of r requires adding or subtracting π to the angle, giving (2, π/4), which is also (√2, √2).
Rationales: A: This changes only the sign of r, which reflects the point through the pole to (−√2, −√2) instead of keeping it at (√2, √2). B: This changes the angle by π but keeps r negative, so the point is still reflected through the pole and lands at (−√2, −√2). C: This negates the angle instead of shifting it by π and also makes r positive; the point lands at (−√2, √2), not at (√2, √2).

**N-3.13-B-v1.** Which polar pair names the same point as (r, θ) = (−5, π/3)?

- A. (5, π/3)
- B. (−5, −2π/3)
- **C. (5, −2π/3)**
- D. (5, −π/3)

Check: (−5, π/3) is at (−5/2, −5√3/2) in the third quadrant. Flipping the sign of r requires shifting the angle by π: (5, π/3 − π) = (5, −2π/3) is at the same point.
Rationales: A: This changes only the sign of r, which reflects the point through the pole to the first quadrant. B: This subtracts π from the angle but keeps r negative, so the point is reflected through the pole. D: This negates the angle instead of shifting it by π, which reflects the point across an axis into the fourth quadrant rather than the third.

**N-3.13-B-v2.** Which polar pair names the same point as (r, θ) = (3, 7π/6)?

- A. (−3, 7π/6)
- **B. (−3, π/6)**
- C. (3, π/6)
- D. (−3, −π/6)

Check: (3, 7π/6) is at (−3√3/2, −3/2) in the third quadrant. A negative radius at the angle 7π/6 − π = π/6 points the opposite way and lands at the same place: (−3, π/6).
Rationales: A: This changes only the sign of r, which reflects the point through the pole to (3√3/2, 3/2). C: This changes the angle by π but keeps r positive, which reflects the point through the pole. D: This negates the angle instead of shifting it by π and also flips r, giving (−3√3/2, 3/2), not the original point at (−3√3/2, −3/2).

**N-3.13-B-v3.** Which polar pair names the same point as (r, θ) = (−4, 11π/6)?

- **A. (4, 5π/6)**
- B. (4, 11π/6)
- C. (−4, 5π/6)
- D. (4, −5π/6)

Check: (−4, 11π/6) is at (−2√3, 2) in the second quadrant. Flipping the sign of r requires subtracting π from the angle: (4, 11π/6 − π) = (4, 5π/6), which is the same point.
Rationales: B: This changes only the sign of r, which reflects the point through the pole to (2√3, −2). C: This changes the angle by π but keeps r negative, so the point is reflected through the pole to (2√3, −2). D: This negates the angle instead of shifting it by π, giving (−2√3, −2), not the original point at (−2√3, 2).

---

## Seed N-3.14-A (replaces 049 family) — Topic 3.14 Polar Function Graphs
**Skill:** describe a rose curve from its equation: petal count (n or 2n), petal length (amplitude) and tip direction (sine versus cosine).

Which statement correctly describes the graph of the polar equation r = 6cos 2θ?

- **A. 4 petals, each of length 6, with tips on the coordinate axes**
- B. 2 petals, each of length 6, with tips on the coordinate axes
- C. 4 petals, each of length 6, with tips on the lines y = x and y = −x
- D. 4 petals, each of length 2, with tips on the coordinate axes

Check: The coefficient of θ is 2 (even), so there are 2·2 = 4 petals, each of length |6| = 6. r(0) = 6, r(π/2) = −6, r(π) = 6 and r(3π/2) = −6 put the four tips on the axes.
Rationales: B: This counts n petals for n = 2, but a rose with an even coefficient n has 2n petals. C: This puts the tips on the diagonals, which is where r = 6 sin 2θ has them; for cosine r = 6 at θ = 0, so a tip lies on the x-axis. D: This takes the petal length from the coefficient 2 of θ; the petal length is the amplitude 6.

**N-3.14-A-v1.** Which statement correctly describes the graph of the polar equation r = 4sin 2θ?

- A. 2 petals, each of length 4, with tips on the lines y = x and y = −x
- B. 4 petals, each of length 4, with tips on the coordinate axes
- C. 4 petals, each of length 2, with tips on the lines y = x and y = −x
- **D. 4 petals, each of length 4, with tips on the lines y = x and y = −x**

Check: The coefficient of θ is 2 (even), so there are 4 petals, each of length 4. The maximum |r| first occurs at 2θ = π/2, θ = π/4, and then at 3π/4, 5π/4 and 7π/4, so the tips lie on y = x and y = −x.
Rationales: A: This counts n petals for n = 2, but a rose with an even coefficient n has 2n petals. B: This puts the tips on the axes, which is where r = 4cos 2θ has them; for sine, r = 0 at θ = 0, so no tip lies on the x-axis. C: This takes the petal length from the coefficient 2 of θ; the petal length is the amplitude 4.

**N-3.14-A-v2.** Which statement correctly describes the graph of the polar equation r = 2sin 5θ?

- A. 10 petals, each of length 2, with one tip at θ = π/10
- B. 5 petals, each of length 5, with one tip at θ = π/10
- **C. 5 petals, each of length 2, with one tip at θ = π/10**
- D. 5 petals, each of length 2, with one tip on the positive x-axis

Check: The coefficient of θ is 5 (odd), so there are 5 petals, each of length 2. The first maximum is where 5θ = π/2, θ = π/10, where r = 2; r(0) = 0, so no tip lies on the positive x-axis.
Rationales: A: This doubles the petal count as for an even coefficient, but for an odd coefficient n the rose has exactly n petals. B: This takes the petal length from the coefficient 5 of θ; the petal length is the amplitude 2. D: This puts a tip on the positive x-axis, as for cosine; for sine, r(0) = 0, so the first tip is at θ = π/10.

**N-3.14-A-v3.** Which statement correctly describes the graph of the polar equation r = 3cos 4θ?

- A. 4 petals, each of length 3, with one tip on the positive x-axis
- **B. 8 petals, each of length 3, with one tip on the positive x-axis**
- C. 8 petals, each of length 4, with one tip on the positive x-axis
- D. 8 petals, each of length 3, with one tip at θ = π/8

Check: The coefficient of θ is 4 (even), so there are 2·4 = 8 petals, each of length 3. r(0) = 3cos 0 = 3, so one tip lies on the positive x-axis; r(π/8) = 0, so no tip is at π/8.
Rationales: A: This counts n petals for n = 4, but a rose with an even coefficient n has 2n petals. C: This takes the petal length from the coefficient 4 of θ; the petal length is the amplitude 3. D: This puts a tip at θ = π/8, but r(π/8) = 3cos(π/2) = 0, so the curve passes through the pole there.

---

## Seed N-3.14-B (replaces 020 family) — Topic 3.14 Polar Function Graphs
**Skill:** classify a limaçon or cardioid from its equation using the ratio of the constant to the coefficient, and find its axis of symmetry and farthest distance from the pole.

Which statement best describes the graph of the polar equation r = 3 − 5sin θ?

- A. A limaçon with an inner loop, symmetric about the polar axis, with a maximum distance of 8 from the pole
- **B. A limaçon with an inner loop, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole**
- C. A dimpled limaçon with no inner loop, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole
- D. A limaçon with an inner loop, symmetric about the line θ = π/2, with a maximum distance of 5 from the pole

Check: Here |a| = 3 is less than |b| = 5, so r takes negative values and the curve has an inner loop. The sin θ form makes it symmetric about θ = π/2, and the greatest |r| is 3 + 5 = 8 at θ = 3π/2.
Rationales: A: This swaps the axis of symmetry; an equation in sin θ is symmetric about the vertical line θ = π/2, while cos θ gives the polar axis. C: This ignores that |3| < |−5|: when the constant is smaller than the sine coefficient, r becomes negative and an inner loop forms. D: This uses only the coefficient 5 as the maximum distance; the farthest point is 3 + 5 = 8 at θ = 3π/2.

**N-3.14-B-v1.** Which statement best describes the graph of the polar equation r = 3 + 2cos θ?

- **A. A dimpled limaçon with no inner loop, symmetric about the polar axis, with a maximum distance of 5 from the pole**
- B. A limaçon with an inner loop, symmetric about the polar axis, with a maximum distance of 5 from the pole
- C. A dimpled limaçon with no inner loop, symmetric about the line θ = π/2, with a maximum distance of 5 from the pole
- D. A dimpled limaçon with no inner loop, symmetric about the polar axis, with a maximum distance of 3 from the pole

Check: Here b < a < 2b (2 < 3 < 4), so r stays positive and the curve has a dimple but no inner loop. The cos θ form makes it symmetric about the polar axis, and the greatest r is 3 + 2 = 5 at θ = 0.
Rationales: B: This claims an inner loop, but a loop needs |a| < |b|; here 3 > 2, so r never becomes negative. C: This swaps the axis of symmetry; an equation in cos θ is symmetric about the polar axis, not the vertical line θ = π/2. D: This uses only the constant 3 as the maximum distance; the farthest point is 3 + 2 = 5 at θ = 0.

**N-3.14-B-v2.** Which statement best describes the graph of the polar equation r = 4 − 4sin θ?

- A. A cardioid with a cusp at the pole, symmetric about the polar axis, with a maximum distance of 8 from the pole
- B. A dimpled limaçon with no inner loop, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole
- C. A cardioid with a cusp at the pole, symmetric about the line θ = π/2, with a maximum distance of 4 from the pole
- **D. A cardioid with a cusp at the pole, symmetric about the line θ = π/2, with a maximum distance of 8 from the pole**

Check: Here |a| = |b| = 4, so the curve is a cardioid with its cusp at the pole (r = 0 at θ = π/2). The sin θ form makes it symmetric about θ = π/2, and the greatest r is 4 + 4 = 8 at θ = 3π/2.
Rationales: A: This swaps the axis of symmetry; an equation in sin θ is symmetric about the vertical line θ = π/2. B: This treats |a| = |b| as a dimpled limaçon, but when the constant equals the coefficient the dimple pinches to a cusp at the pole (a cardioid). C: This uses the constant 4 as the maximum distance; the farthest point is 4 + 4 = 8 at θ = 3π/2.

**N-3.14-B-v3.** Which statement best describes the graph of the polar equation r = 7 − 2cos θ?

- A. A dimpled limaçon with no inner loop, symmetric about the polar axis, with a maximum distance of 9 from the pole
- B. A limaçon with no dimple and no inner loop, symmetric about the line θ = π/2, with a maximum distance of 9 from the pole
- **C. A limaçon with no dimple and no inner loop, symmetric about the polar axis, with a maximum distance of 9 from the pole**
- D. A limaçon with no dimple and no inner loop, symmetric about the polar axis, with a maximum distance of 5 from the pole

Check: Here a = 7 is at least 2|b| = 4, so r stays positive and the curve is convex with no dimple and no loop. The cos θ form gives symmetry about the polar axis, and the greatest r is 7 + 2 = 9 at θ = π.
Rationales: A: This adds a dimple, but a dimple needs the constant to be less than twice the coefficient; here 7 > 4, so the curve is convex. B: This swaps the axis of symmetry; an equation in cos θ is symmetric about the polar axis. D: This uses 7 − 2 = 5, which is the nearest distance (at θ = 0), not the farthest; the farthest is 7 + 2 = 9 at θ = π.

---

## Seed N-3.15-A (new) — Topic 3.15 Rates of Change in Polar Functions
**Skill:** decide where a polar point moves toward the pole by comparing the signs of r and dr/dθ, rather than the sign of dr/dθ alone.

The polar function r = 4sin θ − 2 is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?

- A. (π/2, π)
- B. (0, π/2)
- **C. (0, π/6) ∪ (π/2, 5π/6)**
- D. (π/6, π/2) ∪ (5π/6, π)

Check: r' = 4cos θ and r = 0 at θ = π/6 and 5π/6. Distance decreases when r and r' have opposite signs: r < 0 and r' > 0 on (0, π/6); r > 0 and r' < 0 on (π/2, 5π/6). So the point approaches the pole on (0, π/6) ∪ (π/2, 5π/6).
Rationales: A: This is where r is decreasing (cos θ < 0), but r is negative on part of it, where a decreasing r moves the point farther from the pole. B: This is where r is increasing, but r is positive on part of it, where an increasing r moves the point away from the pole. D: This is where the distance increases (r positive and increasing, or r negative and decreasing), the opposite of what is asked.

**N-3.15-A-v1.** The polar function r = 6cos θ − 3 is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?

- A. (0, π)
- **B. (0, π/3)**
- C. (π/3, π)
- D. (π/2, π)

Check: r' = −6 sin θ < 0 on (0, π), so r decreases throughout. r = 0 at θ = π/3. On (0, π/3), r is positive and decreasing, so the distance falls to 0; on (π/3, π), r is negative and decreasing, so the distance grows. The answer is (0, π/3).
Rationales: A: This uses only that r is decreasing (r' = −6 sin θ < 0); where r is negative, a decreasing r puts the point farther from the pole. C: This takes the interval where r is negative and decreasing as approaching the pole, but a more negative r means a larger distance. D: This is only where cos θ < 0, which does not relate to the sign changes of r (r = 0 at θ = π/3).

**N-3.15-A-v2.** The polar function r = √3 − 2cos θ is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?

- **A. (0, π/6)**
- B. (0, π)
- C. (π/6, π)
- D. (0, π/2)

Check: r' = 2 sin θ > 0 on (0, π), so r increases throughout. r = 0 where cos θ = √3/2, θ = π/6. On (0, π/6), r is negative and increasing, so the distance falls to 0; afterward r is positive and increasing, so the distance grows. The answer is (0, π/6).
Rationales: B: This uses only that r is increasing (r' = 2 sin θ > 0); where r is positive, an increasing r puts the point farther from the pole. C: This takes the interval where r is positive and increasing as approaching the pole, but a larger positive r means a larger distance. D: This is only where cos θ > 0, which does not relate to the sign changes of r (r = 0 at θ = π/6).

**N-3.15-A-v3.** The polar function r = 2√2 sin θ − 2 is graphed for 0 ≤ θ ≤ π. On which interval(s) of θ does the plotted point get closer to the pole (its distance from the origin decreases)?

- A. (π/2, π)
- B. (0, π/2)
- C. (π/4, π/2) ∪ (3π/4, π)
- **D. (0, π/4) ∪ (π/2, 3π/4)**

Check: r' = 2√2 cos θ and r = 0 at θ = π/4 and 3π/4. Distance decreases when r and r' have opposite signs: r < 0 and r' > 0 on (0, π/4); r > 0 and r' < 0 on (π/2, 3π/4). So the answer is (0, π/4) ∪ (π/2, 3π/4).
Rationales: A: This is where r is decreasing (cos θ < 0), but r is negative on part of it, where a decreasing r moves the point farther from the pole. B: This is where r is increasing, but r is positive on part of it, where an increasing r moves the point away from the pole. C: This is where the distance increases (r positive and increasing, or r negative and decreasing), the opposite of what is asked.

---

## Seed N-3.15-B (new) — Topic 3.15 Rates of Change in Polar Functions
**Skill:** compute the average rate of change of a signed polar radius and interpret it together with the sign of r, including when r crosses the pole.

A polar function r = f(θ) is continuous and strictly increasing on [π/6, π/2], with f(π/6) = −2 and f(π/2) = 4. Which statement is correct?

- A. The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole increases throughout the interval.
- B. The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.
- C. The average rate of change of r is 6/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.
- **D. The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.**

Check: The average rate of change is (4 − (−2))/(π/2 − π/6) = 6/(π/3) = 18/π. Since r is continuous and increasing from −2 to 4, it passes through 0 once: |r| falls from 2 to 0 and then rises to 4.
Rationales: A: This finds the rate correctly but claims the distance increases throughout, reading the increase in r as a move away from the pole even where r is negative. B: This finds the rate correctly but claims the distance decreases throughout, ignoring that r becomes positive and then moves farther from the pole. C: This finds the change in distance, (4 − 2)/(π/3), instead of the change in r itself, (4 − (−2))/(π/3); the average rate of change is for r, signed.

**N-3.15-B-v1.** A polar function r = f(θ) is continuous and strictly increasing on [π/4, π], with f(π/4) = −3 and f(π) = 6. Which statement is correct?

- A. The average rate of change of r is 12/π per radian, and the distance of the plotted point from the pole increases throughout the interval.
- B. The average rate of change of r is 12/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.
- **C. The average rate of change of r is 12/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.**
- D. The average rate of change of r is 4/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.

Check: The average rate of change is (6 − (−3))/(π − π/4) = 9/(3π/4) = 12/π. Since r is continuous and increasing from −3 to 6, it passes through 0 once: |r| falls from 3 to 0 and then rises to 6.
Rationales: A: This finds the rate correctly but claims the distance increases throughout, reading the increase in r as a move away from the pole even where r is negative. B: This finds the rate correctly but claims the distance decreases throughout, ignoring that r becomes positive and then moves farther from the pole. D: This finds the change in distance, (6 − 3)/(3π/4), instead of the change in r itself, (6 − (−3))/(3π/4); the average rate of change is for r, signed.

**N-3.15-B-v2.** A polar function r = f(θ) is continuous and strictly decreasing on [0, 2π/3], with f(0) = 5 and f(2π/3) = −1. Which statement is correct?

- A. The average rate of change of r is −9/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.
- **B. The average rate of change of r is −9/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.**
- C. The average rate of change of r is −9/π per radian, and the distance of the plotted point from the pole increases throughout the interval.
- D. The average rate of change of r is −6/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.

Check: The average rate of change is (−1 − 5)/(2π/3 − 0) = −9/π. Since r is continuous and decreasing from 5 to −1, it passes through 0 once: |r| falls from 5 to 0 and then rises to 1.
Rationales: A: This finds the rate correctly but claims the distance decreases throughout, reading the negative rate as a move toward the pole even after r becomes negative. C: This finds the rate correctly but claims the distance increases throughout, ignoring that r starts at 5 and falls toward 0 before the sign change. D: This finds the change in distance, (1 − 5)/(2π/3), instead of the change in r itself, (−1 − 5)/(2π/3); the average rate of change is for r, signed.

**N-3.15-B-v3.** A polar function r = f(θ) is continuous and strictly decreasing on [π/6, π/2], with f(π/6) = −1 and f(π/2) = −7. Which statement is correct?

- **A. The average rate of change of r is −18/π per radian, and the distance of the plotted point from the pole increases throughout the interval.**
- B. The average rate of change of r is −18/π per radian, and the distance of the plotted point from the pole decreases throughout the interval.
- C. The average rate of change of r is −18/π per radian, and the distance of the plotted point from the pole first decreases to 0 and then increases.
- D. The average rate of change of r is 18/π per radian, and the distance of the plotted point from the pole increases throughout the interval.

Check: The average rate of change is (−7 − (−1))/(π/2 − π/6) = −6/(π/3) = −18/π. Since r stays negative and decreases from −1 to −7, |r| grows from 1 to 7, so the point moves away from the pole.
Rationales: B: This finds the rate correctly but claims the distance decreases because the rate is negative; when r is negative, a decreasing r puts the point farther from the pole. C: This finds the rate correctly but claims the distance first decreases to 0; r stays negative here, so it never reaches the pole. D: This reports the opposite sign for the rate; r decreases from −1 to −7, so the average rate of change is negative.
