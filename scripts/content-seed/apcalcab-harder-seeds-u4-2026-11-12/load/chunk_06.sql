begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.6-b-v1','apcalcab-mcq-b4-sv-h-4.6-b-v2','apcalcab-mcq-b4-sv-h-4.6-b-v3','apcalcab-mcq-b4-h-4.7-a','apcalcab-mcq-b4-sv-h-4.7-a-v1','apcalcab-mcq-b4-sv-h-4.7-a-v2','apcalcab-mcq-b4-sv-h-4.7-a-v3','apcalcab-mcq-b4-h-4.7-b','apcalcab-mcq-b4-sv-h-4.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-sv-h-4.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.6-b-v1', 'mcq', 'use a linear approximation to turn a percent error in a measurement into a percent error in a derived quantity. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The edge of a cube is measured with a possible error of 1.5 percent. Using a linear approximation, what is the approximate percent error in the volume V = s³ calculated from this edge length?', null, md5('apcalcab-mcq-b4-sv-h-4.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.5 percent', true, 'Correct: dV = 3s²·ds, so dV/V = 3s²·ds/s³ = 3·ds/s = 3(1.5%) = 4.5%.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.5 percent', false, 'This assumes the relative error in V equals the relative error in s. Since V depends on s³, the relative error is multiplied by 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 percent', false, 'This uses the exponent 2, as if the formula were an area such as s². The volume formula has s³, so the factor is 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.375 percent', false, 'This cubes the percent, 1.5³, instead of multiplying by the exponent. The linear approximation gives dV/V = 3·ds/s.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.6-b-v2', 'mcq', 'use a linear approximation to turn a percent error in a measurement into a percent error in a derived quantity. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The diameter of a circular plate is measured with a possible error of 3 percent. Using a linear approximation, what is the approximate percent error in the area A = π(d/2)² calculated from this diameter?', null, md5('apcalcab-mcq-b4-sv-h-4.6-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6 percent', true, 'Correct: A = (π/4)d², so dA = (π/2)d·dd and dA/A = ((π/2)d·dd)/((π/4)d²) = 2·dd/d = 2(3%) = 6%.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 percent', false, 'This assumes the relative error in A equals the relative error in d. Since A depends on d², the relative error is multiplied by 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '9 percent', false, 'This squares the percent, 3², or uses the exponent 3, instead of multiplying by the exponent 2. The linear approximation gives dA/A = 2·dd/d.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.5 percent', false, 'This halves the error because the radius is half the diameter. The percent error of d/2 equals that of d, and the exponent 2 then doubles it.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.6-b-v3', 'mcq', 'use a linear approximation to turn a percent error in a measurement into a percent error in a derived quantity. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The length of a pendulum is measured with a possible error of 4 percent. Using a linear approximation, what is the approximate percent error in the period T = 2π√(L/g) calculated from this length, where g is a constant?', null, md5('apcalcab-mcq-b4-sv-h-4.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 percent', true, 'Correct: T = (2π/√g)·L^(1/2), so dT = (π/√g)L^(−1/2)·dL and dT/T = (1/2)·dL/L = (1/2)(4%) = 2%.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 percent', false, 'This assumes the relative error in T equals the relative error in L. Since T depends on the square root of L, the relative error is multiplied by 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '8 percent', false, 'This doubles the error instead of halving it. The exponent of L in T is 1/2, so the linear approximation gives dT/T = (1/2)·dL/L.' from version_ins
union all select gen_random_uuid(), id, 'D', '16 percent', false, 'This squares the percent, 4², instead of multiplying by the exponent 1/2. The linear approximation gives dT/T = (1/2)·dL/L.' from version_ins;
-- apcalcab-mcq-b4-h-4.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.7-a', 'mcq', 'recognize that L''Hospital''s Rule must be applied more than once, rechecking the form after each step.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (x − sin x)/x³?', null, md5('apcalcab-mcq-b4-h-4.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This applies L''Hospital''s Rule once to get (1 − cos x)/(3x²), then evaluates only the numerator, 1 − cos 0 = 0, and ignores that the denominator is also 0, so the rule must be applied again.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/6', true, 'Correct: Direct substitution gives 0/0. L''Hospital: (1 − cos x)/(3x²), still 0/0. Again: sin x/(6x), still 0/0. Again: cos x/6 → 1/6.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3', false, 'After the first application this treats (1 − cos x)/x² like the limit of sin x / x and replaces it with 1, leaving 1/3. The correct value of (1 − cos x)/x² is 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/2', false, 'This uses the known limit (1 − cos x)/x² = 1/2 but drops the factor 1/3 from the derivative of x³, which is 3x².' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.7-a-v1', 'mcq', 'recognize that L''Hospital''s Rule must be applied more than once, rechecking the form after each step. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (eˣ − 1 − x)/x²?', null, md5('apcalcab-mcq-b4-sv-h-4.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', true, 'Correct: Direct substitution gives 0/0. L''Hospital: (eˣ − 1)/(2x), still 0/0. Again: eˣ/2 → 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This applies L''Hospital''s Rule once to get (eˣ − 1)/(2x), then evaluates only the numerator, e⁰ − 1 = 0, and ignores that the denominator is also 0, so the rule must be applied again.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'After the first application this treats (eˣ − 1)/(2x) as if the 2 were not there and uses the limit of (eˣ − 1)/x, which is 1. The factor 1/2 from 2x is lost.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'After the first application this moves the 2 from the denominator 2x into the numerator, writing 2(eˣ − 1)/x, so the limit becomes 2 instead of 1/2.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.7-a-v2', 'mcq', 'recognize that L''Hospital''s Rule must be applied more than once, rechecking the form after each step. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (1 − cos 2x)/x²?', null, md5('apcalcab-mcq-b4-sv-h-4.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'This applies L''Hospital''s Rule once to get 2 sin 2x/(2x), then evaluates only the numerator, 2 sin 0 = 0, and ignores that the denominator is also 0, so the rule must be applied again.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This differentiates 1 − cos 2x as sin 2x, forgetting the chain-rule factor 2, so the limit of sin 2x/(2x) is taken as 1 instead of 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: Direct substitution gives 0/0. L''Hospital: 2 sin 2x/(2x) = sin 2x/x, still 0/0. Again: 2 cos 2x/1 → 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'The second application gives 4 cos 2x over the derivative of 2x, which is 2. This answer leaves out the division by 2 and reports 4.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.7-a-v3', 'mcq', 'recognize that L''Hospital''s Rule must be applied more than once, rechecking the form after each step. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is lim(x→0) (eˣ − e⁻ˣ − 2x)/x³?', null, md5('apcalcab-mcq-b4-sv-h-4.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/3', true, 'Correct: Direct substitution gives 0/0. L''Hospital: (eˣ + e⁻ˣ − 2)/(3x²), 0/0. Again: (eˣ − e⁻ˣ)/(6x), 0/0. Again: (eˣ + e⁻ˣ)/6 → 2/6 = 1/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This applies L''Hospital''s Rule once to get (eˣ + e⁻ˣ − 2)/(3x²), then evaluates only the numerator, 1 + 1 − 2 = 0, and ignores that the denominator is also 0, so the rule must be applied again.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/6', false, 'After the final step the numerator is eˣ + e⁻ˣ, which equals 2 at x = 0. This answer takes it as 1, giving 1/6 instead of 2/6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'does not exist', false, 'This treats each 0/0 as meaning the limit does not exist. A 0/0 form is indeterminate, so the rule can be applied again, and here it leads to a finite value.' from version_ins;
-- apcalcab-mcq-b4-h-4.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.7-b', 'mcq', 'recognize when L''Hospital''s Rule is inconclusive because the limit of the derivative quotient does not exist.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement about lim(x→∞) (x + sin x)/x is correct?', null, md5('apcalcab-mcq-b4-h-4.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist, because L''Hospital''s Rule gives 1 + cos x, which oscillates.', false, 'L''Hospital''s Rule only concludes something when the limit of the derivative quotient exists. If it does not, the original limit can still exist, and here (x + sin x)/x = 1 + (sin x)/x → 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is ∞, because the numerator is larger than the denominator.', false, 'The numerator exceeds the denominator only by sin x, which stays between −1 and 1. The quotient equals 1 + (sin x)/x, which approaches 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 1, and L''Hospital''s Rule gives no conclusion because the limit of 1 + cos x does not exist.', true, 'Correct: (x + sin x)/x = 1 + (sin x)/x. Since |sin x/x| ≤ 1/x → 0, the limit is 1. L''Hospital''s Rule gives (1 + cos x)/1, which oscillates between 0 and 2, so the rule is inconclusive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 0, because sin x is bounded and the denominator grows without bound.', false, 'Only the term (sin x)/x approaches 0. The quotient is x/x + (sin x)/x = 1 + (sin x)/x, so the limit is 1, not 0.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.7-b-v1', 'mcq', 'recognize when L''Hospital''s Rule is inconclusive because the limit of the derivative quotient does not exist. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which statement about lim(x→∞) (3x − cos x)/x is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist, because L''Hospital''s Rule gives 3 + sin x, which oscillates.', false, 'L''Hospital''s Rule only concludes something when the limit of the derivative quotient exists. If it does not, the original limit can still exist, and here (3x − cos x)/x = 3 − (cos x)/x → 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is ∞, because the form is ∞/∞, which equals ∞.', false, 'The form ∞/∞ is indeterminate and can have any value. Here the quotient equals 3 − (cos x)/x, which approaches 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 0, because cos x is bounded and the denominator grows without bound.', false, 'Only the term (cos x)/x approaches 0. The quotient is 3x/x − (cos x)/x = 3 − (cos x)/x, so the limit is 3, not 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 3, and L''Hospital''s Rule gives no conclusion because the limit of 3 + sin x does not exist.', true, 'Correct: (3x − cos x)/x = 3 − (cos x)/x → 3. L''Hospital''s Rule gives (3 + sin x)/1, which oscillates between 2 and 4, so the rule is inconclusive.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.6-b-v1','apcalcab-mcq-b4-sv-h-4.6-b-v2','apcalcab-mcq-b4-sv-h-4.6-b-v3','apcalcab-mcq-b4-h-4.7-a','apcalcab-mcq-b4-sv-h-4.7-a-v1','apcalcab-mcq-b4-sv-h-4.7-a-v2','apcalcab-mcq-b4-sv-h-4.7-a-v3','apcalcab-mcq-b4-h-4.7-b','apcalcab-mcq-b4-sv-h-4.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-sv-h-4.6-b-v1','apcalcab-mcq-b4-sv-h-4.6-b-v2','apcalcab-mcq-b4-sv-h-4.6-b-v3','apcalcab-mcq-b4-h-4.7-a','apcalcab-mcq-b4-sv-h-4.7-a-v1','apcalcab-mcq-b4-sv-h-4.7-a-v2','apcalcab-mcq-b4-sv-h-4.7-a-v3','apcalcab-mcq-b4-h-4.7-b','apcalcab-mcq-b4-sv-h-4.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
