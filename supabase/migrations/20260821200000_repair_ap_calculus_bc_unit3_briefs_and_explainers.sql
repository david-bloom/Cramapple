begin;

-- Repair AP Calculus BC Unit 3 (Differentiation: Composite, Implicit, and
-- Inverse Functions) -- BOTH point briefs and Learn More explainers.
--
-- Unlike every other repair batch today, Unit 3's briefs were ALSO debt, not
-- just the explainers: all 6 briefs followed one filler template ('X is the
-- <unit title> topic where you turn the concept into an AP-ready action: Y')
-- with only Y swapped per topic -- discovered while pulling this unit's
-- briefs to anchor the explainer repair. This is unlike Unit 1, where the
-- briefs were genuinely good and only explainers needed repair. Every other
-- BC unit's briefs (2, 4-8) were duplicated from AB's genuinely hand-authored
-- content and do not have this problem.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 3 deep-tier
-- detail -- the highest-error-density unit in the whole Units 1-3 range per
-- the Chief Reader Report (AB6, the flagship implicit-differentiation FRQ,
-- mean 4.12/9): the CED's own chain-rule misapplication note (forgetting the
-- inner-function factor), and the 5 documented implicit-differentiation
-- errors, most notably the vertical-vs-horizontal tangent inversion (setting
-- the numerator to zero when the denominator was required).
--
-- Before-state for both briefs and explainers captured at
-- docs/research/topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit3_before_state.json.
--
-- Every new row is genuinely topic-specific and mathematically verified:
-- core_idea differs from what_it_is on every row, and no
-- mini_example_question / weak_answer / point_attaining_answer /
-- practice_bridge value repeats within this batch or elsewhere in the
-- corpus (checked programmatically before and after).

