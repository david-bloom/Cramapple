begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and content_key = any (array['apphy1-mcq-sv-005-v2','apphy1-mcq-sv-005-v3','apphy1-mcq-sv-006-v1','apphy1-mcq-sv-006-v2','apphy1-mcq-sv-006-v3','apphy1-mcq-sv-007-v1','apphy1-mcq-sv-007-v2','apphy1-mcq-sv-007-v3','apphy1-mcq-sv-008-v1','apphy1-mcq-sv-008-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy1-mcq-sv-005-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-005-v2', 'mcq', 'Box pushed up ramp', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A worker pushes a box up a rough ramp at constant speed, using a force directed parallel to the ramp surface. Friction acts down the ramp. How does the magnitude of the worker''s push compare with the magnitude of the component of the box''s weight directed down the ramp?', null, md5('apphy1-mcq-sv-005-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The push equals the friction force, because both act along the ramp.', false, 'Equating push and friction ignores the weight component down the ramp. All three forces along the ramp balance: push = weight component + friction, so the push exceeds the friction force.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The push equals the weight component, because the box moves at constant speed.', false, 'This would be true only if friction were zero. Constant speed makes the net force zero, but friction also acts down the ramp, so the push must equal the weight component plus friction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The push is less than the weight component, because the box is moving up the ramp.', false, 'Assumes that motion up the ramp means the push can be smaller. With zero net force the push must be at least as large as the weight component, and with friction present it is larger.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The push is greater than the weight component, because it must also balance friction.', true, 'At constant velocity the net force along the ramp is zero. The push up the ramp balances both the weight component down the ramp and the friction down the ramp, so push = weight component + friction, which is greater than the weight component.' from version_ins;
-- apphy1-mcq-sv-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-005-v3', 'mcq', 'Car at constant velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A car travels at constant velocity along a straight, level highway. The engine causes the road to exert a forward force of 900 N on the car through the driven wheels. What is the total backward resistive force (air resistance plus rolling resistance) on the car?', null, md5('apphy1-mcq-sv-005-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '900 N', true, 'Constant velocity means zero net force, so the total backward resistive force equals the 900 N forward force.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 N', false, 'Assumes no resistance acts because the speed is constant. Resistive forces are present; it is the net force that is zero, because the 900 N forward force balances them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'less than 900 N', false, 'Assumes the forward force must exceed resistance to keep the car moving. A forward force larger than resistance would give a nonzero net force and an acceleration, not constant velocity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'more than 900 N', false, 'Assumes that the car needs an extra margin of backward force to explain why it is not speeding up. If resistance exceeded 900 N the net force would be backward and the car would slow down.' from version_ins;
-- apphy1-mcq-sv-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-006-v1', 'mcq', 'Crate push work', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A worker pushes a crate across a warehouse floor with a constant 25 N horizontal force in the direction of the crate''s motion. The crate moves 6.0 m. How much work does the worker do on the crate?', null, md5('apphy1-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '150 J', true, 'Work by a constant force along the displacement is W = Fd cos 0° = 25 × 6.0 = 150 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.2 J', false, 'Divides force by distance, 25/6.0 ≈ 4.2. Work is the product Fd, not a quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '31 J', false, 'Adds force and distance: 25 + 6.0 = 31. Work is the product of force and displacement along the force, not their sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '1500 J', false, 'Multiplies the correct product (150) by an extra factor of 10, as if g = 10 needed to be included. Work done by a horizontal push does not involve g: W = 25 × 6.0 = 150 J.' from version_ins;
-- apphy1-mcq-sv-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-006-v2', 'mcq', 'Angled pull work', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A child pulls a wagon 4.0 m along level ground with a constant 20 N force directed 60° above the horizontal. How much work does the child''s pull do on the wagon?', null, md5('apphy1-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '80 J', false, 'Multiplies the full force by the full distance, 20 × 4.0 = 80 J, ignoring the angle. Only the component F cos 60° = 10 N is along the motion.' from version_ins
union all select gen_random_uuid(), id, 'B', '40 J', true, 'Only the component of force along the displacement does work: W = Fd cos 60° = 20 × 4.0 × 0.50 = 40 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '24 J', false, 'Adds the quantities, 20 + 4.0 = 24. Work is the product of force component and displacement, not a sum.' from version_ins
union all select gen_random_uuid(), id, 'D', '69 J', false, 'Uses sin 60° instead of cos 60°: 20 × 4.0 × 0.866 = 69 J. That uses the vertical component of the force (F sin 60°), which is perpendicular to the displacement and does no work.' from version_ins;
-- apphy1-mcq-sv-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-006-v3', 'mcq', 'Friction work sign', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 15 N constant friction force acts on a box sliding 3.0 m across a floor, opposite to the box''s motion. How much work does friction do on the box?', null, md5('apphy1-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−18 J', false, 'Adds force and distance, 15 + 3.0 = 18, and applies the negative sign. Work is the product Fd cos 180° = −45 J, not a sum.' from version_ins
union all select gen_random_uuid(), id, 'B', '−5.0 J', false, 'Divides force by distance, 15/3.0 = 5.0, and applies the negative sign. Work is the product Fd cos 180° = −45 J, not a quotient.' from version_ins
union all select gen_random_uuid(), id, 'C', '+45 J', false, 'Gets the size right (15 × 3.0 = 45) but ignores that friction points opposite the motion, which makes the work negative (cos 180° = −1).' from version_ins
union all select gen_random_uuid(), id, 'D', '−45 J', true, 'The friction force is opposite the displacement, so W = Fd cos 180° = 15 × 3.0 × (−1) = −45 J.' from version_ins;
-- apphy1-mcq-sv-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-007-v1', 'mcq', 'Tripled speed kinetic energy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cyclist increases her speed from 4 m/s to 12 m/s with no change in mass. Her kinetic energy becomes', null, md5('apphy1-mcq-sv-007-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'nine times as large', true, 'Since K = ½mv², K is proportional to v². Tripling the speed multiplies K by 3² = 9.' from version_ins
union all select gen_random_uuid(), id, 'B', 'twenty-seven times as large', false, 'Cubes the speed ratio, 3³ = 27. The exponent in K = ½mv² is 2, not 3, so the factor is 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'three times as large', false, 'Treats K as proportional to v, as if tripling the speed triples K. K = ½mv² depends on the square of the speed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'six times as large', false, 'Multiplies the speed ratio by the exponent, 3 × 2 = 6, instead of raising the ratio to the second power, 3² = 9.' from version_ins;
-- apphy1-mcq-sv-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-007-v2', 'mcq', 'Halved speed kinetic energy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A runner slows from 8.0 m/s to 4.0 m/s. By what factor does the runner''s kinetic energy change?', null, md5('apphy1-mcq-sv-007-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It becomes one-sixteenth as large.', false, 'Raises the speed ratio to the fourth power, (½)⁴ = 1/16. The exponent in K = ½mv² is 2, so the factor is (½)² = ¼.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It becomes one-half as large.', false, 'Treats K as directly proportional to speed, so halving v halves K. K depends on v², so the factor is ¼.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It becomes one-eighth as large.', false, 'Cubes the speed ratio, (½)³ = ⅛. The exponent in K = ½mv² is 2, so the factor is (½)² = ¼.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It becomes one-fourth as large.', true, 'K = ½mv² is proportional to v². Halving the speed multiplies K by (½)² = ¼.' from version_ins;
-- apphy1-mcq-sv-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-007-v3', 'mcq', 'Car kinetic energy calculation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1200 kg car traveling at 10 m/s has a kinetic energy of 60,000 J. The car speeds up to 15 m/s. What is its new kinetic energy?', null, md5('apphy1-mcq-sv-007-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '75,000 J', false, 'Adds ½m(Δv)² to the old energy: 60,000 + ½ × 1200 × 5² = 60,000 + 15,000 = 75,000 J. The change in K is ½m(v² − v₀²) = ½m(225 − 100), not ½m(Δv)².' from version_ins
union all select gen_random_uuid(), id, 'B', '135,000 J', true, 'K = ½mv² = ½ × 1200 × (15)² = 600 × 225 = 135,000 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '90,000 J', false, 'Scales K by the speed ratio, 60,000 × 1.5 = 90,000 J. K is proportional to v², so the factor is 1.5² = 2.25.' from version_ins
union all select gen_random_uuid(), id, 'D', '202,500 J', false, 'Scales K by the cube of the speed ratio, 60,000 × 1.5³ = 202,500 J. K depends on v², so the factor is 2.25.' from version_ins;
-- apphy1-mcq-sv-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-008-v1', 'mcq', 'Flowerpot potential energy loss', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg flowerpot falls 4.0 m from a balcony railing to the patio. Use g = 10 m/s². The decrease in the pot''s gravitational potential energy is', null, md5('apphy1-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 J', false, 'Drops g and multiplies mass and height only: 3.0 × 4.0 = 12 J. The weight mg = 30 N must be multiplied by the height.' from version_ins
union all select gen_random_uuid(), id, 'B', '40 J', false, 'Drops the mass and multiplies g by the height: 10 × 4.0 = 40 J. The energy change is proportional to the mass.' from version_ins
union all select gen_random_uuid(), id, 'C', '30 J', false, 'Computes only the weight, mg = 3.0 × 10 = 30 N, and forgets to multiply by the 4.0 m height.' from version_ins
union all select gen_random_uuid(), id, 'D', '120 J', true, 'The decrease in U_g is mgΔh = 3.0 × 10 × 4.0 = 120 J.' from version_ins;
-- apphy1-mcq-sv-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '29c719dc-701b-470f-9e49-fab981722d3f', 'apphy1-mcq-sv-008-v2', 'mcq', 'Climber potential energy gain', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 60 kg climber ascends a cliff face, gaining 15 m in height. Use g = 10 m/s². The increase in the climber''s gravitational potential energy is', null, md5('apphy1-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '150 J', false, 'Leaves out the mass and multiplies only g by the height: 10 × 15 = 150. That is not the climber''s energy change, which is proportional to the 60 kg mass.' from version_ins
union all select gen_random_uuid(), id, 'B', '9000 J', true, 'ΔU_g = mgΔh = 60 × 10 × 15 = 9000 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '900 J', false, 'Multiplies only mass and height, 60 × 15 = 900, and leaves out g. The energy change needs the weight mg times the height gained.' from version_ins
union all select gen_random_uuid(), id, 'D', '600 J', false, 'Computes only the weight, mg = 60 × 10 = 600 N, and does not multiply by the 15 m of height gained.' from version_ins;
commit;
