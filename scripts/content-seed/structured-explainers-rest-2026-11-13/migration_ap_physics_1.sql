-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- A scalar carries only magnitude (speed, distance, time); a vector carries magnitude and direction.
- In one dimension this course does not require vector-arrow notation.
- A signed value like v_x = -4 m/s fully conveys direction through its sign alone, without ever writing an arrow over the symbol.$q$,
  what_students_need_to_understand = $q$- Every kinematics equation you'll use this unit depends on getting signs right.
- If you can't tell a scalar from a vector, you'll add speeds when you should be subtracting velocities.
- Every later unit (forces, momentum, energy) builds on this same signed-quantity habit.$q$,
  how_this_becomes_points = $q$1. Consistently assign and use a sign convention (e.g., positive = rightward or upward) for every vector quantity in a problem.
2. Correctly identify which given quantities are scalars (speed, distance, time) versus vectors (velocity, displacement, acceleration).$q$,
  point_attaining_answer = $q$1. Total distance traveled is a scalar: 7 m (from +2 to +9) plus 6 m (from +9 to +3) = 13 m.
2. Net displacement is a vector, found from final minus initial position: x_f - x_i = 3 - 2 = +1 m, i.e. 1 m in the positive direction.
3. It is not 13 m, because the backward leg subtracts from displacement even though it adds to distance.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=1 and topic_code='1.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='671574502804c3c56364ec61a4fb06e5';
update app.topic_explainers set
  core_idea = $q$- Average velocity is (delta-x)/(delta-t) and average acceleration is (delta-v)/(delta-t).
- Instantaneous velocity and acceleration are defined as the limit of that average over a very small time interval.
- They are never introduced via a derivative, since no derivative notation appears anywhere in this algebra-based course.$q$,
  what_students_need_to_understand = $q$- These three definitions are the vocabulary every other kinematics topic is written in.
- The constant-acceleration equations, the graph slopes, and the relative-motion rules in this unit all reduce back to these two ratios.$q$,
  how_this_becomes_points = $q$- Correctly compute displacement, change in velocity, average velocity, or average acceleration from given position/velocity/time data.
- Correctly distinguish an instantaneous value (read at one moment) from an average value (computed over an interval).$q$,
  point_attaining_answer = $q$1. Average velocity = (delta-x)/(delta-t) = (24 m - 4 m)/(5 s - 1 s) = 20 m / 4 s = 5 m/s.
2. This is not necessarily the instantaneous velocity at t = 3 s: instantaneous velocity is the limit of (delta-x)/(delta-t) as the time interval shrinks toward that single moment.
3. Unless the car moves at constant velocity throughout, the 4-second average can differ from the instant at t = 3 s.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=1 and topic_code='1.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ac26cc9f2e7cb2391ad768655a00611f';
update app.topic_explainers set
  core_idea = $q$- The three constant-acceleration equations (v = v0 + at, x = x0 + v0t + (1/2)at^2, v^2 = v0^2 + 2a(x - x0)) apply only when acceleration is constant.
- Nonuniform acceleration is analyzed only qualitatively or graphically, never by plugging into these equations.
- g = 10 m/s^2 is used for numeric problems; 9.8 or 9.81 m/s^2 is not penalized.$q$,
  what_students_need_to_understand = $q$- Most quantitative kinematics problems on the exam are solved by picking the one correct equation from this set or by reading a value off a graph.
- Fluency here is the single biggest lever for points in this unit.$q$,
  how_this_becomes_points = $q$1. Pick the equation matching the knowns and unknown; substitute correctly.
2. Graphs: position slope = velocity, velocity slope = acceleration, area under velocity = displacement, area under acceleration = change in velocity.
3. Nonuniform acceleration is scored on qualitative shape/reasoning, not the three equations.$q$,
  point_attaining_answer = $q$1. v = v0 + at: v = 0 + (4 m/s^2)(5 s) = 20 m/s.
2. x = x0 + v0t + (1/2)at^2: x = 0 + 0 + (1/2)(4 m/s^2)(5 s)^2 = (1/2)(4)(25) = 50 m.
3. Check with v^2 = v0^2 + 2a(x - x0): 20^2 = 400, and 2(4)(50) = 400, confirming consistency.

The distance is not simply final velocity times time, because the car wasn't moving at 20 m/s for the whole interval -- it started from rest and sped up.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=1 and topic_code='1.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='21aaf8d4f78beaf7161dc8a3e80d35f5';
update app.topic_explainers set
  core_idea = $q$- Acceleration is the same in every inertial reference frame, but velocity is not.
- Velocity combines the object's velocity in one frame with the relative velocity between frames.
- Relative-velocity vector addition is restricted to one dimension; two-dimensional problems, such as a boat crossing a river, are outside AP Physics 1's scope.$q$,
  what_students_need_to_understand = $q$- Problems describing motion "as seen from" a moving platform (a walkway, a train, another car) only make sense once velocities are combined between frames.
- Accelerations transfer over unchanged.$q$,
  how_this_becomes_points = $q$- Correctly add or subtract one-dimensional velocities to convert between reference frames.
- Correctly state that the acceleration of an object is the same as measured in any inertial frame.$q$,
  point_attaining_answer = $q$1. Passenger's velocity relative to the floor = walkway's velocity + passenger's velocity relative to the walkway: 1.5 m/s + 1.2 m/s = 2.7 m/s, both in the same direction.
2. Simple addition works because both velocities lie along the same one-dimensional line of motion (forward along the walkway).
3. Only one-dimensional relative velocities are tested; a two-dimensional case such as a boat crossing a river, needing full vector addition, is not.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=1 and topic_code='1.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cb8c9cc364b67387e214608ececcc14a';
update app.topic_explainers set
  core_idea = $q$- Projectile motion decomposes into two independent 1-D motions: zero acceleration horizontally, constant g vertically, linked only by a shared time.
- On a 2026 released FRQ, qualitative reasoning about the motion was graded as a separate requirement from the mathematical derivation.
- It is its own scored piece, not an optional add-on to the math.$q$,
  what_students_need_to_understand = $q$- Projectile motion is the main way the course tests whether you can combine vector resolution with the kinematics equations from the previous topic.
