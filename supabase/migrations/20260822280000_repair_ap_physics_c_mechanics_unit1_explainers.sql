begin;

-- Repair AP Physics C: Mechanics Unit 1 (Kinematics) Learn More explainers --
-- all 5 were template-generated debt (core_idea byte-identical to their
-- paired brief's what_it_is, and mini_example_question/weak_answer shared
-- boilerplate: "A physics prompt gives a scenario involving <Title>. What
-- should your response show to earn credit?" and "I would plug into a
-- formula without defining the quantities or direction." respectively) per
-- the 2026-08-21 bulk audit. Confirmed via SQL before authoring: all 5 rows
-- carried source_note 'generated-from-brief:legacy; grandfathered-2026-08-21'
-- with no "repaired" marker, and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate mini_example_question and weak_answer on every
-- row -- so all 5 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are genuinely hand-authored,
-- correctly calculus-based (Physics 1's algebra-based "limit of an average"
-- language is already absent, unit-vector notation and integral relations
-- already appear), and correct; NOT touched here.
--
-- Grounded in docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 1
-- section (starting line 77, "Unit 1 -- Kinematics"), and this is the
-- calculus-based sibling of the AP Physics 1 Unit 1 repair
-- (20260822270000_repair_ap_physics_1_unit1_explainers.sql), covering the
-- same 5 topic names with independently authored, calculus-flavored content:
-- 1.1's full unit-vector notation r-vec = A*i-hat + B*j-hat + C*k-hat and the
-- resultant-vector component formula, applied to a two-leg unit-vector
-- displacement addition (distinct scenario/numbers from the Physics 1 batch's
-- 1-D distance-vs-displacement example); 1.2's EK 1.2.C.2 fact that
-- instantaneous velocity/acceleration are true derivatives (v = dr/dt,
-- a = dv/dt) found by differentiation, never the "limit of an average over a
-- small interval" language Physics 1 uses, applied to differentiating an
-- explicit cubic position function (distinct from the Physics 1 batch's
-- two-point average-velocity example, which never differentiates a
-- function); 1.3's integral definitions (delta-x = integral of v_x(t) dt,
-- delta-v_x = integral of a_x(t) dt) for time-varying acceleration, alongside
-- the same g = 10 m/s^2 boundary statement shared with Physics C: E&M,
-- applied to integrating a genuinely time-varying (quadratic) acceleration
-- function (distinct from the Physics 1 batch's constant-acceleration
-- example, which never integrates); 1.4's verified fact that this course does
-- NOT restrict relative-velocity vector addition to one dimension (unlike
-- Physics 1's explicit one-dimension-only boundary statement), applied to a
-- genuine two-dimensional boat-crossing-a-river vector-addition problem
-- (explicitly called out in the fact pack as in-scope here and out-of-scope
-- in Physics 1, and distinct from the Physics 1 batch's one-dimensional
-- moving-walkway example); and 1.5's fact that this course's quantitative
-- ceiling is two dimensions (three-dimensional motion is qualitative-only,
-- an AP Physics C: E&M-course expectation), applied to a projectile
-- maximum-height calculation with different launch speed/angle and a
-- different target quantity than the Physics 1 batch's range-and-flight-time
-- example. All derivatives, integrals, vector sums, and numeric results were
-- independently verified during authoring (e.g. 1.2's dx/dt and d^2x/dt^2
-- recomputed term-by-term; 1.3's integral of 4t^2 from 0 to 3 recomputed and
-- cross-checked against the flawed midpoint-value shortcut it's contrasted
-- with; 1.4's 3-4-5 vector triangle and arctangent recomputed; 1.5's
-- component resolution and v_y0^2/(2g) recomputed); no physics or calculus
-- errors required correction after this independent check.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics C: Mechanics Unit 1); the
-- pre-repair content is fully recoverable from git history for this table's
-- rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the fact
-- pack rather than restating it). answer_move and common_point_loss are
-- preserved verbatim from the paired brief per protocol section 4 ("the same
-- topic-specific answer_move" / "the same or refined common_point_loss") --
-- the Unit 1 briefs already carry specific, correct, calculus-appropriate,
-- non-templated point-earning language, so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus
-- (zero collisions found against every published row's matching field,
-- including against the AP Physics 1 Unit 1 batch's independently authored
-- examples for the same 5 topic names).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'A scalar has magnitude only (speed, distance); a vector has magnitude and direction, written as r-vec = A*i-hat + B*j-hat + C*k-hat. Resultant vectors add component-by-component: C-vec = A-vec + B-vec = (Ax+Bx)*i-hat + (Ay+By)*j-hat, never by adding magnitudes.',
   'The rest of Unit 1 -- displacement, velocity, and acceleration -- is defined using this same unit-vector language, so component-by-component vector algebra isn''t a one-time skill; it''s the notation every later equation in the course is written in.',
   'Credit requires resolving each given vector into its i-hat/j-hat (and k-hat, when 3D) components, adding or subtracting matching components separately, and only then recombining into a magnitude or direction -- a final answer with no visible component work is not full credit.',
   'When asked for a resultant vector, add or subtract the components in each direction separately before recombining, and keep each component''s sign tied to its assigned axis direction throughout.',
   'A hiker''s displacement during the morning is A = 3i-hat + 4j-hat km, and during the afternoon it''s B = -1i-hat + 2j-hat km. Find the hiker''s total displacement C = A + B in unit vector notation, and its magnitude.',
   'The magnitude of A is 5 km and the magnitude of B is about 2.24 km, so the total displacement is roughly 5 + 2.24 = 7.24 km.',
   'Add matching components: C = (3 + (-1))i-hat + (4 + 2)j-hat = 2i-hat + 6j-hat km. The magnitude is |C| = sqrt(2^2 + 6^2) = sqrt(40) ~= 6.32 km -- not the sum of the two individual magnitudes, because A and B don''t point in the same direction.',
   'Combining vector magnitudes directly (like adding lengths) instead of adding matching components separately.',
   'Head back to practice and, on every vector-addition item, resolve each vector into i-hat/j-hat components first -- only add matching components, never raw magnitudes.'),
  ('1.2',
   'Average velocity and acceleration use delta over a finite interval, but instantaneous velocity and acceleration are true derivatives: v = dr/dt and a = dv/dt. Per EK 1.2.C.2, position, velocity, and acceleration can all be found from one another by differentiating or integrating.',
   'Because this course defines instantaneous quantities as true derivatives (not as limits of an average), every later unit -- forces, energy, momentum -- eventually comes back to differentiating or integrating a position, velocity, or acceleration function.',
   'Points come from correctly differentiating (or integrating) a given function of time, and from clearly identifying whether the question wants an average value over an interval or an instantaneous value at one moment -- the two are graded as distinct calculations, not interchangeable ones.',
   'When a position or velocity function is given as an explicit expression in time, differentiate it directly to get instantaneous velocity or acceleration -- do not fall back on average-rate formulas, which only apply when you''re working from two data points, not a continuous function.',
   'A particle''s position is x(t) = 2t^3 - 6t^2 + 4t (meters, t in seconds). Find its instantaneous velocity and acceleration at t = 2 s.',
   'Using average velocity: x(2) = 2(8) - 6(4) + 4(2) = 0 m, x(0) = 0 m, so average velocity is (0 - 0)/2 = 0 m/s, and that''s the velocity at t = 2 s.',
   'Differentiate: v(t) = dx/dt = 6t^2 - 12t + 4, so v(2) = 6(4) - 12(2) + 4 = 4 m/s. Differentiate again: a(t) = dv/dt = 12t - 12, so a(2) = 12(2) - 12 = 12 m/s^2. The average-velocity shortcut gives 0 m/s here only because x(0) = x(2); it is not the instantaneous value the question asked for.',
   'Using the average velocity or average acceleration formula when the question actually asks for an instantaneous value at a specific time.',
   'Back to practice: whenever position or velocity is given as an explicit function of t, differentiate directly rather than reaching for an average-rate formula meant for two data points.'),
  ('1.3',
   'The three constant-acceleration equations apply only when a is constant. When a(t) varies, use the calculus definitions instead: delta-x = integral of v_x(t) dt and delta-v_x = integral of a_x(t) dt. As on the algebra-based exam, g ~= 10 m/s^2 is standard, and 9.8 or 9.81 m/s^2 is not penalized.',
   'Nearly every free-response question in this unit rewards recognizing which regime you''re in -- constant acceleration versus acceleration as a function of time -- before choosing between the three kinematic equations and setting up an integral.',
   'Points require first identifying whether acceleration is constant (justifying the three kinematic equations) or time-varying (requiring delta-x = integral of v_x dt or delta-v_x = integral of a_x dt), then correctly executing the algebra or the integral with the right limits.',
   'Before choosing a method, check whether acceleration is stated or shown to be constant; if it is not constant, set up the correct integral with the correct time bounds instead of reaching for the constant-acceleration equations, which do not apply.',
   'A particle''s acceleration is a_x(t) = 4t^2 (m/s^2) for 0 <= t <= 3 s. Find the change in velocity over that interval.',
   'Since acceleration changes, use its value at the midpoint time t = 1.5 s: a(1.5) = 4(1.5)^2 = 9 m/s^2. Then delta-v = at = 9(3) = 27 m/s.',
   'Because a_x(t) is not constant, integrate directly: delta-v_x = integral from 0 to 3 of 4t^2 dt = [4t^3/3] from 0 to 3 = 4(27)/3 = 36 m/s. The midpoint-value shortcut (27 m/s) is wrong here because a_x(t) = 4t^2 is not linear in t, so its average over the interval isn''t its value at the midpoint.',
   'Applying the constant-acceleration kinematic equations to a situation where acceleration is explicitly given as a function of time.',
   'Return to practice and check first whether acceleration is constant or a function of time -- if it''s a function of time, set up the correct integral with the correct limits instead of reaching for the three kinematic equations.'),
  ('1.4',
   'Velocity measured in one inertial frame converts to another by vector addition; acceleration is the same in every inertial frame. Unlike the algebra-based course, this course does not cap relative-velocity addition to one dimension -- full two-dimensional cases, like a boat crossing a river, are in scope.',
   'Relative-motion problems test whether velocities are treated as vectors that add and subtract across reference frames -- and because this course doesn''t cap that addition to one dimension, a scenario like a boat crossing a river is genuinely fair game, not just a one-dimensional walkway case.',
   'Points come from writing a correct vector equation linking an object''s velocity in one frame to its velocity in another and resolving it by components -- in two dimensions when the scenario calls for it -- not from combining speeds as if they were scalars.',
   'For a relative-velocity problem, write the vector equation linking the two frames component-by-component (including both dimensions when the scenario is 2D, such as a boat-and-current problem) rather than adding or subtracting speeds directly.',
   'A boat''s velocity relative to the water is 4 m/s due north (straight across a river). The river current flows due east at 3 m/s relative to the ground. Find the boat''s velocity relative to the ground, as a magnitude and direction.',
   'The boat''s speed relative to the ground is just 4 m/s + 3 m/s = 7 m/s, since both velocities add together.',
   'Set up the vector equation by components: v_boat/ground = v_boat/water + v_water/ground = 4j-hat + 3i-hat = 3i-hat + 4j-hat m/s. Magnitude = sqrt(3^2 + 4^2) = 5 m/s, at an angle of arctan(4/3) ~= 53.1 degrees north of east -- not 7 m/s, because the two velocities are perpendicular and must be added as vectors, not scalars.',
   'Adding relative velocities as plain numbers instead of as vectors, which drops the perpendicular component of motion entirely.',
   'Head to practice and, for every relative-motion item, write the frame-conversion equation component-by-component first -- this course expects you to handle the two-dimensional case, not just the one-dimensional shortcut.'),
  ('1.5',
   '2D motion splits into independent 1D components per axis, linked only by a shared time -- projectile motion is zero acceleration horizontally plus constant g vertically. This course''s quantitative ceiling is two dimensions; three-dimensional motion may only be described qualitatively, not calculated.',
   'Almost every 2D motion question in this unit -- projectiles, launched objects, curved paths -- is really two separate 1D kinematics problems solved in parallel along independent axes, and this course holds you to quantitative work only up to two dimensions.',
   'Points require explicitly separating motion into components along each axis, applying the correct kinematic or integral relationship independently to each axis, and only recombining components at the final step when a single resultant quantity is requested.',
   'Set up separate equations for each axis using that axis''s own acceleration and initial velocity before solving, and only combine the two results at the very last step when a single resultant quantity (like speed or range) is requested.',
   'A projectile is launched from the ground at 25 m/s at 37 degrees above horizontal (use g = 10 m/s^2, sin37 ~= 0.6, cos37 ~= 0.8). Find the time to reach maximum height and the maximum height itself.',
   'Time to reach max height is v0/g = 25/10 = 2.5 s, and max height is v0^2/(2g) = 625/20 = 31.25 m.',
   'Resolve into components first: v_x0 = 25cos37deg = 20 m/s (constant, since horizontal acceleration is zero) and v_y0 = 25sin37deg = 15 m/s. Time to peak uses only the vertical component: t = v_y0/g = 15/10 = 1.5 s. Max height = v_y0^2/(2g) = 225/20 = 11.25 m -- using the full launch speed instead of the vertical component alone (as the weak answer does) overstates both values.',
   'Letting the acceleration or time used in one direction''s equation leak into the other direction''s calculation instead of keeping the two axes fully separate.',
   'Return to practice and, on every 2D motion item, resolve into components before solving anything -- this course only requires quantitative work in two dimensions, so keep three-dimensional cases to qualitative description only.')
)
update app.topic_explainers e
set
  core_idea = u.core_idea,
  what_students_need_to_understand = u.what_students_need_to_understand,
  how_this_becomes_points = u.how_this_becomes_points,
  answer_move = u.answer_move,
  mini_example_question = u.mini_example_question,
  weak_answer = u.weak_answer,
  point_attaining_answer = u.point_attaining_answer,
  common_point_loss = u.common_point_loss,
  practice_bridge = u.practice_bridge,
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific, calculus-based content grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 1 section (line 77): full unit-vector notation and the resultant-vector component formula for 1.1, applied to a two-leg unit-vector displacement addition; EK 1.2.C.2''s true-derivative definition of instantaneous velocity/acceleration (v = dr/dt, a = dv/dt), explicitly not the "limit of an average" language Physics 1 uses, for 1.2, applied to differentiating an explicit cubic position function; the integral definitions delta-x = integral of v_x(t) dt and delta-v_x = integral of a_x(t) dt for time-varying acceleration, alongside the shared g = 10 m/s^2 boundary statement, for 1.3, applied to integrating a genuinely time-varying (quadratic) acceleration function; the verified fact that this course does not restrict relative-velocity vector addition to one dimension (unlike Physics 1) for 1.4, applied to a genuine two-dimensional boat-crossing-a-river vector-addition problem; and the fact that this course''s quantitative ceiling is two dimensions (three dimensions is qualitative-only, an E&M-course expectation) for 1.5, applied to a projectile maximum-height calculation. All derivatives, integrals, vector sums, and numeric results were independently verified during authoring; no physics or calculus errors required correction. briefs for this unit are genuinely hand-authored, already calculus-appropriate, and were NOT touched. mini-examples are independently authored and distinct from the AP Physics 1 Unit 1 repair batch''s examples for the same 5 topic names. batch 2026-08-22-ap-physics-c-mechanics-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_c_mechanics'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_c_mechanics' and unit_number=1 and status='published'
      and source_note like '%unit1-explainer-repair%';
  if v_repaired <> 5 then
    raise exception 'expected 5 repaired AP Physics C: Mechanics Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_c_mechanics' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C: Mechanics Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
