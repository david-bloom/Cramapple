begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-h-3.3-a-v2','apcalcab-mcq-sv-h-3.3-a-v3','apcalcab-mcq-h-3.3-b','apcalcab-mcq-sv-h-3.3-b-v1','apcalcab-mcq-sv-h-3.3-b-v2','apcalcab-mcq-sv-h-3.3-b-v3'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcab-mcq-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.3-a-v2', 'mcq', 'Tangent line to an inverse function (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ + x, which is one-to-one. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = 2?', null, md5('apcalcab-mcq-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y − 1 = (1/4)(x − 2)', true, 'Correct: f(1) = 2, so f⁻¹(2) = 1; f′(1) = 4, so (f⁻¹)′(2) = 1/4 and y − 1 = (1/4)(x − 2).' from version_ins
union all select gen_random_uuid(), id, 'B', 'y − 2 = (1/4)(x − 1)', false, 'This swaps the coordinates, using (1, 2) on f instead of (2, 1) on f⁻¹.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y − 1 = 4(x − 2)', false, 'This uses the slope of f instead of its reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y − 1 = (1/4)(x − 1)', false, 'The tangent is at x = 2 on the inverse, so the point is (2, 1), not x = 1.' from version_ins;
-- apcalcab-mcq-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.3-a-v3', 'mcq', 'Tangent line to an inverse function (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one, with f(3) = −1 and f′(3) = 5. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = −1?', null, md5('apcalcab-mcq-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y + 1 = (1/5)(x − 3)', false, 'This swaps the coordinates and uses the point (3, −1) on f.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y − 3 = 5(x + 1)', false, 'This uses the slope of f instead of its reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y − 3 = (1/5)(x − 1)', false, 'This has the wrong x value; the point on the inverse has x = −1, so the factor is (x + 1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'y − 3 = (1/5)(x + 1)', true, 'Correct: f⁻¹(−1) = 3 and (f⁻¹)′(−1) = 1/f′(3) = 1/5, so y − 3 = (1/5)(x + 1).' from version_ins;
-- apcalcab-mcq-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-h-3.3-b', 'mcq', 'When an inverse function is not differentiable', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f(x) = x³ is one-to-one. Which statement about (f⁻¹)′(0) is correct?', null, md5('apcalcab-mcq-h-3.3-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(f⁻¹)′(0) = 0, because f(0) = 0.', false, 'F(0) = 0 does not make the derivative of the inverse 0; the derivative of the inverse is the reciprocal of f′.' from version_ins
union all select gen_random_uuid(), id, 'B', '(f⁻¹)′(0) = 1/3, because f⁻¹(x) = x^(1/3).', false, 'The power rule gives (1/3)x^(−2/3), which is undefined at x = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '(f⁻¹)′(0) does not exist, because f′(0) = 0 and the formula 1/f′(0) is undefined.', true, 'Correct: (f⁻¹)′(0) = 1/f′(f⁻¹(0)) = 1/f′(0) = 1/0; the graph of x^(1/3) has a vertical tangent at the origin.' from version_ins
union all select gen_random_uuid(), id, 'D', '(f⁻¹)′(0) = 1, because an inverse function reflects the graph across y = x.', false, 'Reflection across y = x swaps slopes into reciprocals, and the slope of f at 0 is 0, so the reciprocal is not 1.' from version_ins;
-- apcalcab-mcq-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.3-b-v1', 'mcq', 'When an inverse function is not differentiable (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f(x) = (x − 1)³ + 2 is one-to-one. Which statement about (f⁻¹)′(2) is correct?', null, md5('apcalcab-mcq-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(f⁻¹)′(2) = 0, because f′(2) = 3.', false, 'F′ must be evaluated at f⁻¹(2) = 1 and not at 2, and the reciprocal of its value is not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(f⁻¹)′(2) does not exist, because f⁻¹(2) = 1 and f′(1) = 0.', true, 'Correct: f(1) = 2, so f⁻¹(2) = 1; f′(1) = 3(1 − 1)² = 0, so 1/f′(1) is undefined.' from version_ins
union all select gen_random_uuid(), id, 'C', '(f⁻¹)′(2) = 1/3, because f′(2) = 3.', false, 'This evaluates f′ at 2 instead of at f⁻¹(2) = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '(f⁻¹)′(2) = 1, because f(1) = 2.', false, 'F(1) = 2 identifies the point, but the derivative is a reciprocal of f′(1), which is 0.' from version_ins;
-- apcalcab-mcq-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.3-b-v2', 'mcq', 'When an inverse function is not differentiable (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f(x) = x³ + 3x is one-to-one. Which statement about (f⁻¹)′(0) is correct?', null, md5('apcalcab-mcq-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(f⁻¹)′(0) does not exist, because f is a cubic and cubics have a vertical tangent at the origin.', false, 'This version of the cubic has f′(0) = 3, which is not 0, so the inverse is differentiable at 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(f⁻¹)′(0) = 0, because f(0) = 0.', false, 'F(0) = 0 locates the point, and the derivative is a reciprocal of f′(0).' from version_ins
union all select gen_random_uuid(), id, 'C', '(f⁻¹)′(0) = 3, because f′(0) = 3.', false, 'This forgets to take the reciprocal of f′(0).' from version_ins
union all select gen_random_uuid(), id, 'D', '(f⁻¹)′(0) = 1/3, because f⁻¹(0) = 0 and f′(0) = 3.', true, 'Correct: f(0) = 0 and f′(0) = 3(0)² + 3 = 3, so (f⁻¹)′(0) = 1/3.' from version_ins;
-- apcalcab-mcq-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.3-b-v3', 'mcq', 'When an inverse function is not differentiable (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = sin x on the interval −π/2 ≤ x ≤ π/2, so f is one-to-one. Which statement about (f⁻¹)′(1) is correct?', null, md5('apcalcab-mcq-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(f⁻¹)′(1) = 1, because f(π/2) = 1.', false, 'F(π/2) = 1 locates the point, but the derivative of the inverse is the reciprocal of f′(π/2), which is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(f⁻¹)′(1) = cos 1, because f′(x) = cos x.', false, 'This evaluates f′ at 1 instead of at f⁻¹(1) = π/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '(f⁻¹)′(1) does not exist, because f⁻¹(1) = π/2 and f′(π/2) = cos(π/2) = 0.', true, 'Correct: f⁻¹(1) = π/2; f′(π/2) = 0, so 1/f′(π/2) is undefined; the arcsine graph has a vertical tangent at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '(f⁻¹)′(1) = 0, because the sine function has a maximum at x = π/2.', false, 'The maximum of f makes f′(π/2) = 0, but the derivative of the inverse is then undefined, not 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-h-3.3-a-v2','apcalcab-mcq-sv-h-3.3-a-v3','apcalcab-mcq-h-3.3-b','apcalcab-mcq-sv-h-3.3-b-v1','apcalcab-mcq-sv-h-3.3-b-v2','apcalcab-mcq-sv-h-3.3-b-v3']) and status='draft')<>6 then raise exception 'chunk 3: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-sv-h-3.3-a-v2','apcalcab-mcq-sv-h-3.3-a-v3','apcalcab-mcq-h-3.3-b','apcalcab-mcq-sv-h-3.3-b-v1','apcalcab-mcq-sv-h-3.3-b-v2','apcalcab-mcq-sv-h-3.3-b-v3']))<>24 then raise exception 'chunk 3: expected 24 choices'; end if;
end $$;
commit;
