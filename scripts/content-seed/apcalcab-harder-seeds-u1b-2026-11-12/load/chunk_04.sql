begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.12-a-v3','apcalcab-mcq-b7-h-1.12-b','apcalcab-mcq-b7-sv-h-1.12-b-v1','apcalcab-mcq-b7-sv-h-1.12-b-v2','apcalcab-mcq-b7-sv-h-1.12-b-v3','apcalcab-mcq-b7-h-1.13-a','apcalcab-mcq-b7-sv-h-1.13-a-v1','apcalcab-mcq-b7-sv-h-1.13-a-v2','apcalcab-mcq-b7-sv-h-1.13-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-sv-h-1.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.12-a-v3', 'mcq', 'decide on which closed interval a function with a radical or logarithm and a rational factor is continuous, checking the (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = sin x/(2cos x − 1). On which of the following closed intervals is f continuous?', null, md5('apcalcab-mcq-b7-sv-h-1.12-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, π/2]', false, 'This contains x = π/3, where cos x = 1/2 and the denominator is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−π/3, 0]', false, 'The endpoint x = −π/3 has cos x = 1/2, so the denominator is 0 there and f is undefined.' from version_ins
union all select gen_random_uuid(), id, 'C', '[π/6, π/2]', false, 'This contains x = π/3, where the denominator is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '[−π/6, π/6]', true, 'Correct: The denominator is zero when cos x = 1/2, that is x = ±π/3 + 2πn. [−π/6, π/6] contains none of these.' from version_ins;
-- apcalcab-mcq-b7-h-1.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.12-b', 'mcq', 'use a verbal description of limits and values at specific points to decide on which interval a function is continuous, a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined on [0, 8]. It is known that lim(x→3−) f(x) = 2, lim(x→3+) f(x) = 2, and f(3) = 2; that lim(x→6−) f(x) = 4, lim(x→6+) f(x) = 1, and f(6) = 1; and that f is continuous at every other point of [0, 8] (one-sided at the endpoints). On which of the following sets is f continuous?', null, md5('apcalcab-mcq-b7-h-1.12-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 6)', true, 'Correct: f is continuous at 3 and everywhere except at 6, so it is continuous on [0, 6) and on [6, 8].' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 6]', false, 'At x = 6 the left-hand limit 4 does not equal f(6) = 1, so f is not continuous from the left at 6, and 6 cannot be the right endpoint of an interval of continuity.' from version_ins
union all select gen_random_uuid(), id, 'C', '[3, 8]', false, 'This contains x = 6, where the limit from the left differs from the limit from the right.' from version_ins
union all select gen_random_uuid(), id, 'D', '(0, 8)', false, 'This contains x = 6 as an interior point, where f has a jump.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.12-b-v1', 'mcq', 'use a verbal description of limits and values at specific points to decide on which interval a function is continuous, a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined on [−4, 4]. It is known that lim(x→−1−) f(x) = 5, lim(x→−1+) f(x) = 5, and f(−1) = 5; that lim(x→2−) f(x) = 3, lim(x→2+) f(x) = 3, and f(2) = 0; and that f is continuous at every other point of [−4, 4] (one-sided at the endpoints). On which of the following sets is f continuous?', null, md5('apcalcab-mcq-b7-sv-h-1.12-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−4, 4]', false, 'At x = 2 the limit is 3 but f(2) = 0, so f has a removable discontinuity at 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−4, 2) ∪ (2, 4]', true, 'Correct: The only point of discontinuity is x = 2, so f is continuous on [−4, 2) ∪ (2, 4].' from version_ins
union all select gen_random_uuid(), id, 'C', '[−4, 2]', false, 'The right endpoint x = 2 fails continuity from the left, since the limit 3 differs from f(2) = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−4, −1) ∪ (−1, 4)', false, 'This wrongly removes x = −1, where the limit and the value are both 5, so f is continuous there.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.12-b-v2', 'mcq', 'use a verbal description of limits and values at specific points to decide on which interval a function is continuous, a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined on [1, 9] except at x = 7, where f is undefined and lim(x→7) f(x) = ∞ from both sides. Also lim(x→3−) f(x) = 2, lim(x→3+) f(x) = 5, and f(3) = 5, and f is continuous at every other point of its domain (one-sided at the endpoints). Which of the following is the longest interval on which f is continuous?', null, md5('apcalcab-mcq-b7-sv-h-1.12-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[1, 7)', false, 'This contains x = 3 as an interior point, where the one-sided limits 2 and 5 differ.' from version_ins
union all select gen_random_uuid(), id, 'B', '[3, 7)', true, 'Correct: f is continuous from the right at 3 (limit 5 = f(3)) and continuous up to but not including 7, so [3, 7) has length 4, longer than [1, 3) or (7, 9].' from version_ins
union all select gen_random_uuid(), id, 'C', '[3, 7]', false, 'F is not defined at 7, so 7 cannot belong to an interval of continuity.' from version_ins
union all select gen_random_uuid(), id, 'D', '[1, 3]', false, 'The right endpoint x = 3 requires continuity from the left, but the left-hand limit 2 differs from f(3) = 5.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.12-b-v3', 'mcq', 'use a verbal description of limits and values at specific points to decide on which interval a function is continuous, a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined on [0, 10]. The graph has a sharp corner at x = 5, but lim(x→5) f(x) = f(5) = 2. At x = 8, lim(x→8−) f(x) = 4 = f(8) and lim(x→8+) f(x) = 1. At every other point f is continuous (one-sided at the endpoints). Which of the following is the longest interval on which f is continuous?', null, md5('apcalcab-mcq-b7-sv-h-1.12-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 10]', false, 'This contains x = 8 as an interior point, where the right-hand limit 1 differs from f(8) = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '[5, 10]', false, 'This also contains x = 8 as an interior point, where f has a jump.' from version_ins
union all select gen_random_uuid(), id, 'C', '[0, 5]', false, 'F is continuous on this interval, but it stops short because the corner at 5 is mistaken for a discontinuity. A corner does not break continuity.' from version_ins
union all select gen_random_uuid(), id, 'D', '[0, 8]', true, 'Correct: f is continuous at 5 (limit equals value) and left-continuous at 8, so f is continuous on [0, 8], which has length 8.' from version_ins;
-- apcalcab-mcq-b7-h-1.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.13-a', 'mcq', 'find the value that removes a discontinuity of a complex fraction by combining the fractions, factoring and cancelling t', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = (1/x − 1/2)/(x − 2) for x ≠ 0 and x ≠ 2. What value should be assigned to g(2) so that g is continuous at x = 2?', null, md5('apcalcab-mcq-b7-h-1.13-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/4', true, 'Correct: (1/x − 1/2)/(x − 2) = ((2 − x)/(2x))/(x − 2) = −1/(2x), which tends to −1/4 as x → 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/4', false, 'This has a sign error. 1/x − 1/2 = (2 − x)/(2x), whose factor 2 − x is −(x − 2), so the quotient is −1/(2x).' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/2', false, 'This drops the 2 in the denominator, simplifying to −1/x and evaluating at x = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This substitutes into the numerator, where 1/2 − 1/2 = 0, and ignores that the denominator is also 0.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.13-a-v1', 'mcq', 'find the value that removes a discontinuity of a complex fraction by combining the fractions, factoring and cancelling t (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = (1/(x + 1) − 1/4)/(x − 3) for x ≠ −1 and x ≠ 3. What value should be assigned to g(3) so that g is continuous at x = 3?', null, md5('apcalcab-mcq-b7-sv-h-1.13-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/16', false, 'This has a sign error. The numerator combines to (3 − x)/(4(x + 1)), and 3 − x is −(x − 3).' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/16', true, 'Correct: 1/(x + 1) − 1/4 = (3 − x)/(4(x + 1)), so g(x) = −1/(4(x + 1)) → −1/16.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/4', false, 'This forgets the factor x + 1 in the denominator, leaving −1/4 instead of −1/(4(x + 1)).' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This substitutes into the numerator, getting 1/4 − 1/4 = 0, and ignores the zero in the denominator.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.13-a-v2', 'mcq', 'find the value that removes a discontinuity of a complex fraction by combining the fractions, factoring and cancelling t (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = (1/x² − 1/9)/(x − 3) for x ≠ 0 and x ≠ 3. What value should be assigned to g(3) so that g is continuous at x = 3?', null, md5('apcalcab-mcq-b7-sv-h-1.13-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/27', false, 'This has a sign error. 9 − x² = −(x − 3)(x + 3), so the quotient is −(x + 3)/(9x²).' from version_ins
union all select gen_random_uuid(), id, 'B', '−2/27', true, 'Correct: 1/x² − 1/9 = (9 − x²)/(9x²), so g(x) = −(x + 3)/(9x²) → −6/81 = −2/27.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2/3', false, 'This forgets the x² in the denominator and evaluates −(x + 3)/9.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This substitutes into the numerator, getting 1/9 − 1/9 = 0, and ignores the zero in the denominator.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.13-a-v3', 'mcq', 'find the value that removes a discontinuity of a complex fraction by combining the fractions, factoring and cancelling t (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = (1/(2x − 1) − 1)/(x − 1) for x ≠ 1/2 and x ≠ 1. What value should be assigned to g(1) so that g is continuous at x = 1?', null, md5('apcalcab-mcq-b7-sv-h-1.13-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This has a sign error. 1 − (2x − 1) = 2 − 2x = −2(x − 1).' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', true, 'Correct: 1/(2x − 1) − 1 = (2 − 2x)/(2x − 1) = −2(x − 1)/(2x − 1), so g(x) = −2/(2x − 1) → −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This loses the factor 2 from 2 − 2x and evaluates −1/(2x − 1).' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This substitutes into the numerator, getting 1 − 1 = 0, and ignores the zero in the denominator.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.12-a-v3','apcalcab-mcq-b7-h-1.12-b','apcalcab-mcq-b7-sv-h-1.12-b-v1','apcalcab-mcq-b7-sv-h-1.12-b-v2','apcalcab-mcq-b7-sv-h-1.12-b-v3','apcalcab-mcq-b7-h-1.13-a','apcalcab-mcq-b7-sv-h-1.13-a-v1','apcalcab-mcq-b7-sv-h-1.13-a-v2','apcalcab-mcq-b7-sv-h-1.13-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-sv-h-1.12-a-v3','apcalcab-mcq-b7-h-1.12-b','apcalcab-mcq-b7-sv-h-1.12-b-v1','apcalcab-mcq-b7-sv-h-1.12-b-v2','apcalcab-mcq-b7-sv-h-1.12-b-v3','apcalcab-mcq-b7-h-1.13-a','apcalcab-mcq-b7-sv-h-1.13-a-v1','apcalcab-mcq-b7-sv-h-1.13-a-v2','apcalcab-mcq-b7-sv-h-1.13-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
