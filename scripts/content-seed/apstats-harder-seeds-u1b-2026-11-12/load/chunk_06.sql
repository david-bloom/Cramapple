begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.13-b-v1','apstats-mcq-b6-sv-h-1.13-b-v2','apstats-mcq-b6-sv-h-1.13-b-v3'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apstats-mcq-b6-sv-h-1.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.13-b-v1', 'mcq', 'determine the scope of conclusions (cause, generalization) from random assignment and random selection (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers select a simple random sample of 600 adults from a county and record each person''s daily coffee intake and whether the person has been diagnosed with high blood pressure. Those who drink more coffee are more likely to have high blood pressure. Which conclusion is justified?', null, md5('apstats-mcq-b6-sv-h-1.13-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Coffee causes high blood pressure, and this can be generalized to all adults in the county.', false, 'The study is observational, so confounding variables could explain the association, and no cause can be concluded.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Coffee causes high blood pressure among the 600 adults, but the result cannot be generalized.', false, 'There was no random assignment, so a cause-and-effect conclusion is not justified, even for the sample.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The association applies only to the 600 adults, because only they were studied.', false, 'The random selection of adults supports generalizing the association to the county population.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The association can be generalized to all adults in the county, but it cannot be concluded that coffee causes high blood pressure.', true, 'Correct: A random sample supports generalization to the county; no random assignment means association only.' from version_ins;
-- apstats-mcq-b6-sv-h-1.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.13-b-v2', 'mcq', 'determine the scope of conclusions (cause, generalization) from random assignment and random selection (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher selects a simple random sample of 120 students from a school of 2,000, then uses a random number generator to assign 60 to a new study app and 60 to the usual materials. Test scores are significantly higher for the app group. Which conclusion is justified?', null, md5('apstats-mcq-b6-sv-h-1.13-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The app caused the higher scores, but the result cannot be generalized to all students at the school.', false, 'The random selection of the students from the school supports generalizing to that school.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The result can be generalized to the school, but there is only an association with the app.', false, 'Random assignment to the app supports a cause-and-effect conclusion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is only an association between the app and scores, and it applies only to the 120 students.', false, 'Both random selection and random assignment were used, so both generalization and causation are supported.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The app caused the higher scores, and the result can be generalized to all students at the school.', true, 'Correct: Random selection supports generalizing to the school and random assignment supports a causal conclusion.' from version_ins;
-- apstats-mcq-b6-sv-h-1.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b6-sv-h-1.13-b-v3', 'mcq', 'determine the scope of conclusions (cause, generalization) from random assignment and random selection (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Eighty volunteers from a community center choose whether to join a walking group or not join it. After 10 weeks, the walking group has lower mean blood pressure. Which conclusion is justified?', null, md5('apstats-mcq-b6-sv-h-1.13-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Walking caused the lower blood pressure, and the result can be generalized to all adults.', false, 'The participants chose their group and were volunteers, so neither causation nor generalization is supported.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is an association among these volunteers, but the walking cannot be concluded to cause the lower blood pressure and the result cannot be generalized to all adults.', true, 'Correct: No random assignment (self-chosen groups) and no random sampling (volunteers) means neither a causal conclusion nor generalization.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Walking caused the lower blood pressure among these volunteers, because the groups were compared over 10 weeks.', false, 'Comparison over time is not random assignment; the people who chose to walk may differ in other ways.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The association can be generalized to all adults, because 80 people is a large enough sample.', false, 'The sample size does not matter without random selection, and these volunteers were not randomly selected.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b6-sv-h-1.13-b-v1','apstats-mcq-b6-sv-h-1.13-b-v2','apstats-mcq-b6-sv-h-1.13-b-v3']) and status='draft')<>3 then raise exception 'chunk 6: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b6-sv-h-1.13-b-v1','apstats-mcq-b6-sv-h-1.13-b-v2','apstats-mcq-b6-sv-h-1.13-b-v3']))<>12 then raise exception 'chunk 6: expected 12 choices'; end if;
end $$;
commit;
