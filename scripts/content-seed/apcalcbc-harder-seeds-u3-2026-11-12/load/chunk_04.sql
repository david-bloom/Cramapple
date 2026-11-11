begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.4-a-v3','apcalcbc-mcq-b2-h-3.4-b','apcalcbc-mcq-b2-sv-h-3.4-b-v1','apcalcbc-mcq-b2-sv-h-3.4-b-v2','apcalcbc-mcq-b2-sv-h-3.4-b-v3','apcalcbc-mcq-b2-h-3.5-a','apcalcbc-mcq-b2-sv-h-3.5-a-v1','apcalcbc-mcq-b2-sv-h-3.5-a-v2','apcalcbc-mcq-b2-sv-h-3.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b2-sv-h-3.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.4-a-v3', 'mcq', 'differentiate an inverse trigonometric function of a reciprocal or quadratic on a restricted domain, keeping the correct (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x < −2, let f(x) = cos⁻¹(2/x). What is f′(−4)?', null, md5('apcalcbc-mcq-b2-sv-h-3.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−√3/12', false, 'This applies 2/(x√(x² − 4)), which holds for x > 2; at x = −4 the correct form has |x|, so the sign is wrong.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2/√3', false, 'This omits the chain-rule factor −2/x² from the inner function 2/x and keeps only −1/√(1 − 1/4).' from version_ins
union all select gen_random_uuid(), id, 'C', '2/√3', false, 'This omits the chain-rule factor and also uses the derivative of sin⁻¹ rather than the negative derivative of cos⁻¹.' from version_ins
union all select gen_random_uuid(), id, 'D', '√3/12', true, 'Correct: f′(x) = [−1/√(1 − 4/x²)]·(−2/x²). At x = −4: [1/√(3/4)]·(2/16) = (2/√3)(1/8) = 1/(4√3) = √3/12.' from version_ins;
-- apcalcbc-mcq-b2-h-3.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.4-b', 'mcq', 'find the rate of change of an angle defined by an inverse trigonometric function of a changing length, with the correct ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A camera is 40 meters from the base of a launch pad and films a rocket rising vertically. When the rocket is h meters high, the camera''s angle of elevation is θ = tan⁻¹(h/40). At the moment h = 30 meters, the rocket is rising at 12 meters per second. How fast is θ changing at that moment?', null, md5('apcalcbc-mcq-b2-h-3.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.192 radians per second', true, 'Correct: dθ/dt = [1/(1 + (h/40)²)]·(1/40)·dh/dt = [1/(1 + 9/16)]·(12/40) = (16/25)(0.3) = 0.192 radians per second.' from version_ins
union all select gen_random_uuid(), id, 'B', '7.68 radians per second', false, 'This omits the chain-rule factor 1/40 from the argument h/40, so the rate of h is used as if the argument were h itself.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.3 radians per second', false, 'This uses only the inner derivative (12/40) and leaves out the factor 1/(1 + (h/40)²) from the arctangent derivative.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0133 radians per second', false, 'This applies the arctangent derivative to h instead of h/40, giving 12/(1 + 900) and ignoring the scale factor 40.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.4-b-v1', 'mcq', 'find the rate of change of an angle defined by an inverse trigonometric function of a changing length, with the correct  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 13-meter ladder leans against a wall. The angle θ between the ladder and the ground satisfies θ = cos⁻¹(x/13), where x is the distance in meters from the wall to the foot of the ladder. The foot slides away from the wall at 0.5 meters per second. How fast is θ changing when x = 5 meters?', null, md5('apcalcbc-mcq-b2-sv-h-3.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/24 radians per second', false, 'This drops the minus sign from the derivative of cos⁻¹; the angle decreases as the foot slides out.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1/24 radians per second', true, 'Correct: dθ/dt = −[1/√(1 − (x/13)²)]·(1/13)·dx/dt = −[1/√(144/169)]·(1/13)(0.5) = −(13/12)(1/26) = −1/24 radians per second.' from version_ins
union all select gen_random_uuid(), id, 'C', '−13/24 radians per second', false, 'This omits the chain-rule factor 1/13 from the argument x/13.' from version_ins
union all select gen_random_uuid(), id, 'D', '−13/288 radians per second', false, 'This leaves out the square root and uses 1/(1 − (x/13)²) in place of 1/√(1 − (x/13)²).' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.4-b-v2', 'mcq', 'find the rate of change of an angle defined by an inverse trigonometric function of a changing length, with the correct  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An observer watches a plane fly horizontally at an altitude of 3 kilometers. The angle of elevation is θ = tan⁻¹(3/x), where x is the horizontal distance in kilometers from the observer to the plane. The plane is approaching at 400 kilometers per hour, so dx/dt = −400. How fast is θ changing when x = 4 kilometers?', null, md5('apcalcbc-mcq-b2-sv-h-3.4-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−48 radians per hour', false, 'This has the correct size but the wrong sign: the plane is approaching, so the angle of elevation is increasing.' from version_ins
union all select gen_random_uuid(), id, 'B', '75 radians per hour', false, 'This keeps the chain factors but drops 1/(1 + (3/x)²) = 16/25 from the arctangent derivative.' from version_ins
union all select gen_random_uuid(), id, 'C', '−256 radians per hour', false, 'This omits the chain-rule factor −3/x² from the inner function 3/x, using only 1/(1 + (3/x)²)·dx/dt.' from version_ins
union all select gen_random_uuid(), id, 'D', '48 radians per hour', true, 'Correct: dθ/dt = [1/(1 + (3/x)²)]·(−3/x²)·dx/dt = (16/25)(−3/16)(−400) = (−3/25)(−400) = 48 radians per hour.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.4-b-v3', 'mcq', 'find the rate of change of an angle defined by an inverse trigonometric function of a changing length, with the correct  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A kite is flown on a 100-meter string held taut at ground level. The angle θ between the string and the ground satisfies θ = sin⁻¹(h/100), where h is the kite''s height in meters. The kite is rising at 2 meters per second. How fast is θ changing when h = 60 meters?', null, md5('apcalcbc-mcq-b2-sv-h-3.4-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.5 radians per second', false, 'This omits the chain-rule factor 1/100 from the argument h/100, so dh/dt = 2 is used unscaled.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.03125 radians per second', false, 'This leaves out the square root and uses 1/(1 − (h/100)²) in place of 1/√(1 − (h/100)²).' from version_ins
union all select gen_random_uuid(), id, 'C', '0.025 radians per second', true, 'Correct: dθ/dt = [1/√(1 − (h/100)²)]·(1/100)·dh/dt = (1/0.8)(0.02) = 0.025 radians per second.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.02 radians per second', false, 'This uses only the inner derivative (2/100) and leaves out the factor 1/√(1 − (h/100)²) from the arcsine derivative.' from version_ins;
-- apcalcbc-mcq-b2-h-3.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.5-a', 'mcq', 'recognize that a variable base with a variable exponent needs logarithmic differentiation, and apply it with the product', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, which expression gives the derivative of y = x³ˣ?', null, md5('apcalcbc-mcq-b2-h-3.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3x·x³ˣ⁻¹', false, 'This applies the power rule as if the exponent 3x were a constant, but here both the base and the exponent depend on x.' from version_ins
union all select gen_random_uuid(), id, 'B', '3x³ˣ·ln x', false, 'This applies the rule for aˣ with a constant base, which gives only part of the answer; it omits the term from differentiating the base x.' from version_ins
union all select gen_random_uuid(), id, 'C', '3x³ˣ/x', false, 'This differentiates ln y = 3x·ln x as 3·(1/x), treating the factor 3x as constant and skipping the product rule.' from version_ins
union all select gen_random_uuid(), id, 'D', '3x³ˣ(ln x + 1)', true, 'Correct: ln y = 3x·ln x, so y′/y = 3 ln x + 3x·(1/x) = 3(ln x + 1), and y′ = 3x³ˣ(ln x + 1). At x = 2 this is 192(ln 2 + 1), which differs from each other choice.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.5-a-v1', 'mcq', 'recognize that a variable base with a variable exponent needs logarithmic differentiation, and apply it with the product (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 1, which expression gives the derivative of y = (ln x)ˣ?', null, md5('apcalcbc-mcq-b2-sv-h-3.5-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(ln x)ˣ⁻¹', false, 'This applies the power rule as if the exponent x were constant; the exponent depends on x, so logarithmic differentiation is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', '(ln x)ˣ·ln(ln x)', false, 'This applies the rule for aˣ with a constant base, omitting the term that comes from differentiating the base ln x.' from version_ins
union all select gen_random_uuid(), id, 'C', '(ln x)ˣ·[ln(ln x) + 1/ln x]', true, 'Correct: ln y = x·ln(ln x), so y′/y = ln(ln x) + x·[1/(x ln x)] = ln(ln x) + 1/ln x, and y′ = (ln x)ˣ[ln(ln x) + 1/ln x].' from version_ins
union all select gen_random_uuid(), id, 'D', '(ln x)ˣ·[ln(ln x) + 1/(x ln x)]', false, 'This differentiates x·ln(ln x) but forgets to multiply the derivative 1/(x ln x) of ln(ln x) by the factor x from the product rule.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.5-a-v2', 'mcq', 'recognize that a variable base with a variable exponent needs logarithmic differentiation, and apply it with the product (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For all x, which expression gives the derivative of y = (x² + 1)ˣ?', null, md5('apcalcbc-mcq-b2-sv-h-3.5-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2x²(x² + 1)ˣ⁻¹', false, 'This applies the power rule as if the exponent x were constant, which captures only the term from differentiating the base.' from version_ins
union all select gen_random_uuid(), id, 'B', '(x² + 1)ˣ·ln(x² + 1)', false, 'This applies the rule for aˣ with a constant base, omitting the term that comes from differentiating the base x² + 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '(x² + 1)ˣ·[ln(x² + 1) + 2x/(x² + 1)]', false, 'This forgets the factor x from the product rule on x·ln(x² + 1), so the second term should be x·2x/(x² + 1).' from version_ins
union all select gen_random_uuid(), id, 'D', '(x² + 1)ˣ·[ln(x² + 1) + 2x²/(x² + 1)]', true, 'Correct: ln y = x·ln(x² + 1), so y′/y = ln(x² + 1) + x·2x/(x² + 1), and y′ = (x² + 1)ˣ[ln(x² + 1) + 2x²/(x² + 1)].' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.5-a-v3', 'mcq', 'recognize that a variable base with a variable exponent needs logarithmic differentiation, and apply it with the product (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For x > 0, which expression gives the derivative of y = x^(cos x)?', null, md5('apcalcbc-mcq-b2-sv-h-3.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(cos x)·x^(cos x − 1)', false, 'This applies the power rule as if the exponent cos x were constant, which captures only the term from differentiating the base.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x^(cos x)·[−sin x·ln x + (cos x)/x]', true, 'Correct: ln y = cos x·ln x, so y′/y = −sin x·ln x + (cos x)/x, and y′ = x^(cos x)[−sin x·ln x + (cos x)/x].' from version_ins
union all select gen_random_uuid(), id, 'C', '−sin x·ln x·x^(cos x)', false, 'This applies the rule for aˣ with a constant base, omitting the term that comes from differentiating the base x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x^(cos x)·[sin x·ln x + (cos x)/x]', false, 'This loses the minus sign: the derivative of cos x is −sin x, so the first term must be −sin x·ln x.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-sv-h-3.4-a-v3','apcalcbc-mcq-b2-h-3.4-b','apcalcbc-mcq-b2-sv-h-3.4-b-v1','apcalcbc-mcq-b2-sv-h-3.4-b-v2','apcalcbc-mcq-b2-sv-h-3.4-b-v3','apcalcbc-mcq-b2-h-3.5-a','apcalcbc-mcq-b2-sv-h-3.5-a-v1','apcalcbc-mcq-b2-sv-h-3.5-a-v2','apcalcbc-mcq-b2-sv-h-3.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b2-sv-h-3.4-a-v3','apcalcbc-mcq-b2-h-3.4-b','apcalcbc-mcq-b2-sv-h-3.4-b-v1','apcalcbc-mcq-b2-sv-h-3.4-b-v2','apcalcbc-mcq-b2-sv-h-3.4-b-v3','apcalcbc-mcq-b2-h-3.5-a','apcalcbc-mcq-b2-sv-h-3.5-a-v1','apcalcbc-mcq-b2-sv-h-3.5-a-v2','apcalcbc-mcq-b2-sv-h-3.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
