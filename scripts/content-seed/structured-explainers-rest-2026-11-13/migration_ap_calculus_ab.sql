-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- Instantaneous rate at x=a is the limit of the average rate (secant slope) over shrinking intervals around a.
- That limit is the difference quotient (f(a+h)-f(a))/h as h->0.
- It turns a table of change into a single point-value derivative.$q$,
  what_students_need_to_understand = $q$- Average rate over [a,b] is a secant-line slope computed from two endpoint values.
- Instantaneous rate at a is the limiting slope those secants approach as the second point moves toward a.
- Confusing which is asked costs the whole answer, not partial credit.$q$,
  how_this_becomes_points = $q$1. The scoring checks whether you used the interval endpoints (average) or set up a limiting/tangent argument (instantaneous).
2. It must match what the question asked.
3. A numerically plausible answer built from the wrong quantity earns no credit.$q$,
  point_attaining_answer = $q$| Quantity | Work | Value |
| Average rate on [1,4] | (f(4)-f(1))/(4-1) = (28-4)/3 | 8 |
| Instantaneous rate at x=1 | f'(x) = 2x+3, so f'(1) | 5 |

These are two different numbers because they answer two different questions.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c729803d5df72cf08a90e2abaf0da283';
update app.topic_explainers set
  core_idea = $q$- A derivative's value at a point is a rate, not a y-value of the original function.
- Once a derivative expression is written, renaming it later without redefining it (e.g. silently calling x_H'(t) just H'(t)) is a documented, scored notation error even when the calculus is correct.$q$,
  what_students_need_to_understand = $q$- f'(a) means the instantaneous rate of change or tangent slope at x=a, computed as the limit of the difference quotient.
- It is a completely different kind of number from f(a).
- Every new derivative symbol you introduce must be defined before you reuse it.$q$,
  how_this_becomes_points = $q$1. Points require both the correct derivative value and consistent, defined notation throughout.
2. Introducing a shortened or renamed derivative symbol without stating what it refers to can cost the point even when the underlying computation is right.$q$,
  point_attaining_answer = $q$1. x_H'(t) = 3t^2 - 2, so x_H'(2) = 3(4) - 2 = 10 feet per unit time.
2. The notation x_H'(t) is defined once and used consistently.
3. The value is reported with units and context.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fe0bda4c1f7a8c482cb067c02d619896';
update app.topic_explainers set
  core_idea = $q$- Estimating a derivative from a table means using the two data points closest to the target input and computing their slope.
- Symmetric intervals (one point on each side) give a better local estimate than using only points on one side.$q$,
  what_students_need_to_understand = $q$- A derivative estimate from data is a secant slope between nearby points, not the true instantaneous rate.
- Select the closest available x-values.
- Report the estimate with the context's units, never as an exact derivative.$q$,
  how_this_becomes_points = $q$1. Choose genuinely nearby data (not the widest or most convenient interval).
2. Compute the slope correctly.
3. Label the result as an estimate with correct units when the table has them.$q$,
  point_attaining_answer = $q$1. Using the closest surrounding values, f'(3) is approximately (f(4) - f(2)) / (4 - 2) = (13 - 5) / 2 = 4.
2. This is an estimate of the local slope, not an exact derivative.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a599c372ffc64d7111154aa0c79faa74';
update app.topic_explainers set
  core_idea = $q$- Differentiability implies continuity, but continuity never implies differentiability.
- A function can be continuous at a point while still failing to have a derivative there because of a corner, cusp, vertical tangent, or a mismatch between left- and right-hand slopes.$q$,
  what_students_need_to_understand = $q$- Checking differentiability at a point requires two separate checks.
- First: is the function continuous there?
- Second: do the left-hand and right-hand derivative limits agree to one finite value?
- Passing only the continuity check is not enough to claim a derivative exists.$q$,
  how_this_becomes_points = $q$1. Show that continuity holds.
2. Show that the one-sided derivative limits are equal.
3. Asserting differentiability from a smooth-looking graph or from continuity alone, without checking the slopes on each side, does not earn the point.$q$,
  point_attaining_answer = $q$1. g is continuous at x = 2.
2. The left-hand derivative is -1 and the right-hand derivative is +1.
3. These one-sided limits disagree, so g is not differentiable at x = 2 despite being continuous there.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='befbabd9379b585b5f17e4364185afec';
update app.topic_explainers set
  core_idea = $q$- The power rule, d/dx x^n = n*x^(n-1), applies directly to negative and fractional exponents once a radical or reciprocal is rewritten as a power of x first.
- Skipping that rewrite step is where most power-rule errors start.$q$,
  what_students_need_to_understand = $q$- Every term must be rewritten in the form (coefficient)*x^n before the power rule is applied.
- That includes turning 1/x^2 into x^(-2) and sqrt(x) into x^(1/2).
- The exponent rule works identically once that rewriting is done.$q$,
  how_this_becomes_points = $q$1. Rewrite every non-polynomial term as a power of x.
2. Apply n*x^(n-1) to each term, preserving every coefficient.
3. A dropped coefficient or an un-rewritten radical both cost the computation point.$q$,
  point_attaining_answer = $q$1. Rewrite as 4x^3 - x^(-2) + x^(1/2).
