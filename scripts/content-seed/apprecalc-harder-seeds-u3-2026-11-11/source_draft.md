# AP Precalculus topics 3.1 to 3.3: replacement seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Trigonometric values and arithmetic recomputed in Python.
Scope: the 12 published practice MCQs for these topics (radian conversion, one exact value each, and a duplicate pair, cos(5π/6) in both 041 and np2-007) are replaced with R3-level seeds. The three OHT items are teaching items and stay.
Target level: reasoning with periodicity and rates, signs and quadrants, ratios from a point not on the unit circle, solving trig equations, and symmetry identities.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.1-A | 3.1 Periodic phenomena | 015 family (radian conversion filed under 3.1): shifts that a period guarantees |
| N-3.1-B | 3.1 Periodic phenomena | new: rates of change of a periodic function |
| N-3.2-A | 3.2 Sine, cosine, tangent | 015 family: quadrant signs from one value |
| N-3.2-B | 3.2 Sine, cosine, tangent | new: ratios from a point not on the unit circle |
| N-3.3-A | 3.3 Sine and cosine values | 041 and np2-007 families: solve for angles |
| N-3.3-B | 3.3 Sine and cosine values | new: symmetry and shift identities |

---

## Seed N-3.1-A (replaces 015 family) — Topic 3.1 Periodic Phenomena
**Skill:** decide which shifts of the input a period guarantees, and avoid treating half a period as a period.

A function f is periodic with period 12. For which of the following expressions is it NOT guaranteed that the expression equals f(x) for all x?

- A. f(x + 24)
- B. f(x − 36)
- **C. f(x + 6)**
- D. f(x + 60)

Check: a shift by any whole number of periods leaves f unchanged: 24 = 2·12, −36 = −3·12 and 60 = 5·12, but 6 is half a period.
Rationales: A: a shift of 24 is two full periods, so f(x + 24) = f(x) for all x. B: a shift of −36 is three full periods backward, so f(x − 36) = f(x) for all x. D: a shift of 60 is five full periods, so f(x + 60) = f(x) for all x.

**N-3.1-A-v1.** A function g is periodic with period 5. For which of the following expressions is it NOT guaranteed that the expression equals g(x) for all x?

- A. g(x + 15)
- B. g(x − 10)
- **C. g(x + 12.5)**
- D. g(x + 50)

Check: 15 = 3·5, −10 = −2·5 and 50 = 10·5 are whole numbers of periods, but 12.5 = 2.5 periods.
Rationales: A: a shift of 15 is three full periods, so g(x + 15) = g(x) for all x. B: a shift of −10 is two full periods backward, so g(x − 10) = g(x) for all x. D: a shift of 50 is ten full periods, so g(x + 50) = g(x) for all x.

**N-3.1-A-v2.** A function h is periodic with period 8. For which of the following expressions is it NOT guaranteed that the expression equals h(x) for all x?

- A. h(x + 16)
- B. h(x − 24)
- **C. h(x + 20)**
- D. h(x + 40)

Check: 16 = 2·8, −24 = −3·8 and 40 = 5·8 are whole numbers of periods, but 20 = 2.5 periods.
Rationales: A: a shift of 16 is two full periods, so h(x + 16) = h(x) for all x. B: a shift of −24 is three full periods backward, so h(x − 24) = h(x) for all x. D: a shift of 40 is five full periods, so h(x + 40) = h(x) for all x.

**N-3.1-A-v3.** A function p is periodic with period 7. For which of the following expressions is it NOT guaranteed that the expression equals p(x) for all x?

- A. p(x + 49)
- B. p(x − 21)
- C. p(x + 35)
- **D. p(x + 10)**

Check: 49 = 7·7, −21 = −3·7 and 35 = 5·7 are whole numbers of periods, but 10 is not a multiple of 7.
Rationales: A: a shift of 49 is seven full periods, so p(x + 49) = p(x) for all x. B: a shift of −21 is three full periods backward, so p(x − 21) = p(x) for all x. C: a shift of 35 is five full periods, so p(x + 35) = p(x) for all x.

