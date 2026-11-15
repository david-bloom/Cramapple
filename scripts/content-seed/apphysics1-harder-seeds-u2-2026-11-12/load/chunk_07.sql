begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.7-b-v2','apphysics1-mcq-b5-sv-h-2.7-b-v3','apphysics1-mcq-b5-h-2.8-a','apphysics1-mcq-b5-sv-h-2.8-a-v1','apphysics1-mcq-b5-sv-h-2.8-a-v2','apphysics1-mcq-b5-sv-h-2.8-a-v3','apphysics1-mcq-b5-h-2.8-b','apphysics1-mcq-b5-sv-h-2.8-b-v1','apphysics1-mcq-b5-sv-h-2.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apphysics1-mcq-b5-sv-h-2.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.7-b-v2', 'mcq', 'use static friction as a supporting force: the normal force comes from the pushing force, not the weight, when a block i (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.5 kg book is held at rest between two vertical hands. Each hand squeezes with the same horizontal force F, and the static friction coefficient between each hand and the book is 0.30. What is the minimum F that keeps the book from slipping? Use g = 10 m/s².', null, md5('apphysics1-mcq-b5-sv-h-2.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50 N, because friction acts only on one side.', false, 'Friction acts at both surfaces, so the total upward friction can be 2 × 0.30 F. Using one side doubles the required force.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.5 N, because the maximum friction is 0.30 × 15 N.', false, 'The normal forces come from the hands'' squeeze F, not from the weight. The weight does not press the book against the hands.' from version_ins
union all select gen_random_uuid(), id, 'C', '15 N, because the squeeze must equal the weight.', false, 'The squeeze is horizontal and friction carries the vertical load. The condition is 2(0.30)F ≥ 15 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '25 N', true, 'Correct: Two friction forces share the load: 2 μ_s F ≥ mg gives F ≥ 15/0.60 = 25 N.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.7-b-v3', 'mcq', 'use static friction as a supporting force: the normal force comes from the pushing force, not the weight, when a block i (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg block is pushed against a rough vertical wall by a force F directed 37° above the horizontal, pointing toward the wall. The static friction coefficient is 0.50. What is the minimum F that keeps the block from sliding down? Use sin 37° = 0.60, cos 37° = 0.80 and g = 10 m/s².', null, md5('apphysics1-mcq-b5-sv-h-2.7-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '75 N, because only the friction force supports the block.', false, 'The upward component of F also supports the weight. Ignoring it overstates the required force.' from version_ins
union all select gen_random_uuid(), id, 'B', '50 N, because the upward component alone must support the weight.', false, 'The friction force also helps; the wall normal force 0.80 F gives friction up to 0.40 F. Both together must carry the weight.' from version_ins
union all select gen_random_uuid(), id, 'C', '60 N, because the push must equal the weight divided by the friction coefficient.', false, 'The normal force is the horizontal component of F, not F itself, and the vertical component helps too.' from version_ins
union all select gen_random_uuid(), id, 'D', '30 N', true, 'Correct: Normal force N = F cos 37° = 0.80 F. Vertical balance: F sin 37° + μ_s N = mg gives 0.60 F + 0.40 F = 30 N, so F = 30 N.' from version_ins;
-- apphysics1-mcq-b5-h-2.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.8-a', 'mcq', 'extract the spring constant and the natural length from two force-length readings, where the length is not the stretch', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spring is pulled by a horizontal force. When the force is 2.0 N the spring''s total length is 0.30 m, and when the force is 5.0 N its total length is 0.36 m. The spring obeys Hooke''s law. What are the spring constant and the natural (unstretched) length?', null, md5('apphysics1-mcq-b5-h-2.8-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 50 N/m; natural length 0.30 m, because the first reading is the unstretched length.', false, 'The spring is already stretched by the 2.0 N force at the first reading. Its stretch there is 2.0/50 = 0.04 m, so the natural length is 0.26 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 50 N/m; natural length 0.26 m', true, 'Correct: k = ΔF/ΔL = 3.0 N/0.06 m = 50 N/m. At 2.0 N the stretch is 2.0/50 = 0.04 m, so L₀ = 0.30 − 0.04 = 0.26 m.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 14 N/m; natural length 0.26 m, because k = F/L at the 5.0 N reading.', false, 'Hooke''s law uses the stretch, not the total length. The change in force over the change in length gives k = 3.0 N/0.06 m = 50 N/m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 7 N/m; natural length 0.30 m, because k = F/L at the first reading.', false, 'Dividing force by total length mixes the natural length with the stretch. The slope of force against length is the spring constant.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.8-a-v1', 'mcq', 'extract the spring constant and the natural length from two force-length readings, where the length is not the stretch (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spring is pulled by a horizontal force. When the force is 2.0 N the spring''s total length is 0.37 m, and when the force is 6.0 N its total length is 0.47 m. The spring obeys Hooke''s law. What are the spring constant and the natural (unstretched) length?', null, md5('apphysics1-mcq-b5-sv-h-2.8-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 40 N/m; natural length 0.37 m, because the first reading is the unstretched length.', false, 'The 2.0 N force already stretches the spring by 0.05 m, so the natural length is 0.32 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 13 N/m; natural length 0.32 m, because k = F/L at the 6.0 N reading.', false, 'The spring constant is the force change divided by the length change, 4.0 N/0.10 m = 40 N/m, not force over total length.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 5.4 N/m; natural length 0.37 m, because k = F/L at the first reading.', false, 'Force divided by total length does not give the spring constant. Use the change in force over the change in length.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 40 N/m; natural length 0.32 m', true, 'Correct: k = ΔF/ΔL = 4.0 N/0.10 m = 40 N/m. At 2.0 N the stretch is 0.050 m, so L₀ = 0.37 − 0.05 = 0.32 m.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.8-a-v2', 'mcq', 'extract the spring constant and the natural length from two force-length readings, where the length is not the stretch (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A light spring is stretched by a horizontal force. When the force is 5.0 N the spring''s total length is 0.45 m, and when the force is 20 N its total length is 0.60 m. The spring obeys Hooke''s law. What are the spring constant and the natural (unstretched) length?', null, md5('apphysics1-mcq-b5-sv-h-2.8-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 100 N/m; natural length 0.40 m', true, 'Correct: k = ΔF/ΔL = 15 N/0.15 m = 100 N/m. At 5.0 N the stretch is 0.050 m, so L₀ = 0.45 − 0.05 = 0.40 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 100 N/m; natural length 0.45 m, because the first reading is the unstretched length.', false, 'At 5.0 N the spring is stretched by 0.050 m already, so the natural length is 0.40 m.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 33 N/m; natural length 0.40 m, because k = F/L at the 20 N reading.', false, 'Hooke''s law uses stretch, not total length. ΔF/ΔL = 15 N/0.15 m = 100 N/m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 11 N/m; natural length 0.45 m, because k = F/L at the first reading.', false, 'Dividing the force by the total length does not give the spring constant. Use the slope of force against length.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.8-a-v3', 'mcq', 'extract the spring constant and the natural length from two force-length readings, where the length is not the stretch (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A light spring hangs from a hook. With a 0.20 kg mass attached, its total length is 0.38 m, and with a 0.60 kg mass attached, its total length is 0.54 m. The spring obeys Hooke''s law and g = 10 m/s². What are the spring constant and the natural (unstretched) length?', null, md5('apphysics1-mcq-b5-sv-h-2.8-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'k = 25 N/m; natural length 0.38 m, because the first reading is the unstretched length.', false, 'The 0.20 kg mass already stretches the spring by 2.0/25 = 0.08 m, so the natural length is 0.30 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'k = 11 N/m; natural length 0.30 m, because k = F/L at the 0.60 kg reading.', false, 'The spring constant comes from the change in force over the change in length: 4.0 N/0.16 m = 25 N/m, not force over total length.' from version_ins
union all select gen_random_uuid(), id, 'C', 'k = 25 N/m; natural length 0.30 m', true, 'Correct: k = ΔF/ΔL = 4.0 N/0.16 m = 25 N/m. At 2.0 N the stretch is 0.080 m, so L₀ = 0.38 − 0.08 = 0.30 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'k = 5.3 N/m; natural length 0.38 m, because k = F/L at the first reading.', false, 'Dividing the weight by the total length does not give k. The slope of force against length does.' from version_ins;
-- apphysics1-mcq-b5-h-2.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-h-2.8-b', 'mcq', 'combine springs: the same force passes through springs in series so their stretches add, while parallel springs share th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical light springs, each with k = 200 N/m, are joined end to end. The upper end is fixed to the ceiling and a 2.0 kg block hangs at rest from the lower end. Use g = 10 m/s². What is the total stretch of the two-spring chain?', null, md5('apphysics1-mcq-b5-h-2.8-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.20 m', true, 'Correct: Each spring carries the 20 N weight, so each stretches 20/200 = 0.10 m. Stretches add in series: 0.20 m (effective k = 100 N/m).' from version_ins
union all select gen_random_uuid(), id, 'B', '0.10 m, because the stretch of one spring is 20/200.', false, 'That is the stretch of one spring only. Both springs carry the full 20 N, so their stretches add to 0.20 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.050 m, because the two springs add to a total spring constant of 400 N/m.', false, 'Adding spring constants applies to springs side by side (parallel). End-to-end springs are softer, with an effective constant of 100 N/m.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.40 m, because each spring carries its own 20 N and another 20 N from the spring below.', false, 'The lower spring is light and adds no force. Each spring carries only the 20 N weight, so each stretches 0.10 m.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.8-b-v1', 'mcq', 'combine springs: the same force passes through springs in series so their stretches add, while parallel springs share th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two light springs with k = 100 N/m and k = 200 N/m hang side by side from the ceiling. Their lower ends are attached to the same light bar that supports a 3.0 kg block at rest, and both springs stretch by the same amount. Use g = 10 m/s². What is the stretch of the springs?', null, md5('apphysics1-mcq-b5-sv-h-2.8-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.10 m', true, 'Correct: Parallel springs have equal stretch and add their constants: k = 300 N/m, so x = 30/300 = 0.10 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.30 m, because the softer spring carries the whole weight.', false, 'Both springs stretch by the same amount and share the 30 N load, so neither carries all of it.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.15 m, because the stiffer spring carries the whole weight.', false, 'The softer spring also carries load. The total constant is 300 N/m, so the stretch is 30/300.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.45 m, because the stretches of the two springs add.', false, 'Stretches add for springs in series. Here the springs are side by side and share a single common stretch.' from version_ins;
-- apphysics1-mcq-b5-sv-h-2.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b5-sv-h-2.8-b-v2', 'mcq', 'combine springs: the same force passes through springs in series so their stretches add, while parallel springs share th (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two light springs with k = 300 N/m and k = 600 N/m are joined end to end. The upper end is fixed to the ceiling and a 6.0 kg block hangs at rest from the lower end. Use g = 10 m/s². What is the total stretch of the two-spring chain?', null, md5('apphysics1-mcq-b5-sv-h-2.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.067 m, because the springs add to a total constant of 900 N/m.', false, 'Adding the constants is correct only for parallel springs. In series each spring carries the full 60 N and the stretches add.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.30 m', true, 'Correct: Each spring carries the 60 N weight: x = 60/300 + 60/600 = 0.20 + 0.10 = 0.30 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.20 m, because only the softer spring stretches.', false, 'The stiffer spring also carries the full 60 N and stretches by 0.10 m. Both contribute.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.10 m, because the stiffer spring limits the stretch.', false, 'The stiffer spring adds 0.10 m, but the softer one adds 0.20 m. The total is the sum of both.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b5-sv-h-2.7-b-v2','apphysics1-mcq-b5-sv-h-2.7-b-v3','apphysics1-mcq-b5-h-2.8-a','apphysics1-mcq-b5-sv-h-2.8-a-v1','apphysics1-mcq-b5-sv-h-2.8-a-v2','apphysics1-mcq-b5-sv-h-2.8-a-v3','apphysics1-mcq-b5-h-2.8-b','apphysics1-mcq-b5-sv-h-2.8-b-v1','apphysics1-mcq-b5-sv-h-2.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b5-sv-h-2.7-b-v2','apphysics1-mcq-b5-sv-h-2.7-b-v3','apphysics1-mcq-b5-h-2.8-a','apphysics1-mcq-b5-sv-h-2.8-a-v1','apphysics1-mcq-b5-sv-h-2.8-a-v2','apphysics1-mcq-b5-sv-h-2.8-a-v3','apphysics1-mcq-b5-h-2.8-b','apphysics1-mcq-b5-sv-h-2.8-b-v1','apphysics1-mcq-b5-sv-h-2.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
