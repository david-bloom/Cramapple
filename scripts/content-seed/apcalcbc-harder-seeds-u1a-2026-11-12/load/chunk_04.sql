begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.4-a-v3','apcalcbc-mcq-b6-h-1.4-b','apcalcbc-mcq-b6-sv-h-1.4-b-v1','apcalcbc-mcq-b6-sv-h-1.4-b-v2','apcalcbc-mcq-b6-sv-h-1.4-b-v3','apcalcbc-mcq-b6-h-1.5-a','apcalcbc-mcq-b6-sv-h-1.5-a-v1','apcalcbc-mcq-b6-sv-h-1.5-a-v2','apcalcbc-mcq-b6-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.4-a-v3', 'mcq', 'estimate a limit from a two-sided table, then transform it algebraically while ignoring the defined value at the point. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of f(x) = sin(3x)/x near x = 0, and f(0) is defined to be 0. f(-0.1) = 2.9552; f(-0.01) = 2.9996; f(-0.001) = 3.0000; f(0.001) = 3.0000; f(0.01) = 2.9996; f(0.1) = 2.9552. Based on the table, what is the best estimate of lim(x→0) (2f(x) + 1)?', null, md5('apcalcbc-mcq-b6-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'This uses f(0) = 0, giving 2·0 + 1 = 1, but the limit depends on values of f near 0, which approach 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'The table gives 2f(x) → 6, but the expression also adds 1, so the limit is 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This computes f(x) + 1 and ignores the factor 2; the expression is 2f(x) + 1, which tends to 2·3 + 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', true, 'Correct: Values of f approach 3 from both sides, so 2f(x) + 1 approaches 7.' from version_ins;
-- apcalcbc-mcq-b6-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.4-b', 'mcq', 'recognize that a table sampled at special inputs cannot establish a limit when the function oscillates.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates g(x) = sin(π/x) at x = 0.1, 0.01, 0.001, and 0.0001 and finds g(x) = 0 at every input (up to rounding). Which is the best conclusion?', null, md5('apcalcbc-mcq-b6-h-1.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The table does not justify a limit of 0: g takes the value 1 at inputs x = 2/(4n + 1) arbitrarily close to 0, so lim(x→0) g(x) does not exist', true, 'Correct: At x = 2/(4n + 1), π/x = (4n + 1)π/2 and g = 1, while g = 0 at the tabulated inputs, so g has no limit at 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) g(x) = 0, because g(x) = 0 at every input checked and the inputs approach 0', false, 'Values that are 0 at selected inputs do not determine the limit; these inputs were chosen so that π/x is a multiple of π, which hides the oscillation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0) g(x) = 1, because the sine of a very large angle reaches its maximum', false, 'The sine of a large angle takes every value in [−1, 1] repeatedly, so it does not settle at its maximum 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0) g(x) does not exist only because g(0) is undefined', false, 'A function being undefined at a point does not prevent a limit; the limit fails to exist here because g oscillates between −1 and 1.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.4-b-v1', 'mcq', 'recognize that a table sampled at special inputs cannot establish a limit when the function oscillates. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates g(x) = sin(2π/x) at x = 0.5, 0.25, 0.2, and 0.1 and finds g(x) = 0 at every input. Which is the best conclusion?', null, md5('apcalcbc-mcq-b6-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) g(x) = 0, because every tabulated value is 0', false, 'Tabulated zeros come from inputs where 2π/x is a multiple of π; other inputs near 0 give values up to 1, so the table is misleading.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The table does not justify a limit of 0: g takes the value 1 at inputs x = 4/(4n + 1) arbitrarily close to 0, so lim(x→0) g(x) does not exist', true, 'Correct: At x = 4/(4n + 1), 2π/x = (4n + 1)π/2 so g = 1, while the tabulated inputs give 0; no single limit exists.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0) g(x) = 1, because sin reaches 1 at some inputs', false, 'Reaching 1 at some inputs does not make 1 the limit, since g also reaches −1 and 0 at inputs arbitrarily close to 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0) g(x) does not exist only because g(0) is undefined', false, 'The undefined value at 0 is irrelevant to a limit; the limit fails because g keeps oscillating between −1 and 1.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.4-b-v2', 'mcq', 'recognize that a table sampled at special inputs cannot establish a limit when the function oscillates. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates g(x) = sin(4π/x) at x = 0.5, 0.25, 0.125, and 0.0625 and finds g(x) = 0 at every input. Which is the best conclusion?', null, md5('apcalcbc-mcq-b6-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) g(x) = 0, since the values stay at 0 as x gets smaller', false, 'Zeros at four chosen inputs do not control the behavior at all inputs near 0; g oscillates infinitely often.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The table does not justify a limit of 0: g takes the value 1 at inputs x = 8/(4n + 1) arbitrarily close to 0, so lim(x→0) g(x) does not exist', true, 'Correct: At x = 8/(4n + 1), 4π/x = (4n + 1)π/2 so g = 1, yet g = 0 at the tabulated inputs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0) g(x) = 4π, since the numerator of the argument is 4π', false, 'The constant 4π is part of the argument of the sine, not the value of the function, which always lies in [−1, 1].' from version_ins
union all select gen_random_uuid(), id, 'D', 'lim(x→0) g(x) does not exist only because g(0) is undefined', false, 'A limit can exist where a function is undefined; this one fails because g oscillates between −1 and 1 near 0.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.4-b-v3', 'mcq', 'recognize that a table sampled at special inputs cannot establish a limit when the function oscillates. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student evaluates g(x) = x sin(π/x) at x = 0.1, 0.01, 0.001, and 0.0001 and finds g(x) = 0 at every input (up to rounding). Which is the best conclusion?', null, md5('apcalcbc-mcq-b6-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'lim(x→0) g(x) does not exist, because sin(π/x) oscillates infinitely often near 0', false, 'The sine factor oscillates, but it is multiplied by x, which forces g toward 0; oscillation of a factor does not by itself rule out a limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'lim(x→0) g(x) = 1, because sin(π/x) takes the value 1 arbitrarily close to 0', false, 'When sin(π/x) = 1, g(x) = x, which is small; the factor x pulls every value of g toward 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'lim(x→0) g(x) does not exist, because g(0) is undefined', false, 'A function can have a limit at a point where it is undefined; here the limit exists and equals 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The table alone proves nothing, but lim(x→0) g(x) = 0 is correct because |g(x)| ≤ |x| for all x ≠ 0', true, 'Correct: −|x| ≤ x sin(π/x) ≤ |x| for x ≠ 0, so by the Squeeze Theorem the limit is 0, which the table cannot prove.' from version_ins;
-- apcalcbc-mcq-b6-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.5-a', 'mcq', 'use a limit of a difference quotient to deduce lim f, then apply product laws.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function f satisfies lim(x→2) (f(x) − 5)/(x − 2) = 4. What is lim(x→2) f(x)(x² + 1)?', null, md5('apcalcbc-mcq-b6-h-1.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25', true, 'Correct: f(x) − 5 = [(f(x) − 5)/(x − 2)]·(x − 2) → 4·0 = 0, so f → 5 and f(x)(x² + 1) → 5·5 = 25.' from version_ins
union all select gen_random_uuid(), id, 'B', '20', false, 'The value 4 is the limit of the difference quotient, not of f; the quotient has a limit and a denominator tending to 0, so f(x) − 5 → 0 and f(x) → 5, giving 5·5.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The numerator f(x) − 5 tends to 0, but f(x) itself tends to 5, so f(x)(x² + 1) tends to 5·5, not 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined without a formula for f', false, 'The given limit forces lim f(x) = 5, since f(x) − 5 = [(f(x) − 5)/(x − 2)]·(x − 2) → 4·0 = 0, so the product limit can be found.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.5-a-v1', 'mcq', 'use a limit of a difference quotient to deduce lim f, then apply product laws. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function g satisfies lim(x→3) (g(x) + 2)/(x − 3) = 7. What is lim(x→3) g(x)(x − 1)?', null, md5('apcalcbc-mcq-b6-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '14', false, 'The value 7 is the limit of the quotient, not of g; the quotient forces g(x) + 2 → 0 so g → −2, and the product limit is −2·2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4', true, 'Correct: g(x) + 2 → 7·0 = 0, so g → −2 and g(x)(x − 1) → (−2)(2) = −4.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The numerator g(x) + 2 tends to 0, but g itself tends to −2, so g(x)(x − 1) → (−2)(2) = −4, not 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined without a formula for g', false, 'Since g(x) + 2 = [(g(x) + 2)/(x − 3)]·(x − 3) → 7·0 = 0, we know lim g = −2, which is enough to evaluate the product.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.5-a-v2', 'mcq', 'use a limit of a difference quotient to deduce lim f, then apply product laws. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The function h satisfies lim(x→−1) (h(x) − 1)/(x + 1) = −3. What is lim(x→−1) h(x)(x − 4)?', null, md5('apcalcbc-mcq-b6-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15', false, 'The value −3 is the limit of the quotient; using it as lim h gives (−3)(−5) = 15, but the quotient forces h → 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5', true, 'Correct: h(x) − 1 → (−3)(0) = 0, so h → 1 and h(x)(x − 4) → 1·(−5) = −5.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'The numerator h(x) − 1 tends to 0, but h(x) itself tends to 1, so h(x)(x − 4) → 1·(−5), not 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined without a formula for h', false, 'From h(x) − 1 = [(h(x) − 1)/(x + 1)]·(x + 1) → (−3)·0 = 0 we get lim h = 1, so the product limit is 1·(−5).' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.5-a-v3', 'mcq', 'use a limit of a difference quotient to deduce lim f, then apply product laws. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cost function C(t), in dollars, satisfies lim(t→4) (C(t) − 20)/(t − 4) = 1.5. What is lim(t→4) t·C(t)?', null, md5('apcalcbc-mcq-b6-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6', false, 'The value 1.5 is the limit of the quotient, and 4·1.5 = 6 uses it as lim C, but the quotient forces C → 20.' from version_ins
union all select gen_random_uuid(), id, 'B', '80', true, 'Correct: C(t) − 20 → 1.5·0 = 0, so C → 20 and t·C(t) → 4·20 = 80.' from version_ins
union all select gen_random_uuid(), id, 'C', '20', false, 'The quotient forces lim C(t) = 20, but the product t·C(t) also includes the factor t → 4, so the limit is 4·20.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'The numerator C(t) − 20 tends to 0, but C itself tends to 20, so t·C(t) → 4·20, not 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.4-a-v3','apcalcbc-mcq-b6-h-1.4-b','apcalcbc-mcq-b6-sv-h-1.4-b-v1','apcalcbc-mcq-b6-sv-h-1.4-b-v2','apcalcbc-mcq-b6-sv-h-1.4-b-v3','apcalcbc-mcq-b6-h-1.5-a','apcalcbc-mcq-b6-sv-h-1.5-a-v1','apcalcbc-mcq-b6-sv-h-1.5-a-v2','apcalcbc-mcq-b6-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-sv-h-1.4-a-v3','apcalcbc-mcq-b6-h-1.4-b','apcalcbc-mcq-b6-sv-h-1.4-b-v1','apcalcbc-mcq-b6-sv-h-1.4-b-v2','apcalcbc-mcq-b6-sv-h-1.4-b-v3','apcalcbc-mcq-b6-h-1.5-a','apcalcbc-mcq-b6-sv-h-1.5-a-v1','apcalcbc-mcq-b6-sv-h-1.5-a-v2','apcalcbc-mcq-b6-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
