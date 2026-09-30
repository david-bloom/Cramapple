begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-019-v2','apcalcab-mcq-u1v-019-v3','apcalcab-mcq-u1v-020-v1','apcalcab-mcq-u1v-020-v2','apcalcab-mcq-u1v-020-v3','apcalcab-mcq-u1v-021-v1','apcalcab-mcq-u1v-021-v2','apcalcab-mcq-u1v-021-v3','apcalcab-mcq-u1v-022-v1','apcalcab-mcq-u1v-022-v2','apcalcab-mcq-u1v-022-v3'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 019-v2 of 019 | medium | Rationalizing a Reaction-Rate Model With a Reversed Difference
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-019-v2', 'mcq', 'Rationalizing a Reaction-Rate Model With a Reversed Difference', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chemist models the rate of a reaction by k(x) = (5 - sqrt(25 - 3x))/x for x < 25/3, x != 0, and k(0) = m. For what value of m is k continuous at x = 0?', md5('apcalcab-mcq-u1v-019-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3/10', true, 'Multiplying by the conjugate 5 + sqrt(25 - 3x) gives (25 - (25 - 3x))/(x(5 + sqrt(25 - 3x))) = 3x/(x(5 + sqrt(25 - 3x))) = 3/(5 + sqrt(25 - 3x)) for x != 0. As x approaches 0 this approaches 3/(5 + 5) = 3/10.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/5', false, 'This treats the conjugate sum as 5 instead of 10. At x = 0 the factor 5 + sqrt(25 - 3x) equals 5 + 5 = 10, so the limit is 3/10.' from version_ins
union all select gen_random_uuid(), id, 'C', '10/3', false, 'This inverts the result. After rationalizing, the expression is 3/(5 + sqrt(25 - 3x)), which approaches 3/10, not 10/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The numerator 5 - sqrt(25) equals 0, but the denominator is also 0. The quotient is 0/0, which is indeterminate, so the limit has to be found by simplifying first, for example by rationalizing, and it should not be assumed to be 0.' from version_ins
;
-- MCQ variant 019-v3 of 019 | medium | Rationalizing a Difference of Two Radicals
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-019-v3', 'mcq', 'Rationalizing a Difference of Two Radicals', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal ratio is modeled by r(x) = (sqrt(x + 3) - sqrt(5x - 1))/(x - 1) for x > 1/5, x != 1, and r(1) = d. For what value of d is r continuous at x = 1?', md5('apcalcab-mcq-u1v-019-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'At x = 1 the numerator is sqrt(4) - sqrt(4) = 0 and the denominator is also 0. The quotient is 0/0, which is indeterminate, so the limit has to be found by simplifying first, for example by rationalizing with the conjugate.' from version_ins
union all select gen_random_uuid(), id, 'B', '-4', false, 'This cancels x - 1 to get -4 but forgets to divide by the conjugate sum sqrt(x + 3) + sqrt(5x - 1), which equals 4 at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '-1', true, 'Multiplying by the conjugate sqrt(x + 3) + sqrt(5x - 1) gives ((x + 3) - (5x - 1))/((x - 1)(sqrt(x + 3) + sqrt(5x - 1))) = -4(x - 1)/((x - 1)(...)) = -4/(sqrt(x + 3) + sqrt(5x - 1)). As x approaches 1 this approaches -4/(2 + 2) = -1.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This subtracts the radicands in the wrong order, getting (5x - 1) - (x + 3) = 4x - 4 = 4(x - 1) in the numerator. The numerator is (x + 3) - (5x - 1) = -4x + 4 = -4(x - 1).' from version_ins
;
-- MCQ variant 020-v1 of 020 | medium | Choosing a Coefficient So a Wind-Speed Model Has No Gap
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-020-v1', 'mcq', 'Choosing a Coefficient So a Wind-Speed Model Has No Gap', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A wind-speed model is defined by w(x) = (x^2 + ax + 6)/(x - 1) for x != 1, and w(1) = -5. For what value of a is w continuous at x = 1?', md5('apcalcab-mcq-u1v-020-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-6', false, 'This assumes the numerator factors as (x - 1)(x + a) and sets 1 + a = -5. But (x - 1)(x - 6) = x^2 - 7x + 6, so the coefficient of x is -7, not -6.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This makes a sign error in solving 1 + a + 6 = 0. Subtracting 7 from both sides gives a = -7.' from version_ins
union all select gen_random_uuid(), id, 'C', '-5', false, 'This confuses the required limit value with the parameter. The number -5 is the value w(1) that the limit must match, not the value of a.' from version_ins
union all select gen_random_uuid(), id, 'D', '-7', true, 'For the limit to exist, the numerator must be 0 at x = 1: 1 + a + 6 = 0, so a = -7. Then x^2 - 7x + 6 = (x - 1)(x - 6), and the limit is 1 - 6 = -5, which matches w(1).' from version_ins
;
-- MCQ variant 020-v2 of 020 | medium | Choosing a Constant So a Profit Model Has No Gap
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-020-v2', 'mcq', 'Choosing a Constant So a Profit Model Has No Gap', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The profit per unit, in dollars, when q hundred units are sold is modeled by P(q) = (q^2 - 2q + a)/(q - 5) for q != 5, and P(5) = 8. For what value of a is P continuous at q = 5?', md5('apcalcab-mcq-u1v-020-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This confuses the required limit value with the parameter. The number 8 is the value P(5) that the limit must match, not the value of a.' from version_ins
union all select gen_random_uuid(), id, 'B', '-15', true, 'For the limit to exist, the numerator must be 0 at q = 5: 25 - 10 + a = 0, so a = -15. Then q^2 - 2q - 15 = (q - 5)(q + 3), and the limit is 5 + 3 = 8, which matches P(5).' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This treats a as the constant in the second factor, setting 5 + a = 8. But a is the constant term of the numerator, which equals -5 times 3, that is -15.' from version_ins
union all select gen_random_uuid(), id, 'D', '15', false, 'This makes a sign error in solving 25 - 10 + a = 0. Since 25 - 10 = 15, moving it across gives a = -15, not 15.' from version_ins
;
-- MCQ variant 020-v3 of 020 | medium | Choosing a Linear Coefficient in a Cubic Numerator
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-020-v3', 'mcq', 'Choosing a Linear Coefficient in a Cubic Numerator', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stress model is defined by s(x) = (x^3 + ax - 6)/(x - 2) for x != 2, and s(2) = 11. For what value of a is s continuous at x = 2?', md5('apcalcab-mcq-u1v-020-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-7', false, 'This makes a sign error on the constant term, using 8 + 2a + 6 = 0. The numerator''s constant is -6, so the equation is 8 + 2a - 6 = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '-1', true, 'For the limit to exist, the numerator must be 0 at x = 2: 8 + 2a - 6 = 0, so a = -1. Then x^3 - x - 6 = (x - 2)(x^2 + 2x + 3), and the limit is 4 + 4 + 3 = 11, which matches s(2).' from version_ins
union all select gen_random_uuid(), id, 'C', '11', false, 'This confuses the required limit value with the parameter. The number 11 is the value s(2) that the limit must match, not the value of a.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This evaluates 2^3 as 6 (2 times 3), giving 6 + 2a - 6 = 0. The cube 2^3 equals 8.' from version_ins
;
-- MCQ variant 021-v1 of 021 | hard | Classifying Discontinuities of a Gain Ratio
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-021-v1', 'mcq', 'Classifying Discontinuities of a Gain Ratio', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor''s gain ratio is modeled by g(x) = (x^2 - x - 12)/(x^2 + x - 20), where x is the input setting. Which of the following describes the discontinuities of g?', md5('apcalcab-mcq-u1v-021-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Removable at x = 4 and infinite at x = -5', true, 'Factoring gives g(x) = (x - 4)(x + 3)/((x + 5)(x - 4)). The factor x - 4 cancels, so the limit at x = 4 is 7/9 and that discontinuity is removable. The factor x + 5 stays in the denominator while the numerator is 18 at x = -5, so g is unbounded near -5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infinite at both x = -5 and x = 4', false, 'Both are zeros of the denominator, but at x = 4 the factor x - 4 also appears in the numerator and cancels, so the limit there is the finite value 7/9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Removable at x = -5 and infinite at x = 4', false, 'This reverses the roles. The common factor x - 4 cancels at x = 4, making that point removable, while x + 5 remains in the denominator at x = -5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Removable at both x = -5 and x = 4', false, 'At x = -5 the numerator is 25 + 5 - 12 = 18, not 0, so no factor cancels and g is unbounded near -5. Only x = 4 is removable.' from version_ins
;
-- MCQ variant 021-v2 of 021 | hard | Three Zeros of a Denominator in a Flow Model
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-021-v2', 'mcq', 'Three Zeros of a Denominator in a Flow Model', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The ratio of outflow to inflow in a pipe network is modeled by r(x) = (x^2 - 1)/(x^3 - 3x^2 + 2x), where x is the valve setting. Which of the following describes the discontinuities of r?', md5('apcalcab-mcq-u1v-021-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Removable at x = -1; infinite at x = 0 and x = 2', false, 'This reads the zero of the numerator, x = -1, as a removable discontinuity. But r(-1) = 0 is defined, so r is continuous there; the removable point is where a factor cancels, x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infinite at x = 0, x = 1 and x = 2', false, 'All three are zeros of the denominator, but at x = 1 the factor x - 1 also appears in the numerator and cancels, so the limit there is finite.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Removable at x = 0 and x = 2; infinite at x = 1', false, 'This reverses the roles. It is at x = 1 that a common factor cancels; the factors x and x - 2 remain in the denominator, so x = 0 and x = 2 are infinite.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Removable at x = 1; infinite at x = 0 and x = 2', true, 'Factoring gives r(x) = (x - 1)(x + 1)/(x(x - 1)(x - 2)). The factor x - 1 cancels, so the discontinuity at x = 1 is removable. After cancelling, r(x) = (x + 1)/(x(x - 2)), so the limit at x = 1 is 2/(1 * (-1)) = -2. The reduced numerator x + 1 equals 1 at x = 0 while the denominator x(x - 2) is 0 there, and at x = 2 the numerator is 3 while the denominator is 0, so x = 0 and x = 2 are vertical asymptotes and r is unbounded near them.' from version_ins
;
-- MCQ variant 021-v3 of 021 | hard | A Repeated Factor Leaves an Infinite Discontinuity
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-021-v3', 'mcq', 'A Repeated Factor Leaves an Infinite Discontinuity', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lens-maker models a magnification ratio by m(x) = (x^2 - 2x)/(x^3 - 4x^2 + 4x), where x is the object distance in a scaled unit. Which of the following describes the discontinuities of m?', md5('apcalcab-mcq-u1v-021-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Removable at both x = 0 and x = 2', false, 'This notices that x - 2 cancels once, but the denominator has (x - 2)^2, so a factor x - 2 remains and m is still unbounded near 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infinite at both x = 0 and x = 2', false, 'Both are zeros of the denominator, but the factor x appears in the numerator and cancels completely, so the limit at x = 0 is the finite value -1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Removable at x = 0 and infinite at x = 2', true, 'Factoring gives m(x) = x(x - 2)/(x(x - 2)^2). The factor x cancels completely, so the limit at x = 0 is -1/2 and that point is removable. After one factor x - 2 cancels, x - 2 is still in the denominator, so m behaves like 1/(x - 2) and is unbounded near 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Removable at x = 2 and infinite at x = 0', false, 'This reverses the roles. The factor x cancels entirely, making x = 0 removable, while (x - 2) is only partly cancelled, leaving an infinite discontinuity at x = 2.' from version_ins
;
-- MCQ variant 022-v1 of 022 | easy | One-Sided Limit of a Strain Ratio From Below
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-022-v1', 'mcq', 'One-Sided Limit of a Strain Ratio From Below', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An engineer models the strain ratio on a support cable by S(t) = (3 - t)/(t^2 - 16), where t is a load parameter that rises toward 4. What is lim(t->4-) (3 - t)/(t^2 - 16)?', md5('apcalcab-mcq-u1v-022-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-infinity', false, 'This notices that the numerator is negative but overlooks that the denominator is also negative for t slightly less than 4, so the quotient is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', '-1/8', false, 'This substitutes t = 4 into the factors that do not vanish, (3 - t)/(t + 4), and ignores the factor t - 4 that approaches 0 in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'infinity', true, 'As t approaches 4 from the left, the numerator approaches -1, which is negative. The denominator (t - 4)(t + 4) is a small negative number times a number near 8, so it is small and negative. A negative number divided by a small negative number is a large positive number, so the quotient grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The denominator approaches 0 while the numerator approaches -1. A small denominator makes the quotient large in magnitude, not small.' from version_ins
;
-- MCQ variant 022-v2 of 022 | easy | One-Sided Limit of a Mixing Ratio
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-022-v2', 'mcq', 'One-Sided Limit of a Mixing Ratio', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a mixing model, the ratio of solute to solvent is Q(p) = (p + 5)/(p^2 + 5p + 6), where p is a pressure setting that decreases toward -3 from above. What is lim(p->-3+) (p + 5)/(p^2 + 5p + 6)?', md5('apcalcab-mcq-u1v-022-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '-infinity', true, 'Factor the denominator as (p + 2)(p + 3). As p approaches -3 from the right, p + 3 is a small positive number and p + 2 is near -1, so the denominator is small and negative. The numerator approaches 2, which is positive, so the quotient is a large negative number.' from version_ins
union all select gen_random_uuid(), id, 'B', '-2', false, 'This cancels or ignores the vanishing factor p + 3 and evaluates (p + 5)/(p + 2) at p = -3. The factor p + 3 is not in the numerator, so nothing cancels.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The denominator approaches 0 while the numerator approaches 2. A small denominator makes the quotient large in magnitude, not small.' from version_ins
union all select gen_random_uuid(), id, 'D', 'infinity', false, 'This treats p + 2 as positive. Near p = -3 it is close to -1, so the denominator is negative even though p + 3 is positive.' from version_ins
;
-- MCQ variant 022-v3 of 022 | easy | One-Sided Limit at a Speed Barrier
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-022-v3', 'mcq', 'One-Sided Limit at a Speed Barrier', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model for the energy needed to move an object gives E(v) = (3 - 2v)/(1 - v^2), where v is the fraction of a wave speed and v < 1. What is lim(v->1-) (3 - 2v)/(1 - v^2)?', md5('apcalcab-mcq-u1v-022-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'infinity', true, 'As v approaches 1 from the left, the numerator approaches 1, which is positive. For v slightly less than 1, v^2 < 1, so 1 - v^2 is a small positive number. A positive number divided by a small positive number grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The denominator approaches 0 while the numerator approaches 1. A small denominator makes the quotient large, not small.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'This factors 1 - v^2 as (1 - v)(1 + v), then ignores the vanishing factor 1 - v and evaluates (3 - 2v)/(1 + v) at v = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '-infinity', false, 'This treats 1 - v^2 as negative. That is true for v > 1, but for v slightly less than 1, v^2 is slightly less than 1 and the denominator is positive.' from version_ins
;

commit;
