begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.15-b-v2','apcalcab-mcq-b7-sv-h-1.15-b-v3','apcalcab-mcq-b7-h-1.16-a','apcalcab-mcq-b7-sv-h-1.16-a-v1','apcalcab-mcq-b7-sv-h-1.16-a-v2','apcalcab-mcq-b7-sv-h-1.16-a-v3','apcalcab-mcq-b7-h-1.16-b','apcalcab-mcq-b7-sv-h-1.16-b-v1','apcalcab-mcq-b7-sv-h-1.16-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-sv-h-1.15-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.15-b-v2', 'mcq', 'find both horizontal asymptotes of a rational expression containing |x| by rewriting |x| as x for x > 0 and −x for x < 0 (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (5x − 2|x|)/(2x + 1). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcab-mcq-b7-sv-h-1.15-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 3/2 only', false, 'This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is 7/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 3/2 and y = 7/2', true, 'Correct: As x → ∞, f(x) = 3x/(2x + 1) → 3/2. As x → −∞, |x| = −x, so f(x) = 7x/(2x + 1) → 7/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 5/2 only', false, 'This ignores the absolute value and treats it as 0, giving 5x/(2x) = 5/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 3/2 and y = −7/2', false, 'This has a sign slip as x → −∞. The numerator becomes 5x + 2x = 7x and the quotient tends to +7/2.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.15-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.15-b-v3', 'mcq', 'find both horizontal asymptotes of a rational expression containing |x| by rewriting |x| as x for x > 0 and −x for x < 0 (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (|x| − 6x)/(3x − 2). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcab-mcq-b7-sv-h-1.15-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −5/3 and y = −7/3', true, 'Correct: As x → ∞, f(x) = −5x/(3x − 2) → −5/3. As x → −∞, |x| = −x, so f(x) = −7x/(3x − 2) → −7/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −5/3 only', false, 'This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is −7/3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −2 only', false, 'This ignores the absolute value, treating it as 0 and giving −6x/(3x) = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −5/3 and y = 7/3', false, 'This has a sign slip as x → −∞. The numerator becomes −x − 6x = −7x, so the limit is −7/3, not +7/3.' from version_ins;
-- apcalcab-mcq-b7-h-1.16-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.16-a', 'mcq', 'use the Intermediate Value Theorem on a table of values of a continuous function to count the zeros guaranteed, includin', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [0, 6]. Selected values are f(0) = 3, f(2) = −1, f(4) = −1, and f(6) = 5. Which of the following is guaranteed by the Intermediate Value Theorem?', null, md5('apcalcab-mcq-b7-h-1.16-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has exactly two zeros in (0, 6)', false, 'The theorem guarantees a minimum number of zeros only. Between the table values f could cross zero additional times.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has at least three zeros in (0, 6)', false, 'This counts [2, 4] as a sign change, but f(2) and f(4) are both −1, so the theorem gives no guarantee there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has at least two zeros in (0, 6)', true, 'Correct: Sign changes occur on [0, 2] (3 to −1) and [4, 6] (−1 to 5), each giving a zero. No guarantee on [2, 4], so at least two zeros.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has exactly one zero in (0, 6)', false, 'This counts only one sign change, but there are two, on [0, 2] and on [4, 6], each of which gives a zero.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.16-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.16-a-v1', 'mcq', 'use the Intermediate Value Theorem on a table of values of a continuous function to count the zeros guaranteed, includin (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor reading R(t) is continuous on [−3, 7]. Selected values are R(−3) = −2, R(−1) = 3, R(1) = −5, R(4) = −5, and R(7) = 1. Which is the strongest statement about the zeros of the function that the Intermediate Value Theorem guarantees?', null, md5('apcalcab-mcq-b7-sv-h-1.16-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R has at least three zeros in (−3, 7)', true, 'Correct: Sign changes occur on [−3, −1], [−1, 1], and [4, 7], and none on [1, 4]. That guarantees at least three zeros.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R has exactly three zeros in (−3, 7)', false, 'The theorem guarantees a minimum only. R could cross zero more often between the listed times.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R has at least four zeros in (−3, 7)', false, 'This counts [1, 4] as a sign change, but R(1) and R(4) are both −5, so no zero is guaranteed there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R has at least two zeros in (−3, 7)', false, 'This misses one of the three sign changes. Sign changes occur on [−3, −1], [−1, 1], and [4, 7].' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.16-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.16-a-v2', 'mcq', 'use the Intermediate Value Theorem on a table of values of a continuous function to count the zeros guaranteed, includin (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [0, 6]. Selected values are f(0) = 3, f(2) = 0, f(4) = −2, and f(6) = 4. Which is the strongest statement about the zeros of the function that the Intermediate Value Theorem guarantees?', null, md5('apcalcab-mcq-b7-sv-h-1.16-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has at least three zeros in [0, 6]', false, 'This treats the changes 3 to 0 and 0 to −2 as separate sign changes in addition to −2 to 4. The zero at x = 2 is already one zero and counts only once.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has exactly two zeros in [0, 6]', false, 'The theorem guarantees a minimum number only; further zeros may exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has at least two zeros in [0, 6]', true, 'Correct: f(2) = 0 is one zero. On [4, 6] the values go from −2 to 4, giving another zero by the theorem. So at least two zeros.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has at least one zero in [0, 6]', false, 'This counts only the sign change on [4, 6] and ignores that f(2) = 0 is itself a zero.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.16-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.16-a-v3', 'mcq', 'use the Intermediate Value Theorem on a table of values of a continuous function to count the zeros guaranteed, includin (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [−2, 8]. Selected values are f(−2) = 2, f(0) = −1, f(3) = 1, f(5) = −2, and f(8) = 3. Which is the strongest statement about the zeros of the function that the Intermediate Value Theorem guarantees?', null, md5('apcalcab-mcq-b7-sv-h-1.16-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has at least three zeros in (−2, 8)', false, 'This misses one of the four sign changes, which occur on [−2, 0], [0, 3], [3, 5], and [5, 8].' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has at least four zeros in (−2, 8)', true, 'Correct: Consecutive values alternate in sign on all four intervals, giving a zero in each, so at least four zeros.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has at least five zeros in (−2, 8)', false, 'There are five table entries but only four consecutive pairs, and each pair gives at most one guaranteed zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f has exactly four zeros in (−2, 8)', false, 'The theorem guarantees a minimum only. More zeros may exist between the listed points.' from version_ins;
-- apcalcab-mcq-b7-h-1.16-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.16-b', 'mcq', 'decide for which interval the Intermediate Value Theorem, applied to the endpoint values of a polynomial, guarantees a z', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ − 3x² + 1, which is continuous for all x. For which of the following intervals do the values of f at the endpoints let the Intermediate Value Theorem guarantee a zero of f in the interval?', null, md5('apcalcab-mcq-b7-h-1.16-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 3]', false, 'Here f(0) = 1 and f(3) = 1 have the same sign, so the theorem gives no guarantee, even though f does have zeros inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', '[1, 2]', false, 'Here f(1) = −1 and f(2) = −3 are both negative, so no sign change is shown.' from version_ins
union all select gen_random_uuid(), id, 'C', '[3, 4]', false, 'Here f(3) = 1 and f(4) = 17 are both positive, so no sign change is shown.' from version_ins
union all select gen_random_uuid(), id, 'D', '[−1, 0]', true, 'Correct: f(−1) = −3 < 0 and f(0) = 1 > 0, so the theorem guarantees a zero in (−1, 0).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.16-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.16-b-v1', 'mcq', 'decide for which interval the Intermediate Value Theorem, applied to the endpoint values of a polynomial, guarantees a z (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = x³ − 7x + 3, which is continuous for all x. For which of the following intervals do the values of g at the endpoints let the Intermediate Value Theorem guarantee a zero of g in the interval?', null, md5('apcalcab-mcq-b7-sv-h-1.16-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−4, 1]', false, 'Here g(−4) = −33 and g(1) = −3 are both negative, so the theorem gives no guarantee, even though g has two zeros inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', '[2, 3]', true, 'Correct: g(2) = 8 − 14 + 3 = −3 < 0 and g(3) = 27 − 21 + 3 = 9 > 0, so there is a zero in (2, 3).' from version_ins
union all select gen_random_uuid(), id, 'C', '[−2, 0]', false, 'Here g(−2) = 9 and g(0) = 3 are both positive, so no sign change is shown.' from version_ins
union all select gen_random_uuid(), id, 'D', '[1, 2]', false, 'Here g(1) = −3 and g(2) = −3 are both negative, so no sign change is shown.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.16-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.16-b-v2', 'mcq', 'decide for which interval the Intermediate Value Theorem, applied to the endpoint values of a polynomial, guarantees a z (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = x³ − 3x + 1, which is continuous for all x. For which of the following intervals do the values of h at the endpoints let the Intermediate Value Theorem guarantee a zero of h in the interval?', null, md5('apcalcab-mcq-b7-sv-h-1.16-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−1, 2]', false, 'Here h(−1) = 3 and h(2) = 3 are both positive, so the theorem gives no guarantee, even though h has two zeros inside the interval.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 1]', true, 'Correct: h(0) = 1 > 0 and h(1) = −1 < 0, so the theorem guarantees a zero in (0, 1).' from version_ins
union all select gen_random_uuid(), id, 'C', '[−1, 0]', false, 'Here h(−1) = 3 and h(0) = 1 are both positive, so no sign change is shown.' from version_ins
union all select gen_random_uuid(), id, 'D', '[2, 3]', false, 'Here h(2) = 3 and h(3) = 19 are both positive, so no sign change is shown.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.15-b-v2','apcalcab-mcq-b7-sv-h-1.15-b-v3','apcalcab-mcq-b7-h-1.16-a','apcalcab-mcq-b7-sv-h-1.16-a-v1','apcalcab-mcq-b7-sv-h-1.16-a-v2','apcalcab-mcq-b7-sv-h-1.16-a-v3','apcalcab-mcq-b7-h-1.16-b','apcalcab-mcq-b7-sv-h-1.16-b-v1','apcalcab-mcq-b7-sv-h-1.16-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-sv-h-1.15-b-v2','apcalcab-mcq-b7-sv-h-1.15-b-v3','apcalcab-mcq-b7-h-1.16-a','apcalcab-mcq-b7-sv-h-1.16-a-v1','apcalcab-mcq-b7-sv-h-1.16-a-v2','apcalcab-mcq-b7-sv-h-1.16-a-v3','apcalcab-mcq-b7-h-1.16-b','apcalcab-mcq-b7-sv-h-1.16-b-v1','apcalcab-mcq-b7-sv-h-1.16-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