---

## Seed N-3.1-B (new) — Topic 3.1
**Skill:** compute and interpret average rates of change of a periodic function over part of a period and over a full period.

The height h(t), in meters, of the tide at a harbor is periodic with period 12 hours. High tide is h(0) = 2.4 and low tide is h(6) = 0.4, and the tide falls steadily from t = 0 to t = 6 and rises from t = 6 to t = 12. Which statement is correct?

- A. The average rate of change on [0, 6] is −1/3 meters per hour, and on [0, 12] it is +1/3 meters per hour.
- B. The average rate of change on [0, 6] is −2 meters per hour, and on [0, 12] it is 0 meters per hour.
- C. The average rate of change is 0 meters per hour on both [0, 6] and [0, 12], because the tide is periodic.
- **D. The average rate of change on [0, 6] is −1/3 meters per hour, and on [0, 12] it is 0 meters per hour.**

Check: (0.4 − 2.4)/6 = −1/3; over a full period h(12) = h(0), so the average rate on [0, 12] is 0.
Rationales: A: after a full period the height returns to its starting value, so the net change is 0 and not positive. B: the change in height is −2 meters, and dividing by the length 6 hours gives −1/3, not −2. C: a periodic function has average rate 0 over a full period only, and the tide changes from 2.4 to 0.4 on [0, 6].

**N-3.1-B-v1.** A Ferris wheel rider's height h(t), in meters, is periodic with period 20 seconds. The rider is lowest at h(0) = 1 and highest at h(10) = 41. Which statement is correct?

- **A. The average rate of change on [0, 10] is +4 meters per second, and on [0, 20] it is 0 meters per second.**
- B. The average rate of change on [0, 10] is +40 meters per second, and on [0, 20] it is 0 meters per second.
- C. The average rate of change on [0, 10] is +4 meters per second, and on [0, 20] it is +2 meters per second.
- D. The average rate of change is 0 meters per second on [0, 10] and +4 meters per second on [0, 20].

Check: (41 − 1)/10 = 4 on [0, 10]; h(20) = h(0), so the average rate on [0, 20] is 0.
Rationales: B: 40 is the change in height, and the average rate divides it by the 10 seconds elapsed. C: after one full period the rider is back at height 1, so the net change is 0, not 40 or 20. D: this reverses the two intervals; the rider rises on [0, 10] and has no net change over a full period.

**N-3.1-B-v2.** The temperature T(t) at a weather station is modeled by a sinusoidal function with period 24 hours. T has its maximum at t = 0 and its minimum at t = 12, and T is decreasing and concave down on the interval (0, 6). Which statement describes T on the interval (6, 12)?

- A. T is increasing and concave up.
- B. T is decreasing and concave down.
- C. T is increasing and concave down.
- **D. T is decreasing and concave up.**

Check: a sinusoid falls from its maximum to its minimum on (0, 12), bending down until the midline crossing at t = 6, then bending up toward the minimum.
Rationales: A: T keeps decreasing until the minimum at t = 12, so it is not increasing on (6, 12). B: the concavity changes at the midline crossing t = 6, so it does not stay concave down. C: T is not increasing before the minimum, and the concavity has changed to concave up.

**N-3.1-B-v3.** An insect population g(t), in thousands, is periodic with period 3 years. The population has a maximum of 5 at t = 1 and a minimum of 1 at t = 2.5. Which statement is correct?

- **A. g(10) = 5, because 10 = 1 + 3(3), a whole number of periods after the first maximum.**
- B. g(10) = 1, because 10 is a whole number of years after the minimum at 2.5.
- C. g(10) = 5, because the maximum occurs every year.
- D. g(10) cannot be determined, because 10 lies outside the given data.

