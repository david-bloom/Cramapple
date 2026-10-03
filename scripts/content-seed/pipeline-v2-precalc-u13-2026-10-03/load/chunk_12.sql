begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-np2-007-v2','apprecalc-mcq-sv-np2-007-v3','apprecalc-mcq-sv-np2-008-v1','apprecalc-mcq-sv-np2-008-v2','apprecalc-mcq-sv-np2-008-v3','apprecalc-mcq-sv-np2-009-v1','apprecalc-mcq-sv-np2-009-v2','apprecalc-mcq-sv-np2-009-v3','apprecalc-mcq-sv-np2-010-v1','apprecalc-mcq-sv-np2-010-v2','apprecalc-mcq-sv-np2-010-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-np2-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-007-v2', 'mcq', 'Sine of a negative angle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the exact value of sin(−3π/4)?', null, md5('apprecalc-mcq-sv-np2-007-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√2/2', false, 'This ignores the negative sign of the angle and computes sin(3π/4) = √2/2. Since sine is odd, sin(−3π/4) = −sin(3π/4) = −√2/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−√2/2', true, 'The angle −3π/4 is measured clockwise and ends in the third quadrant, with reference angle π/4. Sine is negative there, so sin(−3π/4) = −sin(π/4) = −√2/2. Equivalently, sin(−3π/4) = −sin(3π/4) = −√2/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−√3/2', false, 'The sign is right, but √3/2 is a reference value for π/3, not π/4. The reference angle here is π/4, with sine value √2/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '√3/2', false, 'This both uses the π/3 reference value (√3/2) instead of the π/4 value (√2/2) and drops the negative sign.' from version_ins;
-- apprecalc-mcq-sv-np2-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-007-v3', 'mcq', 'Unit circle point for an angle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A point P starts at (1, 0) on the unit circle and moves counterclockwise through an angle of 4π/3. What are the coordinates of P?', null, md5('apprecalc-mcq-sv-np2-007-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(1/2, √3/2)', false, 'This is the point for angle π/3, the reference angle, without the signs from the third quadrant. Both coordinates are negative for 4π/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−1/2, −√3/2)', true, 'The terminal side of 4π/3 is in the third quadrant with reference angle π/3. P = (cos(4π/3), sin(4π/3)) = (−cos(π/3), −sin(π/3)) = (−1/2, −√3/2).' from version_ins
union all select gen_random_uuid(), id, 'C', '(−1/2, √3/2)', false, 'This is the point for 2π/3 (second quadrant). For 4π/3, which is in the third quadrant, the y-coordinate is negative: sin(4π/3) = −√3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−√3/2, −1/2)', false, 'This swaps the coordinates, using sine for the x-coordinate and cosine for the y-coordinate. For π/3, cos = 1/2 and sin = √3/2, so P = (−1/2, −√3/2).' from version_ins;
-- apprecalc-mcq-sv-np2-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-008-v1', 'mcq', 'Polar to rectangular with negative r (5π/6)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Convert the polar coordinates (r, θ) = (−6, 5π/6) to rectangular coordinates.', null, md5('apprecalc-mcq-sv-np2-008-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(3√3, −3)', true, 'x = r·cosθ = −6·(−√3/2) = 3√3, and y = r·sinθ = −6·(1/2) = −3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−3, 3√3)', false, 'This swaps the coordinates by using x = r·sinθ = −6·(1/2) = −3 and y = r·cosθ = −6·(−√3/2) = 3√3. The correct formulas are x = r·cosθ and y = r·sinθ.' from version_ins
union all select gen_random_uuid(), id, 'C', '(3√3, 3)', false, 'This applies the negative sign of r to x but not to y: x = −6·(−√3/2) = 3√3 is right, but y = r·sinθ = −6·(1/2) = −3, not +3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−3√3, 3)', false, 'This treats r as +6 and ignores the negative sign: x = 6·(−√3/2) = −3√3, y = 6·(1/2) = 3. With r = −6, both coordinates change sign.' from version_ins;
-- apprecalc-mcq-sv-np2-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-008-v2', 'mcq', 'Polar to rectangular in quadrant IV', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which point, in rectangular coordinates, is the polar point (r, θ) = (8, 11π/6)?', null, md5('apprecalc-mcq-sv-np2-008-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−4, 4√3)', false, 'This uses x = r·sinθ = 8·(−1/2) = −4 and y = r·cosθ = 8·(√3/2) = 4√3, swapping the roles of cosine and sine.' from version_ins
union all select gen_random_uuid(), id, 'B', '(4√3, −4)', true, '11π/6 is in the fourth quadrant with reference angle π/6. x = 8·cos(11π/6) = 8·(√3/2) = 4√3, and y = 8·sin(11π/6) = 8·(−1/2) = −4.' from version_ins
union all select gen_random_uuid(), id, 'C', '(4, −4√3)', false, 'This uses 1/2 as the cosine of π/6 and √3/2 as the sine: x = 8·(1/2) = 4, y = 8·(−√3/2) = −4√3. The reference values are reversed; cos(π/6) = √3/2 and sin(π/6) = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(4√3, 4)', false, 'This uses the sine reference value 1/2 without its negative sign: y = 8·(1/2) = 4. Sine is negative in the fourth quadrant, so y = 8·(−1/2) = −4.' from version_ins;
-- apprecalc-mcq-sv-np2-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-008-v3', 'mcq', 'Polar to rectangular with negative irrational r', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which point, in rectangular coordinates, is the polar point (−4√2, 3π/4)?', null, md5('apprecalc-mcq-sv-np2-008-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−4, 4)', false, 'This ignores the negative sign of r and uses r = 4√2: x = 4√2·(−√2/2) = −4, y = 4√2·(√2/2) = 4. With r = −4√2 both coordinates change sign.' from version_ins
union all select gen_random_uuid(), id, 'B', '(4, −4)', true, 'x = r·cosθ = −4√2·(−√2/2) = 4, and y = r·sinθ = −4√2·(√2/2) = −4.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−4, −4)', false, 'This applies the negative sign of r to y only: y = −4√2·(√2/2) = −4 is right, but x = −4√2·(−√2/2) = 4, not −4.' from version_ins
union all select gen_random_uuid(), id, 'D', '(4, 4)', false, 'This applies the negative sign of r to x only: x = −4√2·(−√2/2) = 4 is right, but y = −4√2·(√2/2) = −4, not 4.' from version_ins;
-- apprecalc-mcq-sv-np2-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-009-v1', 'mcq', 'Degree from fourth differences', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is evaluated at equally spaced inputs x = 0, 1, 2, 3, 4, 5, giving outputs 0, 1, 16, 81, 256, 625. What is the minimum degree of a polynomial that could model these outputs?', null, md5('apprecalc-mcq-sv-np2-009-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'First differences: 1, 15, 65, 175, 369. Second: 14, 50, 110, 194. Third: 36, 60, 84. Fourth: 24, 24. The fourth differences are the first constant ones, so the minimum degree is 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'Degree 5 is not needed. Any six points can be fit by some polynomial of degree at most 5, but the minimum degree is set by the first constant row of differences. Here the outputs equal x^4 and the fourth differences are already constant (24, 24), so degree 4 suffices.' from version_ins
union all select gen_random_uuid(), id, 'C', '24', false, '24 is the value of the constant fourth difference, not the degree. The degree equals the number of the difference level that is constant, which is 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'The third differences are 36, 60, 84, which are not constant, so a cubic cannot fit. The constant differences first appear at the fourth level (24, 24).' from version_ins;
-- apprecalc-mcq-sv-np2-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-009-v2', 'mcq', 'Degree from second differences', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The outputs of a function at equally spaced inputs x = 1, 2, 3, 4, 5 are 5, 8, 15, 26, 41. What is the minimum degree of a polynomial that could model these outputs?', null, md5('apprecalc-mcq-sv-np2-009-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, '5 is the number of data points, which does not determine the degree. The first constant differences appear at the second level (4, 4, 4), so the degree is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'A degree-1 polynomial has constant first differences. Here the first differences 3, 7, 11, 15 keep growing (by 4 each time), so the data are not linear.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, '4 is the value of the constant second difference, not the degree. The second differences are the first constant ones, so the degree is 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'First differences: 3, 7, 11, 15 (not constant). Second differences: 4, 4, 4 (constant). Constant second differences mean the minimum degree is 2.' from version_ins;
-- apprecalc-mcq-sv-np2-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-009-v3', 'mcq', 'Degree from a list of first differences', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The first differences of a function''s outputs at equally spaced inputs are 4, 3, 6, 13, 24, 39. What is the minimum degree of a polynomial that could model the function?', null, md5('apprecalc-mcq-sv-np2-009-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, '5 is one fewer than the 6 listed values, but the degree is not found by counting entries. The first constant differences appear at the third level for the outputs (4, 4, 4, 4), so the degree is 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Taking differences of the given first differences gives the second differences of the outputs: −1, 3, 7, 11, 15. Differences of those give the third differences of the outputs: 4, 4, 4, 4, which are constant. So the minimum degree is 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This treats the given list as the outputs: its second differences are constant (4, 4, 4, 4), suggesting degree 2. But the list is already the first differences of the outputs, so one more level of differences is needed, giving degree 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, '4 is the value of the constant difference, not the degree. The constant level is the third differences of the outputs, so the degree is 3.' from version_ins;
-- apprecalc-mcq-sv-np2-010-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-010-v1', 'mcq', 'Where secant is undefined', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For which value of x is sec(x) undefined?', null, md5('apprecalc-mcq-sv-np2-010-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π', false, 'cos(π) = −1, so sec(π) = −1 is defined. sin(π) = 0, which is where csc and cot are undefined, not sec.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2π/3', false, 'cos(2π/3) = −1/2 ≠ 0, so sec(2π/3) = −2 is defined.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 5π/4', false, 'cos(5π/4) = −√2/2 ≠ 0, so sec(5π/4) = −√2 is defined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 3π/2', true, 'sec(x) = 1/cos(x) is undefined where cos(x) = 0, and cos(3π/2) = 0.' from version_ins;
-- apprecalc-mcq-sv-np2-010-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-010-v2', 'mcq', 'Where cotangent is undefined', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For which value of x is cot(x) undefined?', null, md5('apprecalc-mcq-sv-np2-010-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 7π/6', false, 'sin(7π/6) = −1/2 ≠ 0, so cot(7π/6) = (−√3/2)/(−1/2) = √3 is defined.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/2', false, 'cos(π/2) = 0 and sin(π/2) = 1, so cot(π/2) = 0/1 = 0, which is defined. π/2 is where tan is undefined, not cot.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 2π', true, 'cot(x) = cos(x)/sin(x) is undefined where sin(x) = 0, and sin(2π) = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 3π/4', false, 'sin(3π/4) = √2/2 ≠ 0, so cot(3π/4) = (−√2/2)/(√2/2) = −1 is defined.' from version_ins;
-- apprecalc-mcq-sv-np2-010-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-np2-010-v3', 'mcq', 'Where sec(2x) is undefined', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For which value of x is sec(2x) undefined?', null, md5('apprecalc-mcq-sv-np2-010-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 0', false, 'cos(2·0) = cos(0) = 1, so sec(0) = 1 is defined. x = 0 is where sine is zero, which affects csc, not sec.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/4', true, 'sec(2x) = 1/cos(2x) is undefined where cos(2x) = 0. At x = π/4, 2x = π/2 and cos(π/2) = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/2', false, 'This solves cos(x) = 0 and ignores the factor of 2. At x = π/2, 2x = π and cos(π) = −1, so sec(π) = −1 is defined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = π', false, 'This multiplies by 2 instead of dividing: setting 2x = π/2 gives x = π/4, not x = 2·(π/2) = π. At x = π, 2x = 2π and sec(2π) = 1 is defined.' from version_ins;
commit;
