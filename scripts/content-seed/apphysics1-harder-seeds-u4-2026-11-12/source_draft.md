# AP Physics 1 Unit 4: new seed drafts (Linear Momentum and Collisions)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python (scratchpad).
Scope: new content. The published pool has no practice MCQs for Unit 4 (topics 4.1 to 4.4), so nothing is retired. Two seeds per topic, three variants each (32 items).
Target level: comparison of momentum with kinetic energy, signed momentum and impulse, internal explosions and collisions, collision followed by energy, and classification of collisions by numbers.

| Seed | Topic | Description |
|---|---|---|
| N-4.1-A | 4.1 | same stopping force: equal momentum versus kinetic energy |
| N-4.1-B | 4.1 | center of mass velocity with signed momenta and an internal collision |
| N-4.2-A | 4.2 | force-time record with a sign change and a negative initial velocity |
| N-4.2-B | 4.2 | rebound versus sticking: average force from change in momentum |
| N-4.3-A | 4.3 | internal explosion of a moving object |
| N-4.3-B | 4.3 | perfectly inelastic collision with a moving target, then ramp, spring or friction |
| N-4.4-A | 4.4 | classify a collision from momentum and kinetic energy numbers |
| N-4.4-B | 4.4 | elastic versus perfectly inelastic for the same incoming cart |

---

## Seed N-4.1-A (new) — Topic 4.1 Linear Momentum
**Skill:** compare momentum and kinetic energy of two moving objects to predict stopping time and stopping distance.

Cart X has mass 2 kg and moves at 6 m/s. Cart Y has mass 6 kg and moves at 2 m/s. Each cart is brought to rest by the same constant braking force. Which statement is correct?

- A. Both stop in the same time and travel the same distance, because their momenta are equal.
- B. Y takes three times as long to stop and travels farther, because it has more mass.
- **C. Both stop in the same time, but X travels three times as far.**
- D. X takes three times as long to stop and travels three times as far, because it moves three times as fast.

Check: p = mv = 12 kg·m/s for both, so t = p/F is the same. Work-energy: F·d = KE; KE_X = ½(2)(36) = 36 J, KE_Y = ½(6)(4) = 12 J, so d_X = 3 d_Y.
Rationales: A: Equal momentum (12 kg·m/s each) does give equal stopping times, but the distance depends on kinetic energy, which is 36 J for X and only 12 J for Y. B: Mass alone does not set the stopping time. The impulse needed is the momentum, 12 kg·m/s for both carts, so with the same force the times are equal. D: This uses speed alone and ignores mass. The momenta are equal, so the stopping times are equal even though the distance ratio of three is right.

**N-4.1-A-v1.** Block P has mass 3 kg and moves at 8 m/s. Block Q has mass 12 kg and moves at 2 m/s. Each block is brought to rest by the same constant force. Which statement is correct?

- **A. Both stop in the same time, but P travels four times as far.**
- B. Both stop in the same time and travel the same distance, because their momenta are equal.
- C. Q takes four times as long to stop and travels farther, because it has four times the mass.
- D. P takes four times as long to stop and travels four times as far, because it moves four times as fast.

Check: p = 24 kg·m/s for both, so t = p/F is equal. KE_P = ½(3)(64) = 96 J, KE_Q = ½(12)(4) = 24 J, and d = KE/F gives d_P = 4 d_Q.
Rationales: B: Equal momentum (24 kg·m/s each) gives equal stopping times only. The stopping distance depends on kinetic energy, 96 J for P versus 24 J for Q. C: The stopping time depends on momentum, not mass alone. Both blocks have 24 kg·m/s, so the same force stops them in the same time. D: This counts speed but ignores mass in the momentum. The momenta are equal so the times are equal, although the distance ratio of four is right.

**N-4.1-A-v2.** A 500 kg car moves at 12 m/s and a 1500 kg truck moves at 4 m/s. Each is brought to rest over the same stopping distance by a constant braking force. How do the braking forces compare?

- A. The forces are equal, because the car and truck have the same momentum.
- **B. The force on the car is three times the force on the truck.**
- C. The force on the truck is three times the force on the car, because the truck has three times the mass.
- D. The force on the car is nine times the force on the truck, because the car is three times as fast.

Check: F·d = KE for each. KE_car = ½(500)(144) = 36000 J, KE_truck = ½(1500)(16) = 12000 J. With equal d, F_car/F_truck = 3.
Rationales: A: Equal momentum means equal impulse, which fixes the stopping time for equal forces. Over the same distance the force depends on kinetic energy, 36000 J for the car versus 12000 J. C: Greater mass does not mean greater force here. F = KE/d and the car has three times the kinetic energy, so the car needs the larger force. D: This squares the speed ratio but ignores the masses. KE depends on mv², and the truck's mass of three times offsets part of it, leaving a ratio of three.