- Horizontal and vertical motion happen simultaneously but must be solved separately.$q$,
  how_this_becomes_points = $q$1. Resolve the initial velocity into horizontal and vertical components.
2. Recognize horizontal acceleration is zero and vertical acceleration is constant.
3. Solve each axis with the appropriate 1-D kinematic equation, then recombine results if needed.$q$,
  point_attaining_answer = $q$1. vx0 = 20cos(30 deg) is approximately 17.3 m/s (constant, since horizontal acceleration is zero); vy0 = 20sin(30 deg) = 10 m/s.
2. Vertically it slows, stops rising, then falls: time to peak is vy0/g = 10/10 = 1 s; by symmetry (same launch and landing height) total flight time is 2 s.
3. Horizontal range = vx0 times t = 17.3 times 2, approximately 34.6 m.

In words: gravity continuously decelerates the upward motion until vertical velocity reverses sign -- a point separate from the calculation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=1 and topic_code='1.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='658cd5c6f05c11c0db4a13b67120f52a';
update app.topic_explainers set
  core_idea = $q$- A system boundary tells you what objects are being modeled together.
- Center of mass is the mass-weighted average position of that system, so it shifts toward larger masses or clusters of mass.$q$,
  what_students_need_to_understand = $q$- AP Physics 1 center-of-mass calculations are limited to systems of five or fewer particles in two dimensions or highly symmetrical systems.
- The point is not advanced integration; it is choosing the system and weighting positions by mass.$q$,
  how_this_becomes_points = $q$1. Name the system, including only masses in that system.
2. Write x_cm = sum m_i x_i over sum m_i or the matching y expression.

Qualitative answers should say which side has more mass or farther mass.$q$,
  point_attaining_answer = $q$1. It is at x = 4 m.
2. Use the mass-weighted average: (m(0)+m(6)+m(6))/(3m)=4 m.
3. The center of mass shifts toward the side with more mass, so the geometric midpoint is not enough.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f54533ce119d17359cfd7e73eb1ce152';
update app.topic_explainers set
  core_idea = $q$- A free-body diagram is a force inventory for one object.
- It should show each real external force once, as a straight arrow from the dot.
- Components are saved for the equations.$q$,
  what_students_need_to_understand = $q$- Separate physical forces from mathematical components.
- Gravity, normal force, friction, tension, spring force, and applied forces can appear.
- Velocity, acceleration, kinetic energy, momentum, and force components are not separate FBD forces.$q$,
  how_this_becomes_points = $q$1. Choose the object.
2. Draw each force in its physical direction.
3. Avoid extra arrows.

A correct FBD often earns credit before any equation is written.$q$,
  point_attaining_answer = $q$No.

- Draw the full weight mg downward, plus normal force and friction if present.
- The component mg sin(theta) is part of resolving the weight into axes.
- Drawing it as another arrow double-counts gravity.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6dfcaf4d57f595b9517ad6bc7f91fb37';
update app.topic_explainers set
  core_idea = $q$- Newton's third law pairs are two forces from one interaction: A on B and B on A.
- They are equal in magnitude and opposite in direction.
- They act on different objects.$q$,
  what_students_need_to_understand = $q$- Avoid using third-law pairs as if they cancel on one object.
- They cancel only when both objects are inside the chosen system and the pair is internal.
- For AP Physics 1, massive-string tension is described qualitatively rather than calculated in detail.$q$,
  how_this_becomes_points = $q$1. Name both objects.
2. Assign each force to the object it acts on.
3. Use system boundaries to decide whether the pair belongs inside or outside a net-force equation.$q$,
  point_attaining_answer = $q$- The partner is the table pushing up on the book.
- The book-on-table force and table-on-book force are equal and opposite and act on different objects.
- The book weight is Earth pulling on the book, a different interaction.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='555ec01099afb2b88f1517d536a9b304';
update app.topic_explainers set
  core_idea = $q$- Newton's first law says constant velocity requires zero net force in an inertial frame.
- Zero net force can coexist with real forces if they balance.$q$,
  what_students_need_to_understand = $q$- Think component by component.
- A block can have vertical force balance while accelerating horizontally, or horizontal force balance while moving at constant horizontal velocity.
- Rest is just the zero-speed case of constant velocity.$q$,
  how_this_becomes_points = $q$1. Connect zero acceleration to sum F = 0 along the relevant direction.
2. Explain that balanced forces do not disappear.

If acceleration is nonzero, first-law equilibrium does not apply in that direction.$q$,
  point_attaining_answer = $q$- The net horizontal force is zero.
- The pulling force can be balanced by friction, so the sled continues at constant velocity.
- Constant velocity means balanced forces, not no forces.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f5d3595616f58170b16f2307e5e860d5';
update app.topic_explainers set
  core_idea = $q$Newton's second law is a system-matched statement: the net external force on the selected object or system equals that object or system mass times its acceleration.$q$,
  what_students_need_to_understand = $q$- Keep force equations organized.
- A force on block A belongs in block A equation; a force on the two-block system belongs in the system equation.
- Constraints can connect accelerations, but they do not merge unrelated force lists.$q$,
  how_this_becomes_points = $q$1. Draw the FBD.
2. Choose axes.
3. Sum forces by component.
4. Match the mass and acceleration to the same selected object or system.$q$,
  point_attaining_answer = $q$- The equation mixes objects.
- If it is for block A, use forces on block A and mass A.
- If it is for both blocks, use external forces on both blocks and total mass.
- Shared acceleration is a constraint, not permission to mix force lists.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ee8c9aca090eeb3e1fe49021c48c6efe';
update app.topic_explainers set
  core_idea = $q$- Gravity can be modeled as a force between masses or as a field.
- Near Earth, weight is mg.
- Apparent weight is the normal-force magnitude a scale would read.$q$,
  what_students_need_to_understand = $q$- Distinguish mass, weight, gravitational field, and normal force.
- An object feeling heavier or lighter in an accelerating elevator means the normal force changed, not that its mass changed.$q$,
  how_this_becomes_points = $q$1. Use F_g = Gm1m2/r^2 or mg in the right context.
