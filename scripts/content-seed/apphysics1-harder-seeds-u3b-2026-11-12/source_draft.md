# AP Physics 1 topics 3.1 to 3.5: replacement seed drafts (batch u3b)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python.
Scope: replace one-step R1 families in Unit 3 with R3 or strong R2 seeds; keep the R2 power family apphy1-mcq-040 and the conceptual friction family apphy1-mcq-np1-008, plus teaching items that must not be retired.
Target level: comparison of situations, sign and angle traps, force-versus-position data, potential-energy data, nonconservative work, constant-power reasoning.

| Seed | Topic | Replaces |
|---|---|---|
| N-3.1-A | 3.1 Kinetic Energy | apphy1-mcq-007, -036 families |
| N-3.1-B | 3.1 Kinetic Energy | apphy1-np1-009 family (keep sv-np1-009-v3) |
| N-3.2-A | 3.2 Work | apphy1-mcq-006, -037, np1-007, -020 families (keep sv-020-v1) |
| N-3.2-B | 3.2 Work | apphy1-mcq-006, -037 families |
| N-3.3-A | 3.3 Potential Energy | apphy1-mcq-038 family (keep sv-038-v1) |
| N-3.3-B | 3.3 Potential Energy | apphy1-mcq-008 family |
| N-3.4-A | 3.4 Conservation of Energy | apphy1-mcq-039, -041 families (keep sv-041-v1) |
| N-3.4-B | 3.4 Conservation of Energy | apphy1-mcq-039 family |
| N-3.5-A | 3.5 Power | apphy1-np1-010 family (keep np1-010), apphy1-mcq-040 family kept |
| N-3.5-B | 3.5 Power | apphy1-np1-010 family |

---

## Seed N-3.1-A (replaces apphy1-mcq-007, -036 families) — Topic 3.1 Kinetic Energy
**Skill:** compare kinetic energies when both mass and speed differ, and avoid confusing kinetic energy with momentum or with speed alone.

A 4000 kg truck travels at 10 m/s and a 1000 kg car travels at 25 m/s. Which statement correctly compares their motion?

- A. The truck has the greater kinetic energy because it has the greater momentum.
- **B. The car has the greater kinetic energy, about 1.6 times that of the truck.**
- C. The car has the greater kinetic energy, 2.5 times that of the truck.
- D. The car has the greater kinetic energy, about 6 times that of the truck.

Check: Truck K = ½(4000)(10²) = 200 kJ; car K = ½(1000)(25²) = 312.5 kJ; ratio 1.56. Truck momentum 40000 exceeds car momentum 25000, but momentum does not set kinetic energy.
Rationales: A: The truck does have more momentum (40000 versus 25000 kg·m/s), but kinetic energy depends on mv², so the faster car wins. C: A ratio of 2.5 is just the speed ratio; this ignores that the truck has four times the mass, which partly offsets the speed. D: A ratio of 6.25 comes from squaring the speed ratio and ignoring the mass difference entirely.

**N-3.1-A-v1.** Cart X has mass 2 kg and moves at 6 m/s. Cart Y has mass 6 kg and moves at 2 m/s, so the two carts have equal momentum. Which statement is correct?

- A. Both carts have the same kinetic energy because their momenta are equal.
- B. Cart Y has the greater kinetic energy because it has more mass.
- C. Cart X has 9 times the kinetic energy of cart Y.
- **D. Cart X has 3 times the kinetic energy of cart Y.**

Check: K_X = ½(2)(36) = 36 J; K_Y = ½(6)(4) = 12 J; the ratio is 3. Equal momentum with different mass means different kinetic energy.
Rationales: A: Equal momentum does not imply equal kinetic energy; K = p²/2m, so the smaller mass has the larger K. B: Mass alone does not decide it; kinetic energy depends on v², and Y's speed is only one third of X's. C: A factor of 9 is the square of the speed ratio only; it forgets that Y has three times the mass.

**N-3.1-A-v2.** A 0.2 kg ball is thrown at 30 m/s and a 0.8 kg ball is thrown at 15 m/s. Which statement is correct?

- A. The faster ball has the greater kinetic energy.
- B. The heavier ball has the greater kinetic energy and the greater momentum.
- C. The balls have equal kinetic energy and equal momentum.
- **D. The balls have equal kinetic energy, and the heavier ball has the greater momentum.**

Check: K = ½(0.2)(900) = 90 J and ½(0.8)(225) = 90 J, equal. Momenta are 6 and 12 kg·m/s, so the heavier ball has more.
Rationales: A: The faster ball has four times the v² but only one quarter of the mass, so the two effects cancel in K. B: The heavier ball does have more momentum, but its kinetic energy is not larger; it equals the lighter ball's 90 J. C: The kinetic energies are equal, but the momenta are 6 and 12 kg·m/s, so they are not equal.

