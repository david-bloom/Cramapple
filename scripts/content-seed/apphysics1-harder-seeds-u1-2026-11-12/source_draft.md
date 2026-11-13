# AP Physics 1 Unit 1: new harder seed drafts (Kinematics)

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
**Skill:** distinguish average speed (path length) from average velocity (signed displacement) when the motion reverses direction.

A runner on a straight track uses an x-axis pointing east. She starts at x = +3 m, runs to x = +11 m in 4 s, then reverses and runs to x = −1 m in another 6 s. For the whole 10 s, which choice gives her average speed and average velocity?

- A. Average speed 2.0 m/s; average velocity +0.4 m/s.
- **B. Average speed 2.0 m/s; average velocity −0.4 m/s.**
- C. Average speed 0.4 m/s; average velocity −0.4 m/s.
- D. Average speed 2.0 m/s; average velocity +2.0 m/s.

Check: Displacement = −4 m, path length = 20 m, time = 10 s. Speed = 20/10 = 2.0 m/s; velocity = −4/10 = −0.4 m/s.
Rationales: A: Average velocity has the same sign as the net displacement, which is −4 m on this axis, so its sign is −. Reversing it describes the opposite displacement. C: Average speed is total path length divided by time, 20 m over 10 s. Using the 4 m net displacement drops the back-and-forth part of the path. D: Average velocity uses the net displacement of −4 m, not the 20 m path length. Speed and velocity agree only when the motion never reverses.

**N-1.1-A-v1.** A cart on a straight track starts at x = −5 m, rolls to x = +7 m in 3 s, then reverses and rolls to x = +1 m in the next 3 s. Using the track's x-axis, which choice gives the cart's average speed and average velocity over the full 6 s?

- A. Average speed 3.0 m/s; average velocity −1.0 m/s.
- B. Average speed 1.0 m/s; average velocity +1.0 m/s.
- C. Average speed 3.0 m/s; average velocity +3.0 m/s.
- **D. Average speed 3.0 m/s; average velocity +1.0 m/s.**

Check: Displacement = +6 m, path length = 18 m, time = 6 s. Speed = 18/6 = 3.0 m/s; velocity = +6/6 = +1.0 m/s.
Rationales: A: Average velocity has the same sign as the net displacement, which is +6 m on this axis, so its sign is +. Reversing it describes the opposite displacement. B: Average speed is total path length divided by time, 18 m over 6 s. Using the 6 m net displacement drops the back-and-forth part of the path. C: Average velocity uses the net displacement of +6 m, not the 18 m path length. Speed and velocity agree only when the motion never reverses.

**N-1.1-A-v2.** An elevator car is described with a y-axis pointing up. It starts at y = +20 m, descends to y = 0 m in 8 s, then rises to y = +8 m in the next 2 s. Which choice gives its average speed and average velocity over the 10 s?

- **A. Average speed 2.8 m/s; average velocity −1.2 m/s.**
- B. Average speed 2.8 m/s; average velocity +1.2 m/s.
- C. Average speed 1.2 m/s; average velocity −1.2 m/s.
- D. Average speed 2.8 m/s; average velocity +2.8 m/s.

Check: Displacement = −12 m, path length = 28 m, time = 10 s. Speed = 28/10 = 2.8 m/s; velocity = −12/10 = −1.2 m/s.
Rationales: B: Average velocity has the same sign as the net displacement, which is −12 m on this axis, so its sign is −. Reversing it describes the opposite displacement. C: Average speed is total path length divided by time, 28 m over 10 s. Using the 12 m net displacement drops the back-and-forth part of the path. D: Average velocity uses the net displacement of −12 m, not the 28 m path length. Speed and velocity agree only when the motion never reverses.

**N-1.1-A-v3.** A ball rolls along a straight groove with an x-axis pointing right. It starts at x = +4 m, reaches x = −6 m after 5 s, then turns and reaches x = −2 m after another 5 s. Which choice gives its average speed and average velocity for the 10 s?

- A. Average speed 1.4 m/s; average velocity +0.6 m/s.
- B. Average speed 0.6 m/s; average velocity −0.6 m/s.
- **C. Average speed 1.4 m/s; average velocity −0.6 m/s.**
- D. Average speed 1.4 m/s; average velocity +1.4 m/s.

Check: Displacement = −6 m, path length = 14 m, time = 10 s. Speed = 14/10 = 1.4 m/s; velocity = −6/10 = −0.6 m/s.
Rationales: A: Average velocity has the same sign as the net displacement, which is −6 m on this axis, so its sign is −. Reversing it describes the opposite displacement. B: Average speed is total path length divided by time, 14 m over 10 s. Using the 6 m net displacement drops the back-and-forth part of the path. D: Average velocity uses the net displacement of −6 m, not the 14 m path length. Speed and velocity agree only when the motion never reverses.

---

## Seed N-1.1-B (new) — Topic 1.1 Scalars and Vectors in One Dimension
**Skill:** predict how reversing the axis direction or origin changes signed quantities (position, displacement, velocity, acceleration) but not magnitudes.

A ball is tossed straight up from a hand, rises to its highest point, and is caught back at the same height. A student first describes the rise from release to the peak with upward as the positive direction, then describes the same rise with downward as the positive direction and the same origin. Which statement correctly compares the two descriptions?

