begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-h-2.1-a','apphysics1-mcq-b5-sv-h-2.1-a-v1','apphysics1-mcq-b5-sv-h-2.1-a-v2','apphysics1-mcq-b5-sv-h-2.1-a-v3','apphysics1-mcq-b5-h-2.1-b','apphysics1-mcq-b5-sv-h-2.1-b-v1','apphysics1-mcq-b5-sv-h-2.1-b-v2','apphysics1-mcq-b5-sv-h-2.1-b-v3','apphysics1-mcq-b5-h-2.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-h-2.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.1-a', 'mcq', 'apply Newton''s second law to a chosen system: internal force pairs cancel, so only external forces set the acceleration ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Block P (4 kg) rests on block Q (6 kg), which sits on a frictionless table. A horizontal 20 N force pushes on Q, and P rides on Q without slipping. For the system made of both blocks, which choice gives the net external horizontal force and the acceleration of the system''s center of mass?', null, md5('apphysics1-mcq-b5-h-2.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '28 N; 2.8 m/s². The 20 N push and the 8 N friction force on P both act on the system.', false, 'The 8 N friction force on P comes from Q, which is part of the system, so it is internal. Its equal and opposite partner on Q cancels it, so it never adds to the external force.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 N; 1.2 m/s². The 8 N friction force on P opposes the 20 N push.', false, 'Friction on P points forward, not backward, and the opposite friction force on Q cancels it inside the system. The external force on the system is the full 20 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 N; 3.3 m/s². Only the 6 kg block responds to the push.', false, 'P rides on Q without slipping, so both blocks share the same acceleration. The 20 N external force acts on the whole 10 kg system, not on 6 kg alone.' from version_ins
union all select gen_random_uuid(), id, 'D', '20 N; 2.0 m/s². Friction between the blocks is internal and does not change either value.', true, 'Correct: Internal pairs cancel, so F_ext = 20 N on M = 10 kg and a_cm = 2.0 m/s². Friction on P is 4 × 2 = 8 N forward, with an equal 8 N backward on Q.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.1-a-v1', 'mcq', 'apply Newton''s second law to a chosen system: internal force pairs cancel, so only external forces set the acceleration  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2 kg block and a 3 kg block hang from opposite ends of a light string that passes over a light, frictionless pulley held by a fixed support. The blocks are released from rest. For the system of both blocks and the string, what are the net external force and the acceleration of the center of mass just after release?', null, md5('apphysics1-mcq-b5-sv-h-2.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 N downward; 0.4 m/s² downward.', true, 'Correct: a = (30 − 20)/5 = 2 m/s² and T = 2(10 + 2) = 24 N. The pulley pushes up on the string with 48 N, so F_net = 50 − 48 = 2 N down and a_cm = 2/5 = 0.4 m/s².' from version_ins
union all select gen_random_uuid(), id, 'B', '0 N; 0 m/s². The tensions are internal forces and cancel.', false, 'The tension pair inside the string is internal, but the pulley support pulls up on the string with an external 48 N, which is less than the 50 N weight. The net external force is not zero.' from version_ins
union all select gen_random_uuid(), id, 'C', '10 N downward; 2.0 m/s² downward. This is the net force and acceleration of the blocks.', false, 'The heavier block accelerates down at 2.0 m/s² while the lighter one goes up at 2.0 m/s². Their motions partly cancel in the center of mass, so a_cm is much smaller than 2.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '50 N downward; 10 m/s² downward. Only gravity acts on the system.', false, 'The pulley support exerts an upward external force of 48 N through the string, so gravity is not the only external force. The system does not fall freely.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.1-a-v2', 'mcq', 'apply Newton''s second law to a chosen system: internal force pairs cancel, so only external forces set the acceleration  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart R (2 kg) and cart S (3 kg) are joined by a light spring on a frictionless horizontal track. A steady 15 N horizontal force pulls on R directly away from S, and the carts move together with the spring at a constant stretch. For the two-cart system, what are the net external force and the acceleration of the center of mass?', null, md5('apphysics1-mcq-b5-sv-h-2.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15 N; 3.0 m/s².', true, 'Correct: Only the 15 N pull is external, so a_cm = 15/(2 + 3) = 3.0 m/s². The spring pulls S with 3 × 3 = 9 N, leaving 15 − 9 = 6 N = 2 × 3 on R.' from version_ins
union all select gen_random_uuid(), id, 'B', '15 N; 7.5 m/s². The pull accelerates only the 2 kg cart.', false, 'The spring transmits the pull to S, so both carts accelerate together. The 15 N external force acts on the whole 5 kg system, giving 3.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'C', '6 N; 1.2 m/s². The 9 N spring force subtracts from the 15 N pull.', false, 'The spring force on R is a force between parts of the system, so it is internal. It does subtract from the pull for cart R alone, but not for the system as a whole.' from version_ins
union all select gen_random_uuid(), id, 'D', '9 N; 1.8 m/s². Only the spring force acts on the system.', false, 'The 15 N pull is applied from outside the system and is the external force. The spring force of 9 N is internal and cancels with its partner.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.1-a-v3', 'mcq', 'apply Newton''s second law to a chosen system: internal force pairs cancel, so only external forces set the acceleration  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 70 kg person stands at the rear of a 140 kg boat that is at rest on calm water, where water resistance is negligible. She walks 3.0 m toward the front, a distance measured relative to the boat. How far does the boat move relative to the water, and in which direction?', null, md5('apphysics1-mcq-b5-sv-h-2.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.0 m, opposite to her walking direction.', false, 'The 3.0 m is her displacement relative to the boat, not the boat''s displacement. The center of mass stays fixed, so the boat moves only 1.0 m while she moves 2.0 m relative to the water.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.0 m, opposite to her walking direction.', false, 'The 2.0 m is her own displacement relative to the water. The boat has twice her mass, so it moves half as far as she does, which is 1.0 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.0 m, opposite to her walking direction.', true, 'Correct: x_cm stays fixed: 70(x_b + 3.0) + 140 x_b = 0 gives x_b = −1.0 m. She moves +2.0 m relative to the water and the boat moves 1.0 m back.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 m. The net external force on the system is zero, so nothing moves.', false, 'A zero net external force keeps the center of mass of the system fixed, not each part. Her push on the boat is internal, so the boat moves backward while she moves forward.' from version_ins;
-- apphysics1-mcq-b5-h-2.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.1-b', 'mcq', 'locate the center of mass at a later time: it moves at the mass-weighted velocity even when the parts move differently', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two small carts ride on separate, parallel frictionless tracks, so they never touch. Cart 1 (2 kg) starts at x = 0 and moves at +4 m/s. Cart 2 (6 kg) starts at x = +8 m and moves at −2 m/s. At what x-coordinate is the center of mass of the two-cart system at t = 2.0 s?', null, md5('apphysics1-mcq-b5-h-2.1-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+6.0 m. With no external force the center of mass stays where it started.', false, 'No net external force means the center of mass has constant velocity, not zero velocity. Here v_cm = −0.5 m/s, so it moves 1.0 m in 2.0 s.' from version_ins
union all select gen_random_uuid(), id, 'B', '+8.0 m. The center of mass moves at the plain average of the velocities, +1 m/s.', false, 'The center of mass velocity is total momentum over total mass, which weights each velocity by mass. The 6 kg cart dominates, so v_cm is −0.5 m/s, not +1 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+5.0 m', true, 'Correct: At t = 2.0 s the carts are at +8.0 m and +4.0 m: x_cm = (2·8 + 6·4)/8 = 5.0 m. Equivalent: x_cm0 = 6.0 m, v_cm = (8 − 12)/8 = −0.5 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '+4.0 m. The center of mass follows the heavier cart.', false, 'The center of mass is between the carts, not at the heavier one. At t = 2.0 s the 6 kg cart is at +4.0 m, but the 2 kg cart is at +8.0 m, so x_cm is +5.0 m.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.1-b-v1', 'mcq', 'locate the center of mass at a later time: it moves at the mass-weighted velocity even when the parts move differently (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two small carts ride on separate, parallel frictionless tracks. Cart A (3 kg) starts at x = −4 m and moves at +6 m/s. Cart B (1 kg) starts at x = +4 m and moves at −2 m/s. At what x-coordinate is the center of mass of the system at t = 1.5 s?', null, md5('apphysics1-mcq-b5-sv-h-2.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−2.0 m. The center of mass stays at its starting position.', false, 'With no external force the center of mass keeps moving at constant velocity. Its velocity is +4 m/s, so it does not stay at its starting position of −2.0 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '+1.0 m. The center of mass moves at the plain average velocity, +2 m/s.', false, 'This averages the two velocities without weighting by mass. The 3 kg cart counts three times as much, giving v_cm = +4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+4.0 m', true, 'Correct: At 1.5 s the carts are at +5.0 m and +1.0 m: x_cm = (3·5 + 1·1)/4 = 4.0 m. Check: x_cm0 = −2 m, v_cm = (18 − 2)/4 = +4 m/s, so −2 + 6 = +4 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '+5.0 m. The center of mass is at the position of the heavier cart.', false, 'At t = 1.5 s cart A is at +5.0 m, but cart B is at +1.0 m. The center of mass lies between them, weighted toward the heavier cart, at +4.0 m.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.1-b-v2', 'mcq', 'locate the center of mass at a later time: it moves at the mass-weighted velocity even when the parts move differently (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two small carts ride on separate, parallel frictionless tracks. Cart C (5 kg) starts at x = +1 m and moves at −3 m/s. Cart D (1 kg) starts at x = +7 m and moves at +6 m/s. At what x-coordinate is the center of mass of the system at t = 2.0 s?', null, md5('apphysics1-mcq-b5-sv-h-2.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+2.0 m. The center of mass stays at its starting position.', false, 'No net external force keeps the center of mass moving at constant velocity, not at rest. Its velocity is −1.5 m/s, so after 2.0 s it has moved 3.0 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '+5.0 m. The center of mass moves at the plain average velocity, +1.5 m/s.', false, 'The plain average of −3 and +6 m/s ignores the masses. Weighting by mass gives v_cm = −1.5 m/s, directed the other way.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1.0 m', true, 'Correct: At 2.0 s the carts are at −5 m and +19 m: x_cm = (5(−5) + 1(19))/6 = −1.0 m. Check: x_cm0 = 2 m and v_cm = (−15 + 6)/6 = −1.5 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5.0 m. The center of mass is at the position of the heavier cart.', false, 'Cart C is at −5.0 m at t = 2.0 s, but cart D is at +19 m. The center of mass lies between them, at −1.0 m.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.1-b-v3', 'mcq', 'locate the center of mass at a later time: it moves at the mass-weighted velocity even when the parts move differently (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two small carts ride on separate, parallel frictionless tracks. Cart E (1 kg) starts at x = −3 m and moves at +8 m/s. Cart F (3 kg) starts at x = +5 m and is at rest. At what x-coordinate is the center of mass of the system at t = 2.5 s?', null, md5('apphysics1-mcq-b5-sv-h-2.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+3.0 m. The center of mass stays at its starting position.', false, 'The center of mass keeps moving at constant velocity when no external force acts. Its velocity is +2 m/s, so after 2.5 s it is 5.0 m from where it began.' from version_ins
union all select gen_random_uuid(), id, 'B', '+13.0 m. The center of mass moves at the plain average velocity, +4 m/s.', false, 'Averaging 8 m/s and 0 without mass weights overstates the motion. Cart F has three times the mass of E, so v_cm is only +2 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+5.0 m. The center of mass stays with the heavier cart, which is at rest.', false, 'The center of mass is not tied to either cart. Cart E moves to +17 m, so the center of mass shifts toward it and sits at +8.0 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '+8.0 m', true, 'Correct: At 2.5 s the carts are at +17 m and +5 m: x_cm = (1·17 + 3·5)/4 = 8.0 m. Check: x_cm0 = 3 m, v_cm = 8/4 = +2 m/s, so 3 + 5 = 8 m.' from version_ins;
-- apphysics1-mcq-b5-h-2.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.2-a', 'mcq', 'draw forces by their physical sources: a thrown object keeps no "force of the throw", and drag opposes the velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A ball is thrown straight up and air resistance (drag) is not negligible. Consider (i) a moment shortly after release, while the ball moves upward quickly, and (ii) the instant at the top of its path, when its speed is momentarily zero. Which choice correctly lists the forces exerted on the ball at those two moments?', null, md5('apphysics1-mcq-b5-h-2.2-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '(i) weight and drag, both directed downward; (ii) no forces, because the ball is momentarily at rest.', false, 'Speed zero does not mean zero force. Gravity still acts at the top, which is why the ball turns around.' from version_ins
union all select gen_random_uuid(), id, 'B', '(i) weight downward and an upward force from the throw; (ii) weight only.', false, 'Once the ball leaves the hand, no force from the throw remains. Only contact with the air (drag) and gravity act on it, and drag points down while the ball moves up.' from version_ins
union all select gen_random_uuid(), id, 'C', '(i) weight downward and drag upward, because drag opposes the weight; (ii) weight only.', false, 'Drag opposes the velocity, not the weight. The ball moves up, so drag points down; drag points up only when the ball is falling.' from version_ins
union all select gen_random_uuid(), id, 'D', '(i) weight and drag, both directed downward; (ii) weight only.', true, 'Correct: After release only gravity (down) and air drag act. Drag is opposite to the velocity, so it points down while the ball rises and is zero at the top where v = 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-h-2.1-a','apphysics1-mcq-b5-sv-h-2.1-a-v1','apphysics1-mcq-b5-sv-h-2.1-a-v2','apphysics1-mcq-b5-sv-h-2.1-a-v3','apphysics1-mcq-b5-h-2.1-b','apphysics1-mcq-b5-sv-h-2.1-b-v1','apphysics1-mcq-b5-sv-h-2.1-b-v2','apphysics1-mcq-b5-sv-h-2.1-b-v3','apphysics1-mcq-b5-h-2.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-h-2.1-a','apphysics1-mcq-b5-sv-h-2.1-a-v1','apphysics1-mcq-b5-sv-h-2.1-a-v2','apphysics1-mcq-b5-sv-h-2.1-a-v3','apphysics1-mcq-b5-h-2.1-b','apphysics1-mcq-b5-sv-h-2.1-b-v1','apphysics1-mcq-b5-sv-h-2.1-b-v2','apphysics1-mcq-b5-sv-h-2.1-b-v3','apphysics1-mcq-b5-h-2.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
