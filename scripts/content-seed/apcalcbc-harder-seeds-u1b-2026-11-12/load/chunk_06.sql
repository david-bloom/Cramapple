begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.14-b-v1','apcalcbc-mcq-b7-sv-h-1.14-b-v2','apcalcbc-mcq-b7-sv-h-1.14-b-v3','apcalcbc-mcq-b7-h-1.15-a','apcalcbc-mcq-b7-sv-h-1.15-a-v1','apcalcbc-mcq-b7-sv-h-1.15-a-v2','apcalcbc-mcq-b7-sv-h-1.15-a-v3','apcalcbc-mcq-b7-h-1.15-b','apcalcbc-mcq-b7-sv-h-1.15-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-sv-h-1.14-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.14-b-v1', 'mcq', 'evaluate a difference of two unbounded terms by combining them first, deciding which term dominates instead of treating  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→1+) [1/(x − 1) − 1/(x² − 1)]?', null, md5('apcalcbc-mcq-b7-sv-h-1.14-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This treats ∞ − ∞ as 0, but the two terms combine to x/(x² − 1), which is unbounded.' from version_ins
union all select gen_random_uuid(), id, 'B', '−∞', false, 'The denominator x² − 1 is positive for x slightly greater than 1, so the combined fraction is positive, not negative.' from version_ins
union all select gen_random_uuid(), id, 'C', '+∞', true, 'Correct: 1/(x − 1) − 1/((x − 1)(x + 1)) = ((x + 1) − 1)/((x − 1)(x + 1)) = x/(x² − 1). As x → 1+, the numerator → 1 and the denominator → 0⁺, so the limit is +∞.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This cancels the factor x − 1 from the denominator without a matching numerator factor, evaluating x/(x + 1) at 1, which is not justified.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.14-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.14-b-v2', 'mcq', 'evaluate a difference of two unbounded terms by combining them first, deciding which term dominates instead of treating  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→2) [4/(x² − 4) − 1/(x − 2)]?', null, md5('apcalcbc-mcq-b7-sv-h-1.14-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This treats ∞ − ∞ as 0, but after combining the fractions the common factor x − 2 cancels and leaves −1/(x + 2).' from version_ins
union all select gen_random_uuid(), id, 'B', '−∞', false, 'Each term is unbounded, but the unbounded parts cancel after combining; the limit is finite.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1/4', true, 'Correct: 4/((x − 2)(x + 2)) − 1/(x − 2) = (4 − (x + 2))/((x − 2)(x + 2)) = (2 − x)/((x − 2)(x + 2)) = −1/(x + 2) → −1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4', false, 'This gets the magnitude right but loses the sign: the numerator is 4 − (x + 2) = 2 − x, which is the opposite of x − 2, so the result is −1/(x + 2).' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.14-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.14-b-v3', 'mcq', 'evaluate a difference of two unbounded terms by combining them first, deciding which term dominates instead of treating  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0+) [2/x − 1/x²]?', null, md5('apcalcbc-mcq-b7-sv-h-1.14-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+∞', false, 'This follows the 2/x term, but 1/x² is larger than 2/x for small x and is subtracted, so the difference is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This treats ∞ − ∞ as 0, but the terms do not cancel; the 1/x² term dominates.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'This keeps only the numerator 2x − 1 → −1 and drops the denominator x², which approaches 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '−∞', true, 'Correct: Combine: (2x − 1)/x². As x → 0+, the numerator → −1 and the denominator → 0⁺, so the quotient → −∞.' from version_ins;
-- apcalcbc-mcq-b7-h-1.15-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.15-a', 'mcq', 'evaluate an ∞ − ∞ limit of a radical difference by multiplying by the conjugate, then divide through by the dominant pow', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) [√(x² + 6x) − x]?', null, md5('apcalcbc-mcq-b7-h-1.15-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This reasons that √(x² + 6x) is about x for large x so the difference is 0, but the leftover 6x inside the root shifts the value by a constant amount.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This divides 6x by x only, forgetting that the denominator √(x² + 6x) + x is about 2x, not x.' from version_ins
union all select gen_random_uuid(), id, 'C', '∞', false, 'This treats ∞ − ∞ as ∞, but the two terms are nearly equal and their difference settles at a finite value.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'Correct: Multiply by the conjugate: (x² + 6x − x²)/(√(x² + 6x) + x) = 6x/(√(x² + 6x) + x) → 6/(1 + 1) = 3. Numerically at x = 10⁶ the value is about 3.0000.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.15-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.15-a-v1', 'mcq', 'evaluate an ∞ − ∞ limit of a radical difference by multiplying by the conjugate, then divide through by the dominant pow (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) [√(4x² + 20x) − 2x]?', null, md5('apcalcbc-mcq-b7-sv-h-1.15-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10', false, 'This divides 20x by 2x only and forgets that the denominator includes both radical and 2x, each about 2x, so the denominator is about 4x.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', true, 'Correct: (4x² + 20x − 4x²)/(√(4x² + 20x) + 2x) = 20x/(√(4x² + 20x) + 2x) → 20/(2 + 2) = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This treats the radical as about 2x so the difference as 0, ignoring the 20x term that remains after multiplying by the conjugate.' from version_ins
union all select gen_random_uuid(), id, 'D', '∞', false, 'This treats ∞ − ∞ as ∞, but the two terms differ by a bounded amount.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.15-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.15-a-v2', 'mcq', 'evaluate an ∞ − ∞ limit of a radical difference by multiplying by the conjugate, then divide through by the dominant pow (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) [x − √(x² − 8x)]?', null, md5('apcalcbc-mcq-b7-sv-h-1.15-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', false, 'This has the wrong sign; x is larger than √(x² − 8x), so the difference x − √(x² − 8x) is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'This divides 8x by x only, forgetting that the denominator x + √(x² − 8x) is about 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', true, 'Correct: (x² − (x² − 8x))/(x + √(x² − 8x)) = 8x/(x + √(x² − 8x)) → 8/(1 + 1) = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This treats the two terms as equal for large x, ignoring the −8x inside the root.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.15-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.15-a-v3', 'mcq', 'evaluate an ∞ − ∞ limit of a radical difference by multiplying by the conjugate, then divide through by the dominant pow (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) [√(9x² + x) − 3x]?', null, md5('apcalcbc-mcq-b7-sv-h-1.15-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/6', true, 'Correct: (9x² + x − 9x²)/(√(9x² + x) + 3x) = x/(√(9x² + x) + 3x) → 1/(3 + 3) = 1/6.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This reasons that √(9x² + x) is about 3x so the difference is 0, but the leftover x term gives a nonzero constant.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3', false, 'This divides x by 3x only and forgets that the denominator contains the radical, which is also about 3x.' from version_ins
union all select gen_random_uuid(), id, 'D', '∞', false, 'This treats ∞ − ∞ as ∞, but the difference of the two terms stays bounded.' from version_ins;
-- apcalcbc-mcq-b7-h-1.15-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.15-b', 'mcq', 'find horizontal asymptotes at both ends of an exponential rational function, recognizing which exponential dominates as ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (4eˣ − 1)/(eˣ + 2e^(−x)). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcbc-mcq-b7-h-1.15-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0 and y = 4', true, 'Correct: As x → ∞, e^(−x) → 0, so f → 4eˣ/eˣ = 4. As x → −∞, eˣ → 0 and e^(−x) → ∞, so the numerator → −1 and the denominator → ∞, giving f → 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 4 only', false, 'This finds the limit at +∞ but compares the same leading coefficients at −∞ as well; as x → −∞ the denominator grows without bound while the numerator tends to −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 4 and y = −1/2', false, 'This divides −1 by 2 at the left end, ignoring that the denominator is dominated by 2e^(−x), which tends to infinity, so the ratio goes to 0, not −1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 0 only', false, 'This finds the left-end limit but misses the right end, where eˣ dominates both numerator and denominator and the ratio tends to 4.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.15-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.15-b-v1', 'mcq', 'find horizontal asymptotes at both ends of an exponential rational function, recognizing which exponential dominates as  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (6e^(2x) + eˣ)/(2e^(2x) + 3). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcbc-mcq-b7-sv-h-1.15-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 3 only', false, 'This finds only the right-end limit; at the left end the numerator tends to 0 while the denominator tends to 3, so y = 0 is also an asymptote.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 1/3 and y = 3', false, 'This reads the left-end value as 1/3 by using the coefficient of eˣ over 3, but eˣ → 0 as x → −∞, so the numerator tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 0 and y = 3', true, 'Correct: As x → ∞, divide by e^(2x): (6 + e^(−x))/(2 + 3e^(−2x)) → 6/2 = 3. As x → −∞, e^(2x) → 0 and eˣ → 0, so f → 0/3 = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 0 only', false, 'This finds only the left-end limit; at the right end the e^(2x) terms dominate and the ratio tends to 6/2 = 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.14-b-v1','apcalcbc-mcq-b7-sv-h-1.14-b-v2','apcalcbc-mcq-b7-sv-h-1.14-b-v3','apcalcbc-mcq-b7-h-1.15-a','apcalcbc-mcq-b7-sv-h-1.15-a-v1','apcalcbc-mcq-b7-sv-h-1.15-a-v2','apcalcbc-mcq-b7-sv-h-1.15-a-v3','apcalcbc-mcq-b7-h-1.15-b','apcalcbc-mcq-b7-sv-h-1.15-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-sv-h-1.14-b-v1','apcalcbc-mcq-b7-sv-h-1.14-b-v2','apcalcbc-mcq-b7-sv-h-1.14-b-v3','apcalcbc-mcq-b7-h-1.15-a','apcalcbc-mcq-b7-sv-h-1.15-a-v1','apcalcbc-mcq-b7-sv-h-1.15-a-v2','apcalcbc-mcq-b7-sv-h-1.15-a-v3','apcalcbc-mcq-b7-h-1.15-b','apcalcbc-mcq-b7-sv-h-1.15-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