- A. All four quantities change sign, because the axis direction was reversed.
- B. Displacement changes sign, but average velocity keeps its sign because the ball's motion is unchanged.
- C. No quantity changes, since the ball's physical motion is identical in both descriptions.
- **D. Displacement and average velocity for the rise change sign, while distance traveled and average speed keep their values.**

Check: Reversing the axis flips the sign of every vector component, so displacement and average velocity change sign. Path length and speed are magnitudes, so they do not change.
Rationales: A: Distance traveled and average speed are magnitudes built from path length, so they have no sign to flip. Only the vector quantities depend on which way the axis points. B: Average velocity is displacement divided by a positive time interval, so it must take the sign of the displacement. If one flips, the other flips. C: The motion is the same, but the numerical value of a vector component depends on the axis direction. Reversing the axis reverses the signs of displacement and velocity.

**N-1.1-B-v1.** A cart rolling to the right slows steadily and comes to rest. One student takes right as positive and another takes left as positive. Which statement about their descriptions of the slowing-down interval is correct?

- A. Both students record a negative acceleration, because slowing down always means negative acceleration.
- **B. The two students' velocities have opposite signs and their accelerations have opposite signs, yet both agree the cart is slowing down.**
- C. Velocity and acceleration both flip sign, so for the second student the cart is speeding up.
- D. Only the acceleration flips sign; the velocity is positive for both students because the cart moves forward.

Check: Right-positive: v > 0 and a < 0. Left-positive: v < 0 and a > 0. Opposite signs of v and a mean slowing down in both.
Rationales: A: The sign of acceleration depends on the axis direction. For the student with left positive, the cart's velocity change points left, so the acceleration is positive. C: When both flip, they still have opposite signs relative to each other. Opposite signs of velocity and acceleration mean slowing down in either description. D: Velocity is a vector whose sign depends on the chosen axis, so the left-positive student records the cart's velocity as negative.

**N-1.1-B-v2.** A drone hovers 10 m above the ground and rises to 25 m above the ground. Student P measures position upward from the ground. Student Q places the origin on a roof 40 m above the ground and takes downward as positive. Which choice gives Student Q's initial position, final position, and displacement?

- A. Initial +30 m, final +15 m, displacement +15 m, because the drone still climbs 15 m.
- B. Initial −30 m, final −15 m, displacement +15 m, because the drone is below the origin.
- **C. Initial +30 m, final +15 m, displacement −15 m.**
- D. Initial +10 m, final +25 m, displacement −15 m, because positions do not depend on the origin.

Check: Roof origin, down positive: initial = 40 − 10 = +30 m, final = 40 − 25 = +15 m, displacement = 15 − 30 = −15 m.
Rationales: A: The displacement is the final position minus the initial position, which is 15 − 30 = −15 m on a downward-positive axis. Climbing is motion in the negative direction here. B: With downward as positive, a point below the origin has a positive coordinate. Calling it negative ignores the axis direction Student Q chose. D: Positions are measured from the chosen origin, so they differ between students. Only the displacement magnitude of 15 m is shared.

**N-1.1-B-v3.** A bird leaves a perch, flies 6.0 m north along a straight line, then flies 6.0 m south back to the perch, taking 4.0 s in all. Student M takes north as positive and Student N takes south as positive. Which statement about the round trip is correct?

- **A. Both students find zero displacement and zero average velocity, and both find an average speed of 3.0 m/s.**
- B. Student M finds an average velocity of +3.0 m/s and Student N finds −3.0 m/s.
- C. Both students find an average velocity of 3.0 m/s, since the speed is the same for them.
- D. Both students find zero average velocity and zero average speed, because the bird returns to the perch.

Check: Net displacement is 0, so average velocity is 0 for either axis. Path length is 12 m, so average speed = 12/4.0 = 3.0 m/s.
Rationales: B: The bird ends where it started, so the displacement is zero for both students. A nonzero average velocity would require a net change in position. C: Average speed uses the 12 m path length, but average velocity uses the net displacement, which is zero. The two quantities are not interchangeable. D: Returning to the start makes displacement zero, not distance. The bird flew 12 m in 4.0 s, so its average speed is 3.0 m/s.

---

## Seed N-1.2-A (new) — Topic 1.2 Displacement, Velocity, and Acceleration
**Skill:** use the relative signs of velocity and acceleration to decide speeding up or slowing down, then apply v = v0 + at through a reversal.

A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is −3 m/s and its acceleration is a constant −2 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 2.0 s?

- A. Moving left and slowing down; v = +1 m/s.
- **B. Moving left and speeding up; v = −7 m/s.**
- C. Moving left and speeding up; v = +7 m/s.
- D. Moving left and speeding up; v = −5 m/s.

Check: v = v0 + at = −3 + (−2)(2.0) = -7 m/s. Velocity and acceleration have the same sign, so the speed increases.
Rationales: A: A negative acceleration does not by itself mean slowing down. Velocity and acceleration here share the same sign, so the speed grows rather than shrinks. C: Speeding up to a speed of 7 m/s leftward still gives a negative velocity on this axis. The positive sign would mean the cart is moving right. D: The velocity change is a·t = (−2)(2.0) = −4 m/s, the full interval. Using only half the time reaches −5 m/s, which is not the velocity at 2.0 s.

**N-1.2-A-v1.** A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is +4 m/s and its acceleration is a constant −2 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 3.0 s?

