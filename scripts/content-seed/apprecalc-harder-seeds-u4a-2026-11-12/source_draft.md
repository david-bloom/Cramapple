# AP Precalculus topics 4.1 to 4.7: new seed drafts

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Algebra and numeric claims recomputed in Python.
Scope: Unit 4 (parametric functions, implicit relations, conics) has no published practice MCQs. The unit is not assessed on the AP exam, so one R3-level seed per topic is written. Topics 4.8 to 4.14 are covered by another author.
Target level: eliminating the parameter and reading restricted traces, when a particle is at a point, rates with respect to t versus with respect to x, circle motion from equations, implicit relations, conics by completing the square, and checking parametrizations.

| Seed | Topic | Replaces |
|---|---|---|
| N-4.1-A | 4.1 Parametric Functions | new: eliminate the parameter from a trigonometric parametrization and identify exactly which part of the curve a restricted interval traces |
| N-4.2-A | 4.2 Parametric Functions Modeling Planar Motion | new: decide when a moving particle is at a given point by requiring both coordinate equations to hold at the same time |
| N-4.3-A | 4.3 Parametric Functions and Rates of Change | new: separate the average rates of change of x(t) and y(t) with respect to t from the average rate of change of y with respect to x |
| N-4.4-A | 4.4 Parametrically Defined Circles and Lines | new: read the center |
| N-4.5-A | 4.5 Implicitly Defined Functions | new: test points against an implicit relation and use them to decide whether y is a function of x |
| N-4.6-A | 4.6 Conic Sections | new: complete the square on a general second-degree equation to identify the conic and read off its center and the endpoints of its axis |
| N-4.7-A | 4.7 Parametrization of Implicitly Defined Functions | new: choose a parametrization that traces an entire implicitly defined curve |

---

## Seed N-4.1-A (new) — Topic 4.1 Parametric Functions
**Skill:** eliminate the parameter from a trigonometric parametrization and identify exactly which part of the curve a restricted interval traces, with direction.

A particle's position at time t is x(t) = 4cos t and y(t) = 3 sin t for 0 ≤ t ≤ π. Which statement describes the path traced?

- A. The entire ellipse x²/16 + y²/9 = 1, traced once
- B. The upper half of the ellipse x²/9 + y²/16 = 1, traced from (3, 0) to (−3, 0)
- **C. The upper half of the ellipse x²/16 + y²/9 = 1, traced from (4, 0) to (−4, 0)**
- D. The lower half of the ellipse x²/16 + y²/9 = 1, traced from (4, 0) to (−4, 0)

Check: cos t = x/4 and sin t = y/3, so x²/16 + y²/9 = 1. At t = 0 the point is (4, 0), at t = π/2 it is (0, 3), at t = π it is (−4, 0), and y = 3 sin t ≥ 0 throughout, so it is the upper half from right to left.
Rationales: A: The elimination is right, since cos²t + sin²t = 1 gives x²/16 + y²/9 = 1, but 0 ≤ t ≤ π is only half a revolution, so only part of the ellipse is traced. B: This swaps the denominators: x = 4cos t means x² is divided by 16, and y = 3 sin t means y² is divided by 9. D: On 0 < t < π we have sin t > 0, so y = 3 sin t is positive and the path is the upper half, not the lower half.

**N-4.1-A-v1.** A particle's position at time t is x(t) = 2 sin t and y(t) = 5 cos t for 0 ≤ t ≤ π. Which statement describes the path traced?

- **A. The right half of the ellipse x²/4 + y²/25 = 1, traced from (0, 5) to (0, −5)**
- B. The entire ellipse x²/4 + y²/25 = 1, traced once
- C. The left half of the ellipse x²/4 + y²/25 = 1, traced from (0, 5) to (0, −5)
- D. The right half of the ellipse x²/25 + y²/4 = 1, traced from (0, 2) to (0, −2)

