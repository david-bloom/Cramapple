begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-029-v1','apphycem-mcq-sv-029-v2','apphycem-mcq-sv-029-v3','apphycem-mcq-sv-030-v1','apphycem-mcq-sv-030-v2','apphycem-mcq-sv-030-v3','apphycem-mcq-sv-np1-001-v1','apphycem-mcq-sv-np1-001-v2','apphycem-mcq-sv-np1-001-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-029-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-029-v1', 'mcq', 'Why the surface field is perpendicular', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A charged solid metal object sits in electrostatic equilibrium. Why must the electric field just outside its surface be perpendicular to the surface?', null, md5('apphycem-mcq-sv-029-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Electric field lines always cross every surface at right angles', false, 'Field lines cross an arbitrary surface at all angles. They are perpendicular only to an equipotential surface, such as a conductor''s surface in electrostatic equilibrium.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Excess charge spreads uniformly over any conductor, and uniform charge gives only a perpendicular field', false, 'The charge is not uniform on a non-spherical conductor, since it concentrates at points. The field is perpendicular because of the equilibrium condition, not because of uniformity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A steady surface current cancels any part of the field along the surface', false, 'In electrostatic equilibrium there is no current. The parallel component is zero because charges would otherwise flow.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A component along the surface would push charges along it, so equilibrium allows none', true, 'Free charges in the conductor feel the force qE. If the field had a part along the surface, charges would move, contradicting equilibrium. The surface is therefore an equipotential.' from version_ins;
-- apphycem-mcq-sv-029-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-029-v2', 'mcq', 'Neutral sphere in a uniform field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An uncharged metal sphere is placed in a uniform electric field that points in the +x direction and is allowed to reach electrostatic equilibrium. At the point on the sphere''s surface farthest in the −x direction, the electric field just outside the surface is', null, md5('apphycem-mcq-sv-029-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Perpendicular to the surface, pointing toward the sphere (+x)', true, 'Electrons shift toward the −x side, leaving negative induced charge there. Field lines end on negative charge, so the field just outside points into the surface, along +x, perpendicular to it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Zero, because the field inside the metal is zero', false, 'The interior field is zero, but induced charge sits on the surface at this point. The field just outside is not zero where there is surface charge.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Perpendicular to the surface, pointing away from the sphere (−x)', false, 'Away from the sphere would mean positive charge on this side. The induced charge on the −x side is negative, so the field points inward.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Tangent to the surface, pointing along +y', false, 'A part of the field along the surface would move the induced charges, so none exists in equilibrium. The field is perpendicular.' from version_ins;
-- apphycem-mcq-sv-029-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-029-v3', 'mcq', 'Field at a tip and a flat face', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A charged conductor in electrostatic equilibrium has a broad flat face and a sharp pointed tip. Which statement about the electric field just outside its surface is correct?', null, md5('apphycem-mcq-sv-029-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Perpendicular at the flat face but tilted along the surface near the tip', false, 'A tilted field would have a tangential part that moves charges. The field is perpendicular at the tip too.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Perpendicular everywhere, and stronger at the flat face because it holds more total charge', false, 'The flat face may hold more total charge, but the field depends on charge per area. The density is greater at the tip.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Perpendicular everywhere, and stronger at the tip than at the flat face', true, 'Charge density is higher at sharp points, and the field just outside is larger where the surface charge density is larger. The field is perpendicular because the surface is an equipotential.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Perpendicular everywhere, and equal at the tip and the flat face because the surface is at one potential', false, 'One potential means no tangential field, not equal magnitude. The surface charge density, and so the field strength, varies with curvature.' from version_ins;
-- apphycem-mcq-sv-030-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-030-v1', 'mcq', 'Dielectric in an isolated capacitor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A parallel-plate capacitor is charged by a battery, which is then disconnected. A dielectric with κ = 4 is slipped in to fill the space between the plates completely. The energy stored in the capacitor becomes', null, md5('apphycem-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'one-sixteenth of its original value', false, 'This applies the factor κ twice. The energy at fixed Q changes by the single factor 1/κ.' from version_ins
union all select gen_random_uuid(), id, 'B', 'unchanged', false, 'The stored energy does change. Total energy is conserved, but the field does positive work pulling the dielectric in, so the energy stored in the capacitor drops (U = Q²/2C with C larger and Q fixed).' from version_ins
union all select gen_random_uuid(), id, 'C', 'one-fourth of its original value', true, 'With the battery gone the charge Q stays fixed while C becomes 4C. The energy U = Q²/(2C) is therefore divided by 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'four times its original value', false, 'This applies the fixed-voltage result. With the battery disconnected the charge is fixed, not the voltage, and the voltage drops.' from version_ins;
-- apphycem-mcq-sv-030-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-030-v2', 'mcq', 'Energy with a dielectric on a battery', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 μF parallel-plate capacitor is connected to a 6.0 V battery and stays connected. A dielectric with κ = 2.5 is then inserted to fill the gap completely. What is the energy stored in the capacitor after insertion?', null, md5('apphycem-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '14 μJ', false, 'This divides the original 36 μJ by κ, the fixed-charge result. The battery holds the voltage fixed, so the energy rises.' from version_ins
union all select gen_random_uuid(), id, 'B', '90 μJ', true, 'The voltage stays 6.0 V and C becomes 2.5 × 2.0 = 5.0 μF. U = ½CV² = ½(5.0×10⁻⁶)(6.0)² = 9.0×10⁻⁵ J = 90 μJ.' from version_ins
union all select gen_random_uuid(), id, 'C', '225 μJ', false, 'This multiplies the original 36 μJ by κ² = 6.25. With V fixed, U = ½CV² grows only by the factor κ.' from version_ins
union all select gen_random_uuid(), id, 'D', '36 μJ', false, 'This is the original energy ½(2.0 μF)(6.0 V)². The capacitance grows by κ at the same voltage, so the energy grows too.' from version_ins;
-- apphycem-mcq-sv-030-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-030-v3', 'mcq', 'Energy change after removing the battery', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 μF parallel-plate capacitor is charged to 100 V by a battery, and the battery is then removed. A dielectric with κ = 4 is inserted to fill the gap completely. By how much does the stored energy change?', null, md5('apphycem-mcq-sv-030-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Decreases by 15 mJ', true, 'Initially U = ½CV² = 20 mJ. With Q fixed and C becoming 16 μF, U = Q²/(2C) falls to 5.0 mJ. The change is −15 mJ.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Decreases by 5.0 mJ', false, '5.0 mJ is the final energy, not the change. The change subtracts it from the initial 20 mJ.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Increases by 60 mJ', false, 'This is the change if the capacitor stayed connected at 100 V, where U would rise to 80 mJ. Without the battery the charge is fixed, not the voltage.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Decreases by 19 mJ', false, 'This uses the factor 1/κ² for the energy, giving 1.25 mJ. At fixed charge the energy changes by 1/κ, leaving 5.0 mJ.' from version_ins;
-- apphycem-mcq-sv-np1-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-001-v1', 'mcq', 'Field of a long charged wire', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A very long straight wire carries a uniform linear charge density of +4.0 nC/m. Using Gauss''s law, what is the magnitude of the electric field 0.20 m from the wire?', null, md5('apphycem-mcq-sv-np1-001-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '180 N/C', false, 'This is kλ/r, which drops the factor 2. The cylinder''s lateral area is 2πrL, so the field is 2kλ/r.' from version_ins
union all select gen_random_uuid(), id, 'B', '360 N/C', true, 'A cylindrical Gaussian surface gives E(2πrL) = λL/ε₀, so E = λ/(2πε₀r) = 2kλ/r = 2(9.0×10⁹)(4.0×10⁻⁹)/0.20 = 360 N/C.' from version_ins
union all select gen_random_uuid(), id, 'C', '900 N/C', false, 'This is kλ/r², the point-charge dependence. For a long wire the field falls as 1/r.' from version_ins
union all select gen_random_uuid(), id, 'D', '1800 N/C', false, 'This is 2kλ/r². The factor 2 is correct but the field of a line falls off as 1/r, not 1/r².' from version_ins;
-- apphycem-mcq-sv-np1-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-001-v2', 'mcq', 'Inside a uniformly charged cylinder', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A very long solid cylinder of radius 0.10 m carries a uniform volume charge density of +5.0 μC/m³. What is the electric field magnitude at a point inside the cylinder, 0.040 m from its axis?', null, md5('apphycem-mcq-sv-np1-001-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.1 × 10⁴ N/C', true, 'Take a coaxial Gaussian cylinder of radius r < R. The enclosed charge is ρπr²L, so E(2πrL) = ρπr²L/ε₀ and E = ρr/(2ε₀) = (5.0×10⁻⁶)(0.040)/(2×8.85×10⁻¹²) ≈ 1.1×10⁴ N/C.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.5 × 10³ N/C', false, 'This divides by the area 2πRL of the cylinder''s outer surface instead of the Gaussian surface''s own area 2πrL.' from version_ins
union all select gen_random_uuid(), id, 'C', '7.1 × 10⁴ N/C', false, 'This counts the charge of the whole cylinder, ρπR²L, inside a Gaussian surface of radius 0.040 m. Only the charge within that radius is enclosed.' from version_ins
union all select gen_random_uuid(), id, 'D', '7.5 × 10³ N/C', false, 'This is ρr/(3ε₀), the result for a sphere (area 4πr², volume 4πr³/3). A long cylinder needs the lateral area 2πrL and volume πr²L.' from version_ins;
-- apphycem-mcq-sv-np1-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-001-v3', 'mcq', 'Wire inside a charged shell', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A very long straight wire with uniform linear charge density +6.0 nC/m lies along the axis of a long thin cylindrical shell of radius 0.20 m. The shell carries a uniform charge of −12 nC per meter of length. What are the magnitude and direction of the electric field at 0.50 m from the axis?', null, md5('apphycem-mcq-sv-np1-001-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '216 N/C, directed toward the axis', true, 'At r = 0.50 m the Gaussian cylinder encloses both charges: λ_net = +6.0 − 12 = −6.0 nC/m. E = 2k|λ_net|/r = 2(9.0×10⁹)(6.0×10⁻⁹)/0.50 = 216 N/C, inward because the net charge is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '432 N/C, directed toward the axis', false, 'This uses only the shell''s −12 nC/m. The Gaussian surface also encloses the wire''s +6.0 nC/m.' from version_ins
union all select gen_random_uuid(), id, 'C', '648 N/C, directed away from the axis', false, 'This adds the magnitudes 6.0 + 12 = 18 nC/m. The charges have opposite signs and partly cancel.' from version_ins
union all select gen_random_uuid(), id, 'D', '216 N/C, directed away from the axis', false, 'The magnitude is right, but the net enclosed charge is negative, so the field points inward.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-029-v1','apphycem-mcq-sv-029-v2','apphycem-mcq-sv-029-v3','apphycem-mcq-sv-030-v1','apphycem-mcq-sv-030-v2','apphycem-mcq-sv-030-v3','apphycem-mcq-sv-np1-001-v1','apphycem-mcq-sv-np1-001-v2','apphycem-mcq-sv-np1-001-v3']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-029-v1','apphycem-mcq-sv-029-v2','apphycem-mcq-sv-029-v3','apphycem-mcq-sv-030-v1','apphycem-mcq-sv-030-v2','apphycem-mcq-sv-030-v3','apphycem-mcq-sv-np1-001-v1','apphycem-mcq-sv-np1-001-v2','apphycem-mcq-sv-np1-001-v3']))<>36 then raise exception 'chunk 5: choice rows'; end if;
end $$;
commit;
