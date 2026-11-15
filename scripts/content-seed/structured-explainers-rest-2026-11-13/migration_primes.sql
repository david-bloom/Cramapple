-- Restore lost second-derivative primes in AP Calculus AB 5.6-5.9, 5.11. Guarded on current four-field md5 (and weak_answer text).
begin;
update app.topic_explainers set
  core_idea = $q$- Concavity is governed by the sign of f'', never the sign of f'.
- A response that reuses the increasing/decreasing sign chart from f' to answer a concavity question has tested the wrong derivative.
- The f' sign describes slope direction, not whether that slope is itself increasing or decreasing.$q$,
  what_students_need_to_understand = $q$- Concave up means the slope f' is increasing, which happens exactly where f''>0.
- Concave down means f' is decreasing, exactly where f''<0.
- Concavity is a statement about the second derivative's sign.
- Confusing it with the first derivative's sign produces a plausible-looking but structurally wrong sign chart.$q$,
  how_this_becomes_points = $q$1. Build the sign chart from f'' specifically.
2. Translate that sign into concave up or concave down by interval.
3. A sign chart built from f' instead of f'' does not earn the point even if the increasing/decreasing conclusions it produces are individually correct.$q$,
  point_attaining_answer = $q$h''(x)=12x^2-12=12(x-1)(x+1). Testing h''(0)=-12<0 and h''(2)=36>0 gives:

| Interval | h is |
| (-1,1) | concave down |
| (-infinity,-1) and (1,infinity) | concave up |$q$,
  weak_answer = $q$h'(x)=4x^3-12x, and the response tests the sign of h' at x=-2,0,2 and reports those as the concavity intervals, never computing h'' at all.$q$,
  source_note = coalesce(source_note,'') || $q$ Primes restored 2026-11-13: second-derivative notation (f'', h'', k'', m'', A'') had lost a prime in the stored text; only prime counts changed. Checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/structured-explainers-rest-2026-11-13/.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.6' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='a11c514baa97083f08cd01eadbf9101c'
  and weak_answer = $q$h'(x)=4x^3-12x, and the response tests the sign of h' at x=-2,0,2 and reports those as the concavity intervals, never computing h' at all.$q$;
update app.topic_explainers set
  core_idea = $q$- The Second Derivative Test only applies when f''(c) is nonzero.
- If f''(c)=0, the test is explicitly inconclusive.
- Treating that inconclusive result as if it still classified the point (rather than falling back to the First Derivative Test) is the topic's most common error.$q$,
  what_students_need_to_understand = $q$- When f'(c)=0 and f''(c)>0, c is a local minimum; when f''(c)<0, c is a local maximum.
- But when f''(c)=0, the test gives no information at all.
- The correct response is to abandon it and check the sign change of f' directly instead of forcing a conclusion from an inconclusive result.$q$,
  how_this_becomes_points = $q$1. Check whether f''(c) is actually nonzero before applying the classification rule.
2. Switch to the First Derivative Test when f''(c)=0.
3. Reporting a classification from an inconclusive f''(c)=0 result does not earn the point, regardless of whether the classification is coincidentally correct.$q$,
  point_attaining_answer = $q$1. k'(x)=4x^3=0 gives the critical point x=0.
2. k''(x)=12x^2, so k''(0)=0 and the Second Derivative Test is inconclusive.
3. Falling back to the First Derivative Test: k'(x)=4x^3 is negative for x<0 and positive for x>0, so x=0 is a local minimum by that test instead.$q$,
  weak_answer = $q$k''(0)=12(0)^2=0, and the response states that since f''(0) is not negative, x=0 must be a local minimum, treating the inconclusive result as if it still supported a conclusion.$q$,
  source_note = coalesce(source_note,'') || $q$ Primes restored 2026-11-13: second-derivative notation (f'', h'', k'', m'', A'') had lost a prime in the stored text; only prime counts changed. Checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/structured-explainers-rest-2026-11-13/.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.7' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='10df60ca40bd326985b633a62c323a0f'
  and weak_answer = $q$k'(0)=12(0)^2=0, and the response states that since f'(0) is not negative, x=0 must be a local minimum, treating the inconclusive result as if it still supported a conclusion.$q$;
update app.topic_explainers set
  core_idea = $q$- A graph sketch of f is only as good as the derivative evidence behind it.
- Every increasing/decreasing interval, extremum, concavity interval, and inflection point drawn must trace back to an explicit sign chart for f' and f''.
- It must not come from what the curve intuitively looks like it should do.$q$,
  what_students_need_to_understand = $q$- Sketching coordinates three separate pieces of derivative evidence at once: the sign of f' locates increasing/decreasing intervals and extrema.
