-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- Treating one quantity as a function of another means every input value corresponds to exactly one output value.
- This topic is explicitly scoped to describing change qualitatively.
- Open-versus-closed interval distinctions for increasing/decreasing behavior are outside the course's scope entirely.$q$,
  what_students_need_to_understand = $q$- The AP Precalculus course states directly that discriminating between open and closed intervals for increasing/decreasing behavior is outside its scope.
- So a response should never be penalized (or rewarded) for interval-endpoint notation on this kind of description.$q$,
  how_this_becomes_points = $q$1. Correctly identify which quantity depends on which (the functional relationship).
2. Describe the co-change qualitatively.
3. Do not introduce open/closed interval distinctions the course doesn't assess.$q$,
  point_attaining_answer = $q$Neither the open nor the closed version is required here.

- The AP Precalculus course explicitly states that discriminating between open and closed intervals for increasing/decreasing behavior is outside its scope.
- Describing the interval as [2,5] or (2,5) are both acceptable, since this distinction is not something the course assesses.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='41e0562d33ce9e6d5876f049d3b69f48';
update app.topic_explainers set
  core_idea = $q$- Average rate of change over [a,b] is computed as [f(b)-f(a)]/(b-a), the slope of the secant line connecting the two endpoints.
- It is a ratio over an interval, not an instantaneous value at a single point.
- Instantaneous rates belong to calculus and are outside this course.$q$,
  what_students_need_to_understand = $q$- The average rate of change formula always needs two distinct input values to compute a difference in outputs over a difference in inputs.
- Asking for a rate 'at' a single point (rather than over an interval) is a calculus question this course doesn't address.$q$,
  how_this_becomes_points = $q$1. State two endpoint values.
2. Compute the average rate of change explicitly as [f(b)-f(a)]/(b-a).
3. Do not estimate it from the graph's visual steepness at a single point.$q$,
  point_attaining_answer = $q$1. Average rate of change must be computed, not estimated visually.
2. Use the formula [f(4)-f(1)]/(4-1) = (16-1)/3 = 5.
3. The average rate of change is exactly 5, which requires evaluating f at both endpoints and dividing, not judging the curve's steepness by eye.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5c6c0a60a2aabc72fd73d5d84ca73f55';
update app.topic_explainers set
  core_idea = $q$- Increasing/decreasing behavior comes from the sign of the average rate of change.
- Concavity comes from whether that rate itself rises or falls.
- Describe it only in increasing/decreasing and concave-up/down language, never calculus phrasing like 'rate increasing at an increasing rate.'$q$,
  what_students_need_to_understand = $q$- A documented real scoring rule states that language analyzing a rate of change of a rate of change requires calculus and does not earn credit in this course.
- This holds even when the underlying graph feature is exactly the one a calculus student would call concavity.$q$,
  how_this_becomes_points = $q$1. Describe increasing/decreasing behavior and concavity in this course's own vocabulary: increasing, decreasing, concave up, concave down.
2. Never state it as a rate-of-a-rate that presumes calculus.$q$,
  point_attaining_answer = $q$- This phrasing does not earn credit.
- A real, documented scoring rule states that language describing a rate of change of a rate of change requires calculus and is not accepted in this course.
- The correct description states the section is concave up, or that the average rate of change is increasing across consecutive intervals, without ever describing a rate of a rate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='72a424a4a63686915d10f66a51a29025';
update app.topic_explainers set
  core_idea = $q$- A polynomial's degree can be identified from tabulated data by checking successive finite differences.
- The degree n is confirmed when the nth differences (not the first or second) are the constant ones.
- Checking only the first difference can misidentify a higher-degree polynomial as linear.$q$,
  what_students_need_to_understand = $q$- Each additional round of consecutive differences reduces the degree by one.
- So a genuine cubic won't show a constant pattern until the third round of differences, not the first or second.$q$,
  how_this_becomes_points = $q$1. Compute successive differences round by round until a constant round is reached.
2. Identify the degree as the number of rounds needed.
3. Do not assume the degree from the first round alone.$q$,
  point_attaining_answer = $q$1. Non-constant first differences don't rule out a polynomial; they rule out degree 1.
2. Second differences from 2,6,12,20 give 4,6,8 (still not constant).
3. Third differences from those give 2,2 (constant).
4. This confirms degree-3 (cubic) data, not non-polynomial data.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8590f7f88e43499bd367d168fe3a2dbd';
update app.topic_explainers set
  core_idea = $q$- A degree-n polynomial has exactly n complex zeros counting multiplicity.
- For a polynomial with real coefficients, any nonreal complex zero must occur together with its conjugate.
- Finding one nonreal zero without its conjugate partner leaves the zero count incomplete.$q$,
  what_students_need_to_understand = $q$- The Complex Conjugate Root Theorem is specific to polynomials with real coefficients.
- If a+bi is a zero, a-bi must also be a zero, so nonreal zeros for such a polynomial always come in matched pairs, never alone.$q$,
  how_this_becomes_points = $q$1. Make the total zero count match the polynomial's degree exactly.
2. When the polynomial has real coefficients, pair every nonreal zero with its conjugate.$q$,
  point_attaining_answer = $q$1. A degree-4 polynomial must have exactly 4 zeros counting multiplicity.
2. This polynomial has real coefficients, so the nonreal zero 3+2i must have its conjugate 3-2i as a zero too.
3. The complete list is 2, -1, 3+2i, and 3-2i.
4. Listing only three zeros for a degree-4 polynomial leaves one zero, the conjugate partner, missing.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='964e9b63e51e8952644943318b5c10af';
update app.topic_explainers set
  core_idea = $q$- A polynomial's end behavior as x approaches positive or negative infinity is determined entirely by its leading term (the highest-degree term).
- Every other term becomes negligible at extreme x-values.
- Reading end behavior from a lower-degree term produces a wrong prediction.$q$,
  what_students_need_to_understand = $q$- The leading term's degree (even or odd) and its coefficient's sign together determine all four possible end-behavior patterns.
- The rest of the polynomial's terms only matter for behavior near the middle of the graph, not at the extremes.$q$,
  how_this_becomes_points = $q$1. Determine end behavior explicitly from the leading term's degree and sign.
2. Do not use a lower-degree term or the polynomial's behavior near the origin.$q$,
  point_attaining_answer = $q$1. End behavior is governed only by the leading term, -2x^3, not by which term has the largest coefficient.
2. The degree is odd (3) and the leading coefficient is negative.
3. So f(x) approaches positive infinity as x approaches negative infinity, and f(x) approaches negative infinity as x approaches positive infinity.
4. The 100x^2 term's large coefficient becomes irrelevant at extreme x-values.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d611a7a78875780a55a5a4a2b581531c';
update app.topic_explainers set
  core_idea = $q$- A rational function's end behavior is found by comparing the degrees of its numerator and denominator.
- If the degrees are equal, the end behavior approaches the ratio of leading coefficients, not zero or infinity.
- That specific case is easy to conflate with the other degree-comparison outcomes.$q$,
  what_students_need_to_understand = $q$- There are three genuinely distinct cases: numerator degree less than, equal to, or greater than denominator degree.
- Each produces a different end-behavior pattern, so identifying which case applies is a required first step, not something that can be skipped.$q$,
  how_this_becomes_points = $q$1. Compare the numerator and denominator degrees explicitly first.