- A. Moving right and speeding up; v = +10 m/s.
- B. Moving right and slowing down; v = 0 m/s.
- C. Moving left and speeding up; v = −2 m/s.
- **D. Moving right and slowing down; v = −2 m/s.**

Check: v = 4 + (−2)(3.0) = -2 m/s. At t = 0, v > 0 and a < 0, so the cart is slowing; it stops at t = 2.0 s and reverses.
Rationales: A: Velocity and acceleration have opposite signs here, so the cart loses speed at first. Adding the magnitude of the acceleration treats it as always speeding the cart up. B: The velocity does reach zero, at t = 2.0 s, but the constant acceleration continues to act. By 3.0 s the cart has reversed and moves left at 2 m/s. C: The direction of motion at t = 0 comes from the sign of the velocity, which is positive, so the cart starts out moving right. The acceleration's sign does not set that direction.

**N-1.2-A-v2.** A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is −5 m/s and its acceleration is a constant +2 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 4.0 s?

- **A. Moving left and slowing down; v = +3 m/s.**
- B. Moving left and speeding up; v = −13 m/s.
- C. Moving left and slowing down; v = 0 m/s.
- D. Moving right and speeding up; v = +13 m/s.

Check: v = −5 + (2)(4.0) = +3 m/s. Velocity and acceleration start with opposite signs, so the cart slows, stops at 2.5 s, then moves right.
Rationales: B: The positive acceleration points opposite to the leftward velocity, so it reduces the speed. Treating a positive acceleration as adding to a leftward speed gets the relationship backward. C: The cart does stop at t = 2.5 s, but the acceleration keeps acting. After a further 1.5 s it is moving right at 3 m/s. D: At t = 0 the velocity is negative, so the cart is moving left. The positive acceleration does not make it start out moving right.

**N-1.2-A-v3.** A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is +2 m/s and its acceleration is a constant +3 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 2.0 s?

- A. Moving right and speeding up; v = +5 m/s.
- B. Moving right and speeding up; v = +6 m/s.
- **C. Moving right and speeding up; v = +8 m/s.**
- D. Moving left and speeding up; v = −8 m/s.

Check: v = 2 + (3)(2.0) = 8 m/s. Both signs are positive, so the speed increases.
Rationales: A: The change in velocity is the acceleration multiplied by the time, (3)(2.0) = 6 m/s. Adding the acceleration value directly to 2 m/s leaves out the time factor. B: The acceleration only supplies the change in velocity, 6 m/s. The cart's initial 2 m/s must be added, giving 8 m/s. D: The positive velocity at t = 0 means the cart moves right. Speeding up in the positive direction gives +8 m/s, not −8 m/s.

---

## Seed N-1.2-B (new) — Topic 1.2 Displacement, Velocity, and Acceleration
**Skill:** separate displacement from distance traveled for constant-acceleration motion that reverses at a turning point.

A cart on a straight track has an initial velocity of +8.0 m/s and a constant acceleration of −2.0 m/s². Considering the first 6.0 s of motion, which choice gives its displacement and the total distance it travels?

- A. Displacement +12.0 m; distance traveled 12.0 m.
- B. Displacement +20.0 m; distance traveled 12.0 m.
- C. Displacement +16.0 m; distance traveled 16.0 m.
- **D. Displacement +12.0 m; distance traveled 20.0 m.**

Check: Turning point at t = −v0/a = 4.0 s, reached after 16.0 m. x(t) = v0 t + ½ a t² = +12.0 m. Path length = 16.0 + 4.0 = 20.0 m.
Rationales: A: The object reverses at t = 4.0 s, so the path length is greater than the 12.0 m magnitude of the displacement. The two are equal only when the motion never reverses. B: Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives +12.0 m. The path length of 20.0 m is a different, unsigned quantity. C: The object reverses at t = 4.0 s, but the motion continues until t = 6.0 s. Stopping the calculation at the turning point ignores the return trip.

**N-1.2-B-v1.** A ball is thrown straight up at 12 m/s with the upward direction positive and a constant acceleration of −10 m/s². Neglecting air resistance, which choice gives its displacement and the total distance it travels during the first 2.0 s?

- A. Displacement +4.0 m; distance traveled 4.0 m.
- **B. Displacement +4.0 m; distance traveled 10.4 m.**
- C. Displacement +10.4 m; distance traveled 4.0 m.
- D. Displacement +7.2 m; distance traveled 7.2 m.

Check: Turning point at t = −v0/a = 1.2 s, reached after 7.2 m. x(t) = v0 t + ½ a t² = +4.0 m. Path length = 7.2 + 3.2 = 10.4 m.
Rationales: A: The object reverses at t = 1.2 s, so the path length is greater than the 4.0 m magnitude of the displacement. The two are equal only when the motion never reverses. C: Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives +4.0 m. The path length of 10.4 m is a different, unsigned quantity. D: The object reverses at t = 1.2 s, but the motion continues until t = 2.0 s. Stopping the calculation at the turning point ignores the return trip.

**N-1.2-B-v2.** A cart moving along a track at +10 m/s has a constant acceleration of −4.0 m/s². Over the first 5.0 s, which choice gives its displacement and the total distance it travels?

- A. Displacement 0.0 m; distance traveled 0.0 m.
- B. Displacement +25.0 m; distance traveled 25.0 m.
- **C. Displacement 0.0 m; distance traveled 25.0 m.**
- D. Displacement +12.5 m; distance traveled 12.5 m.

