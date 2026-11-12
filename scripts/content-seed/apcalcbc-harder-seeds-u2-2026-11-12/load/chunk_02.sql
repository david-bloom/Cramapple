begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.2-a-v1','apcalcbc-mcq-b5-sv-h-2.2-a-v2','apcalcbc-mcq-b5-sv-h-2.2-a-v3','apcalcbc-mcq-b5-h-2.2-b','apcalcbc-mcq-b5-sv-h-2.2-b-v1','apcalcbc-mcq-b5-sv-h-2.2-b-v2','apcalcbc-mcq-b5-sv-h-2.2-b-v3','apcalcbc-mcq-b5-h-2.3-a','apcalcbc-mcq-b5-sv-h-2.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-sv-h-2.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.2-a-v1', 'mcq', 'evaluate a scaled or offset difference quotient as a multiple of f′(a), tracking the coefficients of h in both terms. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(2) = −4. What is lim as h→0 of [f(2 + 3h) − f(2 − h)]/h?', null, md5('apcalcbc-mcq-b5-sv-h-2.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12', false, 'This counts only the 3h shift on the upper side and treats f(2 − h) as f(2), so it gives 3·(−4) and misses the extra h below 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−8', false, 'Subtracting the coefficients 3 − 1 = 2 treats the lower point as if it lay above 2; the actual gap between the inputs is 3h − (−h) = 4h.' from version_ins
union all select gen_random_uuid(), id, 'C', '−16', true, 'Correct: The inputs differ by 3h − (−h) = 4h, so the limit is 4f′(2) = 4·(−4) = −16.' from version_ins
union all select gen_random_uuid(), id, 'D', '16', false, 'The magnitude 4·4 comes from the gap 4h, but the derivative f′(2) = −4 is negative, so the limit must be negative.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.2-a-v2', 'mcq', 'evaluate a scaled or offset difference quotient as a multiple of f′(a), tracking the coefficients of h in both terms. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(1) = 6. What is lim as h→0 of [f(1 + h) − f(1 − 2h)]/(3h)?', null, md5('apcalcbc-mcq-b5-sv-h-2.2-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18', false, 'This finds that the numerator behaves like 3h·f′(1) = 18h but forgets to divide by the 3 in the denominator 3h.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', true, 'Correct: f(1 + h) − f(1 − 2h) ≈ 3h f′(1), so dividing by 3h leaves f′(1) = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'Dividing f′(1) = 6 by 3 treats the 3h in the denominator as if it were not already matched by the 3h gap in the numerator.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'This counts only the 2h shift of the lower term and divides by 3, giving 2·6/3, and it ignores the h shift of the first term.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.2-a-v3', 'mcq', 'evaluate a scaled or offset difference quotient as a multiple of f′(a), tracking the coefficients of h in both terms. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(5) = −2. What is lim as h→0 of [f(5 − h) − f(5 + 2h)]/h?', null, md5('apcalcbc-mcq-b5-sv-h-2.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', false, 'Reversing the order of the terms, this computes the limit of [f(5 + 2h) − f(5 − h)]/h, which is 3f′(5), but the given numerator is f(5 − h) − f(5 + 2h), the opposite.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', false, 'This reports f′(5) alone, taking the combination as a single derivative and ignoring that the inputs are 3h apart and in decreasing order.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This keeps only the −h shift, (−1)(−2), and ignores the 2h shift in the second term, which adds another factor from the same direction.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', true, 'Correct: The first input is 3h below the second, so the numerator ≈ −3h f′(5) and the limit is −3·(−2) = 6.' from version_ins;
-- apcalcbc-mcq-b5-h-2.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.2-b', 'mcq', 'recognize a limit of the form (g(x) − g(a))/(x² − a²) as a derivative divided by (x + a), evaluating the extra factor.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the value of lim as x→e of (ln x − 1)/(x² − e²)?', null, md5('apcalcbc-mcq-b5-h-2.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/e', false, 'This is the derivative of ln x at x = e alone; the denominator x² − e² = (x − e)(x + e) contributes an extra factor x + e that tends to 2e.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/(2e²)', true, 'Correct: (ln x − 1)/(x − e) → (ln)′(e) = 1/e and 1/(x + e) → 1/(2e), so the limit is 1/(2e²).' from version_ins
union all select gen_random_uuid(), id, 'C', '1/(2e)', false, 'The factor x + e tends to 2e, not to 2, so dividing 1/e by 2 leaves out the e in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/e²', false, 'This replaces the factor x + e by e instead of 2e, so the second factor is only half of what it should be.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.2-b-v1', 'mcq', 'recognize a limit of the form (g(x) − g(a))/(x² − a²) as a derivative divided by (x + a), evaluating the extra factor. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the value of lim as x→1 of (eˣ − e)/(x² − 1)?', null, md5('apcalcbc-mcq-b5-sv-h-2.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e', false, 'This is the derivative of eˣ at x = 1 alone; the factor 1/(x + 1) in the denominator still has to be applied and tends to 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2e', false, 'This multiplies by x + 1 = 2 instead of dividing by it, since x² − 1 = (x − 1)(x + 1) sits in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e/2', true, 'Correct: (eˣ − e)/(x − 1) → e and 1/(x + 1) → 1/2, so the limit is e/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This takes the derivative of eˣ at 1 to be 1, which is the derivative at 0, and then divides by 2 as required.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.2-b-v2', 'mcq', 'recognize a limit of the form (g(x) − g(a))/(x² − a²) as a derivative divided by (x + a), evaluating the extra factor. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the value of lim as x→π/6 of (sin x − 1/2)/(x² − π²/36)?', null, md5('apcalcbc-mcq-b5-sv-h-2.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3/2', false, 'This is cos(π/6), the derivative of sin x at π/6 alone; it ignores the factor 1/(x + π/6), which tends to 3/π.' from version_ins
union all select gen_random_uuid(), id, 'B', '3√3/(2π)', true, 'Correct: (sin x − 1/2)/(x − π/6) → cos(π/6) = √3/2 and 1/(x + π/6) → 3/π, so the limit is 3√3/(2π).' from version_ins
union all select gen_random_uuid(), id, 'C', '3/(2π)', false, 'This uses sin(π/6) = 1/2 in place of the derivative cos(π/6) = √3/2, then correctly divides by x + π/6 = π/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '√3π/6', false, 'This multiplies cos(π/6) by x + π/6 = π/3 instead of dividing by it, so the factor from the denominator is inverted.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.2-b-v3', 'mcq', 'recognize a limit of the form (g(x) − g(a))/(x² − a²) as a derivative divided by (x + a), evaluating the extra factor. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the value of lim as x→4 of (√x − 2)/(x² − 16)?', null, md5('apcalcbc-mcq-b5-sv-h-2.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4', false, 'This is the derivative of √x at x = 4 alone; the denominator x² − 16 = (x − 4)(x + 4) also supplies a factor 1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/16', false, 'This divides 1/4 by 4, using 4 for the factor x + 4 instead of 4 + 4 = 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/32', true, 'Correct: (√x − 2)/(x − 4) → 1/(2√4) = 1/4 and 1/(x + 4) → 1/8, so the limit is 1/32.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'This multiplies 1/4 by x + 4 = 8 instead of dividing by it, so the factor from the denominator is inverted.' from version_ins;
-- apcalcbc-mcq-b5-h-2.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.3-a', 'mcq', 'use monotonic f′ to place f′ at a point strictly between the adjacent secant slopes, rather than treating the centered e', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has a strictly increasing derivative on [3, 5]. The values f(3) = 10, f(4) = 12.5, and f(5) = 17 are known. Which statement about f′(4) must be true?', null, md5('apcalcbc-mcq-b5-h-2.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f′(4) = 3.5 exactly.', false, 'The centered estimate (17 − 10)/2 = 3.5 is only an approximation; it equals f′(4) only for special functions such as quadratics.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f′(4) is strictly between 2.5 and 4.5.', true, 'Correct: Average slopes are (12.5 − 10)/1 = 2.5 on [3, 4] and (17 − 12.5)/1 = 4.5 on [4, 5]; with f′ increasing, 2.5 < f′(4) < 4.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f′(4) > 4.5.', false, 'Increasing f′ makes f′(4) smaller than the average slope on [4, 5], which is 4.5, because f′ keeps growing past x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f′(4) < 2.5.', false, 'Increasing f′ makes f′(4) larger than the average slope on [3, 4], which is 2.5, because f′ was smaller before x = 4.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.3-a-v1', 'mcq', 'use monotonic f′ to place f′ at a point strictly between the adjacent secant slopes, rather than treating the centered e (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is differentiable and concave down on [1, 3]. The values f(1) = 7, f(2) = 12, and f(3) = 15 are known. Which statement about f′(2) must be true?', null, md5('apcalcbc-mcq-b5-sv-h-2.3-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f′(2) = 4 exactly.', false, 'The centered estimate (15 − 7)/2 = 4 is only an approximation; concave down does not make the central slope exact.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f′(2) is strictly between 3 and 5.', true, 'Correct: Average slopes are 12 − 7 = 5 on [1, 2] and 15 − 12 = 3 on [2, 3]; with f′ decreasing, 3 < f′(2) < 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f′(2) > 5.', false, 'With f′ decreasing, f′(2) is smaller than the average slope on [1, 2], which is 5, so it cannot exceed 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f′(2) < 3.', false, 'With f′ decreasing, f′(2) is larger than the average slope on [2, 3], which is 3, so it cannot be smaller than 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-sv-h-2.2-a-v1','apcalcbc-mcq-b5-sv-h-2.2-a-v2','apcalcbc-mcq-b5-sv-h-2.2-a-v3','apcalcbc-mcq-b5-h-2.2-b','apcalcbc-mcq-b5-sv-h-2.2-b-v1','apcalcbc-mcq-b5-sv-h-2.2-b-v2','apcalcbc-mcq-b5-sv-h-2.2-b-v3','apcalcbc-mcq-b5-h-2.3-a','apcalcbc-mcq-b5-sv-h-2.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-sv-h-2.2-a-v1','apcalcbc-mcq-b5-sv-h-2.2-a-v2','apcalcbc-mcq-b5-sv-h-2.2-a-v3','apcalcbc-mcq-b5-h-2.2-b','apcalcbc-mcq-b5-sv-h-2.2-b-v1','apcalcbc-mcq-b5-sv-h-2.2-b-v2','apcalcbc-mcq-b5-sv-h-2.2-b-v3','apcalcbc-mcq-b5-h-2.3-a','apcalcbc-mcq-b5-sv-h-2.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
