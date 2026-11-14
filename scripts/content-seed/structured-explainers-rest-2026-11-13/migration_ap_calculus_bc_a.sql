-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$- An instant has zero width, so there is no direct change-over-an-instant to compute.
- The instantaneous rate is defined as the value that average rates over shrinking intervals containing that instant approach.
- It is not a ratio you plug an instant directly into.$q$,
  what_students_need_to_understand = $q$Writing (f(a)-f(a))/(a-a) as a way to compute an instantaneous rate is not valid -- the instant case is defined entirely as a limiting value, never a direct quotient with a zero-width interval.$q$,
  how_this_becomes_points = $q$Full credit for an 'at this instant' question requires framing the answer as a limit of average rates, not attempting to divide by a zero-width interval.$q$,
  point_attaining_answer = $q$It means finding the value that the average rates of volume change, computed over intervals containing t = 5, approach as those intervals shrink toward zero width -- not a direct quotient at a single instant.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b3e506e82e63c9f3f27e87115ed2ac3b';
update app.topic_explainers set
  core_idea = $q$- This course never requires or expects an epsilon-delta proof of a limit.
- Limit notation and approach language are the full expected toolkit.
- Producing or reasoning from an epsilon-delta argument is outside what this exam assesses.$q$,
  what_students_need_to_understand = $q$Limit notation lim(x approaches c) f(x) = L is read as 'as x approaches c, f(x) approaches L' -- a claim about nearby behavior that never means f(c) = L automatically.$q$,
  how_this_becomes_points = $q$Full credit requires reading and writing notation with approach language kept distinct from equality, and never attempting or citing an epsilon-delta argument, since that content is outside what this exam assesses.$q$,
  point_attaining_answer = $q$- No -- the epsilon-delta definition of a limit is not assessed on this exam.
- The expected approach is notation and approach language.
- State that 2x+1 approaches 7 as x approaches 3, not a formal epsilon-delta proof.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='57d69553529e958258c35d9c0de1eb27';
update app.topic_explainers set
  core_idea = $q$- A graph's plotted point at x = c, filled or open, tells you f(c).
- The limit as x approaches c is read from the curve's behavior near c from both sides.
- These two pieces of information can disagree with each other.$q$,
  what_students_need_to_understand = $q$- Tracing from the left and tracing from the right can approach different y-values.
- When they disagree, the two-sided limit does not exist even if the graph has a single well-defined point at x = c.$q$,
  how_this_becomes_points = $q$Full credit requires checking left-hand and right-hand behavior separately and stating whether they agree before concluding a two-sided limit exists.$q$,
  point_attaining_answer = $q$- No, the limit does not exist.
- The left-hand limit (2) and right-hand limit (6) disagree.
- The open circle at (5, 2) is irrelevant to the limit and would only describe f(5) if the function were defined there.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a3a00eb240ef64c85f7e9e083e5688be';
update app.topic_explainers set
  core_idea = $q$- A table only ever gives evidence of a trend approaching some value.
- It cannot prove the limit exactly.
- No finite table shows every x-value arbitrarily close to the target input.$q$,
  what_students_need_to_understand = $q$- The estimate should come from values on both sides of the target input, read as they get closer.
- Do not pick whichever single row looks closest to a nice round number.$q$,
  how_this_becomes_points = $q$1. Cite values approaching from both sides of the input.
2. State the trend those values suggest.
3. Do not just quote the single closest entry.$q$,
  point_attaining_answer = $q$The limit appears to be 6, since values from both below and above x = 2 approach 6 as x gets closer to 2 from either side.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f56814a26846537f82a200d1002020df';
update app.topic_explainers set
  core_idea = $q$- Limit properties for sums, differences, products, quotients, and compositions only combine limits that individually exist.
- Applying the quotient property when the denominator's limit is zero is not a shortcut.
- It is an invalid use of the rule.$q$,
  what_students_need_to_understand = $q$- Before applying a limit property, the individual component limits actually have to exist.
- For the quotient property, the denominator's limit specifically must be nonzero.
- These are conditions on the property, not optional details.$q$,
  how_this_becomes_points = $q$1. Check that component limits exist.
2. Check that a quotient's denominator limit is nonzero.
3. Then cite the corresponding property, not just name a property and compute a value.$q$,
  point_attaining_answer = $q$- This is not a valid use of the quotient property, since that property requires the denominator's limit to be nonzero.
- With g's limit equal to 0, more information about g's behavior near x = 2 is needed before any conclusion can be drawn.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='68e81f1d2242494296c637d515760bc5';
update app.topic_explainers set
  core_idea = $q$- A limit expression that gives 0/0 on direct substitution is not undefined.
- It is a signal the expression needs to be rewritten, by factoring, rationalizing, or simplifying, into an equivalent form.
- Substitution then reveals the real limiting value.$q$,
  what_students_need_to_understand = $q$- Canceling a factor is only valid when that factor is a genuine common factor of both numerator and denominator.
- Canceling terms that merely look similar, without factoring first, produces a wrong result even when the arithmetic looks tidy.$q$,
  how_this_becomes_points = $q$1. Show the rewritten, factored, or rationalized expression as an explicit intermediate step.
2. Do not just stop at 0/0.
3. Do not jump straight to a final numeric answer.$q$,
  point_attaining_answer = $q$1. Factoring gives (x-3)(x+3)/(x-3).
2. This simplifies to x+3 for x not equal to 3.
3. Substituting x = 3 into the simplified form gives a limit of 6.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3a461160f3de2e24d112f2cdc86109e1';
update app.topic_explainers set
  core_idea = $q$- The real skill being tested is recognizing which cue applies: direct substitution, one-sided checking, algebraic rewriting, or another strategy.
- Applying the wrong tool wastes the setup even if later arithmetic is correct.$q$,
  what_students_need_to_understand = $q$- A limit problem's form is itself the evidence for which procedure applies.
- Forms include a nice continuous function, a 0/0 result, a piecewise definition, an absolute value.
- Reading that form correctly comes before any computation.$q$,
  how_this_becomes_points = $q$- Name the correct strategy cue from the problem's form before computing.
- Do not just eventually arrive at a numeric answer through trial and error.$q$,
  point_attaining_answer = $q$- The expression involves an absolute value and direct substitution is blocked at x = 0, so one-sided analysis applies.
