begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-h-1.5-b','apphycm-mcq-b6-sv-h-1.5-b-v1','apphycm-mcq-b6-sv-h-1.5-b-v2','apphycm-mcq-b6-sv-h-1.5-b-v3'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apphycm-mcq-b6-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.5-b', 'mcq', 'obtain speed as the magnitude of the velocity vector found by differentiating each position component, not from |r|, com', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves in the xy-plane with position components x(t) = 2t² and y(t) = 3t, in meters with t in seconds. What is the particle''s speed at t = 2.0 s?', null, md5('apphycm-mcq-b6-h-1.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.2 m/s', false, 'This is the rate of change of the particle''s distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', '11 m/s', false, 'Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.54 m/s', true, 'Correct: At t = 2: r = (8, 6), v = (8, 3), speed = √(64 + 9) = 8.544 m/s. d|r|/dt = (8·8 + 6·3)/10 = 8.2; vx+vy = 11; |r|/t = 5; |a| = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '5 m/s', false, 'This is the magnitude of the position vector divided by time, an average-like quantity from the origin. Speed at an instant is the magnitude of dr/dt evaluated at that time, not |r|/t.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.5-b-v1', 'mcq', 'obtain speed as the magnitude of the velocity vector found by differentiating each position component, not from |r|, com (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s position in a horizontal plane is given by x(t) = 3t and y(t) = t² − 4t, in meters with t in seconds. What is the drone''s speed at t = 3.0 s?', null, md5('apphycm-mcq-b6-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.21 m/s', false, 'This is the rate of change of the particle''s distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 m/s', false, 'Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 m/s', false, 'This is the magnitude of the acceleration, the second derivative of position. Speed requires only the first derivative of position, the velocity, and then its magnitude.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.61 m/s', true, 'Correct: At t = 3: r = (9, -3), v = (3, 2), speed = √(9 + 4) = 3.606 m/s. d|r|/dt = (9·3 + -3·2)/9.487 = 2.214; vx+vy = 5; |r|/t = 3.162; |a| = 2.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.5-b-v2', 'mcq', 'obtain speed as the magnitude of the velocity vector found by differentiating each position component, not from |r|, com (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart on a flat floor has position components x(t) = 4t and y(t) = 5t − t², in meters with t in seconds. What is its speed at t = 2.0 s?', null, md5('apphycm-mcq-b6-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.8 m/s', false, 'This is the rate of change of the particle''s distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', '5 m/s', false, 'Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 m/s', false, 'This is the magnitude of the acceleration, the second derivative of position. Speed requires only the first derivative of position, the velocity, and then its magnitude.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.12 m/s', true, 'Correct: At t = 2: r = (8, 6), v = (4, 1), speed = √(16 + 1) = 4.123 m/s. d|r|/dt = (8·4 + 6·1)/10 = 3.8; vx+vy = 5; |r|/t = 5; |a| = 2.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.5-b-v3', 'mcq', 'obtain speed as the magnitude of the velocity vector found by differentiating each position component, not from |r|, com (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bead in a plane has position components x(t) = t² and y(t) = 2t, in meters with t in seconds. What is the bead''s speed at t = 3.0 s?', null, md5('apphycm-mcq-b6-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.1 m/s', false, 'This is the rate of change of the particle''s distance from the origin, d|r|/dt. Speed is the magnitude of the velocity vector, |v|, and the two agree only when the motion is directly away from the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.32 m/s', true, 'Correct: At t = 3: r = (9, 6), v = (6, 2), speed = √(36 + 4) = 6.325 m/s. d|r|/dt = (9·6 + 6·2)/10.817 = 6.102; vx+vy = 8; |r|/t = 3.606; |a| = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '8 m/s', false, 'Adding the velocity components is not the speed. Speed is the magnitude of the velocity vector, found from the square root of the sum of the squares of its components.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.61 m/s', false, 'This is the magnitude of the position vector divided by time, an average-like quantity from the origin. Speed at an instant is the magnitude of dr/dt evaluated at that time, not |r|/t.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-h-1.5-b','apphycm-mcq-b6-sv-h-1.5-b-v1','apphycm-mcq-b6-sv-h-1.5-b-v2','apphycm-mcq-b6-sv-h-1.5-b-v3']) and status='draft')<>4 then raise exception 'chunk 5: expected 4 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-b6-h-1.5-b','apphycm-mcq-b6-sv-h-1.5-b-v1','apphycm-mcq-b6-sv-h-1.5-b-v2','apphycm-mcq-b6-sv-h-1.5-b-v3']))<>16 then raise exception 'chunk 5: expected 16 choices'; end if;
end $$;
commit;