**N-4.1-A-v3.** Block P has mass 1 kg and moves at 8 m/s. Block Q has mass 4 kg and moves at 4 m/s. The same constant force brings each block to rest. Which statement is correct?

- A. Both blocks stop in the same time and travel the same distance, because their kinetic energies are equal.
- B. P takes twice as long to stop, and both blocks travel the same distance.
- C. Q takes twice as long to stop and travels twice as far, because it has twice the momentum.
- **D. Q takes twice as long to stop, and both blocks travel the same distance.**

Check: KE_P = ½(1)(64) = 32 J, KE_Q = ½(4)(16) = 32 J, so d = KE/F is equal. p_P = 8, p_Q = 16 kg·m/s, so t = p/F is twice as long for Q.
Rationales: A: Equal kinetic energy (32 J each) gives equal stopping distances, but the momenta differ (8 versus 16 kg·m/s), so the stopping times are not equal. B: This reverses the time comparison. Q has twice the momentum (16 versus 8 kg·m/s), so it needs twice the impulse and takes longer. C: Time does follow momentum, but the distance follows kinetic energy, which is equal (32 J each). The distance is therefore the same for both blocks.

---

## Seed N-4.1-B (new) — Topic 4.1 Linear Momentum
**Skill:** find the velocity of the center of mass of a system with signed momenta, and recognize that an internal collision does not change it.

Three carts ride on a frictionless horizontal track. Cart 1 (2 kg) moves at +3 m/s, cart 2 (1 kg) moves at −2 m/s and cart 3 (1 kg) moves at +4 m/s. Carts 2 and 3 collide and stick together before anything else happens. What is the velocity of the center of mass of the three-cart system after that collision?

- A. +1.0 m/s
- B. +1.67 m/s
- C. +3.0 m/s
- **D. +2.0 m/s**

Check: Total p = 2(3) + 1(−2) + 1(4) = +8 kg·m/s, M = 4 kg, so v_cm = +2.0 m/s. The collision between carts 2 and 3 is internal, so v_cm is the same before and after.
Rationales: A: This is the velocity of the stuck pair alone (carts 2 and 3 have total momentum +2 kg·m/s and mass 2 kg). The center of mass of the whole system includes cart 1. B: This averages the three velocities without weighting by mass. The center of mass velocity is total momentum divided by total mass. C: This adds the momenta as if all were positive, ignoring that cart 2 moves in the negative direction, then divides by the total mass of 4 kg.

**N-4.1-B-v1.** Three skaters glide on frictionless ice. Skater 1 (50 kg) moves at +2 m/s, skater 2 (30 kg) moves at −3 m/s and skater 3 (20 kg) moves at +1 m/s. Skaters 2 and 3 push off each other, and nobody else is touched. What is the velocity of the center of mass of the three-skater system after the push?

- **A. +0.30 m/s**
- B. −1.4 m/s
- C. 0.0 m/s
- D. +2.1 m/s

Check: Total p = 50(2) + 30(−3) + 20(1) = 100 − 90 + 20 = +30 kg·m/s. M = 100 kg, so v_cm = +0.30 m/s. The push is an internal interaction and does not change it.
Rationales: B: This is the center of mass velocity of skaters 2 and 3 only (total momentum −70 kg·m/s, mass 50 kg). Skater 1 must be included in the system. C: This averages the three velocities, (2 − 3 + 1)/3 = 0, without weighting by mass, and so does not give the true center of mass velocity. D: This adds the magnitudes of the momenta as if all were positive, giving 210 kg·m/s, and divides by 100 kg. Signs must be kept for momentum.

**N-4.1-B-v2.** Three pucks slide on a frictionless air table. Puck 1 (0.4 kg) moves at +5 m/s, puck 2 (0.2 kg) moves at −10 m/s and puck 3 (0.4 kg) moves at +2.5 m/s. Pucks 1 and 2 collide elastically before anything else happens. What is the velocity of the center of mass of the three-puck system after that collision?

- A. 0 m/s
- B. −0.83 m/s
- **C. +1.0 m/s**
- D. +5.0 m/s

Check: Total p = 0.4(5) + 0.2(−10) + 0.4(2.5) = 2 − 2 + 1 = +1 kg·m/s; M = 1.0 kg; v_cm = +1.0 m/s, unchanged by the internal collision.
Rationales: A: Pucks 1 and 2 have a total momentum of zero, but puck 3 is also part of the system and carries +1 kg·m/s, so the system as a whole is not at rest. B: This averages the velocities without weighting by mass. The center of mass velocity is total momentum divided by total mass. D: This adds the magnitudes of the three momenta (2 + 2 + 1 kg·m/s) and divides by the total mass of 1 kg. The momentum of puck 2 is negative and must subtract.

**N-4.1-B-v3.** Three blocks slide on a frictionless track. Block 1 (1 kg) moves at +6 m/s, block 2 (3 kg) moves at −2 m/s and block 3 (2 kg) moves at +3 m/s. Blocks 2 and 3 collide and stick together before anything else happens. What is the velocity of the center of mass of the three-block system after that collision?

