begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-sv-h-3.3-a-v2','apphysics1-mcq-b2-sv-h-3.3-a-v3','apphysics1-mcq-b2-h-3.3-b','apphysics1-mcq-b2-sv-h-3.3-b-v1','apphysics1-mcq-b2-sv-h-3.3-b-v2','apphysics1-mcq-b2-sv-h-3.3-b-v3','apphysics1-mcq-b2-h-3.4-a','apphysics1-mcq-b2-sv-h-3.4-a-v1','apphysics1-mcq-b2-sv-h-3.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apphysics1-mcq-b2-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.3-a-v2', 'mcq', 'read force direction and motion from potential-energy data: force is the negative slope of U, and total energy limits th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg particle on the x axis has potential energy 10 J at x = 0, 4 J at x = 2 m, and −2 J at x = 4 m, changing linearly between these points. It is released from rest at x = 0. What is its speed at x = 4 m?', null, md5('apphysics1-mcq-b2-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.8 m/s', false, '2.8 m/s sets K equal to the magnitude of the final U (2 J) instead of the decrease in U.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.9 m/s', true, 'Correct: ΔU = −2 − 10 = −12 J, so K = 12 J and v = √(2·12/0.50) = 6.9 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.9 m/s', false, '4.9 m/s leaves out the factor ½ in K = ½mv², using mv² = 12 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.3 m/s', false, '6.3 m/s uses the starting U (10 J) as the energy gained instead of the full change from 10 J to −2 J.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.3-a-v3', 'mcq', 'read force direction and motion from potential-energy data: force is the negative slope of U, and total energy limits th (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The potential energy of a particle (in joules) is 10 at x = 0, 6 at x = 1 m, 3 at x = 2 m, 4 at x = 3 m, 9 at x = 4 m and 15 at x = 5 m. Which statement is correct?', null, md5('apphysics1-mcq-b2-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There is a stable equilibrium near x = 2 m, and the force at x = 4 m points toward −x.', true, 'Correct: U is lowest near x = 2 m, so that is a stable equilibrium. At x = 4 m, U is rising with x, so F = −dU/dx is negative: toward −x, back toward the minimum.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There is a stable equilibrium at x = 0 where U is greatest, and the force at x = 4 m points toward +x.', false, 'At x = 0 the potential energy is falling steeply toward +x, so there is a force there and it is not an equilibrium; also U is rising at x = 4 m, so the force there is toward −x.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There is an equilibrium near x = 2 m, but the force at x = 4 m points toward +x.', false, 'At x = 4 m, U increases with x, so the force points toward −x; a +x force would push the particle up the potential hill.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There is no equilibrium because U is never zero.', false, 'Equilibrium occurs where the slope of U is zero, not where U itself is zero.' from version_ins;
-- apphysics1-mcq-b2-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.3-b', 'mcq', 'find changes in potential energy that depend on configuration (height, compression, reference level) rather than on path', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spring is stretched from 0 to 2.0 cm, and then further from 2.0 cm to 6.0 cm. How does the work needed in the second stretch compare with the work needed in the first?', null, md5('apphysics1-mcq-b2-h-3.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 times as much, because the second stretch is 2 times as long.', false, 'The second stretch is 4.0 cm against 2.0 cm, but the force also grows with stretch, so the work is not proportional to the length.' from version_ins
union all select gen_random_uuid(), id, 'B', '8 times as much, because U depends on the square of the stretch.', true, 'Correct: U = ½kx². First stretch: ½k(2²) = 2k (cm² units). Second: ½k(6² − 2²) = 16k. Ratio = 8.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 times as much, because 6.0 cm is 3 times 2.0 cm.', false, 'A ratio of 3 treats the work as proportional to the final stretch, but the spring force increases as it is stretched.' from version_ins
union all select gen_random_uuid(), id, 'D', '9 times as much, because the final stretch is 3 times the first.', false, 'A factor of 9 compares the total energy at 6.0 cm to that at 2.0 cm (36 to 4); the second stretch only adds the difference.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.3-b-v1', 'mcq', 'find changes in potential energy that depend on configuration (height, compression, reference level) rather than on path (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Maya takes the floor as U = 0 for a 2.0 kg book on a shelf 1.50 m high. Jon takes the 0.75 m high table as U = 0. The book falls from the shelf onto the table. Use g = 10 m/s². Which statement is correct?', null, md5('apphysics1-mcq-b2-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both find the book''s initial U is 30 J, so they agree on the energy of the shelf.', false, 'Jon''s initial U is 15 J, not 30 J; the value of U depends on the chosen zero.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Maya finds a decrease of 15 J and Jon finds a decrease of 30 J.', false, 'Jon''s value is also 15 J: the drop is 0.75 m for both, and the choice of zero does not change a difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only Maya''s analysis is correct, since the floor is the true zero of potential energy.', false, 'No reference level is physically special; any choice gives the same ΔU.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both find that the book''s U decreases by 15 J, though they disagree on the values of U.', true, 'Correct: Maya: 30 J to 15 J. Jon: 15 J to 0 J. Both find ΔU = −15 J = −mg(0.75 m). Only changes in U are physically meaningful.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.3-b-v2', 'mcq', 'find changes in potential energy that depend on configuration (height, compression, reference level) rather than on path (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 kg crate is pushed at constant speed 5.0 m along a ramp to a platform 3.0 m above the starting point. Use g = 10 m/s². What is the change in the gravitational potential energy of the crate-Earth system?', null, md5('apphysics1-mcq-b2-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '200 J', false, '200 J uses the ramp length (5.0 m) as the height; only the vertical change matters.' from version_ins
union all select gen_random_uuid(), id, 'B', '120 J', true, 'Correct: ΔU = mgΔh = 4.0 × 10 × 3.0 = 120 J, regardless of the path length along the ramp.' from version_ins
union all select gen_random_uuid(), id, 'C', '160 J', false, '160 J uses the horizontal distance of 4.0 m (from the 3-4-5 triangle) as the height.' from version_ins
union all select gen_random_uuid(), id, 'D', '72 J', false, '72 J applies the factor 3/5 a second time; the 3.0 m height already includes the incline geometry, so the rise is not scaled again.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.3-b-v3', 'mcq', 'find changes in potential energy that depend on configuration (height, compression, reference level) rather than on path (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spring with k = 200 N/m is compressed 0.10 m and then compressed further to 0.30 m. What is the change in the elastic potential energy stored in the spring?', null, md5('apphysics1-mcq-b2-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.0 J', false, '4.0 J uses ½k(Δx)² with Δx = 0.20 m; the energy depends on the squares of the compressions, not the square of their difference.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.0 J', false, '9.0 J is the total energy stored at 0.30 m; it does not subtract the 1.0 J already stored at 0.10 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '40 J', false, '40 J is k times the extra compression (200 × 0.20), which is a force in newtons, not an energy; energy changes come from differences of ½kx².' from version_ins
union all select gen_random_uuid(), id, 'D', '8.0 J', true, 'Correct: ΔU = ½(200)(0.30² − 0.10²) = 100(0.09 − 0.01) = 8.0 J.' from version_ins;
-- apphysics1-mcq-b2-h-3.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.4-a', 'mcq', 'apply energy conservation with nonconservative work, and recognize which quantities do and do not depend on the path.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block is released from rest at a height of 3.0 m on a curved track. Friction on the track dissipates a total of 8.0 J as the block reaches the bottom. Use g = 10 m/s². What is the block''s speed at the bottom?', null, md5('apphysics1-mcq-b2-h-3.4-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.2 m/s', true, 'Correct: mgh = 60 J. K_bottom = 60 − 8 = 52 J, so v = √(2·52/2.0) = √52 = 7.2 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.6 m/s', false, '6.6 m/s subtracts the 8.0 J of dissipated energy twice (K = 44 J).' from version_ins
union all select gen_random_uuid(), id, 'C', '7.7 m/s', false, '7.7 m/s ignores friction (K = 60 J), which is the answer for a frictionless track.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.2 m/s', false, '8.2 m/s adds the dissipated energy to the starting energy (K = 68 J) instead of subtracting it.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.4-a-v1', 'mcq', 'apply energy conservation with nonconservative work, and recognize which quantities do and do not depend on the path. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg ball is thrown straight up at 12 m/s and reaches a maximum height of 6.0 m because of air drag. Use g = 10 m/s². How much mechanical energy is transferred to thermal energy by air resistance during the rise?', null, md5('apphysics1-mcq-b2-sv-h-3.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '36 J', false, '36 J is the initial kinetic energy, not the amount lost to drag; some of it became gravitational potential energy.' from version_ins
union all select gen_random_uuid(), id, 'B', '30 J', false, '30 J is the gain in gravitational potential energy, not the energy lost to drag.' from version_ins
union all select gen_random_uuid(), id, 'C', '66 J', false, '66 J adds the initial kinetic energy and the final potential energy; the energy lost is their difference.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.0 J', true, 'Correct: Initial K = ½(0.50)(144) = 36 J. At the top U = mgh = 30 J and K = 0. Lost energy = 36 − 30 = 6.0 J.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.4-a-v2', 'mcq', 'apply energy conservation with nonconservative work, and recognize which quantities do and do not depend on the path. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Block X slides from rest down a frictionless ramp of height 2.0 m that is inclined at 30°. Block Y, with the same mass, slides from rest down a different frictionless ramp, also of height 2.0 m, inclined at 60°. Which statement is correct about their speeds at the bottom? Use g = 10 m/s².', null, md5('apphysics1-mcq-b2-sv-h-3.4-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Block Y is faster because its steeper ramp gives a larger acceleration.', false, 'A larger acceleration shortens the time, but the speed depends only on the height dropped when there is no friction.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Block X is faster because gravity does work over a longer distance on the gentler ramp.', false, 'Gravity''s work is mg × (vertical drop) on either ramp; the longer path is offset by a smaller force component along the slope.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both blocks reach the bottom at about 6.3 m/s, although block Y arrives sooner.', true, 'Correct: Frictionless: both lose mgh, so ½mv² = mgh gives v = √(2·10·2.0) = 6.3 m/s for both. Only the time differs (Y is steeper, so it arrives sooner).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Block Y reaches the bottom with a higher kinetic energy than block X.', false, 'Kinetic energy at the bottom equals mgh for both blocks, so they have equal K.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-sv-h-3.3-a-v2','apphysics1-mcq-b2-sv-h-3.3-a-v3','apphysics1-mcq-b2-h-3.3-b','apphysics1-mcq-b2-sv-h-3.3-b-v1','apphysics1-mcq-b2-sv-h-3.3-b-v2','apphysics1-mcq-b2-sv-h-3.3-b-v3','apphysics1-mcq-b2-h-3.4-a','apphysics1-mcq-b2-sv-h-3.4-a-v1','apphysics1-mcq-b2-sv-h-3.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b2-sv-h-3.3-a-v2','apphysics1-mcq-b2-sv-h-3.3-a-v3','apphysics1-mcq-b2-h-3.3-b','apphysics1-mcq-b2-sv-h-3.3-b-v1','apphysics1-mcq-b2-sv-h-3.3-b-v2','apphysics1-mcq-b2-sv-h-3.3-b-v3','apphysics1-mcq-b2-h-3.4-a','apphysics1-mcq-b2-sv-h-3.4-a-v1','apphysics1-mcq-b2-sv-h-3.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
