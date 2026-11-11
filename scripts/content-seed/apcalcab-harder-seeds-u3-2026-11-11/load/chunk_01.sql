begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-h-3.1-a','apcalcab-mcq-sv-h-3.1-a-v1','apcalcab-mcq-sv-h-3.1-a-v2','apcalcab-mcq-sv-h-3.1-a-v3','apcalcab-mcq-h-3.1-b','apcalcab-mcq-sv-h-3.1-b-v1','apcalcab-mcq-sv-h-3.1-b-v2','apcalcab-mcq-sv-h-3.1-b-v3','apcalcab-mcq-h-3.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcab-mcq-h-3.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-h-3.1-a', 'mcq', 'Product and chain rules with an unspecified function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function and let h(x) = x²·f(3x). Which expression gives h′(x)?', null, md5('apcalcab-mcq-h-3.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x·f(3x) + x²·f′(3x)', false, 'This forgets the inner derivative 3 from the chain rule when differentiating f(3x).' from version_ins
union all select gen_random_uuid(), id, 'B', '2x·f(3x) + 3x²·f′(3x)', true, 'Correct: product rule gives 2x·f(3x) + x²·d/dx[f(3x)], and d/dx[f(3x)] = 3f′(3x).' from version_ins
union all select gen_random_uuid(), id, 'C', '6x·f′(3x)', false, 'This multiplies the derivatives of the two factors instead of using the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '2x·f(3x) + 3x²·f′(x)', false, 'The derivative of f must be evaluated at the inner function 3x, not at x.' from version_ins;
-- apcalcab-mcq-sv-h-3.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.1-a-v1', 'mcq', 'Product and chain rules with an unspecified function (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function and let h(x) = (x + 1)·f(x²). Which expression gives h′(x)?', null, md5('apcalcab-mcq-sv-h-3.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x²) + (x + 1)·f′(x²)', false, 'This drops the inner derivative 2x when differentiating f(x²).' from version_ins
union all select gen_random_uuid(), id, 'B', 'f′(x²)·2x', false, 'This differentiates only the factor f(x²) and ignores the product rule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x²) + 2x(x + 1)·f′(x²)', true, 'Correct: product rule gives 1·f(x²) + (x + 1)·2x·f′(x²).' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x²) + (x + 1)·2x·f′(x)', false, 'F′ must be evaluated at the inner function x², not at x.' from version_ins;
-- apcalcab-mcq-sv-h-3.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.1-a-v2', 'mcq', 'Product and chain rules with an unspecified function (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function and let h(x) = f(eˣ)/x for x > 0. Which expression gives h′(x)?', null, md5('apcalcab-mcq-sv-h-3.1-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x·f′(eˣ) − f(eˣ))/x²', false, 'This omits the factor eˣ from the chain rule applied to f(eˣ).' from version_ins
union all select gen_random_uuid(), id, 'B', '(x·eˣ·f′(eˣ) − f(eˣ))/x²', true, 'Correct: quotient rule: [x·d/dx f(eˣ) − f(eˣ)·1]/x², with d/dx f(eˣ) = eˣ·f′(eˣ).' from version_ins
union all select gen_random_uuid(), id, 'C', '(x·eˣ·f′(eˣ) + f(eˣ))/x²', false, 'This has a sign error in the numerator of the quotient rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '(eˣ·f′(eˣ) − f(eˣ))/x', false, 'The quotient rule divides by the square of the denominator, x², not by x.' from version_ins;
-- apcalcab-mcq-sv-h-3.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.1-a-v3', 'mcq', 'Product and chain rules with an unspecified function (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function and let h(x) = (f(x² + 1))². Which expression gives h′(x)?', null, md5('apcalcab-mcq-sv-h-3.1-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2f(x² + 1)·f′(x² + 1)', false, 'This omits the derivative of the innermost function x² + 1, which is 2x.' from version_ins
union all select gen_random_uuid(), id, 'B', '4x·f(x² + 1)·f′(x² + 1)', true, 'Correct: outer square gives 2f(x² + 1), then f′(x² + 1), then the inner derivative 2x: 2·f·f′·2x = 4x·f(x² + 1)·f′(x² + 1).' from version_ins
union all select gen_random_uuid(), id, 'C', '4x·f′(x² + 1)', false, 'This loses the factor f(x² + 1) that comes from differentiating the square.' from version_ins
union all select gen_random_uuid(), id, 'D', '4x·f(x² + 1)', false, 'This loses the factor f′(x² + 1) that comes from differentiating f.' from version_ins;
-- apcalcab-mcq-h-3.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-h-3.1-b', 'mcq', 'Interpret a composite rate with units', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A weather balloon rises so that its altitude after t hours is h(t) kilometers. The air temperature at altitude h is T(h) degrees Celsius. At t = 2, h(2) = 3, h′(2) = 0.5, T(3) = −12 and T′(3) = −6.5. Which statement is correct about the temperature the balloon experiences, T(h(t)), at t = 2?', null, md5('apcalcab-mcq-h-3.1-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is decreasing at 6.5 degrees Celsius per hour.', false, 'This uses T′(3) alone, which is the rate per kilometer of altitude, and ignores how fast the balloon is rising.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is decreasing at 13 degrees Celsius per hour.', false, 'This divides by h′(2) instead of multiplying.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is decreasing at 3.25 degrees Celsius per hour.', true, 'Correct: d/dt T(h(t)) = T′(h(2))·h′(2) = (−6.5)(0.5) = −3.25 degrees Celsius per hour.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is decreasing at 3.25 degrees Celsius per kilometer.', false, 'The units of the composite rate are degrees per hour, since the derivative is with respect to time.' from version_ins;
-- apcalcab-mcq-sv-h-3.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.1-b-v1', 'mcq', 'Interpret a composite rate with units (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The fuel economy of a car is E(v) kilometers per liter when it travels at v kilometers per hour. At t = 1 hour, the car''s speed is v(1) = 60 and its speed is increasing at v′(1) = 5 kilometers per hour per hour, and E′(60) = −0.04 kilometers per liter per (kilometer per hour). Which statement is correct about d/dt E(v(t)) at t = 1?', null, md5('apcalcab-mcq-sv-h-3.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fuel economy is decreasing at 0.04 kilometers per liter per hour.', false, 'This uses E′(60) alone and ignores that the speed is changing over time.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fuel economy is decreasing at 0.2 kilometers per liter per hour.', true, 'Correct: E′(60)·v′(1) = (−0.04)(5) = −0.2 kilometers per liter per hour.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fuel economy is decreasing at 0.008 kilometers per liter per hour.', false, 'This divides E′(60) by v′(1) instead of multiplying them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fuel economy is increasing at 0.2 kilometers per liter per hour.', false, 'The product is negative, so fuel economy is decreasing, not increasing.' from version_ins;
-- apcalcab-mcq-sv-h-3.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.1-b-v2', 'mcq', 'Interpret a composite rate with units (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of water in a tank is V(h) liters when the depth is h centimeters, and V′(h) = 12 liters per centimeter at the current depth. The depth after t minutes is h(t), and h′(t) = −0.5 centimeters per minute at that moment. Which statement is correct?', null, md5('apcalcab-mcq-sv-h-3.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume is decreasing at 12 liters per minute.', false, 'This uses V′(h) alone, which is per centimeter of depth and ignores the falling depth.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The volume is decreasing at 6 liters per minute.', true, 'Correct: d/dt V(h(t)) = V′(h)·h′(t) = (12)(−0.5) = −6 liters per minute.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The volume is decreasing at 24 liters per minute.', false, 'This divides 12 by 0.5 instead of multiplying.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The volume is increasing at 6 liters per minute.', false, 'The depth is falling, so the product is negative and the volume is decreasing.' from version_ins;
-- apcalcab-mcq-sv-h-3.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.1-b-v3', 'mcq', 'Interpret a composite rate with units (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The pressure on a diver is P(d) atmospheres at depth d meters, and P′(d) = 0.1 atmospheres per meter at the diver''s current depth. The diver is ascending, so the depth d(t) is changing at d′(t) = −3 meters per minute. Which statement is correct about the pressure on the diver?', null, md5('apcalcab-mcq-sv-h-3.1-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is decreasing at 0.3 atmospheres per minute.', true, 'Correct: P′(d)·d′(t) = (0.1)(−3) = −0.3 atmospheres per minute.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is increasing at 0.1 atmospheres per minute.', false, 'This uses P′(d) alone and ignores the diver''s change in depth.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is increasing at 0.3 atmospheres per minute.', false, 'Ascending reduces depth, so the pressure falls and the rate is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is decreasing at 0.03 atmospheres per minute.', false, 'This divides instead of multiplying the two rates.' from version_ins;
-- apcalcab-mcq-h-3.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-h-3.2-a', 'mcq', 'Horizontal tangents of an implicit curve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of x² + xy + y² = 7 have a horizontal tangent line?', null, md5('apcalcab-mcq-h-3.2-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(±√7, 0)', false, 'These are the points where y = 0, which is not the condition for dy/dx = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, ±√7)', false, 'These are the points where x = 0, which is not the condition for dy/dx = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−2√21/3, √21/3) and (2√21/3, −√21/3)', false, 'These are the points where x + 2y = 0, where the tangent line is vertical rather than horizontal.' from version_ins
union all select gen_random_uuid(), id, 'D', '(√21/3, −2√21/3) and (−√21/3, 2√21/3)', true, 'Correct: dy/dx = −(2x + y)/(x + 2y). A horizontal tangent needs 2x + y = 0, so y = −2x, and then x² − 2x² + 4x² = 3x² = 7, so x = ±√21/3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-h-3.1-a','apcalcab-mcq-sv-h-3.1-a-v1','apcalcab-mcq-sv-h-3.1-a-v2','apcalcab-mcq-sv-h-3.1-a-v3','apcalcab-mcq-h-3.1-b','apcalcab-mcq-sv-h-3.1-b-v1','apcalcab-mcq-sv-h-3.1-b-v2','apcalcab-mcq-sv-h-3.1-b-v3','apcalcab-mcq-h-3.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-h-3.1-a','apcalcab-mcq-sv-h-3.1-a-v1','apcalcab-mcq-sv-h-3.1-a-v2','apcalcab-mcq-sv-h-3.1-a-v3','apcalcab-mcq-h-3.1-b','apcalcab-mcq-sv-h-3.1-b-v1','apcalcab-mcq-sv-h-3.1-b-v2','apcalcab-mcq-sv-h-3.1-b-v3','apcalcab-mcq-h-3.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
