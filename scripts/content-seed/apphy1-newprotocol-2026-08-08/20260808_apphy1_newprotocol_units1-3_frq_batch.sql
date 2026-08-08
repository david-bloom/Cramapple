-- AP Physics 1: Algebra-Based, Units 1-3, new-content-creation-protocol batch — FRQs.
--
-- Owner instruction, 2026-08-08: update the Physics 1 CED (David supplied the
-- full 220-page primary-source CED PDF for the first time this session) and
-- author 10 FRQs + 10 MCQs for Units 1-3 (Kinematics; Force and Translational
-- Dynamics; Work, Energy, and Power) using the new content-authoring protocol
-- against the newly-deepened CED fact pack
-- (docs/product/AP_PHYSICS_1_CED_FACT_PACK.md, "Units 1-3 deep-tier detail"
-- section, added same day). Assigned to Muhammad Saood for review.
--
-- Provenance note (protocol §7.1, P0-A gap): the schema has no
-- authoring-model/fact-pack-hash column, so authorship provenance is recorded
-- here instead. Authoring model: Claude (this session). Grounded against: the
-- full CED PDF pages 21-74 (Units 1-3 unit guides, read via 3 parallel
-- research passes), the 2024 AP Physics 1 Scoring Guidelines, the 2024 Chief
-- Reader Report, the 2024/2026 released FRQ booklets, and the 2024 Q1/Q2
-- Sample Student Responses booklets (all David-supplied primary-source PDFs,
-- read directly). Every FRQ below was independently hand-computed and
-- verified by direct calculation before insertion (not merely "looks
-- plausible") — see the worked verification for each item in this header:
--
--   FRQ1 (Unit 1, uniform accel then constant v): v=12 m/s, x1=36m, x2=48m,
--     total=84m.
--   FRQ2 (Unit 1, v-t graph, linear decel 4->0 m/s over 4s then flat): a=-1
--     m/s^2, displacement=8m (triangle area), x-t concave-down then flat,
--     a=0 for t=4-6s.
--   FRQ3 (Unit 1, horizontal projectile, v0=8 m/s, h=20m, g=10): t=2s,
--     x=16m, vy=20 m/s.
--   FRQ4 (Unit 2, F=20N pulls 5kg block, mu_k=0.2, g=10): N=50N, f=10N,
--     F_net=10N, a=2 m/s^2.
--   FRQ5 (Unit 2, 4kg frictionless incline at 30 deg, g=10): F_parallel=20N,
--     N=F_perp=34.64N, a=5 m/s^2 (=g sin30).
--   FRQ6 (Unit 2, vertical loop r=1.5m, g=10 -- targets the documented ~50%
--     failure rate on normal-force direction at the loop top): v_min=sqrt(15)
--     ~=3.87 m/s, N=0 at v_min, N direction at top is downward (toward
--     center), N increases above zero if v > v_min.
--   FRQ7 (Unit 2, frictionless banked curve, r=50m, theta=20deg, g=10 --
--     explicitly in-scope per the CED's banked-curve boundary statement):
--     tan(theta)=v^2/(rg) => v^2=rg*tan(20deg)=500*0.36397=181.98,
--     v~=13.49 m/s; above this speed the car slides up/outward without
--     friction.
--   FRQ8 (Unit 3, 3kg box v0=4 m/s, F=15N over d=5m, friction=6N opposing):
--     W_applied=75J, W_friction=-30J, W_net=45J, KE_i=24J, KE_f=69J,
--     v_f=sqrt(2*69/3)=sqrt(46)~=6.78 m/s.
--   FRQ9 (Unit 3, spring k=200 N/m compressed 0.3m launches 2kg block up a
--     frictionless incline, g=10): U_s=0.5*200*0.09=9J, v=3 m/s (from
--     0.5*2*v^2=9), h=9/(2*10)=0.45m.
--   FRQ10 (Unit 3, 1000kg elevator, constant v=2 m/s, 80% motor efficiency,
--     g=10): F=mg=10000N, P_out=20000W, P_in=20000/0.8=25000W.
--
-- Content-key scheme: apphy1-frq-np1-001..010 ("np1" = Physics 1's first
-- new-protocol batch), distinct from any legacy apphy1-* keys.
--
-- IMPORTANT — NOT YET RUN. This script has not been executed. Before running:
--   1. Verify the exam_name string in app.exam_packs actually matches
--      'AP Physics 1' (or whatever the live value is) — not re-confirmed
--      this session due to a Supabase MCP auth lapse.
--   2. Verify the content_key prefix 'apphy1-' matches the live corpus
--      (recalled from earlier session context, not re-queried this session).
--   3. Verify Muhammad Saood is a qualified reviewer for AP Physics 1 in
--      validator_qualifications before running the companion assignment
--      script.
--
-- All items inserted as status='draft' (not published). A
-- content_review_assignment is created per item in the companion assignment
-- script, assigned to Muhammad Saood, review_stage='tutor_question'.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy1-newprotocol-units1-3-frq-batch-20260808'));

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

  if exists (
    select 1 from app.content_items
    where content_key like 'apphy1-frq-np1-%' or content_key like 'apphy1-mcq-np1-%'
  ) then
    raise exception 'batch_already_seeded:apphy1-np1';
  end if;

  create temporary table np1_epv (epv_id uuid) on commit drop;
  insert into np1_epv values (v_epv_id);
end $$;

-- =============================================================================
-- FRQ 1 — apphy1-frq-np1-001 — Unit 1 (constant accel then constant velocity) — easy
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-001', 'frq',
    'Two-Phase Motion: Uniform Acceleration then Constant Velocity', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Calculate the car''s velocity at t = 6 s.

(b) Calculate the car''s displacement during the first 6 s.

(c) Calculate the car''s displacement during the next 4 s, while it travels at constant velocity.

(d) Calculate the car''s total displacement over the full 10 s.',
    'A car starts from rest and accelerates uniformly at 2 m/s^2 for 6 s. It then travels at the constant velocity it reached for an additional 4 s.',
    md5('apphy1-frq-np1-001'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes v = 12 m/s at t = 6 s using v = v0 + at.', 1,
  'Response substitutes v0=0, a=2 m/s^2, t=6s into v=v0+at to get v=12 m/s.',
  'Show the substituted expression v = 0 + (2)(6) before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the first-phase displacement as 36 m using x = x0 + v0t + (1/2)at^2.', 1,
  'Response substitutes x0=0, v0=0, a=2 m/s^2, t=6s into the kinematic equation to get x=36 m.',
  'Show the substituted expression x = 0 + 0 + (1/2)(2)(6)^2 before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the second-phase displacement as 48 m, using the velocity found in part (a) and constant-velocity motion.', 1,
  'Response uses v=12 m/s from part (a) and multiplies by t=4s to get x=48 m, recognizing this phase has zero acceleration.',
  'Explicitly use the velocity value carried over from part (a), not a newly assumed value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly sums the two displacements to get a total of 84 m.', 1,
  'Response adds 36 m + 48 m = 84 m.', 'Show both displacement values being added together explicitly.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 2 — apphy1-frq-np1-002 — Unit 1 (v-t graph to x-t graph, nonuniform accel scope) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-002', 'frq',
    'From a Velocity-Time Graph to Acceleration and Position Behavior', 'draft', 'short', 'targeted_drill', 'translation_between_representations'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Calculate the object''s acceleration during the interval 0 <= t <= 4 s.

(b) Calculate the object''s displacement during the interval 0 <= t <= 4 s.

(c) Describe the shape of the object''s position-time graph over the full 0 <= t <= 6 s interval, and explain your reasoning.

(d) State the object''s acceleration during the interval 4 s <= t <= 6 s.',
    'A velocity-time graph shows an object''s velocity decreasing linearly from 4 m/s at t = 0 s to 0 m/s at t = 4 s. From t = 4 s to t = 6 s, the object''s velocity remains constant at 0 m/s.',
    md5('apphy1-frq-np1-002'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes a = -1 m/s^2 using the slope of the v-t graph over 0-4s.', 1,
  'Response computes (0-4)/(4-0) = -1 m/s^2 as the slope of the given segment.',
  'Show the slope calculation (change in v)/(change in t) explicitly.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the displacement as 8 m using the area under the v-t graph (triangle) for 0-4s.', 1,
  'Response computes the triangular area (1/2)(4)(4) = 8 m under the velocity-time graph for this interval.',
  'Identify the region as a triangle and show the (1/2)(base)(height) computation.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly describes the position-time graph as concave down (curving, with decreasing slope) from t=0 to t=4s, becoming a horizontal flat line from t=4s to t=6s, with reasoning tied to the velocity/slope relationship.', 1,
  'Response explains that since velocity (the slope of the x-t graph) is positive but decreasing during 0-4s, the x-t graph rises but curves downward (concave down), and since velocity is zero and constant from 4-6s, the x-t graph is flat (constant position) over that interval.',
  'Connect the x-t graph shape explicitly to the given v-t behavior (decreasing positive slope, then zero slope), not just describe a generic curve.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly states a = 0 for 4 s <= t <= 6 s, since velocity is constant (zero slope on the v-t graph) over that interval.', 1,
  'Response states the acceleration is zero because the velocity is constant (unchanging) during this interval.',
  'State the reasoning that constant velocity implies zero acceleration, not just the numeric answer.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 3 — apphy1-frq-np1-003 — Unit 1 (horizontal projectile motion) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-003', 'frq',
    'Horizontal Projectile Launched from a Height', 'draft', 'short', 'targeted_drill', 'qualitative_quantitative_translation'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2.

(a) Calculate the time the ball is in the air before landing.

(b) Calculate the horizontal distance the ball travels before landing.

(c) Calculate the vertical component of the ball''s velocity the instant before it lands.

(d) The ball''s horizontal velocity is 8 m/s at launch and remains 8 m/s the instant before landing. Explain, in terms of the forces acting on the ball, why the horizontal velocity does not change during the flight.',
    'A ball is launched horizontally with an initial speed of 8 m/s from a height of 20 m above the ground. Air resistance is negligible.',
    md5('apphy1-frq-np1-003'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the fall time as 2 s, using the vertical kinematic equation with v0y = 0.', 1,
  'Response substitutes 20 = (1/2)(10)t^2 and solves t^2=4, t=2 s.',
  'Show the substituted vertical kinematic equation before solving for t.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the horizontal distance as 16 m, using x = v0x * t with the time from part (a).', 1,
  'Response multiplies the given horizontal speed 8 m/s by t=2s (carried from part a) to get x=16 m.',
  'Explicitly use the time value from part (a), not a newly assumed value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the vertical velocity at landing as 20 m/s, using vy = gt with the time from part (a).', 1,
  'Response substitutes g=10 m/s^2 and t=2s (from part a) into vy=gt to get vy=20 m/s.',
  'Show the substituted expression vy = (10)(2) before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly explains that horizontal velocity is unchanged because there is no horizontal force (and therefore no horizontal acceleration) acting on the ball once launched, since air resistance is negligible and gravity acts only vertically.', 1,
  'Response explicitly identifies that the only force acting during flight is gravity, which is purely vertical, so there is zero net horizontal force and therefore zero horizontal acceleration, leaving horizontal velocity constant.',
  'State explicitly that gravity is a vertical-only force and that zero net horizontal force means zero horizontal acceleration — a bare assertion that "horizontal and vertical motion are independent" without this reasoning does not earn the point.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 4 — apphy1-frq-np1-004 — Unit 2 (Newton's second law with kinetic friction) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-004', 'frq',
    'Newton''s Second Law with Kinetic Friction on a Horizontal Surface', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2.

(a) Calculate the magnitude of the normal force exerted on the block by the surface.

(b) Calculate the magnitude of the kinetic friction force acting on the block.

(c) Calculate the net force acting on the block in the horizontal direction.

(d) Calculate the magnitude of the block''s acceleration.',
    'A 5 kg block on a horizontal surface is pulled by a horizontal applied force of 20 N. The coefficient of kinetic friction between the block and the surface is 0.2, and the block is already moving.',
    md5('apphy1-frq-np1-004'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the normal force as 50 N, recognizing it balances gravity on this horizontal surface with no vertical applied-force component.', 1,
  'Response computes N = mg = (5)(10) = 50 N.', 'Show the substituted expression N = mg before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the kinetic friction force as 10 N, using the equality F_f,k = mu_k * N with the normal force from part (a).', 1,
  'Response computes F_f,k = (0.2)(50) = 10 N, using the kinetic friction relation as an equality (not an inequality, since the block is moving).',
  'Use the normal force value carried over from part (a) explicitly.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the net horizontal force as 10 N, by subtracting the friction force from the applied force.', 1,
  'Response computes F_net = 20 N - 10 N = 10 N, with friction opposing the applied force''s direction of motion.',
  'Show both forces (applied and friction) being combined with correct signs before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly computes the acceleration as 2 m/s^2, using Newton''s second law with the net force from part (c).', 1,
  'Response computes a = F_net/m = 10/5 = 2 m/s^2, using the net force value from part (c).',
  'Explicitly use the net force value from part (c), not the applied force alone.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 5 — apphy1-frq-np1-005 — Unit 2 (frictionless incline, force components) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-005', 'frq',
    'Force Components on a Frictionless Incline', 'draft', 'short', 'targeted_drill', 'translation_between_representations'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2, sin(30 deg) = 0.5, cos(30 deg) = 0.866.

(a) Calculate the component of the block''s weight directed parallel to the incline surface.

(b) Calculate the magnitude of the normal force exerted on the block by the incline surface.

(c) Calculate the magnitude of the block''s acceleration down the incline.

(d) The magnitude of the normal force found in part (b) is less than the block''s weight (40 N). Explain why, in terms of the components of the gravitational force.',
    'A 4 kg block is placed on a frictionless incline that makes a 30-degree angle with the horizontal. A coordinate axis is chosen parallel to the incline surface, consistent with the block''s direction of acceleration.',
    md5('apphy1-frq-np1-005'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the parallel component of gravity as 20 N, using mg*sin(30deg).', 1,
  'Response computes (4)(10)(0.5) = 20 N.', 'Show the substituted expression mg*sin(30deg) before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the normal force as approximately 34.6 N (accept 34.4 to 34.8 N), recognizing it equals the perpendicular component of gravity on this frictionless incline.', 1,
  'Response computes N = mg*cos(30deg) = (4)(10)(0.866) = 34.64 N, or equivalent.',
  'Explicitly identify the normal force as balancing only the perpendicular component of gravity, not the full weight.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the acceleration down the incline as 5 m/s^2, using the parallel component of gravity from part (a) divided by mass (or equivalently a = g*sin(30deg)).', 1,
  'Response computes a = 20 N / 4 kg = 5 m/s^2, or a = (10)(0.5) = 5 m/s^2.',
  'Show either the F=ma computation using part (a)''s force, or the equivalent a=g*sin(theta) form.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly explains that the normal force only balances the perpendicular component of gravity (mg*cos30deg = 34.6 N), while the parallel component (mg*sin30deg = 20 N) is unbalanced and produces the block''s acceleration down the incline, so the normal force is necessarily less than the full weight.', 1,
  'Response explicitly connects the normal force to only the perpendicular component of gravity, distinguishing it from the parallel component that causes acceleration, to explain why N < weight.',
  'Explicitly reference both gravity components (parallel and perpendicular) and their separate roles, not just state that "the incline reduces the normal force" without the component reasoning.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 6 — apphy1-frq-np1-006 — Unit 2 (vertical circular loop, normal force direction) — hard
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-006', 'frq',
    'Minimum Speed and Normal Force at the Top of a Vertical Loop', 'draft', 'short', 'targeted_drill', 'qualitative_quantitative_translation'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2.

(a) Calculate the minimum speed the ball must have at the top of the loop to maintain contact with the track.

(b) At this minimum speed, calculate the magnitude of the normal force exerted by the track on the ball at the top of the loop.

(c) At the top of the loop, state the direction of the normal force exerted by the track on the ball, and justify your answer.

(d) Suppose the ball instead travels through the top of the loop at a speed greater than the minimum speed found in part (a). State whether the magnitude of the normal force at the top would be greater than, less than, or equal to the value found in part (b), and justify your answer.',
    'A 2 kg ball moves through a vertical circular loop of radius 1.5 m on the inside of a track.',
    md5('apphy1-frq-np1-006'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the minimum speed as approximately 3.87 m/s (accept 3.8 to 3.9 m/s), by setting gravity alone equal to the required centripetal force at the top.', 1,
  'Response sets mg = mv^2/r, cancels m, and solves v = sqrt(gr) = sqrt((10)(1.5)) = sqrt(15) ~= 3.87 m/s.',
  'Show the equation mg = mv^2/r (gravity alone supplies centripetal force at minimum speed) before solving for v.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly states the normal force is 0 N at this minimum speed.', 1,
  'Response explains that at the minimum speed, gravity alone provides exactly the required centripetal force, so the normal force contributes nothing and equals zero.',
  'Explicitly connect the zero normal force to gravity alone already supplying the required centripetal force at this speed.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly states the normal force is directed downward, toward the center of the loop, with justification that the track can only push (not pull) on the ball, and the center of the circular path is below the ball at the top of the loop.', 1,
  'Response states the normal force points downward (toward the loop''s center) because the inside surface of the track can only exert a contact (pushing) force on the ball directed away from the track surface and toward the center of the circular path — not the flat-surface-habit answer of "upward."',
  'Explicitly justify the downward direction using the contact-force/center-of-the-circle reasoning, not just state "downward" without justification.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly states the normal force would be greater than the value in part (b), justified by the additional centripetal force required at a higher speed.', 1,
  'Response explains that at a speed greater than the minimum, the required centripetal force (mv^2/r) exceeds what gravity alone supplies, so the normal force must supply the remainder, making it greater than zero (and greater than the part (b) value).',
  'Explicitly state that required centripetal force increases with speed, so the normal force must increase to make up the difference beyond what gravity supplies.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 7 — apphy1-frq-np1-007 — Unit 2 (frictionless banked curve) — hard
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-007', 'frq',
    'Speed on a Frictionless Banked Curve', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2, tan(20 deg) = 0.364.

(a) Write the two Newton''s-second-law equations (vertical and horizontal/centripetal directions) for the car on this frictionless banked curve, and combine them to show that tan(theta) = v^2/(rg).

(b) Calculate v^2 for the speed at which the car can travel this curve while relying on no friction.

(c) Calculate the corresponding speed v.

(d) Explain what would happen to the car if it traveled around this curve faster than the speed found in part (c), given that the curve is frictionless.',
    'A car travels on a frictionless, circular, banked curve of radius 50 m. The curve is banked at an angle of 20 degrees from the horizontal.',
    md5('apphy1-frq-np1-007'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly sets up N*cos(theta) = mg (vertical equilibrium) and N*sin(theta) = mv^2/r (horizontal, centripetal), and correctly divides the second by the first to derive tan(theta) = v^2/(rg).', 1,
  'Response writes both component equations for the normal force (the only force present besides gravity, since the curve is frictionless) and shows the division step that eliminates N and m to reach tan(theta)=v^2/(rg).',
  'Show both individual component equations before combining them, not just the final combined relation.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes v^2 as approximately 182 m^2/s^2 (accept 178 to 186), using v^2 = rg*tan(theta).', 1,
  'Response substitutes r=50, g=10, tan(20deg)=0.364 into v^2=rg*tan(theta) to get v^2=(50)(10)(0.364)=182.',
  'Show the substituted expression v^2 = rg*tan(theta) before the numeric value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes v as approximately 13.5 m/s (accept 13.3 to 13.6), by taking the square root of the value from part (b).', 1,
  'Response takes the square root of v^2 from part (b) to get v ~= 13.5 m/s.', 'Show the square-root step applied to the part (b) value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly explains that without friction, if the car travels faster than this speed, the normal force can no longer supply enough centripetal force, so the car tends to slide up and outward on the banked surface, moving toward a larger radius.', 1,
  'Response explains that at higher speed, more centripetal force is required than the normal force alone (at this banking angle) can provide, and with no friction available to supply the extra inward force, the car slides outward/up the bank.',
  'Explicitly state that the deficiency is in centripetal force supplied by the normal force, and that with no friction to compensate, the car slides outward/up the incline of the bank — not just "it will slide" without this reasoning.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 8 — apphy1-frq-np1-008 — Unit 3 (work-energy theorem with friction) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-008', 'frq',
    'Work-Energy Theorem with an Applied Force and Friction', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question.

(a) Calculate the work done on the box by the applied force.

(b) Calculate the work done on the box by friction.

(c) Calculate the net work done on the box.

(d) Using the work-energy theorem, calculate the box''s final kinetic energy.

(e) Calculate the box''s final speed.',
    'A 3 kg box, initially moving at 4 m/s, is pushed by a constant horizontal applied force of 15 N over a distance of 5 m along a rough, horizontal floor. A constant friction force of 6 N opposes the box''s motion over this distance.',
    md5('apphy1-frq-np1-008'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the work done by the applied force as 75 J.', 1,
  'Response computes W = (15 N)(5 m) = 75 J, with the force parallel to the displacement.',
  'Show the substituted expression W=Fd before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the work done by friction as -30 J, with the negative sign reflecting that friction opposes the displacement.', 1,
  'Response computes W_friction = -(6 N)(5 m) = -30 J, explicitly including the negative sign since friction acts opposite to the displacement.',
  'Include the negative sign explicitly and state the reasoning that friction opposes motion.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the net work as 45 J, by summing the work from parts (a) and (b).', 1,
  'Response adds 75 J + (-30 J) = 45 J.', 'Show both work values from parts (a) and (b) being added with correct signs.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly computes the final kinetic energy as 69 J, using the work-energy theorem (initial KE plus net work).', 1,
  'Response computes initial KE = (1/2)(3)(4)^2 = 24 J, then adds the net work from part (c): KE_final = 24 J + 45 J = 69 J.',
  'Show the initial KE computation explicitly before adding the net work from part (c).', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-e-criterion-01', 'Correctly computes the final speed as approximately 6.8 m/s (accept 6.7 to 6.9), by solving KE=(1/2)mv^2 for v using the part (d) value.', 1,
  'Response solves 69 = (1/2)(3)v^2 to get v^2 = 46, v = sqrt(46) ~= 6.78 m/s.',
  'Show the algebraic isolation of v^2 before taking the square root.', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 9 — apphy1-frq-np1-009 — Unit 3 (spring PE to gravitational PE via conservation) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-009', 'frq',
    'Energy Conservation from a Compressed Spring to Maximum Height', 'draft', 'short', 'targeted_drill', 'translation_between_representations'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2.

(a) Calculate the elastic potential energy stored in the compressed spring.

(b) Calculate the block''s speed as it leaves the spring at the bottom of the incline.

(c) Calculate the maximum height the block reaches on the incline.

(d) Describe how the distribution of kinetic energy and gravitational potential energy in the block-spring-Earth system changes from the instant the block leaves the spring to the instant it reaches its maximum height, and state what happens to the system''s total mechanical energy over this process.',
    'A 2 kg block is placed against a spring with spring constant k = 200 N/m, which is compressed 0.3 m from its natural length. The spring is released, launching the block, which then travels up a frictionless incline. The track and incline are frictionless everywhere.',
    md5('apphy1-frq-np1-009'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the elastic potential energy as 9 J, using U_s = (1/2)k(delta x)^2.', 1,
  'Response computes (1/2)(200)(0.3)^2 = (1/2)(200)(0.09) = 9 J.', 'Show the substituted expression before the final value.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the block''s speed as 3 m/s, by setting the spring PE from part (a) equal to the block''s kinetic energy.', 1,
  'Response sets (1/2)(2)v^2 = 9 J (all spring PE converts to KE at the bottom, since the track is frictionless) and solves v=3 m/s.',
  'Show the energy-conservation equation (spring PE = KE) explicitly before solving for v.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the maximum height as 0.45 m, by setting the kinetic energy from part (b) (or the spring PE from part (a) directly) equal to gravitational potential energy at maximum height.', 1,
  'Response sets mgh = 9 J (using either the KE from part (b) or the spring PE from part (a), since total mechanical energy is conserved) and solves h = 9/(2*10) = 0.45 m.',
  'Show the energy-conservation equation (KE or spring PE = mgh) explicitly before solving for h.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-d-criterion-01', 'Correctly describes that kinetic energy decreases from 9 J to 0 J while gravitational potential energy increases from 0 J to 9 J as the block rises, and correctly states the total mechanical energy remains constant at 9 J throughout, since the track and incline are frictionless (no nonconservative forces act).', 1,
  'Response explicitly describes the KE-to-U_g transfer with the correct total (9 J) and explains that total mechanical energy is conserved because only conservative forces (gravity, the ideal spring) act and there is no friction.',
  'State the conserved total value (9 J) explicitly and give the reasoning (no nonconservative forces act), not just state "energy converts from kinetic to potential."', '[]'::jsonb
from version_ins;

-- =============================================================================
-- FRQ 10 — apphy1-frq-np1-010 — Unit 3 (power, constant-velocity lifting) — medium
-- =============================================================================
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, frq_form, practice_format, frq_archetype)
  select gen_random_uuid(), epv_id, 'apphy1-frq-np1-010', 'frq',
    'Power Required to Lift an Elevator at Constant Velocity', 'draft', 'short', 'targeted_drill', 'mathematical_routines'
  from np1_epv
  returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, rubric_type, evaluator_strategy)
  select gen_random_uuid(), id, 1,
    'Answer all parts of the following question. Use g = 10 m/s^2.

(a) Calculate the force the motor must exert on the elevator to lift it at this constant velocity, and explain why this force must equal the elevator''s weight.

(b) Calculate the mechanical power output of the motor.

(c) Given that the motor operates at 80% efficiency, calculate the electrical power input required.',
    'A motor lifts a 1000 kg elevator vertically at a constant velocity of 2 m/s. Friction between the elevator and its guide rails is negligible.',
    md5('apphy1-frq-np1-010'), 'draft', 'tutor_review_pending', 'discrete_text', 'llm_discrete_text'
  from item_ins
  returning id
)
insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select gen_random_uuid(), id, 'part-a-criterion-01', 'Correctly computes the required force as 10,000 N, and explains that it must equal the elevator''s weight because constant velocity means zero acceleration, so by Newton''s first/second law the net force must be zero, requiring the applied force to exactly balance gravity.', 1,
  'Response computes F = mg = (1000)(10) = 10000 N and explicitly states the constant-velocity/zero-net-force reasoning, not just the numeric answer.',
  'Include the explicit reasoning that constant velocity implies zero net force, requiring the applied force to balance gravity exactly — a bare numeric answer without this reasoning does not fully earn the point.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-b-criterion-01', 'Correctly computes the mechanical power output as 20,000 W, using P = Fv with the force from part (a).', 1,
  'Response computes P = (10000 N)(2 m/s) = 20000 W, using the force value from part (a).',
  'Explicitly use the force value from part (a) in the P=Fv computation.', '[]'::jsonb
from version_ins
union all
select gen_random_uuid(), id, 'part-c-criterion-01', 'Correctly computes the electrical power input as 25,000 W, by dividing the mechanical power output from part (b) by the 80% efficiency.', 1,
  'Response computes P_input = 20000 W / 0.80 = 25000 W, correctly dividing (not multiplying) by the efficiency to account for input exceeding useful output.',
  'Show the division step P_output/efficiency explicitly, and state why dividing (not multiplying) is correct for finding a larger input from a smaller useful output.', '[]'::jsonb
from version_ins;

commit;