2. Use g = F_g/m as field strength.
3. Explain apparent weight through the normal force.$q$,
  point_attaining_answer = $q$- The m in g = F_g/m is the test object mass, not the planet mass.
- For a planet, g = GM/r^2, so increasing planet mass M at the same radius increases gravitational field strength.
- Do not confuse object mass, planet mass, and weight.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f2f10cdbcc98a2686352301f9ee8747d';
update app.topic_explainers set
  core_idea = $q$- Kinetic friction has a fixed model during sliding.
- Static friction adjusts to prevent slipping, up to a maximum.
- Static friction equals mu_s F_N only at the threshold of slipping.$q$,
  what_students_need_to_understand = $q$- Infer both direction and size from the contact condition.
- Static friction can be less than its maximum or even zero if no tangential slipping tendency exists.$q$,
  how_this_becomes_points = $q$1. Identify sliding versus non-sliding contact.
2. Use F_k = mu_k F_N for kinetic friction.
3. Solve for the needed static friction.
4. Compare it with F_s,max = mu_s F_N.$q$,
  point_attaining_answer = $q$- It is P, opposite the push.
- Static friction adjusts to whatever value is needed to prevent slipping, up to the maximum mu_s F_N.
- The maximum is a limit, not the automatic value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cdc49ea0d28ba4849c521ab673bff0cb';
update app.topic_explainers set
  core_idea = $q$- A spring force is a restoring force: it points toward equilibrium.
- Its magnitude is k times the displacement from equilibrium.$q$,
  what_students_need_to_understand = $q$- Measure stretch or compression relative to equilibrium, not total length.
- The sign in F_s = -k Delta x means the force opposes displacement from equilibrium.$q$,
  how_this_becomes_points = $q$1. Identify equilibrium.
2. Find Delta x.
3. Draw the restoring force in the correct direction.
4. Use the spring force in a net-force equation when dynamics are involved.$q$,
  point_attaining_answer = $q$- The spring force points left, back toward equilibrium.
- A spring force is restoring: when displacement is to the right, the force is in the opposite direction.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7d40fc71277911a9ff625aa8104aa1a3';
update app.topic_explainers set
  core_idea = $q$- Circular motion needs inward centripetal acceleration v^2/r.
- The inward net force comes from real forces such as tension, gravity, normal force, or friction.
- Centripetal force is not an extra force.$q$,
  what_students_need_to_understand = $q$- Draw the FBD before writing mv^2/r.
- At the top of a vertical loop, both gravity and the normal force can point toward the center, which means the normal force points downward there.$q$,
  how_this_becomes_points = $q$1. Identify the center direction.
2. Resolve real forces radially.
3. Write sum F_radial = mv^2/r.
4. Respect AP Physics 1 limits on banked curves with friction and Kepler laws.$q$,
  point_attaining_answer = $q$- Downward, toward the center of the loop.
- The normal force is perpendicular to the track surface and points from the track toward the object.
- At the top, the center is below the object, so the normal force and gravity can both point inward.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=2 and topic_code='2.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b4ebdc946b4e5028eebc815d7db07d4d';
update app.topic_explainers set
  core_idea = $q$- K = (1/2)mv^2 is a scalar that is always non-negative, because it depends on v^2; velocity direction can never make it negative.
- Kinetic energy is frame-dependent: observers in different frames can measure different speeds for the same object and compute different values of K.
- No single frame is the "correct" one.$q$,
  what_students_need_to_understand = $q$- Identify which speed to plug in: the object's speed relative to the frame the problem specifies.
- K itself never carries a sign, since squaring the speed erases any direction information.$q$,
  how_this_becomes_points = $q$1. Compute K = (1/2)mv^2 with the correct speed for the specified reference frame.
2. Reason that K cannot be negative.
3. Reason that its value can differ between two valid reference frames for the same object.$q$,
  point_attaining_answer = $q$1. Ground frame: K = (1/2)(2 kg)(6 m/s)^2 = 36 J.
2. Observer running at 4 m/s in the same direction: the ball's speed is only 6 - 4 = 2 m/s, so K = (1/2)(2 kg)(2 m/s)^2 = 4 J.
3. The values differ because kinetic energy depends on speed relative to the observer's frame, not on some single absolute speed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=3 and topic_code='3.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f3a170f290584195b83976ddab152db5';
update app.topic_explainers set
  core_idea = $q$- Work for a constant force is W = F_parallel d = Fd cos(theta) -- never treated as a dot product or with calculus notation in this course.
- For a force that changes with position, work equals the area under a graph of F_parallel versus displacement.
- The constant-force formula no longer applies directly there.$q$,
  what_students_need_to_understand = $q$- The most common way to lose points is using the full force magnitude instead of the component parallel to the displacement.
- Work only comes from the piece of the force that's doing something in the direction of motion.$q$,
  how_this_becomes_points = $q$1. Isolate F_parallel (via Fcos(theta) or direct identification).
2. Multiply by displacement with the correct sign.
3. For a variable force, read area under an F_parallel-vs-displacement graph instead of forcing a single-formula calculation.$q$,
  point_attaining_answer = $q$- Only the horizontal component of the 50 N force does work on the box, since displacement is horizontal.
- W = Fd cos(theta) = (50 N)(10 m)(0.8) = 400 J.
- It is not 500 J, because the full 50 N isn't aligned with the direction of motion; part of it points upward and does no work on the horizontal displacement.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=3 and topic_code='3.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8fea985e4e50e47beb26157ecd42cc0b';
update app.topic_explainers set
  core_idea = $q$- U = 0 is an observer's choice, not a fixed physical reference: place it anywhere convenient (the ground, a table, a spring's natural length), consistently within one problem.
- deltaU_g = mg deltay approximates the general inverse-square gravitational form; it is not an independent law.
- With more than two objects, total potential energy sums every pair.$q$,
  what_students_need_to_understand = $q$- Two students can pick different reference heights and both be correct, as long as they only report changes in U or are explicit about their reference.
