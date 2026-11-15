# AP Physics C: Mechanics Unit 1: new harder seed drafts (Kinematics)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python. Two new R3 seeds per topic (1.1 to 1.5), three variants each (40 items); nothing is retired.

| Seed | Topic | Replaces |
|---|---|---|
| N-1.1-A | 1.1 | new |
| N-1.1-B | 1.1 | new |
| N-1.2-A | 1.2 | new |
| N-1.2-B | 1.2 | new |
| N-1.3-A | 1.3 | new |
| N-1.3-B | 1.3 | new |
| N-1.4-A | 1.4 | new |
| N-1.4-B | 1.4 | new |
| N-1.5-A | 1.5 | new |
| N-1.5-B | 1.5 | new |

---

## Seed N-1.1-A (new) — Topic 1.1 Scalars and Vectors in One Dimension
**Skill:** distinguish total distance (path length) from displacement (signed net change in position) when a position function reverses direction.

A particle moves along the x-axis with position x(t) = t³ − 12t² + 36t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 7 s, which choice gives the total distance traveled and the displacement?

- A. Distance 7 m; displacement +7 m.
- **B. Distance 71 m; displacement +7 m.**
- C. Distance 71 m; displacement +71 m.
- D. Distance 64 m; displacement +7 m.

Check: v = 3at² + 2bt + c = 0 gives turning points t = 2, 6 s. Positions at t = 0, 2, 6, 7: x = 0, 32, 0, 7 m. Legs = 32, 32, 7 m, distance = 71 m. Displacement = 7 − 0 = 7 m. Without last leg: 71 − 7 = 64 m.
Rationales: A: Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end. C: Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval. D: The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.

**N-1.1-A-v1.** A particle moves along the x-axis with position x(t) = t³ − 6t² + 9t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 4 s, which choice gives the total distance traveled and the displacement?

- **A. Distance 12 m; displacement +4 m.**
- B. Distance 4 m; displacement +4 m.
- C. Distance 12 m; displacement +12 m.
- D. Distance 8 m; displacement +4 m.

Check: v = 3at² + 2bt + c = 0 gives turning points t = 1, 3 s. Positions at t = 0, 1, 3, 4: x = 0, 4, 0, 4 m. Legs = 4, 4, 4 m, distance = 12 m. Displacement = 4 − 0 = 4 m. Without last leg: 12 − 4 = 8 m.
Rationales: B: Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end. C: Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval. D: The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.

**N-1.1-A-v2.** A particle moves along the x-axis with position x(t) = t³ − 9t² + 24t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 5 s, which choice gives the total distance traveled and the displacement?

- A. Distance 20 m; displacement +20 m.
- B. Distance 28 m; displacement +28 m.
- C. Distance 24 m; displacement +20 m.
- **D. Distance 28 m; displacement +20 m.**

Check: v = 3at² + 2bt + c = 0 gives turning points t = 2, 4 s. Positions at t = 0, 2, 4, 5: x = 0, 20, 16, 20 m. Legs = 20, 4, 4 m, distance = 28 m. Displacement = 20 − 0 = 20 m. Without last leg: 28 − 4 = 24 m.
Rationales: A: Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end. B: Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval. C: The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.

**N-1.1-A-v3.** A particle moves along the x-axis with position x(t) = −t³ + 6t² − 9t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 4 s, which choice gives the total distance traveled and the displacement?

- A. Distance 4 m; displacement −4 m.
- B. Distance 12 m; displacement +12 m.
- **C. Distance 12 m; displacement −4 m.**
- D. Distance 8 m; displacement −4 m.

Check: v = 3at² + 2bt + c = 0 gives turning points t = 1, 3 s. Positions at t = 0, 1, 3, 4: x = 0, −4, 0, −4 m. Legs = 4, 4, 4 m, distance = 12 m. Displacement = −4 − 0 = −4 m. Without last leg: 12 − 4 = 8 m.
Rationales: A: Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end. B: Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval. D: The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.

---

## Seed N-1.1-B (new) — Topic 1.1 Scalars and Vectors in One Dimension
**Skill:** compute signed average acceleration through a rebound where velocity changes sign, avoiding speed-difference and reversed-sign errors.

