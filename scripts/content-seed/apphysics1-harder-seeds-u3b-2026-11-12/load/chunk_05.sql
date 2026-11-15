begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-h-3.5-b','apphysics1-mcq-b2-sv-h-3.5-b-v1','apphysics1-mcq-b2-sv-h-3.5-b-v2','apphysics1-mcq-b2-sv-h-3.5-b-v3'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apphysics1-mcq-b2-h-3.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.5-b', 'mcq', 'use P = Fv with the force component along the velocity, constant-power engines and instantaneous versus average power.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car''s engine delivers a constant 60 kW to the drive wheels. At 30 m/s, the total resistive force on the 1000 kg car is 1500 N. What is the car''s acceleration at that instant?', null, md5('apphysics1-mcq-b2-h-3.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.0 m/s²', false, '2.0 m/s² is F/m with the resistance ignored; the resistive force subtracts from the forward force.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.5 m/s²', false, '3.5 m/s² adds the resistive force to the forward force instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.50 m/s²', true, 'Correct: Forward force F = P/v = 60000/30 = 2000 N. Net force = 2000 − 1500 = 500 N, so a = 0.50 m/s².' from version_ins
union all select gen_random_uuid(), id, 'D', '4.5 m/s²', false, '4.5 m/s² uses the forward force found at 10 m/s (6000 N), not the smaller one at 30 m/s; constant power means force falls as speed rises.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.5-b-v1', 'mcq', 'use P = Fv with the force component along the velocity, constant-power engines and instantaneous versus average power. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg object at rest is pulled by a constant 6.0 N net force along a frictionless horizontal line for 4.0 s. What is the instantaneous power delivered by the force at t = 4.0 s?', null, md5('apphysics1-mcq-b2-sv-h-3.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24 W', false, '24 W multiplies the force by the time (6.0 × 4.0), which does not have units of power.' from version_ins
union all select gen_random_uuid(), id, 'B', '36 W', false, '36 W is the average power (F × average speed 6 m/s); the instantaneous power at the end is twice this.' from version_ins
union all select gen_random_uuid(), id, 'C', '144 W', false, '144 W equals the kinetic energy at 4.0 s (½·2·12²), which is work done, not a rate.' from version_ins
union all select gen_random_uuid(), id, 'D', '72 W', true, 'Correct: a = 3.0 m/s², v = 12 m/s at 4.0 s, P = Fv = 6.0 × 12 = 72 W. The average power over the interval is only 36 W.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.5-b-v2', 'mcq', 'use P = Fv with the force component along the velocity, constant-power engines and instantaneous versus average power. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force of 200 N is applied to a sled by a rope that makes a 60° angle with the horizontal path. The sled moves at constant speed 3.0 m/s. What power does the rope''s force deliver to the sled?', null, md5('apphysics1-mcq-b2-sv-h-3.5-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '600 W', false, '600 W ignores the angle and uses the full 200 N, but only the component along the motion transfers energy.' from version_ins
union all select gen_random_uuid(), id, 'B', '520 W', false, '520 W uses sin60° instead of cos60°, which is the component perpendicular to the motion.' from version_ins
union all select gen_random_uuid(), id, 'C', '100 W', false, '100 W comes from dividing 200 N × 3.0 m/s by 6 or by an angle value; the component along the motion is F cos60°, so the power is not 100 W.' from version_ins
union all select gen_random_uuid(), id, 'D', '300 W', true, 'Correct: P = Fv cosθ = 200 × 3.0 × 0.50 = 300 W.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.5-b-v3', 'mcq', 'use P = Fv with the force component along the velocity, constant-power engines and instantaneous versus average power. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car''s top speed on a level road is 40 m/s when its engine delivers 50 kW. At high speed the air-drag force is proportional to v². If the engine power is doubled to 100 kW, what is the new top speed, to the nearest 0.1 m/s?', null, md5('apphysics1-mcq-b2-sv-h-3.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '56.6 m/s', false, '56.6 m/s uses v ∝ √P, which would hold if drag were constant; with drag ∝ v², the power needed is proportional to v³.' from version_ins
union all select gen_random_uuid(), id, 'B', '50.4 m/s', true, 'Correct: At top speed engine power equals drag power: P = kv³. Doubling P multiplies v by 2^(1/3) = 1.26, giving 40 × 1.26 = 50.4 m/s.' from version_ins
union all select gen_random_uuid(), id, 'C', '63.5 m/s', false, '63.5 m/s corresponds to v ∝ P^(2/3), a wrong exponent from mixing the powers of v.' from version_ins
union all select gen_random_uuid(), id, 'D', '80.0 m/s', false, '80.0 m/s assumes speed is proportional to power; the drag grows with speed, so doubling power does not double the top speed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-h-3.5-b','apphysics1-mcq-b2-sv-h-3.5-b-v1','apphysics1-mcq-b2-sv-h-3.5-b-v2','apphysics1-mcq-b2-sv-h-3.5-b-v3']) and status='draft')<>4 then raise exception 'chunk 5: expected 4 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b2-h-3.5-b','apphysics1-mcq-b2-sv-h-3.5-b-v1','apphysics1-mcq-b2-sv-h-3.5-b-v2','apphysics1-mcq-b2-sv-h-3.5-b-v3']))<>16 then raise exception 'chunk 5: expected 16 choices'; end if;
end $$;
commit;