2. Match the end behavior to the correct case: horizontal asymptote at zero, at the leading-coefficient ratio, or no horizontal asymptote with a possible slant behavior.$q$,
  point_attaining_answer = $q$1. This reasoning applies only when the denominator's degree exceeds the numerator's, which is not the case here.
2. Both numerator and denominator have degree 2 (equal degrees).
3. So the end behavior instead approaches the ratio of leading coefficients, 3/5, not 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ceff1ec201eb42a98e613785be517f47';
update app.topic_explainers set
  core_idea = $q$- A rational function's zero requires the numerator to equal zero at that input.
- It also requires that the same factor doesn't cancel with a matching factor in the denominator.
- A cancelable common factor produces a hole there instead of a genuine zero.$q$,
  what_students_need_to_understand = $q$- Finding where the numerator equals zero is necessary but not sufficient for a true zero.
- The same input value must be checked against the denominator's factors too, since a shared factor changes that point from a zero into a removable discontinuity.$q$,
  how_this_becomes_points = $q$1. Find the numerator's zeros explicitly.
2. Check each one against the denominator's factors.
3. Confirm it isn't a canceling common factor before calling it a genuine zero.$q$,
  point_attaining_answer = $q$- x=2 is not a genuine zero: the factor (x-2) cancels between the numerator and denominator, creating a hole at x=2, not a zero.
- The only actual zero of this rational function is x=-3, since that value makes the numerator zero without any canceling factor in the denominator.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3cb3f50f6a0f1a62a1d1fb73276d0f3d';
update app.topic_explainers set
  core_idea = $q$- A vertical asymptote occurs where the denominator equals zero and that factor does not cancel with a matching factor in the numerator.
- A canceling factor at that same input instead produces a hole, not unbounded behavior.$q$,
  what_students_need_to_understand = $q$- Both a vertical asymptote and a hole come from the denominator equaling zero at some input.
- So the distinguishing question is always whether that specific factor cancels with the numerator or survives uncanceled.$q$,
  how_this_becomes_points = $q$1. Check every denominator zero against the numerator's factors.
2. Identify vertical asymptotes only at the ones that don't cancel.$q$,
  point_attaining_answer = $q$- x=-1 is not a vertical asymptote: the factor (x+1) cancels with the matching factor in the numerator, producing a hole there instead.
- The only vertical asymptote is at x=5, since that denominator factor does not cancel with anything in the numerator.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c1fe40b5b29ca384e726c5d33b358519';
update app.topic_explainers set
  core_idea = $q$- A hole appears exactly where a factor cancels between the numerator and denominator.
- The hole's location is the input value making that shared factor zero.
- Its height is found by evaluating the simplified (post-cancellation) function at that input, not by leaving it undefined.$q$,
  what_students_need_to_understand = $q$- Canceling a common factor changes the function's formula (removing the discontinuity from the expression) but not its actual behavior.
- The original function is still undefined at that exact input, even though the simplified expression would compute a value there.$q$,
  how_this_becomes_points = $q$1. Identify the hole's x-location from the canceling factor.
2. Compute its y-value by substituting that x into the simplified expression after cancellation, not the original unsimplified one.$q$,
  point_attaining_answer = $q$1. The hole's y-value is found from the simplified expression, not the original.
2. After canceling (x-3), the simplified function is f(x)=x+2.
3. At x=3 the hole's height is 3+2=5, so the hole is located at the point (3,5), not left as an undefined y-value.
4. The original unsimplified expression is indeed undefined there.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='279bcc01ba91ad6631017dfc6b914393';
update app.topic_explainers set
  core_idea = $q$- Polynomial division rewrites a rational expression as f(x)=g(x)q(x)+r(x), with the remainder's degree strictly less than the divisor's degree.
- This rewrite reveals a rational function's slant or curved asymptotic behavior, which the original unrewritten fraction form doesn't show directly.$q$,
  what_students_need_to_understand = $q$- The quotient q(x) from this division is exactly the function the rational expression approaches for large x-values.
- The remainder term r(x)/g(x) shrinks toward zero as x grows, making q(x) the asymptotic behavior in a rewritten, equivalent form.$q$,
  how_this_becomes_points = $q$1. Perform the division identity correctly.
2. Confirm the remainder's degree is less than the divisor's.
3. Identify the quotient term as the asymptotic behavior for large x.$q$,
  point_attaining_answer = $q$1. The division identity requires the remainder's degree to be strictly less than the divisor's degree.
2. A degree-1 remainder over a degree-1 divisor means the division isn't finished.
3. Continuing correctly gives f(x) = x+1 + 4/(x-1), where the remainder 4 has degree 0, properly less than the divisor's degree 1.
4. x+1 is the correct slant-asymptote behavior for large x.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f476c7d609b25aee5d45c05170a144ad';
update app.topic_explainers set
  core_idea = $q$- The four transformation forms are f(x)+k, f(x+h), a*f(x), f(bx).
- Each moves or reshapes a parent function's graph in a specific, distinct way.
- A change made inside the function's input (h or b) behaves in the opposite direction from what its sign might suggest.$q$,
  what_students_need_to_understand = $q$- f(x+h) shifts the graph horizontally by -h, not +h.
- An input-side change acts in the reverse direction of an output-side change, which is the single most common transformation direction error.$q$,
  how_this_becomes_points = $q$| Parameter | Effect |
| k | vertical shift |
| h | horizontal shift, opposite direction of h's sign |
| a | vertical stretch/reflection |
| b | horizontal stretch/compression |$q$,
  point_attaining_answer = $q$1. An input-side change acts in the opposite direction from its sign.
2. f(x+3) shifts the graph of f 3 units to the left, not to the right.
3. Replacing x with x+3 means the graph reaches the same output values 3 units earlier (at a smaller x).
4. A rightward shift of 3 would instead require f(x-3).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2b03fb1f924b983afd3fbc116398eb0f';
update app.topic_explainers set
  core_idea = $q$- Selecting a function model from data requires computing the data's actual constant pattern (difference, ratio, or another structural check).
- State that computed value as the assumption.
- Do not describe the data's general growth trend or cite a regression statistic.$q$,
  what_students_need_to_understand = $q$- A documented real error mislabels an exponential decay's actual ratio: describing data as 'decreasing at a factor of 2' when the computed ratio is really 0.5.
- This is a genuine reciprocal-confusion mistake, not just imprecise wording, since a decay factor of 0.5 and a growth factor of 2 describe very different behaviors.$q$,
  how_this_becomes_points = $q$1. Compute the model type's defining pattern (constant difference, constant ratio, or other) explicitly from the data.
2. State the exact computed value (not its reciprocal) as the model's assumption.$q$,
  point_attaining_answer = $q$1. This is a documented, real reciprocal-confusion error.
2. The actual computed ratios are 50/100=0.5, 25/50=0.5, 12.5/25=0.5, a constant ratio of 0.5, not 2.
3. Describing this as 'a factor of 2' states the reciprocal of the actual computed ratio, which is a genuinely different (growth, not decay) number.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dd1ea6f0660a12cdaefc5e6dd96a88f0';
update app.topic_explainers set
  core_idea = $q$- Constructing a function model from context requires translating every given piece of information (an initial value, a rate, a constraint) into a specific parameter in the model's equation.
