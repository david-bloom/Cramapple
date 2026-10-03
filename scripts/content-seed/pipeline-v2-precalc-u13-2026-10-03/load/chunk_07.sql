begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-027-v2','apprecalc-mcq-sv-027-v3','apprecalc-mcq-sv-028-v1','apprecalc-mcq-sv-028-v2','apprecalc-mcq-sv-028-v3','apprecalc-mcq-sv-029-v1','apprecalc-mcq-sv-029-v2','apprecalc-mcq-sv-029-v3','apprecalc-mcq-sv-030-v1','apprecalc-mcq-sv-030-v2','apprecalc-mcq-sv-030-v3','apprecalc-mcq-sv-031-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-027-v2', 'mcq', 'Third differences identify a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Equally spaced inputs x=0, 1, 2, 3, 4, 5 produce the outputs 0, −1, 4, 21, 56, 115. Which kind of function best fits these values?', null, md5('apprecalc-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A quartic model; the third differences are not zero', false, 'Nonzero constant third differences identify a cubic. A quartic model would show constant fourth differences, and here the third differences are already constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A cubic model; the third differences are all 6', true, 'The first differences are −1, 5, 17, 35, 59; the second differences are 6, 12, 18, 24; the third differences are 6, 6, 6. Constant third differences indicate a cubic.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A quadratic model; the second differences 6, 12, 18, 24 grow steadily', false, 'A quadratic needs constant second differences. These are 6, 12, 18, 24, which are not equal, so the model is not quadratic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An exponential model; the first differences keep growing', false, 'An exponential ab^x with a≠0 and b>0 never outputs 0 or changes sign, but the outputs here are 0 at x=0 and −1 at x=1. The consecutive ratios are also not constant.' from version_ins;
-- apprecalc-mcq-sv-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-027-v3', 'mcq', 'Quadratic with negative leading coefficient from a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A ball''s height h (in feet) is recorded every half second: for t=0, 0.5, 1, 1.5, 2 seconds, h=2, 8, 12, 14, 14. Which model type is most appropriate for h as a function of t?', null, md5('apprecalc-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cubic, with a negative leading coefficient', false, 'The negative sign is right, but the second differences are already constant (−2, −2, −2), which means degree 2. A cubic would need constant third differences.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Quadratic, with a positive leading coefficient', false, 'The model type is right, but the second differences are −2 (negative), so the parabola opens downward and the leading coefficient is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Quadratic, with a negative leading coefficient', true, 'The first differences are 6, 4, 2, 0 and the second differences are −2, −2, −2. Constant second differences indicate a quadratic, and the negative value means the leading coefficient is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Linear, with a positive slope', false, 'The outputs rise overall, but a linear model needs constant first differences. These are 6, 4, 2, 0.' from version_ins;
-- apprecalc-mcq-sv-028-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-028-v1', 'mcq', 'Remainder Theorem with a positive root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

When p(x)=x³+4x²−5x+6 is divided by x−3, what is the remainder?', null, md5('apprecalc-mcq-sv-028-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '48', false, 'This omits the constant term: 27+36−15=48. The remainder p(3) also includes +6, so it is 54.' from version_ins
union all select gen_random_uuid(), id, 'B', '54', true, 'By the Remainder Theorem the remainder is p(3)=27+36−15+6=54.' from version_ins
union all select gen_random_uuid(), id, 'C', '36', false, 'This computes 3³ as 3·3=9 instead of 27: 9+36−15+6=36.' from version_ins
union all select gen_random_uuid(), id, 'D', '30', false, 'This evaluates p(−3) instead of p(3): −27+36+15+6=30. Dividing by x−3 gives remainder p(3).' from version_ins;
-- apprecalc-mcq-sv-028-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-028-v2', 'mcq', 'Remainder Theorem with x + 2', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

When p(x)=3x³−x²+2x−10 is divided by x+2, what is the remainder?', null, md5('apprecalc-mcq-sv-028-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−42', true, 'Dividing by x+2=x−(−2) gives remainder p(−2)=3(−8)−4+2(−2)−10=−24−4−4−10=−42.' from version_ins
union all select gen_random_uuid(), id, 'B', '14', false, 'This evaluates p(2) instead of p(−2): 24−4+4−10=14. Dividing by x+2 requires evaluating at −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'This computes (−2)³ as +8 instead of −8: 3(8)−4−4−10=6.' from version_ins
union all select gen_random_uuid(), id, 'D', '−32', false, 'This omits the constant term: −24−4−4=−32. The remainder p(−2) also includes −10, so it is −42.' from version_ins;
-- apprecalc-mcq-sv-028-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-028-v3', 'mcq', 'Remainder Theorem with a missing term', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

