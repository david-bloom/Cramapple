# AP Physics 1 Unit 2: new harder seed drafts (Force and Translational Dynamics)

DRAFT for owner review. Author-in-session; not checked by a checker; not in the database. Every numeric claim recomputed in Python. Two new R3 seeds per topic (2.1 to 2.9), three variants each (72 items); nothing is retired.

| Seed | Topic | Replaces |
|---|---|---|
| N-2.1-A | 2.1 | new |
| N-2.1-B | 2.1 | new |
| N-2.2-A | 2.2 | new |
| N-2.2-B | 2.2 | new |
| N-2.3-A | 2.3 | new |
| N-2.3-B | 2.3 | new |
| N-2.4-A | 2.4 | new |
| N-2.4-B | 2.4 | new |
| N-2.5-A | 2.5 | new |
| N-2.5-B | 2.5 | new |
| N-2.6-A | 2.6 | new |
| N-2.6-B | 2.6 | new |
| N-2.7-A | 2.7 | new |
| N-2.7-B | 2.7 | new |
| N-2.8-A | 2.8 | new |
| N-2.8-B | 2.8 | new |
| N-2.9-A | 2.9 | new |
| N-2.9-B | 2.9 | new |

---

## Seed N-2.1-A (new) — Topic 2.1 Systems and Center of Mass
**Skill:** apply Newton's second law to a chosen system: internal force pairs cancel, so only external forces set the acceleration of the center of mass.

Block P (4 kg) rests on block Q (6 kg), which sits on a frictionless table. A horizontal 20 N force pushes on Q, and P rides on Q without slipping. For the system made of both blocks, which choice gives the net external horizontal force and the acceleration of the system's center of mass?

- A. 28 N; 2.8 m/s². The 20 N push and the 8 N friction force on P both act on the system.
- **B. 20 N; 2.0 m/s². Friction between the blocks is internal and does not change either value.**
- C. 12 N; 1.2 m/s². The 8 N friction force on P opposes the 20 N push.
- D. 20 N; 3.3 m/s². Only the 6 kg block responds to the push.

Check: Internal pairs cancel, so F_ext = 20 N on M = 10 kg and a_cm = 2.0 m/s². Friction on P is 4 × 2 = 8 N forward, with an equal 8 N backward on Q.
Rationales: A: The 8 N friction force on P comes from Q, which is part of the system, so it is internal. Its equal and opposite partner on Q cancels it, so it never adds to the external force. C: Friction on P points forward, not backward, and the opposite friction force on Q cancels it inside the system. The external force on the system is the full 20 N. D: P rides on Q without slipping, so both blocks share the same acceleration. The 20 N external force acts on the whole 10 kg system, not on 6 kg alone.

**N-2.1-A-v1.** A 2 kg block and a 3 kg block hang from opposite ends of a light string that passes over a light, frictionless pulley held by a fixed support. The blocks are released from rest. For the system of both blocks and the string, what are the net external force and the acceleration of the center of mass just after release?

- **A. 2 N downward; 0.4 m/s² downward.**
- B. 0 N; 0 m/s². The tensions are internal forces and cancel.
- C. 10 N downward; 2.0 m/s² downward. This is the net force and acceleration of the blocks.
- D. 50 N downward; 10 m/s² downward. Only gravity acts on the system.

Check: a = (30 − 20)/5 = 2 m/s² and T = 2(10 + 2) = 24 N. The pulley pushes up on the string with 48 N, so F_net = 50 − 48 = 2 N down and a_cm = 2/5 = 0.4 m/s².
Rationales: B: The tension pair inside the string is internal, but the pulley support pulls up on the string with an external 48 N, which is less than the 50 N weight. The net external force is not zero. C: The heavier block accelerates down at 2.0 m/s² while the lighter one goes up at 2.0 m/s². Their motions partly cancel in the center of mass, so a_cm is much smaller than 2.0 m/s². D: The pulley support exerts an upward external force of 48 N through the string, so gravity is not the only external force. The system does not fall freely.

**N-2.1-A-v2.** Cart R (2 kg) and cart S (3 kg) are joined by a light spring on a frictionless horizontal track. A steady 15 N horizontal force pulls on R directly away from S, and the carts move together with the spring at a constant stretch. For the two-cart system, what are the net external force and the acceleration of the center of mass?

- A. 15 N; 7.5 m/s². The pull accelerates only the 2 kg cart.
- B. 6 N; 1.2 m/s². The 9 N spring force subtracts from the 15 N pull.
- C. 9 N; 1.8 m/s². Only the spring force acts on the system.
- **D. 15 N; 3.0 m/s².**

Check: Only the 15 N pull is external, so a_cm = 15/(2 + 3) = 3.0 m/s². The spring pulls S with 3 × 3 = 9 N, leaving 15 − 9 = 6 N = 2 × 3 on R.
Rationales: A: The spring transmits the pull to S, so both carts accelerate together. The 15 N external force acts on the whole 5 kg system, giving 3.0 m/s². B: The spring force on R is a force between parts of the system, so it is internal. It does subtract from the pull for cart R alone, but not for the system as a whole. C: The 15 N pull is applied from outside the system and is the external force. The spring force of 9 N is internal and cancels with its partner.

**N-2.1-A-v3.** A 70 kg person stands at the rear of a 140 kg boat that is at rest on calm water, where water resistance is negligible. She walks 3.0 m toward the front, a distance measured relative to the boat. How far does the boat move relative to the water, and in which direction?

- A. 3.0 m, opposite to her walking direction.
- B. 2.0 m, opposite to her walking direction.
- **C. 1.0 m, opposite to her walking direction.**
- D. 0 m. The net external force on the system is zero, so nothing moves.

Check: x_cm stays fixed: 70(x_b + 3.0) + 140 x_b = 0 gives x_b = −1.0 m. She moves +2.0 m relative to the water and the boat moves 1.0 m back.
Rationales: A: The 3.0 m is her displacement relative to the boat, not the boat's displacement. The center of mass stays fixed, so the boat moves only 1.0 m while she moves 2.0 m relative to the water. B: The 2.0 m is her own displacement relative to the water. The boat has twice her mass, so it moves half as far as she does, which is 1.0 m. D: A zero net external force keeps the center of mass of the system fixed, not each part. Her push on the boat is internal, so the boat moves backward while she moves forward.

---

## Seed N-2.1-B (new) — Topic 2.1 Systems and Center of Mass
**Skill:** locate the center of mass at a later time: it moves at the mass-weighted velocity even when the parts move differently.

Two small carts ride on separate, parallel frictionless tracks, so they never touch. Cart 1 (2 kg) starts at x = 0 and moves at +4 m/s. Cart 2 (6 kg) starts at x = +8 m and moves at −2 m/s. At what x-coordinate is the center of mass of the two-cart system at t = 2.0 s?

- A. +6.0 m. With no external force the center of mass stays where it started.
- B. +8.0 m. The center of mass moves at the plain average of the velocities, +1 m/s.
- **C. +5.0 m**
- D. +4.0 m. The center of mass follows the heavier cart.

Check: At t = 2.0 s the carts are at +8.0 m and +4.0 m: x_cm = (2·8 + 6·4)/8 = 5.0 m. Equivalent: x_cm0 = 6.0 m, v_cm = (8 − 12)/8 = −0.5 m/s.
Rationales: A: No net external force means the center of mass has constant velocity, not zero velocity. Here v_cm = −0.5 m/s, so it moves 1.0 m in 2.0 s. B: The center of mass velocity is total momentum over total mass, which weights each velocity by mass. The 6 kg cart dominates, so v_cm is −0.5 m/s, not +1 m/s. D: The center of mass is between the carts, not at the heavier one. At t = 2.0 s the 6 kg cart is at +4.0 m, but the 2 kg cart is at +8.0 m, so x_cm is +5.0 m.

**N-2.1-B-v1.** Two small carts ride on separate, parallel frictionless tracks. Cart A (3 kg) starts at x = −4 m and moves at +6 m/s. Cart B (1 kg) starts at x = +4 m and moves at −2 m/s. At what x-coordinate is the center of mass of the system at t = 1.5 s?

- A. −2.0 m. The center of mass stays at its starting position.
- **B. +4.0 m**
- C. +1.0 m. The center of mass moves at the plain average velocity, +2 m/s.
- D. +5.0 m. The center of mass is at the position of the heavier cart.

Check: At 1.5 s the carts are at +5.0 m and +1.0 m: x_cm = (3·5 + 1·1)/4 = 4.0 m. Check: x_cm0 = −2 m, v_cm = (18 − 2)/4 = +4 m/s, so −2 + 6 = +4 m.
Rationales: A: With no external force the center of mass keeps moving at constant velocity. Its velocity is +4 m/s, so it does not stay at its starting position of −2.0 m. C: This averages the two velocities without weighting by mass. The 3 kg cart counts three times as much, giving v_cm = +4 m/s. D: At t = 1.5 s cart A is at +5.0 m, but cart B is at +1.0 m. The center of mass lies between them, weighted toward the heavier cart, at +4.0 m.

**N-2.1-B-v2.** Two small carts ride on separate, parallel frictionless tracks. Cart C (5 kg) starts at x = +1 m and moves at −3 m/s. Cart D (1 kg) starts at x = +7 m and moves at +6 m/s. At what x-coordinate is the center of mass of the system at t = 2.0 s?

- **A. −1.0 m**
- B. +2.0 m. The center of mass stays at its starting position.
- C. +5.0 m. The center of mass moves at the plain average velocity, +1.5 m/s.
- D. −5.0 m. The center of mass is at the position of the heavier cart.

