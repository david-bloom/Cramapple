begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.3-a-v2','apcalcab-mcq-b4-sv-h-4.3-a-v3','apcalcab-mcq-b4-h-4.3-b','apcalcab-mcq-b4-sv-h-4.3-b-v1','apcalcab-mcq-b4-sv-h-4.3-b-v2','apcalcab-mcq-b4-sv-h-4.3-b-v3','apcalcab-mcq-b4-h-4.4-a','apcalcab-mcq-b4-sv-h-4.4-a-v1','apcalcab-mcq-b4-sv-h-4.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-sv-h-4.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.3-a-v2', 'mcq', 'read increasing or decreasing and concavity from a table of a rate of change, and describe it as speeding up or slowing  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The water level in a reservoir is W(t) centimeters at time t days, and selected values of W′(t) are given in the table. Assume W′ keeps the trend shown for 0 < t < 9.
t (days):   0   3   6   9
W′(t) (centimeters per day):   −1.2   −2.0   −3.1   −4.5
Which statement is true for 0 < t < 9?', null, md5('apcalcab-mcq-b4-sv-h-4.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'W is decreasing and the decline is slowing, so the graph of W is concave up.', false, 'The size of W′ grows from 1.2 to 4.5 centimeters per day, so the level is falling faster each day. W′ is falling, which makes W concave down.' from version_ins
union all select gen_random_uuid(), id, 'B', 'W is increasing, because the values of W′ are getting larger in size.', false, 'W′ is negative throughout, so W is decreasing. A growing magnitude of a negative rate means the decline is speeding up, not that W increases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'W is decreasing, and W″ > 0 because W′ < 0.', false, 'The sign of W′ tells whether W is increasing or decreasing, not the sign of W″. W′ is decreasing from −1.2 to −4.5, so W″ < 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'W is decreasing and the decline is speeding up, so the graph of W is concave down.', true, 'Correct: W′ < 0, so W is decreasing. W′ decreases from −1.2 to −4.5, so W″ < 0 and the graph is concave down; the level falls faster each day.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.3-a-v3', 'mcq', 'read increasing or decreasing and concavity from a table of a rate of change, and describe it as speeding up or slowing  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The amount of product formed in a chemical reaction is P(t) grams at time t minutes, and selected values of P′(t) are given in the table. Assume P′ keeps the trend shown for 0 < t < 6.
t (minutes):   0   2   4   6
P′(t) (grams per minute):   0.5   1.1   1.9   3.0
Which statement is true for 0 < t < 6?', null, md5('apcalcab-mcq-b4-sv-h-4.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P is increasing, but the growth is slowing, so the graph of P is concave down.', false, 'P′ is rising from 0.5 to 3.0, which means the rate of growth is increasing. A rising P′ gives a concave up graph, not a concave down one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P is increasing and growth is speeding up, so the graph of P is concave up.', true, 'Correct: P′ > 0, so P is increasing. P′ increases from 0.5 to 3.0, so P″ > 0 and the graph is concave up: the product forms faster as time passes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P is decreasing, because the values of P′ are increasing.', false, 'P′ is positive throughout, so P is increasing. A rising P′ describes how the growth is changing, not the direction of P.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P is increasing at a constant rate.', false, 'P′ is not constant. It rises from 0.5 to 3.0 grams per minute, so the rate of formation changes over the interval.' from version_ins;
-- apcalcab-mcq-b4-h-4.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.3-b', 'mcq', 'compare marginal cost with average cost to decide whether average cost is rising or falling.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A manufacturer''s total cost of producing q units is C(q) = 0.02q² + 5q + 400 dollars, and the average cost per unit is A(q) = C(q)/q. At a production level of q = 50 units, which statement is correct?', null, md5('apcalcab-mcq-b4-h-4.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average cost per unit is increasing, because the total cost C is increasing.', false, 'Total cost increasing does not decide the behavior of the average. The average cost falls whenever the extra unit costs less than the current average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average cost per unit is decreasing, because the marginal cost C′(50) = 7 dollars per unit is less than the average cost A(50) = 14 dollars per unit.', true, 'Correct: C′(q) = 0.04q + 5, so C′(50) = 7. C(50) = 50 + 250 + 400 = 700, A(50) = 14. A′(q) = (qC′(q) − C(q))/q², so A′(50) = (350 − 700)/2500 = −0.14 < 0.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average cost per unit is increasing, because the marginal cost is increasing (C″(q) = 0.04 > 0).', false, 'A rising marginal cost does not alone make the average rise. At q = 50 the marginal cost 7 is still below the average 14, which pulls the average down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average cost per unit is 7 dollars at q = 50, because C′(50) = 7 gives the cost per unit.', false, 'C′(50) is the marginal cost of the next unit. The average cost per unit is C(50)/50 = 700/50 = 14 dollars.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.3-b-v1', 'mcq', 'compare marginal cost with average cost to decide whether average cost is rising or falling. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A print shop''s total cost of making q posters is C(q) = 0.05q² + 3q + 500 dollars, and the average cost per poster is A(q) = C(q)/q. At a production level of q = 60 posters, which statement is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average cost per poster is decreasing, because the marginal cost C′(60) = 9 dollars per poster is less than the average cost A(60) ≈ 14.33 dollars per poster.', true, 'Correct: C′(q) = 0.1q + 3, so C′(60) = 9. C(60) = 180 + 180 + 500 = 860, A(60) ≈ 14.33. A′(60) = (60·9 − 860)/3600 ≈ −0.089 < 0, so the average cost is decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average cost per poster is increasing, because the total cost C is increasing.', false, 'Total cost increasing does not decide whether the average rises. The average falls whenever the cost of one more poster is below the current average.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average cost per poster is increasing, because the marginal cost is increasing (C″(q) = 0.1 > 0).', false, 'A rising marginal cost does not alone make the average rise. At q = 60 the marginal cost 9 is below the average 14.33, which pulls the average down.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average cost per poster is 9 dollars at q = 60, because C′(60) = 9 gives the cost per poster.', false, 'C′(60) is the marginal cost of the next poster. The average cost per poster is C(60)/60 = 860/60, about 14.33 dollars.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.3-b-v2', 'mcq', 'compare marginal cost with average cost to decide whether average cost is rising or falling. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bike shop''s total cost of assembling q bikes in a month is C(q) = 0.5q² + 4q + 50 dollars, and the average cost per bike is A(q) = C(q)/q. At a production level of q = 20 bikes, which statement is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average cost per bike is decreasing, because the total cost C is increasing at a slowing pace.', false, 'The total cost''s growth is speeding up, since C″(q) = 1 > 0, and the extra bike costs more than the average, so the average is rising.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average cost per bike is increasing, because the marginal cost C′(20) = 24 dollars per bike is greater than the average cost A(20) = 16.50 dollars per bike.', true, 'Correct: C′(q) = q + 4, so C′(20) = 24. C(20) = 200 + 80 + 50 = 330, A(20) = 16.5. A′(20) = (20·24 − 330)/400 = 0.375 > 0, so the average cost is increasing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average cost per bike is decreasing, because 400 dollars of fixed cost is spread over more bikes.', false, 'The fixed cost is only 50 dollars here, and the marginal cost of 24 dollars is well above the average of 16.50, so the average is rising.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average cost per bike is 24 dollars at q = 20, because C′(20) = 24 gives the cost per bike.', false, 'C′(20) is the marginal cost of the next bike. The average cost per bike is C(20)/20 = 330/20 = 16.50 dollars.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.3-b-v3', 'mcq', 'compare marginal cost with average cost to decide whether average cost is rising or falling. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bottling plant''s total cost of filling q hundred bottles is C(q) = 0.01q² + 2q + 300 dollars, where q is measured in hundreds of bottles, and the average cost per hundred bottles is A(q) = C(q)/q. At a production level of q = 200 hundred bottles, which statement is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average cost per hundred bottles is decreasing, because the average is only 5.50 dollars and the marginal cost is 6 dollars.', false, 'The comparison is reversed. When the marginal cost 6 is above the average 5.50, the next hundred bottles raise the average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average cost per hundred bottles is decreasing, because the total cost C is increasing at a slowing pace.', false, 'C″(q) = 0.02 > 0, so the total cost grows faster, not slower, and the marginal cost is above the average, so the average is rising.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average cost per hundred bottles is increasing, because the marginal cost C′(200) = 6 dollars is greater than the average cost A(200) = 5.50 dollars.', true, 'Correct: C′(q) = 0.02q + 2, so C′(200) = 6. C(200) = 400 + 400 + 300 = 1100, A(200) = 5.5. A′(200) = (200·6 − 1100)/40000 = 0.0025 > 0, so the average cost is increasing.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average cost per hundred bottles is 6 dollars at q = 200, because C′(200) = 6 gives the average cost.', false, 'C′(200) is the marginal cost. The average cost is C(200)/200 = 1100/200 = 5.50 dollars.' from version_ins;
-- apcalcab-mcq-b4-h-4.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.4-a', 'mcq', 'build a relationship from similar triangles and differentiate it with respect to time.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6-foot-tall person walks away from a streetlight that is 15 feet tall. Let x be the person''s distance from the base of the light and s the length of the person''s shadow, both in feet. Which equation correctly relates ds/dt and dx/dt?', null, md5('apcalcab-mcq-b4-h-4.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ds/dt = (2/5)·dx/dt', false, 'This uses the ratio of heights 6/15 directly. The similar triangles give 15/(x + s) = 6/s, which leads to s = (2/3)x, not s = (2/5)x.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ds/dt = (2/3)·dx/dt', true, 'Correct: Similar triangles: 15/(x + s) = 6/s, so 15s = 6x + 6s, 9s = 6x, s = (2/3)x. Differentiating with respect to t gives ds/dt = (2/3)·dx/dt.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ds/dt = dx/dt', false, 'This assumes the shadow grows at the same rate as the person walks. The shadow length s is only a fraction of x, so it grows more slowly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ds/dt = (5/3)·dx/dt', false, 'This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow''s length s changes.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.4-a-v1', 'mcq', 'build a relationship from similar triangles and differentiate it with respect to time. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5-foot-tall person walks away from a lamp that is 20 feet tall. Let x be the person''s distance from the base of the lamp and s the length of the person''s shadow, both in feet. Which equation correctly relates ds/dt and dx/dt?', null, md5('apcalcab-mcq-b4-sv-h-4.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ds/dt = (1/4)·dx/dt', false, 'This uses the ratio of heights 5/20 directly. The similar triangles give 20/(x + s) = 5/s, which leads to s = x/3, not s = x/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ds/dt = dx/dt', false, 'This assumes the shadow grows at the same rate as the person walks. The shadow length s is only a fraction of x, so it grows more slowly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ds/dt = (4/3)·dx/dt', false, 'This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow''s length s changes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ds/dt = (1/3)·dx/dt', true, 'Correct: Similar triangles: 20/(x + s) = 5/s, so 20s = 5x + 5s, 15s = 5x, s = x/3. Differentiating with respect to t gives ds/dt = (1/3)·dx/dt.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.4-a-v2', 'mcq', 'build a relationship from similar triangles and differentiate it with respect to time. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A person 1.8 meters tall walks away from a lamppost that is 6 meters tall. Let x be the person''s distance from the base of the post and s the length of the person''s shadow, both in meters. Which equation correctly relates ds/dt and dx/dt?', null, md5('apcalcab-mcq-b4-sv-h-4.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ds/dt = (3/7)·dx/dt', true, 'Correct: Similar triangles: 6/(x + s) = 1.8/s, so 6s = 1.8x + 1.8s, 4.2s = 1.8x, s = (3/7)x. Differentiating with respect to t gives ds/dt = (3/7)·dx/dt.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ds/dt = (3/10)·dx/dt', false, 'This uses the ratio of heights 1.8/6 directly. The similar triangles give 6/(x + s) = 1.8/s, which leads to s = (3/7)x, not s = (3/10)x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ds/dt = dx/dt', false, 'This assumes the shadow grows at the same rate as the person walks. The shadow length s is only a fraction of x, so it grows more slowly.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ds/dt = (10/7)·dx/dt', false, 'This is the rate at which the tip of the shadow moves, d(x + s)/dt, not the rate at which the shadow''s length s changes.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-sv-h-4.3-a-v2','apcalcab-mcq-b4-sv-h-4.3-a-v3','apcalcab-mcq-b4-h-4.3-b','apcalcab-mcq-b4-sv-h-4.3-b-v1','apcalcab-mcq-b4-sv-h-4.3-b-v2','apcalcab-mcq-b4-sv-h-4.3-b-v3','apcalcab-mcq-b4-h-4.4-a','apcalcab-mcq-b4-sv-h-4.4-a-v1','apcalcab-mcq-b4-sv-h-4.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-sv-h-4.3-a-v2','apcalcab-mcq-b4-sv-h-4.3-a-v3','apcalcab-mcq-b4-h-4.3-b','apcalcab-mcq-b4-sv-h-4.3-b-v1','apcalcab-mcq-b4-sv-h-4.3-b-v2','apcalcab-mcq-b4-sv-h-4.3-b-v3','apcalcab-mcq-b4-h-4.4-a','apcalcab-mcq-b4-sv-h-4.4-a-v1','apcalcab-mcq-b4-sv-h-4.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
