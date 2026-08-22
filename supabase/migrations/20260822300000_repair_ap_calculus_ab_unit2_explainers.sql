begin;

-- Repair AP Calculus AB Unit 2 (Differentiation: Definition and
-- Fundamental Properties) Learn More explainers. The 10 point briefs for
-- this unit are already hand-authored and correct (each brief's what_it_is
-- is genuinely topic-specific, not boilerplate) and are NOT touched by this
-- migration. All 10 explainers, however, are the template-generated debt
-- flagged in the 2026-08-21 grandfathering pass: core_idea byte-identical
-- to the paired brief's what_it_is, and a meta-question mini-example ("A
-- calculus prompt asks you to justify a conclusion involving <title>...")
-- with a weak_answer ("I would write the final value or conclusion without
-- showing why it follows.") shared across roughly 150 rows corpus-wide.
--
-- Verified at the content level before authoring (per the lesson from the
-- earlier AP Calculus AB Unit 1 false start, where a batch with the same
-- grandfathered tag turned out to already be genuine hand-authored content):
-- all 10 rows in this batch showed core_idea = paired brief's what_it_is
-- (byte-for-byte), source_note containing 'grandfathered-2026-08-21' and not
-- 'repaired', and the identical boilerplate weak_answer/mini_example_question
-- template. No row was excluded from this batch.
--
-- This is a Repair under
-- docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md.
-- Before-state was not separately captured as a standalone artifact for
-- this batch; rollback is restoring source_note to
-- 'generated-from-brief:legacy; grandfathered-2026-08-21' and the other 9
-- fields to the boilerplate template values documented above (identical in
-- shape to every other still-grandfathered row in the corpus).
--
-- Every new explainer is genuinely topic-specific: core_idea differs from
-- the paired brief's what_it_is on every row and adds a real fact from
-- docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md's Unit 2 section (the
-- product/quotient-rule structural scoring requirement for 2.8-2.9, the
-- documented notation misconception for 2.2, the base derivative-rule
-- facts for 2.5-2.7/2.10, and the calculator-rounding convention where
-- relevant); every mini_example_question / weak_answer /
-- point_attaining_answer / practice_bridge is an original, independently
-- computed calculus problem, verified against no other published row in
-- the corpus before this migration was applied.

