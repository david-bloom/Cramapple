begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-037-v2','apprecalc-mcq-sv-037-v3','apprecalc-mcq-sv-038-v1','apprecalc-mcq-sv-038-v2','apprecalc-mcq-sv-038-v3','apprecalc-mcq-sv-040-v1','apprecalc-mcq-sv-040-v2','apprecalc-mcq-sv-040-v3','apprecalc-mcq-sv-041-v1','apprecalc-mcq-sv-041-v2','apprecalc-mcq-sv-041-v3','apprecalc-mcq-sv-043-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-037-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-037-v2', 'mcq', 'Exponential decay versus linear fit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

For x=0, 1, 2, 3, 4, a quantity has values 80, 60.4, 45.1, 34.2, 25.6. Which claim is best supported?', null, md5('apprecalc-mcq-sv-037-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A quadratic model, because the second differences are exactly constant', false, 'The first differences are −19.6, −15.3, −10.9, −8.6, and the second differences are 4.3, 4.4, 2.3, which are not constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An exponential decay model, because successive ratios are near 0.75', true, 'The ratios of each value to the previous one are about 0.755, 0.747, 0.758, 0.749, nearly constant near 0.75, which indicates exponential decay.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A linear model, because a linear regression has r² greater than 0.95', false, 'A linear fit does have r^2 = 0.973, but a high r^2 alone does not show that a linear model is the best description. The first differences are -19.6, -15.3, -10.9, -8.6, which are not constant (linear data would have constant differences), while the successive ratios are all near 0.75, so an exponential model is better supported.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An exponential growth model, because the outputs are multiplied by about 1.33 each step', false, '1.33 is about 1/0.75, the ratio of a value to the next one. Going from one value to the next multiplies by about 0.75, which is less than 1, so the model is decay, not growth.' from version_ins;
-- apprecalc-mcq-sv-037-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-037-v3', 'mcq', 'Quadratic from constant second differences', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A lab technician records a quantity at the whole-number inputs x = 0, 1, 2, 3, 4 and obtains 2, 5, 10, 17, 26. Based on these data, which claim is best supported?', null, md5('apprecalc-mcq-sv-037-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A quadratic model, because the second differences are constant', true, 'The first differences are 3, 5, 7, 9 and the second differences are 2, 2, 2, exactly constant, which indicates a quadratic model.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An exponential model, because every ratio of successive values is greater than 1', false, 'The ratios are 2.5, 2.0, 1.7, about 1.53. They are greater than 1 but steadily decreasing, not constant, so the data are not exponential.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No model, because the first differences are not constant', false, 'Non-constant first differences only rule out a linear model. The second differences 2, 2, 2 are constant, so a quadratic model fits.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A linear model, because the average rate of change over [0, 4] is 6', false, 'The average rate of change is (26−2)/4=6, but the first differences 3, 5, 7, 9 are not constant, so the data are not linear.' from version_ins;
-- apprecalc-mcq-sv-038-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-038-v1', 'mcq', 'Semi-log slope with base 2', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Points from y=ab^x lie on a line when log₂(y) is plotted against x. If the line has slope 3, what is b?', null, md5('apprecalc-mcq-sv-038-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', true, 'Since log₂(y)=log₂(a)+x·log₂(b), the slope is log₂(b)=3, so b=2³=8.' from version_ins
union all select gen_random_uuid(), id, 'B', '9', false, 'Computes 3² instead of 2³, swapping the base and the exponent.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'Uses the slope itself as b, but the slope is log₂(b), not b.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'Multiplies the base 2 by the slope 3 instead of raising 2 to the power 3.' from version_ins;
-- apprecalc-mcq-sv-038-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-038-v2', 'mcq', 'Semi-log line to exponential model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Points from y=ab^x lie on a line when log₁₀(y) is plotted against x. The line has y-intercept 2 and slope 0.3010. Use log₁₀2≈0.3010 to choose the best model for y.', null, md5('apprecalc-mcq-sv-038-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y ≈ 2·10^(0.3010x)', false, 'Uses the intercept 2 directly as a, but the intercept is log₁₀(a), so a=10²=100. (The factor 10^(0.3010x)≈2^x is handled correctly.)' from version_ins
union all select gen_random_uuid(), id, 'B', 'y ≈ 100(0.3010)^x', false, 'Finds a=10²=100 correctly but uses the slope 0.3010 directly as b, but the slope is log₁₀(b), so b=10^0.3010≈2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y ≈ 2(100)^x', false, 'Swaps the roles: uses the intercept 2 as a and 10² as b, but the intercept is log₁₀(a) so a=100, and the slope gives b≈2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y ≈ 100(2)^x', true, 'The line is log₁₀(y)=2+0.3010x. The intercept is log₁₀(a)=2, so a=100, and the slope is log₁₀(b)=0.3010, so b≈2. Thus y≈100(2)^x.' from version_ins;
-- apprecalc-mcq-sv-038-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-038-v3', 'mcq', 'Semi-log with negative slope', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Points from y=ab^x lie on a line when log₁₀(y) is plotted against x. The line has slope −0.4771. Use log₁₀3≈0.4771 to find b.', null, md5('apprecalc-mcq-sv-038-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.5229', false, 'Treats the slope as a rate, b=1+(−0.4771)=0.5229, instead of b=10^(−0.4771).' from version_ins
union all select gen_random_uuid(), id, 'B', '0.4771', false, 'Uses the magnitude of the slope as b instead of raising 10 to the slope.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'Ignores the negative sign: 10^0.4771≈3 gives the reciprocal of the correct decay factor.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/3', true, 'The slope is log₁₀(b)=−0.4771=−log₁₀3=log₁₀(1/3), so b=1/3 (exponential decay).' from version_ins;
-- apprecalc-mcq-sv-040-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-040-v1', 'mcq', 'Solve a log regression for x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A logarithmic regression is y=3.2+4.1ln(x). What x gives y=15, to the nearest tenth?', null, md5('apprecalc-mcq-sv-040-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '17.8', true, 'Subtract: 4.1ln(x)=15−3.2=11.8, so ln(x)=11.8/4.1≈2.878 and x=e^2.878≈17.78, or 17.8 to the nearest tenth.' from version_ins
union all select gen_random_uuid(), id, 'B', '755.2', false, 'Finds ln(x)≈2.878 correctly but undoes ln with base 10: 10^2.878≈755.2. The inverse of ln is e^( ), not 10^( ).' from version_ins
union all select gen_random_uuid(), id, 'C', '38.8', false, 'Skips subtracting 3.2 and divides 15 by 4.1 first: ln(x)=15/4.1≈3.659, so x=e^3.659≈38.8.' from version_ins
union all select gen_random_uuid(), id, 'D', '84.7', false, 'Adds 3.2 instead of subtracting: ln(x)=(15+3.2)/4.1≈4.439, so x=e^4.439≈84.7.' from version_ins;
-- apprecalc-mcq-sv-040-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-040-v2', 'mcq', 'Solve exponential model for time', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A population model is P(t)=12e^(0.07t), where t is in years. At what time t is P(t)=50, to the nearest tenth?', null, md5('apprecalc-mcq-sv-040-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.9', false, 'Finds 50/12 correctly but undoes the exponential e^( ) with log₁₀ instead of ln: log₁₀(50/12)/0.07≈8.9.' from version_ins
union all select gen_random_uuid(), id, 'B', '55.9', false, 'Takes the log of both sides without handling the factor 12, writing 0.07t = ln 50, so t = ln(50)/0.07 = 55.9. But ln(12e^(0.07t)) = ln 12 + 0.07t, so the 12 must be divided out first. Check: P(55.9) = 12e^(3.913) is about 600, not 50.' from version_ins
union all select gen_random_uuid(), id, 'C', '52.0', false, 'Subtracts 12 instead of dividing by it: 0.07t=ln(38)≈3.638, so t≈52.0.' from version_ins
union all select gen_random_uuid(), id, 'D', '20.4', true, 'Divide by 12: e^(0.07t)=50/12, so 0.07t=ln(50/12)≈1.427 and t≈20.39, or 20.4.' from version_ins;
-- apprecalc-mcq-sv-040-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-040-v3', 'mcq', 'Log model with negative coefficient', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A model is y=7.5−2.4ln(x). What x gives y=3, to the nearest tenth?', null, md5('apprecalc-mcq-sv-040-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.5', true, 'Subtract 7.5: −2.4ln(x)=3−7.5=−4.5, so ln(x)=4.5/2.4=1.875 and x=e^1.875≈6.52, or 6.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '79.4', false, 'Makes two sign errors: adds 7.5 instead of subtracting it and also drops the negative sign on -2.4, giving ln(x) = (3 + 7.5)/2.4 = 4.375 and x = e^4.375, about 79.4.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.2', false, 'Divides by 2.4 but loses the sign of the coefficient: ln(x)=(3−7.5)/2.4=−1.875, so x=e^(−1.875)≈0.153, or 0.2.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.5', false, 'Ignores the constant 7.5 and also drops the negative sign on -2.4, giving ln(x) = 3/2.4 = 1.25 and x = e^1.25, about 3.5.' from version_ins;
-- apprecalc-mcq-sv-041-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-041-v1', 'mcq', 'Exact sin(4π/3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A point P on the unit circle is found by rotating counterclockwise from (1, 0) through an angle of 4π/3 radians. What is the exact y-coordinate of P, which equals sin(4π/3)?', null, md5('apprecalc-mcq-sv-041-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1/2', false, 'This is cos(4π/3)=−cos(π/3)=−1/2, the value of the wrong function (it has the correct negative sign).' from version_ins
union all select gen_random_uuid(), id, 'B', '−√3/2', true, '4π/3 is in quadrant III with reference angle π/3, where sine is negative: sin(4π/3)=−sin(π/3)=−√3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', false, 'This is cos(π/3)=1/2, the cosine reference value with the sign dropped; sin(4π/3) is neither 1/2 nor positive.' from version_ins
union all select gen_random_uuid(), id, 'D', '√3/2', false, 'Uses the correct magnitude sin(π/3)=√3/2 but ignores that sine is negative in quadrant III.' from version_ins;
-- apprecalc-mcq-sv-041-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-041-v2', 'mcq', 'Exact cos(11π/6)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Using reference angles, evaluate cos(11π/6) exactly. Which choice gives the correct value?', null, md5('apprecalc-mcq-sv-041-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', false, 'Uses the sine reference value sin(π/6)=1/2 for the magnitude, but cos(π/6)=√3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−√3/2', false, 'Uses the correct magnitude but assigns a negative sign; cosine is positive in quadrant IV.' from version_ins
union all select gen_random_uuid(), id, 'C', '√3/2', true, '11π/6 is in quadrant IV with reference angle π/6, where cosine is positive: cos(11π/6)=cos(π/6)=√3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2', false, 'This is sin(11π/6)=−sin(π/6)=−1/2, the value of the wrong function.' from version_ins;
-- apprecalc-mcq-sv-041-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-041-v3', 'mcq', 'Exact cos(−2π/3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A student rotates clockwise from the point (1, 0) on the unit circle through 2π/3 radians. Which choice gives the exact x-coordinate of the point reached, namely cos(−2π/3)?', null, md5('apprecalc-mcq-sv-041-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3/2', false, 'This is sin(2π/3)=√3/2, the sine of the positive angle, not the cosine of −2π/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2', false, 'Applies the odd-function rule cos(−θ)=−cos(θ) to get −(−1/2)=1/2, but cosine is even, not odd.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/2', true, 'Cosine is even, so cos(−2π/3)=cos(2π/3). The angle 2π/3 is in quadrant II with reference angle π/3, so cos(2π/3)=−cos(π/3)=−1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−√3/2', false, 'This is sin(−2π/3)=−sin(2π/3)=−√3/2, the value of the wrong function.' from version_ins;
-- apprecalc-mcq-sv-043-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-043-v1', 'mcq', 'Cosine with a minimum at x=0', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Which function has midline y=2, amplitude 5, period 6, and a minimum at x=0?', null, md5('apprecalc-mcq-sv-043-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−5cos(πx/6)+2', false, 'Uses b=π/6, which gives period 2π/(π/6)=12, not 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5cos(6x)+2', false, 'Uses b equal to the period 6 instead of 2π/6; its period is 2π/6=π/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5cos(πx/3)+2', true, 'With b=2π/6=π/3 the period is 6. The reflection −5cos gives a minimum at x=0: −5+2=−3, with midline 2 and amplitude 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '5cos(πx/3)+2', false, 'Has the right midline, amplitude and period but a maximum at x=0 (value 7), not a minimum.' from version_ins;
commit;
