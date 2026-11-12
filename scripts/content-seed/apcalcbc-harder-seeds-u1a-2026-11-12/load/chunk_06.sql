begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.6-b-v1','apcalcbc-mcq-b6-sv-h-1.6-b-v2','apcalcbc-mcq-b6-sv-h-1.6-b-v3','apcalcbc-mcq-b6-h-1.7-a','apcalcbc-mcq-b6-sv-h-1.7-a-v1','apcalcbc-mcq-b6-sv-h-1.7-a-v2','apcalcbc-mcq-b6-sv-h-1.7-a-v3','apcalcbc-mcq-b6-h-1.7-b','apcalcbc-mcq-b6-sv-h-1.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-sv-h-1.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.6-b-v1', 'mcq', 'evaluate trigonometric quotients that need a half-angle identity and the sin u / u limit together. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (1 − cos 6x)/(x sin 3x)?', null, md5('apcalcbc-mcq-b6-sv-h-1.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Direct substitution gives 0/0, which is indeterminate; the identity 1 − cos 6x = 2 sin² 3x shows the limit is 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This drops the 2 in 1 − cos 6x = 2 sin² 3x, giving sin 3x / x → 3 instead of 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', true, 'Correct: 1 − cos 6x = 2 sin² 3x, so the quotient is 2 sin 3x / x = 6 · (sin 3x)/(3x) → 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '18', false, 'This treats sin 3x as x in the denominator, giving 2·9x²/x² = 18 instead of 6.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.6-b-v2', 'mcq', 'evaluate trigonometric quotients that need a half-angle identity and the sin u / u limit together. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) tan 6x / sin 4x?', null, md5('apcalcbc-mcq-b6-sv-h-1.6-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/3', false, 'This inverts the ratio; near 0, tan 6x ≈ 6x and sin 4x ≈ 4x, so the quotient approaches 6/4, not 4/6.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This treats tan 6x and sin 4x as both approaching the same multiple of x, ignoring the coefficients 6 and 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/2', true, 'Correct: tan 6x / sin 4x = (sin 6x)/(cos 6x · sin 4x) → (6x)/(1 · 4x) = 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '24', false, 'This multiplies the coefficients 6 and 4 instead of dividing them.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.6-b-v3', 'mcq', 'evaluate trigonometric quotients that need a half-angle identity and the sin u / u limit together. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (1 − cos 2x)/(x tan x)?', null, md5('apcalcbc-mcq-b6-sv-h-1.6-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'Substituting gives 0/0, which is indeterminate; the identity 1 − cos 2x = 2 sin² x shows the limit is 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This replaces 1 − cos 2x by sin² x, missing the factor 2 in the identity 1 − cos 2x = 2 sin² x.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This uses 1 − cos θ ≈ θ², giving 4x²/x² = 4, but the correct approximation is θ²/2, giving 2x²/x² = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'Correct: 1 − cos 2x = 2 sin² x, and tan x ≈ x, so the quotient is 2 sin x cos x / x → 2.' from version_ins;
-- apcalcbc-mcq-b6-h-1.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.7-a', 'mcq', 'match each limit with an appropriate procedure and identify which one has the stated value.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following limits equals 2?', null, md5('apcalcbc-mcq-b6-h-1.7-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) (√(x + 4) − 2)/x', false, 'Multiplying by the conjugate gives 1/(√(x + 4) + 2), which tends to 1/4, not 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) sin 6x / (2x)', false, 'Writing sin 6x/(2x) = 3 · (sin 6x)/(6x) shows the limit is 3, not 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→1) (x³ − 1)/(x² − 1)', false, 'Factoring gives (x² + x + 1)/(x + 1), which tends to 3/2, not 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→∞) (4x² − x)/(2x² + 1)', true, 'Correct: Dividing by x² gives (4 − 1/x)/(2 + 1/x²) → 2; the other three limits are 1/4, 3, and 3/2.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.7-a-v1', 'mcq', 'match each limit with an appropriate procedure and identify which one has the stated value. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following limits equals 3?', null, md5('apcalcbc-mcq-b6-sv-h-1.7-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) (√(x + 9) − 3)/x', false, 'The conjugate gives 1/(√(x + 9) + 3), which tends to 1/6, not 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) sin 6x / (2x)', true, 'Correct: sin 6x/(2x) = 3·(sin 6x)/(6x) → 3; the other limits are 1/6, 0, and 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→∞) (9x² + x)/(3x³ − 2)', false, 'The denominator has the higher degree, so the quotient tends to 0, not 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→2) (x² − 4)/(x − 2)', false, 'Factoring gives x + 2, which tends to 4, not 3.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.7-a-v2', 'mcq', 'match each limit with an appropriate procedure and identify which one has the stated value. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following limits equals 1?', null, md5('apcalcbc-mcq-b6-sv-h-1.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) sin x / (2x)', false, 'Writing sin x/(2x) = (1/2)·(sin x)/x shows the limit is 1/2, not 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) (1 − cos x)/x', false, 'Since 1 − cos x behaves like x²/2, the quotient tends to 0, not 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→∞) (x² + sin x)/(x² − cos x)', true, 'Correct: Dividing by x² gives (1 + sin x/x²)/(1 − cos x/x²) → 1 since the sine and cosine terms are bounded; the others are 1/2, 0, and 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→1) (x² − 1)/(x − 1)', false, 'Factoring gives x + 1, which tends to 2, not 1.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.7-a-v3', 'mcq', 'match each limit with an appropriate procedure and identify which one has the stated value. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following limits equals −1?', null, md5('apcalcbc-mcq-b6-sv-h-1.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→−∞) x/√(x² + 1)', true, 'Correct: For x < 0, √(x² + 1) = |x|√(1 + 1/x²) = −x√(1 + 1/x²), so the quotient tends to −1; the others are DNE, 1, and −1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) |x|/x', false, 'The one-sided limits are 1 and −1, so this limit does not exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→∞) x/√(x² + 1)', false, 'For x > 0, √(x² + 1)/x → 1, so the limit is +1, not −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0) (cos x − 1)/x²', false, 'Using cos x − 1 ≈ −x²/2 gives −1/2, not −1.' from version_ins;
-- apcalcbc-mcq-b6-h-1.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.7-b', 'mcq', 'locate the first error in a student''s worked limit and recognize why the step fails.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates lim(x→3) (√(x + 6) − 3)/(x − 3) as follows. Step 1: Substituting x = 3 gives 0/0, so the expression must be rewritten. Step 2: Multiply numerator and denominator by √(x + 6) + 3; the numerator becomes (x + 6) − 9 = x − 3. Step 3: Cancel the factor x − 3 from numerator and denominator, leaving √(x + 6) + 3. Step 4: Substitute x = 3 to get √9 + 3 = 6. In which step does the first error occur?', null, md5('apcalcbc-mcq-b6-h-1.7-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 3', true, 'Correct: Step 3 should leave 1/(√(x + 6) + 3), since the factor x − 3 cancels from the numerator; the limit is 1/6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 1', false, 'Substitution giving 0/0 is indeterminate, so rewriting the expression is the right move and this step has no error.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 2', false, 'Multiplying by the conjugate gives the numerator (x + 6) − 9 = x − 3, which is correct, and the denominator becomes (x − 3)(√(x + 6) + 3).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4', false, 'Substituting into √(x + 6) + 3 does give 6, so the arithmetic is right; the wrong answer comes from the cancellation in Step 3, which is earlier.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.7-b-v1', 'mcq', 'locate the first error in a student''s worked limit and recognize why the step fails. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates lim(x→2) (x² − 4)/(x − 2) as follows. Step 1: Substituting x = 2 gives 0/0, so the expression must be rewritten. Step 2: Factor the numerator as (x − 2)². Step 3: Cancel one factor of x − 2, leaving x − 2. Step 4: Substitute x = 2 to get 0. In which step does the first error occur?', null, md5('apcalcbc-mcq-b6-sv-h-1.7-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Step 1', false, 'Substitution gives 0/0, which signals the need for algebra, so this step is correct.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Step 3', false, 'Cancelling one factor of x − 2 from (x − 2)²/(x − 2) does leave x − 2, so this step follows from Step 2; the mistake is the factorization before it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Step 2', true, 'Correct: x² − 4 factors as (x − 2)(x + 2), so the quotient simplifies to x + 2 and the limit is 4; the error is in Step 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Step 4', false, 'Substituting x = 2 into x − 2 does give 0, so this step follows correctly from the previous one; the error came earlier.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.6-b-v1','apcalcbc-mcq-b6-sv-h-1.6-b-v2','apcalcbc-mcq-b6-sv-h-1.6-b-v3','apcalcbc-mcq-b6-h-1.7-a','apcalcbc-mcq-b6-sv-h-1.7-a-v1','apcalcbc-mcq-b6-sv-h-1.7-a-v2','apcalcbc-mcq-b6-sv-h-1.7-a-v3','apcalcbc-mcq-b6-h-1.7-b','apcalcbc-mcq-b6-sv-h-1.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-sv-h-1.6-b-v1','apcalcbc-mcq-b6-sv-h-1.6-b-v2','apcalcbc-mcq-b6-sv-h-1.6-b-v3','apcalcbc-mcq-b6-h-1.7-a','apcalcbc-mcq-b6-sv-h-1.7-a-v1','apcalcbc-mcq-b6-sv-h-1.7-a-v2','apcalcbc-mcq-b6-sv-h-1.7-a-v3','apcalcbc-mcq-b6-h-1.7-b','apcalcbc-mcq-b6-sv-h-1.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