- The left-hand limit is -1 and the right-hand limit is 1.
- They disagree, so the two-sided limit does not exist.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a6c5f1f30eb5523758c58bffdda9f6a5';
update app.topic_explainers set
  core_idea = $q$- The squeeze theorem does not just require naming two bounding functions.
- It requires showing that both bounding functions actually approach the same limiting value at the target input.
- The conclusion only follows once that match is demonstrated.$q$,
  what_students_need_to_understand = $q$- Naming 'squeeze theorem' as the topic is not the same as applying it.
- The specific bounding inequality has to be shown explicitly.
- The fact that both outside limits equal each other has to be shown explicitly.$q$,
  how_this_becomes_points = $q$1. Write the bounding inequality.
2. Compute both outside limits and show them equal.
3. Only then state the concluding statement about the middle function's limit.$q$,
  point_attaining_answer = $q$1. -x^2 <= f(x) <= x^2 for all x.
2. The limit of -x^2 and the limit of x^2 as x approaches 0 both equal 0 and match.
3. The squeeze theorem gives that the limit of f(x) as x approaches 0 also equals 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='36dc1387d5b355e689a303de020bf770';
update app.topic_explainers set
  core_idea = $q$- A limit claim stays the same mathematical fact whether shown as notation, a graph, a table, or a verbal description.
- The representation changes, but every one is claiming 'as x approaches c, f(x) approaches L'.$q$,
  what_students_need_to_understand = $q$- Matching a table or graph to the function's value at a point, instead of to its approach behavior near that point, is a category error.
- These representations show approach behavior, not necessarily the function's actual value there.$q$,
  how_this_becomes_points = $q$- Translate every representation into the same underlying approach-behavior claim.
- Keep that claim consistent across all representations given.$q$,
  point_attaining_answer = $q$- Yes, both representations agree that the limit as x approaches 2 of f(x) equals 4.
- The hole in the graph just shows that f(2) itself may be undefined or different from 4.
- That is a separate fact from the limit.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ec1dccc599efcc9f8dfda84c9b57b8ba';
update app.topic_explainers set
  core_idea = $q$- Classifying a discontinuity means checking which specific piece fails: the value, the two one-sided limits agreeing, or the function staying bounded.
- Name the type that matches, rather than describing the graph's general appearance.$q$,
  what_students_need_to_understand = $q$- Removable discontinuity: the limit exists but disagrees with or is missing f(c).
- Jump discontinuity: the one-sided limits disagree.
- Infinite discontinuity: unbounded behavior.
- Each fails a different specific condition, so check left-hand limit, right-hand limit, and f(c) explicitly.$q$,
  how_this_becomes_points = $q$Full credit requires checking left-hand limit, right-hand limit, and f(c) explicitly and naming the discontinuity type tied to which of those failed.$q$,
  point_attaining_answer = $q$- It is a jump discontinuity.
- The left-hand limit (3) and right-hand limit (7) disagree.
- So the two-sided limit does not exist at x = 5.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6431085a0f325853a0cf04ab98146c4c';
update app.topic_explainers set
  core_idea = $q$- Continuity at a point is a three-item checklist: f(c) exists, the limit exists, and the two are equal.
- A graph merely looking unbroken is not evidence that any one of the three actually holds.$q$,
  what_students_need_to_understand = $q$- Each of the three continuity conditions can fail independently.
- Checking only one or two of them, such as just confirming f(c) exists, does not establish continuity.$q$,
  how_this_becomes_points = $q$1. Verify f(c) exists.
2. Verify the limit exists.
3. Verify the limit equals f(c).
4. Only then conclude continuity, not from the graph's appearance.$q$,
  point_attaining_answer = $q$- No -- concluding continuity requires explicit checks, not a visually connected graph.
- Check that the limit as x approaches 4 of f(x) exists.
- Check that it equals f(4) = 7.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6247299e8e401edea5f21657d6cfd7a9';
update app.topic_explainers set
  core_idea = $q$- Continuity over an interval requires continuity at every single point inside it.
- A function can look continuous almost everywhere and still fail at one excluded domain value, hole, or piecewise boundary that is easy to overlook.$q$,
  what_students_need_to_understand = $q$- Hunt for holes, asymptotes, piecewise boundary points, and domain restrictions inside the interval.
- Do not just confirm the function's general formula looks well-behaved.$q$,
  how_this_becomes_points = $q$- Explicitly check special points inside the stated interval: holes, asymptotes, piecewise boundaries, domain exclusions.
- Do not assert continuity from the function's general type.$q$,
  point_attaining_answer = $q$- No -- f(x) = 1/(x-3) is undefined at x = 3, which lies inside [1, 5].
- So the function is not continuous over this entire interval.
- It is continuous everywhere else in that range.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='68a5d23292bcd40504e8de52c3775f10';
update app.topic_explainers set
  core_idea = $q$- Removing a discontinuity means finding the specific value the limit approaches at that point and assigning that exact value to f(c).
- It is not any nearby-looking number.
- Do not skip showing the limit was actually computed.$q$,
  what_students_need_to_understand = $q$- At a removable discontinuity the value is uniquely determined by the limit at that point, not a free choice.
- Compute and show the limit before stating the value.$q$,
  how_this_becomes_points = $q$1. Compute the limit at the discontinuity explicitly.
2. Show that the chosen value for f(c), or an unknown parameter, equals that computed limit.$q$,
  point_attaining_answer = $q$1. Factoring gives (x-2)(x+2)/(x-2), which equals x+2 for x not equal to 2.
2. So the limit as x approaches 2 equals 4.
3. Setting k = 4 removes the discontinuity, since that matches the computed limit.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='234051ae0d144e15f65dd339deda6fe4';
update app.topic_explainers set
  core_idea = $q$- An infinite limit is still a limit statement, not a does-not-exist dead end.
- Writing that a limit equals infinity communicates specific unbounded behavior.
- Connect it explicitly to the vertical asymptote when the question asks about the function's behavior or graph.$q$,
  what_students_need_to_understand = $q$- 'Does not exist' is technically true for an infinite limit, but it throws away the more specific and more useful information that the function grows without bound.