2. Differentiate term by term: f'(x) = 12x^2 + 2x^(-3) + (1/2)x^(-1/2).
3. This can be rewritten back as 12x^2 + 2/x^3 + 1/(2*sqrt(x)).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c3670e558cb3e2ef245edcfcca8fca0f';
update app.topic_explainers set
  core_idea = $q$- Sum, difference, and constant-multiple rules let you differentiate each term of an expression independently and add the results.
- This only works because the derivative of a constant term is exactly zero, not because constants can be ignored.$q$,
  what_students_need_to_understand = $q$- Every additive term in an expression gets its own derivative, computed separately.
- Any constant multiplier is carried through unchanged.
- Any standalone constant term differentiates to zero.
- These are separate facts, not one shortcut.$q$,
  how_this_becomes_points = $q$1. Differentiate every term correctly and independently.
2. Correctly set a lone constant term's derivative to zero.
3. A sign error introduced while separating terms, or a constant term left un-zeroed, both cost points.$q$,
  point_attaining_answer = $q$Differentiating term by term:

| Term | Derivative |
| d/dx(5x^4) | 20x^3 |
| d/dx(-7x) | -7 |
| d/dx(9) | 0 |

So g'(x) = 20x^3 - 7.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4cbc65bb36f85ad508cf7d689d2c0d43';
update app.topic_explainers set
  core_idea = $q$- The four base derivative facts must be recalled exactly: d/dx sin x = cos x, d/dx cos x = -sin x, d/dx e^x = e^x, and d/dx ln x = 1/x.
- e^x is its own derivative.
- The trig pair swaps sign only for cosine, not sine.$q$,
  what_students_need_to_understand = $q$- These four rules are memorized facts, not derived on the fly.
- e^x differentiates to itself unchanged, and ln x differentiates to 1/x.
- sin x differentiates to cos x, and cos x differentiates to -sin x.
- The negative sign belongs only to cosine's derivative.$q$,
  how_this_becomes_points = $q$1. Recall each base derivative fact correctly, including the sign on cos x's derivative.
2. Do this before combining it with sum, product, or chain-rule structure.
3. A single sign or function-family error in the base fact invalidates everything built on top of it.$q$,
  point_attaining_answer = $q$Applying each base fact:

| Term | Derivative |
| d/dx(3 sin x) | 3 cos x |
| d/dx(-2e^x) | -2e^x |
| d/dx(5 ln x) | 5/x |

So h'(x) = 3 cos x - 2e^x + 5/x.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='78c7320312a448f6901801d2222657df';
update app.topic_explainers set
  core_idea = $q$- The product rule needs both terms shown as an explicit structural step: f'(a) = u(a)v'(a) + v(a)u'(a), written out before any number.
- AP scoring treats the structure and the final value as two separate points.
- Skipping the visible structure costs the point even with a correct number.$q$,
  what_students_need_to_understand = $q$- Differentiating a product means computing u'v + uv', not multiplying u' by v' or differentiating both factors as if they didn't interact.
- The structural line itself, not just the final number, is what a reader checks for credit.$q$,
  how_this_becomes_points = $q$1. Show the explicit u(a)v'(a) + v(a)u'(a) structure (one point).
2. Evaluate it correctly (a separate point).
3. A response with the right final number but no visible structural step loses the structure point even when the arithmetic is flawless.$q$,
  point_attaining_answer = $q$1. With u = x^2, v = e^x: f'(x) = u'(x)v(x) + u(x)v'(x) = 2x*e^x + x^2*e^x.
2. So f'(2) = u(2)v'(2) + v(2)u'(2) = (4)(e^2) + (e^2)(4) = 8e^2 ≈ 59.112.
3. The structural step is shown before the number.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='661012f75be5cceda158ec156fef0cb1';
update app.topic_explainers set
  core_idea = $q$- The quotient rule's order matters: (u'v - uv')/v^2, never uv' - u'v.
- The denominator must be squared, not left as v.
- Both are documented as the most common quotient-rule point losses.$q$,
  what_students_need_to_understand = $q$- The numerator of a quotient derivative is (derivative of top)(bottom) minus (top)(derivative of bottom), always in that order.
- It is divided by the bottom squared.
- Reversing the subtraction order or forgetting to square the denominator both change the answer's sign or value.$q$,
  how_this_becomes_points = $q$1. Preserve the exact subtraction order in the numerator.
2. Square the denominator correctly before any simplification.
3. A numerator with the terms swapped changes the sign of the whole result and loses the point even with correct individual derivatives.$q$,
  point_attaining_answer = $q$1. With u = 3x^2-1, v = x+2, u'=6x, v'=1: f'(x) = (u'v - uv')/v^2.
2. At x=1: u(1)=2, v(1)=3, u'(1)=6, v'(1)=1.
3. So f'(1) = (6*3 - 2*1)/3^2 = (18-2)/9 = 16/9.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3356165990ec78f252270f54d65cd76c';
update app.topic_explainers set
  core_idea = $q$- Beyond sine and cosine, d/dx tan x = sec^2 x, d/dx cot x = -csc^2 x, d/dx sec x = sec x tan x, and d/dx csc x = -csc x cot x.
- The two 'squared' derivatives and the two 'product' derivatives are easy to cross, especially confusing sec x tan x with sec^2 x.$q$,
  what_students_need_to_understand = $q$- Each of these four derivative facts pairs a specific trig function with its own distinct derivative form.