A ball travels along a straight line toward a wall. Take the x-axis to point toward the wall, so the ball's velocity just before impact is +8 m/s. It rebounds with a velocity of 6 m/s directly away from the wall, and contact lasts 0.020 s. Which choice gives the ball's average acceleration during contact, on the same x-axis?

- A. +700 m/s²
- **B. −700 m/s²**
- C. +100 m/s²
- D. −100 m/s²

Check: Δv = vf − vi = −6 − (8) = −14 m/s; a = −14/0.02 = −700 m/s². Wrong: negated = 700; (|vi|−|vf|)/Δt = 100; (|vf|−|vi|)/Δt = −100.
Rationales: A: Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change. C: The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way. D: This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.

**N-1.1-B-v1.** A rubber ball falls onto a floor. Take the y-axis to point upward. Just before impact the ball moves at 5 m/s downward, and just after impact it moves at 3 m/s upward. The impact lasts 0.040 s. Which choice gives the ball's average acceleration during the impact, in the same y-direction convention?

- **A. +200 m/s²**
- B. −200 m/s²
- C. +50 m/s²
- D. −50 m/s²

Check: Δv = vf − vi = 3 − (−5) = 8 m/s; a = 8/0.04 = 200 m/s². Wrong: negated = −200; (|vi|−|vf|)/Δt = 50; (|vf|−|vi|)/Δt = −50.
Rationales: B: Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change. C: The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way. D: This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.

**N-1.1-B-v2.** A cart on a horizontal track uses an x-axis that points east. The cart moves west at 12 m/s, strikes a spring bumper, and leaves moving east at 4 m/s. The collision lasts 0.10 s. Which choice gives the cart's average acceleration during the collision on this axis?

- A. −160 m/s²
- B. +80 m/s²
- C. −80 m/s²
- **D. +160 m/s²**

Check: Δv = vf − vi = 4 − (−12) = 16 m/s; a = 16/0.1 = 160 m/s². Wrong: negated = −160; (|vi|−|vf|)/Δt = 80; (|vf|−|vi|)/Δt = −80.
Rationales: A: Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change. B: The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way. C: This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.

**N-1.1-B-v3.** A puck slides across ice toward a board. A student chooses an x-axis that points west, and the puck is moving east when it strikes the board at 10 m/s. It rebounds westward at 6 m/s, and the contact time is 0.050 s. Using the student's axis, which choice gives the puck's average acceleration during contact?

- A. −320 m/s²
- B. +80 m/s²
- **C. +320 m/s²**
- D. −80 m/s²

Check: Δv = vf − vi = 6 − (−10) = 16 m/s; a = 16/0.05 = 320 m/s². Wrong: negated = −320; (|vi|−|vf|)/Δt = 80; (|vf|−|vi|)/Δt = −80.
Rationales: A: Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change. B: The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way. D: This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.

---

## Seed N-1.2-A (new) — Topic 1.2 Displacement, Velocity, and Acceleration in One Dimension
**Skill:** use the relative signs of velocity and acceleration, obtained by differentiating, to decide speeding up or slowing down.

A particle moves along the x-axis with velocity v(t) = t² − 6t + 8, in SI units. At t = 1.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?

- A. a = −4 m/s², speeding up.
- **B. a = −4 m/s², slowing down.**
- C. a = 4 m/s², speeding up.
- D. a = −5 m/s², slowing down.

Check: v = 3 m/s, a = −4 m/s²; v·a = −12 so slowing down. dv/dt = 2t − 6 → at t = 1: −4; v(1) = 1 − 6 + 8 = 3. Wrong slip value = −5.
Rationales: A: The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it. C: This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there. D: Differentiating t² gives 2t, not t. Using a = t − 6 drops the factor of 2 from the power rule, which gives the wrong magnitude of the acceleration.

**N-1.2-A-v1.** A particle moves along the x-axis with velocity v(t) = t² − 4t, in SI units. At t = 1.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?

- **A. a = −2 m/s², speeding up.**
- B. a = −2 m/s², slowing down.
- C. a = 2 m/s², slowing down.
- D. a = −3 m/s², speeding up.