- A. 0 m/s
- **B. +1.0 m/s**
- C. +2.3 m/s
- D. +3.0 m/s

Check: Total p = 1(6) + 3(−2) + 2(3) = 6 − 6 + 6 = +6 kg·m/s; M = 6 kg; v_cm = +1.0 m/s, the same before and after the internal collision.
Rationales: A: Blocks 2 and 3 have total momentum of zero, so the stuck pair stops, but block 1 is part of the system and still carries +6 kg·m/s. C: This averages the three velocities without weighting by mass. The center of mass velocity must be total momentum divided by total mass. D: This adds the magnitudes of the momenta, 6 + 6 + 6 = 18 kg·m/s, and divides by 6 kg. Block 2 moves in the negative direction, so its momentum subtracts.

---

## Seed N-4.2-A (new) — Topic 4.2 Change in Momentum and Impulse
**Skill:** use the area under a force-time record with a sign change and the initial velocity to find a final velocity.

A 2 kg cart moves along a frictionless track with an initial velocity of −3 m/s. The net force on it, along the track, is +8 N from t = 0 to t = 3 s and then −5 N from t = 3 s to t = 7 s. What is the velocity of the cart at t = 7 s?

- A. +2 m/s
- **B. −1 m/s**
- C. +5 m/s
- D. +1 m/s

Check: J = (+8)(3) + (−5)(4) = 24 − 20 = +4 N·s. Δv = J/m = +2 m/s. v_f = −3 + 2 = −1 m/s.
Rationales: A: This finds the velocity change, J/m = +2 m/s, but treats the cart as starting from rest instead of adding the initial velocity of −3 m/s. C: This finds the +2 m/s change but adds it to +3 m/s, dropping the negative sign of the initial velocity. Momentum and velocity are signed quantities. D: This adds the net impulse of +4 N·s directly to the initial velocity without dividing by the 2 kg mass, giving 4 − 3.

**N-4.2-A-v1.** A 4 kg cart moves along a frictionless track with an initial velocity of −5 m/s. The net force on it, along the track, is +10 N from t = 0 to t = 2 s and then −4 N from t = 2 s to t = 5 s. What is the velocity of the cart at t = 5 s?

- **A. −3 m/s**
- B. +2 m/s
- C. +7 m/s
- D. +3 m/s

Check: J = (+10)(2) + (−4)(3) = 20 − 12 = +8 N·s. Δv = 8/4 = +2 m/s. v_f = −5 + 2 = −3 m/s.
Rationales: B: This finds the velocity change, J/m = +2 m/s, but ignores the initial velocity of −5 m/s, as if the cart began at rest. C: This adds the +2 m/s velocity change to +5 m/s, dropping the negative sign of the initial velocity. D: This adds the net impulse of +8 N·s to the initial velocity without dividing by the 4 kg mass, giving 8 − 5.

**N-4.2-A-v2.** A 3 kg cart moves along a frictionless track with an initial velocity of +10 m/s. The net force on it, along the track, is −6 N from t = 0 to t = 4 s and then +3 N from t = 4 s to t = 6 s. What is the velocity of the cart at t = 6 s?

- A. −6 m/s
- B. −16 m/s
- **C. +4 m/s**
- D. −8 m/s

Check: J = (−6)(4) + (+3)(2) = −24 + 6 = −18 N·s. Δv = −18/3 = −6 m/s. v_f = +10 − 6 = +4 m/s.
Rationales: A: This finds the velocity change, J/m = −6 m/s, but forgets to add the initial velocity of +10 m/s. B: This subtracts the 6 m/s change from −10 m/s, giving the initial velocity the wrong sign. D: This adds the net impulse of −18 N·s to the initial velocity without dividing by the 3 kg mass, giving −18 + 10.

**N-4.2-A-v3.** A 2 kg cart moves along a frictionless track with an initial velocity of −4 m/s. The net force on it, along the track, is +12 N from t = 0 to t = 1 s and then −3 N from t = 1 s to t = 3 s. What is the velocity of the cart at t = 3 s?

- A. +3 m/s
- B. +7 m/s
- C. +2 m/s
- **D. −1 m/s**

Check: J = (+12)(1) + (−3)(2) = 12 − 6 = +6 N·s. Δv = 6/2 = +3 m/s. v_f = −4 + 3 = −1 m/s.
Rationales: A: This finds the velocity change, J/m = +3 m/s, but ignores the initial velocity of −4 m/s. B: This adds the +3 m/s velocity change to +4 m/s, dropping the negative sign of the initial velocity. C: This adds the net impulse of +6 N·s to the initial velocity without dividing by the 2 kg mass, giving 6 − 4.

---

## Seed N-4.2-B (new) — Topic 4.2 Change in Momentum and Impulse
**Skill:** compare the average forces in two collisions by the change in momentum, including a rebound, rather than by speed lost or energy lost.

