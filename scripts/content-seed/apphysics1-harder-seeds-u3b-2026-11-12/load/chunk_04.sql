begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-sv-h-3.4-a-v3','apphysics1-mcq-b2-h-3.4-b','apphysics1-mcq-b2-sv-h-3.4-b-v1','apphysics1-mcq-b2-sv-h-3.4-b-v2','apphysics1-mcq-b2-sv-h-3.4-b-v3','apphysics1-mcq-b2-h-3.5-a','apphysics1-mcq-b2-sv-h-3.5-a-v1','apphysics1-mcq-b2-sv-h-3.5-a-v2','apphysics1-mcq-b2-sv-h-3.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apphysics1-mcq-b2-sv-h-3.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.4-a-v3', 'mcq', 'apply energy conservation with nonconservative work, and recognize which quantities do and do not depend on the path. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A block slides from rest down a frictionless ramp that drops 1.5 m, then onto a level floor where the coefficient of kinetic friction is 0.30. Use g = 10 m/s². How far along the floor does the block slide before stopping?', null, md5('apphysics1-mcq-b2-sv-h-3.4-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.45 m', false, '0.45 m multiplies the height by μ (μh) instead of dividing; friction''s work must equal the starting energy.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.0 m', true, 'Correct: mgh = μmg d, so d = h/μ = 1.5/0.30 = 5.0 m (the mass cancels).' from version_ins
union all select gen_random_uuid(), id, 'C', '10 m', false, '10 m drops the factor of 2 when going from v² = 2gh and the stopping relation, using d = v²/(μg).' from version_ins
union all select gen_random_uuid(), id, 'D', '50 m', false, '50 m forgets to divide by g when computing the stopping distance from v²/(2μ).' from version_ins;
-- apphysics1-mcq-b2-h-3.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.4-b', 'mcq', 'choose the right states and geometry (height, spring compression, loop condition) when applying conservation of mechanic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.0 kg ball is dropped from rest at 5.0 m above the floor, hits the floor, and rebounds to a height of 3.2 m. Use g = 10 m/s². How much mechanical energy of the ball-Earth system is dissipated in the collision?', null, md5('apphysics1-mcq-b2-h-3.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 J', true, 'Correct: Before: mgh = 50 J. After rebound: 32 J. Dissipated: 50 − 32 = 18 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '50 J', false, '50 J is the whole initial energy; the ball still has 32 J of mechanical energy after rebounding.' from version_ins
union all select gen_random_uuid(), id, 'C', '32 J', false, '32 J is the mechanical energy the ball retains after the bounce, not the amount lost.' from version_ins
union all select gen_random_uuid(), id, 'D', '82 J', false, '82 J adds the two energies; energy dissipated is their difference.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.4-b-v1', 'mcq', 'choose the right states and geometry (height, spring compression, loop condition) when applying conservation of mechanic (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spring with k = 400 N/m is compressed 0.10 m and launches a 0.050 kg ball straight up. Ignore friction and air drag, and treat the launch as occurring at the release point of the spring. Use g = 10 m/s². What is the maximum height of the ball above the release point?', null, md5('apphysics1-mcq-b2-sv-h-3.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.0 m', false, '2.0 m uses the stored energy in joules as if it were a height; dividing by the weight (0.50 N), not by 1 N, is what converts energy to height.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 m', false, '8.0 m uses U = kx² = 4.0 J and forgets the factor ½ in the spring energy.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.0 m', true, 'Correct: U_spring = ½(400)(0.10²) = 2.0 J. At the top, mgh = 2.0 J, so h = 2.0/(0.050 × 10) = 4.0 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '40 m', false, '40 m takes the energy as 20 J (½kx with x not squared); the spring energy involves x².' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.4-b-v2', 'mcq', 'choose the right states and geometry (height, spring compression, loop condition) when applying conservation of mechanic (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 m long pendulum bob is released from rest with the string at 60° from the vertical. Use g = 10 m/s². What is the speed of the bob at the lowest point?', null, md5('apphysics1-mcq-b2-sv-h-3.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.2 m/s', false, '3.2 m/s is √(gh) with h = 1.0 m; it drops the factor of 2 in v = √(2gh).' from version_ins
union all select gen_random_uuid(), id, 'B', '4.5 m/s', true, 'Correct: The bob drops h = L(1 − cos60°) = 2.0(0.5) = 1.0 m, so v = √(2gh) = 4.5 m/s. The tension does no work.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.3 m/s', false, '6.3 m/s uses the full string length 2.0 m as the drop; the bob falls only L(1 − cos60°).' from version_ins
union all select gen_random_uuid(), id, 'D', '7.7 m/s', false, '7.7 m/s uses h = L(1 + cos60°) = 3.0 m, which is the wrong geometry for the height drop.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.4-b-v3', 'mcq', 'choose the right states and geometry (height, spring compression, loop condition) when applying conservation of mechanic (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small cart starts from rest on a frictionless track and enters a vertical loop of radius 0.80 m. What is the minimum starting height above the bottom of the loop that lets the cart stay in contact with the track at the top of the loop? Use g = 10 m/s².', null, md5('apphysics1-mcq-b2-sv-h-3.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.0 m', true, 'Correct: At the top, contact requires v² ≥ gR. Energy: mg h = mg(2R) + ½mv²_top ≥ mg(2R) + ½mgR, so h ≥ 2.5R = 2.0 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.2 m', false, '1.2 m (1.5R) is too small even to reach the top of the loop, which is 1.6 m above the bottom.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.6 m', false, '1.6 m (2R) would bring the cart to the top with zero speed, but at the top it needs speed √(gR) to stay on the track.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.4 m', false, '2.4 m (3R) is more than needed; at the minimum speed the cart needs only 2.5R of starting height.' from version_ins;
-- apphysics1-mcq-b2-h-3.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.5-a', 'mcq', 'distinguish work from power and use efficiency, slope and time to compare energy transfer rates in multi-step settings.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Climber A has mass 60 kg and climbs 10 m in 20 s. Climber B has mass 80 kg and climbs 6.0 m in 15 s. Use g = 10 m/s². Which statement is correct about their work against gravity and average power?', null, md5('apphysics1-mcq-b2-h-3.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A does more work and has the greater average power.', false, 'A''s power is 300 W, which is less than B''s 320 W; more work does not imply more power when the time differs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A does more work, but B has the greater average power.', true, 'Correct: A: W = 60·10·10 = 6000 J, P = 300 W. B: W = 80·10·6.0 = 4800 J, P = 320 W. A does more work; B has more power.' from version_ins
union all select gen_random_uuid(), id, 'C', 'B does more work and has the greater average power.', false, 'B''s work is 4800 J, less than A''s 6000 J; B''s greater mass is offset by a smaller climb height.' from version_ins
union all select gen_random_uuid(), id, 'D', 'They do equal work, and B has the greater power.', false, 'The works are 6000 J and 4800 J, not equal, since mass times height differ.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.5-a-v1', 'mcq', 'distinguish work from power and use efficiency, slope and time to compare energy transfer rates in multi-step settings. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hoist motor is rated at 2.0 kW but only 80% of its output power goes into lifting. How long does it take to raise a 500 kg load 8.0 m at constant speed? Use g = 10 m/s².', null, md5('apphysics1-mcq-b2-sv-h-3.5-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '25 s', true, 'Correct: Work = 500·10·8.0 = 40000 J. Useful power = 0.80 × 2000 = 1600 W. t = 40000/1600 = 25 s.' from version_ins
union all select gen_random_uuid(), id, 'B', '16 s', false, '16 s divides the work by 2500 W, as if the efficiency increased the available power.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 s', false, '20 s uses the full 2000 W and ignores the efficiency loss.' from version_ins
union all select gen_random_uuid(), id, 'D', '31 s', false, '31 s applies the efficiency a second time (25 s ÷ 0.80).' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.5-a-v2', 'mcq', 'distinguish work from power and use efficiency, slope and time to compare energy transfer rates in multi-step settings. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cyclist and bicycle with total mass 80 kg climb a steady slope at a constant 5.0 m/s. The road rises 1.0 m for every 10 m traveled along it, and the combined drag and friction force opposing the motion is 20 N. Use g = 10 m/s². What power must the cyclist supply?', null, md5('apphysics1-mcq-b2-sv-h-3.5-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '400 W', false, '400 W accounts for the climb only and leaves out the power spent against drag and friction.' from version_ins
union all select gen_random_uuid(), id, 'B', '100 W', false, '100 W is the 100 N force alone; power is force times speed, so the force must be multiplied by 5.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '500 W', true, 'Correct: At constant speed the forward force is mg sinθ + drag = 80 + 20 = 100 N, so P = Fv = 100 × 5.0 = 500 W.' from version_ins
union all select gen_random_uuid(), id, 'D', '4000 W', false, '4000 W uses the full weight (800 N) instead of the component along the slope (80 N).' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.5-a-v3', 'mcq', 'distinguish work from power and use efficiency, slope and time to compare energy transfer rates in multi-step settings. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 100 W bulb is left on for 5.0 hours. An electric heater rated at 1500 W is run for 20 minutes. Which statement correctly compares the energy used?', null, md5('apphysics1-mcq-b2-sv-h-3.5-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The bulb and heater use equal energy.', true, 'Correct: Bulb: 100 W × 5.0 h = 0.50 kWh. Heater: 1500 W × (1/3 h) = 0.50 kWh. Equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The heater uses more energy because its power is 15 times larger.', false, 'The heater runs for only 1/15 as long, so the 15-times power advantage is exactly cancelled.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The bulb uses more energy because it is on for much longer.', false, 'The bulb has a much smaller power, and the longer time exactly cancels the heater''s greater rate of energy use.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The heater uses 3 times as much energy as the bulb.', false, 'A factor of 3 has no basis here; energy is power times time, and both devices use 0.50 kWh, so the ratio is 1.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-sv-h-3.4-a-v3','apphysics1-mcq-b2-h-3.4-b','apphysics1-mcq-b2-sv-h-3.4-b-v1','apphysics1-mcq-b2-sv-h-3.4-b-v2','apphysics1-mcq-b2-sv-h-3.4-b-v3','apphysics1-mcq-b2-h-3.5-a','apphysics1-mcq-b2-sv-h-3.5-a-v1','apphysics1-mcq-b2-sv-h-3.5-a-v2','apphysics1-mcq-b2-sv-h-3.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b2-sv-h-3.4-a-v3','apphysics1-mcq-b2-h-3.4-b','apphysics1-mcq-b2-sv-h-3.4-b-v1','apphysics1-mcq-b2-sv-h-3.4-b-v2','apphysics1-mcq-b2-sv-h-3.4-b-v3','apphysics1-mcq-b2-h-3.5-a','apphysics1-mcq-b2-sv-h-3.5-a-v1','apphysics1-mcq-b2-sv-h-3.5-a-v2','apphysics1-mcq-b2-sv-h-3.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
