begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-h-3.2-a-v1','apcalcab-mcq-sv-h-3.2-a-v2','apcalcab-mcq-sv-h-3.2-a-v3','apcalcab-mcq-h-3.2-b','apcalcab-mcq-sv-h-3.2-b-v1','apcalcab-mcq-sv-h-3.2-b-v2','apcalcab-mcq-sv-h-3.2-b-v3','apcalcab-mcq-h-3.3-a','apcalcab-mcq-sv-h-3.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-sv-h-3.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.2-a-v1', 'mcq', 'Horizontal tangents of an implicit curve (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of x² − xy + y² = 3 have a horizontal tangent line?', null, md5('apcalcab-mcq-sv-h-3.2-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(1, 2) and (−1, −2)', true, 'Correct: dy/dx = (y − 2x)/(2y − x). A horizontal tangent needs y = 2x, and then x² − 2x² + 4x² = 3x² = 3, so x = ±1.' from version_ins
union all select gen_random_uuid(), id, 'B', '(±√3, 0)', false, 'These are the points where y = 0, which is not the condition for dy/dx = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '(0, ±√3)', false, 'These are the points where x = 0, which is not the condition for dy/dx = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2, 1) and (−2, −1)', false, 'These are the points where x = 2y, where the tangent is vertical.' from version_ins;
-- apcalcab-mcq-sv-h-3.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.2-a-v2', 'mcq', 'Horizontal tangents of an implicit curve (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement about the graph of x² + 4y² = 16 is correct?', null, md5('apcalcab-mcq-sv-h-3.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has horizontal tangent lines at (±4, 0).', false, 'At (±4, 0) the denominator 4y is 0, so the tangent lines are vertical.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has horizontal tangent lines at (±2√2, ±√2).', false, 'These points lie on the curve, but dy/dx there is −1/2 or 1/2, not 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has no horizontal tangent line, because dy/dx = −x/(4y) is undefined whenever y = 0.', false, 'Dy/dx = 0 requires only that the numerator be 0, and the denominator being 0 elsewhere does not remove other points.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It has horizontal tangent lines at (0, ±2).', true, 'Correct: dy/dx = −x/(4y) equals 0 when x = 0, and then 4y² = 16 gives y = ±2.' from version_ins;
-- apcalcab-mcq-sv-h-3.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.2-a-v3', 'mcq', 'Horizontal tangents of an implicit curve (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of y² = x³ − 3x have a horizontal tangent line?', null, md5('apcalcab-mcq-sv-h-3.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, 0)', false, 'At (0, 0) the denominator 2y is 0, so dy/dx is not 0 there.' from version_ins
union all select gen_random_uuid(), id, 'B', '(1, ±√2)', false, 'X = 1 gives y² = 1 − 3 = −2, so these points are not on the curve.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−1, √2) and (−1, −√2)', true, 'Correct: 2y·y′ = 3x² − 3, so y′ = (3x² − 3)/(2y) = 0 at x = ±1; y² = x³ − 3x gives y² = 2 at x = −1 but y² = −2 at x = 1, so only x = −1 is on the curve.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−1, ±√2) and (1, ±√2)', false, 'Only the points with x = −1 lie on the curve, and the points with x = 1 do not.' from version_ins;
-- apcalcab-mcq-h-3.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-h-3.2-b', 'mcq', 'Vertical tangents and undefined slope', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the circle x² + y² = 25, which statement is correct?', null, md5('apcalcab-mcq-h-3.2-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'dy/dx is undefined at (0, 5) and (0, −5), where the tangent lines are vertical.', false, 'Dy/dx = −x/y at (0, 5) equals 0, so the tangent line there is horizontal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'dy/dx is undefined at (5, 0) and (−5, 0), so the circle has no tangent line at those points.', false, 'An undefined derivative formula at a point on a smooth curve signals a vertical tangent, not the absence of one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'dy/dx = 0 at (5, 0) and (−5, 0), where the tangent lines are horizontal.', false, 'At (5, 0) the denominator y is 0, so the slope is not 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'dy/dx is undefined at (5, 0) and (−5, 0), where the tangent lines are vertical.', true, 'Correct: dy/dx = −x/y is undefined when y = 0, which gives (±5, 0); there the tangent lines are x = ±5.' from version_ins;
-- apcalcab-mcq-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.2-b-v1', 'mcq', 'Vertical tangents and undefined slope (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of x² − 2xy + 2y² = 4 have a vertical tangent line?', null, md5('apcalcab-mcq-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2√2, √2) and (−2√2, −√2)', true, 'Correct: dy/dx = (x − y)/(x − 2y). A vertical tangent needs x = 2y, and then 4y² − 4y² + 2y² = 2y² = 4, so y = ±√2 and x = ±2√2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(2, 2) and (−2, −2)', false, 'These are the points where x = y, which makes the numerator 0 and the tangent horizontal.' from version_ins
union all select gen_random_uuid(), id, 'C', '(±2, 0)', false, 'The points (±2, 0) lie on the curve, but there x − 2y = ±2 is not 0, so the tangent is not vertical; these come from setting y = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '(0, ±√2)', false, 'The points (0, ±√2) lie on the curve, but there x − 2y is not 0, so the tangent is not vertical; these come from setting x = 0.' from version_ins;
-- apcalcab-mcq-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.2-b-v2', 'mcq', 'Vertical tangents and undefined slope (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is an equation of the line tangent to the graph of x² + 4y² = 16 at the point (4, 0)?', null, md5('apcalcab-mcq-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0', false, 'Y = 0 is a horizontal line, but the slope at (4, 0) is infinite, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −(x − 4)/4', false, 'This uses a finite slope that does not come from dy/dx at this point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 4', true, 'Correct: dy/dx = −x/(4y) is undefined at (4, 0), and the tangent there is the vertical line x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is no tangent line, because dy/dx is undefined at (4, 0).', false, 'A curve can have a vertical tangent line where dy/dx is undefined, and the ellipse is smooth at (4, 0).' from version_ins;
-- apcalcab-mcq-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.2-b-v3', 'mcq', 'Vertical tangents and undefined slope (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student differentiates x² + y² = 25 to get dy/dx = −x/y and concludes that the circle has no tangent line at (5, 0) because the slope is undefined. Which statement best describes the error?', null, md5('apcalcab-mcq-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An undefined slope here means the tangent line is vertical (x = 5), not that no tangent line exists.', true, 'Correct: (5, 0) satisfies 25 = 25, and the tangent there is x = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The derivative is wrong, because dy/dx should be x/y.', false, 'The derivative −x/y is correct for this circle.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A tangent line exists only where dy/dx = 0.', false, 'A tangent line exists wherever the curve is smooth, whether the slope is 0, finite, or infinite.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The point (5, 0) is not on the circle.', false, 'The point (5, 0) satisfies the equation, since 25 + 0 = 25.' from version_ins;
-- apcalcab-mcq-h-3.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-h-3.3-a', 'mcq', 'Tangent line to an inverse function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and increasing, with f(2) = 5 and f′(2) = 1/3. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = 5?', null, md5('apcalcab-mcq-h-3.3-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y − 5 = 3(x − 2)', false, 'This swaps the coordinates, using the point (2, 5), which lies on f and not on f⁻¹.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y − 2 = (1/3)(x − 5)', false, 'This uses the slope of f instead of its reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y − 2 = −3(x − 5)', false, 'The slope of the inverse is the reciprocal of f′, not the negative reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y − 2 = 3(x − 5)', true, 'Correct: f⁻¹(5) = 2 and (f⁻¹)′(5) = 1/f′(2) = 3, so y − 2 = 3(x − 5).' from version_ins;
-- apcalcab-mcq-sv-h-3.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-sv-h-3.3-a-v1', 'mcq', 'Tangent line to an inverse function (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one, with f(1) = 4 and f′(1) = −2. Which is an equation of the line tangent to the graph of y = f⁻¹(x) at x = 4?', null, md5('apcalcab-mcq-sv-h-3.3-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y − 1 = −(1/2)(x − 4)', true, 'Correct: f⁻¹(4) = 1 and (f⁻¹)′(4) = 1/f′(1) = −1/2, so y − 1 = −(1/2)(x − 4).' from version_ins
union all select gen_random_uuid(), id, 'B', 'y − 4 = −(1/2)(x − 1)', false, 'This swaps the coordinates and uses the point (1, 4) on f instead of (4, 1) on f⁻¹.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y − 1 = −2(x − 4)', false, 'This uses the slope of f instead of its reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y − 1 = (1/2)(x − 4)', false, 'This drops the negative sign when taking the reciprocal of −2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-sv-h-3.2-a-v1','apcalcab-mcq-sv-h-3.2-a-v2','apcalcab-mcq-sv-h-3.2-a-v3','apcalcab-mcq-h-3.2-b','apcalcab-mcq-sv-h-3.2-b-v1','apcalcab-mcq-sv-h-3.2-b-v2','apcalcab-mcq-sv-h-3.2-b-v3','apcalcab-mcq-h-3.3-a','apcalcab-mcq-sv-h-3.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-sv-h-3.2-a-v1','apcalcab-mcq-sv-h-3.2-a-v2','apcalcab-mcq-sv-h-3.2-a-v3','apcalcab-mcq-h-3.2-b','apcalcab-mcq-sv-h-3.2-b-v1','apcalcab-mcq-sv-h-3.2-b-v2','apcalcab-mcq-sv-h-3.2-b-v3','apcalcab-mcq-h-3.3-a','apcalcab-mcq-sv-h-3.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
