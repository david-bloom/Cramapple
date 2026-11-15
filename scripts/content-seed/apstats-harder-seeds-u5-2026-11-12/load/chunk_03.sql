begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.3-a-v2','apstats-mcq-b8-sv-h-5.3-a-v3','apstats-mcq-b8-h-5.3-b','apstats-mcq-b8-sv-h-5.3-b-v1','apstats-mcq-b8-sv-h-5.3-b-v2','apstats-mcq-b8-sv-h-5.3-b-v3','apstats-mcq-b8-h-5.4-a','apstats-mcq-b8-sv-h-5.4-a-v1','apstats-mcq-b8-sv-h-5.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apstats-mcq-b8-sv-h-5.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-a-v2', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear model fitted using weeks after planting from 1 to 8 predicts plant height in cm by y-hat=5+2x. What should an analyst report for x=10?', null, md5('apstats-mcq-b8-sv-h-5.3-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model predicts 25 plant height in cm, and this is interpolation because the equation accepts x=10.', false, 'A fitted equation can be evaluated outside the observed x-range, but that use is extrapolation, not interpolation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model predicts 9 plant height in cm, since the model input must be the distance past the largest observed x.', false, 'The model uses the actual explanatory value x, not the distance past the edge of the data range.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model predicts 25 plant height in cm, but this is extrapolation beyond the fitted x-range and is less reliable.', true, 'Correct: Substitute x=10: 5+2(10)=25. Since 10>8, the prediction extrapolates; the equation yields a value but reliability is weaker outside the data range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No predicted value can be calculated once x lies outside the observed range.', false, 'Extrapolation is less reliable, yet the model still produces a numerical prediction when x is substituted.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-a-v3', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear model fitted using daily temperature in degrees from 12 to 30 predicts ice cream sales by y-hat=20+5x. What should an analyst report for x=34?', null, md5('apstats-mcq-b8-sv-h-5.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model predicts 190 ice cream sales, and this is interpolation because the equation accepts x=34.', false, 'A fitted equation can be evaluated outside the observed x-range, but that use is extrapolation, not interpolation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model predicts 190 ice cream sales, but this is extrapolation beyond the fitted x-range and is less reliable.', true, 'Correct: Substitute x=34: 20+5(34)=190. Since 34>30, the prediction extrapolates; the equation yields a value but reliability is weaker outside the data range.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model predicts 40 ice cream sales, since the model input must be the distance past the largest observed x.', false, 'The model uses the actual explanatory value x, not the distance past the edge of the data range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No predicted value can be calculated once x lies outside the observed range.', false, 'Extrapolation is less reliable, yet the model still produces a numerical prediction when x is substituted.' from version_ins;
-- apstats-mcq-b8-h-5.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.3-b', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed B', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model predicts a response y from distance x measured in kilometers: y-hat=10+2x. The same observation has x=3 kilometers. If x is instead recorded in meters (1000 meters per kilometers), which equation and prediction describe the same model?', null, md5('apstats-mcq-b8-h-5.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y-hat=10+(2000)x_new, which predicts 6000010 at x_new=3000.', false, 'The slope per new unit is the old slope divided by the number of new units in one old unit; multiplying it gives a different prediction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y-hat=10+(0.002)x_new, which predicts 16 at x_new=3000.', true, 'Correct: x_new=1000x, so x=x_new/1000. Substitute into the original equation: y-hat=10+(0.002)x_new. At x_new=3000, the prediction is 16.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y-hat=10+2x_new, which predicts 6010 at x_new=3000.', false, 'Keeping the numerical slope after changing the x-unit changes the model and inflates the predicted response.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y-hat=10000+(0.002)x_new, which predicts 10006 at x_new=3000.', false, 'Only the explanatory variable''s unit changed; multiplying the response intercept by the conversion factor changes the response scale incorrectly.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-b-v1', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed B (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model predicts a response y from time x measured in hours: y-hat=20+5x. The same observation has x=2 hours. If x is instead recorded in minutes (60 minutes per hours), which equation and prediction describe the same model?', null, md5('apstats-mcq-b8-sv-h-5.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y-hat=20+(300)x_new, which predicts 36020 at x_new=120.', false, 'The slope per new unit is the old slope divided by the number of new units in one old unit; multiplying it gives a different prediction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y-hat=20+5x_new, which predicts 620 at x_new=120.', false, 'Keeping the numerical slope after changing the x-unit changes the model and inflates the predicted response.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y-hat=1200+(0.0833333)x_new, which predicts 1210 at x_new=120.', false, 'Only the explanatory variable''s unit changed; multiplying the response intercept by the conversion factor changes the response scale incorrectly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y-hat=20+(0.0833333)x_new, which predicts 30 at x_new=120.', true, 'Correct: x_new=60x, so x=x_new/60. Substitute into the original equation: y-hat=20+(0.0833333)x_new. At x_new=120, the prediction is 30.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-b-v2', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed B (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model predicts a response y from mass x measured in kilograms: y-hat=8+4x. The same observation has x=6 kilograms. If x is instead recorded in grams (1000 grams per kilograms), which equation and prediction describe the same model?', null, md5('apstats-mcq-b8-sv-h-5.3-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y-hat=8+(0.004)x_new, which predicts 32 at x_new=6000.', true, 'Correct: x_new=1000x, so x=x_new/1000. Substitute into the original equation: y-hat=8+(0.004)x_new. At x_new=6000, the prediction is 32.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y-hat=8+(4000)x_new, which predicts 24000008 at x_new=6000.', false, 'The slope per new unit is the old slope divided by the number of new units in one old unit; multiplying it gives a different prediction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y-hat=8+4x_new, which predicts 24008 at x_new=6000.', false, 'Keeping the numerical slope after changing the x-unit changes the model and inflates the predicted response.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y-hat=8000+(0.004)x_new, which predicts 8024 at x_new=6000.', false, 'Only the explanatory variable''s unit changed; multiplying the response intercept by the conversion factor changes the response scale incorrectly.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-b-v3', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed B (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model predicts a response y from volume x measured in liters: y-hat=12+3x. The same observation has x=5 liters. If x is instead recorded in milliliters (1000 milliliters per liters), which equation and prediction describe the same model?', null, md5('apstats-mcq-b8-sv-h-5.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y-hat=12+(3000)x_new, which predicts 15000012 at x_new=5000.', false, 'The slope per new unit is the old slope divided by the number of new units in one old unit; multiplying it gives a different prediction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y-hat=12+(0.003)x_new, which predicts 27 at x_new=5000.', true, 'Correct: x_new=1000x, so x=x_new/1000. Substitute into the original equation: y-hat=12+(0.003)x_new. At x_new=5000, the prediction is 27.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y-hat=12+3x_new, which predicts 15012 at x_new=5000.', false, 'Keeping the numerical slope after changing the x-unit changes the model and inflates the predicted response.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y-hat=12000+(0.003)x_new, which predicts 12015 at x_new=5000.', false, 'Only the explanatory variable''s unit changed; multiplying the response intercept by the conversion factor changes the response scale incorrectly.' from version_ins;
-- apstats-mcq-b8-h-5.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.4-a', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fitted line for fitness score versus training hours is y-hat=12+3x. The observed responses are 21 at x=4 and 32 at x=5. Which statement correctly compares the two prediction errors?', null, md5('apstats-mcq-b8-h-5.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The residuals are +3 and -5; the second observation has the larger absolute prediction error.', false, 'Residuals subtract predicted from observed, not observed from predicted, so both signs are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The residuals are -3 and +5; the second observation has the larger absolute prediction error.', true, 'Correct: Predictions are 24 and 27. Observed minus predicted gives residuals -3 and +5; compare their absolute values, 3 and 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The residuals are -3 and +5; the first observation has the larger absolute prediction error.', false, 'The residual values are correct, but comparing absolute errors selects the other observation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The residuals are the predicted responses 24 and 27; the larger prediction is always the larger error.', false, 'Predicted values are not residuals; the size of a prediction does not by itself show its error.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-a-v1', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fitted line for crop yield versus daily rainfall is y-hat=7+5x. The observed responses are 26 at x=3 and 21 at x=4. Which statement correctly compares the two prediction errors?', null, md5('apstats-mcq-b8-sv-h-5.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The residuals are -4 and +6; the second observation has the larger absolute prediction error.', false, 'Residuals subtract predicted from observed, not observed from predicted, so both signs are reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The residuals are +4 and -6; the first observation has the larger absolute prediction error.', false, 'The residual values are correct, but comparing absolute errors selects the other observation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The residuals are the predicted responses 22 and 27; the larger prediction is always the larger error.', false, 'Predicted values are not residuals; the size of a prediction does not by itself show its error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The residuals are +4 and -6; the second observation has the larger absolute prediction error.', true, 'Correct: Predictions are 22 and 27. Observed minus predicted gives residuals +4 and -6; compare their absolute values, 4 and 6.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-a-v2', 'mcq', 'AP Statistics Unit 5 topic 5.4, seed A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fitted line for sales versus advertising hours is y-hat=15+4x. The observed responses are 31 at x=5 and 44 at x=6. Which statement correctly compares the two prediction errors?', null, md5('apstats-mcq-b8-sv-h-5.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The residuals are -4 and +5; the second observation has the larger absolute prediction error.', true, 'Correct: Predictions are 35 and 39. Observed minus predicted gives residuals -4 and +5; compare their absolute values, 4 and 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The residuals are +4 and -5; the second observation has the larger absolute prediction error.', false, 'Residuals subtract predicted from observed, not observed from predicted, so both signs are reversed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The residuals are -4 and +5; the first observation has the larger absolute prediction error.', false, 'The residual values are correct, but comparing absolute errors selects the other observation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The residuals are the predicted responses 35 and 39; the larger prediction is always the larger error.', false, 'Predicted values are not residuals; the size of a prediction does not by itself show its error.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.3-a-v2','apstats-mcq-b8-sv-h-5.3-a-v3','apstats-mcq-b8-h-5.3-b','apstats-mcq-b8-sv-h-5.3-b-v1','apstats-mcq-b8-sv-h-5.3-b-v2','apstats-mcq-b8-sv-h-5.3-b-v3','apstats-mcq-b8-h-5.4-a','apstats-mcq-b8-sv-h-5.4-a-v1','apstats-mcq-b8-sv-h-5.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-sv-h-5.3-a-v2','apstats-mcq-b8-sv-h-5.3-a-v3','apstats-mcq-b8-h-5.3-b','apstats-mcq-b8-sv-h-5.3-b-v1','apstats-mcq-b8-sv-h-5.3-b-v2','apstats-mcq-b8-sv-h-5.3-b-v3','apstats-mcq-b8-h-5.4-a','apstats-mcq-b8-sv-h-5.4-a-v1','apstats-mcq-b8-sv-h-5.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