Check: At 2.0 s the carts are at −5 m and +19 m: x_cm = (5(−5) + 1(19))/6 = −1.0 m. Check: x_cm0 = 2 m and v_cm = (−15 + 6)/6 = −1.5 m/s.
Rationales: B: No net external force keeps the center of mass moving at constant velocity, not at rest. Its velocity is −1.5 m/s, so after 2.0 s it has moved 3.0 m. C: The plain average of −3 and +6 m/s ignores the masses. Weighting by mass gives v_cm = −1.5 m/s, directed the other way. D: Cart C is at −5.0 m at t = 2.0 s, but cart D is at +19 m. The center of mass lies between them, at −1.0 m.

**N-2.1-B-v3.** Two small carts ride on separate, parallel frictionless tracks. Cart E (1 kg) starts at x = −3 m and moves at +8 m/s. Cart F (3 kg) starts at x = +5 m and is at rest. At what x-coordinate is the center of mass of the system at t = 2.5 s?

- A. +3.0 m. The center of mass stays at its starting position.
- B. +13.0 m. The center of mass moves at the plain average velocity, +4 m/s.
- C. +5.0 m. The center of mass stays with the heavier cart, which is at rest.
- **D. +8.0 m**

Check: At 2.5 s the carts are at +17 m and +5 m: x_cm = (1·17 + 3·5)/4 = 8.0 m. Check: x_cm0 = 3 m, v_cm = 8/4 = +2 m/s, so 3 + 5 = 8 m.
Rationales: A: The center of mass keeps moving at constant velocity when no external force acts. Its velocity is +2 m/s, so after 2.5 s it is 5.0 m from where it began. B: Averaging 8 m/s and 0 without mass weights overstates the motion. Cart F has three times the mass of E, so v_cm is only +2 m/s. C: The center of mass is not tied to either cart. Cart E moves to +17 m, so the center of mass shifts toward it and sits at +8.0 m.

---

## Seed N-2.2-A (new) — Topic 2.2 Forces and Free-Body Diagrams
**Skill:** draw forces by their physical sources: a thrown object keeps no "force of the throw", and drag opposes the velocity.

A ball is thrown straight up and air resistance (drag) is not negligible. Consider (i) a moment shortly after release, while the ball moves upward quickly, and (ii) the instant at the top of its path, when its speed is momentarily zero. Which choice correctly lists the forces exerted on the ball at those two moments?

- A. (i) weight and drag, both directed downward; (ii) no forces, because the ball is momentarily at rest.
- B. (i) weight downward and an upward force from the throw; (ii) weight only.
- C. (i) weight downward and drag upward, because drag opposes the weight; (ii) weight only.
- **D. (i) weight and drag, both directed downward; (ii) weight only.**

Check: After release only gravity (down) and air drag act. Drag is opposite to the velocity, so it points down while the ball rises and is zero at the top where v = 0.
Rationales: A: Speed zero does not mean zero force. Gravity still acts at the top, which is why the ball turns around. B: Once the ball leaves the hand, no force from the throw remains. Only contact with the air (drag) and gravity act on it, and drag points down while the ball moves up. C: Drag opposes the velocity, not the weight. The ball moves up, so drag points down; drag points up only when the ball is falling.

**N-2.2-A-v1.** A rock is thrown straight down from a bridge, and air drag is not negligible. A moment after it leaves the hand, while it is falling quickly, which choice correctly lists the forces exerted on the rock?

- A. Weight directed downward, drag directed upward, and a downward force from the throw.
- B. Weight directed downward only, because drag acts only on rising objects.
- **C. Weight directed downward and drag directed upward.**
- D. Weight and drag, both directed downward, because the rock moves downward.

Check: After release only gravity and drag act. Gravity is downward and drag opposes the downward velocity, so it is upward.
Rationales: A: The throwing force acts only while the hand is in contact. After release the rock has no extra downward force; its speed comes from its earlier acceleration. B: Drag acts whenever an object moves through air, in either direction. It always opposes the velocity, so it points upward on a falling rock. D: Drag opposes the direction of motion rather than matching it. The rock moves down, so drag points up.

**N-2.2-A-v2.** A stone is thrown horizontally to the right off a cliff, and air drag is not negligible. At one instant the stone is moving to the right and downward. Which choice correctly describes the forces exerted on it at that instant?

- A. Weight straight down, drag directed to the left only, and a rightward force that keeps the stone moving.
- **B. Weight straight down, and drag directed up and to the left, opposite the velocity.**
- C. Weight directed down and to the right along the path, and drag directed up and to the left.
- D. Weight straight down, and drag directed straight up, because the stone is falling.

Check: Only gravity (straight down) and drag act. Drag is opposite the velocity, so with v pointing right and down, drag points left and up.
Rationales: A: No rightward force acts after release; the stone keeps its horizontal motion by inertia. Drag also opposes the full velocity, so it has an upward part too. C: Weight always points straight down, toward Earth's center, not along the path of motion. Only drag is tied to the direction of the velocity. D: Drag opposes the whole velocity, which has both a rightward and a downward part. Drag therefore points up and to the left, not straight up.

**N-2.2-A-v3.** A soccer ball has just been kicked and is rising while moving to the right through the air. Air drag is not negligible. Which choice correctly lists the forces exerted on the ball at that instant?

- **A. Weight straight down, and drag directed down and to the left, opposite the velocity.**
- B. Weight straight down, a force from the kick directed up and to the right, and drag directed down and to the left.
- C. Weight straight down and drag directed up and to the left, because drag opposes gravity.
- D. Weight straight down and drag directed horizontally to the left only.

Check: In flight only gravity and drag act. Velocity points up and right, so drag points down and left, while weight points straight down.
Rationales: B: The kick force acts only during the brief contact with the foot. In flight the only forces are gravity and air drag. C: Drag does not oppose the weight; it opposes the velocity. The ball moves up and right, so drag points down and to the left. D: Drag opposes the entire velocity vector, including its upward part. A rising ball therefore has a downward component of drag as well.

---

## Seed N-2.2-B (new) — Topic 2.2 Forces and Free-Body Diagrams
**Skill:** analyze a free-body diagram of a hanging object: balance horizontal and vertical components to find unequal cable tensions.

A 6.0 kg lamp hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes an angle of 37° with the ceiling and the right cable makes 53° with the ceiling. Use sin 37° = cos 53° = 0.60, cos 37° = sin 53° = 0.80 and g = 10 m/s². What are the tensions in the left and right cables?

- **A. Left 36 N; right 48 N.**
- B. Left 48 N; right 36 N, because the cable closer to horizontal pulls harder.
- C. 30 N each, because each cable supports half of the 60 N weight.
- D. 60 N each, because each cable must hold the whole weight.

Check: Horizontal: 0.80 T_L = 0.60 T_R. Vertical: 0.60 T_L + 0.80 T_R = 60. Solving gives T_L = 36 N and T_R = 48 N.
Rationales: B: The cable closer to the horizontal carries less tension here. The steeper cable supplies more of the vertical support and also needs the larger horizontal component to balance the other cable. C: Equal tensions are possible only if the cables make equal angles. Different angles require different tensions to balance horizontally and to support the weight. D: Each tension has a vertical component that adds with the other, so neither cable carries the full 60 N. The vertical components sum to 60 N.

**N-2.2-B-v1.** A 10 kg sign hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes 30° with the ceiling and the right cable makes 60° with the ceiling. Use g = 10 m/s². To the nearest newton, what are the tensions in the left and right cables?

- A. Left 87 N; right 50 N, because the flatter cable pulls harder.
- B. 50 N each, because each cable supports half of the weight.
- C. 100 N each, because each cable must hold the whole weight.
- **D. Left 50 N; right 87 N.**

Check: T_L cos 30° = T_R cos 60° and T_L sin 30° + T_R sin 60° = 100 N. Then T_L = 50 N and T_R = 86.6 N ≈ 87 N.
Rationales: A: The flatter cable has the larger horizontal share of its force, but the horizontal parts must be equal. Its tension is the smaller one; the steeper cable has the larger tension. B: The weight is shared as vertical components, which differ when the angles differ. Equal tensions would not balance horizontally. C: The vertical components of the two tensions add to the 100 N weight, so neither cable alone carries 100 N unless the other is slack.

**N-2.2-B-v2.** A 5.0 kg planter hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes 53° with the ceiling and the right cable makes 37° with the ceiling. Use sin 37° = cos 53° = 0.60, cos 37° = sin 53° = 0.80 and g = 10 m/s². What are the tensions in the left and right cables?

- A. Left 30 N; right 40 N, because the cable closer to horizontal pulls harder.
- B. 25 N each, because each cable supports half of the 50 N weight.
- **C. Left 40 N; right 30 N.**
- D. 50 N each, because each cable must hold the whole weight.

Check: Horizontal: 0.60 T_L = 0.80 T_R. Vertical: 0.80 T_L + 0.60 T_R = 50. Solving gives T_L = 40 N and T_R = 30 N.
Rationales: A: The cable closer to the horizontal is the right cable and it carries the smaller tension. The steeper left cable carries more. B: Different cable angles give different vertical components. Equal tensions of 25 N would not even balance horizontally at 53° and 37°. D: Both cables share the load through their vertical components, so each tension is less than or comparable to the weight depending on the angle, and they are not both 50 N.

**N-2.2-B-v3.** A 4.0 kg lantern hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes 60° with the ceiling and the right cable makes 30° with the ceiling. Use g = 10 m/s². To the nearest newton, what are the tensions in the left and right cables?

- A. Left 20 N; right 35 N, because the cable closer to horizontal pulls harder.
- **B. Left 35 N; right 20 N.**
- C. 20 N each, because each cable supports half of the 40 N weight.
- D. 40 N each, because each cable must hold the whole weight.