**N-3.1-A-v3.** A 1000 kg car accelerates from rest to 10 m/s, and later from 10 m/s to 20 m/s. Ignoring all resistance, how do the net work needed in the two stages compare?

- A. The two stages need equal work because the speed increases by the same 10 m/s.
- B. The second stage needs twice as much work as the first.
- **C. The second stage needs 3 times as much work as the first.**
- D. The second stage needs 4 times as much work as the first.

Check: Stage 1: ΔK = ½(1000)(100) = 50 kJ. Stage 2: ΔK = ½(1000)(400 − 100) = 150 kJ. Ratio 3.
Rationales: A: Work equals the change in kinetic energy, which depends on v², not on the size of the change in speed. B: A factor of 2 would match the final speed doubling, but K at 20 m/s minus K at 10 m/s is 150 kJ against 50 kJ. D: A factor of 4 is the ratio of the final K values (200 kJ to 50 kJ), not the ratio of the two changes in K.

---

## Seed N-3.1-B (replaces apphy1-np1-009 family (keep sv-np1-009-v3)) — Topic 3.1 Kinetic Energy
**Skill:** treat kinetic energy as a scalar: change in K depends on the speeds only, not on the direction change or the vector change in velocity.

A 0.40 kg ball strikes a wall at 10 m/s and rebounds along the same line at 6 m/s. What is the change in the ball's kinetic energy?

- A. +12.8 J
- B. +51.2 J
- C. −3.2 J
- **D. −12.8 J**

Check: ΔK = ½(0.40)(6² − 10²) = 0.20(36 − 100) = −12.8 J; direction does not enter K.
Rationales: A: The sign is wrong; the ball ends with less speed, so its kinetic energy decreases and ΔK is negative. B: 51.2 J uses the change in velocity (−16 m/s) squared, treating velocity as if the vector difference sets ΔK. C: 3.2 J uses the change in speed (4 m/s) squared; K depends on the square of each speed, not on the square of their difference.

**N-3.1-B-v1.** A 2.0 kg puck moves east at 4.0 m/s. After a collision it moves north at 3.0 m/s. What is its change in kinetic energy?

- **A. −7.0 J**
- B. +7.0 J
- C. +25 J
- D. −1.0 J

Check: ΔK = ½(2.0)(3.0² − 4.0²) = −7.0 J. Only the speeds matter.
Rationales: B: The puck slows down, so ΔK cannot be positive; 7.0 J has the right size but the wrong sign. C: 25 J comes from taking the magnitude of the vector change in velocity (5 m/s) and squaring it; that is not how K changes. D: 1.0 J squares the change in speed (1 m/s) instead of subtracting the squares of the two speeds.

**N-3.1-B-v2.** A 0.25 kg ball moving at 8.0 m/s strikes a wall perpendicularly and rebounds at 8.0 m/s. Which statement about the ball is correct?

- A. Its kinetic energy and its momentum are both unchanged.
- **B. Its kinetic energy is unchanged, but its momentum changes by 4.0 kg·m/s in magnitude.**
- C. Its kinetic energy increases by 32 J and its momentum is unchanged.
- D. Its kinetic energy decreases by 8.0 J and its momentum is unchanged.

Check: K = ½(0.25)(64) = 8.0 J before and after, so ΔK = 0. Momentum goes from +2.0 to −2.0 kg·m/s, a change of 4.0 in magnitude.
Rationales: A: Momentum is a vector; reversing the direction changes it from +2.0 to −2.0 kg·m/s even though the speed is the same. C: Kinetic energy does not increase; 32 J comes from squaring the vector velocity change of −16 m/s, which is not how K behaves. D: Kinetic energy depends only on speed, which did not change, so K does not drop by 8.0 J; the momentum also does change.

**N-3.1-B-v3.** A 3.0 kg object moves in a horizontal circle at a constant 5.0 m/s. During a quarter of a revolution its velocity changes direction by 90°. What is the net work done on the object during that quarter turn?

- A. 37.5 J
- B. 75 J
- **C. 0 J**
- D. −37.5 J

Check: Speed is constant, so ΔK = 0 and by the work-energy theorem the net work is 0 J (the net force is perpendicular to the motion).
Rationales: A: 37.5 J is the value of K itself (½mv²), not a change in K; K did not change. B: 75 J comes from using the size of the vector change in velocity (about 7.1 m/s) in ½mv²; kinetic energy depends on speed only. D: A negative net work would mean the object is slowing down, but its speed stays 5.0 m/s.

---

## Seed N-3.2-A (replaces apphy1-mcq-006, -037, np1-007, -020 families (keep sv-020-v1)) — Topic 3.2 Work
**Skill:** find the work done by an individual force when several forces act and the object moves at constant speed or along an incline, using net work and angle correctly.