Check: Turning point at t = −v0/a = 2.5 s, reached after 12.5 m. x(t) = v0 t + ½ a t² = 0.0 m. Path length = 12.5 + 12.5 = 25.0 m.
Rationales: A: The object reverses at t = 2.5 s, so the path length is greater than the 0.0 m magnitude of the displacement. The two are equal only when the motion never reverses. B: Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives 0.0 m. The path length of 25.0 m is a different, unsigned quantity. D: The object reverses at t = 2.5 s, but the motion continues until t = 5.0 s. Stopping the calculation at the turning point ignores the return trip.

**N-1.2-B-v3.** A sled slides on a slope where the downhill direction is positive. It starts at −9.0 m/s (moving uphill) with a constant acceleration of +3.0 m/s². Over the first 4.0 s, which choice gives its displacement and the total distance it travels?

- **A. Displacement −12.0 m; distance traveled 15.0 m.**
- B. Displacement −12.0 m; distance traveled 12.0 m.
- C. Displacement +15.0 m; distance traveled 12.0 m.
- D. Displacement −13.5 m; distance traveled 13.5 m.

Check: Turning point at t = −v0/a = 3.0 s, reached after 13.5 m. x(t) = v0 t + ½ a t² = −12.0 m. Path length = 13.5 + 1.5 = 15.0 m.
Rationales: B: The object reverses at t = 3.0 s, so the path length is greater than the 12.0 m magnitude of the displacement. The two are equal only when the motion never reverses. C: Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives −12.0 m. The path length of 15.0 m is a different, unsigned quantity. D: The object reverses at t = 3.0 s, but the motion continues until t = 4.0 s. Stopping the calculation at the turning point ignores the return trip.

---

## Seed N-1.3-A (new) — Topic 1.3 Representing Motion
**Skill:** read position from the signed area under a velocity-time graph, distinguishing zero velocity and a turning point from zero or maximum displacement.

A cart moves along a straight track. Its velocity–time graph is a single straight line that starts at +6.0 m/s at t = 0 and falls steadily to −6.0 m/s at t = 6.0 s. Take the position at t = 0 as the starting position. Which statement about the cart's position is correct?

- A. It is farthest from its start at t = 6 s, because the velocity has its largest negative value there.
- **B. It is farthest from its start at t = 3 s, 9 m away on the positive side; at t = 6 s it is back at its starting position.**
- C. The object is at its starting position at t = 3 s, because the velocity is zero there.
- D. At t = 6 s the object is 18 m from its start, because the two areas add.

Check: Zero crossing at t = 3 s; area = 9 m. Remaining area has magnitude 9 m in the opposite direction, so x(6) = 0 m.
Rationales: A: Position depends on the accumulated area under the graph, not on the current value of the velocity. After the crossing, the object moves back toward its start. C: Zero velocity is not zero position. The velocity is zero at the crossing, while the object has already covered the whole area before it. D: The area below the time axis is displacement in the opposite direction, so it subtracts from the area above. The total of the two areas is the path length, not the net displacement.

**N-1.3-A-v1.** A cart moves along a straight track. Its velocity–time graph is one straight line from +8.0 m/s at t = 0 down to −4.0 m/s at t = 6.0 s. Taking its position at t = 0 as the start, which statement about the cart's position is correct?

- A. It is farthest from its start at t = 6 s, because the velocity has its largest negative value there.
- B. The object is at its starting position at t = 4 s, because the velocity is zero there.
- C. At t = 6 s the object is 20 m from its start, because the two areas add.
- **D. It is farthest from its start at t = 4 s, 16 m away on the positive side; at t = 6 s it is 12 m from its start, on the positive side.**

Check: Zero crossing at t = 4 s; area = 16 m. Remaining area has magnitude 4 m in the opposite direction, so x(6) = +12 m.
Rationales: A: Position depends on the accumulated area under the graph, not on the current value of the velocity. After the crossing, the object moves back toward its start. B: Zero velocity is not zero position. The velocity is zero at the crossing, while the object has already covered the whole area before it. C: The area below the time axis is displacement in the opposite direction, so it subtracts from the area above. The total of the two areas is the path length, not the net displacement.

**N-1.3-A-v2.** A robot moves along a straight hallway. Its velocity–time graph is one straight line from −4.0 m/s at t = 0 up to +12 m/s at t = 8.0 s. Taking its position at t = 0 as the start, which statement about the robot's position is correct?

- **A. It is farthest from its start at t = 8 s, 32 m away on the positive side.**
- B. It is farthest from its start at t = 2 s, 4 m away, because the velocity is zero there.
- C. It is farthest from its start at t = 8 s, 32 m away on the negative side.
- D. It is farthest from its start at t = 8 s, 40 m away.

Check: Zero crossing at t = 2 s; signed area before it = -4 m. Signed area from 2 s to 8 s = +36 m, so x(8) = +32 m. The magnitude is larger at t = 8 s.
Rationales: B: A velocity of zero marks a turning point, not the farthest distance. After the crossing the object moves the other way and keeps going, ending up farther from the start. C: The signed area after the crossing decides the side of the start where the object ends up. The graph shows the object is on the other side. D: Areas on opposite sides of the time axis subtract. The net position is -4 + (+36) = +32 m, so the object is 32 m away, not 40 m.

