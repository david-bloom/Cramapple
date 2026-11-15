begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-sv-h-3.2-a-v1','apphysics1-mcq-b2-sv-h-3.2-a-v2','apphysics1-mcq-b2-sv-h-3.2-a-v3','apphysics1-mcq-b2-h-3.2-b','apphysics1-mcq-b2-sv-h-3.2-b-v1','apphysics1-mcq-b2-sv-h-3.2-b-v2','apphysics1-mcq-b2-sv-h-3.2-b-v3','apphysics1-mcq-b2-h-3.3-a','apphysics1-mcq-b2-sv-h-3.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apphysics1-mcq-b2-sv-h-3.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.2-a-v1', 'mcq', 'find the work done by an individual force when several forces act and the object moves at constant speed or along an inc (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 10 kg box is pushed 4.0 m up a rough incline of height 2.0 m by a force parallel to the incline, at constant speed. Friction on the box is 20 N. Use g = 10 m/s². How much work does the pushing force do?', null, md5('apphysics1-mcq-b2-sv-h-3.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '120 J', false, '120 J subtracts friction (50 − 20 = 30 N) when friction acts down the slope along with gravity''s component, so it adds.' from version_ins
union all select gen_random_uuid(), id, 'B', '200 J', false, '200 J is the increase in gravitational potential energy only; the push must also supply the energy lost to friction.' from version_ins
union all select gen_random_uuid(), id, 'C', '480 J', false, '480 J uses the full weight (100 N) as the force opposing the motion instead of its component along the slope.' from version_ins
union all select gen_random_uuid(), id, 'D', '280 J', true, 'Correct: Constant speed: F = mg sinθ + f = 50 + 20 = 70 N (mg sinθ = mg·h/L = 100·0.5). W = 70 × 4.0 = 280 J.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.2-a-v2', 'mcq', 'find the work done by an individual force when several forces act and the object moves at constant speed or along an inc (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg block slides 3.0 m down a 30° incline while a constant 4.0 N friction force acts up the slope. Use g = 10 m/s². What is the net work done on the block?', null, md5('apphysics1-mcq-b2-sv-h-3.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '30 J', false, '30 J counts gravity''s work alone and leaves out the negative work done by friction.' from version_ins
union all select gen_random_uuid(), id, 'B', '42 J', false, '42 J adds the magnitude of friction''s work instead of subtracting it; friction opposes the displacement.' from version_ins
union all select gen_random_uuid(), id, 'C', '40 J', false, '40 J uses the cosine of the angle (mg cos30° along the slope), which is the component perpendicular to the incline, not along it.' from version_ins
union all select gen_random_uuid(), id, 'D', '18 J', true, 'Correct: Gravity: mg sin30° × d = 20 × 0.5 × 3.0 = 30 J. Friction: −4.0 × 3.0 = −12 J. Normal force: 0. Net = 18 J.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.2-a-v3', 'mcq', 'find the work done by an individual force when several forces act and the object moves at constant speed or along an inc (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg object is raised 2.0 m by a cable while accelerating upward at 2.0 m/s². Use g = 10 m/s². How much work does the cable do on the object?', null, md5('apphysics1-mcq-b2-sv-h-3.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 J', false, '60 J is mg·h, the work if the object rose at constant speed; the upward acceleration requires extra tension.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 J', false, '12 J is the net work (ma × d), which is the work done by all forces together, not by the cable alone.' from version_ins
union all select gen_random_uuid(), id, 'C', '48 J', false, '48 J uses T = m(g − a), subtracting the acceleration as if the object were accelerating downward.' from version_ins
union all select gen_random_uuid(), id, 'D', '72 J', true, 'Correct: T − mg = ma gives T = 3.0(10 + 2.0) = 36 N, so W = 36 × 2.0 = 72 J.' from version_ins;
-- apphysics1-mcq-b2-h-3.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.2-b', 'mcq', 'compute work from a force that changes with position (area with sign) and connect it to a change in speed.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg object moves along the x axis with speed 3.0 m/s at x = 0. The net force on it is +6.0 N from x = 0 to 2.0 m, zero from 2.0 to 5.0 m, and −4.0 N from 5.0 m to 7.0 m. What is its speed at x = 7.0 m?', null, md5('apphysics1-mcq-b2-h-3.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.6 m/s', true, 'Correct: W = 6(2) + 0 + (−4)(2) = 4 J. K_f = ½(2)(9) + 4 = 13 J, so v = √13 = 3.6 m/s.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.0 m/s', false, '3.0 m/s would mean zero net work, which comes from ignoring the positive work of the first segment.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.6 m/s', false, '4.6 m/s uses only the +12 J of the first segment and ignores the negative work done in the last segment.' from version_ins
union all select gen_random_uuid(), id, 'D', '5.4 m/s', false, '5.4 m/s adds the magnitude of the negative work (12 + 8 = 20 J) instead of subtracting it.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.2-b-v1', 'mcq', 'compute work from a force that changes with position (area with sign) and connect it to a change in speed. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force along the x axis grows linearly from 0 at x = 0 to 12 N at x = 0.50 m, then stays at 12 N until x = 1.5 m. How much work does the force do from x = 0 to x = 1.5 m?', null, md5('apphysics1-mcq-b2-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 J', false, '12 J counts only the constant-force part and ignores the work done while the force was growing.' from version_ins
union all select gen_random_uuid(), id, 'B', '18 J', false, '18 J uses the maximum force (12 N) for the whole 1.5 m, overestimating the early part.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.0 J', false, '9.0 J uses the average of 0 and 12 N (6 N) over the whole 1.5 m, which only applies to the first segment.' from version_ins
union all select gen_random_uuid(), id, 'D', '15 J', true, 'Correct: Area: triangle ½(12)(0.50) = 3.0 J plus rectangle (12)(1.0) = 12 J gives 15 J.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.2-b-v2', 'mcq', 'compute work from a force that changes with position (area with sign) and connect it to a change in speed. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg object starts from rest at x = 0. The net force on it is +5.0 N from x = 0 to 4.0 m, then −10 N from x = 4.0 m to 6.0 m. At x = 6.0 m, its speed is', null, md5('apphysics1-mcq-b2-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.7 m/s', false, '3.7 m/s results from counting only the +20 J of the first segment and ignoring the −20 J in the second.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.2 m/s', false, '5.2 m/s results from adding the magnitudes of both segments (40 J) instead of using the sign of the second.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 m/s', true, 'Correct: W = 5(4) + (−10)(2) = 20 − 20 = 0 J. Net work is zero, so the object has the same kinetic energy as at the start: it is at rest.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.5 m/s', false, '4.5 m/s results from using 5.0 N over the entire 6.0 m (30 J), forgetting that the force reversed.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.2-b-v3', 'mcq', 'compute work from a force that changes with position (area with sign) and connect it to a change in speed. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 20 N force acts on an object while it moves 7.0 m along a line. For the first 2.0 m the force is parallel to the motion, for the next 2.0 m it is at 60° to the motion, and for the last 3.0 m it is perpendicular to the motion. What total work does the force do?', null, md5('apphysics1-mcq-b2-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 J', true, 'Correct: W = 20(2.0)cos0° + 20(2.0)cos60° + 20(3.0)cos90° = 40 + 20 + 0 = 60 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '75 J', false, '75 J uses sin60° instead of cos60° for the middle leg (about 34.6 J there), mixing up the component along the motion.' from version_ins
union all select gen_random_uuid(), id, 'C', '80 J', false, '80 J gives full force credit on the 60° leg (40 J there), ignoring the cosine.' from version_ins
union all select gen_random_uuid(), id, 'D', '140 J', false, '140 J multiplies the force by the whole distance and ignores the angles.' from version_ins;
-- apphysics1-mcq-b2-h-3.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-h-3.3-a', 'mcq', 'read force direction and motion from potential-energy data: force is the negative slope of U, and total energy limits th', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along the x axis in a conservative force field. Its potential energy decreases linearly from 12 J at x = 0 to 4 J at x = 2 m, stays at 4 J from x = 2 m to 3 m, then increases linearly to 10 J at x = 5 m. Which choice gives the force on the particle in the three intervals (0 to 2 m, 2 to 3 m, 3 to 5 m)?', null, md5('apphysics1-mcq-b2-h-3.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4 N, 0 N, +3 N', false, 'These signs are reversed; the force points toward lower potential energy, so it is +x where U decreases and −x where U increases.' from version_ins
union all select gen_random_uuid(), id, 'B', '+4 N, 0 N, −3 N', true, 'Correct: F = −ΔU/Δx: −(4 − 12)/2 = +4 N; −(0)/1 = 0; −(10 − 4)/2 = −3 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '+4 N, +4 N, −3 N', false, 'The force in the flat region is zero, not equal to the value of U; U itself does not set the force, only its slope does.' from version_ins
union all select gen_random_uuid(), id, 'D', '+8 N, 0 N, −6 N', false, 'These values use the total change in U across each interval instead of the change divided by the interval length.' from version_ins;
-- apphysics1-mcq-b2-sv-h-3.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphysics1-mcq-b2-sv-h-3.3-a-v1', 'mcq', 'read force direction and motion from potential-energy data: force is the negative slope of U, and total energy limits th (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A potential energy function is given by these values (in joules): U = 6.0 at x = 0, 1.5 at x = 1 m, 0 at x = 2 m, 1.5 at x = 3 m, and 6.0 at x = 4 m, with a smooth parabolic shape. A particle is released from rest at x = 1 m. Which description of its motion is correct?', null, md5('apphysics1-mcq-b2-sv-h-3.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It moves to x = 4 m and turns around, with maximum kinetic energy of 6.0 J.', false, 'U = 6.0 J at x = 4 m exceeds the particle''s total energy of 1.5 J, so it cannot reach x = 4 m.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It moves to x = 3 m and turns around, with maximum kinetic energy of 3.0 J at x = 2 m.', false, 'Maximum K equals the total energy minus the minimum U (1.5 J), not twice that value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It moves to x = 3 m and turns around, with maximum kinetic energy of 1.5 J at x = 2 m.', true, 'Correct: Total energy is 1.5 J, so the particle can reach any point with U ≤ 1.5 J, up to x = 3 m. Its K is largest where U is smallest (x = 2 m): K = 1.5 − 0 = 1.5 J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It moves to x = 2 m and stays there, because the force is zero at that position.', false, 'The force is zero at x = 2 m, but the particle arrives there with nonzero speed and keeps moving past it.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphysics1-mcq-b2-sv-h-3.2-a-v1','apphysics1-mcq-b2-sv-h-3.2-a-v2','apphysics1-mcq-b2-sv-h-3.2-a-v3','apphysics1-mcq-b2-h-3.2-b','apphysics1-mcq-b2-sv-h-3.2-b-v1','apphysics1-mcq-b2-sv-h-3.2-b-v2','apphysics1-mcq-b2-sv-h-3.2-b-v3','apphysics1-mcq-b2-h-3.3-a','apphysics1-mcq-b2-sv-h-3.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and ci.content_key = any (array['apphysics1-mcq-b2-sv-h-3.2-a-v1','apphysics1-mcq-b2-sv-h-3.2-a-v2','apphysics1-mcq-b2-sv-h-3.2-a-v3','apphysics1-mcq-b2-h-3.2-b','apphysics1-mcq-b2-sv-h-3.2-b-v1','apphysics1-mcq-b2-sv-h-3.2-b-v2','apphysics1-mcq-b2-sv-h-3.2-b-v3','apphysics1-mcq-b2-h-3.3-a','apphysics1-mcq-b2-sv-h-3.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