Check: T_L cos 60° = T_R cos 30° and T_L sin 60° + T_R sin 30° = 40 N. Then T_L = 34.6 N ≈ 35 N and T_R = 20 N.
Rationales: A: The right cable is closer to horizontal and has the smaller tension. The steeper left cable carries the larger tension. C: Splitting the weight in half assumes equal angles. With 60° and 30° the tensions must differ to balance horizontally. D: The vertical components of the tensions add to the 40 N weight. Each cable carries only part of it.

---

## Seed N-2.3-A (new) — Topic 2.3 Newton's Third Law
**Skill:** combine Newton's second and third laws: the contact force between two pushed blocks is found from the acceleration of the block being pushed.

Two blocks touch on a frictionless horizontal table. A horizontal 12 N force pushes on the 1.0 kg block, which pushes against the 3.0 kg block, and the blocks accelerate together. What is the magnitude of the force that the 3.0 kg block exerts on the 1.0 kg block?

- A. 12 N, because the push is transmitted undiminished through the blocks.
- **B. 9 N**
- C. 3 N, because that is the net force on the 1.0 kg block.
- D. 6 N, because the push is shared equally between the two blocks.

Check: a = 12/(1.0 + 3.0) = 3.0 m/s². The 1.0 kg block pushes the 3.0 kg block with 3.0 × 3.0 = 9 N, and by the third law the 3.0 kg block pushes back with 9 N. Check: 12 − 9 = 1.0 × 3.0.
Rationales: A: Only part of the push goes into accelerating the 1.0 kg block itself. The rest, 9 N, is passed on, so the contact force is less than 12 N. C: The 3 N is the net force on the 1.0 kg block (12 N minus the contact force). The contact force itself is the 9 N needed to accelerate the 3.0 kg block. D: The push is shared in proportion to mass, not equally. The 3.0 kg block needs three times the force of the 1.0 kg block.

**N-2.3-A-v1.** Two blocks touch on a frictionless horizontal table. A horizontal 20 N force pushes on the 4.0 kg block, which pushes against a 1.0 kg block, and the blocks accelerate together. What is the magnitude of the force that the 1.0 kg block exerts on the 4.0 kg block?

- **A. 4 N**
- B. 20 N, because the push is transmitted undiminished through the blocks.
- C. 16 N, because that is the net force on the 4.0 kg block.
- D. 10 N, because the push is shared equally between the two blocks.

Check: a = 20/5.0 = 4.0 m/s². The 4.0 kg block pushes the 1.0 kg block with 1.0 × 4.0 = 4 N, and the third law gives 4 N back on the 4.0 kg block. Check: 20 − 4 = 4.0 × 4.0.
Rationales: B: Only the part needed to accelerate the 1.0 kg block is passed on. The 4.0 kg block itself needs most of the 20 N. C: The 16 N is the net force on the 4.0 kg block, which is the push minus the contact force. The contact force by the 1.0 kg block is only 4 N. D: Equal sharing ignores that forces divide in proportion to mass. The 1.0 kg block needs only one fifth of the total.

**N-2.3-A-v2.** Two blocks touch on a frictionless horizontal table. A horizontal 30 N force pushes on the 2.0 kg block, which pushes against a 3.0 kg block, and the blocks accelerate together. What is the magnitude of the force that the 3.0 kg block exerts on the 2.0 kg block?

- A. 30 N, because the push is transmitted undiminished through the blocks.
- B. 12 N, because that is the net force on the 2.0 kg block.
- C. 15 N, because the push is shared equally between the two blocks.
- **D. 18 N**

Check: a = 30/5.0 = 6.0 m/s². The 2.0 kg block pushes the 3.0 kg block with 3.0 × 6.0 = 18 N, so the 3.0 kg block pushes back with 18 N. Check: 30 − 18 = 2.0 × 6.0.
Rationales: A: Part of the push accelerates the 2.0 kg block itself, so less than 30 N reaches the other block. B: The 12 N is the net force on the 2.0 kg block (30 N minus the contact force). The contact force is 18 N. C: The share is proportional to mass, not equal. The 3.0 kg block takes 3/5 of the push, which is 18 N.

**N-2.3-A-v3.** Two blocks touch on a frictionless horizontal table. A horizontal 15 N force pushes on the 5.0 kg block, which pushes against a 10 kg block, and the blocks accelerate together. What is the magnitude of the force that the 5.0 kg block exerts on the 10 kg block?

- A. 15 N, because the push is transmitted undiminished through the blocks.
- B. 5 N, because that is the net force on the 5.0 kg block.
- **C. 10 N**
- D. 7.5 N, because the push is shared equally between the two blocks.

Check: a = 15/15 = 1.0 m/s². The 5.0 kg block pushes the 10 kg block with 10 × 1.0 = 10 N, and the third law gives the same 10 N back. Check: 15 − 10 = 5.0 × 1.0.
Rationales: A: The 5.0 kg block uses part of the push itself, so the force it passes on is smaller than 15 N. B: The 5 N is the net force on the 5.0 kg block (15 N minus the contact force). The contact force on the 10 kg block is 10 N. D: Equal halves ignore the different masses. The 10 kg block needs twice the force the 5.0 kg block needs.

---

## Seed N-2.3-B (new) — Topic 2.3 Newton's Third Law
**Skill:** keep third-law pairs distinct from balanced forces: contact forces stay equal and opposite even when the surface and object accelerate.

A 5.0 kg box rests on the floor of an elevator that is accelerating upward at 2.0 m/s². Which statement about the forces between the box and the floor is correct?

- A. The floor pushes up on the box with 60 N, and the box pushes down on the floor with 50 N, its weight.
- B. The floor's 60 N push and the box's 50 N weight form a third-law pair, and they are unequal because the box accelerates.
- **C. The floor pushes up on the box with 60 N, and the box pushes down on the floor with 60 N.**
- D. Both forces are 50 N, because acceleration does not change the contact force.

Check: Newton's second law: N − mg = ma gives N = 5.0(10 + 2.0) = 60 N. The third law makes the box's downward push on the floor 60 N as well; the weight is 50 N.
Rationales: A: The box's push on the floor is the third-law partner of the floor's push on the box, so it is 60 N. The 50 N weight is a different force, exerted by Earth. B: Third-law pairs always involve two objects acting on each other and are always equal. Weight and the normal force act on the same object and are not a pair. D: The floor must supply the net upward force: N − 50 = 5.0 × 2.0 gives 60 N. The contact force changes with acceleration.

**N-2.3-B-v1.** A 4.0 kg box rests on the floor of an elevator that is accelerating downward at 3.0 m/s². Which statement about the forces between the box and the floor is correct?

- A. The floor pushes up on the box with 28 N, and the box pushes down on the floor with 40 N, its weight.
- **B. The floor pushes up on the box with 28 N, and the box pushes down on the floor with 28 N.**
- C. The floor's 28 N push and the box's 40 N weight form a third-law pair, and they are unequal because the box accelerates.
- D. Both forces are 40 N, because the floor always supports the full weight.

Check: N − mg = ma with a = −3.0 m/s² gives N = 4.0(10 − 3.0) = 28 N. The third law gives the same 28 N downward on the floor; the weight is 40 N.
Rationales: A: The reaction to the floor's push is the box's push on the floor, which equals 28 N. The weight is a separate force from Earth. C: Weight and the normal force act on one object, so they cannot be a third-law pair. Third-law partners are equal even when accelerating. D: The normal force equals the weight only when there is no vertical acceleration. Here N = 4.0(10 − 3.0) = 28 N.

**N-2.3-B-v2.** A 60 kg person stands on a bathroom scale in an elevator that is moving upward but slowing down at 2.0 m/s². Which statement about the forces between the person and the scale is correct?

- **A. The scale pushes up on the person with 480 N, and the person pushes down on the scale with 480 N.**
- B. The scale pushes up on the person with 480 N, and the person pushes down on the scale with 600 N, the person's weight.
- C. The scale and the person exert 600 N on each other, because the elevator is still moving upward.
- D. The scale's 480 N force and the person's 600 N weight are a third-law pair, unequal because the elevator is slowing.

Check: Taking up as positive, a = −2.0 m/s²: N − 600 = 60(−2.0) gives N = 480 N. By the third law the person pushes down on the scale with 480 N.
Rationales: B: The person's push on the scale is the partner of the scale's push on the person, so it is also 480 N. The 600 N weight is a force from Earth. C: Upward motion does not set the contact force; acceleration does. The elevator's acceleration is downward, so the scale reads less than 600 N. D: These two forces act on the same object, the person, so they cannot be a third-law pair. The actual pair is the two contact forces of 480 N.

**N-2.3-B-v3.** An 8.0 kg instrument rests on the floor of a rocket that is accelerating straight upward at 5.0 m/s². Which statement about the forces between the instrument and the floor is correct?

- A. The floor pushes up with 120 N, and the instrument pushes down on the floor with 80 N, its weight.
- B. Both forces are 80 N, because the instrument's weight does not depend on the rocket's motion.
- C. The floor's 120 N push and the 80 N weight are a third-law pair, unequal because of the rocket's acceleration.
- **D. The floor pushes up on the instrument with 120 N, and the instrument pushes down on the floor with 120 N.**

Check: N − mg = ma gives N = 8.0(10 + 5.0) = 120 N. The third law gives 120 N downward on the floor, while the weight is 80 N.
Rationales: A: The downward push on the floor is the third-law partner of the upward 120 N force, so it is 120 N. The 80 N weight is exerted by Earth. B: The contact force depends on the acceleration, not only on weight. N − 80 = 8.0 × 5.0 gives N = 120 N. C: A third-law pair always has equal magnitudes and acts on two different objects. Weight and the floor's push both act on the instrument.

---

