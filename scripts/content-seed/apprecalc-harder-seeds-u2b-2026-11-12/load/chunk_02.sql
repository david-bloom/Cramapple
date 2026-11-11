begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.10-a-v1','apprecalc-mcq-b8-sv-h-2.10-a-v2','apprecalc-mcq-b8-sv-h-2.10-a-v3','apprecalc-mcq-b8-h-2.10-b','apprecalc-mcq-b8-sv-h-2.10-b-v1','apprecalc-mcq-b8-sv-h-2.10-b-v2','apprecalc-mcq-b8-sv-h-2.10-b-v3','apprecalc-mcq-b8-h-2.11-a','apprecalc-mcq-b8-sv-h-2.11-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-sv-h-2.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.10-a-v1', 'mcq', 'evaluate the inverse of a shifted and scaled exponential function at a given output by undoing the shift, the scale, and (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 2·3ˣ + 1. What is g⁻¹(55)?', null, md5('apprecalc-mcq-b8-sv-h-2.10-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '27', false, 'This isolates the exponential, 3ˣ = 27, and stops there. The inverse value is the exponent x, so one more step, log₃(27) = 3, is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₃(28)', false, 'The constant must be removed by subtracting c: 55 − (1) = 54. This uses 55 + (1) = 56 instead, so the shift is moved the wrong way.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: Solve 2·3ˣ + 1 = 55: 3ˣ = 27, so x = log₃(27) = 3. Check: 2·3^(3) + (1) = 55.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₃(55/2) − 1', false, 'This takes the logarithm of 55 divided by 2 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 55 first.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.10-a-v2', 'mcq', 'evaluate the inverse of a shifted and scaled exponential function at a given output by undoing the shift, the scale, and (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = 1/2·4ˣ − 2. What is h⁻¹(6)?', null, md5('apprecalc-mcq-b8-sv-h-2.10-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16', false, 'This isolates the exponential, 4ˣ = 16, and stops there. The inverse value is the exponent x, so one more step, log₄(16) = 2, is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₄(8)', false, 'The constant must be removed by subtracting c: 6 − (-2) = 8. This uses 6 + (-2) = 4 instead, so the shift is moved the wrong way.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₄(12) + 2', false, 'This takes the logarithm of 6 divided by 1/2 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 6 first.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'Correct: Solve 1/2·4ˣ − 2 = 6: 4ˣ = 16, so x = log₄(16) = 2. Check: 1/2·4^(2) + (-2) = 6.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.10-a-v3', 'mcq', 'evaluate the inverse of a shifted and scaled exponential function at a given output by undoing the shift, the scale, and (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let p(x) = 3·(1/2)ˣ + 4. What is p⁻¹(10)?', null, md5('apprecalc-mcq-b8-sv-h-2.10-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-1', true, 'Correct: Solve 3·(1/2)ˣ + 4 = 10: (1/2)ˣ = 2, so x = log_(1/2)(2) = -1. Check: 3·1/2^(-1) + (4) = 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This isolates the exponential, (1/2)ˣ = 2, and stops there. The inverse value is the exponent x, so one more step, log_(1/2)(2) = -1, is needed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log_(1/2)(14/3)', false, 'The constant must be removed by subtracting c: 10 − (4) = 6. This uses 10 + (4) = 14 instead, so the shift is moved the wrong way.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log_(1/2)(10/3) − 4', false, 'This takes the logarithm of 10 divided by 3 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 10 first.' from version_ins;
-- apprecalc-mcq-b8-h-2.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.10-b', 'mcq', 'determine the domain and asymptote of an inverse exponential function from the range and horizontal asymptote of the ori', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 2·3ˣ + 4. Which statement about the inverse function g⁻¹ is true?', null, md5('apprecalc-mcq-b8-h-2.10-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The domain of g⁻¹ is x > 4, and its graph has a vertical asymptote at x = 4.', true, 'Correct: The horizontal asymptote y = 4 and range of g become the vertical asymptote x = 4 and domain x > 4 of the inverse, while the range of g⁻¹ is all real numbers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The domain of g⁻¹ is x > 0, and its graph has a vertical asymptote at x = 0.', false, 'This treats the inverse of any exponential as having domain x > 0, ignoring the vertical shift. The domain of the inverse is the range of g, so the boundary moves to x = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The domain of g⁻¹ is x > 4, and its graph has a horizontal asymptote at y = 4.', false, 'The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = 4, not a horizontal asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The domain of g⁻¹ is all real numbers, and its range is y > 4.', false, 'This describes the original function: the range of g is y > 4, and its domain is all reals. For the inverse the roles swap, so the domain is x > 4 and the range is all reals.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.10-b-v1', 'mcq', 'determine the domain and asymptote of an inverse exponential function from the range and horizontal asymptote of the ori (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 3·2ˣ − 1. Which statement about the inverse function g⁻¹ is true?', null, md5('apprecalc-mcq-b8-sv-h-2.10-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The domain of g⁻¹ is x > 0, and its graph has a vertical asymptote at x = 0.', false, 'This treats the inverse of any exponential as having domain x > 0, ignoring the vertical shift. The domain of the inverse is the range of g, so the boundary moves to x = −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The domain of g⁻¹ is x > −1, and its graph has a vertical asymptote at x = −1.', true, 'Correct: The horizontal asymptote y = −1 and range of g become the vertical asymptote x = −1 and domain x > −1 of the inverse, while the range of g⁻¹ is all real numbers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The domain of g⁻¹ is x > −1, and its graph has a horizontal asymptote at y = −1.', false, 'The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = −1, not a horizontal asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The domain of g⁻¹ is all real numbers, and its range is y > −1.', false, 'This describes the original function: the range of g is y > −1, and its domain is all reals. For the inverse the roles swap, so the domain is x > −1 and the range is all reals.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.10-b-v2', 'mcq', 'determine the domain and asymptote of an inverse exponential function from the range and horizontal asymptote of the ori (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = −2·3ˣ + 6. Which statement about the inverse function h⁻¹ is true?', null, md5('apprecalc-mcq-b8-sv-h-2.10-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The domain of h⁻¹ is x > 6, and its graph has a vertical asymptote at x = 6.', false, 'The coefficient −2 reflects the graph below its asymptote, so h takes only values below 6. The inverse''s inputs are those outputs, so its domain is x < 6, not x > 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The domain of h⁻¹ is x < 6, and its graph has a horizontal asymptote at y = 6.', false, 'The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = 6, not a horizontal asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The domain of h⁻¹ is all real numbers, and its range is y < 6.', false, 'This describes the original function: the range of h is y < 6, and its domain is all reals. For the inverse the roles swap, so the domain is x < 6 and the range is all reals.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The domain of h⁻¹ is x < 6, and its graph has a vertical asymptote at x = 6.', true, 'Correct: The horizontal asymptote y = 6 and range of h become the vertical asymptote x = 6 and domain x < 6 of the inverse, while the range of h⁻¹ is all real numbers.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.10-b-v3', 'mcq', 'determine the domain and asymptote of an inverse exponential function from the range and horizontal asymptote of the ori (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let k(x) = 4·(1/2)ˣ − 3. Which statement about the inverse function k⁻¹ is true?', null, md5('apprecalc-mcq-b8-sv-h-2.10-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The domain of k⁻¹ is x > 0, and its graph has a vertical asymptote at x = 0.', false, 'This treats the inverse of any exponential as having domain x > 0, ignoring the vertical shift. The domain of the inverse is the range of k, so the boundary moves to x = −3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The domain of k⁻¹ is x > −3, and its graph has a horizontal asymptote at y = −3.', false, 'The boundary value is right, but reflecting over y = x turns a horizontal asymptote into a vertical one, so the inverse has a vertical asymptote at x = −3, not a horizontal asymptote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The domain of k⁻¹ is x > −3, and its graph has a vertical asymptote at x = −3.', true, 'Correct: The horizontal asymptote y = −3 and range of k become the vertical asymptote x = −3 and domain x > −3 of the inverse, while the range of k⁻¹ is all real numbers.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The domain of k⁻¹ is all real numbers, and its range is y > −3.', false, 'This describes the original function: the range of k is y > −3, and its domain is all reals. For the inverse the roles swap, so the domain is x > −3 and the range is all reals.' from version_ins;
-- apprecalc-mcq-b8-h-2.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.11-a', 'mcq', 'describe increasing or decreasing behavior, concavity, and the vertical asymptote of a transformed logarithmic function ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes f(x) on its domain, where f(x) = −log₂(x + 3) + 1?', null, md5('apprecalc-mcq-b8-h-2.11-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is decreasing and concave up, with vertical asymptote x = −3.', true, 'Correct: x + 3 > 0 gives asymptote x = −3. For −log₂(u), the derivative is −1/((x+3) ln 2) < 0 and the second derivative is 1/((x+3)² ln 2) > 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is decreasing and concave down, with vertical asymptote x = −3.', false, 'A reflection in the x-axis reverses the direction of change and also the concavity: log₂ is concave down, so −log₂ is concave up.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is decreasing and concave up, with vertical asymptote x = 3.', false, 'The input is x + 3, which is zero at x = −3, not x = 3, so the vertical asymptote is at x = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is increasing and concave down, with vertical asymptote x = −3.', false, 'This ignores the negative sign in front of the logarithm; with it the function decreases and is concave up.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.11-a-v1', 'mcq', 'describe increasing or decreasing behavior, concavity, and the vertical asymptote of a transformed logarithmic function  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement correctly describes g(x) on its domain, where g(x) = −3·log₂(x − 4) + 5?', null, md5('apprecalc-mcq-b8-sv-h-2.11-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is decreasing and concave down, with vertical asymptote x = 4.', false, 'The negative multiplier reverses the direction and the concavity; log₂ is concave down, so −3·log₂ is concave up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is decreasing and concave up, with vertical asymptote x = −4.', false, 'The input is x − 4, which is zero at x = 4, not x = −4, so the asymptote is at x = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is decreasing and concave up, with vertical asymptote x = 4.', true, 'Correct: x − 4 > 0 gives asymptote x = 4. The derivative −3/((x−4) ln 2) is negative and the second derivative 3/((x−4)² ln 2) is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is increasing and concave down, with vertical asymptote x = 4.', false, 'This overlooks the factor −3: the negative multiplier makes the function decrease and be concave up.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.10-a-v1','apprecalc-mcq-b8-sv-h-2.10-a-v2','apprecalc-mcq-b8-sv-h-2.10-a-v3','apprecalc-mcq-b8-h-2.10-b','apprecalc-mcq-b8-sv-h-2.10-b-v1','apprecalc-mcq-b8-sv-h-2.10-b-v2','apprecalc-mcq-b8-sv-h-2.10-b-v3','apprecalc-mcq-b8-h-2.11-a','apprecalc-mcq-b8-sv-h-2.11-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-sv-h-2.10-a-v1','apprecalc-mcq-b8-sv-h-2.10-a-v2','apprecalc-mcq-b8-sv-h-2.10-a-v3','apprecalc-mcq-b8-h-2.10-b','apprecalc-mcq-b8-sv-h-2.10-b-v1','apprecalc-mcq-b8-sv-h-2.10-b-v2','apprecalc-mcq-b8-sv-h-2.10-b-v3','apprecalc-mcq-b8-h-2.11-a','apprecalc-mcq-b8-sv-h-2.11-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
