begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-005-v1','apprecalc-mcq-sv-005-v3','apprecalc-mcq-sv-006-v1','apprecalc-mcq-sv-006-v2','apprecalc-mcq-sv-006-v3','apprecalc-mcq-sv-007-v1','apprecalc-mcq-sv-007-v2','apprecalc-mcq-sv-007-v3','apprecalc-mcq-sv-008-v1','apprecalc-mcq-sv-008-v2','apprecalc-mcq-sv-008-v3','apprecalc-mcq-sv-009-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-005-v1', 'mcq', 'Caution with a quadratic model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quadratic function h was fit to measurements of a ball''s height taken for times between t = 0.5 and t = 3.5 seconds. Which use of the model should be treated with the most caution?', null, md5('apprecalc-mcq-sv-005-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Estimating the height at t = 12 seconds', true, 't = 12 is far outside the measured interval 0.5 ≤ t ≤ 3.5. Extrapolating that far assumes the fitted pattern continues, which the data cannot support.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Evaluating the model at t = 3.5 seconds', false, 't = 3.5 is the last measured time, so it is within the data domain.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Estimating the height at t = 2 seconds', false, 't = 2 lies inside the measured interval, so this is interpolation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Comparing the model''s heights at t = 1 and t = 3', false, 'Both inputs lie inside the measured interval, so the comparison is based on interpolated values.' from version_ins;
-- apprecalc-mcq-sv-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-005-v3', 'mcq', 'Evaluating a claim about model reliability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial model P(t) was fit to data collected for 5 ≤ t ≤ 25. A student claims the prediction P(40) is just as trustworthy as the prediction P(15). Which response is best?', null, md5('apprecalc-mcq-sv-005-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The claim is incorrect, because 40 is far outside the data interval, so the pattern may not continue there', true, 'The input 40 is beyond the observed values 5 ≤ t ≤ 25, so P(40) is an extrapolation, while P(15) is an interpolation inside the data.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The claim is correct, because polynomial models are valid for all real inputs', false, 'A polynomial can be evaluated at any real input, but that does not mean it models the situation there; 40 lies outside 5 ≤ t ≤ 25.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The claim is correct, because a model that fits the data well fits at every input', false, 'A good fit on the observed interval says nothing certain about inputs beyond it; P(40) is outside 5 ≤ t ≤ 25.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The claim is incorrect, because P(15) lies inside the data and is therefore less reliable', false, 'Reverses the idea of reliability: interpolating inside the observed interval is more trustworthy than extrapolating beyond it.' from version_ins;
-- apprecalc-mcq-sv-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-006-v1', 'mcq', 'Composition of linear and quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 3x + 2 and g(x) = x² − 1. Which expression equals (f∘g)(x)?', null, md5('apprecalc-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3x² − 1', true, '(f∘g)(x) = f(g(x)) = 3(x² − 1) + 2 = 3x² − 3 + 2 = 3x² − 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '3x³ + 2x² − 3x − 2', false, 'Multiplies the functions, (3x + 2)(x² − 1) = 3x³ + 2x² − 3x − 2, instead of composing them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x² + 3x + 1', false, 'Adds the functions, (3x + 2) + (x² − 1) = x² + 3x + 1, instead of composing them.' from version_ins
union all select gen_random_uuid(), id, 'D', '9x² + 12x + 3', false, 'Computes g(f(x)) = (3x + 2)² − 1 = 9x² + 12x + 3, reversing the order of composition.' from version_ins;
-- apprecalc-mcq-sv-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-006-v2', 'mcq', 'Composition involving a square root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(x + 5) and g(x) = x² − 4. Which expression equals (f∘g)(x)?', null, md5('apprecalc-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x + 1', false, 'Computes g(f(x)) = (√(x + 5))² − 4 = x + 1, reversing the order of composition.' from version_ins
union all select gen_random_uuid(), id, 'B', '√(x + 5) + x² − 4', false, 'Adds f(x) and g(x), √(x + 5) + (x² − 4), instead of composing them.' from version_ins
union all select gen_random_uuid(), id, 'C', '√(x² − 4) + 5', false, 'Applies the +5 after the square root instead of inside it: √(x² − 4) + 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '√(x² + 1)', true, '(f∘g)(x) = f(x² − 4) = √((x² − 4) + 5) = √(x² + 1).' from version_ins;
-- apprecalc-mcq-sv-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-006-v3', 'mcq', 'Evaluate a composition with an exponential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 2^x and g(x) = x² − 5. What is the value of (g∘f)(3)?', null, md5('apprecalc-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '64', false, 'Squares f(3) = 8 to get 64 but forgets to subtract 5 in g(8) = 64 − 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', false, 'Adds the function values, f(3) + g(3) = 8 + 4 = 12, instead of composing.' from version_ins
union all select gen_random_uuid(), id, 'C', '59', true, 'f(3) = 2³ = 8, then g(8) = 8² − 5 = 64 − 5 = 59.' from version_ins
union all select gen_random_uuid(), id, 'D', '16', false, 'Computes (f∘g)(3) instead: g(3) = 9 − 5 = 4 and f(4) = 2⁴ = 16, reversing the order of composition.' from version_ins;
-- apprecalc-mcq-sv-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-007-v1', 'mcq', 'Equal-degree rational end behavior', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student is checking what happens to the rational function Q(x) = (2x² − 3x + 1)/(x² + 4) when x grows very large and positive. Comparing the leading terms of numerator and denominator, the right-end behavior of Q is closest to which of the following descriptions?', null, md5('apprecalc-mcq-sv-007-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q(x) behaves like 2', true, 'The numerator and denominator both have degree 2, so for large x the function behaves like the ratio of the leading coefficients, 2/1 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q(x) behaves like 2x²', false, 'Keeps only the numerator''s leading term 2x² and ignores the denominator x², which should divide it to leave 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q(x) behaves like 0', false, 'A limit of 0 would require the denominator''s degree to exceed the numerator''s. Here both degrees are 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q(x) behaves like 1/2', false, 'Inverts the ratio of leading coefficients, 1/2, instead of numerator over denominator, 2/1.' from version_ins;
-- apprecalc-mcq-sv-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-007-v2', 'mcq', 'Slant-type end behavior with coefficients', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For R(x) = (x + 3)(2x − 1)(x − 4)/(x² + 1), the right-end behavior is closest to', null, md5('apprecalc-mcq-sv-007-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R(x) behaves like 2', false, 'Applies the equal-degree rule using only the ratio of leading coefficients, 2/1; but the numerator''s degree 3 exceeds the denominator''s degree 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R(x) behaves like x', false, 'Leaves out the coefficient 2 from the factor 2x − 1, using 1 as the numerator''s leading coefficient.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R(x) behaves like 2x', true, 'The numerator has degree 3 with leading coefficient 1·2·1 = 2, and the denominator has degree 2 with leading coefficient 1. So R(x) behaves like 2x³/x² = 2x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R(x) behaves like 2x²', false, 'Divides the leading term 2x³ by x instead of by x², getting 2x²; the denominator''s leading term is x².' from version_ins;
-- apprecalc-mcq-sv-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-007-v3', 'mcq', 'Denominator-dominant rational end behavior', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For S(x) = (5x² + 1)/(2x³ − x), the right-end behavior is closest to', null, md5('apprecalc-mcq-sv-007-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'S(x) behaves like 5x/2', false, 'Divides in the wrong direction: it treats 5x²/(2x³) as (5/2)x, but 5x²/(2x³) = 5/(2x).' from version_ins
union all select gen_random_uuid(), id, 'B', 'S(x) increases without bound', false, 'Reasons that positive leading coefficients make the function grow; but the denominator, of higher degree, grows faster, so S(x) → 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'S(x) approaches 5/2', false, 'Uses the ratio of leading coefficients, 5/2, which applies only when numerator and denominator have the same degree.' from version_ins
union all select gen_random_uuid(), id, 'D', 'S(x) approaches 0', true, 'The denominator''s degree, 3, exceeds the numerator''s degree, 2, so S(x) behaves like 5x²/(2x³) = 5/(2x), which approaches 0. For example S(100) = 50001/1999900 ≈ 0.025.' from version_ins;
-- apprecalc-mcq-sv-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-008-v1', 'mcq', 'Model for percent decay', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quantity starts at 250 and decreases by 12% each period. A suitable model for the amount after t periods is', null, md5('apprecalc-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '250(0.88)^t', true, 'Each period keeps 100% − 12% = 88% of the amount, so the amount is multiplied by 0.88 each period.' from version_ins
union all select gen_random_uuid(), id, 'B', '250 − 0.12t', false, 'Subtracts 0.12 units per period instead of 12% of the current amount; this model is linear, not exponential.' from version_ins
union all select gen_random_uuid(), id, 'C', '250(1.12)^t', false, 'Uses the growth factor 1.12, which would model a 12% increase.' from version_ins
union all select gen_random_uuid(), id, 'D', '250(0.12)^t', false, 'Uses the percent decrease, 0.12, as the multiplier; after one period this gives 250(0.12) = 30 rather than 250(0.88) = 220.' from version_ins;
-- apprecalc-mcq-sv-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-008-v2', 'mcq', 'Model from a doubling time', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quantity starts at 40 and doubles every 3 years. A suitable model for the amount after t years is', null, md5('apprecalc-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40(2)^t', false, 'Doubles every year instead of every 3 years; at t = 3 this gives 40·8 = 320 rather than 80.' from version_ins
union all select gen_random_uuid(), id, 'B', '40(4/3)^t', false, 'Spreads the 100% increase evenly over 3 years as 1/3 per year; at t = 3 this gives 40(4/3)³ ≈ 94.8, not 80.' from version_ins
union all select gen_random_uuid(), id, 'C', '40(2)^(t/3)', true, 'The amount doubles once every 3 years, so there are t/3 doublings after t years: 40·2^(t/3). At t = 3 this gives 80.' from version_ins
union all select gen_random_uuid(), id, 'D', '40(2)^(3t)', false, 'Puts the doubling time in the numerator of the exponent; at t = 1 this gives 40·2³ = 320, far more than doubling in 3 years.' from version_ins;
-- apprecalc-mcq-sv-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-008-v3', 'mcq', 'Exponential model from table values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives values of a function f: f(0) = 12, f(1) = 18, f(2) = 27, f(3) = 40.5. Which model fits the table exactly?', null, md5('apprecalc-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18(1.5)^t', false, 'Uses the correct ratio 1.5 but takes the first nonzero-input value 18 as the initial value; at t = 0 this gives 18, not 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 + 6t', false, 'Uses the first difference, 18 − 12 = 6, as a constant rate; but the differences are 6, 9, 13.5, so the growth is not linear. This model gives 24 at t = 2, not 27.' from version_ins
union all select gen_random_uuid(), id, 'C', '12(6)^t', false, 'Uses the first difference 6 as the base of the exponential; this gives 72 at t = 1, not 18.' from version_ins
union all select gen_random_uuid(), id, 'D', '12(1.5)^t', true, 'Each value is 1.5 times the previous one (18/12 = 27/18 = 40.5/27 = 1.5), and f(0) = 12, so f(t) = 12(1.5)^t.' from version_ins;
-- apprecalc-mcq-sv-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-009-v1', 'mcq', 'Solve a logarithmic equation, base 3', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution of log₃(x + 2) = 4?', null, md5('apprecalc-mcq-sv-009-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 10', false, 'Multiplies the base and the exponent, 3·4 = 12, instead of raising 3 to the 4th power, so x + 2 = 12 and x = 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 83', false, 'Rewrites correctly as x + 2 = 81 but adds 2 instead of subtracting it: x = 81 + 2 = 83.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 79', true, 'Rewrite in exponential form: x + 2 = 3⁴ = 81, so x = 79.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 2', false, 'Sets x + 2 equal to the exponent 4 instead of 3⁴, giving x = 4 − 2 = 2.' from version_ins;
commit;