Check: v = −3 m/s, a = −2 m/s²; v·a = 6 so speeding up. dv/dt = 2t − 4 → at t = 1: −2; v(1) = 1 − 4 = −3. Wrong slip value = −3.
Rationales: B: The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it. C: This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there. D: Differentiating t² gives 2t, not t. Using a = t − 4 drops the factor of 2 from the power rule, which gives the wrong magnitude of the acceleration.

**N-1.2-A-v2.** A bead moves along a wire with position x(t) = t³ − 6t² + 5t, in SI units. At t = 3.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?

- A. a = 6 m/s², speeding up.
- B. a = −6 m/s², speeding up.
- C. a = 18 m/s², slowing down.
- **D. a = 6 m/s², slowing down.**

Check: v = −4 m/s, a = 6 m/s²; v·a = −24 so slowing down. v = 3t² − 12t + 5, a = 6t − 12; at t = 3: v = 27 − 36 + 5 = −4, a = 18 − 12 = 6. Slip: 6t = 18. Wrong slip value = 18.
Rationales: A: The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it. B: This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there. C: Differentiating only the t³ term twice gives 6t = 18, but the −6t² term also contributes −12 to the acceleration. Dropping it gives the wrong value.

**N-1.2-A-v3.** A sled moves along a straight track with position x(t) = t³ − 3t² + 2, in SI units. At t = 3.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?

- A. a = 12 m/s², slowing down.
- B. a = −12 m/s², slowing down.
- **C. a = 12 m/s², speeding up.**
- D. a = 18 m/s², speeding up.

Check: v = 9 m/s, a = 12 m/s²; v·a = 108 so speeding up. v = 3t² − 6t, a = 6t − 6; at t = 3: v = 27 − 18 = 9, a = 18 − 6 = 12. Slip: 6t = 18. Wrong slip value = 18.
Rationales: A: The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it. B: This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there. D: Differentiating only the t³ term twice gives 6t = 18, but the −3t² term also contributes −6 to the acceleration. Dropping it gives the wrong value.

---

## Seed N-1.2-B (new) — Topic 1.2 Displacement, Velocity, and Acceleration in One Dimension
**Skill:** recognize that average velocity is displacement over time (area under v-t) and not the endpoint average or midpoint value when acceleration is not constant.

A particle moves along the x-axis with velocity v(t) = 3t², in SI units. What is its average velocity over the interval from t = 0 to t = 4.0 s?

- A. 24 m/s
- **B. 16 m/s**
- C. 12 m/s
- D. 48 m/s

Check: ∫v dt from 0 to 4 = 64 m; average = 64/4 = 16 m/s. Endpoint average = (0 + 48)/2 = 24; v at midpoint (2 s) = 12; v(4) = 48.
Rationales: A: Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average. C: The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time. D: This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.

**N-1.2-B-v1.** A rocket sled moves along a straight track with velocity v(t) = 6t², in SI units. What is its average velocity over the first 3.0 s of motion?

- **A. 18 m/s**
- B. 27 m/s
- C. 13.5 m/s
- D. 54 m/s

Check: ∫v dt from 0 to 3 = 54 m; average = 54/3 = 18 m/s. Endpoint average = (0 + 54)/2 = 27; v at midpoint (1.5 s) = 13.5; v(3) = 54.
Rationales: B: Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average. C: The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time. D: This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.

**N-1.2-B-v2.** A probe moves along a line with velocity v(t) = t³, in SI units. What is its average velocity from t = 0 to t = 2.0 s?

- A. 4 m/s
- B. 1 m/s
- C. 8 m/s
- **D. 2 m/s**

Check: ∫v dt from 0 to 2 = 4 m; average = 4/2 = 2 m/s. Endpoint average = (0 + 8)/2 = 4; v at midpoint (1 s) = 1; v(2) = 8.
Rationales: A: Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average. B: The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time. C: This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.

**N-1.2-B-v3.** A cart rolls along a straight track with velocity v(t) = 12 − t², in SI units. What is its average velocity from t = 0 to t = 3.0 s?

- A. 7.5 m/s
- B. 9.75 m/s
- **C. 9 m/s**
- D. 3 m/s

Check: ∫v dt from 0 to 3 = 27 m; average = 27/3 = 9 m/s. Endpoint average = (12 + 3)/2 = 7.5; v at midpoint (1.5 s) = 9.75; v(3) = 3.
Rationales: A: Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average. B: The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time. D: This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.

