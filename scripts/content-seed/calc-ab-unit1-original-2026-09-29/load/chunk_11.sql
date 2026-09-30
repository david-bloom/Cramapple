begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array['apcalcab-mcq-u1v-026-v3','apcalcab-mcq-u1v-027-v1','apcalcab-mcq-u1v-027-v2','apcalcab-mcq-u1v-027-v3','apcalcab-mcq-u1v-028-v1','apcalcab-mcq-u1v-028-v2','apcalcab-mcq-u1v-028-v3','apcalcab-mcq-u1v-029-v1','apcalcab-mcq-u1v-029-v2','apcalcab-mcq-u1v-029-v3'])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
-- MCQ variant 026-v3 of 026 | easy | Limit at Infinity When the Numerator Has Greater Degree
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-026-v3', 'mcq', 'Limit at Infinity When the Numerator Has Greater Degree', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An athlete''s energy output is modeled by E(x) = 4x^3 - x and the recovery required is modeled by D(x) = 5x^2 + 9, where x is the training load. What is lim(x->infinity) E(x)/D(x)?', md5('apcalcab-mcq-u1v-026-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'infinity', true, 'The numerator has degree 3 and the denominator has degree 2. Dividing each term by x^2 gives (4x - 1/x)/(5 + 9/x^2). The numerator grows without bound while the denominator approaches 5, so the quotient grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'A limit of 0 would require the denominator''s degree to exceed the numerator''s. Here the numerator has the greater degree.' from version_ins
union all select gen_random_uuid(), id, 'C', '5/4', false, 'This inverts the leading coefficients and also applies the equal-degree rule. The degrees are different, so the limit is not a ratio of coefficients.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/5', false, 'This applies the equal-degree rule and compares leading coefficients. That rule only applies when both degrees are the same; here the degrees are 3 and 2.' from version_ins
;
-- MCQ variant 027-v1 of 027 | hard | Steady Output of a Signal-Conditioning Circuit
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-027-v1', 'mcq', 'Steady Output of a Signal-Conditioning Circuit', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The output voltage of a signal-conditioning circuit is modeled by V(s) = (8s - 5)/sqrt(4s^2 + 7), where s is any real input setting. Which of the following gives all horizontal asymptotes of the graph of V?', md5('apcalcab-mcq-u1v-027-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'V = 4 only', false, 'This considers only s approaching positive infinity. As s approaches negative infinity, the radical is positive while 8s - 5 is negative, giving the limit -4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V = 0 only', false, 'The numerator is first degree in s, and the radical behaves like 2|s|, also first degree. Equal growth rates give a nonzero limit, not 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V = 4 and V = -4', true, 'For large positive s, sqrt(4s^2 + 7) behaves like 2s, so V approaches 8s/(2s) = 4. For large negative s, the radical behaves like 2|s| = -2s, so V approaches 8s/(-2s) = -4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'V = 8 and V = -8', false, 'This treats sqrt(4s^2 + 7) as behaving like |s|. It behaves like 2|s|, because sqrt(4s^2) = 2|s|, so the limits are 4 and -4.' from version_ins
;
-- MCQ variant 027-v2 of 027 | hard | Two Horizontal Asymptotes of an Exponential Ratio
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-027-v2', 'mcq', 'Two Horizontal Asymptotes of an Exponential Ratio', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme''s activity level is modeled by f(x) = (3e^x + 1)/(e^x + 2), where x is a concentration setting that can take any real value. Which of the following gives all horizontal asymptotes of the graph of f?', md5('apcalcab-mcq-u1v-027-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 3 only', false, 'This considers only x approaching positive infinity. As x approaches negative infinity, e^x approaches 0 and f approaches 1/2, giving a second horizontal asymptote.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 3 and y = 1/2', true, 'As x approaches infinity, e^x dominates and f approaches 3e^x/e^x = 3. As x approaches negative infinity, e^x approaches 0, so the numerator approaches 1 and the denominator approaches 2, giving the limit 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 1/2 only', false, 'This considers only x approaching negative infinity. As x approaches positive infinity, e^x dominates and f approaches 3, giving a second horizontal asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 3 and y = 0', false, 'This treats e^x approaching 0 as making the whole expression approach 0. But the constants 1 and 2 remain, so f approaches 1/2 as x approaches negative infinity.' from version_ins
;
-- MCQ variant 027-v3 of 027 | hard | Radical in a Denominator With Unequal Sides
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-027-v3', 'mcq', 'Radical in a Denominator With Unequal Sides', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gain function is modeled by f(x) = 6x/(x + 2sqrt(x^2 + 1)). The denominator is positive for every real x. Which of the following gives all horizontal asymptotes of the graph of f?', md5('apcalcab-mcq-u1v-027-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 2 and y = -2', false, 'This assumes the two asymptotes are opposites. For negative x the radical contributes -2x to the denominator, which changes its size as well as its sign, giving -6, not -2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 2 and y = -6', true, 'For large positive x, sqrt(x^2 + 1) behaves like x, so f behaves like 6x/(x + 2x) = 2. For large negative x, sqrt(x^2 + 1) behaves like |x| = -x, so the denominator behaves like x - 2x = -x and f behaves like 6x/(-x) = -6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 2 and y = 6', false, 'This replaces sqrt(x^2) with -x for negative x but then loses a sign when simplifying 6x/(-x). That quotient is -6, not 6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 2 only', false, 'This considers only x approaching positive infinity, or treats sqrt(x^2) as x for negative x as well. For negative x the denominator behaves like -x, giving the limit -6.' from version_ins
;
-- MCQ variant 028-v1 of 028 | medium | Interpreting a Long-Run Capacitor Voltage
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-028-v1', 'mcq', 'Interpreting a Long-Run Capacitor Voltage', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The voltage across a charging capacitor is modeled by V(t) = 12 - 9e^(-t/5) volts, where t >= 0 is the time in seconds. What is lim(t->infinity) V(t), and what does it mean in this context?', md5('apcalcab-mcq-u1v-028-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0; the voltage eventually falls to 0 volts.', false, 'The exponential term approaches 0, but the constant 12 remains, so V(t) approaches 12, not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '3; the voltage levels off near 3 volts.', false, 'The value 3 is V(0) = 12 - 9, the starting voltage. The question is about what happens as t grows large, not at t = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '-infinity; the voltage decreases without bound.', false, 'The minus sign in front of 9e^(-t/5) does not make the term grow. The exponent -t/5 is negative, so e^(-t/5) decays toward 0 and V(t) approaches 12 for large t.' from version_ins
union all select gen_random_uuid(), id, 'D', '12; the voltage levels off near 12 volts.', true, 'As t increases, e^(-t/5) approaches 0, so V(t) approaches 12 - 9(0) = 12. The model predicts the voltage settles near 12 volts.' from version_ins
;
-- MCQ variant 028-v2 of 028 | medium | Interpreting a Long-Run Visitor Rate
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-028-v2', 'mcq', 'Interpreting a Long-Run Visitor Rate', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'After a website launches, its visitor rate is modeled by R(t) = 400t/(t + 5) visitors per hour, where t >= 0 is the time in hours since launch. What is lim(t->infinity) R(t), and what does it mean in this context?', md5('apcalcab-mcq-u1v-028-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0; the visitor rate falls to 0 visitors per hour.', false, 'This assumes a growing denominator forces the quotient to 0, but the numerator grows at the same rate. Both have degree 1, so the limit is the ratio of leading coefficients.' from version_ins
union all select gen_random_uuid(), id, 'B', 'infinity; the visitor rate grows without bound.', false, 'This assumes the growing numerator makes the quotient grow, but the denominator grows at the same rate, so the rate levels off.' from version_ins
union all select gen_random_uuid(), id, 'C', '400; the visitor rate levels off near 400 visitors per hour.', true, 'Dividing the numerator and denominator by t gives 400/(1 + 5/t), which approaches 400 as t grows. The model predicts the rate settles near 400 visitors per hour.' from version_ins
union all select gen_random_uuid(), id, 'D', '80; the visitor rate levels off near 80 visitors per hour.', false, 'This divides the leading coefficient 400 by the constant term 5 in the denominator (t + 5), as if the denominator were just its constant. For large t the 5 is negligible next to t, and the limit is 400/1 = 400.' from version_ins
;
-- MCQ variant 028-v3 of 028 | medium | Long-Run Speed of a Probe
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-028-v3', 'mcq', 'Long-Run Speed of a Probe', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The average speed of a research probe t hours after launch is modeled by s(t) = 30t/sqrt(t^2 + 9) kilometers per hour, where t >= 0. What is lim(t->infinity) s(t), and what does it mean in this context?', md5('apcalcab-mcq-u1v-028-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'infinity; the probe''s speed grows without bound.', false, 'The numerator grows like t, but the denominator also grows like t, so the ratio does not grow without bound. It approaches a finite limit.' from version_ins
union all select gen_random_uuid(), id, 'B', '10; the probe''s speed levels off near 10 kilometers per hour.', false, 'This treats sqrt(t^2 + 9) as if it were 3t, giving 30t/(3t) = 10. But for large t, sqrt(t^2 + 9) behaves like t, not 3t, so the limit is 30.' from version_ins
union all select gen_random_uuid(), id, 'C', '30; the probe''s speed levels off near 30 kilometers per hour.', true, 'For large t, sqrt(t^2 + 9) behaves like t, so s(t) behaves like 30t/t = 30. Dividing the numerator and denominator by t gives 30/sqrt(1 + 9/t^2), which approaches 30. The model predicts the speed settles near 30 kilometers per hour.' from version_ins
union all select gen_random_uuid(), id, 'D', '0; the probe eventually comes to a stop.', false, 'The value 0 is s(0), the speed at launch. The question is about what happens as t grows large, and s(t) increases toward 30, not toward 0.' from version_ins
;
-- MCQ variant 029-v1 of 029 | hard | Comparing Two Running Times With Different Exponential Bases
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-029-v1', 'mcq', 'Comparing Two Running Times With Different Exponential Bases', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two data-processing methods have running times A(x) = 5^x + x^4 and B(x) = 3^x + x^7 milliseconds for a job of size x, where x can be any real number with x >= 1. What is lim(x->infinity) A(x)/B(x)?', md5('apcalcab-mcq-u1v-029-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5/3', false, 'This treats the bases as if they were coefficients and takes 5/3 as the limit. The ratio behaves like (5/3)^x, and since 5/3 > 1 that expression grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This assumes that because both expressions are a sum of an exponential and a polynomial, their sizes are comparable. The base 5 exponential grows much faster than the base 3 exponential.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This compares only the polynomial parts, x^4 and x^7, and concludes the denominator is larger. Any exponential a^x with a > 1 eventually outgrows every polynomial, so the polynomials do not decide the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'infinity', true, 'The exponential 5^x outgrows the polynomial x^4, so the numerator behaves like 5^x. The exponential 3^x outgrows x^7, so the denominator behaves like 3^x. The ratio behaves like (5/3)^x, which grows without bound.' from version_ins
;
-- MCQ variant 029-v2 of 029 | hard | Same Exponential Base With Polynomial Terms
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-029-v2', 'mcq', 'Same Exponential Base With Polynomial Terms', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The daily views of two videos are modeled by V1(x) = 9 * 2^x + x^12 and V2(x) = 6 * 2^x + x^5, where x is the day number. What is lim(x->infinity) V1(x)/V2(x)?', md5('apcalcab-mcq-u1v-029-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This assumes the two expressions grow at the same rate, so their ratio is 1. Growing at the same rate means the ratio approaches the ratio of the leading coefficients, 9/6, which is not 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/2', true, 'The exponential 2^x grows faster than every power of x, so x^12 is negligible next to 9 * 2^x and x^5 is negligible next to 6 * 2^x. Dividing the numerator and denominator by 2^x gives (9 + x^12/2^x)/(6 + x^5/2^x), which approaches 9/6 = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'infinity', false, 'This compares the polynomials and concludes that x^12 outgrows x^5. But 2^x grows faster than both, so the polynomial terms do not matter in the limit.' from version_ins
union all select gen_random_uuid(), id, 'D', '12/5', false, 'This treats the exponents 12 and 5 as if they were leading coefficients. The polynomial terms are negligible, and the leading terms 9 * 2^x and 6 * 2^x give 9/6.' from version_ins
;
-- MCQ variant 029-v3 of 029 | hard | Polynomial Revenue Against an Exponential Cost
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apcalcab-mcq-u1v-029-v3', 'mcq', 'Polynomial Revenue Against an Exponential Cost', 'draft' from u1v_epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company''s revenue is modeled by R(x) = 3x^8 + 4x^2 and its cost by C(x) = 5(2^x) - x^3, where x is the number of years. What is lim(x->infinity) R(x)/C(x)?', md5('apcalcab-mcq-u1v-029-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', true, 'The exponential 2^x grows faster than any power of x, so 5(2^x) - x^3 behaves like 5(2^x) for large x, and the numerator behaves like 3x^8. Since x^8/2^x approaches 0, the quotient approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '-infinity', false, 'This assumes the subtraction makes the denominator negative. For large x, 2^x is much larger than x^3, so the denominator is positive and grows.' from version_ins
union all select gen_random_uuid(), id, 'C', '-3', false, 'This compares the coefficients of the top-degree polynomial terms, 3x^8 in R and -x^3 in C, and forms 3/(-1) as if both were polynomials of equal degree. But the degrees differ, and C is dominated by 5(2^x), not by -x^3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'infinity', false, 'This assumes the numerator''s higher power, x^8, wins by comparing only polynomial degrees. But 2^x eventually outgrows any polynomial, so the denominator wins and the quotient approaches 0.' from version_ins
;

commit;
