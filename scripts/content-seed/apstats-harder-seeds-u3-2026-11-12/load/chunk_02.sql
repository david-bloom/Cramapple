begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b2-sv-h-3.14-b-v1','apstats-mcq-b2-sv-h-3.14-b-v2','apstats-mcq-b2-sv-h-3.14-b-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apstats-mcq-b2-sv-h-3.14-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.14-b-v1', 'mcq', 'Chi-square hypotheses and expected-count condition (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quality manager takes independent random samples of 100 items from each of three plants and classifies each item by defect type (4 types). Which hypotheses are appropriate for a chi-square test?', null, md5('apstats-mcq-b2-sv-h-3.14-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H0: Defect type and plant are independent. Ha: Defect type and plant are not independent.', false, 'This states the hypotheses of a test of independence, which fits one sample classified on two variables and not separate samples from each plant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H0: In the samples, the distribution of defect types is the same for each plant. Ha: In the samples, the distributions differ.', false, 'Hypotheses must be about the populations, since samples would almost never have identical distributions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H0: The mean number of defects is the same at the three plants. Ha: At least one mean is different.', false, 'The response is categorical, so means are not defined, and this is a hypothesis for a different procedure.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H0: The distribution of defect types is the same in the populations of items from the three plants. Ha: The distribution of defect types is not the same in all three populations.', true, 'Correct: independent random samples from several populations, with one categorical response, calls for a test of homogeneity.' from version_ins;
-- apstats-mcq-b2-sv-h-3.14-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.14-b-v2', 'mcq', 'Chi-square hypotheses and expected-count condition (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chi-square test is planned for the table below, from a random sample of 70 people classified by group (rows) and response (columns).
| | Response 1 | Response 2 | Response 3 | Total |
|---|---|---|---|---|
| Group 1 | 12 | 18 | 10 | 40 |
| Group 2 | 5 | 9 | 16 | 30 |
| Total | 17 | 27 | 26 | 70 |
Which statement about the expected count for Group 2, Response 1 and the condition is correct?', null, md5('apstats-mcq-b2-sv-h-3.14-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The expected count is 5, and the condition is not met because that count is below 10.', false, 'The expected count is not the observed count, and the usual threshold for expected counts is 5, not 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The expected count is 10, so the condition is met.', false, 'This divides the row total by 3 and ignores the column total.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The expected count is 7.29, but the condition requires all expected counts to be at least 10, so it is not met.', false, 'The standard condition is that every expected count is at least 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The expected count is 7.29, and all expected counts are at least 5, so the condition is met.', true, 'Correct: expected = (30 × 17)/70 = 7.29; the smallest expected count is 7.29, which is at least 5.' from version_ins;
-- apstats-mcq-b2-sv-h-3.14-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b2-sv-h-3.14-b-v3', 'mcq', 'Chi-square hypotheses and expected-count condition (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A random sample of 90 students is classified by grade (rows: Freshman 40, Sophomore 30, Junior 20) and by whether they own a car (columns: Yes 70, No 20), with observed counts Freshman 30 and 10, Sophomore 22 and 8, Junior 18 and 2. Which statement about the expected count for Junior, No and the large counts condition is correct?', null, md5('apstats-mcq-b2-sv-h-3.14-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The expected count equals the observed count of 2, which is less than 5, so the condition is not met.', false, 'An expected count comes from the row and column totals and is not the observed count, so it is not 2 here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The expected count is 4.44, but the condition only requires that observed counts be at least 5, so it is met.', false, 'The condition applies to expected counts, so the small expected value matters.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The expected count is 4.44, which is less than 5, so the condition is not met.', true, 'Correct: expected = (20 × 20)/90 = 4.44 < 5, so the condition on expected counts fails.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The expected count is 10, so the condition is met.', false, 'This does not use the row and column totals, which give 20 × 20 / 90.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b2-sv-h-3.14-b-v1','apstats-mcq-b2-sv-h-3.14-b-v2','apstats-mcq-b2-sv-h-3.14-b-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b2-sv-h-3.14-b-v1','apstats-mcq-b2-sv-h-3.14-b-v2','apstats-mcq-b2-sv-h-3.14-b-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