A crate is dragged 5.0 m across a rough floor at constant speed by a rope with tension 100 N directed 37° above the horizontal (cos 37° = 0.80). What is the work done on the crate by the friction force of the floor?

- A. −500 J
- **B. −400 J**
- C. 0 J
- D. +400 J

Check: Constant speed means ΔK = 0, so net work is zero. Normal force and gravity do no work, so W_friction = −W_rope = −(100)(5.0)(0.80) = −400 J.
Rationales: A: 500 J would be the rope's work if the full tension acted along the motion; the rope's horizontal component is only 80 N, so friction does −400 J. C: Friction does not do zero work; it opposes the motion, and zero net work comes from friction canceling the rope's positive work. D: Friction opposes the displacement, so its work is negative; a positive 400 J belongs to the rope.

**N-3.2-A-v1.** A 10 kg box is pushed 4.0 m up a rough incline of height 2.0 m by a force parallel to the incline, at constant speed. Friction on the box is 20 N. Use g = 10 m/s². How much work does the pushing force do?

- A. 120 J
- B. 200 J
- **C. 280 J**
- D. 480 J

Check: Constant speed: F = mg sinθ + f = 50 + 20 = 70 N (mg sinθ = mg·h/L = 100·0.5). W = 70 × 4.0 = 280 J.
Rationales: A: 120 J subtracts friction (50 − 20 = 30 N) when friction acts down the slope along with gravity's component, so it adds. B: 200 J is the increase in gravitational potential energy only; the push must also supply the energy lost to friction. D: 480 J uses the full weight (100 N) as the force opposing the motion instead of its component along the slope.

**N-3.2-A-v2.** A 2.0 kg block slides 3.0 m down a 30° incline while a constant 4.0 N friction force acts up the slope. Use g = 10 m/s². What is the net work done on the block?

- A. 30 J
- **B. 18 J**
- C. 42 J
- D. 40 J

Check: Gravity: mg sin30° × d = 20 × 0.5 × 3.0 = 30 J. Friction: −4.0 × 3.0 = −12 J. Normal force: 0. Net = 18 J.
Rationales: A: 30 J counts gravity's work alone and leaves out the negative work done by friction. C: 42 J adds the magnitude of friction's work instead of subtracting it; friction opposes the displacement. D: 40 J uses the cosine of the angle (mg cos30° along the slope), which is the component perpendicular to the incline, not along it.

**N-3.2-A-v3.** A 3.0 kg object is raised 2.0 m by a cable while accelerating upward at 2.0 m/s². Use g = 10 m/s². How much work does the cable do on the object?

- A. 60 J
- B. 12 J
- **C. 72 J**
- D. 48 J

Check: T − mg = ma gives T = 3.0(10 + 2.0) = 36 N, so W = 36 × 2.0 = 72 J.
Rationales: A: 60 J is mg·h, the work if the object rose at constant speed; the upward acceleration requires extra tension. B: 12 J is the net work (ma × d), which is the work done by all forces together, not by the cable alone. D: 48 J uses T = m(g − a), subtracting the acceleration as if the object were accelerating downward.

---

## Seed N-3.2-B (replaces apphy1-mcq-006, -037 families) — Topic 3.2 Work
**Skill:** compute work from a force that changes with position (area with sign) and connect it to a change in speed.

A 2.0 kg object moves along the x axis with speed 3.0 m/s at x = 0. The net force on it is +6.0 N from x = 0 to 2.0 m, zero from 2.0 to 5.0 m, and −4.0 N from 5.0 m to 7.0 m. What is its speed at x = 7.0 m?

- A. 3.0 m/s
- **B. 3.6 m/s**
- C. 4.6 m/s
- D. 5.4 m/s

Check: W = 6(2) + 0 + (−4)(2) = 4 J. K_f = ½(2)(9) + 4 = 13 J, so v = √13 = 3.6 m/s.
Rationales: A: 3.0 m/s would mean zero net work, which comes from ignoring the positive work of the first segment. C: 4.6 m/s uses only the +12 J of the first segment and ignores the negative work done in the last segment. D: 5.4 m/s adds the magnitude of the negative work (12 + 8 = 20 J) instead of subtracting it.

**N-3.2-B-v1.** A force along the x axis grows linearly from 0 at x = 0 to 12 N at x = 0.50 m, then stays at 12 N until x = 1.5 m. How much work does the force do from x = 0 to x = 1.5 m?

- A. 12 J
- **B. 15 J**
- C. 18 J
- D. 9.0 J

Check: Area: triangle ½(12)(0.50) = 3.0 J plus rectangle (12)(1.0) = 12 J gives 15 J.
Rationales: A: 12 J counts only the constant-force part and ignores the work done while the force was growing. C: 18 J uses the maximum force (12 N) for the whole 1.5 m, overestimating the early part. D: 9.0 J uses the average of 0 and 12 N (6 N) over the whole 1.5 m, which only applies to the first segment.

