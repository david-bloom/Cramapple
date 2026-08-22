begin;

-- Repair AP Precalculus Unit 1 (Polynomial and Rational Functions)
-- Learn More explainers -- all 14 were template-generated debt
-- (core_idea verbatim-matching their brief's what_it_is). Briefs for
-- this unit are genuinely hand-authored and correct; NOT touched here.
--
-- Grounded in docs/product/AP_PRECALCULUS_CED_FACT_PACK.md Unit 1
-- deep-tier detail: the boxed exclusion that open-vs-closed interval
-- distinctions for increasing/decreasing behavior are outside this
-- course's scope (1.1); the register-boundary rule that calculus-
-- flavored rate-of-a-rate language never earns credit in this course
-- (1.3); the Complex Conjugate Root Theorem for real-coefficient
-- polynomials (1.5); the documented real reciprocal/ratio-confusion
-- error (describing a computed ratio of 0.5 as 'a factor of 2') (1.13);
-- and the polynomial-division identity's remainder-degree requirement
-- (1.11).
--
-- Before-state captured at docs/research/
-- topic_guide_source_note_grandfather_2026_08_21/
-- ap_precalculus_unit1_explainer_before_state.json.
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
  ('1.1',
   'Treating one quantity as a function of another means every input value corresponds to exactly one output value -- this topic is explicitly scoped to describing change qualitatively, and open-versus-closed interval distinctions for increasing/decreasing behavior are outside the course''s scope entirely.',
   'The AP Precalculus course states directly that discriminating between open and closed intervals for increasing/decreasing behavior is outside its scope, so a response should never be penalized (or rewarded) for interval-endpoint notation on this kind of description.',
   'Full credit requires correctly identifying which quantity depends on which (the functional relationship) and describing the co-change qualitatively, without introducing open/closed interval distinctions the course doesn''t assess.',
   'State which quantity is the input and which is the output, confirm each input gives exactly one output, then describe how they change together without worrying about open versus closed interval endpoints.',
   'A student describes a function as ''increasing on the closed interval [2,5]'' and a classmate insists it must instead be described as ''increasing on the open interval (2,5)'' for full credit.',
   'The classmate is right -- open versus closed intervals must be specified precisely for full credit.',
   'Neither the open nor the closed version is required here -- the AP Precalculus course explicitly states that discriminating between open and closed intervals for increasing/decreasing behavior is outside its scope; describing the interval as [2,5] or (2,5) are both acceptable, since this distinction is not something the course assesses.',
   'Treating open-versus-closed interval notation as a scored distinction for increasing/decreasing behavior, when the course explicitly excludes it.',
   'When describing where a function increases or decreases, don''t worry about open-versus-closed interval endpoints -- that distinction is explicitly outside this course''s scope.'),
  ('1.2',
   'Average rate of change over [a,b] is computed as [f(b)-f(a)]/(b-a), the slope of the secant line connecting the two endpoints -- this is a ratio over an interval, not an instantaneous value at a single point, since instantaneous rates belong to calculus and are outside this course.',
   'The average rate of change formula always needs two distinct input values to compute a difference in outputs over a difference in inputs; asking for a rate ''at'' a single point (rather than over an interval) is a calculus question this course doesn''t address.',
   'Full credit requires the average rate of change computed explicitly as [f(b)-f(a)]/(b-a) using two stated endpoint values, not estimated from the graph''s visual steepness at a single point.',
   'Identify the two endpoint input values a and b, compute f(a) and f(b), then divide the output difference by the input difference to get the average rate of change.',
   'A student is asked for the average rate of change of f(x)=x^2 on [1,4] and estimates it by looking at how steep the curve appears halfway between x=1 and x=4.',
   'This visual estimate is an acceptable way to find the average rate of change.',
   'Average rate of change must be computed, not estimated visually -- using the formula [f(4)-f(1)]/(4-1) = (16-1)/3 = 5, the average rate of change is exactly 5, which requires evaluating f at both endpoints and dividing, not judging the curve''s steepness by eye.',
   'Estimating average rate of change visually from a graph''s steepness instead of computing [f(b)-f(a)]/(b-a) explicitly.',
   'Whenever asked for an average rate of change, compute [f(b)-f(a)]/(b-a) explicitly using two stated input values, rather than estimating from a graph''s appearance.'),
  ('1.3',
   'Increasing/decreasing behavior comes from the sign of the average rate of change, and concavity from whether that rate itself rises or falls -- described only in increasing/decreasing and concave-up/down language, never calculus phrasing like ''rate increasing at an increasing rate.''',
   'A documented real scoring rule states explicitly that language analyzing a rate of change of a rate of change requires calculus and does not earn credit in this course, even when the underlying graph feature being described is exactly the same one a calculus student would call concavity.',
   'Full credit requires increasing/decreasing behavior and concavity described in this course''s own vocabulary (increasing, decreasing, concave up, concave down), never as a rate-of-a-rate statement that presumes calculus.',
   'Describe increasing/decreasing behavior from the sign of the average rate of change, and describe concavity as concave-up or concave-down, never as a rate changing at a changing rate.',
   'A student describes a graph''s behavior as ''the rate of change of the function is increasing at an increasing rate'' to explain a concave-up section.',
   'This is an acceptable, precise way to describe the graph''s behavior.',
   'This phrasing does not earn credit -- a real, documented scoring rule states that language describing a rate of change of a rate of change requires calculus and is not accepted in this course; the correct description states the section is concave up, or that the average rate of change is increasing across consecutive intervals, without ever describing a rate of a rate.',
   'Using calculus-flavored ''rate of change of the rate of change'' language instead of this course''s increasing/decreasing and concave-up/concave-down vocabulary.',
   'When describing a graph''s behavior, use only increasing/decreasing and concave-up/concave-down language, and never describe a rate of change of a rate of change.'),
  ('1.4',
   'A polynomial''s degree can be identified from tabulated data by checking successive finite differences -- the degree n is confirmed when the nth differences (not the first or second) are the constant ones, and checking only the first difference can misidentify a higher-degree polynomial as linear.',
   'Each additional round of consecutive differences reduces the degree by one, so a genuine cubic won''t show a constant pattern until the third round of differences, not the first or second.',
   'Full credit requires successive differences computed round by round until a constant round is reached, with the degree identified as matching the number of rounds needed, not assumed from the first round alone.',
   'Compute first differences; if not constant, compute second differences from those; continue until a round of differences is constant, and let the round number indicate the polynomial''s degree.',
   'A table of a polynomial''s values shows first differences of 2, 6, 12, 20 (not constant). A student concludes the data isn''t polynomial at all since the first differences aren''t constant.',
   'Correct -- non-constant first differences mean this isn''t polynomial data.',
   'Non-constant first differences don''t rule out a polynomial -- they rule out degree 1; computing second differences from 2,6,12,20 gives 4,6,8 (still not constant), and third differences from those give 2,2 (constant), confirming this is degree-3 (cubic) data, not non-polynomial data.',
   'Concluding data isn''t polynomial (or is a low degree) after checking only the first round of differences without continuing to higher rounds.',
   'When identifying a polynomial''s degree from a table, keep computing successive rounds of differences until one round is constant, rather than stopping after the first round.'),
  ('1.5',
   'A degree-n polynomial has exactly n complex zeros counting multiplicity, and for a polynomial with real coefficients, any nonreal complex zero must occur together with its conjugate -- finding one nonreal zero without its conjugate partner leaves the zero count incomplete.',
   'The Complex Conjugate Root Theorem is specific to polynomials with real coefficients: if a+bi is a zero, a-bi must also be a zero, so nonreal zeros for such a polynomial always come in matched pairs, never alone.',
   'Full credit requires the total zero count matching the polynomial''s degree exactly, with every nonreal zero paired with its conjugate when the polynomial has real coefficients.',
   'Count the degree first to know how many zeros (with multiplicity) must exist, and whenever one nonreal zero is found, immediately include its conjugate as a second zero.',
   'A degree-4 polynomial with real coefficients has known zeros 2, -1, and 3+2i. A student lists these three as the complete set of zeros.',
   'This is the complete list, since three zeros were correctly identified.',
   'A degree-4 polynomial must have exactly 4 zeros counting multiplicity, and this polynomial has real coefficients, so the nonreal zero 3+2i must have its conjugate 3-2i as a zero too; the complete list is 2, -1, 3+2i, and 3-2i -- listing only three zeros for a degree-4 polynomial leaves one zero, the conjugate partner, missing.',
   'Listing a nonreal zero without its complex conjugate partner for a real-coefficient polynomial, or miscounting the total zeros against the polynomial''s degree.',
   'Before finalizing a list of a polynomial''s zeros, check the count against the degree, and confirm every nonreal zero has its conjugate included as well.'),
  ('1.6',
   'A polynomial''s end behavior as x approaches positive or negative infinity is determined entirely by its leading term (the highest-degree term) -- every other term becomes negligible at extreme x-values, so reading end behavior from a lower-degree term produces a wrong prediction.',
   'The leading term''s degree (even or odd) and its coefficient''s sign together determine all four possible end-behavior patterns; the rest of the polynomial''s terms only matter for behavior near the middle of the graph, not at the extremes.',
   'Full credit requires end behavior determined explicitly from the leading term''s degree and sign, not from a lower-degree term or the polynomial''s behavior near the origin.',
   'Identify the leading term (highest degree with its coefficient), determine whether the degree is even or odd and the coefficient''s sign, then state the end behavior from that pattern alone.',
   'For f(x) = -2x^3 + 100x^2 + 5, a student predicts end behavior by focusing on the 100x^2 term since it has the largest coefficient.',
   'This is a reasonable way to predict end behavior, since 100x^2 has the biggest coefficient.',
   'End behavior is governed only by the leading term, -2x^3, not by which term has the largest coefficient; since the degree is odd (3) and the leading coefficient is negative, the correct end behavior is f(x) approaches positive infinity as x approaches negative infinity, and f(x) approaches negative infinity as x approaches positive infinity -- the 100x^2 term''s large coefficient becomes irrelevant at extreme x-values.',
   'Predicting end behavior from a term with a large coefficient instead of the actual highest-degree (leading) term.',
   'Before predicting a polynomial''s end behavior, identify the leading term (highest degree, not largest coefficient) and read the degree-and-sign pattern from that term alone.'),
  ('1.7',
   'A rational function''s end behavior is found by comparing the degrees of its numerator and denominator -- if the degrees are equal, the end behavior approaches the ratio of leading coefficients, not zero or infinity, a specific case that''s easy to conflate with the other degree-comparison outcomes.',
   'There are three genuinely distinct cases (numerator degree less than, equal to, or greater than denominator degree), each producing a different end-behavior pattern, so identifying which case applies is a required first step, not something that can be skipped.',
   'Full credit requires the numerator and denominator degrees compared explicitly first, with the end behavior matched to the correct case (horizontal asymptote at zero, at the leading-coefficient ratio, or no horizontal asymptote with a possible slant behavior).',
   'Compare the numerator''s degree to the denominator''s degree explicitly, then apply the matching end-behavior rule for that specific case rather than a general rule.',
   'For f(x) = (3x^2+1)/(5x^2-4), a student concludes the end behavior approaches 0 since the denominator ''grows without bound.''',
   'This is correct, since a growing denominator should force the whole fraction toward 0.',
   'This reasoning applies only when the denominator''s degree exceeds the numerator''s, which is not the case here -- since both numerator and denominator have degree 2 (equal degrees), the end behavior instead approaches the ratio of leading coefficients, 3/5, not 0.',
   'Applying the wrong end-behavior rule by not first checking whether the numerator and denominator degrees are less than, equal to, or greater than each other.',
   'Before stating a rational function''s end behavior, explicitly compare the numerator''s and denominator''s degrees first, and apply only the rule matching that specific comparison.'),
  ('1.8',
   'A rational function''s zero requires the numerator to equal zero at that input, and also requires that the same factor doesn''t cancel with a matching factor in the denominator -- a cancelable common factor produces a hole there instead of a genuine zero.',
   'Finding where the numerator equals zero is necessary but not sufficient for a true zero; the same input value must be checked against the denominator''s factors too, since a shared factor changes that point from a zero into a removable discontinuity.',
   'Full credit requires the numerator''s zeros found explicitly, then each one checked against the denominator''s factors to confirm it isn''t a canceling common factor before calling it a genuine zero.',
   'Find where the numerator equals zero, then check whether that same input also makes the denominator zero via a shared, canceling factor -- if so, it''s a hole, not a zero.',
   'For f(x) = (x-2)(x+3)/(x-2), a student lists x=2 and x=-3 as the function''s two zeros.',
   'This is correct, since both values make the numerator equal to zero.',
   'x=2 is not a genuine zero -- the factor (x-2) cancels between the numerator and denominator, creating a hole at x=2, not a zero; the only actual zero of this rational function is x=-3, since that value makes the numerator zero without any canceling factor in the denominator.',
   'Listing a numerator zero as a genuine zero of the rational function without checking whether it''s actually a canceling common factor (a hole).',
   'After finding where a rational function''s numerator equals zero, always check whether that same input is also canceled by the denominator before calling it a genuine zero.'),
  ('1.9',
   'A vertical asymptote occurs where the denominator equals zero and that factor does not cancel with a matching factor in the numerator -- a canceling factor at that same input instead produces a hole, not unbounded behavior.',
   'Both a vertical asymptote and a hole come from the denominator equaling zero at some input, so the distinguishing question is always whether that specific factor cancels with the numerator or survives uncanceled.',
   'Full credit requires every denominator zero checked against the numerator''s factors, with vertical asymptotes identified only at the ones that don''t cancel.',
   'Find where the denominator equals zero, then check each one against the numerator''s factors -- an uncanceled factor gives a vertical asymptote, a canceled one gives a hole instead.',
   'For f(x) = (x+1)/[(x+1)(x-5)], a student identifies vertical asymptotes at both x=-1 and x=5.',
   'This is correct, since both values make the denominator equal zero.',
   'x=-1 is not a vertical asymptote -- the factor (x+1) cancels with the matching factor in the numerator, producing a hole there instead; the only vertical asymptote is at x=5, since that denominator factor does not cancel with anything in the numerator.',
   'Identifying a vertical asymptote at a denominator zero without checking whether that factor actually cancels with the numerator (which would make it a hole instead).',
   'Before calling any denominator zero a vertical asymptote, check whether that specific factor cancels with the numerator -- if it does, it''s a hole, not an asymptote.'),
  ('1.10',
   'A hole appears exactly where a factor cancels between the numerator and denominator -- the hole''s location is the input value making that shared factor zero, and its height is found by evaluating the simplified (post-cancellation) function at that input, not by leaving it undefined.',
   'Canceling a common factor changes the function''s formula (removing the discontinuity from the expression) but not its actual behavior -- the original function is still undefined at that exact input, even though the simplified expression would compute a value there.',
   'Full credit requires the hole''s x-location identified from the canceling factor, and its y-value computed by substituting that x into the simplified expression after cancellation, not the original unsimplified one.',
   'Identify the canceling factor and its zero as the hole''s x-location, simplify the expression by canceling that factor, then substitute the x-location into the simplified expression to find the hole''s y-value.',
   'For f(x) = (x-3)(x+2)/(x-3), a student identifies a hole at x=3 but leaves its y-value as undefined since the original expression is 0/0 there.',
   'The y-value should be reported as undefined, since substituting x=3 into the original expression gives 0/0.',
   'The hole''s y-value is found from the simplified expression, not the original -- after canceling (x-3), the simplified function is f(x)=x+2, so at x=3 the hole''s height is 3+2=5; the hole is located at the point (3,5), not left as an undefined y-value, even though the original unsimplified expression is indeed undefined there.',
   'Leaving a hole''s y-value undefined instead of computing it from the simplified expression after canceling the common factor.',
   'After identifying a hole''s x-location from a canceling factor, always compute its y-value by substituting into the simplified expression, not the original unsimplified one.'),
  ('1.11',
   'Polynomial division rewrites a rational expression as f(x)=g(x)q(x)+r(x), with the remainder''s degree strictly less than the divisor''s degree -- this rewrite is what reveals a rational function''s slant or curved asymptotic behavior, which the original unrewritten fraction form doesn''t show directly.',
   'The quotient q(x) from this division is exactly the function the rational expression approaches for large x-values, since the remainder term r(x)/g(x) shrinks toward zero as x grows, making q(x) the asymptotic behavior in a rewritten, equivalent form.',
   'Full credit requires the division identity performed correctly with the remainder''s degree confirmed less than the divisor''s, and the quotient term identified as the asymptotic behavior for large x.',
   'Perform polynomial division to write the rational function as quotient plus remainder-over-divisor, confirm the remainder''s degree is less than the divisor''s, then read the quotient as the large-x asymptotic behavior.',
   'For f(x) = (x^2+3)/(x-1), a student performs division and gets a remainder of degree 1, matching the divisor''s own degree of 1.',
   'A remainder of the same degree as the divisor is a valid final result for this division.',
   'The division identity requires the remainder''s degree to be strictly less than the divisor''s degree -- a degree-1 remainder over a degree-1 divisor means the division isn''t finished; continuing correctly gives f(x) = x+1 + 4/(x-1), where the remainder 4 has degree 0, properly less than the divisor''s degree 1, and x+1 is the correct slant-asymptote behavior for large x.',
   'Stopping a polynomial division before the remainder''s degree is strictly less than the divisor''s degree.',
   'When performing polynomial division to rewrite a rational function, confirm the final remainder''s degree is strictly less than the divisor''s degree before treating the division as complete.'),
  ('1.12',
   'The four transformation forms -- f(x)+k, f(x+h), a*f(x), f(bx) -- each move or reshape a parent function''s graph in a specific, distinct way, and a change made inside the function''s input (h or b) behaves in the opposite direction from what its sign might suggest.',
   'f(x+h) shifts the graph horizontally by -h, not +h -- an input-side change acts in the reverse direction of an output-side change, which is the single most common transformation direction error.',
   'Full credit requires each transformation parameter (k, h, a, b) correctly matched to its specific effect (vertical shift, horizontal shift in the opposite direction of h''s sign, vertical stretch/reflection, horizontal stretch/compression), not assumed to all shift in the same intuitive direction.',
   'Identify whether each change is inside or outside the function, then apply outside changes (k, a) directly and inside changes (h, b) in the reversed and/or reciprocal direction.',
   'For g(x) = f(x+3), a student states the graph of f is shifted 3 units to the right to produce g.',
   'This is correct, since the +3 suggests a shift in the positive direction.',
   'An input-side change acts in the opposite direction from its sign -- f(x+3) shifts the graph of f 3 units to the left, not to the right, since replacing x with x+3 means the graph reaches the same output values 3 units earlier (at a smaller x); a rightward shift of 3 would instead require f(x-3).',
   'Shifting a graph in the same direction as an inside-the-function parameter''s sign, instead of the reversed direction that horizontal shifts actually require.',
   'Before applying any transformation, check whether the change is inside or outside the function -- inside changes (horizontal shift and stretch) act in the reversed and/or reciprocal direction from what the sign alone suggests.'),
  ('1.13',
   'Selecting a function model from data requires computing the data''s actual constant pattern (difference, ratio, or another structural check) and stating that computed value as the assumption, not describing the data''s general growth trend or citing a regression statistic.',
   'A documented real error mislabels an exponential decay''s actual ratio -- describing data as ''decreasing at a factor of 2'' when the computed ratio is really 0.5 is a genuine reciprocal-confusion mistake, not just imprecise wording, since a decay factor of 0.5 and a growth factor of 2 describe very different behaviors.',
   'Full credit requires the model type''s defining pattern (constant difference, constant ratio, or other) computed explicitly from the data, with the exact computed value (not its reciprocal) stated as the model''s assumption.',
   'Compute the actual constant difference or ratio directly from the data, then state that exact computed number as the model''s assumption, checking it isn''t accidentally reported as its reciprocal.',
   'Data at equally spaced intervals shows values 100, 50, 25, 12.5. A student describes this as ''decreasing exponentially at a factor of 2.''',
   'This is a correct description, since the values are clearly halving.',
   'This is a documented, real reciprocal-confusion error -- the actual computed ratio here is 50/100=0.5, 25/50=0.5, 12.5/25=0.5, a constant ratio of 0.5, not 2; describing this as ''a factor of 2'' states the reciprocal of the actual computed ratio, which is a genuinely different (growth, not decay) number.',
   'Stating a data pattern''s reciprocal (such as saying ''factor of 2'' when the computed ratio is actually 0.5) instead of the exact computed value.',
   'When stating a data pattern''s constant ratio or difference as a model assumption, double-check the number is the actual computed value, not its reciprocal.'),
  ('1.14',
   'Constructing a function model from context requires translating every given piece of information -- an initial value, a rate, a constraint -- into a specific parameter in the model''s equation, not just choosing the right function family and leaving parameters unset or guessed.',
   'Model construction is a distinct, later step from model selection: after the function type is chosen, every numeric detail given in the context must be matched to a specific parameter, since an unset or guessed parameter makes the model unusable for prediction.',
   'Full credit requires every given numeric detail in the context translated into a specific, correctly-placed parameter in the model equation, with none left as a placeholder or assumed value.',
   'List every numeric detail given in the context, match each one to a specific parameter in the chosen model type, then write the fully parameterized equation before using it.',
   'A context states a company''s revenue starts at $10,000 and grows by $2,000 each year. A student selects the linear model type f(x)=mx+b but leaves m and b as unspecified variables when answering a prediction question.',
   'Selecting the correct model type, linear, is enough to answer the prediction question.',
   'Selecting the model type is not the same as constructing it -- the context gives both needed values: the initial value 10,000 is b, and the yearly change 2,000 is m, so the fully constructed model is f(x)=2000x+10000; leaving m and b unspecified means the model can''t actually be used to answer any numeric prediction question.',
   'Selecting the correct model type without translating every given numeric detail into a specific, correctly-placed parameter.',
   'After selecting a model type from context, explicitly match every given numeric detail to a specific parameter before treating the model as complete.')
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
  source_note = 'cramapple-authored; repaired 2026-08-22 replacing a template-generated explainer (previously generated-from-brief, grandfathered) with topic-specific content grounded in AP_PRECALCULUS_CED_FACT_PACK.md Unit 1 deep-tier detail (the boxed open-vs-closed-interval exclusion for 1.1, the register-boundary rule barring calculus rate-of-a-rate language for 1.3, the Complex Conjugate Root Theorem for 1.5, the documented reciprocal/ratio-confusion error for 1.13, and the polynomial-division remainder-degree requirement for 1.11); briefs for this unit are genuinely hand-authored and were NOT touched. batch 2026-08-22-ap-precalculus-unit1-explainer-repair; author=reviewer same session, no independent human review yet'
from explainer_updates u
where e.subject_key = 'ap_precalculus'
  and e.unit_number = 1
  and e.topic_code = u.topic_code;

do $$
declare
  v_repaired integer;
  v_core_matches integer;
begin
  select count(*) into v_repaired from app.topic_explainers
    where subject_key='ap_precalculus' and unit_number=1 and status='published'
      and source_note like '%unit1-explainer-repair%';
  if v_repaired <> 14 then
    raise exception 'expected 14 repaired AP Precalculus Unit 1 explainers, got %', v_repaired;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e on e.subject_key=b.subject_key and e.topic_code=b.topic_code
  where b.subject_key='ap_precalculus' and b.unit_number=1 and b.status='published'
    and e.status='published' and e.core_idea = b.what_it_is;
  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Precalculus Unit 1 explainers matching their brief verbatim, got %', v_core_matches;
  end if;
end $$;

commit;