Check: sin t = x/2 and cos t = y/5 give x²/4 + y²/25 = 1. At t = 0 the point is (0, 5), at t = π/2 it is (2, 0), at t = π it is (0, −5), and x = 2 sin t ≥ 0 throughout.
Rationales: B: The equation x²/4 + y²/25 = 1 is correct, but the interval 0 ≤ t ≤ π is only half a revolution, so only half of the ellipse is traced. C: Because sin t ≥ 0 on [0, π], x = 2 sin t is never negative, so the path is on the right side of the y-axis, not the left. D: This swaps the denominators: x = 2 sin t gives x²/4 and y = 5 cos t gives y²/25, so the long axis is vertical with endpoints (0, ±5).

**N-4.1-A-v2.** A particle's position at time t is x(t) = 3cos t and y(t) = 2 sin t for π ≤ t ≤ 2π. Which statement describes the path traced?

- A. The upper half of the ellipse x²/9 + y²/4 = 1, traced from (−3, 0) to (3, 0)
- **B. The lower half of the ellipse x²/9 + y²/4 = 1, traced from (−3, 0) to (3, 0)**
- C. The lower half of the ellipse x²/9 + y²/4 = 1, traced from (3, 0) to (−3, 0)
- D. The entire ellipse x²/9 + y²/4 = 1, traced once

Check: x²/9 + y²/4 = cos²t + sin²t = 1. At t = π the point is (−3, 0), at t = 3π/2 it is (0, −2), and at t = 2π it is (3, 0), with y ≤ 0 throughout.
Rationales: A: On π < t < 2π, sin t is negative, so y = 2 sin t is negative and the path lies below the x-axis. C: At t = π the point is (3cos π, 2 sin π) = (−3, 0), not (3, 0), so the motion starts at the left end and moves to the right. D: The ellipse equation is correct, but the interval π ≤ t ≤ 2π is only half a revolution, so only the lower half is traced.

**N-4.1-A-v3.** A particle's position at time t is x(t) = 5 sin t and y(t) = 2cos t for 0 ≤ t ≤ π/2. Which statement describes the path traced?

- **A. The part of the ellipse x²/25 + y²/4 = 1 in the first quadrant, traced from (0, 2) to (5, 0)**
- B. The part of the ellipse x²/25 + y²/4 = 1 in the first quadrant, traced from (5, 0) to (0, 2)
- C. The part of the ellipse x²/4 + y²/25 = 1 in the first quadrant, traced from (0, 5) to (2, 0)
- D. The entire ellipse x²/25 + y²/4 = 1, traced once

Check: x²/25 + y²/4 = sin²t + cos²t = 1. At t = 0 the point is (0, 2) and at t = π/2 it is (5, 0); both coordinates are nonnegative on [0, π/2], so the path is the first-quadrant quarter.
Rationales: B: At t = 0 the point is (5 sin 0, 2cos 0) = (0, 2), so the motion starts on the y-axis and ends on the x-axis, not the reverse. C: This swaps the denominators: x = 5 sin t means x² is divided by 25, and y = 2cos t means y² is divided by 4. D: The ellipse equation is correct, but 0 ≤ t ≤ π/2 is only a quarter of a revolution, so only a quarter of the ellipse is traced.

---

## Seed N-4.2-A (new) — Topic 4.2 Parametric Functions Modeling Planar Motion
**Skill:** decide when a moving particle is at a given point by requiring both coordinate equations to hold at the same time, including a point the path passes through twice.

A particle moves in the plane with position x(t) = t² − 4 and y(t) = t³ − 4t for −3 ≤ t ≤ 3, with t in seconds. At which times is the particle at the origin?

- **A. t = −2 and t = 2**
- B. t = 2 only
- C. t = −2, t = 0 and t = 2
- D. At no time; the first zero of y is t = 0, where x = -4

Check: x(t) = t² − 4 = 0 gives t = ±2. Then y(2) = 8 − 8 = 0 and y(−2) = −8 + 8 = 0, so the origin is reached at t = −2 and t = 2 (the path crosses itself there). At t = 0 the point is (−4, 0).
Rationales: B: The equation x(t) = 0 gives t = 2 and also t = −2, and y(−2) = 0 as well, so the particle also reaches the origin at t = −2, which is in the interval. C: Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (-4, 0), not the origin, so both coordinates must be zero together. D: At t = 0 the particle is at (-4, 0), but that does not rule out other times; both coordinates are zero at t = ±2.

