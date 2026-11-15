begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.12-a-v3','apcalcbc-mcq-b7-h-1.12-b','apcalcbc-mcq-b7-sv-h-1.12-b-v1','apcalcbc-mcq-b7-sv-h-1.12-b-v2','apcalcbc-mcq-b7-sv-h-1.12-b-v3','apcalcbc-mcq-b7-h-1.13-a','apcalcbc-mcq-b7-sv-h-1.13-a-v1','apcalcbc-mcq-b7-sv-h-1.13-a-v2','apcalcbc-mcq-b7-sv-h-1.13-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b7-sv-h-1.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.12-a-v3', 'mcq', 'find the largest set of continuity for a quotient of inverse-trigonometric and logarithmic expressions by intersecting d (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the largest set of x-values on which k(x) = arccos(1 − x)/√(x − 1) is continuous?', null, md5('apcalcbc-mcq-b7-sv-h-1.12-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[1, 2]', false, 'This includes x = 1, but there √0 = 0 makes the denominator zero, so k is undefined at 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 2]', false, 'This only uses the arccos restriction and ignores that √(x − 1) is undefined for x < 1 and zero at 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '(1, ∞)', false, 'This only uses the square-root restriction x > 1, but arccos(1 − x) is undefined for x > 2 where 1 − x < −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '(1, 2]', true, 'Correct: arccos(1 − x) needs −1 ≤ 1 − x ≤ 1, so 0 ≤ x ≤ 2. The square root in the denominator needs x − 1 > 0. Intersecting gives (1, 2]; at x = 2, arccos(−1) = π and √1 = 1.' from version_ins;
-- apcalcbc-mcq-b7-h-1.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.12-b', 'mcq', 'make a three-piece function continuous on all real numbers by matching both junction points, tracking how ln(1) and e⁰ r', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = a·eˣ for x < 0, f(x) = bx + 2 for 0 ≤ x ≤ 2, and f(x) = a·ln(x − 1) + 8 for x > 2. For which values of a and b is f continuous for all real numbers?', null, md5('apcalcbc-mcq-b7-h-1.12-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 2, b = 3', true, 'Correct: At x = 0: a·e⁰ = a must equal b·0 + 2, so a = 2. At x = 2: 2b + 2 must equal a·ln 1 + 8 = 8, so b = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 2, b = 6', false, 'The equation 2b + 2 = 8 gives 2b = 6; this stops there and reports b = 6 without dividing by 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 2, b = 4', false, 'This takes ln 1 = 1, so the right limit at 2 is a + 8 = 10, giving 2b + 2 = 10 and b = 4; but ln 1 = 0 so the right limit is just 8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 2, b = 5', false, 'This solves 2b + 2 = 8 by adding 2 instead of subtracting, writing 2b = 10 and b = 5.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.12-b-v1', 'mcq', 'make a three-piece function continuous on all real numbers by matching both junction points, tracking how ln(1) and e⁰ r (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g be defined by g(x) = a·e^(x − 1) + bx for x < 1, g(x) = x² for 1 ≤ x ≤ 3, and g(x) = a·ln(x − 2) + 3b for x > 3. For which values of a and b is g continuous for all real numbers?', null, md5('apcalcbc-mcq-b7-sv-h-1.12-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = −3, b = 4', false, 'This takes ln 1 = 1, giving a + 3b = 9 with a + b = 1, which solves to b = 4 and a = −3; but ln 1 = 0, so the right limit at 3 is 3b.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = −2, b = 3', true, 'Correct: At x = 3: right piece gives a·ln 1 + 3b = 3b, which must equal 3² = 9, so b = 3. At x = 1: left piece gives a + b, which must equal 1² = 1, so a = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 2, b = 3', false, 'This gets b = 3 correctly but solves a + 3 = 1 as a = 2, a sign error.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −8, b = 9', false, 'This writes 3b = 9 and stops at b = 9 without dividing by 3, and then a + 9 = 1 gives a = −8.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.12-b-v2', 'mcq', 'make a three-piece function continuous on all real numbers by matching both junction points, tracking how ln(1) and e⁰ r (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h be defined by h(x) = a·eˣ + b for x < 0, h(x) = 2x + 4 for 0 ≤ x ≤ 1, and h(x) = 2b·e^(x − 1) − a·ln x for x > 1. For which values of a and b is h continuous for all real numbers?', null, md5('apcalcbc-mcq-b7-sv-h-1.12-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 3, b = 3', false, 'This matches the left junction at 0 to the middle value 6 (its value at x = 1) instead of 4, so a + b = 6 with b = 3 gives a = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 1, b = 3', true, 'Correct: At x = 1: the right piece gives 2b·e⁰ − a·ln 1 = 2b, which must equal 2(1) + 4 = 6, so b = 3. At x = 0: the left piece gives a + b, which must equal 4, so a = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 2, b = 2', false, 'This matches the right junction at 1 to the middle value 4 (its value at x = 0), so 2b = 4 gives b = 2, and then a + b = 4 gives a = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = −2, b = 6', false, 'This forgets the factor 2 on the right, writing b = 6, and then a + 6 = 4 gives a = −2.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.12-b-v3', 'mcq', 'make a three-piece function continuous on all real numbers by matching both junction points, tracking how ln(1) and e⁰ r (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = 3e^(x − 2) for x < 2, f(x) = ax − 5 for 2 ≤ x ≤ 3, and f(x) = b + 4 ln(x − 2) for x > 3. If f is continuous for all real numbers, what is a + b?', null, md5('apcalcbc-mcq-b7-sv-h-1.12-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', false, 'This takes ln 1 = 1, so b + 4 = 7 and b = 3, which gives a + b = 7; but ln 1 = 0, so b = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−9', false, 'This solves 2a − 5 = 3 as a = −1 through a sign slip, then 3a − 5 = −8 gives b = −8, and a + b = −9.' from version_ins
union all select gen_random_uuid(), id, 'C', '27', false, 'This solves 2a − 5 = 3 as a = 8 by forgetting to divide by 2, then 3a − 5 = 19 gives b = 19, and a + b = 27.' from version_ins
union all select gen_random_uuid(), id, 'D', '11', true, 'Correct: At x = 2: 3e⁰ = 3 = 2a − 5, so a = 4. At x = 3: 3a − 5 = 7 must equal b + 4 ln 1 = b, so b = 7. Then a + b = 11.' from version_ins;
-- apcalcbc-mcq-b7-h-1.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-h-1.13-a', 'mcq', 'find the value that removes a discontinuity when the limit requires a double-angle identity and the special trigonometri', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f is defined by f(x) = (1 − cos 6x)/(x·sin 3x) for x ≠ 0 near 0, and f(0) = k. For what value of k is f continuous at x = 0?', null, md5('apcalcbc-mcq-b7-h-1.13-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', true, 'Correct: 1 − cos 6x = 2sin²3x, so f(x) = 2 sin 3x / x for x near 0, which has limit 2·3 = 6. Numerically f(0.001) ≈ 5.99999.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This takes (1 − cos u)/u → 0 and concludes the limit is 0, but the denominator here is x·sin 3x, which is of order x², the same order as the numerator.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'This writes 1 − cos 6x = sin²3x, forgetting the factor 2 in the identity 1 − cos 2θ = 2sin²θ, and gets sin 3x/x → 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', false, 'This approximates 1 − cos 6x by (6x)² = 36x², forgetting the 1/2 in 1 − cos u ≈ u²/2, and gets 36x²/(3x²) = 12.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.13-a-v1', 'mcq', 'find the value that removes a discontinuity when the limit requires a double-angle identity and the special trigonometri (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g is defined by g(x) = (1 − cos 4x)/(x·sin 2x) for x ≠ 0 near 0, and g(0) = k. For what value of k is g continuous at x = 0?', null, md5('apcalcbc-mcq-b7-sv-h-1.13-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This assumes the limit is 0 from (1 − cos u)/u → 0, ignoring that the denominator is also small, of order x².' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: 1 − cos 4x = 2sin²2x, so g(x) = 2 sin 2x / x → 2·2 = 4. Numerically g(0.001) ≈ 4.0000.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'This drops the factor 2 in 1 − cos 4x = 2sin²2x and gets sin 2x/x → 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '8', false, 'This approximates 1 − cos 4x by (4x)² = 16x², forgetting the 1/2, and gets 16x²/(2x²) = 8.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.13-a-v2', 'mcq', 'find the value that removes a discontinuity when the limit requires a double-angle identity and the special trigonometri (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function h is defined by h(x) = (1 − cos 8x)/(x·sin 2x) for x ≠ 0 near 0, and h(0) = k. For what value of k is h continuous at x = 0?', null, md5('apcalcbc-mcq-b7-sv-h-1.13-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This treats the 0/0 form as 0 using (1 − cos u)/u → 0, but both numerator and denominator are of order x², so the ratio is a nonzero constant.' from version_ins
union all select gen_random_uuid(), id, 'B', '16', true, 'Correct: 1 − cos 8x = 2sin²4x, so h(x) = 2 sin²4x / (x sin 2x). Using sin 4x ≈ 4x and sin 2x ≈ 2x, h(x) ≈ 2·16x²/(2x²) = 16. Numerically h(0.001) ≈ 16.0.' from version_ins
union all select gen_random_uuid(), id, 'C', '32', false, 'This approximates 1 − cos 8x by (8x)² = 64x², dropping the 1/2, and gets 64x²/(2x²) = 32.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/16', false, 'This inverts the quotient, finding denominator/numerator = 2/32 = 1/16.' from version_ins;
-- apcalcbc-mcq-b7-sv-h-1.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b7-sv-h-1.13-a-v3', 'mcq', 'find the value that removes a discontinuity when the limit requires a double-angle identity and the special trigonometri (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function p is defined by p(x) = (1 − cos 2x)/(x·tan x) for x ≠ 0 near 0, and p(0) = k. For what value of k is p continuous at x = 0?', null, md5('apcalcbc-mcq-b7-sv-h-1.13-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This uses (1 − cos u)/u → 0, but the denominator x·tan x is of order x², so the limit is not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', true, 'Correct: 1 − cos 2x = 2sin²x, so p(x) = 2 sin²x/(x tan x) = 2 sin x cos x / x → 2. Numerically p(0.001) ≈ 2.0000.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This approximates 1 − cos 2x by (2x)² = 4x², dropping the 1/2, and gets 4x²/x² = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This approximates 1 − cos 2x by x²/2 (using u = x instead of u = 2x), which gives 1/2.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b7-sv-h-1.12-a-v3','apcalcbc-mcq-b7-h-1.12-b','apcalcbc-mcq-b7-sv-h-1.12-b-v1','apcalcbc-mcq-b7-sv-h-1.12-b-v2','apcalcbc-mcq-b7-sv-h-1.12-b-v3','apcalcbc-mcq-b7-h-1.13-a','apcalcbc-mcq-b7-sv-h-1.13-a-v1','apcalcbc-mcq-b7-sv-h-1.13-a-v2','apcalcbc-mcq-b7-sv-h-1.13-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b7-sv-h-1.12-a-v3','apcalcbc-mcq-b7-h-1.12-b','apcalcbc-mcq-b7-sv-h-1.12-b-v1','apcalcbc-mcq-b7-sv-h-1.12-b-v2','apcalcbc-mcq-b7-sv-h-1.12-b-v3','apcalcbc-mcq-b7-h-1.13-a','apcalcbc-mcq-b7-sv-h-1.13-a-v1','apcalcbc-mcq-b7-sv-h-1.13-a-v2','apcalcbc-mcq-b7-sv-h-1.13-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
