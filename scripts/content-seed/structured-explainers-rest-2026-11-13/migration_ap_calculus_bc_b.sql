-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- An accumulation total is only as trustworthy as the rate-times-interval reasoning behind it.
- Stating the final number without identifying the rate function and the interval it was integrated over does not show where that number came from.$q$,
  what_students_need_to_understand = $q$- A rate function describes how fast a quantity is changing at an instant.
- The definite integral of that rate over an interval gives the total accumulated change, a genuinely different quantity from any single instantaneous value.$q$,
  how_this_becomes_points = $q$1. State the rate function explicitly.
2. State the interval of accumulation explicitly.
3. Connect the integral notation to the total-change interpretation, not just a number pulled from a calculator.$q$,
  point_attaining_answer = $q$No -- even if 40 is numerically correct, the response never identifies r(t) as the rate being accumulated or states that the integral is taken over [0,5].

Full credit requires writing the definite integral of r(t) from 0 to 5 and interpreting the result as the total gallons that flowed in during that specific interval.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='28bedca2a71269ce6845d8f9b3675353';
update app.topic_explainers set
  core_idea = $q$- A Riemann sum is only as defensible as its subinterval widths and sample-point choice.
- Reporting a numeric approximation without showing which endpoint (left, right, or midpoint) generated each height, and the width used, does not earn credit even when the arithmetic is right.$q$,
  what_students_need_to_understand = $q$- The CED does not codify universal over/underestimate rules by name; that a right sum overestimates an increasing function, for instance, is standard teaching convention, not required CED text.
- A response still must show its subinterval structure explicitly, since that structure is what's actually being scored.$q$,
  how_this_becomes_points = $q$1. Show each subinterval's width.
2. Show the chosen sample height.
3. Write them as an explicit product before summing, not just a final number.$q$,
  point_attaining_answer = $q$The subinterval breakdown is missing.

- With unequal widths (2, 3, 4), each term needs its own width times the correct right-endpoint height shown explicitly.
- Assuming equal widths or omitting the individual products is exactly the kind of setup error this topic is scored on, not just the final sum.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='32945220b6d26b32f415a234c0d54aed';
update app.topic_explainers set
  core_idea = $q$- Definite integral notation is the limit of a Riemann sum: the integral from a to b of f(x)dx equals the limit, as the maximum subinterval width goes to zero, of the sum of sample heights times widths.
- Reading the symbol as just 'find area' misses what the notation actually asserts.$q$,
  what_students_need_to_understand = $q$- Moving between summation notation, a Riemann sum picture, and definite integral notation is itself a tested skill.
- Misreading which function is being summed, or which variable the bounds refer to, breaks the translation even when the final area value would have been correct.$q$,
  how_this_becomes_points = $q$1. Identify the integrand.
2. Identify the variable of integration.
3. Identify the bounds a and b as matching the Riemann sum's function and interval, not just recognizing that 'integral' means 'area.'$q$,
  point_attaining_answer = $q$- That shortcut is only valid once an antiderivative relationship is established.
- As written, the notation itself claims the limit of Riemann sums of g(x) from x=2 to x=7, the total accumulated change in the rate g over that interval.
- Writing g(7) minus g(2) skips past what the notation is actually defining and substitutes a different (later-justified) evaluation shortcut in its place.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4d0546089a880945e740f395a97048b2';
update app.topic_explainers set
  core_idea = $q$- Stating the final derivative value of an accumulation function without an explicit statement that g'(x) = f(x) (the Fundamental Theorem's own claim) does not earn the FTC-statement point, even if the final numeric answer is fully correct.
- The answer and the FTC statement are two separate, independently scored requirements.$q$,
  what_students_need_to_understand = $q$- A real documented AP error confuses the derivative of an accumulation function with a difference quotient -- writing g'(8) = f(8) - f(6) instead of the correct g'(8) = f(8).
- That error can still earn the answer point if numerically consistent, but never the separate FTC-statement point, because it never actually states the theorem's claim.$q$,
  how_this_becomes_points = $q$1. State the explicit general statement g'(x) = f(x) (adjusted by chain rule if the upper bound is not x) as its own step.
2. Give it separately from, and in addition to, the final numeric answer.$q$,
  point_attaining_answer = $q$- The final value may be numerically fine, but this earns only the answer point, not the FTC-statement point.
- The FTC's actual claim is g'(x) = f(x), so the correct approach states g'(8) = f(8) explicitly as a general rule before substituting.
- Writing f(8) - f(6) confuses the derivative of an accumulation function with a difference quotient and never states the theorem being used.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c62212f15c1dd68ce055a42a6bbba641';
update app.topic_explainers set
  core_idea = $q$- Reading an accumulation function's increasing/decreasing or concavity behavior directly off the area picture answers the question using the wrong object's behavior.
- The integrand should be treated as the accumulation function's own derivative first.$q$,
  what_students_need_to_understand = $q$- The integrand f is literally F' for the accumulation function F(x) = integral from a to x of f(t)dt.
- Every increasing/decreasing and concavity fact about F must be derived through f's sign and f's own increasing/decreasing behavior, exactly like any other first- and second-derivative analysis.$q$,
  how_this_becomes_points = $q$1. Treat the given integrand as the derivative of the accumulation function.
2. Apply standard sign-of-derivative reasoning to reach conclusions about the accumulation function itself.$q$,
  point_attaining_answer = $q$- Incorrect -- F's increasing/decreasing behavior depends on the sign of f, not on whether f itself is increasing or decreasing.
- Since f(x) > 0 on (2,5), F is increasing there.
- That f is decreasing on (2,5) instead tells you something about F's concavity: F is concave down on (2,5), since F''(x) = f'(x) < 0 there.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5a309ac2465ab540b42a4f7c50af77ad';
update app.topic_explainers set
  core_idea = $q$- Combining partial areas from a graph or table using definite integral properties requires explicitly tracking sign and interval direction.
- Adding magnitudes together without checking whether an interval was traversed backward or whether a piece lies below the axis treats every area as automatically positive, which the properties do not guarantee.$q$,
  what_students_need_to_understand = $q$- Interval additivity, sign reversal on reversed bounds, and constant-multiple scaling are algebraic properties of the integral itself, not just bookkeeping conventions.
- Misapplying any one of them produces a genuinely wrong total, not just an imprecise one.$q$,
  how_this_becomes_points = $q$1. Rewrite the requested integral explicitly in terms of the given sub-integrals.
2. Name the specific property invoked (additivity, reversal, or constant multiple).
3. Do not give a combined number with no visible property-based justification.$q$,
  point_attaining_answer = $q$- The subtraction correctly finds the integral from 4 to 6 (which is 8 - 3 = 5), but the question asked for the integral from 4 to 1, not 4 to 6.
- Reversing the bounds requires the sign-reversal property, so the integral from 4 to 1 of f(x)dx equals negative the integral from 1 to 4, which is -3, not 5.
- Two different properties were needed and only additivity was applied.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6be0a338711be6d30c700b4e57b8a93f';
update app.topic_explainers set
  core_idea = $q$- Evaluating a definite integral via the Fundamental Theorem requires subtracting the antiderivative's value at the lower bound from its value at the upper bound in that specific order.