**N-4.2-A-v1.** A particle moves in the plane with position x(t) = t² − 1 and y(t) = t³ − t for −2 ≤ t ≤ 2, with t in seconds. At which times is the particle at the origin?

- A. t = 1 only
- B. t = −1, t = 0 and t = 1
- **C. t = −1 and t = 1**
- D. At no time; the first zero of y is t = 0, where x = -1

Check: x(t) = t² − 1 = 0 gives t = ±1, and y(±1) = ±1 ∓ 1 = 0, so the origin is reached at t = −1 and t = 1. At t = 0 the point is (−1, 0).
Rationales: A: The equation x(t) = 0 gives t = 1 and also t = −1, and y(−1) = 0 as well, so the particle also reaches the origin at t = −1, which is in the interval. B: Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (-1, 0), not the origin, so both coordinates must be zero together. D: At t = 0 the particle is at (-1, 0), but that does not rule out other times; both coordinates are zero at t = ±1.

**N-4.2-A-v2.** A particle moves in the plane with position x(t) = t² − 9 and y(t) = t³ − 9t for −4 ≤ t ≤ 4, with t in seconds. At which times is the particle at the origin?

- A. t = 3 only
- **B. t = −3 and t = 3**
- C. t = −3, t = 0 and t = 3
- D. At no time; the first zero of y is t = 0, where x = -9

Check: x(t) = t² − 9 = 0 gives t = ±3, and y(3) = 27 − 27 = 0 and y(−3) = −27 + 27 = 0, so the origin is reached at t = −3 and t = 3. At t = 0 the point is (−9, 0).
Rationales: A: The equation x(t) = 0 gives t = 3 and also t = −3, and y(−3) = 0 as well, so the particle also reaches the origin at t = −3, which is in the interval. C: Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (-9, 0), not the origin, so both coordinates must be zero together. D: At t = 0 the particle is at (-9, 0), but that does not rule out other times; both coordinates are zero at t = ±3.

**N-4.2-A-v3.** A particle moves in the plane with position x(t) = 4 − t² and y(t) = 4t − t³ for −3 ≤ t ≤ 3, with t in seconds. At which times is the particle at the origin?

- A. t = 2 only
- B. t = −2, t = 0 and t = 2
- C. At no time; the first zero of y is t = 0, where x = 4
- **D. t = −2 and t = 2**

Check: x(t) = 4 − t² = 0 gives t = ±2, and y(2) = 8 − 8 = 0 and y(−2) = −8 + 8 = 0, so the origin is reached at t = −2 and t = 2. At t = 0 the point is (4, 0).
Rationales: A: The equation x(t) = 0 gives t = 2 and also t = −2, and y(−2) = 0 as well, so the particle also reaches the origin at t = −2, which is in the interval. B: Solving y(t) = 0 alone gives t = 0, but at t = 0 the particle is at (4, 0), not the origin, so both coordinates must be zero together. C: At t = 0 the particle is at (4, 0), but that does not rule out other times; both coordinates are zero at t = ±2.

---

## Seed N-4.3-A (new) — Topic 4.3 Parametric Functions and Rates of Change
**Skill:** separate the average rates of change of x(t) and y(t) with respect to t from the average rate of change of y with respect to x, and compute the latter as a ratio of net changes.

A drone's horizontal position is x(t) = 3t + 1 meters and its height is y(t) = t² meters, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 1 to t = 3?

- A. 3/4 meters of height per meter of horizontal distance
- B. 4 meters per second
- C. 3 meters per second
- **D. 4/3 meters of height per meter of horizontal distance**

Check: From t = 1 to t = 3, Δy = 9 − 1 = 8 and Δx = 10 − 4 = 6, so the average rate of change of y with respect to x is 8/6 = 4/3.
Rationales: A: This inverts the ratio: the net change in height is 8 and the net change in horizontal position is 6, so the rate is 8/6 = 4/3, not 6/8. B: This is the average rate of change of the height with respect to time, (9 − 1)/2 = 4, not with respect to horizontal position. C: This is the average rate of change of the horizontal position with respect to time, (10 − 4)/2 = 3, not the height with respect to horizontal position.