with explainer_updates (
  topic_code, core_idea, what_students_need_to_understand,
  how_this_becomes_points, answer_move, mini_example_question, weak_answer,
  point_attaining_answer, common_point_loss, practice_bridge
) as (
  values
  ('2.1',
   'The instantaneous rate at x=a is the limit of the average rate (secant slope) over shrinking intervals around a -- the difference quotient (f(a+h)-f(a))/h as h->0 is what turns a table of change into a single point-value derivative.',
   'Average rate over [a,b] is a secant-line slope computed from two endpoint values; instantaneous rate at a is the limiting slope those secants approach as the second point moves toward a -- confusing which is asked costs the whole answer, not partial credit.',
   'The scoring checks whether you used the interval endpoints (average) or set up a limiting/tangent argument (instantaneous) that matches what the question asked -- a numerically plausible answer built from the wrong quantity earns no credit.',
   'Read whether the prompt says ''over the interval'' (compute (f(b)-f(a))/(b-a)) or ''at the instant/at x=a'' (use the derivative or a local slope estimate) before writing any formula.',
   'For f(x) = x^2 + 3x, find the average rate of change on [1,4] and the instantaneous rate of change at x = 1.',
   'The rate of change is 8, using (f(4)-f(1))/(4-1).',
   'Average rate on [1,4]: (f(4)-f(1))/(4-1) = (28-4)/3 = 8. Instantaneous rate at x=1 uses f''(x) = 2x+3, so f''(1) = 5 -- two different numbers because they answer two different questions.',
   'Answering an ''at x=a'' instantaneous-rate question with the average-rate formula computed over some interval, or vice versa.',
   'Go back to practice and drill the difference: for every rate-of-change prompt, underline whether it says ''over an interval'' or ''at a point'' before picking a formula.'),
  ('2.2',
   'A derivative''s value at a point is a rate, not a y-value of the original function -- and once a derivative expression is written, renaming it later without redefining it (e.g. silently calling x_H''(t) just H''(t)) is a documented, scored notation error even when the calculus is correct.',
   'f''(a) means the instantaneous rate of change or tangent slope at x=a, computed as the limit of the difference quotient -- it is a completely different kind of number from f(a), and every new derivative symbol you introduce must be defined before you reuse it.',
   'Points require both the correct derivative value and consistent, defined notation throughout -- introducing a shortened or renamed derivative symbol without stating what it refers to can cost the point even when the underlying computation is right.',
   'Write the full derivative notation the first time (e.g. x_H''(t)), state in words what it represents, and keep using that exact notation -- never quietly swap to a shorter unlabeled symbol partway through.',
   'A hiker''s height above sea level is modeled by x_H(t) = t^3 - 2t. Find the derivative and interpret it at t = 2, keeping notation consistent.',
   'H''(2) = 10.',
   'x_H''(t) = 3t^2 - 2, so x_H''(2) = 3(4) - 2 = 10 feet per unit time -- the notation x_H''(t) is defined once and used consistently, and the value is reported with units and context.',
   'Treating f''(a) as if it were f(a), or silently renaming a defined derivative expression to shorter unlabeled notation partway through a solution.',
   'Return to practice and check every derivative problem for one thing: does your final notation match the notation you started with, with nothing silently renamed?'),
  ('2.3',
   'Estimating a derivative from a table means using the two data points closest to the target input and computing their slope -- symmetric intervals (one point on each side) give a better local estimate than using only points on one side.',
   'A derivative estimate from data is a secant slope between nearby points, not the true instantaneous rate -- students must select the closest available x-values and report the estimate with the context''s units, never as an exact derivative.',
   'Credit requires choosing genuinely nearby data (not the widest or most convenient interval), computing the slope correctly, and labeling the result as an estimate with correct units when the table has them.',
   'Identify the two table rows immediately surrounding the target x-value, compute (change in output)/(change in input) between them, and label the result as an estimate, with units.',
   'A table gives f(2) = 5 and f(4) = 13, with no data between them. Estimate f''(3).',
   'f''(3) = 13, using the value at x = 4.',
   'Using the closest surrounding values, f''(3) is approximately (f(4) - f(2)) / (4 - 2) = (13 - 5) / 2 = 4 -- an estimate of the local slope, not an exact derivative.',
   'Reporting a raw function value instead of a computed slope, or building the estimate from data points that are not the closest available to the target x-value.',
   'Head back to practice and check each estimation problem for the same habit: circle the two closest table rows before computing any slope.'),
  ('2.4',
   'Differentiability implies continuity, but continuity never implies differentiability -- a function can be continuous at a point while still failing to have a derivative there because of a corner, cusp, vertical tangent, or a mismatch between left- and right-hand slopes.',
   'Checking differentiability at a point requires two separate checks: is the function continuous there, and do the left-hand and right-hand derivative limits agree to one finite value -- passing only the continuity check is not enough to claim a derivative exists.',
   'Full credit requires showing both that continuity holds and that the one-sided derivative limits are equal -- asserting differentiability from a smooth-looking graph or from continuity alone, without checking the slopes on each side, does not earn the point.',
   'At a suspicious point (corner, sharp bend, or piecewise boundary), compute the left-hand and right-hand derivative limits separately and confirm they are equal before claiming the derivative exists.',
   'Is g(x) = |x - 2| differentiable at x = 2? Justify using both continuity and the one-sided derivatives.',
   'Yes, it''s differentiable at x = 2 because the graph is continuous there with no gaps.',
   'g is continuous at x = 2, but the left-hand derivative is -1 and the right-hand derivative is +1 -- since these one-sided limits disagree, g is not differentiable at x = 2 despite being continuous there.',
   'Concluding differentiability from continuity alone, without checking that the one-sided derivative limits actually agree at the point in question.',
   'Back to practice: for every corner-point or piecewise question, write both one-sided derivative limits side by side before deciding whether the derivative exists.'),
  ('2.5',
   'The power rule, d/dx x^n = n*x^(n-1), applies just as directly to negative and fractional exponents once a radical or reciprocal is rewritten as a power of x first -- skipping that rewrite step is where most power-rule errors start.',
   'Every term must be rewritten in the form (coefficient)*x^n before the power rule is applied, including turning 1/x^2 into x^(-2) and sqrt(x) into x^(1/2) -- the exponent rule works identically once that rewriting is done.',
   'Points require correctly rewriting every non-polynomial term as a power of x, then correctly applying n*x^(n-1) to each term while preserving every coefficient -- a dropped coefficient or an un-rewritten radical both cost the computation point.',
   'Rewrite every root and reciprocal as a power of x first, then apply d/dx x^n = n*x^(n-1) term by term, carrying every coefficient through unchanged.',
   'Find the derivative of f(x) = 4x^3 - 1/x^2 + sqrt(x).',
   'f''(x) = 12x^2 - 1/x + 1, leaving the reciprocal and radical terms undifferentiated as if they were constants.',
   'Rewrite as 4x^3 - x^(-2) + x^(1/2), then differentiate term by term: f''(x) = 12x^2 + 2x^(-3) + (1/2)x^(-1/2), which can be rewritten back as 12x^2 + 2/x^3 + 1/(2*sqrt(x)).',
   'Leaving a reciprocal or radical term unrewritten as a power of x, so the power rule is never actually applied to it, or dropping a coefficient during the exponent step.',
   'Return to practice and rewrite every radical and reciprocal as x^n before touching the power rule, every single time, until it becomes automatic.'),
  ('2.6',
   'Sum, difference, and constant-multiple rules let you differentiate each term of an expression independently and add the results -- but this only works because the derivative of a constant term is exactly zero, not because constants can be ignored.',
   'Every additive term in an expression gets its own derivative, computed separately, with any constant multiplier carried through unchanged and any standalone constant term differentiating to zero -- these are separate facts, not one shortcut.',
   'Credit requires differentiating every term correctly and independently, including correctly setting a lone constant term''s derivative to zero -- a sign error introduced while separating terms, or a constant term left un-zeroed, both cost points.',
   'Differentiate one additive term at a time, keep every coefficient and sign attached to its term, and explicitly set the derivative of any standalone constant to zero.',
   'Find the derivative of g(x) = 5x^4 - 7x + 9.',
   'g''(x) = 20x^3 - 7x + 9, leaving the constant term unchanged instead of differentiating it to zero.',
   'Differentiating term by term: d/dx(5x^4) = 20x^3, d/dx(-7x) = -7, and d/dx(9) = 0, so g''(x) = 20x^3 - 7.',
   'Carrying a standalone constant term through unchanged into the derivative instead of correctly reducing it to zero.',
   'Go back to practice and check every multi-term derivative for one thing: did every standalone constant actually vanish?'),
  ('2.7',
   'The four base derivative facts -- d/dx sin x = cos x, d/dx cos x = -sin x, d/dx e^x = e^x, and d/dx ln x = 1/x -- must be recalled exactly, since e^x is its own derivative and the trig pair swaps sign only for cosine, not sine.',
   'These four rules are memorized facts, not derived on the fly -- e^x differentiates to itself unchanged, ln x differentiates to 1/x, sin x differentiates to cos x, and cos x differentiates to -sin x, with the negative sign belonging only to cosine''s derivative.',
   'Credit requires recalling each base derivative fact correctly, including the sign on cos x''s derivative, before combining it with sum, product, or chain-rule structure -- a single sign or function-family error in the base fact invalidates everything built on top of it.',
   'Identify which function family each term belongs to (sine, cosine, exponential, or logarithmic), state its exact derivative fact, then combine with other rules as needed.',
   'Find the derivative of h(x) = 3 sin x - 2e^x + 5 ln x.',
   'h''(x) = 3 cos x - 2e^x + 5x, mishandling the logarithmic term as if its derivative were 5x instead of 5/x.',
   'Applying each base fact: d/dx(3 sin x) = 3 cos x, d/dx(-2e^x) = -2e^x, d/dx(5 ln x) = 5/x, so h''(x) = 3 cos x - 2e^x + 5/x.',
   'Reversing the sign on cosine''s derivative, or misremembering ln x''s derivative as x or as ln(1/x) instead of 1/x.',
   'Back to practice: drill flashcards on these four base derivatives until you can state all four without hesitation, sign included.'),
  ('2.8',
   'The product rule needs both terms shown as an explicit structural step -- f''(a) = u(a)v''(a) + v(a)u''(a) written out before any number -- because AP scoring treats the structure and the final value as two separate points, and skipping the visible structure costs the point even with a correct number.',
   'Differentiating a product means computing u''v + uv'', not multiplying u'' by v'' or differentiating both factors as if they didn''t interact -- and the structural line itself, not just the final number, is what a reader checks for credit.',
   'Two separate points exist: showing the explicit u(a)v''(a) + v(a)u''(a) structure, and correctly evaluating it -- a response with the right final number but no visible structural step loses the structure point even when the arithmetic is flawless.',
   'Write f''(x) = u(x)v''(x) + v(x)u''(x) as its own explicit line before plugging in any numbers, then substitute and simplify only after that structural line is visible.',
   'Given f(x) = x^2 * e^x, find f''(2), showing the product-rule structure explicitly before evaluating.',
   'f''(2) = 59.112.',
   'With u = x^2, v = e^x: f''(x) = u''(x)v(x) + u(x)v''(x) = 2x*e^x + x^2*e^x. So f''(2) = u(2)v''(2) + v(2)u''(2) = (4)(e^2) + (e^2)(4) = 8e^2 ≈ 59.112, with the structural step shown before the number.',
   'Reporting only the final numeric value without ever writing the explicit u(a)v''(a) + v(a)u''(a) structural step -- this loses the structure point even when the number is correct.',
   'Return to practice and force yourself to write the product-rule structure as its own line, every time, before computing any number.'),
  ('2.9',
   'The quotient rule''s order matters: (u''v - uv'')/v^2, never uv'' - u''v -- and the denominator must be squared, not left as v, since both are documented as the most common quotient-rule point losses.',
   'The numerator of a quotient derivative is (derivative of top)(bottom) minus (top)(derivative of bottom), always in that order, divided by the bottom squared -- reversing the subtraction order or forgetting to square the denominator both change the answer''s sign or value.',
   'Credit requires preserving the exact subtraction order in the numerator and correctly squaring the denominator before any simplification -- a numerator with the terms swapped changes the sign of the whole result and loses the point even with correct individual derivatives.',
   'Write f''(x) = (u''v - uv'')/v^2 with u'' and v computed first, keep that exact term order, square the denominator, and only simplify after the structure is correct.',
   'Given f(x) = (3x^2 - 1)/(x + 2), find f''(1).',
   'f''(1) = (u*v'' - u''*v)/v^2 = (2*1 - 6*3)/9 = -16/9, reversing the numerator''s term order.',
   'With u = 3x^2-1, v = x+2, u''=6x, v''=1: f''(x) = (u''v - uv'')/v^2. At x=1: u(1)=2, v(1)=3, u''(1)=6, v''(1)=1, so f''(1) = (6*3 - 2*1)/3^2 = (18-2)/9 = 16/9.',
   'Reversing the subtraction order in the quotient-rule numerator, which flips the sign of the entire result, or leaving the denominator unsquared.',
   'Back to practice: say ''low d-high minus high d-low, over low squared'' out loud before writing any quotient-rule derivative.'),
  ('2.10',
   'Beyond sine and cosine, d/dx tan x = sec^2 x, d/dx cot x = -csc^2 x, d/dx sec x = sec x tan x, and d/dx csc x = -csc x cot x -- the two ''squared'' derivatives and the two ''product'' derivatives are easy to cross, especially confusing sec x tan x with sec^2 x.',
   'Each of these four derivative facts pairs a specific trig function with its own distinct derivative form -- tan and cot produce squared-function derivatives, while sec and csc produce two-factor product derivatives, and mixing the two families produces a wrong but plausible-looking answer.',
   'Credit requires recalling the exact derivative form for each trig function, including which functions get a squared derivative and which get a two-factor product derivative -- swapping sec x''s derivative for a squared form (or vice versa) invalidates the term even if everything else is correct.',
   'Before differentiating, recall which family the function belongs to: tan/cot give a squared derivative, sec/csc give a two-factor product derivative -- then apply the exact fact for that function.',
   'Find the derivative of h(x) = 4 tan x - 3 sec x.',
   'h''(x) = 4 sec^2 x - 3 sec^2 x, treating sec x''s derivative as if it were the same squared form as tan x''s.',
   'Using d/dx tan x = sec^2 x and d/dx sec x = sec x tan x separately: h''(x) = 4 sec^2 x - 3 sec x tan x.',
   'Confusing sec x''s two-factor derivative (sec x tan x) with tan x''s squared derivative (sec^2 x), or dropping the negative sign on cot x or csc x''s derivative.',
   'Go back to practice and drill all four extended trig derivatives together until the squared-vs-product distinction stops being a guess.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously source_note ''generated-from-brief:legacy; grandfathered-2026-08-21'') with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 2 detail (the product/quotient rule structural scoring requirement for topics 2.8-2.9, the documented derivative-notation-renaming misconception for topic 2.2, and the base derivative-rule facts for topics 2.5-2.7 and 2.10); repair reason: grandfathered explainer restated the paired brief and used a generic meta-question mini-example shared across ~150 corpus rows; batch 2026-08-22-ap-calculus-ab-unit2-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_ab'
  and e.unit_number = 2
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_ab' and unit_number=2 and status='published'
      and source_note like 'cramapple-authored; repaired 2026-08-22%';
  if v_repaired <> 10 then
    raise exception 'expected 10 repaired AP Calculus AB Unit 2 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_ab' and b.unit_number=2 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus AB Unit 2 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
