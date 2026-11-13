begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.2-a-v1','apstats-mcq-b8-sv-h-5.2-a-v2','apstats-mcq-b8-sv-h-5.2-a-v3','apstats-mcq-b8-h-5.2-b','apstats-mcq-b8-sv-h-5.2-b-v1','apstats-mcq-b8-sv-h-5.2-b-v2','apstats-mcq-b8-sv-h-5.2-b-v3','apstats-mcq-b8-h-5.3-a','apstats-mcq-b8-sv-h-5.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apstats-mcq-b8-sv-h-5.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-a-v1', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a sample, the correlation between temperature in degrees Celsius and electricity use is +0.64. An analyst converts the first variable to a new unit using a positive scale factor, then reports the negative of the second variable instead. Which statement is justified about the new correlation and a possible causal claim?', null, md5('apstats-mcq-b8-sv-h-5.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The new correlation is +0.64; changing units and negating a variable cannot change correlation''s direction.', false, 'Positive rescaling preserves correlation, but negating one of the variables reverses its sign.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The new correlation is -0.64; its magnitude establishes that changing temperature in degrees Celsius causes a change in electricity use.', false, 'The sign calculation is right, but the size of a correlation does not by itself identify a causal effect.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The new correlation is -0.64; the sign reverses because one variable was negated, and neither correlation establishes causation.', true, 'Correct: A positive rescaling preserves r=+0.64; multiplying one variable by -1 changes its sign to -0.64. Association alone cannot prove causation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The new correlation is 0 because both variables were transformed before it was computed.', false, 'Linear transformations do not in general destroy association; a positive rescaling and a sign reversal leave the magnitude unchanged.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-a-v2', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a sample, the correlation between hours of sleep and reaction time is -0.71. An analyst converts the first variable to a new unit using a positive scale factor, then reports the negative of the second variable instead. Which statement is justified about the new correlation and a possible causal claim?', null, md5('apstats-mcq-b8-sv-h-5.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The new correlation is -0.71; changing units and negating a variable cannot change correlation''s direction.', false, 'Positive rescaling preserves correlation, but negating one of the variables reverses its sign.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The new correlation is +0.71; its magnitude establishes that changing hours of sleep causes a change in reaction time.', false, 'The sign calculation is right, but the size of a correlation does not by itself identify a causal effect.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The new correlation is 0 because both variables were transformed before it was computed.', false, 'Linear transformations do not in general destroy association; a positive rescaling and a sign reversal leave the magnitude unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The new correlation is +0.71; the sign reverses because one variable was negated, and neither correlation establishes causation.', true, 'Correct: A positive rescaling preserves r=-0.71; multiplying one variable by -1 changes its sign to +0.71. Association alone cannot prove causation.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-a-v3', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a sample, the correlation between practice hours and completion time is -0.83. An analyst converts the first variable to a new unit using a positive scale factor, then reports the negative of the second variable instead. Which statement is justified about the new correlation and a possible causal claim?', null, md5('apstats-mcq-b8-sv-h-5.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The new correlation is +0.83; the sign reverses because one variable was negated, and neither correlation establishes causation.', true, 'Correct: A positive rescaling preserves r=-0.83; multiplying one variable by -1 changes its sign to +0.83. Association alone cannot prove causation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The new correlation is -0.83; changing units and negating a variable cannot change correlation''s direction.', false, 'Positive rescaling preserves correlation, but negating one of the variables reverses its sign.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The new correlation is +0.83; its magnitude establishes that changing practice hours causes a change in completion time.', false, 'The sign calculation is right, but the size of a correlation does not by itself identify a causal effect.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The new correlation is 0 because both variables were transformed before it was computed.', false, 'Linear transformations do not in general destroy association; a positive rescaling and a sign reversal leave the magnitude unchanged.' from version_ins;
-- apstats-mcq-b8-h-5.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.2-b', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed B', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Study A reports r=+0.84 for school attendance and test scores. Study B reports r=-0.61 for hours of exercise and pulse rate. Both use quantitative variables. Which comparison is supported by these summaries alone?', null, md5('apstats-mcq-b8-h-5.2-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Study B has the stronger linear association because its sign makes its correlation more meaningful than Study A''s.', false, 'A positive or negative sign gives direction, while strength is based on distance from zero; the named study has the smaller magnitude.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The study with the larger |r| proves that its explanatory variable causes the response.', false, 'Correlation measures linear association; even a large magnitude does not prove that one variable caused the other.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two studies have the same strength because both correlations lie between -1 and 1.', false, 'Both coefficients being in the valid range says nothing about equality of their magnitudes or strengths.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Study A has the stronger linear association because |r| is larger; its direction is positive, but neither study establishes causation.', true, 'Correct: Compare magnitudes: |+0.84|=0.84, |-0.61|=0.61. Study A is stronger and has a positive direction; causal claims require more evidence.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-b-v1', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed B (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Study A reports r=+0.57 for rainfall and crop yield. Study B reports r=-0.91 for altitude and air pressure. Both use quantitative variables. Which comparison is supported by these summaries alone?', null, md5('apstats-mcq-b8-sv-h-5.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Study A has the stronger linear association because its sign makes its correlation more meaningful than Study B''s.', false, 'A positive or negative sign gives direction, while strength is based on distance from zero; the named study has the smaller magnitude.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Study B has the stronger linear association because |r| is larger; its direction is negative, but neither study establishes causation.', true, 'Correct: Compare magnitudes: |+0.57|=0.57, |-0.91|=0.91. Study B is stronger and has a negative direction; causal claims require more evidence.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The study with the larger |r| proves that its explanatory variable causes the response.', false, 'Correlation measures linear association; even a large magnitude does not prove that one variable caused the other.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two studies have the same strength because both correlations lie between -1 and 1.', false, 'Both coefficients being in the valid range says nothing about equality of their magnitudes or strengths.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-b-v2', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed B (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Study A reports r=+0.76 for practice time and task score. Study B reports r=-0.48 for travel speed and trip time. Both use quantitative variables. Which comparison is supported by these summaries alone?', null, md5('apstats-mcq-b8-sv-h-5.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Study B has the stronger linear association because its sign makes its correlation more meaningful than Study A''s.', false, 'A positive or negative sign gives direction, while strength is based on distance from zero; the named study has the smaller magnitude.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The study with the larger |r| proves that its explanatory variable causes the response.', false, 'Correlation measures linear association; even a large magnitude does not prove that one variable caused the other.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two studies have the same strength because both correlations lie between -1 and 1.', false, 'Both coefficients being in the valid range says nothing about equality of their magnitudes or strengths.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Study A has the stronger linear association because |r| is larger; its direction is positive, but neither study establishes causation.', true, 'Correct: Compare magnitudes: |+0.76|=0.76, |-0.48|=0.48. Study A is stronger and has a positive direction; causal claims require more evidence.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-b-v3', 'mcq', 'AP Statistics Unit 5 topic 5.2, seed B (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Study A reports r=+0.42 for sunlight and plant height. Study B reports r=-0.88 for age of a device and battery capacity. Both use quantitative variables. Which comparison is supported by these summaries alone?', null, md5('apstats-mcq-b8-sv-h-5.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Study A has the stronger linear association because its sign makes its correlation more meaningful than Study B''s.', false, 'A positive or negative sign gives direction, while strength is based on distance from zero; the named study has the smaller magnitude.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The study with the larger |r| proves that its explanatory variable causes the response.', false, 'Correlation measures linear association; even a large magnitude does not prove that one variable caused the other.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Study B has the stronger linear association because |r| is larger; its direction is negative, but neither study establishes causation.', true, 'Correct: Compare magnitudes: |+0.42|=0.42, |-0.88|=0.88. Study B is stronger and has a negative direction; causal claims require more evidence.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two studies have the same strength because both correlations lie between -1 and 1.', false, 'Both coefficients being in the valid range says nothing about equality of their magnitudes or strengths.' from version_ins;
-- apstats-mcq-b8-h-5.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.3-a', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear model fitted using practice sessions from 1 to 10 predicts score points by y-hat=42+4x. What should an analyst report for x=12?', null, md5('apstats-mcq-b8-h-5.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model predicts 90 score points, but this is extrapolation beyond the fitted x-range and is less reliable.', true, 'Correct: Substitute x=12: 42+4(12)=90. Since 12>10, the prediction extrapolates; the equation yields a value but reliability is weaker outside the data range.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model predicts 90 score points, and this is interpolation because the equation accepts x=12.', false, 'A fitted equation can be evaluated outside the observed x-range, but that use is extrapolation, not interpolation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model predicts 50 score points, since the model input must be the distance past the largest observed x.', false, 'The model uses the actual explanatory value x, not the distance past the edge of the data range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No predicted value can be calculated once x lies outside the observed range.', false, 'Extrapolation is less reliable, yet the model still produces a numerical prediction when x is substituted.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-a-v1', 'mcq', 'AP Statistics Unit 5 topic 5.3, seed A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear model fitted using machine hours from 2 to 14 predicts units of output by y-hat=15+3x. What should an analyst report for x=17?', null, md5('apstats-mcq-b8-sv-h-5.3-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model predicts 66 units of output, but this is extrapolation beyond the fitted x-range and is less reliable.', true, 'Correct: Substitute x=17: 15+3(17)=66. Since 17>14, the prediction extrapolates; the equation yields a value but reliability is weaker outside the data range.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model predicts 66 units of output, and this is interpolation because the equation accepts x=17.', false, 'A fitted equation can be evaluated outside the observed x-range, but that use is extrapolation, not interpolation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model predicts 24 units of output, since the model input must be the distance past the largest observed x.', false, 'The model uses the actual explanatory value x, not the distance past the edge of the data range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No predicted value can be calculated once x lies outside the observed range.', false, 'Extrapolation is less reliable, yet the model still produces a numerical prediction when x is substituted.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.2-a-v1','apstats-mcq-b8-sv-h-5.2-a-v2','apstats-mcq-b8-sv-h-5.2-a-v3','apstats-mcq-b8-h-5.2-b','apstats-mcq-b8-sv-h-5.2-b-v1','apstats-mcq-b8-sv-h-5.2-b-v2','apstats-mcq-b8-sv-h-5.2-b-v3','apstats-mcq-b8-h-5.3-a','apstats-mcq-b8-sv-h-5.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-sv-h-5.2-a-v1','apstats-mcq-b8-sv-h-5.2-a-v2','apstats-mcq-b8-sv-h-5.2-a-v3','apstats-mcq-b8-h-5.2-b','apstats-mcq-b8-sv-h-5.2-b-v1','apstats-mcq-b8-sv-h-5.2-b-v2','apstats-mcq-b8-sv-h-5.2-b-v3','apstats-mcq-b8-h-5.3-a','apstats-mcq-b8-sv-h-5.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
