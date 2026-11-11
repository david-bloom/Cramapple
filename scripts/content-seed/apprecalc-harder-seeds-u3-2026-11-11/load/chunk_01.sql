begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-h-3.1-a','apprecalc-mcq-sv-h-3.1-a-v1','apprecalc-mcq-sv-h-3.1-a-v2','apprecalc-mcq-sv-h-3.1-a-v3','apprecalc-mcq-h-3.1-b','apprecalc-mcq-sv-h-3.1-b-v1','apprecalc-mcq-sv-h-3.1-b-v2','apprecalc-mcq-sv-h-3.1-b-v3','apprecalc-mcq-h-3.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-h-3.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-h-3.1-a', 'mcq', 'Evaluate a periodic function using the period', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is periodic with period 12. For which of the following expressions is it NOT guaranteed that the expression equals f(x) for all x?', null, md5('apprecalc-mcq-h-3.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x + 24)', false, 'A shift of 24 is two full periods, so f(x + 24) = f(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x + 6)', true, 'Correct: a shift by any whole number of periods leaves f unchanged: 24 = 2·12, −36 = −3·12 and 60 = 5·12, but 6 is half a period.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x − 36)', false, 'A shift of −36 is three full periods backward, so f(x − 36) = f(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x + 60)', false, 'A shift of 60 is five full periods, so f(x + 60) = f(x) for all x.' from version_ins;
-- apprecalc-mcq-sv-h-3.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.1-a-v1', 'mcq', 'Evaluate a periodic function using the period (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is periodic with period 5. For which of the following expressions is it NOT guaranteed that the expression equals g(x) for all x?', null, md5('apprecalc-mcq-sv-h-3.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(x + 15)', false, 'A shift of 15 is three full periods, so g(x + 15) = g(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(x + 12.5)', true, 'Correct: 15 = 3·5, −10 = −2·5 and 50 = 10·5 are whole numbers of periods, but 12.5 = 2.5 periods.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(x − 10)', false, 'A shift of −10 is two full periods backward, so g(x − 10) = g(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(x + 50)', false, 'A shift of 50 is ten full periods, so g(x + 50) = g(x) for all x.' from version_ins;
-- apprecalc-mcq-sv-h-3.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.1-a-v2', 'mcq', 'Evaluate a periodic function using the period (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h is periodic with period 8. For which of the following expressions is it NOT guaranteed that the expression equals h(x) for all x?', null, md5('apprecalc-mcq-sv-h-3.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x + 16)', false, 'A shift of 16 is two full periods, so h(x + 16) = h(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x − 24)', false, 'A shift of −24 is three full periods backward, so h(x − 24) = h(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x + 40)', false, 'A shift of 40 is five full periods, so h(x + 40) = h(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x + 20)', true, 'Correct: 16 = 2·8, −24 = −3·8 and 40 = 5·8 are whole numbers of periods, but 20 = 2.5 periods.' from version_ins;
-- apprecalc-mcq-sv-h-3.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.1-a-v3', 'mcq', 'Evaluate a periodic function using the period (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function p is periodic with period 7. For which of the following expressions is it NOT guaranteed that the expression equals p(x) for all x?', null, md5('apprecalc-mcq-sv-h-3.1-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p(x + 10)', true, 'Correct: 49 = 7·7, −21 = −3·7 and 35 = 5·7 are whole numbers of periods, but 10 is not a multiple of 7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'p(x + 49)', false, 'A shift of 49 is seven full periods, so p(x + 49) = p(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'p(x − 21)', false, 'A shift of −21 is three full periods backward, so p(x − 21) = p(x) for all x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'p(x + 35)', false, 'A shift of 35 is five full periods, so p(x + 35) = p(x) for all x.' from version_ins;
-- apprecalc-mcq-h-3.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-h-3.1-b', 'mcq', 'Average rates of change of a periodic function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height h(t), in meters, of the tide at a harbor is periodic with period 12 hours. High tide is h(0) = 2.4 and low tide is h(6) = 0.4, and the tide falls steadily from t = 0 to t = 6 and rises from t = 6 to t = 12. Which statement is correct?', null, md5('apprecalc-mcq-h-3.1-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate of change on [0, 6] is −1/3 meters per hour, and on [0, 12] it is +1/3 meters per hour.', false, 'After a full period the height returns to its starting value, so the net change is 0 and not positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change on [0, 6] is −2 meters per hour, and on [0, 12] it is 0 meters per hour.', false, 'The change in height is −2 meters, and dividing by the length 6 hours gives −1/3, not −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average rate of change on [0, 6] is −1/3 meters per hour, and on [0, 12] it is 0 meters per hour.', true, 'Correct: (0.4 − 2.4)/6 = −1/3; over a full period h(12) = h(0), so the average rate on [0, 12] is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change is 0 meters per hour on both [0, 6] and [0, 12], because the tide is periodic.', false, 'A periodic function has average rate 0 over a full period only, and the tide changes from 2.4 to 0.4 on [0, 6].' from version_ins;
-- apprecalc-mcq-sv-h-3.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.1-b-v1', 'mcq', 'Average rates of change of a periodic function (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A Ferris wheel rider''s height h(t), in meters, is periodic with period 20 seconds. The rider is lowest at h(0) = 1 and highest at h(10) = 41. Which statement is correct?', null, md5('apprecalc-mcq-sv-h-3.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average rate of change on [0, 10] is +4 meters per second, and on [0, 20] it is 0 meters per second.', true, 'Correct: (41 − 1)/10 = 4 on [0, 10]; h(20) = h(0), so the average rate on [0, 20] is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average rate of change on [0, 10] is +40 meters per second, and on [0, 20] it is 0 meters per second.', false, '40 is the change in height, and the average rate divides it by the 10 seconds elapsed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average rate of change on [0, 10] is +4 meters per second, and on [0, 20] it is +2 meters per second.', false, 'After one full period the rider is back at height 1, so the net change is 0, not 40 or 20.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average rate of change is 0 meters per second on [0, 10] and +4 meters per second on [0, 20].', false, 'This reverses the two intervals; the rider rises on [0, 10] and has no net change over a full period.' from version_ins;
-- apprecalc-mcq-sv-h-3.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.1-b-v2', 'mcq', 'Average rates of change of a periodic function (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature T(t) at a weather station is modeled by a sinusoidal function with period 24 hours. T has its maximum at t = 0 and its minimum at t = 12, and T is decreasing and concave down on the interval (0, 6). Which statement describes T on the interval (6, 12)?', null, md5('apprecalc-mcq-sv-h-3.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T is increasing and concave up.', false, 'T keeps decreasing until the minimum at t = 12, so it is not increasing on (6, 12).' from version_ins
union all select gen_random_uuid(), id, 'B', 'T is decreasing and concave up.', true, 'Correct: a sinusoid falls from its maximum to its minimum on (0, 12), bending down until the midline crossing at t = 6, then bending up toward the minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T is decreasing and concave down.', false, 'The concavity changes at the midline crossing t = 6, so it does not stay concave down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T is increasing and concave down.', false, 'T is not increasing before the minimum, and the concavity has changed to concave up.' from version_ins;
-- apprecalc-mcq-sv-h-3.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-sv-h-3.1-b-v3', 'mcq', 'Average rates of change of a periodic function (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An insect population g(t), in thousands, is periodic with period 3 years. The population has a maximum of 5 at t = 1 and a minimum of 1 at t = 2.5. Which statement is correct?', null, md5('apprecalc-mcq-sv-h-3.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(10) = 1, because 10 is a whole number of years after the minimum at 2.5.', false, 'The minima occur at 2.5 + 3k, and 10 is not of that form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(10) = 5, because the maximum occurs every year.', false, 'The maximum occurs once per period of 3 years, not every year.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(10) cannot be determined, because 10 lies outside the given data.', false, 'A periodic function is determined everywhere by its values on one period.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(10) = 5, because 10 = 1 + 3(3), a whole number of periods after the first maximum.', true, 'Correct: maxima occur at t = 1 + 3k, and 10 = 1 + 9.' from version_ins;
-- apprecalc-mcq-h-3.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-h-3.2-a', 'mcq', 'Signs and quadrants from one trigonometric value', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An angle θ is in Quadrant III, and cos θ = −5/13. Which choice gives sin θ and tan θ?', null, md5('apprecalc-mcq-h-3.2-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin θ = 12/13 and tan θ = −12/5', false, 'Sine is negative in Quadrant III, and a positive sine would place the angle in Quadrant II.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin θ = −12/13 and tan θ = −12/5', false, 'The quotient of two negative numbers is positive, so tan θ is positive in Quadrant III.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin θ = −12/13 and tan θ = 12/5', true, 'Correct: sin θ = −√(1 − 25/169) = −12/13 in Quadrant III, and tan θ = sin θ/cos θ = (−12/13)/(−5/13) = 12/5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin θ = −12/13 and tan θ = 5/12', false, 'This inverts the ratio, giving cos θ/sin θ instead of sin θ/cos θ.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-h-3.1-a','apprecalc-mcq-sv-h-3.1-a-v1','apprecalc-mcq-sv-h-3.1-a-v2','apprecalc-mcq-sv-h-3.1-a-v3','apprecalc-mcq-h-3.1-b','apprecalc-mcq-sv-h-3.1-b-v1','apprecalc-mcq-sv-h-3.1-b-v2','apprecalc-mcq-sv-h-3.1-b-v3','apprecalc-mcq-h-3.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-h-3.1-a','apprecalc-mcq-sv-h-3.1-a-v1','apprecalc-mcq-sv-h-3.1-a-v2','apprecalc-mcq-sv-h-3.1-a-v3','apprecalc-mcq-h-3.1-b','apprecalc-mcq-sv-h-3.1-b-v1','apprecalc-mcq-sv-h-3.1-b-v2','apprecalc-mcq-sv-h-3.1-b-v3','apprecalc-mcq-h-3.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
