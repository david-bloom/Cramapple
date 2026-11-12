begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.7-b-v2','apcalcbc-mcq-b6-sv-h-1.7-b-v3','apcalcbc-mcq-b6-h-1.8-a','apcalcbc-mcq-b6-sv-h-1.8-a-v1','apcalcbc-mcq-b6-sv-h-1.8-a-v2','apcalcbc-mcq-b6-sv-h-1.8-a-v3','apcalcbc-mcq-b6-h-1.8-b','apcalcbc-mcq-b6-sv-h-1.8-b-v1','apcalcbc-mcq-b6-sv-h-1.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-sv-h-1.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.7-b-v2', 'mcq', 'locate the first error in a student''s worked limit and recognize why the step fails. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates lim(x→0) (sin 5x)/(sin 2x) as follows. Step 1: Divide numerator and denominator by x. Step 2: Rewrite the quotient as 5·[sin 5x/(5x)] divided by 2·[sin 2x/(2x)]. Step 3: Each bracket has limit 1, so the numerator tends to 5 and the denominator tends to 2. Step 4: Subtract to get 5 − 2 = 3. In which step does the first error occur?', null, md5('apcalcbc-mcq-b6-sv-h-1.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 1', false, 'Dividing numerator and denominator by x leaves the quotient unchanged for x ≠ 0, so this step is valid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 4', true, 'Correct: The quotient 5/2 should be formed by dividing, not subtracting; the limit is 5/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 2', false, 'Writing sin 5x / x = 5·(sin 5x)/(5x) and sin 2x / x = 2·(sin 2x)/(2x) is correct algebra.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 3', false, 'Since lim(u→0) sin u / u = 1, each bracket tends to 1, so the numerator tends to 5 and the denominator to 2; this step is correct.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.7-b-v3', 'mcq', 'locate the first error in a student''s worked limit and recognize why the step fails. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates lim(x→−∞) (2x + 1)/√(x² + 1) as follows. Step 1: Divide numerator and denominator by x. Step 2: Since √(x² + 1)/x = √(1 + 1/x²), the expression becomes (2 + 1/x)/√(1 + 1/x²). Step 3: As x → −∞, 1/x → 0. Step 4: The limit is 2/1 = 2. In which step does the first error occur?', null, md5('apcalcbc-mcq-b6-sv-h-1.7-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 2', true, 'Correct: For x < 0, √(x² + 1)/x = −√(1 + 1/x²), so the limit is 2/(−1) = −2; the error is in Step 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 1', false, 'Dividing numerator and denominator by x is valid for x ≠ 0, so no error occurs here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 3', false, 'As x tends to negative infinity, 1/x does tend to 0, so this step is correct.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4', false, 'Given the expression in Step 2 the limit would be 2/1, so Step 4 follows; the mistake is earlier, in how the radical was divided by a negative x.' from version_ins;
-- apcalcbc-mcq-b6-h-1.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.8-a', 'mcq', 'bound a quotient containing a bounded oscillating term and squeeze at infinity.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) (x + 3 sin x)/(2x + 1)?', null, md5('apcalcbc-mcq-b6-h-1.8-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'The sine term oscillates, but it is bounded between −3 and 3 while x grows, so the quotient is squeezed between (x − 3)/(2x + 1) and (x + 3)/(2x + 1), both approaching 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/2', false, 'This replaces sin x by its maximum 1 and then treats the 3 as a multiple of x; the bounded term is negligible next to x.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/2', true, 'Correct: For x > 0, (x − 3)/(2x + 1) ≤ (x + 3 sin x)/(2x + 1) ≤ (x + 3)/(2x + 1), and both bounds tend to 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This keeps the coefficient of x in the numerator but ignores the 2 in the denominator; the ratio of leading coefficients is 1/2.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.8-a-v1', 'mcq', 'bound a quotient containing a bounded oscillating term and squeeze at infinity. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) (2x − 5 cos x)/(x + 4)?', null, md5('apcalcbc-mcq-b6-sv-h-1.8-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', true, 'Correct: (2x − 5)/(x + 4) ≤ (2x − 5 cos x)/(x + 4) ≤ (2x + 5)/(x + 4) for x > −4, and both bounds tend to 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist', false, 'The cosine term oscillates but is bounded, so the quotient is squeezed between (2x − 5)/(x + 4) and (2x + 5)/(x + 4), both tending to 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5', false, 'This reads the oscillating term as dominant; −5 cos x is bounded while 2x grows without bound.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This adds the maximum of the oscillating term, 5, to the leading coefficient 2, but a bounded term vanishes relative to x.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.8-a-v2', 'mcq', 'bound a quotient containing a bounded oscillating term and squeeze at infinity. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) x² sin x / (x³ + 1)?', null, md5('apcalcbc-mcq-b6-sv-h-1.8-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'The sine factor oscillates, but its size is at most 1, so the quotient is squeezed between −x²/(x³ + 1) and x²/(x³ + 1), both tending to 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This cancels x² with x³ and lets the sine factor equal 1; the denominator grows faster than the numerator.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', true, 'Correct: |x² sin x/(x³ + 1)| ≤ x²/(x³ + 1) → 0, so the limit is 0 by the Squeeze Theorem.' from version_ins
union all select gen_random_uuid(), id, 'D', '∞', false, 'The numerator x² sin x is large in size, but the denominator x³ + 1 grows faster, so the quotient is squeezed toward 0.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.8-a-v3', 'mcq', 'bound a quotient containing a bounded oscillating term and squeeze at infinity. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→∞) (4x² − 3x cos x)/(x² + 2)?', null, md5('apcalcbc-mcq-b6-sv-h-1.8-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'The cosine term oscillates, but it is bounded and multiplied by 3x, which is small next to 4x²; both (4x² − 3x)/(x² + 2) and (4x² + 3x)/(x² + 2) tend to 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', true, 'Correct: (4x² − 3x)/(x² + 2) ≤ (4x² − 3x cos x)/(x² + 2) ≤ (4x² + 3x)/(x² + 2) for x > 0, and both bounds tend to 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'This adds the maximum size of the oscillating term, 3, to 4, but that term is dominated by x².' from version_ins
union all select gen_random_uuid(), id, 'D', '1', false, 'This divides leading terms without including the coefficient 4 in the numerator; the ratio of leading coefficients is 4/1.' from version_ins;
-- apcalcbc-mcq-b6-h-1.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.8-b', 'mcq', 'use a bound on |f| to squeeze a quotient f(x)/xⁿ, and recognize when the bound is too weak.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies |f(x)| ≤ x² for all x. What is lim(x→0) f(x)/x?', null, md5('apcalcbc-mcq-b6-h-1.8-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'Nothing in the bound gives the value 1; dividing |f(x)| ≤ x² by |x| gives |f(x)/x| ≤ |x|, which tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit does not exist, because f(x)/x is of the form 0/0', false, 'A 0/0 form is indeterminate, not nonexistent; here −|x| ≤ f(x)/x ≤ |x| squeezes the quotient to 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It cannot be determined, because f is not given explicitly', false, 'The inequality alone suffices: |f(x)/x| ≤ |x| for x ≠ 0, so the Squeeze Theorem applies without a formula.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', true, 'Correct: |f(x)/x| ≤ x²/|x| = |x| → 0, so f(x)/x → 0.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.8-b-v1', 'mcq', 'use a bound on |f| to squeeze a quotient f(x)/xⁿ, and recognize when the bound is too weak. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g satisfies |g(x) − 3| ≤ 2(x − 1)² for all x. What is lim(x→1) (g(x) − 3)/(x − 1)?', null, md5('apcalcbc-mcq-b6-sv-h-1.8-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'The constant 2 is the coefficient in the bound, but dividing by |x − 1| gives |(g(x) − 3)/(x − 1)| ≤ 2|x − 1|, which tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', true, 'Correct: |(g(x) − 3)/(x − 1)| ≤ 2|x − 1| → 0, so the quotient tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'The value 3 is the limit of g itself, not of the quotient; the quotient is squeezed to 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist, because both numerator and denominator tend to 0', false, 'Both tending to 0 is an indeterminate form, not a proof of nonexistence; the bound squeezes the quotient to 0.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.8-b-v2', 'mcq', 'use a bound on |f| to squeeze a quotient f(x)/xⁿ, and recognize when the bound is too weak. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h satisfies |h(x)| ≤ 5x⁴ for all x. What is lim(x→0) h(x)/x²?', null, md5('apcalcbc-mcq-b6-sv-h-1.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'The constant 5 comes from the bound, but dividing by x² gives |h(x)/x²| ≤ 5x², which tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', true, 'Correct: |h(x)/x²| ≤ 5x⁴/x² = 5x² → 0, so the quotient tends to 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The inequality bounds the quotient by 5x², so it is squeezed between −5x² and 5x², both tending to 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '∞', false, 'Dividing by x² does not make the quotient grow; the bound |h(x)/x²| ≤ 5x² keeps it small near 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.7-b-v2','apcalcbc-mcq-b6-sv-h-1.7-b-v3','apcalcbc-mcq-b6-h-1.8-a','apcalcbc-mcq-b6-sv-h-1.8-a-v1','apcalcbc-mcq-b6-sv-h-1.8-a-v2','apcalcbc-mcq-b6-sv-h-1.8-a-v3','apcalcbc-mcq-b6-h-1.8-b','apcalcbc-mcq-b6-sv-h-1.8-b-v1','apcalcbc-mcq-b6-sv-h-1.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-sv-h-1.7-b-v2','apcalcbc-mcq-b6-sv-h-1.7-b-v3','apcalcbc-mcq-b6-h-1.8-a','apcalcbc-mcq-b6-sv-h-1.8-a-v1','apcalcbc-mcq-b6-sv-h-1.8-a-v2','apcalcbc-mcq-b6-sv-h-1.8-a-v3','apcalcbc-mcq-b6-h-1.8-b','apcalcbc-mcq-b6-sv-h-1.8-b-v1','apcalcbc-mcq-b6-sv-h-1.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
