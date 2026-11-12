begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-h-2.9-a','apprecalc-mcq-b8-sv-h-2.9-a-v1','apprecalc-mcq-b8-sv-h-2.9-a-v2','apprecalc-mcq-b8-sv-h-2.9-a-v3','apprecalc-mcq-b8-h-2.9-b','apprecalc-mcq-b8-sv-h-2.9-b-v1','apprecalc-mcq-b8-sv-h-2.9-b-v2','apprecalc-mcq-b8-sv-h-2.9-b-v3','apprecalc-mcq-b8-h-2.10-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-h-2.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.9-a', 'mcq', 'order logarithms with different bases and arguments by estimating each value against benchmarks, rather than by the size', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the numbers log₄(8), log₂(5), log₃(30) from least to greatest?', null, md5('apprecalc-mcq-b8-h-2.9-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₂(5) < log₄(8) < log₃(30)', false, 'This sorts by the size of the number inside each logarithm (5, 8, 30), but the base matters just as much. The actual values are log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂(5) < log₃(30) < log₄(8)', false, 'This sorts by the size of the base (2, 3, 4), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₄(8) < log₂(5) < log₃(30)', true, 'Correct: Compare each to benchmarks or compute it: log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10. Least to greatest is log₄(8) < log₂(5) < log₃(30).' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₃(30) < log₂(5) < log₄(8)', false, 'This is the order from greatest to least. Estimating each value gives log₄(8) ≈ 1.50, log₂(5) ≈ 2.32, log₃(30) ≈ 3.10, so the list must run the other way.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.9-a-v1', 'mcq', 'order logarithms with different bases and arguments by estimating each value against benchmarks, rather than by the size (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the numbers log₃(6), log₅(25), log₂(12) from least to greatest?', null, md5('apprecalc-mcq-b8-sv-h-2.9-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₃(6) < log₂(12) < log₅(25)', false, 'This sorts by the size of the number inside each logarithm (6, 12, 25), but the base matters just as much. The actual values are log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂(12) < log₃(6) < log₅(25)', false, 'This sorts by the size of the base (2, 3, 5), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₃(6) < log₅(25) < log₂(12)', true, 'Correct: Compare each to benchmarks or compute it: log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58. Least to greatest is log₃(6) < log₅(25) < log₂(12).' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₂(12) < log₅(25) < log₃(6)', false, 'This is the order from greatest to least. Estimating each value gives log₃(6) ≈ 1.63, log₅(25) ≈ 2.00, log₂(12) ≈ 3.58, so the list must run the other way.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.9-a-v2', 'mcq', 'order logarithms with different bases and arguments by estimating each value against benchmarks, rather than by the size (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the numbers log₃(5), log₂(9), log₅(40) from least to greatest?', null, md5('apprecalc-mcq-b8-sv-h-2.9-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₃(5) < log₂(9) < log₅(40)', false, 'This sorts by the size of the number inside each logarithm (5, 9, 40), but the base matters just as much. The actual values are log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂(9) < log₃(5) < log₅(40)', false, 'This sorts by the size of the base (2, 3, 5), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₂(9) < log₅(40) < log₃(5)', false, 'This is the order from greatest to least. Estimating each value gives log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17, so the list must run the other way.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₃(5) < log₅(40) < log₂(9)', true, 'Correct: Compare each to benchmarks or compute it: log₃(5) ≈ 1.46, log₅(40) ≈ 2.29, log₂(9) ≈ 3.17. Least to greatest is log₃(5) < log₅(40) < log₂(9).' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.9-a-v3', 'mcq', 'order logarithms with different bases and arguments by estimating each value against benchmarks, rather than by the size (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which list orders the numbers log₄(3), log₆(36), log₂(6) from least to greatest?', null, md5('apprecalc-mcq-b8-sv-h-2.9-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₄(3) < log₂(6) < log₆(36)', false, 'This sorts by the size of the number inside each logarithm (3, 6, 36), but the base matters just as much. The actual values are log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂(6) < log₄(3) < log₆(36)', false, 'This sorts by the size of the base (2, 4, 6), assuming a larger base gives a larger logarithm. The base and the argument both matter: log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₂(6) < log₆(36) < log₄(3)', false, 'This is the order from greatest to least. Estimating each value gives log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58, so the list must run the other way.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₄(3) < log₆(36) < log₂(6)', true, 'Correct: Compare each to benchmarks or compute it: log₄(3) ≈ 0.79, log₆(36) ≈ 2.00, log₂(6) ≈ 2.58. Least to greatest is log₄(3) < log₆(36) < log₂(6).' from version_ins;
-- apprecalc-mcq-b8-h-2.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.9-b', 'mcq', 'solve a nested logarithmic equation by undoing the outer logarithm first and then the inner one, keeping track of which ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If log₂(log₃(x)) = 1, what is x?', null, md5('apprecalc-mcq-b8-h-2.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9', true, 'Correct: The outer log gives log₃(x) = 2^1 = 2; then x = 3^2 = 9. Check: log₃(9) = 2 and log₂(2) = 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This undoes the logarithms in the wrong order or with the wrong bases: log₃(x) = 2^1 = 2, so x is a power of 3, not a power of 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This ignores the outer logarithm and treats log₃(x) as if it equalled 1, so it stops after one step.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This finds log₃(x) = 2 correctly but then multiplies 3 by 2 instead of raising 3 to the power 2.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.9-b-v1', 'mcq', 'solve a nested logarithmic equation by undoing the outer logarithm first and then the inner one, keeping track of which  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If log₂(log₃(x)) = 2, what is x?', null, md5('apprecalc-mcq-b8-sv-h-2.9-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '512', false, 'This undoes the logarithms in the wrong order or with the wrong bases: log₃(x) = 2^2 = 4, so x is a power of 3, not a power of 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '81', true, 'Correct: The outer log gives log₃(x) = 2^2 = 4; then x = 3^4 = 81. Check: log₃(81) = 4 and log₂(4) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '9', false, 'This ignores the outer logarithm and treats log₃(x) as if it equalled 2, so it stops after one step.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', false, 'This finds log₃(x) = 4 correctly but then multiplies 3 by 4 instead of raising 3 to the power 4.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.9-b-v2', 'mcq', 'solve a nested logarithmic equation by undoing the outer logarithm first and then the inner one, keeping track of which  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If log₃(log₂(x)) = 1, what is x?', null, md5('apprecalc-mcq-b8-sv-h-2.9-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9', false, 'This undoes the logarithms in the wrong order or with the wrong bases: log₂(x) = 3^1 = 3, so x is a power of 2, not a power of 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', true, 'Correct: The outer log gives log₂(x) = 3^1 = 3; then x = 2^3 = 8. Check: log₂(8) = 3 and log₃(3) = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This ignores the outer logarithm and treats log₂(x) as if it equalled 1, so it stops after one step.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This finds log₂(x) = 3 correctly but then multiplies 2 by 3 instead of raising 2 to the power 3.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.9-b-v3', 'mcq', 'solve a nested logarithmic equation by undoing the outer logarithm first and then the inner one, keeping track of which  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If log₂(log₅(x)) = 1, what is x?', null, md5('apprecalc-mcq-b8-sv-h-2.9-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '32', false, 'This undoes the logarithms in the wrong order or with the wrong bases: log₅(x) = 2^1 = 2, so x is a power of 5, not a power of 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This ignores the outer logarithm and treats log₅(x) as if it equalled 1, so it stops after one step.' from version_ins
union all select gen_random_uuid(), id, 'C', '25', true, 'Correct: The outer log gives log₅(x) = 2^1 = 2; then x = 5^2 = 25. Check: log₅(25) = 2 and log₂(2) = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '10', false, 'This finds log₅(x) = 2 correctly but then multiplies 5 by 2 instead of raising 5 to the power 2.' from version_ins;
-- apprecalc-mcq-b8-h-2.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.10-a', 'mcq', 'evaluate the inverse of a shifted and scaled exponential function at a given output by undoing the shift, the scale, and', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 3·2ˣ − 5. What is f⁻¹(19)?', null, md5('apprecalc-mcq-b8-h-2.10-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: Solve 3·2ˣ − 5 = 19: 2ˣ = 8, so x = log₂(8) = 3. Check: 3·2^(3) + (-5) = 19.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This isolates the exponential, 2ˣ = 8, and stops there. The inverse value is the exponent x, so one more step, log₂(8) = 3, is needed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₂(14/3)', false, 'The constant must be removed by subtracting c: 19 − (-5) = 24. This uses 19 + (-5) = 14 instead, so the shift is moved the wrong way.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₂(19/3) + 5', false, 'This takes the logarithm of 19 divided by 3 before removing the constant, then adjusts by the constant afterward. The constant is inside the exponential relationship and must be subtracted from 19 first.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-h-2.9-a','apprecalc-mcq-b8-sv-h-2.9-a-v1','apprecalc-mcq-b8-sv-h-2.9-a-v2','apprecalc-mcq-b8-sv-h-2.9-a-v3','apprecalc-mcq-b8-h-2.9-b','apprecalc-mcq-b8-sv-h-2.9-b-v1','apprecalc-mcq-b8-sv-h-2.9-b-v2','apprecalc-mcq-b8-sv-h-2.9-b-v3','apprecalc-mcq-b8-h-2.10-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-h-2.9-a','apprecalc-mcq-b8-sv-h-2.9-a-v1','apprecalc-mcq-b8-sv-h-2.9-a-v2','apprecalc-mcq-b8-sv-h-2.9-a-v3','apprecalc-mcq-b8-h-2.9-b','apprecalc-mcq-b8-sv-h-2.9-b-v1','apprecalc-mcq-b8-sv-h-2.9-b-v2','apprecalc-mcq-b8-sv-h-2.9-b-v3','apprecalc-mcq-b8-h-2.10-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
