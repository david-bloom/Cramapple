begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-h-1.5-b','apprecalc-mcq-b10-sv-h-1.5-b-v1','apprecalc-mcq-b10-sv-h-1.5-b-v2','apprecalc-mcq-b10-sv-h-1.5-b-v3','apprecalc-mcq-b10-h-1.6-a','apprecalc-mcq-b10-sv-h-1.6-a-v1','apprecalc-mcq-b10-sv-h-1.6-a-v2','apprecalc-mcq-b10-sv-h-1.6-a-v3','apprecalc-mcq-b10-h-1.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apprecalc-mcq-b10-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.5-b', 'mcq', 'use the factor theorem to find an unknown coefficient, then use the sum of the zeros of a monic cubic to get the sum of ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polynomial p(x) = x³ + ax² − 4x + 3 has x − 3 as a factor, where a is a constant. What is the sum of the other two zeros of p?', null, md5('apprecalc-mcq-b10-h-1.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This is the sum of all three zeros, 2, found from the x² coefficient. The question asks for the other two zeros, so the known zero 3 must be subtracted from that sum.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This adds the known zero 3 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5', false, 'This uses a = −2 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1', true, 'Correct: Since x − 3 is a factor, p(3) = 0, which gives a = −2. The zeros of this monic cubic sum to −a = 2, so the other two sum to 2 minus the known zero 3, which is −1.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.5-b-v1', 'mcq', 'use the factor theorem to find an unknown coefficient, then use the sum of the zeros of a monic cubic to get the sum of  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polynomial f(x) = x³ + ax² − x − 6 has x + 2 as a factor, where a is a constant. What is the sum of the two zeros of f other than the zero from that factor?', null, md5('apprecalc-mcq-b10-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3', false, 'This is the sum of all three zeros, −3, found from the x² coefficient. The question asks for the other two zeros, so the known zero −2 must be subtracted from that sum.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', false, 'This adds the known zero −2 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', true, 'Correct: Since x + 2 is a factor, p(-2) = 0, which gives a = 3. The zeros of this monic cubic sum to −a = −3, so the other two sum to −3 minus the known zero −2, which is −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This uses a = 3 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.5-b-v2', 'mcq', 'use the factor theorem to find an unknown coefficient, then use the sum of the zeros of a monic cubic to get the sum of  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a constant a, the cubic g(x) = x³ + ax² + 2x + 8 is divisible by x − 4. What is the sum of the remaining two zeros of g?', null, md5('apprecalc-mcq-b10-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This is the sum of all three zeros, 5, found from the x² coefficient. The question asks for the other two zeros, so the known zero 4 must be subtracted from that sum.' from version_ins
union all select gen_random_uuid(), id, 'B', '9', false, 'This adds the known zero 4 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', true, 'Correct: Since x − 4 is a factor, p(4) = 0, which gives a = −5. The zeros of this monic cubic sum to −a = 5, so the other two sum to 5 minus the known zero 4, which is 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−9', false, 'This uses a = −5 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.5-b-v3', 'mcq', 'use the factor theorem to find an unknown coefficient, then use the sum of the zeros of a monic cubic to get the sum of  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cubic function h is given by h(x) = x³ + ax² − 3x − 6, where a is a constant, and x + 1 divides h(x) with no remainder. What is the sum of the other two zeros of h?', null, md5('apprecalc-mcq-b10-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', false, 'This is the sum of all three zeros, −4, found from the x² coefficient. The question asks for the other two zeros, so the known zero −1 must be subtracted from that sum.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', false, 'This adds the known zero −1 to the sum of all three zeros instead of subtracting it. Removing a zero from the total means subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This uses a = 4 for the sum of the zeros instead of −a. For a monic cubic the three zeros add to the opposite of the x² coefficient.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', true, 'Correct: Since x + 1 is a factor, p(-1) = 0, which gives a = 4. The zeros of this monic cubic sum to −a = −4, so the other two sum to −4 minus the known zero −1, which is −3.' from version_ins;
-- apprecalc-mcq-b10-h-1.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.6-a', 'mcq', 'find the end behavior of a product with a reflected factor by tracking both the degree parity and the sign contributed b', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'f is a polynomial of degree 5 with a negative leading coefficient, and g is a polynomial of degree 3 with a positive leading coefficient. Let h(x) = f(x)·g(−x). Which statement describes the end behavior of h?', null, md5('apprecalc-mcq-b10-h-1.6-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞', false, 'This has the right shape, since the degree 5+3 = 8 is even, but the wrong sign for the leading coefficient. The leading coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^3, which is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞', false, 'This sends the left end to −∞ and the right end to ∞, so the ends point opposite ways. But the degree of h is 5 + 3 = 8, which is even, so its ends point the same way; here the left end should go to ∞, not −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞', true, 'Correct: The leading term of h has degree 5+3 = 8, which is even, and its coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^3, which is negative. So as x → ∞, h → ∞, and as x → −∞, h → ∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞', false, 'This sends the left end to ∞ and the right end to −∞, so the ends point opposite ways. But the degree of h is 5 + 3 = 8, which is even, so its ends point the same way; the right end goes to ∞, not −∞.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.6-a-v1', 'mcq', 'find the end behavior of a product with a reflected factor by tracking both the degree parity and the sign contributed b (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'f is a polynomial of degree 4 with a positive leading coefficient, and g is a polynomial of degree 5 with a negative leading coefficient. Let h(x) = f(−x)·g(x). Which statement describes the end behavior of h?', null, md5('apprecalc-mcq-b10-sv-h-1.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞', false, 'This sends the left end to ∞ and the right end to ∞, so the ends point the same way. But the degree of h is 4 + 5 = 9, which is odd, so its ends point opposite ways; the right end goes to −∞, not ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞', false, 'This sends the left end to −∞ and the right end to −∞, so the ends point the same way. But the degree of h is 4 + 5 = 9, which is odd, so its ends point opposite ways; here the left end should go to ∞, not −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞', false, 'This has the right shape, since the degree 4+5 = 9 is odd, but the wrong sign for the leading coefficient. The leading coefficient is negative because replacing x with −x in f multiplies its leading term by (−1)^4, which is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞', true, 'Correct: The leading term of h has degree 4+5 = 9, which is odd, and its coefficient is negative because replacing x with −x in f multiplies its leading term by (−1)^4, which is positive. So as x → ∞, h → −∞, and as x → −∞, h → ∞.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.6-a-v2', 'mcq', 'find the end behavior of a product with a reflected factor by tracking both the degree parity and the sign contributed b (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'f is a polynomial of degree 2 with a positive leading coefficient, and g is a polynomial of degree 4 with a positive leading coefficient. Let h(x) = −f(x)·g(x). Which statement describes the end behavior of h?', null, md5('apprecalc-mcq-b10-sv-h-1.6-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞', false, 'This has the right shape, since the degree 2+4 = 6 is even, but the wrong sign for the leading coefficient. The leading coefficient is negative because the leading coefficient of f·g is negated by the leading minus sign.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞', false, 'This sends the left end to −∞ and the right end to ∞, so the ends point opposite ways. But the degree of h is 2 + 4 = 6, which is even, so its ends point the same way; the right end goes to −∞, not ∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞', false, 'This sends the left end to ∞ and the right end to −∞, so the ends point opposite ways. But the degree of h is 2 + 4 = 6, which is even, so its ends point the same way; here the left end should go to −∞, not ∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞', true, 'Correct: The leading term of h has degree 2+4 = 6, which is even, and its coefficient is negative because the leading coefficient of f·g is negated by the leading minus sign. So as x → ∞, h → −∞, and as x → −∞, h → −∞.' from version_ins;
-- apprecalc-mcq-b10-sv-h-1.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-sv-h-1.6-a-v3', 'mcq', 'find the end behavior of a product with a reflected factor by tracking both the degree parity and the sign contributed b (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'f is a polynomial of degree 3 with a negative leading coefficient, and g is a polynomial of degree 2 with a negative leading coefficient. Let h(x) = f(x)·g(−x). Which statement describes the end behavior of h?', null, md5('apprecalc-mcq-b10-sv-h-1.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'h(x) → ∞ as x → ∞ and h(x) → ∞ as x → −∞', false, 'This sends the left end to ∞ and the right end to ∞, so the ends point the same way. But the degree of h is 3 + 2 = 5, which is odd, so its ends point opposite ways; here the left end should go to −∞, not ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'h(x) → ∞ as x → ∞ and h(x) → −∞ as x → −∞', true, 'Correct: The leading term of h has degree 3+2 = 5, which is odd, and its coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^2, which is positive. So as x → ∞, h → ∞, and as x → −∞, h → −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'h(x) → −∞ as x → ∞ and h(x) → −∞ as x → −∞', false, 'This sends the left end to −∞ and the right end to −∞, so the ends point the same way. But the degree of h is 3 + 2 = 5, which is odd, so its ends point opposite ways; the right end goes to ∞, not −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'h(x) → −∞ as x → ∞ and h(x) → ∞ as x → −∞', false, 'This has the right shape, since the degree 3+2 = 5 is odd, but the wrong sign for the leading coefficient. The leading coefficient is positive because replacing x with −x in g multiplies its leading term by (−1)^2, which is positive.' from version_ins;
-- apprecalc-mcq-b10-h-1.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b10-h-1.6-b', 'mcq', 'build a sign chart from end behavior and zero multiplicities, changing sign only at odd-multiplicity zeros.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The polynomial p has the form p(x) = a(x + 3)(x − 1)²(x − 4)², where a is a nonzero constant. The zeros of p are −3 with multiplicity 1, 1 with multiplicity 2, and 4 with multiplicity 2, and p(x) → −∞ as x → ∞. For which values of x is p(x) > 0?', null, md5('apprecalc-mcq-b10-h-1.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3, 1) ∪ (1, 4) ∪ (4, ∞)', false, 'This takes the sign to be negative on the far right, reversing the end behavior. Because p(x) → −∞ as x → ∞, a is negative, and the intervals found here are where p is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−∞, −3) ∪ (1, 4)', false, 'This changes sign at every zero. A zero of even multiplicity only touches the x-axis, so p does not change sign there; only the zeros of odd multiplicity are sign changes.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−∞, −3)', true, 'Correct: Since a polynomial''s ends follow the leading term, the sign on the far right is negative. Moving left, the sign changes only at zeros of odd multiplicity. This gives p(x) > 0 on (−∞, −3).' from version_ins
union all select gen_random_uuid(), id, 'D', '(−3, 1) ∪ (4, ∞)', false, 'This makes two errors. It reverses the sign on the far right and also changes sign at every zero, so it lists the intervals where p would be negative if every zero were a crossing.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b10-h-1.5-b','apprecalc-mcq-b10-sv-h-1.5-b-v1','apprecalc-mcq-b10-sv-h-1.5-b-v2','apprecalc-mcq-b10-sv-h-1.5-b-v3','apprecalc-mcq-b10-h-1.6-a','apprecalc-mcq-b10-sv-h-1.6-a-v1','apprecalc-mcq-b10-sv-h-1.6-a-v2','apprecalc-mcq-b10-sv-h-1.6-a-v3','apprecalc-mcq-b10-h-1.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b10-h-1.5-b','apprecalc-mcq-b10-sv-h-1.5-b-v1','apprecalc-mcq-b10-sv-h-1.5-b-v2','apprecalc-mcq-b10-sv-h-1.5-b-v3','apprecalc-mcq-b10-h-1.6-a','apprecalc-mcq-b10-sv-h-1.6-a-v1','apprecalc-mcq-b10-sv-h-1.6-a-v2','apprecalc-mcq-b10-sv-h-1.6-a-v3','apprecalc-mcq-b10-h-1.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
