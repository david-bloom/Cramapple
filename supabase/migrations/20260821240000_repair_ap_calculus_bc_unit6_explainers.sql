begin;

-- Repair AP Calculus BC Unit 6 (Integration and Accumulation of Change)
-- Learn More explainers. Briefs were duplicated from AB's genuinely
-- hand-authored content and are correct; NOT touched here. Topic 6.11
-- (Integration by Parts) is BC-only (moved, not duplicated) but was also
-- template-generated debt, so it is repaired in this same batch.
--
-- AP Calculus AB's Unit 6 explainers are still grandfathered debt as of
-- this batch (not yet repaired), so there is no AB Unit 6 hand-authored
-- batch to accidentally collide with the way BC/AB Unit 4 did.
--
-- Grounded in docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 6
-- deep-tier detail: the exact Riemann-sum-to-definite-integral limit
-- form, the FTC-statement point being separate from and in addition to
-- the final-answer point for accumulation-function derivatives (with the
-- documented g'(8)=f(8)-f(6) difference-quotient confusion as an anchor
-- error), and the requirement that a by-parts remaining integral be
-- evaluated to completion, not left as a dangling term.
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_calculus_bc_unit6_explainer_before_state.json.
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
  ('6.1',
   'An accumulation total is only as trustworthy as the rate-times-interval reasoning behind it -- stating the final number without identifying the rate function and the interval it was integrated over does not show where that number came from.',
   'A rate function describes how fast a quantity is changing at an instant, while the definite integral of that rate over an interval gives the total accumulated change, a genuinely different quantity from any single instantaneous value.',
   'Full credit requires the rate function and the interval of accumulation both stated explicitly, connecting the integral notation to the total-change interpretation, not just a number pulled from a calculator.',
   'Name the rate function being accumulated and the interval of accumulation before stating any total, then interpret the result as total change over exactly that interval.',
   'Water flows into a tank at a rate of r(t) = 3 + 2t gallons per minute for 0 <= t <= 5. A student answers ''the tank gained about 40 gallons'' with no supporting work. Does this response show the required reasoning?',
   'Yes, since 40 gallons is the correct total amount that accumulated.',
   'No -- even if 40 is numerically correct, the response never identifies r(t) as the rate being accumulated or states that the integral is taken over [0,5]; full credit requires writing the definite integral of r(t) from 0 to 5 and interpreting the result as the total gallons that flowed in during that specific interval.',
   'Treating the rate value at one point as the accumulated total over an interval.',
   'Before answering any accumulation question, write the rate function and its interval of integration as an explicit definite integral before stating any total-change number.'),
  ('6.2',
   'A Riemann sum is only as defensible as its subinterval widths and sample-point choice -- reporting a numeric approximation without showing which endpoint (left, right, or midpoint) generated each height, and the width used, does not earn credit even when the arithmetic is right.',
   'The CED does not codify universal over/underestimate rules by name (that a right sum overestimates an increasing function, for instance, is standard teaching convention, not required CED text) -- but a response still must show its subinterval structure explicitly, since that structure is what''s actually being scored.',
   'Full credit requires each subinterval''s width and chosen sample height shown as an explicit product before summing, not just a final number.',
   'List each subinterval''s width and sample height as base times height, sum the products, then attach units to the final total.',
   'A table gives v(t) at t = 0, 2, 5, 9 (unequal widths). A student uses a right Riemann sum and reports a single final number with no subinterval breakdown shown. What is missing?',
   'Nothing -- the final number is what matters for a Riemann sum approximation.',
   'The subinterval breakdown is missing -- with unequal widths (2, 3, 4), each term needs its own width times the correct right-endpoint height shown explicitly, since assuming equal widths or omitting the individual products is exactly the kind of setup error this topic is scored on, not just the final sum.',
   'Using the wrong endpoint or assuming all subintervals have equal width when they do not.',
   'Whenever subinterval widths in a table are unequal, write out each width times height term explicitly before summing, rather than assuming a uniform width shortcut.'),
  ('6.3',
   'Definite integral notation is the limit of a Riemann sum: the integral from a to b of f(x)dx equals the limit, as the maximum subinterval width goes to zero, of the sum of sample heights times widths -- reading the symbol as just ''find area'' misses what the notation actually asserts.',
   'Moving between summation notation, a Riemann sum picture, and definite integral notation is itself a tested skill -- misreading which function is being summed, or which variable the bounds refer to, breaks the translation even when the final area value would have been correct.',
   'Full credit requires correctly identifying the integrand, the variable of integration, and the bounds a and b as matching the Riemann sum''s function and interval, not just recognizing that ''integral'' means ''area.''',
   'Before evaluating, explicitly restate what the integral symbol claims: an integrand, a variable, and bounds a and b, matching the limit-of-sums definition.',
   'A student sees the notation integral from 2 to 7 of g(x)dx and immediately writes ''this asks for g(7) minus g(2)'' without further explanation. What is the error?',
   'There is no error -- that is exactly what the definite integral computes.',
   'That shortcut is only valid once an antiderivative relationship is established; as written, the notation itself claims the limit of Riemann sums of g(x) from x=2 to x=7, the total accumulated change in the rate g over that interval -- writing g(7) minus g(2) skips past what the notation is actually defining and substitutes a different (later-justified) evaluation shortcut in its place.',
   'Misreading the bounds or treating definite integral notation as an antiderivative request only.',
   'Before evaluating any definite integral, restate in words what the notation is claiming as a limit of a Riemann sum before applying any shortcut for computing its value.'),
  ('6.4',
   'Stating the final derivative value of an accumulation function without an explicit statement that g''(x) = f(x) (the Fundamental Theorem''s own claim) does not earn the FTC-statement point, even if the final numeric answer is fully correct -- these are two separate, independently scored requirements.',
   'A real documented AP error confuses the derivative of an accumulation function with a difference quotient -- writing g''(8) = f(8) - f(6) instead of the correct g''(8) = f(8) -- and that error can still earn the answer point if numerically consistent, but never the separate FTC-statement point, because it never actually states the theorem''s claim.',
   'Full credit requires the explicit general statement g''(x) = f(x) (adjusted by chain rule if the upper bound is not x) shown as its own step, separate from and in addition to the final numeric answer.',
   'Write g''(x) = f(x) as an explicit general statement first (applying the chain rule if the bound is a function of x, not x itself), then substitute the specific x-value.',
   'g(x) = integral from 3 to x of f(t)dt. A student is asked for g''(8) and writes g''(8) = f(8) - f(6) = 5, getting a numerically correct final value by coincidence. Does this earn full credit?',
   'Yes, since g''(8) = 5 is the correct final value.',
   'The final value may be numerically fine, but this earns only the answer point, not the FTC-statement point -- the FTC''s actual claim is g''(x) = f(x), so the correct approach states g''(8) = f(8) explicitly as a general rule before substituting; writing f(8) - f(6) confuses the derivative of an accumulation function with a difference quotient and never states the theorem being used.',
   'Replacing the accumulation function with a number or forgetting the chain rule for variable bounds.',
   'Before computing any accumulation-function derivative numerically, write the general statement g''(x) = f(x) (with chain rule adjustment if needed) as its own explicit step.'),
  ('6.5',
   'Reading an accumulation function''s increasing/decreasing or concavity behavior directly off the area picture, rather than treating the integrand as the accumulation function''s own derivative first, answers the question using the wrong object''s behavior.',
   'Since the integrand f is literally F'' for the accumulation function F(x) = integral from a to x of f(t)dt, every increasing/decreasing and concavity fact about F must be derived through f''s sign and f''s own increasing/decreasing behavior, exactly like any other first- and second-derivative analysis.',
   'Full credit requires treating the given integrand as the derivative of the accumulation function, then applying standard sign-of-derivative reasoning to reach conclusions about the accumulation function itself.',
   'Explicitly relabel the given integrand as F''(x), then use its sign for increasing/decreasing and its own increasing/decreasing behavior for F''s concavity.',
   'The graph of f(x) is given, and F(x) = integral from 0 to x of f(t)dt. f(x) > 0 and decreasing on (2,5). A student concludes ''F is decreasing on (2,5) because f is decreasing there.''',
   'Correct, since f decreasing means F is decreasing.',
   'Incorrect -- F''s increasing/decreasing behavior depends on the sign of f, not on whether f itself is increasing or decreasing; since f(x) > 0 on (2,5), F is increasing there. The fact that f is decreasing on (2,5) instead tells you something about F''s concavity: F is concave down on (2,5), since F''''(x) = f''(x) < 0 there.',
   'Judging the accumulation function directly from the area picture without using the integrand as its derivative.',
   'Whenever a question gives the graph of an integrand and asks about the accumulation function''s behavior, relabel the integrand as F'' explicitly before applying any increasing/decreasing or concavity rule.'),
  ('6.6',
   'Combining partial areas from a graph or table using definite integral properties requires explicitly tracking sign and interval direction -- adding magnitudes together without checking whether an interval was traversed backward or whether a piece lies below the axis treats every area as automatically positive, which the properties do not guarantee.',
   'Interval additivity, sign reversal on reversed bounds, and constant-multiple scaling are algebraic properties of the integral itself, not just bookkeeping conventions, so misapplying any one of them produces a genuinely wrong total, not just an imprecise one.',
   'Full credit requires the requested integral rewritten explicitly in terms of the given sub-integrals using the specific property invoked (additivity, reversal, or constant multiple), not a combined number with no visible property-based justification.',
   'Write the requested integral as an explicit sum or difference of the given sub-integrals, naming which property (additivity, sign reversal, constant multiple) justifies each step.',
   'Given that the integral from 1 to 6 of f(x)dx = 8 and the integral from 1 to 4 of f(x)dx = 3, a student is asked to find the integral from 4 to 1 of f(x)dx and writes 8 - 3 = 5.',
   'Correct, since 8 minus 3 gives the remaining piece.',
   'The subtraction correctly finds the integral from 4 to 6 (which is 8 - 3 = 5), but the question asked for the integral from 4 to 1, not 4 to 6 -- reversing the bounds requires the sign-reversal property, so the integral from 4 to 1 of f(x)dx equals negative the integral from 1 to 4, which is -3, not 5; two different properties were needed and only additivity was applied.',
   'Adding areas without accounting for sign or reversed bounds.',
   'Before combining any partial areas, name explicitly which property, additivity, sign reversal, or constant multiple, justifies each step in rewriting the requested integral.'),
  ('6.7',
   'Evaluating a definite integral via the Fundamental Theorem requires subtracting the antiderivative''s value at the lower bound from its value at the upper bound in that specific order -- reversing the order changes the sign of the answer and, when the integral represents signed change, silently converts a real decrease into a reported increase or vice versa.',
   'A definite integral can be negative when the integrand represents a rate that is negative over part or all of the interval, so a negative final answer is not automatically a sign of an arithmetic error -- it may be exactly what a decreasing accumulated quantity should produce.',
   'Full credit requires an explicit antiderivative F, evaluated as F(b) minus F(a) in that order, with the result interpreted in context including units when the integral represents a real-world change.',
   'Find an antiderivative F explicitly, compute F(b) minus F(a) in that exact order, then attach the contextual units and sign interpretation.',
   'A particle''s velocity is v(t) = t - 4 on [0,6]. A student computes the antiderivative F(t) = t^2/2 - 4t and reports the displacement as F(0) - F(6) = 0 - (-6) = 6.',
   'Correct, since displacement should be a positive distance traveled.',
   'The subtraction order is reversed -- the Fundamental Theorem requires F(6) - F(0), not F(0) - F(6); computing it correctly gives F(6) - F(0) = -6 - 0 = -6, meaning the particle''s net displacement is negative 6 (it ended up 6 units to the left of where it started), which is a legitimate signed result, not an error to be corrected by flipping the sign after the fact.',
   'Subtracting in the wrong order or forgetting that a definite integral can be negative when it represents signed change.',
   'Always write the subtraction explicitly as F(upper bound) minus F(lower bound) in that order, and accept a negative result as meaningful when the integrand can be negative.'),
  ('6.8',
   'An indefinite integral names an entire family of antiderivatives, not one specific function -- omitting the constant of integration when no bounds are given reports only one member of that family as if it were the unique answer, which is not what the indefinite integral notation actually represents.',
   'Finding an antiderivative is the reverse operation of differentiation, so it should be checked by differentiating the proposed answer and confirming it reproduces the original integrand exactly, not by pattern-matching to a memorized rule alone.',
   'Full credit requires the correct reverse-derivative rule applied and the constant of integration, +C, included whenever no bounds are given.',
   'Ask explicitly what function differentiates to the given integrand, verify by differentiating the proposed antiderivative, then append +C since no bounds restrict the family to one member.',
   'A student is asked for the indefinite integral of 6x^2 dx and writes 2x^3 as the final answer, checking that the derivative of 2x^3 is indeed 6x^2.',
   'Correct, since differentiating 2x^3 does give back 6x^2.',
   'The reverse-derivative rule is applied correctly, but the answer is incomplete -- an indefinite integral (no bounds given) represents an entire family of antiderivatives that differ only by a constant, since d/dx of any constant is zero; the complete answer must be written as 2x^3 + C, not just 2x^3, to represent that whole family rather than a single member of it.',
   'Forgetting +C or applying derivative rules forward instead of reversing them.',
   'After finding any indefinite integral, check explicitly whether bounds were given -- if not, append +C before considering the answer complete.'),
  ('6.9',
   'Substitution requires every instance of the original variable to be rewritten in terms of the new variable u, including the differential -- leaving a mixed expression with both x and u present part way through is not a valid intermediate step, it is an unfinished substitution that cannot be integrated as written.',
   'For a definite integral, the bounds themselves must be converted from x-values to the corresponding u-values at the moment of substitution, since integrating in terms of u while still using the original x-bounds evaluates the wrong quantity entirely.',
   'Full credit requires u and du both defined explicitly, the entire integral rewritten purely in terms of u with no x remaining, and for definite integrals, the bounds converted to u-values before evaluating.',
   'Define u and du explicitly, rewrite the whole integral with no x remaining, and for a definite integral convert the bounds to u-values before evaluating in u.',
   'For the integral from 0 to 2 of x times the square root of (x^2+1) dx, a student sets u = x^2+1, correctly finds du = 2x dx, but then evaluates the resulting u-integral using the original bounds 0 and 2 instead of converting them.',
   'This is fine, since the bounds describe the same interval either way.',
   'The bounds must be converted along with the variable -- since u = x^2+1, the bound x=0 becomes u=1 and the bound x=2 becomes u=5; evaluating the u-integral from 0 to 2 instead of from 1 to 5 computes a completely different, incorrect quantity, even though every other step of the substitution was done correctly.',
   'Leaving a mix of x and u in the same integral or forgetting to adjust definite bounds.',
   'For any definite integral solved by substitution, convert the bounds to u-values as an explicit step at the same time u and du are defined, before integrating.'),
  ('6.10',
   'A rational integrand that does not match a basic antiderivative form must first be rewritten -- by long division when the numerator''s degree is at least the denominator''s, or by completing the square for an irreducible-quadratic denominator -- before any technique is applied to it.',
   'Long division and completing the square are preparation steps, not integration techniques themselves -- the actual integration only becomes possible once the rewritten pieces individually match a recognizable antiderivative form, such as a basic power rule term plus an arctangent-form term.',
   'Full credit requires the algebraic rewrite (long division or completed-square form) shown as an explicit step before any antiderivative rule is applied to the resulting simpler pieces.',
   'Check the integrand''s structure first; if it''s an improper rational expression or has an irreducible quadratic denominator, perform the algebraic rewrite as its own visible step before integrating the resulting pieces.',
   'A student is asked to integrate (x^2 + 1)/(x^2 + 4) dx and immediately tries substitution with u = x^2+4, getting stuck since du does not match the numerator.',
   'Substitution should always work eventually with enough algebra manipulation inside the same attempt.',
   'Substitution is the wrong first move here -- since the numerator''s degree equals the denominator''s degree, long division applies first: (x^2+1)/(x^2+4) = 1 - 3/(x^2+4), which splits into a constant term (integrates to x) and a recognizable arctangent-form term (integrates to (3/2)arctan(x/2)); the rewrite must happen before any antiderivative rule is chosen, not as a fallback after substitution fails.',
   'Trying to integrate a complicated rational expression directly without making the needed algebraic rewrite.',
   'Before choosing an integration technique for a rational integrand, check whether long division or completing the square is needed first, and perform that rewrite as its own visible step.'),
  ('6.11',
   'Integration by parts is not complete once the remaining integral term v du is written down -- that remaining integral still has to be evaluated and combined with the uv term into one final antiderivative, since a response that stops at the formula''s skeleton has not actually integrated anything.',
   'This technique is BC-only content (the CED marks it explicitly BC ONLY, the same tagging pattern used for L''Hospital''s other-indeterminate-forms exclusion), and choosing u to be the factor that simplifies upon differentiation is what makes the remaining integral v du solvable rather than more complicated than the original.',
   'Full credit requires u, dv, du, and v all identified explicitly, the formula integral u dv = uv - integral v du written out, and the remaining integral v du fully evaluated to reach one final closed-form antiderivative.',
   'Choose u as the factor that simplifies when differentiated, identify dv, du, and v, write the full by-parts formula, then evaluate the remaining integral to completion.',
   'For the integral of x times e^x dx, a student sets u = x, dv = e^x dx, correctly finds du = dx and v = e^x, writes x*e^x - integral of e^x dx, and stops there as the final answer.',
   'This is complete, since the by-parts formula has been correctly applied.',
   'The formula''s skeleton is correct, but the response stops short -- the remaining integral of e^x dx still must be evaluated; the correct complete antiderivative is x*e^x - e^x + C, not x*e^x - integral of e^x dx, since a dangling unevaluated integral term does not count as a finished antiderivative.',
   'Dropping the remaining integral or reversing signs in the uv - integral v du step.',
   'After writing the by-parts formula, always evaluate the remaining integral term to completion before treating the antiderivative as finished.'),
  ('6.14',
   'Forcing a memorized technique, such as substitution, onto an integrand whose actual structure calls for a different method wastes setup work and often cannot be completed at all -- the integrand''s structure has to be classified first, before any specific rule is chosen.',
   'Recognizing structure means checking, in order, whether the integrand matches a basic reverse-derivative rule directly, has a composite structure suited to substitution, is a rational expression needing an algebraic rewrite first, or is a product suited to integration by parts.',
   'Full credit requires an explicit classification step (naming which structural category the integrand fits) shown before the chosen technique is applied, not a technique applied first and abandoned if it fails.',
   'Before integrating, classify the integrand''s structure explicitly among basic rule, substitution-composite, rational-needing-rewrite, or by-parts-product, then apply only the matching technique.',
   'A student is asked to integrate x times cos(x) dx and first attempts u-substitution with u = cos(x), finds the attempt does not resolve, then tries again with a different technique.',
   'Trying substitution first is always a reasonable default technique to attempt on any integral.',
   'The integrand x*cos(x) is a product of two unrelated factors, not a composite function -- that structure calls for integration by parts, not substitution, from the start; classifying the structure correctly first (a product of a polynomial and a trig function, suited to by-parts with u=x) avoids the wasted, unresolvable substitution attempt entirely.',
   'Forcing substitution or a memorized pattern when the integrand structure points elsewhere.',
   'Before starting any integration, explicitly name which structural category, basic rule, substitution, algebraic rewrite, or by-parts, the integrand fits, then apply only that matching technique.')
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
  source_note = 'cramapple-authored; repaired 2026-08-21 replacing a template-generated explainer (previously duplicated-from-AB, then generated-from-brief, grandfathered) with topic-specific content grounded in AP_CALCULUS_AB_BC_CED_FACT_PACK.md Unit 6 deep-tier detail (the exact Riemann-sum-to-definite-integral limit form, the FTC-statement point scored separately from and in addition to the final-answer point for accumulation-function derivatives -- with the documented g''(8)=f(8)-f(6) difference-quotient confusion as the anchor error -- and the requirement that a by-parts remaining integral be evaluated to completion rather than left as a dangling term); AP Calculus AB''s Unit 6 explainers are still grandfathered debt as of this batch, so every mini-example here is checked only against the corpus-wide distinctness query, not against an AB Unit 6 repair that does not yet exist; batch 2026-08-21-ap-calculus-bc-unit6-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_calculus_bc'
  and e.unit_number = 6
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_calculus_bc' and unit_number=6 and status='published'
      and source_note like '%unit6-explainer-repair%';
  if v_repaired <> 12 then
    raise exception 'expected 12 repaired AP Calculus BC Unit 6 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_calculus_bc' and b.unit_number=6 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Calculus BC Unit 6 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