**N-4.3-A-v1.** A skater's horizontal position is x(t) = 5t − 2 feet and her height is y(t) = t² feet, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 0 to t = 4?

- **A. 4/5 feet of height per foot of horizontal distance**
- B. 5/4 feet of height per foot of horizontal distance
- C. 4 feet per second
- D. 5 feet per second

Check: From t = 0 to t = 4, Δy = 16 − 0 = 16 and Δx = 18 − (−2) = 20, so the average rate of change of y with respect to x is 16/20 = 4/5.
Rationales: B: This inverts the ratio: the net change in height is 16 and the net change in horizontal position is 20, so the rate is 16/20 = 4/5. C: This is the average rate of change of the height with respect to time, 16/4 = 4, not with respect to horizontal position. D: This is the average rate of change of the horizontal position with respect to time, 20/4 = 5, not the height with respect to horizontal position.

**N-4.3-A-v2.** A cart's horizontal position is x(t) = 4t meters and its height is y(t) = 2t² meters, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 2 to t = 5?

- A. 2/7 meters of height per meter of horizontal distance
- **B. 7/2 meters of height per meter of horizontal distance**
- C. 14 meters per second
- D. 4 meters per second

Check: From t = 2 to t = 5, Δy = 50 − 8 = 42 and Δx = 20 − 8 = 12, so the average rate of change of y with respect to x is 42/12 = 7/2.
Rationales: A: This inverts the ratio: the net change in height is 42 and the net change in horizontal position is 12, so the rate is 42/12 = 7/2. C: This is the average rate of change of the height with respect to time, 42/3 = 14, not with respect to horizontal position. D: This is the average rate of change of the horizontal position with respect to time, 12/3 = 4, not the height with respect to horizontal position.

**N-4.3-A-v3.** A bird's horizontal position is x(t) = t² + 1 meters and its height is y(t) = 3t meters, where t is in seconds. What is the average rate of change of the height with respect to the horizontal position from t = 1 to t = 3?

- A. 4/3 meters of height per meter of horizontal distance
- B. 3 meters per second
- **C. 3/4 meters of height per meter of horizontal distance**
- D. 4 meters per second

Check: From t = 1 to t = 3, Δy = 9 − 3 = 6 and Δx = 10 − 2 = 8, so the average rate of change of y with respect to x is 6/8 = 3/4.
Rationales: A: This inverts the ratio: the net change in height is 6 and the net change in horizontal position is 8, so the rate is 6/8 = 3/4. B: This is the average rate of change of the height with respect to time, 6/2 = 3, not with respect to horizontal position. D: This is the average rate of change of the horizontal position with respect to time, 8/2 = 4, not the height with respect to horizontal position.

---

## Seed N-4.4-A (new) — Topic 4.4 Parametrically Defined Circles and Lines
**Skill:** read the center, radius, direction and period of circular motion directly from parametric equations.

A bug walks around a circular track: position x(t) = 2 + 4cos(3t), y(t) = −1 − 4 sin(3t), with t in seconds. Which statement is correct?

- A. The track has center (2, −1) and radius 4; the bug moves counterclockwise and completes one lap every 2π/3 seconds
- **B. The track has center (2, −1) and radius 4; the bug moves clockwise and completes one lap every 2π/3 seconds**
- C. The track has center (2, −1) and radius 4; the bug moves clockwise and completes one lap every 2π seconds
- D. The track has center (−2, 1) and radius 4; the bug moves clockwise and completes one lap every 2π/3 seconds

Check: The terms 4cos(3t) and −4 sin(3t) satisfy ((x − 2)/4)² + ((y + 1)/4)² = 1, so center (2, −1), radius 4. The period is 2π/3. At t = 0 the bug is at (6, −1), the rightmost point, and y decreases for small t, so the motion is clockwise.
Rationales: A: The signs on the sine and cosine terms make the bug move clockwise: just after t = 0 it heads downward from the starting point on the track, as the check shows, so the opposite direction is wrong. C: The period is 2π divided by the coefficient of t inside the trigonometric functions, which is 2π/3, not 2π. D: The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.

