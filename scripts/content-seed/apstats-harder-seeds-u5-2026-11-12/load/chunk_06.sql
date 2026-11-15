begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.2-c-v1','apstats-mcq-b8-sv-h-5.2-c-v2','apstats-mcq-b8-sv-h-5.2-c-v3','apstats-mcq-b8-h-5.3-c','apstats-mcq-b8-sv-h-5.3-c-v1','apstats-mcq-b8-sv-h-5.3-c-v2','apstats-mcq-b8-sv-h-5.3-c-v3','apstats-mcq-b8-h-5.4-c','apstats-mcq-b8-sv-h-5.4-c-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apstats-mcq-b8-sv-h-5.2-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-c-v1', 'mcq', 'interpret correlation with nonlinear scatterplot (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of pain relief against dosage has a pronounced inverted U-shaped pattern, but its computed correlation is r=-0.04. A student proposes using a straight-line equation to predict every response and claims the small r proves there is no relationship. Which critique addresses both parts of the proposal?', null, md5('apstats-mcq-b8-sv-h-5.2-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The correlation proves the two variables are independent, so a straight line is the only model worth testing.', false, 'Near-zero Pearson r does not establish independence when a nonlinear pattern is visible; a line would also miss that form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The curved pattern must be a plotting error because a correlation close to zero prohibits association.', false, 'The reported r and visible curvature can coexist because r describes only the linear component.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The small r guarantees that a straight line predicts each observed response exactly despite the curve.', false, 'A small |r| does not guarantee small residuals; the visible curve is evidence against exact line predictions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A straight line would miss the inverted U-shaped form; the small r describes weak linear association, not absence of every association.', true, 'Correct: Pearson correlation measures linear association. The stated curved form warns that a single straight-line predictor misses systematic structure even if its r is close to zero.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-c-v2', 'mcq', 'interpret correlation with nonlinear scatterplot (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of sensor reading against distance from a heater has a pronounced U-shaped pattern, but its computed correlation is r=+0.01. A student proposes using a straight-line equation to predict every response and claims the small r proves there is no relationship. Which critique addresses both parts of the proposal?', null, md5('apstats-mcq-b8-sv-h-5.2-c-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The correlation proves the two variables are independent, so a straight line is the only model worth testing.', false, 'Near-zero Pearson r does not establish independence when a nonlinear pattern is visible; a line would also miss that form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A straight line would miss the U-shaped form; the small r describes weak linear association, not absence of every association.', true, 'Correct: Pearson correlation measures linear association. The stated curved form warns that a single straight-line predictor misses systematic structure even if its r is close to zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The curved pattern must be a plotting error because a correlation close to zero prohibits association.', false, 'The reported r and visible curvature can coexist because r describes only the linear component.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The small r guarantees that a straight line predicts each observed response exactly despite the curve.', false, 'A small |r| does not guarantee small residuals; the visible curve is evidence against exact line predictions.' from version_ins;
-- apstats-mcq-b8-sv-h-5.2-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.2-c-v3', 'mcq', 'interpret correlation with nonlinear scatterplot (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scatterplot of performance against training load has a pronounced W-shaped pattern, but its computed correlation is r=-0.03. A student proposes using a straight-line equation to predict every response and claims the small r proves there is no relationship. Which critique addresses both parts of the proposal?', null, md5('apstats-mcq-b8-sv-h-5.2-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The correlation proves the two variables are independent, so a straight line is the only model worth testing.', false, 'Near-zero Pearson r does not establish independence when a nonlinear pattern is visible; a line would also miss that form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The curved pattern must be a plotting error because a correlation close to zero prohibits association.', false, 'The reported r and visible curvature can coexist because r describes only the linear component.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A straight line would miss the W-shaped form; the small r describes weak linear association, not absence of every association.', true, 'Correct: Pearson correlation measures linear association. The stated curved form warns that a single straight-line predictor misses systematic structure even if its r is close to zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The small r guarantees that a straight line predicts each observed response exactly despite the curve.', false, 'A small |r| does not guarantee small residuals; the visible curve is evidence against exact line predictions.' from version_ins;
-- apstats-mcq-b8-h-5.3-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.3-c', 'mcq', 'compare interpolation and extrapolation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line y-hat=20+6x was fitted using age of equipment values from 2 through 8 to predict repair cost. A report uses it at x=5 and x=11. Which assessment correctly compares the two predictions?', null, md5('apstats-mcq-b8-h-5.3-c'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The predictions are 50 and 86; the first is interpolation, while the second extrapolates and deserves more caution.', true, 'Correct: Substituting the given x-values gives 50 and 86. 5 is inside [2,8], while 11 exceeds 8; numerical evaluation is possible but extrapolation is less dependable.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The predictions are 50 and 86; both are interpolation because the equation accepts both inputs.', false, 'The second x-value is outside the observed range, so it is extrapolation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The predictions are 50 and 86; both are equally reliable because the fitted slope is constant.', false, 'A constant fitted slope does not guarantee a straight-line relationship beyond observed x-values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only the first prediction, 50, can be calculated; extrapolation makes the second value undefined.', false, 'Extrapolation still yields a numerical value; its reliability, not its algebraic existence, is in doubt.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-c-v1', 'mcq', 'compare interpolation and extrapolation (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line y-hat=42+4x was fitted using practice sessions values from 1 through 10 to predict score. A report uses it at x=7 and x=14. Which assessment correctly compares the two predictions?', null, md5('apstats-mcq-b8-sv-h-5.3-c-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The predictions are 70 and 98; the first is interpolation, while the second extrapolates and deserves more caution.', true, 'Correct: Substituting the given x-values gives 70 and 98. 7 is inside [1,10], while 14 exceeds 10; numerical evaluation is possible but extrapolation is less dependable.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The predictions are 70 and 98; both are interpolation because the equation accepts both inputs.', false, 'The second x-value is outside the observed range, so it is extrapolation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The predictions are 70 and 98; both are equally reliable because the fitted slope is constant.', false, 'A constant fitted slope does not guarantee a straight-line relationship beyond observed x-values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only the first prediction, 70, can be calculated; extrapolation makes the second value undefined.', false, 'Extrapolation still yields a numerical value; its reliability, not its algebraic existence, is in doubt.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-c-v2', 'mcq', 'compare interpolation and extrapolation (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line y-hat=5+3x was fitted using weeks after planting values from 1 through 8 to predict height. A report uses it at x=6 and x=12. Which assessment correctly compares the two predictions?', null, md5('apstats-mcq-b8-sv-h-5.3-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The predictions are 23 and 41; both are interpolation because the equation accepts both inputs.', false, 'The second x-value is outside the observed range, so it is extrapolation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The predictions are 23 and 41; both are equally reliable because the fitted slope is constant.', false, 'A constant fitted slope does not guarantee a straight-line relationship beyond observed x-values.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only the first prediction, 23, can be calculated; extrapolation makes the second value undefined.', false, 'Extrapolation still yields a numerical value; its reliability, not its algebraic existence, is in doubt.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The predictions are 23 and 41; the first is interpolation, while the second extrapolates and deserves more caution.', true, 'Correct: Substituting the given x-values gives 23 and 41. 6 is inside [1,8], while 12 exceeds 8; numerical evaluation is possible but extrapolation is less dependable.' from version_ins;
-- apstats-mcq-b8-sv-h-5.3-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.3-c-v3', 'mcq', 'compare interpolation and extrapolation (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A least-squares line y-hat=25-2x was fitted using distance from shore values from 1 through 9 to predict temperature. A report uses it at x=4 and x=13. Which assessment correctly compares the two predictions?', null, md5('apstats-mcq-b8-sv-h-5.3-c-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The predictions are 17 and -1; both are interpolation because the equation accepts both inputs.', false, 'The second x-value is outside the observed range, so it is extrapolation.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The predictions are 17 and -1; the first is interpolation, while the second extrapolates and deserves more caution.', true, 'Correct: Substituting the given x-values gives 17 and -1. 4 is inside [1,9], while 13 exceeds 9; numerical evaluation is possible but extrapolation is less dependable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The predictions are 17 and -1; both are equally reliable because the fitted slope is constant.', false, 'A constant fitted slope does not guarantee a straight-line relationship beyond observed x-values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only the first prediction, 17, can be calculated; extrapolation makes the second value undefined.', false, 'Extrapolation still yields a numerical value; its reliability, not its algebraic existence, is in doubt.' from version_ins;
-- apstats-mcq-b8-h-5.4-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-h-5.4-c', 'mcq', 'compare residual diagnostics across models', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two candidate models predict energy use from temperature. At five increasing x-values, model A has residuals [3, 1, -2, 1, 3], and model B has residuals [1, -1, 0, 1, -1]. Which judgment about form follows from these residuals?', null, md5('apstats-mcq-b8-h-5.4-c'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Model B has the more appropriate form for energy use: A leaves a systematic curve across temperature, whereas B''s residuals fluctuate around zero.', true, 'Correct: Model A''s endpoint and middle residuals trace a repeated high-low-high or low-high-low shape. B''s signs fluctuate without that curve; zero residual at every point is unnecessary.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Model A has the better form for energy use because an orderly curve of residuals is desirable.', false, 'The orderly curve is evidence that A misses systematic structure, not evidence in its favor.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both forms are equally supported because each list contains positive and negative residuals.', false, 'Having both signs is not enough; the order of residuals across x reveals A''s pattern.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither form can be used because a fitted model must make every residual exactly zero.', false, 'Residuals need not all be zero for a model to be useful; random scatter is the relevant form check.' from version_ins;
-- apstats-mcq-b8-sv-h-5.4-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'apstats-mcq-b8-sv-h-5.4-c-v1', 'mcq', 'compare residual diagnostics across models (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two candidate models predict reaction time from dosage. At five increasing x-values, model A has residuals [-4, -1, 2, -1, -4], and model B has residuals [-1, 1, 0, -1, 1]. Which judgment about form follows from these residuals?', null, md5('apstats-mcq-b8-sv-h-5.4-c-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Model A has the better form for reaction time because an orderly curve of residuals is desirable.', false, 'The orderly curve is evidence that A misses systematic structure, not evidence in its favor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both forms are equally supported because each list contains positive and negative residuals.', false, 'Having both signs is not enough; the order of residuals across x reveals A''s pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Model B has the more appropriate form for reaction time: A leaves a systematic curve across dosage, whereas B''s residuals fluctuate around zero.', true, 'Correct: Model A''s endpoint and middle residuals trace a repeated high-low-high or low-high-low shape. B''s signs fluctuate without that curve; zero residual at every point is unnecessary.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither form can be used because a fitted model must make every residual exactly zero.', false, 'Residuals need not all be zero for a model to be useful; random scatter is the relevant form check.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['apstats-mcq-b8-sv-h-5.2-c-v1','apstats-mcq-b8-sv-h-5.2-c-v2','apstats-mcq-b8-sv-h-5.2-c-v3','apstats-mcq-b8-h-5.3-c','apstats-mcq-b8-sv-h-5.3-c-v1','apstats-mcq-b8-sv-h-5.3-c-v2','apstats-mcq-b8-sv-h-5.3-c-v3','apstats-mcq-b8-h-5.4-c','apstats-mcq-b8-sv-h-5.4-c-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['apstats-mcq-b8-sv-h-5.2-c-v1','apstats-mcq-b8-sv-h-5.2-c-v2','apstats-mcq-b8-sv-h-5.2-c-v3','apstats-mcq-b8-h-5.3-c','apstats-mcq-b8-sv-h-5.3-c-v1','apstats-mcq-b8-sv-h-5.3-c-v2','apstats-mcq-b8-sv-h-5.3-c-v3','apstats-mcq-b8-h-5.4-c','apstats-mcq-b8-sv-h-5.4-c-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