**N-3.2-B-v2.** A 3.0 kg object starts from rest at x = 0. The net force on it is +5.0 N from x = 0 to 4.0 m, then −10 N from x = 4.0 m to 6.0 m. At x = 6.0 m, its speed is

- A. 3.7 m/s
- **B. 0 m/s**
- C. 5.2 m/s
- D. 4.5 m/s

Check: W = 5(4) + (−10)(2) = 20 − 20 = 0 J. Net work is zero, so the object has the same kinetic energy as at the start: it is at rest.
Rationales: A: 3.7 m/s results from counting only the +20 J of the first segment and ignoring the −20 J in the second. C: 5.2 m/s results from adding the magnitudes of both segments (40 J) instead of using the sign of the second. D: 4.5 m/s results from using 5.0 N over the entire 6.0 m (30 J), forgetting that the force reversed.

**N-3.2-B-v3.** A 20 N force acts on an object while it moves 7.0 m along a line. For the first 2.0 m the force is parallel to the motion, for the next 2.0 m it is at 60° to the motion, and for the last 3.0 m it is perpendicular to the motion. What total work does the force do?

- A. 75 J
- **B. 60 J**
- C. 80 J
- D. 140 J

Check: W = 20(2.0)cos0° + 20(2.0)cos60° + 20(3.0)cos90° = 40 + 20 + 0 = 60 J.
Rationales: A: 75 J uses sin60° instead of cos60° for the middle leg (about 34.6 J there), mixing up the component along the motion. C: 80 J gives full force credit on the 60° leg (40 J there), ignoring the cosine. D: 140 J multiplies the force by the whole distance and ignores the angles.

---

## Seed N-3.3-A (replaces apphy1-mcq-038 family (keep sv-038-v1)) — Topic 3.3 Potential Energy
**Skill:** read force direction and motion from potential-energy data: force is the negative slope of U, and total energy limits the motion.

A particle moves along the x axis in a conservative force field. Its potential energy decreases linearly from 12 J at x = 0 to 4 J at x = 2 m, stays at 4 J from x = 2 m to 3 m, then increases linearly to 10 J at x = 5 m. Which choice gives the force on the particle in the three intervals (0 to 2 m, 2 to 3 m, 3 to 5 m)?

- **A. +4 N, 0 N, −3 N**
- B. −4 N, 0 N, +3 N
- C. +4 N, +4 N, −3 N
- D. +8 N, 0 N, −6 N

Check: F = −ΔU/Δx: −(4 − 12)/2 = +4 N; −(0)/1 = 0; −(10 − 4)/2 = −3 N.
Rationales: B: These signs are reversed; the force points toward lower potential energy, so it is +x where U decreases and −x where U increases. C: The force in the flat region is zero, not equal to the value of U; U itself does not set the force, only its slope does. D: These values use the total change in U across each interval instead of the change divided by the interval length.

**N-3.3-A-v1.** A potential energy function is given by these values (in joules): U = 6.0 at x = 0, 1.5 at x = 1 m, 0 at x = 2 m, 1.5 at x = 3 m, and 6.0 at x = 4 m, with a smooth parabolic shape. A particle is released from rest at x = 1 m. Which description of its motion is correct?

- **A. It moves to x = 3 m and turns around, with maximum kinetic energy of 1.5 J at x = 2 m.**
- B. It moves to x = 4 m and turns around, with maximum kinetic energy of 6.0 J.
- C. It moves to x = 3 m and turns around, with maximum kinetic energy of 3.0 J at x = 2 m.
- D. It moves to x = 2 m and stays there, because the force is zero at that position.

Check: Total energy is 1.5 J, so the particle can reach any point with U ≤ 1.5 J, up to x = 3 m. Its K is largest where U is smallest (x = 2 m): K = 1.5 − 0 = 1.5 J.
Rationales: B: U = 6.0 J at x = 4 m exceeds the particle's total energy of 1.5 J, so it cannot reach x = 4 m. C: Maximum K equals the total energy minus the minimum U (1.5 J), not twice that value. D: The force is zero at x = 2 m, but the particle arrives there with nonzero speed and keeps moving past it.

**N-3.3-A-v2.** A 0.50 kg particle on the x axis has potential energy 10 J at x = 0, 4 J at x = 2 m, and −2 J at x = 4 m, changing linearly between these points. It is released from rest at x = 0. What is its speed at x = 4 m?

- A. 2.8 m/s
- B. 4.9 m/s
- C. 6.3 m/s
- **D. 6.9 m/s**

