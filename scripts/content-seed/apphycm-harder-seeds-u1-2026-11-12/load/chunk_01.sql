begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-h-1.1-a','apphycm-mcq-b6-sv-h-1.1-a-v1','apphycm-mcq-b6-sv-h-1.1-a-v2','apphycm-mcq-b6-sv-h-1.1-a-v3','apphycm-mcq-b6-h-1.1-b','apphycm-mcq-b6-sv-h-1.1-b-v1','apphycm-mcq-b6-sv-h-1.1-b-v2','apphycm-mcq-b6-sv-h-1.1-b-v3','apphycm-mcq-b6-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apphycm-mcq-b6-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.1-a', 'mcq', 'distinguish total distance (path length) from displacement (signed net change in position) when a position function reve', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with position x(t) = t³ − 12t² + 36t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 7 s, which choice gives the total distance traveled and the displacement?', null, md5('apphycm-mcq-b6-h-1.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Distance 7 m; displacement +7 m.', false, 'Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Distance 71 m; displacement +7 m.', true, 'Correct: v = 3at² + 2bt + c = 0 gives turning points t = 2, 6 s. Positions at t = 0, 2, 6, 7: x = 0, 32, 0, 7 m. Legs = 32, 32, 7 m, distance = 71 m. Displacement = 7 − 0 = 7 m. Without last leg: 71 − 7 = 64 m.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Distance 71 m; displacement +71 m.', false, 'Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Distance 64 m; displacement +7 m.', false, 'The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.1-a-v1', 'mcq', 'distinguish total distance (path length) from displacement (signed net change in position) when a position function reve (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with position x(t) = t³ − 6t² + 9t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 4 s, which choice gives the total distance traveled and the displacement?', null, md5('apphycm-mcq-b6-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Distance 4 m; displacement +4 m.', false, 'Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Distance 12 m; displacement +4 m.', true, 'Correct: v = 3at² + 2bt + c = 0 gives turning points t = 1, 3 s. Positions at t = 0, 1, 3, 4: x = 0, 4, 0, 4 m. Legs = 4, 4, 4 m, distance = 12 m. Displacement = 4 − 0 = 4 m. Without last leg: 12 − 4 = 8 m.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Distance 12 m; displacement +12 m.', false, 'Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Distance 8 m; displacement +4 m.', false, 'The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.1-a-v2', 'mcq', 'distinguish total distance (path length) from displacement (signed net change in position) when a position function reve (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with position x(t) = t³ − 9t² + 24t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 5 s, which choice gives the total distance traveled and the displacement?', null, md5('apphycm-mcq-b6-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Distance 28 m; displacement +20 m.', true, 'Correct: v = 3at² + 2bt + c = 0 gives turning points t = 2, 4 s. Positions at t = 0, 2, 4, 5: x = 0, 20, 16, 20 m. Legs = 20, 4, 4 m, distance = 28 m. Displacement = 20 − 0 = 20 m. Without last leg: 28 − 4 = 24 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Distance 20 m; displacement +20 m.', false, 'Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Distance 28 m; displacement +28 m.', false, 'Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Distance 24 m; displacement +20 m.', false, 'The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.1-a-v3', 'mcq', 'distinguish total distance (path length) from displacement (signed net change in position) when a position function reve (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with position x(t) = −t³ + 6t² − 9t, where x is in meters and t is in seconds. Over the interval from t = 0 to t = 4 s, which choice gives the total distance traveled and the displacement?', null, md5('apphycm-mcq-b6-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Distance 4 m; displacement −4 m.', false, 'Distance is the total path length, which adds up every leg of the trip including the legs where the particle moves back. Taking the magnitude of the net displacement only gives the straight-line gap between start and end.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Distance 12 m; displacement +12 m.', false, 'Displacement is the signed net change in position x(T) − x(0), not the path length. It equals the distance only when the particle never reverses direction, and here the velocity changes sign inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Distance 12 m; displacement −4 m.', true, 'Correct: v = 3at² + 2bt + c = 0 gives turning points t = 1, 3 s. Positions at t = 0, 1, 3, 4: x = 0, −4, 0, −4 m. Legs = 4, 4, 4 m, distance = 12 m. Displacement = −4 − 0 = −4 m. Without last leg: 12 − 4 = 8 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Distance 8 m; displacement −4 m.', false, 'The path length must include the final leg after the last turning point. Stopping the sum at the last time v = 0 leaves out the distance covered in the last stretch of the interval.' from version_ins;
-- apphycm-mcq-b6-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.1-b', 'mcq', 'compute signed average acceleration through a rebound where velocity changes sign, avoiding speed-difference and reverse', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball travels along a straight line toward a wall. Take the x-axis to point toward the wall, so the ball''s velocity just before impact is +8 m/s. It rebounds with a velocity of 6 m/s directly away from the wall, and contact lasts 0.020 s. Which choice gives the ball''s average acceleration during contact, on the same x-axis?', null, md5('apphycm-mcq-b6-h-1.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−700 m/s²', true, 'Correct: Δv = vf − vi = −6 − (8) = −14 m/s; a = −14/0.02 = −700 m/s². Wrong: negated = 700; (|vi|−|vf|)/Δt = 100; (|vf|−|vi|)/Δt = −100.' from version_ins
union all select gen_random_uuid(), id, 'B', '+700 m/s²', false, 'Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change.' from version_ins
union all select gen_random_uuid(), id, 'C', '+100 m/s²', false, 'The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way.' from version_ins
union all select gen_random_uuid(), id, 'D', '−100 m/s²', false, 'This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.1-b-v1', 'mcq', 'compute signed average acceleration through a rebound where velocity changes sign, avoiding speed-difference and reverse (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rubber ball falls onto a floor. Take the y-axis to point upward. Just before impact the ball moves at 5 m/s downward, and just after impact it moves at 3 m/s upward. The impact lasts 0.040 s. Which choice gives the ball''s average acceleration during the impact, in the same y-direction convention?', null, md5('apphycm-mcq-b6-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−200 m/s²', false, 'Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change.' from version_ins
union all select gen_random_uuid(), id, 'B', '+50 m/s²', false, 'The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way.' from version_ins
union all select gen_random_uuid(), id, 'C', '+200 m/s²', true, 'Correct: Δv = vf − vi = 3 − (−5) = 8 m/s; a = 8/0.04 = 200 m/s². Wrong: negated = −200; (|vi|−|vf|)/Δt = 50; (|vf|−|vi|)/Δt = −50.' from version_ins
union all select gen_random_uuid(), id, 'D', '−50 m/s²', false, 'This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.1-b-v2', 'mcq', 'compute signed average acceleration through a rebound where velocity changes sign, avoiding speed-difference and reverse (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart on a horizontal track uses an x-axis that points east. The cart moves west at 12 m/s, strikes a spring bumper, and leaves moving east at 4 m/s. The collision lasts 0.10 s. Which choice gives the cart''s average acceleration during the collision on this axis?', null, md5('apphycm-mcq-b6-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−160 m/s²', false, 'Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change.' from version_ins
union all select gen_random_uuid(), id, 'B', '+80 m/s²', false, 'The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way.' from version_ins
union all select gen_random_uuid(), id, 'C', '+160 m/s²', true, 'Correct: Δv = vf − vi = 4 − (−12) = 16 m/s; a = 16/0.1 = 160 m/s². Wrong: negated = −160; (|vi|−|vf|)/Δt = 80; (|vf|−|vi|)/Δt = −80.' from version_ins
union all select gen_random_uuid(), id, 'D', '−80 m/s²', false, 'This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.1-b-v3', 'mcq', 'compute signed average acceleration through a rebound where velocity changes sign, avoiding speed-difference and reverse (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A puck slides across ice toward a board. A student chooses an x-axis that points west, and the puck is moving east when it strikes the board at 10 m/s. It rebounds westward at 6 m/s, and the contact time is 0.050 s. Using the student''s axis, which choice gives the puck''s average acceleration during contact?', null, md5('apphycm-mcq-b6-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−320 m/s²', false, 'Average acceleration is (final velocity − initial velocity)/Δt. Subtracting in the other order, initial minus final, flips the sign and describes the opposite direction of the velocity change.' from version_ins
union all select gen_random_uuid(), id, 'B', '+80 m/s²', false, 'The velocity reverses, so the signed change in velocity is the sum of the two speeds, not their difference. Using initial speed minus final speed treats the signed velocities as if both pointed the same way.' from version_ins
union all select gen_random_uuid(), id, 'C', '−80 m/s²', false, 'This uses final speed minus initial speed, which ignores that the velocity changes sign. The change in velocity runs from one sign to the other, so its magnitude is the sum of the two speeds.' from version_ins
union all select gen_random_uuid(), id, 'D', '+320 m/s²', true, 'Correct: Δv = vf − vi = 6 − (−10) = 16 m/s; a = 16/0.05 = 320 m/s². Wrong: negated = −320; (|vi|−|vf|)/Δt = 80; (|vf|−|vi|)/Δt = −80.' from version_ins;
-- apphycm-mcq-b6-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.2-a', 'mcq', 'use the relative signs of velocity and acceleration, obtained by differentiating, to decide speeding up or slowing down', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = t² − 6t + 8, in SI units. At t = 1.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?', null, md5('apphycm-mcq-b6-h-1.2-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = −4 m/s², speeding up.', false, 'The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 4 m/s², speeding up.', false, 'This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = −4 m/s², slowing down.', true, 'Correct: v = 3 m/s, a = −4 m/s²; v·a = −12 so slowing down. dv/dt = 2t − 6 → at t = 1: −4; v(1) = 1 − 6 + 8 = 3. Wrong slip value = −5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −5 m/s², slowing down.', false, 'Differentiating t² gives 2t, not t. Using a = t − 6 drops the factor of 2 from the power rule, which gives the wrong magnitude of the acceleration.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-h-1.1-a','apphycm-mcq-b6-sv-h-1.1-a-v1','apphycm-mcq-b6-sv-h-1.1-a-v2','apphycm-mcq-b6-sv-h-1.1-a-v3','apphycm-mcq-b6-h-1.1-b','apphycm-mcq-b6-sv-h-1.1-b-v1','apphycm-mcq-b6-sv-h-1.1-b-v2','apphycm-mcq-b6-sv-h-1.1-b-v3','apphycm-mcq-b6-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-b6-h-1.1-a','apphycm-mcq-b6-sv-h-1.1-a-v1','apphycm-mcq-b6-sv-h-1.1-a-v2','apphycm-mcq-b6-sv-h-1.1-a-v3','apphycm-mcq-b6-h-1.1-b','apphycm-mcq-b6-sv-h-1.1-b-v1','apphycm-mcq-b6-sv-h-1.1-b-v2','apphycm-mcq-b6-sv-h-1.1-b-v3','apphycm-mcq-b6-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