## Seed N-2.4-A (new) — Topic 2.4 Newton's First Law
**Skill:** use constant velocity (net force zero) to find an unknown force by vector balance, not by assuming constant velocity needs a force.

A puck moves at a constant velocity of 3 m/s toward the east on frictionless ice while exactly three horizontal forces act on it. One force is 6 N toward the east and another is 8 N toward the north. What is the third force?

- A. 10 N, directed toward the north and east.
- B. 14 N, directed toward the south and west.
- C. 2 N, directed toward the south.
- **D. 10 N, directed toward the south and west.**

Check: Constant velocity means a net force of zero. The first two forces give √(6² + 8²) = 10 N toward 53° north of east, so the third is 10 N toward 53° south of west.
Rationales: A: This points the same way as the sum of the first two forces and would add to the net force instead of cancelling it. The third force must be opposite to that sum. B: Forces at right angles combine by the Pythagorean theorem, not by adding magnitudes. The resultant of 6 N and 8 N is 10 N, so the third force is 10 N. C: This subtracts 6 N from 8 N, which treats perpendicular forces as if they were along one line. Perpendicular forces cannot cancel each other.

**N-2.4-A-v1.** A sled slides at constant velocity across a level frozen lake while exactly three horizontal forces act on it. One force is 5 N toward the west and another is 12 N toward the south. What is the third force?

- A. 13 N, directed toward the south and west.
- B. 17 N, directed toward the north and east.
- **C. 13 N, directed toward the north and east.**
- D. 7 N, directed toward the north.

Check: Net force is zero. The first two forces give √(5² + 12²) = 13 N toward south-west, so the third force is 13 N toward north-east.
Rationales: A: This is the direction of the sum of the first two forces, which would add to the net force. The third force must point the opposite way. B: Perpendicular forces combine by the Pythagorean theorem, not by adding magnitudes. The resultant of 5 N and 12 N is 13 N. D: Subtracting 5 from 12 treats perpendicular forces as collinear. They cannot cancel one another, so a force at an angle is needed.

**N-2.4-A-v2.** A 2.0 kg drone flies at constant velocity. The only forces on it are its weight, a horizontal wind force of 15 N directed toward the west, and the thrust from its rotors. What is the thrust?

- A. 20 N, directed straight up, because the thrust only needs to cancel the weight.
- **B. 25 N, directed upward and toward the east.**
- C. 35 N, directed upward and toward the east.
- D. 25 N, directed upward and toward the west.

Check: Net force zero: thrust vertical component = weight = 20 N and horizontal component = 15 N toward the east. Magnitude √(20² + 15²) = 25 N.
Rationales: A: The wind force of 15 N also needs cancelling, and straight-up thrust cannot do that. The thrust needs an eastward component. C: Perpendicular components of 20 N and 15 N combine as √(20² + 15²) = 25 N, not by adding magnitudes. D: A westward component would add to the westward wind force. The thrust must have an eastward component of 15 N.

**N-2.4-A-v3.** A barge moves at constant velocity on a still canal. Tug 1 pulls with 300 N toward the north and tug 2 pulls with 400 N toward the east. These tugs and the water drag are the only horizontal forces. What is the drag force from the water?

- **A. 500 N, directed toward the south and west.**
- B. 500 N, directed toward the north and east.
- C. 700 N, directed toward the south and west.
- D. 100 N, directed toward the east.

Check: Net force zero: the tugs combine to √(300² + 400²) = 500 N toward 37° east of north, so the water drag is 500 N toward the opposite direction (south-west).
Rationales: B: The drag must oppose the sum of the tug forces. Pointing the same way as the sum would accelerate the barge. C: Perpendicular forces combine as √(300² + 400²) = 500 N, not by adding magnitudes. D: This subtracts 300 from 400 as if the tugs pulled along one line. The tugs pull at right angles to each other.

---

## Seed N-2.4-B (new) — Topic 2.4 Newton's First Law
**Skill:** link motion to the net force: constant velocity means balanced forces in any direction, and speeding up or slowing down changes the tension from the weight.

An 800 kg elevator car is lifted by a cable. It starts from rest at the bottom and speeds up for 3 s, then rises at a constant 4 m/s for 5 s, then slows to rest during the last 3 s. How does the cable tension T compare with the car's weight W in the three intervals, in order?

- **A. T > W, then T = W, then T < W.**
- B. T > W in all three intervals, because the car moves upward the whole time.
- C. T > W, then T > W, then T < W, because a force larger than the weight is needed to keep moving upward.
- D. T > W, then T = W, then T > W, because the car is moving upward at the end.

Check: Upward acceleration needs T > W; constant velocity needs T = W; slowing while moving up means a downward acceleration, so T < W.
Rationales: B: Upward motion does not require a net upward force. At constant velocity the net force is zero, so T = W, and while slowing T is less than W. C: This is the idea that force is needed to maintain motion. At constant velocity the forces balance and T equals W. D: While slowing the acceleration is downward, so the net force is downward and T is less than W. The direction of motion does not set the sign of the net force.

**N-2.4-B-v1.** A 900 kg mine cage is lowered on a cable. It starts from rest and speeds up downward for 4 s, then descends at a constant 3 m/s for 6 s, then slows to rest during the last 4 s. How does the cable tension T compare with the cage's weight W in the three intervals, in order?

- A. T < W in all three intervals, because the cage moves downward the whole time.
- B. T < W, then T < W, then T > W, because gravity must pull the cage along to keep it descending.
- C. T > W, then T = W, then T < W, because the tension is larger when the motion starts.
- **D. T < W, then T = W, then T > W.**

Check: Speeding up downward: net force down, T < W. Constant velocity: T = W. Slowing while moving down: acceleration up, so T > W.
Rationales: A: Downward motion alone does not make T less than W. At constant velocity the net force is zero, so T = W, and while slowing T must exceed W. B: Constant velocity requires zero net force, so no extra net downward force is needed. T equals W in that interval. C: Speeding up downward means a downward acceleration, so T must be less than W at the start. The order of the first and last intervals is reversed here.

**N-2.4-B-v2.** A 60 kg person stands on a scale in an elevator that rises. It speeds up at 1.5 m/s², then moves at constant speed, then slows at 1.5 m/s² as it stops. Use g = 10 m/s². What does the scale read in the three intervals, in order?

- A. 690 N, then 690 N, then 510 N, because the scale reads more whenever the elevator moves upward.
- B. 600 N, then 600 N, then 600 N, because the person's weight does not change.
- **C. 690 N, then 600 N, then 510 N.**
- D. 690 N, then 600 N, then 690 N, because the elevator is moving upward at the end.

Check: N = m(g + a): 60(11.5) = 690 N while speeding up, 600 N at constant speed, and 60(8.5) = 510 N while slowing with a downward acceleration.
Rationales: A: At constant velocity the net force is zero, so the scale reads the weight, 600 N. Motion alone does not change the reading. B: The weight stays 600 N, but the scale reading is the normal force, which changes with acceleration. D: While slowing, the acceleration is downward: N = 60(10 − 1.5) = 510 N, less than the weight.

**N-2.4-B-v3.** A 5.0 kg block hangs from a spring scale that is lowered. The block speeds up downward at 2.0 m/s², then moves down at constant speed, then slows at 2.0 m/s² until it stops. Use g = 10 m/s². What does the scale read in the three intervals, in order?

- A. 40 N, then 40 N, then 60 N, because the scale reads less whenever the block moves down.
- **B. 40 N, then 50 N, then 60 N.**
- C. 50 N, then 50 N, then 50 N, because the block's weight does not change.
- D. 60 N, then 50 N, then 40 N, because the first interval has the largest force.

Check: T = m(g + a) with a = −2.0 m/s² gives 5.0(8.0) = 40 N while speeding up downward, 50 N at constant speed, and 5.0(12) = 60 N while slowing.
Rationales: A: At constant velocity the forces balance and the scale reads the weight, 50 N. Downward motion alone does not reduce the reading. C: The scale reads the tension, which changes with acceleration. It is 50 N only at constant speed. D: The block accelerates downward at first, so the tension is less than the weight. The order of the first and last intervals is reversed here.

---

## Seed N-2.5-A (new) — Topic 2.5 Newton's Second Law
**Skill:** apply Newton's second law separately to connected objects to find the tension, which is not simply the weight of the hanging mass.

A 3.0 kg block rests on a frictionless horizontal table. A light string runs from it over a light, frictionless pulley at the table's edge to a 2.0 kg block that hangs vertically. The system is released from rest. What is the tension in the string while the blocks move?

- A. 20 N, the weight of the hanging block.
- **B. 12 N**
- C. 8 N, the hanging block's mass times the system's acceleration.
- D. 30 N, the weight of the block on the table.

Check: a = 20/(3.0 + 2.0) = 4.0 m/s². Table block: T = 3.0 × 4.0 = 12 N. Check: 20 − T = 2.0 × 4.0, so T = 12 N.
Rationales: A: The hanging block accelerates downward, so the tension must be less than its weight. The tension equals the weight only if the block is at rest or at constant velocity. C: The net force on the hanging block is its weight minus the tension, and that equals m·a = 8 N. The tension itself is 20 − 8 = 12 N. D: The table block's weight is balanced by the normal force and does not pull the string. Only the horizontal tension affects its motion.

**N-2.5-A-v1.** A 4.0 kg block rests on a horizontal table with a kinetic friction coefficient of 0.25. A light string runs from it over a light, frictionless pulley at the table's edge to a 6.0 kg block that hangs vertically. The system is released from rest and the blocks move. What is the tension in the string?

- **A. 30 N**
- B. 60 N, the weight of the hanging block.
- C. 20 N, the table block's mass times the acceleration.
- D. 50 N, the net force on the whole system.

