begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b16-h-5.9-a','apcalcab-mcq-b16-sv-h-5.9-a-v1','apcalcab-mcq-b16-sv-h-5.9-a-v2','apcalcab-mcq-b16-sv-h-5.9-a-v3','apcalcab-mcq-b16-h-5.9-b','apcalcab-mcq-b16-sv-h-5.9-b-v1','apcalcab-mcq-b16-sv-h-5.9-b-v2','apcalcab-mcq-b16-sv-h-5.9-b-v3','apcalcab-mcq-b16-h-5.9-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-b16-h-5.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-h-5.9-a', 'mcq', 'connect f'' extrema and f inflections', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x)=1(x−(-2))³+(0)(x−(-2)) for all real x. Which description correctly links the graphs of f, f'', and f'''' at x=-2?', null, md5('apcalcab-mcq-b16-h-5.9-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum there because f'' has a local minimum there.', false, 'An extremum of f'' concerns the slope of f; f has an inflection here, and may have a nonzero slope.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a stationary inflection there; f'' has a local minimum there, and f'''' changes sign through zero.', true, 'Correct: f''=3(1)(x−(-2))²+(0), f''''=6(1)(x−(-2)). The linear f'''' changes sign at -2; f'' is quadratic with local minimum there; f''(-2)=0, so f is stationary.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'' has an inflection there because f'''' is zero there, while f has no concavity change.', false, 'A zero of f'''' with sign change makes an inflection of f, while f'' has a local extremum, not an inflection, here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f'''' has a local extremum there because its value is zero, so f cannot have an inflection.', false, 'The linear f'''' crosses zero rather than turning around; that crossing marks f''s concavity change.' from version_ins;
-- apcalcab-mcq-b16-sv-h-5.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-sv-h-5.9-a-v1', 'mcq', 'connect f'' extrema and f inflections (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x)=-1(x−(1))³+(0)(x−(1)) for all real x. Which description correctly links the graphs of f, f'', and f'''' at x=1?', null, md5('apcalcab-mcq-b16-sv-h-5.9-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local maximum there because f'' has a local maximum there.', false, 'An extremum of f'' concerns the slope of f; f has an inflection here, and may have a nonzero slope.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f'' has an inflection there because f'''' is zero there, while f has no concavity change.', false, 'A zero of f'''' with sign change makes an inflection of f, while f'' has a local extremum, not an inflection, here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'''' has a local extremum there because its value is zero, so f cannot have an inflection.', false, 'The linear f'''' crosses zero rather than turning around; that crossing marks f''s concavity change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has a stationary inflection there; f'' has a local maximum there, and f'''' changes sign through zero.', true, 'Correct: f''=3(-1)(x−(1))²+(0), f''''=6(-1)(x−(1)). The linear f'''' changes sign at 1; f'' is quadratic with local maximum there; f''(1)=0, so f is stationary.' from version_ins;
-- apcalcab-mcq-b16-sv-h-5.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-sv-h-5.9-a-v2', 'mcq', 'connect f'' extrema and f inflections (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x)=2(x−(0))³+(1)(x−(0)) for all real x. Which description correctly links the graphs of f, f'', and f'''' at x=0?', null, md5('apcalcab-mcq-b16-sv-h-5.9-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a nonstationary inflection there; f'' has a local minimum there, and f'''' changes sign through zero.', true, 'Correct: f''=3(2)(x−(0))²+(1), f''''=6(2)(x−(0)). The linear f'''' changes sign at 0; f'' is quadratic with local minimum there; f''(0)=1, so f is nonstationary.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local minimum there because f'' has a local minimum there.', false, 'An extremum of f'' concerns the slope of f; f has an inflection here, and may have a nonzero slope.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'' has an inflection there because f'''' is zero there, while f has no concavity change.', false, 'A zero of f'''' with sign change makes an inflection of f, while f'' has a local extremum, not an inflection, here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f'''' has a local extremum there because its value is zero, so f cannot have an inflection.', false, 'The linear f'''' crosses zero rather than turning around; that crossing marks f''s concavity change.' from version_ins;
-- apcalcab-mcq-b16-sv-h-5.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-sv-h-5.9-a-v3', 'mcq', 'connect f'' extrema and f inflections (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x)=-2(x−(3))³+(-1)(x−(3)) for all real x. Which description correctly links the graphs of f, f'', and f'''' at x=3?', null, md5('apcalcab-mcq-b16-sv-h-5.9-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local maximum there because f'' has a local maximum there.', false, 'An extremum of f'' concerns the slope of f; f has an inflection here, and may have a nonzero slope.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f'' has an inflection there because f'''' is zero there, while f has no concavity change.', false, 'A zero of f'''' with sign change makes an inflection of f, while f'' has a local extremum, not an inflection, here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has a nonstationary inflection there; f'' has a local maximum there, and f'''' changes sign through zero.', true, 'Correct: f''=3(-2)(x−(3))²+(-1), f''''=6(-2)(x−(3)). The linear f'''' changes sign at 3; f'' is quadratic with local maximum there; f''(3)=-1, so f is nonstationary.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f'''' has a local extremum there because its value is zero, so f cannot have an inflection.', false, 'The linear f'''' crosses zero rather than turning around; that crossing marks f''s concavity change.' from version_ins;
-- apcalcab-mcq-b16-h-5.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-h-5.9-b', 'mcq', 'locate f extrema using f'''' and f''', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''''(x)=2(x−(-1))(x−(2)) for all real x, where -1<2. Also f''(-1)=5 and f''(2)=-4. Which relationship among the three graphs is forced on (-1,2) and at its boundary points?', null, md5('apcalcab-mcq-b16-h-5.9-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has local extrema at both x=-1 and x=2 because f'''' is zero at those points.', false, 'F''''=0 can make an inflection of f, but the given f'' values at those points are nonzero, so neither is a local extremum of f.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f'' decreases from 5 to -4 and has exactly one zero inside (-1,2), giving f a local maximum there; f has inflections at x=-1 and x=2.', true, 'Correct: Between -1 and 2, f'''' has sign negative, so f'' is strictly monotone. Its endpoint values 5,-4 straddle zero, forcing exactly one zero, where f has a local maximum. f'''' changes sign at each boundary root.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'' cannot cross zero between -1 and 2 because f'''' has no zero strictly between them.', false, 'A monotone continuous f'' with endpoint values on opposite sides of zero must cross zero exactly once.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interior zero of f'' is an inflection of f, while x=a and x=b cannot be inflections because f'''' vanishes there.', false, 'At the interior zero, f'''' is nonzero, giving an extremum of f; f'''' changes sign at the two boundary roots, giving inflections there.' from version_ins;
-- apcalcab-mcq-b16-sv-h-5.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-sv-h-5.9-b-v1', 'mcq', 'locate f extrema using f'''' and f'' (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''''(x)=-2(x−(-3))(x−(0)) for all real x, where -3<0. Also f''(-3)=-4 and f''(0)=5. Which relationship among the three graphs is forced on (-3,0) and at its boundary points?', null, md5('apcalcab-mcq-b16-sv-h-5.9-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f'' increases from -4 to 5 and has exactly one zero inside (-3,0), giving f a local minimum there; f has inflections at x=-3 and x=0.', true, 'Correct: Between -3 and 0, f'''' has sign positive, so f'' is strictly monotone. Its endpoint values -4,5 straddle zero, forcing exactly one zero, where f has a local minimum. f'''' changes sign at each boundary root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has local extrema at both x=-3 and x=0 because f'''' is zero at those points.', false, 'F''''=0 can make an inflection of f, but the given f'' values at those points are nonzero, so neither is a local extremum of f.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'' cannot cross zero between -3 and 0 because f'''' has no zero strictly between them.', false, 'A monotone continuous f'' with endpoint values on opposite sides of zero must cross zero exactly once.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interior zero of f'' is an inflection of f, while x=a and x=b cannot be inflections because f'''' vanishes there.', false, 'At the interior zero, f'''' is nonzero, giving an extremum of f; f'''' changes sign at the two boundary roots, giving inflections there.' from version_ins;
-- apcalcab-mcq-b16-sv-h-5.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-sv-h-5.9-b-v2', 'mcq', 'locate f extrema using f'''' and f'' (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''''(x)=2(x−(0))(x−(3)) for all real x, where 0<3. Also f''(0)=4 and f''(3)=-5. Which relationship among the three graphs is forced on (0,3) and at its boundary points?', null, md5('apcalcab-mcq-b16-sv-h-5.9-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has local extrema at both x=0 and x=3 because f'''' is zero at those points.', false, 'F''''=0 can make an inflection of f, but the given f'' values at those points are nonzero, so neither is a local extremum of f.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f'' decreases from 4 to -5 and has exactly one zero inside (0,3), giving f a local maximum there; f has inflections at x=0 and x=3.', true, 'Correct: Between 0 and 3, f'''' has sign negative, so f'' is strictly monotone. Its endpoint values 4,-5 straddle zero, forcing exactly one zero, where f has a local maximum. f'''' changes sign at each boundary root.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'' cannot cross zero between 0 and 3 because f'''' has no zero strictly between them.', false, 'A monotone continuous f'' with endpoint values on opposite sides of zero must cross zero exactly once.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interior zero of f'' is an inflection of f, while x=a and x=b cannot be inflections because f'''' vanishes there.', false, 'At the interior zero, f'''' is nonzero, giving an extremum of f; f'''' changes sign at the two boundary roots, giving inflections there.' from version_ins;
-- apcalcab-mcq-b16-sv-h-5.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-sv-h-5.9-b-v3', 'mcq', 'locate f extrema using f'''' and f'' (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A twice-differentiable function f has f''''(x)=-2(x−(-2))(x−(1)) for all real x, where -2<1. Also f''(-2)=-5 and f''(1)=4. Which relationship among the three graphs is forced on (-2,1) and at its boundary points?', null, md5('apcalcab-mcq-b16-sv-h-5.9-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f'' increases from -5 to 4 and has exactly one zero inside (-2,1), giving f a local minimum there; f has inflections at x=-2 and x=1.', true, 'Correct: Between -2 and 1, f'''' has sign positive, so f'' is strictly monotone. Its endpoint values -5,4 straddle zero, forcing exactly one zero, where f has a local minimum. f'''' changes sign at each boundary root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has local extrema at both x=-2 and x=1 because f'''' is zero at those points.', false, 'F''''=0 can make an inflection of f, but the given f'' values at those points are nonzero, so neither is a local extremum of f.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f'' cannot cross zero between -2 and 1 because f'''' has no zero strictly between them.', false, 'A monotone continuous f'' with endpoint values on opposite sides of zero must cross zero exactly once.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The interior zero of f'' is an inflection of f, while x=a and x=b cannot be inflections because f'''' vanishes there.', false, 'At the interior zero, f'''' is nonzero, giving an extremum of f; f'''' changes sign at the two boundary roots, giving inflections there.' from version_ins;
-- apcalcab-mcq-b16-h-5.9-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b16-h-5.9-c', 'mcq', 'match trig graph landmarks', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval from x=0 to x=0+2π, let g(x)=1sin(x−(0)). Which interior features of the graphs of g, g'', and g'''' correspond?', null, md5('apcalcab-mcq-b16-h-5.9-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g has inflections at x=0+π/2 and x=0+3π/2, because g'' is zero there; g has an extremum at x=0+π.', false, 'Zeros of g'' locate extrema of g, whereas a sign change of g'''' locates an inflection of g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g has local extrema at all three listed interior points because either g'' or g'''' vanishes at each.', false, 'At the middle point g'' is nonzero, so g has no extremum there; g''''=0 alone does not mark an extremum of g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g has a local maximum at x=0+π/2 and a local minimum at x=0+3π/2; g has an inflection at x=0+π, where g'' has a local extremum.', true, 'Correct: g''=1cos(x−(0)), g''''=−1sin(x−(0)). The cosine zeros make g''s two extrema; g'''' changes sign at the middle point, where the cosine graph has an extremum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g cannot have an inflection at the middle point because g'''' is zero there.', false, 'G'''' changes sign at the middle point, which is the defining concavity change for an inflection.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b16-h-5.9-a','apcalcab-mcq-b16-sv-h-5.9-a-v1','apcalcab-mcq-b16-sv-h-5.9-a-v2','apcalcab-mcq-b16-sv-h-5.9-a-v3','apcalcab-mcq-b16-h-5.9-b','apcalcab-mcq-b16-sv-h-5.9-b-v1','apcalcab-mcq-b16-sv-h-5.9-b-v2','apcalcab-mcq-b16-sv-h-5.9-b-v3','apcalcab-mcq-b16-h-5.9-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b16-h-5.9-a','apcalcab-mcq-b16-sv-h-5.9-a-v1','apcalcab-mcq-b16-sv-h-5.9-a-v2','apcalcab-mcq-b16-sv-h-5.9-a-v3','apcalcab-mcq-b16-h-5.9-b','apcalcab-mcq-b16-sv-h-5.9-b-v1','apcalcab-mcq-b16-sv-h-5.9-b-v2','apcalcab-mcq-b16-sv-h-5.9-b-v3','apcalcab-mcq-b16-h-5.9-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
