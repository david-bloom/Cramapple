begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.3-a-v2','apcalcbc-mcq-b6-sv-h-1.3-a-v3','apcalcbc-mcq-b6-h-1.3-b','apcalcbc-mcq-b6-sv-h-1.3-b-v1','apcalcbc-mcq-b6-sv-h-1.3-b-v2','apcalcbc-mcq-b6-sv-h-1.3-b-v3','apcalcbc-mcq-b6-h-1.4-a','apcalcbc-mcq-b6-sv-h-1.4-a-v1','apcalcbc-mcq-b6-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.3-a-v2', 'mcq', 'transform one-sided limits read from a graph through a reflection, shift, or scaling of the input, tracking which side i (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has lim(x→6⁻) f(x) = 2, lim(x→6⁺) f(x) = −3, and f(6) = 0. Let g(x) = f(3x). What is lim(x→2⁺) g(x)?', null, md5('apcalcbc-mcq-b6-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'The value 2 is the left-hand limit of f at 6, but for x > 2 the input 3x is greater than 6, so the right-hand limit applies.' from version_ins
union all select gen_random_uuid(), id, 'B', '0', false, 'The value 0 is f(6), which does not determine a limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'Dividing −3 by 3 treats the scaling as acting on the output; replacing x by 3x changes where f is evaluated, not the values f takes.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', true, 'Correct: For x > 2 near 2, 3x > 6 near 6, so g(x) → lim(u→6⁺) f(u) = −3.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.3-a-v3', 'mcq', 'transform one-sided limits read from a graph through a reflection, shift, or scaling of the input, tracking which side i (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f has lim(x→2⁻) f(x) = 6, lim(x→2⁺) f(x) = 1, and f(2) = 3. Let g(x) = −f(x + 4). What is lim(x→−2⁻) g(x)?', null, md5('apcalcbc-mcq-b6-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6', true, 'Correct: For x < −2 near −2, x + 4 < 2 near 2, so f(x + 4) → 6 and g(x) → −6.' from version_ins
union all select gen_random_uuid(), id, 'B', '6', false, 'As x approaches −2 from the left, x + 4 approaches 2 from the left and f approaches 6, but the leading minus sign in g makes the value −6.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1', false, 'As x approaches −2 from the left, x + 4 is less than 2, so the left-hand limit 6 applies, not the right-hand limit 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3', false, 'The value −3 is −f(2); a limit depends on values of f near 2, not at 2.' from version_ins;
-- apcalcbc-mcq-b6-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.3-b', 'mcq', 'count points where a limit exists but differs from the function value or the value is undefined, from a verbal descripti', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined on (−3, 4) with this behavior. At x = −2: f(−2) = 3 and lim(x→−2) f(x) = 1. At x = 0: f(0) = 2, lim(x→0⁻) f(x) = 2, and lim(x→0⁺) f(x) = −2. At x = 1: f(1) is undefined and lim(x→1) f(x) = 0. At x = 3: f(3) = 4 and lim(x→3) f(x) = 4. Elsewhere on (−3, 4), f is continuous. At how many values of c in (−3, 4) does lim(x→c) f(x) exist but not equal f(c), including the case where f(c) is undefined?', null, md5('apcalcbc-mcq-b6-h-1.3-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'Only x = −2 has a defined value different from the limit; the limit at x = 1 also exists and does not equal an undefined f(1), so it counts as well.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'The point x = 0 has a jump, so lim(x→0) f(x) does not exist, and the question counts only points where the limit exists.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: Count x = −2 (limit 1, value 3) and x = 1 (limit 0, no value); x = 0 has no limit and x = 3 has limit equal to f(3).' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'The points x = 0 and x = 3 should not be counted: the limit at 0 does not exist and at 3 the limit equals f(3).' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.3-b-v1', 'mcq', 'count points where a limit exists but differs from the function value or the value is undefined, from a verbal descripti (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function g is defined on (−2, 5) with this behavior. At x = −1: g(−1) = −2 and lim(x→−1) g(x) = 0. At x = 0: g(0) = −3 and lim(x→0) g(x) = 2. At x = 1: g(1) = 3 and lim(x→1) g(x) = 3. At x = 2: lim(x→2⁻) g(x) = 1, lim(x→2⁺) g(x) = 4, and g(2) = 1. At x = 3: g(3) is undefined and lim(x→3) g(x) = 2. Elsewhere on (−2, 5), g is continuous. At how many values of c in (−2, 5) does lim(x→c) g(x) exist but not equal g(c), including the case where g(c) is undefined?', null, md5('apcalcbc-mcq-b6-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'The limit at x = 3 exists and g(3) is undefined, so the limit does not equal g(3) and the point counts; omitting it gives 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', true, 'Correct: Count x = −1 (0 vs −2), x = 0 (2 vs −3), and x = 3 (2 vs undefined); x = 1 matches and x = 2 has no limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'The point x = 2 has a jump, so the limit there does not exist and it should not be counted.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'Counting all listed points includes x = 1, where the limit equals g(1), and x = 2, where the limit does not exist.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.3-b-v2', 'mcq', 'count points where a limit exists but differs from the function value or the value is undefined, from a verbal descripti (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function h is defined on (−4, 3) with this behavior. At x = −2: h(−2) = 1, lim(x→−2⁻) h(x) = 1, and lim(x→−2⁺) h(x) = −1. At x = 0: h(0) is undefined and lim(x→0) h(x) = 2. At x = 1: h(1) = 0 and lim(x→1) h(x) = 0. At x = 2: lim(x→2⁻) h(x) = ∞. Elsewhere on (−4, 3), h is continuous. At how many values of c in (−4, 3) does lim(x→c) h(x) exist as a real number but not equal h(c), including the case where h(c) is undefined?', null, md5('apcalcbc-mcq-b6-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', false, 'A limit can exist where the function is undefined; at x = 0 the limit is 2 and h(0) does not exist, so the point counts.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', true, 'Correct: Only x = 0 qualifies; x = −2 has a jump, x = 1 has limit equal to h(1), and x = 2 has an infinite limit.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'The point x = −2 has a jump, so there is no limit there, and it should not be counted.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'Counting x = −2, 0, and 2 includes a jump and an infinite limit, where the limit does not exist as a real number.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.3-b-v3', 'mcq', 'count points where a limit exists but differs from the function value or the value is undefined, from a verbal descripti (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function k is defined on (−3, 4) with this behavior. At x = −2: k(−2) = 5 and lim(x→−2) k(x) = 5. At x = −1: k(−1) = 0 and lim(x→−1) k(x) = 3. At x = 1/2: k(1/2) is undefined and lim(x→1/2) k(x) = −1. At x = 2: lim(x→2⁻) k(x) = 0 and lim(x→2⁺) k(x) = 3. At x = 3: k(3) = 2 and lim(x→3) k(x) = 2. Elsewhere on (−3, 4), k is continuous. At how many values of c in (−3, 4) does lim(x→c) k(x) exist but not equal k(c), including the case where k(c) is undefined?', null, md5('apcalcbc-mcq-b6-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1', false, 'The limit at x = 1/2 exists and k(1/2) is undefined, so the limit does not equal k(1/2) and the point counts; omitting it gives 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'The point x = 2 has a jump so no limit exists there, and it must not be counted.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', true, 'Correct: Count x = −1 (3 vs 0) and x = 1/2 (−1 vs undefined); x = −2 and x = 3 match, and x = 2 has no limit.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'Counting all five listed points includes x = −2 and x = 3, where the limit equals the function value, and x = 2, where no limit exists.' from version_ins;
-- apcalcbc-mcq-b6-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.4-a', 'mcq', 'estimate a limit from a two-sided table, then transform it algebraically while ignoring the defined value at the point.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of f(x) = (e^(2x) − 1)/x near x = 0, and f(0) is defined to be 1. f(-0.1) = 1.8127; f(-0.01) = 1.9801; f(-0.001) = 1.9980; f(0.001) = 2.0020; f(0.01) = 2.0201; f(0.1) = 2.2140. Based on the table, what is the best estimate of lim(x→0) (3f(x) − 1)?', null, md5('apcalcbc-mcq-b6-h-1.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2', false, 'This uses f(0) = 1, giving 3·1 − 1 = 2, but a limit is determined by the values of f near 0, which approach 2, not by f(0).' from version_ins
union all select gen_random_uuid(), id, 'B', '3', false, 'This computes 3(f − 1) with f approaching 2, which puts the 1 inside the multiple; the expression is 3f(x) minus 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'The table gives f(x) → 2, so 3f(x) → 6, but the expression also subtracts 1, giving 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', true, 'Correct: Values of f approach 2 from both sides, so 3f(x) − 1 approaches 3·2 − 1 = 5.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.4-a-v1', 'mcq', 'estimate a limit from a two-sided table, then transform it algebraically while ignoring the defined value at the point. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of f(x) = ln(1 + 4x)/x near x = 0, and f(0) is defined to be 6. f(-0.1) = 5.1083; f(-0.01) = 4.0822; f(-0.001) = 4.0080; f(0.001) = 3.9920; f(0.01) = 3.9221; f(0.1) = 3.3647. Based on the table, what is the best estimate of lim(x→0) (f(x)/2 + 1)?', null, md5('apcalcbc-mcq-b6-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3', true, 'Correct: Values of f approach 4 from both sides, so f(x)/2 + 1 approaches 4/2 + 1 = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '4', false, 'This uses f(0) = 6, giving 6/2 + 1 = 4, but the limit depends on values of f near 0, which approach 4, not on f(0).' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'The table gives f(x)/2 approaching 2, but the expression also adds 1, so the limit is 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '5', false, 'This adds 1 to f(x) but never halves it, giving 4 + 1 = 5; the expression is f(x)/2 + 1, which tends to 2 + 1.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.4-a-v2', 'mcq', 'estimate a limit from a two-sided table, then transform it algebraically while ignoring the defined value at the point. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table shows values of f(x) = (1 − cos 2x)/x² near x = 0, and f(0) is defined to be 0. f(-0.1) = 1.9933; f(-0.01) = 1.9999; f(-0.001) = 2.0000; f(0.001) = 2.0000; f(0.01) = 1.9999; f(0.1) = 1.9933. Based on the table, what is the best estimate of lim(x→0) (f(x)² − 1)?', null, md5('apcalcbc-mcq-b6-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−1', false, 'This uses f(0) = 0, giving 0² − 1 = −1, but the limit depends on values near 0, which approach 2.' from version_ins
union all select gen_random_uuid(), id, 'B', '1', false, 'This computes f(x) − 1 with f approaching 2; the expression squares f(x) first, so the limit is 2² − 1.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'The table gives f(x)² → 4, but the expression also subtracts 1, so the limit is 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'Correct: Values of f approach 2 from both sides, so f(x)² − 1 approaches 4 − 1 = 3.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-sv-h-1.3-a-v2','apcalcbc-mcq-b6-sv-h-1.3-a-v3','apcalcbc-mcq-b6-h-1.3-b','apcalcbc-mcq-b6-sv-h-1.3-b-v1','apcalcbc-mcq-b6-sv-h-1.3-b-v2','apcalcbc-mcq-b6-sv-h-1.3-b-v3','apcalcbc-mcq-b6-h-1.4-a','apcalcbc-mcq-b6-sv-h-1.4-a-v1','apcalcbc-mcq-b6-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-sv-h-1.3-a-v2','apcalcbc-mcq-b6-sv-h-1.3-a-v3','apcalcbc-mcq-b6-h-1.3-b','apcalcbc-mcq-b6-sv-h-1.3-b-v1','apcalcbc-mcq-b6-sv-h-1.3-b-v2','apcalcbc-mcq-b6-sv-h-1.3-b-v3','apcalcbc-mcq-b6-h-1.4-a','apcalcbc-mcq-b6-sv-h-1.4-a-v1','apcalcbc-mcq-b6-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