Check: ΔU = −2 − 10 = −12 J, so K = 12 J and v = √(2·12/0.50) = 6.9 m/s.
Rationales: A: 2.8 m/s sets K equal to the magnitude of the final U (2 J) instead of the decrease in U. B: 4.9 m/s leaves out the factor ½ in K = ½mv², using mv² = 12 J. C: 6.3 m/s uses the starting U (10 J) as the energy gained instead of the full change from 10 J to −2 J.

**N-3.3-A-v3.** The potential energy of a particle (in joules) is 10 at x = 0, 6 at x = 1 m, 3 at x = 2 m, 4 at x = 3 m, 9 at x = 4 m and 15 at x = 5 m. Which statement is correct?

- **A. There is a stable equilibrium near x = 2 m, and the force at x = 4 m points toward −x.**
- B. There is a stable equilibrium at x = 0 where U is greatest, and the force at x = 4 m points toward +x.
- C. There is an equilibrium near x = 2 m, but the force at x = 4 m points toward +x.
- D. There is no equilibrium because U is never zero.

Check: U is lowest near x = 2 m, so that is a stable equilibrium. At x = 4 m, U is rising with x, so F = −dU/dx is negative: toward −x, back toward the minimum.
Rationales: B: At x = 0 the potential energy is falling steeply toward +x, so there is a force there and it is not an equilibrium; also U is rising at x = 4 m, so the force there is toward −x. C: At x = 4 m, U increases with x, so the force points toward −x; a +x force would push the particle up the potential hill. D: Equilibrium occurs where the slope of U is zero, not where U itself is zero.

---

## Seed N-3.3-B (replaces apphy1-mcq-008 family) — Topic 3.3 Potential Energy
**Skill:** find changes in potential energy that depend on configuration (height, compression, reference level) rather than on path length or arbitrary zeros.

A spring is stretched from 0 to 2.0 cm, and then further from 2.0 cm to 6.0 cm. How does the work needed in the second stretch compare with the work needed in the first?

- A. 2 times as much, because the second stretch is 2 times as long.
- B. 3 times as much, because 6.0 cm is 3 times 2.0 cm.
- **C. 8 times as much, because U depends on the square of the stretch.**
- D. 9 times as much, because the final stretch is 3 times the first.

Check: U = ½kx². First stretch: ½k(2²) = 2k (cm² units). Second: ½k(6² − 2²) = 16k. Ratio = 8.
Rationales: A: The second stretch is 4.0 cm against 2.0 cm, but the force also grows with stretch, so the work is not proportional to the length. B: A ratio of 3 treats the work as proportional to the final stretch, but the spring force increases as it is stretched. D: A factor of 9 compares the total energy at 6.0 cm to that at 2.0 cm (36 to 4); the second stretch only adds the difference.

**N-3.3-B-v1.** Maya takes the floor as U = 0 for a 2.0 kg book on a shelf 1.50 m high. Jon takes the 0.75 m high table as U = 0. The book falls from the shelf onto the table. Use g = 10 m/s². Which statement is correct?

- A. Both find the book's initial U is 30 J, so they agree on the energy of the shelf.
- B. Maya finds a decrease of 15 J and Jon finds a decrease of 30 J.
- **C. Both find that the book's U decreases by 15 J, though they disagree on the values of U.**
- D. Only Maya's analysis is correct, since the floor is the true zero of potential energy.

Check: Maya: 30 J to 15 J. Jon: 15 J to 0 J. Both find ΔU = −15 J = −mg(0.75 m). Only changes in U are physically meaningful.
Rationales: A: Jon's initial U is 15 J, not 30 J; the value of U depends on the chosen zero. B: Jon's value is also 15 J: the drop is 0.75 m for both, and the choice of zero does not change a difference. D: No reference level is physically special; any choice gives the same ΔU.

**N-3.3-B-v2.** A 4.0 kg crate is pushed at constant speed 5.0 m along a ramp to a platform 3.0 m above the starting point. Use g = 10 m/s². What is the change in the gravitational potential energy of the crate-Earth system?

- A. 200 J
- B. 160 J
- **C. 120 J**
- D. 72 J

Check: ΔU = mgΔh = 4.0 × 10 × 3.0 = 120 J, regardless of the path length along the ramp.
Rationales: A: 200 J uses the ramp length (5.0 m) as the height; only the vertical change matters. B: 160 J uses the horizontal distance of 4.0 m (from the 3-4-5 triangle) as the height. D: 72 J applies the factor 3/5 a second time; the 3.0 m height already includes the incline geometry, so the rise is not scaled again.

**N-3.3-B-v3.** A spring with k = 200 N/m is compressed 0.10 m and then compressed further to 0.30 m. What is the change in the elastic potential energy stored in the spring?

- A. 4.0 J
- **B. 8.0 J**
- C. 9.0 J
- D. 40 J

