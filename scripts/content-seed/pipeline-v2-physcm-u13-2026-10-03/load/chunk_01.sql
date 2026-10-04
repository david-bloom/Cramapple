begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-001-v1','apphycm-mcq-sv-001-v2','apphycm-mcq-sv-001-v3','apphycm-mcq-sv-002-v3','apphycm-mcq-sv-003-v1','apphycm-mcq-sv-003-v2','apphycm-mcq-sv-003-v3','apphycm-mcq-sv-006-v1','apphycm-mcq-sv-006-v2','apphycm-mcq-sv-006-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycm-mcq-sv-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-001-v1', 'mcq', 'Sled acceleration from a cubic velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sled slides down a snowy hill with velocity v(t) = 2t³ in SI units. What is its acceleration at t = 2.0 s?', null, md5('apphycm-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24 m/s²', true, 'The acceleration is the time derivative of the velocity: a = dv/dt = 6t². At t = 2.0 s, a = 6(2.0)² = 24 m/s².' from version_ins
union all select gen_random_uuid(), id, 'B', '16 m/s²', false, 'This is the numerical value of the velocity, v(2.0) = 2(2.0)³ = 16 m/s, so it would have units of m/s rather than m/s². Acceleration requires differentiating v(t) before substituting the time.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 m/s²', false, 'Differentiating 2t³ gives 6t², not 6t. Lowering the exponent by two instead of one produces 6(2.0) = 12, which is not dv/dt.' from version_ins
union all select gen_random_uuid(), id, 'D', '48 m/s²', false, 'Multiplying by the exponent without lowering it gives 6t³ = 6(2.0)³ = 48. The power rule also reduces the exponent by one, so dv/dt = 6t².' from version_ins;
-- apphycm-mcq-sv-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-001-v2', 'mcq', 'Cart acceleration from a quadratic velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cart''s velocity along a straight track is v(t) = 20 + 6t − t² in SI units. What is the cart''s acceleration at t = 4.0 s?', null, md5('apphycm-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+2.0 m/s²', false, '(v(4.0) − v(0))/4.0 = (28 − 20)/4.0 = +2.0 m/s² is the average acceleration over the first 4.0 s. Here the acceleration changes with time, so the instantaneous value at t = 4.0 s must come from dv/dt, which is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.0 m/s²', false, 'Differentiating only the 6t term gives 6. The −t² term contributes −2t, which is −8.0 m/s² at t = 4.0 s, so the full derivative is 6 − 8.0 = −2.0 m/s².' from version_ins
union all select gen_random_uuid(), id, 'C', '−2.0 m/s²', true, 'a = dv/dt = 6 − 2t. At t = 4.0 s, a = 6 − 8.0 = −2.0 m/s², so the cart is slowing down at that instant.' from version_ins
union all select gen_random_uuid(), id, 'D', '28 m/s²', false, 'This is the velocity, v(4.0) = 20 + 24 − 16 = 28 m/s, not the acceleration. Acceleration is the derivative of v(t).' from version_ins;
-- apphycm-mcq-sv-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-001-v3', 'mcq', 'Probe acceleration with symbolic constants', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A probe moves along a straight line with velocity v(t) = bt³ − ct, where b and c are positive constants. What is its acceleration at time t = T?', null, md5('apphycm-mcq-sv-001-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3bT² − c', true, 'a = dv/dt = 3bt² − c. Evaluating at t = T gives 3bT² − c.' from version_ins
union all select gen_random_uuid(), id, 'B', '3bT³ − c', false, 'The factor 3 is correct, but the exponent must drop by one: d(bt³)/dt = 3bt², so the first term is 3bT², not 3bT³.' from version_ins
union all select gen_random_uuid(), id, 'C', 'bT² − c', false, 'Differentiating bt³ gives 3bt², not bt². Dropping the exponent multiplier loses the factor of 3.' from version_ins
union all select gen_random_uuid(), id, 'D', '3bT² − cT', false, 'The derivative of ct with respect to t is the constant c. Keeping the factor t, as in −cT, means the linear term was not differentiated.' from version_ins;
-- apphycm-mcq-sv-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-002-v3', 'mcq', 'Distance traveled until the puck stops', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A puck slides along the x-axis starting from x = 0 at t = 0, with velocity v(t) = 12 − 3t² in SI units. How far from its starting point is the puck when it first comes momentarily to rest?', null, md5('apphycm-mcq-sv-002-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24 m', false, '12 m/s × 2.0 s = 24 m treats the initial speed as constant. The speed drops as t² grows, so the puck covers less distance, 24 − 8 = 16 m.' from version_ins
union all select gen_random_uuid(), id, 'B', '16 m', true, 'The puck is at rest when 12 − 3t² = 0, so t = 2.0 s. Then x = ∫₀² (12 − 3t²) dt = [12t − t³] from 0 to 2.0 = 24 − 8 = 16 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 m', false, 'Integrating −3t² to −3t³ instead of −t³ leaves out the division by 3 and gives 24 − 24 = 0 m. The correct integral of −3t² is −t³, so the puck has moved 24 − 8 = 16 m.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 m', false, 'Integrating −3t² gives −t³, not −3t³/2. A wrong power-rule denominator produces 24 − 12 = 12 m instead of 24 − 8 = 16 m.' from version_ins;
-- apphycm-mcq-sv-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-003-v1', 'mcq', 'Work by a force that grows with position', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A variable force F(x) = 4.0x, with F in newtons and x in meters, acts on a block along a straight line. How much work does this force do as the block moves from x = 0 to x = 3.0 m?', null, md5('apphycm-mcq-sv-003-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '36 J', false, 'F(3.0) × 3.0 m = 36 J treats the force as constant at its largest value. The force grows from zero, so the integral picks up a factor 1/2 and gives 18 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 J', false, 'This is the force at the endpoint, F(3.0) = 12 N. Work is the integral of force over the displacement, not the force value.' from version_ins
union all select gen_random_uuid(), id, 'C', '18 J', true, 'W = ∫₀³ 4.0x dx = 2.0x² evaluated from 0 to 3.0 m = 18 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.0 J', false, '½(4.0)(3.0) = 6.0 uses the slope 4.0 N/m as if it were the height of the force triangle. The height is F(3.0) = 12 N, so the area is ½(12)(3.0) = 18 J.' from version_ins;
-- apphycm-mcq-sv-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-003-v2', 'mcq', 'Work by a quadratic force over a later interval', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force F(x) = 3.0x², with F in newtons and x in meters, acts along a line. How much work does it do as an object moves from x = 1.0 m to x = 2.0 m?', null, md5('apphycm-mcq-sv-003-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.0 J', true, 'W = ∫₁² 3.0x² dx = [x³] from 1.0 to 2.0 m = 8.0 − 1.0 = 7.0 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 J', false, 'This is the work from x = 0 to x = 2.0 m. The integral must start at x = 1.0 m, so x³ at the lower limit (1.0 J) is subtracted.' from version_ins
union all select gen_random_uuid(), id, 'C', '10.5 J', false, 'Integrating 3.0x² gives x³, not 1.5x³. Using a denominator of 2 instead of 3 gives 1.5 × (8.0 − 1.0) = 10.5 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 J', false, 'F(2.0) × 1.0 m = 12 J treats the force as constant at its endpoint value over the 1.0 m interval. The force rises from 3.0 N to 12 N, so the integral must be used.' from version_ins;
-- apphycm-mcq-sv-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-003-v3', 'mcq', 'Net work when the force changes sign', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A force F(x) = 12 − 3.0x, with F in newtons and x in meters, acts along the x-axis on an object that moves from x = 0 to x = 6.0 m. How much net work does this force do on the object?', null, md5('apphycm-mcq-sv-003-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24 J', false, 'This is the work from x = 0 to x = 4.0 m, where the force is positive. Beyond x = 4.0 m the force points the other way and removes 6 J, so the net is 24 − 6 = 18 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '72 J', false, '12 N × 6.0 m uses the initial force as if it stayed constant. The force falls to −6 N at x = 6.0 m, so the integral must be used and gives 18 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '30 J', false, 'Adding the sizes of the two regions, 24 J + 6 J, treats the work beyond x = 4.0 m as positive. The force there is opposite the displacement, so that region subtracts 6 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '18 J', true, 'W = ∫₀⁶ (12 − 3.0x) dx = [12x − 1.5x²] from 0 to 6.0 m = 72 − 54 = 18 J. The force reverses direction at x = 4.0 m, and the integral counts that later region as negative work.' from version_ins;
-- apphycm-mcq-sv-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-006-v1', 'mcq', 'Force on a bead from a quadratic potential energy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bead slides along a wire (the x-axis) with potential energy U(x) = 5.0x², where U is in joules and x is in meters. What is the force on the bead at x = 2.0 m?', null, md5('apphycm-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−10 N', false, 'U(2.0) = 20 J, so −U/x = −10 N, but this divides U by x instead of differentiating. The same value also results from dropping the exponent multiplier (differentiating 5.0x² to 5.0x). The correct derivative is 10x, giving −20 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '−20 N', true, 'F = −dU/dx = −10x. At x = 2.0 m, F = −20 N, pointing back toward the origin.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4.0 N', false, 'Differentiating x² to 2x and then leaving out the coefficient 5.0 gives −2x = −4.0 N. The coefficient multiplies the derivative: dU/dx = 5.0 × 2x = 10x.' from version_ins
union all select gen_random_uuid(), id, 'D', '−40 N', false, 'Multiplying by the exponent without lowering it gives −10x² = −40 N. The power rule also reduces the exponent by one, so dU/dx = 10x.' from version_ins;
-- apphycm-mcq-sv-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-006-v2', 'mcq', 'Force from a quartic potential energy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A bead on a straight wire has potential energy U(x) = x⁴ − 4x in SI units. At x = 2.0 m, the force on the bead along the wire is', null, md5('apphycm-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−28 N', true, 'F = −dU/dx = −(4x³ − 4). At x = 2.0 m, F = −(32 − 4) = −28 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4.0 N', false, '−U/x = −(16 − 8)/2.0 = −4.0 N divides the potential energy by x instead of taking the derivative. The two agree only when U is proportional to x.' from version_ins
union all select gen_random_uuid(), id, 'C', '−60 N', false, 'Differentiating x⁴ gives 4x³, not 4x⁴. With the exponent not lowered, −(4x⁴ − 4) = −(64 − 4) = −60 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '+28 N', false, 'The magnitude is right, but the force is the negative of the slope. The slope dU/dx is +28 J/m here, so F = −28 N, directed toward smaller x.' from version_ins;
-- apphycm-mcq-sv-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-006-v3', 'mcq', 'Force from an inverse-distance potential energy', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle moves along a radial line under a conservative force with potential energy U(r) = −A/r, where A is a positive constant and r > 0 is the distance from the origin. What are the magnitude and direction of the force on the particle?', null, md5('apphycm-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A/r², toward the origin', true, 'F_r = −dU/dr = −d(−A r⁻¹)/dr = −A/r². The radial component is negative, so the force has magnitude A/r² and points toward the origin.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Zero, because U is negative', false, 'The sign of U does not set the force; the slope does. Here dU/dr = A/r² is nonzero everywhere, so the force is nonzero everywhere.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A/r, toward the origin', false, 'Differentiating r⁻¹ gives −r⁻², not −r⁻¹. Keeping the exponent unchanged gives a 1/r force, which is not the derivative of the 1/r potential.' from version_ins
union all select gen_random_uuid(), id, 'D', '2A/r³, toward the origin', false, 'This is the magnitude of the second derivative, d²U/dr². The force is the first derivative of U with respect to r, with a minus sign.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-001-v1','apphycm-mcq-sv-001-v2','apphycm-mcq-sv-001-v3','apphycm-mcq-sv-002-v3','apphycm-mcq-sv-003-v1','apphycm-mcq-sv-003-v2','apphycm-mcq-sv-003-v3','apphycm-mcq-sv-006-v1','apphycm-mcq-sv-006-v2','apphycm-mcq-sv-006-v3']) and status='draft')<>10 then raise exception 'chunk 1: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-sv-001-v1','apphycm-mcq-sv-001-v2','apphycm-mcq-sv-001-v3','apphycm-mcq-sv-002-v3','apphycm-mcq-sv-003-v1','apphycm-mcq-sv-003-v2','apphycm-mcq-sv-003-v3','apphycm-mcq-sv-006-v1','apphycm-mcq-sv-006-v2','apphycm-mcq-sv-006-v3']))<>40 then raise exception 'chunk 1: choice rows'; end if;
end $$;
commit;
