-- AP Physics 1: Algebra-Based, Units 1-3, new-content-creation-protocol batch — MCQs.
-- Companion to 20260808_apphy1_newprotocol_units1-3_frq_batch.sql (see that
-- file's header for provenance, grounding sources, and the "NOT YET RUN"
-- verification checklist — the same three pre-run checks apply here).
--
-- Every distractor below traces to a specific documented misconception,
-- exclusion/boundary statement, or common algebra error surfaced in the
-- research: the ~50% failure rate on vertical-loop normal-force direction
-- (2024 CRR), the static-vs-kinetic friction equality/inequality distinction
-- (CED 2.7), the 1-D-only relative-velocity restriction (CED 1.4), the
-- gravity-only action-at-a-distance restriction (CED 2.3), the g=10 vs 9.8/
-- 9.81 no-penalty rule (CED 1.3), the nonuniform-acceleration
-- qualitative-only scope (CED 1.3), the constant-force-only cosine work
-- formula vs. a dot-product misconception (CED 3.2), the conservative/
-- nonconservative path-(in)dependence distinction (CED 3.2), and the
-- documented delta-K = (1/2)m(delta v)^2 algebra error (2024 CRR, Q1/Q2
-- sample responses) in place of the correct delta-K = (1/2)m*delta(v^2).
--
-- Hand-verified computations (MCQs requiring numeric computation):
--   MCQ5: N=(10kg)(10)=100N, max static friction=(0.5)(100)=50N; applied
--     force 25N < 50N, so the crate stays static and friction = 25N
--     (balances the applied force, not the max value); kinetic value
--     (0.3)(100)=30N is a distractor since the crate is not moving.
--   MCQ7: W=Fd*cos(theta)=(20)(3)*cos(40deg)=(60)(0.766)=45.96J~=46J;
--     sin(40deg)=0.643 distractor gives (60)(0.643)=38.6J.
--   MCQ9: KE_i=(1/2)(2)(3)^2=9J, KE_f=(1/2)(2)(5)^2=25J, delta-K=16J;
--     misconception formula (1/2)(2)(5-3)^2=4J is the distractor.
--   MCQ10: P=Fv=(40)(6)=240W.
--
-- Content-key scheme: apphy1-mcq-np1-001..010.
-- All items inserted as status='draft'. content_review_assignments created
-- in the companion assignment script
-- (20260808_apphy1_newprotocol_assign_saood.sql).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy1-newprotocol-units1-3-mcq-batch-20260808'));

do $$
declare
  v_epv_id uuid;
begin
  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs e on e.id = epv.exam_pack_id
  where e.exam_name = 'AP Physics 1';

  if v_epv_id is null then
    raise exception 'no_exam_pack_version_found:AP Physics 1';
  end if;

  if exists (select 1 from app.content_items where content_key like 'apphy1-mcq-np1-%') then
    raise exception 'batch_already_seeded:apphy1-mcq-np1';
  end if;

  create temporary table np1_mcq_epv (epv_id uuid) on commit drop;
  insert into np1_mcq_epv values (v_epv_id);
end $$;