Check: ΔU = ½(200)(0.30² − 0.10²) = 100(0.09 − 0.01) = 8.0 J.
Rationales: A: 4.0 J uses ½k(Δx)² with Δx = 0.20 m; the energy depends on the squares of the compressions, not the square of their difference. C: 9.0 J is the total energy stored at 0.30 m; it does not subtract the 1.0 J already stored at 0.10 m. D: 40 J is k times the extra compression (200 × 0.20), which is a force in newtons, not an energy; energy changes come from differences of ½kx².

---

## Seed N-3.4-A (replaces apphy1-mcq-039, -041 families (keep sv-041-v1)) — Topic 3.4 Conservation of Energy
**Skill:** apply energy conservation with nonconservative work, and recognize which quantities do and do not depend on the path.

A 2.0 kg block is released from rest at a height of 3.0 m on a curved track. Friction on the track dissipates a total of 8.0 J as the block reaches the bottom. Use g = 10 m/s². What is the block's speed at the bottom?

- A. 6.6 m/s
- **B. 7.2 m/s**
- C. 7.7 m/s
- D. 8.2 m/s

Check: mgh = 60 J. K_bottom = 60 − 8 = 52 J, so v = √(2·52/2.0) = √52 = 7.2 m/s.
Rationales: A: 6.6 m/s subtracts the 8.0 J of dissipated energy twice (K = 44 J). C: 7.7 m/s ignores friction (K = 60 J), which is the answer for a frictionless track. D: 8.2 m/s adds the dissipated energy to the starting energy (K = 68 J) instead of subtracting it.

**N-3.4-A-v1.** A 0.50 kg ball is thrown straight up at 12 m/s and reaches a maximum height of 6.0 m because of air drag. Use g = 10 m/s². How much mechanical energy is transferred to thermal energy by air resistance during the rise?

- **A. 6.0 J**
- B. 36 J
- C. 30 J
- D. 66 J

Check: Initial K = ½(0.50)(144) = 36 J. At the top U = mgh = 30 J and K = 0. Lost energy = 36 − 30 = 6.0 J.
Rationales: B: 36 J is the initial kinetic energy, not the amount lost to drag; some of it became gravitational potential energy. C: 30 J is the gain in gravitational potential energy, not the energy lost to drag. D: 66 J adds the initial kinetic energy and the final potential energy; the energy lost is their difference.

**N-3.4-A-v2.** Block X slides from rest down a frictionless ramp of height 2.0 m that is inclined at 30°. Block Y, with the same mass, slides from rest down a different frictionless ramp, also of height 2.0 m, inclined at 60°. Which statement is correct about their speeds at the bottom? Use g = 10 m/s².

- A. Block Y is faster because its steeper ramp gives a larger acceleration.
- B. Block X is faster because gravity does work over a longer distance on the gentler ramp.
- C. Block Y reaches the bottom with a higher kinetic energy than block X.
- **D. Both blocks reach the bottom at about 6.3 m/s, although block Y arrives sooner.**

Check: Frictionless: both lose mgh, so ½mv² = mgh gives v = √(2·10·2.0) = 6.3 m/s for both. Only the time differs (Y is steeper, so it arrives sooner).
Rationales: A: A larger acceleration shortens the time, but the speed depends only on the height dropped when there is no friction. B: Gravity's work is mg × (vertical drop) on either ramp; the longer path is offset by a smaller force component along the slope. C: Kinetic energy at the bottom equals mgh for both blocks, so they have equal K.

**N-3.4-A-v3.** A block slides from rest down a frictionless ramp that drops 1.5 m, then onto a level floor where the coefficient of kinetic friction is 0.30. Use g = 10 m/s². How far along the floor does the block slide before stopping?

- A. 0.45 m
- B. 10 m
- C. 50 m
- **D. 5.0 m**

Check: mgh = μmg d, so d = h/μ = 1.5/0.30 = 5.0 m (the mass cancels).
Rationales: A: 0.45 m multiplies the height by μ (μh) instead of dividing; friction's work must equal the starting energy. B: 10 m drops the factor of 2 when going from v² = 2gh and the stopping relation, using d = v²/(μg). C: 50 m forgets to divide by g when computing the stopping distance from v²/(2μ).

---

## Seed N-3.4-B (replaces apphy1-mcq-039 family) — Topic 3.4 Conservation of Energy
**Skill:** choose the right states and geometry (height, spring compression, loop condition) when applying conservation of mechanical energy.

A 1.0 kg ball is dropped from rest at 5.0 m above the floor, hits the floor, and rebounds to a height of 3.2 m. Use g = 10 m/s². How much mechanical energy of the ball-Earth system is dissipated in the collision?

- A. 50 J
- B. 32 J
- **C. 18 J**
- D. 82 J

Check: Before: mgh = 50 J. After rebound: 32 J. Dissipated: 50 − 32 = 18 J.
Rationales: A: 50 J is the whole initial energy; the ball still has 32 J of mechanical energy after rebounding. B: 32 J is the mechanical energy the ball retains after the bounce, not the amount lost. D: 82 J adds the two energies; energy dissipated is their difference.

