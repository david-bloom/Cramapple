begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.6-A-v1','APSTATS-MCQ-SV-H-2.6-A-v2','APSTATS-MCQ-SV-H-2.6-A-v3','APSTATS-MCQ-SV-H-2.6-B-v1','APSTATS-MCQ-SV-H-2.6-B-v2','APSTATS-MCQ-SV-H-2.6-B-v3','APSTATS-MCQ-H-2.7-A','APSTATS-MCQ-SV-H-2.7-A-v1','APSTATS-MCQ-SV-H-2.7-A-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- APSTATS-MCQ-SV-H-2.6-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.6-A-v1', 'mcq', 'Independence from a two-way table (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A company classified 250 workers by work location and whether they completed an optional training.
Remote, Completed: 45
Remote, Did not complete: 55
On-site, Completed: 30
On-site, Did not complete: 120
Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.6-A-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Work location and completing the training are independent, because both groups have more workers who did not complete than who did.', false, 'Counts of unequal groups cannot be compared; the right comparison is within-group proportions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Work location and completing the training are not independent, because P(completed | remote) = 45/100 = 0.45 is not equal to P(completed) = 75/250 = 0.30.', true, 'Correct: P(completed | remote) = 45/100 = 0.45 differs from P(completed) = 75/250 = 0.30, so the variables are not independent.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Work location and completing the training are independent, because P(remote and completed) = 0.18 is smaller than both P(remote) and P(completed).', false, 'A joint probability is always smaller than each marginal probability, so being smaller does not show independence; here the conditional proportions differ.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Work location and completing the training are not independent, because P(remote | completed) = 0.60 is not equal to P(completed | remote) = 0.45.', false, 'P(remote | completed) and P(completed | remote) are different quantities that are allowed to differ even when the variables are independent.' from version_ins;
-- APSTATS-MCQ-SV-H-2.6-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.6-A-v2', 'mcq', 'Independence from a two-way table (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three hundred students were classified by grade and by whether they take an AP class.
Senior, Take AP: 48
Senior, No AP: 72
Junior, Take AP: 72
Junior, No AP: 108
Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.6-A-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Grade and taking an AP class are not independent, because more juniors (72) than seniors (48) take an AP class.', false, 'Compares counts of unequal groups; independence is judged from proportions, and 40% of both seniors and juniors take AP.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Grade and taking an AP class are not independent, because P(junior | AP) = 0.60 is not equal to P(senior | AP) = 0.40.', false, 'P(junior | AP) and P(senior | AP) describe the same group split two ways and always differ; they do not test independence.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Grade and taking an AP class are independent, because P(senior and AP) = 0.16 is smaller than both P(senior) and P(AP).', false, 'A joint probability is always smaller than each marginal probability, so this does not show independence.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Grade and taking an AP class are independent, because P(AP | senior) = 48/120 = 0.40 equals P(AP) = 120/300 = 0.40.', true, 'Correct: P(AP | senior) = 48/120 = 0.40 equals P(AP) = 120/300 = 0.40, so the variables are independent.' from version_ins;
-- APSTATS-MCQ-SV-H-2.6-A-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.6-A-v3', 'mcq', 'Independence from a two-way table (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A store classified 400 customers by whether they have a loyalty membership and whether they bought an item on sale.
Member, Bought on sale: 72
Member, Did not: 88
Non-member, Bought on sale: 48
Non-member, Did not: 192
Which statement is correct?', null, md5('APSTATS-MCQ-SV-H-2.6-A-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Membership and buying on sale are independent, because the store has more non-members (240) than members (160).', false, 'Compares group sizes; independence concerns proportions, not which group is bigger.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Membership and buying on sale are independent, because P(member and bought on sale) = 0.18 is smaller than both P(member) and P(bought on sale).', false, 'A joint probability is always smaller than each marginal probability, so this does not show independence.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Membership and buying on sale are not independent, because P(bought on sale | member) = 72/160 = 0.45 is not equal to P(bought on sale) = 120/400 = 0.30.', true, 'Correct: P(bought on sale | member) = 72/160 = 0.45 differs from P(bought on sale) = 120/400 = 0.30, so the variables are not independent.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Membership and buying on sale are not independent, because P(member | bought on sale) = 0.60 is not equal to P(bought on sale | member) = 0.45.', false, 'The two conditional probabilities describe different groups and are expected to differ even for independent variables; this reaches the right verdict for the wrong reason.' from version_ins;
-- APSTATS-MCQ-SV-H-2.6-B-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.6-B-v1', 'mcq', 'Two draws without replacement (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bag contains 6 green marbles and 4 yellow marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?', null, md5('APSTATS-MCQ-SV-H-2.6-B-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13/25', false, 'This treats the draws as if each item were replaced, but the draws are made without replacement, so the second draw has a different composition.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/3', false, 'This counts only two green marbles, (6/10)(5/9) = 1/3, and misses two yellow marbles.' from version_ins
union all select gen_random_uuid(), id, 'C', '7/15', true, 'Correct: (6/10)(5/9) + (4/10)(3/9) = 30/90 + 12/90 = 42/90 = 7/15.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/15', false, 'This is P(green then yellow) = (6/10)(4/9), which is a different-color outcome.' from version_ins;
-- APSTATS-MCQ-SV-H-2.6-B-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.6-B-v2', 'mcq', 'Two draws without replacement (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A box contains 5 black pens and 4 white pens. Two pens are drawn at random, one after the other, without replacement. What is the probability that the two pens are different colors?', null, md5('APSTATS-MCQ-SV-H-2.6-B-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40/81', false, 'This treats the draws as if each item were replaced, but the draws are made without replacement, so the second draw has a different composition.' from version_ins
union all select gen_random_uuid(), id, 'B', '5/9', true, 'Correct: P(different colors) = 2 × (5/9)(4/8) = 40/72 = 5/9.' from version_ins
union all select gen_random_uuid(), id, 'C', '5/18', false, 'This counts only black then white, (5/9)(4/8) = 5/18, and misses white then black.' from version_ins
union all select gen_random_uuid(), id, 'D', '4/9', false, 'This is P(same color) = 32/72 = 4/9, the complement of what the question asks.' from version_ins;
-- APSTATS-MCQ-SV-H-2.6-B-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.6-B-v3', 'mcq', 'Two draws without replacement (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bag contains 3 red, 3 blue, and 2 green marbles. Two marbles are drawn at random, one after the other, without replacement. What is the probability that both marbles are the same color?', null, md5('APSTATS-MCQ-SV-H-2.6-B-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '11/32', false, 'This uses replacement, (9 + 9 + 4)/64 = 11/32, but the draws are made without replacement.' from version_ins
union all select gen_random_uuid(), id, 'B', '3/28', false, 'This counts only two red marbles, (3/8)(2/7) = 3/28, and misses blue-blue and green-green.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/4', true, 'Correct: (3/8)(2/7) + (3/8)(2/7) + (2/8)(1/7) = 6/56 + 6/56 + 2/56 = 14/56 = 1/4.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/3', false, 'This treats the three colors as equally likely, but the colors have different numbers of marbles.' from version_ins;
-- APSTATS-MCQ-H-2.7-A
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-H-2.7-A', 'mcq', 'Union of independent events', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Events A and B are independent, with P(A) = 0.40 and P(B) = 0.30. What is P(A or B)?', null, md5('APSTATS-MCQ-H-2.7-A'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.58', true, 'Correct: P(A and B) = 0.40 × 0.30 = 0.12; P(A or B) = 0.40 + 0.30 − 0.12 = 0.58.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.70', false, 'This adds 0.40 + 0.30 without subtracting the overlap P(A and B) = 0.12.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.12', false, 'This stops at P(A and B) = 0.12; the question asks for P(A or B).' from version_ins
union all select gen_random_uuid(), id, 'D', '0.42', false, 'This is 1 − 0.58, the probability that neither event occurs, not P(A or B).' from version_ins;
-- APSTATS-MCQ-SV-H-2.7-A-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.7-A-v1', 'mcq', 'Union of independent events (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a school, whether a student rides the bus (event R, P = 0.50) and whether a student has a part-time job (event J, P = 0.20) are independent. What is the probability that a randomly selected student rides the bus or has a job (or both)?', null, md5('APSTATS-MCQ-SV-H-2.7-A-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.60', true, 'Correct: 0.50 + 0.20 − (0.50)(0.20) = 0.60.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.70', false, 'This adds the two probabilities without subtracting the overlap, so the overlap is counted twice.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.10', false, 'This multiplies the probabilities, which gives P(A and B), not P(A or B).' from version_ins
union all select gen_random_uuid(), id, 'D', '0.40', false, 'This is the complement, 1 − 0.60, not the probability the question asks about.' from version_ins;
-- APSTATS-MCQ-SV-H-2.7-A-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '548f06be-ccf4-426d-b82b-b424137a4438', 'APSTATS-MCQ-SV-H-2.7-A-v2', 'mcq', 'Union of independent events (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a town, the event that a household owns a dog (P = 0.35) and the event that it owns a bicycle (P = 0.40) are independent. What is the probability that a randomly selected household owns a dog or a bicycle?', null, md5('APSTATS-MCQ-SV-H-2.7-A-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.61', true, 'Correct: 0.35 + 0.40 − 0.14 = 0.61.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.14', false, 'This multiplies the probabilities, which gives P(A and B), not P(A or B).' from version_ins
union all select gen_random_uuid(), id, 'C', '0.75', false, 'This adds the two probabilities without subtracting the overlap, so the overlap is counted twice.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.39', false, 'This is the complement, 1 − 0.61, not the probability the question asks about.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and content_key = any (array['APSTATS-MCQ-SV-H-2.6-A-v1','APSTATS-MCQ-SV-H-2.6-A-v2','APSTATS-MCQ-SV-H-2.6-A-v3','APSTATS-MCQ-SV-H-2.6-B-v1','APSTATS-MCQ-SV-H-2.6-B-v2','APSTATS-MCQ-SV-H-2.6-B-v3','APSTATS-MCQ-H-2.7-A','APSTATS-MCQ-SV-H-2.7-A-v1','APSTATS-MCQ-SV-H-2.7-A-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and ci.content_key = any (array['APSTATS-MCQ-SV-H-2.6-A-v1','APSTATS-MCQ-SV-H-2.6-A-v2','APSTATS-MCQ-SV-H-2.6-A-v3','APSTATS-MCQ-SV-H-2.6-B-v1','APSTATS-MCQ-SV-H-2.6-B-v2','APSTATS-MCQ-SV-H-2.6-B-v3','APSTATS-MCQ-H-2.7-A','APSTATS-MCQ-SV-H-2.7-A-v1','APSTATS-MCQ-SV-H-2.7-A-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
