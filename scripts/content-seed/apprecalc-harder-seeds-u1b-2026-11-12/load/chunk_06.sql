begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.13-b-v1','apprecalc-mcq-b9-sv-h-1.13-b-v2','apprecalc-mcq-b9-sv-h-1.13-b-v3','apprecalc-mcq-b9-h-1.14-a','apprecalc-mcq-b9-sv-h-1.14-a-v1','apprecalc-mcq-b9-sv-h-1.14-a-v2','apprecalc-mcq-b9-sv-h-1.14-a-v3','apprecalc-mcq-b9-h-1.14-b','apprecalc-mcq-b9-sv-h-1.14-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apprecalc-mcq-b9-sv-h-1.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.13-b-v1', 'mcq', 'decide the valid input interval for a quadratic model in context by finding where the output stops being meaningful, not (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drone''s altitude A, in meters, is modeled by A(t) = −8t² + 22t + 6, where t is the number of seconds after launch, starting at t = 0. What input interval is most appropriate for this model while the drone is in flight?', null, md5('apprecalc-mcq-b9-sv-h-1.13-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 ≤ t ≤ 3', true, 'Correct: Factoring gives −8(t + 1/4)(t − 3), so the zeros are −1/4 and 3. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'all real numbers t', false, 'This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed seconds and the altitude cannot be negative, so the model only makes sense while its output stays at or above 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 ≤ t ≤ 11/8', false, 'This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1/4 ≤ t ≤ 3', false, 'This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −1/4, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 3.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.13-b-v2', 'mcq', 'decide the valid input interval for a quadratic model in context by finding where the output stops being meaningful, not (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The profit P, in dollars, from a school event is modeled by P(t) = −3t² + 15t + 18, where t is the number of weeks after tickets go on sale, starting at t = 0. For what interval of t does the model give meaningful, nonnegative profit?', null, md5('apprecalc-mcq-b9-sv-h-1.13-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 ≤ t ≤ 6', true, 'Correct: Factoring gives −3(t + 1)(t − 6), so the zeros are −1 and 6. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'all real numbers t', false, 'This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed weeks and the profit cannot be negative, so the model only makes sense while its output stays at or above 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 ≤ t ≤ 5/2', false, 'This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1 ≤ t ≤ 6', false, 'This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −1, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 6.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.13-b-v3', 'mcq', 'decide the valid input interval for a quadratic model in context by finding where the output stops being meaningful, not (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The depth D, in centimeters, of water in a tank that is first filled and then drained is modeled by D(t) = −4t² + 10t + 24, where t is minutes after the process begins, starting at t = 0. Which input interval is most appropriate for this model?', null, md5('apprecalc-mcq-b9-sv-h-1.13-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 ≤ t ≤ 4', true, 'Correct: Factoring gives −4(t + 3/2)(t − 4), so the zeros are −3/2 and 4. Time starts at 0 and the output must be nonnegative, so the interval is 0 ≤ t ≤ 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'all real numbers t', false, 'This uses the domain of the algebraic function, which is every real number. In this context t measures elapsed minutes and the depth cannot be negative, so the model only makes sense while its output stays at or above 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 ≤ t ≤ 5/4', false, 'This stops at the vertex, where the model reaches its maximum. The model is still valid after the vertex while the output is positive, until the zero at t = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '−3/2 ≤ t ≤ 4', false, 'This uses both zeros of the quadratic as the ends of the interval. The other zero, t = −3/2, is before the start of the process, so only t ≥ 0 can be used, and the upper end is 4.' from version_ins;
-- apprecalc-mcq-b9-h-1.14-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.14-a', 'mcq', 'build a quadratic model from its vertex and one other point, find the stretch factor, and use the model to make a predic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A quadratic model P gives the height, in feet, of a thrown ball t seconds after release. The model has its maximum value of 20 feet at t = 3 seconds, and P(0) = 2 feet. What does the model predict for the height, in feet, at t = 5 seconds?', null, md5('apprecalc-mcq-b9-h-1.14-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24', false, 'This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 2, which gives a = −2, so P(5) = 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '12', true, 'Correct: Write P(t) = a(t − 3)² + 20. Using P(0) = 2: a·9 + 20 = 2, so a = −2. Then P(5) = −2·4 + 20 = 12.' from version_ins
union all select gen_random_uuid(), id, 'C', '−108', false, 'This uses (t + 3)², putting the vertex at t = −3. A vertex at t = 3 gives the factor (t − 3)², so the value at 5 is 12.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4', false, 'This finds a by dividing by 3 instead of 3². At t = 0 the squared factor is (3)² = 9, so a = −2, and the prediction at 5 is 12.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.14-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.14-a-v1', 'mcq', 'build a quadratic model from its vertex and one other point, find the stretch factor, and use the model to make a predic (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The daily profit P, in hundreds of dollars, of a food truck is modeled by a quadratic function of t, the hours after opening. The maximum profit of 18 occurs at t = 2, and P(0) = 6. What profit does the model predict at t = 3?', null, md5('apprecalc-mcq-b9-sv-h-1.14-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15', true, 'Correct: Write P(t) = a(t − 2)² + 18. Using P(0) = 6: a·4 + 18 = 6, so a = −3. Then P(3) = −3·1 + 18 = 15.' from version_ins
union all select gen_random_uuid(), id, 'B', '19', false, 'This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 6, which gives a = −3, so P(3) = 15.' from version_ins
union all select gen_random_uuid(), id, 'C', '−57', false, 'This uses (t + 2)², putting the vertex at t = −2. A vertex at t = 2 gives the factor (t − 2)², so the value at 3 is 15.' from version_ins
union all select gen_random_uuid(), id, 'D', '12', false, 'This finds a by dividing by 2 instead of 2². At t = 0 the squared factor is (2)² = 4, so a = −3, and the prediction at 3 is 15.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.14-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.14-a-v2', 'mcq', 'build a quadratic model from its vertex and one other point, find the stretch factor, and use the model to make a predic (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diver''s height P, in meters above the water, is modeled by a quadratic function of the time t in seconds. The highest point of 34 meters occurs at t = 4, and the diver leaves the board at t = 0 with P(0) = 2. What height does the model predict at t = 6?', null, md5('apprecalc-mcq-b9-sv-h-1.14-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '38', false, 'This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 2, which gives a = −2, so P(6) = 26.' from version_ins
union all select gen_random_uuid(), id, 'B', '−166', false, 'This uses (t + 4)², putting the vertex at t = −4. A vertex at t = 4 gives the factor (t − 4)², so the value at 6 is 26.' from version_ins
union all select gen_random_uuid(), id, 'C', '26', true, 'Correct: Write P(t) = a(t − 4)² + 34. Using P(0) = 2: a·16 + 34 = 2, so a = −2. Then P(6) = −2·4 + 34 = 26.' from version_ins
union all select gen_random_uuid(), id, 'D', '2', false, 'This finds a by dividing by 4 instead of 4². At t = 0 the squared factor is (4)² = 16, so a = −2, and the prediction at 6 is 26.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.14-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.14-a-v3', 'mcq', 'build a quadratic model from its vertex and one other point, find the stretch factor, and use the model to make a predic (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fountain jet''s height P, in feet, is modeled by a quadratic function of the horizontal distance t in feet. The peak height of 30 feet occurs at t = 5, and P(0) = 5. What height does the model predict at horizontal distance t = 8?', null, md5('apprecalc-mcq-b9-sv-h-1.14-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '21', true, 'Correct: Write P(t) = a(t − 5)² + 30. Using P(0) = 5: a·25 + 30 = 5, so a = −1. Then P(8) = −1·9 + 30 = 21.' from version_ins
union all select gen_random_uuid(), id, 'B', '39', false, 'This leaves out the stretch factor and uses a = 1. The value a must be found from P(0) = 5, which gives a = −1, so P(8) = 21.' from version_ins
union all select gen_random_uuid(), id, 'C', '−139', false, 'This uses (t + 5)², putting the vertex at t = −5. A vertex at t = 5 gives the factor (t − 5)², so the value at 8 is 21.' from version_ins
union all select gen_random_uuid(), id, 'D', '−15', false, 'This finds a by dividing by 5 instead of 5². At t = 0 the squared factor is (5)² = 25, so a = −1, and the prediction at 8 is 21.' from version_ins;
-- apprecalc-mcq-b9-h-1.14-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-h-1.14-b', 'mcq', 'construct an average-cost model with a fixed amount and a per-person amount, solve an inequality for the number of peopl', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A club orders custom jackets for its members. The one-time design fee is $470 and each jacket costs $6, with the total split equally among n members. The cost per member is A(n) = 6 + 470/n dollars. What is the smallest whole number of members n for which the cost per member is at most $14?', null, md5('apprecalc-mcq-b9-h-1.14-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '58', false, 'This rounds 235/4 down. At n = 58 the average is 6 + 470/58 ≈ 14.10, which is still above 14, so the goal is not met until the next whole number.' from version_ins
union all select gen_random_uuid(), id, 'B', '24', false, 'This adds the per-member cost to the target instead of subtracting it, dividing 470 by 20. The fixed amount only has to be covered by the part of the target left after the per-member cost, 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '59', true, 'Correct: The average per member is A(n) = 6 + 470/n. A(n) ≤ 14 gives 470/n ≤ 8, so n ≥ 470/8 ≈ 58.75; n must be a whole number, so the smallest is 59.' from version_ins
union all select gen_random_uuid(), id, 'D', '34', false, 'This divides the fixed cost by the whole target of 14, ignoring that each member also pays 6 directly. Only 8 per member is left to cover the fixed cost, so 470/8 is needed.' from version_ins;
-- apprecalc-mcq-b9-sv-h-1.14-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b9-sv-h-1.14-b-v1', 'mcq', 'construct an average-cost model with a fixed amount and a per-person amount, solve an inequality for the number of peopl (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A band presses a record. The one-time studio fee is $900 and each copy costs $5 to press. The cost per copy, if n copies are made, is C(n) = 5 + 900/n dollars. What is the smallest whole number of copies n for which the cost per copy is at most $12?', null, md5('apprecalc-mcq-b9-sv-h-1.14-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '128', false, 'This rounds 900/7 down. At n = 128 the average is 5 + 900/128 ≈ 12.03, which is still above 12, so the goal is not met until the next whole number.' from version_ins
union all select gen_random_uuid(), id, 'B', '53', false, 'This adds the per-copy cost to the target instead of subtracting it, dividing 900 by 17. The fixed amount only has to be covered by the part of the target left after the per-copy cost, 7.' from version_ins
union all select gen_random_uuid(), id, 'C', '75', false, 'This divides the fixed cost by the whole target of 12, ignoring that each copy also pays 5 directly. Only 7 per copy is left to cover the fixed cost, so 900/7 is needed.' from version_ins
union all select gen_random_uuid(), id, 'D', '129', true, 'Correct: The average per copy is A(n) = 5 + 900/n. A(n) ≤ 12 gives 900/n ≤ 7, so n ≥ 900/7 ≈ 128.57; n must be a whole number, so the smallest is 129.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b9-sv-h-1.13-b-v1','apprecalc-mcq-b9-sv-h-1.13-b-v2','apprecalc-mcq-b9-sv-h-1.13-b-v3','apprecalc-mcq-b9-h-1.14-a','apprecalc-mcq-b9-sv-h-1.14-a-v1','apprecalc-mcq-b9-sv-h-1.14-a-v2','apprecalc-mcq-b9-sv-h-1.14-a-v3','apprecalc-mcq-b9-h-1.14-b','apprecalc-mcq-b9-sv-h-1.14-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b9-sv-h-1.13-b-v1','apprecalc-mcq-b9-sv-h-1.13-b-v2','apprecalc-mcq-b9-sv-h-1.13-b-v3','apprecalc-mcq-b9-h-1.14-a','apprecalc-mcq-b9-sv-h-1.14-a-v1','apprecalc-mcq-b9-sv-h-1.14-a-v2','apprecalc-mcq-b9-sv-h-1.14-a-v3','apprecalc-mcq-b9-h-1.14-b','apprecalc-mcq-b9-sv-h-1.14-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