- When a question asks for behavior or an asymptote, infinite-limit notation is the expected answer, not a bare does-not-exist.$q$,
  how_this_becomes_points = $q$- Write the infinite limit notation.
- Name the vertical asymptote.
- Do not just state the limit does not exist.$q$,
  point_attaining_answer = $q$- As x approaches 2 from either side, f(x) grows without bound.
- So the limit as x approaches 2 of f(x) is infinity.
- x = 2 is a vertical asymptote.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d54c54c2fce274861d6da7c6ba611812';
update app.topic_explainers set
  core_idea = $q$- End behavior means what happens as the input grows without bound in either direction.
- That is a completely different question from what happens near input zero.
- Mixing the two up is a documented, common exam error.$q$,
  what_students_need_to_understand = $q$- The phrase 'end behavior' or 'as t becomes large' always signals a limit as the variable approaches positive or negative infinity.
- It never signals a limit as the variable approaches zero.
- These are read from completely different parts of the function's domain.$q$,
  how_this_becomes_points = $q$1. Write the limit with the variable approaching infinity, not zero, when a question asks about end behavior or long-run behavior.
2. Connect a finite result to a named horizontal asymptote.$q$,
  point_attaining_answer = $q$- This is incorrect notation for the question asked.
- Long-run or end behavior means the limit as t approaches infinity, so the correct expression is the limit as t approaches infinity of A(t).
- The limit as t approaches 0 instead asks about behavior near t = 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.15' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e2859dc071a0a5ef99c5f5a7e83b2679';
update app.topic_explainers set
  core_idea = $q$- A correct IVT conclusion is not one sentence.
- Real AP scoring data shows the pattern of stating continuity with a reason, showing the target value between the actual endpoint numbers, then concluding existence, as the single lowest-scoring point on the entire exam.
- Responses skip straight to the conclusion.$q$,
  what_students_need_to_understand = $q$- IVT guarantees a function hits a specific output value somewhere in an interval.
- MVT guarantees a specific instantaneous rate matches an average rate.
- Reaching for MVT when a question asks about hitting a target value is a documented, common mistake.$q$,
  how_this_becomes_points = $q$1. State continuity with its reason.
2. Show the target value numerically between the endpoint values.
3. Only then give the existence conclusion.

Skipping any one of the three costs the point even with a correct final claim.$q$,
  point_attaining_answer = $q$This response cites the wrong theorem -- the Mean Value Theorem is about matching an instantaneous rate to an average rate, not about hitting a target output value.

1. The correct justification is the Intermediate Value Theorem.
2. g is continuous on [0, 6].
3. 0 is strictly between g(0) = -3 and g(6) = 9.
4. So some c in (0, 6) exists with g(c) = 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=1 and topic_code='1.16' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='99ce6504aa43057b051c4b91d657345c';
update app.topic_explainers set
  core_idea = $q$- Average rate of change is a secant line's slope over an interval.
- Instantaneous rate of change is what that secant slope approaches as the interval shrinks to a single point.
- These are genuinely two different computations, not two names for the same thing.$q$,
  what_students_need_to_understand = $q$- The average rate formula (f(b)-f(a))/(b-a) requires two distinct input values.
- The instantaneous rate at one point is a limit.
- Plugging a single point into the average-rate formula produces an undefined 0/0, not an answer.$q$,
  how_this_becomes_points = $q$Full credit requires identifying which type of rate the question actually asks for before choosing a formula, since the average-rate formula and the derivative are structurally different tools.$q$,
  point_attaining_answer = $q$- It's the average rate.
- It is computed as total distance (180 miles) divided by total time (3 hours) over the whole trip.
- An instantaneous rate would require information about a single moment, not the whole interval.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='04fc1b52411afed5e644df3495737915';
update app.topic_explainers set
  core_idea = $q$- f'(a) is a rate -- a slope, a speed, a number of units per unit.
- It is never a y-value of f itself.
- Treating f'(a) as if it were f evaluated at a produces a completely different, usually wrong, quantity.$q$,
  what_students_need_to_understand = $q$- f(a) answers: what is the function's value here.
- f'(a) answers: how fast is the function changing here.
- Confusing them is a category error, not a computational slip.$q$,
  how_this_becomes_points = $q$Full credit requires keeping f(a) and f'(a) as distinct quantities throughout a response, never substituting one for the other.$q$,
  point_attaining_answer = $q$- That's incorrect.
- f(2)=10 is the function's value at x=2, while f'(2)=3 is the rate of change there.
- The question asked for the value, so the answer should be 10, not 3.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='65b8fd58a40f66409310d33899339390';
update app.topic_explainers set
  core_idea = $q$- Estimating a derivative from data means computing a secant slope between the two table or graph points closest to the target input, in both directions if possible.
- Using distant points produces a worse estimate even if the arithmetic is clean.$q$,
  what_students_need_to_understand = $q$- An estimate is not the same as an exact value, and the response should say so.
- The estimate should be built from the nearest available x-values surrounding the target point, not just any two points in the table.$q$,
  how_this_becomes_points = $q$1. Select the closest surrounding data points, not distant ones.
2. Label the result as an estimate.
3. Include units when the context provides them.$q$,
  point_attaining_answer = $q$- Using the closest surrounding values, f(3) and f(7): (38-8)/(7-3) = 7.5.
- This is an estimate for f'(5), built from the nearest available points rather than the widest-spread ones.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8236735d4a0bbde9423e25abe9d66f28';
update app.topic_explainers set
  core_idea = $q$- Differentiability implies continuity, but continuity does not imply differentiability.
- A function can be perfectly continuous, no gaps or jumps, and still fail to have a derivative at a sharp corner, a cusp, or a vertical tangent.$q$,
  what_students_need_to_understand = $q$- At a corner, like the graph of |x| at x=0, the function is continuous but the left-hand and right-hand slopes disagree.
- So no single derivative value exists there.
- Continuity alone never guarantees a derivative exists.$q$,
  how_this_becomes_points = $q$- Recognize that continuity is necessary but not sufficient for differentiability.
- Specifically check for corners, cusps, or vertical tangents before claiming a derivative exists.$q$,
  point_attaining_answer = $q$- No -- f is continuous at x=0, but it has a corner there.
