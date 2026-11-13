begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-sv-h-4.4-a-v3','apphysics1-mcq-b4-h-4.4-b','apphysics1-mcq-b4-sv-h-4.4-b-v1','apphysics1-mcq-b4-sv-h-4.4-b-v2','apphysics1-mcq-b4-sv-h-4.4-b-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apphysics1-mcq-b4-sv-h-4.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.4-a-v3', 'mcq', 'classify a collision from momentum and kinetic energy before and after, using numbers (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2 kg cart moving at +4 m/s collides with a 1 kg cart at rest on a frictionless track. A student''s data show that afterward the 2 kg cart moves at +1 m/s and the 1 kg cart moves at +6 m/s. The carts contain no springs or other stored energy. Which statement about these data is correct?', null, md5('apphysics1-mcq-b4-sv-h-4.4-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The collision was elastic, because the total momentum is the same before and after.', false, 'Momentum balances, but an elastic collision also needs equal kinetic energy. Here kinetic energy goes from 16 J to 19 J, so it is not conserved.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The data are impossible: momentum balances at 8 kg·m/s, but kinetic energy would rise from 16 J to 19 J.', true, 'Correct: Momentum: 2(4) = 8 = 2(1) + 1(6). Kinetic energy: before ½(2)(16) = 16 J; after ½(2)(1) + ½(1)(36) = 1 + 18 = 19 J. A gain of energy is impossible without an energy source.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The collision was inelastic, because the carts end with different speeds.', false, 'An inelastic collision loses kinetic energy. These data show a gain, from 16 J to 19 J, which would need an energy source.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The collision was perfectly inelastic, because the lighter cart ends up faster.', false, 'A perfectly inelastic collision has the carts moving together at the same velocity afterward and kinetic energy decreasing. Neither is true of these data.' from version_ins;
-- apphysics1-mcq-b4-h-4.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-h-4.4-b', 'mcq', 'compare an elastic collision with a perfectly inelastic one for the same incoming object, tracking momentum, kinetic ene', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart A (1 kg) moves at 4 m/s toward an identical stationary cart B (1 kg) on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?', null, md5('apphysics1-mcq-b4-h-4.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total momentum afterward is the same in both (4 kg·m/s), the kinetic energy afterward is 4 J in collision 1 and 8 J in collision 2, and cart B receives half as much impulse in collision 1.', true, 'Correct: Collision 1: v = 4/2 = 2 m/s, p = 4, KE = ½(2)(4) = 4 J, impulse on B = 1(2) = 2 N·s. Collision 2: A stops and B moves at 4 m/s, p = 4, KE = 8 J, impulse on B = 4 N·s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.', false, 'Total momentum is conserved in both collisions. Kinetic energy is lost when the carts stick, but the total momentum stays 4 kg·m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The kinetic energy afterward is the same in both collisions, because momentum is conserved in both.', false, 'Conserving momentum does not guarantee conserving kinetic energy. After sticking the energy is 4 J, while the elastic collision leaves 8 J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total momentum afterward is the same in both collisions and cart B receives the same impulse in both, because cart A starts with the same momentum.', false, 'The impulse on B equals its momentum gained. In collision 1 B ends at 2 m/s (impulse 2 N·s), and in collision 2 B ends at 4 m/s (impulse 4 N·s).' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.4-b-v1', 'mcq', 'compare an elastic collision with a perfectly inelastic one for the same incoming object, tracking momentum, kinetic ene (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart A (2 kg) moves at 3 m/s toward cart B (1 kg), which is at rest on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?', null, md5('apphysics1-mcq-b4-sv-h-4.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.', false, 'Momentum is conserved in both collisions, so the total is 6 kg·m/s either way. Only kinetic energy differs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The kinetic energy afterward is 9 J in both collisions, because momentum is conserved in both.', false, 'Kinetic energy is lost when the carts stick: after sticking the carts move at 2 m/s with 6 J, not 9 J.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The total momentum afterward is 6 kg·m/s in both and cart B receives the same impulse in both, because cart A starts with the same momentum.', false, 'The impulse on B equals its momentum gained. B ends at 2 m/s in collision 1 (2 N·s) and at 4 m/s in collision 2 (4 N·s).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total momentum afterward is 6 kg·m/s in both, the kinetic energy afterward is 6 J in collision 1 and 9 J in collision 2, and cart B receives half as much impulse in collision 1.', true, 'Correct: Collision 1: v = 6/3 = 2 m/s, KE = ½(3)(4) = 6 J, impulse on B = 1(2) = 2 N·s. Collision 2: v_A = 1 m/s, v_B = 4 m/s, KE = 1 + 8 = 9 J, impulse on B = 4 N·s.' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.4-b-v2', 'mcq', 'compare an elastic collision with a perfectly inelastic one for the same incoming object, tracking momentum, kinetic ene (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart A (1 kg) moves at 8 m/s toward cart B (3 kg), which is at rest on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?', null, md5('apphysics1-mcq-b4-sv-h-4.4-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total momentum afterward is 8 kg·m/s in both, the kinetic energy afterward is 8 J in collision 1 and 32 J in collision 2, and cart B receives half as much impulse in collision 1.', true, 'Correct: Collision 1: v = 8/4 = 2 m/s, KE = ½(4)(4) = 8 J, impulse on B = 3(2) = 6 N·s. Collision 2: v_A = −4 m/s, v_B = +4 m/s, KE = 8 + 24 = 32 J, impulse on B = 12 N·s.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.', false, 'Momentum is conserved in both collisions, so the total is 8 kg·m/s either way. Only kinetic energy differs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The kinetic energy afterward is 32 J in both collisions, because momentum is conserved in both.', false, 'Kinetic energy is lost when the carts stick: after sticking the carts move at 2 m/s with 8 J, not 32 J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total momentum afterward is 8 kg·m/s in both and cart B receives the same impulse in both, because cart A starts with the same momentum.', false, 'The impulse on B equals its momentum gained. B ends at 2 m/s in collision 1 (6 N·s) and at 4 m/s in collision 2 (12 N·s).' from version_ins;
-- apphysics1-mcq-b4-sv-h-4.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b4-sv-h-4.4-b-v3', 'mcq', 'compare an elastic collision with a perfectly inelastic one for the same incoming object, tracking momentum, kinetic ene (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cart A (3 kg) moves at 4 m/s toward cart B (1 kg), which is at rest on a frictionless track. In collision 1 the carts stick together. In collision 2 the same carts collide elastically. Which statement correctly compares the two collisions?', null, md5('apphysics1-mcq-b4-sv-h-4.4-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total momentum afterward is smaller in collision 1, because kinetic energy is lost there.', false, 'Momentum is conserved in both collisions, so the total is 12 kg·m/s either way. Only kinetic energy differs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The total momentum afterward is 12 kg·m/s in both, the kinetic energy afterward is 18 J in collision 1 and 24 J in collision 2, and cart B receives half as much impulse in collision 1.', true, 'Correct: Collision 1: v = 12/4 = 3 m/s, KE = ½(4)(9) = 18 J, impulse on B = 1(3) = 3 N·s. Collision 2: v_A = 2 m/s, v_B = 6 m/s, KE = 6 + 18 = 24 J, impulse on B = 6 N·s.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The kinetic energy afterward is 24 J in both collisions, because momentum is conserved in both.', false, 'Kinetic energy is lost when the carts stick: after sticking the carts move at 3 m/s with 18 J, not 24 J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total momentum afterward is 12 kg·m/s in both and cart B receives the same impulse in both, because cart A starts with the same momentum.', false, 'The impulse on B equals its momentum gained. B ends at 3 m/s in collision 1 (3 N·s) and at 6 m/s in collision 2 (6 N·s).' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b4-sv-h-4.4-a-v3','apphysics1-mcq-b4-h-4.4-b','apphysics1-mcq-b4-sv-h-4.4-b-v1','apphysics1-mcq-b4-sv-h-4.4-b-v2','apphysics1-mcq-b4-sv-h-4.4-b-v3']) and status='draft')<>5 then raise exception 'chunk 4: expected 5 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b4-sv-h-4.4-a-v3','apphysics1-mcq-b4-h-4.4-b','apphysics1-mcq-b4-sv-h-4.4-b-v1','apphysics1-mcq-b4-sv-h-4.4-b-v2','apphysics1-mcq-b4-sv-h-4.4-b-v3']))<>20 then raise exception 'chunk 4: expected 20 choices'; end if;
end $$;
commit;
