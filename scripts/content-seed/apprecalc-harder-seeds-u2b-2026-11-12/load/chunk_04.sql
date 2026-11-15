begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.12-a-v3','apprecalc-mcq-b8-h-2.12-b','apprecalc-mcq-b8-sv-h-2.12-b-v1','apprecalc-mcq-b8-sv-h-2.12-b-v2','apprecalc-mcq-b8-sv-h-2.12-b-v3','apprecalc-mcq-b8-h-2.13-a','apprecalc-mcq-b8-sv-h-2.13-a-v1','apprecalc-mcq-b8-sv-h-2.13-a-v2','apprecalc-mcq-b8-sv-h-2.13-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b8-sv-h-2.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.12-a-v3', 'mcq', 'decide which logarithm-property rewrite is valid for every x in the domain of the original expression, recognizing that  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider the expression log₂(16x²). Which equation is true for every real number x for which log₂(16x²) is defined?', null, md5('apprecalc-mcq-b8-sv-h-2.12-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'log₂(16x²) = 4 + 2log₂(x)', false, 'At x = −2, log₂(16x²) = log₂(64) is defined, but log₂(−2) does not exist, so 4 + 2log₂(x) cannot match for negative x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'log₂(16x²) = log₂(16)·log₂(x²)', false, 'At x = 8, log₂(1024) = 10, but 4·log₂(64) = 24.' from version_ins
union all select gen_random_uuid(), id, 'C', 'log₂(16x²) = 4 + (log₂ x)²', false, 'At x = 8, log₂(1024) = 10, but 4 + (log₂ 8)² = 13.' from version_ins
union all select gen_random_uuid(), id, 'D', 'log₂(16x²) = 4 + 2log₂|x|', true, 'Correct: The power rule needs |x| because x² and x⁴ are positive even when x is negative. Test points: negative x defined on the left but not for a plain log(x); the absolute-value form agrees at x = -2 and x = 8.' from version_ins;
-- apprecalc-mcq-b8-h-2.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.12-b', 'mcq', 'write the logarithm of a quotient involving a root in terms of given logarithms, using log₁₀(5) = 1 − log₁₀(2) and the p', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(√12 / 5)?', null, md5('apprecalc-mcq-b8-h-2.12-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3a + b − 1', false, 'This leaves out the factor ½ that the square root contributes to the numerator''s logarithm, using the whole of log₁₀ of the radicand instead of half of it.' from version_ins
union all select gen_random_uuid(), id, 'B', '2a + b/2 − 1', true, 'Correct: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result 2a + b/2 − 1 ≈ -0.1594, matching log₁₀(√12 / 5) ≈ -0.1594.' from version_ins
union all select gen_random_uuid(), id, 'C', '(a + b/2)/(−a + 1)', false, 'This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms.' from version_ins
union all select gen_random_uuid(), id, 'D', 'b/2 + 1', false, 'This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator''s logarithm must be subtracted, not added.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.12-b-v1', 'mcq', 'write the logarithm of a quotient involving a root in terms of given logarithms, using log₁₀(5) = 1 − log₁₀(2) and the p (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(√45 / 8)?', null, md5('apprecalc-mcq-b8-sv-h-2.12-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4a + 2b + 1', false, 'This leaves out the factor ½ that the square root contributes to the numerator''s logarithm, using the whole of log₁₀ of the radicand instead of half of it.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−a/2 + b + 1/2)/(3a)', false, 'This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms.' from version_ins
union all select gen_random_uuid(), id, 'C', '−7a/2 + b + 1/2', true, 'Correct: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result −7a/2 + b + 1/2 ≈ -0.0765, matching log₁₀(√45 / 8) ≈ -0.0765.' from version_ins
union all select gen_random_uuid(), id, 'D', '5a/2 + b + 1/2', false, 'This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator''s logarithm must be subtracted, not added.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.12-b-v2', 'mcq', 'write the logarithm of a quotient involving a root in terms of given logarithms, using log₁₀(5) = 1 − log₁₀(2) and the p (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(75 / √8)?', null, md5('apprecalc-mcq-b8-sv-h-2.12-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−5a + b + 2', false, 'This leaves out the factor ½ that the square root contributes to the denominator''s logarithm, using the whole of log₁₀(8) instead of half of it.' from version_ins
union all select gen_random_uuid(), id, 'B', '−7a/2 + b + 2', true, 'Correct: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result −7a/2 + b + 2 ≈ 1.4235, matching log₁₀(75 / √8) ≈ 1.4235.' from version_ins
union all select gen_random_uuid(), id, 'C', '(−2a + b + 2)/(3a/2)', false, 'This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms.' from version_ins
union all select gen_random_uuid(), id, 'D', '−a/2 + b + 2', false, 'This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator''s logarithm must be subtracted, not added.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.12-b-v3', 'mcq', 'write the logarithm of a quotient involving a root in terms of given logarithms, using log₁₀(5) = 1 − log₁₀(2) and the p (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let a = log₁₀(2) and b = log₁₀(3). Which expression equals log₁₀(√48 / 15)?', null, md5('apprecalc-mcq-b8-sv-h-2.12-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3a − b/2 − 1', true, 'Correct: Use log₁₀(5) = 1 − a. Half-logs for roots, then subtract: result 3a − b/2 − 1 ≈ -0.3355, matching log₁₀(√48 / 15) ≈ -0.3355.' from version_ins
union all select gen_random_uuid(), id, 'B', '5a − 1', false, 'This leaves out the factor ½ that the square root contributes to the numerator''s logarithm, using the whole of log₁₀ of the radicand instead of half of it.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2a + b/2)/(−a + b + 1)', false, 'This divides the logarithm of the numerator by the logarithm of the denominator. The quotient property says log(P/Q) = log P − log Q, a difference, not a quotient of logarithms.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a + 3b/2 + 1', false, 'This adds the two logarithms. Division inside the logarithm becomes subtraction of logarithms, so the denominator''s logarithm must be subtracted, not added.' from version_ins;
-- apprecalc-mcq-b8-h-2.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-h-2.13-a', 'mcq', 'solve a logarithmic inequality by combining the exponential rewrite with the domain requirement that the argument is pos', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of log₃(2x − 4) ≤ 2?', null, md5('apprecalc-mcq-b8-h-2.13-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x ≤ 13/2', false, 'This solves 2x − 4 ≤ 9 but ignores that the argument of the logarithm must be positive, so x must also be greater than 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 < x ≤ 5', false, 'This writes the exponential form as 2x − 4 ≤ 3·2 = 6 instead of 3² = 9, so the upper bound comes out wrong.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x ≥ 13/2', false, 'This reverses the inequality, but the base 3 is greater than 1, so log₃ is increasing and the direction is kept; the domain x > 2 is also lost.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 < x ≤ 13/2', true, 'Correct: Need 2x − 4 > 0, so x > 2, and log₃(2x − 4) ≤ 2 gives 2x − 4 ≤ 9, so x ≤ 13/2. Together 2 < x ≤ 13/2.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.13-a-v1', 'mcq', 'solve a logarithmic inequality by combining the exponential rewrite with the domain requirement that the argument is pos (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of log₂(3x − 6) ≤ 3?', null, md5('apprecalc-mcq-b8-sv-h-2.13-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x ≤ 14/3', false, 'This solves 3x − 6 ≤ 8 but ignores that the argument of the logarithm must be positive, so x must also be greater than 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 < x ≤ 14/3', true, 'Correct: Need 3x − 6 > 0, so x > 2, and log₂(3x − 6) ≤ 3 gives 3x − 6 ≤ 8, so x ≤ 14/3. Together 2 < x ≤ 14/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 < x ≤ 4', false, 'This writes the exponential form as 3x − 6 ≤ 2·3 = 6 instead of 2³ = 8, so the upper bound comes out wrong.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x ≥ 14/3', false, 'This reverses the inequality, but the base 2 is greater than 1, so log₂ is increasing and the direction is kept; the domain x > 2 is also lost.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.13-a-v2', 'mcq', 'solve a logarithmic inequality by combining the exponential rewrite with the domain requirement that the argument is pos (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of log₅(4 − x) < 1?', null, md5('apprecalc-mcq-b8-sv-h-2.13-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1 < x < 4', true, 'Correct: Need 4 − x > 0, so x < 4, and log₅(4 − x) < 1 gives 4 − x < 5, so x > −1. Together −1 < x < 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x > −1', false, 'This solves 4 − x < 5 correctly for x > −1 but ignores that the argument 4 − x must be positive, which requires x < 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x < 4', false, 'This uses only the domain condition 4 − x > 0 and never applies the inequality log₅(4 − x) < 1, which requires 4 − x < 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x < −1', false, 'This forgets to reverse the inequality when moving from 4 − x < 5 to the condition on x: subtracting 4 and multiplying by −1 flips the sign.' from version_ins;
-- apprecalc-mcq-b8-sv-h-2.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b8-sv-h-2.13-a-v3', 'mcq', 'solve a logarithmic inequality by combining the exponential rewrite with the domain requirement that the argument is pos (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the solution set of log_(1/2)(x + 1) ≥ −2?', null, md5('apprecalc-mcq-b8-sv-h-2.13-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x ≥ 3', false, 'This does not reverse the inequality; since the base 1/2 is between 0 and 1, the logarithm is decreasing and the inequality flips to x + 1 ≤ 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1 < x ≤ 3', true, 'Correct: Need x + 1 > 0, so x > −1. Since the base is 1/2, the inequality flips: x + 1 ≤ (1/2)⁻² = 4, so x ≤ 3. Together −1 < x ≤ 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x ≤ 3', false, 'This reverses the inequality correctly to x ≤ 3 but ignores that the argument x + 1 must be positive, so x must be greater than −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1 < x ≤ −3/4', false, 'This computes (1/2)⁻² as 1/4 instead of 4, which gives x + 1 ≤ 1/4; a negative exponent makes the power larger than 1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b8-sv-h-2.12-a-v3','apprecalc-mcq-b8-h-2.12-b','apprecalc-mcq-b8-sv-h-2.12-b-v1','apprecalc-mcq-b8-sv-h-2.12-b-v2','apprecalc-mcq-b8-sv-h-2.12-b-v3','apprecalc-mcq-b8-h-2.13-a','apprecalc-mcq-b8-sv-h-2.13-a-v1','apprecalc-mcq-b8-sv-h-2.13-a-v2','apprecalc-mcq-b8-sv-h-2.13-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b8-sv-h-2.12-a-v3','apprecalc-mcq-b8-h-2.12-b','apprecalc-mcq-b8-sv-h-2.12-b-v1','apprecalc-mcq-b8-sv-h-2.12-b-v2','apprecalc-mcq-b8-sv-h-2.12-b-v3','apprecalc-mcq-b8-h-2.13-a','apprecalc-mcq-b8-sv-h-2.13-a-v1','apprecalc-mcq-b8-sv-h-2.13-a-v2','apprecalc-mcq-b8-sv-h-2.13-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