**N-1.3-A-v3.** A sled moves along a straight slope. Its velocity–time graph is one straight line from +5.0 m/s at t = 0 down to −15 m/s at t = 8.0 s. Taking its position at t = 0 as the start, which statement about the sled's position is correct?

- A. It is farthest from its start at t = 2 s, 5 m away, because the velocity is zero there.
- B. It is farthest from its start at t = 8 s, 40 m away on the positive side.
- **C. It is farthest from its start at t = 8 s, 40 m away on the negative side.**
- D. It is farthest from its start at t = 8 s, 50 m away.

Check: Zero crossing at t = 2 s; signed area before it = +5 m. Signed area from 2 s to 8 s = -45 m, so x(8) = -40 m. The magnitude is larger at t = 8 s.
Rationales: A: A velocity of zero marks a turning point, not the farthest distance. After the crossing the object moves the other way and keeps going, ending up farther from the start. B: The signed area after the crossing decides the side of the start where the object ends up. The graph shows the object is on the other side. D: Areas on opposite sides of the time axis subtract. The net position is +5 + (-45) = -40 m, so the object is 40 m away, not 50 m.

---

## Seed N-1.3-B (new) — Topic 1.3 Representing Motion
**Skill:** compare slopes (instantaneous versus average velocity) of straight and curved position-time graphs.

On one set of axes, the position–time graph of object A is a straight line from the origin to x = 12 m at t = 6.0 s. The graph of object B is a parabola that starts at the origin with zero slope, curves upward, and also reaches x = 12 m at t = 6.0 s. Which statement is correct?

- A. The curved object has the larger average velocity, because it is moving fastest at the end.
- B. The two objects have the same velocity at every instant, because they start and end at the same positions.
- C. The two objects have equal instantaneous velocities only at t = 6.0 s, where the graphs meet.
- **D. Both have an average velocity of 2.0 m/s, and their instantaneous velocities are equal at t = 3.0 s.**

Check: x = bt² with b = 12/6² gives v = 2bt. Setting 2bt equal to the line's slope 2.0 m/s gives t = 3.0 s.
Rationales: A: Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average. B: Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope. C: Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.

**N-1.3-B-v1.** Two cars start from the same marker on a straight road. Car A's position–time graph is a straight line reaching 24 m at t = 4.0 s. Car B's graph is a parabola that begins with zero slope and also reaches 24 m at t = 4.0 s. Which statement is correct?

- A. The curved object has the larger average velocity, because it is moving fastest at the end.
- **B. Both have an average velocity of 6.0 m/s, and their instantaneous velocities are equal at t = 2.0 s.**
- C. The two objects have the same velocity at every instant, because they start and end at the same positions.
- D. The two objects have equal instantaneous velocities only at t = 4.0 s, where the graphs meet.

Check: x = bt² with b = 24/4² gives v = 2bt. Setting 2bt equal to the line's slope 6.0 m/s gives t = 2.0 s.
Rationales: A: Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average. C: Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope. D: Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.

**N-1.3-B-v2.** Two runners start from the same line on a track. Runner A's position–time graph is a straight line reaching 20 m at t = 10 s. Runner B's graph is a parabola that begins with zero slope and also reaches 20 m at t = 10 s. Which statement is correct?

- A. The curved object has the larger average velocity, because it is moving fastest at the end.
- B. The two objects have the same velocity at every instant, because they start and end at the same positions.
- **C. Both have an average velocity of 2.0 m/s, and their instantaneous velocities are equal at t = 5.0 s.**
- D. The two objects have equal instantaneous velocities only at t = 10.0 s, where the graphs meet.

Check: x = bt² with b = 20/10² gives v = 2bt. Setting 2bt equal to the line's slope 2.0 m/s gives t = 5.0 s.
Rationales: A: Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average. B: Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope. D: Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.

**N-1.3-B-v3.** Two boats leave the same dock along a straight channel. Boat A's position–time graph is a straight line reaching 18 m at t = 6.0 s. Boat B's graph is a parabola that begins with zero slope and also reaches 18 m at t = 6.0 s. Which statement is correct?

- **A. Both have an average velocity of 3.0 m/s, and their instantaneous velocities are equal at t = 3.0 s.**
- B. The curved object has the larger average velocity, because it is moving fastest at the end.
- C. The two objects have the same velocity at every instant, because they start and end at the same positions.
- D. The two objects have equal instantaneous velocities only at t = 6.0 s, where the graphs meet.

Check: x = bt² with b = 18/6² gives v = 2bt. Setting 2bt equal to the line's slope 3.0 m/s gives t = 3.0 s.
Rationales: B: Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average. C: Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope. D: Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.

---

## Seed N-1.4-A (new) — Topic 1.4 Reference Frames and Relative Motion
**Skill:** combine and subtract signed velocities in one dimension across two or three reference frames.

On a straight east–west road, car P travels east at 20 m/s and truck T travels east at 14 m/s, both measured relative to the ground. A motorcycle M travels west at 10 m/s relative to the ground. Which choice gives M's velocity relative to P and T's velocity relative to P?

- A. M relative to P: 10 m/s west; T relative to P: 6 m/s west.
- **B. M relative to P: 30 m/s west; T relative to P: 6 m/s west.**
- C. M relative to P: 30 m/s west; T relative to P: 6 m/s east.
- D. M relative to P: 30 m/s west; T relative to P: 34 m/s west.

