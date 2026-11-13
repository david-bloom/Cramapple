begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.4-c-v2','apstats-mcq-b8-sv-h-5.4-c-v3','apstats-mcq-b8-h-5.5-c','apstats-mcq-b8-sv-h-5.5-c-v1','apstats-mcq-b8-sv-h-5.5-c-v2','apstats-mcq-b8-sv-h-5.5-c-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apstats-mcq-b8-sv-h-5.4-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-c-v2', 'mcq', 'compare residual diagnostics across models (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two candidate models predict fuel use from speed. At five increasing x-values, model A has residuals [5, 2, -1, 2, 5], and model B has residuals [0, 1, -1, 0, 1]. Which judgment about form follows from these residuals?', null, md5('apstats-mcq-b8-sv-h-5.4-c-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Model B has the more appropriate form for fuel use: A leaves a systematic curve across speed, whereas B''s residuals fluctuate around zero.', true, 'Correct: Model A''s endpoint and middle residuals trace a repeated high-low-high or low-high-low shape. B''s signs fluctuate without that curve; zero residual at every point is unnecessary.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Model A has the better form for fuel use because an orderly curve of residuals is desirable.', false, 'The orderly curve is evidence that A misses systematic structure, not evidence in its favor.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both forms are equally supported because each list contains positive and negative residuals.', false, 'Having both signs is not enough; the order of residuals across x reveals A''s pattern.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither form can be used because a fitted model must make every residual exactly zero.', false, 'Residuals need not all be zero for a model to be useful; random scatter is the relevant form check.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-c-v3', 'mcq', 'compare residual diagnostics across models (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two candidate models predict pollution from time. At five increasing x-values, model A has residuals [-3, 0, 2, 0, -3], and model B has residuals [1, 0, -1, 1, 0]. Which judgment about form follows from these residuals?', null, md5('apstats-mcq-b8-sv-h-5.4-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Model A has the better form for pollution because an orderly curve of residuals is desirable.', false, 'The orderly curve is evidence that A misses systematic structure, not evidence in its favor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both forms are equally supported because each list contains positive and negative residuals.', false, 'Having both signs is not enough; the order of residuals across x reveals A''s pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Model B has the more appropriate form for pollution: A leaves a systematic curve across time, whereas B''s residuals fluctuate around zero.', true, 'Correct: Model A''s endpoint and middle residuals trace a repeated high-low-high or low-high-low shape. B''s signs fluctuate without that curve; zero residual at every point is unnecessary.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither form can be used because a fitted model must make every residual exactly zero.', false, 'Residuals need not all be zero for a model to be useful; random scatter is the relevant form check.' from version_ins;
-- apstats-mcq-b8-h-5.5-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.5-c', 'mcq', 'predict from least-squares means and slope', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicting score from study hours has slope +5 and passes through the sample means (4,70). A student predicts at x=6 by adding the slope directly to y-bar. What is the correct prediction and why?', null, md5('apstats-mcq-b8-h-5.5-c'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '75; the slope is added once whenever x exceeds its mean.', false, 'The slope is a response change per one x-unit; the x-change here is not one.' from version_ins
union all select gen_random_uuid(), id, 'B', '100; y-bar is the intercept for every least-squares line.', false, 'The least-squares line passes through the means, so y-bar is its value at x-bar, not usually its intercept.' from version_ins
union all select gen_random_uuid(), id, 'C', '70; the mean response is the prediction at every x because the line passes through the means.', false, 'The line predicts y-bar at x-bar only; its slope is nonzero.' from version_ins
union all select gen_random_uuid(), id, 'D', '80; the x-value is 2 units above x-bar, so the change from y-bar is 5 times 2.', true, 'Correct: Use point-slope form y-hat=70+(5)(x-4). At x=6, y-hat=80. The slope multiplies change in x from x-bar.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-c-v1', 'mcq', 'predict from least-squares means and slope (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicting output from machine age has slope -4 and passes through the sample means (6,80). A student predicts at x=9 by adding the slope directly to y-bar. What is the correct prediction and why?', null, md5('apstats-mcq-b8-sv-h-5.5-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '76; the slope is added once whenever x exceeds its mean.', false, 'The slope is a response change per one x-unit; the x-change here is not one.' from version_ins
union all select gen_random_uuid(), id, 'B', '44; y-bar is the intercept for every least-squares line.', false, 'The least-squares line passes through the means, so y-bar is its value at x-bar, not usually its intercept.' from version_ins
union all select gen_random_uuid(), id, 'C', '80; the mean response is the prediction at every x because the line passes through the means.', false, 'The line predicts y-bar at x-bar only; its slope is nonzero.' from version_ins
union all select gen_random_uuid(), id, 'D', '68; the x-value is 3 units above x-bar, so the change from y-bar is -4 times 3.', true, 'Correct: Use point-slope form y-hat=80+(-4)(x-6). At x=9, y-hat=68. The slope multiplies change in x from x-bar.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-c-v2', 'mcq', 'predict from least-squares means and slope (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicting fuel remaining from distance traveled has slope -3 and passes through the sample means (5,30). A student predicts at x=7 by adding the slope directly to y-bar. What is the correct prediction and why?', null, md5('apstats-mcq-b8-sv-h-5.5-c-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '27; the slope is added once whenever x exceeds its mean.', false, 'The slope is a response change per one x-unit; the x-change here is not one.' from version_ins
union all select gen_random_uuid(), id, 'B', '24; the x-value is 2 units above x-bar, so the change from y-bar is -3 times 2.', true, 'Correct: Use point-slope form y-hat=30+(-3)(x-5). At x=7, y-hat=24. The slope multiplies change in x from x-bar.' from version_ins
union all select gen_random_uuid(), id, 'C', '9; y-bar is the intercept for every least-squares line.', false, 'The least-squares line passes through the means, so y-bar is its value at x-bar, not usually its intercept.' from version_ins
union all select gen_random_uuid(), id, 'D', '30; the mean response is the prediction at every x because the line passes through the means.', false, 'The line predicts y-bar at x-bar only; its slope is nonzero.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-c-v3', 'mcq', 'predict from least-squares means and slope (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicting crop height from weekly rainfall has slope +2 and passes through the sample means (3,18). A student predicts at x=7 by adding the slope directly to y-bar. What is the correct prediction and why?', null, md5('apstats-mcq-b8-sv-h-5.5-c-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20; the slope is added once whenever x exceeds its mean.', false, 'The slope is a response change per one x-unit; the x-change here is not one.' from version_ins
union all select gen_random_uuid(), id, 'B', '26; the x-value is 4 units above x-bar, so the change from y-bar is 2 times 4.', true, 'Correct: Use point-slope form y-hat=18+(2)(x-3). At x=7, y-hat=26. The slope multiplies change in x from x-bar.' from version_ins
union all select gen_random_uuid(), id, 'C', '32; y-bar is the intercept for every least-squares line.', false, 'The least-squares line passes through the means, so y-bar is its value at x-bar, not usually its intercept.' from version_ins
union all select gen_random_uuid(), id, 'D', '18; the mean response is the prediction at every x because the line passes through the means.', false, 'The line predicts y-bar at x-bar only; its slope is nonzero.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.4-c-v2','apstats-mcq-b8-sv-h-5.4-c-v3','apstats-mcq-b8-h-5.5-c','apstats-mcq-b8-sv-h-5.5-c-v1','apstats-mcq-b8-sv-h-5.5-c-v2','apstats-mcq-b8-sv-h-5.5-c-v3']) and status='draft')<>6 then raise exception 'chunk 7: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-sv-h-5.4-c-v2','apstats-mcq-b8-sv-h-5.4-c-v3','apstats-mcq-b8-h-5.5-c','apstats-mcq-b8-sv-h-5.5-c-v1','apstats-mcq-b8-sv-h-5.5-c-v2','apstats-mcq-b8-sv-h-5.5-c-v3']))<>24 then raise exception 'chunk 7: expected 24 choices'; end if;
end $$;
commit;