- The left-hand slope is -1 and the right-hand slope is 1, so they disagree.
- So f'(0) does not exist, even though continuity holds.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='93220144d6a9106aeead091f9d372cf8';
update app.topic_explainers set
  core_idea = $q$- The power rule applies cleanly to x^n only after negative and fractional exponents are rewritten in that exact form.
- Differentiating a radical or a reciprocal without first rewriting it as a power is where this topic's arithmetic most often goes wrong.$q$,
  what_students_need_to_understand = $q$- The square root of x is x^(1/2), and 1/x^3 is x^(-3).
- The power rule does not apply to a radical or a fraction as written, only to the rewritten power form.
- So that rewriting step has to happen first.$q$,
  how_this_becomes_points = $q$1. Show the explicit rewriting step, radical or reciprocal to a power.
2. Then apply the power rule.

Skipping the rewriting is where sign and exponent errors happen.$q$,
  point_attaining_answer = $q$1. Rewrite as x^(-2).
2. The power rule gives f'(x) = -2x^(-3), which is -2/x^3.
3. The exponent decreases by one to -3, not kept at -2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4dfb53f481d2481ef2dec403b7a4cd29';
update app.topic_explainers set
  core_idea = $q$- Differentiating term by term is safe only when every coefficient and sign is carried through with explicit grouping.
- Writing 2t minus 4 times e to a power without parentheses around (2t-4) changes what the expression actually means, even if the intended derivative was correct.$q$,
  what_students_need_to_understand = $q$- When a derivative produces a binomial coefficient in front of another factor, that coefficient needs parentheses around it.
- The CED's own scoring notes flag this exact omission as a real, documented point-losing error.$q$,
  how_this_becomes_points = $q$- Put parentheses around any multi-term coefficient produced by these rules.
- A response with the right numbers but ambiguous or missing grouping can be marked as a different, incorrect expression.$q$,
  point_attaining_answer = $q$- The notation is ambiguous and incorrect as written.
- The derivative of (2t^2-4t) is (4t-4).
- It must be grouped in parentheses as (4t-4) times e^t, not written as 4t - 4 times e^t, which changes the meaning of the expression.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3a4b81eb91960774d21e269e98d4c82e';
update app.topic_explainers set
  core_idea = $q$- e^x is its own derivative only when x itself is the variable.
- When the exponent is a function of x rather than x alone, the chain rule requires multiplying by that inner function's derivative.
- Skipping this step is a specific, documented, common error.$q$,
  what_students_need_to_understand = $q$- Differentiating e^(x^2) as x^2 times e^(x^2) is a garbled version of the product rule mistakenly applied here.
- The correct chain-rule derivative is e^(x^2) times the derivative of x^2, which is 2x.
- This gives 2x times e^(x^2).$q$,
  how_this_becomes_points = $q$1. Recognize when the exponent is not simply x.
2. Multiply by that inner function's own derivative rather than by the inner function itself.$q$,
  point_attaining_answer = $q$- f'(x) = 2x times e^(x^2), using the chain rule.
- The derivative of e to an inner power is e to that same inner power times the derivative of the inner expression.
- The derivative of x^2 is 2x, not x^2 itself.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dd95fb916887ba30d0a4aca108452715';
update app.topic_explainers set
  core_idea = $q$- The product rule's two terms are scored as two separate, independent points on this exam.
- Writing the correct structure, first times derivative of second plus second times derivative of first, earns credit even if a later arithmetic slip changes the final number.$q$,
  what_students_need_to_understand = $q$- The CED's own scoring notes state that failing to present the product-rule structure explicitly costs the setup point even with a correct final numeric answer.
- The structural step and the final value are graded as two separate things.$q$,
  how_this_becomes_points = $q$Full credit requires showing the explicit structural setup, first factor times derivative of second plus second factor times derivative of first, as its own visible step, separate from the final simplified value.$q$,
  point_attaining_answer = $q$1. (uv)'(3) = u(3)v'(3) + v(3)u'(3)
2. = (5)(-1) + (4)(2)
3. = -5 + 8 = 3

Both structural terms are shown explicitly before combining to the final value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3fb3146c5897f7f82e1233ab2a41e551';
update app.topic_explainers set
  core_idea = $q$- The quotient rule's numerator has a fixed order: denominator times derivative of numerator, minus numerator times derivative of denominator.
- Reversing that subtraction order produces the exact negative of the correct answer, not just a small error.$q$,
  what_students_need_to_understand = $q$- Unlike the product rule, order matters here.
- Swapping which term comes first in the numerator's subtraction produces a completely different, negated, result.
- Subtraction is not commutative the way the product rule's addition is.$q$,
  how_this_becomes_points = $q$- Write the numerator terms in the correct order: denominator times derivative of numerator minus numerator times derivative of denominator.
- Put it over the denominator squared.
- A numerically close final answer is not enough.$q$,
  point_attaining_answer = $q$1. (u/v)'(2) = (v(2)u'(2) - u(2)v'(2))/v(2)^2
2. = (2*4 - 5*1)/4
3. = 3/4

Denominator times derivative of numerator minus numerator times derivative of denominator, in that order, over denominator squared.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3f655af86351dda29042394aa2601734';
update app.topic_explainers set
  core_idea = $q$- sec x and tan x have similar-looking derivatives that are easy to swap.
- The derivative of tan x is sec^2(x), while the derivative of sec x is sec(x)tan(x).
- Confusing which one produces which is a common error with these four functions.$q$,
  what_students_need_to_understand = $q$- cot x and csc x both have negative derivatives, -csc^2(x) and -csc(x)cot(x) respectively.
- tan x and sec x have positive derivatives.
- Forgetting the negative sign specifically on the cot/csc pair is a well-known, repeated error.$q$,
  how_this_becomes_points = $q$- Cite the exact correct derivative formula for whichever of the four functions is present, including the correct sign.
- Do not borrow a formula from one of the other three.$q$,
  point_attaining_answer = $q$- f'(x) = -csc^2(x).
- cot(x)'s derivative carries a negative sign.
- tan(x)'s derivative sec^2(x) is positive, with no negative sign at all.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=2 and topic_code='2.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fe97294c1f12953ef834e1eb13266e3e';
update app.topic_explainers set
  core_idea = $q$- The chain rule's most common failure mode is misidentifying which piece is the inner function, not the formula itself.