Check: maxima occur at t = 1 + 3k, and 10 = 1 + 9.
Rationales: B: the minima occur at 2.5 + 3k, and 10 is not of that form. C: the maximum occurs once per period of 3 years, not every year. D: a periodic function is determined everywhere by its values on one period.

---

## Seed N-3.2-A (replaces 015 family) — Topic 3.2 Sine, Cosine, and Tangent
**Skill:** use a quadrant and one trigonometric value to find the others, with correct signs.

An angle θ is in Quadrant III, and cos θ = −5/13. Which choice gives sin θ and tan θ?

- A. sin θ = 12/13 and tan θ = −12/5
- B. sin θ = −12/13 and tan θ = −12/5
- C. sin θ = −12/13 and tan θ = 5/12
- **D. sin θ = −12/13 and tan θ = 12/5**

Check: sin θ = −√(1 − 25/169) = −12/13 in Quadrant III, and tan θ = sin θ/cos θ = (−12/13)/(−5/13) = 12/5.
Rationales: A: sine is negative in Quadrant III, and a positive sine would place the angle in Quadrant II. B: the quotient of two negative numbers is positive, so tan θ is positive in Quadrant III. C: this inverts the ratio, giving cos θ/sin θ instead of sin θ/cos θ.

**N-3.2-A-v1.** An angle θ is in Quadrant II, and sin θ = 3/5. Which choice gives cos θ and tan θ?

- A. cos θ = 4/5 and tan θ = −3/4
- B. cos θ = −4/5 and tan θ = 3/4
- C. cos θ = −4/5 and tan θ = −4/3
- **D. cos θ = −4/5 and tan θ = −3/4**

Check: cos θ = −√(1 − 9/25) = −4/5 in Quadrant II, and tan θ = (3/5)/(−4/5) = −3/4.
Rationales: A: cosine is negative in Quadrant II, and a positive cosine would place the angle in Quadrant I. B: tangent is negative in Quadrant II because sine is positive and cosine is negative. C: this inverts the ratio, giving cos θ/sin θ in magnitude instead of sin θ/cos θ.

**N-3.2-A-v2.** An angle θ is in Quadrant IV, and tan θ = −2. Which choice gives sin θ and cos θ?

- A. sin θ = 2/√5 and cos θ = −1/√5
- B. sin θ = −1/√5 and cos θ = 2/√5
- C. sin θ = −2/√5 and cos θ = −1/√5
- **D. sin θ = −2/√5 and cos θ = 1/√5**

Check: tan θ = sin θ/cos θ = −2 with cos θ > 0 and sin θ < 0 in Quadrant IV; with sin² + cos² = 1 we get cos θ = 1/√5 and sin θ = −2/√5.
Rationales: A: these signs place the angle in Quadrant II, where sine is positive and cosine is negative. B: this swaps the two values, so tan θ would be −1/2 instead of −2. C: these signs place the angle in Quadrant III, where both are negative and the tangent is positive.

**N-3.2-A-v3.** An angle θ satisfies sin θ = −8/17 and cos θ > 0. What is tan θ?

- A. 8/15
- B. −15/8
- **C. −8/15**
- D. 15/8

Check: cos θ = √(1 − 64/289) = 15/17 > 0, so tan θ = (−8/17)/(15/17) = −8/15.
Rationales: A: sine is negative and cosine is positive, so the tangent is negative, and a positive value ignores the sign of sine. B: this inverts the ratio, giving cos θ/sin θ instead of sin θ/cos θ. D: this both inverts the ratio and drops the sign.

---

## Seed N-3.2-B (new) — Topic 3.2
**Skill:** find sine, cosine and tangent from a point on the terminal ray that is not on the unit circle.

The terminal ray of an angle θ in standard position passes through the point (−6, 8). Which choice gives sin θ, cos θ and tan θ?

- A. sin θ = 8, cos θ = −6, tan θ = −4/3
- B. sin θ = 4/5, cos θ = 3/5, tan θ = −4/3
- C. sin θ = 4/5, cos θ = −3/5, tan θ = −3/4
- **D. sin θ = 4/5, cos θ = −3/5, tan θ = −4/3**