---

## Seed N-1.3-A (new) — Topic 1.3 Representations of Motion
**Skill:** find final position from a velocity-time graph as initial position plus signed area, with segments below the axis counted negative.

The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, 0 m/s), (2 s, +6 m/s), (5 s, +6 m/s), (8 s, −4 m/s). The cart is at x = −3 m at t = 0. What is its position at t = 8 s?

- A. x = +28.8 m
- **B. x = +24 m**
- C. x = +27 m
- D. x = −4 m

Check: Signed area = 6 + 18 + 3 = 27 m; x = −3 + 27 = +24 m. Absolute-area version: 31.8 + −3 = +28.8. Final velocity = −4.
Rationales: A: Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement. C: The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end. D: This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.

**N-1.3-A-v1.** The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, −4 m/s), (3 s, −4 m/s), (5 s, +6 m/s), (9 s, +6 m/s). The cart is at x = +5 m at t = 0. What is its position at t = 9 s?

- **A. x = +19 m**
- B. x = +46.2 m
- C. x = +14 m
- D. x = +6 m

Check: Signed area = −12 + 2 + 24 = 14 m; x = +5 + 14 = +19 m. Absolute-area version: 41.2 + +5 = +46.2. Final velocity = +6.
Rationales: B: Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement. C: The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end. D: This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.

**N-1.3-A-v2.** The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, +8 m/s), (2 s, +8 m/s), (6 s, −8 m/s), (7 s, −8 m/s). The cart is at x = −10 m at t = 0. What is its position at t = 7 s?

- A. x = +30 m
- B. x = +8 m
- C. x = −8 m
- **D. x = −2 m**

Check: Signed area = 16 + 0 + −8 = 8 m; x = −10 + 8 = −2 m. Absolute-area version: 40 + −10 = +30. Final velocity = −8.
Rationales: A: Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement. B: The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end. C: This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.

**N-1.3-A-v3.** The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, −6 m/s), (2 s, −6 m/s), (4 s, 0 m/s), (8 s, +12 m/s). The cart is at x = +20 m at t = 0. What is its position at t = 8 s?

- A. x = +62 m
- B. x = +6 m
- **C. x = +26 m**
- D. x = +12 m

Check: Signed area = −12 + −6 + 24 = 6 m; x = +20 + 6 = +26 m. Absolute-area version: 42 + +20 = +62. Final velocity = +12.
Rationales: A: Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement. B: The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end. D: This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.

---

## Seed N-1.3-B (new) — Topic 1.3 Representations of Motion
**Skill:** locate maximum velocity where acceleration is zero and compute it by integrating a(t) plus the initial velocity.

A particle moves along the x-axis with acceleration a(t) = 6 − 2t, in SI units, for t ≥ 0. Its velocity at t = 0 is −2 m/s. What is the greatest velocity the particle reaches for t ≥ 0?

- A. 9 m/s
- **B. 7 m/s**
- C. 6 m/s
- D. 16 m/s

Check: v(t) = −2 + 6t − 1t². a = 0 at t = 6/2 = 3 s. v = −2 + 18 − 9 = 7 m/s. Without v0: 9; max a = 6; constant-a: −2 + 6·3 = 16.
Rationales: A: The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself. C: This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t). D: This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.

**N-1.3-B-v1.** A cart on a straight track has acceleration a(t) = 12 − 3t, in SI units, for t ≥ 0, and its velocity at t = 0 is +4 m/s. What is the greatest velocity the cart reaches for t ≥ 0?

- **A. 28 m/s**
- B. 24 m/s
- C. 12 m/s
- D. 52 m/s

Check: v(t) = 4 + 12t − 1.5t². a = 0 at t = 12/3 = 4 s. v = 4 + 48 − 24 = 28 m/s. Without v0: 24; max a = 12; constant-a: 4 + 12·4 = 52.
Rationales: B: The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself. C: This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t). D: This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.

**N-1.3-B-v2.** A probe moves along a line with acceleration a(t) = 9 − 3t, in SI units, for t ≥ 0. Its velocity at t = 0 is −6 m/s. What is the greatest velocity the probe reaches for t ≥ 0?