- tan and cot produce squared-function derivatives.
- sec and csc produce two-factor product derivatives.
- Mixing the two families produces a wrong but plausible-looking answer.$q$,
  how_this_becomes_points = $q$1. Recall the exact derivative form for each trig function.
2. Know which functions get a squared derivative and which get a two-factor product derivative.
3. Swapping sec x's derivative for a squared form (or vice versa) invalidates the term even if everything else is correct.$q$,
  point_attaining_answer = $q$1. Use d/dx tan x = sec^2 x and d/dx sec x = sec x tan x separately.
2. h'(x) = 4 sec^2 x - 3 sec x tan x.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=2 and topic_code='2.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='23af68e038001a5849d709b5b4315e07';
update app.topic_explainers set
  core_idea = $q$- The chain rule requires two separate factors: the outer function's derivative evaluated at the inner expression, times the inner expression's own derivative.
- A documented, reader-quoted error is garbling this into a product-rule-shaped pattern, e.g. differentiating e^u as u*e^u instead of the correct e^u*u'.$q$,
  what_students_need_to_understand = $q$- A composite function's derivative is never just the outer rule applied and left alone.
- Every layer of nesting (sin of something, e raised to something, a power of something) contributes its own multiplied derivative factor.
- Skipping or misidentifying the inner function is the single most common chain-rule failure mode.$q$,
  how_this_becomes_points = $q$1. Differentiate the outer function at the inner expression.
2. Multiply by the inner function's derivative as a separate, visible factor.
3. Differentiating only the outer layer, or folding the inner expression into the base instead of multiplying by its derivative, does not earn the point.$q$,
  point_attaining_answer = $q$1. With u = x^2, the outer function is e^u.
2. f'(x) = e^u * u' = e^(x^2) * 2x = 2x*e^(x^2).
3. The inner derivative 2x is carried through as a multiplied factor, not folded into the base.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=3 and topic_code='3.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='56a9f2acc7fde2fb02f904b841c73749';
update app.topic_explainers set
  core_idea = $q$- After implicitly differentiating both sides and collecting every dy/dx term, the coefficient multiplying dy/dx must be wrapped in parentheses before dividing.
- A documented, reader-quoted error is dropping those parentheses (writing x + 3y^2*dy/dx = ... instead of (x + 3y^2)*dy/dx = ...), which changes what the expression actually means.$q$,
  what_students_need_to_understand = $q$- Implicit differentiation applies d/dx to both sides of an equation relating x and y.
- Attach dy/dx to every term that differentiates a y-expression.
- Then isolate dy/dx by factoring it out of every term it appears in.
- That factoring step is where the parenthesization error happens.$q$,
  how_this_becomes_points = $q$1. Differentiate every term correctly, with dy/dx attached wherever a y-expression was differentiated.
2. Factor dy/dx out of the collected terms with the remaining coefficient clearly grouped.
3. An ambiguous or missing parenthesization is treated as changing the expression, not as a stylistic slip.$q$,
  point_attaining_answer = $q$1. Differentiating both sides: 2x + (y + x*dy/dx) + 3y^2*dy/dx = 0.
2. Collecting dy/dx terms: (x + 3y^2)*dy/dx = -(2x + y).
3. So dy/dx = -(2x+y)/(x+3y^2), with the coefficient of dy/dx parenthesized before dividing.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=3 and topic_code='3.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='78cfb8184174d68e886c85ed3adb98f6';
update app.topic_explainers set
  core_idea = $q$- An inverse function's derivative at a point uses the reciprocal of the original function's derivative.
- It is evaluated at the original x-value that corresponds to the inverse's input, not at the inverse's input value itself.
- That is the single most common error on this topic.$q$,
  what_students_need_to_understand = $q$- Finding (f^-1)'(a) means first finding the x-value b such that f(b) = a.
- Then compute 1/f'(b).
- The reciprocal is taken at b, the original input, never at a, the value that was just plugged into the inverse.$q$,
  how_this_becomes_points = $q$1. Identify the original x-value that maps to the given inverse input.
2. Then take the reciprocal derivative.
3. Evaluating f' at the inverse's input value instead of the corresponding original x-value produces a plausible-looking but wrong number and does not earn the point.$q$,
  point_attaining_answer = $q$1. Since f(1) = 3, g(3) = 1.
2. g'(3) = 1/f'(1).
3. f'(x) = 3x^2 + 1, so f'(1) = 4, giving g'(3) = 1/4.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=3 and topic_code='3.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='44dc4ee3441d70af447f1a41cd44e27f';
update app.topic_explainers set
  core_idea = $q$- Each inverse trig function has its own specific derivative denominator form: arcsin uses sqrt(1-u^2), arctan uses 1+u^2, arcsec uses |u|*sqrt(u^2-1).
- Swapping one function's denominator form for another's is a documented, common error when the functions are not clearly distinguished before differentiating.$q$,
  what_students_need_to_understand = $q$- Inverse trig derivatives are memorized templates, each paired with a specific algebraic denominator that must not be interchanged.
- Whenever the argument is not simply x, the chain rule contributes an extra multiplied factor on top of the template.$q$,
  how_this_becomes_points = $q$1. Select the exact denominator form that matches the inverse trig function being differentiated.
2. Multiply by the inner derivative when the argument is not just x.
3. A correct-looking but wrong function's denominator form does not earn the point even if the chain-rule factor is handled correctly.$q$,
  point_attaining_answer = $q$1. Using d/dx arctan(u) = u'/(1+u^2) with u = 3x, u' = 3.
