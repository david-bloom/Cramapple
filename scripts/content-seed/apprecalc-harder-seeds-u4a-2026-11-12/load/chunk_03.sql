begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-sv-h-4.5-a-v2','apprecalc-mcq-b4a-sv-h-4.5-a-v3','apprecalc-mcq-b4a-h-4.6-a','apprecalc-mcq-b4a-sv-h-4.6-a-v1','apprecalc-mcq-b4a-sv-h-4.6-a-v2','apprecalc-mcq-b4a-sv-h-4.6-a-v3','apprecalc-mcq-b4a-h-4.7-a','apprecalc-mcq-b4a-sv-h-4.7-a-v1','apprecalc-mcq-b4a-sv-h-4.7-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b4a-sv-h-4.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.5-a-v2', 'mcq', 'test points against an implicit relation and use them to decide whether y is a function of x, without swapping coordinat (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the relation 4x² + y² = 40. Which statement is correct?', null, md5('apprecalc-mcq-b4a-sv-h-4.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The points (2, 3) and (2, −3) both lie on the graph, so y is not a function of x', false, 'These points have the coordinates reversed: substituting x = 2, y = 3 gives 25, not 40.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The points (3, 2) and (3, −2) both lie on the graph, so y is not a function of x', true, 'Correct: Substituting (3, 2) gives 36 + 4 = 40, and (3, −2) gives the same value since y is squared. One input x = 3 then has two outputs, so y is not a function of x. Reversed coordinates (2, 3) give 25 ≠ 40.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The point (3, 2) lies on the graph but (3, −2) does not, so y is a function of x', false, 'Since y appears only as y², replacing y with −2 gives the same value 4, so (3, −2) also lies on the graph.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The points (3, 2) and (3, −2) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis', false, 'Symmetry about the x-axis is exactly what produces two outputs for one input: x = 3 has y = 2 and y = −2, which breaks the definition of a function.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.5-a-v3', 'mcq', 'test points against an implicit relation and use them to decide whether y is a function of x, without swapping coordinat (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the relation x² + 2y² = 27. Which statement is correct?', null, md5('apprecalc-mcq-b4a-sv-h-4.5-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The points (5, 1) and (5, −1) both lie on the graph, so y is not a function of x', true, 'Correct: Substituting (5, 1) gives 25 + 2 = 27, and (5, −1) gives the same value since y is squared. One input x = 5 then has two outputs, so y is not a function of x. Reversed coordinates (1, 5) give 51 ≠ 27.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The points (1, 5) and (1, −5) both lie on the graph, so y is not a function of x', false, 'These points have the coordinates reversed: substituting x = 1, y = 5 gives 51, not 27.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The point (5, 1) lies on the graph but (5, −1) does not, so y is a function of x', false, 'Since y appears only as y², replacing y with −1 gives the same value 2, so (5, −1) also lies on the graph.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The points (5, 1) and (5, −1) both lie on the graph, and y is a function of x because the graph is symmetric about the x-axis', false, 'Symmetry about the x-axis is exactly what produces two outputs for one input: x = 5 has y = 1 and y = −1, which breaks the definition of a function.' from version_ins;
-- apprecalc-mcq-b4a-h-4.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.6-a', 'mcq', 'complete the square on a general second-degree equation to identify the conic and read off its center and the endpoints ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of 9x² + 4y² − 36x + 24y + 36 = 0 is an ellipse. Which gives its center and the endpoints of its major axis?', null, md5('apprecalc-mcq-b4a-h-4.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Center (2, −3); the major axis is horizontal with endpoints (−1, −3) and (5, −3)', false, 'Completing the square gives (x − 2)²/4 + (y + 3)²/9 = 1, so the larger denominator 9 is under y and the major axis is vertical, not horizontal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Center (2, −3); the major axis is vertical with endpoints (2, 0) and (2, −6)', true, 'Correct: 9(x² − 4x) + 4(y² + 6y) = −36 gives 9(x − 2)² + 4(y + 3)² = 36, so (x − 2)²/4 + (y + 3)²/9 = 1. Center (2, −3), a = 3 vertical, so endpoints (2, 0) and (2, −6).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Center (−2, 3); the major axis is vertical with endpoints (−2, 6) and (−2, 0)', false, 'The center is found from (x − 2) and (y + 3), so it is (2, −3); the signs of both coordinates were flipped.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Center (2, −3); the major axis is vertical with endpoints (2, 6) and (2, −12)', false, 'The endpoints lie √9 = 3 units from the center, not 9 units; the denominator 9 is a² and must be square-rooted.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.6-a-v1', 'mcq', 'complete the square on a general second-degree equation to identify the conic and read off its center and the endpoints  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of x² − 4y² + 6x + 16y − 11 = 0 is a hyperbola. Which gives its center and its vertices?', null, md5('apprecalc-mcq-b4a-sv-h-4.6-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Center (3, −2); vertices (1, −2) and (5, −2)', false, 'Completing the square gives (x + 3)² − 4(y − 2)² = 4, so the center is (−3, 2); the signs of both coordinates were flipped.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Center (−3, 2); vertices (−7, 2) and (1, 2)', false, 'From (x + 3)²/4 − (y − 2)² = 1 the vertices are √4 = 2 units from the center, not 4 units; the denominator 4 is a² and must be square-rooted.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Center (−3, 2); vertices (−5, 2) and (−1, 2)', true, 'Correct: x² + 6x − 4(y² − 4y) = 11 gives (x + 3)² − 4(y − 2)² = 4, so (x + 3)²/4 − (y − 2)² = 1. Center (−3, 2), a = 2 horizontal, so vertices (−5, 2) and (−1, 2).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Center (−3, 2); vertices (−3, 3) and (−3, 1)', false, 'The positive squared term is the x term, so the hyperbola opens left and right and the vertices are horizontal from the center, not vertical.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.6-a-v2', 'mcq', 'complete the square on a general second-degree equation to identify the conic and read off its center and the endpoints  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of 4x² + y² + 16x − 6y + 9 = 0 is an ellipse. Which gives its center and the endpoints of its major axis?', null, md5('apprecalc-mcq-b4a-sv-h-4.6-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Center (−2, 3); the major axis is horizontal with endpoints (−4, 3) and (0, 3)', false, 'These are the endpoints of the minor axis: completing the square gives (x + 2)²/4 + (y − 3)²/16 = 1, and the longer axis follows the larger denominator 16 under y.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Center (−2, 3); the major axis is vertical with endpoints (−2, 7) and (−2, −1)', true, 'Correct: 4(x² + 4x) + (y² − 6y) = −9 gives 4(x + 2)² + (y − 3)² = 16, so (x + 2)²/4 + (y − 3)²/16 = 1. Center (−2, 3), a = 4 vertical, so endpoints (−2, 7) and (−2, −1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Center (2, −3); the major axis is vertical with endpoints (2, 1) and (2, −7)', false, 'The center comes from (x + 2) and (y − 3), so it is (−2, 3); the signs of both coordinates were flipped.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Center (−2, 3); the major axis is vertical with endpoints (−2, 19) and (−2, −13)', false, 'The endpoints lie √16 = 4 units from the center, not 16; the denominator 16 is a² and must be square-rooted.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.6-a-v3', 'mcq', 'complete the square on a general second-degree equation to identify the conic and read off its center and the endpoints  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of y² − 6y − 8x + 25 = 0 is a parabola. Which gives its focus?', null, md5('apprecalc-mcq-b4a-sv-h-4.6-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(10, 3)', false, 'Completing the square gives (y − 3)² = 8(x − 2), so 4p = 8 and p = 2; the focus is 2 units from the vertex (2, 3), not 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '(0, 3)', false, 'The coefficient of (x − 2) is positive, so the parabola opens to the right and the focus lies to the right of the vertex, not to the left.' from version_ins
union all select gen_random_uuid(), id, 'C', '(4, 3)', true, 'Correct: y² − 6y + 9 = 8x − 16 gives (y − 3)² = 8(x − 2). Vertex (2, 3), 4p = 8 so p = 2, opening right, so the focus is (4, 3).' from version_ins
union all select gen_random_uuid(), id, 'D', '(2, 5)', false, 'The squared term is y, so the parabola opens horizontally and the focus is found by moving along the x-direction from the vertex, not the y-direction.' from version_ins;
-- apprecalc-mcq-b4a-h-4.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-h-4.7-a', 'mcq', 'choose a parametrization that traces an entire implicitly defined curve, checking the denominators, shifts and parameter', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which parametrization traces the entire curve x²/25 + y²/4 = 1 exactly once?', null, md5('apprecalc-mcq-b4a-h-4.7-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 2cos t, y = 5 sin t, 0 ≤ t ≤ 2π', false, 'This swaps the semi-axes: with these equations x²/25 + y²/4 = 4cos²t/25 + 25 sin²t/4, which is not equal to 1 for all t.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 25cos t, y = 4 sin t, 0 ≤ t ≤ 2π', false, 'The denominators 25 and 4 are the squares of the semi-axes, so the multipliers should be √25 = 5 and √4 = 2, not 25 and 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 5cos t, y = 2 sin t, 0 ≤ t ≤ 2π', true, 'Correct: With x = 5cos t and y = 2 sin t, x²/25 + y²/4 = cos²t + sin²t = 1, and 0 ≤ t ≤ 2π covers one full revolution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 5cos t, y = 2 sin t, 0 ≤ t ≤ π', false, 'These equations do satisfy the relation, but 0 ≤ t ≤ π traces only the upper half of the ellipse, not the entire curve.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.7-a-v1', 'mcq', 'choose a parametrization that traces an entire implicitly defined curve, checking the denominators, shifts and parameter (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which parametrization traces the entire curve (x − 1)²/9 + (y + 2)²/16 = 1 exactly once?', null, md5('apprecalc-mcq-b4a-sv-h-4.7-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −1 + 3cos t, y = 2 + 4 sin t, 0 ≤ t ≤ 2π', false, 'These equations center the ellipse at (−1, 2); the relation is centered at (1, −2), so the shifts must be +1 and −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 1 + 4cos t, y = −2 + 3 sin t, 0 ≤ t ≤ 2π', false, 'This swaps the semi-axes: the x-direction has denominator 9, so the multiplier on cos t is 3 and the multiplier on sin t is 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1 + 3cos t, y = −2 + 4 sin t, 0 ≤ t ≤ π', false, 'These equations satisfy the relation, but 0 ≤ t ≤ π traces only the upper half of the ellipse, not the entire curve.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 1 + 3cos t, y = −2 + 4 sin t, 0 ≤ t ≤ 2π', true, 'Correct: ((x − 1)/3)² + ((y + 2)/4)² = cos²t + sin²t = 1, and 0 ≤ t ≤ 2π covers one full revolution.' from version_ins;
-- apprecalc-mcq-b4a-sv-h-4.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b4a-sv-h-4.7-a-v2', 'mcq', 'choose a parametrization that traces an entire implicitly defined curve, checking the denominators, shifts and parameter (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which parametrization traces the entire parabola y² = 8x?', null, md5('apprecalc-mcq-b4a-sv-h-4.7-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 4t², y = 2t, for all real t', false, 'Here y² = 4t² but 8x = 32t², so the points do not satisfy y² = 8x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 4t, y = 2t², for all real t', false, 'This swaps the roles of x and y: y² = 4t⁴ while 8x = 32t, so the points do not satisfy y² = 8x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 2t², y = 4t, for t ≥ 0', false, 'These equations satisfy the relation, but t ≥ 0 gives y ≥ 0, so only the upper half of the parabola is traced.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 2t², y = 4t, for all real t', true, 'Correct: With x = 2t² and y = 4t, y² = 16t² = 8(2t²) = 8x, and as t ranges over all reals y takes every real value, so the whole parabola is traced.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b4a-sv-h-4.5-a-v2','apprecalc-mcq-b4a-sv-h-4.5-a-v3','apprecalc-mcq-b4a-h-4.6-a','apprecalc-mcq-b4a-sv-h-4.6-a-v1','apprecalc-mcq-b4a-sv-h-4.6-a-v2','apprecalc-mcq-b4a-sv-h-4.6-a-v3','apprecalc-mcq-b4a-h-4.7-a','apprecalc-mcq-b4a-sv-h-4.7-a-v1','apprecalc-mcq-b4a-sv-h-4.7-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b4a-sv-h-4.5-a-v2','apprecalc-mcq-b4a-sv-h-4.5-a-v3','apprecalc-mcq-b4a-h-4.6-a','apprecalc-mcq-b4a-sv-h-4.6-a-v1','apprecalc-mcq-b4a-sv-h-4.6-a-v2','apprecalc-mcq-b4a-sv-h-4.6-a-v3','apprecalc-mcq-b4a-h-4.7-a','apprecalc-mcq-b4a-sv-h-4.7-a-v1','apprecalc-mcq-b4a-sv-h-4.7-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