- A. 13.5 m/s
- B. 9 m/s
- C. 21 m/s
- **D. 7.5 m/s**

Check: v(t) = −6 + 9t − 1.5t². a = 0 at t = 9/3 = 3 s. v = −6 + 27 − 13.5 = 7.5 m/s. Without v0: 13.5; max a = 9; constant-a: −6 + 9·3 = 21.
Rationales: A: The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself. B: This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t). C: This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.

**N-1.3-B-v3.** A sled moves along a straight track with acceleration a(t) = 8 − 2t, in SI units, for t ≥ 0. Its velocity at t = 0 is −5 m/s. What is the greatest velocity the sled reaches for t ≥ 0?

- A. 16 m/s
- B. 8 m/s
- **C. 11 m/s**
- D. 27 m/s

Check: v(t) = −5 + 8t − 1t². a = 0 at t = 8/2 = 4 s. v = −5 + 32 − 16 = 11 m/s. Without v0: 16; max a = 8; constant-a: −5 + 8·4 = 27.
Rationales: A: The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself. B: This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t). D: This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.

---

## Seed N-1.4-A (new) — Topic 1.4 Reference Frames and Relative Motion
**Skill:** use relative (closing) speed in one dimension for pursuit and approach, then convert time back to ground-frame distance for one object.

Car A travels east at 30 m/s on a straight road, 90 m behind car B, which travels east at 24 m/s. Both speeds are measured relative to the road and stay constant. Car A catches car B at a certain instant. How far does car A travel, measured on the road, from the moment the gap is 90 m until it catches car B?

- A. 360 m
- **B. 450 m**
- C. 50 m
- D. 90 m

Check: Closing speed = 6 m/s; t = 90/6 = 15 s; distance = 30·15 = 450 m. Other object: 24·15 = 360 m. Wrong closing speed 54: t = 1.667 s → 50 m. Gap = 90 m.
Rationales: A: This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time. C: The closing speed was found by adding the speeds, which applies only when the objects approach each other. Here they move the same way, so the gap closes at the difference of the speeds. D: This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.

**N-1.4-A-v1.** Two trains approach each other on a straight track, 140 m apart. Train A moves east at 20 m/s and train B moves west at 15 m/s, both relative to the ground and constant. How far does train A travel relative to the ground before the trains meet?

- **A. 80 m**
- B. 60 m
- C. 560 m
- D. 140 m

Check: Closing speed = 35 m/s; t = 140/35 = 4 s; distance = 20·4 = 80 m. Other object: 15·4 = 60 m. Wrong closing speed 5: t = 28 s → 560 m. Gap = 140 m.
Rationales: B: This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time. C: The closing speed was found by subtracting the speeds, which applies only when the objects move the same way. Here they approach each other, so the gap closes at the sum of the speeds. D: This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.

**N-1.4-A-v2.** A runner jogs east at 12 m/s relative to the ground along a straight path. A cyclist, 60 m behind her, rides east at 18 m/s relative to the ground. Both speeds stay constant. How far does the runner travel relative to the ground from the moment the gap is 60 m until the cyclist catches her?

- A. 180 m
- B. 24 m
- C. 60 m
- **D. 120 m**

Check: Closing speed = 6 m/s; t = 60/6 = 10 s; distance = 12·10 = 120 m. Other object: 18·10 = 180 m. Wrong closing speed 30: t = 2 s → 24 m. Gap = 60 m.
Rationales: A: This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time. B: The closing speed was found by adding the speeds, which applies only when the objects approach each other. Here they move the same way, so the gap closes at the difference of the speeds. C: This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.

**N-1.4-A-v3.** Two boats on a straight canal start 200 m apart and head straight toward each other. Boat A moves at 25 m/s and boat B at 15 m/s, both relative to the shore and constant. How far does boat B travel relative to the shore before they meet?

- A. 125 m
- B. 300 m
- **C. 75 m**
- D. 200 m

Check: Closing speed = 40 m/s; t = 200/40 = 5 s; distance = 15·5 = 75 m. Other object: 25·5 = 125 m. Wrong closing speed 10: t = 20 s → 300 m. Gap = 200 m.
Rationales: A: This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time. B: The closing speed was found by subtracting the speeds, which applies only when the objects move the same way. Here they approach each other, so the gap closes at the sum of the speeds. D: This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.