with brief_updates (
  topic_code, what_it_is, why_it_matters, how_points_are_earned, answer_move,
  common_point_loss
) as (
  values
  ('3.1',
   'The chain rule differentiates a composite function f(g(x)) by multiplying the derivative of the outer function, evaluated at the inner function, by the derivative of the inner function itself.',
   'The CED''s own scoring notes flag forgetting the inner-function factor as a common, real point-losing error, and nearly every derivative beyond a bare polynomial on this exam involves a composition.',
   'You earn points by correctly identifying which piece is the outer function and which is the inner function, and by explicitly multiplying by the inner function''s derivative rather than stopping after the outer function.',
   'Identify the outer function and the inner function separately, differentiate the outer function and evaluate it at the inner function, then multiply the result by the inner function''s own derivative.',
   'Differentiating the outer function correctly but forgetting to multiply by the inner function''s derivative, or misidentifying which piece is the inner function.'),
  ('3.2',
   'Implicit differentiation finds dy/dx from an equation relating x and y that is not solved for y, by differentiating both sides with respect to x and treating y as a function of x via the chain rule.',
   'This underlies tangent-line and related-rates questions whenever a curve is not solved for y, and the Chief Reader Report documents specific ways students lose points here despite understanding the concept.',
   'You earn points by attaching dy/dx correctly to every y-term via the chain rule, collecting dy/dx terms with parentheses around any coefficient, and, for a vertical-tangent question, setting the denominator, not the numerator, of dy/dx equal to zero.',
   'Differentiate both sides with respect to x, attach dy/dx to every y-term, collect dy/dx terms with parentheses around the coefficient, then solve; for a vertical tangent, set the denominator equal to zero, not the numerator.',
   'Setting the numerator of dy/dx equal to zero, the horizontal-tangent condition, when the question actually asks for a vertical tangent, which requires the denominator equal to zero.'),
  ('3.3',
   'If g is the inverse of f, then g''(x) equals the reciprocal of f''(g(x)) -- the derivative of the inverse at a point is tied to the derivative of the original function evaluated at the corresponding swapped point.',
   'This lets students find an inverse function''s derivative without ever solving for the inverse function''s formula, using only known values of the original function and its derivative.',
   'You earn points by correctly identifying the corresponding point on the original function, swapping x and y from the point given for the inverse, before taking the reciprocal of that derivative value.',
   'If asked for g''(a) where g is the inverse of f, first find the point b such that f(b) = a, then compute g''(a) as 1 divided by f''(b).',
   'Taking the reciprocal of f''(a) directly instead of first finding the corresponding input b where f(b) = a.'),
  ('3.4',
   'Each inverse trigonometric function has its own specific derivative formula, for example the derivative of arcsin(x) is 1 over the square root of 1 minus x squared, distinct from the derivatives of sine, cosine, or tangent themselves.',
   'These formulas appear combined with the chain rule throughout the course, and mistaking an inverse-trig derivative for a regular trig derivative produces a completely different, incorrect expression.',
   'You earn points by citing the correct inverse-trig derivative formula, not a regular trig derivative, and applying the chain rule correctly when the inverse-trig function''s argument is itself a function of x.',
   'Identify which inverse-trig function is present, recall its specific derivative formula, then apply the chain rule if its argument is more than just x.',
   'Reaching for the derivative of sine, cosine, or tangent instead of the distinct inverse-trig derivative formula.'),
  ('3.5',
   'This topic is about recognizing which derivative rule or combination of rules -- product, quotient, chain, implicit, inverse, or inverse-trig -- fits a given function''s structure before differentiating.',
   'Misreading a function''s structure and reaching for the wrong rule, such as the product rule on a composition, wastes the setup even when the arithmetic that follows is technically correct.',
   'You earn points by correctly classifying the function''s structure and naming the matching procedure before carrying out any differentiation.',
   'Before differentiating, ask whether the expression is a product of two functions, a quotient, a composition, an implicit relationship, or an inverse function, and name the matching rule.',
   'Using the product rule on an expression that is actually a composition requiring the chain rule.'),
  ('3.6',
   'Higher-order derivatives are found by differentiating repeatedly -- the second derivative is the derivative of the first derivative, the third is the derivative of the second, and so on.',
   'Questions about acceleration, concavity, and rate-of-change-of-a-rate all require a second or higher derivative, and stopping at the first derivative when a higher one was requested leaves the actual question unanswered.',
   'You earn points by differentiating the correct number of times for what the question actually asks, and by correctly interpreting what a second derivative means in context, such as acceleration or concavity, when asked.',
   'Identify how many times you need to differentiate based on what is being asked (velocity needs one derivative of position, acceleration needs two), then differentiate that many times.',
   'Stopping after the first derivative when the question asks for acceleration, concavity, or another second-derivative quantity.')
)
update app.topic_point_briefs b
set
  what_it_is = u.what_it_is,
  why_it_matters = u.why_it_matters,
  how_points_are_earned = u.how_points_are_earned,
  answer_move = u.answer_move,
  common_point_loss = u.common_point_loss,
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated brief (the prior ''cramapple-authored'' row was itself a filler template -- ''X is the <unit title> topic where you turn the concept into an AP-ready action: Y'' repeated across all 6 Unit 3 topics with only Y swapped) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 3 deep-tier detail (the CED''s own chain-rule misapplication note, the 5 documented implicit-differentiation errors including the vertical-vs-horizontal tangent inversion, all confirmed against the 2025 Chief Reader Report); repair reason: brief was template filler, not topic-specific content, discovered while auditing the paired explainer debt; batch 2026-08-21-ap-calculus-bc-unit3-repair; author=reviewer same session, no independent human review yet'
from brief_updates u
where b.subject_key = 'ap_calculus_bc'
  and b.unit_number = 3
  and b.topic_code = u.topic_code;

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('3.1',
   'The chain rule''s most common failure mode is not the formula itself -- it is misidentifying which piece is the inner function, especially inside forms like sin squared of x or e to a squared power, where the inner function is not obviously separate from the outer one.',
   'sin^2(x) means (sin x)^2, so the outer function is squaring and the inner function is sin x -- differentiating this requires both the power rule on the outside and the derivative of sin x on the inside; stopping after the power rule alone is the single most common way this topic loses points.',
   'Full credit requires both differentiating the outer function correctly and explicitly multiplying by the inner function''s derivative -- a response that nails the outer step but omits the inner factor still loses the point.',
   'Before differentiating, write down explicitly which piece is inner and which is outer -- for sin^2(x), inner = sin x, outer = squaring; then differentiate outer at inner, times inner''s own derivative.',
   'Differentiate f(x) = sin^2(x).',
   'f''(x) = 2 sin(x).',
   'f''(x) = 2 sin(x) times cos(x), since the outer function is squaring (derivative 2 times the inside) and the inner function is sin(x), whose own derivative cos(x) must also be multiplied in.',
   'Differentiating the outer function correctly but forgetting to multiply by the inner function''s derivative, or misidentifying which piece is the inner function.',
   'For every composite function, write ''inner ='' and ''outer ='' explicitly before differentiating -- this catches the single most common chain rule error before it happens.'),
  ('3.2',
   'Horizontal and vertical tangents are found from opposite parts of dy/dx once it is written as a single fraction -- horizontal tangents come from the numerator equal to zero, vertical tangents come from the denominator equal to zero, and the Chief Reader Report documents swapping these as a real, common error.',
   'Once dy/dx is solved for and expressed as a fraction, a horizontal tangent occurs where the top, the numerator, is zero, and a vertical tangent occurs where the bottom, the denominator, is zero -- reaching for the wrong one is the single most reader-documented implicit-differentiation error.',
   'Full credit for a vertical-tangent question requires explicitly setting the denominator of dy/dx to zero, not the numerator, and, per the Scoring Guidelines, explicitly stating which resulting root satisfies the problem''s domain restriction if more than one root results.',
   'Solve for dy/dx as a single fraction, then match the tangent type to the correct part: numerator = 0 for horizontal, denominator = 0 for vertical -- and if multiple roots result, state explicitly which one satisfies the problem''s domain.',
   'A curve is defined by x^2 + y^2 - 4x = 0. Find the location(s) of any vertical tangent lines.',
   'Set the numerator of dy/dx equal to zero and solve.',
   'Implicit differentiation gives dy/dx = (2-x)/y; a vertical tangent occurs where the denominator y = 0, not where the numerator is zero, so substituting y = 0 back into the original equation gives x = 0 or x = 4 as the vertical-tangent locations.',
   'Setting the numerator of dy/dx equal to zero, the horizontal-tangent condition, when the question actually asks for a vertical tangent, which requires the denominator equal to zero.',
   'Whenever a question asks for a vertical tangent, say ''denominator equals zero'' before writing any equation -- this is the exact spot the Chief Reader Report documents students getting backwards.'),
  ('3.3',
   'The reciprocal-slope relationship works at corresponding points, not the same input value -- finding g''(a) requires first locating the input b on the original function where f(b) = a, then taking the reciprocal of f''(b), never the reciprocal of f'' evaluated at a itself.',
   'Swapping x and y is the whole trick here: since g is f''s inverse, g(a) = b exactly when f(b) = a, so g''(a) is the reciprocal of the original function''s derivative at b, not at a.',
   'Full credit requires explicitly finding the corresponding input b, where f(b) equals the value you were given, before taking any reciprocal -- skipping straight to 1/f''(a) is the single most common way this topic loses points.',
   'Write ''g(a) = b means f(b) = a'' explicitly, solve for b, then compute g''(a) = 1/f''(b), never 1/f''(a).',
   'Given f(3) = 7 and f''(3) = 5, and g is the inverse of f, find g''(7).',
   'g''(7) = 1/f''(7).',
   'Since f(3) = 7, g(7) = 3; therefore g''(7) = 1/f''(3) = 1/5, using the derivative at the corresponding input 3, not at the input 7 itself.',
   'Taking the reciprocal of f''(a) directly instead of first finding the corresponding input b where f(b) = a.',
   'Before taking any reciprocal, write out explicitly which input on the original function corresponds to the value you were given for the inverse.'),
  ('3.4',
   'arcsin, arccos, and arctan each have their own derivative formula built from square roots or denominators of 1 plus or minus x squared -- these formulas look nothing like the derivatives of sine, cosine, or tangent, and confusing the two produces an answer with the wrong structure entirely, not just a sign error.',
   'The derivative of arctan(x) is 1/(1+x^2), a completely different algebraic form from the derivative of tan(x), which is sec^2(x) -- these are not related formulas that can be confused for partial credit, they are structurally unrelated.',
   'Full credit requires citing the specific inverse-trig formula matching the function present, then correctly chaining through if the argument is itself a function of x, not a regular trig derivative substituted in its place.',
   'Before differentiating, name which specific inverse-trig function is present and recall its distinct formula, rather than defaulting to a regular trig derivative from habit.',
   'Differentiate f(x) = arctan(3x).',
   'f''(x) = sec^2(3x) times 3.',
   'f''(x) = 3/(1+(3x)^2), using the arctan derivative formula 1/(1+u^2) with u = 3x, then multiplying by u'' = 3 via the chain rule, not the tangent derivative formula.',
   'Reaching for the derivative of sine, cosine, or tangent instead of the distinct inverse-trig derivative formula.',
   'Before differentiating any inverse-trig expression, write out its specific formula first, separately from the chain-rule step, so you never substitute a regular trig derivative by habit.'),
  ('3.5',
   'The real skill tested here is reading a function''s structure correctly -- h(x) = (3x+1)^5 looks like it could involve a product, but it is a single composed function requiring the chain rule, not a product of two separate factors.',
   'A product rule applies to two genuinely separate factors multiplied together, like x times sin(x); a chain rule applies to one function raised to a power or nested inside another, like (3x+1)^5 -- these look superficially similar but require completely different procedures.',
   'Full credit requires naming the correct procedure from the function''s actual structure before differentiating, not applying a rule by habit or pattern-matching to the most recently practiced technique.',
   'Ask whether you are looking at two separate factors multiplied together (product rule) or one expression nested inside another (chain rule), and name your answer before differentiating.',
   'Differentiate h(x) = (3x+1)^5.',
   'Use the product rule, treating (3x+1) and itself raised to the 4th power as two factors.',
   'This is a single composed function, not a product of separate factors, so the chain rule applies: h''(x) = 5(3x+1)^4 times 3, the derivative of the outer power function times the derivative of the inner expression.',
   'Using the product rule on an expression that is actually a composition requiring the chain rule.',
   'Before applying any rule, ask whether you are looking at two separate factors multiplied (product) or one expression nested inside another (chain) -- these are the two structures most often confused.'),
  ('3.6',
   'The number of times you differentiate has to match what is actually being asked -- velocity requires one derivative of position, acceleration requires two, and stopping one derivative short means the final answer, however carefully computed, answers the wrong question entirely.',
   'A second derivative does not just mean differentiate twice as a mechanical instruction -- in context it specifically represents the rate of change of a rate, such as acceleration, the rate of change of velocity, or concavity, the rate of change of slope.',
   'Full credit requires differentiating the exact number of times the question requires and stating the resulting value with its correct contextual meaning, acceleration, concavity, or another named second-derivative quantity, not stopping at velocity or slope when asked for the rate of the rate.',
   'Before differentiating, identify exactly what quantity is being requested -- position, velocity, or acceleration; slope or concavity -- then differentiate the matching number of times for that quantity.',
   'Given position function s(t) = t^3 - 6t^2 + 9t, find the acceleration at t = 2.',
   's''(2) = 3(2)^2 - 12(2) + 9 = 12 - 24 + 9 = -3, so the acceleration is -3.',
   'Acceleration requires the second derivative: s''''(t) = 6t - 12, so s''''(2) = 6(2) - 12 = 0; the value s''(2) computed above is velocity, not acceleration.',
   'Stopping after the first derivative when the question asks for acceleration, concavity, or another second-derivative quantity.',
   'Before differentiating, write down exactly which quantity is being asked for and how many derivatives that requires -- this catches the single most common way this topic loses points, stopping one derivative short.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously source_note ''generated-from-brief:legacy; grandfathered-2026-08-21'') with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 3 deep-tier detail; repair reason: grandfathered explainer restated the (also template-generated) paired brief verbatim; batch 2026-08-21-ap-calculus-bc-unit3-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 3
  and e.topic_code = u.topic_code;

do $$
declare
  v_core_matches integer;
begin
  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=3 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 3 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