- Choosing the right function family is not enough; parameters must not be left unset or guessed.$q$,
  what_students_need_to_understand = $q$- Model construction is a distinct, later step from model selection.
- After the function type is chosen, every numeric detail given in the context must be matched to a specific parameter, since an unset or guessed parameter makes the model unusable for prediction.$q$,
  how_this_becomes_points = $q$1. Translate every given numeric detail in the context into a specific, correctly-placed parameter in the model equation.
2. Leave none as a placeholder or assumed value.$q$,
  point_attaining_answer = $q$1. Selecting the model type is not the same as constructing it.
2. The context gives both needed values: the initial value 10,000 is b, and the yearly change 2,000 is m.
3. The fully constructed model is f(x)=2000x+10000.
4. Leaving m and b unspecified means the model can't actually be used to answer any numeric prediction question.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=1 and topic_code='1.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ce2ff53e8be5ced7fadd3b8b400103e4';
update app.topic_explainers set
  core_idea = $q$- A sequence is classified as arithmetic or geometric by an actual computed check, not by how the numbers look at a glance.
- Arithmetic: constant term-to-term difference.
- Geometric: constant term-to-term ratio.$q$,
  what_students_need_to_understand = $q$- The same list of numbers could look like it fits either pattern at first glance.
- Only the explicit difference-then-ratio check distinguishes them, and a sequence can fail both checks entirely.$q$,
  how_this_becomes_points = $q$1. Show the consecutive-difference computation explicitly.
2. If differences aren't constant, show the consecutive-ratio computation too.
3. Do not just name a sequence type.$q$,
  point_attaining_answer = $q$1. This is not arithmetic: the differences (3, 6, 12) are not constant, so the arithmetic check fails.
2. Checking ratios instead (6/3=2, 12/6=2, 24/12=2) gives a constant ratio of 2.
3. So this sequence is geometric with common ratio 2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='35765c804f2adda1892e8ae9d693d824';
update app.topic_explainers set
  core_idea = $q$- Justifying that data is exponential requires computing the actual constant ratio between consecutive outputs.
- Citing a calculator's regression fit statistic like r-squared is a documented, real reasoning error that fails to earn credit even with the correct classification.$q$,
  what_students_need_to_understand = $q$- A high r-squared value only says a model fits well.
- It says nothing about which family of function actually produces constant ratios in the data, which is the real defining test for exponential behavior.$q$,
  how_this_becomes_points = $q$1. Compute the actual constant ratio (or constant difference) from the data and show it.
2. Do not cite a regression-fit statistic as justification.$q$,
  point_attaining_answer = $q$1. Citing r-squared is not sufficient reasoning; this is a documented real scoring pattern where such justification fails to earn the point.
2. Compute the actual ratios of consecutive outputs: 10/5=2, 20/10=2, 40/20=2.
3. The constant ratio of 2 is what actually demonstrates exponential behavior.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b69642913899f7e10ebdad31742faf87';
update app.topic_explainers set
  core_idea = $q$- The exponential form f(x) = a*b^x carries three required restrictions: a nonzero, b positive, b not equal to 1.
- Each restriction rules out a specific way the function would otherwise break or degenerate.$q$,
  what_students_need_to_understand = $q$- b=1 would make f(x) constant (not exponential at all).
- b≤0 would make the function undefined or oscillate wildly for non-integer x.
- So these are not arbitrary technicalities but conditions that keep the function meaningfully exponential.$q$,
  how_this_becomes_points = $q$1. State the general form with a and b correctly identified from the given information.
2. Confirm the restrictions are satisfied rather than assumed.$q$,
  point_attaining_answer = $q$- This is not a valid exponential model: b=1 is explicitly excluded by the required form, since (1)^x always equals 1, making f(x) constant at 200 rather than exponential.
- A valid exponential model needs a growth or decay factor b that is positive and not equal to 1, such as f(x)=200*(1.05)^x for 5% growth.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dc0af5e332eafa809a91be0a3617f010';
update app.topic_explainers set
  core_idea = $q$- Rewriting an exponential expression into an equivalent form (a different base, a different-looking growth rate) requires the exponent laws applied correctly step by step.
- A rewrite not checked against the original at a test value can silently be a different function, not an equivalent one.$q$,
  what_students_need_to_understand = $q$- Exponent rules like (b^m)^n = b^(mn) apply to products and powers of the base, never to sums in the exponent or the base itself.
- A rewrite that distributes an exponent across addition breaks the expression's actual value.$q$,
  how_this_becomes_points = $q$1. Show each exponent-law step explicitly.
2. Verify the rewritten expression against the original at a test input value.$q$,
  point_attaining_answer = $q$1. This is not equivalent: exponent addition in 2^(x+3) means 2^x * 2^3, not 2^x + 2^3.
2. Test at x=0: the original gives 2^3=8, while the incorrect rewrite gives 2^0+2^3=1+8=9.
3. So the rewritten form is a different function, not an equivalent one.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ffeefc014151087c02af6642231385d5';
update app.topic_explainers set
  core_idea = $q$- Building an exponential model from a stated growth or decay rate requires converting that percentage into b as 1 plus or minus the rate as a decimal.
- Using the raw percentage itself as b, without the 1, produces a model that shrinks or grows in the wrong direction entirely.$q$,
  what_students_need_to_understand = $q$- A '5% growth' rate means the new amount is 105% of the old amount, so b = 1.05, not b = 0.05.
- The same logic in reverse gives b = 0.95 for 5% decay, since the new amount is 95% of the old.$q$,
  how_this_becomes_points = $q$1. Convert the rate to b (1 plus or minus the decimal rate).
2. Identify the initial value as a.
3. Interpret the model's output using the context's units.$q$,
  point_attaining_answer = $q$1. The base is wrong: a 5% growth rate means the population becomes 105% of the previous year's value each year, so b should be 1.05, not 0.05.
2. Using b=0.05 would model rapid decay toward zero, the opposite of growth.
3. The correct model is f(x) = 200*(1.05)^x.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='12ffc4b58625a3b4fd1f87fd051c5158';
update app.topic_explainers set
  core_idea = $q$- Choosing between two competing model types for the same data requires computing the data's actual difference and ratio patterns directly.
- Comparing which model has the higher r-squared value is not valid justification, even when it points to the same correct answer.$q$,
  what_students_need_to_understand = $q$- Test the data against both patterns: if consecutive differences are constant, linear fits; if consecutive ratios are constant instead, exponential fits.
- A data set should not fit both patterns simultaneously unless it is genuinely constant.$q$,
  how_this_becomes_points = $q$1. Show both the consecutive-difference and consecutive-ratio computations.
2. Select the model based on which pattern is actually constant in the data.$q$,
  point_attaining_answer = $q$1. Neither pattern actually holds here, and 'growing faster' alone isn't valid reasoning.
2. Consecutive differences are 3, 5, 7 (not constant, so not linear).
3. Consecutive ratios are 7/4=1.75, 12/7≈1.71, 19/12≈1.58 (not constant either, so not exponential).
4. This data doesn't cleanly fit either competing model, and neither should be selected without an actual constant pattern found.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='33a79506bd49f043bfdb5d4253ad97c6';
update app.topic_explainers set
  core_idea = $q$- Function composition applies the inner function first and substitutes its entire output into the outer function.