- Reversing the order changes the sign and, when the integral represents signed change, silently converts a real decrease into a reported increase or vice versa.$q$,
  what_students_need_to_understand = $q$- A definite integral can be negative when the integrand represents a rate that is negative over part or all of the interval.
- A negative final answer is not automatically a sign of an arithmetic error -- it may be exactly what a decreasing accumulated quantity should produce.$q$,
  how_this_becomes_points = $q$1. Write an explicit antiderivative F.
2. Evaluate F(b) minus F(a) in that order.
3. Interpret the result in context, including units when the integral represents a real-world change.$q$,
  point_attaining_answer = $q$- The subtraction order is reversed -- the Fundamental Theorem requires F(6) - F(0), not F(0) - F(6).
- Computed correctly, F(6) - F(0) = -6 - 0 = -6, meaning the particle's net displacement is negative 6 (it ended up 6 units to the left of where it started).
- That is a legitimate signed result, not an error to be corrected by flipping the sign after the fact.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0ba6f16902eb5cea10dfda807c8d6fa8';
update app.topic_explainers set
  core_idea = $q$- An indefinite integral names an entire family of antiderivatives, not one specific function.
- Omitting the constant of integration when no bounds are given reports only one member of that family as if it were the unique answer, which is not what the indefinite integral notation actually represents.$q$,
  what_students_need_to_understand = $q$- Finding an antiderivative is the reverse operation of differentiation.
- Check it by differentiating the proposed answer and confirming it reproduces the original integrand exactly, not by pattern-matching to a memorized rule alone.$q$,
  how_this_becomes_points = $q$1. Apply the correct reverse-derivative rule.
2. Include the constant of integration, +C, whenever no bounds are given.$q$,
  point_attaining_answer = $q$- The reverse-derivative rule is applied correctly, but the answer is incomplete.
- An indefinite integral (no bounds given) represents an entire family of antiderivatives that differ only by a constant, since d/dx of any constant is zero.
- The complete answer must be written as 2x^3 + C, not just 2x^3, to represent that whole family rather than a single member of it.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='87b8100674b26a461faf346276819994';
update app.topic_explainers set
  core_idea = $q$- Substitution requires every instance of the original variable to be rewritten in terms of the new variable u, including the differential.
- Leaving a mixed expression with both x and u present part way through is not a valid intermediate step; it is an unfinished substitution that cannot be integrated as written.$q$,
  what_students_need_to_understand = $q$- For a definite integral, the bounds themselves must be converted from x-values to the corresponding u-values at the moment of substitution.
- Integrating in terms of u while still using the original x-bounds evaluates the wrong quantity entirely.$q$,
  how_this_becomes_points = $q$1. Define u and du explicitly.
2. Rewrite the entire integral purely in terms of u with no x remaining.
3. For definite integrals, convert the bounds to u-values before evaluating.$q$,
  point_attaining_answer = $q$- The bounds must be converted along with the variable.
- Since u = x^2+1, the bound x=0 becomes u=1 and the bound x=2 becomes u=5.
- Evaluating the u-integral from 0 to 2 instead of from 1 to 5 computes a completely different, incorrect quantity, even though every other step of the substitution was done correctly.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4663ae9cbe47aa667242fb766ce29e10';
update app.topic_explainers set
  core_idea = $q$- A rational integrand that does not match a basic antiderivative form must first be rewritten before any technique is applied to it.
- Use long division when the numerator's degree is at least the denominator's, or completing the square for an irreducible-quadratic denominator.$q$,
  what_students_need_to_understand = $q$- Long division and completing the square are preparation steps, not integration techniques themselves.
- The actual integration only becomes possible once the rewritten pieces individually match a recognizable antiderivative form, such as a basic power rule term plus an arctangent-form term.$q$,
  how_this_becomes_points = $q$1. Show the algebraic rewrite (long division or completed-square form) as an explicit step.
2. Only then apply antiderivative rules to the resulting simpler pieces.$q$,
  point_attaining_answer = $q$- Substitution is the wrong first move here -- the numerator's degree equals the denominator's degree, so long division applies first: (x^2+1)/(x^2+4) = 1 - 3/(x^2+4).
- This splits into a constant term (integrates to x) and a recognizable arctangent-form term (integrates to (3/2)arctan(x/2)).
- The rewrite must happen before any antiderivative rule is chosen, not as a fallback after substitution fails.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4c310b4d2f31136e51751cc6cee81fc3';
update app.topic_explainers set
  core_idea = $q$- Integration by parts is not complete once the remaining integral term v du is written down.
- That remaining integral still has to be evaluated and combined with the uv term into one final antiderivative.
- A response that stops at the formula's skeleton has not actually integrated anything.$q$,
  what_students_need_to_understand = $q$- This technique is BC-only content (the CED marks it explicitly BC ONLY, the same tagging pattern used for L'Hospital's other-indeterminate-forms exclusion).
- Choosing u to be the factor that simplifies upon differentiation is what makes the remaining integral v du solvable rather than more complicated than the original.$q$,
  how_this_becomes_points = $q$1. Identify u, dv, du, and v explicitly.
2. Write out the formula integral u dv = uv - integral v du.
3. Fully evaluate the remaining integral v du to reach one final closed-form antiderivative.$q$,
  point_attaining_answer = $q$- The formula's skeleton is correct, but the response stops short -- the remaining integral of e^x dx still must be evaluated.
- The correct complete antiderivative is x*e^x - e^x + C, not x*e^x - integral of e^x dx.
- A dangling unevaluated integral term does not count as a finished antiderivative.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='307293f0cb4dfb164d8bfe8e944a303b';
update app.topic_explainers set
  core_idea = $q$- Linear partial fraction decomposition is scoped by the CED to nonrepeating linear factors only.
- A denominator with a repeated linear factor or an irreducible quadratic factor falls outside what this technique covers, even though BC students learn it.$q$,
  what_students_need_to_understand = $q$- Before setting up A/(x-a) + B/(x-b), confirm the denominator factors into distinct, not repeated, linear factors.
- Also confirm the numerator's degree is already less than the denominator's, or long division is needed first.$q$,
  how_this_becomes_points = $q$1. Factor the denominator correctly into distinct linear factors.
2. Set up the decomposition A/(x-a)+B/(x-b) explicitly.
3. Solve for the constants.
4. Integrate each resulting term to a logarithm.$q$,
  point_attaining_answer = $q$- This denominator is out of scope for this technique -- (x+2)^2 is a repeated linear factor, and the CED restricts linear partial fractions to nonrepeating linear factors only.
- A properly scoped example instead has two distinct linear factors, such as 1/((x-1)(x+2)) = A/(x-1) + B/(x+2).
- Clear denominators to get 1 = A(x+2) + B(x-1), then substitute x=1 and x=-2 to find A and B separately.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='79b31926874ed6c9278c67f4f1f486eb';
update app.topic_explainers set
  core_idea = $q$- An improper integral, with an infinite bound or a discontinuous integrand, is only defined as the limit of a proper definite integral as the problematic bound approaches infinity or the point of discontinuity.
- A numeric answer without that limit step skips the actual definition.$q$,
  what_students_need_to_understand = $q$- The limit must actually be evaluated and shown to exist as a finite value before the integral can be called convergent.
- If the limit is infinite or does not exist, the integral diverges, regardless of how the final expression looks.$q$,
  how_this_becomes_points = $q$1. Rewrite the improper integral explicitly as a limit of a proper integral.
