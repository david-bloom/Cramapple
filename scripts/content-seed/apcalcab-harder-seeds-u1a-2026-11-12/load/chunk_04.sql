begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.4-a-v3','apcalcab-mcq-b6-h-1.4-b','apcalcab-mcq-b6-sv-h-1.4-b-v1','apcalcab-mcq-b6-sv-h-1.4-b-v2','apcalcab-mcq-b6-sv-h-1.4-b-v3','apcalcab-mcq-b6-h-1.5-a','apcalcab-mcq-b6-sv-h-1.5-a-v1','apcalcab-mcq-b6-sv-h-1.5-a-v2','apcalcab-mcq-b6-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apcalcab-mcq-b6-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.4-a-v3', 'mcq', 'estimate two limits from tables of values near a point where both functions are undefined, then combine them (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two functions f and g are both undefined at x = 3. Their values near 3 are given for x = 2.99, 2.999, 3.001, 3.01: f(x) = 5.99, 5.999, 6.001, 6.01; g(x) = 26.9101, 26.991, 27.009, 27.0901. Based on the table, what is lim(x→3) g(x)/f(x)?', null, md5('apcalcab-mcq-b6-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/9', false, 'The value 2/9 is 6/27, which inverts the quotient. The question asks for g divided by f.' from version_ins
union all select gen_random_uuid(), id, 'B', '162', false, 'The value 162 is 27 · 6, the product of the limits. The question asks about the quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '21', false, 'The value 21 is 27 − 6, the difference of the limits. The question asks about the quotient.' from version_ins
union all select gen_random_uuid(), id, 'D', '9/2', true, 'Correct: The values of f approach 6 and the values of g approach 27. The limit of g(x)/f(x) is 27/6 = 9/2.' from version_ins;
-- apcalcab-mcq-b6-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.4-b', 'mcq', 'judge what a table of sampled values can and cannot establish about a limit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function g, the table shows g(x) = 0 at each of the inputs x = −0.1, −0.01, −0.001, 0.001, 0.01, and 0.1. The function is undefined at x = 0. Which statement about lim(x→0) g(x) is best supported by the table alone?', null, md5('apcalcab-mcq-b6-h-1.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The table is consistent with a limit of 0, but it lists only a few inputs, so it cannot establish the limit.', true, 'Correct: A table samples finitely many inputs, so values that agree at those inputs do not rule out different behavior between them. The table suggests 0 but does not prove it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is 0, because g(x) = 0 on both sides of x = 0 and the values never change.', false, 'The tabulated values are 0, but a table gives only sampled inputs. A function can equal 0 at the sampled inputs and still take other values between them, so the table alone does not prove the limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist, because g is undefined at x = 0.', false, 'Whether g is defined at 0 has no effect on the limit. A limit can exist at a point where the function is undefined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 0.001, because that is the input closest to 0.', false, 'The limit is a value the outputs approach, not the closest input listed. The listed outputs are all 0, so 0.001 does not come from the table.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.4-b-v1', 'mcq', 'judge what a table of sampled values can and cannot establish about a limit (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sensor''s reading is R(t) = cos(π/t) volts at time t seconds. The table shows R(t) = 1 at each of the inputs t = 0.5, 0.25, 0.125, and 0.1 (since 2π, 4π, 8π, and 10π are multiples of 2π). Which statement about lim(t→0⁺) R(t) is best supported by the table alone?', null, md5('apcalcab-mcq-b6-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is 1, because the readings equal 1 at every input in the table.', false, 'Equal readings at sampled inputs do not guarantee the outputs stay near 1 at the inputs not listed. The table alone cannot prove the limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The table is consistent with a limit of 1, but it lists only a few inputs, so it cannot establish the limit.', true, 'Correct: The tabulated values are all 1, but the table samples only specific inputs. Other inputs close to 0 could give different readings, so the table suggests 1 without proving it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 0, because the inputs in the table approach 0.', false, 'The limit describes the outputs, not the inputs. The outputs in the table are all 1, so nothing in the table points to 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit cannot be discussed, because R(0) is undefined.', false, 'A limit does not need the function to be defined at the point. The table can still suggest a value for the limit, even though it cannot prove it.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.4-b-v2', 'mcq', 'judge what a table of sampled values can and cannot establish about a limit (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function p, the table shows p(x) = 0 at each of the inputs x = −0.5, −0.25, −0.1, −0.05, 0.05, 0.1, 0.25, and 0.5. The function is undefined at x = 0. Which statement about lim(x→0) p(x) is best supported by the table alone?', null, md5('apcalcab-mcq-b6-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is 0, because p(x) = 0 at inputs on both sides of 0.', false, 'Having values on both sides is necessary for a limit estimate but not sufficient. Unlisted inputs might give other values, so the table does not prove the limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The table is consistent with a limit of 0, but it lists only a few inputs, so it cannot establish the limit.', true, 'Correct: Only eight sampled inputs are listed. Different behavior at the unlisted inputs near 0 would be invisible in the table, so the table suggests 0 but cannot prove it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit does not exist, because p(0) is undefined and the table has no value there.', false, 'A limit does not depend on the value, or lack of one, at the point itself. Only the behavior of p near 0 matters.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit is 0.05, because that is the smallest input in absolute value.', false, 'The limit is about outputs, not inputs. The outputs in the table are all 0, so 0.05 has no support from the data.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.4-b-v3', 'mcq', 'judge what a table of sampled values can and cannot establish about a limit (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A signal is w(x) = 5 + 3 sin(π/x). The table shows w(x) = 5 at each of the inputs x = 0.5, 0.2, 0.1, and 0.05 (since π/x equals 2π, 5π, 10π, and 20π, and sin of each is 0). Which statement about lim(x→0⁺) w(x) is best supported by the table alone?', null, md5('apcalcab-mcq-b6-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The limit is 5, because every tabulated output equals 5.', false, 'Identical outputs at four sampled inputs do not show the outputs stay near 5 at the unlisted inputs. The table is evidence, not proof.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The limit is 0, because the inputs approach 0.', false, 'The limit is the value the outputs approach. The tabulated outputs are 5, not 0, so nothing supports 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The limit is 8, because w can be as large as 5 + 3.', false, 'The maximum possible output is not the limit. The table shows only outputs equal to 5, and the table does not support any other limit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The table is consistent with a limit of 5, but it lists only a few inputs, so it cannot establish the limit.', true, 'Correct: All four tabulated outputs equal 5, but the table samples only a few inputs. Other inputs near 0 could give different outputs, so the table suggests 5 without proving it.' from version_ins;
-- apcalcab-mcq-b6-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-h-1.5-a', 'mcq', 'recover individual limits from limits of linear combinations using limit properties, then evaluate a new expression', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→3) [2f(x) − g(x)] = 7 and lim(x→3) [f(x) + g(x)] = 2. What is lim(x→3) f(x)·g(x)?', null, md5('apcalcab-mcq-b6-h-1.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−3', true, 'Correct: Adding the two limits gives lim 3f(x) = 9, so lim f(x) = 3, and then lim g(x) = 2 − 3 = −1. The limit of the product is 3 · (−1) = −3.' from version_ins
union all select gen_random_uuid(), id, 'B', '14', false, 'The value 14 multiplies the two given limits, 7 · 2. The product of the limits of the combinations is not the limit of f(x)g(x).' from version_ins
union all select gen_random_uuid(), id, 'C', '−15', false, 'This comes from reading the first limit as the limit of 2f(x) + g(x), which would give f = 5 and g = −3. The first combination subtracts g(x).' from version_ins
union all select gen_random_uuid(), id, 'D', '6', false, 'The value 6 is 3 · 2, the limit of f(x) times the limit of the second combination. The product must use lim f and lim g.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.5-a-v1', 'mcq', 'recover individual limits from limits of linear combinations using limit properties, then evaluate a new expression (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→−1) [f(x) + g(x)] = 5 and lim(x→−1) [f(x) − g(x)] = 1. What is lim(x→−1) [(f(x))² − g(x)]?', null, md5('apcalcab-mcq-b6-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'The value 5 multiplies the two given limits, 5 · 1, which is the limit of (f(x))² − (g(x))², not the requested expression.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', true, 'Correct: Adding the limits gives lim 2f(x) = 6, so lim f(x) = 3, and then lim g(x) = 5 − 3 = 2. The limit of (f(x))² − g(x) is 3² − 2 = 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '11', false, 'The value 11 is 3² + 2, a sign error that adds g(x) instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'D', '9', false, 'The value 9 is 3², the limit of (f(x))² alone. The limit of g(x), which is 2, still has to be subtracted.' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.5-a-v2', 'mcq', 'recover individual limits from limits of linear combinations using limit properties, then evaluate a new expression (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→5) [2f(x) + 3g(x)] = 1 and lim(x→5) [f(x) − g(x)] = 3. What is lim(x→5) f(x)/g(x)?', null, md5('apcalcab-mcq-b6-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/3', false, 'The value 1/3 divides the first given limit by the second. The question asks about the quotient f(x)/g(x), which needs lim f and lim g.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2', true, 'Correct: Writing f = g + 3 in the limits gives 2(L + 3) + 3L = 1, so L = −1, where L = lim g(x), and lim f(x) = 2. The limit of the quotient is 2/(−1) = −2.' from version_ins
union all select gen_random_uuid(), id, 'C', '2', false, 'The value 2 is lim f(x), or the quotient with the wrong sign for lim g(x). The limit of g(x) is −1, so the quotient is negative.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/2', false, 'The value −1/2 inverts the quotient, giving lim g divided by lim f. The question asks for f(x) divided by g(x).' from version_ins;
-- apcalcab-mcq-b6-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b6-sv-h-1.5-a-v3', 'mcq', 'recover individual limits from limits of linear combinations using limit properties, then evaluate a new expression (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Suppose lim(x→0) [f(x) + g(x)] = −2 and lim(x→0) [2f(x) − g(x)] = 11. What is lim(x→0) [(g(x))² − f(x)]?', null, md5('apcalcab-mcq-b6-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28', false, 'The value 28 is 25 + 3, a sign error that adds f(x) instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'B', '22', true, 'Correct: Adding the limits gives lim 3f(x) = 9, so lim f(x) = 3, and then lim g(x) = −2 − 3 = −5. The limit of (g(x))² − f(x) is 25 − 3 = 22.' from version_ins
union all select gen_random_uuid(), id, 'C', '−22', false, 'The value −22 is 3 − 25, the limit of f(x) − (g(x))² with the order reversed. The question subtracts f(x) from (g(x))².' from version_ins
union all select gen_random_uuid(), id, 'D', '64', false, 'The value 64 is (−5 − 3)², the square of g − f. The expression squares only g(x) and then subtracts f(x).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b6-sv-h-1.4-a-v3','apcalcab-mcq-b6-h-1.4-b','apcalcab-mcq-b6-sv-h-1.4-b-v1','apcalcab-mcq-b6-sv-h-1.4-b-v2','apcalcab-mcq-b6-sv-h-1.4-b-v3','apcalcab-mcq-b6-h-1.5-a','apcalcab-mcq-b6-sv-h-1.5-a-v1','apcalcab-mcq-b6-sv-h-1.5-a-v2','apcalcab-mcq-b6-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b6-sv-h-1.4-a-v3','apcalcab-mcq-b6-h-1.4-b','apcalcab-mcq-b6-sv-h-1.4-b-v1','apcalcab-mcq-b6-sv-h-1.4-b-v2','apcalcab-mcq-b6-sv-h-1.4-b-v3','apcalcab-mcq-b6-h-1.5-a','apcalcab-mcq-b6-sv-h-1.5-a-v1','apcalcab-mcq-b6-sv-h-1.5-a-v2','apcalcab-mcq-b6-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
