begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-021-v1','apphycem-mcq-sv-021-v2','apphycem-mcq-sv-021-v3','apphycem-mcq-sv-022-v1','apphycem-mcq-sv-022-v2','apphycem-mcq-sv-022-v3','apphycem-mcq-sv-024-v1','apphycem-mcq-sv-024-v2','apphycem-mcq-sv-024-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-021-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-021-v1', 'mcq', 'Halving the separation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two point charges are held fixed in place. If the distance between them is cut to one-half of its original value, the magnitude of the electric force between them becomes', null, md5('apphycem-mcq-sv-021-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'one-fourth as large', false, 'This applies the 1/r² factor in the wrong direction. A smaller r gives a larger force, so the factor is 4, not 1/4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'twice as large', false, 'This uses a 1/r dependence. The force varies as 1/r², so halving the distance gives a factor of 4, not 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'four times as large', true, 'Coulomb''s law gives F = k|q₁q₂|/r². Replacing r with r/2 multiplies the force by 1/(1/2)² = 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'one-half as large', false, 'This treats the force as proportional to r. The force grows when the charges move closer together.' from version_ins;
-- apphycem-mcq-sv-021-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-021-v2', 'mcq', 'Force between two small charged spheres', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two small spheres carry charges of +3.0 μC and +5.0 μC and are 0.30 m apart. What is the magnitude of the electric force each sphere exerts on the other? (k = 9.0 × 10⁹ N·m²/C²)', null, md5('apphycem-mcq-sv-021-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.5 N', true, 'F = k q₁q₂/r² = (9.0 × 10⁹)(3.0 × 10⁻⁶)(5.0 × 10⁻⁶)/(0.30)² = 0.135/0.090 = 1.5 N. By Newton''s third law, each sphere feels this same magnitude.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.45 N', false, 'This divides by r instead of r². Coulomb''s force depends on the square of the separation, so the denominator is (0.30)² = 0.090 m².' from version_ins
union all select gen_random_uuid(), id, 'C', '3.0 N', false, 'This adds the two force magnitudes, 1.5 N on each sphere. The pair of forces are equal and opposite, and the question asks for the magnitude of one of them.' from version_ins
union all select gen_random_uuid(), id, 'D', '17 N', false, 'This squares the already squared separation, effectively dividing by (0.090)² = 0.0081 m⁴. The denominator should be r² = (0.30)² = 0.090 m² only once.' from version_ins;
-- apphycem-mcq-sv-021-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-021-v3', 'mcq', 'Combined change of charge and separation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two fixed point charges repel each other with a force of magnitude 12 N when they are 0.20 m apart. One charge is then doubled and the separation is increased to 0.60 m. What is the new force magnitude?', null, md5('apphycem-mcq-sv-021-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.7 N', true, 'F is proportional to q₁q₂/r². Doubling one charge multiplies F by 2, and tripling the separation multiplies it by 1/9. The new force is 12 × 2/9 ≈ 2.7 N.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.3 N', false, 'This applies only the factor of 1/9 from the larger separation and forgets that doubling one charge doubles the force: 12/9 ≈ 1.3 N.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.0 N', false, 'This treats the separation factor as 1/3, giving 12 × 2/3 = 8.0 N. The force varies with the square of the separation, so tripling it gives a factor of 1/9.' from version_ins
union all select gen_random_uuid(), id, 'D', '216 N', false, 'This multiplies by 9 instead of dividing by it: 12 × 2 × 9 = 216 N. A larger separation weakens the force.' from version_ins;
-- apphycem-mcq-sv-022-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-022-v1', 'mcq', 'Field east of a positive charge', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small object carrying a positive charge sits at the origin. At a point P located due east of it, the electric field due to this object points', null, md5('apphycem-mcq-sv-022-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'east, away from the object', true, 'The field points in the direction of the force on a positive test charge. A positive test charge at P is repelled by the positive object, so the force and the field point away from it, to the east.' from version_ins
union all select gen_random_uuid(), id, 'B', 'west, toward the object', false, 'This is the field direction for a negative source charge. A positive source repels a positive test charge, so the field points away from it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'north, perpendicular to the line joining P and the object', false, 'A field that circles around a source describes the magnetic field of a current. The electric field of a point charge is along the line joining the charge and the point.' from version_ins
union all select gen_random_uuid(), id, 'D', 'west or east, depending on the sign of the test charge used', false, 'The field is defined as force per unit positive charge and belongs to the source. It does not change direction when a negative test charge is used (only the force does).' from version_ins;
-- apphycem-mcq-sv-022-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-022-v2', 'mcq', 'Field magnitude near a negative charge', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A point charge of −4.0 nC sits at the origin. What are the magnitude and direction of the electric field at a point 0.20 m from the charge? (k = 9.0 × 10⁹ N·m²/C²)', null, md5('apphycem-mcq-sv-022-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3600 N/C, toward the charge', false, 'This uses r = 0.10 m, half the distance, in k|q|/r². The given distance of 0.20 m yields 900 N/C.' from version_ins
union all select gen_random_uuid(), id, 'B', '180 N/C, toward the charge', false, 'This divides by r instead of r²: (9.0 × 10⁹)(4.0 × 10⁻⁹)/0.20 = 180 N/C. The field of a point charge falls off as 1/r².' from version_ins
union all select gen_random_uuid(), id, 'C', '1.1 × 10⁴ N/C, toward the charge', false, 'This uses q/(ε₀r²) and leaves out the 4π, which is 4π times too large. The correct form is q/(4πε₀r²) = kq/r².' from version_ins
union all select gen_random_uuid(), id, 'D', '900 N/C, toward the charge', true, 'E = k|q|/r² = (9.0 × 10⁹)(4.0 × 10⁻⁹)/(0.20)² = 900 N/C. The source is negative, so the field points toward it.' from version_ins;
-- apphycem-mcq-sv-022-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-022-v3', 'mcq', 'Field between opposite charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A charge of +2.0 μC is at x = 0 and a charge of −2.0 μC is at x = 0.40 m. What are the magnitude and direction of the net electric field at x = 0.20 m? (k = 9.0 × 10⁹ N·m²/C²)', null, md5('apphycem-mcq-sv-022-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 N/C', false, 'The fields cancel at the midpoint only when the two charges have the same sign. For opposite charges the two fields point the same way and add.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.2 × 10⁵ N/C, toward the negative charge', false, 'This uses the full 0.40 m separation as the distance from each charge to the point. Each charge is only 0.20 m from the midpoint.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.5 × 10⁵ N/C, toward the negative charge', false, 'This counts only one of the two charges. Both charges contribute a 4.5 × 10⁵ N/C field in the same direction.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.0 × 10⁵ N/C, toward the negative charge', true, 'Each charge produces a field of k|q|/r² = (9.0 × 10⁹)(2.0 × 10⁻⁶)/(0.20)² = 4.5 × 10⁵ N/C at the midpoint. The positive charge pushes the field away from itself and the negative charge pulls it toward itself, so both point in +x and add: 9.0 × 10⁵ N/C.' from version_ins;
-- apphycem-mcq-sv-024-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-024-v1', 'mcq', 'Flux through a tilted plane', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A uniform electric field of magnitude 200 N/C passes through a flat surface of area 0.50 m². The normal to the surface makes an angle of 60° with the field. What is the electric flux through the surface?', null, md5('apphycem-mcq-sv-024-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '87 N·m²/C', false, 'This uses sin 60° ≈ 0.87 where cos 60° = 0.50 belongs. The angle is measured between the field and the normal, which pairs with the cosine.' from version_ins
union all select gen_random_uuid(), id, 'B', '50 N·m²/C', true, 'For uniform E and flat A, Φ = EA cos θ = (200)(0.50)(cos 60°) = (100)(0.50) = 50 N·m²/C.' from version_ins
union all select gen_random_uuid(), id, 'C', '100 N·m²/C', false, 'This is EA with no angle factor, correct only when the normal is parallel to the field. At 60° only part of the field passes through the surface.' from version_ins
union all select gen_random_uuid(), id, 'D', '200 N·m²/C', false, 'This divides EA by cos θ: 100/0.50 = 200. The angle factor multiplies EA.' from version_ins;
-- apphycem-mcq-sv-024-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-024-v2', 'mcq', 'Flux through a loop parallel to the field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A square loop of side 0.10 m is placed in a uniform electric field of magnitude 5.0 × 10³ N/C so that the plane of the loop is parallel to the field lines. What is the electric flux through the loop?', null, md5('apphycem-mcq-sv-024-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50 N·m²/C', false, 'This is EA = (5.0 × 10³)(0.010) with the angle taken as 0°. That is the flux when the plane is perpendicular to the field, not parallel.' from version_ins
union all select gen_random_uuid(), id, 'B', '25 N·m²/C', false, 'This takes half of EA as an average between the extremes. Flux depends on cos θ, which is exactly zero when the plane is parallel to the field.' from version_ins
union all select gen_random_uuid(), id, 'C', '0', true, 'If the plane is parallel to the field, the normal is perpendicular to E, so θ = 90° and Φ = EA cos 90° = 0. The field lines skim along the surface without passing through it.' from version_ins
union all select gen_random_uuid(), id, 'D', '5.0 × 10⁵ N·m²/C', false, 'This computes E/A instead of EA. Flux is the field times the area.' from version_ins;
-- apphycem-mcq-sv-024-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-024-v3', 'mcq', 'Flux from field components', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A uniform electric field has components Eₓ = 300 N/C and E_y = 400 N/C. A flat surface of area 0.20 m² lies in the xz-plane, with its area vector pointing along +y. What is the electric flux through the surface?', null, md5('apphycem-mcq-sv-024-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 N·m²/C', false, 'This uses Eₓ, the component parallel to the surface, in place of the component along the normal.' from version_ins
union all select gen_random_uuid(), id, 'B', '80 N·m²/C', true, 'Flux is the dot product of E and the area vector. With the area vector along +y, only the y-component contributes: Φ = E_y A = (400)(0.20) = 80 N·m²/C. This is EA cos θ with E = 500 N/C and cos θ = 0.8.' from version_ins
union all select gen_random_uuid(), id, 'C', '100 N·m²/C', false, 'This multiplies the full field magnitude, 500 N/C, by the area. That drops the angle between E and the normal, which has cos θ = 0.8.' from version_ins
union all select gen_random_uuid(), id, 'D', '140 N·m²/C', false, 'This adds the two components, 300 + 400 = 700, and multiplies by A. Only the component along the normal passes through the surface.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-021-v1','apphycem-mcq-sv-021-v2','apphycem-mcq-sv-021-v3','apphycem-mcq-sv-022-v1','apphycem-mcq-sv-022-v2','apphycem-mcq-sv-022-v3','apphycem-mcq-sv-024-v1','apphycem-mcq-sv-024-v2','apphycem-mcq-sv-024-v3']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-021-v1','apphycem-mcq-sv-021-v2','apphycem-mcq-sv-021-v3','apphycem-mcq-sv-022-v1','apphycem-mcq-sv-022-v2','apphycem-mcq-sv-022-v3','apphycem-mcq-sv-024-v1','apphycem-mcq-sv-024-v2','apphycem-mcq-sv-024-v3']))<>36 then raise exception 'chunk 3: choice rows'; end if;
end $$;
commit;
