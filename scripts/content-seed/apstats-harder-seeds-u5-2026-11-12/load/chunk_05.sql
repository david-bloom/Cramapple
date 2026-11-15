begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-h-5.5-b','apstats-mcq-b8-sv-h-5.5-b-v1','apstats-mcq-b8-sv-h-5.5-b-v2','apstats-mcq-b8-sv-h-5.5-b-v3','apstats-mcq-b8-h-5.1-c','apstats-mcq-b8-sv-h-5.1-c-v1','apstats-mcq-b8-sv-h-5.1-c-v2','apstats-mcq-b8-sv-h-5.1-c-v3','apstats-mcq-b8-h-5.2-c'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apstats-mcq-b8-h-5.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.5-b', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed B', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Technology gives a least-squares slope of +5 for predicting test score from practice hours. The sample means are x-bar=4 and y-bar=70. Using the fact that the line passes through the means, what is the predicted response at x=6?', null, md5('apstats-mcq-b8-h-5.5-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '100, because y-bar=70 is the intercept of the line.', false, 'The least-squares line passes through the two means, but its y-intercept is y-bar minus slope times x-bar, not generally y-bar.' from version_ins
union all select gen_random_uuid(), id, 'B', '80, because the intercept is 50 and y-hat=50+5x.', true, 'Correct: The line passes through (4,70), so a=70-(5)(4)=50; at x=6, y-hat=50+(5)(6)=80.' from version_ins
union all select gen_random_uuid(), id, 'C', '84, because x-bar must be added to the predicted response after applying the slope.', false, 'The explanatory mean is used to solve for the intercept; it is not added to a predicted response, which has different units.' from version_ins
union all select gen_random_uuid(), id, 'D', '70, because a least-squares line predicts the sample mean at every x-value.', false, 'The line predicts y-bar at x-bar, not at every explanatory value when its slope is nonzero.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-b-v1', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed B (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Technology gives a least-squares slope of +2 for predicting crop height from weekly rainfall. The sample means are x-bar=3 and y-bar=18. Using the fact that the line passes through the means, what is the predicted response at x=5?', null, md5('apstats-mcq-b8-sv-h-5.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28, because y-bar=18 is the intercept of the line.', false, 'The least-squares line passes through the two means, but its y-intercept is y-bar minus slope times x-bar, not generally y-bar.' from version_ins
union all select gen_random_uuid(), id, 'B', '25, because x-bar must be added to the predicted response after applying the slope.', false, 'The explanatory mean is used to solve for the intercept; it is not added to a predicted response, which has different units.' from version_ins
union all select gen_random_uuid(), id, 'C', '18, because a least-squares line predicts the sample mean at every x-value.', false, 'The line predicts y-bar at x-bar, not at every explanatory value when its slope is nonzero.' from version_ins
union all select gen_random_uuid(), id, 'D', '22, because the intercept is 12 and y-hat=12+2x.', true, 'Correct: The line passes through (3,18), so a=18-(2)(3)=12; at x=5, y-hat=12+(2)(5)=22.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-b-v2', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed B (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Technology gives a least-squares slope of -4 for predicting output from machine age. The sample means are x-bar=6 and y-bar=80. Using the fact that the line passes through the means, what is the predicted response at x=8?', null, md5('apstats-mcq-b8-sv-h-5.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '48, because y-bar=80 is the intercept of the line.', false, 'The least-squares line passes through the two means, but its y-intercept is y-bar minus slope times x-bar, not generally y-bar.' from version_ins
union all select gen_random_uuid(), id, 'B', '78, because x-bar must be added to the predicted response after applying the slope.', false, 'The explanatory mean is used to solve for the intercept; it is not added to a predicted response, which has different units.' from version_ins
union all select gen_random_uuid(), id, 'C', '72, because the intercept is 104 and y-hat=104-4x.', true, 'Correct: The line passes through (6,80), so a=80-(-4)(6)=104; at x=8, y-hat=104+(-4)(8)=72.' from version_ins
union all select gen_random_uuid(), id, 'D', '80, because a least-squares line predicts the sample mean at every x-value.', false, 'The line predicts y-bar at x-bar, not at every explanatory value when its slope is nonzero.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-b-v3', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed B (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Technology gives a least-squares slope of -3 for predicting fuel remaining from distance traveled. The sample means are x-bar=5 and y-bar=30. Using the fact that the line passes through the means, what is the predicted response at x=7?', null, md5('apstats-mcq-b8-sv-h-5.5-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9, because y-bar=30 is the intercept of the line.', false, 'The least-squares line passes through the two means, but its y-intercept is y-bar minus slope times x-bar, not generally y-bar.' from version_ins
union all select gen_random_uuid(), id, 'B', '29, because x-bar must be added to the predicted response after applying the slope.', false, 'The explanatory mean is used to solve for the intercept; it is not added to a predicted response, which has different units.' from version_ins
union all select gen_random_uuid(), id, 'C', '24, because the intercept is 45 and y-hat=45-3x.', true, 'Correct: The line passes through (5,30), so a=30-(-3)(5)=45; at x=7, y-hat=45+(-3)(7)=24.' from version_ins
union all select gen_random_uuid(), id, 'D', '30, because a least-squares line predicts the sample mean at every x-value.', false, 'The line predicts y-bar at x-bar, not at every explanatory value when its slope is nonzero.' from version_ins;
-- apstats-mcq-b8-h-5.1-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.1-c', 'mcq', 'diagnose nonlinear form', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of electricity demand against daily temperature has a roughly flat pattern over low x-values and then rises sharply over high x-values, with no isolated points. A student describes the association as one straight line. Which criticism best addresses the full plot?', null, md5('apstats-mcq-b8-h-5.1-c'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Because there are no isolated points, the association must be linear even when its steepness changes.', false, 'A lack of outliers does not make a changing slope linear.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The direction and steepness change across x, so describe the form as nonlinear and report the two regions rather than one linear trend.', true, 'Correct: The stated low- and high-x regions have different slopes; a single straight line does not describe both. Axes should retain explanatory x and response y.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The association has no form because its low and high x regions do not have identical slopes.', false, 'A relationship can have a clear curved or piecewise form even when a single slope is inadequate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Changing the explanatory variable to the vertical axis would make the two regions one straight line.', false, 'Swapping axes does not remove a change in slope and reverses the explanatory/response roles.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-c-v1', 'mcq', 'diagnose nonlinear form (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of plant height against time since planting has a rises sharply pattern over low x-values and then roughly flat over high x-values, with no isolated points. A student describes the association as one straight line. Which criticism best addresses the full plot?', null, md5('apstats-mcq-b8-sv-h-5.1-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Because there are no isolated points, the association must be linear even when its steepness changes.', false, 'A lack of outliers does not make a changing slope linear.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association has no form because its low and high x regions do not have identical slopes.', false, 'A relationship can have a clear curved or piecewise form even when a single slope is inadequate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Changing the explanatory variable to the vertical axis would make the two regions one straight line.', false, 'Swapping axes does not remove a change in slope and reverses the explanatory/response roles.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The direction and steepness change across x, so describe the form as nonlinear and report the two regions rather than one linear trend.', true, 'Correct: The stated low- and high-x regions have different slopes; a single straight line does not describe both. Axes should retain explanatory x and response y.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-c-v2', 'mcq', 'diagnose nonlinear form (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of turbine output against wind speed has a roughly flat pattern over low x-values and then falls sharply over high x-values, with no isolated points. A student describes the association as one straight line. Which criticism best addresses the full plot?', null, md5('apstats-mcq-b8-sv-h-5.1-c-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Because there are no isolated points, the association must be linear even when its steepness changes.', false, 'A lack of outliers does not make a changing slope linear.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association has no form because its low and high x regions do not have identical slopes.', false, 'A relationship can have a clear curved or piecewise form even when a single slope is inadequate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The direction and steepness change across x, so describe the form as nonlinear and report the two regions rather than one linear trend.', true, 'Correct: The stated low- and high-x regions have different slopes; a single straight line does not describe both. Axes should retain explanatory x and response y.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Changing the explanatory variable to the vertical axis would make the two regions one straight line.', false, 'Swapping axes does not remove a change in slope and reverses the explanatory/response roles.' from version_ins;
-- apstats-mcq-b8-sv-h-5.1-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.1-c-v3', 'mcq', 'diagnose nonlinear form (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of response against dosage has a falls sharply pattern over low x-values and then roughly flat over high x-values, with no isolated points. A student describes the association as one straight line. Which criticism best addresses the full plot?', null, md5('apstats-mcq-b8-sv-h-5.1-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Because there are no isolated points, the association must be linear even when its steepness changes.', false, 'A lack of outliers does not make a changing slope linear.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The association has no form because its low and high x regions do not have identical slopes.', false, 'A relationship can have a clear curved or piecewise form even when a single slope is inadequate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The direction and steepness change across x, so describe the form as nonlinear and report the two regions rather than one linear trend.', true, 'Correct: The stated low- and high-x regions have different slopes; a single straight line does not describe both. Axes should retain explanatory x and response y.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Changing the explanatory variable to the vertical axis would make the two regions one straight line.', false, 'Swapping axes does not remove a change in slope and reverses the explanatory/response roles.' from version_ins;
-- apstats-mcq-b8-h-5.2-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.2-c', 'mcq', 'interpret correlation with nonlinear scatterplot', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of solar output against time of day has a pronounced arched pattern, but its computed correlation is r=+0.02. A student proposes using a straight-line equation to predict every response and claims the small r proves there is no relationship. Which critique addresses both parts of the proposal?', null, md5('apstats-mcq-b8-h-5.2-c'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The correlation proves the two variables are independent, so a straight line is the only model worth testing.', false, 'Near-zero Pearson r does not establish independence when a nonlinear pattern is visible; a line would also miss that form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The curved pattern must be a plotting error because a correlation close to zero prohibits association.', false, 'The reported r and visible curvature can coexist because r describes only the linear component.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The small r guarantees that a straight line predicts each observed response exactly despite the curve.', false, 'A small |r| does not guarantee small residuals; the visible curve is evidence against exact line predictions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A straight line would miss the arched form; the small r describes weak linear association, not absence of every association.', true, 'Correct: Pearson correlation measures linear association. The stated curved form warns that a single straight-line predictor misses systematic structure even if its r is close to zero.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-h-5.5-b','apstats-mcq-b8-sv-h-5.5-b-v1','apstats-mcq-b8-sv-h-5.5-b-v2','apstats-mcq-b8-sv-h-5.5-b-v3','apstats-mcq-b8-h-5.1-c','apstats-mcq-b8-sv-h-5.1-c-v1','apstats-mcq-b8-sv-h-5.1-c-v2','apstats-mcq-b8-sv-h-5.1-c-v3','apstats-mcq-b8-h-5.2-c']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-h-5.5-b','apstats-mcq-b8-sv-h-5.5-b-v1','apstats-mcq-b8-sv-h-5.5-b-v2','apstats-mcq-b8-sv-h-5.5-b-v3','apstats-mcq-b8-h-5.1-c','apstats-mcq-b8-sv-h-5.1-c-v1','apstats-mcq-b8-sv-h-5.1-c-v2','apstats-mcq-b8-sv-h-5.1-c-v3','apstats-mcq-b8-h-5.2-c']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
