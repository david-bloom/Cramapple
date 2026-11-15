begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-h-1.9-a','apcalcbc-mcq-b7-sv-h-1.9-a-v1','apcalcbc-mcq-b7-sv-h-1.9-a-v2','apcalcbc-mcq-b7-sv-h-1.9-a-v3','apcalcbc-mcq-b7-h-1.9-b','apcalcbc-mcq-b7-sv-h-1.9-b-v1','apcalcbc-mcq-b7-sv-h-1.9-b-v2','apcalcbc-mcq-b7-sv-h-1.9-b-v3','apcalcbc-mcq-b7-h-1.10-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-h-1.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.9-a', 'mcq', 'decide whether limits of sums and products exist from one-sided limits read off two described graphs, without using the ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f near x = 1 has these features: as x approaches 1 from the left, y approaches 2; as x approaches 1 from the right, y approaches 5; and f(1) = 3. The graph of g near x = 1 has these features: as x approaches 1 from the left, y approaches 3; as x approaches 1 from the right, y approaches 0; and g(1) = 4. Which of the following is true?', null, md5('apcalcbc-mcq-b7-h-1.9-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→1) [f(x) + g(x)] exists and equals 5, but lim(x→1) [f(x)·g(x)] does not exist.', true, 'Correct: Left side: sum 2 + 3 = 5, product 2·3 = 6. Right side: sum 5 + 0 = 5, product 5·0 = 0. The sum has equal one-sided limits 5; the product has 6 and 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Neither lim(x→1) [f(x) + g(x)] nor lim(x→1) [f(x)·g(x)] exists, because neither f nor g has a limit at x = 1.', false, 'A sum can have a limit even when each term has none; here the one-sided sums are 2 + 3 = 5 from the left and 5 + 0 = 5 from the right, so the sum does have a limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→1) [f(x)·g(x)] exists and equals 0, but lim(x→1) [f(x) + g(x)] does not exist.', false, 'The one-sided product limits are 2·3 = 6 from the left and 5·0 = 0 from the right, which disagree, so the product has no limit; 0 is only the right-hand value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both limits exist: lim(x→1) [f(x) + g(x)] = 7 and lim(x→1) [f(x)·g(x)] = 12.', false, 'Adding and multiplying f(1) = 3 and g(1) = 4 uses function values, but a limit depends only on the behavior near x = 1, not on the value at 1.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.9-a-v1', 'mcq', 'decide whether limits of sums and products exist from one-sided limits read off two described graphs, without using the  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f near x = 2 has these features: from the left, y approaches 4; from the right, y approaches −1; and f(2) = 1. The graph of g near x = 2: from the left, y approaches −2; from the right, y approaches 3; and g(2) = 0. Which of the following is true?', null, md5('apcalcbc-mcq-b7-sv-h-1.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→2) [f(x) + g(x)] exists and equals 2, but lim(x→2) [f(x) − g(x)] does not exist.', true, 'Correct: Left: f + g → 4 + (−2) = 2 and f − g → 4 − (−2) = 6. Right: f + g → −1 + 3 = 2 and f − g → −1 − 3 = −4. The sum agrees (2) and the difference does not (6 versus −4).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both limits exist: lim(x→2) [f(x) + g(x)] = 1 and lim(x→2) [f(x) − g(x)] = 1.', false, 'This substitutes f(2) = 1 and g(2) = 0, but a limit is determined by nearby values, not by the value at the point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→2) [f(x) − g(x)] exists and equals 6, but lim(x→2) [f(x) + g(x)] does not exist.', false, 'The value 6 is only the left-hand limit of the difference; the right-hand limit is −1 − 3 = −4, so the difference has no limit, while the sum, whose one-sided limits are both 2, does.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither limit exists, because f and g do not have limits at x = 2.', false, 'Individual limits failing to exist does not prevent a combination from having one; the left and right sums are both 2.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.9-a-v2', 'mcq', 'decide whether limits of sums and products exist from one-sided limits read off two described graphs, without using the  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f near x = −1 has these features: from the left, y approaches 2; from the right, y approaches −2; and f(−1) = 0. The graph of g near x = −1: from the left, y approaches 3; from the right, y approaches −3; and g(−1) = 1. Which of the following is true?', null, md5('apcalcbc-mcq-b7-sv-h-1.9-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→−1) [f(x)·g(x)] = 0 and lim(x→−1) [f(x) + g(x)] = 1.', false, 'This multiplies and adds the function values f(−1) = 0 and g(−1) = 1, which do not determine a limit at all.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→−1) [f(x) + g(x)] exists, but lim(x→−1) [f(x)·g(x)] does not exist.', false, 'The sum is the combination that fails: its one-sided limits are 5 from the left and −5 from the right, so it has no limit; the product is the one that exists.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Neither lim(x→−1) [f(x) + g(x)] nor lim(x→−1) [f(x)·g(x)] exists.', false, 'The product does exist because both one-sided products equal 6, even though f and g individually have jump behavior at x = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→−1) [f(x)·g(x)] exists and equals 6, but lim(x→−1) [f(x) + g(x)] does not exist.', true, 'Correct: Left: product 2·3 = 6, sum 2 + 3 = 5. Right: product (−2)(−3) = 6, sum −2 + (−3) = −5. The product has limit 6; the sum has one-sided limits 5 and −5.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.9-a-v3', 'mcq', 'decide whether limits of sums and products exist from one-sided limits read off two described graphs, without using the  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f near x = 0 has these features: from the left, y approaches 3; from the right, y approaches 1; and f(0) = 2. The graph of g near x = 0: from the left, y approaches 1; from the right, y approaches 3; and g(0) = 2. Which of the following is true?', null, md5('apcalcbc-mcq-b7-sv-h-1.9-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'All three limits (sum, product, and quotient) exist.', false, 'The quotient has left limit 3/1 = 3 and right limit 1/3, which differ, so the quotient has no limit even though the sum and product do.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Only the limit of the product exists.', false, 'The sum also has a limit: both one-sided sums are 3 + 1 = 1 + 3 = 4, so the product is not the only combination that exists.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sum, the product, and the quotient all fail to have limits at x = 0.', false, 'Although neither f nor g has a limit at 0, the sum (4 on both sides) and the product (3 on both sides) both do.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0) [f(x) + g(x)] = 4 and lim(x→0) [f(x)·g(x)] = 3 both exist, but lim(x→0) [f(x)/g(x)] does not exist.', true, 'Correct: Left: f + g → 4, f·g → 3, f/g → 3/1 = 3. Right: f + g → 4, f·g → 3, f/g → 1/3. The quotient has one-sided limits 3 and 1/3.' from version_ins;
-- apcalcbc-mcq-b7-h-1.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.9-b', 'mcq', 'recognize that a table of values on a special sequence of inputs can mislead, and use an algebraic or graphical descript', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A table lists values of f(x) = sin(π/x) at x = 1/2, 1/4, 1/10, 1/100, and 1/1000, and also at the negatives of these numbers. Every value in the table is 0. A student writes, "lim(x→0) f(x) = 0, because the table values are all 0." Which statement best evaluates the student''s conclusion?', null, md5('apcalcbc-mcq-b7-h-1.9-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The conclusion is correct: ten different inputs close to 0 on both sides all give 0, so the limit is 0.', false, 'A finite list of values, even on both sides of 0, cannot prove a limit; the tabulated inputs all happen to be of the form 1/n where the sine is 0, and other inputs give other values.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The conclusion is incorrect: the limit is +∞, because π/x grows without bound as x approaches 0.', false, 'The argument π/x does grow without bound, but sin of an unbounded argument keeps oscillating between −1 and 1 rather than growing, so the limit is not +∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conclusion is incorrect: the limit is 1, because f reaches its maximum value 1 arbitrarily close to 0.', false, 'The function takes the value 1 near 0 but also takes the values 0 and −1 near 0, so it does not settle at 1; a limit requires f to approach a single number.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The conclusion is incorrect: the limit does not exist, because f(x) = 1 at x = 2/5, 2/9, 2/13, ..., which also approach 0.', true, 'Correct: sin(π/x) = 0 at x = 1/n, but at x = 2/(4k + 1) it equals sin((4k + 1)π/2) = 1; two sequences approaching 0 give different values (0 and 1), so no limit.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.9-b-v1', 'mcq', 'recognize that a table of values on a special sequence of inputs can mislead, and use an algebraic or graphical descript (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student tabulates g(x) = cos(π/x) at x = 1/2, 1/4, 1/6, 1/8, and 1/100, finds g(x) = 1 every time, and concludes that lim(x→0+) g(x) = 1. Which statement is correct?', null, md5('apcalcbc-mcq-b7-sv-h-1.9-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The conclusion is correct: the values equal 1 at inputs that get arbitrarily close to 0 from the right.', false, 'All five inputs are even reciprocals 1/(2n), where cos(2nπ) = 1; a sample on one special sequence does not decide the limit, and inputs 1/(2n + 1) give −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The conclusion is incorrect: the limit is 0, because cos oscillates between −1 and 1 and the values average out to 0.', false, 'Averaging the extreme values is not how limits work; a limit exists only if g approaches one number, and g keeps hitting both 1 and −1 near 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The conclusion is incorrect: the limit is −1, because g(1/3) = −1 shows the true value that the table missed.', false, 'The value −1 on odd reciprocals is equally unrepresentative as the value 1 on even reciprocals; neither one is the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The conclusion is incorrect: the limit does not exist, because g(x) = −1 at x = 1/3, 1/5, 1/7, ..., which also approach 0 from the right.', true, 'Correct: cos(π/x) at x = 1/(2n) is cos(2nπ) = 1, and at x = 1/(2n + 1) is cos((2n + 1)π) = −1. Two sequences approaching 0+ give 1 and −1, so the limit does not exist.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.9-b-v2', 'mcq', 'recognize that a table of values on a special sequence of inputs can mislead, and use an algebraic or graphical descript (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A table lists values of h(x) = x·sin(π/x) at x = 1/2, 1/4, 1/10, 1/100, and 1/1000, and every value is 0. A student claims lim(x→0) h(x) = 0. Which statement gives the best justification that this claim is true?', null, md5('apcalcbc-mcq-b7-sv-h-1.9-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The table shows h(x) = 0 at five inputs approaching 0, so the limit is 0.', false, 'The claim happens to be true, but the table cannot justify it because the sampled inputs all make sin(π/x) = 0; a bound valid for all x near 0 is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Since sin(π/x) has no limit at 0, the product x·sin(π/x) has no limit at 0 either.', false, 'A product can have a limit even if one factor does not; here the factor x → 0 squeezes the bounded oscillation to 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Since −|x| ≤ x·sin(π/x) ≤ |x| for x ≠ 0 and both bounds approach 0, the Squeeze Theorem gives lim(x→0) h(x) = 0.', true, 'Correct: |x·sin(π/x)| ≤ |x| and |x| → 0, so the Squeeze Theorem gives 0. The table is only suggestive because sin(π/x) = 0 at every 1/n.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Since sin(π/x) oscillates between −1 and 1, the limit is the average of these, which is 0, regardless of the factor x.', false, 'The limit is 0 because the factor x forces the amplitude to 0, not because the oscillation averages out; without the factor x the oscillation would give no limit.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.9-b-v3', 'mcq', 'recognize that a table of values on a special sequence of inputs can mislead, and use an algebraic or graphical descript (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For f(x) = sin(3π/x), which of the following pairs of sequences of x-values, with both sequences approaching 0 as k = 1, 2, 3, ... increases, shows that lim(x→0) f(x) does not exist?', null, md5('apcalcbc-mcq-b7-sv-h-1.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x_k = 3/k and y_k = 3/(2k)', false, 'On both sequences f equals sin(kπ) = 0 and sin(2kπ) = 0, so the function values agree and this pair does not contradict a limit of 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x_k = 6/(4k + 1) and y_k = 6/(8k + 1)', false, 'On both sequences the argument is an odd multiple of π/2 that gives sine equal to 1 (since 4k + 1 and 8k + 1 are both 1 more than a multiple of 4), so both give 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x_k = 6/(4k + 1) and y_k = 6/(4k + 3)', true, 'Correct: f(3/k) = sin(kπ) = 0 and f(3/(2k)) = sin(2kπ) = 0. For 6/(4k + 1): sin((4k + 1)π/2) = 1; for 6/(8k + 1): sin((8k + 1)π/2) = 1; for 6/(4k + 5): sin((4k + 5)π/2) = 1; for 6/(4k + 3): sin((4k + 3)π/2) = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x_k = 6/(4k + 1) and y_k = 6/(4k + 5)', false, 'Both 4k + 1 and 4k + 5 are 1 more than a multiple of 4, so both sequences give sin = 1, again no disagreement. Only mixing 4k + 1 (value 1) with 4k + 3 (value −1) shows two different limits.' from version_ins;
-- apcalcbc-mcq-b7-h-1.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.10-a', 'mcq', 'classify a discontinuity from one-sided limits of an inverse-trigonometric expression and reject an argument that confus', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = arctan(1/(x − 2)) for x ≠ 2, and let f(2) = 0. A student argues, "f has a removable discontinuity at x = 2, because the one-sided limits are −π/2 and π/2, which average to f(2) = 0." Which statement is correct?', null, md5('apcalcbc-mcq-b7-h-1.10-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The discontinuity is a jump: the one-sided limits are −π/2 and π/2, so the jump has size π.', true, 'Correct: As x → 2−, 1/(x − 2) → −∞ and arctan → −π/2. As x → 2+, arctan → π/2. The one-sided limits are finite and unequal, so this is a jump of π/2 − (−π/2) = π.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student is correct: the discontinuity is removable.', false, 'A removable discontinuity requires the two-sided limit to exist, and here the one-sided limits differ; f(2) being their average does not make the limit exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The discontinuity is infinite, because 1/(x − 2) is unbounded near x = 2.', false, 'The inner expression is unbounded, but arctan is bounded, so f itself stays between −π/2 and π/2 and the one-sided limits are finite, which excludes an infinite discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The discontinuity is a jump of size π/2, which is the distance from f(2) = 0 to either one-sided limit.', false, 'The size of a jump is the difference between the two one-sided limits, π/2 − (−π/2) = π, not the distance from f(2) to one side.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-h-1.9-a','apcalcbc-mcq-b7-sv-h-1.9-a-v1','apcalcbc-mcq-b7-sv-h-1.9-a-v2','apcalcbc-mcq-b7-sv-h-1.9-a-v3','apcalcbc-mcq-b7-h-1.9-b','apcalcbc-mcq-b7-sv-h-1.9-b-v1','apcalcbc-mcq-b7-sv-h-1.9-b-v2','apcalcbc-mcq-b7-sv-h-1.9-b-v3','apcalcbc-mcq-b7-h-1.10-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-h-1.9-a','apcalcbc-mcq-b7-sv-h-1.9-a-v1','apcalcbc-mcq-b7-sv-h-1.9-a-v2','apcalcbc-mcq-b7-sv-h-1.9-a-v3','apcalcbc-mcq-b7-h-1.9-b','apcalcbc-mcq-b7-sv-h-1.9-b-v1','apcalcbc-mcq-b7-sv-h-1.9-b-v2','apcalcbc-mcq-b7-sv-h-1.9-b-v3','apcalcbc-mcq-b7-h-1.10-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
