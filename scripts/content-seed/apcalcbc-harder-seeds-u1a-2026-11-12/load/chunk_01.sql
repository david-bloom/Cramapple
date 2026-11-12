begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-h-1.1-a','apcalcbc-mcq-b6-sv-h-1.1-a-v1','apcalcbc-mcq-b6-sv-h-1.1-a-v2','apcalcbc-mcq-b6-sv-h-1.1-a-v3','apcalcbc-mcq-b6-h-1.1-b','apcalcbc-mcq-b6-sv-h-1.1-b-v1','apcalcbc-mcq-b6-sv-h-1.1-b-v2','apcalcbc-mcq-b6-sv-h-1.1-b-v3','apcalcbc-mcq-b6-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b6-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.1-a', 'mcq', 'recover the instantaneous rate as the limit of an average-rate expression, and evaluate that same expression at a fixed ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function f, the average rate of change of f over the interval [2, 2 + h] is 5 + 3h + h² for every h > 0. What is the instantaneous rate of change of f at x = 2, and what is the average rate of change of f over [2, 4]?', null, md5('apcalcbc-mcq-b6-h-1.1-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Instantaneous rate 5; average rate over [2, 4] is 15', true, 'Correct: As h → 0, 5 + 3h + h² → 5; the interval [2, 4] is h = 2, so the average rate is 5 + 6 + 4 = 15.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Instantaneous rate 5; average rate over [2, 4] is 5', false, 'The instantaneous rate 5 is the limit of the expression as h approaches 0, but the average over [2, 4] corresponds to h = 2 and must use the whole expression, not only its limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Instantaneous rate 15; average rate over [2, 4] is 5', false, 'The values are swapped: the instantaneous rate is the limit of 5 + 3h + h² as h approaches 0, which is 5, while the interval [2, 4] has h = 2 and gives 15.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Instantaneous rate 5; average rate over [2, 4] is 11', false, 'The average over [2, 4] uses h = 2 in 5 + 3h + h², giving 5 + 6 + 4 = 15; the value 11 comes from dropping the h² term, which is negligible only as h approaches 0.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.1-a-v1', 'mcq', 'recover the instantaneous rate as the limit of an average-rate expression, and evaluate that same expression at a fixed  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quantity Q changes with time t in hours. Its average rate of change over [1, 1 + h] is 8 − 2h + h² units per hour for every h > 0. What is the instantaneous rate of change of Q at t = 1, and what is the average rate of change of Q over [1, 4]?', null, md5('apcalcbc-mcq-b6-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Instantaneous rate 8; average rate over [1, 4] is 11', true, 'Correct: As h → 0, 8 − 2h + h² → 8; for [1, 4], h = 3 and 8 − 6 + 9 = 11.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Instantaneous rate 8; average rate over [1, 4] is 8', false, 'The instantaneous rate is the limit 8, but an average over [1, 4] is not that limit; it equals the expression evaluated at h = 3, which is 8 − 6 + 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Instantaneous rate 11; average rate over [1, 4] is 8', false, 'The values are swapped: letting h approach 0 gives the instantaneous rate 8, while the interval [1, 4] has h = 3 and gives 11.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Instantaneous rate 8; average rate over [1, 4] is 2', false, 'At h = 3 the expression is 8 − 6 + 9 = 11; the value 2 comes from dropping the h² term, which cannot be ignored when h is as large as 3.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.1-a-v2', 'mcq', 'recover the instantaneous rate as the limit of an average-rate expression, and evaluate that same expression at a fixed  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A store''s cumulative revenue R, in thousands of dollars, has average rate of change 6 + 4h − h² thousand dollars per week over the interval [0, h] weeks, for every h > 0. What is the instantaneous rate of change of R at t = 0, and what is the average rate of change of R over [0, 2]?', null, md5('apcalcbc-mcq-b6-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Instantaneous rate 6; average rate over [0, 2] is 6', false, 'The instantaneous rate 6 is the limit as h approaches 0, but [0, 2] corresponds to h = 2, where the expression gives 6 + 8 − 4, not its limit.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Instantaneous rate 10; average rate over [0, 2] is 6', false, 'These are swapped: the limit as h approaches 0 gives the instantaneous rate 6, and h = 2 gives the average rate 10 over [0, 2].' from version_ins
union all select gen_random_uuid(), id, 'C', 'Instantaneous rate 6; average rate over [0, 2] is 14', false, 'At h = 2 the h² term is −4, so the average is 6 + 8 − 4 = 10; 14 comes from ignoring the h² term, which does not vanish at h = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Instantaneous rate 6; average rate over [0, 2] is 10', true, 'Correct: The limit as h → 0 is 6; for [0, 2], h = 2 and 6 + 8 − 4 = 10.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.1-a-v3', 'mcq', 'recover the instantaneous rate as the limit of an average-rate expression, and evaluate that same expression at a fixed  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a function p, the average rate of change over [4, 4 + h] is 3 + h + 2h² for every h > 0. What is the instantaneous rate of change of p at x = 4, and what is the average rate of change of p over [4, 6]?', null, md5('apcalcbc-mcq-b6-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Instantaneous rate 3; average rate over [4, 6] is 3', false, 'The limit 3 is the instantaneous rate at x = 4, but the interval [4, 6] has h = 2 and the average rate is the full expression there, 3 + 2 + 8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Instantaneous rate 13; average rate over [4, 6] is 3', false, 'The two answers are interchanged: h approaching 0 gives the instantaneous rate 3, and h = 2 gives the average rate 13 for [4, 6].' from version_ins
union all select gen_random_uuid(), id, 'C', 'Instantaneous rate 3; average rate over [4, 6] is 5', false, 'At h = 2 the expression is 3 + 2 + 2·4 = 13; the value 5 results from omitting the 2h² term, which is not small when h = 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Instantaneous rate 3; average rate over [4, 6] is 13', true, 'Correct: As h → 0 the expression tends to 3; for [4, 6], h = 2 and 3 + 2 + 8 = 13.' from version_ins;
-- apcalcbc-mcq-b6-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.1-b', 'mcq', 'decide whether an instantaneous rate exists from one-sided average rates over shrinking intervals.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function g has the following average rates of change. Over [1 − h, 1] the average rate is 1.9 for h = 0.1, 1.99 for h = 0.01, and 1.999 for h = 0.001. Over [1, 1 + h] the average rate is 3 for each of these three values of h. Which is the best conclusion about the instantaneous rate of change of g at x = 1?', null, md5('apcalcbc-mcq-b6-h-1.1-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It equals 2, the value approached by the left-hand average rates', false, 'The left-hand rates approach 2, but the instantaneous rate requires average rates from both sides to approach the same value, and the right-hand rates stay at 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 3, because the right-hand average rates are constant', false, 'The right-hand rates are 3, but a constant list does not outweigh the left-hand rates, which approach 2; both sides must agree for the instantaneous rate to exist.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It equals 5/2, the mean of the two one-sided values', false, 'Averaging 2 and 3 has no meaning here; the instantaneous rate is a limit of average rates and exists only if the left and right limits are equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It does not exist, because the average rates approach 2 from the left and 3 from the right', true, 'Correct: Left-hand rates tend to 2, right-hand rates equal 3; the two sides disagree, so the limit of the average rates does not exist.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.1-b-v1', 'mcq', 'decide whether an instantaneous rate exists from one-sided average rates over shrinking intervals. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature T(t) of a metal part is continuous. Its average rate of change over [2 − h, 2] is −2.1 for h = 0.1, −2.01 for h = 0.01, and −2.001 for h = 0.001, and its average rate of change over [2, 2 + h] is 3 for each of these h. Which is the best conclusion about the instantaneous rate of change of T at t = 2?', null, md5('apcalcbc-mcq-b6-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It equals −2, the value approached by the left-hand average rates', false, 'The left-hand rates approach −2, but the right-hand rates stay at 3, so the average rates do not settle on one value as h shrinks.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 3, the constant right-hand average rate', false, 'The right-hand rates are 3, yet the left-hand rates approach −2; an instantaneous rate needs both one-sided limits to agree.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It equals 1/2, the mean of −2 and 3', false, 'The mean of −2 and 3 is 1/2, but the instantaneous rate is not an average of one-sided values; it exists only when both one-sided limits are equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It does not exist, because the average rates approach −2 from the left and 3 from the right', true, 'Correct: Left-hand rates tend to −2 and right-hand rates equal 3; the one-sided limits differ, so no instantaneous rate exists.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.1-b-v2', 'mcq', 'decide whether an instantaneous rate exists from one-sided average rates over shrinking intervals. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function p has average rate of change over [4 − h, 4] equal to 4.2 for h = 0.1, 4.02 for h = 0.01, and 4.002 for h = 0.001, and average rate of change over [4, 4 + h] equal to 3.8, 3.98, and 3.998 for the same three values of h. Which is the best conclusion about the instantaneous rate of change of p at x = 4?', null, md5('apcalcbc-mcq-b6-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It does not exist, because the left-hand rates are all above 4 and the right-hand rates are all below 4', false, 'Rates lying on opposite sides of 4 do not prevent a limit; what matters is that both lists approach the same number, 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 4.002, the last left-hand value listed', false, 'A listed value is only an estimate that still contains error; the limit is the number the rates approach as h shrinks, which is 4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It equals 4, because the average rates from both sides approach 4', true, 'Correct: Left-hand rates 4 + 2h and right-hand rates 4 − 2h both approach 4 as h → 0, so the instantaneous rate is 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It equals 3.998, the last right-hand value listed', false, 'The last tabulated rate is not the limit; the right-hand rates approach 4 and the left-hand rates approach 4, so the instantaneous rate is 4.' from version_ins;
-- apcalcbc-mcq-b6-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-sv-h-1.1-b-v3', 'mcq', 'decide whether an instantaneous rate exists from one-sided average rates over shrinking intervals. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A continuous function q has average rate of change 0.5 over [4 − h, 4] for h = 0.1, 0.01, and 0.001, and average rate of change −0.5 over [4, 4 + h] for the same values of h. Which is the best conclusion about the instantaneous rate of change of q at x = 4?', null, md5('apcalcbc-mcq-b6-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It equals 0, because 0.5 and −0.5 cancel', false, 'Cancelling the one-sided values is not a valid way to combine them; the instantaneous rate exists only when both sides approach the same number.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It equals 0.5, the left-hand rate', false, 'The left-hand rates are 0.5, but the right-hand rates are −0.5, so the average rates do not approach a single value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It does not exist, because the average rates from the two sides approach different values', true, 'Correct: One-sided limits of the average rates are 0.5 and −0.5, which differ, so the instantaneous rate does not exist.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It equals −0.5, the right-hand rate', false, 'The right-hand rates are −0.5, but the left-hand rates are 0.5; the rates must agree from both sides for the instantaneous rate to exist.' from version_ins;
-- apcalcbc-mcq-b6-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b6-h-1.2-a', 'mcq', 'evaluate a limit of a composite h(f(x)) by tracking the side from which the inner function approaches its limit.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a function with lim(x→0⁻) f(x) = 2, where f(x) < 2 for x < 0 near 0. Let h be a function with lim(u→2⁻) h(u) = 7, lim(u→2⁺) h(u) = −1, and h(2) = 4. What is lim(x→0⁻) h(f(x))?', null, md5('apcalcbc-mcq-b6-h-1.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7', true, 'Correct: As x → 0⁻, f(x) → 2 from below, so h(f(x)) → lim(u→2⁻) h(u) = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '−1', false, 'The value −1 is the right-hand limit of h at 2, but f(x) approaches 2 from below as x approaches 0 from the left, so the left-hand limit of h is the one that applies.' from version_ins
union all select gen_random_uuid(), id, 'C', '4', false, 'The value 4 is h(2); a limit depends on the values of h near 2, not at 2, and f(x) never needs to equal 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The limit does not exist', false, 'The two-sided limit of h at 2 does not exist, but h(f(x)) only sees inputs below 2 as x approaches 0 from the left, so a single limit does exist.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b6-h-1.1-a','apcalcbc-mcq-b6-sv-h-1.1-a-v1','apcalcbc-mcq-b6-sv-h-1.1-a-v2','apcalcbc-mcq-b6-sv-h-1.1-a-v3','apcalcbc-mcq-b6-h-1.1-b','apcalcbc-mcq-b6-sv-h-1.1-b-v1','apcalcbc-mcq-b6-sv-h-1.1-b-v2','apcalcbc-mcq-b6-sv-h-1.1-b-v3','apcalcbc-mcq-b6-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b6-h-1.1-a','apcalcbc-mcq-b6-sv-h-1.1-a-v1','apcalcbc-mcq-b6-sv-h-1.1-a-v2','apcalcbc-mcq-b6-sv-h-1.1-a-v3','apcalcbc-mcq-b6-h-1.1-b','apcalcbc-mcq-b6-sv-h-1.1-b-v1','apcalcbc-mcq-b6-sv-h-1.1-b-v2','apcalcbc-mcq-b6-sv-h-1.1-b-v3','apcalcbc-mcq-b6-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
