begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.15-b-v2','apcalcbc-mcq-b7-sv-h-1.15-b-v3','apcalcbc-mcq-b7-h-1.16-a','apcalcbc-mcq-b7-sv-h-1.16-a-v1','apcalcbc-mcq-b7-sv-h-1.16-a-v2','apcalcbc-mcq-b7-sv-h-1.16-a-v3','apcalcbc-mcq-b7-h-1.16-b','apcalcbc-mcq-b7-sv-h-1.16-b-v1','apcalcbc-mcq-b7-sv-h-1.16-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-sv-h-1.15-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.15-b-v2', 'mcq', 'find horizontal asymptotes at both ends of an exponential rational function, recognizing which exponential dominates as  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (5 + 2e^(−x))/(1 + e^(−x)). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcbc-mcq-b7-sv-h-1.15-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 5 only', false, 'This finds only the right-end limit; as x → −∞, e^(−x) is huge, so the constants 5 and 1 become negligible and the ratio tends to 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 2 and y = 5', true, 'Correct: As x → ∞, e^(−x) → 0 and f → 5/1 = 5. As x → −∞, e^(−x) → ∞ and f → 2e^(−x)/e^(−x) = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 2 only', false, 'This finds only the left-end limit; as x → ∞ the exponential terms vanish and the ratio tends to 5/1 = 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 0 and y = 5', false, 'This reads the left end as 0, but both numerator and denominator grow like e^(−x) there, so their ratio approaches 2, not 0.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.15-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.15-b-v3', 'mcq', 'find horizontal asymptotes at both ends of an exponential rational function, recognizing which exponential dominates as  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (2x + 1)eˣ/(eˣ + 1). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcbc-mcq-b7-sv-h-1.15-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0 only', true, 'Correct: As x → −∞, eˣ → 0 so the numerator (2x + 1)eˣ → 0 (exponential decay beats the linear factor) and the denominator → 1, so f → 0. As x → ∞, eˣ/(eˣ + 1) → 1, so f(x) ≈ 2x + 1 → ∞, so no horizontal asymptote on the right.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 0 and y = 2', false, 'At the right end, f behaves like 2x + 1, which grows without bound; the coefficient 2 is not a limit value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 2 only', false, 'This reads the coefficient 2 as a limit at the right end, but f(x) ≈ 2x + 1 diverges there, and at the left end f tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There are no horizontal asymptotes, because f is unbounded.', false, 'Being unbounded on the right does not rule out an asymptote on the left; as x → −∞, f tends to 0, so y = 0 is a horizontal asymptote.' from version_ins;
-- apcalcbc-mcq-b7-h-1.16-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.16-a', 'mcq', 'count the zeros that the Intermediate Value Theorem guarantees from a table by checking each subinterval for a sign chan', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [0, 8]. Selected values are f(0) = 5, f(2) = −2, f(4) = −6, f(6) = −1, and f(8) = 3. What is the greatest number of zeros of f in the interval (0, 8) that the Intermediate Value Theorem guarantees?', null, md5('apcalcbc-mcq-b7-h-1.16-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This compares only f(0) = 5 and f(8) = 3, which have the same sign, but the intermediate values dip below 0 and give sign changes on two subintervals.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This finds the sign change on [0, 2] but misses the one on [6, 8], where f goes from −1 to 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: Sign changes occur on [0, 2] (5 to −2) and [6, 8] (−1 to 3). The values on [2, 4] and [4, 6] are all negative, so no zero is guaranteed there. So at least 2 zeros are guaranteed.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This counts every subinterval, but on [2, 4] and [4, 6] both endpoint values are negative, so the theorem guarantees nothing there.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.16-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.16-a-v1', 'mcq', 'count the zeros that the Intermediate Value Theorem guarantees from a table by checking each subinterval for a sign chan (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [0, 4]. Selected values are f(0) = 0, f(1) = 3, f(2) = −2, f(3) = 4, and f(4) = 1. What is the least number of distinct solutions of f(x) = 1 in [0, 4] that the Intermediate Value Theorem guarantees?', null, md5('apcalcbc-mcq-b7-sv-h-1.16-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', true, 'Correct: The value 1 lies strictly between the endpoint values on (0, 1) (0 to 3), (1, 2) (3 to −2), and (2, 3) (−2 to 4), giving three distinct solutions in the open intervals, and f(4) = 1 is a fourth. On [3, 4] the value 1 is attained only at the endpoint x = 4, which was already counted.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This counts the three open subintervals but forgets that f(4) = 1 is itself a solution.' from version_ins
union all select gen_random_uuid(), id, 'C', '5', false, 'This counts a fifth solution on (3, 4), but the values 4 and 1 on [3, 4] give the level 1 only at the endpoint x = 4, which is already counted.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'This counts only the crossings on (1, 2) and (2, 3) and overlooks both the rise from 0 to 3 on (0, 1), which passes through 1, and the value f(4) = 1.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.16-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.16-a-v2', 'mcq', 'count the zeros that the Intermediate Value Theorem guarantees from a table by checking each subinterval for a sign chan (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [1, 7] with f(1) = 2, f(2) = −3, f(5) = −1, and f(7) = 6. Which statement must be true?', null, md5('apcalcbc-mcq-b7-sv-h-1.16-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f has at least one zero in the interval (2, 5).', false, 'The values f(2) = −3 and f(5) = −1 are both negative, so the theorem does not guarantee a zero between them; f could stay negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f has exactly two zeros in the interval [1, 7].', false, 'The theorem only guarantees at least two zeros; additional zeros could occur, for instance if f crosses 0 and returns in the middle.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f has at least one zero in (1, 2) and at least one zero in (5, 7).', true, 'Correct: Sign change on [1, 2] (2 to −3) and on [5, 7] (−1 to 6) give zeros in (1, 2) and (5, 7). On [2, 5] both values are negative, so no zero is guaranteed there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(c) = 7 for some c in [1, 7].', false, 'The given values only reach 6, and 7 is not guaranteed to be between any two known values.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.16-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.16-a-v3', 'mcq', 'count the zeros that the Intermediate Value Theorem guarantees from a table by checking each subinterval for a sign chan (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is continuous on [0, 3] with f(0) = 2, f(1) = 0, f(2) = 5, and f(3) = 1. What is the least number of solutions of f(x) = x in the interval (0, 3) that the Intermediate Value Theorem guarantees?', null, md5('apcalcbc-mcq-b7-sv-h-1.16-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This compares f with x only at the endpoints, f(0) = 2 above x = 0 and f(3) = 1 below x = 3, and finds one crossing, ignoring the interior points.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Correct: Let g(x) = f(x) − x, continuous. g(0) = 2, g(1) = −1, g(2) = 3, g(3) = −2. Sign changes occur on (0, 1), (1, 2), and (2, 3), so at least 3 solutions of g(x) = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This finds the crossings on (0, 1) and (1, 2) but misses the one on (2, 3), where g goes from 3 to −2.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This counts four solutions, one per given point, but the theorem guarantees solutions on subintervals with a sign change, and there are only three such intervals.' from version_ins;
-- apcalcbc-mcq-b7-h-1.16-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.16-b', 'mcq', 'choose the interval on which the Intermediate Value Theorem actually applies to an equation, checking both continuity an', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of eˣ + x² = 4?', null, md5('apcalcbc-mcq-b7-h-1.16-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−1, 1]', false, 'Here h(−1) ≈ −2.63 and h(1) ≈ −0.28 are both negative, so no sign change is shown and the theorem guarantees nothing.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 1]', false, 'Here h(0) = −3 and h(1) ≈ −0.28 are both negative, so the theorem gives no solution.' from version_ins
union all select gen_random_uuid(), id, 'C', '[2, 3]', false, 'Here h(2) ≈ 7.39 and h(3) ≈ 25.1 are both positive, so there is no sign change.' from version_ins
union all select gen_random_uuid(), id, 'D', '[1, 2]', true, 'Correct: Let h(x) = eˣ + x² − 4, continuous everywhere. h(−1) ≈ −2.63, h(0) = −3, h(1) ≈ −0.28, h(2) = e² ≈ 7.39, h(3) ≈ 25.1. Only [1, 2] has h(1) < 0 < h(2).' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.16-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.16-b-v1', 'mcq', 'choose the interval on which the Intermediate Value Theorem actually applies to an equation, checking both continuity an (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of ln x + x² = 3?', null, md5('apcalcbc-mcq-b7-sv-h-1.16-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 2]', false, 'The function ln x is not defined at x = 0, so h is not continuous on [0, 2] and the theorem cannot be applied there.' from version_ins
union all select gen_random_uuid(), id, 'B', '[1, 2]', true, 'Correct: Let h(x) = ln x + x² − 3, continuous for x > 0. h(1) = −2, h(2) = ln 2 + 1 ≈ 1.69. On [2, 3], h(2) > 0 and h(3) > 0. On [1/2, 1], h(1/2) ≈ −3.44 and h(1) = −2 are both negative. h is not defined at 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '[2, 3]', false, 'Here h(2) ≈ 1.69 and h(3) ≈ 7.1 are both positive, so there is no sign change.' from version_ins
union all select gen_random_uuid(), id, 'D', '[1/2, 1]', false, 'Here h(1/2) ≈ −3.44 and h(1) = −2 are both negative, so the theorem guarantees nothing.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.16-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.16-b-v2', 'mcq', 'choose the interval on which the Intermediate Value Theorem actually applies to an equation, checking both continuity an (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following intervals can be used with the Intermediate Value Theorem to guarantee a solution of tan x = −1?', null, md5('apcalcbc-mcq-b7-sv-h-1.16-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[1, 2]', false, 'The endpoint values have opposite signs, but tan x is not continuous on [1, 2] because it has a vertical asymptote at π/2 ≈ 1.57, so the theorem does not apply.' from version_ins
union all select gen_random_uuid(), id, 'B', '[2, 3]', true, 'Correct: Let g(x) = tan x + 1. g(2) ≈ −1.19, g(3) ≈ 0.86, and g is continuous on [2, 3] since π/2 ≈ 1.57 and 3π/2 ≈ 4.71 lie outside it. On [1, 2], g(1) ≈ 2.56 and g(2) ≈ −1.19 differ in sign but π/2 is inside the interval. On [0, 1], g(0) = 1 and g(1) ≈ 2.56 are positive. On [3, 4], g(3) ≈ 0.86 and g(4) ≈ 2.16 are positive.' from version_ins
union all select gen_random_uuid(), id, 'C', '[0, 1]', false, 'Here g(0) = 1 and g(1) ≈ 2.56 are both positive, so no sign change.' from version_ins
union all select gen_random_uuid(), id, 'D', '[3, 4]', false, 'Here g(3) ≈ 0.86 and g(4) ≈ 2.16 are both positive, so no sign change.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.15-b-v2','apcalcbc-mcq-b7-sv-h-1.15-b-v3','apcalcbc-mcq-b7-h-1.16-a','apcalcbc-mcq-b7-sv-h-1.16-a-v1','apcalcbc-mcq-b7-sv-h-1.16-a-v2','apcalcbc-mcq-b7-sv-h-1.16-a-v3','apcalcbc-mcq-b7-h-1.16-b','apcalcbc-mcq-b7-sv-h-1.16-b-v1','apcalcbc-mcq-b7-sv-h-1.16-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-sv-h-1.15-b-v2','apcalcbc-mcq-b7-sv-h-1.15-b-v3','apcalcbc-mcq-b7-h-1.16-a','apcalcbc-mcq-b7-sv-h-1.16-a-v1','apcalcbc-mcq-b7-sv-h-1.16-a-v2','apcalcbc-mcq-b7-sv-h-1.16-a-v3','apcalcbc-mcq-b7-h-1.16-b','apcalcbc-mcq-b7-sv-h-1.16-b-v1','apcalcbc-mcq-b7-sv-h-1.16-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
