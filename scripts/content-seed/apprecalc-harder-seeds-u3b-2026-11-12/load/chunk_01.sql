begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-h-3.4-a','apprecalc-mcq-b2-sv-h-3.4-a-v1','apprecalc-mcq-b2-sv-h-3.4-a-v2','apprecalc-mcq-b2-sv-h-3.4-a-v3','apprecalc-mcq-b2-h-3.4-b','apprecalc-mcq-b2-sv-h-3.4-b-v1','apprecalc-mcq-b2-sv-h-3.4-b-v2','apprecalc-mcq-b2-sv-h-3.4-b-v3','apprecalc-mcq-b2-h-3.5-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b2-h-3.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.4-a', 'mcq', 'combine increasing/decreasing with concavity on a quarter-period of a sine or cosine graph, including a reflected curve.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 < x < 2π, which open interval of the graph of y = sin x is both increasing and concave down?', null, md5('apprecalc-mcq-b2-h-3.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π/2)', true, 'Correct: For y = sin x the slope sign and second-derivative sign by quadrant give increasing and concave down only on (0, π/2).' from version_ins
union all select gen_random_uuid(), id, 'B', '(π/2, π)', false, 'On (π/2, π) the graph is concave down there but it is decreasing, so only one of the two conditions holds.' from version_ins
union all select gen_random_uuid(), id, 'C', '(π, 3π/2)', false, 'On (π, 3π/2) the graph is decreasing and concave up there, which meets neither condition.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3π/2, 2π)', false, 'On (3π/2, 2π) the graph is increasing there but it is concave up, so only one of the two conditions holds.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.4-a-v1', 'mcq', 'combine increasing/decreasing with concavity on a quarter-period of a sine or cosine graph, including a reflected curve. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 < x < 2π, which open interval of the graph of y = cos x is both decreasing and concave up?', null, md5('apprecalc-mcq-b2-sv-h-3.4-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π/2)', false, 'On (0, π/2) the graph is decreasing there but it is concave down, so only one of the two conditions holds.' from version_ins
union all select gen_random_uuid(), id, 'B', '(π/2, π)', true, 'Correct: For y = cos x the slope sign and second-derivative sign by quadrant give decreasing and concave up only on (π/2, π).' from version_ins
union all select gen_random_uuid(), id, 'C', '(π, 3π/2)', false, 'On (π, 3π/2) the graph is concave up there but it is increasing, so only one of the two conditions holds.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3π/2, 2π)', false, 'On (3π/2, 2π) the graph is increasing and concave down there, which meets neither condition.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.4-a-v2', 'mcq', 'combine increasing/decreasing with concavity on a quarter-period of a sine or cosine graph, including a reflected curve. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 < x < 2π, which open interval of the graph of y = sin x is both decreasing and concave up?', null, md5('apprecalc-mcq-b2-sv-h-3.4-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π/2)', false, 'On (0, π/2) the graph is increasing and concave down there, which meets neither condition.' from version_ins
union all select gen_random_uuid(), id, 'B', '(π, 3π/2)', true, 'Correct: For y = sin x the slope sign and second-derivative sign by quadrant give decreasing and concave up only on (π, 3π/2).' from version_ins
union all select gen_random_uuid(), id, 'C', '(π/2, π)', false, 'On (π/2, π) the graph is decreasing there but it is concave down, so only one of the two conditions holds.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3π/2, 2π)', false, 'On (3π/2, 2π) the graph is concave up there but it is increasing, so only one of the two conditions holds.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.4-a-v3', 'mcq', 'combine increasing/decreasing with concavity on a quarter-period of a sine or cosine graph, including a reflected curve. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On the interval 0 < x < 2π, which open interval of the graph of y = cos x is both increasing and concave down?', null, md5('apprecalc-mcq-b2-sv-h-3.4-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(0, π/2)', false, 'On (0, π/2) the graph is concave down there but it is decreasing, so only one of the two conditions holds.' from version_ins
union all select gen_random_uuid(), id, 'B', '(π/2, π)', false, 'On (π/2, π) the graph is decreasing and concave up there, which meets neither condition.' from version_ins
union all select gen_random_uuid(), id, 'C', '(3π/2, 2π)', true, 'Correct: For y = cos x the slope sign and second-derivative sign by quadrant give increasing and concave down only on (3π/2, 2π).' from version_ins
union all select gen_random_uuid(), id, 'D', '(π, 3π/2)', false, 'On (π, 3π/2) the graph is increasing there but it is concave up, so only one of the two conditions holds.' from version_ins;
-- apprecalc-mcq-b2-h-3.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.4-b', 'mcq', 'order values of sine or cosine at inputs spread over more than one period segment, using rise and fall of the graph rath', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the values cos(1), cos(2.5), cos(4), cos(5.5) from least to greatest? (Inputs are in radians.)', null, md5('apprecalc-mcq-b2-h-3.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cos(1) < cos(2.5) < cos(4) < cos(5.5)', false, 'This lists the values in the order of the inputs, which assumes cos keeps increasing as its input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cos(2.5) < cos(4) < cos(1) < cos(5.5)', true, 'Correct: Values: cos(1) ≈ 0.540, cos(2.5) ≈ −0.801, cos(4) ≈ −0.654, cos(5.5) ≈ 0.709; ascending order is cos(2.5) < cos(4) < cos(1) < cos(5.5).' from version_ins
union all select gen_random_uuid(), id, 'C', 'cos(5.5) < cos(4) < cos(2.5) < cos(1)', false, 'This reverses the input order, which assumes cos keeps decreasing as the input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'cos(1) < cos(4) < cos(5.5) < cos(2.5)', false, 'This orders by distance from zero, ignoring that negative values are less than positive values.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.4-b-v1', 'mcq', 'order values of sine or cosine at inputs spread over more than one period segment, using rise and fall of the graph rath (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the values sin(0.5), sin(2), sin(4), sin(5.5) from least to greatest? (Inputs are in radians.)', null, md5('apprecalc-mcq-b2-sv-h-3.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin(0.5) < sin(2) < sin(4) < sin(5.5)', false, 'This lists the values in the order of the inputs, which assumes sin keeps increasing as its input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin(5.5) < sin(4) < sin(2) < sin(0.5)', false, 'This reverses the input order, which assumes sin keeps decreasing as the input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin(0.5) < sin(5.5) < sin(4) < sin(2)', false, 'This orders by distance from zero, ignoring that negative values are less than positive values.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin(4) < sin(5.5) < sin(0.5) < sin(2)', true, 'Correct: Values: sin(0.5) ≈ 0.479, sin(2) ≈ 0.909, sin(4) ≈ −0.757, sin(5.5) ≈ −0.706; ascending order is sin(4) < sin(5.5) < sin(0.5) < sin(2).' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.4-b-v2', 'mcq', 'order values of sine or cosine at inputs spread over more than one period segment, using rise and fall of the graph rath (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the values cos(2), cos(3.5), cos(5), cos(6.5) from least to greatest? (Inputs are in radians.)', null, md5('apprecalc-mcq-b2-sv-h-3.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'cos(2) < cos(3.5) < cos(5) < cos(6.5)', false, 'This lists the values in the order of the inputs, which assumes cos keeps increasing as its input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'cos(3.5) < cos(2) < cos(5) < cos(6.5)', true, 'Correct: Values: cos(2) ≈ −0.416, cos(3.5) ≈ −0.936, cos(5) ≈ 0.284, cos(6.5) ≈ 0.977; ascending order is cos(3.5) < cos(2) < cos(5) < cos(6.5).' from version_ins
union all select gen_random_uuid(), id, 'C', 'cos(6.5) < cos(5) < cos(3.5) < cos(2)', false, 'This reverses the input order, which assumes cos keeps decreasing as the input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'cos(5) < cos(2) < cos(3.5) < cos(6.5)', false, 'This orders by distance from zero, ignoring that negative values are less than positive values.' from version_ins;
-- apprecalc-mcq-b2-sv-h-3.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-sv-h-3.4-b-v3', 'mcq', 'order values of sine or cosine at inputs spread over more than one period segment, using rise and fall of the graph rath (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the values sin(1), sin(3), sin(4.5), sin(6) from least to greatest? (Inputs are in radians.)', null, md5('apprecalc-mcq-b2-sv-h-3.4-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'sin(1) < sin(3) < sin(4.5) < sin(6)', false, 'This lists the values in the order of the inputs, which assumes sin keeps increasing as its input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'sin(4.5) < sin(6) < sin(3) < sin(1)', true, 'Correct: Values: sin(1) ≈ 0.841, sin(3) ≈ 0.141, sin(4.5) ≈ −0.978, sin(6) ≈ −0.279; ascending order is sin(4.5) < sin(6) < sin(3) < sin(1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'sin(6) < sin(4.5) < sin(3) < sin(1)', false, 'This reverses the input order, which assumes sin keeps decreasing as the input increases; the graph rises and falls over these inputs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'sin(3) < sin(6) < sin(1) < sin(4.5)', false, 'This orders by distance from zero, ignoring that negative values are less than positive values.' from version_ins;
-- apprecalc-mcq-b2-h-3.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b2-h-3.5-a', 'mcq', 'build the equation of a sinusoid from a maximum point and the adjacent minimum point (amplitude, midline, half period to', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sinusoidal function f has a maximum point at (2, 11) and its next minimum point at (8, 3). Which equation defines f?', null, md5('apprecalc-mcq-b2-h-3.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 4cos(π(x − 2)/6) + 7', true, 'Correct: Amplitude = (11 − 3)/2 = 4; midline y = 7; half period 6 so period 12 and b = π/6; a maximum at x = 2 gives cosine shifted 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 4cos(π(x − 2)/3) + 7', false, 'This uses the distance between the two points as the full period, but it is only half a period, so the argument should be π(x − h)/6 and the graph repeats too quickly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 8cos(π(x − 2)/6) + 7', false, 'This takes the whole distance between the maximum and minimum values as the amplitude, but the amplitude is half of that distance, so the graph overshoots the given points.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 4sin(π(x − 2)/6) + 7', false, 'This uses sine with the shift of the maximum, but sin(0) = 0 puts the midline value at x = 2 instead of the maximum.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b2-h-3.4-a','apprecalc-mcq-b2-sv-h-3.4-a-v1','apprecalc-mcq-b2-sv-h-3.4-a-v2','apprecalc-mcq-b2-sv-h-3.4-a-v3','apprecalc-mcq-b2-h-3.4-b','apprecalc-mcq-b2-sv-h-3.4-b-v1','apprecalc-mcq-b2-sv-h-3.4-b-v2','apprecalc-mcq-b2-sv-h-3.4-b-v3','apprecalc-mcq-b2-h-3.5-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b2-h-3.4-a','apprecalc-mcq-b2-sv-h-3.4-a-v1','apprecalc-mcq-b2-sv-h-3.4-a-v2','apprecalc-mcq-b2-sv-h-3.4-a-v3','apprecalc-mcq-b2-h-3.4-b','apprecalc-mcq-b2-sv-h-3.4-b-v1','apprecalc-mcq-b2-sv-h-3.4-b-v2','apprecalc-mcq-b2-sv-h-3.4-b-v3','apprecalc-mcq-b2-h-3.5-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
