begin;

-- Repair AP Calculus BC Unit 7 (Differential Equations) Learn More
-- explainers. Briefs were duplicated from AB's genuinely hand-authored
-- content and are correct; NOT touched here. Topics 7.5 (Euler's Method)
-- and 7.9 (Logistic Models) are BC-only (moved, not duplicated) but were
-- also template-generated debt, so both are repaired in this same batch.
--
-- AP Calculus AB's Unit 7 explainers are still grandfathered debt as of
-- this batch (not yet repaired), so there is no AB Unit 7 hand-authored
-- batch to accidentally collide with the way BC/AB Unit 4 did.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 7
-- deep-tier detail: Euler's Method has no CED-mandated formula or
-- step-size notation -- it is defined only as repeated tangent-line
-- approximation, so credit rests on recomputing the slope at the current
-- point every step; the documented misconception that all fraction-form
-- differential equations have logarithmic solutions; domain restrictions
-- on particular solutions (EK FUN-7.E.3); and the CED's explicit
-- permission to use or interpret the exponential model's solution form
-- directly without re-deriving it. Per the fact pack, Unit 7's scoring
-- signal is lower-confidence than Units 4-6/8 (no released AB FRQ
-- scoring guide yet covers a slope-field/Euler/separable item), so this
-- batch is grounded in the CED's own quoted unit-level guidance rather
-- than a specific released-FRQ scoring split.
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit7_explainer_before_state.json.
--
-- Every new explainer is genuinely topic-specific and mathematically
-- verified: core_idea differs from what_it_is on every row, and no
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge value repeats within this batch or elsewhere in the
-- corpus (checked programmatically before and after).

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('7.1',
   'A differential equation models a rate relationship, so the equation itself must be written in terms of dy/dx (or dy/dt) equal to an expression -- writing a formula for y directly, without ever expressing the rate, skips past what a differential equation model actually is.',
   'The modeling step asks only for the rate relationship as an equation, not yet its solution; solving that equation is a separate, later step handled by other topics in this unit.',
   'Full credit requires the differential equation written explicitly as dy/dx (or dy/dt) equals an expression in the relevant variables, not a solved formula for y.',
   'Identify the quantity and what its rate depends on, then write dy/dx (or dy/dt) equals that dependency as the model, stopping there rather than solving it.',
   'A snowball''s radius decreases at a rate proportional to its current radius. A student models this by writing r(t) = r0 * e^(-kt) directly as the answer.',
   'This is a correct and complete model of the situation.',
   'This is the solution to a differential equation, not the model itself -- the modeling step asks for the rate relationship as an equation: dr/dt = -kr, expressing that the rate of change is proportional to the current radius; the exponential formula for r(t) is a later result obtained by solving that differential equation, not the model requested here.',
   'Writing a formula for y instead of an equation for the rate of change.',
   'Before answering any modeling question, check whether the response is an equation for a rate (dy/dx or dy/dt equals something) or an already-solved formula, and stop at the rate equation unless solving is explicitly asked for.'),
  ('7.2',
   'Verifying a solution to a differential equation with an initial condition requires checking two separate things -- that the derivative of the proposed solution matches the equation''s right-hand side, and that the proposed solution actually passes through the given initial point -- confirming only one does not verify the whole claim.',
   'These are two independent checks: the differentiation-and-substitution check confirms the equation is satisfied everywhere, while the initial-condition check confirms this particular member of the solution family is the one asked about.',
   'Full credit requires both checks shown explicitly when both are part of the claim: differentiate and substitute to verify the equation, and separately substitute the initial x and y values to verify the condition.',
   'When asked to verify a particular solution, perform both checks as separate explicit steps: differentiate-and-substitute for the equation, then plug in the initial point for the condition.',
   'A student is asked to verify that y = 3e^(2x) - 1 is the particular solution to dy/dx = 2y + 2 with y(0) = 2, and only checks that the derivative of 3e^(2x) - 1 equals 2(3e^(2x)-1) + 2.',
   'This is a complete verification, since the differential equation checks out.',
   'The equation check alone is incomplete -- verifying a particular solution also requires confirming the initial condition: substituting x=0 gives y = 3e^0 - 1 = 2, which does match y(0)=2, so this specific check also needs to be shown; verifying only the equation leaves the ''particular'' part of the claim (that this is the specific solution satisfying that initial point) unconfirmed.',
   'Checking only the initial condition or only the equation, rather than verifying both when both are asked.',
   'Whenever a proposed solution comes with an initial condition, verify the differential equation and the initial condition as two separate, explicitly shown steps.'),
  ('7.3',
   'Each segment in a slope field represents only the local slope, computed from dy/dx at that single point -- the segment''s length or its connection to neighboring segments carries no meaning, since a slope field is a grid of independent local directions, not a sketch of any one solution curve.',
   'Sketching a field correctly means treating every point as its own independent slope calculation; a segment drawn too long, or drawn to visually connect with the next one, misrepresents what the field is actually showing.',
   'Full credit requires the slope computed correctly at each specified point and drawn as a short segment with the correct sign and relative steepness, not as part of a continuous curve.',
   'Compute dy/dx independently at each given point, then draw a short segment with that exact sign and steepness, without connecting it visually to neighboring points.',
   'For dy/dx = x - y, a student draws segments at (0,0), (1,0), and (2,0), then connects them into one smooth continuous curve to make the sketch look cleaner.',
   'This is fine, since a smooth connected curve is easier to read than separate segments.',
   'Each point''s segment must be computed and drawn independently -- at (0,0), dy/dx = 0 (flat); at (1,0), dy/dx = 1 (positive slope); at (2,0), dy/dx = 2 (steeper positive slope); connecting these into one smooth line misrepresents the field, since each segment only shows the local slope at that exact point, not a piece of an actual solution curve.',
   'Drawing solution curves when the task asks for field segments, or ignoring the sign of the slope.',
   'Before sketching any slope field, compute dy/dx independently at each required point and draw only a short segment there, resisting the urge to connect segments into a smooth curve.'),
  ('7.4',
   'A slope field''s segments describe directions a solution curve would follow, not the values of y itself -- reading the field as if it were a direct graph of y against x, rather than as instructions for how a solution moves, answers the wrong question about the picture.',
   'Qualitative reasoning from a slope field means tracing how a solution curve would move by following the local directions point to point, including recognizing where segments flatten toward an equilibrium or where the direction reverses.',
   'Full credit requires the described behavior (increasing, decreasing, leveling off, or changing direction) tied explicitly to following the field''s local slope directions from the given starting point, not just a description of the picture''s general appearance.',
   'Starting from the given point, trace the solution curve by following the local slope directions step by step, and describe behavior in terms of what those directions imply.',
   'A slope field shows segments that flatten toward zero slope as y approaches 5 from below, for all starting points with y less than 5. A student says ''the graph has a horizontal asymptote at y=5.''',
   'This is a correct reading of the slope field.',
   'The conclusion is directionally right but stated as if reading a graph of y directly, rather than reasoning from the field -- the correct qualitative statement is that a solution curve starting below y=5 approaches y=5 as its limiting (equilibrium) behavior, since the slope field shows the rate of change itself approaching zero there; the field shows directions a solution follows, not a plotted curve of y-values to read off directly.',
   'Reading the slope field as a graph of y-values rather than as directions for solution curves.',
   'Before describing any slope-field behavior, explicitly trace a solution curve from the given starting point by following local directions, rather than reading the field as a plotted graph.'),
  ('7.5',
   'Euler''s Method has no single CED-mandated formula or step-size notation -- it is defined conceptually as repeated tangent-line approximation, so what actually earns credit is using the current point''s own slope for each step, not any particular symbolic convention.',
   'This BC-only technique repeats the same tangent-line-approximation idea used in linearization, just applied step by step: at each stage, the slope must come from the point you are currently standing at, not from where you are heading or from an earlier point.',
   'Full credit requires the slope recomputed from the current (x,y) point at every single step, each step''s change in y equal to that current slope times the step size, and no steps skipped between the start and the target x-value.',
   'At every step, recompute the slope using the point you currently have, multiply by the step size to get the change in y, update to the new point, and repeat without skipping any intermediate step.',
   'Using dy/dx = x + y with step size 0.5 starting at (0,1), a student computes the first step''s slope correctly, but for the second step reuses the same starting slope value instead of recomputing it at the new point.',
   'This is fine, since the slope does not change much over one small step.',
   'Euler''s Method requires the slope recomputed at the current point for every single step, not reused from an earlier point -- after the first step moves to a new (x,y), the second step''s slope must be evaluated at that new point using dy/dx = x + y again, since using a stale slope value from the previous step breaks the method''s defining tangent-line-at-the-current-point idea, even though there is no single CED-mandated formula dictating the notation used to write this out.',
   'Using the slope from the endpoint instead of the current point or skipping intermediate steps.',
   'For every Euler''s Method step, explicitly recompute the slope at the point you currently have before moving to the next step, and never reuse an earlier step''s slope value.'),
  ('7.6',
   'The CED states directly that failing to separate variables, or omitting the constant of integration, severely limits the points a student can earn -- these are not minor stylistic slips, they are treated as substantive breaks in the required solution method.',
   'A documented misconception is assuming every differential equation involving fractions has a logarithmic solution; the actual antiderivative depends entirely on the specific separated expression, and forcing a logarithmic form onto the wrong structure produces a genuinely incorrect antiderivative.',
   'Full credit requires the variables fully separated (all y-terms with dy, all x-terms with dx) as an explicit step, both sides integrated using the antiderivative rule that actually matches each side''s structure, and +C included.',
   'Separate all y-terms with dy from all x-terms with dx as an explicit step, integrate each side using the rule matching its actual structure (not an assumed logarithmic form), and include +C.',
   'For dy/dx = x/y^2, a student separates to get y^2 dy = x dx, then integrates the left side as ln|y| dx (assuming a logarithmic solution) instead of using the power rule.',
   'Using a logarithmic antiderivative is a safe default for any differential equation involving fractions like this.',
   'Not every fraction-form differential equation has a logarithmic solution -- this is a documented misconception; y^2 dy integrates by the power rule to y^3/3 + C, not a logarithmic expression, since the separated left side is a simple power of y, not 1/y; the antiderivative rule must match the actual separated expression''s structure, not a default assumption based on the equation merely containing a fraction.',
   'Mixing x and y after separation or omitting the integration constant.',
   'After separating variables, check the actual structure of each side before choosing an antiderivative rule, rather than defaulting to a logarithmic form just because the original equation involved a fraction.'),
  ('7.7',
   'A general solution found by separation of variables can be subject to domain restrictions -- the algebraic solution formula may only be valid on the connected piece of its domain that actually contains the given initial point, not across its entire algebraic domain.',
   'Solving for C using the initial condition determines one specific curve from the general family, but that curve''s valid domain must also be checked against the initial point, since some particular solutions are legitimately restricted to less than their full algebraic domain.',
   'Full credit requires solving generally, substituting the initial condition to determine C, presenting the particular solution, and checking whether the initial point restricts the solution''s valid domain.',
   'Solve generally, substitute the initial condition explicitly to solve for C, present the particular solution, then check whether the initial point restricts which piece of the domain is valid.',
   'Separation of variables on dy/dx = -x/y with y(0) = 2 gives x^2 + y^2 = C, and substituting the initial condition gives C = 4, so a student presents the particular solution as x^2 + y^2 = 4 for all real x.',
   'This is the complete particular solution, since C has been correctly determined.',
   'The equation x^2 + y^2 = 4 is correct, but presenting it as valid for all real x ignores the domain restriction the initial condition implies -- since y(0)=2 is positive, the particular solution must be restricted to y = sqrt(4 - x^2), the upper semicircle, valid only for -2 <= x <= 2, not the full implicit relation or an unrestricted domain; the initial condition determines which branch and which domain are actually valid, not just the value of C.',
   'Leaving the answer with an undetermined C or applying the initial condition to the derivative instead of the solution.',
   'After determining C from the initial condition, check explicitly whether that same initial point restricts the particular solution to less than its full algebraic domain.'),
  ('7.8',
   'The exponential model dy/dt = ky with solution y = y0*e^(kt) may be used or interpreted directly, without re-deriving it from the differential equation each time -- a response is not required to re-solve the differential equation by separation whenever the exponential form is already the appropriate model.',
   'Recognizing the dy/dt = ky structure (rate proportional to the current amount) is what identifies this as an exponential model in the first place; the sign of k then determines growth (k>0) versus decay (k<0), which must be interpreted in the context given.',
   'Full credit requires the dy/dt = ky structure recognized explicitly, the exponential solution form applied with the correct initial value, and the sign of k interpreted correctly in context.',
   'Confirm the rate is proportional to the current amount (dy/dt = ky), then apply y = y0*e^(kt) directly using the given initial value and interpret the sign of k.',
   'A quantity decays at a rate proportional to its current amount, with k = -0.3 and y0 = 50. A student re-derives the solution from scratch via separation of variables before using it, treating this as a required step.',
   'Re-deriving the solution from separation of variables is always required before it can be used.',
   'Re-derivation is not required here -- the CED explicitly permits the exponential model''s solution form to be used or interpreted directly once dy/dt = ky is recognized; the correct response applies y = 50*e^(-0.3t) directly, using the negative k to confirm this is decay, without needing to re-solve the differential equation by separation as if starting from nothing.',
   'Using a linear model when the rate depends on the current amount.',
   'Once a rate is confirmed proportional to the current amount, apply the exponential solution form directly with the correct initial value rather than re-deriving it every time.'),
  ('7.9',
   'A logistic model''s rate of change depends on both the current population size and its distance from the carrying capacity -- setting the rate expression equal to zero identifies the two equilibrium values (zero and the carrying capacity), and growth is fastest exactly halfway between them, not at either equilibrium.',
   'This BC-only model is genuinely different from ordinary exponential growth: the rate factor includes a term that shrinks toward zero as the population approaches carrying capacity, so the growth rate itself changes shape rather than staying proportional to population size alone.',
   'Full credit requires the equilibrium values found by setting the logistic rate expression to zero, the carrying capacity identified as the nonzero equilibrium, and the fastest-growth point identified as half of the carrying capacity, not confused with either equilibrium.',
   'Set the logistic differential equation''s right-hand side to zero to find both equilibria, identify the nonzero one as the carrying capacity, and locate fastest growth at half that value.',
   'For dP/dt = 0.4P(1 - P/800), a student is asked where the population is growing fastest and answers ''at P = 800, the carrying capacity, since that is where the model is heading.''',
   'This is correct, since growth should be fastest as the population approaches its final size.',
   'This reverses the actual behavior -- at P = 800 (the carrying capacity), the rate dP/dt equals zero, meaning growth has stopped entirely, not peaked; setting 0.4P(1-P/800) = 0 gives the two equilibria P=0 and P=800, and the logistic model''s fastest growth occurs at exactly half the carrying capacity, P=400, where the product P(1-P/800) is maximized, not at either equilibrium value.',
   'Treating logistic growth as ordinary exponential growth with no upper limit.',
   'For any logistic model, set the rate expression to zero to find both equilibria first, then locate fastest growth at half the carrying capacity rather than assuming it occurs near either equilibrium.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously duplicated-from-AB, then generated-from-brief, grandfathered) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 7 deep-tier detail (Euler''s Method as repeated tangent-line approximation with no CED-mandated formula or notation -- credit rests on recomputing the slope at the current point every step, not a specific symbolic convention -- the documented not-all-fraction-DEs-are-logarithmic misconception, domain restrictions on particular solutions per EK FUN-7.E.3, and the CED''s explicit permission to use the exponential solution form directly without re-derivation); this unit''s scoring-architecture signal is lower-confidence than Units 4-6/8 per the fact pack (no released AB FRQ scoring guide yet covers a slope-field/Euler/separable item), so content here is grounded in the CED''s own quoted unit-level guidance rather than a specific released-FRQ scoring split; AP Calculus AB''s Unit 7 explainers are still grandfathered debt as of this batch, so every mini-example here is checked only against the corpus-wide distinctness query, not against an AB Unit 7 repair that does not yet exist; batch 2026-08-21-ap-calculus-bc-unit7-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 7
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=7 and status='published'
      and source_note like '%unit7-explainer-repair%';
  if v_repaired <> 9 then
    raise exception 'expected 9 repaired AP Calculus BC Unit 7 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=7 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 7 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
