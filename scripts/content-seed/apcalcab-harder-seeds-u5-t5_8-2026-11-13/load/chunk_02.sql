begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b15-sv-h-5.8-c-v1','apcalcab-mcq-b15-sv-h-5.8-c-v2','apcalcab-mcq-b15-sv-h-5.8-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b15-sv-h-5.8-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b15-sv-h-5.8-c-v1', 'mcq', 'classify stationary inflection and local extremum (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g has g''(x)=-1(x−(-4))²(x−(2)) for all real x. A proposed sketch marks x=-4 as a horizontal tangent and x=2 as another horizontal tangent. Which additional classification is correct?', null, md5('apcalcab-mcq-b15-sv-h-5.8-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-4 and x=2 are both local maximum points because g'' vanishes at both.', false, 'A repeated derivative zero does not change g'' sign, while the simple zero does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-4 is a stationary inflection, but x=2 is also an inflection because g'' vanishes there.', false, 'The simple zero of g'' is an extremum of g, not an inflection; g'''' does not vanish there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=0 is a local maximum of g because it is a zero of g''''.', false, 'A zero of g'''' can signal an inflection of g, not a local extremum unless g'' also changes sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=-4 is a stationary inflection, x=0 is another inflection, and x=2 is a local maximum.', true, 'Correct: The squared factor makes g'' keep its sign at -4; the simple factor changes sign at 2, giving a local maximum. Differentiation gives g''''=-1(x−(-4))(3x−(0)), whose signs change at -4 and 0.' from version_ins;
-- apcalcab-mcq-b15-sv-h-5.8-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b15-sv-h-5.8-c-v2', 'mcq', 'classify stationary inflection and local extremum (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g has g''(x)=2(x−(0))²(x−(6)) for all real x. A proposed sketch marks x=0 as a horizontal tangent and x=6 as another horizontal tangent. Which additional classification is correct?', null, md5('apcalcab-mcq-b15-sv-h-5.8-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=0 and x=6 are both local minimum points because g'' vanishes at both.', false, 'A repeated derivative zero does not change g'' sign, while the simple zero does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=0 is a stationary inflection, but x=6 is also an inflection because g'' vanishes there.', false, 'The simple zero of g'' is an extremum of g, not an inflection; g'''' does not vanish there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=4 is a local minimum of g because it is a zero of g''''.', false, 'A zero of g'''' can signal an inflection of g, not a local extremum unless g'' also changes sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=0 is a stationary inflection, x=4 is another inflection, and x=6 is a local minimum.', true, 'Correct: The squared factor makes g'' keep its sign at 0; the simple factor changes sign at 6, giving a local minimum. Differentiation gives g''''=2(x−(0))(3x−(12)), whose signs change at 0 and 4.' from version_ins;
-- apcalcab-mcq-b15-sv-h-5.8-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b15-sv-h-5.8-c-v3', 'mcq', 'classify stationary inflection and local extremum (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function g has g''(x)=-2(x−(-1))²(x−(5)) for all real x. A proposed sketch marks x=-1 as a horizontal tangent and x=5 as another horizontal tangent. Which additional classification is correct?', null, md5('apcalcab-mcq-b15-sv-h-5.8-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=-1 and x=5 are both local maximum points because g'' vanishes at both.', false, 'A repeated derivative zero does not change g'' sign, while the simple zero does.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-1 is a stationary inflection, but x=5 is also an inflection because g'' vanishes there.', false, 'The simple zero of g'' is an extremum of g, not an inflection; g'''' does not vanish there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-1 is a stationary inflection, x=3 is another inflection, and x=5 is a local maximum.', true, 'Correct: The squared factor makes g'' keep its sign at -1; the simple factor changes sign at 5, giving a local maximum. Differentiation gives g''''=-2(x−(-1))(3x−(9)), whose signs change at -1 and 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=3 is a local maximum of g because it is a zero of g''''.', false, 'A zero of g'''' can signal an inflection of g, not a local extremum unless g'' also changes sign.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b15-sv-h-5.8-c-v1','apcalcab-mcq-b15-sv-h-5.8-c-v2','apcalcab-mcq-b15-sv-h-5.8-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b15-sv-h-5.8-c-v1','apcalcab-mcq-b15-sv-h-5.8-c-v2','apcalcab-mcq-b15-sv-h-5.8-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
