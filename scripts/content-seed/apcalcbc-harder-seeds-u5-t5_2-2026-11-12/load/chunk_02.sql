begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b8-sv-h-5.2-c-v1','apcalcbc-mcq-b8-sv-h-5.2-c-v2','apcalcbc-mcq-b8-sv-h-5.2-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b8-sv-h-5.2-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.2-c-v1', 'mcq', 'compare local and absolute extrema (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function on [-2,2] alternately increases, decreases, increases, and decreases across x=-1,0,1. Values at -2,-1,0,1,2 are 2,5,1,4,0. Which classification is supported?', null, md5('apcalcbc-mcq-b8-sv-h-5.2-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=1 is the absolute maximum because it is the last interior local maximum.', false, 'F(1)=4 is below f(-1)=5, despite being locally high.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=0 is the absolute minimum because it is an interior local minimum.', false, 'The local minimum f(0)=1 is above the endpoint value f(2)=0, so it is not absolute.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No endpoint can be an absolute minimum when the function has interior local extrema.', false, 'Interior local extrema do not prevent an endpoint from being globally smallest.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=-1 is an interior local and absolute maximum, while x=2 is an absolute minimum at an endpoint.', true, 'Correct: The monotonicity confirms local maxima at -1 and 1, and a local minimum at 0. Listed values show the largest is 5 at -1 and smallest is 0 at endpoint 2.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.2-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.2-c-v2', 'mcq', 'compare local and absolute extrema (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function on [-2,2] alternately increases, decreases, increases, and decreases across x=-1,0,1. Values at -2,-1,0,1,2 are 0,3,1,4,2. What is true?', null, md5('apcalcbc-mcq-b8-sv-h-5.2-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=0 is the absolute minimum because it is an interior local minimum.', false, 'The interior local minimum f(0)=1 exceeds the endpoint value f(-2)=0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-1 is the absolute maximum because it is the first interior peak.', false, 'The first local peak f(-1)=3 is below the later local peak f(1)=4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Absolute extrema cannot occur at endpoints if a function changes direction inside.', false, 'An endpoint may be an absolute extremum even when interior local extrema exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=-2 is the absolute minimum, and x=1 is an interior local and absolute maximum.', true, 'Correct: The smallest value is f(-2)=0 and the greatest is f(1)=4. The stated monotonicity prevents any intermediate values outside the neighboring endpoint values.' from version_ins;
-- apcalcbc-mcq-b8-sv-h-5.2-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b8-sv-h-5.2-c-v3', 'mcq', 'compare local and absolute extrema (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function on [-2,2] decreases, increases, decreases, and increases across x=-1,0,1. Values at -2,-1,0,1,2 are 5,1,4,0,3. Which comparison is correct?', null, md5('apcalcbc-mcq-b8-sv-h-5.2-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=0 is the absolute maximum because it is an interior local peak.', false, 'The interior local peak f(0)=4 is below the endpoint value f(-2)=5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=-1 is the absolute minimum because it is the first interior valley.', false, 'The first local valley f(-1)=1 is above the later valley f(1)=0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=-2 is the absolute maximum, while x=1 is an interior local and absolute minimum.', true, 'Correct: The listed monotonic intervals confine values to the endpoint values of each segment. f(-2)=5 is greatest, f(1)=0 is least; 0 is a smaller local peak and -1 a higher local valley.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The function cannot have absolute extrema because its direction changes three times.', false, 'Direction changes do not prevent a continuous function on a closed interval from attaining absolute extrema.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b8-sv-h-5.2-c-v1','apcalcbc-mcq-b8-sv-h-5.2-c-v2','apcalcbc-mcq-b8-sv-h-5.2-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b8-sv-h-5.2-c-v1','apcalcbc-mcq-b8-sv-h-5.2-c-v2','apcalcbc-mcq-b8-sv-h-5.2-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