A 0.50 kg clay ball and a 0.50 kg rubber ball each hit the same wall at 6.0 m/s, and each is in contact with the wall for the same time. The clay ball sticks to the wall. The rubber ball rebounds at 4.0 m/s. How do the average forces the wall exerts on the balls compare?

- **A. The force on the rubber ball is about 1.7 times the force on the clay ball.**
- B. The forces are equal, because both balls arrive with the same momentum and the same contact time.
- C. The force on the clay ball is about 3 times the force on the rubber ball, because the clay ball loses 6 m/s of speed and the rubber ball loses only 2 m/s.
- D. The force on the clay ball is about 1.8 times the force on the rubber ball, because the clay ball loses 9 J of kinetic energy and the rubber ball loses 5 J.

Check: Clay: |Δp| = 0.5(6) = 3.0 kg·m/s. Rubber: magnitude 0.5(6 + 4) = 5.0 kg·m/s. With equal times, F_rubber/F_clay = 5/3 ≈ 1.7.
Rationales: B: The force depends on the change in momentum, not the initial momentum. The rubber ball's momentum changes by 5.0 kg·m/s and the clay ball's by only 3.0 kg·m/s. C: This compares changes in speed, ignoring that the rubber ball reverses direction. Its velocity changes from +6 to −4 m/s, a change of 10 m/s. D: Force is set by the change in momentum, not by energy lost. Energy lost says nothing about how large a push is needed to reverse the ball's velocity.

**N-4.2-B-v1.** A 0.20 kg clay ball and a 0.20 kg rubber ball each hit the same wall at 10 m/s, with equal contact times. The clay ball sticks. The rubber ball rebounds at 5 m/s. How do the average forces the wall exerts on the balls compare?

- A. The forces are equal, because both balls arrive with the same momentum and the same contact time.
- B. The force on the clay ball is 2 times the force on the rubber ball, because the clay ball loses 10 m/s of speed and the rubber ball loses only 5 m/s.
- **C. The force on the rubber ball is 1.5 times the force on the clay ball.**
- D. The force on the clay ball is about 1.3 times the force on the rubber ball, because the clay ball loses 10 J of kinetic energy and the rubber ball loses 7.5 J.

Check: Clay: Δp magnitude = 0.20(10) = 2.0 kg·m/s. Rubber: 0.20(10 + 5) = 3.0 kg·m/s. With equal contact times, F_rubber/F_clay = 3.0/2.0 = 1.5.
Rationales: A: The force depends on the change in momentum. The rubber ball's momentum changes by 3.0 kg·m/s and the clay ball's by 2.0 kg·m/s. B: This compares speed lost and ignores that the rubber ball reverses direction, so its velocity changes by 15 m/s, not 5 m/s. D: Force is set by the change in momentum, not by kinetic energy lost. The energy comparison reverses the true ordering of the forces.

**N-4.2-B-v2.** A 1000 kg car hits a barrier at 6.0 m/s in two crash tests, each lasting the same time. In test 1 the car stops against the barrier. In test 2 the car rebounds at 2.0 m/s. How do the average forces on the car compare?

- A. The forces are equal, because the car arrives at the same speed with the same contact time.
- B. The force in test 1 is 1.5 times the force in test 2, because the car loses 6 m/s of speed in test 1 and only 4 m/s in test 2.
- C. The force in test 1 is about 1.1 times the force in test 2, because the car loses 18000 J of kinetic energy in test 1 and 16000 J in test 2.
- **D. The force in test 2 is about 1.3 times the force in test 1.**

Check: Test 1: |Δp| = 1000(6) = 6000 kg·m/s. Test 2: |Δp| = 1000(6 + 2) = 8000 kg·m/s. With equal times, F2/F1 = 8000/6000 ≈ 1.3.
Rationales: A: The force depends on the change in momentum. In test 2 the change is 8000 kg·m/s and in test 1 it is 6000 kg·m/s. B: This compares changes in speed (6 versus 4) but in test 2 the velocity reverses, so the change in velocity is 8 m/s, not 4 m/s. C: Force is set by the change in momentum, not by energy lost. Using energy lost reverses the true ordering of the two forces.

**N-4.2-B-v3.** A 0.40 kg ball arrives at a catcher's pad at 8.0 m/s, and the contact lasts the same time in two trials. In trial 1 the ball is held by the pad. In trial 2 the ball is deflected back at 2.0 m/s. How do the average forces on the ball compare?

- A. The forces are equal, because the ball arrives with the same momentum and the same contact time.
- **B. The force in trial 2 is 1.25 times the force in trial 1.**
- C. The force in trial 1 is 1.33 times the force in trial 2, because the ball loses 8 m/s of speed in trial 1 and 6 m/s in trial 2.
- D. The force in trial 1 is 1.07 times the force in trial 2, because the ball loses 12.8 J of kinetic energy in trial 1 and 12.0 J in trial 2.

