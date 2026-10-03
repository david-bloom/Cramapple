begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-031-v2','apprecalc-mcq-sv-031-v3','apprecalc-mcq-sv-032-v1','apprecalc-mcq-sv-032-v2','apprecalc-mcq-sv-032-v3','apprecalc-mcq-sv-034-v1','apprecalc-mcq-sv-034-v2','apprecalc-mcq-sv-034-v3','apprecalc-mcq-sv-035-v3','apprecalc-mcq-sv-036-v1','apprecalc-mcq-sv-036-v3','apprecalc-mcq-sv-037-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-031-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-031-v2', 'mcq', 'Average rate of change of a quartic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

For h(x)=x⁴−3x³+x, what is the average rate of change from x=1.4 to x=3.1, to the nearest tenth?', null, md5('apprecalc-mcq-sv-031-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.9', false, 'This divides the output change 9.0695 by the right endpoint 3.1 instead of the interval length 1.7: 2.9256.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.3', true, '[h(3.1)−h(1.4)]/(3.1−1.4)=[6.0791−(-2.9904)]/1.7=9.0695/1.7=5.3350, which rounds to 5.3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5.3', false, 'This reverses the numerator: [h(1.4)−h(3.1)]/(3.1−1.4)=-9.0695/1.7=-5.3350, changing the sign.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.1', false, 'This is the change in output, h(3.1)−h(1.4)=9.0695, with no division by the input change 1.7.' from version_ins;
-- apprecalc-mcq-sv-031-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-031-v3', 'mcq', 'Average rate of change of a drone''s height', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

A drone''s height (in meters) t seconds after launch is d(t)=0.2t⁴−1.5t²+3t. What is the average rate of change of its height from t=0.5 to t=2.5, in meters per second, to the nearest tenth?', null, md5('apprecalc-mcq-sv-031-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2.4', false, 'This reverses the numerator: [d(0.5)−d(2.5)]/2=-4.8000/2=-2.4000, changing the sign.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.5', false, 'This averages the two heights, (1.1375+5.9375)/2=3.5375, which is a mean height, not a rate of change.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.4', true, '[d(2.5)−d(0.5)]/(2.5−0.5)=[5.9375−1.1375]/2=4.8000/2=2.4000, which rounds to 2.4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.8', false, 'This is the change in height, d(2.5)−d(0.5)=4.8000, with no division by the elapsed time 2.' from version_ins;
-- apprecalc-mcq-sv-032-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-032-v1', 'mcq', 'Decay factor below 1', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

Consider f(x)=400(0.85)^x. Which statement correctly describes the change in f each time x increases by 1?', null, md5('apprecalc-mcq-sv-032-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is reduced by 15%', true, 'The growth factor is 0.85=1−0.15, so each unit of x multiplies f by 0.85, a 15% decrease.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is raised by 15%', false, 'The factor 0.85 is less than 1, so the outputs shrink. A 15% increase would use a factor of 1.15.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has 0.15 subtracted from it', false, 'The change is multiplicative, not additive. Each unit multiplies f by 0.85, so the amount lost shrinks as f gets smaller.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is reduced by 85%', false, 'This uses the whole factor as the percent change. Multiplying by 0.85 keeps 85% of the value, so the decrease is 100%−85%=15%.' from version_ins;
-- apprecalc-mcq-sv-032-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-032-v2', 'mcq', 'Small growth rate as a percent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

For g(x)=5(1.035)^x, which statement is true?', null, md5('apprecalc-mcq-sv-032-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g increases by a constant amount of 0.035 per unit', false, 'The change is multiplicative: each unit multiplies g by 1.035. The amount added grows as g grows (for example, 5(0.035)=0.175 from x=0 to x=1, but more later).' from version_ins
union all select gen_random_uuid(), id, 'B', 'g increases by 35% per unit', false, 'This misplaces the decimal: 0.035 is 3.5%, not 35%. A 35% increase would use the factor 1.35.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g increases by 3.5% per unit', true, 'The factor is 1.035=1+0.035, and 0.035 as a percent is 3.5%, so g increases by 3.5% per unit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g increases by 103.5% per unit', false, 'This uses the entire factor 1.035 as the percent change. The factor includes the original 100%, so the increase is 1.035−1=0.035, or 3.5%.' from version_ins;
-- apprecalc-mcq-sv-032-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-032-v3', 'mcq', 'Medication decay in context', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

