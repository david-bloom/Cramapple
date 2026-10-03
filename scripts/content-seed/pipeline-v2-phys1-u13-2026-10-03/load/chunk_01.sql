begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-001-v1','apphy1-mcq-sv-001-v2','apphy1-mcq-sv-001-v3','apphy1-mcq-sv-003-v1','apphy1-mcq-sv-003-v2','apphy1-mcq-sv-003-v3','apphy1-mcq-sv-004-v1','apphy1-mcq-sv-004-v2','apphy1-mcq-sv-004-v3','apphy1-mcq-sv-005-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-001-v1', 'mcq', 'Sled average acceleration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled moving east at 5.0 m/s on a snowy slope speeds up to 15 m/s east over a time of 4.0 s. What is the sled''s average acceleration?', null, md5('apphy1-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.0 m/s² east', false, 'Adds the two velocities instead of subtracting: (5 + 15)/4.0 = 20/4.0 = 5.0 m/s². The velocity change is 15 − 5 = 10 m/s, giving 2.5 m/s².' from version_ins
union all select gen_random_uuid(), id, 'B', '3.75 m/s² east', false, 'Uses only the final velocity: 15/4.0 = 3.75 m/s². Acceleration depends on the change in velocity (15 − 5 = 10 m/s), not on the final velocity alone.' from version_ins
union all select gen_random_uuid(), id, 'C', '10 m/s² east', false, 'Finds the velocity change correctly (15 − 5 = 10 m/s) but never divides by the 4.0 s interval, so it reports the change in velocity as if it were the acceleration.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.5 m/s² east', true, 'Average acceleration is the change in velocity divided by the elapsed time: (15 − 5)/4.0 = 10/4.0 = 2.5 m/s², directed east because the velocity change is eastward.' from version_ins;
-- apphy1-mcq-sv-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-001-v2', 'mcq', 'Braking truck acceleration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A delivery truck traveling forward at 24 m/s brakes steadily, slowing to 6.0 m/s in 9.0 s while still moving forward. Taking the forward direction as positive, what is the truck''s average acceleration?', null, md5('apphy1-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−18 m/s²', false, 'Computes the velocity change correctly (6.0 − 24 = −18 m/s) but does not divide by the 9.0 s, so a change in velocity is reported as an acceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', '−3.3 m/s²', false, 'Adds the two speeds instead of finding their difference: (24 + 6.0)/9.0 = 30/9.0 ≈ 3.3 m/s², then attaches a negative sign because the truck slows. The velocity change is 6.0 − 24 = −18 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '+2.0 m/s²', false, 'Subtracts in the wrong order, (24 − 6.0)/9.0 = +2.0 m/s². Average acceleration is the final velocity minus the initial velocity, divided by the time, so slowing down along the positive direction gives a negative value.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2.0 m/s²', true, 'Average acceleration = (v − v₀)/Δt = (6.0 − 24)/9.0 = −18/9.0 = −2.0 m/s². The negative sign shows the acceleration points opposite the (forward) velocity.' from version_ins;
-- apphy1-mcq-sv-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-001-v3', 'mcq', 'Ball rebounding from wall', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rubber ball moving to the right at 6.0 m/s hits a wall and rebounds, leaving the wall moving to the left at 4.0 m/s. The ball is in contact with the wall for 0.50 s. Taking right as the positive direction, what is the ball''s average acceleration during the contact?', null, md5('apphy1-mcq-sv-001-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4.0 m/s²', false, 'Treats both speeds as having the same sign: (4.0 − 6.0)/0.50 = −4.0 m/s². The ball reverses direction, so the final velocity must be −4.0 m/s, giving a velocity change of −10 m/s, not −2.0 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '−20 m/s²', true, 'The final velocity is −4.0 m/s (leftward) and the initial velocity is +6.0 m/s. Average acceleration = (−4.0 − 6.0)/0.50 = −10/0.50 = −20 m/s², i.e. 20 m/s² directed to the left.' from version_ins
union all select gen_random_uuid(), id, 'C', '+20 m/s²', false, 'Gets the correct size, 10/0.50 = 20 m/s², but with the wrong sign. The acceleration points left (the direction of the velocity change), which is negative when right is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5.0 m/s²', false, 'Finds the velocity change correctly (−10 m/s) but multiplies by the contact time instead of dividing: −10 × 0.50 = −5.0 m/s². Dividing gives −10/0.50 = −20 m/s².' from version_ins;
-- apphy1-mcq-sv-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-003-v1', 'mcq', 'Cart net force acceleration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.5 kg cart rolls on a level track while a single unbalanced horizontal force of 18 N acts on it. What is the cart''s acceleration?', null, md5('apphy1-mcq-sv-003-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '81 m/s²', false, 'Multiplies force and mass: 18 × 4.5 = 81. Acceleration is F/m, so more mass lowers the acceleration rather than raising it.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.0 m/s²', true, 'Newton''s second law: a = F_net/m = 18 N / 4.5 kg = 4.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'C', '0.25 m/s²', false, 'Inverts Newton''s second law, dividing mass by force: 4.5/18 = 0.25. Acceleration is net force divided by mass, 18/4.5 = 4.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '13.5 m/s²', false, 'Subtracts the mass from the force: 18 − 4.5 = 13.5. The relation is a division, a = F/m, not a subtraction.' from version_ins;
-- apphy1-mcq-sv-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-003-v2', 'mcq', 'Pushed crate with friction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student pushes a 3.0 kg crate across a floor with a constant horizontal force of 20 N. Friction exerts a constant 8.0 N force on the crate opposite its motion. What is the crate''s acceleration?', null, md5('apphy1-mcq-sv-003-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 m/s²', false, 'Finds the net force correctly (12 N) but forgets to divide by the 3.0 kg mass, so the net force''s numerical value is reported as the acceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.0 m/s²', true, 'The net horizontal force is 20 − 8.0 = 12 N. Then a = F_net/m = 12/3.0 = 4.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'C', '6.7 m/s²', false, 'Uses the applied push alone and ignores friction: 20/3.0 = 6.7 m/s². Acceleration depends on the net force, which is 12 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.3 m/s²', false, 'Adds friction to the push instead of subtracting it: (20 + 8.0)/3.0 = 28/3.0 = 9.3 m/s². Friction opposes the motion, so the net force is 20 − 8.0 = 12 N.' from version_ins;
-- apphy1-mcq-sv-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-003-v3', 'mcq', 'Skater mass from net force', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A net horizontal force of 24 N causes a skater on smooth ice to accelerate at 0.40 m/s². What is the skater''s mass?', null, md5('apphy1-mcq-sv-003-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 kg', true, 'From F_net = ma, m = F_net/a = 24 N / 0.40 m/s² = 60 kg.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.017 kg', false, 'Inverts the ratio, a/F = 0.40/24 ≈ 0.017. Mass is force divided by acceleration (24/0.40 = 60 kg), not acceleration divided by force.' from version_ins
union all select gen_random_uuid(), id, 'C', '23.6 kg', false, 'Subtracts the acceleration from the force: 24 − 0.40 = 23.6. Newton''s second law relates the quantities by division, m = F/a, not subtraction.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.6 kg', false, 'Multiplies force and acceleration: 24 × 0.40 = 9.6. That product is not a mass; solving F = ma for m requires dividing the force by the acceleration.' from version_ins;
-- apphy1-mcq-sv-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-004-v1', 'mcq', 'Hanging lamp third-law partner', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lamp hangs at rest from the ceiling on a chain. The chain exerts an upward force on the lamp. Which force is the Newton''s-third-law partner of the chain''s upward force on the lamp?', null, md5('apphy1-mcq-sv-004-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the lamp''s downward force on the chain', true, 'Third-law partners are equal and opposite and act on two different objects, with the roles of the objects swapped. The chain pulls up on the lamp, so the partner is the lamp pulling down on the chain.' from version_ins
union all select gen_random_uuid(), id, 'B', 'the ceiling''s upward force on the chain', false, 'This is a force on the chain by the ceiling. Its own third-law partner is the chain''s force on the ceiling. The partner of the chain''s force on the lamp must involve the chain and the lamp.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Earth''s downward gravitational force on the lamp', false, 'This force balances the chain''s pull so the lamp stays at rest, but both forces act on the lamp. Third-law partners act on different objects, so this is not the partner (the partner of Earth''s pull on the lamp is the lamp''s pull on Earth).' from version_ins
union all select gen_random_uuid(), id, 'D', 'the net force on the lamp, which is zero', false, 'The net force is the vector sum of the forces on the lamp (here zero); it is not an interaction between two objects, so it cannot be a third-law partner. A zero net force does not pair with any individual force.' from version_ins;
-- apphy1-mcq-sv-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-004-v2', 'mcq', 'Kicked ball third-law partner', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'During a kick, a soccer player''s foot exerts a force on the ball. Which force is the Newton''s-third-law partner of the foot''s force on the ball?', null, md5('apphy1-mcq-sv-004-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the ball''s force on the foot', true, 'A third-law pair consists of two forces of equal magnitude and opposite direction exerted by two objects on each other. The foot pushes on the ball, so the partner is the ball pushing back on the foot.' from version_ins
union all select gen_random_uuid(), id, 'B', 'the ground''s friction force on the player''s planted foot', false, 'This is an interaction between the ground and the player''s other foot, not between the foot and the ball, so it cannot be the partner of the foot-on-ball force.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Earth''s gravitational force on the ball', false, 'This force acts on the ball, the same object the foot pushes on. Third-law partners act on different objects, and the partner of Earth''s pull on the ball is the ball''s pull on Earth.' from version_ins
union all select gen_random_uuid(), id, 'D', 'the player''s force on the ground', false, 'This is the partner of the ground''s force on the player. It involves the player and the ground, not the foot and the ball.' from version_ins;
-- apphy1-mcq-sv-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-004-v3', 'mcq', 'Earth-Moon third-law partner', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The Moon orbits Earth. Which force is the Newton''s-third-law partner of Earth''s gravitational force on the Moon?', null, md5('apphy1-mcq-sv-004-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Earth''s gravitational force on the Sun', false, 'This is a force on the Sun, from Earth, and it pairs with the Sun''s pull on Earth. It does not involve the Moon, so it is not the partner of Earth''s pull on the Moon.' from version_ins
union all select gen_random_uuid(), id, 'B', 'the Sun''s gravitational force on the Moon', false, 'This force acts on the Moon and comes from a different object (the Sun), so it is not an interaction between Earth and the Moon. The partner must be exerted by the Moon on Earth.' from version_ins
union all select gen_random_uuid(), id, 'C', 'an outward force on the Moon, away from Earth, that balances Earth''s pull', false, 'No such balancing outward force acts on the Moon; if one did, the net force would be zero and the Moon would move in a straight line. Also, the third-law partner of Earth''s pull on the Moon must be a force exerted by the Moon on Earth, not another force on the Moon.' from version_ins
union all select gen_random_uuid(), id, 'D', 'the Moon''s gravitational force on Earth', true, 'Third-law partners are equal in magnitude and opposite in direction and act on different objects. Earth pulls on the Moon, so the partner is the Moon pulling on Earth with a force of the same size.' from version_ins;
-- apphy1-mcq-sv-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-005-v1', 'mcq', 'Sled friction on slope', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 20 kg sled slides down a snowy hill that makes a 30° angle with the horizontal. It moves at constant velocity. Use g = 10 m/s². What is the magnitude of the friction force the snow exerts on the sled?', null, md5('apphy1-mcq-sv-005-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '173 N', false, 'Uses the weight component perpendicular to the slope, mg cos 30° = 200 × 0.866 = 173 N (the normal force), instead of the component along the slope, mg sin 30° = 100 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 N', false, 'Treats constant velocity as meaning no force acts. Constant velocity requires zero net force, which here means friction exactly balances the 100 N downhill component of gravity, so friction is not zero.' from version_ins
union all select gen_random_uuid(), id, 'C', '200 N', false, 'Uses the full weight, mg = 20 × 10 = 200 N, as the friction force. Only the component of the weight along the slope (100 N) must be balanced by friction.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 N', true, 'Constant velocity means the net force along the slope is zero, so friction equals the weight''s component along the slope: mg sin 30° = 20 × 10 × 0.50 = 100 N.' from version_ins;
commit;
