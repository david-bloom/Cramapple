begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.7-a-v3','apprecalc-mcq-b2-h-3.7-b','apprecalc-mcq-b2-sv-h-3.7-b-v1','apprecalc-mcq-b2-sv-h-3.7-b-v2','apprecalc-mcq-b2-sv-h-3.7-b-v3','apprecalc-mcq-b2-h-3.8-a','apprecalc-mcq-b2-sv-h-3.8-a-v1','apprecalc-mcq-b2-sv-h-3.8-a-v2','apprecalc-mcq-b2-sv-h-3.8-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b2-sv-h-3.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.7-a-v3', 'mcq', 'choose the cosine model that fits a described context (starting position or time of an extreme, range, period), with sig (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a northern city, the length of the day is longest, 15 hours, in mid-June, at t = 5.5 months after January 1, and shortest, 9 hours, six months later. The pattern repeats every 12 months. Which function gives the day length D(t), in hours, at time t months after January 1?', null, md5('apprecalc-mcq-b2-sv-h-3.7-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'D(t) = −3 cos(π(t − 5.5)/6) + 12', false, 'This has the right shift, amplitude, midline and period, but a negative cosine makes t = 5.5 the shortest day, not the longest.' from version_ins
union all select gen_random_uuid(), id, 'B', 'D(t) = 3 cos(π(t − 5.5)/12) + 12', false, 'This uses b = π/12, which has period 24 months; for a 12 month period b should be 2π/12 = π/6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'D(t) = 3 cos(πt/6) + 12', false, 'This leaves out the horizontal shift, so the longest day occurs at t = 0 (January 1), not in mid-June.' from version_ins
union all select gen_random_uuid(), id, 'D', 'D(t) = 3 cos(π(t − 5.5)/6) + 12', true, 'Correct: Amplitude 3, midline 12, b = π/6; the maximum at t = 5.5 means +cos with argument π(t − 5.5)/6.' from version_ins;
-- apprecalc-mcq-b2-h-3.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.7-b', 'mcq', 'find and interpret the average rate of change between a maximum and the next minimum of a sinusoidal model (half a perio', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature, in degrees Fahrenheit, in a warehouse is modeled by T(t) = 60 + 15 cos(π(t − 14)/12), where t is hours after midnight. What is the average rate of change of T from the time of the day''s highest temperature to the time of the next lowest temperature?', null, md5('apprecalc-mcq-b2-h-3.7-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2.5 degrees per hour', true, 'Correct: Maximum 75 at t = 14, next minimum 45 at t = 26: (45 − 75)/12 = −2.5 degrees per hour.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1.25 degrees per hour', false, 'This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.5 degrees per hour', false, 'This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 degrees per hour', false, 'This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.7-b-v1', 'mcq', 'find and interpret the average rate of change between a maximum and the next minimum of a sinusoidal model (half a perio (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The depth, in feet, of water in a reservoir is modeled by H(t) = 20 + 6 sin(π(t − 1)/4), where t is in days. What is the average rate of change of H from the time of its maximum depth to the time of its next minimum depth?', null, md5('apprecalc-mcq-b2-sv-h-3.7-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1.5 feet per day', false, 'This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3 feet per day', true, 'Correct: Maximum 26 at t = 3, next minimum 14 at t = 7: (14 − 26)/4 = −3 feet per day.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 feet per day', false, 'This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 feet per day', false, 'This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.7-b-v2', 'mcq', 'find and interpret the average rate of change between a maximum and the next minimum of a sinusoidal model (half a perio (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A deer population, in hundreds, is modeled by N(t) = 40 − 12 cos(πt/3), where t is in years. What is the average rate of change of N from the time of its maximum to the time of its next minimum, in hundreds of deer per year?', null, md5('apprecalc-mcq-b2-sv-h-3.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4 hundred deer per year', false, 'This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 hundred deer per year', false, 'This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 hundred deer per year', false, 'This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.' from version_ins
union all select gen_random_uuid(), id, 'D', '−8 hundred deer per year', true, 'Correct: Maximum 52 at t = 3, next minimum 28 at t = 6: (28 − 52)/3 = −8 hundred deer per year.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.7-b-v3', 'mcq', 'find and interpret the average rate of change between a maximum and the next minimum of a sinusoidal model (half a perio (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The depth, in meters, of the water at a pier is modeled by D(t) = 7 + 3 cos(π(t − 2)/6), where t is in hours. What is the average rate of change of D from the time of high tide to the time of the next low tide?', null, md5('apprecalc-mcq-b2-sv-h-3.7-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.5 meters per hour', false, 'This divides the total drop of 2R by the full period instead of by the half period that actually elapses from the maximum to the next minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', '1 meters per hour', false, 'This has the correct size but the wrong sign; the value falls from its maximum to its minimum, so the average rate is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1 meters per hour', true, 'Correct: Maximum 10 at t = 2, next minimum 4 at t = 8: (4 − 10)/6 = −1 meters per hour.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 meters per hour', false, 'This treats the interval as a full period, where the average rate of change is 0; but a maximum to the next minimum is only half a period and the value falls.' from version_ins;
-- apprecalc-mcq-b2-h-3.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.8-a', 'mcq', 'find every vertical asymptote of a tangent with horizontal dilation and phase shift, including the spacing between asymp', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the complete set of vertical asymptotes of the graph of y = 2tan(2x + π/3) − 1, where k is any integer?', null, md5('apprecalc-mcq-b2-h-3.8-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/4 + kπ/2', false, 'This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 5π/12 + kπ/2', false, 'This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/12 + kπ', false, 'This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = π/12 + kπ/2', true, 'Correct: Asymptotes where 2x + π/3 = π/2 + kπ, so x = (π/2 − (π/3) + kπ)/b; first asymptote π/12, spacing π/2: x = π/12 + kπ/2.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.8-a-v1', 'mcq', 'find every vertical asymptote of a tangent with horizontal dilation and phase shift, including the spacing between asymp (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the complete set of vertical asymptotes of the graph of y = 3tan(3x + π/4) + 1, where k is any integer?', null, md5('apprecalc-mcq-b2-sv-h-3.8-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/6 + kπ/3', false, 'This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = π/4 + kπ/3', false, 'This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/12 + kπ/3', true, 'Correct: Asymptotes where 3x + π/4 = π/2 + kπ, so x = (π/2 − (π/4) + kπ)/b; first asymptote π/12, spacing π/3: x = π/12 + kπ/3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = π/12 + kπ', false, 'This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.8-a-v2', 'mcq', 'find every vertical asymptote of a tangent with horizontal dilation and phase shift, including the spacing between asymp (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the complete set of vertical asymptotes of the graph of y = −tan(x/2 − π/4), where k is any integer?', null, md5('apprecalc-mcq-b2-sv-h-3.8-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π + 2kπ', false, 'This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 5π/4 + 2kπ', false, 'This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/2 + kπ', false, 'This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 3π/2 + 2kπ', true, 'Correct: Asymptotes where x/2 − π/4 = π/2 + kπ, so x = (π/2 − (−π/4) + kπ)/b; first asymptote 3π/2, spacing 2π: x = 3π/2 + 2kπ.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.8-a-v3', 'mcq', 'find every vertical asymptote of a tangent with horizontal dilation and phase shift, including the spacing between asymp (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the complete set of vertical asymptotes of the graph of y = 4tan(2x − π/3) + 2, where k is any integer?', null, md5('apprecalc-mcq-b2-sv-h-3.8-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = π/4 + kπ/2', false, 'This sets the inside expression equal to π/2 + kπ but forgets the phase term, so the asymptotes are not shifted.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 5π/12 + kπ/2', true, 'Correct: Asymptotes where 2x − π/3 = π/2 + kπ, so x = (π/2 − (−π/3) + kπ)/b; first asymptote 5π/12, spacing π/2: x = 5π/12 + kπ/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = π/12 + kπ/2', false, 'This divides only the π/2 by b and subtracts the phase term unscaled; the whole of π/2 − c must be divided by b.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 5π/12 + kπ', false, 'This finds one asymptote correctly but spaces them by π; spacing is the period π/b, so most asymptotes are missed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.7-a-v3','apprecalc-mcq-b2-h-3.7-b','apprecalc-mcq-b2-sv-h-3.7-b-v1','apprecalc-mcq-b2-sv-h-3.7-b-v2','apprecalc-mcq-b2-sv-h-3.7-b-v3','apprecalc-mcq-b2-h-3.8-a','apprecalc-mcq-b2-sv-h-3.8-a-v1','apprecalc-mcq-b2-sv-h-3.8-a-v2','apprecalc-mcq-b2-sv-h-3.8-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b2-sv-h-3.7-a-v3','apprecalc-mcq-b2-h-3.7-b','apprecalc-mcq-b2-sv-h-3.7-b-v1','apprecalc-mcq-b2-sv-h-3.7-b-v2','apprecalc-mcq-b2-sv-h-3.7-b-v3','apprecalc-mcq-b2-h-3.8-a','apprecalc-mcq-b2-sv-h-3.8-a-v1','apprecalc-mcq-b2-sv-h-3.8-a-v2','apprecalc-mcq-b2-sv-h-3.8-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
