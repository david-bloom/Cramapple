begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-h-3.1-a','apcalcbc-mcq-b2-sv-h-3.1-a-v1','apcalcbc-mcq-b2-sv-h-3.1-a-v2','apcalcbc-mcq-b2-sv-h-3.1-a-v3','apcalcbc-mcq-b2-h-3.1-b','apcalcbc-mcq-b2-sv-h-3.1-b-v1','apcalcbc-mcq-b2-sv-h-3.1-b-v2','apcalcbc-mcq-b2-sv-h-3.1-b-v3','apcalcbc-mcq-b2-h-3.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b2-h-3.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.1-a', 'mcq', 'apply the chain rule to nested compositions of unspecified functions, evaluating each derivative at the correct input fr', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 2 | 3 | 5 | 4
2 | 0 | −3 | 3 | −1
3 | 1 | 2 | 0 | 6
Let h(x) = f(g(f(x))). What is h′(1)?', null, md5('apcalcbc-mcq-b2-h-3.1-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', true, 'Correct: h′(x) = f′(g(f(x)))·g′(f(x))·f′(x). At x = 1: f(1) = 2, g(2) = 3, so h′(1) = f′(3)·g′(2)·f′(1) = 2·(−1)·3 = −6.' from version_ins
union all select gen_random_uuid(), id, 'B', '36', false, 'This evaluates every derivative at x = 1, but the chain rule needs f′ and g′ at the values of the inner functions.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2', false, 'This leaves out the innermost factor f′(1) from the chain rule for the three nested functions.' from version_ins
union all select gen_random_uuid(), id, 'D', '9', false, 'This takes the outer derivative f′ at f(1) = 2 instead of at g(f(1)) = 3, so the wrong table row is used for f′.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.1-a-v1', 'mcq', 'apply the chain rule to nested compositions of unspecified functions, evaluating each derivative at the correct input fr (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 5 | 1 | 2 | −2
2 | −1 | 4 | 3 | 6
Let h(x) = (f(g(x)))³. What is h′(1)?', null, md5('apcalcbc-mcq-b2-sv-h-3.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−8', false, 'This drops the outer power-rule factor 3(f(g(x)))² and keeps only f′(g(x))·g′(x).' from version_ins
union all select gen_random_uuid(), id, 'B', '−24', true, 'Correct: h′(x) = 3(f(g(x)))²·f′(g(x))·g′(x). At x = 1: g(1) = 2, f(2) = −1, so h′(1) = 3·1·f′(2)·g′(1) = 3·4·(−2) = −24.' from version_ins
union all select gen_random_uuid(), id, 'C', '12', false, 'This omits the inner derivative g′(1) from the chain rule applied to f(g(x)).' from version_ins
union all select gen_random_uuid(), id, 'D', '−6', false, 'This evaluates f′ at x = 1 instead of at g(1) = 2, so the wrong table row is used for the middle derivative.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.1-a-v2', 'mcq', 'apply the chain rule to nested compositions of unspecified functions, evaluating each derivative at the correct input fr (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable functions f and g have the values below.
x | f(x) | f′(x) | g(x) | g′(x)
1 | 4 | −3 | 2 | 5
2 | 1 | 3 | 0 | −1
Let h(x) = f(g(x²)). What is h′(1)?', null, md5('apcalcbc-mcq-b2-sv-h-3.1-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−30', false, 'This evaluates the outer derivative f′ at x = 1 instead of at g(1) = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '30', true, 'Correct: h′(x) = f′(g(x²))·g′(x²)·2x. At x = 1: g(1) = 2, so h′(1) = f′(2)·g′(1)·2 = 3·5·2 = 30.' from version_ins
union all select gen_random_uuid(), id, 'C', '15', false, 'This omits the innermost derivative 2x from the chain rule for x², so the factor 2 is missing.' from version_ins
union all select gen_random_uuid(), id, 'D', '−6', false, 'This evaluates g′ at g(1) = 2 instead of at x² = 1, so the middle derivative is taken at the wrong input.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.1-a-v3', 'mcq', 'apply the chain rule to nested compositions of unspecified functions, evaluating each derivative at the correct input fr (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The differentiable function f has the values below.
x | f(x) | f′(x)
1 | 2 | 2
2 | 3 | −1
3 | 1 | 4
Let h(x) = f(f(f(x))). What is h′(1)?', null, md5('apcalcbc-mcq-b2-sv-h-3.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', false, 'This evaluates f′ at x = 1 for all three factors, but each f′ must be taken at the value of the function inside it.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'This adds the three derivatives; the chain rule multiplies the derivatives of the nested functions.' from version_ins
union all select gen_random_uuid(), id, 'C', '−8', true, 'Correct: h′(x) = f′(f(f(x)))·f′(f(x))·f′(x). At x = 1: f(1) = 2, f(2) = 3, so h′(1) = f′(3)·f′(2)·f′(1) = 4·(−1)·2 = −8.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4', false, 'This leaves out the innermost factor f′(1), using only the two outer derivatives.' from version_ins;
-- apcalcbc-mcq-b2-h-3.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.1-b', 'mcq', 'interpret the chain rule as a rate of change of a composite quantity, tracking sign and units.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The water level in a reservoir is L(V) meters when the stored volume is V million cubic meters. At t = 3 months the volume is V(3) = 25 million cubic meters and V′(3) = −1.5 million cubic meters per month, and L′(25) = 0.4 meters per million cubic meters. Which statement about the water level at t = 3 is correct?', null, md5('apcalcbc-mcq-b2-h-3.1-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The level is falling at 0.4 meters per month.', false, 'This uses L′(25) alone and ignores how fast the volume is changing, so the chain-rule factor V′(3) is missing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The level is falling at 0.6 meters per month.', true, 'Correct: d/dt L(V(t)) = L′(V(3))·V′(3) = (0.4)(−1.5) = −0.6 meters per month, so the level is falling.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The level is falling at 0.6 meters per million cubic meters.', false, 'This has the correct size but the wrong units; a rate with respect to time is in meters per month, not per volume.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The level is rising at 0.6 meters per month.', false, 'This has the correct size but the wrong direction: L′(25) is positive and V′(3) is negative, so the product is negative.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.1-b-v1', 'mcq', 'interpret the chain rule as a rate of change of a composite quantity, tracking sign and units. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The cost of producing q thousand units is C(q) million dollars. At t = 10 weeks, production is q(10) = 40 thousand units and is increasing at q′(10) = 3 thousand units per week, and C′(40) = 0.8 million dollars per thousand units. Which statement about the cost at t = 10 is correct?', null, md5('apcalcbc-mcq-b2-sv-h-3.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cost is increasing at 0.8 million dollars per week.', false, 'This uses C′(40) alone and ignores how fast production is rising, so the chain-rule factor q′(10) is missing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cost is increasing at 2.4 million dollars per thousand units.', false, 'This has the correct size but the wrong units; the composite rate is with respect to time, so it is in million dollars per week.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cost is increasing at about 0.27 million dollars per week.', false, 'This divides C′(40) by q′(10) instead of multiplying the two rates.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cost is increasing at 2.4 million dollars per week.', true, 'Correct: d/dt C(q(t)) = C′(q(10))·q′(10) = (0.8)(3) = 2.4 million dollars per week.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.1-b-v2', 'mcq', 'interpret the chain rule as a rate of change of a composite quantity, tracking sign and units. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The pressure on a diver is P(d) kilopascals at a depth of d meters. At t = 2 minutes the diver is at depth d(2) = 30 meters and is rising toward the surface at d′(2) = −0.5 meters per minute, and P′(30) = 10 kilopascals per meter. Which statement about the pressure at t = 2 is correct?', null, md5('apcalcbc-mcq-b2-sv-h-3.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The pressure is decreasing at 10 kilopascals per minute.', false, 'This uses P′(30) alone, treating the depth as changing by one meter per minute and ignoring d′(2).' from version_ins
union all select gen_random_uuid(), id, 'B', 'The pressure is decreasing at 5 kilopascals per minute.', true, 'Correct: d/dt P(d(t)) = P′(d(2))·d′(2) = (10)(−0.5) = −5 kilopascals per minute.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The pressure is increasing at 5 kilopascals per minute.', false, 'This has the correct size but the wrong direction: the depth is decreasing, so the pressure is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The pressure is decreasing at 5 kilopascals per meter.', false, 'This has the correct size but the wrong units; the rate with respect to time is in kilopascals per minute.' from version_ins;
-- apcalcbc-mcq-b2-sv-h-3.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-sv-h-3.1-b-v3', 'mcq', 'interpret the chain rule as a rate of change of a composite quantity, tracking sign and units. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The number of tickets sold per week is D(p) when the price is p dollars. At t = 8 weeks the price is p(8) = 12 dollars and is falling at p′(8) = −0.5 dollars per week, and D′(12) = −30 tickets per week per dollar. Which statement about the weekly ticket sales at t = 8 is correct?', null, md5('apcalcbc-mcq-b2-sv-h-3.1-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Weekly sales are decreasing at 15 tickets per week each week.', false, 'This has the correct size but the wrong direction: both D′(12) and p′(8) are negative, so their product is positive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Weekly sales are increasing at 15 tickets per week each week.', true, 'Correct: d/dt D(p(t)) = D′(12)·p′(8) = (−30)(−0.5) = +15 tickets per week each week, so sales are increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Weekly sales are decreasing at 30 tickets per week each week.', false, 'This uses D′(12) alone and ignores that the price is changing, so the factor p′(8) is missing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Weekly sales are increasing at 15 tickets per week per dollar.', false, 'This has the correct size but the wrong units; the composite rate is with respect to time, not price.' from version_ins;
-- apcalcbc-mcq-b2-h-3.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b2-h-3.2-a', 'mcq', 'locate points of horizontal tangency on an implicitly defined curve by setting the numerator of dy/dx to zero and substi', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At which points does the graph of x² + xy + y² = 12 have a horizontal tangent line?', null, md5('apcalcbc-mcq-b2-h-3.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(2, −4) and (−2, 4)', true, 'Correct: Differentiating gives dy/dx = −(2x + y)/(x + 2y). Horizontal tangents need 2x + y = 0, so y = −2x; substituting gives 3x² = 12, x = ±2, and the points are (2, −4) and (−2, 4), where x + 2y ≠ 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '(−4, 2) and (4, −2)', false, 'These are the points where the denominator x + 2y is zero, so the tangent is vertical; a horizontal tangent needs the numerator 2x + y to be zero.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2, 2) and (−2, −2)', false, 'These come from setting x − y = 0 instead of 2x + y = 0, which is not the condition dy/dx = 0 for this curve.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Only (2, −4)', false, 'This finds one solution but misses (−2, 4), which also lies on the curve with 2x + y = 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b2-h-3.1-a','apcalcbc-mcq-b2-sv-h-3.1-a-v1','apcalcbc-mcq-b2-sv-h-3.1-a-v2','apcalcbc-mcq-b2-sv-h-3.1-a-v3','apcalcbc-mcq-b2-h-3.1-b','apcalcbc-mcq-b2-sv-h-3.1-b-v1','apcalcbc-mcq-b2-sv-h-3.1-b-v2','apcalcbc-mcq-b2-sv-h-3.1-b-v3','apcalcbc-mcq-b2-h-3.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b2-h-3.1-a','apcalcbc-mcq-b2-sv-h-3.1-a-v1','apcalcbc-mcq-b2-sv-h-3.1-a-v2','apcalcbc-mcq-b2-sv-h-3.1-a-v3','apcalcbc-mcq-b2-h-3.1-b','apcalcbc-mcq-b2-sv-h-3.1-b-v1','apcalcbc-mcq-b2-sv-h-3.1-b-v2','apcalcbc-mcq-b2-sv-h-3.1-b-v3','apcalcbc-mcq-b2-h-3.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