- f(g(x)) and g(f(x)) are generally different functions entirely, not just two ways of writing the same computation.$q$,
  what_students_need_to_understand = $q$- The notation f(g(x)) reads right-to-left in terms of application order: g acts on x first.
- Only that full result becomes the input to f, so every instance of the outer function's variable must be replaced by the complete inner expression.$q$,
  how_this_becomes_points = $q$1. Substitute the entire inner function's expression correctly into the outer function.
2. Use the order specified by the notation.
3. Simplify the result.$q$,
  point_attaining_answer = $q$1. This computed g(f(x)), not the requested f(g(x)); these are generally different functions.
2. Substitute g(x)=x-3 into f: f(g(x)) = (x-3)^2 + 1.
3. This expands to x^2 - 6x + 10, a different function from x^2 - 2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7bd0f85db34af774d6b1587591d92a30';
update app.topic_explainers set
  core_idea = $q$- An inverse function only exists when the original function is one-to-one over its domain.
- Swapping x and y and solving for a function that fails this check produces a relation, not a genuine inverse function.$q$,
  what_students_need_to_understand = $q$- A function that assigns the same output to two different inputs cannot have its pairs cleanly reversed into a function.
- The reversed relation would need to send one input back to two different outputs.$q$,
  how_this_becomes_points = $q$1. Confirm the function is one-to-one (or restrict its domain so it is) before computing an inverse.
2. Then correctly swap the variables and solve.$q$,
  point_attaining_answer = $q$1. f(x) = x^2 over all real numbers is not one-to-one (both x=2 and x=-2 give f(x)=4), so it has no true inverse function over its full domain.
2. y = sqrt(x) is only the inverse of the restricted function f(x) = x^2 for x ≥ 0, not of f(x) = x^2 over all real numbers.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1d408706b711f99af520ef708b5ffb2d';
update app.topic_explainers set
  core_idea = $q$- A logarithmic expression log_b(x)=y and the exponential statement b^y=x express the exact same relationship in two directions.
- Fluently rewriting between the two forms, not memorizing them as separate facts, is what lets a logarithm be evaluated exactly.$q$,
  what_students_need_to_understand = $q$- When a logarithm's base and argument are both powers of the same number, the exact value can always be found by rewriting as an exponential equation and solving.
- No decimal approximation is needed.$q$,
  how_this_becomes_points = $q$1. To evaluate a logarithm without a calculator, show the exponential-form rewrite explicitly.
2. Solve it to an exact value, not a decimal estimate.$q$,
  point_attaining_answer = $q$1. The value 3 is correct, but the expected method is the exact exponential rewrite.
2. log_2(8)=y means 2^y=8, and since 2^3=8 exactly, y=3 exactly.
3. Show this as an exact algebraic step, not calculator estimation, since the whole point of this topic is fluency without a calculator.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='27ee90923d581c261bbdfb24ced1b531';
update app.topic_explainers set
  core_idea = $q$- This topic's required inverse-derivation work is scoped specifically to functions with an initial value of 1, f(x) = b^x.
- The general exponential form used elsewhere in this unit allows any nonzero initial value a.$q$,
  what_students_need_to_understand = $q$- Swapping x and y in x = b^y and solving for y requires the definition of a logarithm directly.
- y = log_b(x) is exactly what 'the exponent that produces x when b is raised to it' means.$q$,
  how_this_becomes_points = $q$1. Show the swap-and-solve steps explicitly for f(x) = b^x.
2. Arrive at the inverse y = log_b(x).
3. No need to generalize to an arbitrary initial value.$q$,
  point_attaining_answer = $q$1. This topic's derivation work is scoped to the initial-value-of-1 case, f(x)=b^x, not the general a*b^x form.
2. For f(x)=3^x, swapping gives x=3^y.
3. Rewriting using the logarithm definition gives y=log_3(x) directly.
4. There is no need to introduce or solve for a general constant a here.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='61ecfa77af75d0b31f4c0d8a6cfc1c56';
update app.topic_explainers set
  core_idea = $q$- The general logarithmic form f(x) = a * log_b(x) uses a as a separate vertical scale factor on top of the basic inverse-of-exponential logarithm.
- Unlike topic 2.10's narrower initial-value-of-1 scope, this general form allows any nonzero a.$q$,
  what_students_need_to_understand = $q$- Changing a stretches, compresses, or (if negative) reflects the logarithmic curve vertically.
- Changing the base b changes how quickly the curve grows or decays.
- These are two independent parameters doing different jobs.$q$,
  how_this_becomes_points = $q$1. Identify a and b correctly from the given information.
2. Describe a's effect on the graph (stretch, compression, or reflection) accurately.$q$,
  point_attaining_answer = $q$- The value -2 is the coefficient a, not the base; the base here is 3, matching log_3(x).
- The coefficient a=-2 means the graph is vertically stretched by a factor of 2 and reflected over the x-axis, since a is negative.
- It never functions as the logarithm's base.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='52749d810bff5870d1738e05816b3bcf';
update app.topic_explainers set
  core_idea = $q$- Rewriting log_b(x/y) as log_b(x) minus log_b(y) is a fully valid, testable rewrite.
- A quotient property is never given as its own separate rule in the required content.
- It is derived directly from the product and power properties applied to x*y^(-1).$q$,
  what_students_need_to_understand = $q$- The power property moves an exponent out front as a multiplying coefficient: log_b(x^n) = n*log_b(x).
- It does not work in reverse to turn an existing coefficient into an exponent unless that step is explicitly justified.$q$,
  how_this_becomes_points = $q$1. Apply each logarithm property correctly and explicitly.
2. If a quotient rewrite is used, show it as following from the product and power properties rather than citing it as its own rule.$q$,
  point_attaining_answer = $q$1. This misapplies the power property, which states log_b(x^n) = n*log_b(x).
2. Reversing it correctly gives 3*log_b(x) = log_b(x^3), with the coefficient becoming an exponent, not a multiplier.
3. log_b(3x) is a completely different expression, equal to log_b(3) + log_b(x) by the product property instead.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='aab38871fb8c4142051488e87e90deb3';
update app.topic_explainers set
  core_idea = $q$- An equation like e^(2x) minus e^x minus 12 equals zero is a quadratic disguised in e^x.
- Substitute u=e^x, solve the quadratic, and explicitly reject any negative solution for u (since e^x can never be negative).
- Skipping that rejection is the documented lowest-scoring point pattern on the entire exam.$q$,
  what_students_need_to_understand = $q$- e^(2x) equals (e^x)^2, so the equation becomes an ordinary quadratic in the substitute variable u=e^x.
- Once solved, any solution requiring e^x to equal a negative number or zero must be rejected before finishing, since e^x is always strictly positive.$q$,
  how_this_becomes_points = $q$1. Show the substitution u=e^x explicitly.
2. Solve the resulting quadratic (by factoring or the quadratic formula).
3. Explicitly reject the negative or zero root for u.
4. Then solve for the final x-value.$q$,
  point_attaining_answer = $q$1. The factoring is correct, but u=-3 must be rejected.
