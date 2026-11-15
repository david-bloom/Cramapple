begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-h-4.8-a','apprecalc-mcq-b4b-sv-h-4.8-a-v1','apprecalc-mcq-b4b-sv-h-4.8-a-v2','apprecalc-mcq-b4b-sv-h-4.8-a-v3','apprecalc-mcq-b4b-h-4.9-a','apprecalc-mcq-b4b-sv-h-4.9-a-v1','apprecalc-mcq-b4b-sv-h-4.9-a-v2','apprecalc-mcq-b4b-sv-h-4.9-a-v3','apprecalc-mcq-b4b-h-4.10-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4b-h-4.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.8-a', 'mcq', '4.8-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A boat''s velocity relative to the water is ⟨6, 0⟩ km/h (due east), and the river current''s velocity is ⟨0, -8⟩ km/h (due south). Relative to the ground, what are the boat''s speed and direction?', null, md5('apprecalc-mcq-b4b-h-4.8-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '14 km/h, 53.1° south of east', false, 'Adding the magnitudes 6 and 8 gives 14, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '10 km/h, 36.9° south of east', false, 'The speed 10 is right, but the angle below the east axis is arctan(8/6) = 53.1°; 36.9° comes from dividing the components the wrong way round.' from version_ins
union all select gen_random_uuid(), id, 'C', '10 km/h, 53.1° north of east', false, 'The speed and angle size are right, but the current points south, so the second component pushes the boat south and not north.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 km/h, 53.1° south of east', true, 'Correct: the ground velocity is ⟨6, -8⟩, with magnitude √(6² + 8²) = 10 and direction arctan(8/6) ≈ 53.1° south of east.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.8-a-v1', 'mcq', '4.8-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s velocity relative to the air is ⟨5, 0⟩ m/s (due east), and the wind''s velocity is ⟨0, -12⟩ m/s (due south). Relative to the ground, what are the drone''s speed and direction?', null, md5('apprecalc-mcq-b4b-sv-h-4.8-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13 m/s, 67.4° south of east', true, 'Correct: the ground velocity is ⟨5, -12⟩, with magnitude √(5² + 12²) = 13 and direction arctan(12/5) ≈ 67.4° south of east.' from version_ins
union all select gen_random_uuid(), id, 'B', '17 m/s, 67.4° south of east', false, 'Adding the magnitudes 5 and 12 gives 17, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 13.' from version_ins
union all select gen_random_uuid(), id, 'C', '13 m/s, 22.6° south of east', false, 'The speed 13 is right, but the angle below the east axis is arctan(12/5) = 67.4°; 22.6° comes from dividing the components the wrong way round.' from version_ins
union all select gen_random_uuid(), id, 'D', '13 m/s, 67.4° north of east', false, 'The speed and angle size are right, but the current points south, so the second component pushes the boat south and not north.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.8-a-v2', 'mcq', '4.8-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A kayaker paddles with velocity ⟨8, 0⟩ km/h relative to the water (due east) in a tidal current of velocity ⟨0, 15⟩ km/h (due north). Relative to the shore, what are the kayaker''s speed and direction?', null, md5('apprecalc-mcq-b4b-sv-h-4.8-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '23 km/h, 61.9° north of east', false, 'Adding the magnitudes 8 and 15 gives 23, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 17.' from version_ins
union all select gen_random_uuid(), id, 'B', '17 km/h, 28.1° north of east', false, 'The speed 17 is right, but the angle below the east axis is arctan(15/8) = 61.9°; 28.1° comes from dividing the components the wrong way round.' from version_ins
union all select gen_random_uuid(), id, 'C', '17 km/h, 61.9° south of east', false, 'The speed and angle size are right, but the current points north, so the second component pushes the boat north and not south.' from version_ins
union all select gen_random_uuid(), id, 'D', '17 km/h, 61.9° north of east', true, 'Correct: the ground velocity is ⟨8, 15⟩, with magnitude √(8² + 15²) = 17 and direction arctan(15/8) ≈ 61.9° north of east.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.8-a-v3', 'mcq', '4.8-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ferry''s velocity relative to the water is ⟨7, 0⟩ knots (due east), and the current''s velocity is ⟨0, -24⟩ knots (due south). Relative to the sea floor, what are the ferry''s speed and direction?', null, md5('apprecalc-mcq-b4b-sv-h-4.8-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '31 knots, 73.7° south of east', false, 'Adding the magnitudes 7 and 24 gives 31, but perpendicular vectors combine with the Pythagorean theorem, so the speed is 25.' from version_ins
union all select gen_random_uuid(), id, 'B', '25 knots, 16.3° south of east', false, 'The speed 25 is right, but the angle below the east axis is arctan(24/7) = 73.7°; 16.3° comes from dividing the components the wrong way round.' from version_ins
union all select gen_random_uuid(), id, 'C', '25 knots, 73.7° north of east', false, 'The speed and angle size are right, but the current points south, so the second component pushes the boat south and not north.' from version_ins
union all select gen_random_uuid(), id, 'D', '25 knots, 73.7° south of east', true, 'Correct: the ground velocity is ⟨7, -24⟩, with magnitude √(7² + 24²) = 25 and direction arctan(24/7) ≈ 73.7° south of east.' from version_ins;
-- apprecalc-mcq-b4b-h-4.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.9-a', 'mcq', '4.9-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s position, in meters, at time t seconds (0 ≤ t ≤ 12) is r(t) = ⟨t² − 6t, 12t − t²⟩, with x measured east and y measured north. For which times is the drone moving east and north at the same time?', null, md5('apprecalc-mcq-b4b-h-4.9-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3 < t < 6', true, 'Correct: the velocity is r′(t) = ⟨2t − 6, 12 − 2t⟩; the first component is positive for t > 3 and the second for t < 6, so both hold for 3 < t < 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 't > 3', false, 'X′(t) = 2t − 6 is positive for t > 3, so the object is moving east, but y′(t) = 12 − 2t is negative once t > 6, so it stops moving north.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 < t < 6', false, 'Y′(t) = 12 − 2t is positive for t < 6, so it is moving north, but x′(t) = 2t − 6 is negative until t = 3, so it is moving west at first.' from version_ins
union all select gen_random_uuid(), id, 'D', 't > 6', false, 'T > 6 is where the position x(t) = t² − 6t is positive, which says where the object is east of the origin, not where it is moving east.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.9-a-v1', 'mcq', '4.9-A (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A robot''s position, in meters, at time t seconds (0 ≤ t ≤ 18) is r(t) = ⟨t² − 4t, 18t − t²⟩, with x measured east and y measured north. For which times is the robot moving east and north at the same time?', null, md5('apprecalc-mcq-b4b-sv-h-4.9-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't > 2', false, 'X′(t) = 2t − 4 is positive for t > 2, so the object is moving east, but y′(t) = 18 − 2t is negative once t > 9, so it stops moving north.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 < t < 9', false, 'Y′(t) = 18 − 2t is positive for t < 9, so it is moving north, but x′(t) = 2t − 4 is negative until t = 2, so it is moving west at first.' from version_ins
union all select gen_random_uuid(), id, 'C', 't > 4', false, 'T > 4 is where the position x(t) = t² − 4t is positive, which says where the object is east of the origin, not where it is moving east.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 < t < 9', true, 'Correct: the velocity is r′(t) = ⟨2t − 4, 18 − 2t⟩; the first component is positive for t > 2 and the second for t < 9, so both hold for 2 < t < 9.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.9-a-v2', 'mcq', '4.9-A (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball rolling across a table has position, in centimeters, r(t) = ⟨t² − 10t, 16t − t²⟩ for 0 ≤ t ≤ 16, with x to the right and y up. For which times is the ball moving right and up at the same time?', null, md5('apprecalc-mcq-b4b-sv-h-4.9-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5 < t < 8', true, 'Correct: the velocity is r′(t) = ⟨2t − 10, 16 − 2t⟩; the first component is positive for t > 5 and the second for t < 8, so both hold for 5 < t < 8.' from version_ins
union all select gen_random_uuid(), id, 'B', 't > 5', false, 'X′(t) = 2t − 10 is positive for t > 5, so the object is moving east, but y′(t) = 16 − 2t is negative once t > 8, so it stops moving north.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 < t < 8', false, 'Y′(t) = 16 − 2t is positive for t < 8, so it is moving north, but x′(t) = 2t − 10 is negative until t = 5, so it is moving west at first.' from version_ins
union all select gen_random_uuid(), id, 'D', 't > 10', false, 'T > 10 is where the position x(t) = t² − 10t is positive, which says where the object is east of the origin, not where it is moving east.' from version_ins;
-- apprecalc-mcq-b4b-sv-h-4.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-sv-h-4.9-a-v3', 'mcq', '4.9-A (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A skater''s position, in meters, at time t seconds (0 ≤ t ≤ 20) is r(t) = ⟨t² − 6t, 20t − t²⟩, with x measured east and y measured north. For which times is the skater moving east and north at the same time?', null, md5('apprecalc-mcq-b4b-sv-h-4.9-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 't > 3', false, 'X′(t) = 2t − 6 is positive for t > 3, so the object is moving east, but y′(t) = 20 − 2t is negative once t > 10, so it stops moving north.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 < t < 10', false, 'Y′(t) = 20 − 2t is positive for t < 10, so it is moving north, but x′(t) = 2t − 6 is negative until t = 3, so it is moving west at first.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 < t < 10', true, 'Correct: the velocity is r′(t) = ⟨2t − 6, 20 − 2t⟩; the first component is positive for t > 3 and the second for t < 10, so both hold for 3 < t < 10.' from version_ins
union all select gen_random_uuid(), id, 'D', 't > 6', false, 'T > 6 is where the position x(t) = t² − 6t is positive, which says where the object is east of the origin, not where it is moving east.' from version_ins;
-- apprecalc-mcq-b4b-h-4.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4b-h-4.10-a', 'mcq', '4.10-A', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bakery chain''s weekly sales matrix S has rows for 2 stores and columns for 3 products, so S = [10 20 5; 8 0 12] counts items sold. The price matrix P = [3; 2; 4] lists the price in dollars of each product. Which statement about computing the weekly revenue of each store is correct?', null, md5('apprecalc-mcq-b4b-h-4.10-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'PS is defined and gives the same totals, because matrix products can be taken in either order.', false, 'P is 3×1 and S is 2×3, so in PS the inner dimensions are 1 and 2, which do not match; PS is undefined, and products are not commutative anyway.' from version_ins
union all select gen_random_uuid(), id, 'B', 'SP is defined, is 3×1, and gives one total for each of the 3 columns of S.', false, 'The product of an 2×3 matrix and a 3×1 matrix has 2 rows and 1 column, so it has one entry for each row of S and not for each column.' from version_ins
union all select gen_random_uuid(), id, 'C', 'SP is undefined, because S has 2 rows while P has 3 rows.', false, 'The rule for a product is that the number of columns of S (3) equals the number of rows of P (3); the row counts need not match.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SP is defined, is 2×1, and equals [90; 72], with one entry for each of the 2 rows of S.', true, 'Correct: S is 2×3 and P is 3×1, so SP is defined and 2×1: row 1: 10·3 + 20·2 + 5·4 = 90. row 2: 8·3 + 0·2 + 12·4 = 72.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4b-h-4.8-a','apprecalc-mcq-b4b-sv-h-4.8-a-v1','apprecalc-mcq-b4b-sv-h-4.8-a-v2','apprecalc-mcq-b4b-sv-h-4.8-a-v3','apprecalc-mcq-b4b-h-4.9-a','apprecalc-mcq-b4b-sv-h-4.9-a-v1','apprecalc-mcq-b4b-sv-h-4.9-a-v2','apprecalc-mcq-b4b-sv-h-4.9-a-v3','apprecalc-mcq-b4b-h-4.10-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4b-h-4.8-a','apprecalc-mcq-b4b-sv-h-4.8-a-v1','apprecalc-mcq-b4b-sv-h-4.8-a-v2','apprecalc-mcq-b4b-sv-h-4.8-a-v3','apprecalc-mcq-b4b-h-4.9-a','apprecalc-mcq-b4b-sv-h-4.9-a-v1','apprecalc-mcq-b4b-sv-h-4.9-a-v2','apprecalc-mcq-b4b-sv-h-4.9-a-v3','apprecalc-mcq-b4b-h-4.10-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
