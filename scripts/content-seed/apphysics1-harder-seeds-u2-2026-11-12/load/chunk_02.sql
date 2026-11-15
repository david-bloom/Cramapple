begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.2-a-v1','apphysics1-mcq-b5-sv-h-2.2-a-v2','apphysics1-mcq-b5-sv-h-2.2-a-v3','apphysics1-mcq-b5-h-2.2-b','apphysics1-mcq-b5-sv-h-2.2-b-v1','apphysics1-mcq-b5-sv-h-2.2-b-v2','apphysics1-mcq-b5-sv-h-2.2-b-v3','apphysics1-mcq-b5-h-2.3-a','apphysics1-mcq-b5-sv-h-2.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-sv-h-2.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.2-a-v1', 'mcq', 'draw forces by their physical sources: a thrown object keeps no "force of the throw", and drag opposes the velocity (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rock is thrown straight down from a bridge, and air drag is not negligible. A moment after it leaves the hand, while it is falling quickly, which choice correctly lists the forces exerted on the rock?', null, md5('apphysics1-mcq-b5-sv-h-2.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Weight directed downward, drag directed upward, and a downward force from the throw.', false, 'The throwing force acts only while the hand is in contact. After release the rock has no extra downward force; its speed comes from its earlier acceleration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Weight directed downward only, because drag acts only on rising objects.', false, 'Drag acts whenever an object moves through air, in either direction. It always opposes the velocity, so it points upward on a falling rock.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Weight directed downward and drag directed upward.', true, 'Correct: After release only gravity and drag act. Gravity is downward and drag opposes the downward velocity, so it is upward.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Weight and drag, both directed downward, because the rock moves downward.', false, 'Drag opposes the direction of motion rather than matching it. The rock moves down, so drag points up.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.2-a-v2', 'mcq', 'draw forces by their physical sources: a thrown object keeps no "force of the throw", and drag opposes the velocity (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stone is thrown horizontally to the right off a cliff, and air drag is not negligible. At one instant the stone is moving to the right and downward. Which choice correctly describes the forces exerted on it at that instant?', null, md5('apphysics1-mcq-b5-sv-h-2.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Weight straight down, drag directed to the left only, and a rightward force that keeps the stone moving.', false, 'No rightward force acts after release; the stone keeps its horizontal motion by inertia. Drag also opposes the full velocity, so it has an upward part too.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Weight directed down and to the right along the path, and drag directed up and to the left.', false, 'Weight always points straight down, toward Earth''s center, not along the path of motion. Only drag is tied to the direction of the velocity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Weight straight down, and drag directed straight up, because the stone is falling.', false, 'Drag opposes the whole velocity, which has both a rightward and a downward part. Drag therefore points up and to the left, not straight up.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Weight straight down, and drag directed up and to the left, opposite the velocity.', true, 'Correct: Only gravity (straight down) and drag act. Drag is opposite the velocity, so with v pointing right and down, drag points left and up.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.2-a-v3', 'mcq', 'draw forces by their physical sources: a thrown object keeps no "force of the throw", and drag opposes the velocity (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A soccer ball has just been kicked and is rising while moving to the right through the air. Air drag is not negligible. Which choice correctly lists the forces exerted on the ball at that instant?', null, md5('apphysics1-mcq-b5-sv-h-2.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Weight straight down, a force from the kick directed up and to the right, and drag directed down and to the left.', false, 'The kick force acts only during the brief contact with the foot. In flight the only forces are gravity and air drag.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Weight straight down and drag directed up and to the left, because drag opposes gravity.', false, 'Drag does not oppose the weight; it opposes the velocity. The ball moves up and right, so drag points down and to the left.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Weight straight down and drag directed horizontally to the left only.', false, 'Drag opposes the entire velocity vector, including its upward part. A rising ball therefore has a downward component of drag as well.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Weight straight down, and drag directed down and to the left, opposite the velocity.', true, 'Correct: In flight only gravity and drag act. Velocity points up and right, so drag points down and left, while weight points straight down.' from version_ins;
-- apphysics1-mcq-b5-h-2.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.2-b', 'mcq', 'analyze a free-body diagram of a hanging object: balance horizontal and vertical components to find unequal cable tensio', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6.0 kg lamp hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes an angle of 37° with the ceiling and the right cable makes 53° with the ceiling. Use sin 37° = cos 53° = 0.60, cos 37° = sin 53° = 0.80 and g = 10 m/s². What are the tensions in the left and right cables?', null, md5('apphysics1-mcq-b5-h-2.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Left 36 N; right 48 N.', true, 'Correct: Horizontal: 0.80 T_L = 0.60 T_R. Vertical: 0.60 T_L + 0.80 T_R = 60. Solving gives T_L = 36 N and T_R = 48 N.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Left 48 N; right 36 N, because the cable closer to horizontal pulls harder.', false, 'The cable closer to the horizontal carries less tension here. The steeper cable supplies more of the vertical support and also needs the larger horizontal component to balance the other cable.' from version_ins
union all select gen_random_uuid(), id, 'C', '30 N each, because each cable supports half of the 60 N weight.', false, 'Equal tensions are possible only if the cables make equal angles. Different angles require different tensions to balance horizontally and to support the weight.' from version_ins
union all select gen_random_uuid(), id, 'D', '60 N each, because each cable must hold the whole weight.', false, 'Each tension has a vertical component that adds with the other, so neither cable carries the full 60 N. The vertical components sum to 60 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.2-b-v1', 'mcq', 'analyze a free-body diagram of a hanging object: balance horizontal and vertical components to find unequal cable tensio (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 10 kg sign hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes 30° with the ceiling and the right cable makes 60° with the ceiling. Use g = 10 m/s². To the nearest newton, what are the tensions in the left and right cables?', null, md5('apphysics1-mcq-b5-sv-h-2.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Left 87 N; right 50 N, because the flatter cable pulls harder.', false, 'The flatter cable has the larger horizontal share of its force, but the horizontal parts must be equal. Its tension is the smaller one; the steeper cable has the larger tension.' from version_ins
union all select gen_random_uuid(), id, 'B', '50 N each, because each cable supports half of the weight.', false, 'The weight is shared as vertical components, which differ when the angles differ. Equal tensions would not balance horizontally.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Left 50 N; right 87 N.', true, 'Correct: T_L cos 30° = T_R cos 60° and T_L sin 30° + T_R sin 60° = 100 N. Then T_L = 50 N and T_R = 86.6 N ≈ 87 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 N each, because each cable must hold the whole weight.', false, 'The vertical components of the two tensions add to the 100 N weight, so neither cable alone carries 100 N unless the other is slack.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.2-b-v2', 'mcq', 'analyze a free-body diagram of a hanging object: balance horizontal and vertical components to find unequal cable tensio (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.0 kg planter hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes 53° with the ceiling and the right cable makes 37° with the ceiling. Use sin 37° = cos 53° = 0.60, cos 37° = sin 53° = 0.80 and g = 10 m/s². What are the tensions in the left and right cables?', null, md5('apphysics1-mcq-b5-sv-h-2.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Left 30 N; right 40 N, because the cable closer to horizontal pulls harder.', false, 'The cable closer to the horizontal is the right cable and it carries the smaller tension. The steeper left cable carries more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Left 40 N; right 30 N.', true, 'Correct: Horizontal: 0.60 T_L = 0.80 T_R. Vertical: 0.80 T_L + 0.60 T_R = 50. Solving gives T_L = 40 N and T_R = 30 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '25 N each, because each cable supports half of the 50 N weight.', false, 'Different cable angles give different vertical components. Equal tensions of 25 N would not even balance horizontally at 53° and 37°.' from version_ins
union all select gen_random_uuid(), id, 'D', '50 N each, because each cable must hold the whole weight.', false, 'Both cables share the load through their vertical components, so each tension is less than or comparable to the weight depending on the angle, and they are not both 50 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.2-b-v3', 'mcq', 'analyze a free-body diagram of a hanging object: balance horizontal and vertical components to find unequal cable tensio (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 kg lantern hangs at rest from two light cables fastened to a horizontal ceiling. The left cable makes 60° with the ceiling and the right cable makes 30° with the ceiling. Use g = 10 m/s². To the nearest newton, what are the tensions in the left and right cables?', null, md5('apphysics1-mcq-b5-sv-h-2.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Left 35 N; right 20 N.', true, 'Correct: T_L cos 60° = T_R cos 30° and T_L sin 60° + T_R sin 30° = 40 N. Then T_L = 34.6 N ≈ 35 N and T_R = 20 N.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Left 20 N; right 35 N, because the cable closer to horizontal pulls harder.', false, 'The right cable is closer to horizontal and has the smaller tension. The steeper left cable carries the larger tension.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 N each, because each cable supports half of the 40 N weight.', false, 'Splitting the weight in half assumes equal angles. With 60° and 30° the tensions must differ to balance horizontally.' from version_ins
union all select gen_random_uuid(), id, 'D', '40 N each, because each cable must hold the whole weight.', false, 'The vertical components of the tensions add to the 40 N weight. Each cable carries only part of it.' from version_ins;
-- apphysics1-mcq-b5-h-2.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.3-a', 'mcq', 'combine Newton''s second and third laws: the contact force between two pushed blocks is found from the acceleration of th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two blocks touch on a frictionless horizontal table. A horizontal 12 N force pushes on the 1.0 kg block, which pushes against the 3.0 kg block, and the blocks accelerate together. What is the magnitude of the force that the 3.0 kg block exerts on the 1.0 kg block?', null, md5('apphysics1-mcq-b5-h-2.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9 N', true, 'Correct: a = 12/(1.0 + 3.0) = 3.0 m/s². The 1.0 kg block pushes the 3.0 kg block with 3.0 × 3.0 = 9 N, and by the third law the 3.0 kg block pushes back with 9 N. Check: 12 − 9 = 1.0 × 3.0.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 N, because the push is transmitted undiminished through the blocks.', false, 'Only part of the push goes into accelerating the 1.0 kg block itself. The rest, 9 N, is passed on, so the contact force is less than 12 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 N, because that is the net force on the 1.0 kg block.', false, 'The 3 N is the net force on the 1.0 kg block (12 N minus the contact force). The contact force itself is the 9 N needed to accelerate the 3.0 kg block.' from version_ins
union all select gen_random_uuid(), id, 'D', '6 N, because the push is shared equally between the two blocks.', false, 'The push is shared in proportion to mass, not equally. The 3.0 kg block needs three times the force of the 1.0 kg block.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.3-a-v1', 'mcq', 'combine Newton''s second and third laws: the contact force between two pushed blocks is found from the acceleration of th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two blocks touch on a frictionless horizontal table. A horizontal 20 N force pushes on the 4.0 kg block, which pushes against a 1.0 kg block, and the blocks accelerate together. What is the magnitude of the force that the 1.0 kg block exerts on the 4.0 kg block?', null, md5('apphysics1-mcq-b5-sv-h-2.3-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 N, because the push is transmitted undiminished through the blocks.', false, 'Only the part needed to accelerate the 1.0 kg block is passed on. The 4.0 kg block itself needs most of the 20 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '4 N', true, 'Correct: a = 20/5.0 = 4.0 m/s². The 4.0 kg block pushes the 1.0 kg block with 1.0 × 4.0 = 4 N, and the third law gives 4 N back on the 4.0 kg block. Check: 20 − 4 = 4.0 × 4.0.' from version_ins
union all select gen_random_uuid(), id, 'C', '16 N, because that is the net force on the 4.0 kg block.', false, 'The 16 N is the net force on the 4.0 kg block, which is the push minus the contact force. The contact force by the 1.0 kg block is only 4 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '10 N, because the push is shared equally between the two blocks.', false, 'Equal sharing ignores that forces divide in proportion to mass. The 1.0 kg block needs only one fifth of the total.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.2-a-v1','apphysics1-mcq-b5-sv-h-2.2-a-v2','apphysics1-mcq-b5-sv-h-2.2-a-v3','apphysics1-mcq-b5-h-2.2-b','apphysics1-mcq-b5-sv-h-2.2-b-v1','apphysics1-mcq-b5-sv-h-2.2-b-v2','apphysics1-mcq-b5-sv-h-2.2-b-v3','apphysics1-mcq-b5-h-2.3-a','apphysics1-mcq-b5-sv-h-2.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-sv-h-2.2-a-v1','apphysics1-mcq-b5-sv-h-2.2-a-v2','apphysics1-mcq-b5-sv-h-2.2-a-v3','apphysics1-mcq-b5-h-2.2-b','apphysics1-mcq-b5-sv-h-2.2-b-v1','apphysics1-mcq-b5-sv-h-2.2-b-v2','apphysics1-mcq-b5-sv-h-2.2-b-v3','apphysics1-mcq-b5-h-2.3-a','apphysics1-mcq-b5-sv-h-2.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
