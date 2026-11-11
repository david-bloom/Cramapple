begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.6-a-v2','apprecalc-mcq-b2-sv-h-3.6-a-v3','apprecalc-mcq-b2-h-3.6-b','apprecalc-mcq-b2-sv-h-3.6-b-v1','apprecalc-mcq-b2-sv-h-3.6-b-v2','apprecalc-mcq-b2-sv-h-3.6-b-v3','apprecalc-mcq-b2-h-3.7-a','apprecalc-mcq-b2-sv-h-3.7-a-v1','apprecalc-mcq-b2-sv-h-3.7-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b2-sv-h-3.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.6-a-v2', 'mcq', 'translate a verbal list of transformations of y = sin x into an equation, handling the order of horizontal dilation and  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y = sin x is stretched vertically by a factor of 4, compressed horizontally so that its period is 2π/3, and then translated right π/6 and down 3. Which equation describes the new graph?', null, md5('apprecalc-mcq-b2-sv-h-3.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 4 sin(3x − π/6) − 3', false, 'This subtracts π/6 after multiplying by 3, which shifts the graph right only π/18, not π/6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 4 sin(3(x + π/6)) − 3', false, 'This has a plus sign inside the parentheses, which shifts the graph left π/6 instead of right.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 4 sin(3(x − π/6)) − 3', true, 'Correct: Amplitude 4, b = 2π/(2π/3) = 3, right shift π/6 gives sin(3(x − π/6)), down 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 4 sin((x − π/6)/3) − 3', false, 'This divides x by 3, which stretches the period to 6π, but a period of 2π/3 needs b = 3.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.6-a-v3', 'mcq', 'translate a verbal list of transformations of y = sin x into an equation, handling the order of horizontal dilation and  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y = sin x is stretched vertically by a factor of 2, stretched horizontally so that its period is 8, and then translated left 2 units and up 1. Which equation describes the new graph?', null, md5('apprecalc-mcq-b2-sv-h-3.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 2 sin(π(x + 2)/4) + 1', true, 'Correct: b = 2π/8 = π/4; left 2 gives (x + 2); amplitude 2; up 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 2 sin(πx/4 + 2) + 1', false, 'This adds 2 after multiplying by π/4, which shifts the graph left 8/π units, not 2 units.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 2 sin(π(x − 2)/4) + 1', false, 'This has a minus sign inside the parentheses, which shifts the graph right 2 instead of left.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 2 sin(8(x + 2)) + 1', false, 'This uses the period 8 as the value of b, but b = 2π/8 = π/4.' from version_ins;
-- apprecalc-mcq-b2-h-3.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.6-b', 'mcq', 'locate the first maximum of a reflected or phase-shifted cosine transformation with horizontal compression, handling the', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = −3cos(2x + π/3) + 1. What is the least positive value of x at which f attains its maximum value?', null, md5('apprecalc-mcq-b2-h-3.6-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5π/6', false, 'This solves the argument equal to 0 mod 2π, which is where the unreflected cosine peaks; the negative sign makes f maximum where the cosine equals −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/6', false, 'This divides only the π by b and subtracts c unscaled, but the shift c must also be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/12', false, 'This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/3', true, 'Correct: Maximum (4) needs cos(2x + π/3) = −1, so 2x + π/3 = π + 2πk, giving x = π/3 for the least positive value (f there = 4).' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.6-b-v1', 'mcq', 'locate the first maximum of a reflected or phase-shifted cosine transformation with horizontal compression, handling the (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = 5cos(3x − π/3) − 2. What is the least positive value of x at which f attains its maximum value?', null, md5('apprecalc-mcq-b2-sv-h-3.6-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4π/9', false, 'This uses the argument equal to π, which is where cosine is −1; with a positive coefficient the maximum is where the cosine equals 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/3', false, 'This divides only the 0 by b and subtracts c unscaled, but the shift c must also be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', '5π/18', false, 'This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/9', true, 'Correct: Maximum (3) needs cos(3x − π/3) = 1, so 3x − π/3 = 0 + 2πk, giving x = π/9 for the least positive value (f there = 3).' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.6-b-v2', 'mcq', 'locate the first maximum of a reflected or phase-shifted cosine transformation with horizontal compression, handling the (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = −2cos(4x + π/4) + 3. What is the least positive value of x at which f attains its maximum value?', null, md5('apprecalc-mcq-b2-sv-h-3.6-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7π/16', false, 'This solves the argument equal to 0 mod 2π, which is where the unreflected cosine peaks; the negative sign makes f maximum where the cosine equals −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/2', false, 'This divides only the π by b and subtracts c unscaled, but the shift c must also be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', '3π/16', true, 'Correct: Maximum (5) needs cos(4x + π/4) = −1, so 4x + π/4 = π + 2πk, giving x = 3π/16 for the least positive value (f there = 5).' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/16', false, 'This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.6-b-v3', 'mcq', 'locate the first maximum of a reflected or phase-shifted cosine transformation with horizontal compression, handling the (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = 4cos(2x − π/6). What is the least positive value of x at which f attains its maximum value?', null, md5('apprecalc-mcq-b2-sv-h-3.6-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7π/12', false, 'This uses the argument equal to π, which is where cosine is −1; with a positive coefficient the maximum is where the cosine equals 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'π/6', false, 'This divides only the 0 by b and subtracts c unscaled, but the shift c must also be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', 'π/12', true, 'Correct: Maximum (4) needs cos(2x − π/6) = 1, so 2x − π/6 = 0 + 2πk, giving x = π/12 for the least positive value (f there = 4).' from version_ins
union all select gen_random_uuid(), id, 'D', 'π/3', false, 'This adds a quarter period to the phase shift, which locates a midline crossing of a sine curve, not the maximum of this cosine curve.' from version_ins;
-- apprecalc-mcq-b2-h-3.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.7-a', 'mcq', 'choose the cosine model that fits a described context (starting position or time of an extreme, range, period), with sig', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A Ferris wheel has diameter 40 meters and its center is 22 meters above the ground. It makes one full rotation every 30 seconds. A rider boards at the lowest point of the wheel at time t = 0 seconds. Which function gives the rider''s height h(t), in meters above the ground, at time t seconds?', null, md5('apprecalc-mcq-b2-h-3.7-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(t) = −20 cos(πt/15) + 22', true, 'Correct: Amplitude 20, midline 22, b = 2π/30 = π/15; starting at the minimum requires −cos: h(0) = −20 + 22 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(t) = 20 cos(πt/15) + 22', false, 'This has the correct amplitude, midline and period, but with a positive cosine the rider starts at the top, 42 meters, instead of at the lowest point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(t) = −20 cos(πt/30) + 22', false, 'This uses b = π/30, which has period 60 seconds, as if the 30 seconds were half a rotation; b should be 2π/30 = π/15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(t) = 20 sin(πt/15) + 22', false, 'This has the right amplitude, midline and period, but sine starts at the midline, 22 meters, not the lowest point 2 meters.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.7-a-v1', 'mcq', 'choose the cosine model that fits a described context (starting position or time of an extreme, range, period), with sig (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a harbor, the water height is at its highest, 7.4 meters, at time t = 0 hours, and at its lowest, 1.2 meters, 6.2 hours later. The pattern repeats every 12.4 hours. Which function gives the water height H(t), in meters, at time t hours?', null, md5('apprecalc-mcq-b2-sv-h-3.7-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H(t) = −3.1 cos(πt/6.2) + 4.3', false, 'This has the correct amplitude, midline and period, but with a negative cosine the water starts at its lowest height, not its highest.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H(t) = 3.1 cos(πt/12.4) + 4.3', false, 'This uses b = π/12.4, which has period 24.8 hours, twice the stated 12.4 hours; b should be 2π/12.4 = π/6.2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H(t) = 3.1 sin(πt/6.2) + 4.3', false, 'This has the right amplitude, midline and period, but sine starts at the midline, 4.3, not at the highest height 7.4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H(t) = 3.1 cos(πt/6.2) + 4.3', true, 'Correct: Amplitude (7.4 − 1.2)/2 = 3.1; midline 4.3; b = 2π/12.4 = π/6.2; maximum at t = 0 requires +cos.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.7-a-v2', 'mcq', 'choose the cosine model that fits a described context (starting position or time of an extreme, range, period), with sig (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a greenhouse, the temperature is lowest, 14 degrees Celsius, at 4 a.m. and highest, 30 degrees Celsius, 12 hours later. The pattern repeats every 24 hours. Which function gives the temperature C(t), where t is hours after midnight?', null, md5('apprecalc-mcq-b2-sv-h-3.7-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C(t) = 8 cos(π(t − 4)/12) + 22', false, 'This has the right shift, amplitude, midline and period, but a positive cosine puts the maximum, not the minimum, at t = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C(t) = −8 cos(π(t − 4)/12) + 22', true, 'Correct: Amplitude 8, midline 22, b = π/12; the minimum is at t = 4, so −cos with argument π(t − 4)/12.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C(t) = −8 cos(π(t − 4)/24) + 22', false, 'This uses b = π/24, which has period 48 hours; for a 24 hour period b should be 2π/24 = π/12.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C(t) = −8 cos(πt/12) + 22', false, 'This leaves out the horizontal shift, so the minimum occurs at t = 0 (midnight), not at 4 a.m.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.6-a-v2','apprecalc-mcq-b2-sv-h-3.6-a-v3','apprecalc-mcq-b2-h-3.6-b','apprecalc-mcq-b2-sv-h-3.6-b-v1','apprecalc-mcq-b2-sv-h-3.6-b-v2','apprecalc-mcq-b2-sv-h-3.6-b-v3','apprecalc-mcq-b2-h-3.7-a','apprecalc-mcq-b2-sv-h-3.7-a-v1','apprecalc-mcq-b2-sv-h-3.7-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b2-sv-h-3.6-a-v2','apprecalc-mcq-b2-sv-h-3.6-a-v3','apprecalc-mcq-b2-h-3.6-b','apprecalc-mcq-b2-sv-h-3.6-b-v1','apprecalc-mcq-b2-sv-h-3.6-b-v2','apprecalc-mcq-b2-sv-h-3.6-b-v3','apprecalc-mcq-b2-h-3.7-a','apprecalc-mcq-b2-sv-h-3.7-a-v1','apprecalc-mcq-b2-sv-h-3.7-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
