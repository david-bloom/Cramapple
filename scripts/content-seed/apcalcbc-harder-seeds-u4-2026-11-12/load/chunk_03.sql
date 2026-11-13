begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.3-a-v2','apcalcbc-mcq-b4-sv-h-4.3-a-v3','apcalcbc-mcq-b4-h-4.3-b','apcalcbc-mcq-b4-sv-h-4.3-b-v1','apcalcbc-mcq-b4-sv-h-4.3-b-v2','apcalcbc-mcq-b4-sv-h-4.3-b-v3','apcalcbc-mcq-b4-h-4.4-a','apcalcbc-mcq-b4-sv-h-4.4-a-v1','apcalcbc-mcq-b4-sv-h-4.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b4-sv-h-4.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.3-a-v2', 'mcq', 'combine marginal revenue and marginal cost into a marginal profit and read the sign of the second derivative as the tren (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop sells x units of an item at a constant price of $14 each, so its revenue is R(x) = 14x dollars. Its cost is C(x) = 100 + 6x + 40√x dollars. Which statement is correct at x = 25?', null, md5('apcalcbc-mcq-b4-sv-h-4.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Profit is increasing at $14.00 per unit, and the rate of increase is itself increasing.', false, '14 is the marginal revenue alone; the marginal profit also subtracts the marginal cost C′(25) = 6 + 20/5 = 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Profit is increasing at $4.00 per unit, and the rate of increase is decreasing.', false, 'C″(x) = −10x^(−3/2) is negative, so C′ is falling; profit''s rate 14 − C′(x) therefore rises, and P″ = −C″ is positive, not negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Profit is decreasing at $10.00 per unit, and the rate of decrease is itself decreasing.', false, '10 is the marginal cost alone; the marginal revenue of 14 per unit must also be included, which makes the profit rate positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Profit is increasing at $4.00 per unit, and the rate of increase is itself increasing.', true, 'Correct: P′(x) = 14 − (6 + 20/√x), so P′(25) = 14 − 10 = 4 > 0. C″(x) = −10x^(−3/2) < 0, so P″(x) = −C″(x) > 0 and the rate of profit increase is itself increasing.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.3-a-v3', 'mcq', 'combine marginal revenue and marginal cost into a marginal profit and read the sign of the second derivative as the tren (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A shop sells x units of an item at a constant price of $4 each, so its revenue is R(x) = 4x dollars. Its cost is C(x) = 10 + 60√x dollars. Which statement is correct at x = 25?', null, md5('apcalcbc-mcq-b4-sv-h-4.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Profit is decreasing at $6.00 per unit, and it is decreasing more slowly as x increases.', false, '6 is the marginal cost C′(25) = 30/5 alone; the marginal profit also includes the marginal revenue of 4 per unit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Profit is decreasing at $2.00 per unit, and it is decreasing more slowly as x increases.', true, 'Correct: P′(x) = 4 − 30/√x, so P′(25) = 4 − 6 = −2. C″(x) = −15x^(−3/2), so P″(25) = 15/125 = 0.12 > 0 and the profit rate rises toward zero, meaning profit declines more slowly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Profit is decreasing at $2.00 per unit, and it is decreasing faster as x increases.', false, 'C″(x) = −15x^(−3/2) is negative, so C′ is falling and P″ = −C″ is positive; the profit rate rises toward zero, so the decrease slows down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Profit is increasing at $2.00 per unit, and it is increasing faster as x increases.', false, 'This finds C′ − R′ instead of R′ − C′; marginal cost 6 exceeds marginal revenue 4, so the profit rate is negative and profit is falling.' from version_ins;
-- apcalcbc-mcq-b4-h-4.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.3-b', 'mcq', 'differentiate a rational or exponential model, with units, and compare the instantaneous rate to an average rate over an', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The concentration of a drug in the blood, in mg/L, is C(t) = 8t/(t + 3), where t is the number of hours after the dose. Which statement is correct?', null, md5('apcalcbc-mcq-b4-h-4.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At t = 3 the concentration is rising at 4 mg/L per hour, which is faster than its average rate of 8/9 mg/L per hour over [0, 6].', false, 'The quotient rule gives C′(t) = 24/(t + 3)²; 24/(t + 3) = 4 leaves out squaring the denominator.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At t = 3 the concentration is rising at 2/3 mg/L per hour, which is slower than its average rate of 8/9 mg/L per hour over [0, 6].', true, 'Correct: C′(t) = [8(t + 3) − 8t]/(t + 3)² = 24/(t + 3)², so C′(3) = 24/36 = 2/3. The average rate is (C(6) − C(0))/6 = (16/3)/6 = 8/9, and 2/3 < 8/9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At t = 3 the concentration is rising at 4/3 mg/L per hour, which is faster than its average rate of 8/9 mg/L per hour over [0, 6].', false, '8/(t + 3) = 4/3 differentiates only the numerator and divides by the denominator; the quotient rule also needs the term from differentiating the denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 3 the concentration is falling at 2/3 mg/L per hour, while its average rate over [0, 6] is 8/9 mg/L per hour.', false, 'The quotient rule numerator is 8(t + 3) − 8t = 24, which is positive, so C′(3) is positive and the concentration is rising, not falling.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.3-b-v1', 'mcq', 'differentiate a rational or exponential model, with units, and compare the instantaneous rate to an average rate over an (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of bacteria, in thousands, in a culture is P(t) = 60t/(t + 4), where t is the number of hours after the culture is started. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At t = 1 the population is growing at 9.6 thousand per hour, which is faster than its average rate of 5 thousand per hour over [0, 8].', true, 'Correct: P′(t) = [60(t + 4) − 60t]/(t + 4)² = 240/(t + 4)², so P′(1) = 240/25 = 9.6. The average rate is (P(8) − P(0))/8 = 40/8 = 5, and 9.6 > 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At t = 1 the population is growing at 48 thousand per hour, which is faster than its average rate of 5 thousand per hour over [0, 8].', false, 'The quotient rule gives P′(t) = 240/(t + 4)²; 240/(t + 4) = 48 leaves out squaring the denominator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At t = 1 the population is growing at 12 thousand per hour, which is faster than its average rate of 5 thousand per hour over [0, 8].', false, '60/(t + 4) = 12 differentiates only the numerator and divides by the denominator; the quotient rule also needs the term from differentiating the denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 1 the population is shrinking at 9.6 thousand per hour, while its average rate over [0, 8] is 5 thousand per hour.', false, 'The quotient rule numerator is 60(t + 4) − 60t = 240, which is positive, so P′(1) is positive and the population is growing, not shrinking.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.3-b-v2', 'mcq', 'differentiate a rational or exponential model, with units, and compare the instantaneous rate to an average rate over an (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of salt dissolved from a crystal after t minutes is Q(t) = 5(1 − e^(−0.4t)) grams. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At t = 3 the salt is dissolving at about 1.51 grams per minute, which is faster than its average rate of about 0.86 grams per minute over [0, 5].', false, 'This omits the chain-rule factor 0.4 from differentiating the exponent: Q′(t) = 5·0.4e^(−0.4t) = 2e^(−0.4t), not 5e^(−0.4t).' from version_ins
union all select gen_random_uuid(), id, 'B', 'At t = 3 the salt is dissolving at about 0.60 grams per minute, which is slower than its average rate of about 0.86 grams per minute over [0, 5].', true, 'Correct: Q′(t) = 5(0.4)e^(−0.4t) = 2e^(−0.4t), so Q′(3) = 2e^(−1.2) ≈ 0.602. The average rate is (Q(5) − Q(0))/5 = 5(1 − e^(−2))/5 ≈ 0.865, and 0.602 < 0.865.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At t = 3 the salt is dissolving at about −0.60 grams per minute, which is slower than its average rate of about 0.86 grams per minute over [0, 5].', false, 'The derivative of −e^(−0.4t) is +0.4e^(−0.4t); keeping the minus sign makes the rate negative, but the amount dissolved is increasing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 3 the salt is dissolving at about 0.12 grams per minute, which is slower than its average rate of about 0.86 grams per minute over [0, 5].', false, 'This drops the constant 5 and gets 0.4e^(−1.2); the factor 5 multiplies the whole derivative, giving 5·0.4e^(−1.2) = 2e^(−1.2).' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.3-b-v3', 'mcq', 'differentiate a rational or exponential model, with units, and compare the instantaneous rate to an average rate over an (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height of a plant, in centimeters, is H(t) = 12 ln(t + 1), where t is the number of days after planting. Which statement is correct?', null, md5('apcalcbc-mcq-b4-sv-h-4.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At t = 5 the plant is growing at about 4.30 cm per day, which is faster than its average rate of about 3.30 cm per day over [0, 8].', false, '12 ln 6/5 ≈ 4.30 is the average rate over [0, 5], not the instantaneous rate; the derivative H′(t) = 12/(t + 1) must be evaluated at t = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At t = 5 the plant is growing at 2.4 cm per day, which is slower than its average rate of about 3.30 cm per day over [0, 8].', false, '12/t = 2.4 differentiates ln(t + 1) as 1/t, forgetting the +1 inside the log; the derivative of ln(t + 1) is 1/(t + 1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'At t = 5 the plant is growing at 2 cm per day, which is slower than its average rate of about 3.30 cm per day over [0, 8].', true, 'Correct: H′(t) = 12/(t + 1), so H′(5) = 2. The average rate is (H(8) − H(0))/8 = 12 ln 9/8 ≈ 3.296, and 2 < 3.296.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 5 the plant is growing at about 0.33 cm per day, which is slower than its average rate of about 3.30 cm per day over [0, 8].', false, '12/(t + 1)² = 1/3 uses a squared denominator, which belongs to the quotient rule; the derivative of ln(t + 1) is simply 1/(t + 1).' from version_ins;
-- apcalcbc-mcq-b4-h-4.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-h-4.4-a', 'mcq', 'relate a changing hypotenuse to a changing leg by differentiating the Pythagorean relationship before substituting value', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone flies horizontally at a constant altitude of 60 m. An observer stands on the ground, and the drone moves away at 10 m/s. At the instant when its horizontal distance from the observer is 80 m, how fast is the straight-line distance from the observer to the drone increasing?', null, md5('apcalcbc-mcq-b4-h-4.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 m/s', false, 'This treats the straight-line distance as changing at the same rate as the horizontal distance, but D′ = (x/D)x′ is smaller because the hypotenuse D = 100 is longer than x = 80.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 m/s', true, 'Correct: D² = x² + 60², so 2D·D′ = 2x·x′ and D′ = (x/D)x′. At x = 80, D = 100, so D′ = (80/100)(10) = 8 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '12.5 m/s', false, 'This inverts the ratio: D′ = (x/D)(x′) uses x/D = 0.8, not D/x = 1.25, and the hypotenuse cannot grow faster than the leg that drives it here.' from version_ins
union all select gen_random_uuid(), id, 'D', '6 m/s', false, 'This multiplies by the altitude ratio 60/100 instead of the horizontal ratio 80/100; the altitude is constant and its rate is zero, so x is the factor that appears.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.4-a-v1', 'mcq', 'relate a changing hypotenuse to a changing leg by differentiating the Pythagorean relationship before substituting value (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boat is pulled toward a dock by a rope attached to its bow and passing through a ring on the dock that is 6 ft above the bow. The rope is pulled in at 2 ft/s. When 10 ft of rope is out, how fast is the boat approaching the dock?', null, md5('apcalcbc-mcq-b4-sv-h-4.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 ft/s', false, 'This assumes the boat moves at the same rate as the rope, but the rope is the hypotenuse and the boat''s horizontal distance changes at (L/x)(L′), which is faster.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.6 ft/s', false, 'This inverts the ratio: x′ = (L/x)L′ uses L/x = 10/8, and the factor 8/10 puts the larger length in the wrong place, giving a slower rate.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.2 ft/s', false, 'This multiplies by the ring height ratio 6/10 instead of L/x; the height is constant, so only the horizontal distance x enters the relationship.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.5 ft/s', true, 'Correct: x² + 6² = L², so 2x·x′ = 2L·L′ and x′ = (L/x)L′. At L = 10, x = 8, so x′ = (10/8)(−2) = −2.5; the boat approaches at 2.5 ft/s.' from version_ins;
-- apcalcbc-mcq-b4-sv-h-4.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b4-sv-h-4.4-a-v2', 'mcq', 'relate a changing hypotenuse to a changing leg by differentiating the Pythagorean relationship before substituting value (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a certain moment car P is 3 miles east of an intersection and moving toward it at 30 mph, while car Q is 4 miles north of the intersection and moving away from it at 40 mph. At that moment, how fast is the distance between the cars changing?', null, md5('apcalcbc-mcq-b4-sv-h-4.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing at 14 mph', true, 'Correct: D² = x² + y², so D′ = (x·x′ + y·y′)/D. With x = 3, x′ = −30, y = 4, y′ = 40 and D = 5, D′ = (−90 + 160)/5 = 14 mph.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increasing at 10 mph', false, 'This adds the signed speeds, −30 + 40, as if the distance between the cars were a straight line along one road, ignoring that the distance is a hypotenuse.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increasing at 70 mph', false, 'This computes x·x′ + y·y′ = 70 but forgets to divide by the distance D = 5; the relationship is D′ = (x·x′ + y·y′)/D.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Not changing, at 0 mph', false, 'This pairs each speed with the other car''s distance, 4(−30) + 3(40) = 0; x′ must be multiplied by x and y′ by y.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b4-sv-h-4.3-a-v2','apcalcbc-mcq-b4-sv-h-4.3-a-v3','apcalcbc-mcq-b4-h-4.3-b','apcalcbc-mcq-b4-sv-h-4.3-b-v1','apcalcbc-mcq-b4-sv-h-4.3-b-v2','apcalcbc-mcq-b4-sv-h-4.3-b-v3','apcalcbc-mcq-b4-h-4.4-a','apcalcbc-mcq-b4-sv-h-4.4-a-v1','apcalcbc-mcq-b4-sv-h-4.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b4-sv-h-4.3-a-v2','apcalcbc-mcq-b4-sv-h-4.3-a-v3','apcalcbc-mcq-b4-h-4.3-b','apcalcbc-mcq-b4-sv-h-4.3-b-v1','apcalcbc-mcq-b4-sv-h-4.3-b-v2','apcalcbc-mcq-b4-sv-h-4.3-b-v3','apcalcbc-mcq-b4-h-4.4-a','apcalcbc-mcq-b4-sv-h-4.4-a-v1','apcalcbc-mcq-b4-sv-h-4.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