- The physics never depends on where you set U = 0.$q$,
  how_this_becomes_points = $q$1. Compute a change in potential energy (spring: (1/2)k(deltax)^2; near-surface gravitational: mg deltay).
2. State or use a reference point explicitly, rather than treating U = 0 as a universal, physically fixed location.$q$,
  point_attaining_answer = $q$1. U_s = (1/2)k(deltax)^2 = (1/2)(200 N/m)(0.3 m)^2 = (1/2)(200)(0.09) = 9 J.
2. The zero of elastic potential energy is set at the spring's natural (uncompressed) length here -- a choice, not a universal rule.
3. So U_s = 9 J is the energy relative to that chosen reference, not relative to the ground.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=3 and topic_code='3.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='26eac60f79685be6316a282647deae50';
update app.topic_explainers set
  core_idea = $q$- A single object modeled as a point mass can only possess kinetic energy; potential energy is never a property of one isolated object.
- Potential energy requires a system with an internal conservative interaction (object-and-Earth, object-and-spring).
- Only then does the system have both K and U to track through conservation of mechanical energy.$q$,
  what_students_need_to_understand = $q$- On a released FRQ, the single most common error was defaulting to a 50/50 split between kinetic and gravitational potential energy at an intermediate point, regardless of the actual height ratio.
- This happened despite most students correctly understanding total-energy conservation itself.$q$,
  how_this_becomes_points = $q$1. Write energy conservation as initial energy equals final energy plus any transfer or dissipation term, for a correctly chosen system.
2. Compute the actual K/U split at an intermediate point from the real height ratio given, not an even split.$q$,
  point_attaining_answer = $q$1. Total mechanical energy at the top: E = mgh = (2 kg)(10 m/s^2)(5 m) = 100 J, all potential, since the block starts at rest.
2. At height 2 m, U = mgh = (2)(10)(2) = 40 J, so by conservation K = 100 - 40 = 60 J.
3. The split is 60/40, not 50/50 -- it depends on the actual height ratio (the block has descended 3 of the original 5 m).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=3 and topic_code='3.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='70f094a2cb299b7255f75b2a926c2051';
update app.topic_explainers set
  core_idea = $q$- Average power is P_avg = deltaE/deltat = W/deltat.
- Instantaneous power for a constant force is P = F_parallel v = Fv cos(theta), a derived equation obtained from the rate of work, not an independent formula.
- This algebra-based course gives no treatment of instantaneous power when force or velocity changes with time; no derivative notation is used.$q$,
  what_students_need_to_understand = $q$- Track the time interval correctly: a large amount of work over a long time can be less power than a smaller amount of work done quickly.
- The point is the rate at which energy is transferred, not the energy transferred.$q$,
  how_this_becomes_points = $q$1. Average power: divide energy transferred (or work done) by the actual elapsed time.
2. Instantaneous power: identify the force component parallel to velocity.
3. Do not report work or force alone as if it were power.$q$,
  point_attaining_answer = $q$1. Constant velocity means net force is zero, so the lifting force equals the weight: F = mg = (50 kg)(10 m/s^2) = 500 N, parallel to the velocity (theta = 0).
2. P = Fv cos(theta) = (500 N)(2 m/s)(1) = 1000 W.
3. The force alone (500 N) is not power; it must be multiplied by the speed at which it acts.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=3 and topic_code='3.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7543c5d133abdec76d42954fb8f430f4';
update app.topic_explainers set
  core_idea = $q$- Momentum is mass times velocity, so it inherits velocity direction.
- A 2 kg cart moving left and a 2 kg cart moving right have equal momentum magnitudes but opposite momentum vectors if right is chosen positive.$q$,
  what_students_need_to_understand = $q$- Treat momentum as a signed or directional quantity from the first line of work.
- The word momentum means linear momentum unless the prompt explicitly shifts to angular momentum in a later unit.$q$,
  how_this_becomes_points = $q$1. Set a direction convention.
2. Compute each p = mv with that sign.
3. Add momenta as vector quantities.

In collision setups, that signed total is the quantity that may stay constant for the system.$q$,
  point_attaining_answer = $q$1. Cart A: p_A = (2)(+3) = +6 kg m/s.
2. Cart B: p_B = (1)(-6) = -6 kg m/s because it moves left.
3. Total system momentum: +6 + (-6) = 0 kg m/s.

The equal magnitudes cancel because momentum is a vector; adding magnitudes alone gives the wrong system total.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=4 and topic_code='4.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='cffa7c6c3442420e959fdd892b2dedb7';
update app.topic_explainers set
  core_idea = $q$- Impulse is not a new kind of momentum; it is the transfer that changes momentum.
- For a constant average net force, J = F_avg delta t.
- For a changing net force, J is the signed area under the net-force-versus-time graph.$q$,
  what_students_need_to_understand = $q$- Connect three equivalent ideas: impulse, change in momentum, and force-time area.
- The force direction sets the impulse direction.
- delta p must be final momentum minus initial momentum.$q$,
  how_this_becomes_points = $q$1. Compute delta p with signs.
2. Read or estimate area under a force-time graph.
3. Recognize that Newtons times seconds are the same momentum units as kg m/s.$q$,
  point_attaining_answer = $q$1. Initial momentum: p_i = (0.50)(+4) = +2 kg m/s.
2. Final momentum: p_f = 0 because the cart stops.
3. Delta p = p_f - p_i = 0 - 2 = -2 kg m/s, so the impulse is -2 N s.

The negative sign matters: the impulse is leftward, opposite the cart initial motion.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=4 and topic_code='4.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f45cbaeb35b0c5d4ad91a4124549ed46';
update app.topic_explainers set
  core_idea = $q$- Momentum conservation is a system claim.
- During a collision, each object can experience a large impulse from the other object, but those impulses are equal and opposite inside the system.
- If external impulse is negligible, the system total momentum stays constant.$q$,
  what_students_need_to_understand = $q$- Choose the system boundary before writing a conservation equation.
- One object momentum usually changes; the two-object system momentum can remain constant.
- Center-of-mass velocity also remains constant when no net external force acts.$q$,
  how_this_becomes_points = $q$1. Identify the conserved system.
