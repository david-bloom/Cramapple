begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1n-013','apcalcab-mcq-u1n-014','apcalcab-mcq-u1n-015','apcalcab-mcq-u1n-016','apcalcab-mcq-u1n-017','apcalcab-mcq-u1n-018','apcalcab-mcq-u1n-019','apcalcab-mcq-u1n-020','apcalcab-mcq-u1n-021','apcalcab-mcq-u1n-022','apcalcab-mcq-u1n-023','apcalcab-mcq-u1n-024'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ 013 | topic 1.10 | easy | Identifying a Jump Discontinuity
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-013', 'mcq', 'Identifying a Jump Discontinuity', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be the function defined by

f(x) = x + 2 for x < 1
f(x) = 5 - x for x >= 1

Which of the following describes f at x = 1?', md5('apcalcab-mcq-u1n-013'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a removable discontinuity at x = 1.', false, 'A removable discontinuity has equal one-sided limits. Here the one-sided limits are 3 and 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a jump discontinuity at x = 1.', true, 'From the left, the limit is 1 + 2 = 3. From the right, the limit is 5 - 1 = 4. Both one-sided limits exist but are unequal, which is a jump discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is continuous at x = 1.', false, 'Continuity requires the limit to exist. The left-hand limit is 3 and the right-hand limit is 4, so the limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has an infinite discontinuity at x = 1.', false, 'An infinite discontinuity involves unbounded behavior. Both one-sided limits here are finite numbers.' from version_ins
;
-- MCQ 014 | topic 1.10 | medium | Recognizing an Infinite Discontinuity
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-014', 'mcq', 'Recognizing an Infinite Discontinuity', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following functions has an infinite discontinuity at x = 3?', md5('apcalcab-mcq-u1n-014'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = |x - 3|/(x - 3)', false, 'The one-sided limits are -1 and 1, both finite. This is a jump discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = (x^2 - x - 6)/(x - 3)', false, 'Factoring gives (x - 3)(x + 2)/(x - 3), which equals x + 2 for x != 3. The limit at 3 is 5, so this is a removable discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = (x - 3)/(x + 3)', false, 'This function is continuous at x = 3, where it equals 0. Its discontinuity is at x = -3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = (x + 1)/(x - 3)^2', true, 'At x = 3 the denominator is 0 and the numerator is 4, which is nonzero. The function is unbounded near 3, so there is an infinite discontinuity.' from version_ins
;
-- MCQ 015 | topic 1.11 | medium | Choosing a Parameter for Continuity at a Boundary
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-015', 'mcq', 'Choosing a Parameter for Continuity at a Boundary', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be the function defined by

f(x) = ax + 1 for x < 2
f(x) = x^2 - a for x >= 2

For what value of a is f continuous at x = 2?', md5('apcalcab-mcq-u1n-015'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', true, 'Continuity requires the left-hand limit 2a + 1 to equal f(2) = 4 - a. Solving 2a + 1 = 4 - a gives 3a = 3, so a = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/3', false, 'This solves 2a + 1 = 4 - a as 3a = 5, adding 1 instead of subtracting it. The correct step is 3a = 4 - 1 = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/2', false, 'This sets 2a + 1 = 4 and forgets that the right-hand piece, x^2 - a, also contains a.' from version_ins
union all select gen_random_uuid(), id, 'D', '-5', false, 'This sets up 2a + 1 = a - 4, changing the sign of the right-hand piece. The right-hand value at x = 2 is 4 - a.' from version_ins
;
-- MCQ 016 | topic 1.12 | medium | Where Is a Radical Quotient Continuous?
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-016', 'mcq', 'Where Is a Radical Quotient Continuous?', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the largest set on which f(x) = sqrt(x - 1)/(x - 4) is continuous?', md5('apcalcab-mcq-u1n-016'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[1, infinity)', false, 'This includes x = 4, where the denominator is 0 and f is undefined.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The union of [1, 4) and (4, infinity)', true, 'The square root requires x >= 1, and the denominator is 0 at x = 4. The function is continuous at every point in its domain, and continuity at x = 1 is from the right, so 1 is included.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The union of (-infinity, 4) and (4, infinity)', false, 'The square root is undefined for x < 1, so f is not defined on much of this set.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The union of (1, 4) and (4, infinity)', false, 'The function is continuous on this set, but it is not the largest such set. f is also continuous at x = 1 from the right, because f(1) is defined and equals the right-hand limit.' from version_ins
;
-- MCQ 017 | topic 1.12 | hard | Continuity on a Closed Interval
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-017', 'mcq', 'Continuity on a Closed Interval', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following functions is continuous on the closed interval [0, 5]?', md5('apcalcab-mcq-u1n-017'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = 1/(x - 3)', false, 'The function is undefined at x = 3, which lies in [0, 5].' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = tan(pi x/12)', true, 'The tangent function is undefined only where its argument is pi/2 plus a multiple of pi. Here that happens at x = 6 + 12k for every integer k, and the nearest such x-values are x = 6 and x = -6, both outside [0, 5], so f is continuous on the whole interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = ln(x - 1)', false, 'The logarithm is undefined for x <= 1, so f is not defined on [0, 1].' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = |x - 2|/(x - 2)', false, 'The function is undefined at x = 2, which lies in [0, 5].' from version_ins
;
-- MCQ 018 | topic 1.13 | easy | Filling a Hole Left by a Cube Difference
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-018', 'mcq', 'Filling a Hole Left by a Cube Difference', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (x^3 - 8)/(x - 2) for x != 2, and g(2) = k. For what value of k is g continuous at x = 2?', md5('apcalcab-mcq-u1n-018'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12', true, 'Since x^3 - 8 = (x - 2)(x^2 + 2x + 4), g(x) = x^2 + 2x + 4 for x != 2. The limit as x approaches 2 is 4 + 4 + 4 = 12, and continuity requires k to equal that limit.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This factors x^3 - 8 as (x - 2)(x^2 + 4), dropping the middle term. Expanding (x - 2)(x^2 + 4) gives x^3 - 2x^2 + 4x - 8, not x^3 - 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'Substituting x = 2 gives 0 in the numerator, but the denominator is also 0. The form 0/0 is indeterminate, so the limit must be found by simplifying first.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No such value of k exists.', false, 'The denominator is 0 at x = 2, but the factor x - 2 cancels. The limit exists, so a value of k that matches it does exist.' from version_ins
;
-- MCQ 019 | topic 1.13 | medium | Removing a Discontinuity With a Radical
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-019', 'mcq', 'Removing a Discontinuity With a Radical', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function h is defined by h(x) = (sqrt(x + 9) - 3)/x for x != 0, and h(0) = c. For what value of c is h continuous at x = 0?', md5('apcalcab-mcq-u1n-019'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator sqrt(0 + 9) - 3 equals 0, but the denominator is also 0. The quotient is 0/0, which is indeterminate, so the limit has to be found by simplifying first, for example by rationalizing with the conjugate.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', false, 'This uses 3 instead of 6 for the denominator. After multiplying by the conjugate, the denominator becomes sqrt(x + 9) + 3, which equals 3 + 3 = 6 at x = 0, not 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'This inverts the result. After multiplying by the conjugate, the expression is 1/(sqrt(x + 9) + 3), which approaches 1/6.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/6', true, 'Multiplying the numerator and denominator by the conjugate sqrt(x + 9) + 3 gives x/(x(sqrt(x + 9) + 3)) = 1/(sqrt(x + 9) + 3) for x != 0. As x approaches 0 this approaches 1/(3 + 3) = 1/6.' from version_ins
;
-- MCQ 020 | topic 1.13 | medium | Choosing a Parameter So the Numerator Cancels
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-020', 'mcq', 'Choosing a Parameter So the Numerator Cancels', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be the function defined by f(x) = (x^2 + ax - 10)/(x - 2) for x != 2, and f(2) = 7. For what value of a is f continuous at x = 2?', md5('apcalcab-mcq-u1n-020'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-3', false, 'This makes a sign error in solving 4 + 2a - 10 = 0. Adding 6 to both sides gives 2a = 6, so a = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This assumes the numerator factors as (x - 2)(x + a) and sets 2 + a = 7. But (x - 2)(x + 5) = x^2 + 3x - 10, so the coefficient of x would have to be 3, not 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'For the limit to exist, the numerator must be 0 at x = 2: 4 + 2a - 10 = 0, so a = 3. Then x^2 + 3x - 10 = (x - 2)(x + 5), and the limit is 2 + 5 = 7, which matches f(2).' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This confuses the required limit value with the parameter. The number 7 is the value f(2) that the limit must match, not the value of a.' from version_ins
;
-- MCQ 021 | topic 1.13 | hard | Removable Versus Infinite Discontinuities in One Function
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-021', 'mcq', 'Removable Versus Infinite Discontinuities in One Function', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x^2 - 9)/(x^2 - 5x + 6). Which of the following describes the discontinuities of f?', md5('apcalcab-mcq-u1n-021'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Removable at x = 3 and infinite at x = 2', true, 'Factoring gives f(x) = (x - 3)(x + 3)/((x - 2)(x - 3)). The factor x - 3 cancels, so the limit at x = 3 is 6 and the discontinuity there is removable. The factor x - 2 remains in the denominator while the numerator is -5 at x = 2, so f is unbounded near 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Removable at both x = 2 and x = 3', false, 'At x = 2 the numerator is 4 - 9 = -5, not 0, so nothing cancels and f is unbounded near 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Removable at x = 2 and infinite at x = 3', false, 'This reverses the roles. It is at x = 3 that a common factor cancels, and at x = 2 that the denominator stays zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Infinite at both x = 2 and x = 3', false, 'Both are zeros of the denominator, but at x = 3 the factor x - 3 also appears in the numerator and cancels, so the limit there is finite.' from version_ins
;
-- MCQ 022 | topic 1.14 | easy | One-Sided Infinite Limit From the Right
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-022', 'mcq', 'One-Sided Infinite Limit From the Right', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x->3+) 2x/(x^2 - 9)?', md5('apcalcab-mcq-u1n-022'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'This uses the numerator''s value alone. The denominator approaches 0, so the quotient is unbounded.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The denominator approaches 0 while the numerator approaches 6. A small denominator makes the quotient large, not small.' from version_ins
union all select gen_random_uuid(), id, 'C', 'infinity', true, 'As x approaches 3 from the right, the numerator approaches 6, which is positive. The denominator (x - 3)(x + 3) is a small positive number times a number near 6, so it is small and positive. A positive number divided by a small positive number grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'D', '-infinity', false, 'This uses the wrong sign. For x slightly greater than 3, x - 3 is positive, so the denominator is positive.' from version_ins
;
-- MCQ 023 | topic 1.14 | medium | Holes Versus Vertical Asymptotes
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-023', 'mcq', 'Holes Versus Vertical Asymptotes', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x^2 - 4x)/(x^2 - 16). Which of the following gives all vertical asymptotes of the graph of f?', md5('apcalcab-mcq-u1n-023'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = -4 only', true, 'Factoring gives f(x) = x(x - 4)/((x - 4)(x + 4)). The factor x - 4 cancels, leaving a hole at x = 4. At x = -4 the denominator of the simplified expression x/(x + 4) is 0 while the numerator is -4, which is nonzero, so there is a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 4 only', false, 'At x = 4 the factor cancels, leaving a hole. The asymptote is at x = -4, where the zero of the denominator remains after simplifying.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 4 and x = -4', false, 'Both are zeros of the denominator, but at x = 4 the factor x - 4 cancels with the numerator, leaving a hole rather than an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0 and x = -4', false, 'x = 0 is a zero of the numerator, so f(0) = 0. It is not a zero of the denominator, so there is no asymptote there.' from version_ins
;
-- MCQ 024 | topic 1.14 | medium | An Infinite Limit With a Squared Denominator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1n-024', 'mcq', 'An Infinite Limit With a Squared Denominator', 'draft' from u1n_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x->-2-) (x + 5)/(x + 2)^2?', md5('apcalcab-mcq-u1n-024'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator approaches 3, a nonzero number. When the numerator approaches a nonzero number, a denominator approaching 0 makes the quotient large in magnitude, not small.' from version_ins
union all select gen_random_uuid(), id, 'B', 'infinity', true, 'The numerator approaches 3, which is positive. The denominator (x + 2)^2 is positive for every x != -2 and approaches 0, so the quotient is positive and unbounded.' from version_ins
union all select gen_random_uuid(), id, 'C', '-infinity', false, 'It is tempting to say x + 2 is negative when x < -2. But the factor is squared, so the denominator is positive on both sides of -2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist because the one-sided limits are different.', false, 'The one-sided limits are equal here: (x + 2)^2 is positive on both sides of -2, so the quotient grows without bound in the same direction from both sides.' from version_ins
;

commit;