---

## Seed N-1.4-B (new) — Topic 1.4 Reference Frames and Relative Motion
**Skill:** resolve a river-crossing problem into independent perpendicular motions in the ground frame: crossing time from the boat's cross-stream speed, drift from the current.

A river is 120 m wide and flows east at 3 m/s relative to the banks. A boat has a speed of 4 m/s relative to the water, and its heading is kept pointed directly north, perpendicular to the banks. Which choice gives the crossing time and the downstream drift when it reaches the far bank?

- A. Crossing time 24 s; downstream drift 72 m.
- **B. Crossing time 30 s; downstream drift 90 m.**
- C. Crossing time 40 s; downstream drift 160 m.
- D. Crossing time 30 s; downstream drift 120 m.

Check: Heading straight across: t = W/u = 120/4 = 30 s; drift = w·t = 3·30 = 90 m. Resultant speed 5: t = 24, drift = 72. Swapped: t = 40, drift = 160. Boat speed × t = 120.
Rationales: A: The boat's speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat's heading component across the river carries it across. Using the resultant speed over the width is too fast. C: This swaps the roles of the speeds. The crossing time is the river width divided by the boat's speed across the river, and the drift is the current speed multiplied by that time. D: The crossing time is right, but the drift is found with the boat's speed instead of the current's. The sideways drift comes from the current carrying the boat downstream during the crossing.

**N-1.4-B-v1.** A canal 150 m wide has water flowing east at 8 m/s relative to the ground. A motorboat moves at 6 m/s relative to the water and is steered with its bow pointed directly across, perpendicular to the banks. Which choice gives the crossing time and the downstream drift?

- **A. Crossing time 25 s; downstream drift 200 m.**
- B. Crossing time 15 s; downstream drift 120 m.
- C. Crossing time 18.8 s; downstream drift 112.5 m.
- D. Crossing time 25 s; downstream drift 150 m.

Check: Heading straight across: t = W/u = 150/6 = 25 s; drift = w·t = 8·25 = 200 m. Resultant speed 10: t = 15, drift = 120. Swapped: t = 18.75, drift = 112.5. Boat speed × t = 150.
Rationales: B: The boat's speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat's heading component across the river carries it across. Using the resultant speed over the width is too fast. C: This swaps the roles of the speeds. The crossing time is the river width divided by the boat's speed across the river, and the drift is the current speed multiplied by that time. D: The crossing time is right, but the drift is found with the boat's speed instead of the current's. The sideways drift comes from the current carrying the boat downstream during the crossing.

**N-1.4-B-v2.** A swimmer crosses a 60 m wide stream whose water flows downstream at 2.0 m/s relative to the shore. She swims at 1.5 m/s relative to the water, always pointed straight across, perpendicular to the shore. Which choice gives her crossing time and how far downstream she lands from the point directly opposite her start?

- A. Crossing time 24 s; downstream drift 48 m.
- B. Crossing time 30 s; downstream drift 45 m.
- C. Crossing time 40 s; downstream drift 60 m.
- **D. Crossing time 40 s; downstream drift 80 m.**

Check: Heading straight across: t = W/u = 60/1.5 = 40 s; drift = w·t = 2·40 = 80 m. Resultant speed 2.5: t = 24, drift = 48. Swapped: t = 30, drift = 45. Boat speed × t = 60.
Rationales: A: The boat's speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat's heading component across the river carries it across. Using the resultant speed over the width is too fast. B: This swaps the roles of the speeds. The crossing time is the river width divided by the boat's speed across the river, and the drift is the current speed multiplied by that time. C: The crossing time is right, but the drift is found with the boat's speed instead of the current's. The sideways drift comes from the current carrying the boat downstream during the crossing.

**N-1.4-B-v3.** A ferry points its bow straight across a 120 m wide river. The ferry's speed relative to the water is 8 m/s, and the river flows at 15 m/s relative to the banks. Which choice gives the crossing time and the downstream drift?