2. Evaluate that limit.
3. State the convergence conclusion (a finite value) or divergence conclusion based on the limit's actual result.$q$,
  point_attaining_answer = $q$- The final value of 1 happens to be correct here, but the setup skipped the required limit step.
- The correct approach writes this as lim(b->infinity) of the integral from 1 to b of 1/x^2 dx, and evaluates the antiderivative to get lim(b->infinity) (-1/b + 1) = 0 + 1 = 1.
- The limit must be shown explicitly, since for other integrands the same substitute-infinity-directly shortcut can produce an incorrect or undefined result instead of quietly working out.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8db1f7143dc25c103cec6b15aa5f5501';
update app.topic_explainers set
  core_idea = $q$- Forcing a memorized technique, such as substitution, onto an integrand whose actual structure calls for a different method wastes setup work and often cannot be completed at all.
- The integrand's structure has to be classified first, before any specific rule is chosen.$q$,
  what_students_need_to_understand = $q$1. Does the integrand match a basic reverse-derivative rule directly?
2. Does it have a composite structure suited to substitution?
3. Is it a rational expression needing an algebraic rewrite first?
4. Is it a product suited to integration by parts?$q$,
  how_this_becomes_points = $q$1. Show an explicit classification step, naming which structural category the integrand fits.
2. Show it before the chosen technique is applied, not a technique applied first and abandoned if it fails.$q$,
  point_attaining_answer = $q$- The integrand x*cos(x) is a product of two unrelated factors, not a composite function.
- That structure calls for integration by parts, not substitution, from the start.
- Classifying the structure correctly first (a product of a polynomial and a trig function, suited to by-parts with u=x) avoids the wasted, unresolvable substitution attempt entirely.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=6 and topic_code='6.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2b95dc5a7aff2a8e39202ee775534094';
update app.topic_explainers set
  core_idea = $q$- A differential equation models a rate relationship, so the equation itself must be written in terms of dy/dx (or dy/dt) equal to an expression.
- Writing a formula for y directly, without ever expressing the rate, skips past what a differential equation model actually is.$q$,
  what_students_need_to_understand = $q$- The modeling step asks only for the rate relationship as an equation, not yet its solution.
- Solving that equation is a separate, later step handled by other topics in this unit.$q$,
  how_this_becomes_points = $q$- Write the differential equation explicitly as dy/dx (or dy/dt) equals an expression in the relevant variables.
- Do not give a solved formula for y.$q$,
  point_attaining_answer = $q$- This is the solution to a differential equation, not the model itself.
- The modeling step asks for the rate relationship as an equation: dr/dt = -kr, expressing that the rate of change is proportional to the current radius.
- The exponential formula for r(t) is a later result obtained by solving that differential equation, not the model requested here.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a8b80122f749e136a46d9505ac6919c8';
update app.topic_explainers set
  core_idea = $q$- Verifying a solution to a differential equation with an initial condition requires checking two separate things.
- The derivative of the proposed solution must match the equation's right-hand side, and the proposed solution must actually pass through the given initial point.
- Confirming only one does not verify the whole claim.$q$,
  what_students_need_to_understand = $q$- These are two independent checks.
- The differentiation-and-substitution check confirms the equation is satisfied everywhere.
- The initial-condition check confirms this particular member of the solution family is the one asked about.$q$,
  how_this_becomes_points = $q$1. Differentiate and substitute to verify the equation.
2. Separately substitute the initial x and y values to verify the condition.
3. Show both checks explicitly when both are part of the claim.$q$,
  point_attaining_answer = $q$- The equation check alone is incomplete -- verifying a particular solution also requires confirming the initial condition.
- Substituting x=0 gives y = 3e^0 - 1 = 2, which does match y(0)=2, so this specific check also needs to be shown.
- Verifying only the equation leaves the 'particular' part of the claim (that this is the specific solution satisfying that initial point) unconfirmed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c5f59ae2fef113b33f7a36faf4a863a1';
update app.topic_explainers set
  core_idea = $q$- Each segment in a slope field represents only the local slope, computed from dy/dx at that single point.
- The segment's length or its connection to neighboring segments carries no meaning.
- A slope field is a grid of independent local directions, not a sketch of any one solution curve.$q$,
  what_students_need_to_understand = $q$- Sketching a field correctly means treating every point as its own independent slope calculation.
- A segment drawn too long, or drawn to visually connect with the next one, misrepresents what the field is actually showing.$q$,
  how_this_becomes_points = $q$1. Compute the slope correctly at each specified point.
2. Draw it as a short segment with the correct sign and relative steepness.
3. Do not draw it as part of a continuous curve.$q$,
  point_attaining_answer = $q$Each point's segment must be computed and drawn independently.

| Point | dy/dx | Segment |
| (0,0) | 0 | flat |
| (1,0) | 1 | positive slope |
| (2,0) | 2 | steeper positive slope |

Connecting these into one smooth line misrepresents the field, since each segment only shows the local slope at that exact point, not a piece of an actual solution curve.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bbef90cbb3682af2b1fd6a97b37967eb';
update app.topic_explainers set
  core_idea = $q$- A slope field's segments describe directions a solution curve would follow, not the values of y itself.
- Reading the field as if it were a direct graph of y against x, rather than as instructions for how a solution moves, answers the wrong question about the picture.$q$,
  what_students_need_to_understand = $q$- Qualitative reasoning from a slope field means tracing how a solution curve would move by following the local directions point to point.
- This includes recognizing where segments flatten toward an equilibrium or where the direction reverses.$q$,
  how_this_becomes_points = $q$1. Describe the behavior (increasing, decreasing, leveling off, or changing direction).
2. Tie it explicitly to following the field's local slope directions from the given starting point, not just a description of the picture's general appearance.$q$,
  point_attaining_answer = $q$- The conclusion is directionally right but stated as if reading a graph of y directly, rather than reasoning from the field.
- The correct qualitative statement is that a solution curve starting below y=5 approaches y=5 as its limiting (equilibrium) behavior, since the slope field shows the rate of change itself approaching zero there.
- The field shows directions a solution follows, not a plotted curve of y-values to read off directly.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='93dd35baac83682993b5fd6fe78d80b7';
update app.topic_explainers set
  core_idea = $q$- Euler's Method has no single CED-mandated formula or step-size notation.
- It is defined conceptually as repeated tangent-line approximation.
- What actually earns credit is using the current point's own slope for each step, not any particular symbolic convention.$q$,
  what_students_need_to_understand = $q$- This BC-only technique repeats the same tangent-line-approximation idea used in linearization, just applied step by step.
- At each stage, the slope must come from the point you are currently standing at, not from where you are heading or from an earlier point.$q$,
  how_this_becomes_points = $q$1. Recompute the slope from the current (x,y) point at every single step.
2. Make each step's change in y equal to that current slope times the step size.
3. Skip no steps between the start and the target x-value.$q$,
  point_attaining_answer = $q$- Euler's Method requires the slope recomputed at the current point for every single step, not reused from an earlier point.
- After the first step moves to a new (x,y), the second step's slope must be evaluated at that new point using dy/dx = x + y again.
- A stale slope value from the previous step breaks the method's defining tangent-line-at-the-current-point idea, even though there is no single CED-mandated formula dictating the notation used to write this out.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5f134125bae1615c59e24bd051012aea';
update app.topic_explainers set
  core_idea = $q$- The CED states directly that failing to separate variables, or omitting the constant of integration, severely limits the points a student can earn.
