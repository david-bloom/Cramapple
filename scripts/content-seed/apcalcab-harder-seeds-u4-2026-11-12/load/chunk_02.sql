begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.2-a-v1','apcalcab-mcq-b4-sv-h-4.2-a-v2','apcalcab-mcq-b4-sv-h-4.2-a-v3','apcalcab-mcq-b4-h-4.2-b','apcalcab-mcq-b4-sv-h-4.2-b-v1','apcalcab-mcq-b4-sv-h-4.2-b-v2','apcalcab-mcq-b4-sv-h-4.2-b-v3','apcalcab-mcq-b4-h-4.3-a','apcalcab-mcq-b4-sv-h-4.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-sv-h-4.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.2-a-v1', 'mcq', 'decide direction and speeding up or slowing down from the signs of v and a. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart moves along a track with velocity v(t) = 2t² − 9t + 7 for t ≥ 0. Which statement describes the cart''s motion at t = 2?', null, md5('apcalcab-mcq-b4-sv-h-4.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cart is moving left and slowing down.', false, 'At t = 2 the velocity is −3 and the acceleration a(2) = 4(2) − 9 = −1. Both are negative, so the speed is increasing, not decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cart is moving right and speeding up.', false, 'The sign of v(2) = −3 shows the cart is moving left, not right. Speeding up describes the change in speed, not the direction of motion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cart is moving left and speeding up.', true, 'Correct: v(2) = 8 − 18 + 7 = −3 (left). a(t) = 4t − 9, so a(2) = −1. Same signs mean the speed increases: moving left and speeding up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cart is moving right and slowing down.', false, 'The cart moves left because v(2) = −3, and with a(2) = −1 also negative the speed is increasing, so both parts of this statement are wrong.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.2-a-v2', 'mcq', 'decide direction and speeding up or slowing down from the signs of v and a. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bead slides along a wire with velocity v(t) = −t² + 6t − 5 for t ≥ 0. Which statement describes the bead''s motion at t = 4?', null, md5('apcalcab-mcq-b4-sv-h-4.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The bead is moving right and speeding up.', false, 'V(4) = 3 is positive, but a(4) = −2(4) + 6 = −2 is negative. The signs differ, so the bead is slowing down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The bead is moving left and slowing down.', false, 'The direction comes from v(4) = 3, which is positive, so the bead moves right. The negative acceleration is the reason it slows, not a sign of leftward motion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The bead is moving left and speeding up.', false, 'The negative acceleration a(4) = −2 does not mean leftward motion or a rising speed. The velocity v(4) = 3 is positive and opposite in sign to a(4).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The bead is moving right and slowing down.', true, 'Correct: v(4) = −16 + 24 − 5 = 3 (right). a(t) = −2t + 6, so a(4) = −2. Opposite signs mean the speed decreases: moving right and slowing down.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.2-a-v3', 'mcq', 'decide direction and speeding up or slowing down from the signs of v and a. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = t³ − 6t² + 9t for t ≥ 0. Which statement describes the particle''s motion at t = 5?', null, md5('apcalcab-mcq-b4-sv-h-4.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The particle is moving right and speeding up.', true, 'Correct: v(t) = s′(t) = 3t² − 12t + 9, v(5) = 24 > 0 (right). a(t) = s″(t) = 6t − 12, a(5) = 18 > 0. Same signs: speeding up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The particle is moving right and slowing down.', false, 'At t = 5 the velocity is positive and the acceleration is positive as well, s″(5) = 6(5) − 12 = 18, so the speed is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The particle is moving left and speeding up.', false, 'V(5) = 3(25) − 60 + 9 = 24 is positive, so the particle moves right. Position is positive, but only the sign of the velocity gives direction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The particle is moving left and slowing down.', false, 'Both signs are positive at t = 5: v(5) = 24 and a(5) = 18. The particle moves right and speeds up, so neither part of this statement holds.' from version_ins;
-- apcalcab-mcq-b4-h-4.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.2-b', 'mcq', 'find total distance traveled from a position function by locating the times the particle reverses direction.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = t³ − 9t² + 24t meters for 0 ≤ t ≤ 5 seconds. What is the total distance traveled by the particle on this interval?', null, md5('apcalcab-mcq-b4-h-4.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28 meters', true, 'Correct: v(t) = 3t² − 18t + 24 = 3(t − 2)(t − 4), so the particle reverses at t = 2 and t = 4. s(0) = 0, s(2) = 20, s(4) = 16, s(5) = 20. Distance = 20 + |16 − 20| + |20 − 16| = 20 + 4 + 4 = 28.' from version_ins
union all select gen_random_uuid(), id, 'B', '20 meters', false, 'This is the displacement s(5) − s(0) = 20. The particle reverses direction at t = 2 and t = 4, so the distance traveled is larger than the displacement.' from version_ins
union all select gen_random_uuid(), id, 'C', '24 meters', false, 'This leaves out the middle leg from t = 2 to t = 4, where the particle moves 4 meters in the negative direction, and counts only 20 + 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '36 meters', false, 'This adds the positions s(2) = 20 and s(4) = 16 instead of adding the sizes of the changes in position on each leg.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.2-b-v1', 'mcq', 'find total distance traveled from a position function by locating the times the particle reverses direction. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = 2t³ − 15t² + 24t meters for 0 ≤ t ≤ 6 seconds. What is the total distance traveled by the particle on this interval?', null, md5('apcalcab-mcq-b4-sv-h-4.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '36 meters', false, 'This is the displacement s(6) − s(0) = 36. The particle reverses direction at t = 1 and t = 4, so the total distance is larger.' from version_ins
union all select gen_random_uuid(), id, 'B', '90 meters', true, 'Correct: v(t) = 6t² − 30t + 24 = 6(t − 1)(t − 4). s(0) = 0, s(1) = 11, s(4) = −16, s(6) = 36. Distance = 11 + |−16 − 11| + |36 − (−16)| = 11 + 27 + 52 = 90.' from version_ins
union all select gen_random_uuid(), id, 'C', '38 meters', false, 'This stops at t = 4 and counts only the first two legs, 11 + 27, leaving out the final leg from t = 4 to t = 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '63 meters', false, 'This adds the sizes of the positions at the turning points and the end, 11 + 16 + 36, instead of the changes in position on each leg.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.2-b-v2', 'mcq', 'find total distance traveled from a position function by locating the times the particle reverses direction. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = t³ − 12t² + 36t centimeters for 0 ≤ t ≤ 7 seconds. What is the total distance traveled by the particle on this interval?', null, md5('apcalcab-mcq-b4-sv-h-4.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7 centimeters', false, 'This is the displacement s(7) − s(0) = 7. The particle reverses direction at t = 2 and t = 6, so the distance traveled is larger.' from version_ins
union all select gen_random_uuid(), id, 'B', '64 centimeters', false, 'This leaves out the final leg from t = 6 to t = 7, where the particle moves 7 centimeters, and counts only 32 + 32.' from version_ins
union all select gen_random_uuid(), id, 'C', '57 centimeters', false, 'This subtracts the final 7 centimeters, 64 − 7, instead of adding it, as if the last leg took the particle back over earlier distance.' from version_ins
union all select gen_random_uuid(), id, 'D', '71 centimeters', true, 'Correct: v(t) = 3t² − 24t + 36 = 3(t − 2)(t − 6). s(0) = 0, s(2) = 32, s(6) = 0, s(7) = 7. Distance = 32 + 32 + 7 = 71.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.2-b-v3', 'mcq', 'find total distance traveled from a position function by locating the times the particle reverses direction. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a line with position s(t) = t³ − 6t² + 9t feet for 0 ≤ t ≤ 5 seconds. What is the total distance traveled by the particle on this interval?', null, md5('apcalcab-mcq-b4-sv-h-4.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 feet', false, 'This is the displacement s(5) − s(0) = 20. The particle reverses direction at t = 1 and t = 3, so the total distance is larger.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 feet', false, 'This stops at t = 3 and counts only the first two legs, 4 + 4, leaving out the final leg from t = 3 to t = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '28 feet', true, 'Correct: v(t) = 3t² − 12t + 9 = 3(t − 1)(t − 3). s(0) = 0, s(1) = 4, s(3) = 0, s(5) = 20. Distance = 4 + 4 + 20 = 28.' from version_ins
union all select gen_random_uuid(), id, 'D', '24 feet', false, 'This counts the first leg and the last leg, 4 + 20, and leaves out the middle leg from t = 1 to t = 3.' from version_ins;
-- apcalcab-mcq-b4-h-4.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.3-a', 'mcq', 'read increasing or decreasing and concavity from a table of a rate of change, and describe it as speeding up or slowing ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cup of tea cools after it is poured. Its temperature is T(t) degrees Celsius at time t minutes, and selected values of T′(t) are given in the table. Assume T′ keeps the trend shown for 0 < t < 15.
t (minutes):   0   5   10   15
T′(t) (degrees per minute):   −8.0   −5.2   −3.4   −2.2
Which statement is true for 0 < t < 15?', null, md5('apcalcab-mcq-b4-h-4.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T is decreasing and its rate of decrease is shrinking, so the graph of T is concave up.', true, 'Correct: T′ < 0 in the table, so T is decreasing. T′ increases from −8.0 to −2.2, so T″ > 0 and the graph is concave up; the cooling slows down because |T′| shrinks.' from version_ins
union all select gen_random_uuid(), id, 'B', 'T is decreasing, and T″ < 0 because T′ < 0.', false, 'The sign of T′ tells whether T is increasing or decreasing. The sign of T″ comes from whether T′ is increasing or decreasing, and the table shows T′ increasing from −8.0 toward −2.2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T is increasing, because the values of T′ are increasing.', false, 'T′ is negative throughout the table, so T is decreasing. The fact that T′ is increasing says only that the graph of T is concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T is decreasing and its rate of decrease is growing, so the graph of T is concave down.', false, 'The size of the rate of decrease is shrinking from 8.0 to 2.2 degrees per minute, so the tea is cooling more slowly, not faster.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.3-a-v1', 'mcq', 'read increasing or decreasing and concavity from a table of a rate of change, and describe it as speeding up or slowing  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A social media account has N(t) thousand followers at time t weeks, and selected values of N′(t) are given in the table. Assume N′ keeps the trend shown for 0 < t < 12.
t (weeks):   0   4   8   12
N′(t) (thousands per week):   6.0   4.1   2.3   0.8
Which statement is true for 0 < t < 12?', null, md5('apcalcab-mcq-b4-sv-h-4.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'N is decreasing, because the values of N′ are decreasing.', false, 'N′ is positive throughout the table, so N is increasing. The values of N′ decreasing says only that the graph of N is concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'N is increasing and concave up, because N′ is positive.', false, 'A positive N′ shows N is increasing, but concavity depends on whether N′ is rising or falling. N′ falls from 6.0 to 0.8, so N is concave down.' from version_ins
union all select gen_random_uuid(), id, 'C', 'N is increasing and growth is slowing, so the graph of N is concave down.', true, 'Correct: N′ > 0 so N is increasing. N′ decreases from 6.0 to 0.8, so N″ < 0 and the graph is concave down: followers are still rising, but more slowly each week.' from version_ins
union all select gen_random_uuid(), id, 'D', 'N is increasing at a constant rate, because N′ never changes sign.', false, 'N′ is not constant. It drops from 6.0 to 0.8 thousand followers per week, so the growth rate is changing even though its sign is not.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.2-a-v1','apcalcab-mcq-b4-sv-h-4.2-a-v2','apcalcab-mcq-b4-sv-h-4.2-a-v3','apcalcab-mcq-b4-h-4.2-b','apcalcab-mcq-b4-sv-h-4.2-b-v1','apcalcab-mcq-b4-sv-h-4.2-b-v2','apcalcab-mcq-b4-sv-h-4.2-b-v3','apcalcab-mcq-b4-h-4.3-a','apcalcab-mcq-b4-sv-h-4.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-sv-h-4.2-a-v1','apcalcab-mcq-b4-sv-h-4.2-a-v2','apcalcab-mcq-b4-sv-h-4.2-a-v3','apcalcab-mcq-b4-h-4.2-b','apcalcab-mcq-b4-sv-h-4.2-b-v1','apcalcab-mcq-b4-sv-h-4.2-b-v2','apcalcab-mcq-b4-sv-h-4.2-b-v3','apcalcab-mcq-b4-h-4.3-a','apcalcab-mcq-b4-sv-h-4.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