**N-4.4-A-v1.** A bug walks around a circular track: position x(t) = −3 + 2cos(4t), y(t) = 5 + 2 sin(4t), with t in seconds. Which statement is correct?

- A. The track has center (−3, 5) and radius 2; the bug moves clockwise and completes one lap every π/2 seconds
- B. The track has center (−3, 5) and radius 2; the bug moves counterclockwise and completes one lap every 2π seconds
- C. The track has center (3, −5) and radius 2; the bug moves counterclockwise and completes one lap every π/2 seconds
- **D. The track has center (−3, 5) and radius 2; the bug moves counterclockwise and completes one lap every π/2 seconds**

Check: The terms satisfy ((x + 3)/2)² + ((y − 5)/2)² = 1, so center (−3, 5), radius 2. The period is 2π/4 = π/2. At t = 0 the bug is at (−1, 5), the rightmost point, and y increases for small t, so the motion is counterclockwise.
Rationales: A: The signs on the sine and cosine terms make the bug move counterclockwise: just after t = 0 it heads upward from the starting point on the track, as the check shows, so the opposite direction is wrong. B: The period is 2π divided by the coefficient of t inside the trigonometric functions, which is π/2, not 2π. C: The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.

**N-4.4-A-v2.** A bug walks around a circular track: position x(t) = 1 + 6 sin(t/2), y(t) = −2 + 6cos(t/2), with t in seconds. Which statement is correct?

- **A. The track has center (1, −2) and radius 6; the bug moves clockwise and completes one lap every 4π seconds**
- B. The track has center (1, −2) and radius 6; the bug moves counterclockwise and completes one lap every 4π seconds
- C. The track has center (1, −2) and radius 6; the bug moves clockwise and completes one lap every π seconds
- D. The track has center (−1, 2) and radius 6; the bug moves clockwise and completes one lap every 4π seconds

Check: The terms satisfy ((x − 1)/6)² + ((y + 2)/6)² = 1, so center (1, −2), radius 6. The period is 2π ÷ (1/2) = 4π. At t = 0 the bug is at (1, 4), the top point, and x increases for small t, so the motion is clockwise.
Rationales: B: The signs on the sine and cosine terms make the bug move clockwise: just after t = 0 it heads downward from the starting point on the track, as the check shows, so the opposite direction is wrong. C: The period is 2π divided by the coefficient of t inside the trigonometric functions, which is 4π, not π. D: The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.

**N-4.4-A-v3.** A bug walks around a circular track: position x(t) = 5 + 3cos(πt), y(t) = 3 − 3 sin(πt), with t in seconds. Which statement is correct?

- A. The track has center (5, 3) and radius 3; the bug moves counterclockwise and completes one lap every 2 seconds
- B. The track has center (5, 3) and radius 3; the bug moves clockwise and completes one lap every 2π seconds
- **C. The track has center (5, 3) and radius 3; the bug moves clockwise and completes one lap every 2 seconds**
- D. The track has center (−5, −3) and radius 3; the bug moves clockwise and completes one lap every 2 seconds

Check: The terms satisfy ((x − 5)/3)² + ((y − 3)/3)² = 1, so center (5, 3), radius 3. The period is 2π ÷ π = 2. At t = 0 the bug is at (8, 3), the rightmost point, and y decreases for small t, so the motion is clockwise.
Rationales: A: The signs on the sine and cosine terms make the bug move clockwise: just after t = 0 it heads downward from the starting point on the track, as the check shows, so the opposite direction is wrong. B: The period is 2π divided by the coefficient of t inside the trigonometric functions, which is 2, not 2π. D: The center is read from the constants added to the trigonometric terms, with their signs, so the signs of both coordinates cannot be flipped.

---

## Seed N-4.5-A (new) — Topic 4.5 Implicitly Defined Functions
**Skill:** test points against an implicit relation and use them to decide whether y is a function of x, without swapping coordinates or being misled by symmetry.

Consider the relation x² + 4y² = 20. Which statement is correct?

- A. The points (1, 4) and (1, −4) both lie on the graph, so y is not a function of x
- B. The point (4, 1) lies on the graph but (4, −1) does not, so y is a function of x
- **C. The points (4, 1) and (4, −1) both lie on the graph, so y is not a function of x**
- D. The points (4, 1) and (4, −1) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis

