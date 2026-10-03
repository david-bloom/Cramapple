begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-041-v3','apphy1-mcq-sv-np1-004-v1','apphy1-mcq-sv-np1-004-v2','apphy1-mcq-sv-np1-004-v3','apphy1-mcq-sv-np1-005-v1','apphy1-mcq-sv-np1-005-v2','apphy1-mcq-sv-np1-005-v3','apphy1-mcq-sv-np1-007-v1','apphy1-mcq-sv-np1-007-v2','apphy1-mcq-sv-np1-007-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-041-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-041-v3', 'mcq', 'Energy from a spring-launched block on a rough floor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A block is pressed against a compressed spring on a level rough floor, released, and slides until it comes to rest after the spring has fully relaxed and detached. Most of the spring''s initial elastic potential energy ends up as', null, md5('apphy1-mcq-sv-041-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'elastic potential energy', false, 'The spring has relaxed and detached, so it stores no energy at the end.' from version_ins
union all select gen_random_uuid(), id, 'B', 'gravitational potential energy', false, 'The floor is level, so the block''s height and gravitational potential energy do not change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'kinetic energy of the block', false, 'The block ends at rest, so its final kinetic energy is zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'thermal energy', true, 'The spring''s energy first becomes kinetic energy, and kinetic friction with the floor then dissipates it mostly as thermal energy of the block and floor.' from version_ins;
-- apphy1-mcq-sv-np1-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-004-v1', 'mcq', 'Normal force at the bottom of a loop', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A roller-coaster car moves along the inside of a vertical circular loop. At the lowest point of the loop the car is moving, so its speed is not zero. Which of the following correctly describes the normal force exerted by the track on the car at that point?', null, md5('apphy1-mcq-sv-np1-004-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Upward, with a magnitude equal to the car''s weight', false, 'That holds only when the car is at rest or moving in a straight line on a flat track. The car is accelerating toward the center, so the net force is not zero and N exceeds mg.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Upward, with a magnitude greater than the car''s weight', true, 'At the bottom the center of the circle is above the car. The net force must point upward, so N - mg = mv^2/r, which gives N = mg + mv^2/r > mg.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Upward, with a magnitude less than the car''s weight', false, 'An upward net force toward the center requires the upward normal force to exceed the downward weight, since N - mg = mv^2/r is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Downward, with a magnitude greater than the car''s weight', false, 'The track surface is below the car at the bottom, so it can only push the car upward. A downward normal force occurs only at the top of the loop.' from version_ins;
-- apphy1-mcq-sv-np1-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-004-v2', 'mcq', 'Normal force on a motorcycle at the top', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A motorcycle and rider, total mass 200 kg, ride along the inside of a vertical circular loop of radius 6 m. At the top of the loop their speed is 12 m/s. Use g = 10 m/s^2. What is the magnitude of the normal force exerted by the track at the top?', null, md5('apphy1-mcq-sv-np1-004-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2000 N', false, 'This is mg only, as if the track simply supported the weight. The motorcycle is accelerating toward the center at 24 m/s^2, so more than weight must be accounted for: N = 2800 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '2800 N', true, 'At the top both the weight and the normal force point downward toward the center: N + mg = mv^2/r. So N = (200)(12^2/6) - (200)(10) = 4800 - 2000 = 2800 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '6800 N', false, 'This is mv^2/r + mg = 4800 + 2000, the bottom-of-loop relation. At the top the weight helps supply the inward force, so it is subtracted: 4800 - 2000 = 2800 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '4800 N', false, 'This is mv^2/r alone, which treats the normal force as the entire net force and ignores the weight that also points toward the center at the top.' from version_ins;
-- apphy1-mcq-sv-np1-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-004-v3', 'mcq', 'Normal force beside the center of a loop', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small ball rolls along the inside of a vertical circular track. At one instant it is at the point on the right side of the track that is level with the center of the circle, and it is moving. What is the direction of the normal force exerted by the track on the ball at that instant?', null, md5('apphy1-mcq-sv-np1-004-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Horizontal, pointing to the left toward the center of the circle', true, 'The track is on the ball''s right and the normal force is perpendicular to the surface, pushing the ball toward the center. At this point that is horizontal and to the left; it supplies the centripetal force while gravity acts downward.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Vertically upward, to balance the ball''s weight', false, 'The normal force is perpendicular to the surface of contact; at this point the track surface is vertical, so the normal force is horizontal, not vertical. The normal force here does not balance the weight.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Tangent to the track, pointing vertically downward', false, 'A normal force is perpendicular to the surface, not tangent to it. At this point the tangent is vertical, and the downward pull there is gravity, not the normal force.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Horizontal, pointing to the right away from the center', false, 'The track is on the ball''s right side and can only push the ball away from the track surface, which is to the left. A rightward force would pull the ball into the track, which a normal force cannot do.' from version_ins;
-- apphy1-mcq-sv-np1-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-005-v1', 'mcq', 'Pushed cabinet that does not move', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 20 kg wooden cabinet sits on a level hardwood floor. The coefficient of static friction is 0.6 and the coefficient of kinetic friction is 0.4. A person pushes horizontally with a force of 60 N, and the cabinet does not move. Use g = 10 m/s^2. What is the magnitude of the friction force on the cabinet?', null, md5('apphy1-mcq-sv-np1-005-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 N', true, 'The cabinet is at rest, so the net horizontal force is zero and static friction equals the 60 N push. This is less than the maximum static friction, (0.6)(200) = 120 N, consistent with f_s <= mu_s N.' from version_ins
union all select gen_random_uuid(), id, 'B', '80 N', false, 'This is the kinetic friction, mu_k N = (0.4)(200 N) = 80 N. It applies only to a sliding object, and the cabinet is not sliding.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 N', false, 'With zero friction, the 60 N push would be unbalanced and the cabinet would accelerate, which contradicts the statement that it does not move.' from version_ins
union all select gen_random_uuid(), id, 'D', '120 N', false, 'This is the maximum static friction, mu_s N = (0.6)(200 N) = 120 N. Static friction only reaches that value when the cabinet is about to slip; here it matches the 60 N push.' from version_ins;
-- apphy1-mcq-sv-np1-005-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-005-v2', 'mcq', 'Push on a heavy appliance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 40 kg washing machine rests on a level garage floor. The coefficient of static friction between machine and floor is 0.45, and the coefficient of kinetic friction is 0.30. A worker pushes horizontally with 90 N, and the machine stays at rest. Use g = 10 m/s^2. What is the magnitude of the friction force the floor exerts on the machine?', null, md5('apphy1-mcq-sv-np1-005-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '180 N', false, 'This is the maximum static friction, mu_s N = (0.45)(400 N) = 180 N, which would only occur if the machine were on the verge of slipping.' from version_ins
union all select gen_random_uuid(), id, 'B', '120 N', false, 'This is the kinetic friction, mu_k N = (0.30)(400 N) = 120 N. Kinetic friction applies only once the machine slides.' from version_ins
union all select gen_random_uuid(), id, 'C', '400 N', false, 'This is the normal force (and weight), N = mg = (40)(10) = 400 N. Friction is not equal to the normal force; it is set by the applied push, which is 90 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '90 N', true, 'The machine is at rest, so the horizontal forces balance and static friction equals the 90 N push. The maximum static friction is (0.45)(400) = 180 N, so 90 N is allowed.' from version_ins;
-- apphy1-mcq-sv-np1-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-005-v3', 'mcq', 'Block pulled gently on a lab table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An 8 kg block is on a level lab table. The coefficient of static friction is 0.70 and the coefficient of kinetic friction is 0.50. A horizontal string pulls the block with a tension of 30 N, and the block does not move. Use g = 10 m/s^2. What is the magnitude of the static friction force on the block?', null, md5('apphy1-mcq-sv-np1-005-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '30 N', true, 'The block is in equilibrium, so static friction equals the 30 N tension. The maximum possible static friction is (0.70)(80) = 56 N, which is greater than 30 N, so the block stays at rest.' from version_ins
union all select gen_random_uuid(), id, 'B', '56 N', false, 'This is the maximum static friction, mu_s N = (0.70)(80 N) = 56 N. It is only reached at the verge of slipping, and the 30 N pull is smaller than it.' from version_ins
union all select gen_random_uuid(), id, 'C', '26 N', false, 'This is 56 N - 30 N, the unused margin of static friction. The friction force actually acting is the amount needed to balance the pull, which is 30 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '40 N', false, 'This is the kinetic friction, mu_k N = (0.50)(80 N) = 40 N, which applies only to a sliding block.' from version_ins;
-- apphy1-mcq-sv-np1-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-007-v1', 'mcq', 'Work pulling a suitcase', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A traveler pulls a suitcase 12 m along a level airport floor with a constant 50 N force on the handle, directed 35 degrees above the horizontal. Use cos(35 deg) = 0.819 and sin(35 deg) = 0.574. How much work does the pulling force do on the suitcase?', null, md5('apphy1-mcq-sv-np1-007-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '344 J', false, 'This uses sine instead of cosine: (50)(12)(0.574) = 344.4 J. The component along the displacement is F cos(theta), not F sin(theta).' from version_ins
union all select gen_random_uuid(), id, 'B', '491 J', true, 'W = Fd cos(theta) = (50 N)(12 m)(0.819) = 491.4 J, about 491 J. Only the component of force along the displacement does work.' from version_ins
union all select gen_random_uuid(), id, 'C', '733 J', false, 'This divides by the cosine: 600/0.819 = 732.6 J. The parallel component multiplies Fd by cos(theta), which is less than 1, so the work must be less than 600 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '600 J', false, 'This is Fd = (50)(12) with no angle factor, as if the whole force were along the displacement.' from version_ins;
-- apphy1-mcq-sv-np1-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-007-v2', 'mcq', 'Work pushing a lawn mower', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A person pushes a lawn mower 15 m across level grass with a constant 80 N force along the handle, which makes an angle of 30 degrees below the horizontal. Use cos(30 deg) = 0.866 and sin(30 deg) = 0.500. What is the work done on the mower by this 80 N force?', null, md5('apphy1-mcq-sv-np1-007-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '600 J', false, 'This uses sine: (80)(15)(0.500) = 600 J. The vertical component, F sin(theta), is perpendicular to the displacement and does no work.' from version_ins
union all select gen_random_uuid(), id, 'B', '1386 J', false, 'This divides by the cosine: 1200/0.866 = 1385.7 J. That would exceed Fd, which is impossible since only part of the force is along the displacement.' from version_ins
union all select gen_random_uuid(), id, 'C', '1039 J', true, 'W = Fd cos(theta) = (80 N)(15 m)(0.866) = 1039.2 J, about 1039 J. The component of the push along the displacement is 80 cos 30 degrees.' from version_ins
union all select gen_random_uuid(), id, 'D', '1200 J', false, 'This is Fd = (80)(15), ignoring the angle. Only the horizontal component of the push does work on the mower.' from version_ins;
-- apphy1-mcq-sv-np1-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-np1-007-v3', 'mcq', 'Work by a rope on a crate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rope pulls a 12 kg crate 6.5 m across a level warehouse floor. The rope exerts a constant 40 N force at 25 degrees above the horizontal. Use cos(25 deg) = 0.906 and sin(25 deg) = 0.423. How much work does the rope do on the crate?', null, md5('apphy1-mcq-sv-np1-007-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '287 J', false, 'This divides by the cosine: 260/0.906 = 287.0 J. The result exceeds Fd, which cannot happen because only the parallel component does work.' from version_ins
union all select gen_random_uuid(), id, 'B', '110 J', false, 'This uses sine: (40)(6.5)(0.423) = 110.0 J. The vertical component of the rope force does no work on a crate moving horizontally.' from version_ins
union all select gen_random_uuid(), id, 'C', '236 J', true, 'W = Fd cos(theta) = (40 N)(6.5 m)(0.906) = 235.6 J, about 236 J. The crate''s mass does not enter this calculation.' from version_ins
union all select gen_random_uuid(), id, 'D', '260 J', false, 'This is Fd = (40)(6.5), ignoring the angle between the rope and the floor.' from version_ins;
commit;