Check: r = √(36 + 64) = 10, so sin θ = 8/10 = 4/5, cos θ = −6/10 = −3/5, tan θ = 8/(−6) = −4/3.
Rationales: A: sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 10. B: the x-coordinate is negative, so cosine is negative in Quadrant II. C: tangent is y/x = 8/(−6), which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.

**N-3.2-B-v1.** The terminal ray of an angle θ in standard position passes through the point (5, −12). Which choice gives sin θ, cos θ and tan θ?

- A. sin θ = −12, cos θ = 5, tan θ = −12/5
- B. sin θ = 12/13, cos θ = 5/13, tan θ = −12/5
- C. sin θ = −12/13, cos θ = 5/13, tan θ = −5/12
- **D. sin θ = −12/13, cos θ = 5/13, tan θ = −12/5**

Check: r = √(25 + 144) = 13, so sin θ = −12/13, cos θ = 5/13, tan θ = −12/5.
Rationales: A: sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 13. B: the y-coordinate is negative, so sine is negative in Quadrant IV. C: tangent is y/x = −12/5, which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.

**N-3.2-B-v2.** The terminal ray of an angle θ in standard position passes through the point (−4, −3). Which choice gives sin θ, cos θ and tan θ?

- A. sin θ = −3, cos θ = −4, tan θ = 3/4
- B. sin θ = −3/5, cos θ = −4/5, tan θ = −3/4
- C. sin θ = −3/5, cos θ = −4/5, tan θ = 4/3
- **D. sin θ = −3/5, cos θ = −4/5, tan θ = 3/4**

Check: r = √(16 + 9) = 5, so sin θ = −3/5, cos θ = −4/5, tan θ = (−3)/(−4) = 3/4.
Rationales: A: sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 5. B: the quotient of two negative numbers is positive, so tan θ is positive in Quadrant III. C: tangent is y/x = 3/4, which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.

**N-3.2-B-v3.** The terminal ray of an angle θ in standard position passes through the point (−8, −15). Which choice gives sin θ, cos θ and tan θ?

- A. sin θ = −15, cos θ = −8, tan θ = 15/8
- B. sin θ = −15/17, cos θ = −8/17, tan θ = −15/8
- C. sin θ = −15/17, cos θ = −8/17, tan θ = 8/15
- **D. sin θ = −15/17, cos θ = −8/17, tan θ = 15/8**

Check: r = √(64 + 225) = 17, so sin θ = −15/17, cos θ = −8/17, tan θ = 15/8.
Rationales: A: sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 17. B: the quotient of two negative numbers is positive, so tan θ is positive in Quadrant III. C: tangent is y/x = 15/8, which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.

---

## Seed N-3.3-A (replaces 041 and np2-007 families) — Topic 3.3 Sine and Cosine Function Values
**Skill:** find all angles in an interval with a given sine or cosine value, using reference angles and signs.

Which angles θ in the interval [0, 2π) satisfy sin θ = −√3/2?

- A. π/3 and 2π/3
- B. 2π/3 and 4π/3
- C. 7π/6 and 11π/6
- **D. 4π/3 and 5π/3**

Check: the reference angle is π/3 and sine is negative in Quadrants III and IV, so θ = π + π/3 = 4π/3 and θ = 2π − π/3 = 5π/3.
Rationales: A: these angles have sin θ = +√3/2, since they lie in Quadrants I and II. B: 2π/3 is in Quadrant II, where sine is positive, so it cannot be a solution. C: these have reference angle π/6, for which the sine is −1/2 and not −√3/2.

**N-3.3-A-v1.** Which angles θ in the interval [0, 2π) satisfy cos θ = −√2/2?

- A. π/4 and 7π/4
- **B. 3π/4 and 5π/4**
- C. 5π/4 and 7π/4
- D. π/4 and 3π/4