2. f'(x) = 3/(1+(3x)^2) = 3/(1+9x^2).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=3 and topic_code='3.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bd262521244f412e5c8a5e69dde46851';
update app.topic_explainers set
  core_idea = $q$- Many derivative problems combine rules in one structure, e.g. a product of two nonconstant factors where one factor is itself a composite function.
- A common, specific hybrid error: correctly picking the outer rule (product) while forgetting to apply the inner rule (chain) to the nested factor.$q$,
  what_students_need_to_understand = $q$- Before differentiating, name the expression's outer structure (sum, product, quotient, composition, or implicit relation).
- Once a rule like product rule is chosen, each factor still needs its own correct treatment.
- A factor that is itself a composite function still needs the chain rule applied within the product-rule computation.$q$,
  how_this_becomes_points = $q$1. Select the correct outer rule for the expression's overall structure.
2. Apply any further rule required within that structure, such as a chain-rule factor nested inside one term of a product.
3. Correctly starting a product rule but leaving a nested chain-rule factor out costs that inner factor's point.$q$,
  point_attaining_answer = $q$1. f'(x) = 2x*sin(3x) + x^2*3*cos(3x) = 2x*sin(3x) + 3x^2*cos(3x).
2. The product rule is applied to the two factors, and the chain rule to sin(3x)'s inner 3x.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=3 and topic_code='3.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a5448be4e364ab75c206db9ff8d0ddee';
update app.topic_explainers set
  core_idea = $q$- A higher-order derivative is found by repeating the derivative operation on the previous result, one order at a time.
- A common, specific error is losing track of which order was actually requested: reporting f' when f'' was asked for, especially after substituting a value too early.$q$,
  what_students_need_to_understand = $q$- Second and higher derivatives are computed by differentiating the immediately preceding derivative, not by differentiating the original function some fixed number of times all at once.