Check: a = (60 − 10)/(4.0 + 6.0) = 5.0 m/s². Hanging block: 60 − T = 6.0 × 5.0, so T = 30 N. Check: T − 10 = 4.0 × 5.0 gives T = 30 N.
Rationales: B: The hanging block accelerates downward, so the tension is less than its weight. C: The net force on the table block is T − friction = 20 N, so T is 20 N plus the 10 N friction force. D: The system's net force is 60 − 10 = 50 N, but that is not the tension. The tension acts only between the two blocks and is found from one block's equation.

**N-2.5-A-v2.** A 2.0 kg block and a 6.0 kg block hang from opposite ends of a light string that passes over a light, frictionless pulley. The system is released from rest. What is the tension in the string while the blocks move?

- A. 20 N, the weight of the lighter block.
- B. 60 N, the weight of the heavier block.
- C. 40 N, the net force on the system.
- **D. 30 N**

Check: a = (60 − 20)/8.0 = 5.0 m/s². Lighter block: T − 20 = 2.0 × 5.0, so T = 30 N. Heavier block: 60 − 30 = 6.0 × 5.0.
Rationales: A: The lighter block accelerates upward, so the tension must exceed its weight. B: The heavier block accelerates downward, so the tension must be less than its weight. C: The 40 N is the weight difference, which drives the system. The tension is found from one block's equation of motion.

**N-2.5-A-v3.** A 4.0 kg block sits on a frictionless incline that makes 30° with the horizontal. A light string runs from it up the incline and over a light, frictionless pulley at the top to a 1.0 kg block that hangs vertically. The system is released from rest and the blocks move. What is the tension in the string?

- A. 10 N, the weight of the hanging block.
- B. 20 N, the component of the 4.0 kg block's weight along the incline.
- **C. 12 N**
- D. 8 N, the tension found by assuming the hanging block accelerates downward.

Check: Down-slope pull is 4.0 × 10 × 0.50 = 20 N, which beats 10 N, so a = (20 − 10)/5.0 = 2.0 m/s². Hanging block rises: T − 10 = 1.0 × 2.0 gives T = 12 N.
Rationales: A: The hanging block accelerates upward, so the tension is larger than its weight. B: The 20 N pulls the block down the slope, but the string tension is less than that because the block accelerates down the slope. D: The component along the incline is 20 N, greater than the 10 N hanging weight, so the hanging block goes up and T = 10 + 1.0 × 2.0 = 12 N, not 8 N.

---

## Seed N-2.5-B (new) — Topic 2.5 Newton's Second Law
**Skill:** compare accelerations in opposite directions of travel when a resistive force reverses direction with the velocity.

A 0.50 kg ball is thrown straight up. At every instant of motion the air exerts a drag force of constant magnitude 1.0 N opposite the ball's velocity. Use g = 10 m/s². What are the magnitude and direction of the ball's acceleration while it rises and while it falls?

- A. 10 m/s² downward in both cases, because every object in flight accelerates at g.
- B. 8.0 m/s² downward while rising; 12 m/s² downward while falling.
- **C. 12 m/s² downward while rising; 8.0 m/s² downward while falling.**
- D. 8.0 m/s² downward in both cases, because drag reduces the net downward force.

Check: Rising: net force = 5.0 + 1.0 = 6.0 N down, a = 12 m/s². Falling: net force = 5.0 − 1.0 = 4.0 N down, a = 8.0 m/s².
Rationales: A: The acceleration is g only if gravity is the only force. Drag adds to gravity on the way up and subtracts on the way down. B: This swaps the two cases. Drag points down on the way up, adding to the weight, so the rising acceleration is the larger one. D: Drag reduces the downward force only on the way down. On the way up it points down, adding to the weight.

**N-2.5-B-v1.** A 2.0 kg block slides up a rough incline of 37° with a kinetic friction coefficient of 0.50, momentarily stops and then slides back down. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What are the block's accelerations while sliding up and while sliding down?

- A. 6.0 m/s² down the incline in both directions, because friction does not change the acceleration.
- **B. 10 m/s² down the incline while sliding up; 2.0 m/s² down the incline while sliding down.**
- C. 2.0 m/s² down the incline while sliding up; 10 m/s² down the incline while sliding down.
- D. 10 m/s² down the incline in both directions, because friction always opposes gravity's pull.

Check: Sliding up: a = g sin θ + μ g cos θ = 6.0 + 4.0 = 10 m/s². Sliding down: a = 6.0 − 4.0 = 2.0 m/s². Both are directed down the incline.
Rationales: A: Friction changes the net force along the incline. It adds to the pull of gravity going up and subtracts from it going down. C: This swaps the cases. Friction acts down the slope when the block moves up, so the sliding-up acceleration is larger. D: Friction opposes the motion, not gravity. When the block moves down, friction points up the slope and reduces the net force.

**N-2.5-B-v2.** A 4.0 kg ball is tossed straight up. At every instant of motion the air exerts a drag force of constant magnitude 6.0 N opposite the ball's velocity. Use g = 10 m/s². What are the magnitude and direction of the ball's acceleration while it rises and while it falls?

- **A. 11.5 m/s² downward while rising; 8.5 m/s² downward while falling.**
- B. 10 m/s² downward in both cases, because every object in flight accelerates at g.
- C. 8.5 m/s² downward while rising; 11.5 m/s² downward while falling.
- D. 8.5 m/s² downward in both cases, because drag is upward.

Check: Rising: (40 + 6.0)/4.0 = 11.5 m/s² down. Falling: (40 − 6.0)/4.0 = 8.5 m/s² down.
Rationales: B: Gravity alone gives 10 m/s² only when there is no drag. Here drag adds to the net force on the way up and reduces it on the way down. C: This swaps the two cases. Drag points downward while the ball rises, so the net force is larger on the way up. D: Drag points opposite the velocity, so it is upward only while the ball falls. On the way up it points down and adds to the weight.

**N-2.5-B-v3.** A 0.20 kg stone is thrown straight up. At every instant of motion the air exerts a drag force of constant magnitude 0.50 N opposite the stone's velocity. Use g = 10 m/s². What are the magnitude and direction of the stone's acceleration while it rises and while it falls?

- A. 10 m/s² downward in both cases, because every object in flight accelerates at g.
- B. 7.5 m/s² downward while rising; 12.5 m/s² downward while falling.
- C. 7.5 m/s² downward in both cases, because drag subtracts from the weight.
- **D. 12.5 m/s² downward while rising; 7.5 m/s² downward while falling.**

Check: Rising: (2.0 + 0.50)/0.20 = 12.5 m/s² down. Falling: (2.0 − 0.50)/0.20 = 7.5 m/s² down.
Rationales: A: The acceleration equals g only without drag. Here drag changes the net force differently on the way up and on the way down. B: This swaps the two cases. On the way up drag points down and adds to the weight, so the acceleration is greater. C: Drag subtracts from the weight only when the stone falls. While rising, drag is directed downward and adds to the weight.

---

## Seed N-2.6-A (new) — Topic 2.6 Gravitational Force
**Skill:** find where the net gravitational force from two masses cancels, using the inverse-square dependence rather than a simple ratio of masses.

A small probe lies on the straight line between two large fixed bodies of masses M and 4M whose centers are a distance d apart. At the probe's position the net gravitational force from the two bodies is zero. How far is the probe from the body of mass M?

- A. d/2, because the forces from the two bodies must be equal at the midpoint.
- B. d/5, because the distances must be in the ratio of the masses, 1 to 4.
- C. 2d/3, because the probe must be nearer the heavier body.
- **D. d/3**

Check: Set M/x² = 4M/(d − x)². Then (d − x) = 2x, so x = d/3 from the smaller mass.
Rationales: A: The forces are equal only at the point where G·M/x² = G·4M/(d − x)². At the midpoint the heavier body pulls four times as hard. B: This treats the force as inversely proportional to distance. The force varies as 1/r², so the distances are in the ratio 1 to 2. C: The probe must be nearer the lighter body, since the heavier body pulls more strongly at equal distances. The 2d/3 is the distance from the heavier body.

**N-2.6-A-v1.** A small probe lies on the straight line between two large fixed bodies of masses M and 9M whose centers are a distance d apart. At the probe's position the net gravitational force from the two bodies is zero. How far is the probe from the body of mass M?

- A. d/2, because the forces from the two bodies must be equal at the midpoint.
- B. d/10, because the distances must be in the ratio of the masses, 1 to 9.
- **C. d/4**
- D. 3d/4, because the probe must be nearer the heavier body.

Check: Set M/x² = 9M/(d − x)². Then (d − x) = 3x, so x = d/4 from the smaller mass.
Rationales: A: At the midpoint the heavier body pulls nine times as hard, so the forces do not cancel there. B: The force falls off as 1/r², so the distances are in the ratio of the square roots of the masses, 1 to 3. D: The probe must be nearer the lighter body to compensate for its smaller mass. The 3d/4 is its distance from the heavier body.

**N-2.6-A-v2.** A small probe lies on the straight line between two large fixed bodies of masses 16M and M whose centers are a distance d apart. At the probe's position the net gravitational force from the two bodies is zero. How far is the probe from the smaller body, of mass M?

- A. d/2, because the forces from the two bodies must be equal at the midpoint.
- **B. d/5**
- C. d/17, because the distances must be in the ratio of the masses, 1 to 16.
- D. 4d/5, because the probe must be nearer the heavier body.

Check: Set M/x² = 16M/(d − x)². Then (d − x) = 4x, so x = d/5 from the smaller mass.
Rationales: A: At the midpoint the heavier body pulls sixteen times as hard, so there is no cancellation. C: The force varies as 1/r², so the distances are in the ratio of the square roots of the masses, 1 to 4, not 1 to 16. D: The probe must sit nearer the lighter body. The 4d/5 is its distance from the heavier body, not from the smaller one.