Check: Trial 1: |Δp| = 0.40(8) = 3.2 kg·m/s. Trial 2: 0.40(8 + 2) = 4.0 kg·m/s. With equal times, F2/F1 = 4.0/3.2 = 1.25.
Rationales: A: The force depends on the change in momentum. In trial 2 the change is 4.0 kg·m/s and in trial 1 it is 3.2 kg·m/s. C: This compares changes in speed. In trial 2 the ball reverses, so the velocity change is 10 m/s, not 6 m/s. D: Force is set by the change in momentum, not by kinetic energy lost. Using energy reverses the true ordering of the forces.

---

## Seed N-4.3-A (new) — Topic 4.3 Conservation of Linear Momentum
**Skill:** apply conservation of momentum to an internal explosion of a moving object, keeping signs and the initial momentum.

A 4 kg cart moves at +3 m/s along a frictionless track. A small internal explosion splits it into a 1 kg piece and a 3 kg piece. Immediately afterward the 1 kg piece moves at −6 m/s. What is the velocity of the 3 kg piece immediately afterward?

- A. +2 m/s
- B. +3 m/s
- C. +4.5 m/s
- **D. +6 m/s**

Check: Initial p = 4(3) = +12 kg·m/s. After: 1(−6) + 3v = 12, so 3v = 18 and v = +6 m/s.
Rationales: A: This balances the explosion as though the cart started at rest, so the 3 kg piece only cancels the 1 kg piece's momentum. The cart's initial momentum of +12 kg·m/s must be included. B: This assumes the explosion changed only the small piece and left the large piece at its original velocity. Momentum is conserved for the pair, so both pieces change. C: This divides the correct momentum of the 3 kg piece, +18 kg·m/s, by the total mass of 4 kg rather than by the 3 kg piece's mass.

**N-4.3-A-v1.** A 5 kg cart moves at +2 m/s along a frictionless track. A small internal explosion splits it into a 2 kg piece and a 3 kg piece. Immediately afterward the 2 kg piece moves at −1 m/s. What is the velocity of the 3 kg piece immediately afterward?

- A. +0.67 m/s
- **B. +4 m/s**
- C. +2.0 m/s
- D. +2.4 m/s

Check: Initial p = 5(2) = +10 kg·m/s. After: 2(−1) + 3v = 10, so 3v = 12 and v = +4 m/s.
Rationales: A: This balances the explosion as though the cart started at rest, so the 3 kg piece only cancels the 2 kg piece's momentum. The cart's initial momentum of +10 kg·m/s is ignored. C: This assumes the explosion left the 3 kg piece at the cart's original velocity. Momentum is conserved for the pair, so both pieces change. D: This divides the correct momentum of the 3 kg piece, +12 kg·m/s, by the total mass of 5 kg rather than by the 3 kg piece's mass.

**N-4.3-A-v2.** A 50 kg skater glides at +4 m/s on frictionless ice while carrying a 10 kg medicine ball, so the pair moves at +4 m/s together. The skater throws the ball backward so that it moves at −2 m/s relative to the ice. What is the skater's velocity immediately after the throw?

- A. +4.0 m/s
- B. +4.4 m/s
- **C. +5.2 m/s**
- D. +0.4 m/s

Check: Initial p = (50 + 10)(4) = +240 kg·m/s. After: 50v + 10(−2) = 240, so 50v = 260 and v = +5.2 m/s.
Rationales: A: This assumes the skater's velocity is unchanged by throwing the ball. Throwing the ball is an internal interaction that changes the skater's momentum. B: This gives the ball's momentum the wrong sign, so 240 − 20 is divided by 50 kg. The ball moves backward, so its momentum is negative and the skater must gain momentum. D: This balances the throw as though the pair started at rest, ignoring the initial momentum of +240 kg·m/s.

**N-4.3-A-v3.** A 6 kg shell moves horizontally at +10 m/s. It breaks into a 2 kg piece and a 4 kg piece. Immediately afterward the 2 kg piece moves at −5 m/s. What is the velocity of the 4 kg piece immediately afterward?

- A. +10 m/s
- B. +12.5 m/s
- C. +2.5 m/s
- **D. +17.5 m/s**

Check: Initial p = 6(10) = +60 kg·m/s. After: 2(−5) + 4v = 60, so 4v = 70 and v = +17.5 m/s.
Rationales: A: This assumes the larger piece keeps the shell's original velocity. Momentum is conserved for the pair, so both pieces change. B: This gives the 2 kg piece's momentum the wrong sign, using 60 − 10 = 50 kg·m/s for the 4 kg piece. Its momentum is −10 kg·m/s, so the other piece must have +70 kg·m/s. C: This balances the break-up as though the shell began at rest, so the 4 kg piece only cancels the 2 kg piece's momentum. The initial momentum of +60 kg·m/s is ignored.

---

