-- Structured explainer pieces (recommendation #3), batch 2026-11-13. Guarded on each row still holding the text it was built on.
begin;
update app.topic_explainers set
  core_idea = $q$Calculus begins with the problem that average rate is easy over an interval, but an instant has no interval width.$q$,
  what_students_need_to_understand = $q$- Average rate compares two inputs.
- Instantaneous rate is the value those average rates approach near one input.$q$,
  how_this_becomes_points = $q$1. Connect an instant to a limiting process.
2. Do not divide by zero.$q$,
  point_attaining_answer = $q$The speed at t = 4 is the limit of average velocities over intervals containing t = 4 as the interval width approaches 0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e83999b24ffc85990d642c16a0e972e4';
update app.topic_explainers set
  core_idea = $q$A limit names what a function approaches as x gets close to a chosen input.$q$,
  what_students_need_to_understand = $q$- Approaches does not mean equals.
- The limit is about nearby behavior, and one-sided notation adds direction.$q$,
  how_this_becomes_points = $q$Points come from translating notation accurately into a mathematical claim.$q$,
  point_attaining_answer = $q$As x gets close to 2, f(x) gets close to 5; this does not by itself tell us f(2).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1794bda12ab756fb788e30799ef98a33';
update app.topic_explainers set
  core_idea = $q$A graph shows the y-value approached as x moves toward an input.$q$,
  what_students_need_to_understand = $q$- The filled point shows f(c).
- Nearby curve behavior shows the limit.$q$,
  how_this_becomes_points = $q$Points come from naming left- and right-hand behavior before concluding.$q$,
  point_attaining_answer = $q$The limit is 4 because the graph approaches y = 4 from both sides; the filled point gives f(3).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c0e99c9d44d530cbdb222ed504edce86';
update app.topic_explainers set
  core_idea = $q$A table suggests a limit by showing values near the target input.$q$,
  what_students_need_to_understand = $q$A table gives evidence of a trend, not automatic proof of an exact value.$q$,
  how_this_becomes_points = $q$1. Use nearby values on both sides.
2. State the supported estimate.$q$,
  point_attaining_answer = $q$The limit appears to be 5 because nearby values approach 5 from both sides.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e65c2990e00acc691650b68d236a1662';
update app.topic_explainers set
  core_idea = $q$The squeeze theorem traps one function between two functions approaching the same value.$q$,
  what_students_need_to_understand = $q$- The theorem is a justification.
- Bounds plus matching outside limits force the middle limit.$q$,
  how_this_becomes_points = $q$1. Show the bounds.
2. Show the matching limits.
3. State the conclusion.$q$,
  point_attaining_answer = $q$Since both bounds approach 0 and h(x) is between them, the squeeze theorem gives lim h(x)=0.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a268b7adb229a4a626b5f9739a868d46';
update app.topic_explainers set
  core_idea = $q$A discontinuity occurs where continuity fails, and the type depends on what fails.$q$,
  what_students_need_to_understand = $q$Removable, jump, and infinite discontinuities come from different limit and value behavior.$q$,
  how_this_becomes_points = $q$1. Name the type.
2. Tie it to evidence.$q$,
  point_attaining_answer = $q$It is a jump discontinuity because the one-sided limits are finite but not equal.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bf71f681f0425802f78c1836153ff5f1';
update app.topic_explainers set
  core_idea = $q$A function is continuous over an interval if it is continuous at every point in that interval.$q$,
  what_students_need_to_understand = $q$Students must scan the interval for domain restrictions, holes, jumps, asymptotes, and endpoints.$q$,
  how_this_becomes_points = $q$1. Name the interval.
2. Support continuity across the whole interval.$q$,
  point_attaining_answer = $q$No. Rational functions are continuous on their domains, but x=2 is not in the domain and lies in [0,4].$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5870bffdc8daf9cff8040e9e1dda9bb0';
update app.topic_explainers set
  core_idea = $q$A removable discontinuity can be fixed by making the function value equal the limit.$q$,
  what_students_need_to_understand = $q$A discontinuity is removable only when the limiting behavior has one finite target.$q$,
  how_this_becomes_points = $q$1. Find the limit.
2. Match the value or parameter to it.$q$,
  point_attaining_answer = $q$Redefine f(3)=6 because continuity requires f(3) to equal the limit.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.13' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d29a6894bead22cbef8ea853ec542e81';
update app.topic_explainers set
  core_idea = $q$An infinite limit describes unbounded behavior near a finite input.$q$,
  what_students_need_to_understand = $q$Infinity describes behavior, not a regular real-number limit.$q$,
  how_this_becomes_points = $q$1. Write one-sided or two-sided infinite limit statements.
2. Connect them to vertical asymptotes.$q$,
  point_attaining_answer = $q$The right-hand limit is positive infinity; this supports a vertical asymptote at x=2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='50b911cd05756a802cf6f61a9611d4f5';
update app.topic_explainers set
  core_idea = $q$A limit at infinity describes end behavior as x goes far left or right.$q$,
  what_students_need_to_understand = $q$Horizontal asymptotes describe long-run y-values, not undefined x-values.$q$,
  how_this_becomes_points = $q$1. Write the correct limit at infinity.
2. Connect a finite result to y=L.$q$,
  point_attaining_answer = $q$The graph approaches y=3 as x goes to infinity, so y=3 is a horizontal asymptote to the right.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.15' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ff43446f8c446cb3ff5216f0e7f9491b';
update app.topic_explainers set
  core_idea = $q$IVT says a continuous function on a closed interval takes every y-value between its endpoint values.$q$,
  what_students_need_to_understand = $q$IVT proves existence without locating the exact input.$q$,
  how_this_becomes_points = $q$1. Verify continuity.
2. Compare endpoint values.
3. State the existence conclusion.$q$,
  point_attaining_answer = $q$Because f is continuous and 7 is between f(1)=2 and f(5)=10, IVT guarantees some c in (1,5).$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=1 and topic_code='1.16' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='8e43c473b151ad761f9c45e219f96d9d';
update app.topic_explainers set
  core_idea = $q$Accumulation describes how small changes add up over an interval.$q$,
  what_students_need_to_understand = $q$It introduces the integral as a total-change idea before students focus on symbolic integration.$q$,
  how_this_becomes_points = $q$1. Interpret a rate over an interval as accumulated change.
2. Connect area under a rate graph to total amount.$q$,
  point_attaining_answer = $q$1. Identify the rate, identify the interval, then describe the accumulation as total change over that interval.
2. Then make the scoring connection explicit: You earn points by interpreting a rate over an interval as accumulated change and connecting area under a rate graph to total amount.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='bb818a4993b5181c0f91579cedb0b09b';
update app.topic_explainers set
  core_idea = $q$Riemann sums approximate accumulated area using rectangles based on left, right, midpoint, or other sample values.$q$,
  what_students_need_to_understand = $q$They are a common table-based way to earn accumulation points without an antiderivative.$q$,
  how_this_becomes_points = $q$1. Choose the correct subinterval widths and sample heights.
2. Sum width times height with units.$q$,
  point_attaining_answer = $q$1. For each subinterval, compute base times chosen height, then add the products.
2. Then make the scoring connection explicit: You earn points by choosing the correct subinterval widths and sample heights, then summing width times height with units.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='dd980751d830572c50a824bea0719651';
update app.topic_explainers set
  core_idea = $q$This topic connects rectangle sums, sigma notation, and definite integrals as representations of accumulated change.$q$,
  what_students_need_to_understand = $q$Students need to move among numeric, symbolic, and notation forms to read AP prompts accurately.$q$,
  how_this_becomes_points = $q$You earn points by matching limits of integration, subinterval structure, and integrand meaning to the accumulation being represented.$q$,
  point_attaining_answer = $q$1. Translate the notation into total accumulation from a to b of the rate or height function.
2. Then make the scoring connection explicit: You earn points by matching limits of integration, subinterval structure, and integrand meaning to the accumulation being represented.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='ba88700e05492e4a9b51b5a132475552';
update app.topic_explainers set
  core_idea = $q$The Fundamental Theorem of Calculus links accumulation functions to derivatives of their integrands.$q$,
  what_students_need_to_understand = $q$- It is a central bridge between differentiation and integration.
- It appears in many graph/table FRQs.$q$,
  how_this_becomes_points = $q$1. Recognize that the derivative of an accumulation function depends on the integrand.
2. Account for any variable bound behavior.$q$,
  point_attaining_answer = $q$1. For F(x)=integral from a to x of f(t)dt, write F'(x)=f(x); adjust with chain rule if the bound is not x.
2. Then make the scoring connection explicit: You earn points by recognizing that the derivative of an accumulation function depends on the integrand and any variable bound behavior.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='337bd6ed5cfb6d344738c14f249efe01';
update app.topic_explainers set
  core_idea = $q$- Accumulation functions increase or decrease based on the sign of the rate being accumulated.
- Their concavity depends on how that rate changes.$q$,
  what_students_need_to_understand = $q$This topic turns integral notation into graph behavior, a frequent AP representation shift.$q$,
  how_this_becomes_points = $q$1. Connect the integrand to the derivative of the accumulation function.
2. Reason about sign or slope.$q$,
  point_attaining_answer = $q$1. Treat the integrand as F'(x), then use derivative-sign logic to discuss F.
2. Then make the scoring connection explicit: You earn points by connecting the integrand to the derivative of the accumulation function and then reasoning about sign or slope.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='24b42dbf42a264c03b83b07b0fb77d44';
update app.topic_explainers set
  core_idea = $q$Definite integral properties allow students to split, combine, reverse, and scale accumulated quantities.$q$,
  what_students_need_to_understand = $q$These properties are heavily used when graphs or tables provide partial areas instead of formulas.$q$,
  how_this_becomes_points = $q$You earn points by applying interval additivity, sign reversal, constant multiples, and symmetry when appropriate.$q$,
  point_attaining_answer = $q$1. Rewrite the requested integral in terms of known intervals or areas before calculating.
2. Then make the scoring connection explicit: You earn points by applying interval additivity, sign reversal, constant multiples, and symmetry when appropriate.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='b0ffa2fc45e70b1bc82f2e05114914e9';
update app.topic_explainers set
  core_idea = $q$The evaluation part of the Fundamental Theorem of Calculus uses antiderivatives to compute exact definite integrals.$q$,
  what_students_need_to_understand = $q$It provides the main exact method for total change and area when an antiderivative is available.$q$,
  how_this_becomes_points = $q$1. Find a valid antiderivative.
2. Evaluate it at the bounds.
3. Subtract upper minus lower.$q$,
  point_attaining_answer = $q$1. Find F, then compute F(b)-F(a) and attach contextual units when the integral represents change.
2. Then make the scoring connection explicit: You earn points by finding a valid antiderivative, evaluating it at the bounds, and subtracting upper minus lower.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='1988852639cf538f8b94d61a48119601';
update app.topic_explainers set
  core_idea = $q$An antiderivative reverses differentiation, and an indefinite integral represents a family of functions.$q$,
  what_students_need_to_understand = $q$This skill underlies exact accumulation, differential equation solutions, and many applied models.$q$,
  how_this_becomes_points = $q$1. Use correct reverse derivative rules.
2. Include +C for indefinite integrals.$q$,
  point_attaining_answer = $q$1. Ask what function would differentiate to this expression, then include the constant of integration when no bounds are present.
2. Then make the scoring connection explicit: You earn points by using correct reverse derivative rules and including +C for indefinite integrals.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='5435e95e6680c2502985cbc64715827e';
update app.topic_explainers set
  core_idea = $q$Substitution reverses the chain rule by changing variables so a composite integrand becomes simpler.$q$,
  what_students_need_to_understand = $q$It is one of the most common integration techniques on the AP exam.$q$,
  how_this_becomes_points = $q$1. Choose u.
2. Compute du.
3. Rewrite the integral consistently.
4. Adjust bounds for definite integrals when used.$q$,
  point_attaining_answer = $q$1. Choose the inside expression as u, find du, rewrite everything in u, then integrate.
2. Then make the scoring connection explicit: You earn points by choosing u, computing du, rewriting the integral consistently, and adjusting bounds for definite integrals when used.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='6b9d144dca07c88ec4288b15ecccabce';
update app.topic_explainers set
  core_idea = $q$Some rational expressions must be rewritten by long division or completing the square before integration.$q$,
  what_students_need_to_understand = $q$This topic tests whether students can prepare an expression for a familiar antiderivative form.$q$,
  how_this_becomes_points = $q$1. Rewrite the integrand into an equivalent form.
2. Apply the appropriate antiderivative rule.$q$,
  point_attaining_answer = $q$1. When the integral does not match a basic form, rewrite the algebra first, then integrate the simpler pieces.
2. Then make the scoring connection explicit: You earn points by rewriting the integrand into an equivalent form and then applying the appropriate antiderivative rule.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='47f6258546b0bb6cae2ce1d1e177c71a';
update app.topic_explainers set
  core_idea = $q$This topic is about choosing a valid integration method based on the structure of the integrand.$q$,
  what_students_need_to_understand = $q$AP integration questions often reward recognizing whether basic rules, substitution, algebraic rewrite, or another technique is appropriate.$q$,
  how_this_becomes_points = $q$You earn points by matching the integrand structure to an antidifferentiation procedure before calculating.$q$,
  point_attaining_answer = $q$1. Classify the integrand first: basic reverse rule, composite needing substitution, rational needing rewrite, or product needing another technique.
2. Then make the scoring connection explicit: You earn points by matching the integrand structure to an antidifferentiation procedure before calculating.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=6 and topic_code='6.14' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a7b138bf83ef535afd20d934fb4a7068';
update app.topic_explainers set
  core_idea = $q$Differential equations model situations where a quantity's rate of change depends on variables in the situation.$q$,
  what_students_need_to_understand = $q$They connect derivatives to prediction, growth, decay, and accumulation-based modeling.$q$,
  how_this_becomes_points = $q$You earn points by translating verbal rate relationships into equations involving dy/dx or related notation.$q$,
  point_attaining_answer = $q$1. Identify the quantity, identify what controls its rate, then write the differential equation with the correct variables.
2. Then make the scoring connection explicit: You earn points by translating verbal rate relationships into equations involving dy/dx or related notation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='08da92877b193097b09bbf747c470113';
update app.topic_explainers set
  core_idea = $q$A proposed solution satisfies a differential equation if its derivative matches the rate expression after substitution.$q$,
  what_students_need_to_understand = $q$Verification points are often direct if students show both the derivative and substitution check.$q$,
  how_this_becomes_points = $q$1. Differentiate the proposed solution.
2. Compare it to the right-hand side of the differential equation.$q$,
  point_attaining_answer = $q$1. Compute dy/dx from the proposed y, substitute y and x into the differential equation, then show they match.
2. Then make the scoring connection explicit: You earn points by differentiating the proposed solution and comparing it to the right-hand side of the differential equation.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fcfc1c47cb7bde8d01de0a66222cb542';
update app.topic_explainers set
  core_idea = $q$A slope field shows small line segments whose slopes come from a differential equation at points in the plane.$q$,
  what_students_need_to_understand = $q$It helps students visualize solution behavior without solving the differential equation exactly.$q$,
  how_this_becomes_points = $q$1. Compute slopes at specified points.
2. Draw segments with correct relative direction and steepness.$q$,
  point_attaining_answer = $q$1. Plug each point into dy/dx, then draw a short segment with that slope at the point.
2. Then make the scoring connection explicit: You earn points by computing slopes at specified points and drawing segments with correct relative direction and steepness.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='79443c1efdfbc5652b19f81f6c292acf';
update app.topic_explainers set
  core_idea = $q$Slope fields allow students to infer solution behavior, equilibrium behavior, and approximate paths from local slopes.$q$,
  what_students_need_to_understand = $q$AP questions use slope fields to test qualitative reasoning about differential equations.$q$,
  how_this_becomes_points = $q$You earn points by connecting the displayed segment slopes to whether solutions increase, decrease, level off, or change direction.$q$,
  point_attaining_answer = $q$1. Follow the local directions of the field and describe the solution curve consistent with nearby slopes.
2. Then make the scoring connection explicit: You earn points by connecting the displayed segment slopes to whether solutions increase, decrease, level off, or change direction.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='7960ddc5aac76314677ddc0d36a01074';
update app.topic_explainers set
  core_idea = $q$Separation of variables solves certain differential equations by placing y terms with dy and x terms with dx before integrating.$q$,
  what_students_need_to_understand = $q$This is a major exact-solution method and connects differential equations back to antiderivatives.$q$,
  how_this_becomes_points = $q$1. Separate variables correctly.
2. Integrate both sides.
3. Include the constant of integration.$q$,
  point_attaining_answer = $q$1. Move all y terms to one side and x terms to the other, integrate, then include +C.
2. Then make the scoring connection explicit: You earn points by separating variables correctly, integrating both sides, and including the constant of integration.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='217b2dcab370ff91c8588b94991254c2';
update app.topic_explainers set
  core_idea = $q$A particular solution uses an initial condition to determine the constant in a general differential equation solution.$q$,
  what_students_need_to_understand = $q$AP FRQs often award separate points for separation, integration, constant use, and final solution form.$q$,
  how_this_becomes_points = $q$1. Solve generally.
2. Substitute the initial condition.
3. Determine C.
4. Present the particular solution.$q$,
  point_attaining_answer = $q$1. Do not wait until the end mentally: substitute the given point clearly to solve for C.
2. Then make the scoring connection explicit: You earn points by solving generally, substituting the initial condition, determining C, and presenting the particular solution.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e8f089977d858505a78eec2278afcff2';
update app.topic_explainers set
  core_idea = $q$Exponential models arise when a quantity changes at a rate proportional to the quantity itself.$q$,
  what_students_need_to_understand = $q$They appear in growth, decay, and rate-model contexts across AP Calculus.$q$,
  how_this_becomes_points = $q$1. Recognize dy/dt = ky structure.
2. Interpret the sign and meaning of k in context.$q$,
  point_attaining_answer = $q$1. Look for rate proportional to amount, then write or use the exponential solution model with the initial value.
2. Then make the scoring connection explicit: You earn points by recognizing dy/dt = ky structure and interpreting the sign and meaning of k in context.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=7 and topic_code='7.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='696df34586ec7ea2abdde68489b7908a';
update app.topic_explainers set
  core_idea = $q$Average value uses a definite integral divided by interval length to find the function's mean height over an interval.$q$,
  what_students_need_to_understand = $q$It is a common integration interpretation that is distinct from average rate of change.$q$,
  how_this_becomes_points = $q$1. Set up 1/(b-a) times the integral from a to b of f(x) dx.
2. Interpret the result with correct units.$q$,
  point_attaining_answer = $q$1. Write the formula before evaluating so the interval length and integral are both visible.
2. Then make the scoring connection explicit: You earn points by setting up 1/(b-a) times the integral from a to b of f(x) dx and interpreting the result with correct units.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.1' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='44ca604be4ad36e5e952e49fe7314405';
update app.topic_explainers set
  core_idea = $q$- Integrals connect velocity to change in position.
- Integrals connect acceleration to change in velocity.$q$,
  what_students_need_to_understand = $q$Motion questions often mix derivative and integral relationships in the same prompt.$q$,
  how_this_becomes_points = $q$1. Use definite integrals to compute displacement or change in velocity.
2. Distinguish displacement from distance traveled.$q$,
  point_attaining_answer = $q$1. Identify whether the integral of velocity gives displacement or whether total distance requires integrating speed.
2. Then make the scoring connection explicit: You earn points by using definite integrals to compute displacement or change in velocity and by distinguishing displacement from distance traveled.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.2' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a8eb9fbd42599579340aa67578799c20';
update app.topic_explainers set
  core_idea = $q$Definite integrals in context accumulate rates into total change for quantities like volume, population, temperature, or cost.$q$,
  what_students_need_to_understand = $q$This topic is a direct route to FRQ points because the setup, units, and interpretation can each be assessed.$q$,
  how_this_becomes_points = $q$1. Identify the rate.
2. Integrate over the correct interval.
3. Add an initial value when the question asks for an amount.$q$,
  point_attaining_answer = $q$1. Use final amount = initial amount + accumulated change when an initial value is given.
2. Then make the scoring connection explicit: You earn points by identifying the rate, integrating over the correct interval, and adding an initial value when the question asks for an amount.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.3' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='29620651ea534f78c102204baba9107b';
update app.topic_explainers set
  core_idea = $q$Area between x-functions uses vertical slices and integrates top function minus bottom function.$q$,
  what_students_need_to_understand = $q$It is a core applications-of-integration task and often appears in multi-part FRQs.$q$,
  how_this_becomes_points = $q$1. Find intersection bounds.
2. Integrate upper minus lower over each interval.$q$,
  point_attaining_answer = $q$1. Sketch or compare functions to identify top and bottom, then integrate top minus bottom with respect to x.
2. Then make the scoring connection explicit: You earn points by finding intersection bounds and integrating upper minus lower over each interval.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.4' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='acafb1d1132927a4f1fc3fab4848b55b';
update app.topic_explainers set
  core_idea = $q$Area between y-functions uses horizontal slices and integrates right function minus left function with respect to y.$q$,
  what_students_need_to_understand = $q$This topic extends area reasoning when curves are easier or required to describe as x-functions of y.$q$,
  how_this_becomes_points = $q$1. Use y-bounds.
2. Subtract left from right in the horizontal-slice setup.$q$,
  point_attaining_answer = $q$1. Identify rightmost x and leftmost x as functions of y, then integrate right minus left dy.
2. Then make the scoring connection explicit: You earn points by using y-bounds and subtracting left from right in the horizontal-slice setup.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.5' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d572eaeaf56c73f0c7fcdf9ae9142976';
update app.topic_explainers set
  core_idea = $q$When curves intersect more than twice, the region may need to be split into intervals with different top-bottom relationships.$q$,
  what_students_need_to_understand = $q$AP tasks often use this to test setup decisions, not just integration skill.$q$,
  how_this_becomes_points = $q$1. Identify all relevant intersection points.
2. Split the region.
3. Use the correct subtraction order on each interval.$q$,
  point_attaining_answer = $q$1. Find every intersection, draw or test each interval, then add the separate area integrals.
2. Then make the scoring connection explicit: You earn points by identifying all relevant intersection points, splitting the region, and using the correct subtraction order on each interval.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='fb82d8e818b7273cb506cc01d4d354fc';
update app.topic_explainers set
  core_idea = $q$Cross-section volume sums areas of slices whose square or rectangular dimensions are based on a region in the base.$q$,
  what_students_need_to_understand = $q$This is a high-value setup topic where geometric interpretation earns points before integration is evaluated.$q$,
  how_this_becomes_points = $q$1. Identify the slice width.
2. Write the cross-sectional area formula.
3. Integrate that area over the correct bounds.$q$,
  point_attaining_answer = $q$1. Base of slice from the region first, area formula second, integral of area last.
2. Then make the scoring connection explicit: You earn points by identifying the slice width, writing the cross-sectional area formula, and integrating that area over the correct bounds.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='e06569a4a2c104c2c625b3c08d6a50e8';
update app.topic_explainers set
  core_idea = $q$Triangular and semicircular cross sections use geometry formulas to turn base lengths into slice areas.$q$,
  what_students_need_to_understand = $q$These questions reward students who connect region geometry to the correct area formula instead of memorizing one volume pattern.$q$,
  how_this_becomes_points = $q$1. Identify the cross-section shape.
2. Substitute the region's base length into the correct area formula.
3. Integrate.$q$,
  point_attaining_answer = $q$1. Write the shape formula before substituting the base length from the graph or equations.
2. Then make the scoring connection explicit: You earn points by identifying the cross-section shape, substituting the region's base length into the correct area formula, and integrating.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='d3cc8ac67e08409845683b50bf7a22ac';
update app.topic_explainers set
  core_idea = $q$The disc method finds volume by integrating circular cross-sectional areas when a region rotates around a coordinate axis without a hole.$q$,
  what_students_need_to_understand = $q$It connects geometry, radius choice, and integration in a common AP applications pattern.$q$,
  how_this_becomes_points = $q$1. Identify the radius perpendicular to the axis of rotation.
2. Integrate pi times radius squared over the correct bounds.$q$,
  point_attaining_answer = $q$1. Draw the radius from the axis to the curve, then write pi r^2 for the slice area.
2. Then make the scoring connection explicit: You earn points by identifying the radius perpendicular to the axis of rotation and integrating pi times radius squared over the correct bounds.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a969b8da141e594fe2d9776a6b2bc50c';
update app.topic_explainers set
  core_idea = $q$Disc method around a non-coordinate axis still uses circular slices, but the radius is a distance to the given line of rotation.$q$,
  what_students_need_to_understand = $q$This topic tests whether students understand radius as distance rather than as the function value itself.$q$,
  how_this_becomes_points = $q$1. Express the radius as the distance from the curve to the rotation axis.
2. Integrate pi r^2.$q$,
  point_attaining_answer = $q$1. Write radius = distance to axis, then square it inside pi r^2.
2. Then make the scoring connection explicit: You earn points by expressing the radius as the distance from the curve to the rotation axis and integrating pi r^2.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.10' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='06ca733c834869b99332435941020a81';
update app.topic_explainers set
  core_idea = $q$The washer method finds volume when rotation creates an outer radius and an inner radius.$q$,
  what_students_need_to_understand = $q$It is a common AP setup where the main points come from correct outer-minus-inner structure.$q$,
  how_this_becomes_points = $q$1. Identify both radii.
2. Integrate pi times outer radius squared minus inner radius squared.$q$,
  point_attaining_answer = $q$1. Draw both distances from the axis, label outer and inner, then write pi(R^2-r^2).
2. Then make the scoring connection explicit: You earn points by identifying both radii and integrating pi times outer radius squared minus inner radius squared.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='c207a300f77c6566159878b6a345eab6';
update app.topic_explainers set
  core_idea = $q$Washer method around a shifted axis uses outer and inner radii measured as distances to that axis.$q$,
  what_students_need_to_understand = $q$It extends washer reasoning and often tests careful setup more than difficult integration.$q$,
  how_this_becomes_points = $q$1. Define both shifted-axis distances.
2. Preserve the pi(R^2-r^2) structure.$q$,
  point_attaining_answer = $q$1. Measure each radius from the rotation line, not from the coordinate axis, then subtract areas.
2. Then make the scoring connection explicit: You earn points by defining both shifted-axis distances and preserving the pi(R^2-r^2) structure.$q$,
  source_note = coalesce(source_note,'') || $q$ Structured 2026-11-14 (recommendation #3, AP Calculus AB units 1, 6-8): Claude-authored in session; four fields reshaped into bullets and numbered steps (text markers, no schema change); checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/quick-take-rest-2026-11-14/.$q$
where subject_key='ap_calculus_ab' and unit_number=8 and topic_code='8.12' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0d00d4a880fb62e55e6f4921128cc4f4';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_calculus_ab' and topic_code in ('1.1','1.2','1.3','1.4','1.8','1.10','1.12','1.13','1.14','1.15','1.16','6.1','6.2','6.3','6.4','6.5','6.6','6.7','6.8','6.9','6.10','6.14','7.1','7.2','7.3','7.4','7.6','7.7','7.8','8.1','8.2','8.3','8.4','8.5','8.6','8.7','8.8','8.9','8.10','8.11','8.12') and source_note like '%Structured 2026-11-14 (recommendation #3%')<>41 then raise exception 'expected 41 rows updated'; end if; end $$;
commit;
