begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-sv-h-1.2-a-v1','apphycm-mcq-b6-sv-h-1.2-a-v2','apphycm-mcq-b6-sv-h-1.2-a-v3','apphycm-mcq-b6-h-1.2-b','apphycm-mcq-b6-sv-h-1.2-b-v1','apphycm-mcq-b6-sv-h-1.2-b-v2','apphycm-mcq-b6-sv-h-1.2-b-v3','apphycm-mcq-b6-h-1.3-a','apphycm-mcq-b6-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apphycm-mcq-b6-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.2-a-v1', 'mcq', 'use the relative signs of velocity and acceleration, obtained by differentiating, to decide speeding up or slowing down (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = t² − 4t, in SI units. At t = 1.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?', null, md5('apphycm-mcq-b6-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = −2 m/s², slowing down.', false, 'The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 2 m/s², slowing down.', false, 'This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = −3 m/s², speeding up.', false, 'Differentiating t² gives 2t, not t. Using a = t − 4 drops the factor of 2 from the power rule, which gives the wrong magnitude of the acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −2 m/s², speeding up.', true, 'Correct: v = −3 m/s, a = −2 m/s²; v·a = 6 so speeding up. dv/dt = 2t − 4 → at t = 1: −2; v(1) = 1 − 4 = −3. Wrong slip value = −3.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.2-a-v2', 'mcq', 'use the relative signs of velocity and acceleration, obtained by differentiating, to decide speeding up or slowing down (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bead moves along a wire with position x(t) = t³ − 6t² + 5t, in SI units. At t = 3.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?', null, md5('apphycm-mcq-b6-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 6 m/s², speeding up.', false, 'The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = −6 m/s², speeding up.', false, 'This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 18 m/s², slowing down.', false, 'Differentiating only the t³ term twice gives 6t = 18, but the −6t² term also contributes −12 to the acceleration. Dropping it gives the wrong value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 6 m/s², slowing down.', true, 'Correct: v = −4 m/s, a = 6 m/s²; v·a = −24 so slowing down. v = 3t² − 12t + 5, a = 6t − 12; at t = 3: v = 27 − 36 + 5 = −4, a = 18 − 12 = 6. Slip: 6t = 18. Wrong slip value = 18.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.2-a-v3', 'mcq', 'use the relative signs of velocity and acceleration, obtained by differentiating, to decide speeding up or slowing down (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled moves along a straight track with position x(t) = t³ − 3t² + 2, in SI units. At t = 3.0 s, which choice correctly gives its acceleration and whether it is speeding up or slowing down?', null, md5('apphycm-mcq-b6-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 12 m/s², slowing down.', false, 'The acceleration value is right, but the verdict is reversed. An object speeds up when its velocity and acceleration have the same sign and slows down when they have opposite signs, so the sign of acceleration alone does not decide it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = −12 m/s², slowing down.', false, 'This reverses the sign of the derivative and then judges consistently from the wrong sign. The acceleration is the slope dv/dt evaluated at the given time, and its sign must be compared with the sign of the velocity there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 18 m/s², speeding up.', false, 'Differentiating only the t³ term twice gives 6t = 18, but the −3t² term also contributes −6 to the acceleration. Dropping it gives the wrong value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 12 m/s², speeding up.', true, 'Correct: v = 9 m/s, a = 12 m/s²; v·a = 108 so speeding up. v = 3t² − 6t, a = 6t − 6; at t = 3: v = 27 − 18 = 9, a = 18 − 6 = 12. Slip: 6t = 18. Wrong slip value = 18.' from version_ins;
-- apphycm-mcq-b6-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.2-b', 'mcq', 'recognize that average velocity is displacement over time (area under v-t) and not the endpoint average or midpoint valu', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with velocity v(t) = 3t², in SI units. What is its average velocity over the interval from t = 0 to t = 4.0 s?', null, md5('apphycm-mcq-b6-h-1.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16 m/s', true, 'Correct: ∫v dt from 0 to 4 = 64 m; average = 64/4 = 16 m/s. Endpoint average = (0 + 48)/2 = 24; v at midpoint (2 s) = 12; v(4) = 48.' from version_ins
union all select gen_random_uuid(), id, 'B', '24 m/s', false, 'Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 m/s', false, 'The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time.' from version_ins
union all select gen_random_uuid(), id, 'D', '48 m/s', false, 'This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.2-b-v1', 'mcq', 'recognize that average velocity is displacement over time (area under v-t) and not the endpoint average or midpoint valu (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rocket sled moves along a straight track with velocity v(t) = 6t², in SI units. What is its average velocity over the first 3.0 s of motion?', null, md5('apphycm-mcq-b6-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '27 m/s', false, 'Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average.' from version_ins
union all select gen_random_uuid(), id, 'B', '13.5 m/s', false, 'The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time.' from version_ins
union all select gen_random_uuid(), id, 'C', '54 m/s', false, 'This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.' from version_ins
union all select gen_random_uuid(), id, 'D', '18 m/s', true, 'Correct: ∫v dt from 0 to 3 = 54 m; average = 54/3 = 18 m/s. Endpoint average = (0 + 54)/2 = 27; v at midpoint (1.5 s) = 13.5; v(3) = 54.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.2-b-v2', 'mcq', 'recognize that average velocity is displacement over time (area under v-t) and not the endpoint average or midpoint valu (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A probe moves along a line with velocity v(t) = t³, in SI units. What is its average velocity from t = 0 to t = 2.0 s?', null, md5('apphycm-mcq-b6-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4 m/s', false, 'Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average.' from version_ins
union all select gen_random_uuid(), id, 'B', '1 m/s', false, 'The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 m/s', true, 'Correct: ∫v dt from 0 to 2 = 4 m; average = 4/2 = 2 m/s. Endpoint average = (0 + 8)/2 = 4; v at midpoint (1 s) = 1; v(2) = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', '8 m/s', false, 'This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.2-b-v3', 'mcq', 'recognize that average velocity is displacement over time (area under v-t) and not the endpoint average or midpoint valu (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart rolls along a straight track with velocity v(t) = 12 − t², in SI units. What is its average velocity from t = 0 to t = 3.0 s?', null, md5('apphycm-mcq-b6-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9 m/s', true, 'Correct: ∫v dt from 0 to 3 = 27 m; average = 27/3 = 9 m/s. Endpoint average = (12 + 3)/2 = 7.5; v at midpoint (1.5 s) = 9.75; v(3) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '7.5 m/s', false, 'Averaging the initial and final velocities is valid only when acceleration is constant. Here a = dv/dt changes with time, so the velocity graph is curved and this overestimates or misstates the time-average.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.75 m/s', false, 'The velocity at the midpoint time is not the average velocity for a curved v(t). The average velocity is the displacement, the area under the curve, divided by the elapsed time.' from version_ins
union all select gen_random_uuid(), id, 'D', '3 m/s', false, 'This is the instantaneous velocity at the end of the interval. Average velocity is the displacement divided by the time, which uses the area under the whole v(t) curve.' from version_ins;
-- apphycm-mcq-b6-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.3-a', 'mcq', 'find final position from a velocity-time graph as initial position plus signed area, with segments below the axis counte', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, 0 m/s), (2 s, +6 m/s), (5 s, +6 m/s), (8 s, −4 m/s). The cart is at x = −3 m at t = 0. What is its position at t = 8 s?', null, md5('apphycm-mcq-b6-h-1.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = +28.8 m', false, 'Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = +24 m', true, 'Correct: Signed area = 6 + 18 + 3 = 27 m; x = −3 + 27 = +24 m. Absolute-area version: 31.8 + −3 = +28.8. Final velocity = −4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = +27 m', false, 'The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −4 m', false, 'This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.3-a-v1', 'mcq', 'find final position from a velocity-time graph as initial position plus signed area, with segments below the axis counte (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, −4 m/s), (3 s, −4 m/s), (5 s, +6 m/s), (9 s, +6 m/s). The cart is at x = +5 m at t = 0. What is its position at t = 9 s?', null, md5('apphycm-mcq-b6-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = +46.2 m', false, 'Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = +14 m', false, 'The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = +19 m', true, 'Correct: Signed area = −12 + 2 + 24 = 14 m; x = +5 + 14 = +19 m. Absolute-area version: 41.2 + +5 = +46.2. Final velocity = +6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = +6 m', false, 'This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-sv-h-1.2-a-v1','apphycm-mcq-b6-sv-h-1.2-a-v2','apphycm-mcq-b6-sv-h-1.2-a-v3','apphycm-mcq-b6-h-1.2-b','apphycm-mcq-b6-sv-h-1.2-b-v1','apphycm-mcq-b6-sv-h-1.2-b-v2','apphycm-mcq-b6-sv-h-1.2-b-v3','apphycm-mcq-b6-h-1.3-a','apphycm-mcq-b6-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-b6-sv-h-1.2-a-v1','apphycm-mcq-b6-sv-h-1.2-a-v2','apphycm-mcq-b6-sv-h-1.2-a-v3','apphycm-mcq-b6-h-1.2-b','apphycm-mcq-b6-sv-h-1.2-b-v1','apphycm-mcq-b6-sv-h-1.2-b-v2','apphycm-mcq-b6-sv-h-1.2-b-v3','apphycm-mcq-b6-h-1.3-a','apphycm-mcq-b6-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