- This is especially so inside forms like sin squared of x or e to a squared power.
- There the inner function is not obviously separate from the outer one.$q$,
  what_students_need_to_understand = $q$- sin^2(x) means (sin x)^2, so the outer function is squaring and the inner function is sin x.
- Differentiating requires both the power rule on the outside and the derivative of sin x on the inside.
- Stopping after the power rule alone is the single most common way this topic loses points.$q$,
  how_this_becomes_points = $q$- Differentiate the outer function correctly.
- Explicitly multiply by the inner function's derivative.
- A response that nails the outer step but omits the inner factor still loses the point.$q$,
  point_attaining_answer = $q$- f'(x) = 2 sin(x) times cos(x).
- The outer function is squaring (derivative 2 times the inside).
- The inner function is sin(x), whose own derivative cos(x) must also be multiplied in.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=3 and topic_code='3.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5649937bfa9de449c8988580eaa16935';
update app.topic_explainers set
  core_idea = $q$- Horizontal and vertical tangents are found from opposite parts of dy/dx once it is written as a single fraction.
- Horizontal tangents come from the numerator equal to zero.
- Vertical tangents come from the denominator equal to zero.
- The Chief Reader Report documents swapping these as a real, common error.$q$,
  what_students_need_to_understand = $q$- Once dy/dx is a fraction, a horizontal tangent occurs where the top, the numerator, is zero.
- A vertical tangent occurs where the bottom, the denominator, is zero.
- Reaching for the wrong one is the single most reader-documented implicit-differentiation error.$q$,
  how_this_becomes_points = $q$1. Explicitly set the denominator of dy/dx to zero, not the numerator.
2. Per the Scoring Guidelines, explicitly state which resulting root satisfies the problem's domain restriction if more than one root results.$q$,
  point_attaining_answer = $q$1. Implicit differentiation gives dy/dx = (2-x)/y.
2. A vertical tangent occurs where the denominator y = 0, not where the numerator is zero.
3. Substituting y = 0 back into the original equation gives x = 0 or x = 4 as the vertical-tangent locations.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=3 and topic_code='3.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5f04b3dc58666484640b10026acff5b5';
update app.topic_explainers set
  core_idea = $q$- The reciprocal-slope relationship works at corresponding points, not the same input value.
- Finding g'(a) requires first locating the input b on the original function where f(b) = a.
- Then take the reciprocal of f'(b), never the reciprocal of f' evaluated at a itself.$q$,
  what_students_need_to_understand = $q$- Swapping x and y is the whole trick here.
- Since g is f's inverse, g(a) = b exactly when f(b) = a.
- So g'(a) is the reciprocal of the original function's derivative at b, not at a.$q$,
  how_this_becomes_points = $q$1. Explicitly find the corresponding input b, where f(b) equals the value you were given.
2. Then take the reciprocal.

Skipping straight to 1/f'(a) is the single most common way this topic loses points.$q$,
  point_attaining_answer = $q$1. Since f(3) = 7, g(7) = 3.
2. Therefore g'(7) = 1/f'(3) = 1/5.
3. This uses the derivative at the corresponding input 3, not at the input 7 itself.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=3 and topic_code='3.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c0c073c78f504f1707ae66e173f9a5be';
update app.topic_explainers set
  core_idea = $q$- arcsin, arccos, and arctan each have their own derivative formula built from square roots or denominators of 1 plus or minus x squared.
- These formulas look nothing like the derivatives of sine, cosine, or tangent.
- Confusing the two produces an answer with the wrong structure entirely, not just a sign error.$q$,
  what_students_need_to_understand = $q$- The derivative of arctan(x) is 1/(1+x^2).
- That is a completely different algebraic form from the derivative of tan(x), which is sec^2(x).
- They are structurally unrelated, not formulas that can be confused for partial credit.$q$,
  how_this_becomes_points = $q$1. Cite the specific inverse-trig formula matching the function present.
2. Chain through correctly if the argument is itself a function of x.
3. Do not substitute a regular trig derivative in its place.$q$,
  point_attaining_answer = $q$1. Use the arctan derivative formula 1/(1+u^2) with u = 3x.
2. Multiply by u' = 3 via the chain rule.
3. f'(x) = 3/(1+(3x)^2), not the tangent derivative formula.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=3 and topic_code='3.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ec8169711cd1b40394cd480a7ed46aba';
update app.topic_explainers set
  core_idea = $q$- The real skill tested here is reading a function's structure correctly.
- h(x) = (3x+1)^5 looks like it could involve a product, but it is a single composed function.
- It requires the chain rule, not a product of two separate factors.$q$,
  what_students_need_to_understand = $q$- A product rule applies to two genuinely separate factors multiplied together, like x times sin(x).
- A chain rule applies to one function raised to a power or nested inside another, like (3x+1)^5.
- These look superficially similar but require completely different procedures.$q$,
  how_this_becomes_points = $q$- Name the correct procedure from the function's actual structure before differentiating.
- Do not apply a rule by habit or pattern-matching to the most recently practiced technique.$q$,
  point_attaining_answer = $q$- This is a single composed function, not a product of separate factors, so the chain rule applies.
- h'(x) = 5(3x+1)^4 times 3.
- That is the derivative of the outer power function times the derivative of the inner expression.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=3 and topic_code='3.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='496bc39b9da7d7c1261386c54efffed0';
update app.topic_explainers set
  core_idea = $q$- The number of times you differentiate has to match what is actually being asked.
- Velocity requires one derivative of position, acceleration requires two.
- Stopping one derivative short answers the wrong question entirely, however carefully computed.$q$,
  what_students_need_to_understand = $q$- A second derivative does not just mean differentiate twice as a mechanical instruction.
- In context it represents the rate of change of a rate.
- Examples: acceleration, the rate of change of velocity, or concavity, the rate of change of slope.$q$,
  how_this_becomes_points = $q$1. Differentiate the exact number of times the question requires.
2. State the resulting value with its correct contextual meaning: acceleration, concavity, or another named second-derivative quantity.
3. Do not stop at velocity or slope when asked for the rate of the rate.$q$,
  point_attaining_answer = $q$1. Acceleration requires the second derivative: s''(t) = 6t - 12.
