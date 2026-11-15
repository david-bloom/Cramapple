begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-h-1.5-b','apphysics1-mcq-b6-sv-h-1.5-b-v1','apphysics1-mcq-b6-sv-h-1.5-b-v2','apphysics1-mcq-b6-sv-h-1.5-b-v3'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apphysics1-mcq-b6-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.5-b', 'mcq', 'compare range, time of flight, and maximum height for complementary launch angles at equal speed', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two balls are launched from level ground at the same speed of 20 m/s, one at 30° and the other at 60° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?', null, md5('apphysics1-mcq-b6-h-1.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 30° projectile lands farther away, because it has the larger horizontal velocity component.', false, 'Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both land about 35 m away and stay up for the same time, because they share a launch speed.', false, 'The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both land about 35 m away; the 60° projectile stays up longer (3.5 s versus 2.0 s) and rises higher (15.0 m versus 5.0 m).', true, 'Correct: R = v² sin(2θ)/g is equal for 30° and 60° (34.6 m). T = 2v sinθ/g gives 2.00 s and 3.46 s. H = (v sinθ)²/2g gives 5.00 m and 15.00 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 60° projectile lands farther away, because it rises higher and stays up longer.', false, 'A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.5-b-v1', 'mcq', 'compare range, time of flight, and maximum height for complementary launch angles at equal speed (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two arrows are fired from level ground at 30 m/s, one at 20° and one at 70° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?', null, md5('apphysics1-mcq-b6-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 20° projectile lands farther away, because it has the larger horizontal velocity component.', false, 'Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both land about 58 m away and stay up for the same time, because they share a launch speed.', false, 'The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The 70° projectile lands farther away, because it rises higher and stays up longer.', false, 'A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both land about 58 m away; the 70° projectile stays up longer (5.6 s versus 2.1 s) and rises higher (39.7 m versus 5.3 m).', true, 'Correct: R = v² sin(2θ)/g is equal for 20° and 70° (57.9 m). T = 2v sinθ/g gives 2.05 s and 5.64 s. H = (v sinθ)²/2g gives 5.26 m and 39.74 m.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.5-b-v2', 'mcq', 'compare range, time of flight, and maximum height for complementary launch angles at equal speed (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two water jets leave level ground at 16 m/s, one at 15° and one at 75° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?', null, md5('apphysics1-mcq-b6-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 15° projectile lands farther away, because it has the larger horizontal velocity component.', false, 'Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both land about 13 m away and stay up for the same time, because they share a launch speed.', false, 'The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The 75° projectile lands farther away, because it rises higher and stays up longer.', false, 'A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both land about 13 m away; the 75° projectile stays up longer (3.1 s versus 0.8 s) and rises higher (11.9 m versus 0.9 m).', true, 'Correct: R = v² sin(2θ)/g is equal for 15° and 75° (12.8 m). T = 2v sinθ/g gives 0.83 s and 3.09 s. H = (v sinθ)²/2g gives 0.86 m and 11.94 m.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.5-b-v3', 'mcq', 'compare range, time of flight, and maximum height for complementary launch angles at equal speed (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two footballs are kicked from level ground at 25 m/s, one at 35° and one at 55° above the horizontal. Neglect air resistance and use g = 10 m/s². Which statement compares the flights correctly?', null, md5('apphysics1-mcq-b6-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 35° projectile lands farther away, because it has the larger horizontal velocity component.', false, 'Horizontal speed alone does not set the range, since the time in the air matters too. Complementary angles give equal ranges because sin(2θ) is the same for both.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both land about 59 m away; the 55° projectile stays up longer (4.1 s versus 2.9 s) and rises higher (21.0 m versus 10.3 m).', true, 'Correct: R = v² sin(2θ)/g is equal for 35° and 55° (58.7 m). T = 2v sinθ/g gives 2.87 s and 4.10 s. H = (v sinθ)²/2g gives 10.28 m and 20.97 m.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both land about 59 m away and stay up for the same time, because they share a launch speed.', false, 'The two projectiles have different vertical components, so they spend different times in the air. The one launched at the steeper angle stays up longer.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 55° projectile lands farther away, because it rises higher and stays up longer.', false, 'A longer flight time is offset by a smaller horizontal velocity component. The two effects exactly cancel for complementary angles, giving the same range.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-h-1.5-b','apphysics1-mcq-b6-sv-h-1.5-b-v1','apphysics1-mcq-b6-sv-h-1.5-b-v2','apphysics1-mcq-b6-sv-h-1.5-b-v3']) and status='draft')<>4 then raise exception 'chunk 5: expected 4 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b6-h-1.5-b','apphysics1-mcq-b6-sv-h-1.5-b-v1','apphysics1-mcq-b6-sv-h-1.5-b-v2','apphysics1-mcq-b6-sv-h-1.5-b-v3']))<>16 then raise exception 'chunk 5: expected 16 choices'; end if;
end $$;
commit;
