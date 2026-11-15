begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-sv-h-1.3-a-v2','apphysics1-mcq-b6-sv-h-1.3-a-v3','apphysics1-mcq-b6-h-1.3-b','apphysics1-mcq-b6-sv-h-1.3-b-v1','apphysics1-mcq-b6-sv-h-1.3-b-v2','apphysics1-mcq-b6-sv-h-1.3-b-v3','apphysics1-mcq-b6-h-1.4-a','apphysics1-mcq-b6-sv-h-1.4-a-v1','apphysics1-mcq-b6-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apphysics1-mcq-b6-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.3-a-v2', 'mcq', 'read position from the signed area under a velocity-time graph, distinguishing zero velocity and a turning point from ze (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A robot moves along a straight hallway. Its velocity–time graph is one straight line from −4.0 m/s at t = 0 up to +12 m/s at t = 8.0 s. Taking its position at t = 0 as the start, which statement about the robot''s position is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is farthest from its start at t = 2 s, 4 m away, because the velocity is zero there.', false, 'A velocity of zero marks a turning point, not the farthest distance. After the crossing the object moves the other way and keeps going, ending up farther from the start.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is farthest from its start at t = 8 s, 32 m away on the positive side.', true, 'Correct: Zero crossing at t = 2 s; signed area before it = -4 m. Signed area from 2 s to 8 s = +36 m, so x(8) = +32 m. The magnitude is larger at t = 8 s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is farthest from its start at t = 8 s, 32 m away on the negative side.', false, 'The signed area after the crossing decides the side of the start where the object ends up. The graph shows the object is on the other side.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is farthest from its start at t = 8 s, 40 m away.', false, 'Areas on opposite sides of the time axis subtract. The net position is -4 + (+36) = +32 m, so the object is 32 m away, not 40 m.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.3-a-v3', 'mcq', 'read position from the signed area under a velocity-time graph, distinguishing zero velocity and a turning point from ze (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled moves along a straight slope. Its velocity–time graph is one straight line from +5.0 m/s at t = 0 down to −15 m/s at t = 8.0 s. Taking its position at t = 0 as the start, which statement about the sled''s position is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is farthest from its start at t = 8 s, 40 m away on the negative side.', true, 'Correct: Zero crossing at t = 2 s; signed area before it = +5 m. Signed area from 2 s to 8 s = -45 m, so x(8) = -40 m. The magnitude is larger at t = 8 s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is farthest from its start at t = 2 s, 5 m away, because the velocity is zero there.', false, 'A velocity of zero marks a turning point, not the farthest distance. After the crossing the object moves the other way and keeps going, ending up farther from the start.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is farthest from its start at t = 8 s, 40 m away on the positive side.', false, 'The signed area after the crossing decides the side of the start where the object ends up. The graph shows the object is on the other side.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is farthest from its start at t = 8 s, 50 m away.', false, 'Areas on opposite sides of the time axis subtract. The net position is +5 + (-45) = -40 m, so the object is 40 m away, not 50 m.' from version_ins;
-- apphysics1-mcq-b6-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.3-b', 'mcq', 'compare slopes (instantaneous versus average velocity) of straight and curved position-time graphs', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On one set of axes, the position–time graph of object A is a straight line from the origin to x = 12 m at t = 6.0 s. The graph of object B is a parabola that starts at the origin with zero slope, curves upward, and also reaches x = 12 m at t = 6.0 s. Which statement is correct?', null, md5('apphysics1-mcq-b6-h-1.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The curved object has the larger average velocity, because it is moving fastest at the end.', false, 'Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both have an average velocity of 2.0 m/s, and their instantaneous velocities are equal at t = 3.0 s.', true, 'Correct: x = bt² with b = 12/6² gives v = 2bt. Setting 2bt equal to the line''s slope 2.0 m/s gives t = 3.0 s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two objects have the same velocity at every instant, because they start and end at the same positions.', false, 'Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two objects have equal instantaneous velocities only at t = 6.0 s, where the graphs meet.', false, 'Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.3-b-v1', 'mcq', 'compare slopes (instantaneous versus average velocity) of straight and curved position-time graphs (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two cars start from the same marker on a straight road. Car A''s position–time graph is a straight line reaching 24 m at t = 4.0 s. Car B''s graph is a parabola that begins with zero slope and also reaches 24 m at t = 4.0 s. Which statement is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The curved object has the larger average velocity, because it is moving fastest at the end.', false, 'Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The two objects have the same velocity at every instant, because they start and end at the same positions.', false, 'Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two objects have equal instantaneous velocities only at t = 4.0 s, where the graphs meet.', false, 'Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both have an average velocity of 6.0 m/s, and their instantaneous velocities are equal at t = 2.0 s.', true, 'Correct: x = bt² with b = 24/4² gives v = 2bt. Setting 2bt equal to the line''s slope 6.0 m/s gives t = 2.0 s.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.3-b-v2', 'mcq', 'compare slopes (instantaneous versus average velocity) of straight and curved position-time graphs (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two runners start from the same line on a track. Runner A''s position–time graph is a straight line reaching 20 m at t = 10 s. Runner B''s graph is a parabola that begins with zero slope and also reaches 20 m at t = 10 s. Which statement is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The curved object has the larger average velocity, because it is moving fastest at the end.', false, 'Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both have an average velocity of 2.0 m/s, and their instantaneous velocities are equal at t = 5.0 s.', true, 'Correct: x = bt² with b = 20/10² gives v = 2bt. Setting 2bt equal to the line''s slope 2.0 m/s gives t = 5.0 s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two objects have the same velocity at every instant, because they start and end at the same positions.', false, 'Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two objects have equal instantaneous velocities only at t = 10.0 s, where the graphs meet.', false, 'Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.3-b-v3', 'mcq', 'compare slopes (instantaneous versus average velocity) of straight and curved position-time graphs (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two boats leave the same dock along a straight channel. Boat A''s position–time graph is a straight line reaching 18 m at t = 6.0 s. Boat B''s graph is a parabola that begins with zero slope and also reaches 18 m at t = 6.0 s. Which statement is correct?', null, md5('apphysics1-mcq-b6-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The curved object has the larger average velocity, because it is moving fastest at the end.', false, 'Average velocity is displacement divided by time, and both objects cover the same displacement in the same time. A larger final slope does not change that average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The two objects have the same velocity at every instant, because they start and end at the same positions.', false, 'Same endpoints guarantee the same average velocity only. The curved graph has a changing slope, while the straight line has a constant slope.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two objects have equal instantaneous velocities only at t = 6.0 s, where the graphs meet.', false, 'Meeting at a point means equal positions, not equal slopes. At that point the curve is steeper than the line, so the velocities differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both have an average velocity of 3.0 m/s, and their instantaneous velocities are equal at t = 3.0 s.', true, 'Correct: x = bt² with b = 18/6² gives v = 2bt. Setting 2bt equal to the line''s slope 3.0 m/s gives t = 3.0 s.' from version_ins;
-- apphysics1-mcq-b6-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-h-1.4-a', 'mcq', 'combine and subtract signed velocities in one dimension across two or three reference frames', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a straight east–west road, car P travels east at 20 m/s and truck T travels east at 14 m/s, both measured relative to the ground. A motorcycle M travels west at 10 m/s relative to the ground. Which choice gives M''s velocity relative to P and T''s velocity relative to P?', null, md5('apphysics1-mcq-b6-h-1.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'M relative to P: 30 m/s west; T relative to P: 6 m/s west.', true, 'Correct: East positive: v_M/P = −10 − 20 = −30 m/s; v_T/P = 14 − 20 = −6 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'M relative to P: 10 m/s west; T relative to P: 6 m/s west.', false, 'The motorcycle''s 10 m/s is measured relative to the ground, not to car P. P is itself moving east at 20 m/s, so the relative speed is larger.' from version_ins
union all select gen_random_uuid(), id, 'C', 'M relative to P: 30 m/s west; T relative to P: 6 m/s east.', false, 'T moves east slower than P, so from P''s viewpoint T falls behind, toward the west. The relative velocity is v_T − v_P = −6 m/s, which points west.' from version_ins
union all select gen_random_uuid(), id, 'D', 'M relative to P: 30 m/s west; T relative to P: 34 m/s west.', false, 'Both vehicles in the second case move east, so their velocities subtract. Adding the 14 m/s and 20 m/s is correct only for objects moving in opposite directions.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.4-a-v1', 'mcq', 'combine and subtract signed velocities in one dimension across two or three reference frames (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A train moves east at 25 m/s relative to the ground. A passenger walks toward the front of the train at 2.0 m/s relative to the train. A second train on a parallel track moves west at 15 m/s relative to the ground. Which choice gives the passenger''s velocity relative to the ground and relative to the second train?', null, md5('apphysics1-mcq-b6-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ground: 23 m/s east; second train: 38 m/s east.', false, 'Walking toward the front adds to the train''s velocity, since both point east. Subtracting 2.0 m/s treats the walk as toward the rear.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ground: 27 m/s east; second train: 12 m/s east.', false, 'The second train moves west, opposite to the passenger. Relative to it, the passenger''s velocity is 27 − (−15), so the speeds add instead of subtract.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ground: 25 m/s east; second train: 40 m/s east.', false, 'The passenger''s walking speed relative to the train must be included. It adds to the 25 m/s, giving 27 m/s relative to the ground.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ground: 27 m/s east; second train: 42 m/s east.', true, 'Correct: East positive: v_p/ground = 25 + 2.0 = +27 m/s. v_p/second = 27 − (−15) = +42 m/s.' from version_ins;
-- apphysics1-mcq-b6-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b6-sv-h-1.4-a-v2', 'mcq', 'combine and subtract signed velocities in one dimension across two or three reference frames (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A moving walkway carries people east at 1.5 m/s relative to the floor. A person walks west on the walkway at 2.0 m/s relative to the walkway. A runner on the floor beside it moves east at 3.0 m/s relative to the floor. Which choice gives the person''s velocity relative to the floor and the runner''s velocity relative to the person?', null, md5('apphysics1-mcq-b6-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Person: 3.5 m/s west; runner relative to person: 6.5 m/s east.', false, 'The walkway carries the person east, which partly cancels the westward walk. The two velocities have opposite directions, so they subtract rather than add.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Person: 0.5 m/s west; runner relative to person: 2.5 m/s east.', false, 'The runner moves east and the person moves west, so their relative velocity is 3.0 − (−0.5) = 3.5 m/s. Subtracting the magnitudes gets only 2.5 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Person: 0.5 m/s west; runner relative to person: 3.5 m/s east.', true, 'Correct: East positive: v_person = +1.5 − 2.0 = −0.5 m/s. v_runner/person = 3.0 − (−0.5) = +3.5 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Person: 0.5 m/s east; runner relative to person: 2.5 m/s east.', false, 'The person''s walk of 2.0 m/s west is larger than the walkway''s 1.5 m/s east, so the net motion is westward. The direction follows the larger velocity.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b6-sv-h-1.3-a-v2','apphysics1-mcq-b6-sv-h-1.3-a-v3','apphysics1-mcq-b6-h-1.3-b','apphysics1-mcq-b6-sv-h-1.3-b-v1','apphysics1-mcq-b6-sv-h-1.3-b-v2','apphysics1-mcq-b6-sv-h-1.3-b-v3','apphysics1-mcq-b6-h-1.4-a','apphysics1-mcq-b6-sv-h-1.4-a-v1','apphysics1-mcq-b6-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b6-sv-h-1.3-a-v2','apphysics1-mcq-b6-sv-h-1.3-a-v3','apphysics1-mcq-b6-h-1.3-b','apphysics1-mcq-b6-sv-h-1.3-b-v1','apphysics1-mcq-b6-sv-h-1.3-b-v2','apphysics1-mcq-b6-sv-h-1.3-b-v3','apphysics1-mcq-b6-h-1.4-a','apphysics1-mcq-b6-sv-h-1.4-a-v1','apphysics1-mcq-b6-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