**N-2.6-A-v3.** A small probe lies on the straight line between two large fixed bodies of masses 4M and 9M whose centers are a distance d apart. At the probe's position the net gravitational force from the two bodies is zero. How far is the probe from the body of mass 4M?

- **A. 2d/5**
- B. d/2, because the forces from the two bodies must be equal at the midpoint.
- C. 4d/13, because the distances must be in the ratio of the masses, 4 to 9.
- D. 3d/5, because the probe must be nearer the heavier body.

Check: Set 4M/x² = 9M/(d − x)². Then (d − x)/x = 3/2, so x = 2d/5 from the 4M body.
Rationales: B: At the midpoint the 9M body pulls more strongly, so the net force is not zero there. C: The force falls as 1/r², so the distances are in the ratio of the square roots of the masses, 2 to 3, not 4 to 9. D: The probe must be nearer the lighter body. The 3d/5 is the probe's distance from the heavier body.

---

## Seed N-2.6-B (new) — Topic 2.6 Gravitational Force
**Skill:** compare gravitational forces and accelerations of two bodies: equal forces give accelerations inversely proportional to mass.

Two isolated spheres, of mass 2.0 kg and 8.0 kg, are released from rest in deep space with their centers 1.0 m apart. No other bodies act on them. Which statement about their gravitational forces and initial accelerations is correct?

- **A. The forces are equal in magnitude, and the 2.0 kg sphere has an acceleration four times as large as the 8.0 kg sphere.**
- B. The force on the 8.0 kg sphere is four times greater, so it accelerates four times as fast.
- C. The forces are equal, so both spheres have equal accelerations.
- D. The force on the 8.0 kg sphere is four times greater, but the accelerations are equal because all objects fall with the same acceleration.

Check: Third law: the forces are equal, F = Gm₁m₂/r². a = F/m gives a₂ : a₈ = 8.0 : 2.0 = 4 : 1.
Rationales: B: The two gravitational forces are a third-law pair and are equal. A larger mass with the same force has a smaller acceleration. C: Equal forces give equal accelerations only for equal masses. With a = F/m the 2.0 kg sphere accelerates four times as much. D: The same-acceleration result holds near a planet's surface, where g does not depend on the falling mass. It does not hold for two comparable masses attracting each other.

**N-2.6-B-v1.** Two isolated spheres, of mass 1.0 kg and 9.0 kg, are released from rest in deep space a short distance apart. No other bodies act on them. Which statement about their gravitational forces and initial accelerations is correct?

- A. The force on the 9.0 kg sphere is nine times greater, so it accelerates nine times as fast.
- B. The forces are equal, so both spheres accelerate equally.
- C. The force on the 9.0 kg sphere is nine times greater, but both spheres accelerate equally.
- **D. The forces are equal in magnitude, and the 1.0 kg sphere accelerates nine times as much as the 9.0 kg sphere.**

Check: Third law: the forces are equal. a = F/m, so a₁ : a₉ = 9.0 : 1.0.
Rationales: A: The attraction is mutual and the two forces are equal. The heavier sphere accelerates less. B: Equal forces on unequal masses give unequal accelerations, since a = F/m. C: The equal-acceleration idea belongs to free fall near a planet, where the planet's mass is huge. For two comparable masses the lighter one accelerates much more.

**N-2.6-B-v2.** Two isolated asteroids have masses 6.0 × 10⁶ kg and 2.0 × 10⁶ kg and start at rest a fixed distance apart, far from everything else. Which statement about their gravitational forces and initial accelerations is correct?

- A. The larger asteroid feels the larger force and so has the larger acceleration.
- B. The forces are equal and the accelerations are equal.
- **C. The forces are equal in magnitude, and the smaller asteroid accelerates three times as much as the larger one.**
- D. The smaller asteroid feels the larger force, three times as much, so it accelerates three times as much.

Check: The forces are a third-law pair and equal. a = F/m, so a_small/a_large = 6.0/2.0 = 3.
Rationales: A: The forces are equal because they are a third-law pair. The larger mass makes the same force produce a smaller acceleration. B: With equal forces the accelerations are inversely proportional to the masses, so they differ by a factor of three. D: Gravitational attraction is mutual and equal in magnitude; the smaller body does not feel a larger force. Its larger acceleration comes from its smaller mass.

**N-2.6-B-v3.** A planet has 50 times the mass of its small moon. Ignoring all other bodies, which statement about the gravitational forces between them and their accelerations is correct?

- A. The force on the planet is 50 times greater, so the planet accelerates 50 times as much.
- **B. The forces are equal in magnitude, and the moon's acceleration is 50 times the planet's acceleration.**
- C. The forces are equal, so the planet and moon accelerate equally.
- D. The force on the planet is 50 times greater, yet both accelerate equally, as in free fall.

Check: The gravitational forces form a third-law pair, so they are equal. a = F/m gives a_moon/a_planet = 50.
Rationales: A: The two forces are equal and opposite. The planet's much larger mass gives it a much smaller acceleration. C: Equal forces on very different masses give very different accelerations, in the inverse ratio of the masses. D: Free-fall equality applies to small objects near a planet. Here the two forces are equal, and the moon's far smaller mass gives it the far larger acceleration.

---

## Seed N-2.7-A (new) — Topic 2.7 Kinetic and Static Friction
**Skill:** find kinetic friction when the applied force has a vertical component that changes the normal force.

A 10 kg crate is pulled across a level floor by a rope that exerts a 50 N force directed 37° above the horizontal. The kinetic friction coefficient is 0.40, and the crate is already sliding. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What is the crate's acceleration?

- A. 0 m/s², because friction equals 0.40 × 100 N = 40 N, which balances the horizontal pull.
- **B. 1.2 m/s²**
- C. 2.2 m/s², because the horizontal force is the full 50 N.
- D. 0.6 m/s², because the horizontal pull is 30 N and the normal force is 60 N.

Check: N = 100 − 50(0.60) = 70 N, f = 0.40 × 70 = 28 N, and F_x = 50(0.80) = 40 N. a = (40 − 28)/10 = 1.2 m/s².
Rationales: A: This takes the normal force as the full weight. The rope's upward component of 30 N reduces the normal force to 70 N, so friction is only 28 N. C: Only the horizontal component of the rope force, 40 N, drives the crate forward. Using 50 N overstates the net force. D: This swaps sine and cosine. The horizontal component is 50 cos 37° = 40 N and the vertical is 30 N, giving N = 70 N.

**N-2.7-A-v1.** A 20 kg crate is pushed across a level floor by a force of 100 N directed 37° below the horizontal. The kinetic friction coefficient is 0.20, and the crate is already sliding. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What is the crate's acceleration?

- **A. 1.4 m/s²**
- B. 2.0 m/s², because friction is 0.20 × 200 N = 40 N.
- C. 2.6 m/s², because the push reduces the normal force and so reduces friction.
- D. 2.4 m/s², because the horizontal force is the full 100 N.

Check: N = 200 + 100(0.60) = 260 N, f = 0.20 × 260 = 52 N, F_x = 80 N. a = (80 − 52)/20 = 1.4 m/s².
Rationales: B: The downward component of the push, 60 N, increases the normal force to 260 N. Friction is then 52 N. C: A push directed downward adds to the normal force rather than reducing it. The 60 N downward component raises N to 260 N. D: Only the horizontal component, 80 N, drives the crate along the floor. Using 100 N overstates the net force.

**N-2.7-A-v2.** A 40 kg sled is pulled across level ice-covered ground by a rope with 200 N force directed 37° above the horizontal. The kinetic friction coefficient is 0.25, and the sled is already sliding. Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s². What is the sled's acceleration?

- A. 1.5 m/s², because friction is 0.25 × 400 N = 100 N.
- B. 3.25 m/s², because the horizontal force is the full 200 N.
- C. 0.75 m/s², because the rope's vertical component adds to the normal force.
- **D. 2.25 m/s²**

Check: N = 400 − 200(0.60) = 280 N, f = 0.25 × 280 = 70 N, F_x = 160 N. a = (160 − 70)/40 = 2.25 m/s².
Rationales: A: The rope's upward component of 120 N lowers the normal force to 280 N, so friction is 70 N, not 100 N. B: Only the horizontal component of 160 N drives the sled. Using the full 200 N overstates the net force. C: An upward-angled rope reduces the normal force. It does not add to it, so friction is smaller, not larger.

**N-2.7-A-v3.** A 6.0 kg block is pulled across a level table by a string that exerts a 30 N force directed 53° above the horizontal. The kinetic friction coefficient is 0.50, and the block is already sliding. Use sin 53° = 0.80, cos 53° = 0.60 and g = 10 m/s². What is the block's acceleration?

- A. It slows down at 2.0 m/s², because friction is 0.50 × 60 N = 30 N.
- B. It speeds up at 2.0 m/s², because the horizontal force is the full 30 N.
- **C. 0 m/s², so it keeps moving at constant velocity.**
- D. It speeds up at 0.5 m/s², because the horizontal pull is 24 N and the normal force is 42 N.

Check: N = 60 − 30(0.80) = 36 N, f = 0.50 × 36 = 18 N, and F_x = 30(0.60) = 18 N. The net force is zero, so a = 0.
Rationales: A: The string's upward component of 24 N lowers the normal force to 36 N, so friction is only 18 N and balances the 18 N horizontal pull. B: Only the horizontal component of 18 N pulls the block forward. Using 30 N overstates the net force. D: This swaps sine and cosine. The horizontal component is 30 cos 53° = 18 N and the vertical is 24 N, giving N = 36 N and f = 18 N.

---