2. Sum initial and final momenta with signs.
3. Use conservation for immediately-before and immediately-after states of a collision or explosion.$q$,
  point_attaining_answer = $q$1. The claim confuses one object with the system.
2. Cart A can lose momentum while Cart B gains the same amount from the equal-and-opposite interaction impulse.
3. If the two carts are the system and external impulse from friction is negligible during the short collision, total system momentum before equals total system momentum after.

Momentum conservation applies to the selected system, not to each object separately.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=4 and topic_code='4.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='96b3ffa5656d7d5100c48dcbc5a38250';
update app.topic_explainers set
  core_idea = $q$- Momentum conservation and kinetic-energy conservation answer different questions.
- Momentum can be conserved in elastic, inelastic, and perfectly inelastic collisions if external impulse is negligible; kinetic energy is conserved only in elastic collisions.
- Perfectly inelastic means the objects stick and share one final velocity.$q$,
  what_students_need_to_understand = $q$- Classify collisions after checking energy, not from whether momentum was conserved.
- The 2024 AP Physics 1 collision evidence highlights this: many students missed that the center-of-mass motion can be identical in elastic and inelastic versions of the same isolated collision.$q$,
  how_this_becomes_points = $q$1. Use momentum conservation to determine final motion.
2. Compare total kinetic energy before and after.
3. If objects stick together, one final velocity is required, but the system momentum equation still applies.$q$,
  point_attaining_answer = $q$1. Kinetic energy and momentum are different system quantities.
2. In a perfectly inelastic collision, some kinetic energy is transformed into other forms, so total kinetic energy decreases.
3. If the track is nearly frictionless and external impulse is negligible, total system momentum is still conserved.
4. The stuck-together final velocity is found from momentum conservation, not from kinetic-energy conservation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=4 and topic_code='4.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='afb06c4697a25326d3ea205b498cfb71';
update app.topic_explainers set
  core_idea = $q$- Rotational kinematics uses angular versions of familiar motion quantities.
- Angular displacement, angular velocity, and angular acceleration follow the same constant-acceleration structure as linear kinematics once an axis and sign convention are chosen.$q$,
  what_students_need_to_understand = $q$- Treat rotation as motion about a specified axis.
- A rigid object can be modeled as extended for one rotational question even if it was treated as a point object in a different motion context.
- AP Physics 1 limits direction descriptions to clockwise and counterclockwise with respect to the chosen axis.$q$,
  how_this_becomes_points = $q$1. Choose CW or CCW positive.
2. Keep radians in angular equations.
3. Use omega = omega0 + alpha t or theta = theta0 + omega0 t + 1/2 alpha t^2 with signs that match the convention.$q$,
  point_attaining_answer = $q$- Omega should be positive because the chosen convention says counterclockwise is positive.
- The sign comes from the stated axis and direction convention, not from a universal rule.
- If clockwise had been chosen positive, the same motion would have negative omega.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=5 and topic_code='5.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1b7066f7f5dac1b6c97a4615b68b03ae';
update app.topic_explainers set
  core_idea = $q$- Rigid objects share angular motion, not identical linear motion at every point.
- A point twice as far from the axis travels twice the arc length for the same angle.
- It has twice the tangential speed for the same omega.$q$,
  what_students_need_to_understand = $q$- Identify which point on the object is being described.
- Angular velocity and angular acceleration are common to all points in a rigid system.
- s, v, and tangential acceleration depend on that point distance r from the axis.$q$,
  how_this_becomes_points = $q$1. Select the correct radius.
2. Use s = r theta, v = r omega, and a_T = r alpha.
3. Avoid claims about total acceleration when only tangential acceleration is represented by r alpha.$q$,
  point_attaining_answer = $q$- They have the same angular speed, but not the same tangential speed.
- Using v = r omega, the mark at 2R has speed 2R omega, twice the speed R omega of the inner mark.
- Shared omega does not mean shared v.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=5 and topic_code='5.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f6c3d851705a8a300f91b5a41d403b7e';
update app.topic_explainers set
  core_idea = $q$- Torque depends on force, where the force is applied, and how much of the force is perpendicular to the radius from the axis.
- A force through the axis creates no torque because its lever arm is zero.$q$,
  what_students_need_to_understand = $q$- Draw rotational force diagrams with both force vectors and application points.
- AP Physics 1 expects torque magnitude and CW/CCW tendency.
- Torque direction as a vector is beyond this course scope.$q$,
  how_this_becomes_points = $q$1. Choose the axis.
2. Draw the line of action.
3. Find the perpendicular lever arm or F_perp.
4. Assign CW/CCW signs for a net-torque equation.$q$,
  point_attaining_answer = $q$- The torque is zero.
- The force line of action passes through the hinge, so the perpendicular lever arm is zero.
- Equivalently, the perpendicular component of the force relative to the radius is zero, so tau = rF_perp = 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=5 and topic_code='5.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='315e3e83c0a73897a51296c7761b3a64';
update app.topic_explainers set
  core_idea = $q$- Rotational inertia depends on both mass and distance from the rotation axis.
- For point masses, each contribution is m r^2, so moving mass farther from the axis can change I strongly.$q$,
  what_students_need_to_understand = $q$- Locate the axis before calculating.
- AP Physics 1 asks quantitative rotational inertia for systems of five or fewer point objects in a plane.
- Extended rigid-body formulas are supplied if needed, but qualitative mass-distribution reasoning is still expected.$q$,
  how_this_becomes_points = $q$1. Measure each radius from the actual axis.
2. Square that radius.
3. Sum m_i r_i^2.
4. Use parallel-axis reasoning only when the provided or known center-of-mass inertia is being shifted.$q$,
  point_attaining_answer = $q$1. The total is mR^2 + m(2R)^2 = 5mR^2.
2. Each mass uses its own distance from the axis, and the distance is squared.
3. The farther mass contributes four times as much as the mass at R.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=5 and topic_code='5.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d20fbe0abae4087941525f5d682a47d2';
update app.topic_explainers set
  core_idea = $q$- Rotational equilibrium is about torque balance, not force balance alone.