2. u represents e^x, and e^x is always strictly positive, so u=-3 is impossible and ln(-3) is not a real number.
3. The only valid solution is from u=4: e^x=4, so x=ln(4).
4. This explicit rejection step is exactly the lowest-scoring point pattern on the 2025 exam when it's skipped.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f6c0894d9809bf34406fe5438f337608';
update app.topic_explainers set
  core_idea = $q$- A logarithmic model fits data whose rate of increase is slowing over time: fast growth at first that levels off.
- That is the opposite shape from exponential data, whose rate of increase accelerates.
- Mismatching these two shapes selects the wrong model family entirely.$q$,
  what_students_need_to_understand = $q$- Both exponential and logarithmic models can look like they're 'increasing quickly.'
- Only checking whether the increase is speeding up (exponential) or slowing down (logarithmic) actually distinguishes which family the data belongs to.$q$,
  how_this_becomes_points = $q$1. Identify the data's increasing-but-slowing pattern explicitly as the reason a logarithmic model is appropriate.
2. Interpret the model's output in the context's units.$q$,
  point_attaining_answer = $q$1. This data's rate of increase is accelerating (each jump is 10 times the last), which is exactly exponential behavior, not logarithmic.
2. A logarithmic model instead fits data whose rate of increase slows down over time.
3. 'Increasing quickly' alone doesn't distinguish the two families, since both can increase quickly in the short term.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='00624c86ff96ea8ce00d67860d1ea0e0';
update app.topic_explainers set
  core_idea = $q$- The semi-log linearization of y=a*b^x produces log_n(y) = (log_n b)*x + log_n(a), a genuine straight line.
- This only holds under the specific restriction that the log base n is greater than 1, not merely that n is not equal to 1.$q$,
  what_students_need_to_understand = $q$- The slope of the resulting line is log_n(b), directly encoding the original exponential base b.
- The intercept is log_n(a), encoding the original initial value a.
- Reading a semi-log plot's slope and intercept recovers the original exponential model's parameters.$q$,
  how_this_becomes_points = $q$1. Show the linearization steps explicitly.
2. Identify the slope and intercept as log_n(b) and log_n(a) respectively.
3. Confirm the log base used satisfies n > 1.$q$,
  point_attaining_answer = $q$- The required restriction is n > 1, not merely n ≠ 1.
- A base of 1/2 fails this stricter condition and is not a valid choice for this linearization.
- A valid choice would be any n > 1, such as n=10 (a standard log) or n=e (a natural log), giving slope log_n(2) and intercept log_n(5).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=2 and topic_code='2.15' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a2cb1ae839cbda84cd13686880897bc7';
update app.topic_explainers set
  core_idea = $q$- A periodic phenomenon's period (time or angle per repeat) and its frequency (repeats per time or angle) are reciprocals of each other, not the same quantity.
- Confusing which one a given number represents produces a value that is off by inversion, not just imprecise.$q$,
  what_students_need_to_understand = $q$- If a context states a wheel completes one rotation every 4 seconds, that 4 is the period; the frequency is 1/4 rotations per second.
- These describe the same repeating motion but are different numbers measuring it from opposite directions.$q$,
  how_this_becomes_points = $q$1. Identify whether a given number is a period or a frequency based on its units (time-per-cycle versus cycles-per-time).
2. Take the reciprocal explicitly when the question asks for the other one.$q$,
  point_attaining_answer = $q$1. The number 5 given here is the frequency (5 cycles per second), not the period.
2. The period is the reciprocal of frequency, so the period is 1/5 = 0.2 seconds per cycle, not 5 seconds.
3. Using the frequency value directly as if it were the period inverts the actual relationship.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8c846082be83b2275c5bd9db300873d7';
update app.topic_explainers set
  core_idea = $q$- Tangent is defined as sine divided by cosine, so its vertical asymptotes occur exactly where cosine equals zero.
- This is a genuinely different set of features from sine or cosine's own graphs, not a variation on the same shape.$q$,
  what_students_need_to_understand = $q$- Cosine is the x-coordinate and sine is the y-coordinate of the same unit-circle point.
- So tangent (their ratio) is undefined at every angle where that x-coordinate is zero, which happens at π/2 plus any multiple of π.$q$,
  how_this_becomes_points = $q$1. Read cosine and sine correctly as the x- and y-coordinates of the unit-circle point.
2. Identify tangent's undefined points explicitly as the angles where cosine equals zero.$q$,
  point_attaining_answer = $q$1. Sine is never undefined; it's defined for every real angle.
2. Tangent is undefined specifically where cosine equals zero, since tangent = sine/cosine, and division by zero is undefined.
3. This happens at θ = π/2 + kπ for any integer k, a completely different set of angles from anything related to sine's own behavior.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='807d363627be17cd30e28813345ce2e4';
update app.topic_explainers set
  core_idea = $q$- Evaluating sine or cosine at a non-standard angle requires two separate steps: the reference angle gives the correct magnitude, and the quadrant gives the correct sign.
- Getting the magnitude right while assigning the wrong sign produces a genuinely different, wrong number.$q$,
  what_students_need_to_understand = $q$- The reference angle is always the acute angle formed with the x-axis, and it only ever gives a magnitude.
- The sign (positive or negative) is a completely separate determination based entirely on which quadrant the original angle lies in.$q$,
  how_this_becomes_points = $q$1. Identify the reference angle explicitly for the magnitude.
2. Apply the quadrant's sign rule as a separate, explicit step, not merged into one guess.$q$,
  point_attaining_answer = $q$1. The reference angle and magnitude are correct, but the sign is missing.
2. 2π/3 is in Quadrant II, where cosine is negative, so cos(2π/3) = -1/2, not 1/2.
3. Finding the correct reference angle only gives the magnitude, and the quadrant's sign rule must be applied as its own separate step.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8b20c8af8151754f8127812605b9c358';
update app.topic_explainers set
  core_idea = $q$- Amplitude is the distance from a sinusoidal graph's midline to its maximum or minimum.
- It is a completely separate measurement from the vertical shift, which instead describes how far the midline itself sits from the x-axis.$q$,
  what_students_need_to_understand = $q$- A graph can have a large vertical shift and a small amplitude, or the reverse.
- These two numbers vary independently: one measures the curve's swing size and the other measures where the center of that swing is located.$q$,
  how_this_becomes_points = $q$1. Identify the midline first.
2. Measure amplitude explicitly as the distance from midline to maximum.
3. Report vertical shift as a separate value describing the midline's position.$q$,
  point_attaining_answer = $q$1. 5 is the vertical shift (the midline sits at y=5), not the amplitude.
2. The amplitude is the coefficient in front of sine, 3, which measures the distance from the midline (y=5) up to the maximum (y=8) or down to the minimum (y=2).
3. These are two separate numbers describing two separate graph features.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='686b65dc3272427cdfbe2aa36ebc3cc3';
update app.topic_explainers set
  core_idea = $q$- A sine model naturally starts at the midline moving upward, and a cosine model naturally starts at the maximum.
- Check the data's actual starting value and direction against these two defining behaviors.
- That picks the model that needs no extra phase shift to justify.$q$,
  what_students_need_to_understand = $q$- Either sine or cosine can technically model any given periodic data with the right phase shift added.