**N-3.4-B-v1.** A spring with k = 400 N/m is compressed 0.10 m and launches a 0.050 kg ball straight up. Ignore friction and air drag, and treat the launch as occurring at the release point of the spring. Use g = 10 m/s². What is the maximum height of the ball above the release point?

- A. 2.0 m
- **B. 4.0 m**
- C. 8.0 m
- D. 40 m

Check: U_spring = ½(400)(0.10²) = 2.0 J. At the top, mgh = 2.0 J, so h = 2.0/(0.050 × 10) = 4.0 m.
Rationales: A: 2.0 m uses the stored energy in joules as if it were a height; dividing by the weight (0.50 N), not by 1 N, is what converts energy to height. C: 8.0 m uses U = kx² = 4.0 J and forgets the factor ½ in the spring energy. D: 40 m takes the energy as 20 J (½kx with x not squared); the spring energy involves x².

**N-3.4-B-v2.** A 2.0 m long pendulum bob is released from rest with the string at 60° from the vertical. Use g = 10 m/s². What is the speed of the bob at the lowest point?

- A. 3.2 m/s
- **B. 4.5 m/s**
- C. 6.3 m/s
- D. 7.7 m/s

Check: The bob drops h = L(1 − cos60°) = 2.0(0.5) = 1.0 m, so v = √(2gh) = 4.5 m/s. The tension does no work.
Rationales: A: 3.2 m/s is √(gh) with h = 1.0 m; it drops the factor of 2 in v = √(2gh). C: 6.3 m/s uses the full string length 2.0 m as the drop; the bob falls only L(1 − cos60°). D: 7.7 m/s uses h = L(1 + cos60°) = 3.0 m, which is the wrong geometry for the height drop.

**N-3.4-B-v3.** A small cart starts from rest on a frictionless track and enters a vertical loop of radius 0.80 m. What is the minimum starting height above the bottom of the loop that lets the cart stay in contact with the track at the top of the loop? Use g = 10 m/s².

- A. 1.2 m
- B. 1.6 m
- **C. 2.0 m**
- D. 2.4 m

Check: At the top, contact requires v² ≥ gR. Energy: mg h = mg(2R) + ½mv²_top ≥ mg(2R) + ½mgR, so h ≥ 2.5R = 2.0 m.
Rationales: A: 1.2 m (1.5R) is too small even to reach the top of the loop, which is 1.6 m above the bottom. B: 1.6 m (2R) would bring the cart to the top with zero speed, but at the top it needs speed √(gR) to stay on the track. D: 2.4 m (3R) is more than needed; at the minimum speed the cart needs only 2.5R of starting height.

---

## Seed N-3.5-A (replaces apphy1-np1-010 family (keep np1-010), apphy1-mcq-040 family kept) — Topic 3.5 Power
**Skill:** distinguish work from power and use efficiency, slope and time to compare energy transfer rates in multi-step settings.

Climber A has mass 60 kg and climbs 10 m in 20 s. Climber B has mass 80 kg and climbs 6.0 m in 15 s. Use g = 10 m/s². Which statement is correct about their work against gravity and average power?

- A. A does more work and has the greater average power.
- **B. A does more work, but B has the greater average power.**
- C. B does more work and has the greater average power.
- D. They do equal work, and B has the greater power.

Check: A: W = 60·10·10 = 6000 J, P = 300 W. B: W = 80·10·6.0 = 4800 J, P = 320 W. A does more work; B has more power.
Rationales: A: A's power is 300 W, which is less than B's 320 W; more work does not imply more power when the time differs. C: B's work is 4800 J, less than A's 6000 J; B's greater mass is offset by a smaller climb height. D: The works are 6000 J and 4800 J, not equal, since mass times height differ.

**N-3.5-A-v1.** A hoist motor is rated at 2.0 kW but only 80% of its output power goes into lifting. How long does it take to raise a 500 kg load 8.0 m at constant speed? Use g = 10 m/s².

- A. 16 s
- B. 20 s
- **C. 25 s**
- D. 31 s

Check: Work = 500·10·8.0 = 40000 J. Useful power = 0.80 × 2000 = 1600 W. t = 40000/1600 = 25 s.
Rationales: A: 16 s divides the work by 2500 W, as if the efficiency increased the available power. B: 20 s uses the full 2000 W and ignores the efficiency loss. D: 31 s applies the efficiency a second time (25 s ÷ 0.80).

**N-3.5-A-v2.** A cyclist and bicycle with total mass 80 kg climb a steady slope at a constant 5.0 m/s. The road rises 1.0 m for every 10 m traveled along it, and the combined drag and friction force opposing the motion is 20 N. Use g = 10 m/s². What power must the cyclist supply?