- These are not minor stylistic slips; they are treated as substantive breaks in the required solution method.$q$,
  what_students_need_to_understand = $q$- A documented misconception is assuming every differential equation involving fractions has a logarithmic solution.
- The actual antiderivative depends entirely on the specific separated expression.
- Forcing a logarithmic form onto the wrong structure produces a genuinely incorrect antiderivative.$q$,
  how_this_becomes_points = $q$1. Fully separate the variables (all y-terms with dy, all x-terms with dx) as an explicit step.
2. Integrate both sides using the antiderivative rule that actually matches each side's structure.
3. Include +C.$q$,
  point_attaining_answer = $q$- Not every fraction-form differential equation has a logarithmic solution -- this is a documented misconception.
- y^2 dy integrates by the power rule to y^3/3 + C, not a logarithmic expression, since the separated left side is a simple power of y, not 1/y.
- The antiderivative rule must match the actual separated expression's structure, not a default assumption based on the equation merely containing a fraction.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f2b752edb14adceca9c1c4199c438b37';
update app.topic_explainers set
  core_idea = $q$- A general solution found by separation of variables can be subject to domain restrictions.
- The algebraic solution formula may only be valid on the connected piece of its domain that actually contains the given initial point, not across its entire algebraic domain.$q$,
  what_students_need_to_understand = $q$- Solving for C using the initial condition determines one specific curve from the general family.
- That curve's valid domain must also be checked against the initial point, since some particular solutions are legitimately restricted to less than their full algebraic domain.$q$,
  how_this_becomes_points = $q$1. Solve generally.
2. Substitute the initial condition to determine C.
3. Present the particular solution.
4. Check whether the initial point restricts the solution's valid domain.$q$,
  point_attaining_answer = $q$- The equation x^2 + y^2 = 4 is correct, but presenting it as valid for all real x ignores the domain restriction the initial condition implies.
- Since y(0)=2 is positive, the particular solution must be restricted to y = sqrt(4 - x^2), the upper semicircle, valid only for -2 <= x <= 2, not the full implicit relation or an unrestricted domain.
- The initial condition determines which branch and which domain are actually valid, not just the value of C.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='53462b4ca3aa28e4377975f3a82b0f9d';
update app.topic_explainers set
  core_idea = $q$- The exponential model dy/dt = ky with solution y = y0*e^(kt) may be used or interpreted directly, without re-deriving it from the differential equation each time.
- A response is not required to re-solve the differential equation by separation whenever the exponential form is already the appropriate model.$q$,
  what_students_need_to_understand = $q$- Recognizing the dy/dt = ky structure (rate proportional to the current amount) is what identifies this as an exponential model in the first place.
- The sign of k then determines growth (k>0) versus decay (k<0), which must be interpreted in the context given.$q$,
  how_this_becomes_points = $q$1. Recognize the dy/dt = ky structure explicitly.
2. Apply the exponential solution form with the correct initial value.
3. Interpret the sign of k correctly in context.$q$,
  point_attaining_answer = $q$- Re-derivation is not required here -- the CED explicitly permits the exponential model's solution form to be used or interpreted directly once dy/dt = ky is recognized.
- The correct response applies y = 50*e^(-0.3t) directly, using the negative k to confirm this is decay.
- It does not need to re-solve the differential equation by separation as if starting from nothing.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4fc4dd240f733476ad1a63ca69f7fe2f';
update app.topic_explainers set
  core_idea = $q$- A logistic model's rate of change depends on both the current population size and its distance from the carrying capacity.
- Setting the rate expression equal to zero identifies the two equilibrium values (zero and the carrying capacity).
- Growth is fastest exactly halfway between them, not at either equilibrium.$q$,
  what_students_need_to_understand = $q$- This BC-only model is genuinely different from ordinary exponential growth.
- The rate factor includes a term that shrinks toward zero as the population approaches carrying capacity, so the growth rate itself changes shape rather than staying proportional to population size alone.$q$,
  how_this_becomes_points = $q$1. Find the equilibrium values by setting the logistic rate expression to zero.
2. Identify the carrying capacity as the nonzero equilibrium.
3. Identify the fastest-growth point as half of the carrying capacity, not confused with either equilibrium.$q$,
  point_attaining_answer = $q$- This reverses the actual behavior -- at P = 800 (the carrying capacity), the rate dP/dt equals zero, meaning growth has stopped entirely, not peaked.
- Setting 0.4P(1-P/800) = 0 gives the two equilibria P=0 and P=800.
- The logistic model's fastest growth occurs at exactly half the carrying capacity, P=400, where the product P(1-P/800) is maximized, not at either equilibrium value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=7 and topic_code='7.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='156265f74766b68b6391fa927a72b8ad';
update app.topic_explainers set
  core_idea = $q$- Average value, (1/(b-a)) times the integral of f from a to b, is a genuinely different quantity from average rate of change, (f(b)-f(a))/(b-a).
- Computing the second when the first was requested is a documented, real AP scoring error, not just an unfortunate name collision.$q$,
  what_students_need_to_understand = $q$- Average rate of change only needs the two endpoint values of f.
- Average value needs the entire integral of f across the interval, so a response using only f(a) and f(b) has not actually engaged with what average value asks for.$q$,
  how_this_becomes_points = $q$Full credit requires the average-value formula, with the definite integral explicitly present, not the two-point slope formula between endpoints.$q$,
  point_attaining_answer = $q$- This computes the average rate of change, not the average value -- a real, documented AP scoring error.
- The average depth requires (1/4) times the integral from 0 to 4 of C(t) dt, which needs the accumulated depth across the whole interval, not just the two endpoint depths C(0) and C(4).
- This response would score 0 on an average-value part even with correct arithmetic, because it answers a different, related question.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f1d12465bc447c9f44d44e59c9cfa973';
update app.topic_explainers set
  core_idea = $q$- When position is recovered from velocity by antidifferentiation, the antiderivative's leading constant must be exactly correct.
- A wrong constant carried through otherwise-clean arithmetic disqualifies the final position value outright, unlike some other units' more forgiving wrong-value-but-consistent-process credit.$q$,
  what_students_need_to_understand = $q$- This is a stricter rule than the linearization or related-rates follow-through pattern seen elsewhere.
- A motion problem's antiderivative constant is treated as a correctness gate for the final answer, not just one input that can be wrong and still earn downstream credit.$q$,
  how_this_becomes_points = $q$- Compute the antiderivative's leading constant correctly (matching the actual antiderivative rule applied).
- An incorrect constant blocks eligibility for the final position or displacement value even if every other step is executed cleanly.$q$,
  point_attaining_answer = $q$- A wrong leading constant on the antiderivative is not a minor slip here.
- The correct antiderivative of 3t^2 is t^3 + s0, not 2t^3 + s0.
- Because the leading constant is wrong, the final position or displacement value is not eligible for credit, regardless of how cleanly the rest of the arithmetic is carried out afterward.
- This is a stricter rule than the wrong-value-but-consistent-process leniency seen in other topics.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='004a6f79179f841485cec8684cd28dbb';
update app.topic_explainers set
  core_idea = $q$- In a multi-part applied-context question, a later part is explicitly allowed to import a value computed in an earlier part.