- If net torque is zero, angular velocity is constant; if the object was not rotating, it stays not rotating.$q$,
  what_students_need_to_understand = $q$- Separate translational equilibrium from rotational equilibrium.
- Net force zero controls center-of-mass acceleration.
- Net torque zero controls angular acceleration.
- A system can satisfy one condition without the other, depending on the forces and where they act.$q$,
  how_this_becomes_points = $q$1. Choose an axis.
2. Sum torques with CW/CCW signs.
3. Set sum tau = 0 for rotational equilibrium.
4. Separately write sum F = 0 only if translational equilibrium is required.$q$,
  point_attaining_answer = $q$- Not necessarily.
- The net force can be zero while the net torque is not zero if the forces have different lever arms or create torques in the same rotational sense.
- Rotational equilibrium requires sum tau = 0 about the axis, not just sum F = 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=5 and topic_code='5.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3c41786bbb5e5e5693dd0404d1aada2b';
update app.topic_explainers set
  core_idea = $q$- Net torque causes angular acceleration according to alpha = tau_net/I_sys.
- A larger net torque increases angular acceleration.
- A larger rotational inertia reduces it for the same torque.$q$,
  what_students_need_to_understand = $q$- Know when rotational analysis is independent from linear analysis.
- A rigid body can require a free-body diagram for translation and a torque equation about an axis for rotation.
- The same force may appear in both equations but with different roles.$q$,
  how_this_becomes_points = $q$1. Calculate net torque with signs.
2. Use the rotational inertia about the same axis.
3. Solve alpha = tau_net/I_sys.
4. If linear acceleration is involved, connect it only through valid constraints such as a_T = r alpha.$q$,
  point_attaining_answer = $q$- The angular acceleration is alpha = tau_net/I.
- With clockwise chosen positive, alpha = +tau/I.
- Mass alone is not the rotational resistance; the relevant quantity is rotational inertia about the axis.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=5 and topic_code='5.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d7bdf7ce566faa40f473671fc0ca4dc2';
update app.topic_explainers set
  core_idea = $q$- Rotational kinetic energy is energy stored in motion about an axis.
- For a rigid system, K_rot = 1/2 I omega^2.
- A system can also have translational kinetic energy of its center of mass.$q$,
  what_students_need_to_understand = $q$- Decide whether the object is translating, rotating, or both.
- A wheel rolling across a surface has center-of-mass kinetic energy and rotational kinetic energy.
- A disk spinning in place can have rotational kinetic energy even while its center of mass is at rest.$q$,
  how_this_becomes_points = $q$1. Include all relevant energy terms.
2. Use rotational inertia about the correct axis.
3. Do not replace a rotational term with a translational one.

In energy conservation, missing K_rot usually changes the final speed or height result.$q$,
  point_attaining_answer = $q$- Both terms appear: 1/2 mv_cm^2 for motion of the center of mass and 1/2 I omega^2 for rotation about the center.
- Rolling without slipping lets v_cm and omega be related, but it does not erase the rotational energy term.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=6 and topic_code='6.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c31d285b7e386fc2176ce988bb9f76f1';
update app.topic_explainers set
  core_idea = $q$- A torque transfers energy when it acts through angular displacement.
- Constant torque gives W = tau Delta theta.
- A varying torque requires the signed area under a torque-vs-angular-position graph.$q$,
  what_students_need_to_understand = $q$- Keep the rotational variables paired: torque with angular displacement, not force with angular displacement or torque with linear distance.
- Angular displacement must be in radians when used in W = tau Delta theta.$q$,
  how_this_becomes_points = $q$1. Identify the torque that acts through the stated angle.
2. Use signs consistently for work that adds or removes rotational energy.
3. Interpret graph area as work when torque changes with angle.$q$,
  point_attaining_answer = $q$- The work is W = tau Delta theta and is positive if counterclockwise is the positive rotational direction.
- The torque acts in the same sense as the angular displacement, so it transfers energy into the rotating system.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=6 and topic_code='6.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ea26c3cec9011910a7dbef0c983c968c';
update app.topic_explainers set
  core_idea = $q$- Angular momentum is measured about a selected axis or point.
- For a rigid rotating system, its magnitude can be L = I omega.
- For a moving object about a point, its magnitude can be L = rmv sin(theta).$q$,
  what_students_need_to_understand = $q$- Separate reference choice from object identity: the same moving object can have different angular momentum values about different points.
- Angular impulse is the change in angular momentum caused by torque over time, equal to area under a torque-vs-time graph.$q$,
  how_this_becomes_points = $q$1. Name the reference axis or point.
2. Choose L = I omega or L = rmv sin(theta) appropriately.
3. Use angular impulse = Delta L.

AP Physics 1 uses one-dimensional sign conventions here; vector direction of angular momentum is beyond scope.$q$,
  point_attaining_answer = $q$- The angular momentum magnitude about P is L = rmv sin(theta).
- At closest approach the radius from P to the puck is perpendicular to velocity, so L = dmv.
- The reference point matters because d is measured from P.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=6 and topic_code='6.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ebbf4da7d656040db2019b6fea156ae1';
update app.topic_explainers set
  core_idea = $q$- A system conserves total angular momentum about an axis when the net external torque about that axis is zero.
- Angular speed may still change if the system rotational inertia changes.$q$,
  what_students_need_to_understand = $q$- Define the system and distinguish internal interactions from external torques.
- Internal torques can change how angular momentum is shared among parts, but they cannot change the system total.
- A nonrigid system can spin faster as mass moves closer to the axis because I decreases while L remains constant.$q$,
  how_this_becomes_points = $q$1. Justify why external torque is zero or negligible.
2. Write L_initial = L_final for the chosen system.
3. Solve for a changed angular speed or rotation state without assuming I is constant.$q$,
  point_attaining_answer = $q$- The system angular momentum stays constant, but angular speed increases.
- Pulling the masses inward reduces rotational inertia, so omega must increase to keep total L = I omega constant for the chosen system.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=6 and topic_code='6.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0f89b6a4922687fd041507bbe206c476';
update app.topic_explainers set
  core_idea = $q$- Rolling motion combines center-of-mass translation with rotation about the center.
