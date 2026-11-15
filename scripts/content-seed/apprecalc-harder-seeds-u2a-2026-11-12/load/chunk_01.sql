begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-h-2.1-a','apprecalc-mcq-b7-sv-h-2.1-a-v1','apprecalc-mcq-b7-sv-h-2.1-a-v2','apprecalc-mcq-b7-sv-h-2.1-a-v3','apprecalc-mcq-b7-h-2.1-b','apprecalc-mcq-b7-sv-h-2.1-b-v1','apprecalc-mcq-b7-sv-h-2.1-b-v2','apprecalc-mcq-b7-sv-h-2.1-b-v3','apprecalc-mcq-b7-h-2.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-h-2.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.1-a', 'mcq', 'compare an arithmetic and a geometric sequence term by term to find when the geometric one first overtakes, avoiding ind', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two savings plans are tracked by month number n. Plan X''s balance in dollars is an arithmetic sequence aₙ with a₁ = 200 and common difference 30. Plan Y''s balance in dollars is a geometric sequence bₙ with b₁ = 50 and common ratio 1.4. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?', null, md5('apprecalc-mcq-b7-h-2.1-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', true, 'Correct: aₙ = 200 + 30(n − 1) and bₙ = 50·1.4ⁿ⁻¹. Comparing term by term, b₇ = 376.5 < a₇ = 380, and b₈ = 527.1 > a₈ = 410, so the smallest n is 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This uses bₙ = 50·1.4ⁿ, one term ahead of the sequence described. Since b₁ = 50 is the first term the exponent must be n − 1, and at n = 6 the correct value is b₆ = 268.9, still below a₆ = 350.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This compares the size of each step of bₙ with the constant step 30 of aₙ. The step in bₙ first exceeds 30 at n = 4, but the question is about the values themselves: b₄ = 137.2 is still below a₄ = 290.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₇ = 376.5 is still below a₇ = 380, so Y has not yet passed X at n = 7.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.1-a-v1', 'mcq', 'compare an arithmetic and a geometric sequence term by term to find when the geometric one first overtakes, avoiding ind (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two streaming channels are tracked by week number n. Channel X''s subscriber count is an arithmetic sequence aₙ with a₁ = 500 and common difference 60. Channel Y''s subscriber count is a geometric sequence bₙ with b₁ = 100 and common ratio 1.5. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?', null, md5('apprecalc-mcq-b7-sv-h-2.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', true, 'Correct: aₙ = 500 + 60(n − 1) and bₙ = 100·1.5ⁿ⁻¹. Comparing term by term, b₆ = 759.4 < a₆ = 800, and b₇ = 1139.1 > a₇ = 860, so the smallest n is 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This uses bₙ = 100·1.5ⁿ, one term ahead of the sequence described. Since b₁ = 100 is the first term the exponent must be n − 1, and at n = 5 the correct value is b₅ = 506.3, still below a₅ = 740.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This compares the size of each step of bₙ with the constant step 60 of aₙ. The step in bₙ first exceeds 60 at n = 3, but the question is about the values themselves: b₃ = 225 is still below a₃ = 620.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₆ = 759.4 is still below a₆ = 800, so Y has not yet passed X at n = 6.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.1-a-v2', 'mcq', 'compare an arithmetic and a geometric sequence term by term to find when the geometric one first overtakes, avoiding ind (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two rental programs are tracked by day number n. Program X''s total number of bookings is an arithmetic sequence aₙ with a₁ = 150 and common difference 20. Program Y''s total number of bookings is a geometric sequence bₙ with b₁ = 60 and common ratio 1.25. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?', null, md5('apprecalc-mcq-b7-sv-h-2.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', false, 'This uses bₙ = 60·1.25ⁿ, one term ahead of the sequence described. Since b₁ = 60 is the first term the exponent must be n − 1, and at n = 7 the correct value is b₇ = 228.9, still below a₇ = 270.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This compares the size of each step of bₙ with the constant step 20 of aₙ. The step in bₙ first exceeds 20 at n = 4, but the question is about the values themselves: b₄ = 117.2 is still below a₄ = 210.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₈ = 286.1 is still below a₈ = 290, so Y has not yet passed X at n = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', '9', true, 'Correct: aₙ = 150 + 20(n − 1) and bₙ = 60·1.25ⁿ⁻¹. Comparing term by term, b₈ = 286.1 < a₈ = 290, and b₉ = 357.6 > a₉ = 310, so the smallest n is 9.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.1-a-v3', 'mcq', 'compare an arithmetic and a geometric sequence term by term to find when the geometric one first overtakes, avoiding ind (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two water tanks are tracked by hour number n. Tank X''s volume in liters is an arithmetic sequence aₙ with a₁ = 400 and common difference 80. Tank Y''s volume in liters is a geometric sequence bₙ with b₁ = 40 and common ratio 1.5. For n = 1, 2, 3, …, what is the smallest value of n for which bₙ > aₙ?', null, md5('apprecalc-mcq-b7-sv-h-2.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This uses bₙ = 40·1.5ⁿ, one term ahead of the sequence described. Since b₁ = 40 is the first term the exponent must be n − 1, and at n = 8 the correct value is b₈ = 683.4, still below a₈ = 960.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This compares the size of each step of bₙ with the constant step 80 of aₙ. The step in bₙ first exceeds 80 at n = 6, but the question is about the values themselves: b₆ = 303.8 is still below a₆ = 800.' from version_ins
union all select gen_random_uuid(), id, 'C', '9', false, 'This counts the first term as n = 0, which shifts the answer down by one. With b₁ as the first term, b₉ = 1025.2 is still below a₉ = 1040, so Y has not yet passed X at n = 9.' from version_ins
union all select gen_random_uuid(), id, 'D', '10', true, 'Correct: aₙ = 400 + 80(n − 1) and bₙ = 40·1.5ⁿ⁻¹. Comparing term by term, b₉ = 1025.2 < a₉ = 1040, and b₁₀ = 1537.7 > a₁₀ = 1120, so the smallest n is 10.' from version_ins;
-- apprecalc-mcq-b7-h-2.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.1-b', 'mcq', 'recover the common ratio of a geometric sequence from two non-adjacent terms (including its sign) and extend the sequenc', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A geometric sequence g has real terms. Its terms are g₂ = 12 and g₅ = −96. What is g₈?', null, md5('apprecalc-mcq-b7-h-2.1-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−768', false, 'This takes the common ratio to be 2 instead of −2. The terms g₂ = 12 and g₅ = −96 have opposite signs over three steps, so r³ = −8 forces a negative ratio, and the sign of g₈ follows from it.' from version_ins
union all select gen_random_uuid(), id, 'B', '−204', false, 'This treats the sequence as arithmetic, with common difference (−96 − 12)/3 = −36. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition.' from version_ins
union all select gen_random_uuid(), id, 'C', '−6144', false, 'This multiplies g₅ by r over 6 steps, but g₈ is only three steps after g₅. The exponent must be the difference of the indices, 8 − 5 = 3, not 8 − 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '768', true, 'Correct: From g₅/g₂ = r³ = −8 we get r = −2. Then g₈ = g₅·r³ = −96·(−8) = 768.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.1-b-v1', 'mcq', 'recover the common ratio of a geometric sequence from two non-adjacent terms (including its sign) and extend the sequenc (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A geometric sequence h has real terms. Its terms are h₁ = 2 and h₄ = −54. What is h₇?', null, md5('apprecalc-mcq-b7-sv-h-2.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1458', false, 'This takes the common ratio to be 3 instead of −3. The terms h₁ = 2 and h₄ = −54 have opposite signs over three steps, so r³ = −27 forces a negative ratio, and the sign of h₇ follows from it.' from version_ins
union all select gen_random_uuid(), id, 'B', '−110', false, 'This treats the sequence as arithmetic, with common difference (−54 − 2)/3 = −56/3. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition.' from version_ins
union all select gen_random_uuid(), id, 'C', '−39366', false, 'This multiplies h₄ by r over 6 steps, but h₇ is only three steps after h₄. The exponent must be the difference of the indices, 7 − 4 = 3, not 7 − 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '1458', true, 'Correct: From h₄/h₁ = r³ = −27 we get r = −3. Then h₇ = h₄·r³ = −54·(−27) = 1458.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.1-b-v2', 'mcq', 'recover the common ratio of a geometric sequence from two non-adjacent terms (including its sign) and extend the sequenc (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A geometric sequence u has real terms. Its terms are u₂ = 48 and u₅ = −6. What is u₈?', null, md5('apprecalc-mcq-b7-sv-h-2.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.75', false, 'This takes the common ratio to be 0.5 instead of −0.5. The terms u₂ = 48 and u₅ = −6 have opposite signs over three steps, so r³ = −0.125 forces a negative ratio, and the sign of u₈ follows from it.' from version_ins
union all select gen_random_uuid(), id, 'B', '−60', false, 'This treats the sequence as arithmetic, with common difference (−6 − 48)/3 = −18. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.75', true, 'Correct: From u₅/u₂ = r³ = −0.125 we get r = −0.5. Then u₈ = u₅·r³ = −6·(−0.125) = 0.75.' from version_ins
union all select gen_random_uuid(), id, 'D', '−0.09375', false, 'This multiplies u₅ by r over 6 steps, but u₈ is only three steps after u₅. The exponent must be the difference of the indices, 8 − 5 = 3, not 8 − 2.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.1-b-v3', 'mcq', 'recover the common ratio of a geometric sequence from two non-adjacent terms (including its sign) and extend the sequenc (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A geometric sequence w has real terms. Its terms are w₃ = −5 and w₆ = 40. What is w₉?', null, md5('apprecalc-mcq-b7-sv-h-2.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '320', false, 'This takes the common ratio to be 2 instead of −2. The terms w₃ = −5 and w₆ = 40 have opposite signs over three steps, so r³ = −8 forces a negative ratio, and the sign of w₉ follows from it.' from version_ins
union all select gen_random_uuid(), id, 'B', '85', false, 'This treats the sequence as arithmetic, with common difference (40 − −5)/3 = 15. The problem states the sequence is geometric, so terms are found by repeated multiplication by r, not repeated addition.' from version_ins
union all select gen_random_uuid(), id, 'C', '−320', true, 'Correct: From w₆/w₃ = r³ = −8 we get r = −2. Then w₉ = w₆·r³ = 40·(−8) = −320.' from version_ins
union all select gen_random_uuid(), id, 'D', '2560', false, 'This multiplies w₆ by r over 6 steps, but w₉ is only three steps after w₆. The exponent must be the difference of the indices, 9 − 6 = 3, not 9 − 3.' from version_ins;
-- apprecalc-mcq-b7-h-2.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.2-a', 'mcq', 'decide where an exponential function lies relative to the line through two of its points, using concavity rather than th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear function L and an exponential function E satisfy L(0) = E(0) = 4 and L(2) = E(2) = 36. Which statement about their values at x = 1 and x = 3 is true?', null, md5('apprecalc-mcq-b7-h-2.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'E(1) < L(1) and E(3) > L(3)', true, 'Correct: E(x) = 4·3ˣ and L(x) = 16x + 4. E(1) = 12 < L(1) = 20, and E(3) = 108 > L(3) = 52.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E(1) > L(1) and E(3) > L(3)', false, 'This assumes an exponential function is larger than a linear one everywhere. Because the two graphs meet at x = 0 and x = 2, the concave-up exponential lies below the line between those points: E(1) = 12 is less than L(1) = 20.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E(1) > L(1) and E(3) < L(3)', false, 'This is the pattern for a concave-down curve. An exponential function is concave up, so it lies below the line through two of its points between them and above the line outside them; here E(3) = 108 exceeds L(3) = 52.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E(1) = L(1) and E(3) > L(3)', false, 'This assumes the two functions agree at the midpoint of their two meeting points. Exponential values are not averaged that way: E(1) = 12 while L(1) = 20, so they differ even though they agree at x = 0 and x = 2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-h-2.1-a','apprecalc-mcq-b7-sv-h-2.1-a-v1','apprecalc-mcq-b7-sv-h-2.1-a-v2','apprecalc-mcq-b7-sv-h-2.1-a-v3','apprecalc-mcq-b7-h-2.1-b','apprecalc-mcq-b7-sv-h-2.1-b-v1','apprecalc-mcq-b7-sv-h-2.1-b-v2','apprecalc-mcq-b7-sv-h-2.1-b-v3','apprecalc-mcq-b7-h-2.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-h-2.1-a','apprecalc-mcq-b7-sv-h-2.1-a-v1','apprecalc-mcq-b7-sv-h-2.1-a-v2','apprecalc-mcq-b7-sv-h-2.1-a-v3','apprecalc-mcq-b7-h-2.1-b','apprecalc-mcq-b7-sv-h-2.1-b-v1','apprecalc-mcq-b7-sv-h-2.1-b-v2','apprecalc-mcq-b7-sv-h-2.1-b-v3','apprecalc-mcq-b7-h-2.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
