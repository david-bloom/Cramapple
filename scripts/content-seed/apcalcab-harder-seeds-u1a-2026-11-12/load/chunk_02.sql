begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.2-a-v1','apcalcab-mcq-b6-sv-h-1.2-a-v2','apcalcab-mcq-b6-sv-h-1.2-a-v3','apcalcab-mcq-b6-h-1.2-b','apcalcab-mcq-b6-sv-h-1.2-b-v1','apcalcab-mcq-b6-sv-h-1.2-b-v2','apcalcab-mcq-b6-sv-h-1.2-b-v3','apcalcab-mcq-b6-h-1.3-a','apcalcab-mcq-b6-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.2-a-v1', 'mcq', 'evaluate a limit of f(g(x)) by determining from which side the inner expression approaches the point, using one-sided li (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→1⁻) f(x) = 2, lim(x→1⁺) f(x) = 6, and f(1) = −4. What is lim(x→0) f(1 + x²)?', null, md5('apcalcab-mcq-b6-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'The value 2 is the limit of f as its input approaches 1 from the left. Since 1 + x² is always greater than 1, the input approaches 1 from the right.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4', false, 'The value −4 is f(1), but 1 + x² never equals 1 when x ≠ 0. A limit uses nearby values of f and ignores the value at the point.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', true, 'Correct: For x ≠ 0 near 0, 1 + x² is slightly greater than 1, so the input to f approaches 1 from the right only. The limit is the right-hand limit of f at 1, which is 6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'The one-sided limits of f differ, but the input 1 + x² approaches 1 from one side only. Only the right-hand limit of f is involved, so the limit exists and equals 6.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.2-a-v2', 'mcq', 'evaluate a limit of f(g(x)) by determining from which side the inner expression approaches the point, using one-sided li (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→3⁻) f(x) = −5, lim(x→3⁺) f(x) = 4, and f(3) = 0. What is lim(x→1) f(3 − |x − 1|)?', null, md5('apcalcab-mcq-b6-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4', false, 'The value 4 is the limit of f as its input approaches 3 from the right. Because |x − 1| is positive, 3 − |x − 1| lies below 3, so the input approaches 3 from the left.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The value 0 is f(3), reached only if the input equals 3 exactly. The limit looks at inputs near 3 but not equal to it when x ≠ 1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist', false, 'The two one-sided limits of f at 3 disagree, but the input approaches 3 from one side only. The relevant one-sided limit is −5, so the limit exists.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5', true, 'Correct: For x ≠ 1 near 1, 3 − |x − 1| is slightly less than 3, so the input to f approaches 3 from the left only. The limit is the left-hand limit of f at 3, which is −5.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.2-a-v3', 'mcq', 'evaluate a limit of f(g(x)) by determining from which side the inner expression approaches the point, using one-sided li (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f satisfies lim(x→−2⁻) f(x) = 1, lim(x→−2⁺) f(x) = −3, and f(−2) = 2. What is lim(x→2) f(−2 + (x − 2)²)?', null, md5('apcalcab-mcq-b6-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'The value 1 is the limit of f as its input approaches −2 from the left. Since (x − 2)² is positive, the input −2 + (x − 2)² lies above −2 and approaches from the right.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3', true, 'Correct: For x ≠ 2 near 2, −2 + (x − 2)² is slightly greater than −2, so the input to f approaches −2 from the right only. The limit is the right-hand limit of f at −2, which is −3.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'The value 2 is f(−2). The inner expression equals −2 only at x = 2, and a limit ignores the value at the point and uses nearby inputs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'The one-sided limits of f at −2 differ, but the input approaches −2 from one side only. The limit exists and equals the right-hand value.' from version_ins;
-- apcalcab-mcq-b6-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.2-b', 'mcq', 'set one-sided limits equal to find a parameter for which a two-sided limit exists, ignoring the function value at the po', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = kx + 1 for x < 2, f(2) = 10, and f(x) = x² − k for x > 2, where k is a constant. For which value of k does lim(x→2) f(x) exist?', null, md5('apcalcab-mcq-b6-h-1.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 9/2', false, 'This sets 2k + 1 = f(2) = 10. The value of f at 2 does not affect whether the limit exists; the two one-sided limits must be equal to each other.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 1', true, 'Correct: The left-hand limit is 2k + 1 and the right-hand limit is 4 − k. Setting 2k + 1 = 4 − k gives 3k = 3, so k = 1, and both one-sided limits equal 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 3', false, 'This sets 2k + 1 = 4 + k, replacing the right-hand limit 4 − k with 4 + k. The right piece is x² − k, which tends to 4 − k.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 4/3', false, 'This sets 2k = 4 − k and drops the constant term 1 from the left piece. The left-hand limit is 2k + 1, so 2k + 1 = 4 − k is the correct equation.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.2-b-v1', 'mcq', 'set one-sided limits equal to find a parameter for which a two-sided limit exists, ignoring the function value at the po (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = kx − 1 for x < 2, f(2) = 0, and f(x) = x² + k for x > 2, where k is a constant. For which value of k does lim(x→2) f(x) exist?', null, md5('apcalcab-mcq-b6-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 1/2', false, 'This sets 2k − 1 = f(2) = 0. The limit''s existence depends on the two one-sided limits agreeing, not on the value of f at 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 5/3', false, 'This sets 2k − 1 = 4 − k, using −k for the right piece. The right piece is x² + k, so its limit is 4 + k.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 5', true, 'Correct: The left-hand limit is 2k − 1 and the right-hand limit is 4 + k. Setting 2k − 1 = 4 + k gives k = 5, and both one-sided limits equal 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 4', false, 'This sets 2k = 4 + k and drops the constant −1 from the left piece. The left-hand limit is 2k − 1, so the equation 2k − 1 = 4 + k is needed.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.2-b-v2', 'mcq', 'set one-sided limits equal to find a parameter for which a two-sided limit exists, ignoring the function value at the po (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = kx + 2 for x < 3, f(3) = 7, and f(x) = 14 − kx for x > 3, where k is a constant. For which value of k does lim(x→3) f(x) exist?', null, md5('apcalcab-mcq-b6-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 5/3', false, 'This sets 3k + 2 = f(3) = 7. The value f(3) plays no role in whether the limit exists; the one-sided limits must match each other.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 7/3', false, 'This sets 3k = 14 − 3k and drops the constant 2 from the left piece. The left-hand limit is 3k + 2, so both pieces'' constants must be kept.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 3', false, 'This sets 3k + 2 = 14 − k, forgetting to multiply k by 3 in the right piece. The right-hand limit is 14 − 3k.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 2', true, 'Correct: The left-hand limit is 3k + 2 and the right-hand limit is 14 − 3k. Setting 3k + 2 = 14 − 3k gives 6k = 12, so k = 2, and both one-sided limits equal 8.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.2-b-v3', 'mcq', 'set one-sided limits equal to find a parameter for which a two-sided limit exists, ignoring the function value at the po (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be defined by f(x) = kx² + 1 for x < 1, f(1) = 0, and f(x) = 9 − kx for x > 1, where k is a constant. For which value of k does lim(x→1) f(x) exist?', null, md5('apcalcab-mcq-b6-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 4', true, 'Correct: The left-hand limit is k + 1 and the right-hand limit is 9 − k. Setting k + 1 = 9 − k gives k = 4, and both one-sided limits equal 5.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = −1', false, 'This sets k + 1 = f(1) = 0. The value of f at 1 does not decide whether the limit exists; the one-sided limits must equal each other.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 9/2', false, 'This sets k = 9 − k and drops the constant 1 from the left piece. The left-hand limit is k + 1, not k.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 5', false, 'This sets k − 1 = 9 − k, a sign slip that turns the +1 in kx² + 1 into −1. The left-hand limit is k + 1.' from version_ins;
-- apcalcab-mcq-b6-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.3-a', 'mcq', 'read a verbally described graph at several points and distinguish where a finite limit exists from where the function va', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f on [0, 8] has these features. At x = 1 the curve jumps: it approaches height 2 from the left and height 5 from the right, and the filled point is (1, 2). At x = 3 the curve on both sides approaches height 4, there is an open circle at (3, 4), and the only filled point on the line x = 3 is (3, 1). At x = 5 the curve rises without bound on both sides of a vertical asymptote. At x = 7 the curve is smooth and passes through the filled point (7, 3). At how many of the values x = 1, 3, 5, 7 does lim(x→a) f(x) exist as a finite number?', null, md5('apcalcab-mcq-b6-h-1.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', true, 'Correct: The limit exists at x = 3 (both sides approach 4) and at x = 7 (smooth curve through (7, 3)). It fails at x = 1 (one-sided limits 2 and 5 differ) and at x = 5 (the curve is unbounded). That is 2 values.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'Only x = 7 has a point on the curve at the limit value, which gives 1. But x = 3 also has a limit of 4, even though the filled point (3, 1) is elsewhere; the value of f(3) does not matter.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'Counting x = 1 because the filled point (1, 2) matches the left-hand limit, or counting x = 5 for its infinite behavior, gives 3. At x = 1 the one-sided limits differ, and at x = 5 the curve increases without bound, which is not a finite limit.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'A limit exists at every listed value only if the curve approaches a single finite height from both sides. The jump at x = 1 and the vertical asymptote at x = 5 prevent that.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.3-a-v1', 'mcq', 'read a verbally described graph at several points and distinguish where a finite limit exists from where the function va (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has these features. At x = −3 the curve rises to +∞ on the left side of a vertical asymptote and falls to −∞ on the right side. At x = −1 the curve approaches height 0 from both sides, but the only filled point on the line x = −1 is (−1, 3). At x = 1 there is an open circle at (1, 2) with the curve approaching 2 from both sides and no filled point on that line. At x = 3 the graph has a sharp corner at the filled point (3, 1), with the curve approaching 1 from both sides. At x = 5 the curve approaches height 1 from the left and height −1 from the right, and the filled point is (5, −1). At how many of the values x = −3, −1, 1, 3, 5 does lim(x→a) f(x) exist as a finite number?', null, md5('apcalcab-mcq-b6-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'Counting only x = 3, where the filled point lies on the curve, gives 1. The limit also exists at x = −1 and x = 1, even though f(−1) is displaced and f(1) is undefined.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'Counting x = 5 because the filled point (5, −1) matches the right-hand limit gives 4. A two-sided limit needs both one-sided limits to agree, and 1 and −1 do not.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', true, 'Correct: The limit exists at x = −1 (both sides approach 0), at x = 1 (both sides approach 2), and at x = 3 (both sides approach 1). It fails at x = −3 (unbounded) and at x = 5 (one-sided limits 1 and −1 differ). That is 3 values.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'Every listed x has some visible feature, but a limit exists only where both sides approach the same finite height. The vertical asymptote at x = −3 and the jump at x = 5 break this.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.2-a-v1','apcalcab-mcq-b6-sv-h-1.2-a-v2','apcalcab-mcq-b6-sv-h-1.2-a-v3','apcalcab-mcq-b6-h-1.2-b','apcalcab-mcq-b6-sv-h-1.2-b-v1','apcalcab-mcq-b6-sv-h-1.2-b-v2','apcalcab-mcq-b6-sv-h-1.2-b-v3','apcalcab-mcq-b6-h-1.3-a','apcalcab-mcq-b6-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-sv-h-1.2-a-v1','apcalcab-mcq-b6-sv-h-1.2-a-v2','apcalcab-mcq-b6-sv-h-1.2-a-v3','apcalcab-mcq-b6-h-1.2-b','apcalcab-mcq-b6-sv-h-1.2-b-v1','apcalcab-mcq-b6-sv-h-1.2-b-v2','apcalcab-mcq-b6-sv-h-1.2-b-v3','apcalcab-mcq-b6-h-1.3-a','apcalcab-mcq-b6-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