## Seed N-4.3-B (new) — Topic 4.3 Conservation of Linear Momentum
**Skill:** chain a perfectly inelastic collision with a moving target to an energy calculation, using momentum for the collision and energy only afterward.

On a frictionless horizontal surface, block A (3 kg) moves at +6 m/s and catches up with block B (2 kg) moving ahead of it at +1 m/s. They stick together and then slide up a frictionless ramp. Use g = 10 m/s². What maximum height above the surface do the blocks reach?

- A. 0.65 m
- B. 1.1 m
- **C. 0.80 m**
- D. 1.8 m

Check: Momentum: 3(6) + 2(1) = 20 = 5v, so v = 4 m/s just after sticking. Energy afterward: ½v² = gh, h = 16/20 = 0.80 m.
Rationales: A: This treats block B as at rest, so the combined speed is 18/5 = 3.6 m/s. Block B's momentum of +2 kg·m/s must be included. B: This assumes kinetic energy is conserved in the collision and sets the 55 J total equal to the potential energy. Sticking together is a perfectly inelastic collision in which kinetic energy is lost. D: This sends block A up the ramp by itself with its original 6 m/s, ignoring both the collision and block B.

**N-4.3-B-v1.** Block A (2 kg) moves at +5 m/s and block B (3 kg) moves toward it at −2 m/s on a frictionless surface. They collide head-on and stick together, then slide into a spring of force constant 2000 N/m, which is attached to a wall on the frictionless surface. What is the maximum compression of the spring?

- **A. 4.0 cm**
- B. 16 cm
- C. 18 cm
- D. 10 cm

Check: Momentum: 2(5) + 3(−2) = 4 = 5v, so v = 0.8 m/s. Energy: ½(5)(0.64) = 1.6 J = ½(2000)x², so x = 0.04 m = 4.0 cm.
Rationales: B: This adds the magnitudes of the momenta, 10 + 6 = 16 kg·m/s, so the blocks move at 3.2 m/s. Block B moves in the opposite direction, so its momentum subtracts. C: This assumes kinetic energy is conserved in the collision and uses the 31 J of kinetic energy from before sticking. Sticking together loses kinetic energy. D: This ignores block B's momentum, so the blocks move at 10/5 = 2 m/s. Block B's momentum of −6 kg·m/s must reduce the total.

**N-4.3-B-v2.** On a frictionless surface, block A (2 kg) moves at +9 m/s and catches up with block B (4 kg) moving ahead of it at +3 m/s. They stick together and slide up a frictionless ramp. Use g = 10 m/s². What maximum height above the surface do the blocks reach?

- A. 0.45 m
- B. 1.65 m
- C. 4.05 m
- **D. 1.25 m**

Check: Momentum: 2(9) + 4(3) = 30 = 6v, so v = 5 m/s. Energy afterward: h = v²/(2g) = 25/20 = 1.25 m.
Rationales: A: This treats block B as at rest, so the combined speed is 18/6 = 3 m/s. Block B's momentum of +12 kg·m/s must be included. B: This assumes kinetic energy is conserved in the collision, using 99 J as the energy at the ramp. Sticking together loses kinetic energy. C: This sends block A up the ramp by itself with its original 9 m/s, ignoring the collision and block B.

**N-4.3-B-v3.** On a horizontal surface, block A (1 kg) moves at +7 m/s and catches up with block B (3 kg) moving ahead of it at +1 m/s. They stick together and slide to rest on a rough stretch with coefficient of kinetic friction 0.25. Use g = 10 m/s². How far do they slide on the rough stretch?

- A. 0.61 m
- **B. 1.25 m**
- C. 2.6 m
- D. 9.8 m

Check: Momentum: 1(7) + 3(1) = 10 = 4v, so v = 2.5 m/s. Friction does work: μmg·d = ½mv², so d = v²/(2μg) = 6.25/5 = 1.25 m.
Rationales: A: This treats block B as at rest, so the combined speed is 7/4 = 1.75 m/s. Block B's momentum of +3 kg·m/s must be included. C: This assumes kinetic energy is conserved in the collision and uses 26 J divided by the friction force of 10 N. Sticking together loses kinetic energy. D: This slides block A alone at its original 7 m/s, ignoring the collision and block B.

---

## Seed N-4.4-A (new) — Topic 4.4 Elastic and Inelastic Collisions
**Skill:** classify a collision from momentum and kinetic energy before and after, using numbers.

A 2 kg cart moving at +4 m/s collides with a 1 kg cart at rest on a frictionless track. Motion sensors show that afterward the 2 kg cart moves at +2 m/s and the 1 kg cart moves at +4 m/s. Which statement about this collision is correct?

- A. It is elastic, because the total momentum is the same before and after.
- B. It is perfectly inelastic, because kinetic energy decreased.
- **C. It is inelastic but the carts do not stick: momentum is conserved while kinetic energy falls from 16 J to 12 J.**
- D. The data are impossible, because kinetic energy is not conserved.