Check: East positive: v_M/P = −10 − 20 = −30 m/s; v_T/P = 14 − 20 = −6 m/s.
Rationales: A: The motorcycle's 10 m/s is measured relative to the ground, not to car P. P is itself moving east at 20 m/s, so the relative speed is larger. C: T moves east slower than P, so from P's viewpoint T falls behind, toward the west. The relative velocity is v_T − v_P = −6 m/s, which points west. D: Both vehicles in the second case move east, so their velocities subtract. Adding the 14 m/s and 20 m/s is correct only for objects moving in opposite directions.

**N-1.4-A-v1.** A train moves east at 25 m/s relative to the ground. A passenger walks toward the front of the train at 2.0 m/s relative to the train. A second train on a parallel track moves west at 15 m/s relative to the ground. Which choice gives the passenger's velocity relative to the ground and relative to the second train?

- A. Ground: 23 m/s east; second train: 38 m/s east.
- B. Ground: 27 m/s east; second train: 12 m/s east.
- C. Ground: 25 m/s east; second train: 40 m/s east.
- **D. Ground: 27 m/s east; second train: 42 m/s east.**

Check: East positive: v_p/ground = 25 + 2.0 = +27 m/s. v_p/second = 27 − (−15) = +42 m/s.
Rationales: A: Walking toward the front adds to the train's velocity, since both point east. Subtracting 2.0 m/s treats the walk as toward the rear. B: The second train moves west, opposite to the passenger. Relative to it, the passenger's velocity is 27 − (−15), so the speeds add instead of subtract. C: The passenger's walking speed relative to the train must be included. It adds to the 25 m/s, giving 27 m/s relative to the ground.

**N-1.4-A-v2.** A moving walkway carries people east at 1.5 m/s relative to the floor. A person walks west on the walkway at 2.0 m/s relative to the walkway. A runner on the floor beside it moves east at 3.0 m/s relative to the floor. Which choice gives the person's velocity relative to the floor and the runner's velocity relative to the person?

- **A. Person: 0.5 m/s west; runner relative to person: 3.5 m/s east.**
- B. Person: 3.5 m/s west; runner relative to person: 6.5 m/s east.
- C. Person: 0.5 m/s west; runner relative to person: 2.5 m/s east.
- D. Person: 0.5 m/s east; runner relative to person: 2.5 m/s east.

Check: East positive: v_person = +1.5 − 2.0 = −0.5 m/s. v_runner/person = 3.0 − (−0.5) = +3.5 m/s.
Rationales: B: The walkway carries the person east, which partly cancels the westward walk. The two velocities have opposite directions, so they subtract rather than add. C: The runner moves east and the person moves west, so their relative velocity is 3.0 − (−0.5) = 3.5 m/s. Subtracting the magnitudes gets only 2.5 m/s. D: The person's walk of 2.0 m/s west is larger than the walkway's 1.5 m/s east, so the net motion is westward. The direction follows the larger velocity.

**N-1.4-A-v3.** A river flows east at 3.0 m/s relative to the ground. A boat moves directly upstream, heading west, at 5.0 m/s relative to the water. A log floats freely with the current. Which choice gives the boat's velocity relative to the ground and the log's velocity relative to the boat?

- A. Boat: 8.0 m/s west; log relative to boat: 11 m/s east.
- B. Boat: 2.0 m/s west; log relative to boat: 5.0 m/s west.
- **C. Boat: 2.0 m/s west; log relative to boat: 5.0 m/s east.**
- D. Boat: 5.0 m/s west; log relative to boat: 8.0 m/s east.

Check: East positive: v_boat/ground = −5.0 + 3.0 = −2.0 m/s. v_log/boat = +3.0 − (−2.0) = +5.0 m/s. The log moves with the water, so v_log/boat equals the boat's speed through the water.
Rationales: A: The current opposes the boat's westward motion since the boat heads upstream. The velocities subtract, giving 5.0 − 3.0 = 2.0 m/s. B: The log drifts east relative to the ground while the boat moves west. From the boat, the log therefore moves east, not west. D: The boat's 5.0 m/s is measured relative to the water, not to the ground. The current has to be added in to find the ground velocity.

---

## Seed N-1.4-B (new) — Topic 1.4 Reference Frames and Relative Motion
**Skill:** identify which quantities are invariant between frames moving at constant relative velocity (acceleration, time) and which are frame-dependent (velocity, path, distance).

A train car moves east at a constant 20 m/s on straight, level track. A passenger tosses a ball straight up relative to the car, and it comes back to her hand. An observer on the ground watches the same flight. Which pair of quantities has the same value for both observers?

- A. The ball's speed at the highest point and its acceleration.
- B. The shape of the ball's path and its initial velocity.
- C. The ball's velocity at release and its time of flight.
- **D. The ball's acceleration and its time of flight.**

Check: Frames moving at constant relative velocity agree on acceleration (10 m/s² down) and elapsed time, but disagree on velocities, positions, and path shape.
Rationales: A: At the top, the passenger sees zero speed, but the ground observer sees the ball still moving east at 20 m/s. The speeds differ even though the acceleration agrees. B: The passenger sees a straight vertical path, while the ground observer sees a parabola. The initial velocities also differ by the 20 m/s of the train. C: The ground observer measures a horizontal component of 20 m/s that the passenger does not. The time of flight agrees, but the release velocity does not.