Check: Substituting (4, 1) gives 16 + 4 = 20, and (4, −1) gives the same value since y is squared. One input x = 4 then has two outputs, so y is not a function of x. Reversed coordinates (1, 4) give 65 ≠ 20.
Rationales: A: These points have the coordinates reversed: substituting x = 1, y = 4 gives 65, not 20. B: Since y appears only as y², replacing y with −1 gives the same value 4, so (4, −1) also lies on the graph. D: Symmetry about the x-axis is exactly what produces two outputs for one input: x = 4 has y = 1 and y = −1, which breaks the definition of a function.

**N-4.5-A-v1.** Consider the relation x² + 9y² = 45. Which statement is correct?

- **A. The points (6, 1) and (6, −1) both lie on the graph, so y is not a function of x**
- B. The points (1, 6) and (1, −6) both lie on the graph, so y is not a function of x
- C. The point (6, 1) lies on the graph but (6, −1) does not, so y is a function of x
- D. The points (6, 1) and (6, −1) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis

Check: Substituting (6, 1) gives 36 + 9 = 45, and (6, −1) gives the same value since y is squared. One input x = 6 then has two outputs, so y is not a function of x. Reversed coordinates (1, 6) give 325 ≠ 45.
Rationales: B: These points have the coordinates reversed: substituting x = 1, y = 6 gives 325, not 45. C: Since y appears only as y², replacing y with −1 gives the same value 9, so (6, −1) also lies on the graph. D: Symmetry about the x-axis is exactly what produces two outputs for one input: x = 6 has y = 1 and y = −1, which breaks the definition of a function.

**N-4.5-A-v2.** Consider the relation 4x² + y² = 40. Which statement is correct?

- A. The points (2, 3) and (2, −3) both lie on the graph, so y is not a function of x
- B. The point (3, 2) lies on the graph but (3, −2) does not, so y is a function of x
- C. The points (3, 2) and (3, −2) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis
- **D. The points (3, 2) and (3, −2) both lie on the graph, so y is not a function of x**

Check: Substituting (3, 2) gives 36 + 4 = 40, and (3, −2) gives the same value since y is squared. One input x = 3 then has two outputs, so y is not a function of x. Reversed coordinates (2, 3) give 25 ≠ 40.
Rationales: A: These points have the coordinates reversed: substituting x = 2, y = 3 gives 25, not 40. B: Since y appears only as y², replacing y with −2 gives the same value 4, so (3, −2) also lies on the graph. C: Symmetry about the x-axis is exactly what produces two outputs for one input: x = 3 has y = 2 and y = −2, which breaks the definition of a function.

**N-4.5-A-v3.** Consider the relation x² + 2y² = 27. Which statement is correct?

- A. The points (1, 5) and (1, −5) both lie on the graph, so y is not a function of x
- **B. The points (5, 1) and (5, −1) both lie on the graph, so y is not a function of x**
- C. The point (5, 1) lies on the graph but (5, −1) does not, so y is a function of x
- D. The points (5, 1) and (5, −1) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis

Check: Substituting (5, 1) gives 25 + 2 = 27, and (5, −1) gives the same value since y is squared. One input x = 5 then has two outputs, so y is not a function of x. Reversed coordinates (1, 5) give 51 ≠ 27.
Rationales: A: These points have the coordinates reversed: substituting x = 1, y = 5 gives 51, not 27. C: Since y appears only as y², replacing y with −1 gives the same value 2, so (5, −1) also lies on the graph. D: Symmetry about the x-axis is exactly what produces two outputs for one input: x = 5 has y = 1 and y = −1, which breaks the definition of a function.

---

## Seed N-4.6-A (new) — Topic 4.6 Conic Sections
**Skill:** complete the square on a general second-degree equation to identify the conic and read off its center and the endpoints of its axis, vertices or focus.

The graph of 9x² + 4y² − 36x + 24y + 36 = 0 is an ellipse. Which gives its center and the endpoints of its major axis?