-- MCQ 1 — Unit 1 — nonuniform acceleration: qualitative-only scope — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-001', 'mcq', 'Scope of Nonuniform Acceleration Analysis', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'An object''s acceleration-time graph shows the acceleration increasing linearly with time (nonuniform acceleration). According to the AP Physics 1 course framework, which of the following is a student expected to be able to do for this situation?',
    md5('apphy1-mcq-np1-001'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Calculate the exact instantaneous velocity at a given time using integration of the acceleration function.', false, 'AP Physics 1 is algebra-based; calculus techniques such as integration are never required or expected on this exam.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Qualitatively sketch a velocity-time graph that is consistent with the given acceleration-time graph.', true, 'The CED states students are not expected to quantitatively analyze nonuniform acceleration, but are expected to qualitatively analyze, sketch, and discuss such situations.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Determine an exact algebraic equation for velocity as a function of time using the three constant-acceleration kinematic equations.', false, 'The three kinematic equations (v=v0+at, etc.) apply only to constant-acceleration situations; they cannot be used directly for nonuniform acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Treat the acceleration as effectively zero for the purposes of analysis.', false, 'Nonuniform acceleration is nonzero and changing; treating it as zero would misrepresent the given situation entirely.' from version_ins;

-- MCQ 2 — Unit 1 — g=10 vs 9.8/9.81 no-penalty policy — easy
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-002', 'mcq', 'Policy on the Value Used for g', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'On a free-response question requiring a numerical answer, a student uses g = 9.8 m/s^2 instead of g = 10 m/s^2 for all calculations, and carries this value through correctly and consistently. What is the effect on the student''s score for that question?',
    md5('apphy1-mcq-np1-002'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A one-point deduction is applied for using an incorrect constant.', false, 'AP Physics 1 does not penalize the use of the more precise value; there is no deduction for this choice.' from version_ins
union all select gen_random_uuid(), id, 'B', 'No penalty is applied; both g = 10 m/s^2 and the more precise values g = 9.8 m/s^2 or 9.81 m/s^2 are acceptable.', true, 'The CED explicitly states that while g=10 m/s^2 is used for all situations requiring a numerical value, students will not be penalized for correctly using the more precise commonly accepted values of 9.8 or 9.81 m/s^2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Full credit is awarded only if the final numeric answer is rounded to match the result obtained using g = 10 m/s^2.', false, 'There is no requirement to match the g=10 result; a correctly and consistently carried-through 9.8 or 9.81 value is fully acceptable on its own terms.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The response is disqualified from earning credit on that question.', false, 'This is far too severe; the CED explicitly permits either value with no penalty.' from version_ins;

-- MCQ 3 — Unit 1 — relative velocity restricted to one dimension — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-003', 'mcq', 'Scope of Relative-Velocity Vector Addition', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'According to the AP Physics 1 course framework, adding or subtracting velocity vectors to find an object''s velocity as measured from a different reference frame (e.g., a boat''s velocity relative to the ground, given the boat''s velocity relative to the water and the water''s velocity relative to the ground) is a skill that is:',
    md5('apphy1-mcq-np1-003'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Required in full two-dimensional generality, including cases where the two velocities are not along the same line.', false, 'The CED explicitly restricts this skill to one dimension for AP Physics 1, not full 2-D generality.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Restricted to situations in which the velocities being combined are along the same one-dimensional line.', true, 'The CED states that adding or subtracting vectors to find relative velocities is restricted to motion along one dimension for AP Physics 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Not covered at all in the AP Physics 1 course.', false, 'This skill is covered by the CED (Topic 1.4); it is restricted in scope to one dimension, not excluded entirely.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Tested only using calculus-based vector methods.', false, 'AP Physics 1 is algebra-based; no calculus-based vector methods are used anywhere in this course.' from version_ins;

-- MCQ 4 — Unit 2 — normal force direction at the top of a vertical loop (documented ~50% failure rate) — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-004', 'mcq', 'Direction of the Normal Force at the Top of a Vertical Loop', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A ball moves along the inside of a vertical circular track. At the instant the ball is at the top of the loop, what is the direction of the normal force exerted by the track on the ball?',
    md5('apphy1-mcq-np1-004'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Upward, away from the center of the loop.', false, 'This is a documented, common error (only about half of students correctly identify the direction in this exact scenario per the 2024 Chief Reader Report) that comes from over-generalizing the flat-surface habit of "normal force points up" to a curved track, where it does not apply.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Downward, toward the center of the loop.', true, 'At the top of the loop, the center of the circular path is below the ball, and the inside surface of the track can only push the ball away from the track surface — that is, downward, toward the center.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Horizontal, tangent to the loop at that point.', false, 'A normal force is, by definition, perpendicular to the surface of contact, not tangent to it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Zero, regardless of the ball''s speed at the top.', false, 'The normal force is only exactly zero at the minimum speed required to maintain contact; at any higher speed, the normal force is nonzero.' from version_ins;

-- MCQ 5 — Unit 2 — static friction as an inequality, not always at its maximum value — hard
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-005', 'mcq', 'Static Friction Below Its Maximum Value', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A 10 kg crate rests on a horizontal floor. The coefficient of static friction between the crate and the floor is 0.5, and the coefficient of kinetic friction is 0.3. A horizontal force of 25 N is applied to the crate, and the crate remains at rest. Use g = 10 m/s^2. What is the magnitude of the static friction force acting on the crate?',
    md5('apphy1-mcq-np1-005'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50 N', false, 'This is the maximum possible static friction force (mu_s * N = (0.5)(100) = 50 N), but static friction is an inequality (F_f,s <= mu_s*N), not always equal to this maximum — a common error that treats static friction as though it always takes on its largest possible value.' from version_ins
union all select gen_random_uuid(), id, 'B', '25 N', true, 'Because the crate remains at rest, it is in equilibrium, so static friction must exactly balance the applied force: 25 N. This is below the maximum possible static friction (50 N), consistent with the CED''s inequality relation F_f,s <= mu_s*N.' from version_ins
union all select gen_random_uuid(), id, 'C', '30 N', false, 'This is the kinetic friction force (mu_k * N = (0.3)(100) = 30 N), which does not apply here since the crate is not moving relative to the floor.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 N', false, 'Static friction cannot be zero here; without a friction force, the unbalanced 25 N applied force would cause the crate to accelerate, contradicting the given information that the crate remains at rest.' from version_ins;

-- MCQ 6 — Unit 2 — action-at-a-distance restricted to gravity in AP Physics 1 — easy
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-006', 'mcq', 'Scope of Noncontact Forces in AP Physics 1', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'According to the AP Physics 1 course framework, interactions between objects or systems that are not in contact (action-at-a-distance forces) are restricted, on the AP Physics 1 Exam, to:',
    md5('apphy1-mcq-np1-006'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Gravitational forces only.', true, 'The CED states that the interaction between objects or systems at a distance is limited to gravitational forces in AP Physics 1; electric and magnetic forces are considered in AP Physics 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Gravitational and electric forces.', false, 'Electric forces at a distance are part of AP Physics 2, not AP Physics 1, according to the CED.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Gravitational, electric, and magnetic forces.', false, 'Only gravitational action-at-a-distance forces are within scope for AP Physics 1; electric and magnetic forces belong to AP Physics 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Electric forces only.', false, 'Electric forces are not the action-at-a-distance force considered in AP Physics 1 — gravitational force is.' from version_ins;

-- MCQ 7 — Unit 2/3 boundary — work done by a constant force at an angle, cosine formula — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-007', 'mcq', 'Work Done by a Constant Force Applied at an Angle', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A 5 kg box is pulled across a horizontal floor a distance of 3 m by a constant force of 20 N directed at 40 degrees above the horizontal. Use cos(40 deg) = 0.766 and sin(40 deg) = 0.643. What is the work done on the box by this 20 N force?',
    md5('apphy1-mcq-np1-007'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 J', false, 'This is F*d with no angle factor at all (20 N x 3 m), which ignores that only the component of force parallel to the displacement does work.' from version_ins
union all select gen_random_uuid(), id, 'B', '46 J', true, 'W = F*d*cos(theta) = (20 N)(3 m)(0.766) = 45.96 J, which rounds to approximately 46 J. Only the horizontal (parallel-to-displacement) component of the force does work.' from version_ins
union all select gen_random_uuid(), id, 'C', '38.6 J', false, 'This uses sin(40 deg) instead of cos(40 deg): (20)(3)(0.643) = 38.6 J. The parallel component of a force at an angle theta above the displacement direction uses cosine, not sine.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 J', false, 'This is incorrect; the force has a nonzero component parallel to the displacement (since 40 degrees is not 90 degrees), so nonzero work is done.' from version_ins;

-- MCQ 8 — Unit 3 — path-(in)dependence of conservative vs. nonconservative forces — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-008', 'mcq', 'Path Dependence of the Work Done by Friction', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'An object moves between two fixed points on a rough horizontal surface. Which of the following statements correctly describes the work done on the object by friction, according to the AP Physics 1 course framework?',
    md5('apphy1-mcq-np1-008'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is path-independent, like the work done by gravity between the same two points.', false, 'Friction is explicitly named in the CED as a nonconservative force, and nonconservative-force work is path-dependent — unlike gravity, which is conservative and path-independent.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It depends on the specific path taken between the two points.', true, 'The CED states that the work done by a nonconservative force is path-dependent, and explicitly names friction and air resistance as examples of nonconservative forces.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is always zero if the object returns to its exact starting point.', false, 'This zero-net-work-on-a-closed-loop property applies to conservative forces, not to friction; friction removes mechanical energy regardless of whether the object returns to its start.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It can be associated with a potential energy function, the same way gravity is associated with gravitational potential energy.', false, 'The CED states that potential energies are associated only with conservative forces; since friction is nonconservative, no potential energy function can be defined for it.' from version_ins;

-- MCQ 9 — Unit 3 — correct change-in-kinetic-energy formula vs. the documented (1/2)m(delta v)^2 error — medium
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-009', 'mcq', 'Change in Kinetic Energy for a Changing Speed', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A 2 kg object''s speed increases from 3 m/s to 5 m/s. What is the change in the object''s kinetic energy?',
    md5('apphy1-mcq-np1-009'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4 J', false, 'This results from incorrectly computing (1/2)m(delta v)^2 = (1/2)(2)(5-3)^2 = 4 J — a documented error pattern that squares the change in speed instead of correctly finding the difference of the squared speeds.' from version_ins
union all select gen_random_uuid(), id, 'B', '16 J', true, 'Delta-K = K_f - K_i = (1/2)(2)(5)^2 - (1/2)(2)(3)^2 = 25 J - 9 J = 16 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '25 J', false, 'This is only the final kinetic energy, (1/2)(2)(5)^2 = 25 J; it omits subtracting the initial kinetic energy to find the change.' from version_ins
union all select gen_random_uuid(), id, 'D', '9 J', false, 'This is only the initial kinetic energy, (1/2)(2)(3)^2 = 9 J, not the change in kinetic energy.' from version_ins;

-- MCQ 10 — Unit 3 — instantaneous power for a constant force parallel to velocity — easy
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apphy1-mcq-np1-010', 'mcq', 'Instantaneous Power from a Constant Parallel Force', 'draft'
  from np1_mcq_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1,
    'A cyclist exerts a constant force of 40 N parallel to the direction of motion while traveling at an instantaneous speed of 6 m/s along a flat, straight road. What is the instantaneous power output at that moment?',
    md5('apphy1-mcq-np1-010'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '240 W', true, 'For a constant force parallel to velocity, instantaneous power is P = F*v = (40 N)(6 m/s) = 240 W.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.67 W', false, 'This results from dividing force by speed (40/6) instead of multiplying, which does not correspond to the power formula P=Fv.' from version_ins
union all select gen_random_uuid(), id, 'C', '480 W', false, 'This is double the correct value, as if the formula included an extra factor of 2 (2Fv) that does not appear in P=Fv.' from version_ins
union all select gen_random_uuid(), id, 'D', '34 W', false, 'This results from subtracting speed from force (40-6), which is dimensionally meaningless and does not correspond to the power formula.' from version_ins;

commit;
