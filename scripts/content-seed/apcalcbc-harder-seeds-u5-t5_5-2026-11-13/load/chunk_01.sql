begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b12-h-5.5-a','apcalcbc-mcq-b12-sv-h-5.5-a-v1','apcalcbc-mcq-b12-sv-h-5.5-a-v2','apcalcbc-mcq-b12-sv-h-5.5-a-v3','apcalcbc-mcq-b12-h-5.5-b','apcalcbc-mcq-b12-sv-h-5.5-b-v1','apcalcbc-mcq-b12-sv-h-5.5-b-v2','apcalcbc-mcq-b12-sv-h-5.5-b-v3','apcalcbc-mcq-b12-h-5.5-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b12-h-5.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-h-5.5-a', 'mcq', 'compare endpoint and critical values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For f(x)=x³−3x on the closed interval [-3,2], a student finds f''(x)=3x²−3. Which statement gives every absolute maximum and every absolute minimum on the interval?', null, md5('apcalcbc-mcq-b12-h-5.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The absolute maximum is -18 at x=-3, and the absolute minimum is 2 at x=-1, x=2.', false, 'This reverses the meaning of largest and smallest candidate value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The absolute maximum is 2 at x=-1, x=2, and the absolute minimum is -18 at x=-3.', true, 'Correct: The candidates are the endpoints -3,2 and derivative zeros −1,1. Their function values in that order are -18,2,2,−2. Compare all values, retaining ties.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only x=−1 and x=1 need be compared because they are the zeros of f''.', false, 'The candidates test includes endpoints as well as interior critical points; an endpoint determines or ties an extremum here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The left endpoint is an absolute maximum and the right endpoint is an absolute minimum.', false, 'The left endpoint has a smaller value than the right endpoint here, so their proposed extremum types are reversed.' from version_ins;
-- apcalcbc-mcq-b12-sv-h-5.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-sv-h-5.5-a-v1', 'mcq', 'compare endpoint and critical values (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For f(x)=x³−3x on the closed interval [-2,3], a student finds f''(x)=3x²−3. Which statement gives every absolute maximum and every absolute minimum on the interval?', null, md5('apcalcbc-mcq-b12-sv-h-5.5-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The absolute maximum is -2 at x=-2, x=1, and the absolute minimum is 18 at x=3.', false, 'This reverses the meaning of largest and smallest candidate value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only x=−1 and x=1 need be compared because they are the zeros of f''.', false, 'The candidates test includes endpoints as well as interior critical points; an endpoint determines or ties an extremum here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The left endpoint is an absolute maximum and the right endpoint is an absolute minimum.', false, 'The left endpoint has a smaller value than the right endpoint here, so their proposed extremum types are reversed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The absolute maximum is 18 at x=3, and the absolute minimum is -2 at x=-2, x=1.', true, 'Correct: The candidates are the endpoints -2,3 and derivative zeros −1,1. Their function values in that order are -2,18,2,−2. Compare all values, retaining ties.' from version_ins;
-- apcalcbc-mcq-b12-sv-h-5.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-sv-h-5.5-a-v2', 'mcq', 'compare endpoint and critical values (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For f(x)=x³−3x on the closed interval [-3,3], a student finds f''(x)=3x²−3. Which statement gives every absolute maximum and every absolute minimum on the interval?', null, md5('apcalcbc-mcq-b12-sv-h-5.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The absolute maximum is 18 at x=3, and the absolute minimum is -18 at x=-3.', true, 'Correct: The candidates are the endpoints -3,3 and derivative zeros −1,1. Their function values in that order are -18,18,2,−2. Compare all values, retaining ties.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The absolute maximum is -18 at x=-3, and the absolute minimum is 18 at x=3.', false, 'This reverses the meaning of largest and smallest candidate value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only x=−1 and x=1 need be compared because they are the zeros of f''.', false, 'The candidates test includes endpoints as well as interior critical points; an endpoint determines or ties an extremum here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The left endpoint is an absolute maximum and the right endpoint is an absolute minimum.', false, 'The left endpoint has a smaller value than the right endpoint here, so their proposed extremum types are reversed.' from version_ins;
-- apcalcbc-mcq-b12-sv-h-5.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-sv-h-5.5-a-v3', 'mcq', 'compare endpoint and critical values (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For f(x)=x³−3x on the closed interval [-2,2], a student finds f''(x)=3x²−3. Which statement gives every absolute maximum and every absolute minimum on the interval?', null, md5('apcalcbc-mcq-b12-sv-h-5.5-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The absolute maximum is -2 at x=-2, x=1, and the absolute minimum is 2 at x=-1, x=2.', false, 'This reverses the meaning of largest and smallest candidate value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only x=−1 and x=1 need be compared because they are the zeros of f''.', false, 'The candidates test includes endpoints as well as interior critical points; an endpoint determines or ties an extremum here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The absolute maximum is 2 at x=-1, x=2, and the absolute minimum is -2 at x=-2, x=1.', true, 'Correct: The candidates are the endpoints -2,2 and derivative zeros −1,1. Their function values in that order are -2,2,2,−2. Compare all values, retaining ties.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The left endpoint is an absolute maximum and the right endpoint is an absolute minimum.', false, 'The left endpoint has a smaller value than the right endpoint here, so their proposed extremum types are reversed.' from version_ins;
-- apcalcbc-mcq-b12-h-5.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-h-5.5-b', 'mcq', 'include nondifferentiable candidates', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The continuous function g(x)=|x−(1)|+(-0.5)x is restricted to [0,4]. Its derivative is undefined at x=1 and nonzero at all other interior points. Which conclusion follows from the candidates test?', null, md5('apcalcbc-mcq-b12-h-5.5-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The derivative is undefined at the corner, so the absolute minimum must occur at one of the two endpoints.', false, 'An interior corner is a critical candidate when the derivative does not exist; it has the smallest evaluated value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The absolute minimum is -0.5 at x=1; the absolute maximum is 1 at x=0, x=4.', true, 'Correct: The only candidates are endpoint x=0, corner x=1, and endpoint x=4; their values are 1,-0.5,1. The function is continuous on the closed interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The corner x=1 is the absolute maximum because a sharp point always exceeds nearby values.', false, 'A corner can be a minimum; here both one-sided slopes point upward away from it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The candidates test cannot be used because g is not differentiable at every interior point.', false, 'Continuity on a closed interval permits the test; nondifferentiability adds the corner to the candidate list.' from version_ins;
-- apcalcbc-mcq-b12-sv-h-5.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-sv-h-5.5-b-v1', 'mcq', 'include nondifferentiable candidates (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The continuous function g(x)=|x−(2)|+(0.5)x is restricted to [-1,3]. Its derivative is undefined at x=2 and nonzero at all other interior points. Which conclusion follows from the candidates test?', null, md5('apcalcbc-mcq-b12-sv-h-5.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The absolute minimum is 1 at x=2; the absolute maximum is 2.5 at x=-1, x=3.', true, 'Correct: The only candidates are endpoint x=-1, corner x=2, and endpoint x=3; their values are 2.5,1,2.5. The function is continuous on the closed interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The derivative is undefined at the corner, so the absolute minimum must occur at one of the two endpoints.', false, 'An interior corner is a critical candidate when the derivative does not exist; it has the smallest evaluated value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The corner x=2 is the absolute maximum because a sharp point always exceeds nearby values.', false, 'A corner can be a minimum; here both one-sided slopes point upward away from it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The candidates test cannot be used because g is not differentiable at every interior point.', false, 'Continuity on a closed interval permits the test; nondifferentiability adds the corner to the candidate list.' from version_ins;
-- apcalcbc-mcq-b12-sv-h-5.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-sv-h-5.5-b-v2', 'mcq', 'include nondifferentiable candidates (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The continuous function g(x)=|x−(-1)|+(-0.5)x is restricted to [-3,2]. Its derivative is undefined at x=-1 and nonzero at all other interior points. Which conclusion follows from the candidates test?', null, md5('apcalcbc-mcq-b12-sv-h-5.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The derivative is undefined at the corner, so the absolute minimum must occur at one of the two endpoints.', false, 'An interior corner is a critical candidate when the derivative does not exist; it has the smallest evaluated value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The absolute minimum is 0.5 at x=-1; the absolute maximum is 3.5 at x=-3.', true, 'Correct: The only candidates are endpoint x=-3, corner x=-1, and endpoint x=2; their values are 3.5,0.5,2. The function is continuous on the closed interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The corner x=-1 is the absolute maximum because a sharp point always exceeds nearby values.', false, 'A corner can be a minimum; here both one-sided slopes point upward away from it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The candidates test cannot be used because g is not differentiable at every interior point.', false, 'Continuity on a closed interval permits the test; nondifferentiability adds the corner to the candidate list.' from version_ins;
-- apcalcbc-mcq-b12-sv-h-5.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-sv-h-5.5-b-v3', 'mcq', 'include nondifferentiable candidates (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The continuous function g(x)=|x−(0)|+(0.5)x is restricted to [-2,3]. Its derivative is undefined at x=0 and nonzero at all other interior points. Which conclusion follows from the candidates test?', null, md5('apcalcbc-mcq-b12-sv-h-5.5-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The absolute minimum is 0 at x=0; the absolute maximum is 4.5 at x=3.', true, 'Correct: The only candidates are endpoint x=-2, corner x=0, and endpoint x=3; their values are 1,0,4.5. The function is continuous on the closed interval.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The derivative is undefined at the corner, so the absolute minimum must occur at one of the two endpoints.', false, 'An interior corner is a critical candidate when the derivative does not exist; it has the smallest evaluated value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The corner x=0 is the absolute maximum because a sharp point always exceeds nearby values.', false, 'A corner can be a minimum; here both one-sided slopes point upward away from it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The candidates test cannot be used because g is not differentiable at every interior point.', false, 'Continuity on a closed interval permits the test; nondifferentiability adds the corner to the candidate list.' from version_ins;
-- apcalcbc-mcq-b12-h-5.5-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b12-h-5.5-c', 'mcq', 'interpret exhaustive candidate tables', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h is continuous on [0,5]. Its only interior critical points are x=1, where h''=0, and x=3, where h'' is undefined; h'' is nonzero and defined everywhere else inside the interval. The measured values are h(0)=2, h(1)=6, h(3)=-1, and h(5)=4. Which conclusion is justified?', null, md5('apcalcbc-mcq-b12-h-5.5-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both absolute extrema must occur at x=1, the only place where h''=0.', false, 'A derivative zero is only one candidate, and one point cannot simultaneously have the listed largest and smallest values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The value at x=3 must be discarded because h'' is undefined there.', false, 'An undefined derivative at an interior point makes it a candidate; the corner has a smallest value here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The absolute maximum is 6 at x=1, and the absolute minimum is -1 at x=3.', true, 'Correct: All candidates are 0,1,3,5; by hypothesis there are no other interior critical points. Their values are (2, 6, -1, 4). The largest is 6 and the smallest is -1; include ties.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The absolute extrema cannot be found without the formula for h between the listed points.', false, 'Continuity on the closed interval plus the exhaustive candidate list makes comparison of these four values sufficient.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b12-h-5.5-a','apcalcbc-mcq-b12-sv-h-5.5-a-v1','apcalcbc-mcq-b12-sv-h-5.5-a-v2','apcalcbc-mcq-b12-sv-h-5.5-a-v3','apcalcbc-mcq-b12-h-5.5-b','apcalcbc-mcq-b12-sv-h-5.5-b-v1','apcalcbc-mcq-b12-sv-h-5.5-b-v2','apcalcbc-mcq-b12-sv-h-5.5-b-v3','apcalcbc-mcq-b12-h-5.5-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b12-h-5.5-a','apcalcbc-mcq-b12-sv-h-5.5-a-v1','apcalcbc-mcq-b12-sv-h-5.5-a-v2','apcalcbc-mcq-b12-sv-h-5.5-a-v3','apcalcbc-mcq-b12-h-5.5-b','apcalcbc-mcq-b12-sv-h-5.5-b-v1','apcalcbc-mcq-b12-sv-h-5.5-b-v2','apcalcbc-mcq-b12-sv-h-5.5-b-v3','apcalcbc-mcq-b12-h-5.5-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
