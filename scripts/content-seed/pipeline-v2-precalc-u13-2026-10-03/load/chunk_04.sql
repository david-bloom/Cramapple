begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-014-v2','apprecalc-mcq-sv-014-v3','apprecalc-mcq-sv-015-v1','apprecalc-mcq-sv-015-v2','apprecalc-mcq-sv-015-v3','apprecalc-mcq-sv-016-v1','apprecalc-mcq-sv-016-v2','apprecalc-mcq-sv-016-v3','apprecalc-mcq-sv-017-v1','apprecalc-mcq-sv-017-v2','apprecalc-mcq-sv-017-v3','apprecalc-mcq-sv-018-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-014-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-014-v2', 'mcq', 'Domain of ln of a quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the domain of f(x) = ln(x² − x − 6)?', null, md5('apprecalc-mcq-sv-014-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2 < x < 3', false, 'This is where (x − 3)(x + 2) < 0. At x = 0 the argument is −6, which is negative, so ln is undefined there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x < −2 or x > 3', true, 'x² − x − 6 = (x − 3)(x + 2). The product is positive when both factors have the same sign, which gives x < −2 or x > 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x ≤ −2 or x ≥ 3', false, 'Includes the endpoints, but at x = 3 the argument is 9 − 3 − 6 = 0, and ln(0) is undefined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x < −3 or x > 2', false, 'Factors as (x + 3)(x − 2), which expands to x² + x − 6, not x² − x − 6. At x = 2.5 the argument is 6.25 − 2.5 − 6 = −2.25, which is negative.' from version_ins;
-- apprecalc-mcq-sv-014-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-014-v3', 'mcq', 'Domain of ln of a rational expression', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the domain of k(x) = ln((x + 1)/(x − 5))?', null, md5('apprecalc-mcq-sv-014-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x > −1 and x ≠ 5', false, 'Requires only the numerator to be positive. At x = 0 the argument is −1/5, which is negative, so 0 is not in the domain.' from version_ins
union all select gen_random_uuid(), id, 'B', 'all real numbers except −1 and 5', false, 'Excludes only the input that makes the argument 0 and the input that makes the denominator 0. The argument can also be negative, for example at x = 0 where it is −1/5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x < −1 or x > 5', true, 'The fraction (x + 1)/(x − 5) must be positive, so the numerator and denominator have the same sign: both positive gives x > 5, both negative gives x < −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1 < x < 5', false, 'This is where the fraction is negative. At x = 0 the argument is 1/(−5) = −1/5, so ln is undefined.' from version_ins;
-- apprecalc-mcq-sv-015-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-015-v1', 'mcq', 'Gate rotation in radians', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rotating gate turns through an angle of 210°. What is this angle in radians?', null, md5('apprecalc-mcq-sv-015-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6π/7', false, 'Inverts the ratio: uses 180/210 = 6/7 and attaches π to get 6π/7.' from version_ins
union all select gen_random_uuid(), id, 'B', '7π/6', true, 'Multiplying by π/180 gives 210π/180 = 7π/6.' from version_ins
union all select gen_random_uuid(), id, 'C', '7π/12', false, 'Multiplies by π/360 instead of π/180: 210·π/360 = 7π/12, half the correct measure.' from version_ins
union all select gen_random_uuid(), id, 'D', '7π/3', false, 'Multiplies by π/90 instead of π/180: 210·π/90 = 7π/3, twice the correct measure.' from version_ins;
-- apprecalc-mcq-sv-015-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-015-v2', 'mcq', 'Turntable angle in radians', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A turntable rotates through 135°. Which is the equivalent angle measure in radians?', null, md5('apprecalc-mcq-sv-015-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4π/3', false, 'Inverts the ratio: 180/135 = 4/3, so 4π/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '135π', false, 'Multiplies by π but forgets to divide by 180, giving 135π.' from version_ins
union all select gen_random_uuid(), id, 'C', '3π/8', false, 'Multiplies by π/360 instead of π/180: 135·π/360 = 3π/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '3π/4', true, 'Multiplying by π/180 gives 135π/180 = 3π/4.' from version_ins;
-- apprecalc-mcq-sv-015-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-015-v3', 'mcq', 'Negative angle to radians', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A clockwise rotation of 120° is represented by the angle −120°. What is −120° in radians?', null, md5('apprecalc-mcq-sv-015-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2π/3', false, 'Converts the magnitude correctly but drops the negative sign, which indicates clockwise rotation.' from version_ins
union all select gen_random_uuid(), id, 'B', '−π/3', false, 'Multiplies by π/360 instead of π/180: −120·π/360 = −π/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2π/3', true, 'Multiplying by π/180 gives −120π/180 = −2π/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3π/2', false, 'Inverts the ratio: 180/120 = 3/2, giving −3π/2.' from version_ins;
-- apprecalc-mcq-sv-016-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-016-v1', 'mcq', 'Tide model amplitude and midline', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height of the tide in a harbor is modeled by a sinusoidal function with maximum 7.4 m, minimum 1.2 m, and period 12.4 hours. What are the amplitude and the midline of the model?', null, md5('apprecalc-mcq-sv-016-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.3 and y=3.1', false, 'Interchanges the two quantities: the amplitude is 3.1 and the midline is y = 4.3.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.1 and y=7.4', false, 'Gets the amplitude right, 3.1, but takes the maximum, 7.4, as the midline. The midline is the average of the maximum and minimum, 4.3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.1 and y=4.3', true, 'Amplitude is half the range: (7.4 − 1.2)/2 = 3.1. The midline is the average of the extremes: (7.4 + 1.2)/2 = 4.3.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.2 and y=4.3', false, 'Uses the full range, 7.4 − 1.2 = 6.2, as the amplitude. Amplitude is half the range, 3.1.' from version_ins;
-- apprecalc-mcq-sv-016-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-016-v2', 'mcq', 'Amplitude and midline from extremes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function f has a minimum value of −2 and a maximum value of 10. Which gives its amplitude and its midline?', null, md5('apprecalc-mcq-sv-016-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4 and y=6', false, 'Interchanges the two quantities: the amplitude is 6 and the midline is y = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 and y=4', true, 'Amplitude is half the range: (10 − (−2))/2 = 6. The midline is the average: (10 + (−2))/2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 and y=4', false, 'Uses the full range, 10 − (−2) = 12, as the amplitude. Amplitude is half of that, 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '6 and y=8', false, 'Gets the amplitude right, but finds the midline as the sum 10 + (−2) = 8 without dividing by 2. The midline is 8/2 = 4.' from version_ins;
-- apprecalc-mcq-sv-016-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-016-v3', 'mcq', 'Amplitude and midline from two points', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function has a highest point at (0.5, 9). The next lowest point to its right is (3.5, 1). Which gives the amplitude and the midline?', null, md5('apprecalc-mcq-sv-016-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8 and y=5', false, 'Uses the full vertical distance, 9 − 1 = 8, as the amplitude. Amplitude is half of that, 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 and y=5', false, 'Uses the horizontal distance between the points, 3.5 − 0.5 = 3, as the amplitude. Amplitude is measured vertically and equals 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '5 and y=4', false, 'Interchanges the two quantities: the amplitude is 4 and the midline is y = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 and y=5', true, 'Amplitude is half the vertical distance between the extremes: (9 − 1)/2 = 4. The midline is y = (9 + 1)/2 = 5.' from version_ins;
-- apprecalc-mcq-sv-017-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-017-v1', 'mcq', 'Cosine equation on [0, 2π)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x < 2π, which gives all solutions of 2cos x = −√2?', null, md5('apprecalc-mcq-sv-017-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/4 and 7π/4', false, 'These are the solutions of cos x = +√2/2. The negative sign on the right side was dropped.' from version_ins
union all select gen_random_uuid(), id, 'B', '3π/4 and 5π/4', true, 'cos x = −√2/2. Cosine is negative in Quadrants II and III, where the reference angle π/4 gives x = π − π/4 = 3π/4 and x = π + π/4 = 5π/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '5π/6 and 7π/6', false, 'These have cosine −√3/2, from using the reference angle π/6 instead of π/4. cos(5π/6) = −√3/2 ≈ −0.866, not −√2/2 ≈ −0.707.' from version_ins
union all select gen_random_uuid(), id, 'D', '3π/4 and 7π/4', false, 'Pairs Quadrant II with Quadrant IV, but cosine is positive in Quadrant IV: cos(7π/4) = +√2/2, not −√2/2.' from version_ins;
-- apprecalc-mcq-sv-017-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-017-v2', 'mcq', 'Negative sine equation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 ≤ x < 2π, which gives all solutions of 2sin x + 1 = 0?', null, md5('apprecalc-mcq-sv-017-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/6 and 5π/6', false, 'These are the solutions of sin x = +1/2. The sign was lost when moving the 1 to the other side.' from version_ins
union all select gen_random_uuid(), id, 'B', '5π/6 and 7π/6', false, 'Pairs 7*pi/6, which is a solution of sin x = -1/2, with 5*pi/6, which is a solution of sin x = +1/2. Check: sin(5*pi/6) = +1/2, so 2 sin x + 1 = 2, not 0, and 5*pi/6 is not a solution. It also omits 11*pi/6.' from version_ins
union all select gen_random_uuid(), id, 'C', '7π/6 and 11π/6', true, 'sin x = −1/2. Sine is negative in Quadrants III and IV, where the reference angle π/6 gives x = π + π/6 = 7π/6 and x = 2π − π/6 = 11π/6.' from version_ins
union all select gen_random_uuid(), id, 'D', '7π/6 only', false, 'Finds the Quadrant III solution but omits the Quadrant IV solution, 11π/6, where sine is also −1/2.' from version_ins;
-- apprecalc-mcq-sv-017-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-017-v3', 'mcq', 'Tangent equation on [0, 2π)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use the unit circle to answer this. Considering only angles from 0 up to, but not including, 2π, which choice lists every angle x that satisfies tan x + 1 = 0?', null, md5('apprecalc-mcq-sv-017-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3π/4 and 5π/4', false, 'Pairs Quadrant II with Quadrant III, but tangent is positive in Quadrant III: tan(5π/4) = +1, not −1.' from version_ins
union all select gen_random_uuid(), id, 'B', '3π/4 and 7π/4', true, 'tan x = −1. Tangent is negative in Quadrants II and IV, where the reference angle π/4 gives x = π − π/4 = 3π/4 and x = 2π − π/4 = 7π/4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/4 and 5π/4', false, 'These are the solutions of tan x = +1. The sign was lost when isolating tan x.' from version_ins
union all select gen_random_uuid(), id, 'D', '3π/4 only', false, 'Finds one solution but ignores that tangent has period π, so 3π/4 + π = 7π/4 is also a solution in the interval.' from version_ins;
-- apprecalc-mcq-sv-018-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-018-v1', 'mcq', 'Principal value of arcsine', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A technician records θ = sin⁻¹(−√3/2), using the principal range of the inverse sine function. What is θ?', null, md5('apprecalc-mcq-sv-018-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−π/3', true, 'The principal range of sin⁻¹ is [−π/2, π/2], and sin(−π/3) = −√3/2 there.' from version_ins
union all select gen_random_uuid(), id, 'B', '5π/3', false, 'sin(5π/3) = −√3/2, but 5π/3 is outside the principal range [−π/2, π/2] of inverse sine.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/3', false, 'sin(π/3) = +√3/2, which is positive. The sign was dropped.' from version_ins
union all select gen_random_uuid(), id, 'D', '4π/3', false, 'sin(4π/3) = −√3/2, but 4π/3 is outside the principal range [−π/2, π/2] of inverse sine.' from version_ins;
commit;