2. So s''(2) = 6(2) - 12 = 0.
3. The value s'(2) computed above is velocity, not acceleration.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=3 and topic_code='3.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1c0af9d4a44fdecaca66e7b44b9b6a2c';
update app.topic_explainers set
  core_idea = $q$- A derivative value tied to a real scenario is a rate, not a plain number.
- Reporting it correctly means naming the changing quantity, the direction, the specific input, and the units all together.
- Any one missing piece leaves the interpretation incomplete.$q$,
  what_students_need_to_understand = $q$- The number by itself never earns interpretation credit.
- A grader looks for the full sentence connecting the symbol to the scenario.
- It must name quantity, direction, input value, and units explicitly.$q$,
  how_this_becomes_points = $q$Full credit requires all four pieces stated together in context, so a technically correct derivative computation with no interpreting sentence still misses the point this topic is testing.$q$,
  point_attaining_answer = $q$- At t = 4 minutes after brewing, the coffee's temperature is decreasing at about 3.2 degrees Celsius per minute.
- This names the quantity, the time, the direction, and the units together.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6d86567c7e9b7c5670e985564b925f55';
update app.topic_explainers set
  core_idea = $q$- Whether an object is speeding up or slowing down depends on comparing the signs of velocity and acceleration together.
- Matching signs mean speeding up, opposite signs mean slowing down.
- Checking only one of the two gives the wrong answer about half the time.$q$,
  what_students_need_to_understand = $q$- A positive velocity does not by itself mean the object is speeding up.
- If acceleration is negative at that same moment, the signs disagree and the object is actually slowing down.$q$,
  how_this_becomes_points = $q$Full credit requires comparing both signs explicitly, not concluding from velocity's sign or acceleration's sign alone.$q$,
  point_attaining_answer = $q$- Slowing down.
- Velocity (positive) and acceleration (negative) have opposite signs at t = 5.
- Opposite signs mean the speed is decreasing, even though velocity itself is still positive.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bab9382f3dcdbd8b9386ac652a89cce6';
update app.topic_explainers set
  core_idea = $q$- Outside of motion, dV/dt, dP/dt, or any other rate symbol still means change per unit time.
- The skill is naming which quantity is changing and attaching the scenario's own units.
- Do not treat the derivative as an abstract number.$q$,
  what_students_need_to_understand = $q$The same derivative symbol carries a different real meaning in every scenario, so the response has to name the specific quantity and units from that scenario, not a generic 'rate.'$q$,
  how_this_becomes_points = $q$Full credit requires identifying the changing quantity and reporting the rate with the scenario's own units, not a bare number pulled from a derivative computation.$q$,
  point_attaining_answer = $q$- At t = 8 minutes, the tank's volume is decreasing at about 15 gallons per minute.
- This names the quantity, the time, the direction, and the units together, not the bare derivative value.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c539b91d021a8ef5423b494624fbf06d';
update app.topic_explainers set
  core_idea = $q$- Citing a chain-rule identity by name is not the same as carrying it through to a computed value.
- The identity has to end in an actual number using the given rate, not stop at the formula itself.$q$,
  what_students_need_to_understand = $q$- Writing 'dx/dt = dx/dy times dy/dt' and stopping states a true fact but does not earn credit.
- The identity must be evaluated using the actual given rate to produce a number.$q$,
  how_this_becomes_points = $q$The differentiation point requires the full equation differentiated with respect to t and solved numerically, not a cited identity left unevaluated.$q$,
  point_attaining_answer = $q$- No -- the identity has to be carried through to an actual numeric value for dx/dt using the given dy/dt.
- Differentiating the full equation with respect to t and solving for dx/dt numerically is what earns the point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='74ae2c6b1c59b1332201a23a32db4e37';
update app.topic_explainers set
  core_idea = $q$- Every product term in a related-rates equation produces two separate derivative terms after differentiating, one from each factor.
- Every function nested inside another produces its own chain-rule factor.
- Missing either is the most common way this topic's execution point is lost.$q$,
  what_students_need_to_understand = $q$- A term like 3xy^2 is a product of x and y^2, so differentiating it produces two terms, not one.
- A term like e^y produces a chain-rule factor from differentiating y with respect to t.$q$,
  how_this_becomes_points = $q$1. Include every product-rule and chain-rule term in the differentiated equation.
2. Evaluate with snapshot values only after differentiation is complete.$q$,
  point_attaining_answer = $q$1. Differentiating gives 3y^2(dx/dt) + 6xy(dy/dt) + e^y(dy/dt) = 0.
2. Both terms from the product 3xy^2 are present, along with the chain-rule term from e^y.
3. Substituting x=1, y=2, dx/dt=5 and solving for dy/dt gives the requested rate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='39649983777bbd3122e78ba0ed556e98';
update app.topic_explainers set
  core_idea = $q$- The slope value and the mechanics of building and evaluating a linearization are scored independently.
- A wrong slope carried through consistently to a completed number still earns the mechanics point.
- The slope point is lost.$q$,
  what_students_need_to_understand = $q$- Only an unresolved expression, missing a final evaluated number, loses the mechanics point.
- A wrong-but-fully-computed approximation does not.$q$,
  how_this_becomes_points = $q$Full credit for the mechanics point requires a fully evaluated final number built from L(x) = f(a) + f'(a)(x-a), regardless of whether the slope value itself was correct.$q$,
  point_attaining_answer = $q$- Losing the slope point does not cost the mechanics point here.
- The wrong slope value was used consistently all the way through to one fully evaluated final number.
- So the linearization-mechanics point is still earned.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='3759f190d751e967ffe41ee2b586046a';
update app.topic_explainers set
  core_idea = $q$- Confirming the indeterminate form in words, before applying L'Hospital's Rule, is a required step, not a formality.
- The rule always means differentiating numerator and denominator separately, never the quotient rule.$q$,
  what_students_need_to_understand = $q$- 0/0 and infinity/infinity are labels describing a situation.
- The correct next step is always to differentiate numerator and denominator on their own.
- Never reach for the quotient rule.$q$,
  how_this_becomes_points = $q$1. State the indeterminate form as a verified fact before applying the rule.
