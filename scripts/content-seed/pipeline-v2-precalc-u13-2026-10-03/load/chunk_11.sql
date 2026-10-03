begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-np2-001-v2','apprecalc-mcq-sv-np2-001-v3','apprecalc-mcq-sv-np2-002-v1','apprecalc-mcq-sv-np2-002-v2','apprecalc-mcq-sv-np2-002-v3','apprecalc-mcq-sv-np2-005-v1','apprecalc-mcq-sv-np2-005-v2','apprecalc-mcq-sv-np2-005-v3','apprecalc-mcq-sv-np2-006-v1','apprecalc-mcq-sv-np2-006-v2','apprecalc-mcq-sv-np2-006-v3','apprecalc-mcq-sv-np2-007-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-np2-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-001-v2', 'mcq', 'End behavior from factored form', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polynomial p is given by p(x) = −2x²(x − 3)(x + 1)(x + 4). Which statement describes the end behavior of p?', null, md5('apprecalc-mcq-sv-np2-001-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p(x) → +∞ as x → −∞, and p(x) → −∞ as x → +∞', true, 'Multiplying the factors gives degree 2 + 1 + 1 + 1 = 5 and leading coefficient −2, so the leading term is −2x^5. An odd-degree polynomial with a negative leading coefficient rises to +∞ as x → −∞ and falls to −∞ as x → +∞. Check: p(−10) = −2·100·(−13)(−9)(−6) = 140,400 is positive, and p(10) = −2·100·7·11·14 = −215,600 is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'p(x) → −∞ as x → −∞, and p(x) → −∞ as x → +∞', false, 'This counts the four factors, (x²), (x − 3), (x + 1), (x + 4), to get degree 4 (even) and so uses the −2 to send both ends to −∞. The x² factor contributes degree 2, so the degree is 5 and the ends go in opposite directions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'p(x) → −∞ as x → −∞, and p(x) → +∞ as x → +∞', false, 'This has the odd-degree shape of an upward-sloping cubic or quintic, which would be right for a positive leading coefficient. Here the leading coefficient is −2, so the ends are reversed: p is positive for large negative x and negative for large positive x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'p(x) → +∞ as x → −∞, and p(x) → +∞ as x → +∞', false, 'This combines two slips: counting four factors (degree 4, even) and ignoring the −2. With the correct degree 5 and leading coefficient −2, the two ends go to opposite infinities.' from version_ins;
-- apprecalc-mcq-sv-np2-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-001-v3', 'mcq', 'Dominant term is not the largest coefficient', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'As x approaches positive infinity, what is the end behavior of f(x) = 100x^3 − 5x^4 + x^2?', null, md5('apprecalc-mcq-sv-np2-001-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) approaches positive infinity', false, 'This chooses 100x^3 because it has the largest coefficient. Degree, not coefficient size, decides which term dominates. f(10) = 50,100 is still positive, but f(100) = -399,990,000, and the values keep getting more negative as x increases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) approaches 0', false, 'This treats the function like a rational function with growing denominator. f(100) = −399,990,000, and the magnitude keeps growing for larger x, so the values do not approach 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) approaches −5', false, 'This reports the leading coefficient as if it were the limiting value. The leading term -5x^4 becomes arbitrarily large and negative as x increases; f(100) = -399,990,000, not about -5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) approaches negative infinity', true, 'The term of highest degree, −5x^4, dominates for large x, and its coefficient is negative, so f(x) approaches negative infinity. For example, f(100) = 100,000,000 − 500,000,000 + 10,000 = −399,990,000.' from version_ins;
-- apprecalc-mcq-sv-np2-002-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-002-v1', 'mcq', 'Hole with its y-coordinate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = (x² + x − 6)/(x² − 4). Which statement correctly describes the graph of h at x = 2 and at x = −2?', null, md5('apprecalc-mcq-sv-np2-002-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A hole at (2, 1/4) and a vertical asymptote at x = −2', false, 'The location of the hole is right, but its height drops the remaining numerator factor: after canceling, the function is (x + 3)/(x + 2), so the height is (2 + 3)/(2 + 2) = 5/4. Using only 1/(2 + 2) = 1/4 leaves out (x + 3).' from version_ins
union all select gen_random_uuid(), id, 'B', 'A hole at (2, 0) and a vertical asymptote at x = −2', false, 'This uses the numerator x² + x − 6, which equals 0 at x = 2, as the height of the hole. The hole''s height comes from the simplified function (x + 3)/(x + 2): at x = 2 it is 5/4, not 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Vertical asymptotes at both x = 2 and x = −2, and no hole', false, 'This sets the denominator equal to zero without factoring the numerator. The numerator also has the factor (x − 2), which cancels, so x = 2 is a hole, not an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A hole at (2, 5/4) and a vertical asymptote at x = −2', true, 'Factoring gives h(x) = (x + 3)(x − 2)/[(x − 2)(x + 2)]. The factor (x − 2) cancels, so there is a hole at x = 2 whose height is the value of the simplified function (x + 3)/(x + 2) at x = 2, which is 5/4. The factor (x + 2) stays in the denominator while the numerator (x + 3) is 1 at x = −2, so x = −2 is a vertical asymptote.' from version_ins;
-- apprecalc-mcq-sv-np2-002-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-002-v2', 'mcq', 'Two holes and one asymptote', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x − 1)(x + 2)(x − 5) / [(x + 2)(x − 5)(x − 3)]. Which statement is true about the graph of f?', null, md5('apprecalc-mcq-sv-np2-002-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Holes at x = −2 and x = 5, and a vertical asymptote at x = 3', true, 'The factors (x + 2) and (x − 5) appear in both the numerator and denominator and cancel, giving holes at x = −2 and x = 5. After canceling, f(x) = (x − 1)/(x − 3). The factor (x − 3) remains in the denominator, and the numerator is 3 − 1 = 2 ≠ 0 at x = 3, so x = 3 is a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Vertical asymptotes at x = −2, x = 3, and x = 5, and no holes', false, 'This treats every zero of the denominator as an asymptote without canceling the shared factors (x + 2) and (x − 5) with the numerator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Holes at x = −2, x = 3, and x = 5, and no vertical asymptotes', false, 'This treats every zero of the denominator as a hole. Only the factors that cancel give holes; (x − 3) is not in the numerator, so it remains in the simplified denominator (x − 1)/(x − 3) and gives a vertical asymptote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A hole at x = 3, and vertical asymptotes at x = −2 and x = 5', false, 'This reverses the roles. The cancelled factors (x + 2) and (x − 5) produce holes, and the factor (x − 3) that does not cancel produces the vertical asymptote.' from version_ins;
-- apprecalc-mcq-sv-np2-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-002-v3', 'mcq', 'Partial cancellation of a squared factor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let p(x) = (x + 1) / [(x + 1)²(x − 2)]. Which statement correctly describes the graph of p at x = −1 and at x = 2?', null, md5('apprecalc-mcq-sv-np2-002-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A hole at x = 2 and a vertical asymptote at x = −1', false, 'Gets x = -1 right but x = 2 wrong. The factor (x - 2) appears only in the denominator and cancels with nothing, so x = 2 is a vertical asymptote, not a hole.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Vertical asymptotes at both x = −1 and x = 2, and no hole', true, 'For x ≠ −1, canceling one factor of (x + 1) gives p(x) = 1/[(x + 1)(x − 2)]. The simplified denominator is still 0 at x = −1 and at x = 2, and the numerator is 1, so both are vertical asymptotes. There is no hole because a hole requires the factor to cancel completely.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A vertical asymptote at x = 2 only, with no hole or asymptote at x = −1', false, 'This removes the entire (x + 1)² as if it cancelled with the single (x + 1) in the numerator. Only one factor cancels, leaving 1/[(x + 1)(x − 2)], which is undefined with a vertical asymptote at x = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A hole at x = −1 and a vertical asymptote at x = 2', false, 'This assumes that canceling any common factor creates a hole. Only one of the two factors of (x + 1) in the denominator cancels; the remaining (x + 1) keeps the denominator zero at x = −1 in 1/[(x + 1)(x − 2)], so it is an asymptote.' from version_ins;
-- apprecalc-mcq-sv-np2-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-005-v1', 'mcq', 'Hidden quadratic with a rejected root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of e^(2x) − 5e^x − 14 = 0?', null, md5('apprecalc-mcq-sv-np2-005-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = ln 7 and x = ln(−2)', false, 'The natural logarithm of a negative number is not defined, so e^x = −2 gives no real x. This answer keeps u = −2 without rejecting it, although e^x is always positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 7 and x = −2', false, 'These are the values of u = e^x, not of x. Converting back requires e^x = 7, which gives x = ln 7; e^x = −2 has no real solution.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = ln 7 only', true, 'Let u = e^x. Then u² − 5u − 14 = (u − 7)(u + 2) = 0, so u = 7 or u = −2. Since e^x > 0 for all x, u = −2 is rejected, leaving e^x = 7 and x = ln 7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No real solution', false, 'This rejects the whole equation because one root is negative. The root u = 7 is positive, so e^x = 7 is solvable and x = ln 7 satisfies the equation: e^(2 ln 7) − 5·7 − 14 = 49 − 35 − 14 = 0.' from version_ins;
-- apprecalc-mcq-sv-np2-005-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-005-v2', 'mcq', 'Quadratic form in 3^x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of 9^x − 4·3^x + 3 = 0?', null, md5('apprecalc-mcq-sv-np2-005-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 1 and x = 3', false, 'These are the values of u = 3^x. Converting back, 3^x = 1 gives x = 0 and 3^x = 3 gives x = 1, so x = 3 would give 3^3 = 27, which is not a root (9^3 − 4·27 + 3 = 729 − 108 + 3 ≠ 0).' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 1 only', false, 'This keeps only u = 3 and discards u = 1. But u = 1 is a valid root: 3^x = 1 gives x = 0, and 9^0 − 4·3^0 + 3 = 1 − 4 + 3 = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0 and x = 1', true, 'Since 9^x = (3^x)², let u = 3^x. Then u² − 4u + 3 = (u − 1)(u − 3) = 0, so u = 1 or u = 3. Then 3^x = 1 gives x = 0 and 3^x = 3 gives x = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0 and x = ln 3', false, 'This solves 3^x = 3 with the natural log as if the base were e, giving ln 3 ≈ 1.099. Because the base is 3, 3^x = 3 gives x = 1; indeed 3^(ln 3) ≈ 3.34, not 3.' from version_ins;
-- apprecalc-mcq-sv-np2-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-005-v3', 'mcq', 'Equation with e^(−x) term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of e^x + 12e^(−x) = 7?', null, md5('apprecalc-mcq-sv-np2-005-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No real solution', false, 'This comes from multiplying only the left side by e^x, giving e^(2x) + 12 = 7 and e^(2x) = −5. The right side must be multiplied too: 7e^x. The correct equation e^(2x) − 7e^x + 12 = 0 has two positive roots for e^x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = −ln 3 and x = −ln 4', false, 'With u = e^(−x) the equation becomes 1/u + 12u = 7, so 12u² − 7u + 1 = 0 and u = 1/3 or 1/4. Since e^(−x) = u, x = −ln u, giving ln 3 and ln 4; writing x = ln u instead gives ln(1/3) = −ln 3 and ln(1/4) = −ln 4, which are the wrong signs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 3 and x = 4', false, 'These are the values of u = e^x. Converting back requires x = ln u, so the solutions are ln 3 and ln 4; for example e^3 + 12e^(−3) ≈ 20.7, not 7.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = ln 3 and x = ln 4', true, 'Multiplying every term by e^x gives e^(2x) + 12 = 7e^x, so e^(2x) − 7e^x + 12 = 0. With u = e^x: u² − 7u + 12 = (u − 3)(u − 4) = 0, so u = 3 or u = 4, which gives x = ln 3 or x = ln 4.' from version_ins;
-- apprecalc-mcq-sv-np2-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-006-v1', 'mcq', 'Parameter b from cycles per time', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function used to model a pendulum completes 9 full cycles every 6 seconds. What is the value of b in the general form y = a·sin(b(x + c)) + d, where x is in seconds?', null, md5('apprecalc-mcq-sv-np2-006-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/3', false, 'This is the period, 6/9 = 2/3 second, used directly as b. The period and b are related by b = 2π/period, so b = 2π ÷ (2/3) = 3π.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/2', false, 'This is the frequency, 9 cycles ÷ 6 seconds = 3/2 cycles per second, used directly as b. b is the number of radians per unit, so the frequency must be multiplied by 2π: b = 2π·(3/2) = 3π.' from version_ins
union all select gen_random_uuid(), id, 'C', '3π', true, 'One cycle takes 6/9 = 2/3 second, so the period is 2/3. Then b = 2π/period = 2π ÷ (2/3) = 3π.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/3', false, 'This uses the whole 6 seconds as the period: b = 2π/6 = π/3. The 6 seconds contain 9 cycles, so the period is 6/9 = 2/3, and b = 2π ÷ (2/3) = 3π.' from version_ins;
-- apprecalc-mcq-sv-np2-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-006-v2', 'mcq', 'Parameter b from a frequency in Hz', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sound wave with a frequency of 250 Hz (250 cycles per second) is modeled by y = a·sin(b(t + c)) + d, where t is in seconds. What is the value of b?', null, md5('apprecalc-mcq-sv-np2-006-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '250', false, 'This uses the frequency directly as b. Each cycle spans 2π radians of the argument, so b = 2π·250 = 500π, not 250.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/125', false, 'This treats 250 as if it were the period in seconds: b = 2π/250 = π/125. But 250 is the number of cycles per second; the period is 1/250 second, so b = 2π ÷ (1/250) = 500π.' from version_ins
union all select gen_random_uuid(), id, 'C', '500π', true, 'A frequency of 250 cycles per second means the period is 1/250 second. Then b = 2π/period = 2π·250 = 500π.' from version_ins
union all select gen_random_uuid(), id, 'D', '250π', false, 'This uses b = π·(frequency), dropping the factor of 2. One cycle needs the argument b·t to increase by 2π, so with period 1/250 we get b = 2π·250 = 500π.' from version_ins;
-- apprecalc-mcq-sv-np2-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-006-v3', 'mcq', 'Parameter b from a maximum and the next minimum', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function y = a·sin(b(x + c)) + d, with b > 0, has a maximum at x = 3 and its next minimum at x = 11. What is the value of b?', null, md5('apprecalc-mcq-sv-np2-006-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/8', true, 'A maximum to the next minimum is half a period, so half the period is 11 − 3 = 8 and the period is 16. Then b = 2π/16 = π/8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/4', false, 'This treats 8, the distance from a maximum to the next minimum, as a full period: 2π/8 = π/4. That distance is only half a period, so the period is 16 and b = π/8.' from version_ins
union all select gen_random_uuid(), id, 'C', '16', false, '16 is the correct period, but b is not the period. The relationship is b = 2π/period = 2π/16 = π/8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/16', false, 'This uses b = π/period = π/16, dropping the factor of 2. The period of a sinusoid is 2π/b, so with period 16, b = 2π/16 = π/8.' from version_ins;
-- apprecalc-mcq-sv-np2-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-007-v1', 'mcq', 'Sine at a third-quadrant angle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of sin(7π/6)?', null, md5('apprecalc-mcq-sv-np2-007-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3/2', false, 'This uses the cosine reference value cos(π/6) = √3/2 and also omits the negative sign for the third quadrant. The correct value is −sin(π/6) = −1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−√3/2', false, 'The sign is right, but √3/2 is cos(π/6), the cosine reference value. The sine reference value for π/6 is 1/2, so sin(7π/6) = −1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/2', true, '7π/6 lies in the third quadrant with reference angle 7π/6 − π = π/6. Sine is negative there, so sin(7π/6) = −sin(π/6) = −1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This gives the reference value sin(π/6) = 1/2 but omits the negative sign. In the third quadrant the y-coordinate on the unit circle is negative.' from version_ins;
commit;
