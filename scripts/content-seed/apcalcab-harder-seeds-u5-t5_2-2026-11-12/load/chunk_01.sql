begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b8-h-5.2-a','apcalcab-mcq-b8-sv-h-5.2-a-v1','apcalcab-mcq-b8-sv-h-5.2-a-v2','apcalcab-mcq-b8-sv-h-5.2-a-v3','apcalcab-mcq-b8-h-5.2-b','apcalcab-mcq-b8-sv-h-5.2-b-v1','apcalcab-mcq-b8-sv-h-5.2-b-v2','apcalcab-mcq-b8-sv-h-5.2-b-v3','apcalcab-mcq-b8-h-5.2-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b8-h-5.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-h-5.2-a', 'mcq', 'apply Extreme Value Theorem hypotheses', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On [-1,1], let f(x)=x² for x≠0 and f(0)=1. A student invokes the Extreme Value Theorem to claim both absolute extrema exist. Which assessment is correct?', null, md5('apcalcab-mcq-b8-h-5.2-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The theorem applies because f is defined at every x, and the absolute minimum is 0 at x=0.', false, 'Being defined everywhere is not the same as continuity, and f(0)=1 rather than 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The theorem does not apply because f is discontinuous at 0; f has absolute maximum 1 but no absolute minimum on [-1,1].', true, 'Correct: As x approaches 0, x² approaches 0 but f(0)=1, so continuity fails. Every value is positive and values approach 0 without reaching it; the maximum 1 is attained at 0 and both endpoints.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The theorem does not apply, so neither an absolute maximum nor an absolute minimum can exist.', false, 'Failure of EVT removes a guarantee; a maximum can still exist, and here it equals 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The theorem applies because differentiability is unnecessary, and both extrema occur at the endpoints.', false, 'EVT requires continuity, which fails at 0; endpoints alone do not supply a minimum here.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.2-a-v1', 'mcq', 'apply Extreme Value Theorem hypotheses (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x)=1/x on the closed interval [1,4]. Which conclusion correctly uses the Extreme Value Theorem and the function''s behavior?', null, md5('apcalcab-mcq-b8-sv-h-5.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'EVT fails because g is undefined at x=0, even though 0 is outside [1,4].', false, 'A discontinuity outside the interval does not violate continuity on [1,4].' from version_ins
union all select gen_random_uuid(), id, 'B', 'EVT guarantees extrema only when the derivative is zero at an interior point.', false, 'EVT needs closed-interval continuity, not an interior stationary point; extrema can be endpoints.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both extreme values occur at x=0 because the derivative is undefined there.', false, 'X=0 is outside the domain interval and cannot supply an extremum on [1,4].' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is continuous on [1,4], so EVT applies; its absolute maximum is 1 at x=1 and its absolute minimum is 1/4 at x=4.', true, 'Correct: The interval [1,4] excludes the discontinuity at 0; 1/x is continuous there and decreasing, so endpoint values 1 and 1/4 are the absolute extrema.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.2-a-v2', 'mcq', 'apply Extreme Value Theorem hypotheses (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h(x)=x is considered on [0,2), including 0 but excluding 2. Which statement about its greatest value and EVT is correct?', null, md5('apcalcab-mcq-b8-sv-h-5.2-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'EVT does not apply because the interval is not closed; h has a minimum 0, but no maximum because values approach 2 without attaining it.', true, 'Correct: The endpoint 2 is absent, so [0,2) is not a closed interval. h(0)=0 is attained, while values can be arbitrarily close to 2 without equaling it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'EVT applies because h is continuous, and the maximum is 2 at x=2.', false, 'Continuity alone is insufficient for EVT on a nonclosed interval, and x=2 is excluded.' from version_ins
union all select gen_random_uuid(), id, 'C', 'EVT does not apply, so h cannot have either a minimum or maximum.', false, 'No EVT guarantee does not rule out the actual minimum at the included endpoint 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The maximum is 1 because 2 is not included in the interval.', false, 'Values such as 1.5 exceed 1, and there is no greatest value below 2.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.2-a-v3', 'mcq', 'apply Extreme Value Theorem hypotheses (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For p(x)=x² on [-1,2], which explanation correctly separates the Extreme Value Theorem from locating the extrema?', null, md5('apcalcab-mcq-b8-sv-h-5.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'EVT guarantees that both extrema must be at endpoints, so the minimum is 1 at x=-1.', false, 'EVT guarantees existence, not that extrema are restricted to endpoints; x=0 is smaller.' from version_ins
union all select gen_random_uuid(), id, 'B', 'EVT does not apply because p''(0)=0, creating a critical point.', false, 'A zero derivative is allowed under EVT, which requires continuity only.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Continuity on the closed interval guarantees both extrema; checking the graph or values shows absolute minimum 0 at x=0 and maximum 4 at x=2.', true, 'Correct: x² is continuous on [-1,2], so existence follows from EVT. The interior value p(0)=0 is below endpoint values 1 and 4; p(2)=4 is greatest.' from version_ins
union all select gen_random_uuid(), id, 'D', 'EVT states that the maximum and minimum values must be equal for a continuous function.', false, 'EVT makes no claim that the extreme values coincide; here they are 0 and 4.' from version_ins;
-- apcalcab-mcq-b8-h-5.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-h-5.2-b', 'mcq', 'distinguish critical points and local extrema', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For f(x)=x³ on (-2,2), a student says x=0 is a local extremum because f''(0)=0. Which response is correct?', null, md5('apcalcab-mcq-b8-h-5.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Every point with derivative 0 is both a local maximum and a local minimum.', false, 'The definition of critical point does not guarantee a local extremum; f continues increasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=0 is a critical point but not a local extremum: f is increasing through 0, so the derivative''s zero does not force a turn.', true, 'Correct: f''(x)=3x², so f''(0)=0 makes 0 critical. But f values change from negative to positive through 0, so 0 is neither a local high nor low.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=0 is not a critical point because f is differentiable there.', false, 'A critical point can have derivative zero at a differentiable point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=0 is an absolute maximum because f(0)=0.', false, 'Nearby positive x-values have f(x)>0, so f(0) is not a maximum.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.2-b-v1', 'mcq', 'distinguish critical points and local extrema (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For g(x)=|x-1| on (0,2), which classification of x=1 is justified?', null, md5('apcalcab-mcq-b8-sv-h-5.2-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=1 is a critical point and local minimum even though g''(1) does not exist; the graph decreases before 1 and increases after.', true, 'Correct: The cusp at 1 lies in the domain and has no derivative, satisfying the critical-point definition. |x-1| is 0 there and positive at nearby points, so it is a local minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=1 cannot be critical because the derivative is undefined rather than zero.', false, 'A critical point includes an interior domain point where the derivative is zero or undefined.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=1 is a local maximum because the left and right slopes have opposite signs.', false, 'The function falls toward 1 and rises afterward, making a minimum rather than a maximum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The function has no extrema because it is not differentiable at x=1.', false, 'Differentiability is not required for a local extremum; the cusp is the lowest nearby point.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.2-b-v2', 'mcq', 'distinguish critical points and local extrema (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x)=x^(1/3) on (-1,1), using the real cube root. At x=0 the derivative is undefined. What follows?', null, md5('apcalcab-mcq-b8-sv-h-5.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=0 is not critical because h is continuous there.', false, 'Continuity does not prevent a point with undefined derivative from being critical.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=0 is critical but not a local extremum because h increases through 0 despite its vertical tangent.', true, 'Correct: The function is defined at 0, and h''(0) is undefined, so 0 is critical. Real cube root increases on both sides of 0; nearby negative and positive values bracket h(0), ruling out an extremum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=0 is a local maximum because the derivative is undefined.', false, 'An undefined derivative alone cannot establish a local maximum when nearby values exceed h(0).' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=0 is a local minimum because h(0)=0.', false, 'Nearby negative values are below h(0), so it is not a local minimum either.' from version_ins;
-- apcalcab-mcq-b8-sv-h-5.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-sv-h-5.2-b-v3', 'mcq', 'distinguish critical points and local extrema (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For q(x)=x⁴-2x² on (-2,2), a student finds critical points at -1, 0, and 1 and claims all are local minima. Which correction is valid?', null, md5('apcalcab-mcq-b8-sv-h-5.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-1 and 1 are local minima, but 0 is a local maximum; all three are critical because q''(x)=4x(x²-1).', true, 'Correct: q''(x)=4x(x²-1), so the critical points are -1,0,1. q(±1)=-1 and q(0)=0; in nearby regions the graph rises from -1 to 0 then falls to 1, so 0 is locally high and ±1 locally low.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only 0 is critical because the derivative is zero there.', false, 'The derivative equation has all three listed roots, not just 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three are local maxima because the derivative vanishes at all three.', false, 'A zero derivative identifies candidates; q values and neighboring behavior show different extremum types.' from version_ins
union all select gen_random_uuid(), id, 'D', 'None is a local extremum because polynomial derivatives exist everywhere.', false, 'Differentiable polynomials can have local extrema where their derivative equals zero.' from version_ins;
-- apcalcab-mcq-b8-h-5.2-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b8-h-5.2-c', 'mcq', 'compare local and absolute extrema', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function on [-2,2] is strictly decreasing, increasing, decreasing, then increasing on successive intervals cut by x=-1,0,1. Its values at x=-2,-1,0,1,2 are 4,0,3,1,5. Which statement is correct?', null, md5('apcalcab-mcq-b8-h-5.2-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=1 is the absolute minimum because it is an interior local minimum.', false, 'F(1)=1 exceeds f(-1)=0, so the local minimum at 1 is not absolute.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=0 is the absolute maximum because it is the only interior local maximum.', false, 'The interior local peak f(0)=3 is below the endpoint value f(2)=5, so it is not the absolute maximum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-1 is an interior local and absolute minimum; x=2 is the absolute maximum, even though it is an endpoint.', true, 'Correct: The monotonicity on each segment leaves the smallest listed/possible value 0 at -1 and largest 5 at endpoint 2. x=1 is only a higher local minimum and x=0 a lower local maximum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The absolute maximum must occur at a critical point inside the interval.', false, 'An absolute extremum can occur at a closed interval endpoint; interior critical points are not the only candidates.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b8-h-5.2-a','apcalcab-mcq-b8-sv-h-5.2-a-v1','apcalcab-mcq-b8-sv-h-5.2-a-v2','apcalcab-mcq-b8-sv-h-5.2-a-v3','apcalcab-mcq-b8-h-5.2-b','apcalcab-mcq-b8-sv-h-5.2-b-v1','apcalcab-mcq-b8-sv-h-5.2-b-v2','apcalcab-mcq-b8-sv-h-5.2-b-v3','apcalcab-mcq-b8-h-5.2-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b8-h-5.2-a','apcalcab-mcq-b8-sv-h-5.2-a-v1','apcalcab-mcq-b8-sv-h-5.2-a-v2','apcalcab-mcq-b8-sv-h-5.2-a-v3','apcalcab-mcq-b8-h-5.2-b','apcalcab-mcq-b8-sv-h-5.2-b-v1','apcalcab-mcq-b8-sv-h-5.2-b-v2','apcalcab-mcq-b8-sv-h-5.2-b-v3','apcalcab-mcq-b8-h-5.2-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
