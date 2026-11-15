begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b12-sv-h-5.5-c-v1','apcalcab-mcq-b12-sv-h-5.5-c-v2','apcalcab-mcq-b12-sv-h-5.5-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b12-sv-h-5.5-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b12-sv-h-5.5-c-v1', 'mcq', 'interpret exhaustive candidate tables (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h is continuous on [-2,4]. Its only interior critical points are x=0, where h''=0, and x=2, where h'' is undefined; h'' is nonzero and defined everywhere else inside the interval. The measured values are h(-2)=7, h(0)=3, h(2)=0, and h(4)=4. Which conclusion is justified?', null, md5('apcalcab-mcq-b12-sv-h-5.5-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both absolute extrema must occur at x=0, the only place where h''=0.', false, 'A derivative zero is only one candidate, and one point cannot simultaneously have the listed largest and smallest values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The value at x=2 must be discarded because h'' is undefined there.', false, 'An undefined derivative at an interior point makes it a candidate; the corner has a smallest value here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The absolute extrema cannot be found without the formula for h between the listed points.', false, 'Continuity on the closed interval plus the exhaustive candidate list makes comparison of these four values sufficient.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The absolute maximum is 7 at x=-2, and the absolute minimum is 0 at x=2.', true, 'Correct: All candidates are -2,0,2,4; by hypothesis there are no other interior critical points. Their values are (7, 3, 0, 4). The largest is 7 and the smallest is 0; include ties.' from version_ins;
-- apcalcab-mcq-b12-sv-h-5.5-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b12-sv-h-5.5-c-v2', 'mcq', 'interpret exhaustive candidate tables (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h is continuous on [0,6]. Its only interior critical points are x=2, where h''=0, and x=3, where h'' is undefined; h'' is nonzero and defined everywhere else inside the interval. The measured values are h(0)=-4, h(2)=-1, h(3)=-4, and h(6)=2. Which conclusion is justified?', null, md5('apcalcab-mcq-b12-sv-h-5.5-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both absolute extrema must occur at x=2, the only place where h''=0.', false, 'A derivative zero is only one candidate, and one point cannot simultaneously have the listed largest and smallest values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The value at x=3 must be discarded because h'' is undefined there.', false, 'An undefined derivative at an interior point makes it a candidate; the corner has a smallest value here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The absolute extrema cannot be found without the formula for h between the listed points.', false, 'Continuity on the closed interval plus the exhaustive candidate list makes comparison of these four values sufficient.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The absolute maximum is 2 at x=6, and the absolute minimum is -4 at x=0, x=3.', true, 'Correct: All candidates are 0,2,3,6; by hypothesis there are no other interior critical points. Their values are (-4, -1, -4, 2). The largest is 2 and the smallest is -4; include ties.' from version_ins;
-- apcalcab-mcq-b12-sv-h-5.5-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b12-sv-h-5.5-c-v3', 'mcq', 'interpret exhaustive candidate tables (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h is continuous on [-1,5]. Its only interior critical points are x=1, where h''=0, and x=4, where h'' is undefined; h'' is nonzero and defined everywhere else inside the interval. The measured values are h(-1)=1, h(1)=6, h(4)=-2, and h(5)=4. Which conclusion is justified?', null, md5('apcalcab-mcq-b12-sv-h-5.5-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both absolute extrema must occur at x=1, the only place where h''=0.', false, 'A derivative zero is only one candidate, and one point cannot simultaneously have the listed largest and smallest values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The value at x=4 must be discarded because h'' is undefined there.', false, 'An undefined derivative at an interior point makes it a candidate; the corner has a smallest value here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The absolute maximum is 6 at x=1, and the absolute minimum is -2 at x=4.', true, 'Correct: All candidates are -1,1,4,5; by hypothesis there are no other interior critical points. Their values are (1, 6, -2, 4). The largest is 6 and the smallest is -2; include ties.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The absolute extrema cannot be found without the formula for h between the listed points.', false, 'Continuity on the closed interval plus the exhaustive candidate list makes comparison of these four values sufficient.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b12-sv-h-5.5-c-v1','apcalcab-mcq-b12-sv-h-5.5-c-v2','apcalcab-mcq-b12-sv-h-5.5-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b12-sv-h-5.5-c-v1','apcalcab-mcq-b12-sv-h-5.5-c-v2','apcalcab-mcq-b12-sv-h-5.5-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
