begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-sv-h-1.3-a-v2','apphycm-mcq-b6-sv-h-1.3-a-v3','apphycm-mcq-b6-h-1.3-b','apphycm-mcq-b6-sv-h-1.3-b-v1','apphycm-mcq-b6-sv-h-1.3-b-v2','apphycm-mcq-b6-sv-h-1.3-b-v3','apphycm-mcq-b6-h-1.4-a','apphycm-mcq-b6-sv-h-1.4-a-v1','apphycm-mcq-b6-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apphycm-mcq-b6-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.3-a-v2', 'mcq', 'find final position from a velocity-time graph as initial position plus signed area, with segments below the axis counte (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, +8 m/s), (2 s, +8 m/s), (6 s, −8 m/s), (7 s, −8 m/s). The cart is at x = −10 m at t = 0. What is its position at t = 7 s?', null, md5('apphycm-mcq-b6-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = +30 m', false, 'Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = −2 m', true, 'Correct: Signed area = 16 + 0 + −8 = 8 m; x = −10 + 8 = −2 m. Absolute-area version: 40 + −10 = +30. Final velocity = −8.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = +8 m', false, 'The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −8 m', false, 'This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.3-a-v3', 'mcq', 'find final position from a velocity-time graph as initial position plus signed area, with segments below the axis counte (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The velocity of a cart on a straight track is described by straight-line segments joining these (t, v) points: (0 s, −6 m/s), (2 s, −6 m/s), (4 s, 0 m/s), (8 s, +12 m/s). The cart is at x = +20 m at t = 0. What is its position at t = 8 s?', null, md5('apphycm-mcq-b6-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = +26 m', true, 'Correct: Signed area = −12 + −6 + 24 = 6 m; x = +20 + 6 = +26 m. Absolute-area version: 42 + +20 = +62. Final velocity = +12.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = +62 m', false, 'Position change is the signed area under the v-t graph, so area below the t-axis must be subtracted. Adding every area as positive gives the total path length, not the net displacement.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = +6 m', false, 'The area under the graph gives only the displacement, the change in position. The initial position must be added to find where the cart is at the end.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = +12 m', false, 'This reads the final velocity as if it were the position. The v-t graph shows velocity, so the position comes from the accumulated area under it plus the starting position.' from version_ins;
-- apphycm-mcq-b6-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.3-b', 'mcq', 'locate maximum velocity where acceleration is zero and compute it by integrating a(t) plus the initial velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x-axis with acceleration a(t) = 6 − 2t, in SI units, for t ≥ 0. Its velocity at t = 0 is −2 m/s. What is the greatest velocity the particle reaches for t ≥ 0?', null, md5('apphycm-mcq-b6-h-1.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9 m/s', false, 'The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself.' from version_ins
union all select gen_random_uuid(), id, 'B', '7 m/s', true, 'Correct: v(t) = −2 + 6t − 1t². a = 0 at t = 6/2 = 3 s. v = −2 + 18 − 9 = 7 m/s. Without v0: 9; max a = 6; constant-a: −2 + 6·3 = 16.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 m/s', false, 'This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t).' from version_ins
union all select gen_random_uuid(), id, 'D', '16 m/s', false, 'This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.3-b-v1', 'mcq', 'locate maximum velocity where acceleration is zero and compute it by integrating a(t) plus the initial velocity (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart on a straight track has acceleration a(t) = 12 − 3t, in SI units, for t ≥ 0, and its velocity at t = 0 is +4 m/s. What is the greatest velocity the cart reaches for t ≥ 0?', null, md5('apphycm-mcq-b6-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24 m/s', false, 'The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 m/s', false, 'This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t).' from version_ins
union all select gen_random_uuid(), id, 'C', '52 m/s', false, 'This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.' from version_ins
union all select gen_random_uuid(), id, 'D', '28 m/s', true, 'Correct: v(t) = 4 + 12t − 1.5t². a = 0 at t = 12/3 = 4 s. v = 4 + 48 − 24 = 28 m/s. Without v0: 24; max a = 12; constant-a: 4 + 12·4 = 52.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.3-b-v2', 'mcq', 'locate maximum velocity where acceleration is zero and compute it by integrating a(t) plus the initial velocity (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A probe moves along a line with acceleration a(t) = 9 − 3t, in SI units, for t ≥ 0. Its velocity at t = 0 is −6 m/s. What is the greatest velocity the probe reaches for t ≥ 0?', null, md5('apphycm-mcq-b6-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13.5 m/s', false, 'The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself.' from version_ins
union all select gen_random_uuid(), id, 'B', '7.5 m/s', true, 'Correct: v(t) = −6 + 9t − 1.5t². a = 0 at t = 9/3 = 3 s. v = −6 + 27 − 13.5 = 7.5 m/s. Without v0: 13.5; max a = 9; constant-a: −6 + 9·3 = 21.' from version_ins
union all select gen_random_uuid(), id, 'C', '9 m/s', false, 'This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t).' from version_ins
union all select gen_random_uuid(), id, 'D', '21 m/s', false, 'This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.3-b-v3', 'mcq', 'locate maximum velocity where acceleration is zero and compute it by integrating a(t) plus the initial velocity (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled moves along a straight track with acceleration a(t) = 8 − 2t, in SI units, for t ≥ 0. Its velocity at t = 0 is −5 m/s. What is the greatest velocity the sled reaches for t ≥ 0?', null, md5('apphycm-mcq-b6-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16 m/s', false, 'The initial velocity is part of the total. Velocity at any time is the initial velocity plus the area under the a-t curve, so leaving v(0) out gives the change in velocity, not the velocity itself.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 m/s', false, 'This reads the peak of the acceleration curve as the peak velocity. The velocity is greatest when the acceleration is zero, and its value comes from integrating a(t), not from the maximum of a(t).' from version_ins
union all select gen_random_uuid(), id, 'C', '27 m/s', false, 'This applies v = v₀ + at with the initial acceleration for the whole time. The acceleration is not constant, since a decreases linearly with time, so the area under the a-t curve is a triangle, not a rectangle.' from version_ins
union all select gen_random_uuid(), id, 'D', '11 m/s', true, 'Correct: v(t) = −5 + 8t − 1t². a = 0 at t = 8/2 = 4 s. v = −5 + 32 − 16 = 11 m/s. Without v0: 16; max a = 8; constant-a: −5 + 8·4 = 27.' from version_ins;
-- apphycm-mcq-b6-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-h-1.4-a', 'mcq', 'use relative (closing) speed in one dimension for pursuit and approach, then convert time back to ground-frame distance ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Car A travels east at 30 m/s on a straight road, 90 m behind car B, which travels east at 24 m/s. Both speeds are measured relative to the road and stay constant. Car A catches car B at a certain instant. How far does car A travel, measured on the road, from the moment the gap is 90 m until it catches car B?', null, md5('apphycm-mcq-b6-h-1.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '450 m', true, 'Correct: Closing speed = 6 m/s; t = 90/6 = 15 s; distance = 30·15 = 450 m. Other object: 24·15 = 360 m. Wrong closing speed 54: t = 1.667 s → 50 m. Gap = 90 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '360 m', false, 'This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time.' from version_ins
union all select gen_random_uuid(), id, 'C', '50 m', false, 'The closing speed was found by adding the speeds, which applies only when the objects approach each other. Here they move the same way, so the gap closes at the difference of the speeds.' from version_ins
union all select gen_random_uuid(), id, 'D', '90 m', false, 'This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.4-a-v1', 'mcq', 'use relative (closing) speed in one dimension for pursuit and approach, then convert time back to ground-frame distance  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two trains approach each other on a straight track, 140 m apart. Train A moves east at 20 m/s and train B moves west at 15 m/s, both relative to the ground and constant. How far does train A travel relative to the ground before the trains meet?', null, md5('apphycm-mcq-b6-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 m', false, 'This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time.' from version_ins
union all select gen_random_uuid(), id, 'B', '560 m', false, 'The closing speed was found by subtracting the speeds, which applies only when the objects move the same way. Here they approach each other, so the gap closes at the sum of the speeds.' from version_ins
union all select gen_random_uuid(), id, 'C', '140 m', false, 'This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.' from version_ins
union all select gen_random_uuid(), id, 'D', '80 m', true, 'Correct: Closing speed = 35 m/s; t = 140/35 = 4 s; distance = 20·4 = 80 m. Other object: 15·4 = 60 m. Wrong closing speed 5: t = 28 s → 560 m. Gap = 140 m.' from version_ins;
-- apphycm-mcq-b6-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-b6-sv-h-1.4-a-v2', 'mcq', 'use relative (closing) speed in one dimension for pursuit and approach, then convert time back to ground-frame distance  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A runner jogs east at 12 m/s relative to the ground along a straight path. A cyclist, 60 m behind her, rides east at 18 m/s relative to the ground. Both speeds stay constant. How far does the runner travel relative to the ground from the moment the gap is 60 m until the cyclist catches her?', null, md5('apphycm-mcq-b6-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '180 m', false, 'This is the distance traveled by the other object during the same time. The question asks for the distance for the named object, found from its own speed multiplied by the common time.' from version_ins
union all select gen_random_uuid(), id, 'B', '24 m', false, 'The closing speed was found by adding the speeds, which applies only when the objects approach each other. Here they move the same way, so the gap closes at the difference of the speeds.' from version_ins
union all select gen_random_uuid(), id, 'C', '120 m', true, 'Correct: Closing speed = 6 m/s; t = 60/6 = 10 s; distance = 12·10 = 120 m. Other object: 18·10 = 180 m. Wrong closing speed 30: t = 2 s → 24 m. Gap = 60 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '60 m', false, 'This is only the initial separation. Each object keeps moving while the gap closes, so the distance traveled by one object is its own speed multiplied by the time until they meet, not the gap itself.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-b6-sv-h-1.3-a-v2','apphycm-mcq-b6-sv-h-1.3-a-v3','apphycm-mcq-b6-h-1.3-b','apphycm-mcq-b6-sv-h-1.3-b-v1','apphycm-mcq-b6-sv-h-1.3-b-v2','apphycm-mcq-b6-sv-h-1.3-b-v3','apphycm-mcq-b6-h-1.4-a','apphycm-mcq-b6-sv-h-1.4-a-v1','apphycm-mcq-b6-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-b6-sv-h-1.3-a-v2','apphycm-mcq-b6-sv-h-1.3-a-v3','apphycm-mcq-b6-h-1.3-b','apphycm-mcq-b6-sv-h-1.3-b-v1','apphycm-mcq-b6-sv-h-1.3-b-v2','apphycm-mcq-b6-sv-h-1.3-b-v3','apphycm-mcq-b6-h-1.4-a','apphycm-mcq-b6-sv-h-1.4-a-v1','apphycm-mcq-b6-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
