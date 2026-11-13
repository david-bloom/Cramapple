begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.4-a-v3','apstats-mcq-b8-h-5.4-b','apstats-mcq-b8-sv-h-5.4-b-v1','apstats-mcq-b8-sv-h-5.4-b-v2','apstats-mcq-b8-sv-h-5.4-b-v3','apstats-mcq-b8-h-5.5-a','apstats-mcq-b8-sv-h-5.5-a-v1','apstats-mcq-b8-sv-h-5.5-a-v2','apstats-mcq-b8-sv-h-5.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apstats-mcq-b8-sv-h-5.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-a-v3', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fitted line for output versus machine temperature is y-hat=30-2x. The observed responses are 21 at x=6 and 9 at x=8. Which statement correctly compares the two prediction errors?', null, md5('apstats-mcq-b8-sv-h-5.4-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The residuals are -3 and +5; the second observation has the larger absolute prediction error.', false, 'Residuals subtract predicted from observed, not observed from predicted, so both signs are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The residuals are +3 and -5; the first observation has the larger absolute prediction error.', false, 'The residual values are correct, but comparing absolute errors selects the other observation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The residuals are +3 and -5; the second observation has the larger absolute prediction error.', true, 'Correct: Predictions are 18 and 14. Observed minus predicted gives residuals +3 and -5; compare their absolute values, 3 and 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The residuals are the predicted responses 18 and 14; the larger prediction is always the larger error.', false, 'Predicted values are not residuals; the size of a prediction does not by itself show its error.' from version_ins;
-- apstats-mcq-b8-h-5.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.4-b', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed B', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a proposed straight-line model predicting electricity demand from temperature, the residual plot gives (x, residual) values (1,+4), (2,+1), (3,-2), (4,+1), (5,+4). Which assessment follows from the residual pattern?', null, md5('apstats-mcq-b8-h-5.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The errors for electricity demand are randomly scattered because both positive and negative residuals occur.', false, 'The order across explanatory values matters; the visible systematic pattern is not erased by having both residual signs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A systematic U-shape remains, so the straight-line form misses structure.', true, 'Correct: Read the residuals in temperature order. The curve pattern is systematic; positive and negative values alone do not establish random scatter.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The largest residual alone proves that every prediction of electricity demand has the same error direction.', false, 'One residual gives the error for one observation, not the sign of every model error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A fitted model of electricity demand is useful only when every residual equals zero.', false, 'Useful fitted models can have nonzero residuals; the relevant diagnostic is their pattern and spread.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-b-v1', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed B (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a proposed straight-line model predicting reaction time from dosage, the residual plot gives (x, residual) values (1,-3), (2,+0), (3,+2), (4,+0), (5,-3). Which assessment follows from the residual pattern?', null, md5('apstats-mcq-b8-sv-h-5.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The errors for reaction time are randomly scattered because both positive and negative residuals occur.', false, 'The order across explanatory values matters; the visible systematic pattern is not erased by having both residual signs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An inverted U-shape remains, so the straight-line form misses structure.', true, 'Correct: Read the residuals in dosage order. The curve pattern is systematic; positive and negative values alone do not establish random scatter.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The largest residual alone proves that every prediction of reaction time has the same error direction.', false, 'One residual gives the error for one observation, not the sign of every model error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A fitted model of reaction time is useful only when every residual equals zero.', false, 'Useful fitted models can have nonzero residuals; the relevant diagnostic is their pattern and spread.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-b-v2', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed B (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a proposed straight-line model predicting pollution level from time of day, the residual plot gives (x, residual) values (1,-1), (2,+0), (3,+1), (4,+3), (5,+5). Which assessment follows from the residual pattern?', null, md5('apstats-mcq-b8-sv-h-5.4-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The residuals increase across x, so the line has a systematic bias rather than random error.', true, 'Correct: Read the residuals in time of day order. The trend pattern is systematic; positive and negative values alone do not establish random scatter.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The errors for pollution level are randomly scattered because both positive and negative residuals occur.', false, 'The order across explanatory values matters; the visible systematic pattern is not erased by having both residual signs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The largest residual alone proves that every prediction of pollution level has the same error direction.', false, 'One residual gives the error for one observation, not the sign of every model error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A fitted model of pollution level is useful only when every residual equals zero.', false, 'Useful fitted models can have nonzero residuals; the relevant diagnostic is their pattern and spread.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-b-v3', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed B (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a proposed straight-line model predicting fuel use from speed, the residual plot gives (x, residual) values (1,+0), (2,+1), (3,-1), (4,+2), (5,-2). Which assessment follows from the residual pattern?', null, md5('apstats-mcq-b8-sv-h-5.4-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The errors for fuel use are randomly scattered because both positive and negative residuals occur.', false, 'The order across explanatory values matters; the visible systematic pattern is not erased by having both residual signs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The largest residual alone proves that every prediction of fuel use has the same error direction.', false, 'One residual gives the error for one observation, not the sign of every model error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A fitted model of fuel use is useful only when every residual equals zero.', false, 'Useful fitted models can have nonzero residuals; the relevant diagnostic is their pattern and spread.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The residual magnitudes grow across x, so the errors have changing spread even without a curved mean pattern.', true, 'Correct: Read the residuals in speed order. The spread pattern is systematic; positive and negative values alone do not establish random scatter.' from version_ins;
-- apstats-mcq-b8-h-5.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.5-a', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicts exam score from study time. Its slope is +3 response units per additional explanatory unit and r=+0.80. Which interpretation combines the slope and coefficient of determination correctly?', null, md5('apstats-mcq-b8-h-5.5-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For one more unit of study time, observed exam score must increase by exactly 3 units; about 80% of its variation is explained.', false, 'A regression slope predicts an average change rather than a guaranteed change for each observation, and explained variation uses r squared rather than r.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 64% of variation in study time is explained by the linear relationship with exam score, so the prediction direction can be reversed without refitting.', false, 'The coefficient of determination describes variation in the response variable, not variation in the explanatory variable; reversing prediction changes the question.' from version_ins
union all select gen_random_uuid(), id, 'C', 'For one more unit of study time, predicted exam score tends to increase by 3 units; about 64% of variation in exam score is explained by its linear relationship with study time.', true, 'Correct: Slope concerns predicted response per one-unit explanatory increase. r²=0.64, so 64% of variation in the response is explained by the linear relationship; neither exact outcomes nor causation follows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Because r is +0.80, changing study time causes the predicted increase in exam score and explains all observed variation.', false, 'A correlation and fitted slope alone do not establish causation or explain all variation in observed responses.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-a-v1', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicts water temperature from distance from shore. Its slope is -2 response units per additional explanatory unit and r=-0.70. Which interpretation combines the slope and coefficient of determination correctly?', null, md5('apstats-mcq-b8-sv-h-5.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For one more unit of distance from shore, observed water temperature must decrease by exactly 2 units; about 70% of its variation is explained.', false, 'A regression slope predicts an average change rather than a guaranteed change for each observation, and explained variation uses r squared rather than r.' from version_ins
union all select gen_random_uuid(), id, 'B', 'For one more unit of distance from shore, predicted water temperature tends to decrease by 2 units; about 49% of variation in water temperature is explained by its linear relationship with distance from shore.', true, 'Correct: Slope concerns predicted response per one-unit explanatory increase. r²=0.49, so 49% of variation in the response is explained by the linear relationship; neither exact outcomes nor causation follows.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 49% of variation in distance from shore is explained by the linear relationship with water temperature, so the prediction direction can be reversed without refitting.', false, 'The coefficient of determination describes variation in the response variable, not variation in the explanatory variable; reversing prediction changes the question.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Because r is -0.70, changing distance from shore causes the predicted decrease in water temperature and explains all observed variation.', false, 'A correlation and fitted slope alone do not establish causation or explain all variation in observed responses.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-a-v2', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicts output from machine age. Its slope is -4 response units per additional explanatory unit and r=-0.90. Which interpretation combines the slope and coefficient of determination correctly?', null, md5('apstats-mcq-b8-sv-h-5.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For one more unit of machine age, predicted output tends to decrease by 4 units; about 81% of variation in output is explained by its linear relationship with machine age.', true, 'Correct: Slope concerns predicted response per one-unit explanatory increase. r²=0.81, so 81% of variation in the response is explained by the linear relationship; neither exact outcomes nor causation follows.' from version_ins
union all select gen_random_uuid(), id, 'B', 'For one more unit of machine age, observed output must decrease by exactly 4 units; about 90% of its variation is explained.', false, 'A regression slope predicts an average change rather than a guaranteed change for each observation, and explained variation uses r squared rather than r.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 81% of variation in machine age is explained by the linear relationship with output, so the prediction direction can be reversed without refitting.', false, 'The coefficient of determination describes variation in the response variable, not variation in the explanatory variable; reversing prediction changes the question.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Because r is -0.90, changing machine age causes the predicted decrease in output and explains all observed variation.', false, 'A correlation and fitted slope alone do not establish causation or explain all variation in observed responses.' from version_ins;
-- apstats-mcq-b8-sv-h-5.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.5-a-v3', 'mcq', 'AP Statistics Unit 5 topic 5.5, seed A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line predicts completion score from practice sessions. Its slope is +5 response units per additional explanatory unit and r=+0.60. Which interpretation combines the slope and coefficient of determination correctly?', null, md5('apstats-mcq-b8-sv-h-5.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For one more unit of practice sessions, observed completion score must increase by exactly 5 units; about 60% of its variation is explained.', false, 'A regression slope predicts an average change rather than a guaranteed change for each observation, and explained variation uses r squared rather than r.' from version_ins
union all select gen_random_uuid(), id, 'B', 'For one more unit of practice sessions, predicted completion score tends to increase by 5 units; about 36% of variation in completion score is explained by its linear relationship with practice sessions.', true, 'Correct: Slope concerns predicted response per one-unit explanatory increase. r²=0.36, so 36% of variation in the response is explained by the linear relationship; neither exact outcomes nor causation follows.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 36% of variation in practice sessions is explained by the linear relationship with completion score, so the prediction direction can be reversed without refitting.', false, 'The coefficient of determination describes variation in the response variable, not variation in the explanatory variable; reversing prediction changes the question.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Because r is +0.60, changing practice sessions causes the predicted increase in completion score and explains all observed variation.', false, 'A correlation and fitted slope alone do not establish causation or explain all variation in observed responses.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.4-a-v3','apstats-mcq-b8-h-5.4-b','apstats-mcq-b8-sv-h-5.4-b-v1','apstats-mcq-b8-sv-h-5.4-b-v2','apstats-mcq-b8-sv-h-5.4-b-v3','apstats-mcq-b8-h-5.5-a','apstats-mcq-b8-sv-h-5.5-a-v1','apstats-mcq-b8-sv-h-5.5-a-v2','apstats-mcq-b8-sv-h-5.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-sv-h-5.4-a-v3','apstats-mcq-b8-h-5.4-b','apstats-mcq-b8-sv-h-5.4-b-v1','apstats-mcq-b8-sv-h-5.4-b-v2','apstats-mcq-b8-sv-h-5.4-b-v3','apstats-mcq-b8-h-5.5-a','apstats-mcq-b8-sv-h-5.5-a-v1','apstats-mcq-b8-sv-h-5.5-a-v2','apstats-mcq-b8-sv-h-5.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
