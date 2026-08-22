begin;

-- Repair AP Physics C: Mechanics Unit 3 (Work, Energy, and Power) Learn More
-- explainers -- all 5 were template-generated debt (core_idea byte-identical
-- to their paired brief's what_it_is, and mini_example_question/weak_answer
-- shared boilerplate: "A physics prompt gives a scenario involving <Title>.
-- What should your response show to earn credit?" and "I would plug into a
-- formula without defining the quantities or direction." respectively) per
-- the 2026-08-21 bulk audit. Confirmed via SQL before authoring: all 5 rows
-- carried source_note 'generated-from-brief:legacy; grandfathered-2026-08-21'
-- with no "repaired" marker, and a direct read of the current rows showed
-- core_idea byte-identical to the paired brief's what_it_is on every row,
-- plus the exact boilerplate mini_example_question and weak_answer on every
-- row -- so all 5 are genuine debt; none were an outlier that already had
-- hand-authored content. Briefs for this unit are already hand-authored and
-- correct (title, why_it_matters, how_points_are_earned, answer_move,
-- common_point_loss all topic-specific and non-templated); NOT touched here.
--
-- Grounded in docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 3
-- section (starting line 120, "Unit 3 -- Work, Energy, and Power"). A
-- separate agent is concurrently repairing AP Physics 1's algebra-based
-- Unit 3 for the same 5 topic names; this batch is that repair's
-- calculus-based sibling, covering distinct, independently authored content:
-- 3.1's frame-dependence fact (K = (1/2)mv^2 is a scalar, but different
-- observers in different reference frames may measure different K for the
-- same object because v itself is frame-dependent), applied to a
-- ground-observer-vs-moving-cart-observer kinetic-energy comparison; 3.2's
-- calculus (line-integral) definition of work, W = integral of F(r).dr,
-- absent from Physics 1's constant-force-only W=Fd*cos(theta) treatment,
-- with the constant-force case presented as a derived special case rather
-- than an independent definition, applied to integrating a genuinely
-- position-varying force F(x)=10+2x and cross-checking against the
-- area-under-the-F-vs-x-graph interpretation; 3.3's calculus (line-integral
-- and derivative) definitions, both absent from Physics 1's algebra-only
-- "using the slope" treatment -- delta-U = -integral of F_cf(r).dr and the
-- explicit derivative F_x = -dU(x)/dx -- applied to differentiating a cubic
-- potential-energy function to find force and classify an equilibrium point
-- as stable (local minimum of U) via the second derivative; 3.4's verbatim
-- boundary statement that mechanical energy can be dissipated as thermal
-- energy or sound by nonconservative forces, applied to a ramp-plus-friction
-- energy problem requiring every energy term (gravitational PE, spring PE,
-- and dissipated thermal energy) to be listed before substituting into a
-- single conservation equation; and 3.5's calculus (derivative) definition
-- of instantaneous power, P_inst = dW/dt, absent from Physics 1's
-- treatment (Physics 1 only ever gives instantaneous power via a constant
-- force, labeled a "derived equation," never a true derivative), applied to
-- differentiating an explicit W(t) function and contrasting the result
-- against the (deliberately different) average-power value over the same
-- interval. All derivatives, integrals, and numeric results were
-- independently verified during authoring (e.g. 3.2's integral of
-- (10+2x)dx from 0 to 5 recomputed and cross-checked against the trapezoid
-- area under the F-vs-x graph; 3.3's dU/dx and d^2U/dx^2 recomputed
-- term-by-term and the equilibrium classification re-derived; 3.4's
-- friction-loss and spring-compression arithmetic recomputed twice; 3.5's
-- dW/dt and W(2) recomputed independently); no physics or calculus errors
-- required correction after this independent check.
--
-- Before-state not separately captured for this batch (no prior
-- before-state export file exists for AP Physics C: Mechanics Unit 3); the
-- pre-repair content is fully recoverable from git history for this table's
-- rows if a rollback is ever needed.
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- what_it_is on every row (expands it with a new grounded fact from the fact
-- pack rather than restating it). answer_move and common_point_loss are
-- preserved verbatim from the paired brief per protocol section 4 ("the same
-- topic-specific answer_move" / "the same or refined common_point_loss") --
-- the Unit 3 briefs already carry specific, correct, calculus-appropriate,
-- non-templated point-earning language, so no refinement was needed.
-- mini_example_question/weak_answer/point_attaining_answer/practice_bridge
-- are original per-row text that was checked corpus-wide before this
-- migration was written and repeats nowhere else in the published corpus
-- (zero collisions found against every published row's matching field,
-- including against the AP Physics 1 Unit 3 batch's independently authored
-- examples for the same 5 topic names).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'Kinetic energy stays purely scalar throughout the course: K = (1/2)mv^2. But because v depends on which reference frame you measure it in, different observers in different inertial frames may correctly measure different K for the same object at the same instant.',
   'Kinetic energy is frame-dependent because velocity itself is frame-dependent -- energy-conservation problems later in this unit require picking one consistent frame at the start of the problem and using it throughout, rather than mixing velocities measured from different frames.',
   'Credit requires computing K=(1/2)mv^2 using the correct frame''s velocity, explicitly stating which observer''s frame that velocity is measured in whenever more than one observer appears, and never assigning kinetic energy a sign.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then compute kinetic energy as a scalar and keep reference-frame dependence in mind before doing arithmetic or writing the final sentence.',
   'Two observers analyze a 2 kg ball. Observer A stands on the ground and measures the ball moving at 6 m/s. Observer B rides alongside in a cart moving at 4 m/s in the same direction and measures the ball''s velocity relative to herself. Find the kinetic energy of the ball as measured by each observer.',
   'Kinetic energy is a property of the ball itself, so both observers must calculate the same 36 J regardless of their own motion.',
   'Observer A measures v = 6 m/s, so K_A = (1/2)(2)(6)^2 = 36 J. Observer B measures the ball''s velocity relative to her own frame: v_rel = 6 - 4 = 2 m/s, so K_B = (1/2)(2)(2)^2 = 4 J. Kinetic energy is frame-dependent because velocity itself is frame-dependent -- the two observers correctly disagree.',
   'Assigning a sign to kinetic energy because velocity has a sign',
   'Return to practice and, for any kinetic energy question, first establish whose reference frame the velocity is measured in -- then treat K = (1/2)mv^2 as a strictly non-negative scalar, never signed.'),
  ('3.2',
   'The general definition of work is the line integral W = integral from a to b of F(r).dr, where A.B = AB*cos(theta). The familiar W = Fd*cos(theta) is only the special case where the force is constant -- a derived equation, not the definition itself -- and work also equals the area under an F-parallel-vs-displacement graph.',
   'Every energy problem in this unit and beyond ultimately traces back to work, and because this course defines work as the general line integral rather than only the constant-force case, you are expected to recognize when a force varies with position and set up an integral (or read area under a graph) instead of reaching for W = Fd*cos(theta).',
   'Credit requires recognizing when a force is constant (justifying W = F_parallel*d) versus a function of position (requiring W = integral of F(r).dr or the area under an F-vs-x graph), and setting up that calculation before evaluating -- a final numeric answer with no visible integral or area-under-graph work is not full credit when the force varies.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then set up work as a dot product or line integral and reduce to F parallel times displacement when force is constant before doing arithmetic or writing the final sentence.',
   'A block is pulled along a horizontal surface by a force that varies with position as F(x) = (10 + 2x) N, where x is in meters, and the force stays parallel to the displacement. Find the work done as the block moves from x = 0 to x = 5 m.',
   'The force at the start is F(0) = 10 N, so W = Fd = 10(5) = 50 J.',
   'Because F(x) is not constant, integrate: W = integral from 0 to 5 of (10 + 2x) dx = [10x + x^2] from 0 to 5 = 50 + 25 = 75 J. This matches the area under the F-vs-x graph, a trapezoid from F=10 N to F=20 N over 5 m: (10+20)/2 * 5 = 75 J -- not the 50 J from using only the starting force.',
   'Using constant-force work formulas for a variable force without integrating or using graph area',
   'Back to practice: whenever force is given as a function of position, set up the integral (or find the area under the F-vs-x graph) rather than plugging a single force value into W = Fd.'),
  ('3.3',
   'Potential energy is defined by the line integral delta-U = -(integral from a to b of F_cf(r).dr) for a conservative force, and force is recovered from potential energy by a true derivative, F_x = -dU(x)/dx -- not by "reading a slope" the way an algebra-based course would. Stable equilibrium is a local minimum of U; unstable equilibrium is a local maximum.',
   'Potential energy is what turns work into a state function you can track through a system, and because this course defines the force-from-potential relationship as a true derivative, you are expected to differentiate an explicit U(x) function to find force and to locate equilibrium points as its local minima and maxima.',
   'Credit requires differentiating a given U(x) to find F_x = -dU/dx (or integrating F to find delta-U), and correctly classifying an equilibrium point as a local minimum (stable) or local maximum (unstable) of U using the second derivative -- not just stating a force value without the derivative step.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then connect conservative-force work to changes in potential energy and use slope or derivative relationships when appropriate before doing arithmetic or writing the final sentence.',
   'A particle moves along the x-axis where its potential energy is U(x) = x^3 - 3x (joules, x in meters, x > 0). Find the force on the particle at x = 2 m, and determine whether x = 1 m is a position of stable or unstable equilibrium.',
   'Since U(x) = x^3 - 3x, I would just plug x = 2 directly into U(x) to get the force: F = U(2) = 8 - 6 = 2 N.',
   'Differentiate: F_x = -dU/dx = -(3x^2 - 3) = 3 - 3x^2. At x = 2 m: F_x = 3 - 3(4) = -9 N. To classify x = 1 m, confirm dU/dx = 0 there (3(1)^2 - 3 = 0, yes), then check the second derivative d^2U/dx^2 = 6x; at x = 1 this is +6 > 0, a local minimum of U, so x = 1 m is a stable equilibrium -- not found by evaluating U itself, as the weak answer does.',
   'Treating spring potential energy as negative when a spring is compressed',
   'Return to practice and, whenever potential energy is given as a function U(x), find force by differentiating (F_x = -dU/dx), not by evaluating U itself or reading a slope by eye.'),
  ('3.4',
   'Mechanical energy is K+U for a system with internally conservative interactions. Any energy change within the chosen system is balanced by another internal change or by a transfer across the system boundary -- and, per this course''s own boundary statement, mechanical energy can be dissipated as thermal energy or sound by nonconservative forces, so a full energy accounting must include that term when friction or another nonconservative force is present.',
   'Conservation of energy is the single most tested idea in this unit, and because mechanical energy can be dissipated as thermal energy or sound by nonconservative forces, every conservation equation you write must explicitly account for every energy term present in both the initial and final states, including any that leave the mechanical-energy total.',
   'Credit requires listing every energy term present in the initial state and every term present in the final state -- including thermal energy dissipated by nonconservative forces -- before substituting into a single conservation equation; a correct-looking final number reached by silently skipping a term is not full credit.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then identify all energy terms in initial and final states before substituting into a conservation equation before doing arithmetic or writing the final sentence.',
   'A 0.5 kg block starts at rest at height h = 3 m at the top of a frictionless curved ramp, slides down, then crosses a rough horizontal surface (mu_k = 0.25) for 2 m before compressing a spring (k = 500 N/m). Using g = 10 m/s^2, find the maximum compression of the spring.',
   'Since energy is conserved, mgh = (1/2)kx^2 directly: 15 = 250x^2, so x^2 = 0.06 and x ~= 0.245 m.',
   'Choose the block-earth-spring system and list every term: initial gravitational PE = mgh = (0.5)(10)(3) = 15 J; final spring PE = (1/2)(500)x^2; thermal energy dissipated by friction = mu_k*m*g*d = (0.25)(0.5)(10)(2) = 2.5 J. Conservation gives 15 = (1/2)(500)x^2 + 2.5, so x^2 = 0.05 and x ~= 0.224 m -- dropping the friction term (as the weak answer does) overstates the compression.',
   'Omitting one spring, gravitational, or kinetic term from the selected system''s energy equation',
   'Head back to practice and, before writing any conservation equation, list every energy term present in the initial state and every term present in the final state -- including thermal energy dissipated by nonconservative forces -- so nothing gets silently dropped.'),
  ('3.5',
   'Average power is P_avg = delta-E/delta-t = W/delta-t, but instantaneous power is a true derivative, P_inst = dW/dt -- not just the constant-force special case P = F_parallel*v = Fv*cos(theta), which is a derived equation, not the definition itself.',
   'Power connects work to time, and because this course defines instantaneous power as a true derivative rather than only the derived constant-force case, you are expected to differentiate an explicit W(t) function when a question asks for the power at one specific moment rather than averaged over an interval.',
   'Credit requires differentiating an explicit W(t) to get P_inst = dW/dt (or recognizing P_inst = Fv*cos(theta) for the constant-force special case), and explicitly distinguishing an instantaneous-power request from an average-power request -- the two are graded as distinct calculations.',
   'First name the quantity, structure, condition, or representation the prompt is really asking about; then use average power as energy per time and instantaneous power as dW/dt or force dot velocity before doing arithmetic or writing the final sentence.',
   'The work done on an object is W(t) = 4t^3 - 2t^2 (joules, t in seconds) for t >= 0. Find the instantaneous power delivered at t = 2 s, and compare it to the average power delivered from t = 0 to t = 2 s.',
   'Average power is W/t, so instantaneous power at t = 2 s is also W(2)/2 = 24/2 = 12 W.',
   'Differentiate: P_inst(t) = dW/dt = 12t^2 - 4t, so P_inst(2) = 12(4) - 4(2) = 40 W. Average power uses total work over total time: W(2) = 4(8) - 2(4) = 24 J, so P_avg = (24 - 0)/2 = 12 W. The instantaneous value (40 W) differs sharply from the average (12 W) because power is still increasing at t = 2 s -- unlike the weak answer, which incorrectly treats the average-power formula as valid for a single-moment request.',
   'Using average power when the question asks for instantaneous power at a specific moment',
   'Return to practice and, whenever work or energy is given as an explicit function of time, differentiate to get instantaneous power -- don''t substitute the average-power formula W/t for a single-moment question.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered per the 2026-08-21 bulk audit) with topic-specific, calculus-based content grounded in AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md Unit 3 section (line 120): the frame-dependence fact that K=(1/2)mv^2 may differ between observers in different inertial frames for 3.1, applied to a ground-observer-vs-moving-cart-observer kinetic-energy comparison; the calculus line-integral definition of work W=integral of F(r).dr, explicitly absent from Physics 1''s constant-force-only treatment, for 3.2, applied to integrating a genuinely position-varying force and cross-checking against the area-under-the-F-vs-x-graph interpretation; the calculus line-integral and derivative definitions of potential energy (delta-U=-integral of F_cf(r).dr and F_x=-dU(x)/dx), explicitly absent from Physics 1''s "using the slope" treatment, for 3.3, applied to differentiating a cubic potential-energy function to find force and classify a stable equilibrium via the second derivative; the verbatim boundary statement that mechanical energy can be dissipated as thermal energy or sound by nonconservative forces for 3.4, applied to a ramp-plus-friction conservation problem requiring every energy term to be listed before substituting; and the calculus derivative definition of instantaneous power P_inst=dW/dt, explicitly absent from Physics 1''s constant-force-only treatment, for 3.5, applied to differentiating an explicit W(t) function and contrasting it against the average power over the same interval. All derivatives, integrals, and numeric results were independently verified during authoring; no physics or calculus errors required correction. briefs for this unit are genuinely hand-authored, already calculus-appropriate, and were NOT touched. mini-examples are independently authored and distinct from the AP Physics 1 Unit 3 repair batch''s examples for the same 5 topic names. batch 2026-08-22-ap-physics-c-mechanics-unit3-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_physics_c_mechanics'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_physics_c_mechanics' and unit_number=3 and status='published'
      and source_note like '%unit3-explainer-repair%';
  if v_repaired <> 5 then
    raise exception 'expected 5 repaired AP Physics C: Mechanics Unit 3 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_physics_c_mechanics' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Physics C: Mechanics Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
