begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u3n-012-v2','apcalcab-mcq-u3n-012-v3','apcalcab-mcq-u3n-013-v1','apcalcab-mcq-u3n-013-v2','apcalcab-mcq-u3n-013-v3','apcalcab-mcq-u3n-014-v1','apcalcab-mcq-u3n-014-v2','apcalcab-mcq-u3n-014-v3','apcalcab-mcq-u3n-015-v1','apcalcab-mcq-u3n-015-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u3n-012-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-012-v2', 'mcq', 'Which differentiation rules apply to a product', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student must differentiate g(x) = (3x − 1)⁴ sin x. Which of the following correctly identifies the rules needed?', null, md5('apcalcab-mcq-u3n-012-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Product Rule, with the Chain Rule for (3x − 1)⁴', true, 'g is a product of (3x − 1)⁴ and sin x. The factor (3x − 1)⁴ is a composite function, so its derivative uses the chain rule: 4(3x − 1)³ · 3 = 12(3x − 1)³. Thus g′(x) = 12(3x − 1)³ sin x + (3x − 1)⁴ cos x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Product Rule only, using 4(3x − 1)³ as the derivative of the first factor', false, 'The derivative of (3x − 1)⁴ is 4(3x − 1)³ · 3 = 12(3x − 1)³; the inner derivative 3 is required. Without the chain rule the factor 3 is lost.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Chain Rule only, with sin x as the inner function', false, 'g is a product of two factors, not a function evaluated at sin x, so the chain rule alone cannot differentiate it. The product rule is needed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Quotient Rule, with the Chain Rule for (3x − 1)⁴', false, 'g is a product, not a quotient: no function is divided by another. The quotient rule does not apply, although the chain rule is needed for (3x − 1)⁴.' from version_ins;
-- apcalcab-mcq-u3n-012-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-012-v3', 'mcq', 'How many chain rules for a nested function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following correctly describes how to differentiate y = sin(e^(3x))?', null, md5('apcalcab-mcq-u3n-012-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Product Rule, treating sin and e^(3x) as two factors', false, 'y is sin evaluated at e^(3x), a composition, not a product of sin and e^(3x). The chain rule applies, not the product rule.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Chain Rule twice: sin outside, e^(3x) in the middle, 3x inside', true, 'y is nested three levels deep. The derivative is cos(e^(3x)) · e^(3x) · 3, which applies the chain rule to sin(u) with u = e^(3x), and again to e^(3x) with inner function 3x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Chain Rule once, with sin as the outer function and 3x as the inner function', false, 'The inner function of sin is e^(3x), not 3x. Skipping the e^(3x) layer gives 3cos(3x) instead of 3e^(3x) cos(e^(3x)).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Chain Rule once, with e^(3x) as the inner function and e^(3x) as its derivative', false, 'The derivative of e^(3x) is 3e^(3x), which needs a second chain-rule step for the inner function 3x. Using e^(3x) as its derivative loses the factor 3.' from version_ins;
-- apcalcab-mcq-u3n-013-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-013-v1', 'mcq', 'Quotient rule with a sine composite', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = sin(3x)/x, what is f′(π/3)?', null, md5('apcalcab-mcq-u3n-013-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3/π', false, 'This differentiates sin(3x) as cos(3x), omitting the factor 3: (cos π · (π/3) − 0)/(π²/9) = (−π/3)/(π²/9) = −3/π. The chain rule gives 3cos(3x), so the numerator is −π.' from version_ins
union all select gen_random_uuid(), id, 'B', '−9/π', true, 'f′(x) = (3cos(3x) · x − sin(3x) · 1)/x². At x = π/3: 3cos π · (π/3) − sin π = −π − 0 = −π, and x² = π²/9, so f′(π/3) = −π/(π²/9) = −9/π.' from version_ins
union all select gen_random_uuid(), id, 'C', '−3', false, 'The numerator −π is correct, but the denominator was x = π/3 instead of x² = π²/9: −π/(π/3) = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', '9/π', false, 'This reverses the quotient rule numerator to f · g′ − f′ · g, giving (0 − (−π))/(π²/9) = π/(π²/9) = 9/π. The numerator must be f′ · g − f · g′, giving −9/π.' from version_ins;
-- apcalcab-mcq-u3n-013-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-013-v2', 'mcq', 'Quotient rule with a decaying exponential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = e^(−x)/(x² + 1). Find f′(1).', null, md5('apcalcab-mcq-u3n-013-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/e', false, 'This reverses the quotient rule numerator to f · g′ − f′ · g, giving (2/e + 2/e)/4 = 1/e. The numerator must be f′ · g − f · g′, giving −1/e.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/e', true, 'f′(x) = (−e^(−x)(x² + 1) − e^(−x) · 2x)/(x² + 1)². At x = 1: (−2/e − 2/e)/4 = (−4/e)/4 = −1/e.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This differentiates e^(−x) as e^(−x), missing the chain-rule factor −1: (e^(−1) · 2 − e^(−1) · 2)/4 = 0. The correct derivative is −e^(−x), giving −1/e.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2/e', false, 'The numerator −4/e is correct, but the denominator was x² + 1 = 2 instead of (x² + 1)² = 4: (−4/e)/2 = −2/e.' from version_ins;
-- apcalcab-mcq-u3n-013-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-013-v3', 'mcq', 'Concentration rate using the quotient rule', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The concentration of a medication in a patient''s blood is C(t) = √(4t + 1)/t, where t is the time in hours since the dose, t > 0. What is C′(2)?', null, md5('apcalcab-mcq-u3n-013-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2/3', false, 'This differentiates √(4t + 1) as 1/(2√(4t + 1)), omitting the chain-rule factor 4: ((1/6) · 2 − 3)/4 = (1/3 − 3)/4 = −2/3. The chain rule gives 2/√(4t + 1) = 2/3 at t = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5/12', true, 'C′(t) = ((2/√(4t + 1)) · t − √(4t + 1) · 1)/t². At t = 2: (2/3 · 2 − 3)/4 = (4/3 − 3)/4 = (−5/3)/4 = −5/12.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5/6', false, 'The numerator −5/3 is correct, but the denominator was t = 2 instead of t² = 4: (−5/3)/2 = −5/6.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/12', false, 'This reverses the quotient rule numerator to f · g′ − f′ · g, giving (3 − 4/3)/4 = 5/12. The numerator must be f′ · g − f · g′, giving −5/12.' from version_ins;
-- apcalcab-mcq-u3n-014-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-014-v1', 'mcq', 'Identify the error in a product with a trig composite', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student writes: d/dx[x sin 2x] = sin 2x + x cos 2x. Which statement correctly describes the student''s error?', null, md5('apcalcab-mcq-u3n-014-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The derivative of x should be 0, because x is multiplied by a trigonometric function.', false, 'The derivative of x is 1 whatever it is multiplied by, so the student''s first term sin 2x was correct. The error is the missing factor 2 in the derivative of sin 2x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The derivative of sin 2x is −cos 2x, so the second term should be −x cos 2x.', false, 'The derivative of sin is cos, not −cos (the minus sign belongs to the derivative of cos). The actual error is the missing chain-rule factor 2, giving 2x cos 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The Quotient Rule is required, because sin 2x is not a polynomial.', false, 'The expression is a product, not a quotient, and the quotient rule is for division. The product rule is the correct tool, whether or not a factor is a polynomial.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The product rule is set up correctly, but sin 2x has derivative 2cos 2x, so the second term is 2x cos 2x.', true, 'By the product rule, d/dx[x sin 2x] = (1) sin 2x + x · (2cos 2x) = sin 2x + 2x cos 2x. The student''s first term, sin 2x, was correct; the chain-rule factor 2 was missing from the second term.' from version_ins;
-- apcalcab-mcq-u3n-014-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-014-v2', 'mcq', 'Identify the error in a quotient derivative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student writes: d/dx[(x² + 1)/x] = 2x/1 = 2x. Which statement correctly describes the student''s error?', null, md5('apcalcab-mcq-u3n-014-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It takes the quotient of the derivatives; the quotient rule gives (2x · x − (x² + 1))/x² = (x² − 1)/x².', true, 'The derivative of a quotient is not the quotient of the derivatives. The quotient rule gives ((x²+1)′ · x − (x² + 1) · x′)/x² = (2x · x − (x² + 1))/x² = (x² − 1)/x².' from version_ins
union all select gen_random_uuid(), id, 'B', 'The answer should be negative because x is in the denominator, giving −2x.', false, 'Placing a function in the denominator does not simply change the sign of a derivative. The quotient rule gives (x² − 1)/x², which is not −2x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The derivative of x² + 1 is 2x + 1, so the result should be (2x + 1)/1.', false, 'The derivative of x² + 1 is 2x, since the derivative of the constant 1 is 0. The student''s numerator derivative 2x was correct; the error was dividing derivatives instead of using the quotient rule.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The derivative of the denominator x is 0, so the result should be 2x/x² = 2/x.', false, 'The derivative of x is 1, not 0. Also the quotient rule requires the term (x² + 1) · 1 in the numerator, which gives (x² − 1)/x².' from version_ins;
-- apcalcab-mcq-u3n-014-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-014-v3', 'mcq', 'Identify the error in a chain rule derivative', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student writes: d/dx[sin(x²)] = cos(2x). Which statement correctly describes the student''s error?', null, md5('apcalcab-mcq-u3n-014-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The derivative of sin should be −cos, so the answer should be −cos(2x).', false, 'The derivative of sin u is cos u, not −cos u. The student''s outside factor was correct; the error is placing the derivative 2x inside the cosine instead of multiplying by it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The product rule is needed on sin and x², giving x² cos x + 2x sin x.', false, 'sin(x²) is a composition (sin evaluated at x²), not a product of sin and x², so the product rule does not apply. The chain rule gives 2x cos(x²).' from version_ins
union all select gen_random_uuid(), id, 'C', 'It replaces x² by its derivative inside the cosine; the chain rule gives 2x cos(x²).', true, 'The inside function x² must stay inside the cosine, and its derivative 2x is multiplied outside: d/dx[sin(x²)] = cos(x²) · 2x = 2x cos(x²). The student wrote cos(2x) instead.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The inside function should be left alone, so the derivative is cos(x²).', false, 'The chain rule requires multiplying by the derivative of the inside function, 2x. Without it the derivative is cos(x²), which is missing a factor of 2x.' from version_ins;
-- apcalcab-mcq-u3n-015-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-015-v1', 'mcq', 'Second derivative of a sine composite', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = sin(x²), what is f″(√(π/6))?', null, md5('apcalcab-mcq-u3n-015-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '√3 − π/3', true, 'f′(x) = 2x cos(x²). By the product rule, f″(x) = 2cos(x²) + 2x(−sin(x²))(2x) = 2cos(x²) − 4x² sin(x²). At x² = π/6: 2(√3/2) − 4(π/6)(1/2) = √3 − π/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−π/3', false, 'This differentiates only the factor cos(x²) and treats 2x as constant: −4x² sin(x²) = −4(π/6)(1/2) = −π/3. The product rule also needs the term 2cos(x²) = √3.' from version_ins
union all select gen_random_uuid(), id, 'C', '√3 + π/3', false, 'This differentiates cos(x²) as +sin(x²) · 2x, with the wrong sign: 2cos(x²) + 4x² sin(x²) = √3 + π/3. The derivative of cos u is −sin u · u′, giving √3 − π/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '√3', false, 'This keeps only the term 2cos(x²) = √3 and omits −4x² sin(x²), the term from differentiating cos(x²). Both terms together give √3 − π/3.' from version_ins;
-- apcalcab-mcq-u3n-015-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u3n-015-v2', 'mcq', 'Second derivative of a logarithm', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = ln(x² + 1), what is f″(3)?', null, md5('apcalcab-mcq-u3n-015-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/25', false, 'This reverses the quotient rule numerator to f · g′ − f′ · g: (2x · 2x − 2(x² + 1)) = 36 − 20 = 16, so 16/100 = 4/25. The numerator must be f′ · g − f · g′, giving −16/100 = −4/25.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4/25', true, 'f′(x) = 2x/(x² + 1). By the quotient rule, f″(x) = (2(x² + 1) − 2x · 2x)/(x² + 1)² = (2 − 2x²)/(x² + 1)². At x = 3: (2 − 18)/100 = −16/100 = −4/25.' from version_ins
union all select gen_random_uuid(), id, 'C', '−8/5', false, 'The numerator −16 is correct, but the denominator was x² + 1 = 10 instead of (x² + 1)² = 100: −16/10 = −8/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/5', false, 'This differentiates only the numerator 2x and treats x² + 1 as constant: 2/(x² + 1) = 2/10 = 1/5. The quotient rule also needs the term from differentiating the denominator.' from version_ins;
commit;
