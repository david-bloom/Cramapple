begin;

-- Repair AP Physics 1 Unit 1 (Kinematics) Learn More explainers -- all 5
-- were template-generated debt (core_idea byte-identical to their paired
-- brief's what_it_is, and mini_example_question/weak_answer shared
-- boilerplate: "A physics prompt gives a scenario involving <Title>. What
-- should your response show to earn credit?" and "I would plug into a
-- formula without defining the quantities or direction." respectively) per
-- the 2026-08-21 bulk audit. Confirmed via SQL before authoring: all 5 rows
-- carried source_note 'generated-from-brief:legacy; grandfathered-2026-08-21'
-- with no "repaired" marker, and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate mini_example_question and weak_answer on every
-- row -- so all 5 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here.
--
-- Grounded in docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 1 section
-- (starting line 112, "Unit 1 -- Kinematics"): 1.1's fact that vector-arrow
-- notation is not required for a signed one-dimensional component (sign
-- alone conveys direction), applied to a distance-vs-displacement worked
-- example with a direction reversal; 1.2's fact that instantaneous velocity/
-- acceleration are defined as the limit of an average over a small interval
-- and are never introduced via a derivative (no derivative notation appears
-- anywhere in this algebra-based course), applied to an average-velocity
-- worked example that explicitly distinguishes the average from an
-- instantaneous value; 1.3's two verbatim boundary statements (nonuniform
-- acceleration can only be analyzed qualitatively/graphically, never with
-- the three kinematic equations; g = 10 m/s^2 is the standard numeric value,
-- though 9.8/9.81 is not penalized), applied to a constant-acceleration
-- worked example with real velocity/acceleration/time values; 1.4's verbatim
-- boundary statement restricting relative-velocity vector addition to one
-- dimension only in this course (2-D cases like a boat crossing a river are
-- out of scope), contrasted with acceleration's frame-independence, applied
-- to a one-dimensional moving-walkway worked example that explicitly
-- explains why it does not require two-dimensional vector addition; and
-- 1.5's documented 2026 FRQ finding that qualitative reasoning is graded as
-- a separate, distinct requirement from the mathematical derivation (not
-- boilerplate -- an explicit separately-graded instruction), applied to a
-- projectile-motion worked example with real launch-angle and speed values
-- plus a qualitative-reasoning sentence. All kinematics equation algebra and
-- unit consistency were independently verified during authoring (e.g. 1.3's
-- v = v0 + at and x = x0 + v0t + (1/2)at^2 results cross-checked against
-- v^2 = v0^2 + 2a(x - x0); 1.5's component decomposition, time-of-flight,
-- and range recomputed and confirmed self-consistent); no physics facts or
-- computed numbers required correction after this independent check.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics 1 Unit 1); the pre-repair
-- content is fully recoverable from git history for this table's rows if a
-- rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 1 briefs already carry specific, correct,
-- non-templated point-earning language, so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus
-- (zero collisions found against every published row's matching field,
-- including a specific check against the known template boilerplate
-- weak_answer string, which the check confirmed still appears only on the
-- still-unrepaired rows this batch does not touch).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('1.1',
   'A scalar carries only magnitude (speed, distance, time); a vector carries magnitude and direction. In one dimension this course does not require vector-arrow notation -- a signed value like v_x = -4 m/s fully conveys direction through its sign alone, without ever writing an arrow over the symbol.',
   'Every kinematics equation you''ll use this unit depends on getting signs right. If you can''t tell a scalar from a vector, you''ll add speeds when you should be subtracting velocities, and every later unit (forces, momentum, energy) builds on this same signed-quantity habit.',
   'Credit comes from consistently assigning and using a sign convention (e.g., positive = rightward or upward) for every vector quantity in a problem, and from correctly identifying which given quantities are scalars (speed, distance, time) versus vectors (velocity, displacement, acceleration).',
   'Before solving, state your positive direction in words or with an arrow, then attach the correct sign to every velocity, displacement, and acceleration value you write down -- a bare number without an implied or stated sign is not a complete vector value in 1-D.',
   'A ball starts at x = +2 m, moves to x = +9 m, then moves back to x = +3 m. Find the ball''s total distance traveled and its net displacement, and state whether each answer is a scalar or a vector.',
   'The ball moved 13 m total, and its displacement is also 13 m since that''s how far it moved.',
   'Total distance traveled is a scalar: 7 m (from +2 to +9) plus 6 m (from +9 to +3) = 13 m. Net displacement is a vector, found from final minus initial position: x_f - x_i = 3 - 2 = +1 m, i.e. 1 m in the positive direction -- not 13 m, because the backward leg subtracts from displacement even though it adds to distance.',
   'Treating speed and velocity as interchangeable, or dropping the negative sign on a value once it''s plugged into an equation.',
   'Back to practice: on every 1-D motion item, decide first whether the question asks for distance (scalar, always adds) or displacement (vector, can subtract) before doing any arithmetic.'),
  ('1.2',
   'Average velocity is (delta-x)/(delta-t) and average acceleration is (delta-v)/(delta-t); instantaneous velocity and acceleration are defined as the limit of that average over a very small time interval -- never introduced via a derivative, since no derivative notation appears anywhere in this algebra-based course.',
   'These three definitions are the vocabulary every other kinematics topic is written in -- the constant-acceleration equations, the graph slopes, and the relative-motion rules in this unit all reduce back to these two ratios.',
   'Points come from correctly computing displacement, change in velocity, average velocity, or average acceleration from given position/velocity/time data, and from correctly distinguishing an instantaneous value (read at one moment) from an average value (computed over an interval).',
   'When a problem gives you two positions or two velocities at two different times, explicitly compute the change (final minus initial) before dividing by the elapsed time -- don''t skip straight to a memorized formula without showing the subtraction that defines it.',
   'A car''s position is x = 4 m at t = 1 s and x = 24 m at t = 5 s. Find its average velocity over that interval, and explain why this value is not automatically its instantaneous velocity at t = 3 s.',
   'The average velocity is 20 m/s divided by 4, so 5 m/s, which is also the car''s speed at t = 3 s since that''s the midpoint of the interval.',
   'Average velocity = (delta-x)/(delta-t) = (24 m - 4 m)/(5 s - 1 s) = 20 m / 4 s = 5 m/s. This is not necessarily the instantaneous velocity at t = 3 s: instantaneous velocity is defined as the limit of (delta-x)/(delta-t) as the time interval shrinks toward that single moment, and unless the car moves at constant velocity throughout, the 4-second average can differ from the instant at t = 3 s.',
   'Reporting a velocity or acceleration found from a slope calculation as if it were instantaneous when the problem actually asked for (or gave data for) an average over an interval.',
   'Return to practice and, whenever a problem gives two times and two positions or velocities, compute the change first (final minus initial) before dividing -- and only call the result "instantaneous" if the interval is genuinely shrinking toward one moment.'),
  ('1.3',
   'The three constant-acceleration kinematic equations (v = v0 + at, x = x0 + v0t + (1/2)at^2, v^2 = v0^2 + 2a(x - x0)) apply only when acceleration is constant; nonuniform acceleration can only be analyzed qualitatively or graphically in this course, never by plugging into these three equations. g = 10 m/s^2 is the value used for numeric problems, though 9.8 or 9.81 m/s^2 is not penalized.',
   'Most quantitative kinematics problems on the exam are solved by picking the one correct equation from this set or by reading a value off a graph, so fluency here is the single biggest lever for points in this unit.',
   'Points require selecting the kinematic equation that matches the known and unknown quantities, substituting correctly, and -- for graph items -- correctly matching slope-of-position-graph to velocity, slope-of-velocity-graph to acceleration, area-under-velocity-graph to displacement, and area-under-acceleration-graph to change in velocity; nonuniform-acceleration graphs are scored on qualitative shape/reasoning, not on plugging into the three equations.',
   'Before using a constant-acceleration equation, confirm acceleration is actually constant over the interval in question -- if the acceleration is changing, switch to reading slopes and areas off the graph instead, since the constant-acceleration equations don''t apply there.',
   'A car starts from rest and accelerates at a constant 4 m/s^2 for 5 seconds. Find its final velocity and the distance it travels during that time.',
   'Final velocity is 4 times 5, so 20 m/s, and distance is velocity times time, so 20 times 5 equals 100 m.',
   'Using v = v0 + at: v = 0 + (4 m/s^2)(5 s) = 20 m/s. Using x = x0 + v0t + (1/2)at^2: x = 0 + 0 + (1/2)(4 m/s^2)(5 s)^2 = (1/2)(4)(25) = 50 m. (Check with v^2 = v0^2 + 2a(x - x0): 20^2 = 400, and 2(4)(50) = 400, confirming consistency.) The distance is not simply final velocity times time, because the car wasn''t moving at 20 m/s for the whole interval -- it started from rest and sped up.',
   'Plugging numbers into a constant-acceleration equation for a motion segment where the acceleration is actually changing, instead of switching to graphical/qualitative reasoning.',
   'Head to practice and, before using any of the three kinematic equations, confirm the acceleration is actually constant over the interval in question -- if it isn''t, switch to slopes and areas on a graph instead.'),
  ('1.4',
   'Acceleration is the same in every inertial reference frame, but velocity is not -- it combines the object''s velocity in one frame with the relative velocity between frames. This course restricts relative-velocity vector addition to one dimension only; two-dimensional relative-velocity problems, such as a boat crossing a river, are outside AP Physics 1''s scope.',
   'Problems describing motion "as seen from" a moving platform (a walkway, a train, another car) only make sense once you recognize that velocities must be combined between frames while accelerations transfer over unchanged.',
   'Points come from correctly adding or subtracting one-dimensional velocities to convert between reference frames, and from correctly stating that the acceleration of an object is the same as measured in any inertial frame.',
   'When a problem gives motion relative to a moving frame (like a person walking on a moving walkway) restricted to one dimension, add the object''s velocity in that frame to the frame''s own velocity (with correct signs) to get velocity in the ground frame -- do not attempt this as a two-dimensional vector-addition problem, since 2-D relative-velocity situations are outside this course.',
   'A moving walkway carries passengers forward at 1.5 m/s relative to the airport floor. A passenger walks forward at 1.2 m/s relative to the walkway. Find the passenger''s velocity relative to the airport floor, and explain why this problem can be solved with simple addition rather than two-dimensional vector addition.',
   'The passenger''s velocity relative to the floor is 1.2 m/s, since that''s their own walking speed.',
   'Relative to the airport floor, the passenger''s velocity is the walkway''s velocity plus the passenger''s velocity relative to the walkway: 1.5 m/s + 1.2 m/s = 2.7 m/s, both in the same direction. Simple addition works here because both velocities lie along the same one-dimensional line of motion (forward along the walkway) -- AP Physics 1 only holds students responsible for combining relative velocities along one dimension, unlike a two-dimensional case such as a boat crossing a river, where the boat''s and current''s velocities point in different directions and would require full vector addition, a scenario this course does not test.',
   'Trying to combine relative velocities using two-dimensional vector addition (like a boat crossing a river) when this course only holds students responsible for one-dimensional relative motion.',
   'Back to practice: on every relative-motion item, confirm both velocities lie along the same line before adding or subtracting them directly -- and remember this course never requires two-dimensional relative-velocity vector addition.'),
  ('1.5',
   'Projectile motion decomposes into two independent 1-D motions: zero acceleration horizontally, constant g vertically, linked only by a shared time. On a 2026 released FRQ, qualitative reasoning about the motion was graded as a separate, distinct requirement from the mathematical derivation -- not an optional add-on to the math, but its own scored piece.',
   'Projectile motion is the main way the course tests whether you can combine vector resolution with the kinematics equations from the previous topic, since horizontal and vertical motion happen simultaneously but must be solved separately.',
   'Points come from correctly resolving an initial velocity into horizontal and vertical components, recognizing horizontal acceleration is zero while vertical acceleration is constant, and solving each axis with the appropriate 1-D kinematic equation before recombining results if needed.',
   'For projectile motion, split the initial velocity into horizontal and vertical components immediately, then solve the vertical axis (constant acceleration) and horizontal axis (constant velocity) as two separate 1-D kinematics problems linked only by a shared time variable.',
   'A ball is launched from the ground at 20 m/s at 30 degrees above the horizontal. Using g = 10 m/s^2, find its total time in the air and its horizontal range, and briefly explain in words (not just equations) why the ball''s vertical velocity is zero at the peak of its path.',
   'Time in the air is 20 divided by 10, so 2 seconds, and range is 20 times 2, so 40 m.',
   'Resolve the launch velocity into components: vx0 = 20cos(30 deg) is approximately 17.3 m/s (constant throughout, since horizontal acceleration is zero), vy0 = 20sin(30 deg) = 10 m/s. Vertically, the ball decelerates under gravity, momentarily stops rising, then falls; time to reach the peak is vy0/g = 10/10 = 1 s, and by symmetry (same launch and landing height) total flight time is 2 s. Horizontal range = vx0 times t = 17.3 times 2, approximately 34.6 m. Qualitatively, vertical velocity is zero at the peak because gravity continuously decelerates the upward motion until the vertical velocity component momentarily reverses sign -- this is a separate reasoning point from the calculation itself, not just a restatement of the math.',
   'Using the initial launch speed directly in a kinematics equation instead of first resolving it into horizontal and vertical components.',
   'Return to practice and, on every projectile item, resolve into components first, and always add a sentence of qualitative reasoning (why a quantity is zero, or why the motion behaves as it does) since it is graded separately from the math.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 1 section (line 112): the fact that vector-arrow notation is not required for a signed 1-D component (sign alone conveys direction) for 1.1, applied to a distance-vs-displacement worked example with a direction reversal; the fact that instantaneous velocity/acceleration are the limit of an average over a small interval and never introduced via a derivative for 1.2, applied to an average-velocity worked example; the two verbatim boundary statements (nonuniform acceleration is qualitative/graphical only; g = 10 m/s^2 is standard, 9.8/9.81 not penalized) for 1.3, applied to a constant-acceleration worked example with real numbers; the verbatim boundary statement restricting relative-velocity vector addition to one dimension (2-D cases like a river crossing are out of scope) for 1.4, applied to a moving-walkway worked example; and the documented 2026 FRQ finding that qualitative reasoning is graded as a separate, distinct requirement from the math derivation for 1.5, applied to a projectile-motion worked example with real launch values. All kinematics equation algebra was independently verified during authoring (1.3''s v = v0 + at and x = x0 + v0t + (1/2)at^2 results cross-checked against v^2 = v0^2 + 2a(x - x0); 1.5''s component decomposition, time-of-flight, and range recomputed and confirmed self-consistent); no physics facts or computed numbers required correction. briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-physics-1-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_1'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_1' and unit_number=1 and status='published'
      and source_note like '%unit1-explainer-repair%';
  if v_repaired <> 5 then
    raise exception 'expected 5 repaired AP Physics 1 Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_1' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