- Label each intermediate result by its order (f', f'', or the requested notation) before the next step or substituting any value.$q$,
  how_this_becomes_points = $q$1. Compute the correct order of derivative.
2. Label or report the specific order the question asked for.
3. A numerically correct but mislabeled derivative (reporting the first derivative when the second was requested) does not earn the point for the requested quantity.$q$,
  point_attaining_answer = $q$1. f'(x) = 4x^3 - 9x^2 + 2.
2. Then f''(x) = 12x^2 - 18x.
3. Each derivative is labeled by order before substituting any value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=3 and topic_code='3.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dc2f4054b1288191bf65a2892c68528e';
update app.topic_explainers set
  core_idea = $q$- Interpreting a derivative in context means translating a symbol like f'(a) into a sentence.
- The sentence names the changing quantity, the input it is changing with respect to, the specific input value, and the units.
- The number alone earns nothing without that sentence.$q$,
  what_students_need_to_understand = $q$- Graders read the sentence, not just the number.
- 'the derivative is 3' earns no credit on its own.
- 'the temperature is increasing at about 3 degrees per minute when t = 4' does, because it names quantity, rate direction, input value, and units together.$q$,
  how_this_becomes_points = $q$1. The scoring component checks for the four pieces together: quantity, rate, input value, units.
2. A response can compute f'(4) correctly and still lose the point by reporting just the number.$q$,
  point_attaining_answer = $q$1. At t = 6 minutes, the water depth is decreasing at about 0.4 feet per minute.
2. This names the quantity, the input value, the direction, and the units together, not just the bare number.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bf75fb99ee598a2bdc1639dd97795d30';
update app.topic_explainers set
  core_idea = $q$- Speed is the absolute value of velocity, so a negative velocity means motion in the negative direction, not a smaller speed.
- Whether the object is speeding up or slowing down depends on comparing the signs of velocity and acceleration, not either one alone.$q$,
  what_students_need_to_understand = $q$- The object speeds up when velocity and acceleration share the same sign (both positive or both negative).
- It slows down when they have opposite signs.
- Checking only acceleration's sign, or only velocity's sign, gives the wrong answer half the time.$q$,
  how_this_becomes_points = $q$1. A motion question scores separately for computing the correct derivative value and for the sign-comparison reasoning.
2. That sign comparison answers speeding-up-or-slowing-down.
3. A correct v(t) and a(t) with no sign comparison still loses the interpretation point.$q$,
  point_attaining_answer = $q$1. Speeding up, because velocity and acceleration are both negative at t = 3.
2. Matching signs mean the speed is increasing, even though acceleration alone is negative.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='83d2a4a94051b56dc0e5242117b05a61';
update app.topic_explainers set
  core_idea = $q$- Outside of motion, a derivative dy/dx is still a rate.
- The skill is naming which quantity is the input and which is the output for that specific scenario.
- The same symbol dV/dt means something different for a filling tank than for a shrinking ice cube.$q$,
  what_students_need_to_understand = $q$- The independent variable is whatever the problem measures change against (usually time).
- The dependent variable is whichever quantity is described as changing.
- Misreading which is which flips the entire rate's meaning.$q$,
  how_this_becomes_points = $q$1. Identify both variables correctly from the word problem.
2. Report the rate with the problem's own units, not just a bare number pulled from a derivative computation.$q$,
  point_attaining_answer = $q$1. At t = 5 hours, the bacteria population is increasing at about 12 thousand bacteria per hour.
2. This names the changing quantity, the specific time, the direction, and the units together, not the bare derivative value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a693650856a99f83735473e9f5128d8c';
update app.topic_explainers set
  core_idea = $q$- The relationship equation in a related-rates problem is not always a geometric formula like volume or the Pythagorean theorem.
- Recent released exams instead give an implicit curve equation and ask you to differentiate it with respect to time.
- This is exactly like implicit differentiation, but with every variable now also a function of t.$q$,
  what_students_need_to_understand = $q$- Citing the chain-rule identity dy/dt = (dy/dx)(dx/dt) by name is not enough to earn the differentiation point.
- The identity has to be carried through to an actual computed numeric value, not just stated as a formula.$q$,
  how_this_becomes_points = $q$1. The setup point tolerates at most one small error in differentiating the equation with respect to t.
2. The execution point strictly requires every term differentiated correctly (including any product-rule or chain-rule term).
3. Carry the work through to a completed computation, not a cited formula.$q$,
  point_attaining_answer = $q$1. No: the identity has to be carried through to an actual numeric value for dy/dt using the given dx/dt, not merely stated.
2. Differentiating the full equation with respect to t and solving for dy/dt numerically is what earns the point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1831697c1c6511d1255a9a50541102ce';
update app.topic_explainers set
  core_idea = $q$- Carrying a related-rates setup through to a solved value means applying the product rule and chain rule correctly to every term of the equation.
- Substitute the snapshot values only after the derivative equation is fully formed.
- Substituting early loses the equation you need.$q$,
  what_students_need_to_understand = $q$- A product like xy inside the original equation produces two separate d/dt terms after differentiating (one from each factor).
- A term like ln y produces a chain-rule term (1/y)(dy/dt).
- Missing either term is a common way to lose the execution point even with a correct overall setup.$q$,
  how_this_becomes_points = $q$1. Every product-rule and chain-rule term must be present and correctly formed in the differentiated equation.
2. Evaluate with the snapshot values only after differentiation is complete.
3. An equation missing one required term loses the execution point even if the final numeric answer happens to look reasonable.$q$,
  point_attaining_answer = $q$1. Differentiating gives 2x(dy/dt) + 2y(dx/dt) + (1/y)(dy/dt) = 0.
2. Both terms from the product 2xy and the chain-rule term from ln y are present.
3. Substituting x=4, y=1, dx/dt=3 and solving for dy/dt gives the requested rate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a804e08e43d438ea24d392e6a2d49bb8';
update app.topic_explainers set
  core_idea = $q$- The slope value f'(a) and the mechanics of building and evaluating the tangent-line approximation are scored as two separate points.
- A wrong slope does not cost you the mechanics point if you carry that wrong slope through consistently to a final numeric approximation.$q$,
  what_students_need_to_understand = $q$- Even if you compute f'(a) incorrectly, using that wrong value correctly inside L(x) = f(a) + f'(a)(x-a) and evaluating it to a concrete number still earns the mechanics point.
- Only leaving the expression unresolved, with no final numeric value, loses that point.$q$,
  how_this_becomes_points = $q$1. Two separate scoring components exist: one for the correct slope value, one for correctly building and evaluating the linearization using whatever slope value you have.
2. An unresolved expression with a missing closing parenthesis or no boxed final number fails the mechanics point regardless of the slope.$q$,
  point_attaining_answer = $q$- The slope point is not earned.
- The linearization-mechanics point is still earned.
- The reason: the wrong slope was carried through consistently to a fully evaluated final numeric approximation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='655baeaf1fe988756e6315c65b50ea47';
update app.topic_explainers set
  core_idea = $q$- L'Hospital's Rule only applies to the two indeterminate forms 0/0 and infinity/infinity.
- Other indeterminate-looking forms like infinity minus infinity or 0 times infinity are outside this course's scope.
- They require an algebraic rewrite first, not a direct application of the rule.$q$,
  what_students_need_to_understand = $q$- Writing an equals sign between a limit and 0/0 or infinity/infinity is a notation error.
- 0/0 is a label describing the situation, not a value the limit equals.
- Verify the form in words, then apply the rule to the derivatives.
- Never write lim f(x)/g(x) = 0/0 as if it were a computed answer.$q$,
  how_this_becomes_points = $q$1. Identify the indeterminate form as a labeled fact before applying the rule.
2. Differentiate numerator and denominator separately (not with the quotient rule).
3. Skipping the verification step or misapplying quotient rule both cost points even if a final number is reached.$q$,
  point_attaining_answer = $q$1. As x approaches infinity, e^x approaches infinity and x^2 approaches infinity, so this is the infinity/infinity indeterminate form and L'Hospital's Rule applies.
2. Differentiating numerator and denominator separately (not the quotient rule) gives e^x / (2x), which is still infinity/infinity.
3. Applying the rule again gives e^x / 2, which approaches infinity.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=4 and topic_code='4.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='518c6827b3679cce41d9165ed43e8c54';
update app.topic_explainers set
  core_idea = $q$- The Mean Value Theorem's conclusion is only valid once both hypotheses are stated as explicit sentences: continuity on the closed interval [a,b] and differentiability on the open interval (a,b).
- Jumping straight to solving f'(c) equal to the secant slope skips the justification step, even if the numeric c-value is correct.$q$,
  what_students_need_to_understand = $q$- MVT guarantees at least one point c in (a,b) where the instantaneous rate f'(c) equals the average rate of change over [a,b].
- That holds only under its two named hypotheses.
- A function can fail to be differentiable at even one interior point and the guaranteed c may not exist.
- The hypothesis check is graded content, not optional scaffolding.$q$,
  how_this_becomes_points = $q$1. State f is continuous on the closed interval and differentiable on the open interval (polynomials and sums/products of familiar differentiable functions justify this in one sentence).
2. Compute the average rate of change, then solve f'(c) equal to it.
3. Solving for c without the hypotheses earns no justification point.$q$,
  point_attaining_answer = $q$1. f is a polynomial, so it is continuous on [0,3] and differentiable on (0,3), satisfying MVT's hypotheses.
2. f(0)=0, f(3)=18, so the average rate is (18-0)/3=6.
3. Setting f'(c)=3c^2-3=6 gives c^2=3, so c=sqrt(3), which lies in (0,3).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e9baf8d6f64ddf0480687c411a2091ce';
update app.topic_explainers set
  core_idea = $q$- The Extreme Value Theorem guarantees a global max and min exist on a closed interval, but locating them is not the same step as finding critical points.
- A documented near-miss: a critical x-value with no equation-setting step or explicit critical-point language.
- Another common error: comparing only critical-point values, never evaluating the endpoints.$q$,
  what_students_need_to_understand = $q$- Critical points occur only where f'(x)=0 or where f' is undefined.
- On a closed interval, EVT guarantees the global extrema occur either at one of those critical points or at an endpoint.
- A critical point is not automatically a local or global extremum until sign behavior or a value comparison confirms it.$q$,
  how_this_becomes_points = $q$1. Show the equation-setting work that produces each critical x-value (not just stating the value).
2. Build a complete candidate list that includes both interior critical points and both endpoints.
3. Then name the global max and min.$q$,
  point_attaining_answer = $q$f'(x)=3x^2-12x=3x(x-4)=0 gives critical points x=0 and x=4. Evaluating all candidates:

| x | f(x) |
| -1 | -2 |
| 0 | 5 |
| 4 | -27 |
| 5 | -20 |

The absolute maximum is 5 at x=0, and the absolute minimum is -27 at x=4.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='897d8cd035cf9ed0687603cf35f3e904';
update app.topic_explainers set
  core_idea = $q$- Increasing and decreasing intervals are determined by the sign of f' on a sign chart.
- Never determine them by directly comparing two f-values at chosen points.
- Comparing endpoint function values alone can look like it proves monotonic behavior while missing a dip or rise strictly between them.$q$,
  what_students_need_to_understand = $q$- A sign chart for f' partitions the domain at critical points.
- The sign of f' on each resulting sub-interval (not the raw value of f) tells you whether f is increasing or decreasing there.
- Intervals are always reported using x-values, since increasing/decreasing describes behavior over a range of x, not a single y comparison.$q$,
  how_this_becomes_points = $q$1. Test the sign of f' in each interval created by the critical points.
2. Report increasing/decreasing conclusions by x-interval.
3. Comparing f-values at two isolated points instead of building the sign chart does not earn the point, even when the comparison happens to point the right direction.$q$,
  point_attaining_answer = $q$f'(x)=3x^2-6x=3x(x-2)=0 gives critical points x=0 and x=2. Testing f'(-1)=9>0, f'(1)=-3<0, f'(3)=9>0 gives the sign chart:

| Interval | f' sign | f is |
| (-infinity,0) | positive | increasing |
| (0,2) | negative | decreasing |
| (2,infinity) | positive | increasing |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ac117ccc30fb70570484b1b62771e6b7';
update app.topic_explainers set
  core_idea = $q$- The First Derivative Test classifies a critical point only after checking that f' actually changes sign around it.
- f'(c)=0 alone proves the point is critical, not that it is a maximum or minimum.
- Treating f'(c)=0 as sufficient on its own is the single most common error on this topic.$q$,
  what_students_need_to_understand = $q$- A local maximum requires f' to change from positive to negative moving left to right through the critical point.
- A local minimum requires the reverse (negative to positive).
- If f' does not change sign there, the point is neither a local max nor a local min, no matter what f'(c) equals.$q$,
  how_this_becomes_points = $q$1. Test f' on both sides of the critical point.
2. Show the sign change (or lack of one) explicitly before naming the extremum.
3. Stating f'(c)=0 and immediately naming a maximum or minimum without the two-sided sign check does not earn the point.$q$,
  point_attaining_answer = $q$f'(x)=3x^2-6x-9=3(x-3)(x+1)=0 gives critical points x=-1 and x=3. Testing f'(-2)=15>0, f'(0)=-9<0, f'(4)=15>0 shows:

| Critical point | f' changes | Result |
| x=-1 | positive to negative | local max, f(-1)=10 |
| x=3 | negative to positive | local min, f(3)=-22 |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='61417d1d9d1f11b88c8a5e2682dc9b12';
update app.topic_explainers set
  core_idea = $q$- The Candidates Test is a distinct global-extrema tool from the First and Second Derivative Tests, and real AP scoring treats them as non-interchangeable.
- A local sign-change argument alone for an absolute extremum earns no justification point even when the final numeric answer is correct.
- It remains eligible only for the separate answer point.$q$,
  what_students_need_to_understand = $q$- Absolute extrema on a closed interval are found by evaluating the original function (never the derivative) at every critical point in the domain and at both endpoints.
- Then compare that full set of function values.
- A critical point's local behavior, confirmed by a sign change in f', says nothing by itself about how that value compares to the endpoints.$q$,
  how_this_becomes_points = $q$1. Evaluate f at the complete candidate list (every interior critical point plus both endpoints).
2. Compare those values directly.
3. Justifying the global extremum with a local-only argument, such as a First Derivative Test sign change with no endpoint comparison, does not earn the justification point.$q$,
  point_attaining_answer = $q$Candidates are x=-1, 0, 2, 3 (critical points 0 and 2, both endpoints):

| x | g(x) |
| -1 | -7 |
| 0 | 0 |
| 2 | -16 |
| 3 | 9 |

Comparing all four values: the absolute maximum is 9 at x=3, and the absolute minimum is -16 at x=2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8cb8040628422f68c67e16cace4d3290';
update app.topic_explainers set
  core_idea = $q$- Concavity is governed by the sign of f', never the sign of f'.
- A response that reuses the increasing/decreasing sign chart from f' to answer a concavity question has tested the wrong derivative.
- The f' sign describes slope direction, not whether that slope is itself increasing or decreasing.$q$,
  what_students_need_to_understand = $q$- Concave up means the slope f' is increasing, which happens exactly where f'>0.
- Concave down means f' is decreasing, exactly where f'<0.
- Concavity is a statement about the second derivative's sign.
- Confusing it with the first derivative's sign produces a plausible-looking but structurally wrong sign chart.$q$,
  how_this_becomes_points = $q$1. Build the sign chart from f' specifically.
2. Translate that sign into concave up or concave down by interval.
3. A sign chart built from f' instead of f' does not earn the point even if the increasing/decreasing conclusions it produces are individually correct.$q$,
  point_attaining_answer = $q$h'(x)=12x^2-12=12(x-1)(x+1). Testing h'(0)=-12<0 and h'(2)=36>0 gives:

| Interval | h is |
| (-1,1) | concave down |
| (-infinity,-1) and (1,infinity) | concave up |$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4457410498df6b6b2bf45fcef9cabd90';
update app.topic_explainers set
  core_idea = $q$- The Second Derivative Test only applies when f'(c) is nonzero.
- If f'(c)=0, the test is explicitly inconclusive.
- Treating that inconclusive result as if it still classified the point (rather than falling back to the First Derivative Test) is the topic's most common error.$q$,
  what_students_need_to_understand = $q$- When f'(c)=0 and f'(c)>0, c is a local minimum; when f'(c)<0, c is a local maximum.
- But when f'(c)=0, the test gives no information at all.
- The correct response is to abandon it and check the sign change of f' directly instead of forcing a conclusion from an inconclusive result.$q$,
  how_this_becomes_points = $q$1. Check whether f'(c) is actually nonzero before applying the classification rule.
2. Switch to the First Derivative Test when f'(c)=0.
3. Reporting a classification from an inconclusive f'(c)=0 result does not earn the point, regardless of whether the classification is coincidentally correct.$q$,
  point_attaining_answer = $q$1. k'(x)=4x^3=0 gives the critical point x=0.
2. k'(x)=12x^2, so k'(0)=0 and the Second Derivative Test is inconclusive.
3. Falling back to the First Derivative Test: k'(x)=4x^3 is negative for x<0 and positive for x>0, so x=0 is a local minimum by that test instead.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3b9a86a695a54de22bce58fc5493cf3d';
update app.topic_explainers set
  core_idea = $q$- A graph sketch of f is only as good as the derivative evidence behind it.
- Every increasing/decreasing interval, extremum, concavity interval, and inflection point drawn must trace back to an explicit sign chart for f' and f'.
- It must not come from what the curve intuitively looks like it should do.$q$,
  what_students_need_to_understand = $q$- Sketching coordinates three separate pieces of derivative evidence at once: the sign of f' locates increasing/decreasing intervals and extrema.
- The sign of f' locates concavity intervals and inflection points.
- The two sign charts must agree with each other everywhere the sketch is drawn.$q$,
  how_this_becomes_points = $q$1. Annotate the sign charts for f' and f' before drawing.
2. Produce a sketch whose increasing/decreasing behavior, extrema, concavity, and inflection points all match that annotated evidence.
3. A sketch produced from intuition, without a derivative sign chart behind each feature, does not earn the point.$q$,
  point_attaining_answer = $q$1. m'(x)=-3x^2+3=-3(x-1)(x+1).
2. Testing m'(-2)=-9, m'(0)=3, m'(2)=-9 gives sign pattern negative-positive-negative, so m has a local min at x=-1 (m(-1)=-2) and a local max at x=1 (m(1)=2).
3. m'(x)=-6x is positive for x<0 and negative for x>0, giving an inflection point at x=0 (m(0)=0).
4. The sketch is drawn to match exactly these labeled features.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='00da618c33a9ef5b4e7b0cc87e3d759d';
update app.topic_explainers set
  core_idea = $q$- The CED's own guidance for this unit is explicit: refer to f, f', and f' by name, never as "it" or "the function".
- When a graph shown is of f' itself, that graph's own peaks and valleys are not the extrema of f.
- They are the points where f'=0, which locate inflection points of f, not local maxima or minima of f.$q$,
  what_students_need_to_understand = $q$- Extrema of f occur where the graph of f' crosses zero (changes sign).
- Inflection points of f occur where the graph of f' itself has a peak or valley (since that is where f', the slope of f', equals zero).
- Confusing a feature of the f' graph for a feature of the f graph produces a specific, predictable, and named misclassification.$q$,
  how_this_becomes_points = $q$1. Identify which graph is actually given (f, f', or f').
2. Translate its features correctly into statements about f.
3. Reading an extremum of the f' graph itself as an extremum of f, instead of as an inflection point of f, does not earn the point.$q$,
  point_attaining_answer = $q$1. f'(x)=4-x^2 changes sign from negative to positive at x=-2 (local min of f) and from positive to negative at x=2 (local max of f).
2. f'(x)=-2x, so f'(0)=0 with f' changing from positive to negative there, giving an inflection point of f at x=0.
3. The peak of the given f' graph corresponds to an inflection point of f, not an extremum of f.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7730584995d86444e96266aa61904fc4';
update app.topic_explainers set
  core_idea = $q$- An optimization setup is not complete until the quantity to be optimized is written as a function of exactly one variable, with any constraint already substituted in.
- Differentiating a two-variable expression like A=xy before using the constraint to eliminate one variable is the topic's most common structural error.$q$,
  what_students_need_to_understand = $q$- Name every variable.
- Write the objective quantity's formula (which usually starts with two or more variables).
- Use the given constraint to substitute and reduce that formula to a single-variable function before any derivative work begins.
- State the domain that constraint implies.$q$,
  how_this_becomes_points = $q$1. Define variables.
2. Write the objective as a function of one variable using the constraint.
3. State the resulting domain.

Differentiating an expression that still contains two independent variables, before the constraint has been substituted in, does not earn the setup point.$q$,
  point_attaining_answer = $q$1. Let x be the width of each of the two fenced sides perpendicular to the wall and y be the length of the fenced side parallel to the wall.
2. The fencing constraint is 2x+y=40, so y=40-2x.
3. Substituting gives A(x)=x(40-2x)=40x-2x^2, with domain 0<x<20.
4. Only now is the function ready to differentiate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f7f9b107d946d5518ebe955d773d1225';
update app.topic_explainers set
  core_idea = $q$- Finding a critical point of the objective function is not the same as proving it gives the requested maximum or minimum.
- A response that solves f'(x)=0 and stops has found a candidate, not a justified answer.
- AP credit for the conclusion requires the extra justification step plus a final answer stated in context with units.$q$,
  what_students_need_to_understand = $q$- After the objective function and its domain are set up, solving f'(x)=0 gives candidate x-values.
- A full solution still needs to justify that a specific candidate is the maximum or minimum (via the Second Derivative Test, endpoint comparison, or a sign chart).
- Then answer the original applied question in its own terms, not just report a bare x-value.$q$,
  how_this_becomes_points = $q$1. Differentiate and solve for critical points.
2. Justify which candidate gives the requested extremum.
3. Answer the actual applied question with correct units and variables.

Stopping at the critical point without the justification and contextual answer steps does not earn the final answer point.$q$,
  point_attaining_answer = $q$1. A'(x)=40-4x=0 gives x=10.
2. A'(x)=-4<0 confirms a maximum at x=10 (or comparing A(0)=0, A(20)=0, A(10)=200 confirms it directly).
3. With x=10, y=40-2(10)=20, so the maximum possible area is 200 square feet, achieved when the fenced sides are 10 ft and 20 ft.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1caed8539bcb4983bdd4687b93929a8b';
update app.topic_explainers set
  core_idea = $q$- Differentiating an implicit relation requires applying the chain rule to every y-term, attaching a dy/dx factor each time y is differentiated.
- Treating y as if it were a constant (differentiating y^2 to 0 instead of 2y*dy/dx) drops that factor entirely and produces a derivative that is not even structurally close to correct.$q$,
  what_students_need_to_understand = $q$- An implicit relation like x^2+y^2=25 defines y as a function of x without ever solving for y explicitly.
- Differentiating it term by term still requires the chain rule on every y-containing term.
- The relation's slope, extrema, and concavity all depend on dy/dx being computed this way, not by first trying to isolate y.$q$,
  how_this_becomes_points = $q$1. Apply the chain rule correctly to each y-term (producing a dy/dx factor every time).
2. Then solve algebraically for dy/dx.
3. Differentiating a y-term as if y were a constant, or assuming the relation must first be solved explicitly for y, does not earn the differentiation point.$q$,
  point_attaining_answer = $q$1. Differentiating implicitly: 2x + 2y*(dy/dx) = 0, so dy/dx = -x/y.
2. A horizontal tangent requires dy/dx=0 with y defined, so x=0, giving the points (0,5) and (0,-5) on the circle.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus AB units 2-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='56918f9db517d4835c614dd382492e00';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_calculus_ab' and topic_code in ('2.1','2.2','2.3','2.4','2.5','2.6','2.7','2.8','2.9','2.10','3.1','3.2','3.3','3.4','3.5','3.6','4.1','4.2','4.3','4.4','4.5','4.6','4.7','5.1','5.2','5.3','5.4','5.5','5.6','5.7','5.8','5.9','5.10','5.11','5.12') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>35 then raise exception 'expected 35 rows updated'; end if; end $$;
commit;