- A. Crossing time 7.1 s; downstream drift 105.9 m.
- B. Crossing time 8 s; downstream drift 64 m.
- **C. Crossing time 15 s; downstream drift 225 m.**
- D. Crossing time 15 s; downstream drift 120 m.

Check: Heading straight across: t = W/u = 120/8 = 15 s; drift = w·t = 15·15 = 225 m. Resultant speed 17: t = 7.059, drift = 105.882. Swapped: t = 8, drift = 64. Boat speed × t = 120.
Rationales: A: The boat's speed relative to the water, not the resultant speed relative to the bank, sets the crossing time, because only the boat's heading component across the river carries it across. Using the resultant speed over the width is too fast. B: This swaps the roles of the speeds. The crossing time is the river width divided by the boat's speed across the river, and the drift is the current speed multiplied by that time. D: The crossing time is right, but the drift is found with the boat's speed instead of the current's. The sideways drift comes from the current carrying the boat downstream during the crossing.

---

## Seed N-1.5-A (new) — Topic 1.5 Vectors and Motion in Two Dimensions
**Skill:** solve two-dimensional projectile motion launched from a height with a quadratic for the time of flight, using separate horizontal and vertical components.

A ball is launched from the top of a 20 m cliff with a speed of 25 m/s at 37° above the horizontal (take sin 37° = 0.60 and cos 37° = 0.80). Neglect air resistance and use g = 10 m/s². How far from the base of the cliff, horizontally, does the ball land on the level ground below?

- A. 60 m
- **B. 80 m**
- C. 40 m
- D. 100 m

Check: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 20, vy = 15; t = 4 s. Range = 20·4 = 80 m. Free-fall time √(2h/g) = 2 s → 40 m. Flat-ground time = 2·15/10 = 3 s → 60 m. Launch speed 25·t = 100 m.
Rationales: A: This uses the flight time for a launch and landing at the same height. The landing point is lower than the launch point, so the ball stays in the air longer and travels farther. C: This uses only the time to fall the height h from rest. The ball first rises, so its vertical motion starts with an upward velocity and the total time is longer than a drop from rest. D: The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the ball horizontally.

**N-1.5-A-v1.** A stone is thrown from the edge of a 15 m high roof with a horizontal velocity component of 12 m/s and an upward velocity component of 10 m/s. Neglect air resistance and use g = 10 m/s². At what horizontal distance from the building's wall does it land on level ground?

- **A. 36 m**
- B. 24 m
- C. 20.8 m
- D. 46.9 m

Check: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 15, vy = 10; t = 3 s. Range = 12·3 = 36 m. Free-fall time √(2h/g) = 1.732 s → 20.78 m. Flat-ground time = 2·10/10 = 2 s → 24 m. Launch speed 15.62·t = 46.86 m.
Rationales: B: This uses the flight time for a launch and landing at the same height. The landing point is lower than the launch point, so the ball stays in the air longer and travels farther. C: This uses only the time to fall the height h from rest. The ball first rises, so its vertical motion starts with an upward velocity and the total time is longer than a drop from rest. D: The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the ball horizontally.

**N-1.5-A-v2.** A package is thrown from a balcony 30 m above level ground with a horizontal velocity component of 12 m/s and a downward velocity component of 5 m/s. Neglect air resistance and use g = 10 m/s². How far from the point directly below the balcony does the package land?

- A. 29.4 m
- B. 36 m
- C. 26 m
- **D. 24 m**

Check: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 30, vy = −5; t = 2 s. Range = 12·2 = 24 m. Free-fall time √(2h/g) = 2.449 s → 29.39 m. Sign-error time (initial vy upward) = 3 s → 36 m. Launch speed 13·t = 26 m.
Rationales: A: This uses the time to fall height h from rest, ignoring the initial downward velocity. The initial downward component makes the ball reach the ground sooner than a drop from rest. B: This treats the initial vertical velocity as upward instead of downward. A downward launch shortens the time of flight, while an upward launch would lengthen it. C: The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the object horizontally.

**N-1.5-A-v3.** A drone releases a ball from a height of 69 m by throwing it at 10 m/s at an angle of 53° below the horizontal (take sin 53° = 0.80 and cos 53° = 0.60). Neglect air resistance and use g = 10 m/s². How far, horizontally, does the ball land from the release point?

