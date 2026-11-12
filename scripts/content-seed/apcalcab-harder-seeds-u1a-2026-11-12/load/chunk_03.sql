begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.3-a-v2','apcalcab-mcq-b6-sv-h-1.3-a-v3','apcalcab-mcq-b6-h-1.3-b','apcalcab-mcq-b6-sv-h-1.3-b-v1','apcalcab-mcq-b6-sv-h-1.3-b-v2','apcalcab-mcq-b6-sv-h-1.3-b-v3','apcalcab-mcq-b6-h-1.4-a','apcalcab-mcq-b6-sv-h-1.4-a-v1','apcalcab-mcq-b6-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.3-a-v2', 'mcq', 'read a verbally described graph at several points and distinguish where a finite limit exists from where the function va (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has these features. At x = 0 the curve jumps: it approaches height 3 from the left and height 1 from the right. At x = 2 the curve rises to +∞ on both sides of a vertical asymptote. At x = 4 there is an open circle at (4, 1), the curve on both sides approaches 1, and the only filled point on the line x = 4 is (4, 6). At x = 6 the curve passes smoothly through the filled point (6, 3). At how many of the values x = 0, 2, 4, 6 does lim(x→a) f(x) fail to exist as a finite number?', null, md5('apcalcab-mcq-b6-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'Counting only the jump at x = 0 gives 1. The vertical asymptote at x = 2 also has no finite limit, because the outputs grow without bound.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'Counting x = 4 because the filled point (4, 6) differs from the nearby curve gives 3. The limit at x = 4 is 1 from both sides, regardless of the value f(4).' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'This counts every listed value as a failure. The limits at x = 4 and x = 6 both exist, since the curve approaches a single finite height from both sides.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', true, 'Correct: The limit fails to exist as a finite number at x = 0 (one-sided limits 3 and 1 differ) and at x = 2 (the curve is unbounded). It exists at x = 4 (both sides approach 1) and x = 6. That is 2 values.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.3-a-v3', 'mcq', 'read a verbally described graph at several points and distinguish where a finite limit exists from where the function va (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has these features. At x = −2 the curve approaches height 4 from both sides, and the only filled point on the line x = −2 is (−2, 1). At x = 0 the curve is smooth and passes through the filled point (0, 2). At x = 2 the curve jumps: it approaches height 5 from the left and height 3 from the right, and the filled point is (2, 5). At x = 4 the graph has a sharp corner at the filled point (4, 0), with the curve approaching 0 from both sides. For how many of the values x = −2, 0, 2, 4 does lim(x→a) f(x) exist and equal f(a)?', null, md5('apcalcab-mcq-b6-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', true, 'Correct: The limit equals f(a) at x = 0 (limit 2, f(0) = 2) and at x = 4 (limit 0, f(4) = 0). At x = −2 the limit is 4 but f(−2) = 1, and at x = 2 the limit does not exist. That is 2 values.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'Counting only x = 0 misses the corner at x = 4. A sharp corner does not break the equality of the limit 0 and the value f(4) = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'Counting x = −2 because its limit exists gives 3. There the limit is 4 but f(−2) = 1, so the limit does not equal the function value.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'Counting x = 2 because f(2) = 5 matches the left-hand limit gives 4. A two-sided limit needs both sides to agree, and 5 and 3 differ.' from version_ins;
-- apcalcab-mcq-b6-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.3-b', 'mcq', 'combine one-sided limits read from two graphs to evaluate a sum, difference or product whose two-sided limit exists even', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Graph of f: as x approaches 2 from the left, f(x) approaches 3; as x approaches 2 from the right, f(x) approaches 1; and f(2) = 2. Graph of g: as x approaches 2 from the left, g(x) approaches 0; from the right, g(x) approaches 2; and g(2) = 5. What is lim(x→2) [f(x) + g(x)]?', null, md5('apcalcab-mcq-b6-h-1.3-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'Neither f nor g has a two-sided limit at 2, but the limit of the sum can still exist. The sum approaches 3 from both sides.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'The value 7 is f(2) + g(2) = 2 + 5. Limits depend on the nearby behavior of the functions, not on their values at 2.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: From the left, f + g approaches 3 + 0 = 3. From the right it approaches 1 + 2 = 3. The one-sided limits of the sum agree, so the limit is 3 even though neither lim f nor lim g exists.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This adds the left-hand limit of f (3) to the right-hand limit of g (2), mixing sides. Both functions must be combined on the same side.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.3-b-v1', 'mcq', 'combine one-sided limits read from two graphs to evaluate a sum, difference or product whose two-sided limit exists even (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Graph of f: as x approaches 1 from the left, f(x) approaches 4; from the right, f(x) approaches −2; and f(1) = 0. Graph of g: as x approaches 1 from the left, g(x) approaches −3; from the right, g(x) approaches 3; and g(1) = 6. What is lim(x→1) [f(x) + g(x)]?', null, md5('apcalcab-mcq-b6-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'Neither f nor g has a two-sided limit at 1, but their sum does. The left-hand and right-hand limits of f + g are both 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', true, 'Correct: From the left, f + g approaches 4 + (−3) = 1. From the right it approaches −2 + 3 = 1. The one-sided limits of the sum agree, so the limit is 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'The value 6 is f(1) + g(1) = 0 + 6. A limit is determined by the behavior near 1, not by the values at 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '7', false, 'This adds the left-hand limit of f (4) to the right-hand limit of g (3), mixing sides. Both functions must be evaluated on the same side.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.3-b-v2', 'mcq', 'combine one-sided limits read from two graphs to evaluate a sum, difference or product whose two-sided limit exists even (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Graph of f: as x approaches −1 from the left, f(x) approaches 2; from the right, f(x) approaches 5; and f(−1) = 4. Graph of g: as x approaches −1 from the left, g(x) approaches −1; from the right, g(x) approaches 2; and g(−1) = −3. What is lim(x→−1) [f(x) − g(x)]?', null, md5('apcalcab-mcq-b6-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'Neither f nor g has a two-sided limit at −1, but the difference does. Both one-sided limits of f − g equal 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Correct: From the left, f − g approaches 2 − (−1) = 3. From the right it approaches 5 − 2 = 3. The one-sided limits of the difference agree, so the limit is 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'The value 7 is f(−1) − g(−1) = 4 − (−3). The limit depends on nearby values, not on the values at −1.' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'This subtracts the left-hand limit of g (−1) from the right-hand limit of f (5), mixing sides. Both must be taken from the same side.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.3-b-v3', 'mcq', 'combine one-sided limits read from two graphs to evaluate a sum, difference or product whose two-sided limit exists even (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Graph of f: as x approaches 4 from the left, f(x) approaches 2; from the right, f(x) approaches −1; and f(4) = 1. Graph of g: as x approaches 4 from the left, g(x) approaches 3; from the right, g(x) approaches −6; and g(4) = 4. What is lim(x→4) [f(x) · g(x)]?', null, md5('apcalcab-mcq-b6-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'Neither f nor g has a two-sided limit at 4, but their product does. Both one-sided limits of f · g are 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'The value 4 is f(4) · g(4) = 1 · 4. A limit is not the product of the function values at the point.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', true, 'Correct: From the left, f · g approaches 2 · 3 = 6. From the right it approaches (−1)(−6) = 6. The one-sided limits of the product agree, so the limit is 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '−12', false, 'This multiplies the left-hand limit of f (2) by the right-hand limit of g (−6), mixing sides. Each side''s limits must be multiplied together.' from version_ins;
-- apcalcab-mcq-b6-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.4-a', 'mcq', 'estimate two limits from tables of values near a point where both functions are undefined, then combine them', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two functions f and g are both undefined at x = 2. Their values at inputs near 2 are given for x = 1.99, 1.999, 2.001, 2.01: f(x) = 11.9401, 11.994, 12.006, 12.0601; g(x) = 3.99, 3.999, 4.001, 4.01. Based on the table, what is lim(x→2) f(x)/g(x)?', null, md5('apcalcab-mcq-b6-h-1.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'Neither function is defined at x = 2, but a limit depends only on values near 2. Both f and g approach finite values and g does not approach 0, so the quotient has a limit.' from version_ins
union all select gen_random_uuid(), id, 'B', '48', false, 'The value 48 is 12 · 4, the product of the two limits. The question asks about the quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '8', false, 'The value 8 is 12 − 4, the difference of the two limits. The question asks about the quotient.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'Correct: The values of f approach 12 and the values of g approach 4 from both sides. The limit of the quotient is 12/4 = 3, even though neither function is defined at 2.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.4-a-v1', 'mcq', 'estimate two limits from tables of values near a point where both functions are undefined, then combine them (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two functions f and g are both undefined at x = 1. Their values near 1 are given for x = 0.99, 0.999, 1.001, 1.01: f(x) = 2.9701, 2.997, 3.003, 3.0301; g(x) = 1.99, 1.999, 2.001, 2.01. Based on the table, what is lim(x→1) [f(x) − (g(x))²]?', null, md5('apcalcab-mcq-b6-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1', true, 'Correct: The values of f approach 3 and the values of g approach 2. The limit of f(x) − (g(x))² is 3 − 2² = 3 − 4 = −1.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'The value 1 is 3 − 2, which forgets to square g. The expression subtracts (g(x))², whose limit is 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '7', false, 'The value 7 is 3 + 4, a sign error that adds (g(x))² instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'Neither function is defined at x = 1, but the table shows each approaching a finite value from both sides, so the combined expression has a limit.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.4-a-v2', 'mcq', 'estimate two limits from tables of values near a point where both functions are undefined, then combine them (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two functions f and g are both undefined at x = −2. Their values near −2 are given for x = -2.01, -2.001, -1.999, -1.99: f(x) = 12.0601, 12.006, 11.994, 11.9401; g(x) = -4.01, -4.001, -3.999, -3.99. Based on the table, what is lim(x→−2) f(x)/g(x)?', null, md5('apcalcab-mcq-b6-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit does not exist', false, 'Neither function is defined at x = −2, but a limit uses only nearby values. Both functions approach finite values and the limit of g is not 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '−48', false, 'The value −48 is 12 · (−4), the product of the limits. The question asks about the quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '16', false, 'The value 16 is 12 − (−4), the difference of the limits. The question asks about the quotient.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', true, 'Correct: The values of f approach 12 and the values of g approach −4 from both sides. The limit of the quotient is 12/(−4) = −3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.3-a-v2','apcalcab-mcq-b6-sv-h-1.3-a-v3','apcalcab-mcq-b6-h-1.3-b','apcalcab-mcq-b6-sv-h-1.3-b-v1','apcalcab-mcq-b6-sv-h-1.3-b-v2','apcalcab-mcq-b6-sv-h-1.3-b-v3','apcalcab-mcq-b6-h-1.4-a','apcalcab-mcq-b6-sv-h-1.4-a-v1','apcalcab-mcq-b6-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-sv-h-1.3-a-v2','apcalcab-mcq-b6-sv-h-1.3-a-v3','apcalcab-mcq-b6-h-1.3-b','apcalcab-mcq-b6-sv-h-1.3-b-v1','apcalcab-mcq-b6-sv-h-1.3-b-v2','apcalcab-mcq-b6-sv-h-1.3-b-v3','apcalcab-mcq-b6-h-1.4-a','apcalcab-mcq-b6-sv-h-1.4-a-v1','apcalcab-mcq-b6-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
