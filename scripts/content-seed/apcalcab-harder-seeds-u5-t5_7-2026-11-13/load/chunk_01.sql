begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b14-h-5.7-a','apcalcab-mcq-b14-sv-h-5.7-a-v1','apcalcab-mcq-b14-sv-h-5.7-a-v2','apcalcab-mcq-b14-sv-h-5.7-a-v3','apcalcab-mcq-b14-h-5.7-b','apcalcab-mcq-b14-sv-h-5.7-b-v1','apcalcab-mcq-b14-sv-h-5.7-b-v2','apcalcab-mcq-b14-sv-h-5.7-b-v3','apcalcab-mcq-b14-h-5.7-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b14-h-5.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-h-5.7-a', 'mcq', 'classify two critical points with f''''', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''(x)=1(x−(-2))(x−(1)) on an interval containing both zeros, with -2<1. What does the second derivative test establish at the two critical points?', null, md5('apcalcab-mcq-b14-h-5.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local minimum at x=-2 and a local maximum at x=1.', false, 'This reverses the signs of f'''' at the two critical points.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A local maximum at x=-2 and a local minimum at x=1.', true, 'Correct: Differentiating gives f''''(x)=1(2x−(-2)−(1)). Thus f''''(-2)=-3 and f''''(1)=3; their opposite signs classify the two extrema.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both zeros are local minima because f'' is zero at each.', false, 'A zero of f'' only identifies a candidate; the opposite second-derivative signs yield opposite types.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The test is inconclusive at both points because f'''' is not given directly.', false, 'F'''' can be calculated by differentiating the given f'', so the test is conclusive at both points.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-a-v1', 'mcq', 'classify two critical points with f'''' (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''(x)=-1(x−(-3))(x−(2)) on an interval containing both zeros, with -3<2. What does the second derivative test establish at the two critical points?', null, md5('apcalcab-mcq-b14-sv-h-5.7-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local maximum at x=-3 and a local minimum at x=2.', false, 'This reverses the signs of f'''' at the two critical points.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both zeros are local minima because f'' is zero at each.', false, 'A zero of f'' only identifies a candidate; the opposite second-derivative signs yield opposite types.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The test is inconclusive at both points because f'''' is not given directly.', false, 'F'''' can be calculated by differentiating the given f'', so the test is conclusive at both points.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A local minimum at x=-3 and a local maximum at x=2.', true, 'Correct: Differentiating gives f''''(x)=-1(2x−(-3)−(2)). Thus f''''(-3)=5 and f''''(2)=-5; their opposite signs classify the two extrema.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-a-v2', 'mcq', 'classify two critical points with f'''' (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''(x)=2(x−(0))(x−(4)) on an interval containing both zeros, with 0<4. What does the second derivative test establish at the two critical points?', null, md5('apcalcab-mcq-b14-sv-h-5.7-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local maximum at x=0 and a local minimum at x=4.', true, 'Correct: Differentiating gives f''''(x)=2(2x−(0)−(4)). Thus f''''(0)=-8 and f''''(4)=8; their opposite signs classify the two extrema.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A local minimum at x=0 and a local maximum at x=4.', false, 'This reverses the signs of f'''' at the two critical points.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both zeros are local minima because f'' is zero at each.', false, 'A zero of f'' only identifies a candidate; the opposite second-derivative signs yield opposite types.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The test is inconclusive at both points because f'''' is not given directly.', false, 'F'''' can be calculated by differentiating the given f'', so the test is conclusive at both points.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-a-v3', 'mcq', 'classify two critical points with f'''' (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''(x)=-2(x−(-1))(x−(3)) on an interval containing both zeros, with -1<3. What does the second derivative test establish at the two critical points?', null, md5('apcalcab-mcq-b14-sv-h-5.7-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A local maximum at x=-1 and a local minimum at x=3.', false, 'This reverses the signs of f'''' at the two critical points.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both zeros are local minima because f'' is zero at each.', false, 'A zero of f'' only identifies a candidate; the opposite second-derivative signs yield opposite types.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A local minimum at x=-1 and a local maximum at x=3.', true, 'Correct: Differentiating gives f''''(x)=-2(2x−(-1)−(3)). Thus f''''(-1)=8 and f''''(3)=-8; their opposite signs classify the two extrema.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The test is inconclusive at both points because f'''' is not given directly.', false, 'F'''' can be calculated by differentiating the given f'', so the test is conclusive at both points.' from version_ins;
-- apcalcab-mcq-b14-h-5.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-h-5.7-b', 'mcq', 'resolve an inconclusive second derivative test', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For g(x)=1(x−(1))^4, a student finds g''(1)=0 and g''''(1)=0. Which conclusion is justified about x=1, and why is the second derivative test alone insufficient?', null, md5('apcalcab-mcq-b14-h-5.7-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=1 must be a local minimum because g''''(1)=0 and zero counts as nonnegative.', false, 'The test requires a strictly positive second derivative for a minimum; zero is inconclusive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=1 is a local minimum; the even power and positive coefficient make g(x) greater than g(a) on both sides, while g''''(1)=0 makes the second derivative test inconclusive.', true, 'Correct: At x=1, the first two derivatives vanish. The sign of 1(x−(1))^4 relative to g(1)=0 on either side shows minimum; zero second derivative alone does not classify it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=1 must be a local maximum because g''(1)=0 and g''''(1)=0.', false, 'Vanishing first and second derivatives do not establish a maximum; inspect the function or derivative sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No conclusion about the actual function can be drawn by any method because the second derivative test is inconclusive.', false, 'An inconclusive test does not prohibit using the function''s explicit power and sign to classify the point.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-b-v1', 'mcq', 'resolve an inconclusive second derivative test (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For g(x)=-1(x−(-2))^4, a student finds g''(-2)=0 and g''''(-2)=0. Which conclusion is justified about x=-2, and why is the second derivative test alone insufficient?', null, md5('apcalcab-mcq-b14-sv-h-5.7-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-2 is a local maximum; the even power and negative coefficient make g(x) less than g(a) on both sides, while g''''(-2)=0 makes the second derivative test inconclusive.', true, 'Correct: At x=-2, the first two derivatives vanish. The sign of -1(x−(-2))^4 relative to g(-2)=0 on either side shows maximum; zero second derivative alone does not classify it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-2 must be a local minimum because g''''(-2)=0 and zero counts as nonnegative.', false, 'The test requires a strictly positive second derivative for a minimum; zero is inconclusive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-2 must be a local maximum because g''(-2)=0 and g''''(-2)=0.', false, 'Vanishing first and second derivatives do not establish a maximum; inspect the function or derivative sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No conclusion about the actual function can be drawn by any method because the second derivative test is inconclusive.', false, 'An inconclusive test does not prohibit using the function''s explicit power and sign to classify the point.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-b-v2', 'mcq', 'resolve an inconclusive second derivative test (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For g(x)=1(x−(3))^3, a student finds g''(3)=0 and g''''(3)=0. Which conclusion is justified about x=3, and why is the second derivative test alone insufficient?', null, md5('apcalcab-mcq-b14-sv-h-5.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=3 must be a local minimum because g''''(3)=0 and zero counts as nonnegative.', false, 'The test requires a strictly positive second derivative for a minimum; zero is inconclusive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=3 is neither a local maximum nor a local minimum; the odd power makes g(x) pass through g(a) with opposite signs on the two sides, while g''''(3)=0 makes the second derivative test inconclusive.', true, 'Correct: At x=3, the first two derivatives vanish. The sign of 1(x−(3))^3 relative to g(3)=0 on either side shows neither; zero second derivative alone does not classify it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=3 must be a local maximum because g''(3)=0 and g''''(3)=0.', false, 'Vanishing first and second derivatives do not establish a maximum; inspect the function or derivative sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No conclusion about the actual function can be drawn by any method because the second derivative test is inconclusive.', false, 'An inconclusive test does not prohibit using the function''s explicit power and sign to classify the point.' from version_ins;
-- apcalcab-mcq-b14-sv-h-5.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-sv-h-5.7-b-v3', 'mcq', 'resolve an inconclusive second derivative test (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For g(x)=-1(x−(-1))^5, a student finds g''(-1)=0 and g''''(-1)=0. Which conclusion is justified about x=-1, and why is the second derivative test alone insufficient?', null, md5('apcalcab-mcq-b14-sv-h-5.7-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-1 is neither a local maximum nor a local minimum; the odd power makes g(x) pass through g(a) with opposite signs on the two sides, while g''''(-1)=0 makes the second derivative test inconclusive.', true, 'Correct: At x=-1, the first two derivatives vanish. The sign of -1(x−(-1))^5 relative to g(-1)=0 on either side shows neither; zero second derivative alone does not classify it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-1 must be a local minimum because g''''(-1)=0 and zero counts as nonnegative.', false, 'The test requires a strictly positive second derivative for a minimum; zero is inconclusive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-1 must be a local maximum because g''(-1)=0 and g''''(-1)=0.', false, 'Vanishing first and second derivatives do not establish a maximum; inspect the function or derivative sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No conclusion about the actual function can be drawn by any method because the second derivative test is inconclusive.', false, 'An inconclusive test does not prohibit using the function''s explicit power and sign to classify the point.' from version_ins;
-- apcalcab-mcq-b14-h-5.7-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b14-h-5.7-c', 'mcq', 'infer a global extremum from one critical point', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function h is differentiable for every real x and has h''(x)=1(x−(-2))/(1+x²). This is its only critical point. What can be concluded about x=-2 using the second derivative test together with the one-critical-point result?', null, md5('apcalcab-mcq-b14-h-5.7-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h has a local maximum at x=-2, and it is also an absolute maximum because the denominator is positive.', false, 'The sign of h'''' at the critical point is reversed here, so the local type is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h has a local minimum at x=-2, but it cannot be an absolute extremum because the real-line interval has no endpoints.', false, 'A continuous function with only this critical point and a local extremum has the same absolute extremum on its real-line domain; endpoints are not required.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h has a local minimum at x=-2, and it is also an absolute minimum on the real line.', true, 'Correct: h''''(-2)=1/(1+-2²), with sign positive. The denominator of h'' is always positive, so h'' changes negative to positive at its unique zero; the local minimum is absolute.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h has no extremum at x=-2 because the first derivative vanishes there.', false, 'A zero first derivative is a critical point, and the nonzero second derivative classifies an extremum.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b14-h-5.7-a','apcalcab-mcq-b14-sv-h-5.7-a-v1','apcalcab-mcq-b14-sv-h-5.7-a-v2','apcalcab-mcq-b14-sv-h-5.7-a-v3','apcalcab-mcq-b14-h-5.7-b','apcalcab-mcq-b14-sv-h-5.7-b-v1','apcalcab-mcq-b14-sv-h-5.7-b-v2','apcalcab-mcq-b14-sv-h-5.7-b-v3','apcalcab-mcq-b14-h-5.7-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b14-h-5.7-a','apcalcab-mcq-b14-sv-h-5.7-a-v1','apcalcab-mcq-b14-sv-h-5.7-a-v2','apcalcab-mcq-b14-sv-h-5.7-a-v3','apcalcab-mcq-b14-h-5.7-b','apcalcab-mcq-b14-sv-h-5.7-b-v1','apcalcab-mcq-b14-sv-h-5.7-b-v2','apcalcab-mcq-b14-sv-h-5.7-b-v3','apcalcab-mcq-b14-h-5.7-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
