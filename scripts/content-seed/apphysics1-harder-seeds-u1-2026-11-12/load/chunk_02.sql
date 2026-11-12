begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-sv-h-1.2-a-v1','apphysics1-mcq-b6-sv-h-1.2-a-v2','apphysics1-mcq-b6-sv-h-1.2-a-v3','apphysics1-mcq-b6-h-1.2-b','apphysics1-mcq-b6-sv-h-1.2-b-v1','apphysics1-mcq-b6-sv-h-1.2-b-v2','apphysics1-mcq-b6-sv-h-1.2-b-v3','apphysics1-mcq-b6-h-1.3-a','apphysics1-mcq-b6-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apphysics1-mcq-b6-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.2-a-v1', 'mcq', 'use the relative signs of velocity and acceleration to decide speeding up or slowing down, then apply v = v0 + at throug (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is +4 m/s and its acceleration is a constant −2 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 3.0 s?', null, md5('apphysics1-mcq-b6-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Moving right and speeding up; v = +10 m/s.', false, 'Velocity and acceleration have opposite signs here, so the cart loses speed at first. Adding the magnitude of the acceleration treats it as always speeding the cart up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Moving right and slowing down; v = 0 m/s.', false, 'The velocity does reach zero, at t = 2.0 s, but the constant acceleration continues to act. By 3.0 s the cart has reversed and moves left at 2 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Moving left and speeding up; v = −2 m/s.', false, 'The direction of motion at t = 0 comes from the sign of the velocity, which is positive, so the cart starts out moving right. The acceleration''s sign does not set that direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Moving right and slowing down; v = −2 m/s.', true, 'Correct: v = 4 + (−2)(3.0) = -2 m/s. At t = 0, v > 0 and a < 0, so the cart is slowing; it stops at t = 2.0 s and reverses.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.2-a-v2', 'mcq', 'use the relative signs of velocity and acceleration to decide speeding up or slowing down, then apply v = v0 + at throug (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is −5 m/s and its acceleration is a constant +2 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 4.0 s?', null, md5('apphysics1-mcq-b6-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Moving left and speeding up; v = −13 m/s.', false, 'The positive acceleration points opposite to the leftward velocity, so it reduces the speed. Treating a positive acceleration as adding to a leftward speed gets the relationship backward.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Moving left and slowing down; v = 0 m/s.', false, 'The cart does stop at t = 2.5 s, but the acceleration keeps acting. After a further 1.5 s it is moving right at 3 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Moving right and speeding up; v = +13 m/s.', false, 'At t = 0 the velocity is negative, so the cart is moving left. The positive acceleration does not make it start out moving right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Moving left and slowing down; v = +3 m/s.', true, 'Correct: v = −5 + (2)(4.0) = +3 m/s. Velocity and acceleration start with opposite signs, so the cart slows, stops at 2.5 s, then moves right.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.2-a-v3', 'mcq', 'use the relative signs of velocity and acceleration to decide speeding up or slowing down, then apply v = v0 + at throug (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track with the positive axis pointing right. At t = 0 its velocity is +2 m/s and its acceleration is a constant +3 m/s². Which choice correctly describes the cart at t = 0 and gives its velocity at t = 2.0 s?', null, md5('apphysics1-mcq-b6-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Moving right and speeding up; v = +5 m/s.', false, 'The change in velocity is the acceleration multiplied by the time, (3)(2.0) = 6 m/s. Adding the acceleration value directly to 2 m/s leaves out the time factor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Moving right and speeding up; v = +6 m/s.', false, 'The acceleration only supplies the change in velocity, 6 m/s. The cart''s initial 2 m/s must be added, giving 8 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Moving left and speeding up; v = −8 m/s.', false, 'The positive velocity at t = 0 means the cart moves right. Speeding up in the positive direction gives +8 m/s, not −8 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Moving right and speeding up; v = +8 m/s.', true, 'Correct: v = 2 + (3)(2.0) = 8 m/s. Both signs are positive, so the speed increases.' from version_ins;
-- apphysics1-mcq-b6-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.2-b', 'mcq', 'separate displacement from distance traveled for constant-acceleration motion that reverses at a turning point', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart on a straight track has an initial velocity of +8.0 m/s and a constant acceleration of −2.0 m/s². Considering the first 6.0 s of motion, which choice gives its displacement and the total distance it travels?', null, md5('apphysics1-mcq-b6-h-1.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Displacement +12.0 m; distance traveled 20.0 m.', true, 'Correct: Turning point at t = −v0/a = 4.0 s, reached after 16.0 m. x(t) = v0 t + ½ a t² = +12.0 m. Path length = 16.0 + 4.0 = 20.0 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Displacement +12.0 m; distance traveled 12.0 m.', false, 'The object reverses at t = 4.0 s, so the path length is greater than the 12.0 m magnitude of the displacement. The two are equal only when the motion never reverses.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Displacement +20.0 m; distance traveled 12.0 m.', false, 'Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives +12.0 m. The path length of 20.0 m is a different, unsigned quantity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Displacement +16.0 m; distance traveled 16.0 m.', false, 'The object reverses at t = 4.0 s, but the motion continues until t = 6.0 s. Stopping the calculation at the turning point ignores the return trip.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.2-b-v1', 'mcq', 'separate displacement from distance traveled for constant-acceleration motion that reverses at a turning point (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is thrown straight up at 12 m/s with the upward direction positive and a constant acceleration of −10 m/s². Neglecting air resistance, which choice gives its displacement and the total distance it travels during the first 2.0 s?', null, md5('apphysics1-mcq-b6-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Displacement +4.0 m; distance traveled 4.0 m.', false, 'The object reverses at t = 1.2 s, so the path length is greater than the 4.0 m magnitude of the displacement. The two are equal only when the motion never reverses.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Displacement +10.4 m; distance traveled 4.0 m.', false, 'Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives +4.0 m. The path length of 10.4 m is a different, unsigned quantity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Displacement +7.2 m; distance traveled 7.2 m.', false, 'The object reverses at t = 1.2 s, but the motion continues until t = 2.0 s. Stopping the calculation at the turning point ignores the return trip.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Displacement +4.0 m; distance traveled 10.4 m.', true, 'Correct: Turning point at t = −v0/a = 1.2 s, reached after 7.2 m. x(t) = v0 t + ½ a t² = +4.0 m. Path length = 7.2 + 3.2 = 10.4 m.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.2-b-v2', 'mcq', 'separate displacement from distance traveled for constant-acceleration motion that reverses at a turning point (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moving along a track at +10 m/s has a constant acceleration of −4.0 m/s². Over the first 5.0 s, which choice gives its displacement and the total distance it travels?', null, md5('apphysics1-mcq-b6-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Displacement 0.0 m; distance traveled 0.0 m.', false, 'The object reverses at t = 2.5 s, so the path length is greater than the 0.0 m magnitude of the displacement. The two are equal only when the motion never reverses.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Displacement +25.0 m; distance traveled 25.0 m.', false, 'Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives 0.0 m. The path length of 25.0 m is a different, unsigned quantity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Displacement 0.0 m; distance traveled 25.0 m.', true, 'Correct: Turning point at t = −v0/a = 2.5 s, reached after 12.5 m. x(t) = v0 t + ½ a t² = 0.0 m. Path length = 12.5 + 12.5 = 25.0 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Displacement +12.5 m; distance traveled 12.5 m.', false, 'The object reverses at t = 2.5 s, but the motion continues until t = 5.0 s. Stopping the calculation at the turning point ignores the return trip.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.2-b-v3', 'mcq', 'separate displacement from distance traveled for constant-acceleration motion that reverses at a turning point (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled slides on a slope where the downhill direction is positive. It starts at −9.0 m/s (moving uphill) with a constant acceleration of +3.0 m/s². Over the first 4.0 s, which choice gives its displacement and the total distance it travels?', null, md5('apphysics1-mcq-b6-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Displacement −12.0 m; distance traveled 15.0 m.', true, 'Correct: Turning point at t = −v0/a = 3.0 s, reached after 13.5 m. x(t) = v0 t + ½ a t² = −12.0 m. Path length = 13.5 + 1.5 = 15.0 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Displacement −12.0 m; distance traveled 12.0 m.', false, 'The object reverses at t = 3.0 s, so the path length is greater than the 12.0 m magnitude of the displacement. The two are equal only when the motion never reverses.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Displacement +15.0 m; distance traveled 12.0 m.', false, 'Displacement is the signed change in position from the formula x = v0 t + ½ a t², which gives −12.0 m. The path length of 15.0 m is a different, unsigned quantity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Displacement −13.5 m; distance traveled 13.5 m.', false, 'The object reverses at t = 3.0 s, but the motion continues until t = 4.0 s. Stopping the calculation at the turning point ignores the return trip.' from version_ins;
-- apphysics1-mcq-b6-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.3-a', 'mcq', 'read position from the signed area under a velocity-time graph, distinguishing zero velocity and a turning point from ze', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track. Its velocity–time graph is a single straight line that starts at +6.0 m/s at t = 0 and falls steadily to −6.0 m/s at t = 6.0 s. Take the position at t = 0 as the starting position. Which statement about the cart''s position is correct?', null, md5('apphysics1-mcq-b6-h-1.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is farthest from its start at t = 6 s, because the velocity has its largest negative value there.', false, 'Position depends on the accumulated area under the graph, not on the current value of the velocity. After the crossing, the object moves back toward its start.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is farthest from its start at t = 3 s, 9 m away on the positive side; at t = 6 s it is back at its starting position.', true, 'Correct: Zero crossing at t = 3 s; area = 9 m. Remaining area has magnitude 9 m in the opposite direction, so x(6) = 0 m.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The object is at its starting position at t = 3 s, because the velocity is zero there.', false, 'Zero velocity is not zero position. The velocity is zero at the crossing, while the object has already covered the whole area before it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 6 s the object is 18 m from its start, because the two areas add.', false, 'The area below the time axis is displacement in the opposite direction, so it subtracts from the area above. The total of the two areas is the path length, not the net displacement.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.3-a-v1', 'mcq', 'read position from the signed area under a velocity-time graph, distinguishing zero velocity and a turning point from ze (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a straight track. Its velocity–time graph is one straight line from +8.0 m/s at t = 0 down to −4.0 m/s at t = 6.0 s. Taking its position at t = 0 as the start, which statement about the cart''s position is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is farthest from its start at t = 6 s, because the velocity has its largest negative value there.', false, 'Position depends on the accumulated area under the graph, not on the current value of the velocity. After the crossing, the object moves back toward its start.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The object is at its starting position at t = 4 s, because the velocity is zero there.', false, 'Zero velocity is not zero position. The velocity is zero at the crossing, while the object has already covered the whole area before it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is farthest from its start at t = 4 s, 16 m away on the positive side; at t = 6 s it is 12 m from its start, on the positive side.', true, 'Correct: Zero crossing at t = 4 s; area = 16 m. Remaining area has magnitude 4 m in the opposite direction, so x(6) = +12 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At t = 6 s the object is 20 m from its start, because the two areas add.', false, 'The area below the time axis is displacement in the opposite direction, so it subtracts from the area above. The total of the two areas is the path length, not the net displacement.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-sv-h-1.2-a-v1','apphysics1-mcq-b6-sv-h-1.2-a-v2','apphysics1-mcq-b6-sv-h-1.2-a-v3','apphysics1-mcq-b6-h-1.2-b','apphysics1-mcq-b6-sv-h-1.2-b-v1','apphysics1-mcq-b6-sv-h-1.2-b-v2','apphysics1-mcq-b6-sv-h-1.2-b-v3','apphysics1-mcq-b6-h-1.3-a','apphysics1-mcq-b6-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b6-sv-h-1.2-a-v1','apphysics1-mcq-b6-sv-h-1.2-a-v2','apphysics1-mcq-b6-sv-h-1.2-a-v3','apphysics1-mcq-b6-h-1.2-b','apphysics1-mcq-b6-sv-h-1.2-b-v1','apphysics1-mcq-b6-sv-h-1.2-b-v2','apphysics1-mcq-b6-sv-h-1.2-b-v3','apphysics1-mcq-b6-h-1.3-a','apphysics1-mcq-b6-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
