begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-011-v3','apcalcab-mcq-u1v-012-v1','apcalcab-mcq-u1v-012-v2','apcalcab-mcq-u1v-012-v3','apcalcab-mcq-u1v-013-v1','apcalcab-mcq-u1v-013-v2','apcalcab-mcq-u1v-013-v3','apcalcab-mcq-u1v-014-v1','apcalcab-mcq-u1v-014-v2','apcalcab-mcq-u1v-014-v3','apcalcab-mcq-u1v-015-v1'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 011-v3 of 011 | medium | Sensor Gain With a Stored Calibration Value
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-011-v3', 'mcq', 'Sensor Gain With a Stored Calibration Value', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor''s gain is modeled by g(x) = (sqrt(x + 7) - 3)/(x - 2) for x != 2, and the stored calibration value is g(2) = 1/6. Consider the following statements.

I. lim(x->2) g(x) exists.
II. g is continuous at x = 2.
III. g has a removable discontinuity at x = 2.

Which of the statements are true?', md5('apcalcab-mcq-u1v-011-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I only', false, 'Statement I is true, but the limit 1/6 equals g(2) = 1/6, so all three conditions for continuity hold and II is also true.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I and III only', false, 'A removable discontinuity needs the limit to differ from the function value or the value to be missing. Here g(2) = 1/6 equals the limit, so g is continuous, not discontinuous.' from version_ins
union all select gen_random_uuid(), id, 'C', 'I and II only', true, 'Multiplying by the conjugate gives g(x) = 1/(sqrt(x + 7) + 3) for x != 2, so the limit at 2 is 1/(3 + 3) = 1/6 (I). Since g(2) = 1/6 equals this limit, g is continuous at 2 (II), and therefore there is no discontinuity to remove (III is false).' from version_ins
union all select gen_random_uuid(), id, 'D', 'II and III only', false, 'A function cannot be both continuous and discontinuous at the same point. In fact g is continuous at 2, so III is false.' from version_ins
;
-- MCQ variant 012-v1 of 012 | medium | Signed Correction From a Motor Controller
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-012-v1', 'mcq', 'Signed Correction From a Motor Controller', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A motor controller outputs the signed correction c(x) = (x^2 - 4x)/|x - 4| for x != 4, where x is the commanded position in centimeters. Which of the following is true about lim(x->4) c(x)?', md5('apcalcab-mcq-u1v-012-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is 0.', false, 'Substituting x = 4 makes the numerator 0, but the denominator |x - 4| is also 0, so the value is undefined, not 0. Near 4 the outputs are close to -4 on the left and close to 4 on the right.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is 4.', false, 'This is the right-hand limit only. From the left, c(x) = -x approaches -4, so the two-sided limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist because the one-sided limits are -4 and 4.', true, 'Since x^2 - 4x = x(x - 4), for x > 4 we have |x - 4| = x - 4, so c(x) = x, which approaches 4. For x < 4, |x - 4| = -(x - 4), so c(x) = -x, which approaches -4. The one-sided limits differ, so the two-sided limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is -4.', false, 'This is the left-hand limit only. From the right, c(x) = x approaches 4, so the two-sided limit does not exist.' from version_ins
;
-- MCQ variant 012-v2 of 012 | medium | Polarity Flag in a Circuit Model
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-012-v2', 'mcq', 'Polarity Flag in a Circuit Model', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a circuit model, a polarity readout is p(v) = |2v + 6|/(v + 3) for v != -3, where v is a voltage in volts. Which of the following is true about lim(v->-3) p(v)?', md5('apcalcab-mcq-u1v-012-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is 2.', false, 'This is the right-hand limit only. For v < -3 the absolute value flips the sign and p(v) = -2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is -2.', false, 'This is the left-hand limit only. For v > -3, |2v + 6| = 2v + 6 and p(v) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist because p is unbounded near v = -3.', false, 'The denominator does approach 0, but so does the numerator, and the ratio stays at the finite values -2 and 2. The limit fails to exist because the one-sided limits differ, not because p is unbounded.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist because the one-sided limits are -2 and 2.', true, 'Since |2v + 6| = 2|v + 3|, p(v) = 2|v + 3|/(v + 3). For v > -3 this is 2, and for v < -3 it is -2. The one-sided limits are 2 and -2, which differ, so the two-sided limit does not exist.' from version_ins
;
-- MCQ variant 012-v3 of 012 | medium | Profit Swing Around a Break-Even Output
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-012-v3', 'mcq', 'Profit Swing Around a Break-Even Output', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A firm''s profit swing at output level q (in thousands of units) is modeled by s(q) = |q^2 - 25|/(q - 5) for q != 5. Which of the following is true about lim(q->5) s(q)?', md5('apcalcab-mcq-u1v-012-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is -10.', false, 'This is the left-hand limit only. For q slightly above 5, q^2 - 25 is positive and s(q) = q + 5 approaches 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist because the one-sided limits are -10 and 10.', true, 'Write q^2 - 25 = (q - 5)(q + 5). Near q = 5, for q > 5 the expression q^2 - 25 is positive, so s(q) = q + 5, which approaches 10. For q < 5 (with q > -5) it is negative, so s(q) = -(q + 5), which approaches -10. The one-sided limits differ.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 10.', false, 'This is the right-hand limit only. For q slightly below 5, q^2 - 25 is negative, the absolute value reverses its sign, and s(q) approaches -10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 0.', false, 'Substituting q = 5 makes the numerator 0, but the denominator is also 0, so no value is defined there. The 0/0 form must be resolved by cases, and it gives -10 from the left and 10 from the right.' from version_ins
;
-- MCQ variant 013-v1 of 013 | easy | Identifying a Jump in a Taxi Fare
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-013-v1', 'mcq', 'Identifying a Jump in a Taxi Fare', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A taxi fare F(d), in dollars for a ride of d miles, is defined by

F(d) = 3d + 2 for d < 4
F(d) = 5d - 1 for d >= 4

Which of the following describes F at d = 4?', md5('apcalcab-mcq-u1v-013-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'F has an infinite discontinuity at d = 4.', false, 'An infinite discontinuity involves unbounded behavior. Both one-sided limits here are finite numbers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'F has a jump discontinuity at d = 4.', true, 'From below, the fare approaches 3(4) + 2 = 14. From above (and at d = 4), it is 5(4) - 1 = 19. Both one-sided limits exist but are unequal, which is a jump discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'F has a removable discontinuity at d = 4.', false, 'A removable discontinuity requires equal one-sided limits. Here they are 14 and 19.' from version_ins
union all select gen_random_uuid(), id, 'D', 'F is continuous at d = 4.', false, 'F(4) = 19 matches the right-hand piece, but continuity also needs the left-hand limit 14 to equal it. The limit does not exist.' from version_ins
;
-- MCQ variant 013-v2 of 013 | easy | Classifying a Gap in a Growth Model
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-013-v2', 'mcq', 'Classifying a Gap in a Growth Model', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A colony-size model is defined by

P(x) = (3x^2 - 12x)/(x - 4) for x != 4
P(4) = 5

Which of the following describes P at x = 4?', md5('apcalcab-mcq-u1v-013-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P is continuous at x = 4.', false, 'P(4) is defined, but P(4) = 5 while the limit is 12. Continuity requires the value and the limit to be equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P has a jump discontinuity at x = 4.', false, 'A jump discontinuity needs unequal one-sided limits. Both one-sided limits are 12, because P(x) = 3x on both sides of 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P has a removable discontinuity at x = 4.', true, 'Since 3x^2 - 12x = 3x(x - 4), P(x) = 3x for x != 4, so the limit at 4 is 12. P(4) = 5 does not equal 12, but the limit exists, which is a removable discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P has an infinite discontinuity at x = 4.', false, 'The denominator is 0 at x = 4, but the factor x - 4 cancels with the numerator, so the values stay near 12 and are not unbounded.' from version_ins
;
-- MCQ variant 013-v3 of 013 | easy | Doubling Then Linear Decline in a Culture
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-013-v3', 'mcq', 'Doubling Then Linear Decline in a Culture', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The population index of a culture is defined by

B(t) = 2^t for t < 3
B(t) = 12 - t for t >= 3

Which of the following describes B at t = 3?', md5('apcalcab-mcq-u1v-013-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'B is continuous at t = 3.', false, 'B(3) = 9 equals the right-hand limit, but the left-hand limit is 8. Continuity requires the limit from both sides to equal B(3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'B has a jump discontinuity at t = 3.', true, 'From the left, B approaches 2^3 = 8. From the right, B approaches 12 - 3 = 9. Both one-sided limits exist but are unequal, so the limit does not exist and the discontinuity is a jump.' from version_ins
union all select gen_random_uuid(), id, 'C', 'B has a removable discontinuity at t = 3.', false, 'A removable discontinuity requires the one-sided limits to be equal. Here they are 8 and 9, which are close but not equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'B has an infinite discontinuity at t = 3.', false, 'An infinite discontinuity involves unbounded behavior. Both one-sided limits here are finite numbers.' from version_ins
;
-- MCQ variant 014-v1 of 014 | medium | Which Model Blows Up at t = 4?
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-014-v1', 'mcq', 'Which Model Blows Up at t = 4?', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four models of a quantity Q(t) are shown, where t is time in seconds. Which of them has an infinite discontinuity at t = 4?', md5('apcalcab-mcq-u1v-014-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q(t) = 2 for t < 4 and Q(t) = 7 for t >= 4', false, 'Both one-sided limits (2 and 7) are finite and unequal. This is a jump discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q(t) = (t^2 + 1)/(16 - t^2)', true, 'At t = 4 the denominator is 16 - 16 = 0 while the numerator is 17, which is nonzero. Q is unbounded near t = 4, so there is an infinite discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q(t) = (t - 4)^2/(t + 4)', false, 'This function is continuous at t = 4, where it equals 0. Its trouble spot is t = -4, not t = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q(t) = (t^2 - 3t - 4)/(t - 4)', false, 'Factoring gives (t - 4)(t + 1)/(t - 4), which equals t + 1 for t != 4. The limit at 4 is 5, so this is a removable discontinuity.' from version_ins
;
-- MCQ variant 014-v2 of 014 | medium | Which Intensity Formula Becomes Unbounded at d = 2?
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-014-v2', 'mcq', 'Which Intensity Formula Becomes Unbounded at d = 2?', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An acoustics student proposes four formulas for the intensity I(d) of a sound source at distance d meters. Which formula becomes unbounded, that is, has an infinite discontinuity, at d = 2?', md5('apcalcab-mcq-u1v-014-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I(d) = 3/(e^(d - 2) - 1)', true, 'At d = 2 the denominator is e^0 - 1 = 0 while the numerator is 3, which is nonzero. The values grow without bound in size near d = 2 (negative from the left, positive from the right), so the discontinuity is infinite.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I(d) = (d^3 - 8)/(d - 2)', false, 'Factoring d^3 - 8 = (d - 2)(d^2 + 2d + 4) shows the factor d - 2 cancels, so I equals d^2 + 2d + 4 for d != 2. The limit at 2 is 12, a finite number, so this is removable.' from version_ins
union all select gen_random_uuid(), id, 'C', 'I(d) = 4 for d < 2 and I(d) = 9 - d for d >= 2', false, 'The left-hand limit is 4 and the right-hand limit is 9 - 2 = 7. Both are finite but unequal, so this is a jump discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'I(d) = (d - 2)/(d^2 + 1)', false, 'The denominator d^2 + 1 is never 0, so I is continuous everywhere. At d = 2 the zero numerator only makes I(2) = 0; it does not make I unbounded.' from version_ins
;
-- MCQ variant 014-v3 of 014 | medium | Unbounded Plant Density Along a River Bank
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-014-v3', 'mcq', 'Unbounded Plant Density Along a River Bank', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A biologist tests four formulas for the density D(s) of a plant species at position s kilometers along a river bank. Which formula has an infinite discontinuity at s = -1?', md5('apcalcab-mcq-u1v-014-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'D(s) = sqrt(s^2 + 3)/(s + 4)', false, 'At s = -1 this equals 2/3, and the function is continuous there. Its only trouble spot is s = -4, where the denominator is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'D(s) = (s^2 - 1)/(s + 1)', false, 'Factoring gives (s - 1)(s + 1)/(s + 1), which equals s - 1 for s != -1. The limit at -1 is -2, a finite number, so this is a removable discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'D(s) = (|s + 1| + s + 1)/(s + 1)', false, 'For s < -1 this equals 0 and for s > -1 it equals 2. The one-sided limits are 0 and 2, both finite but unequal, so this is a jump discontinuity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'D(s) = 6/|s + 1|', true, 'At s = -1 the denominator |s + 1| is 0 while the numerator is 6, which is nonzero. The values grow without bound on both sides of -1, so there is an infinite discontinuity.' from version_ins
;
-- MCQ variant 015-v1 of 015 | medium | Tiered Energy Charge Continuous at 3 Units
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-015-v1', 'mcq', 'Tiered Energy Charge Continuous at 3 Units', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A utility''s charge C(x), in dollars for x units of energy, is defined by

C(x) = ax - 5 for x < 3
C(x) = x^2 - 2a for x >= 3

For what value of a is the charge C continuous at x = 3?', md5('apcalcab-mcq-u1v-015-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '14', false, 'This combines 3a and -2a on opposite sides as 3a - 2a = 14 instead of adding 2a to both sides to get 3a + 2a = 14.' from version_ins
union all select gen_random_uuid(), id, 'B', '14/5', true, 'Continuity requires the left-hand limit 3a - 5 to equal C(3) = 9 - 2a. Solving 3a - 5 = 9 - 2a gives 5a = 14, so a = 14/5.' from version_ins
union all select gen_random_uuid(), id, 'C', '4/5', false, 'This solves 3a + 5 = 9 - 2a, treating the -5 as +5. The left-hand value at x = 3 is 3a - 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '14/3', false, 'This sets 3a - 5 = 9 and forgets that the right-hand piece, x^2 - 2a, also contains a.' from version_ins
;

commit;