- A. Center (2, −3); the major axis is horizontal with endpoints (−1, −3) and (5, −3)
- B. Center (−2, 3); the major axis is vertical with endpoints (−2, 6) and (−2, 0)
- C. Center (2, −3); the major axis is vertical with endpoints (2, 6) and (2, −12)
- **D. Center (2, −3); the major axis is vertical with endpoints (2, 0) and (2, −6)**

Check: 9(x² − 4x) + 4(y² + 6y) = −36 gives 9(x − 2)² + 4(y + 3)² = 36, so (x − 2)²/4 + (y + 3)²/9 = 1. Center (2, −3), a = 3 vertical, so endpoints (2, 0) and (2, −6).
Rationales: A: Completing the square gives (x − 2)²/4 + (y + 3)²/9 = 1, so the larger denominator 9 is under y and the major axis is vertical, not horizontal. B: The center is found from (x − 2) and (y + 3), so it is (2, −3); the signs of both coordinates were flipped. C: The endpoints lie √9 = 3 units from the center, not 9 units; the denominator 9 is a² and must be square-rooted.

**N-4.6-A-v1.** The graph of x² − 4y² + 6x + 16y − 11 = 0 is a hyperbola. Which gives its center and its vertices?

- **A. Center (−3, 2); vertices (−5, 2) and (−1, 2)**
- B. Center (3, −2); vertices (1, −2) and (5, −2)
- C. Center (−3, 2); vertices (−7, 2) and (1, 2)
- D. Center (−3, 2); vertices (−3, 3) and (−3, 1)

Check: x² + 6x − 4(y² − 4y) = 11 gives (x + 3)² − 4(y − 2)² = 4, so (x + 3)²/4 − (y − 2)² = 1. Center (−3, 2), a = 2 horizontal, so vertices (−5, 2) and (−1, 2).
Rationales: B: Completing the square gives (x + 3)² − 4(y − 2)² = 4, so the center is (−3, 2); the signs of both coordinates were flipped. C: From (x + 3)²/4 − (y − 2)² = 1 the vertices are √4 = 2 units from the center, not 4 units; the denominator 4 is a² and must be square-rooted. D: The positive squared term is the x term, so the hyperbola opens left and right and the vertices are horizontal from the center, not vertical.

**N-4.6-A-v2.** The graph of 4x² + y² + 16x − 6y + 9 = 0 is an ellipse. Which gives its center and the endpoints of its major axis?

- A. Center (−2, 3); the major axis is horizontal with endpoints (−4, 3) and (0, 3)
- **B. Center (−2, 3); the major axis is vertical with endpoints (−2, 7) and (−2, −1)**
- C. Center (2, −3); the major axis is vertical with endpoints (2, 1) and (2, −7)
- D. Center (−2, 3); the major axis is vertical with endpoints (−2, 19) and (−2, −13)

Check: 4(x² + 4x) + (y² − 6y) = −9 gives 4(x + 2)² + (y − 3)² = 16, so (x + 2)²/4 + (y − 3)²/16 = 1. Center (−2, 3), a = 4 vertical, so endpoints (−2, 7) and (−2, −1).
Rationales: A: These are the endpoints of the minor axis: completing the square gives (x + 2)²/4 + (y − 3)²/16 = 1, and the longer axis follows the larger denominator 16 under y. C: The center comes from (x + 2) and (y − 3), so it is (−2, 3); the signs of both coordinates were flipped. D: The endpoints lie √16 = 4 units from the center, not 16; the denominator 16 is a² and must be square-rooted.

**N-4.6-A-v3.** The graph of y² − 6y − 8x + 25 = 0 is a parabola. Which gives its focus?

- A. (10, 3)
- B. (0, 3)
- **C. (4, 3)**
- D. (2, 5)

Check: y² − 6y + 9 = 8x − 16 gives (y − 3)² = 8(x − 2). Vertex (2, 3), 4p = 8 so p = 2, opening right, so the focus is (4, 3).
Rationales: A: Completing the square gives (y − 3)² = 8(x − 2), so 4p = 8 and p = 2; the focus is 2 units from the vertex (2, 3), not 8. B: The coefficient of (x − 2) is positive, so the parabola opens to the right and the focus lies to the right of the vertex, not to the left. D: The squared term is y, so the parabola opens horizontally and the focus is found by moving along the x-direction from the vertex, not the y-direction.