- Starting from the function whose own natural starting behavior already matches the data avoids introducing an unnecessary phase-shift parameter.$q$,
  how_this_becomes_points = $q$1. Check the data's starting value and direction explicitly against sine's (midline, increasing) and cosine's (maximum) defining behavior.
2. Then select the model.$q$,
  point_attaining_answer = $q$1. Sine fits this data directly without needing any phase shift.
2. The data starts at the midline and is increasing, which is exactly sine's own defining starting behavior.
3. Choosing cosine here would require adding a phase shift to match the same starting condition that sine already satisfies on its own, which is an unnecessary complication.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='784a21e88980a785930317c598540809';
update app.topic_explainers set
  core_idea = $q$- In the form a*sin(b(θ+c))+d, the period is 2π divided by the absolute value of b, not b itself.
- Reporting b directly as the period confuses the parameter that controls the period with the period's actual computed value.$q$,
  what_students_need_to_understand = $q$- A larger value of b compresses the graph horizontally, producing a shorter period, which is exactly what dividing 2π by a larger number produces.
- b and the period are inversely related through this specific formula, not equal to each other.$q$,
  how_this_becomes_points = $q$1. Compute the period explicitly as 2π divided by the absolute value of b, as its own step.
2. Do not report b directly as if it were the period.$q$,
  point_attaining_answer = $q$1. b is not the period; the period is 2π divided by the absolute value of b.
2. Here b=4, so the period is 2π/4 = π/2, not 4.
3. A larger b value compresses the graph, producing a shorter period, which is why the period formula divides by b rather than reporting it directly.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8fbac2c22082fef7df6b29f0a2b7086d';
update app.topic_explainers set
  core_idea = $q$- Converting a stated frequency into the sinusoidal parameter b requires the formula b equals 2π times the frequency.
- This is a real, documented, unusually low-scoring conversion step on an actual administered exam, not a step that can be skipped or guessed.$q$,
  what_students_need_to_understand = $q$- Frequency (cycles per unit time) and the parameter b (which controls period as 2π/b) are related but not identical.
- Multiplying frequency by 2π is the specific, required conversion step connecting the two.$q$,
  how_this_becomes_points = $q$1. Multiply the stated frequency by 2π explicitly to obtain b, as its own step.
2. Do not use the frequency value directly as b in the model.$q$,
  point_attaining_answer = $q$1. b is not the frequency itself; the required conversion is b = 2π times the frequency.
2. So b = 2π(200) = 400π, not 200.
3. This specific conversion step was documented as one of the lowest-scoring points on a real administered exam, so it must be shown explicitly rather than assumed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b04ac007ae46860025288a9870013c15';
update app.topic_explainers set
  core_idea = $q$- Tangent's base period is π, not 2π like sine and cosine.
- So its transformed period formula is π divided by the absolute value of b.
- Borrowing sine and cosine's 2π-based formula for tangent produces a period exactly twice the correct value.$q$,
  what_students_need_to_understand = $q$- Tangent repeats every π radians because tan(θ+π) = tan(θ).
- Sine and cosine don't share this fact; they need a full 2π to repeat.
- So tangent's period formula must use π as the base, not 2π.$q$,
  how_this_becomes_points = $q$1. Use π explicitly as tangent's base period.
2. Compute the transformed period as π divided by the absolute value of b.
3. Do not use the sine/cosine 2π-based formula.$q$,
  point_attaining_answer = $q$1. The formula used was wrong for tangent: its base period is π, not 2π, so the correct period formula is π divided by the absolute value of b.
2. Here the correct period is π/2, not π.
3. Using the sine/cosine 2π-based formula on tangent doubles the actual period.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1289565f66330ef334a2dbb68977f36a';
update app.topic_explainers set
  core_idea = $q$- Inverse sine, inverse cosine, and inverse tangent are each restricted to their own range: [-π/2,π/2], [0,π], and (-π/2,π/2) respectively.
- Returning any other angle that happens to satisfy the original trig equation is not a valid inverse-function output, even if it looks like a reasonable answer.$q$,
  what_students_need_to_understand = $q$- Sine, cosine, and tangent each repeat the same output value at multiple angles.
- So their inverses can only be genuine functions by restricting to one specific range per output value.
- Every inverse trig evaluation must land inside that function's own defined range.$q$,
  how_this_becomes_points = $q$1. Check the inverse trig value explicitly against its function's specific restricted range.
2. Replace any out-of-range angle with the correct in-range equivalent.$q$,
  point_attaining_answer = $q$1. 3π/4 is outside arcsin's restricted range of [-π/2,π/2].
2. Even though sin(3π/4)=√2/2 is a true statement, arcsin must return the angle within its own range that satisfies this.
3. That angle is π/4, since sin(π/4) also equals √2/2 and π/4 does fall within [-π/2,π/2].$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e0cf376f6dd717544d2bebfc8241f674';
update app.topic_explainers set
  core_idea = $q$- A trigonometric equation typically has more than one solution within a given interval, since the same output value repeats at multiple angles.
- Finding only the first solution reached, even if entirely correct, reports an incomplete answer.$q$,
  what_students_need_to_understand = $q$- Within one full period, a sine or cosine equation like sin(θ)=k (for -1<k<1, k≠0) has exactly two solutions, one in each of two quadrants sharing the same reference angle.
- Finding only one of them misses exactly half the required answer.$q$,
  how_this_becomes_points = $q$1. Find every solution within the stated interval explicitly.
2. Use the reference angle and both applicable quadrants.
3. Add periodicity beyond one period if the interval is wider.
4. Don't stop at the first solution reached.$q$,
  point_attaining_answer = $q$1. π/6 is correct but incomplete.
2. Sine is also positive in Quadrant II, where the reference angle π/6 gives a second solution, π - π/6 = 5π/6.
3. The complete solution set on [0, 2π) is θ = π/6 and θ = 5π/6, since both angles have the same reference angle and share the same positive sine value in their respective quadrants.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='13b95032b31f54c3c0d3492596806826';
update app.topic_explainers set
  core_idea = $q$- Secant, cosecant, and cotangent are defined as reciprocals (1/cosine, 1/sine, 1/tangent).
- This is a completely different operation from the inverse trig functions; computing arccos instead of secant, for instance, answers an entirely different question.$q$,
  what_students_need_to_understand = $q$- A reciprocal function flips the output value (1/x) after evaluating the original function.
- An inverse function reverses which value is the input and which is the output.
- These two operations produce different results for the same starting angle.$q$,
  how_this_becomes_points = $q$1. Compute secant, cosecant, and cotangent explicitly as reciprocals of their base functions' evaluated output.
2. Never use an inverse (arc-) trig function.$q$,
  point_attaining_answer = $q$1. Secant is the reciprocal of cosine, not the inverse cosine function.
2. The correct evaluation is sec(π/3) = 1/cos(π/3) = 1/(1/2) = 2.
3. arccos(π/3) is an entirely different operation, and arccos wouldn't even accept π/3, roughly 1.047, as a valid input, since arccos only accepts inputs between -1 and 1.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2ee9fd49360e74a647cf3094470eb221';
update app.topic_explainers set
  core_idea = $q$- The required identities are the Pythagorean identity and the sum identities for sine and cosine.
