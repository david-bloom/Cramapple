begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.7-b-v2','apcalcab-mcq-b6-sv-h-1.7-b-v3','apcalcab-mcq-b6-h-1.8-a','apcalcab-mcq-b6-sv-h-1.8-a-v1','apcalcab-mcq-b6-sv-h-1.8-a-v2','apcalcab-mcq-b6-sv-h-1.8-a-v3','apcalcab-mcq-b6-h-1.8-b','apcalcab-mcq-b6-sv-h-1.8-b-v1','apcalcab-mcq-b6-sv-h-1.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-sv-h-1.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.7-b-v2', 'mcq', 'split a limit into a special trigonometric limit and a rational factor and combine the pieces (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [tan(3x)·(x + 5)]/[x(x + 1)]?', null, md5('apcalcab-mcq-b6-sv-h-1.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This treats tan(3x)/x as approaching 1. The limit of tan(3x)/x is 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '15', true, 'Correct: Rewrite as [tan(3x)/x]·[(x + 5)/(x + 1)]. The first factor approaches 3 and the second approaches 5, so the limit is 3 · 5 = 15.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This finds the limit of tan(3x)/x but ignores the factor (x + 5)/(x + 1), which approaches 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting x = 0 makes the numerator 0, but the denominator is 0 too. The limit must be found using the limit of tan(3x)/x.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.7-b-v3', 'mcq', 'split a limit into a special trigonometric limit and a rational factor and combine the pieces (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [sin(6x)·(x + 4)]/[3x(x + 2)]?', null, md5('apcalcab-mcq-b6-sv-h-1.7-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'Correct: Rewrite as [sin(6x)/(3x)]·[(x + 4)/(x + 2)]. The first factor approaches 6/3 = 2 and the second approaches 2, so the limit is 2 · 2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This finds the limit of sin(6x)/(3x) but ignores the factor (x + 4)/(x + 2), which approaches 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '12', false, 'This takes sin(6x)/x → 6 and ignores the 3 in the denominator, then multiplies by 2. The factor 3x divides the limit 6 down to 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Substituting x = 0 makes the numerator 0, but the denominator is 0 too. The limit must be found from the special limit sin(6x)/x → 6.' from version_ins;
-- apcalcab-mcq-b6-h-1.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.8-a', 'mcq', 'apply the Squeeze Theorem to a bounded oscillating factor inside a product and then add a constant', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [5 + x²(3 + sin(1/x))]?', null, md5('apcalcab-mcq-b6-h-1.8-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'The factor sin(1/x) oscillates, but it is bounded and multiplied by x², which approaches 0. The Squeeze Theorem shows the product has limit 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'The value 8 is 5 + 3, as if sin(1/x) were 0 and x² were 1. The factor x² approaches 0, so the product term approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', true, 'Correct: Since −1 ≤ sin(1/x) ≤ 1, we have 2x² ≤ x²(3 + sin(1/x)) ≤ 4x². Both bounds approach 0, so by the Squeeze Theorem the product approaches 0, and the limit of the whole expression is 5 + 0 = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The product x²(3 + sin(1/x)) approaches 0, but the constant 5 is added to it. The limit of the whole expression is 5.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.8-a-v1', 'mcq', 'apply the Squeeze Theorem to a bounded oscillating factor inside a product and then add a constant (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [x⁴(5 + cos(1/x²)) − 2]?', null, md5('apcalcab-mcq-b6-sv-h-1.8-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2', true, 'Correct: Since −1 ≤ cos(1/x²) ≤ 1, we have 4x⁴ ≤ x⁴(5 + cos(1/x²)) ≤ 6x⁴. Both bounds approach 0, so the product approaches 0, and the limit of the whole expression is 0 − 2 = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist', false, 'The factor cos(1/x²) oscillates, but it is bounded and multiplied by x⁴, which approaches 0. The Squeeze Theorem gives a product limit of 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'The value 3 is 5 − 2, as if the cosine factor contributed 0 and x⁴ contributed 1. Since x⁴ approaches 0, the whole product term approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The product term approaches 0, but the constant −2 is still subtracted. The limit of the whole expression is −2.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.8-a-v2', 'mcq', 'apply the Squeeze Theorem to a bounded oscillating factor inside a product and then add a constant (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→2) [7 + (x − 2)²(4 + sin(1/(x − 2)))]?', null, md5('apcalcab-mcq-b6-sv-h-1.8-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'The sine factor oscillates wildly near 2, but it is bounded and multiplied by (x − 2)², which approaches 0. The Squeeze Theorem gives a limit of 0 for the product.' from version_ins
union all select gen_random_uuid(), id, 'B', '11', false, 'The value 11 is 7 + 4, as if the factor (x − 2)² were 1 and the sine were 0. That squared factor approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', true, 'Correct: Since −1 ≤ sin(1/(x − 2)) ≤ 1, we have 3(x − 2)² ≤ (x − 2)²(4 + sin(1/(x − 2))) ≤ 5(x − 2)². Both bounds approach 0, so the product approaches 0 and the limit is 7 + 0 = 7.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The product term approaches 0, but the constant 7 is added. The limit of the full expression is 7.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.8-a-v3', 'mcq', 'apply the Squeeze Theorem to a bounded oscillating factor inside a product and then add a constant (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) [1 + |x|(2 + cos(3/x))]?', null, md5('apcalcab-mcq-b6-sv-h-1.8-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'The cosine factor oscillates, but it is bounded and multiplied by |x|, which approaches 0. The Squeeze Theorem gives a product limit of 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', true, 'Correct: Since −1 ≤ cos(3/x) ≤ 1, we have |x| ≤ |x|(2 + cos(3/x)) ≤ 3|x|. Both bounds approach 0, so the product approaches 0, and the limit of the whole expression is 1 + 0 = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'The value 3 is 1 + 2, as if |x| were 1 and the cosine factor were 0. Because |x| approaches 0, the product term approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The product term approaches 0, but the constant 1 is added. The limit of the whole expression is 1.' from version_ins;
-- apcalcab-mcq-b6-h-1.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.8-b', 'mcq', 'identify where two quadratic bounds meet so the Squeeze Theorem applies, and recognize it applies nowhere else', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies 4x − x² ≤ f(x) ≤ x² + 2 for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?', null, md5('apcalcab-mcq-b6-h-1.8-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For every a, because f lies between two continuous functions.', false, 'Being squeezed between two continuous functions fixes the limit only where the two bounds approach the same value. Away from x = 1 the bounds have different limits, which leaves a range of possible values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only for a = 0, where the bounds equal 0 and 2.', false, 'The Squeeze Theorem needs the two bounds to have the same limit. At x = 0 the bounds are 0 and 2, which differ, so the theorem does not apply.' from version_ins
union all select gen_random_uuid(), id, 'C', 'For no value of a, because the two bounds are different functions.', false, 'Different bounds are fine; they only need to share a limit at the point of interest. They share the limit 3 at x = 1, so the theorem applies there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only for a = 1, where both bounds equal 3, so the limit is 3.', true, 'Correct: The bounds differ by (x² + 2) − (4x − x²) = 2(x − 1)², which is zero only at x = 1. There both bounds equal 3, so the limit is 3. At every other a the bounds have different limits and the theorem gives no value.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.8-b-v1', 'mcq', 'identify where two quadratic bounds meet so the Squeeze Theorem applies, and recognize it applies nowhere else (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies 6x − 9 ≤ f(x) ≤ x² for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?', null, md5('apcalcab-mcq-b6-sv-h-1.8-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For every a, because f lies between two continuous functions.', false, 'The theorem determines a limit only when the two bounds approach the same value. Away from x = 3 the bounds differ, so f is not forced to one limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only for a = 3, where both bounds equal 9, so the limit is 9.', true, 'Correct: The bounds differ by x² − (6x − 9) = (x − 3)², which is zero only at x = 3. There both bounds equal 9, so the limit is 9. At other values of a the bounds have different limits.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only for a = 0, where the bounds equal −9 and 0.', false, 'The bounds must have equal limits for the Squeeze Theorem. At x = 0 they are −9 and 0, which differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'For no value of a, because the two bounds are different functions.', false, 'The bounds are allowed to be different functions as long as they approach the same value at the point. At x = 3 both approach 9.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.8-b-v2', 'mcq', 'identify where two quadratic bounds meet so the Squeeze Theorem applies, and recognize it applies nowhere else (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies 4x + 1 ≤ f(x) ≤ x² + 5 for all x. For which values of a can the Squeeze Theorem be used to find lim(x→a) f(x) from these bounds, and what is the limit?', null, md5('apcalcab-mcq-b6-sv-h-1.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'For every a, because f lies between two continuous functions.', false, 'The limit is forced only where both bounds approach the same value. Away from x = 2 the two bounds disagree.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only for a = 2, where both bounds equal 9, so the limit is 9.', true, 'Correct: The bounds differ by (x² + 5) − (4x + 1) = (x − 2)², which is zero only at x = 2. There both bounds equal 9, so the limit is 9. Elsewhere the bounds have different limits.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only for a = 0, where the bounds equal 1 and 5.', false, 'The bounds must have the same limit. At x = 0 they are 1 and 5, which differ, so no conclusion is possible.' from version_ins
union all select gen_random_uuid(), id, 'D', 'For no value of a, because the two bounds are different functions.', false, 'Bounds can be different functions. At x = 2 they approach the same value, 9, and the theorem applies.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.7-b-v2','apcalcab-mcq-b6-sv-h-1.7-b-v3','apcalcab-mcq-b6-h-1.8-a','apcalcab-mcq-b6-sv-h-1.8-a-v1','apcalcab-mcq-b6-sv-h-1.8-a-v2','apcalcab-mcq-b6-sv-h-1.8-a-v3','apcalcab-mcq-b6-h-1.8-b','apcalcab-mcq-b6-sv-h-1.8-b-v1','apcalcab-mcq-b6-sv-h-1.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-sv-h-1.7-b-v2','apcalcab-mcq-b6-sv-h-1.7-b-v3','apcalcab-mcq-b6-h-1.8-a','apcalcab-mcq-b6-sv-h-1.8-a-v1','apcalcab-mcq-b6-sv-h-1.8-a-v2','apcalcab-mcq-b6-sv-h-1.8-a-v3','apcalcab-mcq-b6-h-1.8-b','apcalcab-mcq-b6-sv-h-1.8-b-v1','apcalcab-mcq-b6-sv-h-1.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
