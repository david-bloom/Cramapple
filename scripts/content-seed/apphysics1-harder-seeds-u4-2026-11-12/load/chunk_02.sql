begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-sv-h-4.2-a-v1','apphysics1-mcq-b4-sv-h-4.2-a-v2','apphysics1-mcq-b4-sv-h-4.2-a-v3','apphysics1-mcq-b4-h-4.2-b','apphysics1-mcq-b4-sv-h-4.2-b-v1','apphysics1-mcq-b4-sv-h-4.2-b-v2','apphysics1-mcq-b4-sv-h-4.2-b-v3','apphysics1-mcq-b4-h-4.3-a','apphysics1-mcq-b4-sv-h-4.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apphysics1-mcq-b4-sv-h-4.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.2-a-v1', 'mcq', 'use the area under a force-time record with a sign change and the initial velocity to find a final velocity (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4 kg cart moves along a frictionless track with an initial velocity of −5 m/s. The net force on it, along the track, is +10 N from t = 0 to t = 2 s and then −4 N from t = 2 s to t = 5 s. What is the velocity of the cart at t = 5 s?', null, md5('apphysics1-mcq-b4-sv-h-4.2-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+2 m/s', false, 'This finds the velocity change, J/m = +2 m/s, but ignores the initial velocity of −5 m/s, as if the cart began at rest.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3 m/s', true, 'Correct: J = (+10)(2) + (−4)(3) = 20 − 12 = +8 N·s. Δv = 8/4 = +2 m/s. v_f = −5 + 2 = −3 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+7 m/s', false, 'This adds the +2 m/s velocity change to +5 m/s, dropping the negative sign of the initial velocity.' from version_ins
union all select gen_random_uuid(), id, 'D', '+3 m/s', false, 'This adds the net impulse of +8 N·s to the initial velocity without dividing by the 4 kg mass, giving 8 − 5.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.2-a-v2', 'mcq', 'use the area under a force-time record with a sign change and the initial velocity to find a final velocity (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3 kg cart moves along a frictionless track with an initial velocity of +10 m/s. The net force on it, along the track, is −6 N from t = 0 to t = 4 s and then +3 N from t = 4 s to t = 6 s. What is the velocity of the cart at t = 6 s?', null, md5('apphysics1-mcq-b4-sv-h-4.2-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−6 m/s', false, 'This finds the velocity change, J/m = −6 m/s, but forgets to add the initial velocity of +10 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '−16 m/s', false, 'This subtracts the 6 m/s change from −10 m/s, giving the initial velocity the wrong sign.' from version_ins
union all select gen_random_uuid(), id, 'C', '+4 m/s', true, 'Correct: J = (−6)(4) + (+3)(2) = −24 + 6 = −18 N·s. Δv = −18/3 = −6 m/s. v_f = +10 − 6 = +4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', '−8 m/s', false, 'This adds the net impulse of −18 N·s to the initial velocity without dividing by the 3 kg mass, giving −18 + 10.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.2-a-v3', 'mcq', 'use the area under a force-time record with a sign change and the initial velocity to find a final velocity (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2 kg cart moves along a frictionless track with an initial velocity of −4 m/s. The net force on it, along the track, is +12 N from t = 0 to t = 1 s and then −3 N from t = 1 s to t = 3 s. What is the velocity of the cart at t = 3 s?', null, md5('apphysics1-mcq-b4-sv-h-4.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+3 m/s', false, 'This finds the velocity change, J/m = +3 m/s, but ignores the initial velocity of −4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '+7 m/s', false, 'This adds the +3 m/s velocity change to +4 m/s, dropping the negative sign of the initial velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', '+2 m/s', false, 'This adds the net impulse of +6 N·s to the initial velocity without dividing by the 2 kg mass, giving 6 − 4.' from version_ins
union all select gen_random_uuid(), id, 'D', '−1 m/s', true, 'Correct: J = (+12)(1) + (−3)(2) = 12 − 6 = +6 N·s. Δv = 6/2 = +3 m/s. v_f = −4 + 3 = −1 m/s.' from version_ins;
-- apphysics1-mcq-b4-h-4.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.2-b', 'mcq', 'compare the average forces in two collisions by the change in momentum, including a rebound, rather than by speed lost o', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg clay ball and a 0.50 kg rubber ball each hit the same wall at 6.0 m/s, and each is in contact with the wall for the same time. The clay ball sticks to the wall. The rubber ball rebounds at 4.0 m/s. How do the average forces the wall exerts on the balls compare?', null, md5('apphysics1-mcq-b4-h-4.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The force on the rubber ball is about 1.7 times the force on the clay ball.', true, 'Correct: Clay: |Δp| = 0.5(6) = 3.0 kg·m/s. Rubber: magnitude 0.5(6 + 4) = 5.0 kg·m/s. With equal times, F_rubber/F_clay = 5/3 ≈ 1.7.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The forces are equal, because both balls arrive with the same momentum and the same contact time.', false, 'The force depends on the change in momentum, not the initial momentum. The rubber ball''s momentum changes by 5.0 kg·m/s and the clay ball''s by only 3.0 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The force on the clay ball is about 3 times the force on the rubber ball, because the clay ball loses 6 m/s of speed and the rubber ball loses only 2 m/s.', false, 'This compares changes in speed, ignoring that the rubber ball reverses direction. Its velocity changes from +6 to −4 m/s, a change of 10 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force on the clay ball is about 1.8 times the force on the rubber ball, because the clay ball loses 9 J of kinetic energy and the rubber ball loses 5 J.', false, 'Force is set by the change in momentum, not by energy lost. Energy lost says nothing about how large a push is needed to reverse the ball''s velocity.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.2-b-v1', 'mcq', 'compare the average forces in two collisions by the change in momentum, including a rebound, rather than by speed lost o (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.20 kg clay ball and a 0.20 kg rubber ball each hit the same wall at 10 m/s, with equal contact times. The clay ball sticks. The rubber ball rebounds at 5 m/s. How do the average forces the wall exerts on the balls compare?', null, md5('apphysics1-mcq-b4-sv-h-4.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The forces are equal, because both balls arrive with the same momentum and the same contact time.', false, 'The force depends on the change in momentum. The rubber ball''s momentum changes by 3.0 kg·m/s and the clay ball''s by 2.0 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The force on the clay ball is 2 times the force on the rubber ball, because the clay ball loses 10 m/s of speed and the rubber ball loses only 5 m/s.', false, 'This compares speed lost and ignores that the rubber ball reverses direction, so its velocity changes by 15 m/s, not 5 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The force on the clay ball is about 1.3 times the force on the rubber ball, because the clay ball loses 10 J of kinetic energy and the rubber ball loses 7.5 J.', false, 'Force is set by the change in momentum, not by kinetic energy lost. The energy comparison reverses the true ordering of the forces.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force on the rubber ball is 1.5 times the force on the clay ball.', true, 'Correct: Clay: Δp magnitude = 0.20(10) = 2.0 kg·m/s. Rubber: 0.20(10 + 5) = 3.0 kg·m/s. With equal contact times, F_rubber/F_clay = 3.0/2.0 = 1.5.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.2-b-v2', 'mcq', 'compare the average forces in two collisions by the change in momentum, including a rebound, rather than by speed lost o (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1000 kg car hits a barrier at 6.0 m/s in two crash tests, each lasting the same time. In test 1 the car stops against the barrier. In test 2 the car rebounds at 2.0 m/s. How do the average forces on the car compare?', null, md5('apphysics1-mcq-b4-sv-h-4.2-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The force in test 2 is about 1.3 times the force in test 1.', true, 'Correct: Test 1: |Δp| = 1000(6) = 6000 kg·m/s. Test 2: |Δp| = 1000(6 + 2) = 8000 kg·m/s. With equal times, F2/F1 = 8000/6000 ≈ 1.3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The forces are equal, because the car arrives at the same speed with the same contact time.', false, 'The force depends on the change in momentum. In test 2 the change is 8000 kg·m/s and in test 1 it is 6000 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The force in test 1 is 1.5 times the force in test 2, because the car loses 6 m/s of speed in test 1 and only 4 m/s in test 2.', false, 'This compares changes in speed (6 versus 4) but in test 2 the velocity reverses, so the change in velocity is 8 m/s, not 4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force in test 1 is about 1.1 times the force in test 2, because the car loses 18000 J of kinetic energy in test 1 and 16000 J in test 2.', false, 'Force is set by the change in momentum, not by energy lost. Using energy lost reverses the true ordering of the two forces.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.2-b-v3', 'mcq', 'compare the average forces in two collisions by the change in momentum, including a rebound, rather than by speed lost o (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.40 kg ball arrives at a catcher''s pad at 8.0 m/s, and the contact lasts the same time in two trials. In trial 1 the ball is held by the pad. In trial 2 the ball is deflected back at 2.0 m/s. How do the average forces on the ball compare?', null, md5('apphysics1-mcq-b4-sv-h-4.2-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The forces are equal, because the ball arrives with the same momentum and the same contact time.', false, 'The force depends on the change in momentum. In trial 2 the change is 4.0 kg·m/s and in trial 1 it is 3.2 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The force in trial 1 is 1.33 times the force in trial 2, because the ball loses 8 m/s of speed in trial 1 and 6 m/s in trial 2.', false, 'This compares changes in speed. In trial 2 the ball reverses, so the velocity change is 10 m/s, not 6 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The force in trial 1 is 1.07 times the force in trial 2, because the ball loses 12.8 J of kinetic energy in trial 1 and 12.0 J in trial 2.', false, 'Force is set by the change in momentum, not by kinetic energy lost. Using energy reverses the true ordering of the forces.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The force in trial 2 is 1.25 times the force in trial 1.', true, 'Correct: Trial 1: |Δp| = 0.40(8) = 3.2 kg·m/s. Trial 2: 0.40(8 + 2) = 4.0 kg·m/s. With equal times, F2/F1 = 4.0/3.2 = 1.25.' from version_ins;
-- apphysics1-mcq-b4-h-4.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.3-a', 'mcq', 'apply conservation of momentum to an internal explosion of a moving object, keeping signs and the initial momentum', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4 kg cart moves at +3 m/s along a frictionless track. A small internal explosion splits it into a 1 kg piece and a 3 kg piece. Immediately afterward the 1 kg piece moves at −6 m/s. What is the velocity of the 3 kg piece immediately afterward?', null, md5('apphysics1-mcq-b4-h-4.3-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+2 m/s', false, 'This balances the explosion as though the cart started at rest, so the 3 kg piece only cancels the 1 kg piece''s momentum. The cart''s initial momentum of +12 kg·m/s must be included.' from version_ins
union all select gen_random_uuid(), id, 'B', '+3 m/s', false, 'This assumes the explosion changed only the small piece and left the large piece at its original velocity. Momentum is conserved for the pair, so both pieces change.' from version_ins
union all select gen_random_uuid(), id, 'C', '+4.5 m/s', false, 'This divides the correct momentum of the 3 kg piece, +18 kg·m/s, by the total mass of 4 kg rather than by the 3 kg piece''s mass.' from version_ins
union all select gen_random_uuid(), id, 'D', '+6 m/s', true, 'Correct: Initial p = 4(3) = +12 kg·m/s. After: 1(−6) + 3v = 12, so 3v = 18 and v = +6 m/s.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.3-a-v1', 'mcq', 'apply conservation of momentum to an internal explosion of a moving object, keeping signs and the initial momentum (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5 kg cart moves at +2 m/s along a frictionless track. A small internal explosion splits it into a 2 kg piece and a 3 kg piece. Immediately afterward the 2 kg piece moves at −1 m/s. What is the velocity of the 3 kg piece immediately afterward?', null, md5('apphysics1-mcq-b4-sv-h-4.3-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+0.67 m/s', false, 'This balances the explosion as though the cart started at rest, so the 3 kg piece only cancels the 2 kg piece''s momentum. The cart''s initial momentum of +10 kg·m/s is ignored.' from version_ins
union all select gen_random_uuid(), id, 'B', '+4 m/s', true, 'Correct: Initial p = 5(2) = +10 kg·m/s. After: 2(−1) + 3v = 10, so 3v = 12 and v = +4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+2.0 m/s', false, 'This assumes the explosion left the 3 kg piece at the cart''s original velocity. Momentum is conserved for the pair, so both pieces change.' from version_ins
union all select gen_random_uuid(), id, 'D', '+2.4 m/s', false, 'This divides the correct momentum of the 3 kg piece, +12 kg·m/s, by the total mass of 5 kg rather than by the 3 kg piece''s mass.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-sv-h-4.2-a-v1','apphysics1-mcq-b4-sv-h-4.2-a-v2','apphysics1-mcq-b4-sv-h-4.2-a-v3','apphysics1-mcq-b4-h-4.2-b','apphysics1-mcq-b4-sv-h-4.2-b-v1','apphysics1-mcq-b4-sv-h-4.2-b-v2','apphysics1-mcq-b4-sv-h-4.2-b-v3','apphysics1-mcq-b4-h-4.3-a','apphysics1-mcq-b4-sv-h-4.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b4-sv-h-4.2-a-v1','apphysics1-mcq-b4-sv-h-4.2-a-v2','apphysics1-mcq-b4-sv-h-4.2-a-v3','apphysics1-mcq-b4-h-4.2-b','apphysics1-mcq-b4-sv-h-4.2-b-v1','apphysics1-mcq-b4-sv-h-4.2-b-v2','apphysics1-mcq-b4-sv-h-4.2-b-v3','apphysics1-mcq-b4-h-4.3-a','apphysics1-mcq-b4-sv-h-4.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