**N-1.4-B-v1.** An elevator rises at a constant 3.0 m/s. A rider releases a coin from rest, relative to the elevator, and it falls to the floor. An observer outside the shaft watches the same event. Which pair of quantities has the same value for both observers?

- A. The coin's initial velocity and its acceleration.
- **B. The coin's acceleration and the time it takes to reach the floor.**
- C. The coin's displacement and the time it takes to reach the floor.
- D. The coin's speed when it reaches the floor and its acceleration.

Check: The elevator moves at constant velocity, so both frames measure a = 10 m/s² downward and the same fall time. Velocities and displacements differ by the elevator's 3.0 m/s.
Rationales: A: The rider sees the coin start from rest, but the outside observer sees it start moving upward at 3.0 m/s. The initial velocities do not agree. C: The elevator rises during the fall, so the outside observer sees a different displacement for the coin than the rider does. D: The speeds differ at impact because the observers measure velocity relative to different frames. Only the change in velocity is shared.

**N-1.4-B-v2.** A boat moves at a constant 4.0 m/s east on calm water. A sailor throws a ball straight up relative to the boat, and she catches it at the same point on the deck. Someone on a stationary pier watches the flight. Which statement about the two observers' measurements is correct?

- A. They agree on the ball's horizontal velocity but disagree about its acceleration.
- B. They agree on the distance the ball travels but disagree about its flight time.
- **C. They agree on the ball's acceleration and its flight time but disagree about its horizontal velocity.**
- D. They agree on nothing about the ball's motion, since the frames are moving relative to each other.

Check: Constant relative velocity means the frames differ only by a constant velocity: a and t are shared, horizontal velocity (0 versus 4.0 m/s) is not.
Rationales: A: The pier observer sees the ball move east at 4.0 m/s, while the sailor sees no horizontal motion. The acceleration is 10 m/s² downward for both. B: The pier observer sees a longer, curved path, so the distance differs. The flight time is the same in both frames. D: Frames moving at constant velocity relative to each other agree on accelerations and on elapsed time. Disagreement is limited to velocity and position values.

**N-1.4-B-v3.** A cart rolls east at a constant 2.0 m/s along a lab bench. A spring in the cart launches a marble straight up, relative to the cart, and the marble lands back in the cart. A student at rest next to the bench also records the flight. Which choice lists quantities that are the same for both students?

- **A. The marble's acceleration and the time of flight.**
- B. The marble's acceleration and the horizontal distance it travels.
- C. The marble's speed at launch and the time of flight.
- D. The marble's speed at the top of its path and its acceleration.

Check: A cart moving at constant velocity is an inertial frame, so both students measure a = 10 m/s² and the same time. The horizontal velocity differs by 2.0 m/s.
Rationales: B: The student at the bench sees the marble travel east with the cart, while the student riding the cart sees no horizontal travel. The distances differ. C: The bench student sees a launch speed that combines the upward speed with the cart's 2.0 m/s. The launch speeds therefore differ. D: At the top, the cart student measures zero speed, while the bench student measures 2.0 m/s. The speeds differ.

---

## Seed N-1.5-A (new) — Topic 1.5 Vectors and Motion in Two Dimensions
**Skill:** resolve projectile velocity into independent horizontal (constant) and vertical (g-accelerated) components past the apex, with acceleration still g.

A ball is kicked from level ground with an initial horizontal velocity component of 12 m/s and an initial vertical component of 16 m/s. Neglecting air resistance, which choice gives the ball's speed and acceleration at t = 2.4 s, which is after it has passed its highest point?

- A. Speed 8 m/s; acceleration 10 m/s² downward.
- **B. Speed about 14.4 m/s; acceleration 10 m/s² downward.**
- C. Speed 12 m/s; acceleration 10 m/s² downward.
- D. Speed 20 m/s; acceleration 10 m/s² downward.

Check: The object peaks at t = 1.6 s. At t = 2.4 s, v_y = 16 − 10(2.4) = -8 m/s, v_x = 12 m/s, speed = sqrt(12² + -8²) = 14.4 m/s. The acceleration is 10 m/s² down all the way.
Rationales: A: The horizontal velocity component stays at 12 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one. C: The horizontal component is constant, but the vertical component is now 8 m/s, which is not zero at this instant. The speed combines both. D: Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.

**N-1.5-A-v1.** A stone leaves a launcher on level ground with horizontal component 15 m/s and vertical component 20 m/s. Neglecting air resistance, which choice gives the stone's speed and acceleration at t = 3.0 s, after it has passed its highest point?

- A. Speed 10 m/s; acceleration 10 m/s² downward.
- B. Speed 15 m/s; acceleration 10 m/s² downward.
- C. Speed 25 m/s; acceleration 10 m/s² downward.
- **D. Speed about 18.0 m/s; acceleration 10 m/s² downward.**

Check: The object peaks at t = 2.0 s. At t = 3.0 s, v_y = 20 − 10(3.0) = -10 m/s, v_x = 15 m/s, speed = sqrt(15² + -10²) = 18.0 m/s. The acceleration is 10 m/s² down all the way.
Rationales: A: The horizontal velocity component stays at 15 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one. B: The horizontal component is constant, but the vertical component is now 10 m/s, which is not zero at this instant. The speed combines both. C: Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.

**N-1.5-A-v2.** A soccer ball leaves the ground with horizontal component 8.0 m/s and vertical component 6.0 m/s. Neglecting air resistance, which choice gives its speed and acceleration at t = 1.0 s, after it has passed its highest point?