---

## Seed N-4.7-A (new) — Topic 4.7 Parametrization of Implicitly Defined Functions
**Skill:** choose a parametrization that traces an entire implicitly defined curve, checking the denominators, shifts and parameter interval.

Which parametrization traces the entire curve x²/25 + y²/4 = 1 exactly once?

- A. x = 2cos t, y = 5 sin t, 0 ≤ t ≤ 2π
- **B. x = 5cos t, y = 2 sin t, 0 ≤ t ≤ 2π**
- C. x = 25cos t, y = 4 sin t, 0 ≤ t ≤ 2π
- D. x = 5cos t, y = 2 sin t, 0 ≤ t ≤ π

Check: With x = 5cos t and y = 2 sin t, x²/25 + y²/4 = cos²t + sin²t = 1, and 0 ≤ t ≤ 2π covers one full revolution.
Rationales: A: This swaps the semi-axes: with these equations x²/25 + y²/4 = 4cos²t/25 + 25 sin²t/4, which is not equal to 1 for all t. C: The denominators 25 and 4 are the squares of the semi-axes, so the multipliers should be √25 = 5 and √4 = 2, not 25 and 4. D: These equations do satisfy the relation, but 0 ≤ t ≤ π traces only the upper half of the ellipse, not the entire curve.

**N-4.7-A-v1.** Which parametrization traces the entire curve (x − 1)²/9 + (y + 2)²/16 = 1 exactly once?

- A. x = −1 + 3cos t, y = 2 + 4 sin t, 0 ≤ t ≤ 2π
- B. x = 1 + 4cos t, y = −2 + 3 sin t, 0 ≤ t ≤ 2π
- **C. x = 1 + 3cos t, y = −2 + 4 sin t, 0 ≤ t ≤ 2π**
- D. x = 1 + 3cos t, y = −2 + 4 sin t, 0 ≤ t ≤ π

Check: ((x − 1)/3)² + ((y + 2)/4)² = cos²t + sin²t = 1, and 0 ≤ t ≤ 2π covers one full revolution.
Rationales: A: These equations center the ellipse at (−1, 2); the relation is centered at (1, −2), so the shifts must be +1 and −2. B: This swaps the semi-axes: the x-direction has denominator 9, so the multiplier on cos t is 3 and the multiplier on sin t is 4. D: These equations satisfy the relation, but 0 ≤ t ≤ π traces only the upper half of the ellipse, not the entire curve.

**N-4.7-A-v2.** Which parametrization traces the entire parabola y² = 8x?

- **A. x = 2t², y = 4t, for all real t**
- B. x = 4t², y = 2t, for all real t
- C. x = 4t, y = 2t², for all real t
- D. x = 2t², y = 4t, for t ≥ 0

Check: With x = 2t² and y = 4t, y² = 16t² = 8(2t²) = 8x, and as t ranges over all reals y takes every real value, so the whole parabola is traced.
Rationales: B: Here y² = 4t² but 8x = 32t², so the points do not satisfy y² = 8x. C: This swaps the roles of x and y: y² = 4t⁴ while 8x = 32t, so the points do not satisfy y² = 8x. D: These equations satisfy the relation, but t ≥ 0 gives y ≥ 0, so only the upper half of the parabola is traced.

**N-4.7-A-v3.** Which parametrization traces the entire curve x = y² + 1?

- A. x = t², y = t + 1, for all real t
- **B. x = t² + 1, y = t, for all real t**
- C. x = t + 1, y = t², for all real t
- D. x = t² + 1, y = t, for t ≥ 0

Check: With y = t and x = t² + 1, we have x = y² + 1, and y = t takes every real value as t ranges over all reals.
Rationales: A: The shift is placed on the wrong variable: y² + 1 = (t + 1)² + 1 = t² + 2t + 2, which is not equal to x = t². C: This swaps the roles of x and y: y² + 1 = t⁴ + 1, which is not equal to x = t + 1. D: These equations satisfy the relation, but t ≥ 0 gives y ≥ 0, so only the upper half of the curve is traced.