## Seed N-2.7-B (new) — Topic 2.7 Kinetic and Static Friction
**Skill:** use static friction as a supporting force: the normal force comes from the pushing force, not the weight, when a block is held against a wall.

A 2.0 kg block is pressed against a rough vertical wall by a horizontal force F; no other force is applied. The static friction coefficient is 0.40. What is the minimum F that keeps the block from sliding down? Use g = 10 m/s².

- A. 8 N, because the maximum friction is 0.40 × 20 N.
- B. 20 N, because the push must equal the weight.
- **C. 50 N**
- D. 28 N, because the push must exceed the weight by the friction coefficient.

Check: The normal force N = F, and static friction must balance the weight: μ_s F ≥ mg. F ≥ 20/0.40 = 50 N.
Rationales: A: This takes the normal force to be the weight. The normal force from the wall equals the horizontal push F, so the friction limit is 0.40 F. B: The push is horizontal and cannot balance the vertical weight directly. Friction must supply 20 N upward, and its maximum value is 0.40 F. D: Adding the friction coefficient to the weight has no physical meaning. Friction supplies the 20 N, so 0.40 F ≥ 20 N.

**N-2.7-B-v1.** A 5.0 kg block is pressed against a rough vertical wall by a horizontal force F; no other force is applied. The static friction coefficient is 0.50. What is the minimum F that keeps the block from sliding down? Use g = 10 m/s².

- A. 25 N, because the maximum friction is 0.50 × 50 N.
- **B. 100 N**
- C. 50 N, because the push must equal the weight.
- D. 75 N, because the push must exceed the weight by half.

Check: N = F and μ_s F ≥ mg, so F ≥ 50/0.50 = 100 N.
Rationales: A: The normal force is the horizontal push, not the weight. Friction can be at most 0.50 F. C: A horizontal push cannot directly balance the weight. Friction must carry the 50 N, so it must equal 0.50 F. D: Adding half the weight has no basis. The condition is 0.50 F ≥ 50 N.

**N-2.7-B-v2.** A 1.5 kg book is held at rest between two vertical hands. Each hand squeezes with the same horizontal force F, and the static friction coefficient between each hand and the book is 0.30. What is the minimum F that keeps the book from slipping? Use g = 10 m/s².

- **A. 25 N**
- B. 50 N, because friction acts only on one side.
- C. 4.5 N, because the maximum friction is 0.30 × 15 N.
- D. 15 N, because the squeeze must equal the weight.

Check: Two friction forces share the load: 2 μ_s F ≥ mg gives F ≥ 15/0.60 = 25 N.
Rationales: B: Friction acts at both surfaces, so the total upward friction can be 2 × 0.30 F. Using one side doubles the required force. C: The normal forces come from the hands' squeeze F, not from the weight. The weight does not press the book against the hands. D: The squeeze is horizontal and friction carries the vertical load. The condition is 2(0.30)F ≥ 15 N.

**N-2.7-B-v3.** A 3.0 kg block is pushed against a rough vertical wall by a force F directed 37° above the horizontal, pointing toward the wall. The static friction coefficient is 0.50. What is the minimum F that keeps the block from sliding down? Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s².

- A. 75 N, because only the friction force supports the block.
- B. 50 N, because the upward component alone must support the weight.
- C. 60 N, because the push must equal the weight divided by the friction coefficient.
- **D. 30 N**

Check: Normal force N = F cos 37° = 0.80 F. Vertical balance: F sin 37° + μ_s N = mg gives 0.60 F + 0.40 F = 30 N, so F = 30 N.
Rationales: A: The upward component of F also supports the weight. Ignoring it overstates the required force. B: The friction force also helps; the wall normal force 0.80 F gives friction up to 0.40 F. Both together must carry the weight. C: The normal force is the horizontal component of F, not F itself, and the vertical component helps too.

---

## Seed N-2.8-A (new) — Topic 2.8 Spring Forces
**Skill:** extract the spring constant and the natural length from two force-length readings, where the length is not the stretch.

A spring is pulled by a horizontal force. When the force is 2.0 N the spring's total length is 0.30 m, and when the force is 5.0 N its total length is 0.36 m. The spring obeys Hooke's law. What are the spring constant and the natural (unstretched) length?

- A. k = 50 N/m; natural length 0.30 m, because the first reading is the unstretched length.
- B. k = 14 N/m; natural length 0.26 m, because k = F/L at the 5.0 N reading.
- C. k = 7 N/m; natural length 0.30 m, because k = F/L at the first reading.
- **D. k = 50 N/m; natural length 0.26 m**

Check: k = ΔF/ΔL = 3.0 N/0.06 m = 50 N/m. At 2.0 N the stretch is 2.0/50 = 0.04 m, so L₀ = 0.30 − 0.04 = 0.26 m.
Rationales: A: The spring is already stretched by the 2.0 N force at the first reading. Its stretch there is 2.0/50 = 0.04 m, so the natural length is 0.26 m. B: Hooke's law uses the stretch, not the total length. The change in force over the change in length gives k = 3.0 N/0.06 m = 50 N/m. C: Dividing force by total length mixes the natural length with the stretch. The slope of force against length is the spring constant.

**N-2.8-A-v1.** A spring is pulled by a horizontal force. When the force is 2.0 N the spring's total length is 0.37 m, and when the force is 6.0 N its total length is 0.47 m. The spring obeys Hooke's law. What are the spring constant and the natural (unstretched) length?

- A. k = 40 N/m; natural length 0.37 m, because the first reading is the unstretched length.
- B. k = 13 N/m; natural length 0.32 m, because k = F/L at the 6.0 N reading.
- **C. k = 40 N/m; natural length 0.32 m**
- D. k = 5.4 N/m; natural length 0.37 m, because k = F/L at the first reading.

Check: k = ΔF/ΔL = 4.0 N/0.10 m = 40 N/m. At 2.0 N the stretch is 0.050 m, so L₀ = 0.37 − 0.05 = 0.32 m.
Rationales: A: The 2.0 N force already stretches the spring by 0.05 m, so the natural length is 0.32 m. B: The spring constant is the force change divided by the length change, 4.0 N/0.10 m = 40 N/m, not force over total length. D: Force divided by total length does not give the spring constant. Use the change in force over the change in length.

**N-2.8-A-v2.** A light spring is stretched by a horizontal force. When the force is 5.0 N the spring's total length is 0.45 m, and when the force is 20 N its total length is 0.60 m. The spring obeys Hooke's law. What are the spring constant and the natural (unstretched) length?

- A. k = 100 N/m; natural length 0.45 m, because the first reading is the unstretched length.
- **B. k = 100 N/m; natural length 0.40 m**
- C. k = 33 N/m; natural length 0.40 m, because k = F/L at the 20 N reading.
- D. k = 11 N/m; natural length 0.45 m, because k = F/L at the first reading.

Check: k = ΔF/ΔL = 15 N/0.15 m = 100 N/m. At 5.0 N the stretch is 0.050 m, so L₀ = 0.45 − 0.05 = 0.40 m.
Rationales: A: At 5.0 N the spring is stretched by 0.050 m already, so the natural length is 0.40 m. C: Hooke's law uses stretch, not total length. ΔF/ΔL = 15 N/0.15 m = 100 N/m. D: Dividing the force by the total length does not give the spring constant. Use the slope of force against length.

**N-2.8-A-v3.** A light spring hangs from a hook. With a 0.20 kg mass attached, its total length is 0.38 m, and with a 0.60 kg mass attached, its total length is 0.54 m. The spring obeys Hooke's law and g = 10 m/s². What are the spring constant and the natural (unstretched) length?

- **A. k = 25 N/m; natural length 0.30 m**
- B. k = 25 N/m; natural length 0.38 m, because the first reading is the unstretched length.
- C. k = 11 N/m; natural length 0.30 m, because k = F/L at the 0.60 kg reading.
- D. k = 5.3 N/m; natural length 0.38 m, because k = F/L at the first reading.

Check: k = ΔF/ΔL = 4.0 N/0.16 m = 25 N/m. At 2.0 N the stretch is 0.080 m, so L₀ = 0.38 − 0.08 = 0.30 m.
Rationales: B: The 0.20 kg mass already stretches the spring by 2.0/25 = 0.08 m, so the natural length is 0.30 m. C: The spring constant comes from the change in force over the change in length: 4.0 N/0.16 m = 25 N/m, not force over total length. D: Dividing the weight by the total length does not give k. The slope of force against length does.

---

## Seed N-2.8-B (new) — Topic 2.8 Spring Forces
**Skill:** combine springs: the same force passes through springs in series so their stretches add, while parallel springs share the load with a common stretch.

Two identical light springs, each with k = 200 N/m, are joined end to end. The upper end is fixed to the ceiling and a 2.0 kg block hangs at rest from the lower end. Use g = 10 m/s². What is the total stretch of the two-spring chain?

- **A. 0.20 m**
- B. 0.10 m, because the stretch of one spring is 20/200.
- C. 0.050 m, because the two springs add to a total spring constant of 400 N/m.
- D. 0.40 m, because each spring carries its own 20 N and another 20 N from the spring below.

Check: Each spring carries the 20 N weight, so each stretches 20/200 = 0.10 m. Stretches add in series: 0.20 m (effective k = 100 N/m).
Rationales: B: That is the stretch of one spring only. Both springs carry the full 20 N, so their stretches add to 0.20 m. C: Adding spring constants applies to springs side by side (parallel). End-to-end springs are softer, with an effective constant of 100 N/m. D: The lower spring is light and adds no force. Each spring carries only the 20 N weight, so each stretches 0.10 m.

**N-2.8-B-v1.** Two light springs with k = 100 N/m and k = 200 N/m hang side by side from the ceiling. Their lower ends are attached to the same light bar that supports a 3.0 kg block at rest, and both springs stretch by the same amount. Use g = 10 m/s². What is the stretch of the springs?

