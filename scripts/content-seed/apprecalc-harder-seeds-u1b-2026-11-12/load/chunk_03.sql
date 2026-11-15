begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.10-a-v2','apprecalc-mcq-b9-sv-h-1.10-a-v3','apprecalc-mcq-b9-h-1.10-b','apprecalc-mcq-b9-sv-h-1.10-b-v1','apprecalc-mcq-b9-sv-h-1.10-b-v2','apprecalc-mcq-b9-sv-h-1.10-b-v3','apprecalc-mcq-b9-h-1.11-a','apprecalc-mcq-b9-sv-h-1.11-a-v1','apprecalc-mcq-b9-sv-h-1.11-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-sv-h-1.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.10-a-v2', 'mcq', 'locate the hole of a rational function given in expanded form by factoring, cancelling the common factor, and finding th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (x² + 2x − 3)/(x² − x − 12). Which ordered pair is the location of the hole in the graph of f?', null, md5('apprecalc-mcq-b9-sv-h-1.10-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(−3, 0)', false, 'This notices the hole at x = −3 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x − 1) is not zero at x = −3; the height is 4/7.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−3, 7/4)', false, 'This evaluates the reduced function upside down, using (−3 − 4)/(−3 − 1). The numerator of the reduced function is (x − 1) and the denominator is (x − 4), so the height is 4/7.' from version_ins
union all select gen_random_uuid(), id, 'C', '(4, 4/7)', false, 'This puts the hole at the zero of the leftover denominator factor, x = 4. That factor is not cancelled, so x = 4 is a vertical asymptote; the hole is where the common factor (x + 3) is zero, at x = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', '(−3, 4/7)', true, 'Correct: Factoring gives f(x) = (x + 3)(x − 1)/[(x + 3)(x − 4)], so the common factor (x + 3) produces a hole at x = −3. The reduced function (x − 1)/(x − 4) at x = −3 equals 4/7.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.10-a-v3', 'mcq', 'locate the hole of a rational function given in expanded form by factoring, cancelling the common factor, and finding th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider f(x) = (x² − 2x − 8)/(x² − 11x + 28). Which ordered pair is the location of the hole in the graph of f?', null, md5('apprecalc-mcq-b9-sv-h-1.10-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(4, 0)', false, 'This notices the hole at x = 4 but reads its height as 0 because the numerator factor is zero there. After cancelling, the remaining numerator (x + 2) is not zero at x = 4; the height is −2.' from version_ins
union all select gen_random_uuid(), id, 'B', '(4, −2)', true, 'Correct: Factoring gives f(x) = (x − 4)(x + 2)/[(x − 4)(x − 7)], so the common factor (x − 4) produces a hole at x = 4. The reduced function (x + 2)/(x − 7) at x = 4 equals −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '(4, −1/2)', false, 'This evaluates the reduced function upside down, using (4 − 7)/(4 − (−2)). The numerator of the reduced function is (x + 2) and the denominator is (x − 7), so the height is −2.' from version_ins
union all select gen_random_uuid(), id, 'D', '(7, −2)', false, 'This puts the hole at the zero of the leftover denominator factor, x = 7. That factor is not cancelled, so x = 7 is a vertical asymptote; the hole is where the common factor (x − 4) is zero, at x = 4.' from version_ins;
-- apprecalc-mcq-b9-h-1.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.10-b', 'mcq', 'choose the rule of a rational function from its hole, asymptote and intercept, using the hole height to set the leading ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rational function f has a hole at (3, −8), a vertical asymptote at x = 4, and exactly one x-intercept, at x = −1. It has no other features. Which rule could define f?', null, md5('apprecalc-mcq-b9-h-1.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = −8(x − 3)(x + 1) / [(x − 3)(x − 4)]', false, 'This sets the leading constant equal to the hole height −8. The hole height is that constant times (3 − (−1))/(3 − 4), so the constant needed is 2, not −8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = 2(x − 3)(x + 1) / [(x − 3)(x − 4)]', true, 'Correct: The factor (x − 3) in both numerator and denominator makes the hole at x = 3, (x + 1) gives the intercept, and (x − 4) gives the asymptote. The hole height is 2(3 − (−1))/(3 − 4) = −8, which fixes the leading constant at 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = 2(x + 1) / (x − 4)', false, 'This drops the common factor (x − 3). Without it the graph has no hole at x = 3, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = 2(x − 3)(x + 1) / [(x − 3)(x + 4)]', false, 'This writes the asymptote factor as (x + 4), which puts the vertical asymptote at x = −4. An asymptote at x = 4 needs the factor (x − 4), and the cancelled factor (x − 3) still has to appear above and below.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.10-b-v1', 'mcq', 'choose the rule of a rational function from its hole, asymptote and intercept, using the hole height to set the leading  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rational function f has a hole at (2, 3), a vertical asymptote at x = −2, and exactly one x-intercept, at x = 6. It has no other features. Which rule could define f?', null, md5('apprecalc-mcq-b9-sv-h-1.10-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = −3(x − 2)(x − 6) / [(x − 2)(x + 2)]', true, 'Correct: The factor (x − 2) in both numerator and denominator makes the hole at x = 2, (x − 6) gives the intercept, and (x + 2) gives the asymptote. The hole height is −3(2 − 6)/(2 − (−2)) = 3, which fixes the leading constant at −3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = 3(x − 2)(x − 6) / [(x − 2)(x + 2)]', false, 'This sets the leading constant equal to the hole height 3. The hole height is that constant times (2 − 6)/(2 − (−2)), so the constant needed is −3, not 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = −3(x − 6) / (x + 2)', false, 'This drops the common factor (x − 2). Without it the graph has no hole at x = 2, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = −3(x − 2)(x − 6) / [(x − 2)(x − 2)]', false, 'This writes the asymptote factor as (x − 2), which puts the vertical asymptote at x = 2. An asymptote at x = −2 needs the factor (x + 2), and the cancelled factor (x − 2) still has to appear above and below.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.10-b-v2', 'mcq', 'choose the rule of a rational function from its hole, asymptote and intercept, using the hole height to set the leading  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rational function f has a hole at (−1, 2), a vertical asymptote at x = 5, and exactly one x-intercept, at x = 2. It has no other features. Which rule could define f?', null, md5('apprecalc-mcq-b9-sv-h-1.10-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = 2(x + 1)(x − 2) / [(x + 1)(x − 5)]', false, 'This sets the leading constant equal to the hole height 2. The hole height is that constant times (−1 − 2)/(−1 − 5), so the constant needed is 4, not 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = 4(x + 1)(x − 2) / [(x + 1)(x − 5)]', true, 'Correct: The factor (x + 1) in both numerator and denominator makes the hole at x = −1, (x − 2) gives the intercept, and (x − 5) gives the asymptote. The hole height is 4(−1 − 2)/(−1 − 5) = 2, which fixes the leading constant at 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = 4(x − 2) / (x − 5)', false, 'This drops the common factor (x + 1). Without it the graph has no hole at x = −1, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = 4(x + 1)(x − 2) / [(x + 1)(x + 5)]', false, 'This writes the asymptote factor as (x + 5), which puts the vertical asymptote at x = −5. An asymptote at x = 5 needs the factor (x − 5), and the cancelled factor (x + 1) still has to appear above and below.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.10-b-v3', 'mcq', 'choose the rule of a rational function from its hole, asymptote and intercept, using the hole height to set the leading  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rational function f has a hole at (5, 21/4), a vertical asymptote at x = 1, and exactly one x-intercept, at x = −2. It has no other features. Which rule could define f?', null, md5('apprecalc-mcq-b9-sv-h-1.10-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'f(x) = (21/4)(x − 5)(x + 2) / [(x − 5)(x − 1)]', false, 'This sets the leading constant equal to the hole height 21/4. The hole height is that constant times (5 − (−2))/(5 − 1), so the constant needed is 3, not 21/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'f(x) = 3(x + 2) / (x − 1)', false, 'This drops the common factor (x − 5). Without it the graph has no hole at x = 5, so it does not satisfy the stated hole; the factor must appear in both numerator and denominator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'f(x) = 3(x − 5)(x + 2) / [(x − 5)(x − 1)]', true, 'Correct: The factor (x − 5) in both numerator and denominator makes the hole at x = 5, (x + 2) gives the intercept, and (x − 1) gives the asymptote. The hole height is 3(5 − (−2))/(5 − 1) = 21/4, which fixes the leading constant at 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'f(x) = 3(x − 5)(x + 2) / [(x − 5)(x + 1)]', false, 'This writes the asymptote factor as (x + 1), which puts the vertical asymptote at x = −1. An asymptote at x = 1 needs the factor (x − 1), and the cancelled factor (x − 5) still has to appear above and below.' from version_ins;
-- apprecalc-mcq-b9-h-1.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.11-a', 'mcq', 'work backward from an equivalent quotient-plus-remainder form to the polynomial numerator and combine its coefficients.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x ≠ 2, the expression (x² + bx + c)/(x − 2) is equivalent to x + 3 + 4/(x − 2), where b and c are constants. What is the value of b + c?', null, md5('apprecalc-mcq-b9-h-1.11-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15', false, 'This expands (x + 3)(x + 2) + 4, using the wrong sign on the divisor''s constant. The divisor is (x − 2), so the product to expand is (x + 3)(x − 2) + 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', true, 'Correct: Multiply by (x − 2): x² + bx + c = (x + 3)(x − 2) + 4 = x² + x − 2. So b = 1, c = −2, and b + c = −1.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5', false, 'This multiplies the quotient by the divisor but leaves out the remainder term 4. The remainder over (x − 2) is part of the expression, so it must be added to the constant term, which gives c = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', '−9', false, 'This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains + 4/(x − 2), the product must be adjusted by 4, making c = −2.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.11-a-v1', 'mcq', 'work backward from an equivalent quotient-plus-remainder form to the polynomial numerator and combine its coefficients. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x ≠ 3, the expression (x² + bx + c)/(x − 3) is equivalent to x − 2 + 5/(x − 3), where b and c are constants. What is the value of b + c?', null, md5('apprecalc-mcq-b9-sv-h-1.11-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This expands (x − 2)(x + 3) + 5, using the wrong sign on the divisor''s constant. The divisor is (x − 3), so the product to expand is (x − 2)(x − 3) + 5.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This multiplies the quotient by the divisor but leaves out the remainder term 5. The remainder over (x − 3) is part of the expression, so it must be added to the constant term, which gives c = 11.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4', false, 'This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains + 5/(x − 3), the product must be adjusted by 5, making c = 11.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', true, 'Correct: Multiply by (x − 3): x² + bx + c = (x − 2)(x − 3) + 5 = x² − 5x + 11. So b = −5, c = 11, and b + c = 6.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.11-a-v2', 'mcq', 'work backward from an equivalent quotient-plus-remainder form to the polynomial numerator and combine its coefficients. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x ≠ −1, the expression (x² + bx + c)/(x + 1) is equivalent to x + 4 + 7/(x + 1), where b and c are constants. What is the value of b + c?', null, md5('apprecalc-mcq-b9-sv-h-1.11-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16', true, 'Correct: Multiply by (x + 1): x² + bx + c = (x + 4)(x + 1) + 7 = x² + 5x + 11. So b = 5, c = 11, and b + c = 16.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'This expands (x + 4)(x − 1) + 7, using the wrong sign on the divisor''s constant. The divisor is (x + 1), so the product to expand is (x + 4)(x + 1) + 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '9', false, 'This multiplies the quotient by the divisor but leaves out the remainder term 7. The remainder over (x + 1) is part of the expression, so it must be added to the constant term, which gives c = 11.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'This applies the opposite sign to the remainder term when clearing the fraction. Since the expression contains + 7/(x + 1), the product must be adjusted by 7, making c = 11.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.10-a-v2','apprecalc-mcq-b9-sv-h-1.10-a-v3','apprecalc-mcq-b9-h-1.10-b','apprecalc-mcq-b9-sv-h-1.10-b-v1','apprecalc-mcq-b9-sv-h-1.10-b-v2','apprecalc-mcq-b9-sv-h-1.10-b-v3','apprecalc-mcq-b9-h-1.11-a','apprecalc-mcq-b9-sv-h-1.11-a-v1','apprecalc-mcq-b9-sv-h-1.11-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-sv-h-1.10-a-v2','apprecalc-mcq-b9-sv-h-1.10-a-v3','apprecalc-mcq-b9-h-1.10-b','apprecalc-mcq-b9-sv-h-1.10-b-v1','apprecalc-mcq-b9-sv-h-1.10-b-v2','apprecalc-mcq-b9-sv-h-1.10-b-v3','apprecalc-mcq-b9-h-1.11-a','apprecalc-mcq-b9-sv-h-1.11-a-v1','apprecalc-mcq-b9-sv-h-1.11-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
