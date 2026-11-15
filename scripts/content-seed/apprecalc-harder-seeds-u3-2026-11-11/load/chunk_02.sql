begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-h-3.2-a-v1','apprecalc-mcq-sv-h-3.2-a-v2','apprecalc-mcq-sv-h-3.2-a-v3','apprecalc-mcq-h-3.2-b','apprecalc-mcq-sv-h-3.2-b-v1','apprecalc-mcq-sv-h-3.2-b-v2','apprecalc-mcq-sv-h-3.2-b-v3','apprecalc-mcq-h-3.3-a','apprecalc-mcq-sv-h-3.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-sv-h-3.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.2-a-v1', 'mcq', 'Signs and quadrants from one trigonometric value (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An angle θ is in Quadrant II, and sin θ = 3/5. Which choice gives cos θ and tan θ?', null, md5('apprecalc-mcq-sv-h-3.2-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cos θ = −4/5 and tan θ = −3/4', true, 'Correct: cos θ = −√(1 − 9/25) = −4/5 in Quadrant II, and tan θ = (3/5)/(−4/5) = −3/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cos θ = 4/5 and tan θ = −3/4', false, 'Cosine is negative in Quadrant II, and a positive cosine would place the angle in Quadrant I.' from version_ins
union all select gen_random_uuid(), id, 'C', 'cos θ = −4/5 and tan θ = 3/4', false, 'Tangent is negative in Quadrant II because sine is positive and cosine is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'cos θ = −4/5 and tan θ = −4/3', false, 'This inverts the ratio, giving cos θ/sin θ in magnitude instead of sin θ/cos θ.' from version_ins;
-- apprecalc-mcq-sv-h-3.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.2-a-v2', 'mcq', 'Signs and quadrants from one trigonometric value (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An angle θ is in Quadrant IV, and tan θ = −2. Which choice gives sin θ and cos θ?', null, md5('apprecalc-mcq-sv-h-3.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin θ = 2/√5 and cos θ = −1/√5', false, 'These signs place the angle in Quadrant II, where sine is positive and cosine is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin θ = −1/√5 and cos θ = 2/√5', false, 'This swaps the two values, so tan θ would be −1/2 instead of −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin θ = −2/√5 and cos θ = −1/√5', false, 'These signs place the angle in Quadrant III, where both are negative and the tangent is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin θ = −2/√5 and cos θ = 1/√5', true, 'Correct: tan θ = sin θ/cos θ = −2 with cos θ > 0 and sin θ < 0 in Quadrant IV; with sin² + cos² = 1 we get cos θ = 1/√5 and sin θ = −2/√5.' from version_ins;
-- apprecalc-mcq-sv-h-3.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.2-a-v3', 'mcq', 'Signs and quadrants from one trigonometric value (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An angle θ satisfies sin θ = −8/17 and cos θ > 0. What is tan θ?', null, md5('apprecalc-mcq-sv-h-3.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8/15', false, 'Sine is negative and cosine is positive, so the tangent is negative, and a positive value ignores the sign of sine.' from version_ins
union all select gen_random_uuid(), id, 'B', '−15/8', false, 'This inverts the ratio, giving cos θ/sin θ instead of sin θ/cos θ.' from version_ins
union all select gen_random_uuid(), id, 'C', '−8/15', true, 'Correct: cos θ = √(1 − 64/289) = 15/17 > 0, so tan θ = (−8/17)/(15/17) = −8/15.' from version_ins
union all select gen_random_uuid(), id, 'D', '15/8', false, 'This both inverts the ratio and drops the sign.' from version_ins;
-- apprecalc-mcq-h-3.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-h-3.2-b', 'mcq', 'Ratios from a point not on the unit circle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The terminal ray of an angle θ in standard position passes through the point (−6, 8). Which choice gives sin θ, cos θ and tan θ?', null, md5('apprecalc-mcq-h-3.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin θ = 8, cos θ = −6, tan θ = −4/3', false, 'Sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin θ = 4/5, cos θ = −3/5, tan θ = −4/3', true, 'Correct: r = √(36 + 64) = 10, so sin θ = 8/10 = 4/5, cos θ = −6/10 = −3/5, tan θ = 8/(−6) = −4/3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin θ = 4/5, cos θ = 3/5, tan θ = −4/3', false, 'The x-coordinate is negative, so cosine is negative in Quadrant II.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin θ = 4/5, cos θ = −3/5, tan θ = −3/4', false, 'Tangent is y/x = 8/(−6), which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.' from version_ins;
-- apprecalc-mcq-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.2-b-v1', 'mcq', 'Ratios from a point not on the unit circle (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The terminal ray of an angle θ in standard position passes through the point (5, −12). Which choice gives sin θ, cos θ and tan θ?', null, md5('apprecalc-mcq-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin θ = −12, cos θ = 5, tan θ = −12/5', false, 'Sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 13.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin θ = 12/13, cos θ = 5/13, tan θ = −12/5', false, 'The y-coordinate is negative, so sine is negative in Quadrant IV.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin θ = −12/13, cos θ = 5/13, tan θ = −12/5', true, 'Correct: r = √(25 + 144) = 13, so sin θ = −12/13, cos θ = 5/13, tan θ = −12/5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin θ = −12/13, cos θ = 5/13, tan θ = −5/12', false, 'Tangent is y/x = −12/5, which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.' from version_ins;
-- apprecalc-mcq-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.2-b-v2', 'mcq', 'Ratios from a point not on the unit circle (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The terminal ray of an angle θ in standard position passes through the point (−4, −3). Which choice gives sin θ, cos θ and tan θ?', null, md5('apprecalc-mcq-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin θ = −3/5, cos θ = −4/5, tan θ = 3/4', true, 'Correct: r = √(16 + 9) = 5, so sin θ = −3/5, cos θ = −4/5, tan θ = (−3)/(−4) = 3/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin θ = −3, cos θ = −4, tan θ = 3/4', false, 'Sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin θ = −3/5, cos θ = −4/5, tan θ = −3/4', false, 'The quotient of two negative numbers is positive, so tan θ is positive in Quadrant III.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin θ = −3/5, cos θ = −4/5, tan θ = 4/3', false, 'Tangent is y/x = 3/4, which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.' from version_ins;
-- apprecalc-mcq-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.2-b-v3', 'mcq', 'Ratios from a point not on the unit circle (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The terminal ray of an angle θ in standard position passes through the point (−8, −15). Which choice gives sin θ, cos θ and tan θ?', null, md5('apprecalc-mcq-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin θ = −15, cos θ = −8, tan θ = 15/8', false, 'Sine and cosine are the y and x coordinates only on the unit circle, and these must be divided by r = 17.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin θ = −15/17, cos θ = −8/17, tan θ = −15/8', false, 'The quotient of two negative numbers is positive, so tan θ is positive in Quadrant III.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin θ = −15/17, cos θ = −8/17, tan θ = 15/8', true, 'Correct: r = √(64 + 225) = 17, so sin θ = −15/17, cos θ = −8/17, tan θ = 15/8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin θ = −15/17, cos θ = −8/17, tan θ = 8/15', false, 'Tangent is y/x = 15/8, which is the ratio of the y-coordinate to the x-coordinate, the ratio of the y-coordinate to the x-coordinate, not x/y.' from version_ins;
-- apprecalc-mcq-h-3.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-h-3.3-a', 'mcq', 'Solve for angles from a sine or cosine value', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which angles θ in the interval [0, 2π) satisfy sin θ = −√3/2?', null, md5('apprecalc-mcq-h-3.3-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'π/3 and 2π/3', false, 'These angles have sin θ = +√3/2, since they lie in Quadrants I and II.' from version_ins
union all select gen_random_uuid(), id, 'B', '2π/3 and 4π/3', false, '2π/3 is in Quadrant II, where sine is positive, so it cannot be a solution.' from version_ins
union all select gen_random_uuid(), id, 'C', '4π/3 and 5π/3', true, 'Correct: the reference angle is π/3 and sine is negative in Quadrants III and IV, so θ = π + π/3 = 4π/3 and θ = 2π − π/3 = 5π/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '7π/6 and 11π/6', false, 'These have reference angle π/6, for which the sine is −1/2 and not −√3/2.' from version_ins;
-- apprecalc-mcq-sv-h-3.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.3-a-v1', 'mcq', 'Solve for angles from a sine or cosine value (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which angles θ in the interval [0, 2π) satisfy cos θ = −√2/2?', null, md5('apprecalc-mcq-sv-h-3.3-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3π/4 and 5π/4', true, 'Correct: the reference angle is π/4 and cosine is negative in Quadrants II and III, so θ = 3π/4 and θ = 5π/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/4 and 7π/4', false, 'These angles have cos θ = +√2/2, since they lie in Quadrants I and IV.' from version_ins
union all select gen_random_uuid(), id, 'C', '5π/4 and 7π/4', false, '7π/4 is in Quadrant IV, where cosine is positive, so it cannot be a solution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/4 and 3π/4', false, 'Π/4 is in Quadrant I, where cosine is positive, so it cannot be a solution.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-sv-h-3.2-a-v1','apprecalc-mcq-sv-h-3.2-a-v2','apprecalc-mcq-sv-h-3.2-a-v3','apprecalc-mcq-h-3.2-b','apprecalc-mcq-sv-h-3.2-b-v1','apprecalc-mcq-sv-h-3.2-b-v2','apprecalc-mcq-sv-h-3.2-b-v3','apprecalc-mcq-h-3.3-a','apprecalc-mcq-sv-h-3.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-sv-h-3.2-a-v1','apprecalc-mcq-sv-h-3.2-a-v2','apprecalc-mcq-sv-h-3.2-a-v3','apprecalc-mcq-h-3.2-b','apprecalc-mcq-sv-h-3.2-b-v1','apprecalc-mcq-sv-h-3.2-b-v2','apprecalc-mcq-sv-h-3.2-b-v3','apprecalc-mcq-h-3.3-a','apprecalc-mcq-sv-h-3.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