Check: Momentum: before 2(4) = 8, after 2(2) + 1(4) = 8. Kinetic energy: before ½(2)(16) = 16 J, after ½(2)(4) + ½(1)(16) = 4 + 8 = 12 J.
Rationales: A: Conservation of momentum holds in every collision with no outside force, so it cannot show the collision is elastic. Kinetic energy falls from 16 J to 12 J. B: A perfectly inelastic collision requires the objects to move together afterward. Here they end with different velocities, so kinetic energy was lost without the carts sticking. D: Kinetic energy need not be conserved. Momentum is conserved (8 kg·m/s before and after) and kinetic energy decreases, which is physically allowed.

**N-4.4-A-v1.** A 3 kg cart moving at +5 m/s collides with a 2 kg cart at rest on a frictionless track. Afterward the 3 kg cart moves at +1 m/s and the 2 kg cart moves at +6 m/s. Which statement about this collision is correct?

- **A. It is elastic: momentum stays 15 kg·m/s and kinetic energy stays 37.5 J.**
- B. It is inelastic, because the 3 kg cart lost most of its speed.
- C. It is perfectly inelastic, because the 3 kg cart slows down a great deal.
- D. The data are impossible, because the 2 kg cart ends up faster than the 3 kg cart started.

Check: Momentum: 3(5) = 15 = 3(1) + 2(6). Kinetic energy: before ½(3)(25) = 37.5 J; after ½(3)(1) + ½(2)(36) = 1.5 + 36 = 37.5 J, so the collision is elastic.
Rationales: B: Losing speed in a collision does not by itself mean kinetic energy is lost. Here the kinetic energy transferred to the 2 kg cart exactly matches what the 3 kg cart lost. C: A perfectly inelastic collision requires the carts to move together afterward. These carts separate at different speeds. D: A lighter cart can leave faster than the heavier cart arrived. Momentum (15 kg·m/s) and kinetic energy (37.5 J) are both consistent with these speeds.

**N-4.4-A-v2.** A 2 kg cart moving at +3 m/s collides head-on with a 2 kg cart moving at −1 m/s on a frictionless track. Afterward both carts move together at +1 m/s. Which statement about this collision is correct?

- A. It is elastic, because the total momentum is the same before and after.
- **B. It is perfectly inelastic: momentum is conserved while kinetic energy falls from 10 J to 2 J.**
- C. It is inelastic but not perfectly inelastic, because the carts lose some kinetic energy.
- D. Momentum is not conserved, because kinetic energy decreased.

Check: Momentum: 2(3) + 2(−1) = 4 = 4(1). Kinetic energy: before ½(2)(9) + ½(2)(1) = 10 J; after ½(4)(1) = 2 J. They move together, so it is perfectly inelastic.
Rationales: A: Momentum is conserved in every collision with no outside force. Kinetic energy falls from 10 J to 2 J, so the collision is not elastic. C: The carts move together afterward at the same velocity, which is the definition of a perfectly inelastic collision. The maximum possible amount of kinetic energy was lost for this collision. D: The two conservation laws are separate. Momentum is the same before and after (2(3) + 2(−1) = 4 kg·m/s, and 4(1) = 4 kg·m/s) even though kinetic energy decreased.

**N-4.4-A-v3.** A 2 kg cart moving at +4 m/s collides with a 1 kg cart at rest on a frictionless track. A student's data show that afterward the 2 kg cart moves at +1 m/s and the 1 kg cart moves at +6 m/s. The carts contain no springs or other stored energy. Which statement about these data is correct?

- A. The collision was elastic, because the total momentum is the same before and after.
- B. The collision was inelastic, because the carts end with different speeds.
- **C. The data are impossible: momentum balances at 8 kg·m/s, but kinetic energy would rise from 16 J to 19 J.**
- D. The collision was perfectly inelastic, because the lighter cart ends up faster.

Check: Momentum: 2(4) = 8 = 2(1) + 1(6). Kinetic energy: before ½(2)(16) = 16 J; after ½(2)(1) + ½(1)(36) = 1 + 18 = 19 J. A gain of energy is impossible without an energy source.
Rationales: A: Momentum balances, but an elastic collision also needs equal kinetic energy. Here kinetic energy goes from 16 J to 19 J, so it is not conserved. B: An inelastic collision loses kinetic energy. These data show a gain, from 16 J to 19 J, which would need an energy source. D: A perfectly inelastic collision has the carts moving together at the same velocity afterward and kinetic energy decreasing. Neither is true of these data.

---

## Seed N-4.4-B (new) — Topic 4.4 Elastic and Inelastic Collisions
**Skill:** compare an elastic collision with a perfectly inelastic one for the same incoming object, tracking momentum, kinetic energy and impulse.

Cart A (1 kg) moves at 4 m/s toward an identical stationary cart B (1 kg) on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?