- This holds even for a value that turned out to be numerically wrong, and the later part can still earn full credit as long as it is used consistently.$q$,
  what_students_need_to_understand = $q$- This cross-part consistency rule means the accumulated-change setup in this topic does not need to be recomputed from scratch in a later part.
- Using the previously established value or expression consistently is what earns credit, not re-deriving a fresh number.$q$,
  how_this_becomes_points = $q$- Use the earlier value or expression consistently with correct accumulated-change logic, even when that earlier value was itself wrong.
- A later part is not penalized for an error that originated upstream.$q$,
  point_attaining_answer = $q$- Part (c) can still earn full credit -- this is a documented, real AP scoring convention.
- A later part is permitted to import a value from an earlier part, even a wrong one, and receive credit for using it consistently.
- 20 + 12 correctly applies the final-amount-equals-initial-plus-accumulated-change logic to the (wrong) value carried in from part (b), so the error in part (b) does not have to cost points again in part (c).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1c0100cc91915ab02bc68fa602e76397';
update app.topic_explainers set
  core_idea = $q$- Finding the area between two x-functions requires the actual intersection x-values as the integration bounds, found by solving where the functions are equal.
- Guessing bounds from a rough sketch, rather than solving for them, risks integrating over the wrong interval entirely.$q$,
  what_students_need_to_understand = $q$- Which function is on top can change partway through the interval.
- The bounds and the top-minus-bottom order both need to be confirmed by the functions' actual values, not assumed from a quick visual impression.$q$,
  how_this_becomes_points = $q$1. Solve explicitly for the intersection x-values as the bounds.
2. Confirm the top-minus-bottom subtraction order by checking function values (not just a sketch) before integrating.$q$,
  point_attaining_answer = $q$- The bounds must come from where the curves actually intersect, not just the stated interval endpoints.
- Solving x^2 = 2x gives x=0 and x=2, so the enclosed region is only between these two intersection points, not across the full [0,3] interval.
- Using the interval's endpoints instead of the solved intersection points integrates over the wrong region entirely.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a95aac6c0029f7c6b575bbb4aa5b5719';
update app.topic_explainers set
  core_idea = $q$- Area between curves as functions of y requires both curves rewritten with x isolated as a function of y.
- Then integrate the rightmost x-expression minus the leftmost x-expression with respect to y.
- Relabeling an x-based setup instead skips the actual rewrite this setup requires.$q$,
  what_students_need_to_understand = $q$- This topic is chosen specifically when solving for x in terms of y is easier or required (such as when a curve is not a function of x, like a sideways parabola).
- Simply reusing an x-based setup with variable names swapped skips the genuine rewrite needed.$q$,
  how_this_becomes_points = $q$1. Solve each curve explicitly for x as a function of y.
2. Identify the rightmost minus leftmost x-expression by testing a value.
3. Take the integral with respect to y over the correct y-bounds.$q$,
  point_attaining_answer = $q$- This region is naturally described by horizontal slices, since x = y^2 is not a function of x for the full curve.
- Solve each boundary for x in terms of y (x = 4 stays as is, x = y^2 stays as is) and integrate the rightmost expression (x=4) minus the leftmost expression (x=y^2) with respect to y.
- A vertical top-minus-bottom setup would require splitting the parabola into two separate x-function branches unnecessarily.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='18ecac0e846602576f9cee02ae0ddc75';
update app.topic_explainers set
  core_idea = $q$- When two curves cross more than twice, the top-minus-bottom relationship can flip between intersection points.
- The region has to be split at every intersection point, with the subtraction order re-checked on each resulting sub-interval.
- A single subtraction order carried across the whole span will be wrong on at least one piece.$q$,
  what_students_need_to_understand = $q$- Finding all the intersection points is itself part of the setup work being tested here, not just a preliminary step.
- Missing even one intersection point means missing the sub-interval where the top-bottom order changes.$q$,
  how_this_becomes_points = $q$1. Identify every intersection point as a boundary between sub-intervals.
2. Re-verify the top-minus-bottom order (by testing a point) on each individual sub-interval.
3. Then add the separate integrals.$q$,
  point_attaining_answer = $q$- All four intersection points must be used as boundaries, not just one of them.
- The curves cross at x=0, 2, 4, and 6, so there are three sub-intervals, [0,2], [2,4], and [4,6], and the top-bottom order can flip at x=2 as well as at x=4.
- Using a single subtraction order across the whole span [0,4] misses the possible flip at x=2.
- Every solved intersection point must define its own sub-interval, each re-verified independently.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f9439521ac2bebfb522935fea14590b2';
update app.topic_explainers set
  core_idea = $q$- A cross-sectional slice's area formula must use the actual base length taken from the region at that specific x (or y).
- The resulting area expression is what gets integrated.
- The differential itself is not what earns the structural-form point, so its presence or absence in an intermediate expression is not what is being checked at this step.$q$,
  what_students_need_to_understand = $q$- The setup earns its point for producing a genuine area expression: a base length squared for a square cross section or base times height for a rectangle.
- It must be built from the region's actual boundary functions, not from a memorized formula applied without reference to the specific region.$q$,
  how_this_becomes_points = $q$1. Identify the cross-section's base length explicitly from the region's boundary functions at each x.
2. Write the area formula (side squared for a square, base times height for a rectangle) using that base length.
3. Take the integral of that area formula over the correct bounds.$q$,
  point_attaining_answer = $q$- A square cross section's area is the base length squared, not the base length itself.
- The base length here is (4 - x^2), so the area of the square cross section is (4 - x^2)^2.
- This squared expression is what gets integrated over the base's x-bounds, not the unsquared base-length expression, which would compute a length, not an area.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c37633e91bab9badd575cb59b1cace6c';
update app.topic_explainers set
  core_idea = $q$- Triangular and semicircular cross sections require substituting the region's base length into the correct shape-specific area formula.
- A semicircle's radius is half the base, not the base itself.
- Applying the wrong formula produces a structurally wrong integrand even with a correct base length.$q$,
  what_students_need_to_understand = $q$- The shape named in the problem (isosceles right triangle, equilateral triangle, semicircle) determines which area formula applies.
- The base length from the region is only the input to that formula.
- Substituting it into the wrong formula breaks the setup regardless of how correctly the base length itself was found.$q$,
  how_this_becomes_points = $q$1. Identify the shape-specific area formula correctly for the named cross section.
2. Substitute the region's base length correctly into that formula (using half the base as the radius for a semicircle).
3. Take the integral over the correct bounds.$q$,
  point_attaining_answer = $q$- For a semicircle, the radius is half the diameter, not the full base length.
- Since (6-x) is the diameter, the radius is (6-x)/2, so the correct cross-sectional area is (1/2)*pi*((6-x)/2)^2, not pi*(6-x)^2.
- Using the full base length as if it were the radius overstates the area by using the wrong input to the semicircle formula.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='9d2cc5d83f9260e433b8f1a7b0a2a0c3';
update app.topic_explainers set
  core_idea = $q$- Omitting the constant pi from a disc-method volume integral costs exactly the one point tied to the limits-and-constant structure.