- A. 22.3 m
- B. 27.6 m
- **C. 18 m**
- D. 30 m

Check: Taking up as positive, y: h + vy·t − 5t² = 0 with h = 69, vy = −8; t = 3 s. Range = 6·3 = 18 m. Free-fall time √(2h/g) = 3.715 s → 22.29 m. Sign-error time (initial vy upward) = 4.6 s → 27.6 m. Launch speed 10·t = 30 m.
Rationales: A: This uses the time to fall height h from rest, ignoring the initial downward velocity. The initial downward component makes the ball reach the ground sooner than a drop from rest. B: This treats the initial vertical velocity as upward instead of downward. A downward launch shortens the time of flight, while an upward launch would lengthen it. D: The horizontal distance is the horizontal velocity component times time, not the launch speed times time. The launch speed includes the vertical component, which does not move the object horizontally.

---

## Seed N-1.5-B (new) — Topic 1.5 Vectors and Motion in Two Dimensions
**Skill:** obtain speed as the magnitude of the velocity vector found by differentiating each position component, not from |r|, components sum, or acceleration.

A particle moves in the xy-plane with position components x(t) = 2t² and y(t) = 3t, in meters with t in seconds. What is the particle's speed at t = 2.0 s?

- A. 8.2 m/s
- **B. 8.54 m/s**
- C. 11 m/s
- D. 5 m/s

Check: At t = 2: r = (8, 6), v = (8, 3), speed = √(64 + 9) = 8.544 m/s. d|r|/dt = (8·8 + 6·3)/10 = 8.2; vx+vy = 11; |r|/t = 5; |a| = 4.
Rationales: A: This is the rate of change of the particle's distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin. C: Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components. D: This is the magnitude of the position vector divided by time, an average-like quantity from the origin. Speed at an instant is the magnitude of dr/dt evaluated at that time, not |r|/t.

**N-1.5-B-v1.** A drone's position in a horizontal plane is given by x(t) = 3t and y(t) = t² − 4t, in meters with t in seconds. What is the drone's speed at t = 3.0 s?

- **A. 3.61 m/s**
- B. 2.21 m/s
- C. 5 m/s
- D. 2 m/s

Check: At t = 3: r = (9, -3), v = (3, 2), speed = √(9 + 4) = 3.606 m/s. d|r|/dt = (9·3 + -3·2)/9.487 = 2.214; vx+vy = 5; |r|/t = 3.162; |a| = 2.
Rationales: B: This is the rate of change of the particle's distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin. C: Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components. D: This is the magnitude of the acceleration, the second derivative of position. Speed requires only the first derivative of position, the velocity, and then its magnitude.

**N-1.5-B-v2.** A cart on a flat floor has position components x(t) = 4t and y(t) = 5t − t², in meters with t in seconds. What is its speed at t = 2.0 s?

- A. 3.8 m/s
- B. 5 m/s
- C. 2 m/s
- **D. 4.12 m/s**

Check: At t = 2: r = (8, 6), v = (4, 1), speed = √(16 + 1) = 4.123 m/s. d|r|/dt = (8·4 + 6·1)/10 = 3.8; vx+vy = 5; |r|/t = 5; |a| = 2.
Rationales: A: This is the rate of change of the particle's distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin. B: Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components. C: This is the magnitude of the acceleration, the second derivative of position. Speed requires only the first derivative of position, the velocity, and then its magnitude.

**N-1.5-B-v3.** A bead in a plane has position components x(t) = t² and y(t) = 2t, in meters with t in seconds. What is the bead's speed at t = 3.0 s?

- A. 6.1 m/s
- B. 8 m/s
- **C. 6.32 m/s**
- D. 3.61 m/s

Check: At t = 3: r = (9, 6), v = (6, 2), speed = √(36 + 4) = 6.325 m/s. d|r|/dt = (9·6 + 6·2)/10.817 = 6.102; vx+vy = 8; |r|/t = 3.606; |a| = 2.
Rationales: A: This is the rate of change of the particle's distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin. B: Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components. D: This is the magnitude of the position vector divided by time, an average-like quantity from the origin. Speed at an instant is the magnitude of dr/dt evaluated at that time, not |r|/t.
