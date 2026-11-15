begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.2-a-v1','apcalcbc-mcq-b2-sv-h-3.2-a-v2','apcalcbc-mcq-b2-sv-h-3.2-a-v3','apcalcbc-mcq-b2-h-3.2-b','apcalcbc-mcq-b2-sv-h-3.2-b-v1','apcalcbc-mcq-b2-sv-h-3.2-b-v2','apcalcbc-mcq-b2-sv-h-3.2-b-v3','apcalcbc-mcq-b2-h-3.3-a','apcalcbc-mcq-b2-sv-h-3.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b2-sv-h-3.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.2-a-v1', 'mcq', 'locate points of horizontal tangency on an implicitly defined curve by setting the numerator of dy/dx to zero and substi (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of x² − xy + y² = 3 have a horizontal tangent line?', null, md5('apcalcbc-mcq-b2-sv-h-3.2-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2, 1) and (−2, −1)', false, 'These are the points where 2y − x = 0, so the tangent is vertical; a horizontal tangent needs 2x − y = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(1, 2) and (−1, −2)', true, 'Correct: Differentiating gives dy/dx = (y − 2x)/(2y − x). Horizontal tangents need y = 2x; substituting gives 3x² = 3, x = ±1, and the points are (1, 2) and (−1, −2), where 2y − x ≠ 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '(√3, √3) and (−√3, −√3)', false, 'These come from setting x − y = 0, which is not the condition dy/dx = 0 for this curve.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only (1, 2)', false, 'This finds one solution but misses (−1, −2), which also lies on the curve with 2x − y = 0.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.2-a-v2', 'mcq', 'locate points of horizontal tangency on an implicitly defined curve by setting the numerator of dy/dx to zero and substi (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of 3x² + 2xy + y² = 6 have a horizontal tangent line?', null, md5('apcalcbc-mcq-b2-sv-h-3.2-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(√3, −√3) and (−√3, √3)', false, 'These are the points where 2x + 2y = 0, so the tangent is vertical; a horizontal tangent needs 6x + 2y = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(1, −3) and (−1, 3)', true, 'Correct: Differentiating gives dy/dx = −(3x + y)/(x + y). Horizontal tangents need y = −3x; substituting gives 6x² = 6, x = ±1, and the points are (1, −3) and (−1, 3), where x + y ≠ 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only (1, −3)', false, 'This finds one solution but misses (−1, 3), which also lies on the curve with 3x + y = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There are no points with a horizontal tangent line.', false, 'Setting 3x + y = 0 and substituting into the equation gives 6x² = 6, which has real solutions, so horizontal tangents exist.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.2-a-v3', 'mcq', 'locate points of horizontal tangency on an implicitly defined curve by setting the numerator of dy/dx to zero and substi (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of x² + y² − 4x = 0 have a horizontal tangent line?', null, md5('apcalcbc-mcq-b2-sv-h-3.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, 0) and (4, 0)', false, 'These are the points where y = 0, so the tangent is vertical; a horizontal tangent needs the numerator 2x − 4 to be zero.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only (2, 2)', false, 'This finds one solution but misses (2, −2), which also lies on the circle with x = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2, 2) and (2, −2)', true, 'Correct: Differentiating gives dy/dx = (4 − 2x)/(2y) = (2 − x)/y. Horizontal tangents need x = 2; substituting gives y² = 4, so the points are (2, 2) and (2, −2), where y ≠ 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2, 0)', false, 'The point (2, 0) is the center of the circle, not a point on the graph, since 4 + 0 − 8 ≠ 0.' from version_ins;
-- apcalcbc-mcq-b2-h-3.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.2-b', 'mcq', 'build the tangent line to an implicit curve at a point and use it to find an intercept.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The point (0, 2) lies on the curve y² − xy = 4. The line tangent to the curve at (0, 2) crosses the x-axis at what value of x?', null, md5('apcalcbc-mcq-b2-h-3.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', true, 'Correct: Differentiating gives 2y·y′ − y − x·y′ = 0, so y′ = y/(2y − x) = 2/4 = 1/2 at (0, 2). The tangent y = 2 + x/2 meets y = 0 at x = −4.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This uses the slope −1/2, the negative of dy/dx, so the tangent line is reflected and crosses the axis on the wrong side.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'This uses the normal line, with slope −2, instead of the tangent line with slope 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', false, 'This uses 2 as the slope, which is the reciprocal of dy/dx = 1/2, and so describes a different line.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.2-b-v1', 'mcq', 'build the tangent line to an implicit curve at a point and use it to find an intercept. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The point (1, 2) lies on the curve x² + xy + y² = 7. The line tangent to the curve at (1, 2) crosses the x-axis at what value of x?', null, md5('apcalcbc-mcq-b2-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/2', false, 'This uses the slope +4/5, the negative of dy/dx, so the line is reflected and crosses the axis on the wrong side of x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3/5', false, 'This uses the normal line, with slope 5/4, instead of the tangent line with slope −4/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '13/5', false, 'This uses −5/4 as the slope, which inverts dy/dx = −Fx/Fy to −Fy/Fx.' from version_ins
union all select gen_random_uuid(), id, 'D', '7/2', true, 'Correct: Differentiating gives 2x + y + (x + 2y)y′ = 0, so y′ = −(2x + y)/(x + 2y) = −4/5 at (1, 2). The tangent y − 2 = −(4/5)(x − 1) meets y = 0 at x = 7/2.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.2-b-v2', 'mcq', 'build the tangent line to an implicit curve at a point and use it to find an intercept. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The point (1, 2) lies on the curve y³ + xy = 10. The line tangent to the curve at (1, 2) crosses the x-axis at what value of x?', null, md5('apcalcbc-mcq-b2-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12', false, 'This uses the slope +2/13, the negative of dy/dx, so the line is reflected and crosses the axis on the wrong side of x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '9/13', false, 'This uses the normal line, with slope 13/2, instead of the tangent line with slope −2/13.' from version_ins
union all select gen_random_uuid(), id, 'C', '14', true, 'Correct: Differentiating gives 3y²·y′ + y + x·y′ = 0, so y′ = −y/(3y² + x) = −2/13 at (1, 2). The tangent y − 2 = −(2/13)(x − 1) meets y = 0 at x = 14.' from version_ins
union all select gen_random_uuid(), id, 'D', '17/13', false, 'This uses −13/2 as the slope, which inverts dy/dx = −Fx/Fy to −Fy/Fx.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.2-b-v3', 'mcq', 'build the tangent line to an implicit curve at a point and use it to find an intercept. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The point (1, 2) lies on the curve xy² + y = 6. The line tangent to the curve at (1, 2) crosses the y-axis at what value of y?', null, md5('apcalcbc-mcq-b2-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6/5', false, 'This uses the slope +4/5, the negative of dy/dx, so the line is reflected and the intercept is on the wrong side of y = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/4', false, 'This uses the normal line, with slope 5/4, instead of the tangent line with slope −4/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '14/5', true, 'Correct: Differentiating gives y² + (2xy + 1)y′ = 0, so y′ = −y²/(2xy + 1) = −4/5 at (1, 2). The tangent y − 2 = −(4/5)(x − 1) has y-intercept 2 + 4/5 = 14/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/5', false, 'This computes the slope times the x-distance, −(4/5)(0 − 1), but forgets to add the y-coordinate 2 of the point.' from version_ins;
-- apcalcbc-mcq-b2-h-3.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.3-a', 'mcq', 'differentiate a composition or product involving an inverse function, using table values of f only.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = g(2x + 1).
x | f(x) | f′(x)
1 | 3 | 4
2 | 5 | 6
3 | 8 | 7
What is h′(1)?', null, md5('apcalcbc-mcq-b2-h-3.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', true, 'Correct: g(3) = 1 because f(1) = 3, so g′(3) = 1/f′(1) = 1/4. Then h′(1) = g′(3)·2 = 2/4 = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/4', false, 'This finds g′(3) but omits the chain-rule factor 2 from the inner function 2x + 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This multiplies by f′(1) instead of dividing: the inverse derivative is the reciprocal 1/f′(g(3)).' from version_ins
union all select gen_random_uuid(), id, 'D', '2/7', false, 'This evaluates f′ at 3 instead of at g(3) = 1; the inverse derivative uses f′ at the point where f equals 3.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.3-a-v1', 'mcq', 'differentiate a composition or product involving an inverse function, using table values of f only. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is differentiable and one-to-one, with the values below. Let g = f⁻¹ and h(x) = x·g(x).
x | f(x) | f′(x)
1 | 2 | 5
2 | 6 | 3
4 | 9 | 2
What is h′(6)?', null, md5('apcalcbc-mcq-b2-sv-h-3.3-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20', false, 'This uses f′(2) = 3 where g′(6) = 1/f′(2) belongs, treating the inverse derivative as f′ instead of its reciprocal.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This drops the product-rule term g(6) and keeps only x·g′(x).' from version_ins
union all select gen_random_uuid(), id, 'C', '2/3', false, 'This multiplies g(6) by g′(6) instead of applying the product rule to x·g(x).' from version_ins
union all select gen_random_uuid(), id, 'D', '4', true, 'Correct: g(6) = 2 because f(2) = 6, and g′(6) = 1/f′(2) = 1/3. Then h′(6) = g(6) + 6·g′(6) = 2 + 2 = 4.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.2-a-v1','apcalcbc-mcq-b2-sv-h-3.2-a-v2','apcalcbc-mcq-b2-sv-h-3.2-a-v3','apcalcbc-mcq-b2-h-3.2-b','apcalcbc-mcq-b2-sv-h-3.2-b-v1','apcalcbc-mcq-b2-sv-h-3.2-b-v2','apcalcbc-mcq-b2-sv-h-3.2-b-v3','apcalcbc-mcq-b2-h-3.3-a','apcalcbc-mcq-b2-sv-h-3.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b2-sv-h-3.2-a-v1','apcalcbc-mcq-b2-sv-h-3.2-a-v2','apcalcbc-mcq-b2-sv-h-3.2-a-v3','apcalcbc-mcq-b2-h-3.2-b','apcalcbc-mcq-b2-sv-h-3.2-b-v1','apcalcbc-mcq-b2-sv-h-3.2-b-v2','apcalcbc-mcq-b2-sv-h-3.2-b-v3','apcalcbc-mcq-b2-h-3.3-a','apcalcbc-mcq-b2-sv-h-3.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