- It does not disqualify the setup or integrand points, since those are scored on the radius and integrand structure being correct, independent of whether pi was ever written down.$q$,
  what_students_need_to_understand = $q$- Volume setup is scored in separable pieces.
- Identifying the correct radius (perpendicular to the axis of rotation) is one piece; attaching the constant pi with the correct bounds is a separate piece.
- A missing pi is a specific, isolated deduction rather than a sign the whole volume computation is wrong.$q$,
  how_this_becomes_points = $q$1. Identify the radius as the perpendicular distance from the axis of rotation to the curve.
2. Write the integrand as radius squared.
3. Include the constant pi with the correct bounds as a separate, explicit component of the setup.$q$,
  point_attaining_answer = $q$- The radius and integrand structure here are both correct, and omitting pi costs specifically the constant/limits point, not the whole setup.
- The correct volume is pi times the integral from a to b of (f(x))^2 dx.
- A missing pi is treated as an isolated deduction on the constant-and-bounds component of the score, not as evidence the radius or integrand identification was wrong.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a645dd3a5bfeffbab2a58a8782297a8e';
update app.topic_explainers set
  core_idea = $q$- When a region revolves around a non-coordinate line, the radius must be the distance between the curve and that specific rotation line, not the function value itself.
- Reusing the function value directly silently assumes the axis is y=0 or x=0.$q$,
  what_students_need_to_understand = $q$- The radius-as-distance idea is the same geometric concept used for a coordinate-axis disc method, just generalized.
- Subtract (or add) the shift amount to the function value to get the actual distance to the given rotation line before squaring it.$q$,
  how_this_becomes_points = $q$1. Write the radius explicitly as the distance from the curve to the stated rotation line (function value adjusted by the shift, not the function value alone).
2. Square it inside the integral.$q$,
  point_attaining_answer = $q$- The radius must be the distance to the actual rotation line, y = -3, not just the function value.
- Every point on the curve is now f(x) - (-3) = f(x) + 3 units from the line y=-3, so the correct radius is f(x) + 3, not f(x) alone.
- Using f(x) directly silently assumes the axis of rotation is y=0, which is not the case here.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a51890a9d7d0ee24ab3db16c349c2252';
update app.topic_explainers set
  core_idea = $q$- A washer's R-squared-minus-r-squared form earns its own structural point, separate from having correct radii.
- An accidental r-squared-minus-R-squared reversal is self-correcting and still earns full credit once resolved, by a leading negative sign or by flipped bounds.$q$,
  what_students_need_to_understand = $q$- The subtraction order (outer squared minus inner squared) and the specific radius values being correct are scored as genuinely separate components.
- Getting the radii right but reversing which one is squared-and-subtracted-from-which is a real, distinct error from having the wrong radius values entirely.$q$,
  how_this_becomes_points = $q$1. Include the R-squared-minus-r-squared structural form.
2. Identify the correct outer and inner radius expressions.
3. If the subtraction is accidentally reversed, resolve that reversal explicitly by a sign or by the integration bounds, not left as an unresolved negative volume.$q$,
  point_attaining_answer = $q$- A reversed subtraction like this is self-correcting and can still earn full credit.
- The structural form and the individual radius identifications are both correct here, just written in the reversed order.
- As long as the negative result is resolved, either by placing a leading negative sign in front of the integral or by flipping the integration bounds, the volume still comes out correctly.
- The reversal is treated as a resolvable presentation issue, not a disqualifying structural error.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0bbd9e19186ace203d2504e6027ad8eb';
update app.topic_explainers set
  core_idea = $q$- Revolving a region around a shifted (non-axis) line requires every radius to include that line's constant shift.
- Omitting the shift breaks the washer integrand's recognized R-squared-minus-r-squared pattern entirely, which is a documented, real scoring failure distinct from simply computing a wrong final numeric answer.$q$,
  what_students_need_to_understand = $q$- The shift must be applied to both the outer and inner radii consistently.
- Both distances are being measured from the same shifted rotation line, not from the original coordinate axis the functions were originally defined against.$q$,
  how_this_becomes_points = $q$1. Write both the outer and inner radii as distances to the actual shifted rotation line (each function value adjusted by the same shift).
2. Preserve the recognized R-squared-minus-r-squared washer form.$q$,
  point_attaining_answer = $q$- This is a documented, real scoring failure -- omitting the required shift breaks the washer integrand's recognized form entirely, not just the final value.
- Since the axis is y=-2, both radii must be adjusted by that shift: the correct integrand is (f(x)+2)^2 - (g(x)+2)^2, not f(x)^2 - g(x)^2.
- Every point's actual distance to the line y=-2 includes that +2 shift, and omitting it for even one of the two radii breaks the pattern the setup point is scored on.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a3e7a93bb4d6753cf5bf36dbe6836e27';
update app.topic_explainers set
  core_idea = $q$- Arc length is BC-only content, carrying its own dedicated Enduring Understanding separate from the area-and-volume group the rest of this unit belongs to.
- It is not an AB-eligible topic despite sharing the same unit as area and volume applications.$q$,
  what_students_need_to_understand = $q$- The arc length integral, the integral of the square root of 1 plus the derivative squared, needs the derivative found first and squared inside the square root before integrating over the correct bounds.
- Treating the base function's own value as part of the formula, rather than its derivative, produces a completely different (and wrong) integrand.$q$,
  how_this_becomes_points = $q$1. Find the derivative explicitly.
2. Square it inside the square-root expression sqrt(1 + (dy/dx)^2).
3. Integrate over the correct interval.
4. Recognize the topic as BC-only content.$q$,
  point_attaining_answer = $q$- The arc length formula requires the derivative squared, not the original function squared.
- Since dy/dx = 2x for y = x^2, the correct setup is the integral from 0 to 2 of sqrt(1 + (2x)^2) dx, not sqrt(1 + (x^2)^2) dx.
- Using the function's own value instead of its derivative produces an entirely different, incorrect integrand.
- This topic itself is BC-only, not shared with AB.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=8 and topic_code='8.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='14c80753dd6053c55367d8545b607958';
update app.topic_explainers set
  core_idea = $q$Parametric differentiation converts component rates into slope with respect to x by comparing y-change per parameter to x-change per parameter.$q$,
  what_students_need_to_understand = $q$- Students need to keep the parameter visible until the end.
- A slope at a point on the curve is not just y prime of t; it is how y changes relative to x as t changes.$q$,
  how_this_becomes_points = $q$1. Find the component derivatives.
2. Use the correct quotient order.
3. State the dx/dt nonzero condition.$q$,
  point_attaining_answer = $q$dx/dt=2t and dy/dt=3t^2, so dy/dx=(3t^2)/(2t)=3t/2 for t not equal to 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='02cf2ea5826c0da7aa70bc421dd1055b';
update app.topic_explainers set
  core_idea = $q$Parametric concavity requires one more conversion from parameter-change to x-change after differentiating the slope expression.$q$,
  what_students_need_to_understand = $q$- Students need to avoid the tempting shortcut of treating d/dt(dy/dx) as the final second derivative.
- The formula has the extra division by dx/dt because the derivative requested is with respect to x.$q$,
  how_this_becomes_points = $q$1. Find the slope.
2. Take the parameter derivative of the slope.
3. Divide by dx/dt.
4. Interpret the sign if asked.$q$,
  point_attaining_answer = $q$It is (6t)/2=3t, because the parameter derivative of dy/dx must still be divided by dx/dt.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='635c9248f02377577c6f690486ec01c3';
