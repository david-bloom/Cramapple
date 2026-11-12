begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-h-1.12-b','apprecalc-mcq-b9-sv-h-1.12-b-v1','apprecalc-mcq-b9-sv-h-1.12-b-v2','apprecalc-mcq-b9-sv-h-1.12-b-v3','apprecalc-mcq-b9-h-1.13-a','apprecalc-mcq-b9-sv-h-1.13-a-v1','apprecalc-mcq-b9-sv-h-1.13-a-v2','apprecalc-mcq-b9-sv-h-1.13-a-v3','apprecalc-mcq-b9-h-1.13-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-h-1.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.12-b', 'mcq', 'determine how a combination of reflections and shifts changes the interval, the increasing/decreasing behavior and the c', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f and g be functions. The function f is increasing and concave down on the interval (1, 4). The function g is defined by g(x) = −f(x + 3) + 2. Which statement must be true?', null, md5('apprecalc-mcq-b9-h-1.12-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is decreasing and concave up on the interval (4, 7).', false, 'This has the right behavior but the wrong interval. Solving x + 3 = 1 and x + 3 = 4 places the endpoints at −2 and 1, not 4 and 7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is increasing and concave up on the interval (−2, 1).', false, 'This gets the interval and concavity right but the wrong direction. The graph has one reflection (the negative sign in front of f), and each reflection reverses increasing and decreasing, so g is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is decreasing and concave down on the interval (−2, 1).', false, 'This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is negative here, so g is concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is decreasing and concave up on the interval (−2, 1).', true, 'Correct: For f(…) on (1, 4) the input x + 3 must lie in (1, 4), so x lies in (−2, 1). There is one reflection (the negative sign in front of f), so g is decreasing; only the sign in front of f affects concavity, so g is concave up.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.12-b-v1', 'mcq', 'determine how a combination of reflections and shifts changes the interval, the increasing/decreasing behavior and the c (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the function f and the function g built from it. The function f is decreasing and concave up on the interval (−2, 3). The function g is defined by g(x) = f(1 − x) + 4. Which statement must be true?', null, md5('apprecalc-mcq-b9-sv-h-1.12-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave up on the interval (−1, 4).', false, 'This has the right behavior but the wrong interval. Solving 1 − x = −2 and 1 − x = 3 places the endpoints at −2 and 3, not −1 and 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing and concave up on the interval (−2, 3).', false, 'This gets the interval and concavity right but the wrong direction. The graph has one reflection (the negative sign on x inside f), and each reflection reverses increasing and decreasing, so g is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is increasing and concave up on the interval (−2, 3).', true, 'Correct: For f(…) on (−2, 3) the input 1 − x must lie in (−2, 3), so x lies in (−2, 3). There is one reflection (the negative sign on x inside f), so g is increasing; only the sign in front of f affects concavity, so g is concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is increasing and concave down on the interval (−2, 3).', false, 'This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is positive here, so g is concave up.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.12-b-v2', 'mcq', 'determine how a combination of reflections and shifts changes the interval, the increasing/decreasing behavior and the c (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is given, and a related function g is defined. The function f is increasing and concave up on the interval (0, 5). The function g is defined by g(x) = −f(2 − x) − 1. Which statement must be true?', null, md5('apprecalc-mcq-b9-sv-h-1.12-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave down on the interval (2, 7).', false, 'This has the right behavior but the wrong interval. Solving 2 − x = 0 and 2 − x = 5 places the endpoints at −3 and 2, not 2 and 7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing and concave down on the interval (−3, 2).', false, 'This gets the interval and concavity right but the wrong direction. The graph has two reflections (the negative sign in front of f and the negative sign on x inside f), and each reflection reverses increasing and decreasing, so g is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is increasing and concave down on the interval (−3, 2).', true, 'Correct: For f(…) on (0, 5) the input 2 − x must lie in (0, 5), so x lies in (−3, 2). There are two reflections (the negative sign in front of f and the negative sign on x inside f), so g is increasing; only the sign in front of f affects concavity, so g is concave down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is increasing and concave up on the interval (−3, 2).', false, 'This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is negative here, so g is concave down.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.12-b-v3', 'mcq', 'determine how a combination of reflections and shifts changes the interval, the increasing/decreasing behavior and the c (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a function and let g be defined in terms of f. The function f is decreasing and concave down on the interval (2, 6). The function g is defined by g(x) = −f(x − 4). Which statement must be true?', null, md5('apprecalc-mcq-b9-sv-h-1.12-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'g is increasing and concave up on the interval (−2, 2).', false, 'This has the right behavior but the wrong interval. Solving x − 4 = 2 and x − 4 = 6 places the endpoints at 6 and 10, not −2 and 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g is decreasing and concave up on the interval (6, 10).', false, 'This gets the interval and concavity right but the wrong direction. The graph has one reflection (the negative sign in front of f), and each reflection reverses increasing and decreasing, so g is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g is increasing and concave down on the interval (6, 10).', false, 'This gets the direction right but the wrong concavity. Concavity is reversed only by a negative sign multiplying f, and that sign is negative here, so g is concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g is increasing and concave up on the interval (6, 10).', true, 'Correct: For f(…) on (2, 6) the input x − 4 must lie in (2, 6), so x lies in (6, 10). There is one reflection (the negative sign in front of f), so g is increasing; only the sign in front of f affects concavity, so g is concave up.' from version_ins;
-- apprecalc-mcq-b9-h-1.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.13-a', 'mcq', 'use repeated differences on equally spaced data to find the lowest degree of a polynomial that fits exactly, rather than', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A data set from an experiment is recorded. A table gives outputs y for equally spaced inputs x = 0, 1, 2, 3, 4, 5: y = 7, 5, 5, 19, 59, 137. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?', null, md5('apprecalc-mcq-b9-h-1.13-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a polynomial of degree 2', false, 'This stops one round of differences early. Taking differences 2 times does not give a constant list here, so the data cannot come from a degree 2 polynomial; the constant list appears after 3 rounds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a polynomial of degree 5', false, 'This uses the fact that 6 points fit some polynomial of degree 5. The question asks for the lowest degree that fits exactly, and constant differences show that degree 3 is enough.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a polynomial of degree 3', true, 'Correct: Differences of the outputs taken 3 times are all equal to 12, while differences taken 2 times are not constant. So the lowest degree that fits all 6 points is 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'an exponential function, since the outputs keep growing in size', false, 'This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 3 rounds.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.13-a-v1', 'mcq', 'use repeated differences on equally spaced data to find the lowest degree of a polynomial that fits exactly, rather than (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A technician records measurements. A table gives outputs y for equally spaced inputs x = 0, 1, 2, 3, 4, 5, 6: y = 3, 3, 23, 105, 315, 743, 1503. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?', null, md5('apprecalc-mcq-b9-sv-h-1.13-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a polynomial of degree 3', false, 'This stops one round of differences early. Taking differences 3 times does not give a constant list here, so the data cannot come from a degree 3 polynomial; the constant list appears after 4 rounds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a polynomial of degree 6', false, 'This uses the fact that 7 points fit some polynomial of degree 6. The question asks for the lowest degree that fits exactly, and constant differences show that degree 4 is enough.' from version_ins
union all select gen_random_uuid(), id, 'C', 'an exponential function, since the outputs keep growing in size', false, 'This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 4 rounds.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a polynomial of degree 4', true, 'Correct: Differences of the outputs taken 4 times are all equal to 24, while differences taken 3 times are not constant. So the lowest degree that fits all 7 points is 4.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.13-a-v2', 'mcq', 'use repeated differences on equally spaced data to find the lowest degree of a polynomial that fits exactly, rather than (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor records values at equal steps. A table gives outputs y for equally spaced inputs x = 0, 2, 4, 6, 8, 10: y = −4, −12, −156, −580, −1428, −2844. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?', null, md5('apprecalc-mcq-b9-sv-h-1.13-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a polynomial of degree 2', false, 'This stops one round of differences early. Taking differences 2 times does not give a constant list here, so the data cannot come from a degree 2 polynomial; the constant list appears after 3 rounds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a polynomial of degree 5', false, 'This uses the fact that 6 points fit some polynomial of degree 5. The question asks for the lowest degree that fits exactly, and constant differences show that degree 3 is enough.' from version_ins
union all select gen_random_uuid(), id, 'C', 'an exponential function, since the outputs keep growing in size', false, 'This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 3 rounds.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a polynomial of degree 3', true, 'Correct: Differences of the outputs taken 3 times are all equal to −144, while differences taken 2 times are not constant. So the lowest degree that fits all 6 points is 3.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.13-a-v3', 'mcq', 'use repeated differences on equally spaced data to find the lowest degree of a polynomial that fits exactly, rather than (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lab logs a quantity. A table gives outputs y for equally spaced inputs x = 0, 1, 2, 3, 4, 5, 6: y = 5, 4, 13, 68, 229, 580, 1229. Based on repeated differences, which model is the lowest-degree choice that fits all of the data exactly?', null, md5('apprecalc-mcq-b9-sv-h-1.13-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a polynomial of degree 3', false, 'This stops one round of differences early. Taking differences 3 times does not give a constant list here, so the data cannot come from a degree 3 polynomial; the constant list appears after 4 rounds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a polynomial of degree 4', true, 'Correct: Differences of the outputs taken 4 times are all equal to 24, while differences taken 3 times are not constant. So the lowest degree that fits all 7 points is 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a polynomial of degree 6', false, 'This uses the fact that 7 points fit some polynomial of degree 6. The question asks for the lowest degree that fits exactly, and constant differences show that degree 4 is enough.' from version_ins
union all select gen_random_uuid(), id, 'D', 'an exponential function, since the outputs keep growing in size', false, 'This relies on the outputs growing quickly. An exponential function has a constant ratio between consecutive outputs, but here the ratios vary from row to row, while the differences become constant after 4 rounds.' from version_ins;
-- apprecalc-mcq-b9-h-1.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.13-b', 'mcq', 'decide the valid input interval for a quadratic model in context by finding where the output stops being meaningful, not', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A model for the height h, in feet, of a ball is h(t) = −16t² + 24t + 16, where t is time in seconds after the ball is thrown, starting at t = 0. What is the most appropriate domain for this model in the context of the ball being in the air?', null, md5('apprecalc-mcq-b9-h-1.13-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'all real numbers t', false, 'This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed seconds and the height cannot be negative, so the model only makes sense while its output stays at or above 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 ≤ t ≤ 3/4', false, 'This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 ≤ t ≤ 2', true, 'Correct: Factoring gives −16(t + 1/2)(t − 2), so the zeros are −1/2 and 2. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2 ≤ t ≤ 2', false, 'This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −1/2, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-h-1.12-b','apprecalc-mcq-b9-sv-h-1.12-b-v1','apprecalc-mcq-b9-sv-h-1.12-b-v2','apprecalc-mcq-b9-sv-h-1.12-b-v3','apprecalc-mcq-b9-h-1.13-a','apprecalc-mcq-b9-sv-h-1.13-a-v1','apprecalc-mcq-b9-sv-h-1.13-a-v2','apprecalc-mcq-b9-sv-h-1.13-a-v3','apprecalc-mcq-b9-h-1.13-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-h-1.12-b','apprecalc-mcq-b9-sv-h-1.12-b-v1','apprecalc-mcq-b9-sv-h-1.12-b-v2','apprecalc-mcq-b9-sv-h-1.12-b-v3','apprecalc-mcq-b9-h-1.13-a','apprecalc-mcq-b9-sv-h-1.13-a-v1','apprecalc-mcq-b9-sv-h-1.13-a-v2','apprecalc-mcq-b9-sv-h-1.13-a-v3','apprecalc-mcq-b9-h-1.13-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