When p(x)=2x⁴−5x²+3x+1 is divided by x+1, what is the remainder?', null, md5('apprecalc-mcq-sv-028-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', false, 'This omits the constant term: 2−5−3=−6. The remainder p(−1) also includes +1, so it is −5.' from version_ins
union all select gen_random_uuid(), id, 'B', '−9', false, 'This computes (−1)⁴ as −1 instead of 1: −2−5−3+1=−9.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'This evaluates p(1) instead of p(−1): 2−5+3+1=1. Dividing by x+1 requires evaluating at −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5', true, 'Dividing by x+1=x−(−1) gives remainder p(−1)=2(1)−5(1)+3(−1)+1=2−5−3+1=−5.' from version_ins;
-- apprecalc-mcq-sv-029-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-029-v1', 'mcq', 'Rational inequality with a nonstrict sign', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Solve the inequality (x+7)/(x−4)≥0. Which interval notation gives the solution set?', null, md5('apprecalc-mcq-sv-029-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−∞,−7]∪[4,∞)', false, 'The intervals are right, but x=4 makes the denominator 0, so the expression is undefined there and 4 must be excluded.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−7,4)', false, 'This is the solution of (x+7)/(x−4)≤0. For −7<x<4 the numerator is positive and the denominator is negative, so the quotient is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞,−7)∪(4,∞)', false, 'The intervals are right, but the inequality is nonstrict, so x=−7, where the quotient equals 0, must be included.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞,−7]∪(4,∞)', true, 'The critical values are x=−7 (the quotient is 0 and is included) and x=4 (undefined and excluded). The quotient is positive for x<−7 and for x>4, giving (−∞,−7]∪(4,∞).' from version_ins;
-- apprecalc-mcq-sv-029-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-029-v2', 'mcq', 'Rational inequality with a reversed numerator', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Find all x satisfying (9−x)/(x+8)≥0.', null, md5('apprecalc-mcq-sv-029-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−8,9)', false, 'The interval is right, but the inequality is nonstrict, so x=9, where the quotient equals 0, must be included.' from version_ins
union all select gen_random_uuid(), id, 'B', '[−8,9]', false, 'The interval is right, but x=−8 makes the denominator 0, so the expression is undefined there and −8 must be excluded.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞,−8)∪[9,∞)', false, 'This is the solution set of (x-9)/(x+8) >= 0, with the numerator sign reversed. For (9-x)/(x+8), values with x < -8 or x > 9 give negative quotients (x = 10 gives -1/18, x = -9 gives -18). Only the single value x = 9 (quotient 0) works there, and the interval (-8, 9), where the quotient is positive, is missing.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−8,9]', true, 'The critical values are x=9 (quotient 0, included) and x=−8 (undefined, excluded). For −8<x<9 both 9−x and x+8 are positive, so the quotient is positive; for x<−8 and x>9 it is negative.' from version_ins;
-- apprecalc-mcq-sv-029-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-029-v3', 'mcq', 'Rational inequality with three critical values', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

What is the solution set of the inequality (x−8)(x+4)/(x−9)≤0?', null, md5('apprecalc-mcq-sv-029-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−∞,−4)∪(8,9)', false, 'The intervals are right, but the inequality is nonstrict, so the zeros x=−4 and x=8 must be included.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−∞,−4]∪[8,9]', false, 'The intervals are right, but x=9 makes the denominator 0, so the expression is undefined there and 9 must be excluded.' from version_ins
union all select gen_random_uuid(), id, 'C', '[−4,8]∪(9,∞)', false, 'This is the solution of the ≥0 inequality. On (−4,8) and on x>9 the quotient is positive, not negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−∞,−4]∪[8,9)', true, 'The critical values are −4 and 8 (zeros, included) and 9 (undefined, excluded). The quotient is negative on x<−4 and on 8<x<9, and equals 0 at x=−4 and x=8.' from version_ins;
-- apprecalc-mcq-sv-030-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-030-v1', 'mcq', 'Predicted change in water level from a cubic model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A cubic regression models the water level w (in cm) of a reservoir x days after a storm: w=0.31x³−2.2x²+1.45x+9.8. According to the model, what is the change in water level from x=1.5 to x=3.4, to the nearest hundredth?', null, md5('apprecalc-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.59', false, 'This subtracts in the wrong order: w(1.5)−w(3.4)=8.07125−1.48224=6.58901. The change from 1.5 to 3.4 is final minus initial, which is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '−6.59', true, 'w(3.4)−w(1.5)=1.48224−8.07125=-6.58901, so the predicted change is −6.59 cm (a decrease).' from version_ins
union all select gen_random_uuid(), id, 'C', '−3.47', false, 'This divides the change -6.58901 by the interval length 1.9, giving the average rate of change -3.46790 cm per day. The question asks for the total change.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.48', false, 'This is the model''s value at the end of the interval, w(3.4)=1.48224, not the change from x=1.5 to x=3.4.' from version_ins;
-- apprecalc-mcq-sv-030-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-030-v2', 'mcq', 'Predicted change in visitors from a cubic model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A cubic regression models the number of daily visitors V (in hundreds) to a museum x months after it opens: V=−0.18x³+1.4x²−0.9x+12.5. What is the predicted change in V from x=2.2 to x=5.6, to the nearest hundredth?', null, md5('apprecalc-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4.37', false, 'This subtracts in the wrong order: V(2.2)−V(5.6)=15.37936−19.75312=-4.37376. The change from 2.2 to 5.6 is final minus initial.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.29', false, 'This divides the change 4.37376 by the interval length 3.4, giving the average rate 1.28640. The question asks for the total change.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.37', true, 'V(5.6)−V(2.2)=19.75312−15.37936=4.37376, which rounds to 4.37.' from version_ins
union all select gen_random_uuid(), id, 'D', '18.55', false, 'This evaluates the model at the interval length instead of at the endpoints: V(3.4)=18.54928. The change is V(5.6)−V(2.2).' from version_ins;
-- apprecalc-mcq-sv-030-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-030-v3', 'mcq', 'Predicted temperature change from a quartic model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A quartic regression models the temperature T (in °C) of a greenhouse x hours after sunrise: T=0.07x⁴−0.9x²+2.3x+15. What is the predicted change in T from x=1.3 to x=3.8, to the nearest hundredth?', null, md5('apprecalc-mcq-sv-030-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.67', true, 'T(3.8)−T(1.3)=25.339952−16.668927=8.671025, which rounds to 8.67 °C.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.47', false, 'This divides the change 8.671025 by the interval length 2.5, giving the average rate 3.468410 °C per hour. The question asks for the total change.' from version_ins
union all select gen_random_uuid(), id, 'C', '25.34', false, 'This is the predicted temperature at the end of the interval, T(3.8)=25.339952, not the change.' from version_ins
union all select gen_random_uuid(), id, 'D', '−8.67', false, 'This subtracts in the wrong order: T(1.3)−T(3.8)=16.668927−25.339952=-8.671025. The change from 1.3 to 3.8 is final minus initial.' from version_ins;
-- apprecalc-mcq-sv-031-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-031-v1', 'mcq', 'Average rate of change of a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

For g(x)=2x³−5x, what is the average rate of change from x=0.8 to x=2.3, to the nearest tenth?', null, md5('apprecalc-mcq-sv-031-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15.8', false, 'This is the change in output, g(2.3)−g(0.8)=15.810, with no division by the input change 1.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '10.5', true, '[g(2.3)−g(0.8)]/(2.3−0.8)=[12.834−(-2.976)]/1.5=15.810/1.5=10.540, which rounds to 10.5.' from version_ins
union all select gen_random_uuid(), id, 'C', '23.7', false, 'This multiplies the output change 15.810 by the interval length 1.5 instead of dividing: 23.715. The average rate of change divides by 1.5.' from version_ins
union all select gen_random_uuid(), id, 'D', '−10.5', false, 'This reverses the numerator: [g(0.8)−g(2.3)]/(2.3−0.8)=-15.810/1.5=-10.540, changing the sign of the rate.' from version_ins;
commit;
