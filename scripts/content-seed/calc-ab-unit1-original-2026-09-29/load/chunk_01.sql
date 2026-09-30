begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1n-001','apcalcab-mcq-u1n-002','apcalcab-mcq-u1n-003','apcalcab-mcq-u1n-004','apcalcab-mcq-u1n-005','apcalcab-mcq-u1n-006','apcalcab-mcq-u1n-007','apcalcab-mcq-u1n-008','apcalcab-mcq-u1n-009','apcalcab-mcq-u1n-010','apcalcab-mcq-u1n-011','apcalcab-mcq-u1n-012'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ 001 | topic 1.1 | easy | Instantaneous Velocity From Average Velocity
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-001', 'mcq', 'Instantaneous Velocity From Average Velocity', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = t^2 feet at time t seconds. The average velocity of the particle over the interval [2, 2 + h] is 4 + h feet per second. What is the instantaneous velocity of the particle at t = 2?', md5('apcalcab-mcq-u1n-001'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 feet per second', false, 'Letting h approach 0 shrinks the interval, but it does not make the velocity 0. The expression 4 + h approaches 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 feet per second', false, 'This uses the time t = 2 as if it were the velocity. The velocity is found from the limit of the average velocity, not read off the time.' from version_ins
union all select gen_random_uuid(), id, 'C', '4 feet per second', true, 'The instantaneous velocity is the limit of the average velocity as h approaches 0. As h approaches 0, 4 + h approaches 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 + h feet per second', false, 'This is the average velocity over an interval of length h, so it depends on h. The instantaneous velocity is the limit of that expression as h approaches 0.' from version_ins
;
-- MCQ 002 | topic 1.1 | medium | Estimating an Instantaneous Rate From Shrinking Intervals
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-002', 'mcq', 'Estimating an Instantaneous Rate From Shrinking Intervals', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives the average rate of change of a function f over the interval [1, 1 + h] for three values of h.

h = 0.1: 6.3
h = 0.01: 6.03
h = 0.001: 6.003

Which of the following is the best estimate of the instantaneous rate of change of f at x = 1?', md5('apcalcab-mcq-u1n-002'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.003', false, 'This is the average rate over the smallest interval in the table. It is close to the target but is still an average over an interval of length 0.001, not the value the averages approach.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.3', false, 'This is only the average rate over the widest interval. It is the least accurate of the three values, not the value being approached.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', true, 'As the interval shrinks, the average rates are 6.3, 6.03, 6.003, moving toward 6. The instantaneous rate is the value these averages approach.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'Shrinking the interval toward length 0 does not make the rate 0. The averages in the table are getting closer to 6.' from version_ins
;
-- MCQ 003 | topic 1.2 | easy | What a Limit Statement Guarantees
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-003', 'mcq', 'What a Limit Statement Guarantees', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If lim(x->4) f(x) = 7, which of the following must be true?', md5('apcalcab-mcq-u1n-003'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is defined at x = 4', false, 'The limit as x approaches 4 does not depend on whether f is defined at x = 4, so the statement does not guarantee this.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is continuous at x = 4', false, 'Continuity requires f(4) to exist and equal the limit. The limit statement alone does not tell us anything about f(4).' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(4) = 7', false, 'A limit describes what f does near x = 4, not at x = 4. The value f(4) may be a different number, or f(4) may be undefined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The values of f(x) get arbitrarily close to 7 as x gets arbitrarily close to 4 from both sides of 4.', true, 'This is the meaning of a two-sided limit: the outputs approach 7 as the inputs approach 4 from the left and from the right.' from version_ins
;
-- MCQ 004 | topic 1.2 | medium | Limit Versus Function Value
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-004', 'mcq', 'Limit Versus Function Value', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be the function defined by

f(x) = 2x - 1 for x < 3
f(3) = 9
f(x) = x^2 - 4 for x > 3

What is lim(x->3) f(x)?', md5('apcalcab-mcq-u1n-004'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist.', false, 'The limit would fail to exist if the one-sided limits differed. Here both equal 5. The fact that f(3) = 9 does not affect the limit.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This evaluates 2x at x = 3 and drops the -1 from the left-hand piece. The left piece is 2x - 1, which equals 5 at x = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', true, 'From the left, 2(3) - 1 = 5. From the right, 3^2 - 4 = 5. The one-sided limits agree, so the limit is 5, regardless of f(3).' from version_ins
union all select gen_random_uuid(), id, 'D', '9', false, 'This is the value of f(3). The limit depends only on the values of f near 3, not on the value at 3.' from version_ins
;
-- MCQ 005 | topic 1.4 | medium | Estimating a Limit From a Table With an Undefined Point
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-005', 'mcq', 'Estimating a Limit From a Table With an Undefined Point', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of a function f near x = 2. The value f(2) is undefined.

x = 1.9: f(x) = 2.9
x = 1.99: f(x) = 2.99
x = 1.999: f(x) = 2.999
x = 2.001: f(x) = 3.001
x = 2.01: f(x) = 3.01
x = 2.1: f(x) = 3.1

Which of the following is the best estimate of lim(x->2) f(x)?', md5('apcalcab-mcq-u1n-005'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.1', false, 'This is the output at the sampled point x = 2.1, which is the farthest from 2 on the right. The values keep decreasing toward 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.999', false, 'This is the value at x = 1.999, one of the sampled points. The limit is the number the values approach, not one of the sampled outputs.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'From both sides the values of f(x) get closer to 3 as x gets closer to 2. The undefined value f(2) does not affect the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist because f(2) is undefined.', false, 'A limit can exist even if the function is not defined at that point. What matters is the behavior of f on both sides of 2.' from version_ins
;
-- MCQ 006 | topic 1.5 | medium | Combining Limits With Algebraic Properties
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-006', 'mcq', 'Combining Limits With Algebraic Properties', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x->4) f(x) = 3 and lim(x->4) g(x) = -2. What is lim(x->4) [3f(x) + (g(x))^2] / [f(x) + g(x)]?', md5('apcalcab-mcq-u1n-006'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13/5', false, 'This uses 3 + 2 for the denominator, ignoring the sign of g. The denominator''s limit is 3 + (-2) = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This forgets to multiply f by 3 in the numerator, using 3 + 4 = 7 instead of 9 + 4 = 13.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This treats (-2)^2 as -4. Squaring -2 gives 4, so the numerator''s limit is 9 + 4 = 13, not 9 - 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '13', true, 'The numerator approaches 3(3) + (-2)^2 = 9 + 4 = 13 and the denominator approaches 3 + (-2) = 1. The denominator''s limit is not 0, so the quotient approaches 13/1 = 13.' from version_ins
;
-- MCQ 007 | topic 1.5 | medium | Quotient of Two Limits That Are Both Zero
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-007', 'mcq', 'Quotient of Two Limits That Are Both Zero', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x->1) f(x) = 0 and lim(x->1) g(x) = 0. Which of the following is true about lim(x->1) f(x)/g(x)?', md5('apcalcab-mcq-u1n-007'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It does not exist.', false, 'The quotient''s limit sometimes exists, as with f(x) = 2(x - 1) and g(x) = x - 1, where it equals 2. So it is not guaranteed not to exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 0.', false, 'The form 0/0 is indeterminate. It is not automatically 0, as the example f(x) = 2(x - 1) and g(x) = x - 1 shows, where the quotient approaches 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It cannot be determined from this information alone.', true, 'The quotient law for limits requires the denominator''s limit to be nonzero. When both limits are 0, the quotient can approach different values depending on the functions. For example, f(x) = 2(x - 1) and g(x) = x - 1 give 2, while f(x) = (x - 1)^2 and g(x) = x - 1 give 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It equals 1.', false, 'The form 0/0 is not automatically 1. The quotient''s limit depends on how quickly f and g each approach 0.' from version_ins
;
-- MCQ 008 | topic 1.7 | easy | Choosing a Method: When Direct Substitution Works
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-008', 'mcq', 'Choosing a Method: When Direct Substitution Works', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For which of the following limits can the value be found by direct substitution?', md5('apcalcab-mcq-u1n-008'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x->3) (x - 3)/(x^2 - 9)', false, 'Substituting x = 3 gives 0/0. The expression must be simplified first by factoring x^2 - 9 = (x - 3)(x + 3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x->1) (x^3 - 1)/(x - 1)', false, 'Substituting x = 1 gives 0/0. The expression must be simplified first by factoring x^3 - 1 = (x - 1)(x^2 + x + 1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x->0) |x|/x', false, 'Substituting x = 0 gives 0/0, and the one-sided limits are 1 from the right and -1 from the left, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x->2) (x^2 + 3x)/(x - 1)', true, 'Substituting x = 2 gives (4 + 6)/(2 - 1) = 10. The denominator is nonzero at x = 2, so direct substitution gives the limit.' from version_ins
;
-- MCQ 009 | topic 1.7 | medium | Using the Sine Limit After Adjusting the Argument
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-009', 'mcq', 'Using the Sine Limit After Adjusting the Argument', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x->0) sin(3x)/x?', md5('apcalcab-mcq-u1n-009'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator approaches 0, but so does the denominator. The form is 0/0, which is not automatically 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Write sin(3x)/x as 3 * sin(3x)/(3x). As x approaches 0, sin(3x)/(3x) approaches 1, so the limit is 3(1) = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3', false, 'This inverts the factor. Since sin(3x) behaves like 3x near 0, the ratio sin(3x)/x behaves like 3x/x = 3, not 1/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'The special limit sin(u)/u = 1 needs the same expression in the numerator''s argument and in the denominator. Here the argument is 3x but the denominator is x, so a factor of 3 remains.' from version_ins
;
-- MCQ 010 | topic 1.8 | easy | Applying the Squeeze Theorem
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-010', 'mcq', 'Applying the Squeeze Theorem', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies 4 - 3x^2 <= f(x) <= 4 + x^2 for all x. What is lim(x->0) f(x)?', md5('apcalcab-mcq-u1n-010'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'Both bounding functions approach 4 as x approaches 0. Since f is between them, the Squeeze Theorem gives lim f(x) = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This adds the two bounding limits, 4 + 4. The Squeeze Theorem says f has the same limit as the bounds, not their sum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It cannot be determined.', false, 'The Squeeze Theorem applies here because the upper and lower bounds have the same limit, 4, as x approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The terms 3x^2 and x^2 approach 0, but the bounds are 4 - 3x^2 and 4 + x^2, and those approach 4.' from version_ins
;
-- MCQ 011 | topic 1.9 | medium | Limit, Continuity and Discontinuity Type Together
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-011', 'mcq', 'Limit, Continuity and Discontinuity Type Together', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f has lim(x->2-) f(x) = 5, lim(x->2+) f(x) = 5, and f(2) = 1. Consider the following statements.

I. lim(x->2) f(x) exists.
II. f is continuous at x = 2.
III. f has a removable discontinuity at x = 2.

Which of the statements are true?', md5('apcalcab-mcq-u1n-011'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I only', false, 'Statement I is true, but so is III. A discontinuity where the limit exists but differs from the function value is removable.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I and III only', true, 'The one-sided limits are equal, so the limit exists (I). Because f(2) = 1 is not equal to the limit 5, f is not continuous at 2 (II is false). A discontinuity where the limit exists is removable (III).' from version_ins
union all select gen_random_uuid(), id, 'C', 'II and III only', false, 'Statement II is false because f(2) does not equal the limit, and statement I is true because the one-sided limits agree.' from version_ins
union all select gen_random_uuid(), id, 'D', 'I and II only', false, 'Continuity requires f(2) to equal the limit. Here f(2) = 1 and the limit is 5, so f is not continuous at x = 2.' from version_ins
;
-- MCQ 012 | topic 1.9 | medium | A Quotient With an Absolute Value
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-012', 'mcq', 'A Quotient With an Absolute Value', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = |x - 3|/(x - 3) for x != 3. Which of the following is true about lim(x->3) f(x)?', md5('apcalcab-mcq-u1n-012'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is -1.', false, 'This is the left-hand limit only. From the right, f(x) = 1, so the two-sided limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist because the one-sided limits are -1 and 1.', true, 'For x > 3, |x - 3| = x - 3, so f(x) = 1. For x < 3, |x - 3| = -(x - 3), so f(x) = -1. The one-sided limits differ, so the two-sided limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 0.', false, 'The values of f are -1 to the left and 1 to the right of x = 3. They are never 0 near x = 3, and neither one-sided limit is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 1.', false, 'This is the right-hand limit only. From the left, f(x) = -1, so the two-sided limit does not exist.' from version_ins
;

commit;
