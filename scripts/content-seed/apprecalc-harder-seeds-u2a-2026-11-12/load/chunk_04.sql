begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.4-a-v3','apprecalc-mcq-b7-h-2.4-b','apprecalc-mcq-b7-sv-h-2.4-b-v1','apprecalc-mcq-b7-sv-h-2.4-b-v2','apprecalc-mcq-b7-sv-h-2.4-b-v3','apprecalc-mcq-b7-h-2.5-a','apprecalc-mcq-b7-sv-h-2.5-a-v1','apprecalc-mcq-b7-sv-h-2.5-a-v2','apprecalc-mcq-b7-sv-h-2.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apprecalc-mcq-b7-sv-h-2.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.4-a-v3', 'mcq', 'rewrite an exponential with a fractional exponent and a horizontal shift in the form a·bᵗ, tracking both the new base an (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For all real t, N(t) = 3·4^((t + 2)/2). Which expression is equivalent to N(t) for every real t?', null, md5('apprecalc-mcq-b7-sv-h-2.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3·2ᵗ', false, 'This takes the root correctly, 4^(1/2) = 2, but drops the shift in the exponent. Writing 2^(t + 2) = 2ᵗ·2^(2) changes the coefficient from 3 to 12.' from version_ins
union all select gen_random_uuid(), id, 'B', '(3/4)·2ᵗ', false, 'This applies the shift in the wrong direction. Since 2^(t + 2) = 2ᵗ·2^(2), the coefficient is multiplied by 2^(2) = 4, not by 1/4.' from version_ins
union all select gen_random_uuid(), id, 'C', '12·4ᵗ', false, 'This gets the coefficient right but keeps the base 4 instead of reducing it. Because the exponent is divided by 2, the factor per unit of t is 4^(1/2) = 2, not 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '12·2ᵗ', true, 'Correct: 4^(1/2) = 2, so N(t) = 3·2^(t + 2) = 3·2^(2)·2ᵗ = 12·2ᵗ.' from version_ins;
-- apprecalc-mcq-b7-h-2.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.4-b', 'mcq', 'see that a horizontal translation of an exponential graph equals a vertical scaling, and find the scale factor as a powe', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f(x) = 6·2ˣ is translated 3 units to the right. Which single vertical transformation of the graph of f produces exactly the same graph?', null, md5('apprecalc-mcq-b7-h-2.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a vertical compression by a factor of 1/8', true, 'Correct: f(x − 3) = 6·2^(x − 3) = [6·2^(−3)]·2ˣ = 3/4·2ˣ, so the coefficient is multiplied by 1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a vertical stretch by a factor of 8', false, 'This reverses the direction of the factor. Translating 3 units to the right gives f(x − 3) = 6·2^(x − 3), which equals 6·2^(−3)·2ˣ, so the factor is 1/8, not 8.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a vertical compression by a factor of 1/2', false, 'This uses the factor for a shift of one unit. A shift of 3 units multiplies the coefficient by 2^(−3) = 1/8, because each unit of shift contributes one factor of 2^(-1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'a vertical compression by a factor of 1/3', false, 'This uses the size of the shift, 3, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 2^(−3), not by the number of units shifted.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.4-b-v1', 'mcq', 'see that a horizontal translation of an exponential graph equals a vertical scaling, and find the scale factor as a powe (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f(x) = 5·3ˣ is translated 2 units to the left. Which single vertical transformation of the graph of f produces exactly the same graph?', null, md5('apprecalc-mcq-b7-sv-h-2.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a vertical compression by a factor of 1/9', false, 'This reverses the direction of the factor. Translating 2 units to the left gives f(x + 2) = 5·3^(x + 2), which equals 5·3^(2)·3ˣ, so the factor is 9, not 1/9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a vertical stretch by a factor of 9', true, 'Correct: f(x + 2) = 5·3^(x + 2) = [5·3^(2)]·3ˣ = 45·3ˣ, so the coefficient is multiplied by 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a vertical stretch by a factor of 3', false, 'This uses the factor for a shift of one unit. A shift of 2 units multiplies the coefficient by 3^(2) = 9, because each unit of shift contributes one factor of 3^(1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'a vertical stretch by a factor of 2', false, 'This uses the size of the shift, 2, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 3^(2), not by the number of units shifted.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.4-b-v2', 'mcq', 'see that a horizontal translation of an exponential graph equals a vertical scaling, and find the scale factor as a powe (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f(x) = 4·(1/2)ˣ is translated 3 units to the right. Which single vertical transformation of the graph of f produces exactly the same graph?', null, md5('apprecalc-mcq-b7-sv-h-2.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a vertical compression by a factor of 1/8', false, 'This reverses the direction of the factor. Translating 3 units to the right gives f(x − 3) = 4·1/2^(x − 3), which equals 4·1/2^(−3)·1/2ˣ, so the factor is 8, not 1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a vertical stretch by a factor of 8', true, 'Correct: f(x − 3) = 4·1/2^(x − 3) = [4·1/2^(−3)]·1/2ˣ = 32·1/2ˣ, so the coefficient is multiplied by 8.' from version_ins
union all select gen_random_uuid(), id, 'C', 'a vertical stretch by a factor of 2', false, 'This uses the factor for a shift of one unit. A shift of 3 units multiplies the coefficient by 1/2^(−3) = 8, because each unit of shift contributes one factor of 1/2^(-1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'a vertical stretch by a factor of 3', false, 'This uses the size of the shift, 3, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 1/2^(−3), not by the number of units shifted.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.4-b-v3', 'mcq', 'see that a horizontal translation of an exponential graph equals a vertical scaling, and find the scale factor as a powe (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The graph of f(x) = 12·(1/3)ˣ is translated 2 units to the left. Which single vertical transformation of the graph of f produces exactly the same graph?', null, md5('apprecalc-mcq-b7-sv-h-2.4-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'a vertical stretch by a factor of 9', false, 'This reverses the direction of the factor. Translating 2 units to the left gives f(x + 2) = 12·1/3^(x + 2), which equals 12·1/3^(2)·1/3ˣ, so the factor is 1/9, not 9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'a vertical compression by a factor of 1/3', false, 'This uses the factor for a shift of one unit. A shift of 2 units multiplies the coefficient by 1/3^(2) = 1/9, because each unit of shift contributes one factor of 1/3^(1).' from version_ins
union all select gen_random_uuid(), id, 'C', 'a vertical compression by a factor of 1/2', false, 'This uses the size of the shift, 2, as if it were the factor. Shifting an exponential graph changes its coefficient by a power of the base, 1/3^(2), not by the number of units shifted.' from version_ins
union all select gen_random_uuid(), id, 'D', 'a vertical compression by a factor of 1/9', true, 'Correct: f(x + 2) = 12·1/3^(x + 2) = [12·1/3^(2)]·1/3ˣ = 4/3·1/3ˣ, so the coefficient is multiplied by 1/9.' from version_ins;
-- apprecalc-mcq-b7-h-2.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-h-2.5-a', 'mcq', 'build an exponential model from two measurements taken three units apart, backing out the initial value and the per-unit', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bacteria culture is growing in a lab. The model Q(t) = a·bᵗ, with t in hours, is built from two measurements: Q(1) = 1200 and Q(4) = 2073.6. Which choice gives the initial value Q(0) and the percent change of Q per hour?', null, md5('apprecalc-mcq-b7-h-2.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q(0) = 1000; Q increases by 20% each hour', true, 'Correct: 2073.6/1200 = b³ = 1.728, so b = 1.2, a 20% increase per hour. Then Q(0) = 1200/1.2 = 1000.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q(0) = 1200; Q increases by 20% each hour', false, 'This reports the first measurement, Q(1) = 1200, as the initial value. That measurement was taken at t = 1, so going back 1 hour with the factor 1.2 gives Q(0) = 1000.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q(0) = 1000; Q increases by 72.8% each hour', false, 'This reports the percent change across all three hours between the measurements, 72.8%, as the change per hour. The ratio 2073.6/1200 = 1.728 equals b³, so the per-hour factor is b = 1.2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q(0) = 908.8; Q increases by 24.3% each hour', false, 'This treats the two measurements as a straight line, with a constant change of 291.2 per hour. The model is exponential, so it is the percent change, not the amount of change, that stays constant from hour to hour.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.5-a-v1', 'mcq', 'build an exponential model from two measurements taken three units apart, backing out the initial value and the per-unit (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The area covered by algae in a pond, in square meters, is growing. The model Q(t) = a·bᵗ, with t in days, is built from two measurements: Q(2) = 180 and Q(5) = 607.5. Which choice gives the initial value Q(0) and the percent change of Q per day?', null, md5('apprecalc-mcq-b7-sv-h-2.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q(0) = 180; Q increases by 50% each day', false, 'This reports the first measurement, Q(2) = 180, as the initial value. That measurement was taken at t = 2, so going back 2 days with the factor 1.5 gives Q(0) = 80.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q(0) = 80; Q increases by 50% each day', true, 'Correct: 607.5/180 = b³ = 3.375, so b = 1.5, a 50% increase per day. Then Q(0) = 180/2.25 = 80.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q(0) = 80; Q increases by 237.5% each day', false, 'This reports the percent change across all three days between the measurements, 237.5%, as the change per day. The ratio 607.5/180 = 3.375 equals b³, so the per-day factor is b = 1.5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q(0) = 37.5; Q increases by 79.2% each day', false, 'This treats the two measurements as a straight line, with a constant change of 142.5 per day. The model is exponential, so it is the percent change, not the amount of change, that stays constant from day to day.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.5-a-v2', 'mcq', 'build an exponential model from two measurements taken three units apart, backing out the initial value and the per-unit (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of a medicine in a patient''s blood, in milligrams, is decreasing. The model Q(t) = a·bᵗ, with t in hours, is built from two measurements: Q(1) = 200 and Q(4) = 102.4. Which choice gives the initial value Q(0) and the percent change of Q per hour?', null, md5('apprecalc-mcq-b7-sv-h-2.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q(0) = 200; Q decreases by 20% each hour', false, 'This reports the first measurement, Q(1) = 200, as the initial value. That measurement was taken at t = 1, so going back 1 hour with the factor 0.8 gives Q(0) = 250.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q(0) = 250; Q decreases by 20% each hour', true, 'Correct: 102.4/200 = b³ = 0.512, so b = 0.8, a 20% decrease per hour. Then Q(0) = 200/0.8 = 250.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q(0) = 250; Q decreases by 48.8% each hour', false, 'This reports the percent change across all three hours between the measurements, 48.8%, as the change per hour. The ratio 102.4/200 = 0.512 equals b³, so the per-hour factor is b = 0.8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q(0) = 232.5; Q decreases by 16.3% each hour', false, 'This treats the two measurements as a straight line, with a constant change of −32.5 per hour. The model is exponential, so it is the percent change, not the amount of change, that stays constant from hour to hour.' from version_ins;
-- apprecalc-mcq-b7-sv-h-2.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '5522b532-5e50-41f2-99a2-10144bd4e8db', 'apprecalc-mcq-b7-sv-h-2.5-a-v3', 'mcq', 'build an exponential model from two measurements taken three units apart, backing out the initial value and the per-unit (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The resale value of a machine, in dollars, is decreasing. The model Q(t) = a·bᵗ, with t in years, is built from two measurements: Q(2) = 810 and Q(5) = 590.49. Which choice gives the initial value Q(0) and the percent change of Q per year?', null, md5('apprecalc-mcq-b7-sv-h-2.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q(0) = 810; Q decreases by 10% each year', false, 'This reports the first measurement, Q(2) = 810, as the initial value. That measurement was taken at t = 2, so going back 2 years with the factor 0.9 gives Q(0) = 1000.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q(0) = 1000; Q decreases by 10% each year', true, 'Correct: 590.49/810 = b³ = 0.729, so b = 0.9, a 10% decrease per year. Then Q(0) = 810/0.81 = 1000.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q(0) = 1000; Q decreases by 27.1% each year', false, 'This reports the percent change across all three years between the measurements, 27.1%, as the change per year. The ratio 590.49/810 = 0.729 equals b³, so the per-year factor is b = 0.9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q(0) = 883.2; Q decreases by 9% each year', false, 'This treats the two measurements as a straight line, with a constant change of −73.2 per year. The model is exponential, so it is the percent change, not the amount of change, that stays constant from year to year.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and content_key = any (array['apprecalc-mcq-b7-sv-h-2.4-a-v3','apprecalc-mcq-b7-h-2.4-b','apprecalc-mcq-b7-sv-h-2.4-b-v1','apprecalc-mcq-b7-sv-h-2.4-b-v2','apprecalc-mcq-b7-sv-h-2.4-b-v3','apprecalc-mcq-b7-h-2.5-a','apprecalc-mcq-b7-sv-h-2.5-a-v1','apprecalc-mcq-b7-sv-h-2.5-a-v2','apprecalc-mcq-b7-sv-h-2.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.content_key = any (array['apprecalc-mcq-b7-sv-h-2.4-a-v3','apprecalc-mcq-b7-h-2.4-b','apprecalc-mcq-b7-sv-h-2.4-b-v1','apprecalc-mcq-b7-sv-h-2.4-b-v2','apprecalc-mcq-b7-sv-h-2.4-b-v3','apprecalc-mcq-b7-h-2.5-a','apprecalc-mcq-b7-sv-h-2.5-a-v1','apprecalc-mcq-b7-sv-h-2.5-a-v2','apprecalc-mcq-b7-sv-h-2.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
