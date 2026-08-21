begin;

-- Repair AP Calculus BC Unit 2 (Differentiation: Definition and
-- Fundamental Properties) Learn More explainers. The 10 point briefs were
-- duplicated from AB's genuinely hand-authored content and are correct;
-- they are NOT touched by this migration. All 10 explainers were the same
-- template-generated debt as every other repaired BC unit today.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 2
-- deep-tier detail: the CED's own structural requirement for the product
-- rule (the two terms are scored as separate points; failing to show the
-- structure costs the setup point even with a correct final answer), the
-- documented e^u chain-rule misapplication (differentiating e^(x^2) as
-- x^2 times e^(x^2) instead of 2x times e^(x^2)), and the documented
-- parenthesization error (a multi-term coefficient written without
-- grouping parentheses before multiplying another factor).
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
  ('2.1',
   'Average rate of change is a secant line''s slope over an interval; instantaneous rate of change is what that secant slope approaches as the interval shrinks to a single point -- these are genuinely two different computations, not two names for the same thing.',
   'The average rate formula (f(b)-f(a))/(b-a) requires two distinct input values; the instantaneous rate at one point is a limit, and plugging a single point into the average-rate formula produces an undefined 0/0, not an answer.',
   'Full credit requires identifying which type of rate the question actually asks for before choosing a formula, since the average-rate formula and the derivative are structurally different tools.',
   'Read whether the question describes two specific inputs (average rate) or asks about one exact moment or point (instantaneous rate), then choose the matching formula.',
   'A car travels 180 miles in 3 hours. Is this measurement the car''s average rate or instantaneous rate?',
   'It''s the instantaneous rate, since it describes the car''s speed.',
   'It''s the average rate, since it''s computed as total distance (180 miles) divided by total time (3 hours) over the whole trip -- an instantaneous rate would require information about a single moment, not the whole interval.',
   'Using the average rate formula when the question asks for the rate at one instant.',
   'Before computing any rate, count how many input values you''re given -- one point signals instantaneous rate, two distinct points signal average rate.'),
  ('2.2',
   'f''(a) is a rate -- a slope, a speed, a number of units per unit -- never a y-value of f itself; treating f''(a) as if it were f evaluated at a produces a completely different, usually wrong, quantity.',
   'f(a) and f''(a) answer two different questions: f(a) is what is the function''s value here, while f''(a) is how fast is the function changing here -- confusing them is a category error, not a computational slip.',
   'Full credit requires keeping f(a) and f''(a) as distinct quantities throughout a response, never substituting one for the other.',
   'Before using a value, check the notation: f(a) is a value of the function itself, f''(a) is the function''s rate of change at that point -- these answer different questions.',
   'Given f(2)=10 and f''(2)=3, a student is asked for the function''s value at x=2 and answers 3. Evaluate this.',
   'That''s correct, since 3 is the number associated with x=2.',
   'That''s incorrect; f(2)=10 is the function''s value at x=2, while f''(2)=3 is the rate of change there -- the question asked for the value, so the answer should be 10, not 3.',
   'Treating f''(a) as a y-value of the original function instead of as a rate or slope.',
   'Whenever both f(a) and f''(a) are given, pause and label which one the question is actually asking for before writing an answer.'),
  ('2.3',
   'Estimating a derivative from data means computing a secant slope between the two table or graph points closest to the target input, in both directions if possible -- using distant points produces a worse estimate even if the arithmetic is clean.',
   'An estimate is not the same as an exact value, and the response should say so -- and the estimate should be built from the nearest available x-values surrounding the target point, not just any two points in the table.',
   'Full credit requires selecting the closest surrounding data points, not distant ones, and labeling the result as an estimate, with units when the context provides them.',
   'Scan the table or graph for the two x-values closest to the target input, on either side if available, and compute the secant slope between exactly those two points.',
   'A table gives f(1)=2, f(3)=8, f(5)=20, f(7)=38. Estimate f''(5) using the table.',
   'Using f(1) and f(7): (38-2)/(7-1) = 6.',
   'Using the closest surrounding values, f(3) and f(7): (38-8)/(7-3) = 7.5 -- an estimate for f''(5), built from the nearest available points rather than the widest-spread ones.',
   'Using distant data values or failing to distinguish an estimate from an exact derivative.',
   'Before estimating any derivative from a table, circle the closest x-values on both sides of the target point first, then compute the secant slope only between those.'),
  ('2.4',
   'Differentiability implies continuity, but continuity does not imply differentiability -- a function can be perfectly continuous, no gaps or jumps, and still fail to have a derivative at a sharp corner, a cusp, or a vertical tangent.',
   'At a corner, like the graph of |x| at x=0, the function is continuous but the left-hand and right-hand slopes disagree, so no single derivative value exists there -- continuity alone never guarantees a derivative exists.',
   'Full credit requires recognizing that continuity is necessary but not sufficient for differentiability, and specifically checking for corners, cusps, or vertical tangents before claiming a derivative exists.',
   'Confirm continuity first, then separately check for corners, cusps, or vertical tangents -- only if none of those are present does a derivative exist at that point.',
   'The graph of f(x) = |x| is continuous everywhere, including at x=0. Does f''(0) exist?',
   'Yes, since the function is continuous at x=0, the derivative exists there too.',
   'No -- f is continuous at x=0, but it has a corner there: the left-hand slope is -1 and the right-hand slope is 1, so they disagree and f''(0) does not exist, even though continuity holds.',
   'Claiming a derivative exists at a corner or discontinuity because the graph has points on both sides.',
   'Never conclude a derivative exists from continuity alone -- always check separately for corners, cusps, and vertical tangents.'),
  ('2.5',
   'The power rule applies cleanly to x^n only after negative and fractional exponents are rewritten in that exact form -- differentiating a radical or a reciprocal without first rewriting it as a power is where this topic''s arithmetic most often goes wrong.',
   'The square root of x is x^(1/2), and 1/x^3 is x^(-3) -- the power rule does not apply to a radical or a fraction as written, only to the rewritten power form, so that rewriting step has to happen first.',
   'Full credit requires the explicit rewriting step, radical or reciprocal to a power, shown before the power rule is applied, since skipping it is where sign and exponent errors happen.',
   'Rewrite any radical or reciprocal expression as x to a power first, then apply the power rule: multiply by the exponent, subtract one from the exponent.',
   'Differentiate f(x) = 1/x^2 (equivalently, x^(-2)).',
   'f''(x) = -2/x^2, keeping the same exponent.',
   'Rewriting as x^(-2), the power rule gives f''(x) = -2x^(-3), which is -2/x^3 -- the exponent decreases by one to -3, not kept at -2.',
   'Dropping coefficients or mishandling negative and fractional exponents.',
   'Before applying the power rule to any radical or fraction, write the rewritten power form as its own separate step first.'),
  ('2.6',
   'Differentiating term by term is safe only when every coefficient and sign is carried through with explicit grouping -- writing 2t minus 4 times e to a power without parentheses around (2t-4) changes what the expression actually means, even if the intended derivative was correct.',
   'When a derivative produces a binomial coefficient in front of another factor, that coefficient needs parentheses around it -- the CED''s own scoring notes flag this exact omission as a real, documented point-losing error.',
   'Full credit requires parentheses around any multi-term coefficient produced by these rules, not just the correct numeric derivative -- a response with the right numbers but ambiguous or missing grouping can be marked as a different, incorrect expression.',
   'Differentiate term by term, keeping every coefficient and sign visible, and wrap any resulting multi-term coefficient in parentheses before it multiplies another factor.',
   'A student differentiates g(t) = (2t^2 - 4t) times e^t using the product rule and writes the derivative as 2t - 4 times e^t + (2t^2-4t) times e^t. Evaluate the notation.',
   'This is correct, since the numbers match the product rule.',
   'The notation is ambiguous and incorrect as written; the derivative of (2t^2-4t) is (4t-4), and it must be grouped in parentheses as (4t-4) times e^t, not written as 4t - 4 times e^t, which changes the meaning of the expression.',
   'Omitting parentheses around a multi-term coefficient before it multiplies another factor, changing what the expression actually means even when the intended derivative is correct.',
   'Whenever a derivative rule produces a coefficient with more than one term, wrap it in parentheses immediately, before combining it with anything else.'),
  ('2.7',
   'e^x is its own derivative only when x itself is the variable -- as soon as the exponent is a function of x rather than x alone, the chain rule requires multiplying by that inner function''s derivative, and skipping this step is a specific, documented, common error.',
   'Differentiating e^(x^2) as x^2 times e^(x^2) is a garbled version of the product rule mistakenly applied here -- the correct chain-rule derivative is e^(x^2) times the derivative of x^2, which is 2x, giving 2x times e^(x^2).',
   'Full credit requires recognizing when the exponent is not simply x, and multiplying by that inner function''s own derivative rather than by the inner function itself.',
   'Check whether the exponent on e is exactly x or a more complex expression; if it is more complex, multiply by the derivative of that expression, never by the expression itself.',
   'Differentiate f(x) = e^(x^2).',
   'f''(x) = x^2 times e^(x^2).',
   'f''(x) = 2x times e^(x^2), using the chain rule: the derivative of e to an inner power is e to that same inner power times the derivative of the inner expression, and the derivative of x^2 is 2x, not x^2 itself.',
   'Multiplying e raised to a non-x exponent by the exponent itself rather than by the exponent''s derivative -- a documented, garbled product-rule-shaped error.',
   'Whenever e has an exponent that is not simply x, write out ''derivative of the exponent'' as its own separate step before multiplying anything together.'),
  ('2.8',
   'The product rule''s two terms are scored as two separate, independent points on this exam -- writing the correct structure, first times derivative of second plus second times derivative of first, earns credit even if a later arithmetic slip changes the final number.',
   'The CED''s own scoring notes state plainly that failing to present the product-rule structure explicitly costs the setup point even with a correct final numeric answer -- the structural step and the final value are graded as two separate things.',
   'Full credit requires showing the explicit structural setup, first factor times derivative of second plus second factor times derivative of first, as its own visible step, separate from the final simplified value.',
   'Write out the full structural form -- first factor times derivative of second, plus second factor times derivative of first -- as its own line before simplifying to a final number.',
   'Given u(3)=5, u''(3)=2, v(3)=4, v''(3)=-1, find (uv)''(3), showing the required structure.',
   '(uv)''(3) = u(3)v''(3) = -5, using only the first term.',
   '(uv)''(3) = u(3)v''(3) + v(3)u''(3) = (5)(-1) + (4)(2) = -5 + 8 = 3, showing both structural terms explicitly before combining to the final value.',
   'Showing or computing only one of the two required product-rule terms instead of both, even when the omitted term would have been easy to compute.',
   'Always write the structural product-rule form as a visible, separate step, even when you could compute the final number faster in your head.'),
  ('2.9',
   'The quotient rule''s numerator has a fixed order -- denominator times derivative of numerator, minus numerator times derivative of denominator -- and reversing that subtraction order produces the exact negative of the correct answer, not just a small error.',
   'Unlike the product rule, order matters here: swapping which term comes first in the numerator''s subtraction produces a completely different, negated, result, because subtraction is not commutative the way the product rule''s addition is.',
   'Full credit requires the numerator terms in the correct order, denominator times derivative of numerator minus numerator times derivative of denominator, and the denominator squared, not just a numerically close final answer.',
   'Write ''low d-high minus high d-low, over low squared'' explicitly, keeping that exact subtraction order, before simplifying to a final value.',
   'Given u(2)=5, u''(2)=4, v(2)=2, v''(2)=1, find (u/v)''(2).',
   '(u/v)''(2) = (u(2)v''(2) - v(2)u''(2))/v(2)^2 = (5*1 - 2*4)/4 = -3/4.',
   '(u/v)''(2) = (v(2)u''(2) - u(2)v''(2))/v(2)^2 = (2*4 - 5*1)/4 = 3/4 -- denominator times derivative of numerator minus numerator times derivative of denominator, in that order, over denominator squared.',
   'Reversing the numerator terms or forgetting to square the denominator.',
   'Say ''low d-high minus high d-low'' out loud in that exact order before writing any quotient-rule numerator -- reversing it flips the sign of the whole answer.'),
  ('2.10',
   'sec x and tan x have similar-looking derivatives that are easy to swap -- the derivative of tan x is sec^2(x), while the derivative of sec x is sec(x)tan(x) -- confusing which one produces which is a common error with these four functions.',
   'cot x and csc x both have negative derivatives, -csc^2(x) and -csc(x)cot(x) respectively, unlike tan x and sec x, whose derivatives are positive -- forgetting the negative sign specifically on the cot/csc pair is a well-known, repeated error.',
   'Full credit requires citing the exact correct derivative formula for whichever of the four functions is present, including the correct sign, not a formula borrowed from one of the other three.',
   'Before differentiating, name which of the four functions is present and recall its exact formula and sign, rather than pattern-matching to sec^2(x) or tan(x) from memory of a different function.',
   'Differentiate f(x) = cot(x).',
   'f''(x) = csc^2(x).',
   'f''(x) = -csc^2(x); cot(x)''s derivative carries a negative sign, unlike tan(x)''s derivative sec^2(x), which is positive with no negative sign at all.',
   'Mixing up the signs for cot x and csc x or confusing sec x tan x with sec^2 x.',
   'Make a habit of naming the sign, positive or negative, out loud before writing any of these four derivative formulas -- the sign is where this topic''s points are most often lost.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously source_note ''cramapple-authored Duplicated from ap_calculus_ab 2026-08-21 (shared AB/BC topic); BC-owned copy, edit independently.'', with the paired brief kept from that AB duplication since the brief was already genuinely good) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 2 deep-tier detail (the product-rule structural-scoring requirement, the documented e^u-chain-rule misapplication, and the documented parenthesization notation error); repair reason: grandfathered explainer restated the paired brief verbatim; batch 2026-08-21-ap-calculus-bc-unit2-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 2
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=2 and status='published'
      and source_note like 'cramapple-authored; repaired 2026-08-21%unit2%';
  if v_repaired <> 10 then
    raise exception 'expected 10 repaired AP Calculus BC Unit 2 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=2 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 2 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