- Rolling without slipping creates constraints such as v_cm = r omega.
- Slipping means those direct quantitative relationships no longer hold.$q$,
  what_students_need_to_understand = $q$- Identify the rolling condition before applying formulas.
- For ideal rolling without slipping, static friction can enforce the motion without dissipating energy.
- During slipping, kinetic friction dissipates energy; AP Physics 1 expects qualitative explanation rather than precise slipping kinematics.$q$,
  how_this_becomes_points = $q$1. Include translational and rotational energy.
2. Apply v_cm = r omega only when rolling without slipping is stated or justified.
3. Explain qualitatively how slipping changes linear and angular motion.$q$,
  point_attaining_answer = $q$- Use omega = v_cm/R because rolling without slipping links center-of-mass speed and angular speed.
- The total kinetic energy still includes both 1/2 mv_cm^2 and 1/2 I omega^2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=6 and topic_code='6.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d9620585f9a3cf0feb8a900ca7970123';
update app.topic_explainers set
  core_idea = $q$- Satellite motion is analyzed as a gravitational system with energy and angular momentum.
- For a negligible-mass satellite around a massive central object, the central object can be treated as essentially fixed in AP Physics 1 models.$q$,
  what_students_need_to_understand = $q$- Distinguish circular and elliptical orbits.
- Circular: gravitational potential energy, kinetic energy, total mechanical energy, and angular momentum are constant.
- Elliptical: total mechanical energy and angular momentum are constant, but speed, kinetic energy, and gravitational potential energy change with position.$q$,
  how_this_becomes_points = $q$1. Choose the satellite-central-object system.
2. Use U_g = -Gm1m2/r with zero at infinite separation.
3. Apply conservation to the quantity that is actually constant.

Escape speed follows from setting total mechanical energy equal to zero.$q$,
  point_attaining_answer = $q$- Yes.
- In an elliptical orbit the total mechanical energy stays constant, but gravitational potential energy becomes more negative at smaller r.
- The kinetic energy increases so the sum K + U_g remains constant.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=6 and topic_code='6.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4351272afd6f9cd62bd03c85e279ee0a';
update app.topic_explainers set
  core_idea = $q$- SHM is not just repeated motion.
- It is the special case where displacement from equilibrium creates a restoring force back toward equilibrium.
- The restoring-force magnitude is proportional to how far the object is displaced.$q$,
  what_students_need_to_understand = $q$- A system can repeat without being SHM.
- To justify SHM, the force or torque must pull toward equilibrium and scale with displacement.
- For a spring, this leads to ma_x = -k delta x.
- For a small-angle pendulum, the restoring torque is proportional to angular displacement.$q$,
  how_this_becomes_points = $q$1. Name equilibrium.
2. Assign displacement from that equilibrium.
3. Explain the restoring interaction with the correct direction and proportionality.

The negative sign means acceleration points opposite displacement, not merely that the object is moving left.$q$,
  point_attaining_answer = $q$- The spring force must be a restoring force: when the cart is to the right of equilibrium, the force is to the left.
- Its magnitude is proportional to the displacement from equilibrium. That is the SHM condition.
- The back-and-forth motion alone is not enough; the force relationship is what makes the motion simple harmonic.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=7 and topic_code='7.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5485f158eff3ecbe52dfed0994877bff';
update app.topic_explainers set
  core_idea = $q$- Period and frequency are reciprocals: T = 1/f.
- The period depends on the system model.
- Spring-object oscillator: T_s = 2 pi sqrt(m/k).
- Small-angle pendulum: T_p = 2 pi sqrt(L/g).$q$,
  what_students_need_to_understand = $q$- Choose the formula from the physical oscillator, not from whatever variables appear in the prompt.
- A heavier spring-object oscillator has a longer period; a stiffer spring has a shorter period.
- A longer small-angle pendulum has a longer period.
- Amplitude is not part of either ideal SHM period formula.$q$,
  how_this_becomes_points = $q$1. Identify one full cycle.
2. Convert between T and f.
3. Use proportional reasoning from the correct period equation.

If the question asks what happens when a variable changes, the formula should drive the comparison.$q$,
  point_attaining_answer = $q$1. For a spring-object oscillator, T_s = 2 pi sqrt(m/k).
2. If m becomes 4m and k is unchanged, the square-root factor becomes sqrt(4m/k) = 2 sqrt(m/k).
3. The period doubles, not quadruples.

The square root in the period formula is the scoring detail.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=7 and topic_code='7.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='12f7388419974e2151f0c7f7b4d9abf9';
update app.topic_explainers set
  core_idea = $q$- SHM graphs carry position, timing, and force information at once.
- Position varies sinusoidally; amplitude is maximum displacement from equilibrium; period is the time for one full repeat.
- Velocity and acceleration have predictable zeros and extrema during the cycle.$q$,
  what_students_need_to_understand = $q$- Read the graph as motion, not as decoration.
- At maximum displacement, velocity is zero and acceleration has maximum magnitude toward equilibrium.
- At equilibrium, displacement is zero, acceleration is zero for ideal SHM, and speed is maximum.
- Changing amplitude changes maximum displacement and speed/energy, not the period.$q$,
  how_this_becomes_points = $q$1. Identify amplitude and period from the graph.
2. Map maxima/minima/zeros to physical states.
3. Explain signs from displacement relative to equilibrium.

Many wrong answers treat taller waves as slower waves instead of reading the horizontal cycle spacing.$q$,
  point_attaining_answer = $q$- The periods are the same because the horizontal spacing between identical points in the cycle is the same.
- For ideal SHM of the same spring-object system, changing amplitude does not change the period.
- The larger-amplitude motion has greater total energy and can have greater maximum speed, but the cycle time is unchanged.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=7 and topic_code='7.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='40ae75df13e38f07a9a3676f943605d9';
update app.topic_explainers set
  core_idea = $q$- Energy in ideal SHM is conserved while changing form.
- At turning points the oscillator has maximum potential energy and zero kinetic energy.
- At equilibrium, kinetic energy is maximum and spring potential energy is minimum.$q$,
  what_students_need_to_understand = $q$- Avoid treating momentary rest as energy loss; when speed is zero at a turning point, the energy is stored as potential energy.
