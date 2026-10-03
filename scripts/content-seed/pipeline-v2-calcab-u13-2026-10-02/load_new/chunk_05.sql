begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-u2n-007-v2','apcalcab-mcq-u2n-007-v3','apcalcab-mcq-u2n-008-v1','apcalcab-mcq-u2n-008-v2','apcalcab-mcq-u2n-008-v3','apcalcab-mcq-u2n-009-v1','apcalcab-mcq-u2n-009-v2','apcalcab-mcq-u2n-009-v3','apcalcab-mcq-u2n-010-v1','apcalcab-mcq-u2n-010-v2','apcalcab-mcq-u2n-010-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apcalcab-mcq-u2n-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-007-v2', 'mcq', 'Horizontal tangent of x^(3/2) − 6x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, the graph of y = x^(3/2) − 6x has a horizontal tangent line at which value of x?', null, md5('apcalcab-mcq-u2n-007-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 81', false, 'This solves (3/2)√x = 6 by multiplying 6 by 3/2 instead of dividing: √x = 9, so x = 81. Dividing gives √x = 4, so x = 16.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 16', true, 'dy/dx = (3/2)x^(1/2) − 6. Setting this to 0 gives (3/2)√x = 6, so √x = 4 and x = 16.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 4', false, 'This correctly finds √x = 4 but reports x = 4 without squaring. Since √x = 4, x = 4² = 16.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 36', false, 'This differentiates x^(3/2) as x^(1/2) (missing the factor 3/2). Then √x = 6 gives x = 36, but the correct derivative is (3/2)√x = 6, which gives x = 16.' from version_ins;
-- apcalcab-mcq-u2n-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-007-v3', 'mcq', 'Horizontal tangent of x^(5/2) − 5x^(3/2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, let f(x) = x^(5/2) − 5x^(3/2). At what value of x is the tangent line to the graph of f horizontal?', null, md5('apcalcab-mcq-u2n-007-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 15/2', false, 'This differentiates x^(5/2) as x^(3/2) (missing the factor 5/2). Then x^(3/2) = (15/2)x^(1/2) gives x = 15/2, but the correct first term is (5/2)x^(3/2), which gives x = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 5', false, 'This solves f(x) = 0 (x^(5/2) = 5x^(3/2) gives x = 5) rather than f′(x) = 0. A horizontal tangent requires f′(x) = 0, which gives x = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 3', true, 'f′(x) = (5/2)x^(3/2) − (15/2)x^(1/2). Setting this to 0 and dividing by (5/2)x^(1/2) gives x − 3 = 0, so x = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 2', false, 'This differentiates 5x^(3/2) as 5x^(1/2) (missing the factor 3/2). Then (5/2)x^(3/2) = 5x^(1/2) gives x = 2, but the correct term is (15/2)x^(1/2), which gives x = 3.' from version_ins;
-- apcalcab-mcq-u2n-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-008-v1', 'mcq', 'Linear combination with a quadratic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(3) = 2, and let h(x) = 5x² − 4f(x). What is h′(3)?', null, md5('apcalcab-mcq-u2n-008-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28', false, 'This drops the constant multiple 4 on f, giving 30 − 2 = 28. The constant multiple rule gives 4f′(3) = 8, so h′(3) = 30 − 8 = 22.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'This differentiates 5x² as 5x, giving 15 − 8 = 7. The power rule gives 10x, so the first term is 30 and h′(3) = 30 − 8 = 22.' from version_ins
union all select gen_random_uuid(), id, 'C', '22', true, 'h′(x) = 10x − 4f′(x), so h′(3) = 10(3) − 4(2) = 30 − 8 = 22.' from version_ins
union all select gen_random_uuid(), id, 'D', '38', false, 'This adds instead of subtracting, 30 + 4(2) = 38. The difference rule gives 10x − 4f′(x), so h′(3) = 30 − 8 = 22.' from version_ins;
-- apcalcab-mcq-u2n-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-008-v2', 'mcq', 'Half a function plus a line', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(−1) = −8, and let p(x) = (1/2)f(x) + 6x − 7. What is p′(−1)?', null, md5('apcalcab-mcq-u2n-008-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2', false, 'This drops the constant multiple 1/2 on f, giving −8 + 6 = −2. The constant multiple rule gives (1/2)f′(−1) = −4, so p′(−1) = −4 + 6 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−10', false, 'This differentiates 6x as 6x and evaluates it at −1, giving −4 + 6(−1) = −10. The derivative of 6x is the constant 6, so p′(−1) = −4 + 6 = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5', false, 'This differentiates the constant −7 as −7 instead of 0, giving −4 + 6 − 7 = −5. The derivative of a constant is 0, so p′(−1) = −4 + 6 = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'p′(x) = (1/2)f′(x) + 6, so p′(−1) = (1/2)(−8) + 6 = −4 + 6 = 2.' from version_ins;
-- apcalcab-mcq-u2n-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-008-v3', 'mcq', 'Cubic minus a multiple of f', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(4) = −2, and let g(x) = x³ − 2f(x). What is g′(4)?', null, md5('apcalcab-mcq-u2n-008-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '44', false, 'This adds instead of subtracting, 48 + 2(−2) = 44. The difference rule gives 3x² − 2f′(x), so g′(4) = 48 + 4 = 52.' from version_ins
union all select gen_random_uuid(), id, 'B', '16', false, 'This differentiates x³ as 3x, giving 3(4) = 12, and then 12 + 4 = 16. The power rule gives 3x² = 48, so g′(4) = 48 + 4 = 52.' from version_ins
union all select gen_random_uuid(), id, 'C', '50', false, 'This drops the constant multiple 2 on f, giving 48 − (−2) = 50. The constant multiple rule gives 2f′(4) = −4, so g′(4) = 48 − (−4) = 52.' from version_ins
union all select gen_random_uuid(), id, 'D', '52', true, 'g′(x) = 3x² − 2f′(x), so g′(4) = 3(16) − 2(−2) = 48 + 4 = 52.' from version_ins;
-- apcalcab-mcq-u2n-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-009-v1', 'mcq', 'Derivative of e^x and sin x at π', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'If f(x) = 2e^x + 6 sin x, what is f′(π)?', null, md5('apcalcab-mcq-u2n-009-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2πe^(π − 1) − 6', false, 'This treats e^x like a power function, 2·π·e^(π − 1), while getting the sine term right (6cos π = −6). The derivative of e^x is e^x, so the first term is 2e^π and f′(π) = 2e^π − 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '2e^π − 6', true, 'f′(x) = 2e^x + 6cos x, so f′(π) = 2e^π + 6cos π = 2e^π − 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '2e^π + 6', false, 'This uses (sin x)′ = −cos x, giving 2e^π − 6(−1) = 2e^π + 6. The derivative of sin x is cos x, so the second term is 6cos π = −6.' from version_ins
union all select gen_random_uuid(), id, 'D', '2e^π', false, 'This uses (sin x)′ = sin x, so the second term is 6 sin π = 0. The derivative of sin x is cos x, so that term contributes 6cos π = −6 and f′(π) = 2e^π − 6.' from version_ins;
-- apcalcab-mcq-u2n-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-009-v2', 'mcq', 'Derivative of a sin x and cos x combination', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 4 sin x − 3 cos x. What is g′(π/3)?', null, md5('apcalcab-mcq-u2n-009-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 − 3√3/2', false, 'This uses (cos x)′ = sin x, so −3cos x becomes −3 sin x. The derivative is −3(−sin x) = +3 sin x, giving 2 + 3√3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2√3 − 3/2', false, 'This evaluates the original function, g(π/3) = 4(√3/2) − 3(1/2) = 2√3 − 3/2, instead of the derivative. The derivative is g′(π/3) = 2 + 3√3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2 + 3√3/2', false, 'This uses (sin x)′ = −cos x, so 4 sin x becomes −4cos x. The derivative of sin x is cos x, so the first term is +4cos(π/3) = 2, giving 2 + 3√3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 + 3√3/2', true, 'g′(x) = 4cos x + 3 sin x, so g′(π/3) = 4(1/2) + 3(√3/2) = 2 + 3√3/2.' from version_ins;
-- apcalcab-mcq-u2n-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-009-v3', 'mcq', 'Derivative of e^x and ln x at 2', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 3e^x − ln x for x > 0. What is f′(2)?', null, md5('apcalcab-mcq-u2n-009-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3e² + 1/2', false, 'This drops the minus sign on the ln x term, using +1/x. The derivative of −ln x is −1/x, so f′(2) = 3e² − 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '6e − 1/2', false, 'This treats e^x like a power function, 3·2·e^(2−1) = 6e, while getting the ln x term right (−1/2). The derivative of e^x is e^x, so the first term is 3e² and f′(2) = 3e² − 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '3e² + 1/4', false, 'This differentiates ln x as 1/x and then differentiates 1/x again to get −1/x², so −ln x contributes +1/x² = 1/4. The derivative of ln x is just 1/x, so −ln x contributes −1/2 and f′(2) = 3e² − 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '3e² − 1/2', true, 'f′(x) = 3e^x − 1/x, so f′(2) = 3e² − 1/2.' from version_ins;
-- apcalcab-mcq-u2n-010-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-010-v1', 'mcq', 'Derivative with ln x and 1/x²', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 4 ln x + 3/x² for x > 0. What is g′(2)?', null, md5('apcalcab-mcq-u2n-010-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', false, 'This differentiates 3x⁻² as −6x⁻² without lowering the exponent, giving 4/2 − 6/4 = 1/2. The power rule gives −6x⁻³ = −6/8 at x = 2, so g′(2) = 5/4.' from version_ins
union all select gen_random_uuid(), id, 'B', '11/4', false, 'This loses the negative sign on the derivative of 3x⁻², using +6/x³, giving 4/2 + 6/8 = 11/4. The correct term is −6/x³ = −3/4, so g′(2) = 5/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '13/8', false, 'This differentiates 3x⁻² as −3x⁻³ (keeping the coefficient 3 and not multiplying by the exponent −2), giving 4/2 − 3/8 = 13/8. The correct term is −6/x³ = −3/4, so g′(2) = 5/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '5/4', true, 'g′(x) = 4/x − 6/x³ (since 3/x² = 3x⁻² has derivative −6x⁻³). Then g′(2) = 4/2 − 6/8 = 2 − 3/4 = 5/4.' from version_ins;
-- apcalcab-mcq-u2n-010-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-010-v2', 'mcq', 'Derivative with 3/x and ln x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = 3/x − 4 ln x for x > 0. What is h′(3)?', null, md5('apcalcab-mcq-u2n-010-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4/3', false, 'This treats 3/x as a constant with derivative 0, leaving only −4/x = −4/3. The term 3/x = 3x⁻¹ contributes −3/x² = −1/3, so h′(3) = −5/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, 'This loses the negative sign on the derivative of 3x⁻¹, using +3/x² = 1/3, giving 1/3 − 4/3 = −1. The correct term is −3/x² = −1/3, so h′(3) = −5/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '−5/3', true, 'h′(x) = −3/x² − 4/x (since 3/x = 3x⁻¹ has derivative −3x⁻²). Then h′(3) = −3/9 − 4/3 = −1/3 − 4/3 = −5/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−7/3', false, 'This differentiates 3x⁻¹ as −3x⁻¹ without lowering the exponent, giving −3/3 − 4/3 = −7/3. The power rule gives −3x⁻² = −3/9 at x = 3, so h′(3) = −5/3.' from version_ins;
-- apcalcab-mcq-u2n-010-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-u2n-010-v3', 'mcq', 'Derivative with e^x and 6/x', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let p(x) = e^x + 6/x for x > 0. What is p′(2)?', null, md5('apcalcab-mcq-u2n-010-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'e² + 3/2', false, 'This loses the negative sign on the derivative of 6x⁻¹, using +6/x² = 3/2. The correct term is −6/x² = −3/2, so p′(2) = e² − 3/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'e² − 3/2', true, 'p′(x) = e^x − 6/x² (since 6/x = 6x⁻¹ has derivative −6x⁻²). Then p′(2) = e² − 6/4 = e² − 3/2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'e² − 3', false, 'This differentiates 6x⁻¹ as −6x⁻¹ without lowering the exponent, giving −6/2 = −3. The power rule gives −6x⁻² = −6/4 at x = 2, so p′(2) = e² − 3/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '2e − 3/2', false, 'This treats e^x like a power function, x·e^(x−1) = 2e at x = 2, while getting the 6/x term right (−3/2). The derivative of e^x is e^x, so the first term is e² and p′(2) = e² − 3/2.' from version_ins;
commit;
