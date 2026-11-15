begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-h-5.1-a','apstats-mcq-b8-sv-h-5.1-a-v1','apstats-mcq-b8-sv-h-5.1-a-v2','apstats-mcq-b8-sv-h-5.1-a-v3','apstats-mcq-b8-h-5.1-b','apstats-mcq-b8-sv-h-5.1-b-v1','apstats-mcq-b8-sv-h-5.1-b-v2','apstats-mcq-b8-sv-h-5.1-b-v3','apstats-mcq-b8-h-5.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apstats-mcq-b8-h-5.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.1-a', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher records (hours of sunlight, daily plant growth) for five independent observations: (2, 3), (4, 6), (6, 9), (8, 12), (10, 2). The first quantity is used to explain the second. Which description of the scatterplot is best supported?', null, md5('apstats-mcq-b8-h-5.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Put daily plant growth on the horizontal axis and hours of sunlight on the vertical axis; the last point proves that the response causes the explanatory variable.', false, 'The variables were recorded as explanatory then response; exchanging the axes changes the intended prediction, and a scatterplot alone does not establish causation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is negative and roughly linear because the final response is smaller than the first response.', false, 'The direction of the main pattern comes from all observations rather than comparing only the first and last response values.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Put hours of sunlight on the horizontal axis and daily plant growth on the vertical axis; four points follow a positive, roughly linear pattern, with the last point unusually low.', true, 'Correct: The explanatory variable is the first coordinate. The first four response values rise with x; the fifth lies well below that pattern. One unusual point does not reverse the four-point direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No pattern is visible because one unusual point cancels the consistent increase in the other four observations.', false, 'The first four points form a visible positive pattern; the unusual fifth point should be named rather than erasing that pattern.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-a-v1', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher records (minutes of exercise, resting pulse reduction) for five independent observations: (10, 1), (20, 3), (30, 5), (40, 7), (50, 0). The first quantity is used to explain the second. Which description of the scatterplot is best supported?', null, md5('apstats-mcq-b8-sv-h-5.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Put resting pulse reduction on the horizontal axis and minutes of exercise on the vertical axis; the last point proves that the response causes the explanatory variable.', false, 'The variables were recorded as explanatory then response; exchanging the axes changes the intended prediction, and a scatterplot alone does not establish causation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is negative and roughly linear because the final response is smaller than the first response.', false, 'The direction of the main pattern comes from all observations rather than comparing only the first and last response values.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Put minutes of exercise on the horizontal axis and resting pulse reduction on the vertical axis; four points follow a positive, roughly linear pattern, with the last point unusually low.', true, 'Correct: The explanatory variable is the first coordinate. The first four response values rise with x; the fifth lies well below that pattern. One unusual point does not reverse the four-point direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No pattern is visible because one unusual point cancels the consistent increase in the other four observations.', false, 'The first four points form a visible positive pattern; the unusual fifth point should be named rather than erasing that pattern.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-a-v2', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher records (study sessions, quiz score) for five independent observations: (1, 55), (2, 63), (3, 71), (4, 79), (5, 54). The first quantity is used to explain the second. Which description of the scatterplot is best supported?', null, md5('apstats-mcq-b8-sv-h-5.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Put quiz score on the horizontal axis and study sessions on the vertical axis; the last point proves that the response causes the explanatory variable.', false, 'The variables were recorded as explanatory then response; exchanging the axes changes the intended prediction, and a scatterplot alone does not establish causation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is negative and roughly linear because the final response is smaller than the first response.', false, 'The direction of the main pattern comes from all observations rather than comparing only the first and last response values.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No pattern is visible because one unusual point cancels the consistent increase in the other four observations.', false, 'The first four points form a visible positive pattern; the unusual fifth point should be named rather than erasing that pattern.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Put study sessions on the horizontal axis and quiz score on the vertical axis; four points follow a positive, roughly linear pattern, with the last point unusually low.', true, 'Correct: The explanatory variable is the first coordinate. The first four response values rise with x; the fifth lies well below that pattern. One unusual point does not reverse the four-point direction.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-a-v3', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher records (rainfall in centimeters, seedling height) for five independent observations: (1, 4), (2, 7), (3, 10), (4, 13), (5, 3). The first quantity is used to explain the second. Which description of the scatterplot is best supported?', null, md5('apstats-mcq-b8-sv-h-5.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Put seedling height on the horizontal axis and rainfall in centimeters on the vertical axis; the last point proves that the response causes the explanatory variable.', false, 'The variables were recorded as explanatory then response; exchanging the axes changes the intended prediction, and a scatterplot alone does not establish causation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is negative and roughly linear because the final response is smaller than the first response.', false, 'The direction of the main pattern comes from all observations rather than comparing only the first and last response values.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No pattern is visible because one unusual point cancels the consistent increase in the other four observations.', false, 'The first four points form a visible positive pattern; the unusual fifth point should be named rather than erasing that pattern.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Put rainfall in centimeters on the horizontal axis and seedling height on the vertical axis; four points follow a positive, roughly linear pattern, with the last point unusually low.', true, 'Correct: The explanatory variable is the first coordinate. The first four response values rise with x; the fifth lies well below that pattern. One unusual point does not reverse the four-point direction.' from version_ins;
-- apstats-mcq-b8-h-5.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.1-b', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed B', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Five observations of (fertilizer dose, crop yield) are (1, 2), (2, 5), (3, 8), (4, 5), (5, 2), with fertilizer dose explanatory. A classmate describes the scatterplot as having ''no relationship'' because the first and last responses match. Which reply best uses the entire plot?', null, md5('apstats-mcq-b8-h-5.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The response rises then falls as fertilizer dose increases, so the plotted association is curved even though the endpoint responses match.', true, 'Correct: Reading the five ordered pairs in x order gives a rise to the middle point and a fall afterward. Matching endpoints do not erase the curved form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is perfectly positive and linear because the response increases over the first three observations.', false, 'The later observations reverse the early rise, so a single positive straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The association is perfectly negative and linear because the response decreases over the last three observations.', false, 'The earlier observations rise before the later fall, so a single negative straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A scatterplot cannot show an association when the first and last response values are equal.', false, 'The middle observations reveal a strong curved association despite equal response values at the two endpoints.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-b-v1', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed B (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Five observations of (time after sunrise, solar output) are (1, 1), (2, 4), (3, 7), (4, 4), (5, 1), with time after sunrise explanatory. A classmate describes the scatterplot as having ''no relationship'' because the first and last responses match. Which reply best uses the entire plot?', null, md5('apstats-mcq-b8-sv-h-5.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The response rises then falls as time after sunrise increases, so the plotted association is curved even though the endpoint responses match.', true, 'Correct: Reading the five ordered pairs in x order gives a rise to the middle point and a fall afterward. Matching endpoints do not erase the curved form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is perfectly positive and linear because the response increases over the first three observations.', false, 'The later observations reverse the early rise, so a single positive straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The association is perfectly negative and linear because the response decreases over the last three observations.', false, 'The earlier observations rise before the later fall, so a single negative straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A scatterplot cannot show an association when the first and last response values are equal.', false, 'The middle observations reveal a strong curved association despite equal response values at the two endpoints.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-b-v2', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed B (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Five observations of (distance from a heater, sensor response) are (1, 2), (2, 6), (3, 9), (4, 6), (5, 2), with distance from a heater explanatory. A classmate describes the scatterplot as having ''no relationship'' because the first and last responses match. Which reply best uses the entire plot?', null, md5('apstats-mcq-b8-sv-h-5.1-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The response rises then falls as distance from a heater increases, so the plotted association is curved even though the endpoint responses match.', true, 'Correct: Reading the five ordered pairs in x order gives a rise to the middle point and a fall afterward. Matching endpoints do not erase the curved form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is perfectly positive and linear because the response increases over the first three observations.', false, 'The later observations reverse the early rise, so a single positive straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The association is perfectly negative and linear because the response decreases over the last three observations.', false, 'The earlier observations rise before the later fall, so a single negative straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A scatterplot cannot show an association when the first and last response values are equal.', false, 'The middle observations reveal a strong curved association despite equal response values at the two endpoints.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-b-v3', 'mcq', 'AP Statistics Unit 5 topic 5.1, seed B (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Five observations of (training load, performance score) are (1, 3), (2, 7), (3, 10), (4, 7), (5, 3), with training load explanatory. A classmate describes the scatterplot as having ''no relationship'' because the first and last responses match. Which reply best uses the entire plot?', null, md5('apstats-mcq-b8-sv-h-5.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The association is perfectly positive and linear because the response increases over the first three observations.', false, 'The later observations reverse the early rise, so a single positive straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association is perfectly negative and linear because the response decreases over the last three observations.', false, 'The earlier observations rise before the later fall, so a single negative straight-line description omits half the data.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The response rises then falls as training load increases, so the plotted association is curved even though the endpoint responses match.', true, 'Correct: Reading the five ordered pairs in x order gives a rise to the middle point and a fall afterward. Matching endpoints do not erase the curved form.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A scatterplot cannot show an association when the first and last response values are equal.', false, 'The middle observations reveal a strong curved association despite equal response values at the two endpoints.' from version_ins;
-- apstats-mcq-b8-h-5.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.2-a', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a sample, the correlation between distance in miles and delivery time is +0.78. An analyst converts the first variable to a new unit using a positive scale factor, then reports the negative of the second variable instead. Which statement is justified about the new correlation and a possible causal claim?', null, md5('apstats-mcq-b8-h-5.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The new correlation is -0.78; the sign reverses because one variable was negated, and neither correlation establishes causation.', true, 'Correct: A positive rescaling preserves r=+0.78; multiplying one variable by -1 changes its sign to -0.78. Association alone cannot prove causation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The new correlation is +0.78; changing units and negating a variable cannot change correlation''s direction.', false, 'Positive rescaling preserves correlation, but negating one of the variables reverses its sign.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The new correlation is -0.78; its magnitude establishes that changing distance in miles causes a change in delivery time.', false, 'The sign calculation is right, but the size of a correlation does not by itself identify a causal effect.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The new correlation is 0 because both variables were transformed before it was computed.', false, 'Linear transformations do not in general destroy association; a positive rescaling and a sign reversal leave the magnitude unchanged.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-h-5.1-a','apstats-mcq-b8-sv-h-5.1-a-v1','apstats-mcq-b8-sv-h-5.1-a-v2','apstats-mcq-b8-sv-h-5.1-a-v3','apstats-mcq-b8-h-5.1-b','apstats-mcq-b8-sv-h-5.1-b-v1','apstats-mcq-b8-sv-h-5.1-b-v2','apstats-mcq-b8-sv-h-5.1-b-v3','apstats-mcq-b8-h-5.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-h-5.1-a','apstats-mcq-b8-sv-h-5.1-a-v1','apstats-mcq-b8-sv-h-5.1-a-v2','apstats-mcq-b8-sv-h-5.1-a-v3','apstats-mcq-b8-h-5.1-b','apstats-mcq-b8-sv-h-5.1-b-v1','apstats-mcq-b8-sv-h-5.1-b-v2','apstats-mcq-b8-sv-h-5.1-b-v3','apstats-mcq-b8-h-5.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