2. Differentiate numerator and denominator separately rather than using the quotient rule.$q$,
  point_attaining_answer = $q$1. As x approaches 1, ln(x) approaches 0 and (x-1) approaches 0, so this is the 0/0 indeterminate form.
2. L'Hospital's Rule applies.
3. Differentiating numerator and denominator separately gives (1/x)/1, which approaches 1 as x approaches 1.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=4 and topic_code='4.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b46dd23d98b93ad502802bc11cb125e1';
update app.topic_explainers set
  core_idea = $q$- MVT does not just claim some c exists with a matching slope.
- Both hypotheses, continuity on the closed interval and differentiability on the open interval, have to be checked and stated.
- The theorem simply does not apply without them.$q$,
  what_students_need_to_understand = $q$- A function can be continuous everywhere on a closed interval and still fail the MVT hypothesis.
- Even one non-differentiable point, such as a corner, inside the open interval is enough.$q$,
  how_this_becomes_points = $q$1. Explicitly verify both hypotheses.
2. Then state the conclusion.

Do not cite continuity and assume differentiability follows.$q$,
  point_attaining_answer = $q$- Incorrect -- MVT also requires f to be differentiable on the open interval (0,4).
- f(x) = |x-2| is not differentiable at x=2, a corner, which lies inside that interval.
- So MVT's hypotheses are not fully met.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8101e53fcd8204147e39f7a304afe1c7';
update app.topic_explainers set
  core_idea = $q$- Presenting a critical point's x-value alone, with no derivative-setting work shown, does not earn the point.
- The work step or explicit critical-point language has to be visible, even when the value itself is correct.$q$,
  what_students_need_to_understand = $q$- Critical-point credit is not about reaching the right number.
- It is about showing the equation f'(x)=0 (or identifying where f' is undefined) as an explicit step before stating the value.$q$,
  how_this_becomes_points = $q$Full credit requires the derivative-setting work shown as its own step, not just the resulting x-value presented on its own.$q$,
  point_attaining_answer = $q$- No -- credit requires showing the derivative-setting work, f'(x) = 2(x-4) = 0.
- A bare answer without that step does not earn the point even though x=4 is correct.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fe1f6da28a1b79e86c22d49df41cf278';
update app.topic_explainers set
  core_idea = $q$- Increasing and decreasing behavior is described using the x-interval where f' is positive or negative.
- Never name the function's output y-values.
- They describe two different axes of the same graph.$q$,
  what_students_need_to_understand = $q$An increasing/decreasing conclusion is always stated as an x-interval, such as (2,5), because that is where the sign test was actually performed -- describing it by a range of y-values mixes up input and output.$q$,
  how_this_becomes_points = $q$Full credit requires the conclusion stated as an x-interval matching the sign chart, not a range of function output values.$q$,
  point_attaining_answer = $q$- The conclusion should be stated using the x-interval where f' is positive, (2,5).
- Do not name output y-values.
- Increasing and decreasing describe behavior over an x-interval, not a y-range.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f1e7bc96117435c5d1622ed247caaf6e';
update app.topic_explainers set
  core_idea = $q$- f'(c)=0 only identifies a critical point.
- Classifying it as a local maximum or minimum requires checking that f' actually changes sign on both sides of c.
- It is not enough that f' equals zero there.$q$,
  what_students_need_to_understand = $q$- A critical point where f'(c)=0 could be a local max, a local min, or neither (if the sign does not change at all).
- So the sign-change check on both sides is not optional evidence, it is the entire justification.$q$,
  how_this_becomes_points = $q$- Show f''s sign on both the left and right of the critical point.
- Do not just state f'(c)=0 and name an extremum type.$q$,
  point_attaining_answer = $q$- Incorrect as stated -- f'(3)=0 only identifies a critical point.
- Classifying it as a local maximum requires checking that f' changes from positive to negative on either side of x=3.
- That check was never shown.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='789146cf593cd26bea5e07ad6f625e9a';
update app.topic_explainers set
  core_idea = $q$- Justifying an absolute extremum with a local argument, the First or Second Derivative Test, does not earn the justification point even when the final numeric answer is correct.
- Only comparing values at every critical point and both endpoints, the Candidates Test, justifies a global claim.$q$,
  what_students_need_to_understand = $q$- A local test can correctly identify a local maximum or minimum.
- That is a fundamentally different claim from an absolute extremum on a closed interval.
- The absolute claim requires comparing against every candidate, not just the immediate neighborhood of one point.$q$,
  how_this_becomes_points = $q$- The justification point for an absolute extremum requires the Candidates Test comparison shown explicitly.
- A correct local-test argument still earns the separate final-answer point.
- It never earns the justification point for a global claim.$q$,
  point_attaining_answer = $q$- The final value may be correct, but the justification is not.
- A local argument like the First Derivative Test never justifies an absolute extremum.
- Only comparing f-values at every critical point and both endpoints earns the justification point.
- The answer-value point can still be earned separately.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='2767e81c46e39821e0701b3cc6bfeed3';
update app.topic_explainers set
  core_idea = $q$- Concavity is decided entirely by the sign of f'', the second derivative.
- Checking f''s own sign answers a different question, whether the function is increasing or decreasing.
- It does not tell you whether the function curves upward or downward.$q$,
  what_students_need_to_understand = $q$- f' positive or negative tells you increasing or decreasing.
- f'' positive or negative tells you concave up or concave down.
- These are two separate sign tests on two different functions, and swapping them answers the wrong question.$q$,
  how_this_becomes_points = $q$Full credit for a concavity question requires the sign chart built from f'', not f'.$q$,
  point_attaining_answer = $q$- This is incorrect -- concavity is determined by the sign of f'', the second derivative, not f'.
- f' sign determines increasing or decreasing, a separate question from concavity.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='38fcf64bcbb4786926a846adec207259';
update app.topic_explainers set
  core_idea = $q$- When f''(c)=0, the second derivative test is inconclusive, not negative.
- It means this particular test cannot decide, not that no extremum exists.
- A different method has to be used instead.$q$,
  what_students_need_to_understand = $q$- An inconclusive result is a statement about the test's limits, not about the function.