- A. 400 W
- B. 100 W
- C. 4000 W
- **D. 500 W**

Check: At constant speed the forward force is mg sinθ + drag = 80 + 20 = 100 N, so P = Fv = 100 × 5.0 = 500 W.
Rationales: A: 400 W accounts for the climb only and leaves out the power spent against drag and friction. B: 100 W is the 100 N force alone; power is force times speed, so the force must be multiplied by 5.0 m/s. C: 4000 W uses the full weight (800 N) instead of the component along the slope (80 N).

**N-3.5-A-v3.** A 100 W bulb is left on for 5.0 hours. An electric heater rated at 1500 W is run for 20 minutes. Which statement correctly compares the energy used?

- A. The heater uses more energy because its power is 15 times larger.
- B. The bulb uses more energy because it is on for much longer.
- **C. The bulb and heater use equal energy.**
- D. The heater uses 3 times as much energy as the bulb.

Check: Bulb: 100 W × 5.0 h = 0.50 kWh. Heater: 1500 W × (1/3 h) = 0.50 kWh. Equal.
Rationales: A: The heater runs for only 1/15 as long, so the 15-times power advantage is exactly cancelled. B: The bulb has a much smaller power, and the longer time exactly cancels the heater's greater rate of energy use. D: A factor of 3 has no basis here; energy is power times time, and both devices use 0.50 kWh, so the ratio is 1.

---

## Seed N-3.5-B (replaces apphy1-np1-010 family) — Topic 3.5 Power
**Skill:** use P = Fv with the force component along the velocity, constant-power engines and instantaneous versus average power.

A car's engine delivers a constant 60 kW to the drive wheels. At 30 m/s, the total resistive force on the 1000 kg car is 1500 N. What is the car's acceleration at that instant?

- **A. 0.50 m/s²**
- B. 2.0 m/s²
- C. 3.5 m/s²
- D. 4.5 m/s²

Check: Forward force F = P/v = 60000/30 = 2000 N. Net force = 2000 − 1500 = 500 N, so a = 0.50 m/s².
Rationales: B: 2.0 m/s² is F/m with the resistance ignored; the resistive force subtracts from the forward force. C: 3.5 m/s² adds the resistive force to the forward force instead of subtracting it. D: 4.5 m/s² uses the forward force found at 10 m/s (6000 N), not the smaller one at 30 m/s; constant power means force falls as speed rises.

**N-3.5-B-v1.** A 2.0 kg object at rest is pulled by a constant 6.0 N net force along a frictionless horizontal line for 4.0 s. What is the instantaneous power delivered by the force at t = 4.0 s?

- A. 24 W
- B. 36 W
- C. 144 W
- **D. 72 W**

Check: a = 3.0 m/s², v = 12 m/s at 4.0 s, P = Fv = 6.0 × 12 = 72 W. The average power over the interval is only 36 W.
Rationales: A: 24 W multiplies the force by the time (6.0 × 4.0), which does not have units of power. B: 36 W is the average power (F × average speed 6 m/s); the instantaneous power at the end is twice this. C: 144 W equals the kinetic energy at 4.0 s (½·2·12²), which is work done, not a rate.

**N-3.5-B-v2.** A force of 200 N is applied to a sled by a rope that makes a 60° angle with the horizontal path. The sled moves at constant speed 3.0 m/s. What power does the rope's force deliver to the sled?

- **A. 300 W**
- B. 600 W
- C. 520 W
- D. 100 W

Check: P = Fv cosθ = 200 × 3.0 × 0.50 = 300 W.
Rationales: B: 600 W ignores the angle and uses the full 200 N, but only the component along the motion transfers energy. C: 520 W uses sin60° instead of cos60°, which is the component perpendicular to the motion. D: 100 W comes from dividing 200 N × 3.0 m/s by 6 or by an angle value; the component along the motion is F cos60°, so the power is not 100 W.

**N-3.5-B-v3.** A car's top speed on a level road is 40 m/s when its engine delivers 50 kW. At high speed the air-drag force is proportional to v². If the engine power is doubled to 100 kW, what is the new top speed, to the nearest 0.1 m/s?

- **A. 50.4 m/s**
- B. 56.6 m/s
- C. 63.5 m/s
- D. 80.0 m/s

Check: At top speed engine power equals drag power: P = kv³. Doubling P multiplies v by 2^(1/3) = 1.26, giving 40 × 1.26 = 50.4 m/s.
Rationales: B: 56.6 m/s uses v ∝ √P, which would hold if drag were constant; with drag ∝ v², the power needed is proportional to v³. C: 63.5 m/s corresponds to v ∝ P^(2/3), a wrong exponent from mixing the powers of v. D: 80.0 m/s assumes speed is proportional to power; the drag grows with speed, so doubling power does not double the top speed.

---