- A. The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.
- **B. The total momentum afterward is the same in both (4 kg·m/s), the kinetic energy afterward is 4 J in collision 1 and 8 J in collision 2, and cart B receives half as much impulse in collision 1.**
- C. The kinetic energy afterward is the same in both collisions, because momentum is conserved in both.
- D. The total momentum afterward is the same in both collisions and cart B receives the same impulse in both, because cart A starts with the same momentum.

Check: Collision 1: v = 4/2 = 2 m/s, p = 4, KE = ½(2)(4) = 4 J, impulse on B = 1(2) = 2 N·s. Collision 2: A stops and B moves at 4 m/s, p = 4, KE = 8 J, impulse on B = 4 N·s.
Rationales: A: Total momentum is conserved in both collisions. Kinetic energy is lost when the carts stick, but the total momentum stays 4 kg·m/s. C: Conserving momentum does not guarantee conserving kinetic energy. After sticking the energy is 4 J, while the elastic collision leaves 8 J. D: The impulse on B equals its momentum gained. In collision 1 B ends at 2 m/s (impulse 2 N·s), and in collision 2 B ends at 4 m/s (impulse 4 N·s).

**N-4.4-B-v1.** Cart A (2 kg) moves at 3 m/s toward cart B (1 kg), which is at rest on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?

- A. The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.
- B. The kinetic energy afterward is 9 J in both collisions, because momentum is conserved in both.
- C. The total momentum afterward is 6 kg·m/s in both and cart B receives the same impulse in both, because cart A starts with the same momentum.
- **D. The total momentum afterward is 6 kg·m/s in both, the kinetic energy afterward is 6 J in collision 1 and 9 J in collision 2, and cart B receives half as much impulse in collision 1.**

Check: Collision 1: v = 6/3 = 2 m/s, KE = ½(3)(4) = 6 J, impulse on B = 1(2) = 2 N·s. Collision 2: v_A = 1 m/s, v_B = 4 m/s, KE = 1 + 8 = 9 J, impulse on B = 4 N·s.
Rationales: A: Momentum is conserved in both collisions, so the total is 6 kg·m/s either way. Only kinetic energy differs. B: Kinetic energy is lost when the carts stick: after sticking the carts move at 2 m/s with 6 J, not 9 J. C: The impulse on B equals its momentum gained. B ends at 2 m/s in collision 1 (2 N·s) and at 4 m/s in collision 2 (4 N·s).

**N-4.4-B-v2.** Cart A (1 kg) moves at 8 m/s toward cart B (3 kg), which is at rest on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?

- **A. The total momentum afterward is 8 kg·m/s in both, the kinetic energy afterward is 8 J in collision 1 and 32 J in collision 2, and cart B receives half as much impulse in collision 1.**
- B. The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.
- C. The kinetic energy afterward is 32 J in both collisions, because momentum is conserved in both.
- D. The total momentum afterward is 8 kg·m/s in both and cart B receives the same impulse in both, because cart A starts with the same momentum.

Check: Collision 1: v = 8/4 = 2 m/s, KE = ½(4)(4) = 8 J, impulse on B = 3(2) = 6 N·s. Collision 2: v_A = −4 m/s, v_B = +4 m/s, KE = 8 + 24 = 32 J, impulse on B = 12 N·s.
Rationales: B: Momentum is conserved in both collisions, so the total is 8 kg·m/s either way. Only kinetic energy differs. C: Kinetic energy is lost when the carts stick: after sticking the carts move at 2 m/s with 8 J, not 32 J. D: The impulse on B equals its momentum gained. B ends at 2 m/s in collision 1 (6 N·s) and at 4 m/s in collision 2 (12 N·s).

**N-4.4-B-v3.** Cart A (3 kg) moves at 4 m/s toward cart B (1 kg), which is at rest on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?

- A. The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.
- B. The kinetic energy afterward is 24 J in both collisions, because momentum is conserved in both.
- **C. The total momentum afterward is 12 kg·m/s in both, the kinetic energy afterward is 18 J in collision 1 and 24 J in collision 2, and cart B receives half as much impulse in collision 1.**
- D. The total momentum afterward is 12 kg·m/s in both and cart B receives the same impulse in both, because cart A starts with the same momentum.

Check: Collision 1: v = 12/4 = 3 m/s, KE = ½(4)(9) = 18 J, impulse on B = 1(3) = 3 N·s. Collision 2: v_A = 2 m/s, v_B = 6 m/s, KE = 6 + 18 = 24 J, impulse on B = 6 N·s.
Rationales: A: Momentum is conserved in both collisions, so the total is 12 kg·m/s either way. Only kinetic energy differs. B: Kinetic energy is lost when the carts stick: after sticking the carts move at 3 m/s with 18 J, not 24 J. D: The impulse on B equals its momentum gained. B ends at 3 m/s in collision 1 (3 N·s) and at 6 m/s in collision 2 (6 N·s).

---