- For a spring-object oscillator, total energy equals 1/2 k A^2.
- Changing amplitude changes total energy even though it does not change period.$q$,
  how_this_becomes_points = $q$1. Apply total-energy conservation to compare positions in the cycle.
2. Identify where K and U are maximum or minimum.
3. Use E_total = 1/2 k A^2 for spring-object amplitude comparisons.$q$,
  point_attaining_answer = $q$1. For a spring-object oscillator, E_total = 1/2 k A^2.
2. If amplitude becomes 2A, the total energy becomes 1/2 k (2A)^2 = 4(1/2 k A^2).
3. The energy quadruples.

The squared amplitude is the key point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=7 and topic_code='7.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='539e07903a0bf3162b49e82f7a1b7207';
update app.topic_explainers set
  core_idea = $q$- Density links matter to volume.
- The fluid model starts by deciding what shape and compressibility assumptions are allowed.
- In AP Physics 1, an ideal fluid must be treated as both incompressible and nonviscous.$q$,
  what_students_need_to_understand = $q$- Distinguish a material property from an object size.
- Density is mass divided by volume, so two samples of the same uniform material can have different masses and volumes but the same density.
- Ideal-fluid assumptions let later pressure and flow equations ignore volume compression and viscous energy losses.$q$,
  how_this_becomes_points = $q$1. Write rho = m/V with correct units.
2. Recognize that liquids and gases have no fixed shape.
3. Explicitly name both ideal-fluid assumptions before using equations that depend on them.$q$,
  point_attaining_answer = $q$- The densities are the same if the liquid is uniform.
- Density is rho = m/V, so doubling both mass and volume leaves the ratio unchanged.
- More mass alone is not enough; density compares mass to volume.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=8 and topic_code='8.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a7284a0cf4d84ed37dee62b0e4377b35';
update app.topic_explainers set
  core_idea = $q$- Pressure is force spread over area, using only the force component perpendicular to the surface.
- In a fluid at rest, pressure at a point depends on reference pressure plus rho gh below that reference level.
- Gauge pressure reports only the rho gh part.$q$,
  what_students_need_to_understand = $q$- Treat pressure as a scalar even though it creates forces on surfaces.
- Larger depth or larger fluid density increases hydrostatic pressure.
- An incompressible fluid has constant volume and density even when pressure changes, so pressure change does not automatically mean density change.$q$,
  how_this_becomes_points = $q$1. Select F_perp.
2. Use area in the denominator.
3. Identify whether absolute or gauge pressure is requested.
4. Measure depth vertically from the chosen reference level.$q$,
  point_attaining_answer = $q$1. Pressure is force per area, so the force magnitude is F = PA = (P0 + rho gh)A if absolute pressure is acting on that side.
2. If the question asks only for the extra force due to the water column compared with atmosphere, the gauge part is rho gh A.
3. The area must be included to convert pressure to force.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=8 and topic_code='8.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c38a3a96127fb8ea621a3dc3aa250ca4';
update app.topic_explainers set
  core_idea = $q$- Fluids exert forces that fit Newton's laws.
- The buoyant force is an upward net force from pressure differences in the fluid.
- Its magnitude equals the weight of the displaced fluid: F_b = rho_fluid V_displaced g.$q$,
  what_students_need_to_understand = $q$- Avoid treating buoyancy as a property of the object alone.
- The surrounding fluid density and displaced fluid volume determine the buoyant force.
- The object weight still depends on the object mass, so floating, sinking, and accelerating depend on the net force comparison.$q$,
  how_this_becomes_points = $q$1. Draw a force diagram.
2. Identify the displaced volume.
3. Use the fluid density in F_b.
4. Apply Newton's second law to the chosen object or system.

Equilibrium means net force is zero; acceleration means the force difference is not zero.$q$,
  point_attaining_answer = $q$- The buoyant force equals the weight of the displaced water: F_b = rho_water V_displaced g.
- The block being at rest tells you the net force is zero after including weight and string force.
- It does not make buoyant force equal to the block weight unless the other forces and densities make that true.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=8 and topic_code='8.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8c6b18f894b35594e9cfe4e3d4160b18';
update app.topic_explainers set
  core_idea = $q$- For ideal incompressible flow in a filled tube, continuity says volume flow rate is conserved, so A1 v1 = A2 v2.
- Bernoulli applies conservation of mechanical energy along the flow using pressure, gravitational potential energy per volume, and kinetic energy per volume.$q$,
  what_students_need_to_understand = $q$- Choose which conservation law answers the question.
- Continuity links area and speed; Bernoulli links pressure, height, and speed.
- Torricelli's result follows from energy conservation for fluid exiting from a height difference.
- The CED boundary assumes ideal fluids and completely filled pipes unless the prompt says otherwise.$q$,
  how_this_becomes_points = $q$1. Check assumptions.
2. Match two points in the same flow.
3. Keep height references consistent.
4. Do not use a single shortcut such as faster means lower pressure unless height and energy terms have been accounted for.$q$,
  point_attaining_answer = $q$1. Continuity requires A1 v1 = A2 v2 for incompressible flow.
2. With A1 = 2A, v1 = v, and A2 = A, the narrow-section speed is v2 = 2v.
3. The same volume per time must pass through each cross section, so smaller area means larger speed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Physics 1 units 1-8): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_physics_1' and unit_number=8 and topic_code='8.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f00327ba5f321fd22dc9863d22679c96';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_physics_1' and topic_code in ('1.1','1.2','1.3','1.4','1.5','2.1','2.2','2.3','2.4','2.5','2.6','2.7','2.8','2.9','3.1','3.2','3.3','3.4','3.5','4.1','4.2','4.3','4.4','5.1','5.2','5.3','5.4','5.5','5.6','6.1','6.2','6.3','6.4','6.5','6.6','7.1','7.2','7.3','7.4','8.1','8.2','8.3','8.4') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>43 then raise exception 'expected 43 rows updated'; end if; end $$;
commit;