update app.topic_explainers set
  core_idea = $q$Parametric arc length accumulates tiny pieces of distance along the path, using both horizontal and vertical component rates.$q$,
  what_students_need_to_understand = $q$- Path length is not the same as net displacement.
- Both x and y component rates contribute to how fast the point moves along the curve.$q$,
  how_this_becomes_points = $q$1. Use correct parameter bounds.
2. Find the component derivatives.
3. Form a distance-rate integrand.
4. Set up a definite integral.$q$,
  point_attaining_answer = $q$- Arc length depends on motion in both directions.
- The distance-rate expression must include both dx/dt and dy/dt so vertical change is not ignored.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='34bf5eae902fe550ff6db68d3ae6440c';
update app.topic_explainers set
  core_idea = $q$A vector-valued derivative describes how the whole vector output changes, component by component.$q$,
  what_students_need_to_understand = $q$- Students need to preserve vector structure.
- The derivative may represent velocity when the vector-valued function is position, but the interpretation depends on context.$q$,
  how_this_becomes_points = $q$1. Differentiate each component.
2. Use vector notation.
3. Give a context-specific interpretation.$q$,
  point_attaining_answer = $q$- r prime of t is <2t, cos t>.
- Both components must be differentiated and kept as a vector.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='546c4ce2e99d50f7fb27e21e314a29a4';
update app.topic_explainers set
  core_idea = $q$A vector-valued integral accumulates each component separately into one vector result.$q$,
  what_students_need_to_understand = $q$- Students need to distinguish vector accumulation from scalar distance.
- The definite integral of a velocity vector gives net displacement; the integral of speed gives total distance.$q$,
  how_this_becomes_points = $q$1. Integrate each component.
2. Use the bounds.
3. Give the correct displacement-versus-distance interpretation.$q$,
  point_attaining_answer = $q$- It is displacement, the net change in position vector.
- Total distance would require integrating speed, the magnitude of velocity.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4de8f15328fbd78bc31d76454a72dc28';
update app.topic_explainers set
  core_idea = $q$Motion questions are mostly about matching the requested physical quantity to the correct calculus operation.$q$,
  what_students_need_to_understand = $q$- Students need to read wording closely.
- Position is a vector.
- Velocity is position derivative.
- Acceleration is velocity derivative.
- Displacement is net vector change.
- Total distance accumulates speed.$q$,
  how_this_becomes_points = $q$1. Choose the right operation.
2. Interpret the result with units and direction when appropriate.$q$,
  point_attaining_answer = $q$- Its displacement is the zero vector because final position equals initial position.
- The total distance traveled is the path length, not displacement.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e33c0639a685d68865f9b02c73b1bcd2';
update app.topic_explainers set
  core_idea = $q$Polar calculus tracks a curve through radius and angle, but x- and y-behavior often requires translating through cosine and sine.$q$,
  what_students_need_to_understand = $q$- Students need to follow the CED convention r=f(theta) and use theta as the independent variable.
- Horizontal or vertical distance from an axis usually needs x(theta) or y(theta), not r by itself.$q$,
  how_this_becomes_points = $q$1. Translate correctly from polar to rectangular.
2. Set up the derivative.
3. Interpret the derivative information.$q$,
  point_attaining_answer = $q$- x(theta)=r(theta)cos(theta)=2sin(theta)cos(theta).
- The radius alone is not the x-coordinate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b85927d8e35d448aeb31ec999bc6dcf8';
update app.topic_explainers set
  core_idea = $q$A polar area integral accumulates area swept as theta changes, not vertical rectangles or horizontal slices.$q$,
  what_students_need_to_understand = $q$- Students need to choose bounds from the actual tracing of the curve and include the polar area constant.
- The correct setup can fail if the curve is traced twice or if the constant is missing.$q$,
  how_this_becomes_points = $q$1. Choose correct bounds.
2. Use the polar-area structure.
3. Include the one-half factor.
4. Evaluate.$q$,
  point_attaining_answer = $q$Polar area accumulates sector area, so the setup uses one-half times r(theta)^2 integrated with respect to theta over the region.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a3bb0cfea81f537e062f4b757b2a82b1';
update app.topic_explainers set
  core_idea = $q$Polar area between curves compares squared radii because sector area depends on radius squared.$q$,
  what_students_need_to_understand = $q$- Students need to solve intersections in theta and test intervals.
- If the outside curve changes, the integral must be split just like top-bottom switching in rectangular area.$q$,
  how_this_becomes_points = $q$1. Find the intersection bounds.
2. Set the outer/inner order.
3. Use squared radii.
4. Include the one-half constant.
5. Split when needed.$q$,
  point_attaining_answer = $q$Sector area depends on radius squared, so the polar difference setup uses one-half times (r_outer^2-r_inner^2), with correct theta bounds.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=9 and topic_code='9.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1737e3ad089687c3df09c3d342aa1d9c';
update app.topic_explainers set
  core_idea = $q$A series is about accumulated sums, while a sequence is about individual terms.$q$,
  what_students_need_to_understand = $q$- Students need to separate the limit of terms from the limit of partial sums.
- A term limit that is not zero proves divergence, but a zero term limit does not prove convergence.$q$,
  how_this_becomes_points = $q$1. Use correct partial-sum language.
2. Avoid overclaiming from term behavior.$q$,
  point_attaining_answer = $q$- No. Terms approaching 0 is necessary but not sufficient.
- The partial sums must approach a finite value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f40cd6997577817a2d9334090c766674';
update app.topic_explainers set
  core_idea = $q$Geometric series convergence is completely controlled by the common ratio.$q$,
  what_students_need_to_understand = $q$- Students need to identify the first term and ratio from the actual series form.
- The formula is not a general shortcut for every repeated-looking sum.$q$,
  how_this_becomes_points = $q$1. Identify the ratio.
2. Check the condition.
3. Use the correct formula.$q$,
  point_attaining_answer = $q$a=5 and r=1/2, since each term is multiplied by 1/2 to get the next term.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='24d5cb07e234d0d9bfb9caa727e98824';
update app.topic_explainers set
  core_idea = $q$The nth-term test is one-directional: it detects divergence but never proves convergence.$q$,
  what_students_need_to_understand = $q$- Students need to know what the test can and cannot say.
- A zero term limit simply means another convergence test is needed.$q$,
  how_this_becomes_points = $q$1. Find the correct limit.
2. State the correct limited conclusion.$q$,
  point_attaining_answer = $q$It proves nothing by itself about convergence; another test is needed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='84035d970e3777225c0b47717b81caf9';
update app.topic_explainers set
  core_idea = $q$The integral test transfers convergence behavior between a series and a related improper integral.$q$,
  what_students_need_to_understand = $q$- Students need to verify the hypotheses before trusting the conclusion.
- The integral value is usually less important than whether the integral converges.$q$,
  how_this_becomes_points = $q$1. Check the conditions.
2. Set up the integral.
3. Make the correct convergence link.$q$,
  point_attaining_answer = $q$The integral test requires a positive decreasing function matching the terms; without those conditions, the conclusion is not justified.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3e79041d8807dee64373d5c84cfc3930';
