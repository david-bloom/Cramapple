begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.7-b-v2','apprecalc-mcq-b7-sv-h-2.7-b-v3','apprecalc-mcq-b7-h-2.8-a','apprecalc-mcq-b7-sv-h-2.8-a-v1','apprecalc-mcq-b7-sv-h-2.8-a-v2','apprecalc-mcq-b7-sv-h-2.8-a-v3','apprecalc-mcq-b7-h-2.8-b','apprecalc-mcq-b7-sv-h-2.8-b-v1','apprecalc-mcq-b7-sv-h-2.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-sv-h-2.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.7-b-v2', 'mcq', 'solve an equation that sets two different compositions of the same functions equal, expanding the square of a linear exp (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 5x + 16 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?', null, md5('apprecalc-mcq-b7-sv-h-2.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is no real value of x', false, 'This drops the middle term when squaring, writing (f(x))² as 25x² + 256. Then f(g(x)) = g(f(x)) reduces to 5x² + 16 = 25x² + 256, which has no real solution, but the correct expansion is (5x + 16)² = 25x² + 160x + 256.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = −6 and x = −2', true, 'Correct: f(g(x)) = 5x² + 16 and g(f(x)) = (5x + 16)² = 25x² + 160x + 256. Setting them equal: 20x² + 160x + 240 = 0, which factors to give x = −6 or x = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 2 and x = 6', false, 'This has the right size of solutions with the wrong signs. The equation is 20x² + 160x + 240 = 0, and substituting x = 2 gives 640 instead of 0, so these are not solutions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −8 and x = 0', false, 'This squares the linear expression as 25x² + 160x + 16, using 16 instead of 16² = 256 for the last term. Then the equation is 20x² + 160x = 0, whose solutions are x = 0 and x = −8.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.7-b-v3', 'mcq', 'solve an equation that sets two different compositions of the same functions equal, expanding the square of a linear exp (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 6x + 10 and g(x) = x². For which real values of x is f(g(x)) = g(f(x))?', null, md5('apprecalc-mcq-b7-sv-h-2.7-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = −3 and x = −1', true, 'Correct: f(g(x)) = 6x² + 10 and g(f(x)) = (6x + 10)² = 36x² + 120x + 100. Setting them equal: 30x² + 120x + 90 = 0, which factors to give x = −3 or x = −1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is no real value of x', false, 'This drops the middle term when squaring, writing (f(x))² as 36x² + 100. Then f(g(x)) = g(f(x)) reduces to 6x² + 10 = 36x² + 100, which has no real solution, but the correct expansion is (6x + 10)² = 36x² + 120x + 100.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 1 and x = 3', false, 'This has the right size of solutions with the wrong signs. The equation is 30x² + 120x + 90 = 0, and substituting x = 1 gives 240 instead of 0, so these are not solutions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = −4 and x = 0', false, 'This squares the linear expression as 36x² + 120x + 10, using 10 instead of 10² = 100 for the last term. Then the equation is 30x² + 120x = 0, whose solutions are x = 0 and x = −4.' from version_ins;
-- apprecalc-mcq-b7-h-2.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.8-a', 'mcq', 'find the inverse of a rational function by swapping and solving, and reject the reciprocal and sign-slip answers by comp', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (3x + 2)/(x − 4) for x ≠ 4. Which expression is f⁻¹(x)?', null, md5('apprecalc-mcq-b7-h-2.8-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x − 4)/(3x + 2)', false, 'This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives −39/113.' from version_ins
union all select gen_random_uuid(), id, 'B', '(4x − 2)/(x − 3)', false, 'This makes a sign error on the constant when collecting terms after swapping x and y: from xy − 4x = 3y + 2 it takes y(x − 3) = 4x − 2 instead of 4x + 2. Applying f to this expression at x = 7/3 gives 31/15, not 7/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(4x + 2)/(x − 3)', true, 'Correct: Swap x and y: x = (3y + 2)/(y − 4). Multiplying out gives xy − 4x = 3y + 2, so y(x − 3) = 4x + 2, and y = (4x + 2)/(x − 3). Check: f(f⁻¹(7/3)) = 7/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−4x − 2)/(x − 3)', false, 'This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 3) = −4x − 2 instead of 4x + 2. Applying f to this expression at x = 7/3 gives 53/13, not 7/3.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.8-a-v1', 'mcq', 'find the inverse of a rational function by swapping and solving, and reject the reciprocal and sign-slip answers by comp (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (2x − 1)/(x + 3) for x ≠ −3. Which expression is f⁻¹(x)?', null, md5('apprecalc-mcq-b7-sv-h-2.8-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3x − 1)/(x − 2)', true, 'Correct: Swap x and y: x = (2y − 1)/(y + 3). Multiplying out gives xy + 3x = 2y − 1, so y(x − 2) = −3x − 1, and y = (−3x − 1)/(x − 2). Check: f(f⁻¹(7/3)) = 7/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '(x + 3)/(2x − 1)', false, 'This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives 3/7.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−3x + 1)/(x − 2)', false, 'This makes a sign error on the constant when collecting terms after swapping x and y: from xy + 3x = 2y − 1 it takes y(x − 2) = −3x + 1 instead of −3x − 1. Applying f to this expression at x = 7/3 gives 37/15, not 7/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(3x + 1)/(x − 2)', false, 'This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 2) = 3x + 1 instead of −3x − 1. Applying f to this expression at x = 7/3 gives 47/27, not 7/3.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.8-a-v2', 'mcq', 'find the inverse of a rational function by swapping and solving, and reject the reciprocal and sign-slip answers by comp (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (5x − 3)/(x − 1) for x ≠ 1. Which expression is f⁻¹(x)?', null, md5('apprecalc-mcq-b7-sv-h-2.8-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x − 1)/(5x − 3)', false, 'This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives 29/11.' from version_ins
union all select gen_random_uuid(), id, 'B', '(x + 3)/(x − 5)', false, 'This makes a sign error on the constant when collecting terms after swapping x and y: from xy − x = 5y − 3 it takes y(x − 5) = x + 3 instead of x − 3. Applying f to this expression at x = 7/3 gives 13/3, not 7/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(x − 3)/(x − 5)', true, 'Correct: Swap x and y: x = (5y − 3)/(y − 1). Multiplying out gives xy − x = 5y − 3, so y(x − 5) = x − 3, and y = (x − 3)/(x − 5). Check: f(f⁻¹(7/3)) = 7/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−x + 3)/(x − 5)', false, 'This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 5) = −x + 3 instead of x − 3. Applying f to this expression at x = 7/3 gives 17/5, not 7/3.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.8-a-v3', 'mcq', 'find the inverse of a rational function by swapping and solving, and reject the reciprocal and sign-slip answers by comp (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (4x + 1)/(x + 2) for x ≠ −2. Which expression is f⁻¹(x)?', null, md5('apprecalc-mcq-b7-sv-h-2.8-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(x + 2)/(4x + 1)', false, 'This is the reciprocal 1/f(x), which is a different function from the inverse. The inverse must satisfy f(f⁻¹(x)) = x, but at x = 7/3 f applied to this expression gives 83/75.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−2x + 1)/(x − 4)', true, 'Correct: Swap x and y: x = (4y + 1)/(y + 2). Multiplying out gives xy + 2x = 4y + 1, so y(x − 4) = −2x + 1, and y = (−2x + 1)/(x − 4). Check: f(f⁻¹(7/3)) = 7/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−2x − 1)/(x − 4)', false, 'This makes a sign error on the constant when collecting terms after swapping x and y: from xy + 2x = 4y + 1 it takes y(x − 4) = −2x − 1 instead of −2x + 1. Applying f to this expression at x = 7/3 gives 73/27, not 7/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(2x − 1)/(x − 4)', false, 'This is the negative of the correct inverse, from moving terms to the wrong side: it takes y(x − 4) = 2x − 1 instead of −2x + 1. Applying f to this expression at x = 7/3 gives 39, not 7/3.' from version_ins;
-- apprecalc-mcq-b7-h-2.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.8-b', 'mcq', 'evaluate an expression combining an inverse with function values from a table, applying the inverse to the combined outp', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 5, f(2) = 8, f(3) = 2, f(4) = 7, f(5) = 3. What is the value of f⁻¹(f(3) + f(5))?', null, md5('apprecalc-mcq-b7-h-2.8-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 5, which is 1, not the output f(5) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This distributes f⁻¹ over the sum, computing f⁻¹(f(3)) + f⁻¹(f(5)) = 3 + 5. Inverse functions do not distribute over addition: the quantity 2 + 3 = 5 must be computed first, and then f⁻¹ applied to it.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This stops after combining the outputs, f(3) + f(5) = 2 + 3 = 5. The question asks for f⁻¹ of that value, the input x with f(x) = 5, and that input is 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', true, 'Correct: f(3) + f(5) = 2 + 3 = 5. Since f(1) = 5, f⁻¹(5) = 1.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.8-b-v1', 'mcq', 'evaluate an expression combining an inverse with function values from a table, applying the inverse to the combined outp (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 3, f(2) = 2, f(3) = 6, f(4) = 5, f(5) = 8. What is the value of f⁻¹(f(2) + f(1))?', null, md5('apprecalc-mcq-b7-sv-h-2.8-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 5, which is 4, not the output f(5) = 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: f(2) + f(1) = 2 + 3 = 5. Since f(4) = 5, f⁻¹(5) = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This distributes f⁻¹ over the sum, computing f⁻¹(f(2)) + f⁻¹(f(1)) = 2 + 1. Inverse functions do not distribute over addition: the quantity 2 + 3 = 5 must be computed first, and then f⁻¹ applied to it.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This stops after combining the outputs, f(2) + f(1) = 2 + 3 = 5. The question asks for f⁻¹ of that value, the input x with f(x) = 5, and that input is 4.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.8-b-v2', 'mcq', 'evaluate an expression combining an inverse with function values from a table, applying the inverse to the combined outp (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is one-to-one with domain {1, 2, 3, 4, 5}, and f(1) = 2, f(2) = 6, f(3) = 4, f(4) = 9, f(5) = 3. What is the value of f⁻¹(f(4) − f(2))?', null, md5('apprecalc-mcq-b7-sv-h-2.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'This applies f to the result instead of f⁻¹. The expression asks for the input that f sends to 3, which is 5, not the output f(3) = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', true, 'Correct: f(4) − f(2) = 9 − 6 = 3. Since f(5) = 3, f⁻¹(3) = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This distributes f⁻¹ over the difference, computing f⁻¹(f(4)) − f⁻¹(f(2)) = 4 − 2. Inverse functions do not distribute over subtraction: the quantity 9 − 6 = 3 must be computed first, and then f⁻¹ applied to it.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'This stops after combining the outputs, f(4) − f(2) = 9 − 6 = 3. The question asks for f⁻¹ of that value, the input x with f(x) = 3, and that input is 5.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.7-b-v2','apprecalc-mcq-b7-sv-h-2.7-b-v3','apprecalc-mcq-b7-h-2.8-a','apprecalc-mcq-b7-sv-h-2.8-a-v1','apprecalc-mcq-b7-sv-h-2.8-a-v2','apprecalc-mcq-b7-sv-h-2.8-a-v3','apprecalc-mcq-b7-h-2.8-b','apprecalc-mcq-b7-sv-h-2.8-b-v1','apprecalc-mcq-b7-sv-h-2.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-sv-h-2.7-b-v2','apprecalc-mcq-b7-sv-h-2.7-b-v3','apprecalc-mcq-b7-h-2.8-a','apprecalc-mcq-b7-sv-h-2.8-a-v1','apprecalc-mcq-b7-sv-h-2.8-a-v2','apprecalc-mcq-b7-sv-h-2.8-a-v3','apprecalc-mcq-b7-h-2.8-b','apprecalc-mcq-b7-sv-h-2.8-b-v1','apprecalc-mcq-b7-sv-h-2.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
