begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.4-a-v3','apprecalc-mcq-b10-h-1.4-b','apprecalc-mcq-b10-sv-h-1.4-b-v1','apprecalc-mcq-b10-sv-h-1.4-b-v2','apprecalc-mcq-b10-sv-h-1.4-b-v3','apprecalc-mcq-b10-h-1.5-a','apprecalc-mcq-b10-sv-h-1.5-a-v1','apprecalc-mcq-b10-sv-h-1.5-a-v2','apprecalc-mcq-b10-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.4-a-v3', 'mcq', 'extend a table of a cubic by propagating the constant third difference back through second and first differences, reject (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial of degree 3 describes the cost c at production levels x = 0, 5, 10, 15, 20, with costs 10, 7, 10, 25, 58. What cost does the model give at x = 25?', null, md5('apprecalc-mcq-b10-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '109', false, 'This assumes the second differences stay constant at 18, which would make the model quadratic. The second differences here are 6, 12, 18, not constant; the third differences are constant.' from version_ins
union all select gen_random_uuid(), id, 'B', '91', false, 'This assumes the first differences stay constant at 33, which would make the model linear. The first differences are −3, 3, 15, 33, so they keep changing.' from version_ins
union all select gen_random_uuid(), id, 'C', '97', false, 'This adds the constant third difference 6 directly to the last first difference. It must first be added to the last second difference (18) to get the next second difference, and that is then added to the last first difference.' from version_ins
union all select gen_random_uuid(), id, 'D', '115', true, 'Correct: First differences −3, 3, 15, 33; second differences 6, 12, 18; third differences constant at 6. The next second difference is 24, the next first difference is 57, so the next value is 115.' from version_ins;
-- apprecalc-mcq-b10-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.4-b', 'mcq', 'combine the turning-point bound (degree at least turning points plus one) with the parity forced by end behavior to find', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial function p has exactly 5 local extrema, and the graph of p falls without bound to the left and rises without bound to the right. What is the least possible degree of p?', null, md5('apprecalc-mcq-b10-h-1.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'A polynomial of degree 5 has at most 4 turning points, but this function has 5. The degree must be at least 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', true, 'Correct: A polynomial of degree n has at most n − 1 turning points, so n ≥ 6. The end behavior makes n odd, so the least possible degree is 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'A polynomial of degree 6 could have 5 turning points, but a degree-6 polynomial is even, so its ends would point the same way. The stated end behavior requires an odd degree.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'A polynomial of degree 4 has at most 3 turning points, but this function has 5. The degree must be at least 6.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.4-b-v1', 'mcq', 'combine the turning-point bound (degree at least turning points plus one) with the parity forced by end behavior to find (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial function q has exactly 3 turning points, and its graph rises without bound at both ends of the graph. What is the least possible degree of q?', null, md5('apprecalc-mcq-b10-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'A polynomial of degree 3 has at most 2 turning points, but this function has 3. The degree must be at least 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'A polynomial of degree 5 could have 3 turning points, but a degree-5 polynomial is odd, so its ends would point in opposite directions. The stated end behavior requires an even degree.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', true, 'Correct: A polynomial of degree n has at most n − 1 turning points, so n ≥ 4. The end behavior makes n even, so the least possible degree is 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'A polynomial of degree 2 has at most 1 turning points, but this function has 3. The degree must be at least 4.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.4-b-v2', 'mcq', 'combine the turning-point bound (degree at least turning points plus one) with the parity forced by end behavior to find (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of a polynomial function r has exactly 4 local extrema and falls without bound to the left and rises without bound to the right. What is the least possible degree of r?', null, md5('apprecalc-mcq-b10-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'A polynomial of degree 4 has at most 3 turning points, but this function has 4. The degree must be at least 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', true, 'Correct: A polynomial of degree n has at most n − 1 turning points, so n ≥ 5. The end behavior makes n odd, so the least possible degree is 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'A polynomial of degree 6 could have 4 turning points, but a degree-6 polynomial is even, so its ends would point the same way. The stated end behavior requires an odd degree.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'A polynomial of degree 3 has at most 2 turning points, but this function has 4. The degree must be at least 5.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.4-b-v3', 'mcq', 'combine the turning-point bound (degree at least turning points plus one) with the parity forced by end behavior to find (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial function s has exactly 2 turning points, and the graph of s rises without bound at both ends of the graph. What is the least possible degree of s?', null, md5('apprecalc-mcq-b10-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'Correct: A polynomial of degree n has at most n − 1 turning points, so n ≥ 3. The end behavior makes n even, so the least possible degree is 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'A polynomial of degree 2 has at most 1 turning points, but this function has 2. The degree must be at least 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'A polynomial of degree 3 could have 2 turning points, but a degree-3 polynomial is odd, so its ends would point in opposite directions. The stated end behavior requires an even degree.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'A polynomial of degree 1 has at most 0 turning points, but this function has 2. The degree must be at least 3.' from version_ins;
-- apprecalc-mcq-b10-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.5-a', 'mcq', 'count real zeros of a real-coefficient polynomial by adding the conjugate of every nonreal zero with its multiplicity be', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial P has real coefficients and degree 9. Every nonreal zero of P is either one of the following numbers or the complex conjugate of one of them: 3 + 2i with multiplicity 2 and −4i with multiplicity 1. Counting multiplicity, how many real zeros does P have?', null, md5('apprecalc-mcq-b10-h-1.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·3 = 6 nonreal zeros, not 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·3 = 6, not 2·2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This subtracts only the 2 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 6 nonreal zeros there are.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'Correct: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(2+1) = 6. The remaining 9 − 6 = 3 zeros are real.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.5-a-v1', 'mcq', 'count real zeros of a real-coefficient polynomial by adding the conjugate of every nonreal zero with its multiplicity be (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial Q has real coefficients and degree 10. Every nonreal zero of Q is either one of the following numbers or the complex conjugate of one of them: 2 − 3i with multiplicity 2 and i with multiplicity 1. Counting multiplicity, how many real zeros does Q have?', null, md5('apprecalc-mcq-b10-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', false, 'This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·3 = 6 nonreal zeros, not 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(2+1) = 6. The remaining 10 − 6 = 4 zeros are real.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·3 = 6, not 2·2 = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '8', false, 'This subtracts only the 2 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 6 nonreal zeros there are.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.5-a-v2', 'mcq', 'count real zeros of a real-coefficient polynomial by adding the conjugate of every nonreal zero with its multiplicity be (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial R has real coefficients and degree 11. Every nonreal zero of R is either one of the following numbers or the complex conjugate of one of them: −1 + 4i with multiplicity 1, 3i with multiplicity 2 and 2 + i with multiplicity 1. Counting multiplicity, how many real zeros does R have?', null, md5('apprecalc-mcq-b10-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(1+2+1) = 8. The remaining 11 − 8 = 3 zeros are real.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·4 = 8 nonreal zeros, not 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·4 = 8, not 2·3 = 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '8', false, 'This subtracts only the 3 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 8 nonreal zeros there are.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.5-a-v3', 'mcq', 'count real zeros of a real-coefficient polynomial by adding the conjugate of every nonreal zero with its multiplicity be (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polynomial S has real coefficients and degree 13. Every nonreal zero of S is either one of the following numbers or the complex conjugate of one of them: 3 + i with multiplicity 1, −5i with multiplicity 2 and 1 − 2i with multiplicity 2. Counting multiplicity, how many real zeros does S have?', null, md5('apprecalc-mcq-b10-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This counts each listed nonreal zero but not its conjugate. Because P has real coefficients, each nonreal zero comes with its conjugate with the same multiplicity, so there are 2·5 = 10 nonreal zeros, not 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Correct: Nonreal zeros come in conjugate pairs with equal multiplicity, so they total 2·(1+2+2) = 10. The remaining 13 − 10 = 3 zeros are real.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This includes the conjugates but counts each listed zero only once. Multiplicity matters when counting zeros, so the nonreal zeros number 2·5 = 10, not 2·3 = 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '10', false, 'This subtracts only the 3 distinct listed zeros. It ignores both the conjugate of each and the multiplicities, so it removes far fewer than the 10 nonreal zeros there are.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-sv-h-1.4-a-v3','apprecalc-mcq-b10-h-1.4-b','apprecalc-mcq-b10-sv-h-1.4-b-v1','apprecalc-mcq-b10-sv-h-1.4-b-v2','apprecalc-mcq-b10-sv-h-1.4-b-v3','apprecalc-mcq-b10-h-1.5-a','apprecalc-mcq-b10-sv-h-1.5-a-v1','apprecalc-mcq-b10-sv-h-1.5-a-v2','apprecalc-mcq-b10-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-sv-h-1.4-a-v3','apprecalc-mcq-b10-h-1.4-b','apprecalc-mcq-b10-sv-h-1.4-b-v1','apprecalc-mcq-b10-sv-h-1.4-b-v2','apprecalc-mcq-b10-sv-h-1.4-b-v3','apprecalc-mcq-b10-h-1.5-a','apprecalc-mcq-b10-sv-h-1.5-a-v1','apprecalc-mcq-b10-sv-h-1.5-a-v2','apprecalc-mcq-b10-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
