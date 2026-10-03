begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-031-v3','apphy1-mcq-sv-032-v1','apphy1-mcq-sv-032-v2','apphy1-mcq-sv-032-v3','apphy1-mcq-sv-033-v1','apphy1-mcq-sv-033-v2','apphy1-mcq-sv-033-v3','apphy1-mcq-sv-034-v1','apphy1-mcq-sv-034-v2','apphy1-mcq-sv-034-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-031-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-031-v3', 'mcq', 'Surface field of a larger planet', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Planet Z has twice Earth''s mass and twice Earth''s radius. If g_E is the gravitational field at Earth''s surface, what is the field at the surface of Planet Z?', null, md5('apphy1-mcq-sv-031-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 g_E', false, 'This accounts for the doubled mass only and ignores the radius.' from version_ins
union all select gen_random_uuid(), id, 'B', 'g_E', false, 'This assumes the doubled mass and doubled radius cancel (g depends on M/R), but the radius enters squared.' from version_ins
union all select gen_random_uuid(), id, 'C', 'g_E / 4', false, 'This accounts for the doubled radius only (1/2^2) and ignores the doubled mass.' from version_ins
union all select gen_random_uuid(), id, 'D', 'g_E / 2', true, 'g = GM/R^2. With M doubled and R doubled the field changes by a factor 2/2^2 = 1/2, so g = g_E/2.' from version_ins;
-- apphy1-mcq-sv-032-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-032-v1', 'mcq', 'Friction on a crate in an accelerating truck', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 50 kg crate rests on the flat bed of a truck. The coefficient of static friction between the crate and bed is 0.40. The truck speeds up from rest in the forward direction with a constant acceleration of 2.0 m/s^2, and the crate does not slide. Use g = 10 m/s^2. What is the friction force on the crate?', null, md5('apphy1-mcq-sv-032-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 N', false, 'Because the crate does not slide, one might expect no friction, but without friction it would be left behind; friction must supply ma = 100 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '100 N backward', false, 'The magnitude is right but friction must point forward: it is the only horizontal force that can accelerate the crate forward.' from version_ins
union all select gen_random_uuid(), id, 'C', '200 N forward', false, 'This uses the maximum static friction, mu_s N = 0.40 x 500 = 200 N; static friction only reaches that value at the verge of slipping.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 N forward', true, 'The crate accelerates with the truck, so F_net = ma = 50 x 2.0 = 100 N, and only static friction acts horizontally, so it is 100 N forward.' from version_ins;
-- apphy1-mcq-sv-032-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-032-v2', 'mcq', 'Friction on a book as a board is tilted', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A book rests on a flat board. The board is slowly tilted, and the book stays at rest on it. As the tilt angle increases but before the book slips, the friction force on the book', null, md5('apphy1-mcq-sv-032-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'equals mu_s times the normal force at every angle', false, 'mu_s N is only the maximum static friction, reached at the verge of slipping. Before that, friction equals mg sin(theta), which is less than mu_s N.' from version_ins
union all select gen_random_uuid(), id, 'B', 'increases, matching the growing weight component along the board', true, 'At rest, the friction balances the component of weight parallel to the board, mg sin(theta), which grows with the angle; static friction adjusts to whatever is needed up to its limit.' from version_ins
union all select gen_random_uuid(), id, 'C', 'is zero until the book begins to slide', false, 'The book would start sliding as soon as the board tilts if friction were zero; static friction already acts and equals mg sin(theta) at each angle.' from version_ins
union all select gen_random_uuid(), id, 'D', 'decreases, since the normal force on the book decreases', false, 'The normal force does decrease (mg cos(theta)), but static friction is not mu N; it equals the parallel weight component, which increases.' from version_ins;
-- apphy1-mcq-sv-032-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-032-v3', 'mcq', 'Friction on a cabinet that does not move', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 10 kg cabinet rests on a floor with mu_s = 0.50 and mu_k = 0.30. A mover pushes horizontally with 20 N and the cabinet stays at rest. The mover then pushes with 35 N and the cabinet still stays at rest. Use g = 10 m/s^2. What is the magnitude of the friction force during the 35 N push?', null, md5('apphy1-mcq-sv-032-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50 N', false, 'This is the maximum static friction, 0.50 × 100 = 50 N. Friction reaches that value only when the push reaches 50 N; at 35 N the friction equals the push, 35 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '20 N', false, 'This keeps the friction value from the first push; static friction increases to match the larger 35 N push.' from version_ins
union all select gen_random_uuid(), id, 'C', '35 N', true, 'The cabinet is at rest, so the net force is zero and static friction equals the push: 35 N (still below the maximum mu_s N = 50 N).' from version_ins
union all select gen_random_uuid(), id, 'D', '30 N', false, 'This is kinetic friction, 0.30 x 100 = 30 N, which applies only once the cabinet slides.' from version_ins;
-- apphy1-mcq-sv-033-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-033-v1', 'mcq', 'Spring force on a block pushed toward a wall', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'One end of an ideal horizontal spring (k = 150 N/m) is attached to a wall on the left. A block on the right end is pushed left so the spring is compressed 4.0 cm from its natural length. What force does the spring exert on the block?', null, md5('apphy1-mcq-sv-033-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '600 N to the right', false, 'This multiplies by 4.0 without converting cm to m: 150 x 4.0 = 600 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.12 N to the right', false, 'This uses the elastic energy formula, (1/2)kx^2 = 0.5 x 150 x 0.040^2 = 0.12, which is an energy in joules, not a force.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.0 N to the right', true, 'x = 4.0 cm = 0.040 m, so F = kx = 150 x 0.040 = 6.0 N. The compressed spring pushes the block back toward equilibrium, to the right.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.0 N to the left', false, 'The magnitude is right, but the spring force is restoring: a compressed spring pushes the block away from the wall, not toward it.' from version_ins;
-- apphy1-mcq-sv-033-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-033-v2', 'mcq', 'Finding k from a hanging mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.50 kg block hangs at rest from a vertical ideal spring and stretches the spring 0.10 m from its natural length. Use g = 10 m/s^2. What is the spring constant?', null, md5('apphy1-mcq-sv-033-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50 N/m', true, 'At rest the spring force balances the weight: kx = mg, so k = (0.50 x 10)/0.10 = 50 N/m.' from version_ins
union all select gen_random_uuid(), id, 'B', '100 N/m', false, 'This sets mg = (1/2)kx, giving k = 2mg/x = 100 N/m; Hooke''s law has no factor of 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.0 N/m', false, 'This divides the mass by the stretch, 0.50/0.10 = 5.0, using m instead of the weight mg.' from version_ins
union all select gen_random_uuid(), id, 'D', '500 N/m', false, 'This uses mg = kx^2, so k = 5.0/(0.10)^2 = 500 N/m; Hooke''s law is linear in x.' from version_ins;
-- apphy1-mcq-sv-033-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-033-v3', 'mcq', 'Spring force on a hand pulling a spring', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'One end of an ideal horizontal spring (k = 120 N/m, natural length 0.50 m) is fixed to a wall. A hand pulls the free end until the spring''s length is 0.62 m. What force does the spring exert on the hand?', null, md5('apphy1-mcq-sv-033-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '74 N toward the wall', false, 'This uses the full length 0.62 m as x: 120 x 0.62 = 74 N, rather than the 0.12 m stretch.' from version_ins
union all select gen_random_uuid(), id, 'B', '14 N away from the wall', false, 'The magnitude is right but the spring force is restoring: a stretched spring pulls the hand back toward the wall.' from version_ins
union all select gen_random_uuid(), id, 'C', '14 N toward the wall', true, 'The stretch is 0.62 - 0.50 = 0.12 m, so F = 120 x 0.12 = 14 N, and the stretched spring pulls the hand back toward the wall.' from version_ins
union all select gen_random_uuid(), id, 'D', '60 N toward the wall', false, 'This uses the natural length 0.50 m as x: 120 x 0.50 = 60 N, rather than the 0.12 m stretch.' from version_ins;
-- apphy1-mcq-sv-034-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-034-v1', 'mcq', 'Normal force at the bottom of a dip', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1200 kg car crosses the lowest point of a dip in a road. The dip is a circular arc of radius 30 m, and the car moves at 15 m/s. Using g = 10 m/s², the normal force of the road on the car at that point is', null, md5('apphy1-mcq-sv-034-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9000 N', false, 'Keeps only the centripetal term, N = mv²/r = (1200)(225)/30 = 9000 N, and leaves out the 12000 N needed just to balance the car''s weight.' from version_ins
union all select gen_random_uuid(), id, 'B', '12000 N', false, 'Sets N = mg, as if the car were in vertical equilibrium: (1200)(10) = 12000 N. The car accelerates toward the center of the arc, so N must exceed mg.' from version_ins
union all select gen_random_uuid(), id, 'C', '21000 N', true, 'Take inward (toward the arc''s center, which is above the car) as positive: N − mg = mv²/r, so N = mg + mv²/r = 12000 N + (1200)(15)²/30 N = 12000 N + 9000 N = 21000 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '3000 N', false, 'Uses mg − N = mv²/r, which takes the center of the circle to be below the car; N = 12000 − 9000 = 3000 N. At the lowest point of the dip the center is above the car, so the road''s upward push must exceed the weight.' from version_ins;
-- apphy1-mcq-sv-034-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-034-v2', 'mcq', 'Radial equation at the crest of a hill', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A skateboarder of mass m rolls over the top of a rounded hill whose surface is a circular arc of radius r. At the top she moves at speed v and stays in contact with the surface, which exerts a normal force N on her. Taking the direction toward the arc''s center (downward) as positive, which radial equation is correct?', null, md5('apphy1-mcq-sv-034-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'N = mg', false, 'Applies vertical equilibrium. She is moving along a curved path, so there is a nonzero inward acceleration v²/r and the vertical forces cannot balance.' from version_ins
union all select gen_random_uuid(), id, 'B', 'N − mg = mv²/r', false, 'Uses the signs appropriate to the bottom of a dip, with the normal force counted as inward. At the crest the normal force points away from the center, so this has the wrong sign on both terms.' from version_ins
union all select gen_random_uuid(), id, 'C', 'N + mg = mv²/r', false, 'Counts the normal force as pointing toward the center. At the crest the surface pushes upward, away from the center, so N reduces the net inward force instead of adding to it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'mg − N = mv²/r', true, 'At the crest the center of the arc is below her. Weight points toward the center (positive) and the normal force points away from it (negative), so the net inward force is mg − N = mv²/r.' from version_ins;
-- apphy1-mcq-sv-034-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-034-v3', 'mcq', 'Bucket swung in a vertical circle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student swings a bucket of water of mass m on a rope in a vertical circle of radius r. At the top of the circle the bucket moves at speed v and the rope exerts a tension T. Taking the direction toward the circle''s center (downward) as positive, which radial equation is correct at that instant?', null, md5('apphy1-mcq-sv-034-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T − mg = mv²/r', false, 'Treats weight as pointing away from the center, which is correct only at the bottom of the circle. At the top, weight points toward the center.' from version_ins
union all select gen_random_uuid(), id, 'B', 'mg − T = mv²/r', false, 'Treats the tension as pointing away from the center. A rope can only pull, and at the top it pulls the bucket toward the center, downward.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T + mg = mv²/r', true, 'At the top both the rope''s tension and the weight point downward, toward the center, so the net inward force is T + mg = mv²/r.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T = mv²/r', false, 'Leaves out gravity, as if only the rope supplied the inward force. Weight also points toward the center at the top, so it must appear in the sum.' from version_ins;
commit;
