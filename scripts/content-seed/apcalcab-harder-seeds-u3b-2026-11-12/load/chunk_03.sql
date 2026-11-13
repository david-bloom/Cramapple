begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b2-sv-h-3.6-a-v2','apcalcab-mcq-b2-sv-h-3.6-a-v3','apcalcab-mcq-b2-h-3.6-b','apcalcab-mcq-b2-sv-h-3.6-b-v1','apcalcab-mcq-b2-sv-h-3.6-b-v2','apcalcab-mcq-b2-sv-h-3.6-b-v3'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcab-mcq-b2-sv-h-3.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.6-a-v2', 'mcq', 'find a second derivative of a composite or product of unspecified functions by applying the chain and product rules twic (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is twice differentiable, with f(0) = 0, f′(0) = 2 and f″(0) = −3. If h(x) = e^(f(x)), what is h″(0)?', null, md5('apcalcab-mcq-b2-sv-h-3.6-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3', false, 'This keeps only e^f·f″ and drops the term e^f·(f′)² that arises from differentiating e^f a second time.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', true, 'Correct: h′ = e^f·f′; h″ = e^f·(f′)² + e^f·f″ = e⁰(4 − 3) = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This uses f″ + f′ in place of f″ + (f′)², forgetting to square f′(0).' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This keeps only the term e^f·(f′)² and drops e^f·f″.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.6-a-v3', 'mcq', 'find a second derivative of a composite or product of unspecified functions by applying the chain and product rules twic (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The functions f and g are twice differentiable, with f(1) = 2, f′(1) = 3, f″(1) = −1, g(1) = −2, g′(1) = 4 and g″(1) = 5. If h(x) = f(x)·g(x), what is h″(1)?', null, md5('apcalcab-mcq-b2-sv-h-3.6-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24', false, 'This omits the factor 2 on the middle term, using f′g′ instead of 2f′g′.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'This keeps only f″g + f·g″ and drops the cross term 2f′g′.' from version_ins
union all select gen_random_uuid(), id, 'C', '36', true, 'Correct: h″ = f″g + 2f′g′ + f·g″ = (−1)(−2) + 2(3)(4) + (2)(5) = 2 + 24 + 10 = 36.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5', false, 'This multiplies the two second derivatives, f″(1)·g″(1), which ignores the product rule.' from version_ins;
-- apcalcab-mcq-b2-h-3.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-h-3.6-b', 'mcq', 'find and interpret the second derivative of a function defined implicitly, substituting dy/dx before evaluating.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve y² = 4x passes through the point (4, 4), and near that point y is a differentiable function of x. Which statement about d²y/dx² at (4, 4) is correct?', null, md5('apcalcab-mcq-b2-h-3.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx² = −1/8, so the curve is concave down at (4, 4).', false, 'This differentiates 2/y as −2/y² and forgets the chain factor dy/dx = 1/2, which gives −1/8 instead of −2(1/2)/16 = −1/16.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx² = 1/16, so the curve is concave up at (4, 4).', false, 'This loses the minus sign when differentiating 2/y; the derivative of 1/y is −y′/y², which is negative here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx² = −1/16, so the curve is concave down at (4, 4).', true, 'Correct: 2y·y′ = 4 gives y′ = 2/y. Then y″ = −2y′/y² = −4/y³. At (4, 4): y′ = 1/2 and y″ = −4/64 = −1/16 < 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx² = 1/2, so the curve is concave up at (4, 4).', false, 'This reports dy/dx = 2/y = 1/2, the first derivative, instead of differentiating a second time.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.6-b-v1', 'mcq', 'find and interpret the second derivative of a function defined implicitly, substituting dy/dx before evaluating. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near the point (2, 2) on the curve xy = 4, y is a differentiable function of x. Which statement about d²y/dx² at (2, 2) is correct?', null, md5('apcalcab-mcq-b2-sv-h-3.6-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx² = −1, so the curve is concave down at (2, 2).', false, 'This makes a sign error in the quotient step: y″ = −(x·y′ − y)/x² with y′ = −1 equals +1, not −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx² = 1/2, so the curve is concave up at (2, 2).', false, 'This drops the term x·y′ and uses only −(−y)/x² = y/x², ignoring that y′ is not zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx² = 2, so the curve is concave up at (2, 2).', false, 'This forgets to divide by x² and reports 2y/x instead of 2y/x².' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx² = 1, so the curve is concave up at (2, 2).', true, 'Correct: Differentiating xy = 4 gives y + x·y′ = 0, so y′ = −y/x = −1. Then y″ = −(x·y′ − y)/x² = −(−2 − 2)/4 = 1 > 0.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.6-b-v2', 'mcq', 'find and interpret the second derivative of a function defined implicitly, substituting dy/dx before evaluating. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Near the point (3, 4) on the circle x² + y² = 25, y is a differentiable function of x. Which statement about d²y/dx² at (3, 4) is correct?', null, md5('apcalcab-mcq-b2-sv-h-3.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx² = −1/4, so the curve is concave down at (3, 4).', false, 'This treats y′ as 0 when differentiating −x/y, so the term x·y′ in the quotient rule is lost.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx² = −7/64, so the curve is concave down at (3, 4).', false, 'This substitutes y′ = −x/y with the wrong sign, giving y − x²/y in the numerator instead of y + x²/y.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx² = −25/16, so the curve is concave down at (3, 4).', false, 'This divides by y² instead of y³; the simplified result is −25/y³.' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx² = −25/64, so the curve is concave down at (3, 4).', true, 'Correct: y′ = −x/y; y″ = −(y − x·y′)/y² = −(y² + x²)/y³ = −25/y³. At (3, 4): −25/64 < 0.' from version_ins;
-- apcalcab-mcq-b2-sv-h-3.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b2-sv-h-3.6-b-v3', 'mcq', 'find and interpret the second derivative of a function defined implicitly, substituting dy/dx before evaluating. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The curve x = y³ + 2y passes through the point (3, 1), and near that point y is a differentiable function of x. Which statement about d²y/dx² at (3, 1) is correct?', null, md5('apcalcab-mcq-b2-sv-h-3.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'd²y/dx² = −6/125, so the curve is concave down at (3, 1).', true, 'Correct: 1 = (3y² + 2)y′ gives y′ = 1/(3y² + 2) = 1/5. Then y″ = −6y·y′/(3y² + 2)² = −6(1/5)/25 = −6/125 < 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'd²y/dx² = 6/125, so the curve is concave up at (3, 1).', false, 'This loses the minus sign: differentiating (3y² + 2)⁻¹ produces −(3y² + 2)⁻²·6y·y′, which is negative here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'd²y/dx² = −6/25, so the curve is concave down at (3, 1).', false, 'This forgets one factor of dy/dx = 1/5 from the chain rule when differentiating 1/(3y² + 2).' from version_ins
union all select gen_random_uuid(), id, 'D', 'd²y/dx² = −1/25, so the curve is concave down at (3, 1).', false, 'This treats 3y² + 2 as if it were x, ignoring the chain factor 6y·(dy/dx) from the inner function.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b2-sv-h-3.6-a-v2','apcalcab-mcq-b2-sv-h-3.6-a-v3','apcalcab-mcq-b2-h-3.6-b','apcalcab-mcq-b2-sv-h-3.6-b-v1','apcalcab-mcq-b2-sv-h-3.6-b-v2','apcalcab-mcq-b2-sv-h-3.6-b-v3']) and status='draft')<>6 then raise exception 'chunk 3: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b2-sv-h-3.6-a-v2','apcalcab-mcq-b2-sv-h-3.6-a-v3','apcalcab-mcq-b2-h-3.6-b','apcalcab-mcq-b2-sv-h-3.6-b-v1','apcalcab-mcq-b2-sv-h-3.6-b-v2','apcalcab-mcq-b2-sv-h-3.6-b-v3']))<>24 then raise exception 'chunk 3: expected 24 choices'; end if;
end $$;
commit;