- Concluding 'no extremum' from f''(c)=0 replaces an honest 'I need another method' with a claim the test never actually made.$q$,
  how_this_becomes_points = $q$Full credit requires recognizing f''(c)=0 as inconclusive and switching to the First Derivative Test, not treating it as evidence against an extremum.$q$,
  point_attaining_answer = $q$- Incorrect -- f''(2)=0 makes the second derivative test inconclusive, not negative.
- It says nothing about whether an extremum exists.
- The First Derivative Test would be needed to actually determine that.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b8c610eb9024768e0cbbebeb4bc310f3';
update app.topic_explainers set
  core_idea = $q$- A sketch should only show what the derivative evidence actually supports.
- Gather the sign charts for f' and f'' first.
- Let those charts, not intuition about what a graph 'should' look like, decide every feature drawn.$q$,
  what_students_need_to_understand = $q$- Each graph feature, an extremum, an inflection point, a concavity change, needs its own piece of derivative evidence before it can be drawn.
- A feature added from intuition without matching evidence is not supported by the given information.$q$,
  how_this_becomes_points = $q$Full credit requires every sketched feature to be traceable to a specific piece of sign-chart evidence, not added because it looks reasonable.$q$,
  point_attaining_answer = $q$- This is not supported -- an inflection point requires evidence about concavity from f'', which was never given.
- The sign change in f' alone only supports a local maximum at x=2, not an inflection point.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='eced0c0c3da5675ebbf0276d16319f86';
update app.topic_explainers set
  core_idea = $q$- A graph of f' is easy to mistake for a graph of f itself.
- Extrema and concavity of f are read from where the shown f' graph crosses zero and how it behaves.
- They are not read from the shape of that f' graph as if it directly were f.$q$,
  what_students_need_to_understand = $q$- If the graph shown is f', then a zero crossing of that graph corresponds to a critical point of f.
- Whether f' is increasing or decreasing there corresponds to concavity of f.
- None of this is read the same way you would read a graph of f directly.$q$,
  how_this_becomes_points = $q$Full credit requires correctly identifying which function's graph is shown and translating its features into conclusions about the other function, rather than reading the shown graph as if it directly represented f.$q$,
  point_attaining_answer = $q$- This confuses the two functions -- the graph shown is f', not f.
- Since f' changes from positive to negative at x=5, f, not the graph shown, has a local maximum at x=5.
- The shown graph itself simply crosses zero there.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='4872e8fbde0ba2f8e88f3ae3c199cf8f';
update app.topic_explainers set
  core_idea = $q$- An optimization objective has to be reduced to a single variable using the given constraint before any differentiation happens.
- Differentiating a two-variable expression, treating the other variable as if it were already constant, skips a required setup step.$q$,
  what_students_need_to_understand = $q$- Writing an objective like Area = xy is not yet ready to differentiate.
- The constraint relating x and y has to be solved and substituted in first.
- That produces a genuine one-variable function of x alone.$q$,
  how_this_becomes_points = $q$Full credit requires the constraint substitution shown as its own step, producing a one-variable objective function, before any derivative is taken.$q$,
  point_attaining_answer = $q$1. This skips a required step -- the perimeter constraint (2x+2y=40, so y=20-x) must be substituted in first.
2. That reduces A to the one-variable function A(x) = x(20-x).
3. Only then differentiate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='08ef207e4ecc24dd72647ac6894a3e18';
update app.topic_explainers set
  core_idea = $q$- Finding a critical point is not the end of an optimization problem.
- The response still has to justify that the critical value is actually the requested maximum or minimum.
- It must also answer in context with units, not just report the numeric extremum.$q$,
  what_students_need_to_understand = $q$A correct critical point and a correct final number can still be an incomplete response if the justification step, comparing the critical value against endpoints or using a derivative test, is never shown.$q$,
  how_this_becomes_points = $q$1. Show the justification comparison explicitly.
2. State the final answer in context with the requested variable and units.$q$,
  point_attaining_answer = $q$- The value is correct, but the response is missing the justification step.
- Comparing A(10)=100 to the endpoint values A(0)=0 and A(20)=0 confirms x=10 gives the maximum.
- This comparison must be shown, not just the final number.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='de30f24e8f7ba3683d9b16ec3299aac7';
update app.topic_explainers set
  core_idea = $q$- A term like xy inside an implicit relation is a product of two factors that both depend on x.
- Differentiating it requires the product rule, producing a dy/dx term from the y-factor.
- Treating y as an ordinary constant drops that required term entirely.$q$,
  what_students_need_to_understand = $q$- Even outside a related-rates or tangent-line problem, any implicit relation involving both x and y needs the same chain-rule treatment on y-terms established in implicit differentiation.
- Behavior questions about implicit curves are not exempt from that rule.$q$,
  how_this_becomes_points = $q$Full credit requires every product involving both x and y to produce its full product-rule expansion, including the dy/dx factor, not a shortcut that treats y as constant.$q$,
  point_attaining_answer = $q$- This is incomplete -- xy is a product of two factors both depending on x, so the product rule applies.
- Differentiating xy gives x(dy/dx) + y, not just y.
- The correct implicit differentiation is 2x + x(dy/dx) + y = 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-13 (recommendation #3, AP Calculus BC units 1-5): Claude-authored in session; four fields reshaped into bullets, numbered steps and tables (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro, rulings in scripts/content-seed/structured-explainers-rest-2026-11-13/RULINGS.md.$q$
where subject_key='ap_calculus_bc' and unit_number=5 and topic_code='5.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='10463b4be52706f17b3a292be313121d';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_calculus_bc' and topic_code in ('1.1','1.2','1.3','1.4','1.5','1.6','1.7','1.8','1.9','1.10','1.11','1.12','1.13','1.14','1.15','1.16','2.1','2.2','2.3','2.4','2.5','2.6','2.7','2.8','2.9','2.10','3.1','3.2','3.3','3.4','3.5','3.6','4.1','4.2','4.3','4.4','4.5','4.6','4.7','5.1','5.2','5.3','5.4','5.5','5.6','5.7','5.8','5.9','5.10','5.11','5.12') and source_note like '%Structured 2026-11-13 (recommendation #3%')<>51 then raise exception 'expected 51 rows updated'; end if; end $$;
commit;