- Difference and double-angle identities are fully valid and usable, but must be derived from these, since they are not given as their own separate formulas.$q$,
  what_students_need_to_understand = $q$- cos(α-β) is derived from cos(α+β) by substituting -β for β (using that cosine is even and sine is odd).
- Double-angle identities come from setting β=α in the sum identities.
- Both are legitimate, derivable rewrites, not missing content.$q$,
  how_this_becomes_points = $q$1. When a difference or double-angle form is used, derive it explicitly from the sum identities or Pythagorean identity.
2. Do not assume it as an independently given formula.$q$,
  point_attaining_answer = $q$1. cos(α-β) is fully derivable from the given sum identity cos(α+β)=cos(α)cos(β)-sin(α)sin(β) by substituting -β for β.
2. cos(α+(-β)) = cos(α)cos(-β)-sin(α)sin(-β) = cos(α)cos(β)+sin(α)sin(β), using that cosine is even and sine is odd.
3. Not being given as its own separate formula doesn't mean it's unusable, only that it must be derived when needed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='02798ea493ed8f5b505cfbdbd23a97f6';
update app.topic_explainers set
  core_idea = $q$- Converting (x,y) to polar coordinates requires r=√(x²+y²) always.
- θ=arctan(y/x) works directly only when x>0.
- When x<0, π must be added to that arctan result, since arctan's own range can't distinguish opposite-direction points with the same ratio y/x.$q$,
  what_students_need_to_understand = $q$- The points (3,3) and (-3,-3) have the identical ratio y/x=1, so arctan(1)=π/4 for both.
- Only the first point is actually at angle π/4; the second is diametrically opposite, at π/4+π, which is exactly why the x<0 adjustment is required.$q$,
  how_this_becomes_points = $q$1. Check the sign of x explicitly before finalizing θ.
2. Add π to the arctan result whenever x is negative.$q$,
  point_attaining_answer = $q$1. Since x=-3 is negative, π must be added to the raw arctan result: θ = -π/4 + π = 3π/4, not -π/4.
2. The point (-3,3) lies in the second quadrant (135°), while -π/4 points into the fourth quadrant, exactly the opposite direction.
3. This confirms the required adjustment for negative x.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='529868c7bc1322814a7551b66477a896';
update app.topic_explainers set
  core_idea = $q$- A polar point with negative r plots at the opposite direction from the stated angle, at a distance equal to the absolute value of r.
- Treating a negative r as if it simply meant 'this distance, in this direction' places the point on the wrong side of the origin entirely.$q$,
  what_students_need_to_understand = $q$- The polar point (-2, 0) is not near the point (2,0) at all; it's the same point as (2, π), located in the opposite direction from angle 0.
- A negative radius reverses direction rather than just describing a smaller or negative-looking distance.$q$,
  how_this_becomes_points = $q$1. Plot a negative signed radius in the opposite direction from the stated angle.
2. Use the absolute value of r as the distance.
3. Do not plot at the stated angle with the radius treated as positive.$q$,
  point_attaining_answer = $q$1. The negative sign on r changes the direction, not just the distance.
2. (-2, 0) plots in the direction opposite angle 0, which is angle π (the negative x-axis), 2 units from the origin.
3. Placing it along the positive x-axis treats the negative r as if it were positive, putting the point on the completely wrong side of the origin.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1c645470d19d1d2e64342fb92cbf8882';
update app.topic_explainers set
  core_idea = $q$- A polar function's rate of change in this course is always the average rate of change of signed r with respect to θ over a stated interval, computed as [r(θ2)-r(θ1)]/(θ2-θ1).
- This topic is explicitly scoped to average rate only, never a derivative or instantaneous rate.$q$,
  what_students_need_to_understand = $q$- A rate 'at' a specific angle sounds like it might ask for an instantaneous value.
- This course has no derivative tools, so any such request is answered with the average rate of change over a small stated interval around that angle instead.$q$,
  how_this_becomes_points = $q$1. Compute the average rate of change of r with respect to θ explicitly as a difference quotient over the stated interval.
2. Use no derivative or instantaneous-rate language anywhere in the response.$q$,
  point_attaining_answer = $q$1. Derivative language is not accepted in this course; this topic is explicitly scoped to average rate of change only.
2. Compute [r(π/2)-r(0)]/(π/2-0) = [(3+0)-(3+1)]/(π/2) = -1/(π/2) = -2/π.
3. Use the average-rate-of-change formula directly, never a derivative.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=3 and topic_code='3.15' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='523e12ea0af7e62874409ee23a4a1734';
update app.topic_explainers set
  core_idea = $q$A parametric curve is built from two coordinated outputs, x(t) and y(t), produced from the same parameter value.$q$,
  what_students_need_to_understand = $q$- The parameter orders the motion along the curve.
- The same geometric curve can be traced in different directions or speeds depending on how x and y depend on the parameter.$q$,
  how_this_becomes_points = $q$1. Evaluate both components consistently.
2. Describe direction as the parameter increases.
3. Do not force every curve into y=f(x) form.$q$,
  point_attaining_answer = $q$1. Substitute t=3 into both components: x=4 and y=9.
2. So the point is (4,9).
3. The parameter is not automatically the x-coordinate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='43f1b969fa52031b566e57184a567752';
update app.topic_explainers set
  core_idea = $q$Planar motion is naturally parametric because a moving object has two coordinates that change together over time.$q$,
  what_students_need_to_understand = $q$- Keep time as the organizing variable.
- A model can show where an object is, when it reaches a location, and how its horizontal and vertical positions change together.$q$,
  how_this_becomes_points = $q$1. Use a shared time input.
2. Attach units.
3. Explain what the coordinate pair means in the situation.$q$,
  point_attaining_answer = $q$It gives the drone position 5 seconds after the start, with x(5) meters east and y(5) meters north of the reference point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='94ce18c6e6fea54ffbb5865870c3dcc8';
update app.topic_explainers set
  core_idea = $q$A parametric average rate depends on what is being compared: x versus t, y versus t, or y versus x.$q$,
  what_students_need_to_understand = $q$Read the requested rate carefully.

- Average horizontal velocity uses change in x over change in t.
- Average vertical velocity uses change in y over change in t.
- Average slope along the path uses change in y over change in x.$q$,
  how_this_becomes_points = $q$1. Select the correct numerator and denominator.
2. Keep the interval consistent across both components.$q$,
  point_attaining_answer = $q$Compute (y(4)-y(1))/(x(4)-x(1)), because the question asks for change in y relative to change in x, not change in y per unit time.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ea51655d4b3e902f6e3a98339892fc62';
update app.topic_explainers set
  core_idea = $q$A parametric equation can describe both the shape and the traversal of a circle or line.$q$,
  what_students_need_to_understand = $q$- Separate the graph as a set of points from the way the parameter moves along it.
- For example, cosine and sine components can trace a circle, while linear components can trace a line.$q$,
  how_this_becomes_points = $q$1. Identify the shape.
2. Identify the center or direction vector when present.
3. Identify the parameter interval or orientation.$q$,
  point_attaining_answer = $q$A circle centered at (2,-1) with radius 3, because the cosine and sine components share the same radius around a fixed center.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ade1fb5d599c22c74d30cb7724e87cee';