Check: the reference angle is π/4 and cosine is negative in Quadrants II and III, so θ = 3π/4 and θ = 5π/4.
Rationales: A: these angles have cos θ = +√2/2, since they lie in Quadrants I and IV. C: 7π/4 is in Quadrant IV, where cosine is positive, so it cannot be a solution. D: π/4 is in Quadrant I, where cosine is positive, so it cannot be a solution.

**N-3.3-A-v2.** On the interval [0, 2π), sin θ = 1/2 and cos θ < 0. What is θ?

- A. π/6
- **B. 5π/6**
- C. 7π/6
- D. 11π/6

Check: sin θ = 1/2 gives π/6 and 5π/6; cosine is negative only in Quadrant II, so θ = 5π/6.
Rationales: A: π/6 has sin θ = 1/2, but its cosine is positive, so it fails the second condition. C: 7π/6 has cosine negative but sine −1/2, so it fails the first condition. D: 11π/6 has sine −1/2 and cosine positive, so it fails both conditions.

**N-3.3-A-v3.** How many solutions does the equation cos θ = 1/2 have on the interval [0, 4π)?

- A. 2
- B. 3
- **C. 4**
- D. 6

Check: on [0, 2π) the solutions are π/3 and 5π/3, and adding 2π gives 7π/3 and 11π/3, for 4 in total.
Rationales: A: this counts only the solutions on one revolution, but the interval covers two. B: the solutions come in pairs, one in Quadrant I and one in Quadrant IV on each revolution, so an odd count is impossible. D: there are exactly two solutions per revolution, not three.

---

## Seed N-3.3-B (new) — Topic 3.3
**Skill:** use symmetry and shift identities together with the Pythagorean relation to evaluate trigonometric expressions.

Let θ be an angle with 0 < θ < π/2 and sin θ = 3/5. What is the value of cos(θ + π)?

- A. 4/5
- B. −3/5
- C. 3/5
- **D. −4/5**

Check: cos θ = 4/5 in Quadrant I, and cos(θ + π) = −cos θ = −4/5.
Rationales: A: adding π reverses the direction of the point on the unit circle, so the cosine changes sign. B: cos(θ + π) is −cos θ, which is not −sin θ. C: cos(θ + π) is the negative of cos θ, so it is not sin θ.

**N-3.3-B-v1.** Let θ be an angle in Quadrant II with cos θ = −5/13. What is the value of sin(π − θ)?

- A. −12/13
- **B. 12/13**
- C. 5/13
- D. −5/13

Check: sin θ = 12/13 in Quadrant II, and sin(π − θ) = sin θ = 12/13.
Rationales: A: sin(π − θ) equals sin θ, and sine is positive in Quadrant II, so it is not negative. C: this is −cos θ, which is the value of cos(π − θ), not of sin(π − θ). D: this is cos θ itself, but the question asks for a sine.

**N-3.3-B-v2.** Let θ be an angle in Quadrant III with sin θ = −4/5. What is the value of cos(θ − π)?

- A. −3/5
- **B. 3/5**
- C. 4/5
- D. −4/5

Check: cos θ = −3/5 in Quadrant III, and cos(θ − π) = −cos θ = 3/5.
Rationales: A: this is cos θ itself, but shifting by π changes the sign. C: this is −sin θ, and it is not the cosine of the shifted angle. D: this is sin θ itself, and the question asks for a cosine.

**N-3.3-B-v3.** Let θ be an angle in Quadrant IV with cos θ = 4/5. What is the value of sin(−θ)?

- A. −3/5
- B. 4/5
- C. −4/5
- **D. 3/5**

Check: sin θ = −3/5 in Quadrant IV, and sin(−θ) = −sin θ = 3/5.
Rationales: A: this is sin θ itself, but reflecting the angle changes the sign of sine. B: this is cos θ, and cos(−θ) = cos θ, not sin(−θ). C: this is −cos θ, which does not equal sin(−θ).
