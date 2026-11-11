begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-h-4.5-b','apcalcab-mcq-b4-sv-h-4.5-b-v1','apcalcab-mcq-b4-sv-h-4.5-b-v2','apcalcab-mcq-b4-sv-h-4.5-b-v3','apcalcab-mcq-b4-h-4.6-a','apcalcab-mcq-b4-sv-h-4.6-a-v1','apcalcab-mcq-b4-sv-h-4.6-a-v2','apcalcab-mcq-b4-sv-h-4.6-a-v3','apcalcab-mcq-b4-h-4.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apcalcab-mcq-b4-h-4.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.5-b', 'mcq', 'relate the distance between two moving objects to their rates, using signs for approaching and receding motion.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Car P is 6 miles west of an intersection and is driving east toward it at 30 miles per hour. Car Q is 8 miles north of the same intersection and is driving north, away from it, at 40 miles per hour. At this instant, the distance D between the cars is changing at what rate?', null, md5('apcalcab-mcq-b4-h-4.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing at 50 miles per hour', false, 'This treats the rate for the approaching car as +30 instead of −30, giving (6·30 + 8·40)/10 and ignoring that car P is getting closer to the intersection.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increasing at 70 miles per hour', false, 'This adds the two speeds, 30 + 40. The rate of change of the distance between the cars is not the sum of their speeds, because they move along perpendicular lines.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increasing at 140 miles per hour', false, 'This computes x·dx/dt + y·dy/dt = 140 but forgets to divide by D = 10, which comes from differentiating D² = x² + y².' from version_ins
union all select gen_random_uuid(), id, 'D', 'Increasing at 14 miles per hour', true, 'Correct: Let x = distance of P from the intersection and y = distance of Q. D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. Here x = 6, dx/dt = −30, y = 8, dy/dt = 40, D = 10, so dD/dt = (−180 + 320)/10 = 14.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.5-b-v1', 'mcq', 'relate the distance between two moving objects to their rates, using signs for approaching and receding motion. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Boat A is 5 kilometers west of a dock and is moving east toward it at 12 kilometers per hour. Boat B is 12 kilometers north of the dock and is moving north, away from it, at 6 kilometers per hour. At this instant, the distance D between the boats is changing at what rate?', null, md5('apcalcab-mcq-b4-sv-h-4.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing at 132/13 kilometers per hour', false, 'This treats the rate for the approaching boat as +12 instead of −12, giving (5·12 + 12·6)/13 and ignoring that boat A is getting closer to the dock.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increasing at 18 kilometers per hour', false, 'This adds the two speeds, 12 + 6. The rate of change of the distance between the boats is not the sum of their speeds, because they move along perpendicular lines.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increasing at 12/13 kilometers per hour', true, 'Correct: D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. With x = 5, dx/dt = −12, y = 12, dy/dt = 6, D = 13: dD/dt = (−60 + 72)/13 = 12/13.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Increasing at 12 kilometers per hour', false, 'This computes x·dx/dt + y·dy/dt = 12 but forgets to divide by D = 13, which comes from differentiating D² = x² + y².' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.5-b-v2', 'mcq', 'relate the distance between two moving objects to their rates, using signs for approaching and receding motion. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Car M is 12 miles east of an intersection and is driving east, away from it, at 5 miles per hour. Car N is 5 miles north of the same intersection and is driving south toward it at 10 miles per hour. At this instant, the distance D between the cars is changing at what rate?', null, md5('apcalcab-mcq-b4-sv-h-4.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing at 110/13 miles per hour', false, 'This treats the rate for the approaching car as +10 instead of −10, giving (12·5 + 5·10)/13 and ignoring that car N is getting closer to the intersection.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Increasing at 15 miles per hour', false, 'This adds the two speeds, 5 + 10. The rate of change of the distance between the cars is not the sum of their speeds, because they move along perpendicular lines.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increasing at 10/13 miles per hour', true, 'Correct: D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. With x = 12, dx/dt = 5, y = 5, dy/dt = −10, D = 13: dD/dt = (60 − 50)/13 = 10/13.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Increasing at 10 miles per hour', false, 'This computes x·dx/dt + y·dy/dt = 10 but forgets to divide by D = 13, which comes from differentiating D² = x² + y².' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.5-b-v3', 'mcq', 'relate the distance between two moving objects to their rates, using signs for approaching and receding motion. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Robot R is 8 meters east of a pillar and is moving west toward it at 3 meters per second. Robot S is 6 meters north of the pillar and is moving south toward it at 4 meters per second. At this instant, the distance D between the robots is changing at what rate?', null, md5('apcalcab-mcq-b4-sv-h-4.5-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Increasing at 4.8 meters per second', false, 'The magnitude is right, but both robots move toward the pillar, so x·dx/dt + y·dy/dt is negative and the distance is shrinking. This answer has the wrong sign.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Decreasing at 48 meters per second', false, 'This computes x·dx/dt + y·dy/dt = −48 but forgets to divide by D = 10, which comes from differentiating D² = x² + y².' from version_ins
union all select gen_random_uuid(), id, 'C', 'Decreasing at 7 meters per second', false, 'This adds the two speeds, 3 + 4. The rate of change of the distance between the robots is not the sum of their speeds, because they move along perpendicular lines.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Decreasing at 4.8 meters per second', true, 'Correct: D² = x² + y², so D·dD/dt = x·dx/dt + y·dy/dt. With x = 8, dx/dt = −3, y = 6, dy/dt = −4, D = 10: dD/dt = (−24 − 24)/10 = −4.8, so D is decreasing.' from version_ins;
-- apcalcab-mcq-b4-h-4.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.6-a', 'mcq', 'form a tangent-line estimate and decide over or under from the trend of f′ in a table.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f(4) = 7, and f″ does not change sign on the interval shown; selected values of f′ are given in the table.
x:   4.0   4.1   4.2   4.3
f′(x):   −2.0   −1.8   −1.5   −1.1
The tangent line to the graph of f at x = 4 is used to approximate f(4.3). Which statement is correct?', null, md5('apcalcab-mcq-b4-h-4.6-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is 6.4, and it is an overestimate of f(4.3).', false, 'The values of f′ increase from −2.0 to −1.1, so f is concave up on this interval and the tangent line lies below the graph, giving an underestimate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is 7.6, and it is an overestimate of f(4.3).', false, 'This adds 0.6 instead of subtracting it, ignoring that f′(4) = −2.0 is negative. The tangent line value is 7 + (−2.0)(0.3) = 6.4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is 6.4, and it is an underestimate of f(4.3).', true, 'Correct: L(4.3) = f(4) + f′(4)(4.3 − 4) = 7 + (−2.0)(0.3) = 6.4. The values of f′ are increasing, so f″ > 0, the graph is concave up, and the tangent line lies below it: 6.4 underestimates f(4.3).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is 6.67, and it is an underestimate of f(4.3).', false, 'This uses the slope f′(4.3) = −1.1 at the far end. The tangent line at x = 4 must use the slope f′(4) = −2.0, which gives 6.4.' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.6-a-v1', 'mcq', 'form a tangent-line estimate and decide over or under from the trend of f′ in a table. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f(1) = 12, and f″ does not change sign on the interval shown; selected values of f′ are given in the table.
x:   1.0   1.2   1.4   1.5
f′(x):   5.0   4.2   3.1   2.4
The tangent line to the graph of f at x = 1 is used to approximate f(1.5). Which statement is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is 14.5, and it is an underestimate of f(1.5).', false, 'The values of f′ decrease from 5.0 to 2.4, so f is concave down on this interval and the tangent line lies above the graph, giving an overestimate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is 13.2, and it is an underestimate of f(1.5).', false, 'This uses the slope f′(1.5) = 2.4 at the far end. The tangent line at x = 1 must use the slope f′(1) = 5.0, which gives 14.5.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is 19.5, and it is an overestimate of f(1.5).', false, 'This multiplies the slope by 1.5, the new x-value, instead of by the change in x, which is 0.5.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is 14.5, and it is an overestimate of f(1.5).', true, 'Correct: L(1.5) = f(1) + f′(1)(1.5 − 1) = 12 + 5.0(0.5) = 14.5. The values of f′ are decreasing, so f″ < 0, the graph is concave down, and the tangent line lies above it: 14.5 overestimates f(1.5).' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.6-a-v2', 'mcq', 'form a tangent-line estimate and decide over or under from the trend of f′ in a table. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f(6) = −2, and f″ does not change sign on the interval shown; selected values of f′ are given in the table.
x:   5.6   5.8   6.0
f′(x):   2.0   2.5   3.0
The tangent line to the graph of f at x = 6 is used to approximate f(5.8). Which statement is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.6-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is −2.6, and it is an overestimate of f(5.8).', false, 'The values of f′ increase from 2.0 to 3.0, so f is concave up, and a tangent line to a concave up graph lies below it on both sides of the point, giving an underestimate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is −1.4, and it is an overestimate of f(5.8).', false, 'This uses x − 6 = +0.2 instead of −0.2. Moving left from x = 6 lowers the tangent line value, so L(5.8) = −2 + 3(−0.2) = −2.6.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is −2.5, and it is an underestimate of f(5.8).', false, 'This uses the slope f′(5.8) = 2.5 at the point being estimated. The tangent line at x = 6 must use the slope f′(6) = 3.0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is −2.6, and it is an underestimate of f(5.8).', true, 'Correct: L(5.8) = f(6) + f′(6)(5.8 − 6) = −2 + 3(−0.2) = −2.6. The values of f′ are increasing, so f″ > 0 and the graph is concave up; the tangent line lies below it on both sides, so −2.6 underestimates f(5.8).' from version_ins;
-- apcalcab-mcq-b4-sv-h-4.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-sv-h-4.6-a-v3', 'mcq', 'form a tangent-line estimate and decide over or under from the trend of f′ in a table. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A differentiable function f has f(3) = 5, and f″ does not change sign on the interval shown; selected values of f′ are given in the table.
x:   3.0   3.2   3.4
f′(x):   −1.0   −1.4   −2.0
The tangent line to the graph of f at x = 3 is used to approximate f(3.4). Which statement is correct?', null, md5('apcalcab-mcq-b4-sv-h-4.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The approximation is 4.6, and it is an underestimate of f(3.4).', false, 'The values of f′ decrease from −1.0 to −2.0, so f is concave down and the tangent line lies above the graph, giving an overestimate. Decreasing f does not mean an underestimate.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The approximation is 4.6, and it is an overestimate of f(3.4).', true, 'Correct: L(3.4) = f(3) + f′(3)(3.4 − 3) = 5 + (−1.0)(0.4) = 4.6. The values of f′ are decreasing, so f″ < 0, the graph is concave down, and the tangent line lies above it: 4.6 overestimates f(3.4).' from version_ins
union all select gen_random_uuid(), id, 'C', 'The approximation is 4.2, and it is an underestimate of f(3.4).', false, 'This uses the slope f′(3.4) = −2.0 at the far end. The tangent line at x = 3 must use the slope f′(3) = −1.0, which gives 4.6.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The approximation is 5.4, and it is an overestimate of f(3.4).', false, 'This adds 0.4 instead of subtracting it, ignoring that f′(3) = −1.0 is negative. The tangent line value is 5 + (−1.0)(0.4) = 4.6.' from version_ins;
-- apcalcab-mcq-b4-h-4.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-b4-h-4.6-b', 'mcq', 'use a linear approximation to turn a percent error in a measurement into a percent error in a derived quantity.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The radius of a spherical balloon is measured with a possible error of 2 percent. Using a linear approximation, what is the approximate percent error in the volume V = (4/3)πr³ calculated from this radius?', null, md5('apcalcab-mcq-b4-h-4.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 percent', false, 'This assumes the relative error in V equals the relative error in r. Since V depends on r³, the relative error is multiplied by 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 percent', false, 'This uses the exponent 2, as if the formula were an area such as πr². The volume formula has r³, so the factor is 3.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 percent', true, 'Correct: dV = 4πr²·dr, so dV/V = 4πr²·dr/((4/3)πr³) = 3·dr/r = 3(2%) = 6%.' from version_ins
union all select gen_random_uuid(), id, 'D', '8 percent', false, 'This cubes the percent, 2³, instead of multiplying by the exponent. The linear approximation gives dV/V = 3·dr/r.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and content_key = any (array['apcalcab-mcq-b4-h-4.5-b','apcalcab-mcq-b4-sv-h-4.5-b-v1','apcalcab-mcq-b4-sv-h-4.5-b-v2','apcalcab-mcq-b4-sv-h-4.5-b-v3','apcalcab-mcq-b4-h-4.6-a','apcalcab-mcq-b4-sv-h-4.6-a-v1','apcalcab-mcq-b4-sv-h-4.6-a-v2','apcalcab-mcq-b4-sv-h-4.6-a-v3','apcalcab-mcq-b4-h-4.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key = any (array['apcalcab-mcq-b4-h-4.5-b','apcalcab-mcq-b4-sv-h-4.5-b-v1','apcalcab-mcq-b4-sv-h-4.5-b-v2','apcalcab-mcq-b4-sv-h-4.5-b-v3','apcalcab-mcq-b4-h-4.6-a','apcalcab-mcq-b4-sv-h-4.6-a-v1','apcalcab-mcq-b4-sv-h-4.6-a-v2','apcalcab-mcq-b4-sv-h-4.6-a-v3','apcalcab-mcq-b4-h-4.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