update app.topic_explainers set
  core_idea = $q$Harmonic and p-series are benchmark behaviors, not just names to memorize.$q$,
  what_students_need_to_understand = $q$- Students need to distinguish literal identity from comparison or limit comparison.
- A shifted or scaled harmonic-like series may diverge because it behaves like the harmonic series, not because it is literally the same series.$q$,
  how_this_becomes_points = $q$1. Identify p.
2. Explain the convergence threshold.$q$,
  point_attaining_answer = $q$- No. It is not literally sum 1/n.
- It diverges by comparison or limit comparison to the harmonic series.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d15993feed9c300e5f561374d824f145';
update app.topic_explainers set
  core_idea = $q$Comparison tests are about positive-term size relationships to known series.$q$,
  what_students_need_to_understand = $q$- Students need to match both the benchmark and the inequality direction to the intended conclusion.
- For mixed signs, consider absolute values if testing absolute convergence.$q$,
  how_this_becomes_points = $q$1. Check positive-term conditions.
2. Choose the benchmark.
3. Use a valid direction.$q$,
  point_attaining_answer = $q$- Comparison tests are for positive terms.
- For mixed signs, use absolute values or another appropriate test.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e76043b14ba705362a7c23a99b4d64cd';
update app.topic_explainers set
  core_idea = $q$Alternation alone does not guarantee convergence; the magnitudes must shrink to zero.$q$,
  what_students_need_to_understand = $q$- Students need to verify all conditions, not just notice a factor like (-1)^n.
- Missing the zero-limit or decreasing condition breaks the test.$q$,
  how_this_becomes_points = $q$Points come from the three checks and a conclusion tied to them.$q$,
  point_attaining_answer = $q$- No. The magnitudes approach 1, not 0.
- So the alternating series test conditions are not met.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ff837c17eda47b546caff97d3ffdc3ec';
update app.topic_explainers set
  core_idea = $q$The ratio test is powerful for factorials and exponentials but inconclusive at limit 1.$q$,
  what_students_need_to_understand = $q$- Students need to remember both the interpretation and the boundary of assessed methods.
- If the ratio limit equals 1, the test gives no conclusion.$q$,
  how_this_becomes_points = $q$1. Set up the ratio correctly.
2. Evaluate the limit.
3. Use correct inconclusive language when needed.$q$,
  point_attaining_answer = $q$The ratio test is inconclusive at 1, so another assessed test is needed.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3e1cb8639442927345fcb11cec491ff4';
update app.topic_explainers set
  core_idea = $q$Absolute and conditional convergence are two different strengths of convergence.$q$,
  what_students_need_to_understand = $q$- Students need both parts for conditional convergence.
- Absolute convergence is stronger and implies ordinary convergence; conditional convergence requires a separate argument for the original series.$q$,
  how_this_becomes_points = $q$1. Test the absolute-value series clearly.
2. Give a precise final classification.$q$,
  point_attaining_answer = $q$- The original series must converge.
- The absolute-value series must diverge.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='86d4c4fd83e927e059ac0f357a84c906';
update app.topic_explainers set
  core_idea = $q$For qualifying alternating series, the next unused term controls the maximum possible error.$q$,
  what_students_need_to_understand = $q$- Students need to connect the approximation S_n to term n+1, not to term n.
- The bound is an inequality about error size, not an exact error value.$q$,
  how_this_becomes_points = $q$1. Use the correct omitted term.
2. Use at most language.$q$,
  point_attaining_answer = $q$- The fifth term bounds the error because it is the first omitted term.
- Use its magnitude.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='16d0523ad0c7f70422b42144f0151920';
update app.topic_explainers set
  core_idea = $q$Taylor polynomials are local approximations organized by derivative data at a center.$q$,
  what_students_need_to_understand = $q$- Students need to keep the center in every term.
- A polynomial centered at a is written in powers of x-a, not automatically powers of x.$q$,
  how_this_becomes_points = $q$1. Use the coefficient formula.
2. Keep the center.
3. State the degree.
4. Substitute.$q$,
  point_attaining_answer = $q$Use powers of x-2 because the polynomial is centered at 2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='39e449ce879fb6441b4f93a3dfdc4df4';
update app.topic_explainers set
  core_idea = $q$A Lagrange bound is an upper limit on error, not the exact error.$q$,
  what_students_need_to_understand = $q$- Students need to use the next derivative beyond the Taylor polynomial degree and communicate the result as a maximum possible error.
- The connection point can be lost if the inequality meaning is missing.$q$,
  how_this_becomes_points = $q$1. Use the correct form.
2. Give the at most conclusion.$q$,
  point_attaining_answer = $q$- The error is at most 0.01, or <= 0.01.
- The bound is a maximum, not necessarily the exact error.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='415324741cfe0b10a24c93081d13def3';
update app.topic_explainers set
  core_idea = $q$- Radius and interval are related but not interchangeable.
- Radius is a distance; interval is a set of x-values after endpoint testing.$q$,
  what_students_need_to_understand = $q$- Students need to keep the interval centered correctly and test endpoints one at a time.
- Arithmetic that shifts the center incorrectly changes the whole answer.$q$,
  how_this_becomes_points = $q$1. Set up the ratio.
2. Take the limit.
3. Write the open interval.
4. Consider the endpoints.
5. State the final interval.$q$,
  point_attaining_answer = $q$The open interval is 1 < x < 7 because the radius extends 3 units from center 4.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fc1c30052e002a3c080d6b3342bef089';
update app.topic_explainers set
  core_idea = $q$Taylor and Maclaurin series extend polynomial approximation into infinite representation.$q$,
  what_students_need_to_understand = $q$- Students need accurate foundational series before manipulating them.
- A small sign or factorial error can change every later term.$q$,
  how_this_becomes_points = $q$1. Use the correct base series.
2. Make a valid transformation into the requested function.$q$,
  point_attaining_answer = $q$- A Maclaurin series is centered at 0.
- Taylor series is the broader term for center a.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fec322aecbd3c1126c820736a3f53bd9';
update app.topic_explainers set
  core_idea = $q$A power-series representation includes both the series formula and where it converges to the function.$q$,
  what_students_need_to_understand = $q$- Students need to track convergence restrictions through substitutions and transformations.
- The algebraic match alone is incomplete without the valid x-values.$q$,
  how_this_becomes_points = $q$1. Choose the parent series.
2. Write the correct transformed terms.
3. State the convergence interval.$q$,
  point_attaining_answer = $q$Use x replaced by -3x, since 1/(1+3x)=1/(1-(-3x)).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 6-10): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=10 and topic_code='10.15' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0863ff49eaa9c488976ca53c0c5ee8c5';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_calculus_bc' and topic_code in ('6.1','6.2','6.3','6.4','6.5','6.6','6.7','6.8','6.9','6.10','6.11','6.12','6.13','6.14','7.1','7.2','7.3','7.4','7.5','7.6','7.7','7.8','7.9','8.1','8.2','8.3','8.4','8.5','8.6','8.7','8.8','8.9','8.10','8.11','8.12','8.13','9.1','9.2','9.3','9.4','9.5','9.6','9.7','9.8','9.9','10.1','10.2','10.3','10.4','10.5','10.6','10.7','10.8','10.9','10.10','10.11','10.12','10.13','10.14','10.15') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>60 then raise exception 'expected 60 rows updated'; end if; end $$;
commit;
