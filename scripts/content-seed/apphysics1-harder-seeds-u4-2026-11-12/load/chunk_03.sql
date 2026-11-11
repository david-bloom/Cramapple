begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-sv-h-4.3-a-v2','apphysics1-mcq-b4-sv-h-4.3-a-v3','apphysics1-mcq-b4-h-4.3-b','apphysics1-mcq-b4-sv-h-4.3-b-v1','apphysics1-mcq-b4-sv-h-4.3-b-v2','apphysics1-mcq-b4-sv-h-4.3-b-v3','apphysics1-mcq-b4-h-4.4-a','apphysics1-mcq-b4-sv-h-4.4-a-v1','apphysics1-mcq-b4-sv-h-4.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apphysics1-mcq-b4-sv-h-4.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.3-a-v2', 'mcq', 'apply conservation of momentum to an internal explosion of a moving object, keeping signs and the initial momentum (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 50 kg skater glides at +4 m/s on frictionless ice while carrying a 10 kg medicine ball, so the pair moves at +4 m/s together. The skater throws the ball backward so that it moves at −2 m/s relative to the ice. What is the skater''s velocity immediately after the throw?', null, md5('apphysics1-mcq-b4-sv-h-4.3-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+4.0 m/s', false, 'This assumes the skater''s velocity is unchanged by throwing the ball. Throwing the ball is an internal interaction that changes the skater''s momentum.' from version_ins
union all select gen_random_uuid(), id, 'B', '+4.4 m/s', false, 'This gives the ball''s momentum the wrong sign, so 240 − 20 is divided by 50 kg. The ball moves backward, so its momentum is negative and the skater must gain momentum.' from version_ins
union all select gen_random_uuid(), id, 'C', '+5.2 m/s', true, 'Correct: Initial p = (50 + 10)(4) = +240 kg·m/s. After: 50v + 10(−2) = 240, so 50v = 260 and v = +5.2 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '+0.4 m/s', false, 'This balances the throw as though the pair started at rest, ignoring the initial momentum of +240 kg·m/s.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.3-a-v3', 'mcq', 'apply conservation of momentum to an internal explosion of a moving object, keeping signs and the initial momentum (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6 kg shell moves horizontally at +10 m/s. It breaks into a 2 kg piece and a 4 kg piece. Immediately afterward the 2 kg piece moves at −5 m/s. What is the velocity of the 4 kg piece immediately afterward?', null, md5('apphysics1-mcq-b4-sv-h-4.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+10 m/s', false, 'This assumes the larger piece keeps the shell''s original velocity. Momentum is conserved for the pair, so both pieces change.' from version_ins
union all select gen_random_uuid(), id, 'B', '+17.5 m/s', true, 'Correct: Initial p = 6(10) = +60 kg·m/s. After: 2(−5) + 4v = 60, so 4v = 70 and v = +17.5 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+12.5 m/s', false, 'This gives the 2 kg piece''s momentum the wrong sign, using 60 − 10 = 50 kg·m/s for the 4 kg piece. Its momentum is −10 kg·m/s, so the other piece must have +70 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '+2.5 m/s', false, 'This balances the break-up as though the shell began at rest, so the 4 kg piece only cancels the 2 kg piece''s momentum. The initial momentum of +60 kg·m/s is ignored.' from version_ins;
-- apphysics1-mcq-b4-h-4.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.3-b', 'mcq', 'chain a perfectly inelastic collision with a moving target to an energy calculation, using momentum for the collision an', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a frictionless horizontal surface, block A (3 kg) moves at +6 m/s and catches up with block B (2 kg) moving ahead of it at +1 m/s. They stick together and then slide up a frictionless ramp. Use g = 10 m/s². What maximum height above the surface do the blocks reach?', null, md5('apphysics1-mcq-b4-h-4.3-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.65 m', false, 'This treats block B as at rest, so the combined speed is 18/5 = 3.6 m/s. Block B''s momentum of +2 kg·m/s must be included.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.1 m', false, 'This assumes kinetic energy is conserved in the collision and sets the 55 J total equal to the potential energy. Sticking together is a perfectly inelastic collision in which kinetic energy is lost.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.80 m', true, 'Correct: Momentum: 3(6) + 2(1) = 20 = 5v, so v = 4 m/s just after sticking. Energy afterward: ½v² = gh, h = 16/20 = 0.80 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.8 m', false, 'This sends block A up the ramp by itself with its original 6 m/s, ignoring both the collision and block B.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.3-b-v1', 'mcq', 'chain a perfectly inelastic collision with a moving target to an energy calculation, using momentum for the collision an (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Block A (2 kg) moves at +5 m/s and block B (3 kg) moves toward it at −2 m/s on a frictionless surface. They collide head-on and stick together, then slide into a spring of force constant 2000 N/m, which is attached to a wall on the frictionless surface. What is the maximum compression of the spring?', null, md5('apphysics1-mcq-b4-sv-h-4.3-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16 cm', false, 'This adds the magnitudes of the momenta, 10 + 6 = 16 kg·m/s, so the blocks move at 3.2 m/s. Block B moves in the opposite direction, so its momentum subtracts.' from version_ins
union all select gen_random_uuid(), id, 'B', '18 cm', false, 'This assumes kinetic energy is conserved in the collision and uses the 31 J of kinetic energy from before sticking. Sticking together loses kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.0 cm', true, 'Correct: Momentum: 2(5) + 3(−2) = 4 = 5v, so v = 0.8 m/s. Energy: ½(5)(0.64) = 1.6 J = ½(2000)x², so x = 0.04 m = 4.0 cm.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 cm', false, 'This ignores block B''s momentum, so the blocks move at 10/5 = 2 m/s. Block B''s momentum of −6 kg·m/s must reduce the total.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.3-b-v2', 'mcq', 'chain a perfectly inelastic collision with a moving target to an energy calculation, using momentum for the collision an (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a frictionless surface, block A (2 kg) moves at +9 m/s and catches up with block B (4 kg) moving ahead of it at +3 m/s. They stick together and slide up a frictionless ramp. Use g = 10 m/s². What maximum height above the surface do the blocks reach?', null, md5('apphysics1-mcq-b4-sv-h-4.3-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.45 m', false, 'This treats block B as at rest, so the combined speed is 18/6 = 3 m/s. Block B''s momentum of +12 kg·m/s must be included.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.65 m', false, 'This assumes kinetic energy is conserved in the collision, using 99 J as the energy at the ramp. Sticking together loses kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.05 m', false, 'This sends block A up the ramp by itself with its original 9 m/s, ignoring the collision and block B.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.25 m', true, 'Correct: Momentum: 2(9) + 4(3) = 30 = 6v, so v = 5 m/s. Energy afterward: h = v²/(2g) = 25/20 = 1.25 m.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.3-b-v3', 'mcq', 'chain a perfectly inelastic collision with a moving target to an energy calculation, using momentum for the collision an (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'On a horizontal surface, block A (1 kg) moves at +7 m/s and catches up with block B (3 kg) moving ahead of it at +1 m/s. They stick together and slide to rest on a rough stretch with coefficient of kinetic friction 0.25. Use g = 10 m/s². How far do they slide on the rough stretch?', null, md5('apphysics1-mcq-b4-sv-h-4.3-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.25 m', true, 'Correct: Momentum: 1(7) + 3(1) = 10 = 4v, so v = 2.5 m/s. Friction does work: μmg·d = ½mv², so d = v²/(2μg) = 6.25/5 = 1.25 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.61 m', false, 'This treats block B as at rest, so the combined speed is 7/4 = 1.75 m/s. Block B''s momentum of +3 kg·m/s must be included.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.6 m', false, 'This assumes kinetic energy is conserved in the collision and uses 26 J divided by the friction force of 10 N. Sticking together loses kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.8 m', false, 'This slides block A alone at its original 7 m/s, ignoring the collision and block B.' from version_ins;
-- apphysics1-mcq-b4-h-4.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.4-a', 'mcq', 'classify a collision from momentum and kinetic energy before and after, using numbers', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2 kg cart moving at +4 m/s collides with a 1 kg cart at rest on a frictionless track. Motion sensors show that afterward the 2 kg cart moves at +2 m/s and the 1 kg cart moves at +4 m/s. Which statement about this collision is correct?', null, md5('apphysics1-mcq-b4-h-4.4-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is elastic, because the total momentum is the same before and after.', false, 'Conservation of momentum holds in every collision with no outside force, so it cannot show the collision is elastic. Kinetic energy falls from 16 J to 12 J.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is perfectly inelastic, because kinetic energy decreased.', false, 'A perfectly inelastic collision requires the objects to move together afterward. Here they end with different velocities, so kinetic energy was lost without the carts sticking.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is inelastic but the carts do not stick: momentum is conserved while kinetic energy falls from 16 J to 12 J.', true, 'Correct: Momentum: before 2(4) = 8, after 2(2) + 1(4) = 8. Kinetic energy: before ½(2)(16) = 16 J, after ½(2)(4) + ½(1)(16) = 4 + 8 = 12 J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The data are impossible, because kinetic energy is not conserved.', false, 'Kinetic energy need not be conserved. Momentum is conserved (8 kg·m/s before and after) and kinetic energy decreases, which is physically allowed.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.4-a-v1', 'mcq', 'classify a collision from momentum and kinetic energy before and after, using numbers (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3 kg cart moving at +5 m/s collides with a 2 kg cart at rest on a frictionless track. Afterward the 3 kg cart moves at +1 m/s and the 2 kg cart moves at +6 m/s. Which statement about this collision is correct?', null, md5('apphysics1-mcq-b4-sv-h-4.4-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is inelastic, because the 3 kg cart lost most of its speed.', false, 'Losing speed in a collision does not by itself mean kinetic energy is lost. Here the kinetic energy transferred to the 2 kg cart exactly matches what the 3 kg cart lost.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is elastic: momentum stays 15 kg·m/s and kinetic energy stays 37.5 J.', true, 'Correct: Momentum: 3(5) = 15 = 3(1) + 2(6). Kinetic energy: before ½(3)(25) = 37.5 J; after ½(3)(1) + ½(2)(36) = 1.5 + 36 = 37.5 J, so the collision is elastic.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is perfectly inelastic, because the 3 kg cart slows down a great deal.', false, 'A perfectly inelastic collision requires the carts to move together afterward. These carts separate at different speeds.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The data are impossible, because the 2 kg cart ends up faster than the 3 kg cart started.', false, 'A lighter cart can leave faster than the heavier cart arrived. Momentum (15 kg·m/s) and kinetic energy (37.5 J) are both consistent with these speeds.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.4-a-v2', 'mcq', 'classify a collision from momentum and kinetic energy before and after, using numbers (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2 kg cart moving at +3 m/s collides head-on with a 2 kg cart moving at −1 m/s on a frictionless track. Afterward both carts move together at +1 m/s. Which statement about this collision is correct?', null, md5('apphysics1-mcq-b4-sv-h-4.4-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is elastic, because the total momentum is the same before and after.', false, 'Momentum is conserved in every collision with no outside force. Kinetic energy falls from 10 J to 2 J, so the collision is not elastic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is inelastic but not perfectly inelastic, because the carts lose some kinetic energy.', false, 'The carts move together afterward at the same velocity, which is the definition of a perfectly inelastic collision. The maximum possible amount of kinetic energy was lost for this collision.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is perfectly inelastic: momentum is conserved while kinetic energy falls from 10 J to 2 J.', true, 'Correct: Momentum: 2(3) + 2(−1) = 4 = 4(1). Kinetic energy: before ½(2)(9) + ½(2)(1) = 10 J; after ½(4)(1) = 2 J. They move together, so it is perfectly inelastic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Momentum is not conserved, because kinetic energy decreased.', false, 'The two conservation laws are separate. Momentum is the same before and after (2(3) + 2(−1) = 4 kg·m/s, and 4(1) = 4 kg·m/s) even though kinetic energy decreased.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-sv-h-4.3-a-v2','apphysics1-mcq-b4-sv-h-4.3-a-v3','apphysics1-mcq-b4-h-4.3-b','apphysics1-mcq-b4-sv-h-4.3-b-v1','apphysics1-mcq-b4-sv-h-4.3-b-v2','apphysics1-mcq-b4-sv-h-4.3-b-v3','apphysics1-mcq-b4-h-4.4-a','apphysics1-mcq-b4-sv-h-4.4-a-v1','apphysics1-mcq-b4-sv-h-4.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b4-sv-h-4.3-a-v2','apphysics1-mcq-b4-sv-h-4.3-a-v3','apphysics1-mcq-b4-h-4.3-b','apphysics1-mcq-b4-sv-h-4.3-b-v1','apphysics1-mcq-b4-sv-h-4.3-b-v2','apphysics1-mcq-b4-sv-h-4.3-b-v3','apphysics1-mcq-b4-h-4.4-a','apphysics1-mcq-b4-sv-h-4.4-a-v1','apphysics1-mcq-b4-sv-h-4.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
