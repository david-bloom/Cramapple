begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-h-2.5-b','apprecalc-mcq-b7-sv-h-2.5-b-v1','apprecalc-mcq-b7-sv-h-2.5-b-v2','apprecalc-mcq-b7-sv-h-2.5-b-v3','apprecalc-mcq-b7-h-2.6-a','apprecalc-mcq-b7-sv-h-2.6-a-v1','apprecalc-mcq-b7-sv-h-2.6-a-v2','apprecalc-mcq-b7-sv-h-2.6-a-v3','apprecalc-mcq-b7-h-2.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-h-2.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.5-b', 'mcq', 'convert a yearly growth or decay factor to the factor and percent change for a shorter period by taking a root, not by d', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The view count of a viral video is modeled by an exponential function of time t in years. Each full year, the view count is multiplied by 9. By what percent does the view count change over any 6-month period?', null, md5('apprecalc-mcq-b7-h-2.5-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The view count increases by 200%', true, 'Correct: Let c be the factor per 6 months. Then c^2 = 9, so c = 3. The view count is multiplied by 3 every 6 months, a change of (3 − 1)·100% = 200%.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The view count increases by 400%', false, 'This divides the full-year percent change, 800%, by 2. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period''s change is applied to the already-changed amount.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The view count increases by 350%', false, 'This divides the yearly factor 9 by 2 to get a factor of 9/2 per 6 months. Factors combine by multiplication, so 2 equal periods must multiply to 9, which requires the factor to be a square root of 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The view count increases by 300%', false, 'This reports the 6-month factor 3 as if it were the percent change. A factor of 3 means the amount is multiplied by 3, which is a change of 200%, not 300%.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.5-b-v1', 'mcq', 'convert a yearly growth or decay factor to the factor and percent change for a shorter period by taking a root, not by d (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The population of a bacteria culture is modeled by an exponential function of time t in years. Each full year, the population is multiplied by 16. By what percent does the population change over any 3-month period?', null, md5('apprecalc-mcq-b7-sv-h-2.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The population increases by 100%', true, 'Correct: Let c be the factor per 3 months. Then c^4 = 16, so c = 2. The population is multiplied by 2 every 3 months, a change of (2 − 1)·100% = 100%.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The population increases by 375%', false, 'This divides the full-year percent change, 1500%, by 4. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period''s change is applied to the already-changed amount.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The population increases by 300%', false, 'This divides the yearly factor 16 by 4 to get a factor of 4 per 3 months. Factors combine by multiplication, so 4 equal periods must multiply to 16, which requires the factor to be a 4th root of 16.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The population increases by 200%', false, 'This reports the 3-month factor 2 as if it were the percent change. A factor of 2 means the amount is multiplied by 2, which is a change of 100%, not 200%.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.5-b-v2', 'mcq', 'convert a yearly growth or decay factor to the factor and percent change for a shorter period by taking a root, not by d (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The mass of a radioactive sample is modeled by an exponential function of time t in years. Each full year, the mass is multiplied by 1/25. By what percent does the mass change over any 6-month period?', null, md5('apprecalc-mcq-b7-sv-h-2.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The mass decreases by 48%', false, 'This divides the full-year percent change, 96%, by 2. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period''s change is applied to the already-changed amount.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mass decreases by 80%', true, 'Correct: Let c be the factor per 6 months. Then c^2 = 1/25, so c = 1/5. The mass is multiplied by 1/5 every 6 months, a change of (1/5 − 1)·100% = −80%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The mass decreases by 98%', false, 'This divides the yearly factor 1/25 by 2 to get a factor of 1/50 per 6 months. Factors combine by multiplication, so 2 equal periods must multiply to 1/25, which requires the factor to be a square root of 1/25.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mass decreases by 20%', false, 'This reports the 6-month factor 1/5 as if it were the percent change. A factor of 1/5 means the amount is multiplied by 1/5, which is a change of 80%, not 20%.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.5-b-v3', 'mcq', 'convert a yearly growth or decay factor to the factor and percent change for a shorter period by taking a root, not by d (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of seedlings of a tree farm is modeled by an exponential function of time t in years. Each full year, the number of seedlings is multiplied by 9/4. By what percent does the number of seedlings change over any 6-month period?', null, md5('apprecalc-mcq-b7-sv-h-2.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The number of seedlings increases by 62.5%', false, 'This divides the full-year percent change, 125%, by 2. Percent changes of an exponential quantity do not split evenly across sub-periods, because each period''s change is applied to the already-changed amount.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The number of seedlings increases by 50%', true, 'Correct: Let c be the factor per 6 months. Then c^2 = 9/4, so c = 3/2. The number of seedlings is multiplied by 3/2 every 6 months, a change of (3/2 − 1)·100% = 50%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The number of seedlings increases by 12.5%', false, 'This divides the yearly factor 9/4 by 2 to get a factor of 9/8 per 6 months. Factors combine by multiplication, so 2 equal periods must multiply to 9/4, which requires the factor to be a square root of 9/4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The number of seedlings increases by 150%', false, 'This reports the 6-month factor 3/2 as if it were the percent change. A factor of 3/2 means the amount is multiplied by 3/2, which is a change of 50%, not 150%.' from version_ins;
-- apprecalc-mcq-b7-h-2.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.6-a', 'mcq', 'judge a regression model by residuals on the data range, then recognize that a prediction far outside that range can vio', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town has 40 thousand residents. Over the 9 months after a local app launched, its number of active users U (in thousands) was recorded each month, and the exponential regression is U(t) = 2.1·1.38ᵗ, where t is months since launch. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 24. Which conclusion is best supported?', null, md5('apprecalc-mcq-b7-h-2.6-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The random residuals show the exponential model fits at every value of t, so the prediction U(24) ≈ 4,779 can be trusted.', false, 'Random residuals support the model only over the range of the data, 0 ≤ t ≤ 9. They say nothing about t = 24, which is far outside that range, and the predicted value is far above the town''s 40 thousand residents.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Because U(24) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 9, despite its random residuals.', false, 'A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 9 the random residuals show a good fit; the limit applies to extrapolation beyond that range.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.', false, 'Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The model fits the data for 0 ≤ t ≤ 9, but the prediction U(24) ≈ 4,779 thousand, far above the town''s 40 thousand residents, so it should not be trusted at t = 24.', true, 'Correct: U(24) = 2.1·1.38^24 ≈ 4,779, and this is far above the town''s 40 thousand residents. The data cover only 0 ≤ t ≤ 9, so the random residuals support the model only on that range.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.6-a-v1', 'mcq', 'judge a regression model by residuals on the data range, then recognize that a prediction far outside that range can vio (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lab dish can hold at most 5 million bacteria. Over the first 6 hours, the count B (in millions) was recorded each hour, and the exponential regression is B(t) = 0.08·1.9ᵗ, where t is hours. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 20. Which conclusion is best supported?', null, md5('apprecalc-mcq-b7-sv-h-2.6-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The random residuals show the exponential model fits at every value of t, so the prediction B(20) ≈ 30,072 can be trusted.', false, 'Random residuals support the model only over the range of the data, 0 ≤ t ≤ 6. They say nothing about t = 20, which is far outside that range, and the predicted value is far above the dish''s capacity of 5 million.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Because B(20) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 6, despite its random residuals.', false, 'A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 6 the random residuals show a good fit; the limit applies to extrapolation beyond that range.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model fits the data for 0 ≤ t ≤ 6, but the prediction B(20) ≈ 30,072 million, far above the dish''s capacity of 5 million, so it should not be trusted at t = 20.', true, 'Correct: B(20) = 0.08·1.9^20 ≈ 30,072, and this is far above the dish''s capacity of 5 million. The data cover only 0 ≤ t ≤ 6, so the random residuals support the model only on that range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.', false, 'Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.6-a-v2', 'mcq', 'judge a regression model by residuals on the data range, then recognize that a prediction far outside that range can vio (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cup of coffee cools in a room kept at 21°C. Over the first 10 minutes, its temperature T (in °C) was recorded each minute, and the exponential regression is T(t) = 80·0.93ᵗ, where t is minutes. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 40. Which conclusion is best supported?', null, md5('apprecalc-mcq-b7-sv-h-2.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The random residuals show the exponential model fits at every value of t, so the prediction T(40) ≈ 4.4 can be trusted.', false, 'Random residuals support the model only over the range of the data, 0 ≤ t ≤ 10. They say nothing about t = 40, which is far outside that range, and the predicted value is below the room temperature of 21°C, which the coffee cannot reach.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Because T(40) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 10, despite its random residuals.', false, 'A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 10 the random residuals show a good fit; the limit applies to extrapolation beyond that range.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model fits the data for 0 ≤ t ≤ 10, but the prediction T(40) ≈ 4.4°C, below the room temperature of 21°C, which the coffee cannot reach, so it should not be trusted at t = 40.', true, 'Correct: T(40) = 80·0.93^40 ≈ 4.4, and this is below the room temperature of 21°C, which the coffee cannot reach. The data cover only 0 ≤ t ≤ 10, so the random residuals support the model only on that range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.', false, 'Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.6-a-v3', 'mcq', 'judge a regression model by residuals on the data range, then recognize that a prediction far outside that range can vio (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The tallest tree species in a region reaches about 115 m. For a young tree of that region, its height h (in meters) was recorded each year for 8 years, and the exponential regression is h(t) = 0.5·1.25ᵗ, where t is years. The residual plot for the regression shows points scattered randomly above and below zero, with no pattern. The model is used to predict the value at t = 40. Which conclusion is best supported?', null, md5('apprecalc-mcq-b7-sv-h-2.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model fits the data for 0 ≤ t ≤ 8, but the prediction h(40) ≈ 3,762 m, far above the 115 m that trees in the region can reach, so it should not be trusted at t = 40.', true, 'Correct: h(40) = 0.5·1.25^40 ≈ 3,762, and this is far above the 115 m that trees in the region can reach. The data cover only 0 ≤ t ≤ 8, so the random residuals support the model only on that range.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The random residuals show the exponential model fits at every value of t, so the prediction h(40) ≈ 3,762 can be trusted.', false, 'Random residuals support the model only over the range of the data, 0 ≤ t ≤ 8. They say nothing about t = 40, which is far outside that range, and the predicted value is far above the 115 m that trees in the region can reach.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Because h(40) is impossible, the exponential model must also be rejected for 0 ≤ t ≤ 8, despite its random residuals.', false, 'A prediction that fails far outside the data does not invalidate the model inside the data. Within 0 ≤ t ≤ 8 the random residuals show a good fit; the limit applies to extrapolation beyond that range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Exponential models are never appropriate for real-world data, so the random residuals should be ignored and a linear model used instead.', false, 'Exponential models are appropriate over a range where ratios stay close to constant, and random residuals are evidence of that. The model is limited in how far it can be extended, which is different from never being appropriate.' from version_ins;
-- apprecalc-mcq-b7-h-2.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.6-b', 'mcq', 'choose between linear, quadratic and exponential models from a table by checking first differences, second differences a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives values of a function f at equally spaced inputs: x = 0, 1, 2, 3, 4, 5 and f(x) = 1, 6, 15, 28, 45, 66, respectively. Which model is best supported by these values?', null, md5('apprecalc-mcq-b7-h-2.6-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An exponential model, because the first differences are not constant', false, 'The first differences (5, 9, 13, 17, 21) are not constant, so the model is not linear, but that does not make it exponential. An exponential model needs a constant ratio between consecutive outputs, and these ratios (6.00, 2.50, 1.87, 1.61, 1.47) are not constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A linear model, because the outputs always increase', false, 'This does not show the first differences are constant, which is what a linear model needs. The first differences are 5, 9, 13, 17, 21, so the rate of change is different from one step to the next.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An exponential model with growth factor 6, because f(1)/f(0) = 6', false, 'This uses only the first ratio. For an exponential model every ratio of consecutive outputs must equal the same factor, but f(2)/f(1) = 5/2, which is different from 6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A quadratic model, because the second differences are constant at 4', true, 'Correct: First differences: 5, 9, 13, 17, 21. Second differences: 4, 4, 4, 4, all equal to 4. The ratios of consecutive outputs (6.00, 2.50, 1.87, 1.61, 1.47) are not constant, so the data match a quadratic, not an exponential or linear model.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-h-2.5-b','apprecalc-mcq-b7-sv-h-2.5-b-v1','apprecalc-mcq-b7-sv-h-2.5-b-v2','apprecalc-mcq-b7-sv-h-2.5-b-v3','apprecalc-mcq-b7-h-2.6-a','apprecalc-mcq-b7-sv-h-2.6-a-v1','apprecalc-mcq-b7-sv-h-2.6-a-v2','apprecalc-mcq-b7-sv-h-2.6-a-v3','apprecalc-mcq-b7-h-2.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-h-2.5-b','apprecalc-mcq-b7-sv-h-2.5-b-v1','apprecalc-mcq-b7-sv-h-2.5-b-v2','apprecalc-mcq-b7-sv-h-2.5-b-v3','apprecalc-mcq-b7-h-2.6-a','apprecalc-mcq-b7-sv-h-2.6-a-v1','apprecalc-mcq-b7-sv-h-2.6-a-v2','apprecalc-mcq-b7-sv-h-2.6-a-v3','apprecalc-mcq-b7-h-2.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