- A. 0.30 m, because the softer spring carries the whole weight.
- B. 0.15 m, because the stiffer spring carries the whole weight.
- C. 0.45 m, because the stretches of the two springs add.
- **D. 0.10 m**

Check: Parallel springs have equal stretch and add their constants: k = 300 N/m, so x = 30/300 = 0.10 m.
Rationales: A: Both springs stretch by the same amount and share the 30 N load, so neither carries all of it. B: The softer spring also carries load. The total constant is 300 N/m, so the stretch is 30/300. C: Stretches add for springs in series. Here the springs are side by side and share a single common stretch.

**N-2.8-B-v2.** Two light springs with k = 300 N/m and k = 600 N/m are joined end to end. The upper end is fixed to the ceiling and a 6.0 kg block hangs at rest from the lower end. Use g = 10 m/s². What is the total stretch of the two-spring chain?

- A. 0.067 m, because the springs add to a total constant of 900 N/m.
- B. 0.20 m, because only the softer spring stretches.
- **C. 0.30 m**
- D. 0.10 m, because the stiffer spring limits the stretch.

Check: Each spring carries the 60 N weight: x = 60/300 + 60/600 = 0.20 + 0.10 = 0.30 m.
Rationales: A: Adding the constants is correct only for parallel springs. In series each spring carries the full 60 N and the stretches add. B: The stiffer spring also carries the full 60 N and stretches by 0.10 m. Both contribute. D: The stiffer spring adds 0.10 m, but the softer one adds 0.20 m. The total is the sum of both.

**N-2.8-B-v3.** A 1.5 kg block rests on a frictionless horizontal track between two walls. A spring with k = 100 N/m joins the block to the left wall and a spring with k = 300 N/m joins it to the right wall. Both springs are relaxed at the block's equilibrium position. The block is pulled 0.050 m to the right of equilibrium and held. What is the net horizontal spring force on the block?

- A. 5 N, directed toward the left, because only the softer spring acts.
- **B. 20 N, directed toward the left.**
- C. 15 N, directed toward the left, because only the stiffer spring acts.
- D. 10 N, directed toward the left, because the two spring forces partly cancel.

Check: Left spring stretched: 100(0.050) = 5 N toward the left. Right spring compressed: 300(0.050) = 15 N toward the left. The sum is 20 N toward the left.
Rationales: A: Both springs exert force. The right spring, compressed by 0.050 m, pushes left with 15 N, and the left one pulls left with 5 N. C: The left spring is stretched and also pulls the block back toward the left, adding 5 N. D: Both spring forces point left, because one spring is stretched and the other is compressed. They add rather than cancel.

---

## Seed N-2.9-A (new) — Topic 2.9 Circular Motion
**Skill:** use friction as the centripetal force on a flat curve: the maximum speed does not depend on mass.

A 1000 kg car can just barely round a flat circular curve of radius 50 m at its maximum speed without skidding. The static friction coefficient between tires and road is 0.80. Use g = 10 m/s². The same car is then loaded with passengers and cargo until its mass is 1500 kg. What is the maximum speed at which it can now round the curve?

- A. 24 m/s, because the greater weight gives more friction.
- **B. 20 m/s**
- C. 16 m/s, because a heavier car needs more force to turn.
- D. 30 m/s, because the maximum speed scales in proportion to mass.

Check: μ m g = m v²/r gives v = √(μ g r) = √(0.80 × 10 × 50) = 20 m/s, independent of mass.
Rationales: A: Greater weight increases friction, but it also increases the mass that must be accelerated. The two effects cancel, so the speed limit is unchanged. C: The friction limit grows in proportion to mass just as the required centripetal force does, so the maximum speed does not decrease. D: The maximum speed does not depend on mass at all. It depends on μ, g and the radius: v = √(μ g r).

**N-2.9-A-v1.** A 200 kg motorcycle and rider can just barely round a flat circular curve of radius 45 m at their maximum speed without skidding. The static friction coefficient is 0.50. Use g = 10 m/s². A passenger is added so the total mass becomes 400 kg. What is the maximum speed now?

- **A. 15 m/s**
- B. 21 m/s, because the greater weight gives more friction.
- C. 11 m/s, because a heavier vehicle needs more force to turn.
- D. 30 m/s, because the maximum speed doubles when the mass doubles.

Check: v = √(μ g r) = √(0.50 × 10 × 45) = 15 m/s. The mass cancels, so adding a passenger does not change it.
Rationales: B: More weight increases friction, but the mass to be accelerated increases equally, so the limit does not change. C: The friction force limit also doubles when the mass doubles. The maximum speed stays the same. D: The maximum speed does not depend on mass. It is set by μ, g and r.

**N-2.9-A-v2.** An empty 3000 kg truck can just barely round a flat circular curve of radius 20 m at its maximum speed without skidding. The static friction coefficient is 0.50. Use g = 10 m/s². The truck is then loaded until its mass is 12000 kg. What is the maximum speed now?

- A. 20 m/s, because the maximum speed grows as the square root of the mass.
- B. 5 m/s, because the maximum speed falls as the mass increases.
- C. 40 m/s, because the maximum speed is proportional to the mass.
- **D. 10 m/s**

Check: v = √(μ g r) = √(0.50 × 10 × 20) = 10 m/s, independent of the truck's mass.
Rationales: A: Mass does not appear in v = √(μ g r). Friction and the required centripetal force scale together with mass. B: A heavier truck has proportionally more friction available. The speed limit does not decrease. C: The maximum speed does not depend on mass at all. It depends on μ, g and the radius.

**N-2.9-A-v3.** A 800 kg car can just barely round a flat circular curve of radius 24 m at its maximum speed without skidding. The static friction coefficient is 0.60. Use g = 10 m/s². The car is then loaded until its mass is 2400 kg. What is the maximum speed now?

- A. 21 m/s, because the maximum speed grows as the square root of the mass.
- B. 6.9 m/s, because the heavier car must go slower.
- **C. 12 m/s**
- D. 36 m/s, because the maximum speed is proportional to the mass.

Check: v = √(μ g r) = √(0.60 × 10 × 24) = 12 m/s, the same for any mass.
Rationales: A: The mass cancels in μ m g = m v²/r. A heavier car has more friction but also needs more centripetal force. B: The maximum speed is unchanged because both the available friction and the required force scale with mass. D: The speed limit does not depend on mass; it is √(μ g r).

---

## Seed N-2.9-B (new) — Topic 2.9 Circular Motion
**Skill:** scale the centripetal force with speed and radius together using F proportional to v²/r.

A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 20 N. The ball is later whirled at speed 2v on a circle of radius 2r. What is the new tension?

- A. 80 N, because the tension is proportional to v².
- B. 160 N, because both doubling the speed and doubling the radius increase the tension.
- **C. 40 N**
- D. 20 N, because the doubling of speed and radius cancel.

Check: T = mv²/r. The factor is (2)²/2 = 2, so the tension becomes 2 × 20 = 40 N.
Rationales: A: The tension is proportional to v²/r. The larger radius divides the factor of 4 by 2. B: Doubling the radius reduces the tension. It appears in the denominator of F = mv²/r. D: The speed enters as v², giving a factor of 4, while the radius gives a factor of 1/2. They do not cancel exactly; the net factor is 2.

**N-2.9-B-v1.** A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 12 N. The ball is later whirled at speed 3v on a circle of radius 3r. What is the new tension?

- A. 108 N, because the tension is proportional to v².
- **B. 36 N**
- C. 12 N, because the triple speed and triple radius cancel.
- D. 324 N, because both the speed and the radius increase the tension.

Check: T = mv²/r. The factor is 3²/3 = 3, so the tension becomes 3 × 12 = 36 N.
Rationales: A: The tension is proportional to v²/r. The tripled radius divides the factor of 9 by 3. C: The speed counts as v², a factor of 9, but the radius is only a factor of 1/3. The net factor is 3. D: A larger radius lowers the tension, since r is in the denominator of mv²/r.

**N-2.9-B-v2.** A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 15 N. The ball is later whirled at speed 2v on a circle of radius 4r. What is the new tension?

- **A. 15 N**
- B. 60 N, because the tension is proportional to v².
- C. 30 N, because the tension is proportional to the speed.
- D. 3.75 N, because only the larger radius matters.

Check: T = mv²/r. The factor is 2²/4 = 1, so the tension stays 15 N.
Rationales: B: The tension is proportional to v²/r, and the larger radius divides the factor of 4 by 4. C: The tension is proportional to the square of the speed, not the speed itself. The factor from speed is 4 and the factor from radius is 1/4. D: The doubled speed multiplies the tension by 4 and the quadrupled radius divides it by 4. The effect of the radius alone is not the full picture.

**N-2.9-B-v3.** A small ball on a light string moves in a horizontal circle on a frictionless table, so the string tension is the only horizontal force on it. At speed v on a circle of radius r the tension is 4.0 N. The ball is later whirled at speed 3v on a circle of radius r/2. What is the new tension?

- A. 36 N, because the tension is proportional to v².
- B. 24 N, because the tension is proportional to the speed.
- C. 12 N, because only the tripled speed matters.
- **D. 72 N**

Check: T = mv²/r. The factor is 3²/(1/2) = 18, so the tension becomes 18 × 4.0 = 72 N.
Rationales: A: The speed gives a factor of 9, but the halved radius gives another factor of 2, since r is in the denominator. B: The tension varies with the square of the speed, so the speed alone contributes a factor of 9, not 3. C: The speed change alone gives 9 times, and the smaller radius doubles it again. A factor of 3 is wrong on both counts.

---
