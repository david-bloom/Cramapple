begin;
select pg_advisory_xact_lock(hashtext('cramapple-heldfour-variants-load-20261004'));
do $$ begin
  if exists (select 1 from app.content_items ci join (values ('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v1'),('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v2'),('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v3'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v1'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v2'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v3'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v1'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v2'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v3')) p(pack,k) on ci.exam_pack_version_id=p.pack and ci.content_key=p.k) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-003-v1', 'mcq', 'Closed cube in a uniform field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A closed cube with 0.20 m edges contains no charge. It sits in a uniform external electric field of 300 N/C directed perpendicular to two of its faces. What is the net electric flux through the entire surface of the cube?', null, md5('apphycem-mcq-sv-003-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 N·m²/C', false, 'This is the flux magnitude through one face, EA = (300)(0.040) = 12 N·m²/C. The entering face contributes −12 and the leaving face contributes +12, so the net flux is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 N·m²/C', true, 'Gauss''s law gives Φ = Q_enc/ε₀ = 0 because the cube encloses no charge. Directly: the field enters one face with flux −EA = −12 N·m²/C, leaves the opposite face with +12 N·m²/C, and gives zero flux through the four faces parallel to the field.' from version_ins
union all select gen_random_uuid(), id, 'C', '72 N·m²/C', false, 'This treats every one of the six faces as having flux EA. The four faces parallel to the field have zero flux, and the other two cancel, so the net flux is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '24 N·m²/C', false, 'This adds the magnitudes of the entering and leaving fluxes. Flux is signed: the entering flux is negative and the leaving flux is positive, so they cancel to 0.' from version_ins;
-- apphycem-mcq-sv-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-003-v2', 'mcq', 'Dipole inside, charge outside', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A closed surface encloses a +4.0 nC charge and a −4.0 nC charge. A separate +6.0 nC charge sits outside the surface. What is the net electric flux through the surface?', null, md5('apphycem-mcq-sv-003-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9.0 × 10² N·m²/C', false, 'This is (8.0 nC)/ε₀, which adds the magnitudes of the two enclosed charges. Charge is signed, so Q_enc = 0 and the flux is 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 N·m²/C', true, 'Only enclosed charge matters in Gauss''s law: Q_enc = +4.0 nC − 4.0 nC = 0, so Φ = 0. The outside charge produces field lines that enter and leave the surface with no net flux.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.5 × 10² N·m²/C', false, 'This is (4.0 nC)/ε₀, which counts only the enclosed positive charge. The enclosed −4.0 nC cancels it, so Q_enc = 0 and the flux is 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.8 × 10² N·m²/C', false, 'This is (6.0 nC)/ε₀, which counts the outside charge. Charge outside a closed surface contributes zero net flux, and the enclosed charges sum to zero, so the flux is 0.' from version_ins;
-- apphycem-mcq-sv-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-003-v3', 'mcq', 'Gaussian sphere inside a charged shell', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A thin, uniformly charged spherical shell of radius 0.20 m carries a total charge of +12 nC. A concentric spherical Gaussian surface of radius 0.10 m lies entirely inside the shell. What is the net electric flux through the Gaussian surface?', null, md5('apphycem-mcq-sv-003-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 N·m²/C', true, 'The Gaussian sphere lies inside the shell and encloses no charge, because all of the charge sits on the shell''s surface. Gauss''s law gives Φ = Q_enc/ε₀ = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.4 × 10³ N·m²/C', false, 'This is (12 nC)/ε₀, the flux through a surface that encloses the whole shell. The smaller sphere is inside the shell and encloses none of its charge.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.4 × 10² N·m²/C', false, 'This scales the total charge by the area ratio (0.10/0.20)² = 1/4, as if part of the shell''s charge were inside the smaller sphere. None of the charge lies inside it, so Q_enc = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.7 × 10² N·m²/C', false, 'This scales the total charge by the volume ratio (0.10/0.20)³ = 1/8, as if the charge were spread through the volume. The charge is on the shell''s surface, so Q_enc = 0.' from version_ins;
-- apphycm-mcq-sv-031-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-031-v1', 'mcq', 'Net force from a linear velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 3.0 kg cart of constant mass moves along a straight track with velocity v(t) = (4.0 m/s²)t + 1.0 m/s, where t is in seconds. What is the magnitude of the net force on the cart at t = 2.0 s?', null, md5('apphycm-mcq-sv-031-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13.5 N', false, 'This is m v/t = (3.0)(9.0)/(2.0), which divides the velocity by the elapsed time. Net force is mass times the derivative dv/dt = 4.0 m/s², giving 12 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '27 N', false, 'This multiplies mass by the velocity at t = 2.0 s, (3.0)(9.0). Net force is mass times the rate of change of velocity, which is 12 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 N', true, 'For constant mass, F_net = m dv/dt. Here dv/dt = 4.0 m/s², so F_net = (3.0)(4.0) = 12 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.0 N', false, 'This is the numerical value of dv/dt with the mass left out. Net force is m dv/dt = (3.0)(4.0) = 12 N.' from version_ins;
-- apphycm-mcq-sv-031-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-031-v2', 'mcq', 'Net force from a cubic velocity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.5 kg block of constant mass moves along a line with velocity v(t) = (2.0 m/s⁴)t³ − (3.0 m/s²)t, where t is in seconds. What is the magnitude of the net force on the block at t = 2.0 s?', null, md5('apphycm-mcq-sv-031-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.0 N', false, 'This integrates the velocity from 0 to 2.0 s, giving a displacement of 2.0 m, and multiplies by the mass. Net force comes from differentiating, not integrating: m dv/dt = 31.5 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '15 N', false, 'This multiplies mass by the velocity at t = 2.0 s, (1.5)(10). Net force is mass times the derivative of velocity, which gives 31.5 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '7.5 N', false, 'This is m v/t = (1.5)(10)/(2.0), which uses the average rate v/t from the start. Net force requires the instantaneous derivative dv/dt = 21 m/s², giving 31.5 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '31.5 N', true, 'For constant mass, F_net = m dv/dt. dv/dt = 6.0t² − 3.0 = 21 m/s² at t = 2.0 s, so F_net = (1.5)(21) = 31.5 N.' from version_ins;
-- apphycm-mcq-sv-031-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-031-v3', 'mcq', 'Net force from a position function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg object of constant mass moves along the x-axis with position x(t) = (0.50 m/s⁴)t⁴ − (2.0 m/s)t, where t is in seconds. What is the magnitude of the net force on the object at t = 1.5 s?', null, md5('apphycm-mcq-sv-031-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '13.5 N', false, 'This is the acceleration at t = 1.5 s with the mass left out. Net force is m dv/dt = (2.0)(13.5) = 27 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.5 N', false, 'This is m v at t = 1.5 s, (2.0)(4.75), which takes one derivative of position and treats velocity as acceleration. Net force needs the second derivative of position: 27 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '27 N', true, 'Velocity is v = dx/dt = 2.0t³ − 2.0. Acceleration is a = dv/dt = 6.0t² = 13.5 m/s² at t = 1.5 s. For constant mass, F_net = m dv/dt = (2.0)(13.5) = 27 N.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.0 N', false, 'This is the mass times the average acceleration from t = 0 to 1.5 s, (2.0)(6.75/1.5). The acceleration is not constant, so the instantaneous value dv/dt = 13.5 m/s² is needed, giving 27 N.' from version_ins;
-- apphy2-mcq-sv-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-001-v1', 'mcq', 'Heating a rigid sealed container', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid sealed container holds an ideal gas at 27°C and a pressure of 1.0 × 10⁵ Pa. The gas is heated to 177°C. What is its final pressure?', null, md5('apphy2-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.5 × 10⁵ Pa', true, 'At fixed volume and amount, PV = nRT gives P proportional to the absolute temperature. The temperatures are 300 K and 450 K, so P = (1.0 × 10⁵)(450/300) = 1.5 × 10⁵ Pa.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.7 × 10⁴ Pa', false, 'This inverts the ratio, 300/450. At fixed volume, pressure increases with temperature, so P = 1.5 × 10⁵ Pa.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.0 × 10⁵ Pa', false, 'This assumes the pressure stays the same because the volume is fixed. With volume and amount fixed, P is proportional to T, so heating raises the pressure to 1.5 × 10⁵ Pa.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.6 × 10⁵ Pa', false, 'This uses the ratio of Celsius temperatures, 177/27. Pressure is proportional to the Kelvin temperature, so the ratio is 450/300 and P = 1.5 × 10⁵ Pa.' from version_ins;
-- apphy2-mcq-sv-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-001-v2', 'mcq', 'Extrapolating a pressure-temperature line', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid vessel holds a fixed amount of ideal gas. Its pressure is 120 kPa at 27°C and 160 kPa at 127°C, and the graph of pressure versus Celsius temperature is a straight line. The line is extended down to zero pressure. At what Celsius temperature does it reach zero pressure?', null, md5('apphy2-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−300°C', false, 'This divides 120 kPa by the slope of 0.40 kPa/°C and measures the result from 0°C. The 300°C drop must be measured from the 27°C starting point, giving −273°C.' from version_ins
union all select gen_random_uuid(), id, 'B', '−73°C', false, 'This extends the line by one more 100°C measurement interval below 27°C. The line continues until the pressure is zero, which takes a 300°C drop from 27°C, reaching −273°C.' from version_ins
union all select gen_random_uuid(), id, 'C', '0°C', false, 'This assumes the pressure vanishes at the freezing point of water. Pressure is proportional to the Kelvin temperature, so it reaches zero at 0 K, which is −273°C.' from version_ins
union all select gen_random_uuid(), id, 'D', '−273°C', true, 'At fixed volume P is proportional to the Kelvin temperature, so P = 0 at 0 K, which is −273°C. The data agree: 120 kPa at 300 K and 160 kPa at 400 K give 0.40 kPa per kelvin, and 120/0.40 = 300 K below 27°C is −273°C.' from version_ins;
-- apphy2-mcq-sv-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-001-v3', 'mcq', 'Tripling the pressure of a sealed gas', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid sealed tank holds an ideal gas at 27°C. To what Celsius temperature must the gas be heated so that its pressure becomes three times its initial value?', null, md5('apphy2-mcq-sv-001-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9°C', false, 'This divides the Celsius temperature by 3, treating pressure as inversely related to temperature. Pressure rises with temperature at fixed volume, so T must triple to 900 K, which is 627°C.' from version_ins
union all select gen_random_uuid(), id, 'B', '900°C', false, 'This triples the Kelvin temperature correctly to 900 K but reports it as 900°C. Converting back subtracts 273, giving 627°C.' from version_ins
union all select gen_random_uuid(), id, 'C', '627°C', true, 'At fixed volume and amount, P is proportional to the Kelvin temperature. Tripling P triples T: 3 × 300 K = 900 K, which is 900 − 273 = 627°C.' from version_ins
union all select gen_random_uuid(), id, 'D', '81°C', false, 'This triples the Celsius temperature, 3 × 27. Pressure is proportional to the Kelvin temperature, so the 300 K must triple to 900 K, which is 627°C.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items ci join (values ('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v1'),('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v2'),('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v3'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v1'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v2'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v3'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v1'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v2'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v3')) p(pack,k) on ci.exam_pack_version_id=p.pack and ci.content_key=p.k where ci.status='draft')<>9 then raise exception 'expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id join (values ('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v1'),('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v2'),('841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-sv-003-v3'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v1'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v2'),('ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-sv-031-v3'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v1'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v2'),('f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-sv-001-v3')) p(pack,k) on ci.exam_pack_version_id=p.pack and ci.content_key=p.k)<>36 then raise exception 'choice rows'; end if;
end $$;
commit;
