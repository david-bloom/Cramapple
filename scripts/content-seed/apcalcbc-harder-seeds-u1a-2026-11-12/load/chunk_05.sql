begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-h-1.5-b','apcalcbc-mcq-b6-sv-h-1.5-b-v1','apcalcbc-mcq-b6-sv-h-1.5-b-v2','apcalcbc-mcq-b6-sv-h-1.5-b-v3','apcalcbc-mcq-b6-h-1.6-a','apcalcbc-mcq-b6-sv-h-1.6-a-v1','apcalcbc-mcq-b6-sv-h-1.6-a-v2','apcalcbc-mcq-b6-sv-h-1.6-a-v3','apcalcbc-mcq-b6-h-1.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-h-1.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.5-b', 'mcq', 'decide what algebraic limit laws guarantee when one limit is infinite, zero, or nonexistent, using the converse-style ar', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→0) f(x) = 0 and lim(x→0) |g(x)| = ∞. Which statement about lim(x→0) f(x)g(x) is true?', null, md5('apcalcbc-mcq-b6-h-1.5-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It cannot be determined from this information; f(x) = x with g(x) = 1/x gives 1, while f(x) = x² with g(x) = 1/x gives 0', true, 'Correct: x·(1/x) = 1 and x²·(1/x) = x → 0, so different pairs with the same limit behavior give different results.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It must equal 0, because the product of 0 and any quantity is 0', false, 'The product law applies only when both limits are finite; here g is unbounded, so the factor tending to 0 can be outweighed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It must equal ∞, because g grows without bound', false, 'The factor f(x) tends to 0 and can cancel the growth of g, as in f(x) = x with g(x) = 1/x, whose product is 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It does not exist, because 0·∞ is undefined', false, 'An indeterminate form does not mean the limit fails to exist; the products x·(1/x) and x²·(1/x) have limits 1 and 0.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.5-b-v1', 'mcq', 'decide what algebraic limit laws guarantee when one limit is infinite, zero, or nonexistent, using the converse-style ar (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→1) f(x) = 3 and lim(x→1) g(x) = 0. Which statement about lim(x→1) f(x)/g(x) is true?', null, md5('apcalcbc-mcq-b6-sv-h-1.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It cannot equal any real number, because f = (f/g)·g would then tend to 0, not 3', true, 'Correct: If f/g → L, then f = (f/g)·g → L·0 = 0, contradicting lim f = 3; so no real limit exists.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 3, because g contributes nothing in the limit', false, 'The quotient is not f times a vanishing factor; dividing by a quantity near 0 makes the quotient large in magnitude, not close to 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It equals 0, because the numerator is bounded', false, 'Dividing by a very small g makes the quotient large, not small, so 0 is not possible.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It must equal ∞, because the denominator tends to 0', false, 'If g takes both signs near 1, the quotient is large positive on one side and large negative on the other, so the limit may fail to exist rather than equal ∞.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.5-b-v2', 'mcq', 'decide what algebraic limit laws guarantee when one limit is infinite, zero, or nonexistent, using the converse-style ar (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→4) f(x) = −2 and lim(x→4) g(x) does not exist. Which statement about lim(x→4) (f(x) + g(x)) is true?', null, md5('apcalcbc-mcq-b6-sv-h-1.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It equals −2, because a function without a limit contributes nothing', false, 'A function lacking a limit does not contribute zero; if the sum had a limit, subtracting f would give g a limit, which it lacks.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It does not exist, because if it did, g = (f + g) − f would have a limit', true, 'Correct: If f + g had a limit, then g = (f + g) − f would have a limit by the difference law, contradicting the hypothesis.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It cannot be determined, because g is not specified', false, 'Nothing more is needed: the sum having a limit would force g to have one, so the sum fails to have a limit in every case.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It equals ∞, because g is unbounded', false, 'Not having a limit does not mean being unbounded; g may oscillate boundedly, and the argument concludes only that the sum has no limit.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.5-b-v3', 'mcq', 'decide what algebraic limit laws guarantee when one limit is infinite, zero, or nonexistent, using the converse-style ar (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→∞) f(x) = ∞ and lim(x→∞) g(x) = −∞. Which statement about lim(x→∞) (f(x) + g(x)) is true?', null, md5('apcalcbc-mcq-b6-sv-h-1.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It equals 0, because ∞ − ∞ = 0', false, 'Infinity is not a number that can be cancelled; x + (−x) = 0 but 2x + (−x) = x grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It cannot be determined; f(x) = x with g(x) = −x gives 0, while f(x) = 2x with g(x) = −x gives ∞', true, 'Correct: Different pairs with the same infinite behavior give 0, ∞, or −∞, so the sum is an indeterminate form.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It equals −∞, because g is negative', false, 'The sum can be positive, as 2x + (−x) = x, so the sign of g alone does not decide the result.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It equals ∞, because f is positive', false, 'The sum can be 0 or even tend to −∞, as in x + (−2x) = −x, so the sign of f alone does not decide the result.' from version_ins;
-- apcalcbc-mcq-b6-h-1.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.6-a', 'mcq', 'choose a parameter so a radical difference quotient has a finite limit, then evaluate it with the conjugate.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the limit lim(x→1) (√(x + a) − 2)/(x − 1) to exist as a finite number, what must a be, and what is the value of the limit?', null, md5('apcalcbc-mcq-b6-h-1.6-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 3; limit 1/2', false, 'Multiplying by the conjugate gives (x − 1)/((x − 1)(√(x + 3) + 2)), so the limit is 1/(2 + 2) = 1/4; 1/2 uses only one of the two terms of the denominator.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 4; limit 1/4', false, 'The numerator must vanish at x = 1, requiring √(1 + a) = 2, so a = 3; a = 4 comes from setting √a = 2 and gives a nonzero numerator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 3; limit 1/8', false, 'With a = 3 the conjugate denominator at x = 1 is √4 + 2 = 4, so the limit is 1/4; 1/8 doubles this denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 3; limit 1/4', true, 'Correct: √(1 + a) = 2 forces a = 3; then (x + 3 − 4)/((x − 1)(√(x + 3) + 2)) = 1/(√(x + 3) + 2) → 1/4.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.6-a-v1', 'mcq', 'choose a parameter so a radical difference quotient has a finite limit, then evaluate it with the conjugate. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the limit lim(x→2) (√(x + a) − 3)/(x − 2) to exist as a finite number, what must a be, and what is the value of the limit?', null, md5('apcalcbc-mcq-b6-sv-h-1.6-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 7; limit 1/3', false, 'The conjugate denominator at x = 2 is √9 + 3 = 6, so the limit is 1/6; 1/3 uses only √9 and forgets the added 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 9; limit 1/6', false, 'The numerator must vanish at x = 2, requiring √(2 + a) = 3, so a = 7; a = 9 comes from setting √a = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 7; limit 1/6', true, 'Correct: √(2 + a) = 3 forces a = 7; then the quotient becomes 1/(√(x + 7) + 3) → 1/6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 7; limit 1/12', false, 'The conjugate denominator at x = 2 is 6, giving 1/6; 1/12 inserts an extra factor of 2.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.6-a-v2', 'mcq', 'choose a parameter so a radical difference quotient has a finite limit, then evaluate it with the conjugate. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the limit lim(x→4) (√(x + a) − 5)/(x − 4) to exist as a finite number, what must a be, and what is the value of the limit?', null, md5('apcalcbc-mcq-b6-sv-h-1.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 21; limit 1/5', false, 'The conjugate denominator at x = 4 is √25 + 5 = 10, so the limit is 1/10; 1/5 uses only √25.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 25; limit 1/10', false, 'The numerator must vanish at x = 4, so √(4 + a) = 5 and a = 21; a = 25 sets √a = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 21; limit 1/10', true, 'Correct: √(4 + a) = 5 forces a = 21; then the quotient is 1/(√(x + 21) + 5) → 1/10.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 21; limit 1/20', false, 'With a = 21 the conjugate denominator is 10, so the limit is 1/10; 1/20 doubles the denominator.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.6-a-v3', 'mcq', 'choose a parameter so a radical difference quotient has a finite limit, then evaluate it with the conjugate. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the limit lim(x→1) (√(2x + a) − 3)/(x − 1) to exist as a finite number, what must a be, and what is the value of the limit?', null, md5('apcalcbc-mcq-b6-sv-h-1.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 7; limit 1/3', true, 'Correct: √(2 + a) = 3 forces a = 7; then 2(x − 1)/((x − 1)(√(2x + 7) + 3)) → 2/6 = 1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 7; limit 1/6', false, 'The conjugate numerator is (2x + 7) − 9 = 2(x − 1), so a factor of 2 survives; omitting it gives 1/6 instead of 2/6 = 1/3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 9; limit 1/3', false, 'The numerator must vanish at x = 1, so √(2 + a) = 3 and a = 7; a = 9 sets √a = 3 and ignores the 2x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 7; limit 2/3', false, 'The conjugate denominator at x = 1 is √9 + 3 = 6, so the limit is 2/6 = 1/3; 2/3 uses only √9 = 3.' from version_ins;
-- apcalcbc-mcq-b6-h-1.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.6-b', 'mcq', 'evaluate trigonometric quotients that need a half-angle identity and the sin u / u limit together.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (1 − cos 4x)/(x sin 2x)?', null, md5('apcalcbc-mcq-b6-h-1.6-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'The numerator tends to 0, but so does the denominator, so substitution gives 0/0 and no conclusion; using 1 − cos 4x = 2 sin² 2x shows the limit is 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'This replaces 1 − cos 4x by sin² 2x, but the identity is 1 − cos 4x = 2 sin² 2x, which doubles the result.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'This treats sin 2x as if it were x; the denominator behaves like x·2x = 2x², while 1 − cos 4x behaves like 8x², giving 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', true, 'Correct: 1 − cos 4x = 2 sin² 2x, so the quotient is 2 sin 2x / x = 4 · (sin 2x)/(2x) → 4.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-h-1.5-b','apcalcbc-mcq-b6-sv-h-1.5-b-v1','apcalcbc-mcq-b6-sv-h-1.5-b-v2','apcalcbc-mcq-b6-sv-h-1.5-b-v3','apcalcbc-mcq-b6-h-1.6-a','apcalcbc-mcq-b6-sv-h-1.6-a-v1','apcalcbc-mcq-b6-sv-h-1.6-a-v2','apcalcbc-mcq-b6-sv-h-1.6-a-v3','apcalcbc-mcq-b6-h-1.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-h-1.5-b','apcalcbc-mcq-b6-sv-h-1.5-b-v1','apcalcbc-mcq-b6-sv-h-1.5-b-v2','apcalcbc-mcq-b6-sv-h-1.5-b-v3','apcalcbc-mcq-b6-h-1.6-a','apcalcbc-mcq-b6-sv-h-1.6-a-v1','apcalcbc-mcq-b6-sv-h-1.6-a-v2','apcalcbc-mcq-b6-sv-h-1.6-a-v3','apcalcbc-mcq-b6-h-1.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
