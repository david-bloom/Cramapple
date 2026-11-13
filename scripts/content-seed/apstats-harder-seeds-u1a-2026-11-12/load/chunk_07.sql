begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.7-b-v2','apstats-mcq-b7-sv-h-1.7-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apstats-mcq-b7-sv-h-1.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.7-b-v2', 'mcq', 'find and interpret the mean of a combined group from the means and sizes of two subgroups, avoiding the unweighted avera (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hiking club has 25 members with a mean age of 30 years and 15 guests with a mean age of 50 years. Which statement about the mean age of all 40 people is correct?', null, md5('apstats-mcq-b7-sv-h-1.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean age of all 40 people is 40 years, the average of 30 and 50.', false, 'Averaging 30 and 50 treats the groups as equal in size, but there are 25 members and only 15 guests.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean age of all 40 people cannot be found without the age of each person.', false, 'Each group''s total age is its mean times its size, so the overall mean can be calculated from the means and sizes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean age of all 40 people is 37.5 years, and the median age of all 40 people must also be 37.5.', false, 'The mean is 37.5, but the median of the 40 ages cannot be found from the means and sizes and need not equal 37.5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mean age of all 40 people is 37.5 years, which is closer to 30 because the club has more members than guests.', true, 'Correct: Total age = 25(30) + 15(50) = 750 + 750 = 1500, and 1500/40 = 37.5.' from version_ins;
-- apstats-mcq-b7-sv-h-1.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b7-sv-h-1.7-b-v3', 'mcq', 'find and interpret the mean of a combined group from the means and sizes of two subgroups, avoiding the unweighted avera (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Drivers on a highway are grouped by vehicle type. 60% are cars, with a mean speed of 62 miles per hour, and 40% are trucks, with a mean speed of 50 miles per hour. Which statement about the mean speed of all drivers is correct?', null, md5('apstats-mcq-b7-sv-h-1.7-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mean speed of all drivers is 56 miles per hour, the average of 62 and 50.', false, 'The simple average of 62 and 50 ignores that 60% of the drivers are in cars and only 40% are in trucks.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mean speed of all drivers is 57.2 miles per hour, which is closer to 62 because more drivers are in cars.', true, 'Correct: Mean = 0.60(62) + 0.40(50) = 37.2 + 20 = 57.2 miles per hour, a weighted mean using the proportion in each group.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mean speed of all drivers cannot be found without the speed of every driver.', false, 'With the proportion of drivers in each group and each group''s mean, the overall mean is a weighted average and can be found.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mean speed of all drivers is 57.2 miles per hour, and the median speed of all drivers must also be 57.2.', false, 'The mean is 57.2, but the median of all speeds cannot be found from the group means and proportions and need not equal the mean.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b7-sv-h-1.7-b-v2','apstats-mcq-b7-sv-h-1.7-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b7-sv-h-1.7-b-v2','apstats-mcq-b7-sv-h-1.7-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