update app.topic_explainers set
  core_idea = $q$Implicit equations describe relationships between x and y without necessarily making y a single-valued output.$q$,
  what_students_need_to_understand = $q$- A relation can be meaningful even when it is not a function over its whole domain.
- Some implicit relations become functions only after restricting to a branch.$q$,
  how_this_becomes_points = $q$1. Interpret the relation accurately.
2. Recognize when a domain or branch restriction is needed.$q$,
  point_attaining_answer = $q$No. Most x-values inside the circle correspond to two y-values, one above and one below the x-axis, so the whole circle is not one function y=f(x).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1a5010942d193a1badec58a2c871c9c3';
update app.topic_explainers set
  core_idea = $q$Conic equations encode graph features through squared terms, signs, coefficients, and translations.$q$,
  what_students_need_to_understand = $q$- Complete squares or rearrange terms when necessary so the conic type and features are visible.
- The same visual family can look hidden until the equation is organized.$q$,
  how_this_becomes_points = $q$1. Rewrite in standard form.
2. Identify the conic correctly.
3. Extract features rather than giving a label alone.$q$,
  point_attaining_answer = $q$It is an ellipse centered at the origin, because the squared terms have different denominators and are added to equal 1.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d91d19c4cdcc1ccf1dd9818c58d46d0d';
update app.topic_explainers set
  core_idea = $q$A valid parametrization must generate points that satisfy the original implicit equation.$q$,
  what_students_need_to_understand = $q$- Verify parametrizations algebraically.
- For circles, sine and cosine are natural because sin^2(t)+cos^2(t)=1.
- For lines, a starting point plus a direction vector is natural.$q$,
  how_this_becomes_points = $q$1. Check by substitution.
2. Attend to whether the parameter interval traces the full curve or only part of it.$q$,
  point_attaining_answer = $q$1. Substitute: (3cos t)^2+(3sin t)^2=9(cos^2 t+sin^2 t)=9.
2. So every generated point satisfies the circle equation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7d26191056d9883e20615e8cf60ac736';
update app.topic_explainers set
  core_idea = $q$A vector is not just how far; it is how far in what direction.$q$,
  what_students_need_to_understand = $q$- Move between component form, graphical arrows, and contextual meaning.
- Adding vectors means combining corresponding components, not just adding magnitudes unless directions match.$q$,
  how_this_becomes_points = $q$1. Preserve direction.
2. Use components consistently.
3. Attach units when the vector models a context.$q$,
  point_attaining_answer = $q$- The magnitude is sqrt(3^2+(-4)^2)=5.
- Magnitude is length, while the signs belong to the direction of the components.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c7efecb2738911d467b9e7e72c9f8adf';
update app.topic_explainers set
  core_idea = $q$A vector-valued function packages component functions into one vector output.$q$,
  what_students_need_to_understand = $q$- The output may represent position, velocity, or another vector quantity depending on the context.
- The components must stay synchronized by the same input.$q$,
  how_this_becomes_points = $q$1. Evaluate the components.
2. Use vector notation.
3. Interpret contextually.$q$,
  point_attaining_answer = $q$- Evaluate both components: r(3)=<9,6>.
- The output is a vector, not a single scalar.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2f3f7f64ce72ec5444be37c9484492fb';
update app.topic_explainers set
  core_idea = $q$Matrix operations depend on shape as much as on the entries.$q$,
  what_students_need_to_understand = $q$- Read dimensions as rows by columns.
- Use them to decide whether addition, scalar multiplication, or matrix multiplication is valid.
- A correct-looking arithmetic answer is invalid if the operation is not defined.$q$,
  how_this_becomes_points = $q$1. Check dimensions.
2. Do the entry arithmetic correctly.
3. Interpret rows and columns clearly.$q$,
  point_attaining_answer = $q$No. Matrix addition requires the same dimensions, and 2 by 3 is not the same shape as 3 by 2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3219af2aaa4d6e79756e6922af3153e4';
update app.topic_explainers set
  core_idea = $q$Matrix inverses are reversal tools, and determinants tell whether that reversal is possible for square matrices.$q$,
  what_students_need_to_understand = $q$- Determinant zero means information collapses in a way that cannot be undone by an inverse.
- Non-square matrices are outside the ordinary square-matrix inverse rule.$q$,
  how_this_becomes_points = $q$1. Check squareness.
2. Compute the determinant accurately.
3. Interpret determinant zero correctly.$q$,
  point_attaining_answer = $q$No. A square matrix with determinant 0 is not invertible, so inverse-based solving or reversal is not valid.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d9c308a4cd68afc795bb7815d1336002';
update app.topic_explainers set
  core_idea = $q$A linear transformation is understood by what it does to vectors, and a matrix is a compact rule for that action.$q$,
  what_students_need_to_understand = $q$- Connect columns or test vectors to geometric behavior.
- The image of basis vectors often reveals how the whole plane is transformed.$q$,
  how_this_becomes_points = $q$1. Multiply matrix and vector correctly.
2. Describe the resulting geometric effect in a grounded way.$q$,
  point_attaining_answer = $q$- It scales horizontal components by 2 and vertical components by 3.
- Linear transformations represented by matrices do not add a fixed translation vector.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1a9e58f6255707a412901ab4f03a0b32';
update app.topic_explainers set
  core_idea = $q$A matrix function maps vectors to vectors when dimensions are compatible.$q$,
  what_students_need_to_understand = $q$- View the matrix as a rule with a domain of allowable input vectors and a range of possible outputs.
- Composition of matrix functions depends on multiplication order.$q$,
  how_this_becomes_points = $q$1. Check dimension compatibility.
2. Use the correct order.
3. Interpret input and output.$q$,
  point_attaining_answer = $q$- A 3-entry column vector, because the inner dimensions must match in A times v.
- The output will have 2 entries.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='001265e3b6ae1646f4baeb57db5477d7';
update app.topic_explainers set
  core_idea = $q$A matrix model is only useful when its entries and outputs are tied back to the situation being modeled.$q$,
  what_students_need_to_understand = $q$- Decide what each row, column, and vector entry means before doing operations.
- The same numeric matrix can mean different things in different contexts.$q$,
  how_this_becomes_points = $q$1. Set up the model validly.
2. Use compatible dimensions.
3. Calculate correctly.
4. Interpret the result in context.$q$,
  point_attaining_answer = $q$- It should state what 40 and 60 represent in the context, including categories and units or counts.
- Matrix results need interpretation, not just computation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Precalculus units 1-4): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_precalculus' and unit_number=4 and topic_code='4.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='097050b09d683422b4176ada07a9cbf5';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_precalculus' and topic_code in ('1.1','1.2','1.3','1.4','1.5','1.6','1.7','1.8','1.9','1.10','1.11','1.12','1.13','1.14','2.1','2.2','2.3','2.4','2.5','2.6','2.7','2.8','2.9','2.10','2.11','2.12','2.13','2.14','2.15','3.1','3.2','3.3','3.4','3.5','3.6','3.7','3.8','3.9','3.10','3.11','3.12','3.13','3.14','3.15','4.1','4.2','4.3','4.4','4.5','4.6','4.7','4.8','4.9','4.10','4.11','4.12','4.13','4.14') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>58 then raise exception 'expected 58 rows updated'; end if; end $$;
commit;
