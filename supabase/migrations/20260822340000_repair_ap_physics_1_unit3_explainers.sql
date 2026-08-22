begin;

-- Repair AP Physics 1 Unit 3 (Work, Energy, and Power) Learn More explainers
-- -- all 5 were template-generated debt (core_idea byte-identical to their
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
-- hand-authored content. Briefs for this unit are genuinely hand-authored
-- and correct; NOT touched here.
--
-- Grounded in docs/product/AP_PHYSICS_1_CED_FACT_PACK.md Unit 3 section
-- (starting line 252, "Unit 3 -- Work, Energy, and Power"): 3.1's fact that
-- K = (1/2)mv^2 is a scalar (never negative because it depends on v^2, not
-- v) and is frame-dependent (different observers can measure different K
-- for the same object), applied to a two-observer worked example with real
-- relative-velocity numbers; 3.2's fact that work for a constant force is
-- W = F_parallel d = Fd cos(theta) -- never a dot product or calculus
-- treatment -- and that a variable force's work is found graphically as
-- area under an F_parallel-vs-displacement curve, applied to an
-- angled-force worked example that isolates the parallel component;
-- 3.3's fact that the zero of potential energy is always an observer's
-- choice, not fixed, and that the near-surface mgh formula is explicitly
-- an approximation of the general inverse-square gravitational form (not
-- an independent law), applied to a spring-compression worked example
-- that explicitly states its chosen reference; 3.4's fact that a
-- single-object system can only have K (never U, since potential energy
-- requires an internally-conservative interacting system) plus the
-- documented 2024 Chief Reader Report finding that the most common
-- bar-chart FRQ error was a default 50/50 K/U split regardless of the
-- scenario's actual height ratio, applied to a ramp worked example with
-- real height values that deliberately produces a 60/40 (not 50/50)
-- split; and 3.5's fact that instantaneous power P = F_parallel v =
-- Fv cos(theta) is explicitly labeled a derived equation (from the rate
-- of work) with no treatment of time-varying force/velocity in this
-- algebra-based course (no derivative notation used anywhere), applied to
-- a constant-velocity lifting worked example. All energy/work/power
-- algebra and computed numbers were independently verified during
-- authoring (e.g. 3.1's two-frame kinetic energy values recomputed from
-- relative speed; 3.4's mgh totals and the 60/40 split recomputed and
-- cross-checked against the stated height ratio); no physics facts or
-- computed numbers required correction after this independent check.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics 1 Unit 3); the pre-repair
-- content is fully recoverable from git history for this table's rows if a
-- rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the
-- fact pack rather than restating it). answer_move and common_point_loss
-- are preserved verbatim from the paired brief per protocol section 4
-- ("the same topic-specific answer_move" / "the same or refined
-- common_point_loss") -- the Unit 3 briefs already carry specific, correct,
-- non-templated point-earning language, so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus
-- (zero collisions found against every published row's matching field,
-- including a specific check against the known template boilerplate
-- weak_answer string, which the check confirmed still appears only on
-- rows this batch does not touch).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'Kinetic energy is K = (1/2)mv^2, a scalar that is always non-negative because it depends on v^2 -- it can never be made negative by a velocity direction. Kinetic energy is also frame-dependent: two observers in different reference frames can measure different speeds for the same object and therefore compute different values of K for that same motion, with no single frame being the "correct" one.',
   'Kinetic energy problems test whether you can correctly identify which speed to plug in -- the object''s speed relative to the frame the problem specifies -- and whether you understand that K itself never carries a sign, since squaring the speed erases any direction information.',
   'Points come from computing K = (1/2)mv^2 with the correct speed for the specified reference frame, and from correctly reasoning that K cannot be negative and that its value can differ between two valid reference frames for the same object.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then compute kinetic energy from mass and speed and recognize that it depends on reference frame before doing arithmetic or writing the final sentence.',
   'A 2 kg ball moves at 6 m/s relative to the ground. Find its kinetic energy in the ground frame, and in the frame of an observer running alongside it at 4 m/s in the same direction.',
   'The kinetic energy is (1/2)(2)(6)^2 = 36 J in the ground frame, and it''s still 36 J for the moving observer too, since it''s the same ball and the same speed.',
   'In the ground frame, K = (1/2)(2 kg)(6 m/s)^2 = 36 J. Relative to the observer running at 4 m/s in the same direction, the ball''s speed is only 6 - 4 = 2 m/s, so K = (1/2)(2 kg)(2 m/s)^2 = 4 J. The two values differ because kinetic energy depends on speed relative to the observer''s frame, not on some single absolute speed.',
   'Using velocity direction to make kinetic energy negative',
   'Back to practice: before computing K, confirm which frame the speed is measured in -- the same object can have very different kinetic energy values depending on who''s watching.'),
  ('3.2',
   'Work for a constant force is W = F_parallel d = Fd cos(theta) -- never treated as a dot product or with calculus notation in this course. For a force that changes with position, work is found graphically instead: it equals the area under a graph of F_parallel versus displacement, since the constant-force formula no longer applies directly.',
   'The single most common way to lose points here is using the full force magnitude instead of isolating the component that''s actually parallel to the displacement -- work only comes from the piece of the force that''s doing something in the direction of motion.',
   'Points come from correctly isolating F_parallel (via Fcos(theta) or direct identification), multiplying by displacement with the correct sign, and -- for a variable force -- reading area under an F_parallel-vs-displacement graph instead of trying to force a single-formula calculation.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then find signed work from the force component parallel to displacement or from area under an F-parallel versus displacement graph before doing arithmetic or writing the final sentence.',
   'A worker pulls a box across the floor with a 50 N force directed 37 degrees above the horizontal (cos 37 degrees is approximately 0.8), moving the box 10 m horizontally. Find the work done by the worker''s force.',
   'Work is force times distance, so 50 N times 10 m equals 500 J.',
   'Only the horizontal component of the 50 N force does work on the box, since displacement is horizontal. W = Fd cos(theta) = (50 N)(10 m)(0.8) = 400 J -- not 500 J, because the full 50 N isn''t aligned with the direction of motion; part of it points upward and does no work on the horizontal displacement.',
   'Using total force magnitude when only the parallel component does work',
   'Return to practice and, before multiplying force by distance, ask whether the force is fully aligned with the displacement -- if it''s at an angle, isolate the parallel component first.'),
  ('3.3',
   'The zero of potential energy is always an observer''s choice, not a fixed physical reference -- you can place U = 0 anywhere convenient (the ground, a table, a spring''s natural length) as long as you''re consistent within one problem. The near-surface formula deltaU_g = mg deltay is explicitly an approximation of the general inverse-square gravitational form, not an independent law, and in a system with more than two objects, total potential energy is the sum of the potential energy of every pair.',
   'Because U''s zero point is chosen, not given, two students can pick different reference heights and both be correct as long as they only report changes in U or are explicit about their reference -- the physics never depends on where you set U = 0.',
   'Points come from correctly computing a change in potential energy (spring: (1/2)k(deltax)^2; near-surface gravitational: mg deltay) and from stating or using a reference point explicitly rather than treating U = 0 as a universal, physically fixed location.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then choose a system and calculate gravitational or spring potential-energy changes from configuration before doing arithmetic or writing the final sentence.',
   'A spring with spring constant k = 200 N/m is compressed 0.3 m from its natural length. Find the elastic potential energy stored, and state where you''re setting the zero of potential energy.',
   'The stored energy is 200 times 0.3, so 60 J, measured from the ground since that''s where potential energy is normally zero.',
   'U_s = (1/2)k(deltax)^2 = (1/2)(200 N/m)(0.3 m)^2 = (1/2)(200)(0.09) = 9 J. The zero of elastic potential energy is set at the spring''s natural (uncompressed) length here -- a choice, not a universal rule -- so U_s = 9 J represents the energy relative to that chosen reference, not relative to the ground.',
   'Treating the zero of potential energy as physically fixed instead of chosen for convenience',
   'Head to practice and, on every potential-energy item, state your zero-reference point explicitly before computing -- it''s a choice you make, not a fact you look up.'),
  ('3.4',
   'A single object modeled as a point mass can only possess kinetic energy -- potential energy is never a property of one isolated object by itself. Potential energy requires a system with an internal conservative interaction (like object-and-Earth or object-and-spring); only then does the system have both K and U to track through conservation of mechanical energy.',
   'On a released FRQ, the single most common error was defaulting to a 50/50 split between kinetic and gravitational potential energy at some intermediate point, regardless of what the actual height ratio in the scenario required -- despite most students correctly understanding total-energy conservation itself.',
   'Points come from writing energy conservation as initial energy equals final energy plus any transfer or dissipation term for a correctly chosen system, and from computing the actual K/U split at an intermediate point from the real height ratio given -- not from assuming an even split.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then write an initial-energy equals final-energy plus transfer or dissipation equation for the chosen system before doing arithmetic or writing the final sentence.',
   'A 2 kg block starts from rest at the top of a frictionless ramp, 5 m above the ground. Find its kinetic and potential energy when it has descended to a height of 2 m above the ground (use g = 10 m/s^2).',
   'Since the block is partway down, kinetic and potential energy just split evenly: 50 J of kinetic energy and 50 J of potential energy.',
   'Total mechanical energy at the top: E = mgh = (2 kg)(10 m/s^2)(5 m) = 100 J, all potential, since the block starts at rest. At height 2 m, U = mgh = (2)(10)(2) = 40 J, so by conservation K = 100 - 40 = 60 J. The split is 60/40, not 50/50 -- it depends on the actual height ratio (the block has descended 3 of the original 5 m), not on assuming an even division.',
   'Putting potential energy on a single object instead of on an interacting system',
   'Back to practice: on every energy-conservation item, compute the actual potential energy at the point in question from its real height first -- never assume kinetic and potential energy split evenly.'),
  ('3.5',
   'Average power is P_avg = deltaE/deltat = W/deltat. Instantaneous power for a constant force is P = F_parallel v = Fv cos(theta) -- explicitly a derived equation, obtained from the rate of work, not an independent formula -- and this algebra-based course gives no treatment of instantaneous power when the force or velocity is changing with time (unlike a calculus-based course, no derivative notation is ever used here).',
   'Power problems test whether you track the time interval correctly -- a large amount of work done over a long time can represent less power than a smaller amount of work done quickly, so the point isn''t the energy transferred but the rate at which it''s transferred.',
   'Points come from correctly dividing energy transferred (or work done) by the actual elapsed time for average power, or from correctly identifying the force component parallel to velocity for instantaneous power -- not from reporting work or force alone as if it were power.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then relate average power to energy transfer per time and instantaneous power to the parallel force component times speed before doing arithmetic or writing the final sentence.',
   'A motor lifts a 50 kg crate straight up at a constant velocity of 2 m/s. Find the instantaneous power delivered by the lifting force (use g = 10 m/s^2).',
   'The power is just the weight of the crate, 500 N, since that''s the force doing the lifting.',
   'Since the crate moves at constant velocity, the net force is zero, so the lifting force equals the crate''s weight: F = mg = (50 kg)(10 m/s^2) = 500 N, directed parallel to the velocity (theta = 0). Instantaneous power is P = Fv cos(theta) = (500 N)(2 m/s)(1) = 1000 W -- the force alone (500 N) is not power; it must be multiplied by the speed at which it acts.',
   'Confusing a large amount of work with large power without considering time',
   'Return to practice and, whenever a problem gives you a force and asks for power, multiply by the relevant speed before reporting an answer -- force alone is never power.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific content grounded in AP_PHYSICS_1_CED_FACT_PACK.md Unit 3 section (line 252): the fact that K = (1/2)mv^2 is a scalar that is never negative and is frame-dependent for 3.1, applied to a two-observer relative-velocity worked example; the fact that constant-force work is W = Fd cos(theta) -- never a dot product or calculus treatment -- and that variable-force work is read as area under an F_parallel-vs-displacement graph for 3.2, applied to an angled-force worked example; the fact that the zero of potential energy is an observer''s choice and that mgh is explicitly an approximation of the general inverse-square gravitational form for 3.3, applied to a spring-compression worked example; the fact that a single-object system can only have K, never U, plus the documented 2024 Chief Reader Report finding that the most common bar-chart FRQ error is a default 50/50 K/U split regardless of actual height ratio for 3.4, applied to a ramp worked example that deliberately produces a 60/40 split; and the fact that instantaneous power P = Fv cos(theta) is explicitly labeled a derived equation with no time-varying-force treatment in this algebra-based course for 3.5, applied to a constant-velocity lifting worked example. All energy/work/power algebra was independently verified during authoring (3.1''s two-frame kinetic energy values recomputed from relative speed; 3.4''s mgh totals and 60/40 split recomputed and cross-checked against the stated height ratio); no physics facts or computed numbers required correction. briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-physics-1-unit3-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_1'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_1' and unit_number=3 and status='published'
      and source_note like '%unit3-explainer-repair%';
  if v_repaired <> 5 then
    raise exception 'expected 5 repaired AP Physics 1 Unit 3 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_1' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics 1 Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
