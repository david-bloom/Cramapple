begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.8-b-v3','apcalcab-mcq-b5-h-2.9-a','apcalcab-mcq-b5-sv-h-2.9-a-v1','apcalcab-mcq-b5-sv-h-2.9-a-v2','apcalcab-mcq-b5-sv-h-2.9-a-v3','apcalcab-mcq-b5-h-2.9-b','apcalcab-mcq-b5-sv-h-2.9-b-v1','apcalcab-mcq-b5-sv-h-2.9-b-v2','apcalcab-mcq-b5-sv-h-2.9-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apcalcab-mcq-b5-sv-h-2.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.8-b-v3', 'mcq', 'apply the product rule to a rate in context, such as revenue as price times quantity, and interpret the result with unit (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A town has n(t) thousand households and s(t) people per household at year t, so its population in thousands is P(t) = n(t)s(t). At t = 2, n = 50, n′ = 3 thousand households per year, s = 2.5 and s′ = −0.1 people per household per year. What is P′(2)?', null, md5('apcalcab-mcq-b5-sv-h-2.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.5 thousand people per year', false, 'This keeps only the household-growth term n′s = 7.5 and omits ns′ = −5, the loss from shrinking household size.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5 thousand people per year', false, 'This keeps only the term ns′ = −5 and omits n′s = 7.5, the gain from new households.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.5 thousand people per year', true, 'Correct: P′ = n′s + ns′ = (3)(2.5) + (50)(−0.1) = 7.5 − 5 = 2.5 thousand people per year.' from version_ins
union all select gen_random_uuid(), id, 'D', '−0.3 thousand people per year', false, 'This multiplies the rates, 3 · (−0.1). The product rule gives n′s + ns′, not n′s′.' from version_ins;
-- apcalcab-mcq-b5-h-2.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.9-a', 'mcq', 'use the quotient rule backward: a horizontal tangent to a quotient determines a derivative of the numerator.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f and g be differentiable functions with f(2) = 8, g(2) = 4 and g′(2) = 3, and let h(x) = f(x)/g(x). The graph of h has a horizontal tangent line at x = 2. What is f′(2)?', null, md5('apcalcab-mcq-b5-h-2.9-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', false, 'This uses the product rule signs, f′g + fg′ = 0, instead of the quotient rule numerator f′g − fg′.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This sets only f′(2) = 0, as if h′ were f′/g′. The quotient rule has a second term −f g′.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', true, 'Correct: h′ = (f′g − fg′)/g². Setting h′(2) = 0 gives 4f′(2) − 8(3) = 0, so f′(2) = 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '32/3', false, 'This solves f′ = f g/g′ by inverting the relation. The condition f′g − fg′ = 0 gives f′ = f g′/g.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.9-a-v1', 'mcq', 'use the quotient rule backward: a horizontal tangent to a quotient determines a derivative of the numerator. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f and g be differentiable functions with f(1) = −3, g(1) = 2 and g′(1) = −5, and let h(x) = f(x)/g(x). The graph of h has a horizontal tangent line at x = 1. What is f′(1)?', null, md5('apcalcab-mcq-b5-sv-h-2.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15/2', true, 'Correct: h′ = (f′g − fg′)/g². Setting h′(1) = 0 gives 2f′(1) − (−3)(−5) = 0, so f′(1) = 15/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '−15/2', false, 'This uses the product rule signs, f′g + fg′ = 0, which gives the opposite sign.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', false, 'This sets only f′(1) = 0, as if h′ were f′/g′. The quotient rule has a second term −f g′.' from version_ins
union all select gen_random_uuid(), id, 'D', '6/5', false, 'This solves f′ = f g/g′ by inverting the relation. The condition f′g − fg′ = 0 gives f′ = f g′/g.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.9-a-v2', 'mcq', 'use the quotient rule backward: a horizontal tangent to a quotient determines a derivative of the numerator. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f(2) = 10, and let h(x) = f(x)/x². The graph of h has a horizontal tangent line at x = 2. What is f′(2)?', null, md5('apcalcab-mcq-b5-sv-h-2.9-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20', false, 'This forgets to divide by x: the condition x² f′ − 2x f = 0 gives f′ = 2f/x = 10, not 2f = 20.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This uses f′ = f/x with the 2 lost from the derivative of x². The derivative of x² is 2x.' from version_ins
union all select gen_random_uuid(), id, 'C', '10', true, 'Correct: h′ = (x²f′ − 2xf)/x⁴. Setting h′(2) = 0 gives 4f′(2) − 4(10) = 0, so f′(2) = 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '0', false, 'This sets only f′(2) = 0. The quotient rule has a second term −2x f(x) that is not zero.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.9-a-v3', 'mcq', 'use the quotient rule backward: a horizontal tangent to a quotient determines a derivative of the numerator. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f(0) = −4, and let h(x) = f(x)/eˣ. The graph of h has a horizontal tangent line at x = 0. What is f′(0)?', null, md5('apcalcab-mcq-b5-sv-h-2.9-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'This has a sign error from the numerator f′ − f: setting it to 0 gives f′(0) = f(0) = −4, not +4.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'This sets only f′(0) = 0, dropping the term −f eˣ from the quotient rule.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4', true, 'Correct: h′ = (eˣ f′ − f eˣ)/e²ˣ = (f′ − f)/eˣ. Setting h′(0) = 0 gives f′(0) = f(0) = −4.' from version_ins
union all select gen_random_uuid(), id, 'D', '−16', false, 'This squares f(0), producing f² = 16, which has no role in the condition f′(0) = f(0).' from version_ins;
-- apcalcab-mcq-b5-h-2.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-h-2.9-b', 'mcq', 'use the quotient rule on an average-cost function to find where average cost stops falling.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The total cost of producing q units is C(q) = q² + 10q + 400 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?', null, md5('apcalcab-mcq-b5-h-2.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'q = 20', true, 'Correct: A′(q) = [qC′(q) − C(q)]/q² = [q(2q + 10) − (q² + 10q + 400)]/q² = (q² − 400)/q². This is zero at q = 20.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q = 400', false, 'This solves 1 − 400/q² = 0 as q² = 400 and then stops without taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'C', 'q = 10', false, 'This reads the coefficient of the linear term of C off as the answer. It has no connection to where A′ = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'q = 200', false, 'This sets C′(q) = 2q equal to the constant 400, which is not the condition A′(q) = 0.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.9-b-v1', 'mcq', 'use the quotient rule on an average-cost function to find where average cost stops falling. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The total cost of producing q units is C(q) = q² + 4q + 225 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?', null, md5('apcalcab-mcq-b5-sv-h-2.9-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'q = 225', false, 'This solves q² = 225 and stops without taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q = 15', true, 'Correct: A′(q) = [q(2q + 4) − (q² + 4q + 225)]/q² = (q² − 225)/q². This is zero at q = 15.' from version_ins
union all select gen_random_uuid(), id, 'C', 'q = 4', false, 'This reads the coefficient of the linear term of C off as the answer. It has no connection to where A′ = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'q = 112.5', false, 'This sets C′(q) = 2q equal to the constant 225, which is not the condition A′(q) = 0.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.9-b-v2', 'mcq', 'use the quotient rule on an average-cost function to find where average cost stops falling. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The total cost of producing q units is C(q) = 2q² + 7q + 98 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?', null, md5('apcalcab-mcq-b5-sv-h-2.9-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'q = 49', false, 'This solves q² = 49 and stops without taking the square root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q = 7', true, 'Correct: A′(q) = [q(4q + 7) − (2q² + 7q + 98)]/q² = (2q² − 98)/q². This is zero at q = 7.' from version_ins
union all select gen_random_uuid(), id, 'C', 'q = 98', false, 'This gives the constant 98 as the answer, which has no connection to where A′ = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'q = 7/4', false, 'This sets the marginal cost C′(q) = 4q + 7 equal to 0 and drops the sign of q = −7/4. The condition needed is on A′, not on C′.' from version_ins;
-- apcalcab-mcq-b5-sv-h-2.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b5-sv-h-2.9-b-v3', 'mcq', 'use the quotient rule on an average-cost function to find where average cost stops falling. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The total cost of producing q units is C(q) = q³ + 16 dollars, so the average cost per unit is A(q) = C(q)/q. At what production level q > 0 does A′(q) = 0?', null, md5('apcalcab-mcq-b5-sv-h-2.9-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'q = 2', true, 'Correct: A′(q) = [q(3q²) − (q³ + 16)]/q² = (2q³ − 16)/q². This is zero when q³ = 8, so q = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q = 8', false, 'This solves q³ = 8 and stops without taking the cube root.' from version_ins
union all select gen_random_uuid(), id, 'C', 'q = 16', false, 'This gives the constant 16 as the answer, which has no connection to where A′ = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'q = 4', false, 'This solves q² = 16, treating the equation as a quadratic rather than q³ = 8.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b5-sv-h-2.8-b-v3','apcalcab-mcq-b5-h-2.9-a','apcalcab-mcq-b5-sv-h-2.9-a-v1','apcalcab-mcq-b5-sv-h-2.9-a-v2','apcalcab-mcq-b5-sv-h-2.9-a-v3','apcalcab-mcq-b5-h-2.9-b','apcalcab-mcq-b5-sv-h-2.9-b-v1','apcalcab-mcq-b5-sv-h-2.9-b-v2','apcalcab-mcq-b5-sv-h-2.9-b-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b5-sv-h-2.8-b-v3','apcalcab-mcq-b5-h-2.9-a','apcalcab-mcq-b5-sv-h-2.9-a-v1','apcalcab-mcq-b5-sv-h-2.9-a-v2','apcalcab-mcq-b5-sv-h-2.9-a-v3','apcalcab-mcq-b5-h-2.9-b','apcalcab-mcq-b5-sv-h-2.9-b-v1','apcalcab-mcq-b5-sv-h-2.9-b-v2','apcalcab-mcq-b5-sv-h-2.9-b-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
