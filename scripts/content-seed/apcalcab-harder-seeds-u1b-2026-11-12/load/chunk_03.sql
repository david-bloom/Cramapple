begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.11-a-v2','apcalcab-mcq-b7-sv-h-1.11-a-v3','apcalcab-mcq-b7-h-1.11-b','apcalcab-mcq-b7-sv-h-1.11-b-v1','apcalcab-mcq-b7-sv-h-1.11-b-v2','apcalcab-mcq-b7-sv-h-1.11-b-v3','apcalcab-mcq-b7-h-1.12-a','apcalcab-mcq-b7-sv-h-1.12-a-v1','apcalcab-mcq-b7-sv-h-1.12-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcab-mcq-b7-sv-h-1.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.11-a-v2', 'mcq', 'apply the three-part definition of continuity at two junctions of a three-piece function, writing and solving two linear (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = x² for x < 2, f(x) = ax + b for 2 ≤ x ≤ 4, and f(x) = 16 − x for x > 4, where a and b are constants. For what value of a is f continuous for all real x?', null, md5('apcalcab-mcq-b7-sv-h-1.11-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a = 8', false, 'This subtracts the matching values 12 − 4 without dividing by the interval length 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a = 3', false, 'This assumes b = 0 in the condition at x = 4, 4a = 12, and ignores x = 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a = 2', false, 'This assumes b = 0 in the condition at x = 2, 2a = 4, and ignores x = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a = 4', true, 'Correct: At 2: 2a + b = 4. At 4: 4a + b = 12. Subtracting gives 2a = 8, so a = 4 (and b = −4).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.11-a-v3', 'mcq', 'apply the three-part definition of continuity at two junctions of a three-piece function, writing and solving two linear (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = x³ for x < 1, f(x) = ax + b for 1 ≤ x ≤ 2, and f(x) = 12 − x² for x > 2, where a and b are constants. For what value of b is f continuous for all real x?', null, md5('apcalcab-mcq-b7-sv-h-1.11-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'b = −6', true, 'Correct: At 1: a + b = 1. At 2: 2a + b = 8. Subtracting gives a = 7, so b = 1 − 7 = −6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'b = 6', false, 'This finds a = 7 correctly but makes a sign error in b = 1 − a.' from version_ins
union all select gen_random_uuid(), id, 'C', 'b = 1', false, 'This assumes a = 0 in the condition at x = 1, a + b = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'b = 7', false, 'This reports a = 7, the slope, instead of the intercept b.' from version_ins;
-- apcalcab-mcq-b7-h-1.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.11-b', 'mcq', 'find the parameter values that make a piecewise function continuous at a point when the matching condition is a quadrati', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = kx − 3 for x < 3 and f(x) = x + k² − 4 for x ≥ 3, where k is a constant. For which values of k is f continuous at x = 3?', null, md5('apcalcab-mcq-b7-h-1.11-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −1 or k = −2', false, 'This solves k² − 3k + 2 = 0 with the signs of the roots reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 2/3', false, 'This drops the k² term from the right-hand piece, leaving 3k − 3 = −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 1 or k = 2', true, 'Correct: Left limit 3k − 3, f(3) = 3 + k² − 4 = k² − 1. Setting equal: k² − 3k + 2 = 0, so k = 1 or 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 0 or k = 3', false, 'This drops the constant 2 and solves k² − 3k = 0.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.11-b-v1', 'mcq', 'find the parameter values that make a piecewise function continuous at a point when the matching condition is a quadrati (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = kx + 2 for x < 2 and f(x) = x + k² − 8 for x ≥ 2, where k is a constant. For which values of k is f continuous at x = 2?', null, md5('apcalcab-mcq-b7-sv-h-1.11-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −4 or k = 2', false, 'This solves k² − 2k − 8 = 0 with the signs of the roots reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 4 or k = −2', true, 'Correct: Left limit 2k + 2; f(2) = 2 + k² − 8 = k² − 6. So k² − 2k − 8 = 0, giving k = 4 or k = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 4 only', false, 'This keeps one root of k² − 2k − 8 = 0 and discards k = −2. Both roots work, since k can be any constant.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No value of k', false, 'This follows from a sign slip that gives k² − 2k + 8 = 0, which has no real roots. The correct equation k² − 2k − 8 = 0 has two.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.11-b-v2', 'mcq', 'find the parameter values that make a piecewise function continuous at a point when the matching condition is a quadrati (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = kx + 3 for x < 2 and f(x) = x² − 4 + k² for x ≥ 2, where k is a constant. For which values of k is f continuous at x = 2?', null, md5('apcalcab-mcq-b7-sv-h-1.11-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −3 or k = 1', false, 'This solves k² − 2k − 3 = 0 with the signs of the roots reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 3 or k = −1', true, 'Correct: Left limit 2k + 3; f(2) = 4 − 4 + k² = k². So k² − 2k − 3 = 0, giving k = 3 or k = −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 3 only', false, 'This keeps one root and discards k = −1. Both roots work.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No value of k', false, 'This follows from a sign slip that gives k² − 2k + 3 = 0, which has no real roots. The correct equation k² − 2k − 3 = 0 has two.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.11-b-v3', 'mcq', 'find the parameter values that make a piecewise function continuous at a point when the matching condition is a quadrati (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f is defined by f(x) = 3kx + 10 for x < 1 and f(x) = k²x for x ≥ 1, where k is a constant. For which values of k is f continuous at x = 1?', null, md5('apcalcab-mcq-b7-sv-h-1.11-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = −5 or k = 2', false, 'This solves k² − 3k − 10 = 0 with the signs of the roots reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 5 only', false, 'This keeps one root and discards k = −2. Both roots work.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 5 or k = −2', true, 'Correct: Left limit 3k + 10, f(1) = k². So k² − 3k − 10 = 0, giving k = 5 or k = −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No value of k', false, 'This follows from a sign slip that gives k² − 3k + 10 = 0, which has no real roots. The correct equation k² − 3k − 10 = 0 has two.' from version_ins;
-- apcalcab-mcq-b7-h-1.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-h-1.12-a', 'mcq', 'decide on which closed interval a function with a radical or logarithm and a rational factor is continuous, checking the', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = √(x² − 4x)/(x − 5). On which of the following closed intervals is f continuous?', null, md5('apcalcab-mcq-b7-h-1.12-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[4, 6]', false, 'This interval contains x = 5, where the denominator is 0 and f is undefined.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 4]', false, 'For 0 < x < 4 the radicand x² − 4x is negative, so f is undefined at most points of this interval.' from version_ins
union all select gen_random_uuid(), id, 'C', '[5, 8]', false, 'The left endpoint x = 5 makes the denominator 0, so f is not defined or continuous at 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '[−3, 0]', true, 'Correct: x² − 4x ≥ 0 for x ≤ 0 or x ≥ 4, and x ≠ 5. On [−3, 0] f is defined and continuous (one-sided at the endpoint 0).' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.12-a-v1', 'mcq', 'decide on which closed interval a function with a radical or logarithm and a rational factor is continuous, checking the (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = ln(x² − 9)/(x − 5). On which of the following closed intervals is f continuous?', null, md5('apcalcab-mcq-b7-sv-h-1.12-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[−6, −4]', true, 'Correct: x² − 9 > 0 requires |x| > 3, and x ≠ 5. All of [−6, −4] satisfies this.' from version_ins
union all select gen_random_uuid(), id, 'B', '[4, 6]', false, 'This contains x = 5, where the denominator is 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '[−5, −3]', false, 'The endpoint x = −3 gives ln 0, which is undefined, so f is not defined at −3 and cannot be continuous there.' from version_ins
union all select gen_random_uuid(), id, 'D', '[−4, 4]', false, 'For −3 ≤ x ≤ 3 the argument x² − 9 is not positive, so f is undefined on much of this interval.' from version_ins;
-- apcalcab-mcq-b7-sv-h-1.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b7-sv-h-1.12-a-v2', 'mcq', 'decide on which closed interval a function with a radical or logarithm and a rational factor is continuous, checking the (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = 1/(√(x − 1) − 2). On which of the following closed intervals is f continuous?', null, md5('apcalcab-mcq-b7-sv-h-1.12-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[1, 5]', false, 'At x = 5, √4 − 2 = 0, so the denominator vanishes and f is undefined.' from version_ins
union all select gen_random_uuid(), id, 'B', '[0, 4]', false, 'For x < 1 the radical √(x − 1) is not defined, so f is not defined at x = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '[2, 6]', false, 'This contains x = 5, where the denominator is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '[1, 4]', true, 'Correct: The radical needs x ≥ 1 and the denominator is zero only at x = 5, so f is continuous on [1, 4] (one-sided at 1).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b7-sv-h-1.11-a-v2','apcalcab-mcq-b7-sv-h-1.11-a-v3','apcalcab-mcq-b7-h-1.11-b','apcalcab-mcq-b7-sv-h-1.11-b-v1','apcalcab-mcq-b7-sv-h-1.11-b-v2','apcalcab-mcq-b7-sv-h-1.11-b-v3','apcalcab-mcq-b7-h-1.12-a','apcalcab-mcq-b7-sv-h-1.12-a-v1','apcalcab-mcq-b7-sv-h-1.12-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b7-sv-h-1.11-a-v2','apcalcab-mcq-b7-sv-h-1.11-a-v3','apcalcab-mcq-b7-h-1.11-b','apcalcab-mcq-b7-sv-h-1.11-b-v1','apcalcab-mcq-b7-sv-h-1.11-b-v2','apcalcab-mcq-b7-sv-h-1.11-b-v3','apcalcab-mcq-b7-h-1.12-a','apcalcab-mcq-b7-sv-h-1.12-a-v1','apcalcab-mcq-b7-sv-h-1.12-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
