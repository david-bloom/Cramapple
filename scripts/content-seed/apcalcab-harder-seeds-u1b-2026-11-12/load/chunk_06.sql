begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.14-b-v1','apcalcab-mcq-b7-sv-h-1.14-b-v2','apcalcab-mcq-b7-sv-h-1.14-b-v3','apcalcab-mcq-b7-h-1.15-a','apcalcab-mcq-b7-sv-h-1.15-a-v1','apcalcab-mcq-b7-sv-h-1.15-a-v2','apcalcab-mcq-b7-sv-h-1.15-a-v3','apcalcab-mcq-b7-h-1.15-b','apcalcab-mcq-b7-sv-h-1.15-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-sv-h-1.14-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.14-b-v1', 'mcq', 'analyse the sign of each factor to decide whether the one-sided limits at two vertical asymptotes agree, distinguishing  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = (x − 4)/((x + 1)(x − 3)²). Which of the following is true?', null, md5('apcalcab-mcq-b7-sv-h-1.14-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→3) g(x) = ∞, but lim(x→−1) g(x) does not exist', false, 'Near 3 the numerator is −1 and x + 1 is 4, so the quotient is negative and tends to −∞, not +∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→3) g(x) = −∞ and lim(x→−1) g(x) = −∞', false, 'The factor x + 1 changes sign at −1, so the one-sided limits there are +∞ from the left and −∞ from the right, not equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→3) g(x) = −∞, but lim(x→−1) g(x) does not exist', true, 'Correct: Near 3: numerator −1, x + 1 = 4, (x − 3)² > 0, so −∞ both sides. Near −1: numerator −5, (x − 3)² = 16, and x + 1 changes sign, so the one-sided limits are +∞ and −∞.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→3) g(x) does not exist, and lim(x→−1) g(x) = −∞', false, 'This assigns the sign change to the squared factor and the single sign to the linear one, reversing the roles. The squared factor does not change sign.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.14-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.14-b-v2', 'mcq', 'analyse the sign of each factor to decide whether the one-sided limits at two vertical asymptotes agree, distinguishing  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let h(x) = (2 − x)/((x − 5)(x + 1)²). Which of the following is true?', null, md5('apcalcab-mcq-b7-sv-h-1.14-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→−1) h(x) = ∞, but lim(x→5) h(x) does not exist', false, 'Near −1 the numerator is 3 and x − 5 is −6, so the quotient is negative and tends to −∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→−1) h(x) = −∞ and lim(x→5) h(x) = −∞', false, 'The factor x − 5 changes sign at 5, so the one-sided limits there are +∞ from the left and −∞ from the right.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→−1) h(x) = −∞, but lim(x→5) h(x) does not exist', true, 'Correct: Near −1: numerator 3, x − 5 = −6, (x + 1)² > 0 gives −∞ both sides. Near 5: numerator −3 and x − 5 changes sign, giving +∞ from the left and −∞ from the right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→−1) h(x) does not exist, and lim(x→5) h(x) = −∞', false, 'This reverses the roles. The squared factor (x + 1)² is positive on both sides of −1, so the limit there exists as −∞.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.14-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.14-b-v3', 'mcq', 'analyse the sign of each factor to decide whether the one-sided limits at two vertical asymptotes agree, distinguishing  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let k(x) = (2 − x)/((x + 4)³(x − 1)²). Which of the following is true?', null, md5('apcalcab-mcq-b7-sv-h-1.14-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→1) k(x) = −∞, but lim(x→−4) k(x) does not exist', false, 'Near 1 the numerator is 1 and (x + 4)³ is 125, both positive, so k is positive and tends to +∞.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→1) k(x) = ∞ and lim(x→−4) k(x) = ∞', false, 'The factor (x + 4)³ is negative for x < −4 and positive for x > −4, so the one-sided limits at −4 have opposite signs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→1) k(x) does not exist, and lim(x→−4) k(x) = ∞', false, 'This reverses the roles. The even power (x − 1)² does not change sign at 1, while the odd power (x + 4)³ does change sign at −4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→1) k(x) = ∞, but lim(x→−4) k(x) does not exist', true, 'Correct: Near 1: numerator 1, (x + 4)³ = 125, (x − 1)² > 0 gives +∞ both sides. Near −4: numerator 6, (x − 1)² = 25, and (x + 4)³ changes sign, so one-sided limits are −∞ and +∞.' from version_ins;
-- apcalcab-mcq-b7-h-1.15-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.15-a', 'mcq', 'find a horizontal asymptote of a difference of expressions that is infinity minus infinity by multiplying by the conjuga', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x − √(x² + 4x) for x ≥ 0. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?', null, md5('apcalcab-mcq-b7-h-1.15-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0', false, 'This treats x − √(x² + 4x) as ∞ − ∞ = 0. The difference of two large quantities can approach any value, so the expression must be rewritten.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = −4', false, 'This multiplies by the conjugate to get −4x/(x + √(x² + 4x)) but then divides only by x, forgetting that the denominator is about 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 2', false, 'This has a sign error. x is smaller than √(x² + 4x), so the difference is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −2', true, 'Correct: Multiplying by the conjugate gives −4x/(x + √(x² + 4x)). Dividing by x gives −4/(1 + √(1 + 4/x)) → −4/2 = −2.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.15-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.15-a-v1', 'mcq', 'find a horizontal asymptote of a difference of expressions that is infinity minus infinity by multiplying by the conjuga (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(x² + 6x) − x for x ≥ 0. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?', null, md5('apcalcab-mcq-b7-sv-h-1.15-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0', false, 'This treats √(x² + 6x) − x as ∞ − ∞ = 0, which is not a valid conclusion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 3', true, 'Correct: Multiplying by the conjugate gives 6x/(√(x² + 6x) + x) = 6/(√(1 + 6/x) + 1) → 6/2 = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 6', false, 'This reduces 6x/(√(x² + 6x) + x) by dividing by x but forgets the denominator tends to 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −3', false, 'This has a sign error. √(x² + 6x) exceeds x, so the difference is positive.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.15-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.15-a-v2', 'mcq', 'find a horizontal asymptote of a difference of expressions that is infinity minus infinity by multiplying by the conjuga (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(4x² + x) − 2x for x ≥ 0. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?', null, md5('apcalcab-mcq-b7-sv-h-1.15-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 0', false, 'This treats √(4x² + x) − 2x as ∞ − ∞ = 0, which is not valid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 1/2', false, 'This forgets one term in the denominator after rationalising. The denominator √(4x² + x) + 2x behaves like 4x, not 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 1/4', true, 'Correct: Multiplying by the conjugate gives x/(√(4x² + x) + 2x) = 1/(√(4 + 1/x) + 2) → 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 1', false, 'This forgets that the denominator grows. The rationalised form x/(√(4x² + x) + 2x) divided by x has denominator tending to 4.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.15-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.15-a-v3', 'mcq', 'find a horizontal asymptote of a difference of expressions that is infinity minus infinity by multiplying by the conjuga (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x − √(x² − 10x) for x ≥ 10. As x → ∞, the graph of f approaches a horizontal asymptote. What is its equation?', null, md5('apcalcab-mcq-b7-sv-h-1.15-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 5', true, 'Correct: Multiplying by the conjugate gives 10x/(x + √(x² − 10x)) = 10/(1 + √(1 − 10/x)) → 10/2 = 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 0', false, 'This treats x − √(x² − 10x) as ∞ − ∞ = 0, which is not valid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 10', false, 'This forgets the denominator tends to 2 after dividing by x.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −5', false, 'This has a sign error. x exceeds √(x² − 10x), so the difference is positive.' from version_ins;
-- apcalcab-mcq-b7-h-1.15-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.15-b', 'mcq', 'find both horizontal asymptotes of a rational expression containing |x| by rewriting |x| as x for x > 0 and −x for x < 0', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (4x + |x|)/(x + 1). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcab-mcq-b7-h-1.15-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = 5 and y = 3', true, 'Correct: As x → ∞, f(x) = 5x/(x + 1) → 5. As x → −∞, |x| = −x, so f(x) = 3x/(x + 1) → 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 5 only', false, 'This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is different.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = 4 only', false, 'This ignores the absolute value and treats it as 0, giving 4x/x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = 5 and y = −3', false, 'This has a sign slip as x → −∞. The numerator becomes 4x − x = 3x and the quotient 3x/(x + 1) tends to +3.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.15-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.15-b-v1', 'mcq', 'find both horizontal asymptotes of a rational expression containing |x| by rewriting |x| as x for x > 0 and −x for x < 0 (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = (2x − 3|x|)/(x − 4). Which of the following gives all horizontal asymptotes of the graph of f?', null, md5('apcalcab-mcq-b7-sv-h-1.15-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'y = −1 only', false, 'This considers only x → ∞, where |x| = x. As x → −∞, |x| = −x and the limit is 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'y = 2 only', false, 'This ignores the absolute value, treating it as 0 and giving 2x/x = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'y = −1 and y = 5', true, 'Correct: As x → ∞, f(x) = −x/(x − 4) → −1. As x → −∞, |x| = −x, so f(x) = 5x/(x − 4) → 5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'y = −1 and y = −5', false, 'This has a sign slip as x → −∞. The numerator becomes 2x + 3x = 5x, giving +5, not −5.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.14-b-v1','apcalcab-mcq-b7-sv-h-1.14-b-v2','apcalcab-mcq-b7-sv-h-1.14-b-v3','apcalcab-mcq-b7-h-1.15-a','apcalcab-mcq-b7-sv-h-1.15-a-v1','apcalcab-mcq-b7-sv-h-1.15-a-v2','apcalcab-mcq-b7-sv-h-1.15-a-v3','apcalcab-mcq-b7-h-1.15-b','apcalcab-mcq-b7-sv-h-1.15-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-sv-h-1.14-b-v1','apcalcab-mcq-b7-sv-h-1.14-b-v2','apcalcab-mcq-b7-sv-h-1.14-b-v3','apcalcab-mcq-b7-h-1.15-a','apcalcab-mcq-b7-sv-h-1.15-a-v1','apcalcab-mcq-b7-sv-h-1.15-a-v2','apcalcab-mcq-b7-sv-h-1.15-a-v3','apcalcab-mcq-b7-h-1.15-b','apcalcab-mcq-b7-sv-h-1.15-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
