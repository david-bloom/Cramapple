begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-007-v1','apphycem-mcq-sv-007-v2','apphycem-mcq-sv-007-v3','apphycem-mcq-sv-008-v1','apphycem-mcq-sv-008-v2','apphycem-mcq-sv-008-v3','apphycem-mcq-sv-009-v1','apphycem-mcq-sv-009-v2','apphycem-mcq-sv-009-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-007-v1', 'mcq', 'Pulling capacitor plates apart', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The plates of a parallel-plate capacitor, with nothing between them, are pulled apart until their separation is three times the original value. The plate area is unchanged. The capacitance becomes', null, md5('apphycem-mcq-sv-007-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'three times its original value', false, 'This treats C as proportional to d. In C = ε₀A/d the separation is in the denominator, so greater separation lowers C.' from version_ins
union all select gen_random_uuid(), id, 'B', 'one-third of its original value', true, 'For a parallel-plate capacitor C = ε₀A/d, so C is inversely proportional to d. Tripling d with A fixed makes C one-third of its original value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'unchanged, since the area is the same', false, 'Area is one factor, but C = ε₀A/d also depends on separation. Changing d changes C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'one-ninth of its original value', false, 'This treats C as proportional to 1/d². Capacitance varies as 1/d, so tripling d reduces C by a factor of 3, not 9.' from version_ins;
-- apphycem-mcq-sv-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-007-v2', 'mcq', 'Capacitance of rectangular plates', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A parallel-plate capacitor has rectangular plates 0.040 m by 0.050 m separated by 1.0 mm of vacuum. Neglecting edge effects, what is its capacitance?', null, md5('apphycem-mcq-sv-007-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 pF', true, 'C = ε₀A/d = (8.85 × 10⁻¹² F/m)(0.040 m × 0.050 m)/(1.0 × 10⁻³ m) ≈ 1.8 × 10⁻¹¹ F = 18 pF.' from version_ins
union all select gen_random_uuid(), id, 'B', '350 pF', false, 'This uses a single side length (0.040 m) in place of the area. Area is 0.040 × 0.050 = 2.0 × 10⁻³ m², giving C ≈ 18 pF.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.4 pF', false, 'This is ε₀d/A, with the area and separation interchanged. Capacitance is proportional to A/d, so C = ε₀A/d ≈ 18 pF.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.018 pF', false, 'This uses d = 1.0 (millimeters entered as meters) in the denominator. The separation must be 1.0 × 10⁻³ m, giving C ≈ 18 pF.' from version_ins;
-- apphycem-mcq-sv-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-007-v3', 'mcq', 'Comparing two parallel-plate capacitors', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Capacitor 1 has circular plates of radius R separated by d. Capacitor 2 has circular plates of radius 2R separated by 3d. Both are vacuum-filled. What is C₂/C₁, neglecting edge effects?', null, md5('apphycem-mcq-sv-007-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4/3', true, 'C = ε₀A/d with A = πr². Doubling the radius makes the area 4 times larger and tripling the separation divides by 3, so C₂/C₁ = 4/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '2/3', false, 'This scales the area with the radius (factor 2) instead of its square (factor 4). Area is πr², so the area factor is 4 and C₂/C₁ = 4/3.' from version_ins
union all select gen_random_uuid(), id, 'C', '12', false, 'This multiplies by both the area factor 4 and the separation factor 3. The separation is in the denominator, so it divides: C₂/C₁ = 4/3.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/12', false, 'This inverts both factors, as if C were proportional to 1/(A·d) with the area also in the denominator. Capacitance is proportional to A/d, so C₂/C₁ = 4/3.' from version_ins;
-- apphycem-mcq-sv-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-008-v1', 'mcq', 'Energy in a charged capacitor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 10 μF capacitor is charged until the potential difference across it is 6.0 V. How much energy is stored in the capacitor?', null, md5('apphycem-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '180 μJ', true, 'U = ½C(ΔV)² = ½(10 × 10⁻⁶ F)(6.0 V)² = 1.8 × 10⁻⁴ J = 180 μJ.' from version_ins
union all select gen_random_uuid(), id, 'B', '30 μJ', false, 'This is ½CΔV, with the voltage to the first power. Energy depends on the square of the potential difference, U = ½C(ΔV)², which gives 180 μJ.' from version_ins
union all select gen_random_uuid(), id, 'C', '360 μJ', false, 'This is C(ΔV)², missing the factor ½. Charging a capacitor takes energy ½C(ΔV)² because the voltage rises gradually from zero as charge is added.' from version_ins
union all select gen_random_uuid(), id, 'D', '60 μJ', false, 'This is Q = CΔV = 60 μC, a charge rather than an energy. The energy is ½QΔV = ½C(ΔV)² = 180 μJ.' from version_ins;
-- apphycem-mcq-sv-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-008-v2', 'mcq', 'Stored energy when plates are separated', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A parallel-plate capacitor is charged to charge Q and then disconnected from the battery. The plates are slowly pulled apart until their separation is twice the original value. The energy stored in the capacitor is now', null, md5('apphycem-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'four times its original value', false, 'This doubles ΔV in ½C(ΔV)² without also halving C. With C halved and ΔV doubled, U = ½(C/2)(2ΔV)² = 2 × the original.' from version_ins
union all select gen_random_uuid(), id, 'B', 'twice its original value', true, 'Q is fixed and C = ε₀A/d is halved, so ΔV = Q/C doubles. Then U = ½QΔV doubles. The extra energy comes from the work done pulling the plates apart.' from version_ins
union all select gen_random_uuid(), id, 'C', 'half its original value', false, 'This holds ΔV fixed and halves C in U = ½C(ΔV)². The capacitor is disconnected, so Q is what stays fixed and ΔV rises. U = Q²/(2C) doubles.' from version_ins
union all select gen_random_uuid(), id, 'D', 'unchanged, because the charge is fixed', false, 'Fixed Q does not mean fixed energy: U = ½QΔV and ΔV doubles when C halves, so U doubles.' from version_ins;
-- apphycem-mcq-sv-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-008-v3', 'mcq', 'Energy to charge a capacitor further', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.0 μF capacitor already has a potential difference of 2.0 V across it. How much additional energy must be supplied to charge it until the potential difference is 5.0 V?', null, md5('apphycem-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 μJ', false, 'This is CΔV = 12 μC, the added charge, reported as energy. The added energy is ½C(V₂² − V₁²) = 42 μJ.' from version_ins
union all select gen_random_uuid(), id, 'B', '42 μJ', true, 'The added energy is U₂ − U₁ = ½C(V₂² − V₁²) = ½(4.0 × 10⁻⁶ F)(25 − 4) V² = 4.2 × 10⁻⁵ J = 42 μJ.' from version_ins
union all select gen_random_uuid(), id, 'C', '18 μJ', false, 'This is ½C(V₂ − V₁)², the energy as if the capacitor were charged from zero to the 3.0 V difference. Energy is quadratic in V, so the difference of the squares must be used: 42 μJ.' from version_ins
union all select gen_random_uuid(), id, 'D', '50 μJ', false, 'This is the total energy ½CV₂² at 5.0 V, including the 8 μJ already stored at 2.0 V. The question asks for the additional energy: 42 μJ.' from version_ins;
-- apphycem-mcq-sv-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-009-v1', 'mcq', 'Field inside a charged metal sphere', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid copper sphere is given a net positive charge and then left alone until all charge motion has stopped. What is the electric field at a point inside the copper, well below its surface?', null, md5('apphycem-mcq-sv-009-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Equal to the field just outside the surface', false, 'The field just outside is nonzero (it is perpendicular to the surface and proportional to the local surface charge density). Inside the metal the field is zero, so the two are not equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Nonzero, because the excess charge repels itself', false, 'The repulsion is exactly why the excess charge moves to the surface. Once it is at rest, the forces on the free charges inside balance and the net field in the metal is zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Directed radially outward and growing with distance from the center', false, 'This is the pattern for charge spread through the volume of an insulator. In a conductor the excess charge sits on the surface and the field inside the metal is zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Zero', true, 'In electrostatic equilibrium the free charges have rearranged until the net field inside the conducting material vanishes. Any nonzero field would still push free charges, so the charge would not be at rest.' from version_ins;
-- apphycem-mcq-sv-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-009-v2', 'mcq', 'Neutral metal slab in an external field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A neutral solid metal slab is placed in a uniform external electric field of magnitude 4.0 × 10³ N/C directed along +x. After the charges in the slab finish rearranging, what is the magnitude of the net electric field within the metal of the slab?', null, md5('apphycem-mcq-sv-009-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 N/C', true, 'The induced surface charges create a field inside the slab of magnitude 4.0 × 10³ N/C pointing opposite to the external field. The net field inside the metal is 4.0 × 10³ − 4.0 × 10³ = 0 N/C, which is what allows the free charges to stay at rest.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.0 × 10³ N/C', false, 'This would mean the metal has no effect on the field. The free charges respond to the external field and rearrange until it is fully canceled inside the metal.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.0 × 10³ N/C', false, 'The charges do not stop at partial cancellation. They keep moving until the induced field equals the external field, so half the external value is not an equilibrium result.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.0 × 10³ N/C', false, 'This adds the induced field to the external field. The induced charges are arranged so that their field inside the metal opposes the external field, giving cancellation instead of doubling.' from version_ins;
-- apphycem-mcq-sv-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-009-v3', 'mcq', 'Potential at the center of a charged conductor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid conducting sphere of radius 0.30 m carries a net charge of +6.0 nC and is in electrostatic equilibrium. Taking V = 0 infinitely far away, what is the electric potential at the center of the sphere? (k = 9.0 × 10⁹ N·m²/C²)', null, md5('apphycem-mcq-sv-009-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 V', false, 'A zero field does not mean zero potential. Potential only stays constant where the field is zero; its value is fixed by matching the surface value kQ/R, which is 180 V.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infinite', false, 'V = kQ/r diverges only at the location of a point charge. Here the charge sits on the surface, the field inside is zero, and the potential at the center is the finite surface value.' from version_ins
union all select gen_random_uuid(), id, 'C', '180 V', true, 'The field is zero everywhere inside the metal, so the potential has no change from the surface to the center. The center is at the surface potential kQ/R = (9.0 × 10⁹)(6.0 × 10⁻⁹)/0.30 = 180 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '360 V', false, 'This evaluates kQ/r at r = R/2 as if the potential kept rising toward the center like a point-charge potential. Inside the conductor the potential is constant at its surface value.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-007-v1','apphycem-mcq-sv-007-v2','apphycem-mcq-sv-007-v3','apphycem-mcq-sv-008-v1','apphycem-mcq-sv-008-v2','apphycem-mcq-sv-008-v3','apphycem-mcq-sv-009-v1','apphycem-mcq-sv-009-v2','apphycem-mcq-sv-009-v3']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-007-v1','apphycem-mcq-sv-007-v2','apphycem-mcq-sv-007-v3','apphycem-mcq-sv-008-v1','apphycem-mcq-sv-008-v2','apphycem-mcq-sv-008-v3','apphycem-mcq-sv-009-v1','apphycem-mcq-sv-009-v2','apphycem-mcq-sv-009-v3']))<>36 then raise exception 'chunk 2: choice rows'; end if;
end $$;
commit;
