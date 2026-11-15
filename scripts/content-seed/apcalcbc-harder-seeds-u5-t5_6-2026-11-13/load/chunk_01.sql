begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b13-h-5.6-a','apcalcbc-mcq-b13-sv-h-5.6-a-v1','apcalcbc-mcq-b13-sv-h-5.6-a-v2','apcalcbc-mcq-b13-sv-h-5.6-a-v3','apcalcbc-mcq-b13-h-5.6-b','apcalcbc-mcq-b13-sv-h-5.6-b-v1','apcalcbc-mcq-b13-sv-h-5.6-b-v2','apcalcbc-mcq-b13-sv-h-5.6-b-v3','apcalcbc-mcq-b13-h-5.6-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b13-h-5.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-h-5.6-a', 'mcq', 'interpret multiplicity in f''''', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f on all real numbers has f''''(x)=1(x−(-2))²(x−(1)), where -2<1. Which conclusion about concavity and inflection is justified?', null, md5('apcalcbc-mcq-b13-h-5.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both x=-2 and x=1 are inflection points because f'''' is zero at each.', false, 'A zero of the second derivative alone is insufficient; its sign does not change at the squared-factor root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph changes from concave down to concave up at x=1; x=-2 is not an inflection point.', true, 'Correct: The squared factor is nonnegative and does not change sign at -2. The simple factor changes sign at 1; f'''' has sign negative then positive across that point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Neither x=-2 nor x=1 can be an inflection point because f'''' is zero there.', false, 'A sign change of f'''' at the simple-factor root establishes an inflection point even though f'''' is zero there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph changes from concave up to concave down at x=1, and x=-2 is not an inflection point.', false, 'This reverses the sign of f'''' on either side of the simple-factor root.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-a-v1', 'mcq', 'interpret multiplicity in f'''' (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f on all real numbers has f''''(x)=-1(x−(-3))²(x−(2)), where -3<2. Which conclusion about concavity and inflection is justified?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both x=-3 and x=2 are inflection points because f'''' is zero at each.', false, 'A zero of the second derivative alone is insufficient; its sign does not change at the squared-factor root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Neither x=-3 nor x=2 can be an inflection point because f'''' is zero there.', false, 'A sign change of f'''' at the simple-factor root establishes an inflection point even though f'''' is zero there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph changes from concave down to concave up at x=2, and x=-3 is not an inflection point.', false, 'This reverses the sign of f'''' on either side of the simple-factor root.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph changes from concave up to concave down at x=2; x=-3 is not an inflection point.', true, 'Correct: The squared factor is nonnegative and does not change sign at -3. The simple factor changes sign at 2; f'''' has sign positive then negative across that point.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-a-v2', 'mcq', 'interpret multiplicity in f'''' (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f on all real numbers has f''''(x)=2(x−(0))²(x−(4)), where 0<4. Which conclusion about concavity and inflection is justified?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph changes from concave down to concave up at x=4; x=0 is not an inflection point.', true, 'Correct: The squared factor is nonnegative and does not change sign at 0. The simple factor changes sign at 4; f'''' has sign negative then positive across that point.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both x=0 and x=4 are inflection points because f'''' is zero at each.', false, 'A zero of the second derivative alone is insufficient; its sign does not change at the squared-factor root.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Neither x=0 nor x=4 can be an inflection point because f'''' is zero there.', false, 'A sign change of f'''' at the simple-factor root establishes an inflection point even though f'''' is zero there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph changes from concave up to concave down at x=4, and x=0 is not an inflection point.', false, 'This reverses the sign of f'''' on either side of the simple-factor root.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-a-v3', 'mcq', 'interpret multiplicity in f'''' (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f on all real numbers has f''''(x)=-2(x−(-1))²(x−(3)), where -1<3. Which conclusion about concavity and inflection is justified?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both x=-1 and x=3 are inflection points because f'''' is zero at each.', false, 'A zero of the second derivative alone is insufficient; its sign does not change at the squared-factor root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Neither x=-1 nor x=3 can be an inflection point because f'''' is zero there.', false, 'A sign change of f'''' at the simple-factor root establishes an inflection point even though f'''' is zero there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph changes from concave up to concave down at x=3; x=-1 is not an inflection point.', true, 'Correct: The squared factor is nonnegative and does not change sign at -1. The simple factor changes sign at 3; f'''' has sign positive then negative across that point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The graph changes from concave down to concave up at x=3, and x=-1 is not an inflection point.', false, 'This reverses the sign of f'''' on either side of the simple-factor root.' from version_ins;
-- apcalcbc-mcq-b13-h-5.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-h-5.6-b', 'mcq', 'infer concavity from f'' trends', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is differentiable on all real numbers and f'' is continuous. A graph of f'' shows that f'' is decreasing on (−∞,-2), increasing on (-2,1), and decreasing on (1,∞). No numerical values of f'' are supplied. Which conclusion follows?', null, md5('apcalcbc-mcq-b13-h-5.6-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph of f is increasing precisely on the intervals where f'' is increasing, and decreasing where f'' is decreasing.', false, 'Whether f increases depends on the sign of f'', not whether f'' itself rises or falls.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph of f is concave down, then up, then down on those three intervals; its concavity changes at x=-2 and x=1.', true, 'Correct: Concavity of f follows the trend of f'': increasing means up, decreasing means down. The trend sequence is decreasing, increasing, decreasing; only the stated changes in concavity are inflections.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph of f has local extrema at both x=-2 and x=1, because f'' changes its increasing/decreasing trend there.', false, 'A local extremum of f requires a sign switch of f'', which is not given by its increasing/decreasing trend alone.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No concavity conclusion is possible without the numerical values of f'' at the interval boundaries.', false, 'The direction of change of f'' suffices to infer concavity without knowing its numerical values.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-b-v1', 'mcq', 'infer concavity from f'' trends (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is differentiable on all real numbers and f'' is continuous. A graph of f'' shows that f'' is increasing on (−∞,-3), decreasing on (-3,2), and increasing on (2,∞). No numerical values of f'' are supplied. Which conclusion follows?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph of f is concave up, then down, then up on those three intervals; its concavity changes at x=-3 and x=2.', true, 'Correct: Concavity of f follows the trend of f'': increasing means up, decreasing means down. The trend sequence is increasing, decreasing, increasing; only the stated changes in concavity are inflections.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph of f is increasing precisely on the intervals where f'' is increasing, and decreasing where f'' is decreasing.', false, 'Whether f increases depends on the sign of f'', not whether f'' itself rises or falls.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph of f has local extrema at both x=-3 and x=2, because f'' changes its increasing/decreasing trend there.', false, 'A local extremum of f requires a sign switch of f'', which is not given by its increasing/decreasing trend alone.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No concavity conclusion is possible without the numerical values of f'' at the interval boundaries.', false, 'The direction of change of f'' suffices to infer concavity without knowing its numerical values.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-b-v2', 'mcq', 'infer concavity from f'' trends (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is differentiable on all real numbers and f'' is continuous. A graph of f'' shows that f'' is decreasing on (−∞,0), decreasing on (0,4), and increasing on (4,∞). No numerical values of f'' are supplied. Which conclusion follows?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph of f is increasing precisely on the intervals where f'' is increasing, and decreasing where f'' is decreasing.', false, 'Whether f increases depends on the sign of f'', not whether f'' itself rises or falls.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph of f is concave down, then down, then up on those three intervals; its concavity changes at x=4.', true, 'Correct: Concavity of f follows the trend of f'': increasing means up, decreasing means down. The trend sequence is decreasing, decreasing, increasing; only the stated changes in concavity are inflections.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph of f has local extrema at both x=0 and x=4, because f'' changes its increasing/decreasing trend there.', false, 'A local extremum of f requires a sign switch of f'', which is not given by its increasing/decreasing trend alone.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No concavity conclusion is possible without the numerical values of f'' at the interval boundaries.', false, 'The direction of change of f'' suffices to infer concavity without knowing its numerical values.' from version_ins;
-- apcalcbc-mcq-b13-sv-h-5.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-sv-h-5.6-b-v3', 'mcq', 'infer concavity from f'' trends (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is differentiable on all real numbers and f'' is continuous. A graph of f'' shows that f'' is increasing on (−∞,-1), increasing on (-1,3), and decreasing on (3,∞). No numerical values of f'' are supplied. Which conclusion follows?', null, md5('apcalcbc-mcq-b13-sv-h-5.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The graph of f is concave up, then up, then down on those three intervals; its concavity changes at x=3.', true, 'Correct: Concavity of f follows the trend of f'': increasing means up, decreasing means down. The trend sequence is increasing, increasing, decreasing; only the stated changes in concavity are inflections.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The graph of f is increasing precisely on the intervals where f'' is increasing, and decreasing where f'' is decreasing.', false, 'Whether f increases depends on the sign of f'', not whether f'' itself rises or falls.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The graph of f has local extrema at both x=-1 and x=3, because f'' changes its increasing/decreasing trend there.', false, 'A local extremum of f requires a sign switch of f'', which is not given by its increasing/decreasing trend alone.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No concavity conclusion is possible without the numerical values of f'' at the interval boundaries.', false, 'The direction of change of f'' suffices to infer concavity without knowing its numerical values.' from version_ins;
-- apcalcbc-mcq-b13-h-5.6-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b13-h-5.6-c', 'mcq', 'exclude domain gaps from inflection points', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is twice differentiable for all real x except x=0 and satisfies g''''(x)=1(x−(-2))(x−(3))/(x−(0))² on that domain, with -2<0<3. The function has no value at x=0. Which statement correctly describes concavity and inflection points?', null, md5('apcalcbc-mcq-b13-h-5.6-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflection points at x=-2, x=0, and x=3 because the displayed formula is zero or undefined at all three.', false, 'An inflection point must lie on the graph; g is undefined at the domain gap.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is concave down outside (-2,3) and concave up between the roots because the squared denominator is negative there.', false, 'A nonzero square is positive, so it does not reverse the numerator''s sign pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is concave up for x<-2 and x>3, concave down on (-2,0) and (0,3), and has inflection points at x=-2 and x=3 only.', true, 'Correct: The squared denominator is positive wherever defined. The numerator has sign positive, negative, positive across -2,3; the gap at 0 is not a point on the graph.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g has no inflection points because its domain is disconnected at x=0.', false, 'The domain gap does not prevent concavity from changing at the included points x=a and x=b.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b13-h-5.6-a','apcalcbc-mcq-b13-sv-h-5.6-a-v1','apcalcbc-mcq-b13-sv-h-5.6-a-v2','apcalcbc-mcq-b13-sv-h-5.6-a-v3','apcalcbc-mcq-b13-h-5.6-b','apcalcbc-mcq-b13-sv-h-5.6-b-v1','apcalcbc-mcq-b13-sv-h-5.6-b-v2','apcalcbc-mcq-b13-sv-h-5.6-b-v3','apcalcbc-mcq-b13-h-5.6-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b13-h-5.6-a','apcalcbc-mcq-b13-sv-h-5.6-a-v1','apcalcbc-mcq-b13-sv-h-5.6-a-v2','apcalcbc-mcq-b13-sv-h-5.6-a-v3','apcalcbc-mcq-b13-h-5.6-b','apcalcbc-mcq-b13-sv-h-5.6-b-v1','apcalcbc-mcq-b13-sv-h-5.6-b-v2','apcalcbc-mcq-b13-sv-h-5.6-b-v3','apcalcbc-mcq-b13-h-5.6-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
