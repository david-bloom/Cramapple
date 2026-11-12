begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.2-a-v1','apcalcbc-mcq-b6-sv-h-1.2-a-v2','apcalcbc-mcq-b6-sv-h-1.2-a-v3','apcalcbc-mcq-b6-h-1.2-b','apcalcbc-mcq-b6-sv-h-1.2-b-v1','apcalcbc-mcq-b6-sv-h-1.2-b-v2','apcalcbc-mcq-b6-sv-h-1.2-b-v3','apcalcbc-mcq-b6-h-1.3-a','apcalcbc-mcq-b6-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.2-a-v1', 'mcq', 'evaluate a limit of a composite h(f(x)) by tracking the side from which the inner function approaches its limit. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f satisfy lim(x→3⁺) f(x) = −1, where f(x) > −1 for x > 3 near 3. Let h satisfy lim(u→−1⁻) h(u) = 6, lim(u→−1⁺) h(u) = 2, and h(−1) = 0. What is lim(x→3⁺) h(f(x))?', null, md5('apcalcbc-mcq-b6-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'The value 6 is the left-hand limit of h, but f(x) approaches −1 from above, so the inputs to h are greater than −1 and the right-hand limit applies.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The value 0 is h(−1); limits describe nearby behavior, and f(x) stays above −1 so the inputs never need to be −1.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: As x → 3⁺, f(x) → −1 from above, so h(f(x)) → lim(u→−1⁺) h(u) = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'H has no two-sided limit at −1, but the inputs f(x) approach −1 only from above, so only the right-hand limit of h matters and the composite limit exists.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.2-a-v2', 'mcq', 'evaluate a limit of a composite h(f(x)) by tracking the side from which the inner function approaches its limit. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f satisfy lim(x→4) f(x) = 1, with f(x) > 1 for x < 4 and f(x) < 1 for x > 4. Let h satisfy lim(u→1⁻) h(u) = 3, lim(u→1⁺) h(u) = 8, and h(1) = 3. What is lim(x→4) h(f(x))?', null, md5('apcalcbc-mcq-b6-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', false, 'The value 3 equals h(1) and the left-hand limit of h, but it describes only the right side x > 4, where f(x) is below 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '8', false, 'The value 8 is the right-hand limit of h, which governs only x < 4 where f(x) is above 1; for x > 4 the composite approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '11/2', false, 'The mean of 3 and 8 is not a limit of anything here; as x approaches 4 the composite approaches 8 from the left and 3 from the right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', true, 'Correct: For x < 4, f(x) → 1⁺ so h(f(x)) → 8; for x > 4, f(x) → 1⁻ so h(f(x)) → 3. The one-sided limits differ.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.2-a-v3', 'mcq', 'evaluate a limit of a composite h(f(x)) by tracking the side from which the inner function approaches its limit. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f satisfy lim(x→−2⁻) f(x) = 0, with f(x) > 0 for x < −2 near −2. Let h satisfy lim(u→0⁻) h(u) = −4, lim(u→0⁺) h(u) = 1, and h(0) = 3. What is lim(x→−2⁻) h(f(x))?', null, md5('apcalcbc-mcq-b6-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4', false, 'The value −4 is the left-hand limit of h, but f(x) approaches 0 from above, so the right-hand limit of h applies.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', true, 'Correct: As x → −2⁻, f(x) → 0 from above, so h(f(x)) → lim(u→0⁺) h(u) = 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'The value 3 is h(0); the composite limit depends on h near 0 on the side the inputs come from, not on h(0).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'H has different one-sided limits at 0, but f(x) approaches 0 only from above here, so only the right-hand limit is relevant and the composite limit exists.' from version_ins;
-- apcalcbc-mcq-b6-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.2-b', 'mcq', 'judge which limit statements, including infinite and one-sided limits, are written correctly.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following is a correct statement?', null, md5('apcalcbc-mcq-b6-h-1.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) 1/x = ∞', false, 'The one-sided limits of 1/x at 0 are ∞ from the right and −∞ from the left, so the two-sided limit cannot be written as ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) ln|x| = −∞', true, 'Correct: ln|x| → −∞ from both sides of 0; 1/x has opposite one-sided limits; ln x → −∞ as x → 0⁺; −1/x² → −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0⁺) ln x = 0', false, 'The value ln 1 = 0 belongs to x approaching 1; as x approaches 0 from the right, ln x decreases without bound to −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0) (−1/x²) = ∞', false, 'Since 1/x² grows without bound and −1/x² is its opposite, the limit is −∞, not ∞.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.2-b-v1', 'mcq', 'judge which limit statements, including infinite and one-sided limits, are written correctly. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following is a correct statement?', null, md5('apcalcbc-mcq-b6-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→2) 3/(x − 2) = ∞', false, 'The function 3/(x − 2) tends to ∞ from the right of 2 but to −∞ from the left, so the two-sided limit is not ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→2⁺) 1/(x − 2) = −∞', false, 'For x slightly greater than 2, x − 2 is a small positive number, so 1/(x − 2) is large and positive, giving ∞ rather than −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→2) −3/(x − 2)² = −∞', true, 'Correct: (x − 2)² is a small positive number near 2, so −3/(x − 2)² is large and negative from both sides.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→2) 3/(x − 2)² = 0', false, 'As x approaches 2 the denominator (x − 2)² approaches 0, making the quotient grow without bound; a limit of 0 would belong to x approaching infinity.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.2-b-v2', 'mcq', 'judge which limit statements, including infinite and one-sided limits, are written correctly. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following is a correct statement?', null, md5('apcalcbc-mcq-b6-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) e^(1/x) = ∞', false, 'As x approaches 0 from the left, 1/x → −∞ and e^(1/x) → 0, so the two-sided limit cannot be ∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0⁺) e^(1/x) = 1', false, 'The value e⁰ = 1 would arise if 1/x approached 0; as x approaches 0 from the right, 1/x → ∞ and e^(1/x) grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0) e^(1/x) = 0', false, 'The left-hand limit is 0, but from the right e^(1/x) → ∞, so the two-sided limit does not equal 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0⁻) e^(1/x) = 0', true, 'Correct: From the left 1/x → −∞ so e^(1/x) → 0; from the right it → ∞, so only the left-hand statement is correct.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.2-b-v3', 'mcq', 'judge which limit statements, including infinite and one-sided limits, are written correctly. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following is a correct statement?', null, md5('apcalcbc-mcq-b6-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→−3⁻) 1/(x + 3)³ = −∞', true, 'Correct: For x < −3, (x + 3)³ is a small negative number, so 1/(x + 3)³ is large and negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→−3) 1/(x + 3)³ = −∞', false, 'Left of −3 the cube is a small negative number, giving −∞, but right of −3 it is a small positive number, giving ∞, so the two-sided limit is not −∞.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→−3⁺) 1/(x + 3)³ = −∞', false, 'For x slightly greater than −3, x + 3 is positive and so is its cube, making the quotient large and positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→−3) 1/(x + 3)³ = 0', false, 'The denominator approaches 0, so the quotient grows in magnitude; a limit of 0 would arise as x approaches infinity.' from version_ins;
-- apcalcbc-mcq-b6-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.3-a', 'mcq', 'transform one-sided limits read from a graph through a reflection, shift, or scaling of the input, tracking which side i', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has lim(x→2⁻) f(x) = 3, lim(x→2⁺) f(x) = −1, and f(2) = 1. Let g(x) = f(−x). What is lim(x→−2⁺) g(x)?', null, md5('apcalcbc-mcq-b6-h-1.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: For x > −2 near −2, −x < 2 near 2, so g(x) = f(−x) → lim(u→2⁻) f(u) = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, 'This keeps the same side, but when x approaches −2 from the right, −x approaches 2 from the left, where f approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'The value 1 is f(2); a limit is determined by nearby values of f, not by the value at the point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'F has no two-sided limit at 2, but g sees only inputs −x that are less than 2 as x approaches −2 from the right, so a one-sided value is determined.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.3-a-v1', 'mcq', 'transform one-sided limits read from a graph through a reflection, shift, or scaling of the input, tracking which side i (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has lim(x→1⁻) f(x) = −2, lim(x→1⁺) f(x) = 5, and f(1) = 3. Let g(x) = f(2 − x). What is lim(x→1⁺) g(x)?', null, md5('apcalcbc-mcq-b6-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'This keeps the right-hand side, but for x > 1 the input 2 − x is less than 1, so the left-hand limit of f applies.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'The value 3 is f(1); the limit depends on values near 1, not at 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', true, 'Correct: For x > 1 near 1, 2 − x < 1 near 1, so g(x) = f(2 − x) → lim(u→1⁻) f(u) = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'F has different one-sided limits at 1, but as x approaches 1 from the right, 2 − x approaches 1 only from the left, so g has a right-hand limit.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.2-a-v1','apcalcbc-mcq-b6-sv-h-1.2-a-v2','apcalcbc-mcq-b6-sv-h-1.2-a-v3','apcalcbc-mcq-b6-h-1.2-b','apcalcbc-mcq-b6-sv-h-1.2-b-v1','apcalcbc-mcq-b6-sv-h-1.2-b-v2','apcalcbc-mcq-b6-sv-h-1.2-b-v3','apcalcbc-mcq-b6-h-1.3-a','apcalcbc-mcq-b6-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-sv-h-1.2-a-v1','apcalcbc-mcq-b6-sv-h-1.2-a-v2','apcalcbc-mcq-b6-sv-h-1.2-a-v3','apcalcbc-mcq-b6-h-1.2-b','apcalcbc-mcq-b6-sv-h-1.2-b-v1','apcalcbc-mcq-b6-sv-h-1.2-b-v2','apcalcbc-mcq-b6-sv-h-1.2-b-v3','apcalcbc-mcq-b6-h-1.3-a','apcalcbc-mcq-b6-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
