begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.2-a-v1','apcalcab-mcq-b5-sv-h-2.2-a-v2','apcalcab-mcq-b5-sv-h-2.2-a-v3','apcalcab-mcq-b5-h-2.2-b','apcalcab-mcq-b5-sv-h-2.2-b-v1','apcalcab-mcq-b5-sv-h-2.2-b-v2','apcalcab-mcq-b5-sv-h-2.2-b-v3','apcalcab-mcq-b5-h-2.3-a','apcalcab-mcq-b5-sv-h-2.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-sv-h-2.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.2-a-v1', 'mcq', 'identify the function and point behind a difference-quotient limit and evaluate it as a derivative. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The limit lim(x→2) (x⁵ − 32)/(x − 2) equals f′(a) for some function f and number a. What is the value of the limit?', null, md5('apcalcab-mcq-b5-sv-h-2.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '32', false, 'The number 32 is f(2) for f(x) = x⁵, not f′(2). The limit is a slope, not a function value.' from version_ins
union all select gen_random_uuid(), id, 'B', '160', false, 'This computes 5 · 2⁵, keeping the exponent at 5 instead of lowering it to 4. The correct power rule gives 5x⁴.' from version_ins
union all select gen_random_uuid(), id, 'C', '80', true, 'Correct: With f(x) = x⁵ and a = 2, the limit is f′(2) = 5 · 2⁴ = 80.' from version_ins
union all select gen_random_uuid(), id, 'D', '10', false, 'This computes 5 · 2, lowering the exponent but not applying it to the evaluated point. The correct value is 5 · 2⁴.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.2-a-v2', 'mcq', 'identify the function and point behind a difference-quotient limit and evaluate it as a derivative. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The limit lim(h→0) [(1 + h)⁻² − 1]/h equals f′(a) for some function f and number a. What is the value of the limit?', null, md5('apcalcab-mcq-b5-sv-h-2.2-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This drops the negative sign. Differentiating x⁻² gives −2x⁻³, which is negative at x = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', true, 'Correct: With f(x) = x⁻² and a = 1, the limit is f′(1) = −2 · 1⁻³ = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'Substituting h = 0 gives the form 0/0. It does not mean the limit equals zero; the limit is the derivative of x⁻² at 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'The number 1 is f(1) = 1⁻², the function value rather than the derivative at x = 1.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.2-a-v3', 'mcq', 'identify the function and point behind a difference-quotient limit and evaluate it as a derivative. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The limit lim(x→−2) (x³ + 8)/(x + 2) equals f′(a) for some function f and number a. What is the value of the limit?', null, md5('apcalcab-mcq-b5-sv-h-2.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8', false, 'The number −8 is f(−2) = (−2)³, not the derivative. The limit is the slope of f at −2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6', false, 'This uses 3x instead of 3x², so it does not square −2. The power rule gives f′(x) = 3x², which is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The numerator and denominator both approach 0, but that does not make the limit 0. It is f′(−2) for f(x) = x³.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', true, 'Correct: With f(x) = x³ and a = −2, the limit is f′(−2) = 3(−2)² = 12.' from version_ins;
-- apcalcab-mcq-b5-h-2.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.2-b', 'mcq', 'find the error in a limit-definition derivation where f(x + h) is expanded incorrectly, and state the correct derivative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student uses the definition to find f′(x) for f(x) = x². The student writes f(x + h) = x² + h², so [f(x + h) − f(x)]/h = h²/h = h, and concludes f′(x) = lim(h→0) h = 0. Which statement identifies the error and gives the correct derivative?', null, md5('apcalcab-mcq-b5-h-2.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x + h)² = x² + 2xh + h², so the correct derivative is 2x + h.', false, 'This finds the right expansion but stops before taking the limit. The difference quotient is 2x + h, and the derivative is its limit as h → 0, which is 2x.' from version_ins
union all select gen_random_uuid(), id, 'B', '(x + h)² = x² + 2xh + h², not x² + h², so the correct derivative is f′(x) = 2x.', true, 'Correct: The correct expansion gives [x² + 2xh + h² − x²]/h = 2x + h, whose limit as h → 0 is 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is no error. The terms in h vanish as h → 0, so the derivative of x² is 0 for every x.', false, 'The squared binomial has a middle term 2xh that the student dropped. A derivative of 0 would make x² constant, which it is not.' from version_ins
union all select gen_random_uuid(), id, 'D', '(x + h)² = x² + 2xh + h², so the correct derivative is 2.', false, 'This divides 2xh by xh instead of by h, losing a factor of x. The difference quotient is 2x + h, which tends to 2x.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.2-b-v1', 'mcq', 'find the error in a limit-definition derivation where f(x + h) is expanded incorrectly, and state the correct derivative (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student uses the definition to find f′(x) for f(x) = x³. The student writes f(x + h) = x³ + h³, so [f(x + h) − f(x)]/h = h³/h = h², and concludes f′(x) = lim(h→0) h² = 0. Which statement identifies the error and gives the correct derivative?', null, md5('apcalcab-mcq-b5-sv-h-2.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x + h)³ = x³ + 3x²h + 3xh² + h³, so the correct derivative is 3x² + 3xh + h².', false, 'This stops before taking the limit. The difference quotient is 3x² + 3xh + h², and the derivative is its limit as h → 0, which is 3x².' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no error. Both h² and h vanish as h → 0, so the derivative of x³ is 0.', false, 'The cube expansion has two cross terms the student dropped. A derivative of 0 would make x³ constant, which it is not.' from version_ins
union all select gen_random_uuid(), id, 'C', '(x + h)³ = x³ + 3x²h + 3xh² + h³, not x³ + h³, so the correct derivative is f′(x) = 3x².', true, 'Correct: The correct expansion gives [3x²h + 3xh² + h³]/h = 3x² + 3xh + h², whose limit as h → 0 is 3x².' from version_ins
union all select gen_random_uuid(), id, 'D', '(x + h)³ = x³ + 3x²h + 3xh² + h³, so the correct derivative is 3x.', false, 'This lowers the exponent but loses a factor of x. The terms 3x²h and 3xh² give a difference quotient that tends to 3x², not 3x.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.2-b-v2', 'mcq', 'find the error in a limit-definition derivation where f(x + h) is expanded incorrectly, and state the correct derivative (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student uses the definition to find f′(x) for f(x) = 1/x. The student writes 1/(x + h) = 1/x + 1/h, so the numerator is 1/h and the quotient is 1/h², and concludes the derivative does not exist. Which statement identifies the error and gives the correct derivative?', null, md5('apcalcab-mcq-b5-sv-h-2.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/(x + h) is not 1/x + 1/h; using a common denominator gives f′(x) = 1/x².', false, 'This finds the right fix but loses the sign. The numerator x − (x + h) equals −h, so the limit is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(x + h) is not 1/x + 1/h; using a common denominator gives f′(x) = −1/x².', true, 'Correct: [1/(x + h) − 1/x]/h = [x − (x + h)]/[x(x + h)h] = −1/[x(x + h)], whose limit as h → 0 is −1/x².' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is no error. The quotient 1/h² is unbounded as h → 0, so 1/x has no derivative.', false, 'A reciprocal of a sum is not the sum of reciprocals. The function 1/x is differentiable for x ≠ 0, so the conclusion is wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/(x + h) is not 1/x + 1/h; using a common denominator gives f′(x) = −1/x.', false, 'This keeps the sign but misses the factor 1/x² in the common denominator. The limit of −1/(x(x + h)) is −1/x², not −1/x.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.2-b-v3', 'mcq', 'find the error in a limit-definition derivation where f(x + h) is expanded incorrectly, and state the correct derivative (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student uses the definition to find f′(x) for f(x) = √x with x > 0. The student writes √(x + h) = √x + √h, so the quotient is √h/h = 1/√h, and concludes the derivative does not exist. Which statement identifies the error and gives the correct derivative?', null, md5('apcalcab-mcq-b5-sv-h-2.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√(x + h) is not √x + √h; multiplying by the conjugate gives f′(x) = 1/√x.', false, 'This multiplies by the conjugate correctly but drops the 2. The denominator √(x + h) + √x tends to 2√x, not √x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no error. The quotient 1/√h is unbounded as h → 0, so √x has no derivative for x > 0.', false, 'A square root of a sum is not the sum of square roots. The function √x is differentiable for every x > 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '√(x + h) is not √x + √h; multiplying by the conjugate gives f′(x) = 1/(2√x).', true, 'Correct: [√(x + h) − √x]/h = 1/[√(x + h) + √x], whose limit as h → 0 is 1/(2√x).' from version_ins
union all select gen_random_uuid(), id, 'D', '√(x + h) is not √x + √h; multiplying by the conjugate gives f′(x) = 1/(2x).', false, 'This keeps the factor 2 but replaces √x with x in the denominator. The conjugate denominator tends to 2√x.' from version_ins;
-- apcalcab-mcq-b5-h-2.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.3-a', 'mcq', 'estimate acceleration from a table of velocity values with uneven spacing, then use the signs of velocity and accelerati', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity v(t), in meters per second, of a car moving along a straight road is given in the table for selected times t in seconds.
t (seconds):   0   3   7   12
v(t) (m/s):   −4   −10   −16   −22
Using the table values closest to t = 5, which statement is best at t = 5?', null, md5('apcalcab-mcq-b5-h-2.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The acceleration is about −1.5 m/s² and the car is slowing down.', false, 'Velocity and acceleration have the same sign (both negative), so the speed is increasing. A negative acceleration slows an object down only when the velocity is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The acceleration is about −1.5 m/s² and the car is speeding up.', true, 'Correct: a(5) ≈ (v(7) − v(3))/(7 − 3) = (−16 − (−10))/4 = −1.5 m/s². Since v < 0 and a < 0, the speed is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The acceleration is about −6 m/s² and the car is speeding up.', false, 'The change in velocity over [3, 7] is −6, but it must be divided by the interval length 4 to estimate acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The acceleration is about 1.5 m/s² and the car is slowing down.', false, 'This subtracts the values in the wrong order, giving +1.5 instead of −1.5. The velocity is becoming more negative, so the acceleration estimate is negative.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.3-a-v1', 'mcq', 'estimate acceleration from a table of velocity values with uneven spacing, then use the signs of velocity and accelerati (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity v(t), in meters per second, of a cart on a track is given in the table for selected times t in seconds.
t (seconds):   0   2   6   10
v(t) (m/s):   12   9   3   1
Using the table values closest to t = 4, which statement is best at t = 4?', null, md5('apcalcab-mcq-b5-sv-h-2.3-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The acceleration is about −1.5 m/s² and the cart is speeding up.', false, 'Here the velocity is positive and the acceleration negative, so the speed decreases. Treating a negative acceleration as always meaning speeding up reverses the conclusion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The acceleration is about −1.5 m/s² and the cart is slowing down.', true, 'Correct: a(4) ≈ (v(6) − v(2))/(6 − 2) = (3 − 9)/4 = −1.5 m/s². Since v > 0 and a < 0, the speed is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The acceleration is about −6 m/s² and the cart is slowing down.', false, 'The change in velocity over [2, 6] is −6, but it must be divided by the interval length 4 to get the acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The acceleration is about −0.5 m/s² and the cart is slowing down.', false, 'This uses the interval [6, 10], which does not contain t = 4. The estimate needs the interval that straddles t = 4, namely [2, 6].' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.2-a-v1','apcalcab-mcq-b5-sv-h-2.2-a-v2','apcalcab-mcq-b5-sv-h-2.2-a-v3','apcalcab-mcq-b5-h-2.2-b','apcalcab-mcq-b5-sv-h-2.2-b-v1','apcalcab-mcq-b5-sv-h-2.2-b-v2','apcalcab-mcq-b5-sv-h-2.2-b-v3','apcalcab-mcq-b5-h-2.3-a','apcalcab-mcq-b5-sv-h-2.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-sv-h-2.2-a-v1','apcalcab-mcq-b5-sv-h-2.2-a-v2','apcalcab-mcq-b5-sv-h-2.2-a-v3','apcalcab-mcq-b5-h-2.2-b','apcalcab-mcq-b5-sv-h-2.2-b-v1','apcalcab-mcq-b5-sv-h-2.2-b-v2','apcalcab-mcq-b5-sv-h-2.2-b-v3','apcalcab-mcq-b5-h-2.3-a','apcalcab-mcq-b5-sv-h-2.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