- **A. Speed about 8.9 m/s; acceleration 10 m/s² downward.**
- B. Speed 4 m/s; acceleration 10 m/s² downward.
- C. Speed 8 m/s; acceleration 10 m/s² downward.
- D. Speed 12 m/s; acceleration 10 m/s² downward.

Check: The object peaks at t = 0.6 s. At t = 1.0 s, v_y = 6 − 10(1.0) = -4 m/s, v_x = 8 m/s, speed = sqrt(8² + -4²) = 8.9 m/s. The acceleration is 10 m/s² down all the way.
Rationales: B: The horizontal velocity component stays at 8 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one. C: The horizontal component is constant, but the vertical component is now 4 m/s, which is not zero at this instant. The speed combines both. D: Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.

**N-1.5-A-v3.** A rocket-powered toy is launched from level ground, after which it is a free projectile with horizontal component 40 m/s and vertical component 30 m/s. Neglecting air resistance, which choice gives its speed and acceleration at t = 4.0 s, after it has passed its highest point?

- A. Speed 10 m/s; acceleration 10 m/s² downward.
- B. Speed 40 m/s; acceleration 10 m/s² downward.
- **C. Speed about 41.2 m/s; acceleration 10 m/s² downward.**
- D. Speed 50 m/s; acceleration 10 m/s² downward.

Check: The object peaks at t = 3.0 s. At t = 4.0 s, v_y = 30 − 10(4.0) = -10 m/s, v_x = 40 m/s, speed = sqrt(40² + -10²) = 41.2 m/s. The acceleration is 10 m/s² down all the way.
Rationales: A: The horizontal velocity component stays at 40 m/s, so it must be included. The speed is the magnitude of both components combined, not just the vertical one. B: The horizontal component is constant, but the vertical component is now 10 m/s, which is not zero at this instant. The speed combines both. D: Speed is the magnitude of the vector, found by combining perpendicular components with the Pythagorean theorem. Adding the components directly overestimates it.

---

## Seed N-1.5-B (new) — Topic 1.5 Vectors and Motion in Two Dimensions
**Skill:** compare range, time of flight, and maximum height for complementary launch angles at equal speed.

Two balls are launched from level ground at the same speed of 20 m/s, one at 30° and the other at 60° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?

- A. The 30° projectile lands farther away, because it has the larger horizontal velocity component.
- B. Both land about 35 m away and stay up for the same time, because they share a launch speed.
- C. The 60° projectile lands farther away, because it rises higher and stays up longer.
- **D. Both land about 35 m away; the 60° projectile stays up longer (3.5 s versus 2.0 s) and rises higher (15.0 m versus 5.0 m).**

Check: R = v² sin(2θ)/g is equal for 30° and 60° (34.6 m). T = 2v sinθ/g gives 2.00 s and 3.46 s. H = (v sinθ)²/2g gives 5.00 m and 15.00 m.
Rationales: A: Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both. B: The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer. C: A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.

**N-1.5-B-v1.** Two arrows are fired from level ground at 30 m/s, one at 20° and one at 70° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?

- A. The 20° projectile lands farther away, because it has the larger horizontal velocity component.
- **B. Both land about 58 m away; the 70° projectile stays up longer (5.6 s versus 2.1 s) and rises higher (39.7 m versus 5.3 m).**
- C. Both land about 58 m away and stay up for the same time, because they share a launch speed.
- D. The 70° projectile lands farther away, because it rises higher and stays up longer.

Check: R = v² sin(2θ)/g is equal for 20° and 70° (57.9 m). T = 2v sinθ/g gives 2.05 s and 5.64 s. H = (v sinθ)²/2g gives 5.26 m and 39.74 m.
Rationales: A: Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both. C: The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer. D: A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.

**N-1.5-B-v2.** Two water jets leave level ground at 16 m/s, one at 15° and one at 75° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?

- A. The 15° projectile lands farther away, because it has the larger horizontal velocity component.
- B. Both land about 13 m away and stay up for the same time, because they share a launch speed.
- **C. Both land about 13 m away; the 75° projectile stays up longer (3.1 s versus 0.8 s) and rises higher (11.9 m versus 0.9 m).**
- D. The 75° projectile lands farther away, because it rises higher and stays up longer.

Check: R = v² sin(2θ)/g is equal for 15° and 75° (12.8 m). T = 2v sinθ/g gives 0.83 s and 3.09 s. H = (v sinθ)²/2g gives 0.86 m and 11.94 m.
Rationales: A: Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both. B: The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer. D: A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.

**N-1.5-B-v3.** Two footballs are kicked from level ground at 25 m/s, one at 35° and one at 55° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?

- **A. Both land about 59 m away; the 55° projectile stays up longer (4.1 s versus 2.9 s) and rises higher (21.0 m versus 10.3 m).**
- B. The 35° projectile lands farther away, because it has the larger horizontal velocity component.
- C. Both land about 59 m away and stay up for the same time, because they share a launch speed.
- D. The 55° projectile lands farther away, because it rises higher and stays up longer.

Check: R = v² sin(2θ)/g is equal for 35° and 55° (58.7 m). T = 2v sinθ/g gives 2.87 s and 4.10 s. H = (v sinθ)²/2g gives 10.28 m and 20.97 m.
Rationales: B: Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both. C: The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer. D: A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.

---