- The sign of f'' locates concavity intervals and inflection points.
- The two sign charts must agree with each other everywhere the sketch is drawn.$q$,
  how_this_becomes_points = $q$1. Annotate the sign charts for f' and f'' before drawing.
2. Produce a sketch whose increasing/decreasing behavior, extrema, concavity, and inflection points all match that annotated evidence.
3. A sketch produced from intuition, without a derivative sign chart behind each feature, does not earn the point.$q$,
  point_attaining_answer = $q$1. m'(x)=-3x^2+3=-3(x-1)(x+1).
2. Testing m'(-2)=-9, m'(0)=3, m'(2)=-9 gives sign pattern negative-positive-negative, so m has a local min at x=-1 (m(-1)=-2) and a local max at x=1 (m(1)=2).
3. m''(x)=-6x is positive for x<0 and negative for x>0, giving an inflection point at x=0 (m(0)=0).
4. The sketch is drawn to match exactly these labeled features.$q$,
  weak_answer = $q$The response draws a smooth S-shaped curve through a few plotted points and labels a high point and low point by eye, without computing m'(x) or m''(x) anywhere to justify their locations.$q$,
  source_note = coalesce(source_note,'') || $q$ Primes restored 2026-11-13: second-derivative notation (f'', h'', k'', m'', A'') had lost a prime in the stored text; only prime counts changed. Checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/structured-explainers-rest-2026-11-13/.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.8' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='87a1cce2a527e8f5824d533f5cd963c3'
  and weak_answer = $q$The response draws a smooth S-shaped curve through a few plotted points and labels a high point and low point by eye, without computing m'(x) or m'(x) anywhere to justify their locations.$q$;
update app.topic_explainers set
  core_idea = $q$- The CED's own guidance for this unit is explicit: refer to f, f', and f'' by name, never as "it" or "the function".
- When a graph shown is of f' itself, that graph's own peaks and valleys are not the extrema of f.
- They are the points where f''=0, which locate inflection points of f, not local maxima or minima of f.$q$,
  what_students_need_to_understand = $q$- Extrema of f occur where the graph of f' crosses zero (changes sign).
- Inflection points of f occur where the graph of f' itself has a peak or valley (since that is where f'', the slope of f', equals zero).
- Confusing a feature of the f' graph for a feature of the f graph produces a specific, predictable, and named misclassification.$q$,
  how_this_becomes_points = $q$1. Identify which graph is actually given (f, f', or f'').
2. Translate its features correctly into statements about f.
3. Reading an extremum of the f' graph itself as an extremum of f, instead of as an inflection point of f, does not earn the point.$q$,
  point_attaining_answer = $q$1. f'(x)=4-x^2 changes sign from negative to positive at x=-2 (local min of f) and from positive to negative at x=2 (local max of f).
2. f''(x)=-2x, so f''(0)=0 with f'' changing from positive to negative there, giving an inflection point of f at x=0.
3. The peak of the given f' graph corresponds to an inflection point of f, not an extremum of f.$q$,
  source_note = coalesce(source_note,'') || $q$ Primes restored 2026-11-13: second-derivative notation (f'', h'', k'', m'', A'') had lost a prime in the stored text; only prime counts changed. Checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/structured-explainers-rest-2026-11-13/.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.9' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='f6ab66016c9e2babdcb7fff0a58326c1';
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
2. A''(x)=-4<0 confirms a maximum at x=10 (or comparing A(0)=0, A(20)=0, A(10)=200 confirms it directly).
3. With x=10, y=40-2(10)=20, so the maximum possible area is 200 square feet, achieved when the fenced sides are 10 ft and 20 ft.$q$,
  source_note = coalesce(source_note,'') || $q$ Primes restored 2026-11-13: second-derivative notation (f'', h'', k'', m'', A'') had lost a prime in the stored text; only prime counts changed. Checked by openai/gpt-6.1-sol and moonshotai/kimi-k3.1-pro; scripts/content-seed/structured-explainers-rest-2026-11-13/.$q$
where subject_key='ap_calculus_ab' and unit_number=5 and topic_code='5.11' and status='published'
  and md5(core_idea||'|'||what_students_need_to_understand||'|'||how_this_becomes_points||'|'||point_attaining_answer)='0b560b411dd4abc8d6d172a10da8fdef';
do $$ begin if (select count(*) from app.topic_explainers where subject_key='ap_calculus_ab' and topic_code in ('5.6','5.7','5.8','5.9','5.11') and source_note like '%Primes restored 2026-11-13%')<>5 then raise exception 'expected 5 rows updated'; end if; end $$;
commit;
