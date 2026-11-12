begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.3-a-v2','apprecalc-mcq-b10-sv-h-1.3-a-v3','apprecalc-mcq-b10-h-1.3-b','apprecalc-mcq-b10-sv-h-1.3-b-v1','apprecalc-mcq-b10-sv-h-1.3-b-v2','apprecalc-mcq-b10-sv-h-1.3-b-v3','apprecalc-mcq-b10-h-1.4-a','apprecalc-mcq-b10-sv-h-1.4-a-v1','apprecalc-mcq-b10-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.3-a-v2', 'mcq', 'infer concavity from average rates over intervals of unequal width, not from raw changes in output. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company''s cumulative output f is logged at the days x = 2, 6, 8, 9, with corresponding totals 3, 7, 10, 12. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?', null, md5('apprecalc-mcq-b10-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is increasing and concave down', false, 'This compares the changes in output (4, 3, 2) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are 1, 1.5, 2, which are increasing, so f is concave up.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is decreasing and concave up', false, 'This has the right concavity but the wrong direction. Every average rate (1, 1.5, 2) is positive, so f is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is decreasing and concave down', false, 'This gets the direction wrong and takes concavity from the raw output changes (4, 3, 2) rather than from the rates (1, 1.5, 2). The rates show f is increasing and concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is increasing and concave up', true, 'Correct: The average rates on the three intervals are 1, 1.5, 2. They are positive and increasing, so f is increasing and concave up.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.3-a-v3', 'mcq', 'infer concavity from average rates over intervals of unequal width, not from raw changes in output. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A balloon''s height f is logged at the seconds x = 0, 1, 3, 7, with corresponding heights 20, 17, 12, 4. Assume the graph of f is continuous and has the same concavity throughout this interval. Which description of f is supported by the average rates of change?', null, md5('apprecalc-mcq-b10-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f is increasing and concave up', false, 'This has the right concavity but the wrong direction. Every average rate (−3, −2.5, −2) is negative, so f is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f is decreasing and concave up', true, 'Correct: The average rates on the three intervals are −3, −2.5, −2. They are negative and increasing, so f is decreasing and concave up.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f is increasing and concave down', false, 'This gets the direction wrong and takes concavity from the raw output changes (−3, −5, −8) rather than from the rates (−3, −2.5, −2). The rates show f is decreasing and concave up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f is decreasing and concave down', false, 'This compares the changes in output (−3, −5, −8) instead of the average rates. The input intervals have different widths, so the changes mislead; the rates are −3, −2.5, −2, which are increasing, so f is concave up.' from version_ins;
-- apprecalc-mcq-b10-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.3-b', 'mcq', 'locate local extrema from the sign changes in a list of average rates over consecutive unit intervals, without over-clai', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function f has average rates of change over the successive unit intervals [0,1], [1,2], [2,3], and so on, of 8, 5, 1, −2, −3, −1, 3. Which statement must be true?', null, md5('apprecalc-mcq-b10-h-1.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum for some x between 2 and 4 and a local maximum for some x between 5 and 7.', false, 'This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local maximum for some x between 2 and 4 and a local minimum for some x between 5 and 7.', true, 'Correct: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 2–4 and 5–7.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has a local maximum at x = 3 and a local minimum at x = 6.', false, 'This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has a local maximum for some x between 3 and 4 and a local minimum for some x between 6 and 7.', false, 'This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.3-b-v1', 'mcq', 'locate local extrema from the sign changes in a list of average rates over consecutive unit intervals, without over-clai (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The altitude f(t) of a glider, with t in minutes, is continuous. Its average rates of change over the successive unit intervals [0,1], [1,2], [2,3], and so on, are −5, −2, 1, 4, 3, −1, −4, −2. Which statement must be true?', null, md5('apprecalc-mcq-b10-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum for some x between 1 and 3 and a local maximum for some x between 4 and 6.', true, 'Correct: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 1–3 and 4–6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local maximum for some x between 1 and 3 and a local minimum for some x between 4 and 6.', false, 'This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has a local minimum at x = 2 and a local maximum at x = 5.', false, 'This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has a local minimum for some x between 2 and 3 and a local maximum for some x between 5 and 6.', false, 'This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.3-b-v2', 'mcq', 'locate local extrema from the sign changes in a list of average rates over consecutive unit intervals, without over-clai (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stock index f(d) is a continuous function of the day d. Its average rates of change over the successive one-day intervals [0,1], [1,2], [2,3], and so on, are 4, 1, −2, −3, −1, 2, 3. Which statement must be true?', null, md5('apprecalc-mcq-b10-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local minimum for some x between 1 and 3 and a local maximum for some x between 4 and 6.', false, 'This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local maximum for some x between 1 and 3 and a local minimum for some x between 4 and 6.', true, 'Correct: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 1–3 and 4–6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has a local maximum at x = 2 and a local minimum at x = 5.', false, 'This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has a local maximum for some x between 2 and 3 and a local minimum for some x between 5 and 6.', false, 'This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.3-b-v3', 'mcq', 'locate local extrema from the sign changes in a list of average rates over consecutive unit intervals, without over-clai (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature f(h) of a room is a continuous function of the hour h. Its average rates of change over the successive one-hour intervals [0,1], [1,2], [2,3], and so on, are −2, 3, 5, 2, −1, −4, −3, 1. Which statement must be true?', null, md5('apprecalc-mcq-b10-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has a local maximum for some x between 0 and 2, a local minimum for some x between 3 and 5, and a local maximum for some x between 6 and 8.', false, 'This reverses the roles. A change in the sign of the average rate from positive to negative means the function rose and then fell, which is a local maximum; from negative to positive it is a local minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has a local minimum at x = 1, a local maximum at x = 4, and a local minimum at x = 7.', false, 'This places each extremum at the midpoint of the pair of intervals where the sign of the rate changes. The averages only show that the extremum lies somewhere within that stretch, not that it sits at one particular input.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has a local minimum for some x between 0 and 2, a local maximum for some x between 3 and 5, and a local minimum for some x between 6 and 8.', true, 'Correct: A positive average rate on one unit interval followed by a negative one means f rose and then fell across those two intervals, so by continuity a local maximum lies within them; the reverse change gives a local minimum. The sign changes are at 0–2, 3–5, and 6–8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has a local minimum for some x between 1 and 2, a local maximum for some x between 4 and 5, and a local minimum for some x between 7 and 8.', false, 'This narrows the location to the single interval where the rate first has the new sign. The function could turn around in the earlier interval, so the sign change only places the turn somewhere in the two intervals together.' from version_ins;
-- apprecalc-mcq-b10-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.4-a', 'mcq', 'extend a table of a cubic by propagating the constant third difference back through second and first differences, reject', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cubic polynomial model f has the following values at equally spaced inputs x = 0, 1, 2, 3, 4: 2, 2, 4, 14, 38. What is the value of f(5) predicted by the model?', null, md5('apprecalc-mcq-b10-h-1.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '76', false, 'This assumes the second differences stay constant at 14, which would make the model quadratic. The second differences here are 2, 8, 14, not constant; the third differences are constant.' from version_ins
union all select gen_random_uuid(), id, 'B', '82', true, 'Correct: First differences 0, 2, 10, 24; second differences 2, 8, 14; third differences constant at 6. The next second difference is 20, the next first difference is 44, so the next value is 82.' from version_ins
union all select gen_random_uuid(), id, 'C', '62', false, 'This assumes the first differences stay constant at 24, which would make the model linear. The first differences are 0, 2, 10, 24, so they keep changing.' from version_ins
union all select gen_random_uuid(), id, 'D', '68', false, 'This adds the constant third difference 6 directly to the last first difference. It must first be added to the last second difference (14) to get the next second difference, and that is then added to the last first difference.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.4-a-v1', 'mcq', 'extend a table of a cubic by propagating the constant third difference back through second and first differences, reject (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A designer fits a cubic polynomial g to measurements taken at x = 0, 2, 4, 6, 8, getting g = 7, 9, 15, 19, 15. According to the cubic model, what is g(10)?', null, md5('apprecalc-mcq-b10-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'This assumes the second differences stay constant at −8, which would make the model quadratic. The second differences here are 4, −2, −8, not constant; the third differences are constant.' from version_ins
union all select gen_random_uuid(), id, 'B', '11', false, 'This assumes the first differences stay constant at −4, which would make the model linear. The first differences are 2, 6, 4, −4, so they keep changing.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This adds the constant third difference −6 directly to the last first difference. It must first be added to the last second difference (−8) to get the next second difference, and that is then added to the last first difference.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', true, 'Correct: First differences 2, 6, 4, −4; second differences 4, −2, −8; third differences constant at −6. The next second difference is −14, the next first difference is −18, so the next value is −3.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.4-a-v2', 'mcq', 'extend a table of a cubic by propagating the constant third difference back through second and first differences, reject (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cubic polynomial p models the depth of a channel at positions x = 1, 2, 3, 4, 5 meters, with depths 5, 4, 9, 32, 85 centimeters. What depth does the model give at x = 6?', null, md5('apprecalc-mcq-b10-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '180', true, 'Correct: First differences −1, 5, 23, 53; second differences 6, 18, 30; third differences constant at 12. The next second difference is 42, the next first difference is 95, so the next value is 180.' from version_ins
union all select gen_random_uuid(), id, 'B', '168', false, 'This assumes the second differences stay constant at 30, which would make the model quadratic. The second differences here are 6, 18, 30, not constant; the third differences are constant.' from version_ins
union all select gen_random_uuid(), id, 'C', '138', false, 'This assumes the first differences stay constant at 53, which would make the model linear. The first differences are −1, 5, 23, 53, so they keep changing.' from version_ins
union all select gen_random_uuid(), id, 'D', '150', false, 'This adds the constant third difference 12 directly to the last first difference. It must first be added to the last second difference (30) to get the next second difference, and that is then added to the last first difference.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.3-a-v2','apprecalc-mcq-b10-sv-h-1.3-a-v3','apprecalc-mcq-b10-h-1.3-b','apprecalc-mcq-b10-sv-h-1.3-b-v1','apprecalc-mcq-b10-sv-h-1.3-b-v2','apprecalc-mcq-b10-sv-h-1.3-b-v3','apprecalc-mcq-b10-h-1.4-a','apprecalc-mcq-b10-sv-h-1.4-a-v1','apprecalc-mcq-b10-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-sv-h-1.3-a-v2','apprecalc-mcq-b10-sv-h-1.3-a-v3','apprecalc-mcq-b10-h-1.3-b','apprecalc-mcq-b10-sv-h-1.3-b-v1','apprecalc-mcq-b10-sv-h-1.3-b-v2','apprecalc-mcq-b10-sv-h-1.3-b-v3','apprecalc-mcq-b10-h-1.4-a','apprecalc-mcq-b10-sv-h-1.4-a-v1','apprecalc-mcq-b10-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
