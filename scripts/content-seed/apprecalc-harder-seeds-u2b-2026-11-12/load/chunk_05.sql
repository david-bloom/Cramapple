begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-h-2.13-b','apprecalc-mcq-b8-sv-h-2.13-b-v1','apprecalc-mcq-b8-sv-h-2.13-b-v2','apprecalc-mcq-b8-sv-h-2.13-b-v3','apprecalc-mcq-b8-h-2.14-a','apprecalc-mcq-b8-sv-h-2.14-a-v1','apprecalc-mcq-b8-sv-h-2.14-a-v2','apprecalc-mcq-b8-sv-h-2.14-a-v3','apprecalc-mcq-b8-h-2.14-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-h-2.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.13-b', 'mcq', 'model when two exponential quantities become equal and write the solution time as a logarithmic expression, handling bot', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two accounts are modeled, with t the time and values in dollars, by P(t) = 1000·1.05ᵗ and Q(t) = 1500·1.03ᵗ. Which expression gives the time t at which the two quantities are equal?', null, md5('apprecalc-mcq-b8-h-2.13-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ln(1.5) / ln(1.02)', false, 'This subtracts the growth rates, 1.05 − 1.03 = 0.02, to get a 1.02 factor. The relative growth is the ratio 1.05/1.03, so the denominator is ln(1.05/1.03) = ln 1.05 − ln 1.03.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ln(1.5) / (ln 1.05 + ln 1.03)', false, 'This adds the logarithms of the growth factors. Dividing both sides by 1.03ᵗ gives (1.05/1.03)ᵗ = 1.5, so the logarithms are subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ln(1.5) / ln(1.05)', false, 'This lets P grow by the factor 1.5 alone and ignores that Q is growing at the same time, at 3% per year.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ln(1.5) / (ln 1.05 − ln 1.03)', true, 'Correct: 1000·1.05ᵗ = 1500·1.03ᵗ gives (1.05/1.03)ᵗ = 1.5, so t = ln(1.5)/(ln 1.05 − ln 1.03) ≈ 21.1 years.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.13-b-v1', 'mcq', 'model when two exponential quantities become equal and write the solution time as a logarithmic expression, handling bot (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two accounts are modeled, with t the time and values in dollars, by P(t) = 800·1.09ᵗ and Q(t) = 2000·1.05ᵗ. Which expression gives the time t at which the two quantities are equal?', null, md5('apprecalc-mcq-b8-sv-h-2.13-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ln(2.5) / ln(1.04)', false, 'This subtracts the growth rates, 1.09 − 1.05 = 0.04, to get a 1.04 factor. The relative growth is the ratio 1.09/1.05, so the denominator is ln 1.09 − ln 1.05.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ln(2.5) / (ln 1.09 + ln 1.05)', false, 'This adds the logarithms of the growth factors. Dividing both sides by 1.05ᵗ gives (1.09/1.05)ᵗ = 2.5, so the logarithms are subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ln(2.5) / (ln 1.09 − ln 1.05)', true, 'Correct: 800·1.09ᵗ = 2000·1.05ᵗ gives (1.09/1.05)ᵗ = 2.5, so t = ln(2.5)/(ln 1.09 − ln 1.05) ≈ 24.1 years.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ln(2.5) / ln(1.09)', false, 'This lets P grow by the factor 2.5 alone and ignores that Q is growing at the same time, at 5% per year.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.13-b-v2', 'mcq', 'model when two exponential quantities become equal and write the solution time as a logarithmic expression, handling bot (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two drug concentrations are modeled, with t the time and values in mg per liter, by A(t) = 500·0.9ᵗ and B(t) = 200·0.95ᵗ. Which expression gives the time t at which the two quantities are equal?', null, md5('apprecalc-mcq-b8-sv-h-2.13-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ln(2.5) / (ln 0.9 − ln 0.95)', false, 'This inverts the ratio of the starting values: dividing 200ᵗ-side by 500 gives 200/500 = 0.4, not 2.5, and the inverted ratio leads to a negative time.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ln(0.4) / (ln 0.9 + ln 0.95)', false, 'This adds the logarithms of the decay factors. Dividing both sides by 0.95ᵗ gives (0.9/0.95)ᵗ = 0.4, so the logarithms are subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ln(0.4) / (ln 0.9 − ln 0.95)', true, 'Correct: 500·0.9ᵗ = 200·0.95ᵗ gives (0.9/0.95)ᵗ = 0.4, so t = ln(0.4)/(ln 0.9 − ln 0.95) ≈ 16.9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ln(0.4) / ln(0.9)', false, 'This lets A decay alone to 40% of its value and ignores that B is decaying too, at 5% per unit time.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.13-b-v3', 'mcq', 'model when two exponential quantities become equal and write the solution time as a logarithmic expression, handling bot (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two populations are modeled, with t the time and values in individuals, by V(t) = 120e^(0.04t) and W(t) = 300e^(0.01t). Which expression gives the time t at which the two quantities are equal?', null, md5('apprecalc-mcq-b8-sv-h-2.13-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ln(2.5) / 0.05', false, 'This adds the growth rates 0.04 + 0.01. Dividing both sides by e^(0.01t) gives e^(0.03t) = 2.5, so the rates are subtracted.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ln(2.5) / 0.04', false, 'This lets V grow alone by the factor 2.5 and ignores that W is also growing at rate 0.01.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ln(0.4) / 0.03', false, 'This inverts the ratio of the starting values: 120e^(0.04t) = 300e^(0.01t) leads to e^(0.03t) = 300/120 = 2.5, not 0.4, which would give a negative time.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ln(2.5) / 0.03', true, 'Correct: 120e^(0.04t) = 300e^(0.01t) gives e^(0.03t) = 2.5, so t = ln(2.5)/0.03 ≈ 30.5.' from version_ins;
-- apprecalc-mcq-b8-h-2.14-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.14-a', 'mcq', 'use residuals (observed minus predicted) from a logarithmic model to decide where, and by how much, the model overestima', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A study group''s quiz scores (score) are compared with the model N(t) = 6 + 4log₂(t). The observed values are (t, value): t = 1, 6.5; t = 2, 9; t = 4, 14; t = 8, 17.5. Residual means observed minus predicted. Which statement is correct?', null, md5('apprecalc-mcq-b8-h-2.14-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model overestimates the most at t = 1, by 0.5.', false, 'This picks the largest positive residual (0.5 at t = 1), but a positive residual means the model underestimates; the overestimates are the negative residuals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model underestimates the most at t = 2, by 1.', false, 'A residual of -1 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model overestimates the most at t = 2, by 1.', true, 'Correct: Predictions: 6, 10, 14, 18. Residuals (observed − predicted): 0.5, -1, 0, -0.5. The most negative residual is -1 at t = 2, an overestimate of 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The model is exact at t = 4, so it does not overestimate at any input.', false, 'The model is exact at t = 4, but residuals at other inputs are negative, which means the model overestimates there; an exact fit at one point does not rule out overestimates elsewhere.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.14-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.14-a-v1', 'mcq', 'use residuals (observed minus predicted) from a logarithmic model to decide where, and by how much, the model overestima (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cooling experiment''s readings (temperature (degrees)) are compared with the model T(d) = 10 + 3log₂(d). The observed values are (d, value): d = 1, 9; d = 2, 14.5; d = 4, 16; d = 8, 17. Residual means observed minus predicted. Which statement is correct?', null, md5('apprecalc-mcq-b8-sv-h-2.14-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model overestimates the most at d = 2, by 1.5.', false, 'This picks the largest positive residual (1.5 at d = 2), but a positive residual means the model underestimates; the overestimates are the negative residuals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model underestimates the most at d = 8, by 2.', false, 'A residual of -2 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model is exact at d = 4, so it does not overestimate at any input.', false, 'The model is exact at d = 4, but residuals at other inputs are negative, which means the model overestimates there; an exact fit at one point does not rule out overestimates elsewhere.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The model overestimates the most at d = 8, by 2.', true, 'Correct: Predictions: 10, 13, 16, 19. Residuals (observed − predicted): -1, 1.5, 0, -2. The most negative residual is -2 at d = 8, an overestimate of 2.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.14-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.14-a-v2', 'mcq', 'use residuals (observed minus predicted) from a logarithmic model to decide where, and by how much, the model overestima (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A growth study''s measurements (weight (kg)) are compared with the model W(h) = 4 + 5log₃(h). The observed values are (h, value): h = 1, 5; h = 3, 8; h = 9, 15.5; h = 27, 18.5. Residual means observed minus predicted. Which statement is correct?', null, md5('apprecalc-mcq-b8-sv-h-2.14-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model overestimates the most at h = 9, by 1.5.', false, 'This picks the largest positive residual (1.5 at h = 9), but a positive residual means the model underestimates; the overestimates are the negative residuals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model underestimates the most at h = 3, by 1.', false, 'A residual of -1 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model overestimates the most at h = 27, by 0.5.', false, 'The residual at h = 27 is -0.5, an overestimate of only 0.5, which is smaller than the overestimate of 1 at h = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The model overestimates the most at h = 3, by 1.', true, 'Correct: Predictions: 4, 9, 14, 19. Residuals (observed − predicted): 1, -1, 1.5, -0.5. The most negative residual is -1 at h = 3, an overestimate of 1.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.14-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.14-a-v3', 'mcq', 'use residuals (observed minus predicted) from a logarithmic model to decide where, and by how much, the model overestima (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rating panel''s observations (rating) are compared with the model R(x) = 2 + 6log₂(x). The observed values are (x, value): x = 1, 1; x = 2, 9; x = 4, 12.5; x = 8, 20.5. Residual means observed minus predicted. Which statement is correct?', null, md5('apprecalc-mcq-b8-sv-h-2.14-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The model overestimates the most at x = 2, by 1.', false, 'This picks the largest positive residual (1 at x = 2), but a positive residual means the model underestimates; the overestimates are the negative residuals.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The model overestimates the most at x = 4, by 1.5.', true, 'Correct: Predictions: 2, 8, 14, 20. Residuals (observed − predicted): -1, 1, -1.5, 0.5. The most negative residual is -1.5 at x = 4, an overestimate of 1.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The model underestimates the most at x = 4, by 1.5.', false, 'A residual of -1.5 means the observed value is below the prediction, so the model overestimates there; this reverses the interpretation of the sign.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The model overestimates the most at x = 1, by 1.', false, 'The residual at x = 1 is -1, an overestimate of only 1, which is smaller than the overestimate of 1.5 at x = 4.' from version_ins;
-- apprecalc-mcq-b8-h-2.14-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.14-b', 'mcq', 'compare average rates of change of a logarithmic model on two intervals that each span one multiplication of the input, ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model gives score S(t) = 10 + 8log₂(t), t in hours of practice, in points. Which pair correctly gives the average rates of change of S over [1, 2] and over [4, 8]?', null, md5('apprecalc-mcq-b8-h-2.14-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8 points per hour on [1, 2] and 8 points per hour on [4, 8]', false, 'Over each interval the output rises by 8, because the input is multiplied by 2 each time, but a rate divides that change by the interval width: 1 and 4, which are different.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 points per hour on [1, 2] and 8 points per hour on [4, 8]', false, 'This swaps the two rates. The later interval is wider (4 units) for the same rise of 8, so its rate must be the smaller of the two.' from version_ins
union all select gen_random_uuid(), id, 'C', '8 points per hour on [1, 2] and 2 points per hour on [4, 8]', true, 'Correct: Each interval multiplies the input by 2, so the output rises by 8. Rates: 8/1 = 8 and 8/4 = 2; the rate falls as the interval moves right.' from version_ins
union all select gen_random_uuid(), id, 'D', '8 points per hour on [1, 2] and 1 points per hour on [4, 8]', false, 'The rate on [4, 8] divides the rise 8 by the interval''s width, 8 − 4 = 4, not by its right endpoint 8.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-h-2.13-b','apprecalc-mcq-b8-sv-h-2.13-b-v1','apprecalc-mcq-b8-sv-h-2.13-b-v2','apprecalc-mcq-b8-sv-h-2.13-b-v3','apprecalc-mcq-b8-h-2.14-a','apprecalc-mcq-b8-sv-h-2.14-a-v1','apprecalc-mcq-b8-sv-h-2.14-a-v2','apprecalc-mcq-b8-sv-h-2.14-a-v3','apprecalc-mcq-b8-h-2.14-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-h-2.13-b','apprecalc-mcq-b8-sv-h-2.13-b-v1','apprecalc-mcq-b8-sv-h-2.13-b-v2','apprecalc-mcq-b8-sv-h-2.13-b-v3','apprecalc-mcq-b8-h-2.14-a','apprecalc-mcq-b8-sv-h-2.14-a-v1','apprecalc-mcq-b8-sv-h-2.14-a-v2','apprecalc-mcq-b8-sv-h-2.14-a-v3','apprecalc-mcq-b8-h-2.14-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
