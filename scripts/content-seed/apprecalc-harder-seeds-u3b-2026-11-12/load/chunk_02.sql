begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.5-a-v1','apprecalc-mcq-b2-sv-h-3.5-a-v2','apprecalc-mcq-b2-sv-h-3.5-a-v3','apprecalc-mcq-b2-h-3.5-b','apprecalc-mcq-b2-sv-h-3.5-b-v1','apprecalc-mcq-b2-sv-h-3.5-b-v2','apprecalc-mcq-b2-sv-h-3.5-b-v3','apprecalc-mcq-b2-h-3.6-a','apprecalc-mcq-b2-sv-h-3.6-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apprecalc-mcq-b2-sv-h-3.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.5-a-v1', 'mcq', 'build the equation of a sinusoid from a maximum point and the adjacent minimum point (amplitude, midline, half period to (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function f has a minimum point at (3, 2) and its next maximum point at (10, 12). Which equation defines f?', null, md5('apprecalc-mcq-b2-sv-h-3.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −5cos(π(x − 3)/3.5) + 7', false, 'This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/7 and the graph repeats too quickly.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −5cos(π(x − 3)/7) + 7', true, 'Correct: Amplitude = (12 − 2)/2 = 5; midline y = 7; half period 7 so period 14 and b = π/7; a minimum at x = 3 gives a negative cosine shifted 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −10cos(π(x − 3)/7) + 7', false, 'This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 5cos(π(x − 3)/7) + 7', false, 'This uses the cosine curve with a positive sign, so it has a maximum, not a minimum, at x = 3.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.5-a-v2', 'mcq', 'build the equation of a sinusoid from a maximum point and the adjacent minimum point (amplitude, midline, half period to (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function f has a maximum point at (5, 8) and its next minimum point at (9, −4). Which equation defines f?', null, md5('apprecalc-mcq-b2-sv-h-3.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 6cos(π(x − 5)/2) + 2', false, 'This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/4 and the graph repeats too quickly.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 6cos(π(x − 5)/4) + 2', true, 'Correct: Amplitude = (8 − −4)/2 = 6; midline y = 2; half period 4 so period 8 and b = π/4; a maximum at x = 5 gives cosine shifted 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 12cos(π(x − 5)/4) + 2', false, 'This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 6sin(π(x − 5)/4) + 2', false, 'This uses sine with the shift of the maximum, but sin(0) = 0 puts the midline value at x = 5 instead of the maximum.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.5-a-v3', 'mcq', 'build the equation of a sinusoid from a maximum point and the adjacent minimum point (amplitude, midline, half period to (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function f has a minimum point at (4, 1) and its next maximum point at (6, 9). Which equation defines f?', null, md5('apprecalc-mcq-b2-sv-h-3.5-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −4cos(π(x − 4)/1) + 5', false, 'This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/2 and the graph repeats too quickly.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −8cos(π(x − 4)/2) + 5', false, 'This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −4cos(π(x − 4)/2) + 5', true, 'Correct: Amplitude = (9 − 1)/2 = 4; midline y = 5; half period 2 so period 4 and b = π/2; a minimum at x = 4 gives a negative cosine shifted 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 4cos(π(x − 4)/2) + 5', false, 'This uses the cosine curve with a positive sign, so it has a maximum, not a minimum, at x = 4.' from version_ins;
-- apprecalc-mcq-b2-h-3.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.5-b', 'mcq', 'use periodicity and midline symmetry of a sinusoid to decide which function value statement must hold at inputs far from', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function g has a minimum value of 3 at x = 1, and its next maximum value of 11 occurs at x = 5. Which statement must be true?', null, md5('apprecalc-mcq-b2-h-3.5-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(3) = 7', true, 'Correct: Period = 8, midline 7. x = 3 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(9) = 11', false, 'Not guaranteed: x = 9 is a whole number of periods from the minimum at x = 1, so the value there is the minimum, 3, not 11.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(7) = 3', false, 'Not guaranteed: x = 7 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 7, not 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(13) = 3', false, 'Not guaranteed: x = 13 is an odd number of half periods from the minimum at x = 1, so the value there is the maximum, 11, not 3.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.5-b-v1', 'mcq', 'use periodicity and midline symmetry of a sinusoid to decide which function value statement must hold at inputs far from (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function g has a minimum value of −2 at x = 2, and its next maximum value of 10 occurs at x = 8. Which statement must be true?', null, md5('apprecalc-mcq-b2-sv-h-3.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(14) = 10', false, 'Not guaranteed: x = 14 is a whole number of periods from the minimum at x = 2, so the value there is the minimum, −2, not 10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(11) = −2', false, 'Not guaranteed: x = 11 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4, not −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(5) = 10', false, 'Not guaranteed: x = 5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4, not 10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(20) = 10', true, 'Correct: Period = 12, midline 4. x = 20 is an odd number of half periods from the minimum at x = 2, so the value there is the maximum, 10.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.5-b-v2', 'mcq', 'use periodicity and midline symmetry of a sinusoid to decide which function value statement must hold at inputs far from (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function g has a maximum value of 13 at x = 3, and its next minimum value of 5 occurs at x = 7. Which statement must be true?', null, md5('apprecalc-mcq-b2-sv-h-3.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(9) = 13', false, 'Not guaranteed: x = 9 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 9, not 13.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(11) = 5', false, 'Not guaranteed: x = 11 is a whole number of periods from the maximum at x = 3, so the value there is the maximum, 13, not 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(5) = 9', true, 'Correct: Period = 8, midline 9. x = 5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(15) = 9', false, 'Not guaranteed: x = 15 is an odd number of half periods from the maximum at x = 3, so the value there is the minimum, 5, not 9.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.5-b-v3', 'mcq', 'use periodicity and midline symmetry of a sinusoid to decide which function value statement must hold at inputs far from (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function g has a minimum value of 0 at x = 2, and its next maximum value of 8 occurs at x = 11. Which statement must be true?', null, md5('apprecalc-mcq-b2-sv-h-3.5-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g(20) = 8', false, 'Not guaranteed: x = 20 is a whole number of periods from the minimum at x = 2, so the value there is the minimum, 0, not 8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g(15.5) = 0', false, 'Not guaranteed: x = 15.5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4, not 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g(6.5) = 4', true, 'Correct: Period = 18, midline 4. x = 6.5 is a quarter or three quarters of a period from an extreme point, which is where the graph crosses its midline, so the value there is 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g(29) = 0', false, 'Not guaranteed: x = 29 is an odd number of half periods from the minimum at x = 2, so the value there is the maximum, 8, not 0.' from version_ins;
-- apprecalc-mcq-b2-h-3.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.6-a', 'mcq', 'translate a verbal list of transformations of y = sin x into an equation, handling the order of horizontal dilation and ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y = sin x is stretched vertically by a factor of 3, compressed horizontally so that its period is π, and then translated right π/4 and up 2. Which equation describes the new graph?', null, md5('apprecalc-mcq-b2-h-3.6-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 3 sin(2(x − π/4)) + 2', true, 'Correct: Amplitude 3, b = 2π/π = 2, right shift π/4 gives sin(2(x − π/4)), up 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 3 sin(2x − π/4) + 2', false, 'This subtracts π/4 after multiplying by 2, which shifts the graph right only π/8, not π/4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 3 sin(2(x + π/4)) + 2', false, 'This has a plus sign inside the parentheses, which shifts the graph left π/4 instead of right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 3 sin((x − π/4)/2) + 2', false, 'This divides x by 2, which stretches the period to 4π, but a period of π needs b = 2π/π = 2.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.6-a-v1', 'mcq', 'translate a verbal list of transformations of y = sin x into an equation, handling the order of horizontal dilation and  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y = sin x is reflected across the x-axis, stretched vertically by a factor of 5, stretched horizontally so that its period is 4π, and then translated left π and down 1. Which equation describes the new graph?', null, md5('apprecalc-mcq-b2-sv-h-3.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −5 sin(x/2 + π) − 1', false, 'This adds π after dividing by 2, which shifts the graph left 2π, not π.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −5 sin((x − π)/2) − 1', false, 'This has a minus sign inside the parentheses, which shifts the graph right π instead of left.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −5 sin(2(x + π)) − 1', false, 'This uses b = 2, which gives a period of π, but a period of 4π needs b = 2π/4π = 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −5 sin((x + π)/2) − 1', true, 'Correct: Reflection gives −5, b = 2π/4π = 1/2, left shift π gives (x + π)/2, down 1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-sv-h-3.5-a-v1','apprecalc-mcq-b2-sv-h-3.5-a-v2','apprecalc-mcq-b2-sv-h-3.5-a-v3','apprecalc-mcq-b2-h-3.5-b','apprecalc-mcq-b2-sv-h-3.5-b-v1','apprecalc-mcq-b2-sv-h-3.5-b-v2','apprecalc-mcq-b2-sv-h-3.5-b-v3','apprecalc-mcq-b2-h-3.6-a','apprecalc-mcq-b2-sv-h-3.6-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b2-sv-h-3.5-a-v1','apprecalc-mcq-b2-sv-h-3.5-a-v2','apprecalc-mcq-b2-sv-h-3.5-a-v3','apprecalc-mcq-b2-h-3.5-b','apprecalc-mcq-b2-sv-h-3.5-b-v1','apprecalc-mcq-b2-sv-h-3.5-b-v2','apprecalc-mcq-b2-sv-h-3.5-b-v3','apprecalc-mcq-b2-h-3.6-a','apprecalc-mcq-b2-sv-h-3.6-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