The amount of a medication in the bloodstream is modeled by A(t)=80(0.6)^t, where A is in milligrams and t is in hours. Which statement is true?', null, md5('apprecalc-mcq-sv-032-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The amount decreases by 60% each hour', false, 'This uses the whole factor as the percent decrease. Multiplying by 0.6 keeps 60% of the amount, so 40% is lost.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The amount decreases by 32 mg each hour, which is 40% of 80 mg', false, 'This takes 40% of the initial 80 mg as a fixed hourly loss. The 40% applies to the current amount: the loss from t=0 to t=1 is 32 mg, but from t=1 to t=2 it is 40% of 48, or 19.2 mg.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The amount decreases by 0.4 mg each hour', false, 'This treats the 0.4 as a constant amount subtracted each hour. The change is multiplicative: the amount is multiplied by 0.6 each hour.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The amount decreases by 40% each hour', true, 'The factor 0.6=1−0.4, so each hour the amount is multiplied by 0.6, which is a 40% decrease.' from version_ins;
-- apprecalc-mcq-sv-034-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-034-v1', 'mcq', 'Product of logs equation, base 2', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

A student combines two logarithms with the same base and then rewrites the result in exponential form. Solving log₂(x) + log₂(x − 2) = 3, which value of x is the solution?', null, md5('apprecalc-mcq-sv-034-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=5', false, 'Adds the arguments, x+(x−2)=2³=8, so 2x=10 and x=5, treating log₂A+log₂B as log₂(A+B). Check: log₂5+log₂3=log₂15, which is not 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=4', true, 'By the product property, log₂[x(x−2)]=3, so x(x−2)=2³=8, giving x²−2x−8=0 and (x−4)(x+2)=0. The root x=−2 makes log₂(x) undefined, so it is rejected. Check x=4: log₂4+log₂2=2+1=3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=3', false, 'Sets x(x−2)=3 (using the right side 3 as the argument instead of 2³=8), so x²−2x−3=0 and (x−3)(x+1)=0, with x=3 valid for the domain. Check: log₂3+log₂1=log₂3≈1.585, not 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=−2', false, 'Solves x²−2x−8=0 correctly to get x=4 or x=−2 but keeps the negative root. At x=−2 both log₂(−2) and log₂(−4) are undefined, so −2 is extraneous.' from version_ins;
-- apprecalc-mcq-sv-034-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-034-v2', 'mcq', 'Quotient of logs equation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

What is the solution to log₂(x+10)−log₂(x−2)=2?', null, md5('apprecalc-mcq-sv-034-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=4', false, 'Sets (x+10)/(x−2)=4 correctly but distributes incorrectly, 4(x−2)=4x−2 instead of 4x−8, so x+10=4x−2 and x=4. Check: log₂14−log₂2=log₂7≈2.81, not 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=−14', false, 'Inverts the ratio, (x−2)/(x+10)=4, so x−2=4x+40 and x=−14. This is outside the domain because x+10=−4 and x−2=−16 are negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=14', false, 'Sets (x+10)/(x−2)=2 (using the right side 2 as the ratio instead of 2²=4), so x+10=2x−4 and x=14. Check: log₂24−log₂12=log₂2=1, not 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=6', true, 'The difference of logs is log₂[(x+10)/(x−2)]=2, so (x+10)/(x−2)=2²=4. Then x+10=4x−8, so 3x=18 and x=6. Check: log₂16−log₂4=4−2=2.' from version_ins;
-- apprecalc-mcq-sv-034-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-034-v3', 'mcq', 'Log equation with extraneous root', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

To solve the equation log₃(x + 1) + log₃(x + 3) = 1 for x, a student applies the product property of logarithms and rewrites it exponentially. Which choice gives the solution?', null, md5('apprecalc-mcq-sv-034-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x=0', true, 'By the product property, (x+1)(x+3)=3¹=3, so x²+4x+3=3 and x(x+4)=0. The root x=−4 makes x+1=−3 negative and is rejected. Check x=0: log₃1+log₃3=0+1=1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x=−1/2', false, 'Adds the arguments, (x+1)+(x+3)=3, so 2x=−1 and x=−1/2, treating log₃A+log₃B as log₃(A+B). Check: log₃(1/2)+log₃(5/2)=log₃(5/4), which is not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x=−4', false, 'This is a root of x²+4x=0 but it is extraneous: at x=−4 the arguments x+1=−3 and x+3=−1 are negative, so the logarithms are undefined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x=−2+√2', false, 'Sets (x+1)(x+3)=1 (using the right side 1 as the argument instead of 3¹=3), so x²+4x+2=0 and x=−2±√2, and −2+√2≈−0.586 is in the domain. Check: the product (x+1)(x+3)=1, so the sum of logs is log₃1=0, not 1.' from version_ins;
-- apprecalc-mcq-sv-035-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-035-v3', 'mcq', 'Inverse with exponent coefficient', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

