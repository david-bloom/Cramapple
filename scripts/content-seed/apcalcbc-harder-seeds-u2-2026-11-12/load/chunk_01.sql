begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-h-2.1-a','apcalcbc-mcq-b5-sv-h-2.1-a-v1','apcalcbc-mcq-b5-sv-h-2.1-a-v2','apcalcbc-mcq-b5-sv-h-2.1-a-v3','apcalcbc-mcq-b5-h-2.1-b','apcalcbc-mcq-b5-sv-h-2.1-b-v1','apcalcbc-mcq-b5-sv-h-2.1-b-v2','apcalcbc-mcq-b5-sv-h-2.1-b-v3','apcalcbc-mcq-b5-h-2.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apcalcbc-mcq-b5-h-2.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.1-a', 'mcq', 'combine average rates of change over adjacent intervals using total change, not by averaging or subtracting the rates.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has average rate of change 4 over the interval [2, 5] and average rate of change 6 over the interval [2, 3]. What is the average rate of change of f over [3, 5]?', null, md5('apcalcbc-mcq-b5-h-2.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5', false, 'Averaging the two given rates, (4 + 6)/2, treats the intervals as if they had equal width, but [2, 3] and [3, 5] have widths 1 and 2 and the intervals overlap differently.' from version_ins
union all select gen_random_uuid(), id, 'B', '2', false, 'Subtracting the rates, 6 − 4, is not meaningful; average rates combine through total changes f(5) − f(2) = 12 and f(3) − f(2) = 6, not through the rates themselves.' from version_ins
union all select gen_random_uuid(), id, 'C', '6', false, 'The change f(5) − f(3) is 12 − 6 = 6, but this is a change in f and must still be divided by the width 5 − 3 = 2 to give a rate.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', true, 'Correct: f(5) − f(2) = 4·3 = 12 and f(3) − f(2) = 6·1 = 6, so f(5) − f(3) = 6 and the average rate over [3, 5] is 6/2 = 3.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.1-a-v1', 'mcq', 'combine average rates of change over adjacent intervals using total change, not by averaging or subtracting the rates. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature of a sample is T(t) degrees Celsius at time t minutes. The average rate of change of T over [0, 4] is 3 degrees per minute, and the average rate of change of T over [0, 1] is −2 degrees per minute. What is the average rate of change of T over [1, 4], in degrees per minute?', null, md5('apcalcbc-mcq-b5-sv-h-2.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2', false, 'Averaging 3 and −2 gives 1/2, but the average over [1, 4] is not the mean of the other two rates because the three intervals have different widths.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'Subtracting the rates, 3 − (−2), mixes rates with totals; the correct step is to subtract the changes T(4) − T(0) = 12 and T(1) − T(0) = −2 and then divide.' from version_ins
union all select gen_random_uuid(), id, 'C', '14/3', true, 'Correct: T(4) − T(0) = 12 and T(1) − T(0) = −2, so T(4) − T(1) = 14 over a width of 3 gives 14/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '14', false, 'The change T(4) − T(1) = 12 − (−2) = 14 is correct, but it is a change in temperature, and it must be divided by the width 3 of [1, 4].' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.1-a-v2', 'mcq', 'combine average rates of change over adjacent intervals using total change, not by averaging or subtracting the rates. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A store''s cumulative revenue is R(t) thousand dollars after t weeks. The average rate of change of R over [1, 7] is 5 thousand dollars per week, and the average rate of change of R over [4, 7] is 2 thousand dollars per week. What is the average rate of change of R over [1, 4]?', null, md5('apcalcbc-mcq-b5-sv-h-2.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8', true, 'Correct: R(7) − R(1) = 30 and R(7) − R(4) = 6, so R(4) − R(1) = 24 and the average rate over [1, 4] is 24/3 = 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '7/2', false, 'The mean of 5 and 2 is 7/2, but the average over [1, 4] is not their mean; [1, 7] and [4, 7] overlap and have different widths, so the rates cannot simply be averaged.' from version_ins
union all select gen_random_uuid(), id, 'C', '3', false, 'Subtracting 5 − 2 treats the rates as if they were changes; the right step is R(7) − R(1) = 30 minus R(7) − R(4) = 6, which gives the change over [1, 4].' from version_ins
union all select gen_random_uuid(), id, 'D', '4', false, 'The change over [1, 4] is 30 − 6 = 24, but dividing by 6, the width of [1, 7], is wrong; the width of [1, 4] is 3.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.1-a-v3', 'mcq', 'combine average rates of change over adjacent intervals using total change, not by averaging or subtracting the rates. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A function f has average rate of change 2 over [1, 3] and average rate of change 5 over [3, 7]. What is the average rate of change of f over [1, 7]?', null, md5('apcalcbc-mcq-b5-sv-h-2.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7/2', false, 'The mean of 2 and 5 is 7/2, but the two intervals have widths 2 and 4, so the rate over [1, 7] is a weighted average, not a plain one.' from version_ins
union all select gen_random_uuid(), id, 'B', '7', false, 'Adding the rates 2 + 5 treats rates as if they were changes; over [1, 7] the changes 4 and 20 are added and then divided by the total width.' from version_ins
union all select gen_random_uuid(), id, 'C', '24', false, 'The total change is 4 + 20 = 24, but a rate over [1, 7] requires dividing by the width 6, which gives 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '4', true, 'Correct: f(3) − f(1) = 2·2 = 4 and f(7) − f(3) = 5·4 = 20, so the average rate over [1, 7] is 24/6 = 4.' from version_ins;
-- apcalcbc-mcq-b5-h-2.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.1-b', 'mcq', 'decide which conclusions follow from an average rate of change over an interval, separating net change from pointwise or', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has average rate of change 0 over the interval [1, 5]. Which of the following must be true?  I. f(1) = f(5).  II. f′(x) = 0 for every x in (1, 5).  III. f′(3) = 0.', null, md5('apcalcbc-mcq-b5-h-2.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I only', true, 'Correct: Zero average rate means (f(5) − f(1))/4 = 0, so only I is forced; f(x) = (x − 1)²(x − 5) satisfies I but has f′(3) = −4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I and II only', false, 'Statement II confuses an average of zero with zero at every point; for example, f(x) = (x − 1)²(x − 5) has f(1) = f(5) but f′(x) is not zero throughout (1, 5).' from version_ins
union all select gen_random_uuid(), id, 'C', 'I and III only', false, 'Statement III picks out a single point, the midpoint, but an average of zero does not force f′(3) = 0; for f(x) = (x − 1)²(x − 5) we get f′(3) = −4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'II and III only', false, 'Both II and III claim values of f′, which an average rate over an interval does not determine; only the net change f(5) − f(1) = 0 is forced, as in statement I.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.1-b-v1', 'mcq', 'decide which conclusions follow from an average rate of change over an interval, separating net change from pointwise or (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The temperature T(t) of a metal rod is differentiable, and its average rate of change over [2, 6] is −3 degrees per minute. Which of the following must be true?  I. T(6) = T(2) − 12.  II. T′(4) = −3.  III. T is decreasing at every time in [2, 6].', null, md5('apcalcbc-mcq-b5-sv-h-2.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I only', true, 'Correct: (T(6) − T(2))/4 = −3 gives T(6) − T(2) = −12; II and III need extra information about T between the endpoints.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I and II only', false, 'Statement II treats the average rate as the instantaneous rate at the midpoint; that works for a linear or quadratic T but not for every differentiable T.' from version_ins
union all select gen_random_uuid(), id, 'C', 'II only', false, 'Statement II is not forced, and statement I is: an average rate of −3 over a length-4 interval means T drops by 3·4 = 12 in total.' from version_ins
union all select gen_random_uuid(), id, 'D', 'I and III only', false, 'Statement III is false because T can rise for part of the interval and still have a negative average rate; only the net change over [2, 6] is determined.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.1-b-v2', 'mcq', 'decide which conclusions follow from an average rate of change over an interval, separating net change from pointwise or (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has average rate of change 2 over [1, 3] and average rate of change 2 over [3, 7]. Which of the following must be true?  I. The average rate of change of f over [1, 7] is 2.  II. f(7) − f(1) = 12.  III. f′(3) = 2.', null, md5('apcalcbc-mcq-b5-sv-h-2.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I only', false, 'Statement II follows from I: an average rate of 2 over an interval of width 6 gives f(7) − f(1) = 12, so it is also forced.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I, II, and III', false, 'Statement III is not forced; equal average rates on both sides of 3 say nothing about the slope at 3 itself, since f may bend and still have the same net changes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'I and II only', true, 'Correct: f(3) − f(1) = 4 and f(7) − f(3) = 8, so f(7) − f(1) = 12 and the average over [1, 7] is 2; f′(3) is not determined.' from version_ins
union all select gen_random_uuid(), id, 'D', 'II and III only', false, 'Statement I is also forced, since f(7) − f(1) = 4 + 8 = 12 gives average 12/6 = 2, and statement III is not forced by average rates alone.' from version_ins;
-- apcalcbc-mcq-b5-sv-h-2.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-sv-h-2.1-b-v3', 'mcq', 'decide which conclusions follow from an average rate of change over an interval, separating net change from pointwise or (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³. The average rate of change of f over [0, 6] is 36. Which of the following must be true?  I. f′(3) = 36.  II. f′(x) = 36 for some x in (0, 6).  III. f′(x) < 36 for every x in (0, 6).', null, md5('apcalcbc-mcq-b5-sv-h-2.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'I only', false, 'Statement I treats the average rate as the slope at the midpoint, but for a cubic f′(3) = 27, which differs from 36.' from version_ins
union all select gen_random_uuid(), id, 'B', 'I and III only', false, 'Statement III is false: f′(x) = 3x² exceeds 36 for x > 2√3, for example f′(5) = 75, and statement I is false because f′(3) = 27.' from version_ins
union all select gen_random_uuid(), id, 'C', 'III only', false, 'Statement III fails because f′(x) = 3x² is larger than 36 near x = 6, and statement II holds at x = 2√3, which lies in (0, 6).' from version_ins
union all select gen_random_uuid(), id, 'D', 'II only', true, 'Correct: (216 − 0)/6 = 36; f′(x) = 3x² = 36 at x = 2√3 ≈ 3.46 in (0, 6), while f′(3) = 27 and f′(5) = 75.' from version_ins;
-- apcalcbc-mcq-b5-h-2.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '3778d753-273a-403d-8f02-55dc64ec6a27', 'apcalcbc-mcq-b5-h-2.2-a', 'mcq', 'evaluate a scaled or offset difference quotient as a multiple of f′(a), tracking the coefficients of h in both terms.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f be a differentiable function with f′(3) = 5. What is lim as h→0 of [f(3 + 2h) − f(3 − h)]/h?', null, md5('apcalcbc-mcq-b5-h-2.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15', true, 'Correct: f(3 + 2h) − f(3 − h) ≈ f′(3)(2h − (−h)) = 3h f′(3), so the limit is 3·5 = 15.' from version_ins
union all select gen_random_uuid(), id, 'B', '5', false, 'Subtracting the coefficients 2 − 1 = 1 ignores that the second point lies below 3, so the total horizontal gap is 2h − (−h) = 3h and the limit is 3f′(3).' from version_ins
union all select gen_random_uuid(), id, 'C', '10', false, 'This keeps only the shift of 2h from the first term and treats f(3 − h) as f(3), missing the extra h of separation on the other side.' from version_ins
union all select gen_random_uuid(), id, 'D', '3', false, 'The total gap is 3h, which does give the factor 3, but the limit is that factor times the derivative f′(3) = 5, not the factor alone.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and content_key = any (array['apcalcbc-mcq-b5-h-2.1-a','apcalcbc-mcq-b5-sv-h-2.1-a-v1','apcalcbc-mcq-b5-sv-h-2.1-a-v2','apcalcbc-mcq-b5-sv-h-2.1-a-v3','apcalcbc-mcq-b5-h-2.1-b','apcalcbc-mcq-b5-sv-h-2.1-b-v1','apcalcbc-mcq-b5-sv-h-2.1-b-v2','apcalcbc-mcq-b5-sv-h-2.1-b-v3','apcalcbc-mcq-b5-h-2.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and ci.content_key = any (array['apcalcbc-mcq-b5-h-2.1-a','apcalcbc-mcq-b5-sv-h-2.1-a-v1','apcalcbc-mcq-b5-sv-h-2.1-a-v2','apcalcbc-mcq-b5-sv-h-2.1-a-v3','apcalcbc-mcq-b5-h-2.1-b','apcalcbc-mcq-b5-sv-h-2.1-b-v1','apcalcbc-mcq-b5-sv-h-2.1-b-v2','apcalcbc-mcq-b5-sv-h-2.1-b-v3','apcalcbc-mcq-b5-h-2.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
