begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.10-a-v1','apcalcab-mcq-b7-sv-h-1.10-a-v2','apcalcab-mcq-b7-sv-h-1.10-a-v3','apcalcab-mcq-b7-h-1.10-b','apcalcab-mcq-b7-sv-h-1.10-b-v1','apcalcab-mcq-b7-sv-h-1.10-b-v2','apcalcab-mcq-b7-sv-h-1.10-b-v3','apcalcab-mcq-b7-h-1.11-a','apcalcab-mcq-b7-sv-h-1.11-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-sv-h-1.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.10-a-v1', 'mcq', 'classify discontinuities of a rational function containing an absolute value by comparing one-sided limits, distinguishi (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = |x + 2|/(x² + x − 2). Which of the following correctly describes the discontinuities of g?', null, md5('apcalcab-mcq-b7-sv-h-1.10-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A removable discontinuity at x = −2 and an infinite discontinuity at x = 1', false, 'Cancelling x + 2 requires |x + 2| = x + 2, true only for x > −2. For x < −2 the quotient is −1/(x − 1), so the one-sided limits 1/3 and −1/3 differ.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infinite discontinuities at both x = −2 and x = 1', false, 'At x = −2 the factor x + 2 cancels in magnitude, so the one-sided limits are finite, ±1/3. Only x = 1 is an infinite discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A jump discontinuity at x = −2 and an infinite discontinuity at x = 1', true, 'Correct: Near −2 the one-sided limits are 1/3 (left) and −1/3 (right); near 1 the numerator is 3 and the denominator tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A jump discontinuity at x = 1 and an infinite discontinuity at x = −2', false, 'The roles are reversed. At x = 1 the numerator is 3 and the denominator tends to 0, which is infinite. At x = −2 the one-sided limits are finite and unequal, a jump.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.10-a-v2', 'mcq', 'classify discontinuities of a rational function containing an absolute value by comparing one-sided limits, distinguishi (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = |2x − 6|/(x² − 2x − 3). Which of the following correctly describes the discontinuities of h?', null, md5('apcalcab-mcq-b7-sv-h-1.10-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A removable discontinuity at x = 3 and an infinite discontinuity at x = −1', false, 'The absolute value makes the quotient equal 2/(x + 1) for x > 3 but −2/(x + 1) for x < 3, so the one-sided limits at 3 are 1/2 and −1/2, which differ.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A jump discontinuity at x = −1 and an infinite discontinuity at x = 3', false, 'At x = −1 the numerator is |−8| = 8 and the denominator tends to 0, so that point is infinite. The finite, unequal one-sided limits occur at x = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Jump discontinuities at both x = 3 and x = −1', false, 'At x = −1 the numerator is 8 and the denominator tends to 0, so the one-sided limits are unbounded, not finite and unequal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A jump discontinuity at x = 3 and an infinite discontinuity at x = −1', true, 'Correct: At x = 3 the one-sided limits are −1/2 and 1/2; at x = −1 the numerator is 8 and the denominator tends to 0.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.10-a-v3', 'mcq', 'classify discontinuities of a rational function containing an absolute value by comparing one-sided limits, distinguishi (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let q(x) = (x² − 9)/|x + 3|. Which of the following correctly describes the discontinuities of q?', null, md5('apcalcab-mcq-b7-sv-h-1.10-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Only a removable discontinuity, at x = −3', false, 'Cancelling x + 3 with |x + 3| works on one side only. From the left the quotient equals −(x − 3), approaching 6, from the right it equals x − 3, approaching −6, so there is no single limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only a jump discontinuity, at x = −3, with one-sided limits 6 and −6', true, 'Correct: For x < −3, q(x) = −(x − 3) → 6; for x > −3, q(x) = x − 3 → −6. The denominator is nonzero away from −3, so there is no other discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An infinite discontinuity at x = −3', false, 'The factor x + 3 in the numerator offsets the factor in |x + 3| in the denominator, so the quotient stays bounded near −3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A jump discontinuity at x = −3 and an infinite discontinuity at x = 3', false, 'The point x = 3 makes the numerator 0, not the denominator. q(3) = 0 and q is continuous there, so there is no infinite discontinuity.' from version_ins;
-- apcalcab-mcq-b7-h-1.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.10-b', 'mcq', 'choose the parameter that turns a discontinuity at a break point into a removable one rather than a jump, using one-side', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = 3x + 1 for x < 2, f(2) = 10, and f(x) = x² + k for x > 2, where k is a constant. For which value of k does f have a removable discontinuity at x = 2?', null, md5('apcalcab-mcq-b7-h-1.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 6', false, 'This makes the right-hand limit 4 + k equal to f(2) = 10, but the left-hand limit is 7, so the two-sided limit still fails to exist, giving a jump.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 3', true, 'Correct: The left limit is 3(2) + 1 = 7. A removable discontinuity needs the right limit 4 + k = 7, so k = 3, and f(2) = 10 ≠ 7 keeps it discontinuous.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 7', false, 'This sets k equal to the left-hand limit 7, forgetting that the right-hand limit is 2² + k = 4 + k.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 10', false, 'This sets k equal to f(2). The right-hand limit is 4 + k, so k = 10 gives 14, which does not match the left-hand limit 7.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.10-b-v1', 'mcq', 'choose the parameter that turns a discontinuity at a break point into a removable one rather than a jump, using one-side (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is defined by g(x) = x² + 2x for x < 1, g(1) = 0, and g(x) = kx + 5 for x > 1, where k is a constant. For which value of k does g have a removable discontinuity at x = 1?', null, md5('apcalcab-mcq-b7-sv-h-1.10-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −5', false, 'This sets kx + 5 = g(1) = 0 at x = 1. The limit must match the left-hand limit 3, not the point value.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 8', false, 'This solves k + 5 = 3 with a sign slip, moving +5 across the equation as +5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = −2', true, 'Correct: The left limit is 1 + 2 = 3. A removable discontinuity needs k + 5 = 3, so k = −2, and g(1) = 0 ≠ 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 3', false, 'This sets k equal to the left-hand limit 3. The right-hand limit is k(1) + 5 = k + 5.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.10-b-v2', 'mcq', 'choose the parameter that turns a discontinuity at a break point into a removable one rather than a jump, using one-side (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = (x² − 9)/(x − 3) for x < 3, f(3) = 1, and f(x) = kx − 12 for x > 3, where k is a constant. For which value of k does f have a removable discontinuity at x = 3?', null, md5('apcalcab-mcq-b7-sv-h-1.10-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 13/3', false, 'This sets kx − 12 equal to f(3) = 1 at x = 3. The limit from the right must equal the limit from the left, which is 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 4', false, 'This sets 3k − 12 = 0, matching nothing in the problem. The left-hand limit is 6, not 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 18', false, 'This stops after finding 3k = 18, forgetting to divide by 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 6', true, 'Correct: For x < 3, f(x) = x + 3 → 6. Need 3k − 12 = 6, so k = 6; f(3) = 1 ≠ 6.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.10-b-v3', 'mcq', 'choose the parameter that turns a discontinuity at a break point into a removable one rather than a jump, using one-side (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = x² + 3x for x < −1, f(−1) = 5, and f(x) = k − x for x > −1, where k is a constant. For which value of k does f have a removable discontinuity at x = −1?', null, md5('apcalcab-mcq-b7-sv-h-1.10-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −3', true, 'Correct: The left limit is 1 − 3 = −2. Need k − (−1) = k + 1 = −2, so k = −3, and f(−1) = 5 ≠ −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = −1', false, 'This evaluates k − x at x = −1 as k − 1 instead of k + 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 4', false, 'This sets k + 1 = f(−1) = 5. The right-hand limit must match the left-hand limit −2, not the point value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = −2', false, 'This sets k equal to the left-hand limit −2, ignoring the −x term, which contributes +1 at x = −1.' from version_ins;
-- apcalcab-mcq-b7-h-1.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.11-a', 'mcq', 'apply the three-part definition of continuity at two junctions of a three-piece function, writing and solving two linear', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = x + 1 for x < 1, f(x) = ax + b for 1 ≤ x ≤ 3, and f(x) = x² − 2 for x > 3, where a and b are constants. For what value of a is f continuous for all real x?', null, md5('apcalcab-mcq-b7-h-1.11-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 5/2', true, 'Correct: Continuity at 1 gives a + b = 2, at 3 gives 3a + b = 7. Subtracting gives 2a = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 5', false, 'This subtracts the two matching values (7 − 2) without dividing by the interval length 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 2', false, 'This uses only the condition at x = 1, a + b = 2, and assumes b = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 7/3', false, 'This assumes b = 0 in the condition at x = 3, 3a = 7, and ignores the condition at x = 1.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.11-a-v1', 'mcq', 'apply the three-part definition of continuity at two junctions of a three-piece function, writing and solving two linear (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = 2x − 1 for x < −2, f(x) = ax + b for −2 ≤ x ≤ 1, and f(x) = x² + 3 for x > 1, where a and b are constants. For what value of b is f continuous for all real x?', null, md5('apcalcab-mcq-b7-sv-h-1.11-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'b = 4', false, 'This assumes a = 0 in the condition at x = 1, a + b = 4, and ignores the other junction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'b = −5', false, 'This takes b equal to the matching value −5 at x = −2, ignoring the term −2a.' from version_ins
union all select gen_random_uuid(), id, 'C', 'b = 1', true, 'Correct: At −2: −2a + b = −5. At 1: a + b = 4. Subtracting gives 3a = 9, a = 3, so b = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'b = 2', false, 'This takes a = 2 and uses a + b = 4 without checking the condition at x = −2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.10-a-v1','apcalcab-mcq-b7-sv-h-1.10-a-v2','apcalcab-mcq-b7-sv-h-1.10-a-v3','apcalcab-mcq-b7-h-1.10-b','apcalcab-mcq-b7-sv-h-1.10-b-v1','apcalcab-mcq-b7-sv-h-1.10-b-v2','apcalcab-mcq-b7-sv-h-1.10-b-v3','apcalcab-mcq-b7-h-1.11-a','apcalcab-mcq-b7-sv-h-1.11-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-sv-h-1.10-a-v1','apcalcab-mcq-b7-sv-h-1.10-a-v2','apcalcab-mcq-b7-sv-h-1.10-a-v3','apcalcab-mcq-b7-h-1.10-b','apcalcab-mcq-b7-sv-h-1.10-b-v1','apcalcab-mcq-b7-sv-h-1.10-b-v2','apcalcab-mcq-b7-sv-h-1.10-b-v3','apcalcab-mcq-b7-h-1.11-a','apcalcab-mcq-b7-sv-h-1.11-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