If f(x)=2^(3x)+1, which formula gives f⁻¹(x)?', null, md5('apprecalc-mcq-sv-035-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3log₂(x−1)', false, 'Multiplies by 3 instead of dividing by 3 after taking the log. Check: 3log₂(9−1)=3(3)=9, not 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '(1/3)log₂(x)−1', false, 'Subtracts 1 after taking the log instead of before. Check: (1/3)log₂9−1≈1.057−1≈0.06, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '(1/3)log₂(x−1)', true, 'Set y=2^(3x)+1. Then y−1=2^(3x), so 3x=log₂(y−1) and x=(1/3)log₂(y−1). Check: f(1)=8+1=9 and (1/3)log₂(9−1)=(1/3)(3)=1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₂(x−1)−3', false, 'Subtracts 3 instead of dividing by 3. Check: log₂(9−1)−3=3−3=0, not 1.' from version_ins;
-- apprecalc-mcq-sv-036-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-036-v1', 'mcq', 'Composition of quadratic and linear', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

If f(x)=x²−3 and g(x)=3x+1, what is (f∘g)(x)?', null, md5('apprecalc-mcq-sv-036-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9x²−2', false, 'Substitutes correctly but squares 3x+1 as 9x²+1, dropping the middle term 6x, so (3x+1)²−3 becomes 9x²+1−3=9x²−2.' from version_ins
union all select gen_random_uuid(), id, 'B', '3(x²−3)+1', false, 'This is g(f(x))=3(x²−3)+1=3x²−8, the composition in the opposite order.' from version_ins
union all select gen_random_uuid(), id, 'C', '(x²−3)(3x+1)', false, 'Multiplies f(x) and g(x) instead of composing them.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3x+1)²−3', true, '(f∘g)(x)=f(g(x)), so substitute g(x)=3x+1 for x in f: (3x+1)²−3.' from version_ins;
-- apprecalc-mcq-sv-036-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-036-v3', 'mcq', 'Evaluating a composition at a point', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'No calculator is permitted.

If f(x)=1/(x−2) and g(x)=2x+1, what is (f∘g)(3)?', null, md5('apprecalc-mcq-sv-036-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/5', true, 'g(3)=2(3)+1=7, then f(7)=1/(7−2)=1/5.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This is g(3), the inner function only; the outer function f is never applied.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This is (g∘f)(3): f(3)=1/(3−2)=1 and g(1)=2(1)+1=3, the composition in the opposite order.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/7', false, 'Computes g(3)=7 but then takes 1/7, forgetting that f subtracts 2 in its denominator: f(7)=1/(7−2), not 1/7.' from version_ins;
-- apprecalc-mcq-sv-037-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-037-v1', 'mcq', 'Model selection from near-linear data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calculator use is permitted.

For x=0, 1, 2, 3, 4, a measured quantity has values 5.0, 8.1, 10.9, 14.0, 17.1. Which claim is best supported?', null, md5('apprecalc-mcq-sv-037-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An exponential model, because every ratio of successive values is greater than 1', false, 'The ratios are about 1.62, 1.35, 1.28, 1.22. They are all greater than 1, but they keep decreasing rather than staying nearly constant, so the data do not support an exponential model.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A linear model, because the first differences are all close to 3', true, 'The first differences are 3.1, 2.8, 3.1, 3.1, all close to 3, so the data are well modeled by a linear function with slope about 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A quadratic model, because the second differences are exactly constant', false, 'The second differences are −0.3, 0.3, 0.0, which are not equal, and they are small noise around 0 (consistent with a linear pattern).' from version_ins
union all select gen_random_uuid(), id, 'D', 'No model, because the first differences are not all identical', false, 'Measured data rarely give identical differences. The differences 3.1, 2.8, 3.1, 3.1 are nearly constant, which supports a linear model.' from version_ins;
commit;
