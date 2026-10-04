begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-np1-006-v1','apphycem-mcq-sv-np1-006-v2','apphycem-mcq-sv-np1-006-v3','apphycem-mcq-sv-np1-009-v1','apphycem-mcq-sv-np1-009-v2','apphycem-mcq-sv-np1-009-v3','apphycem-mcq-sv-np1-010-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-np1-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-006-v1', 'mcq', 'Field inside a uniformly charged ball versus surface', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid insulating sphere of radius R carries charge distributed uniformly throughout its volume. The electric field magnitude at the surface of the sphere is E_s. What is the field magnitude at a distance R/3 from the center?', null, md5('apphycem-mcq-sv-np1-006-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3E_s', false, 'This treats the field as proportional to 1/r (as for a long line charge). Inside a uniformly charged sphere, E increases with r from zero at the center.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E_s/3', true, 'Inside, Gauss''s law gives E = ρr/(3ε₀), proportional to r. At r = R/3 the field is one third of its value at r = R.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E_s/9', false, 'This makes the field proportional to r², but the enclosed charge falls as r³ while the Gaussian area falls only as r², so E is proportional to r.' from version_ins
union all select gen_random_uuid(), id, 'D', '9E_s', false, 'This uses the outside 1/r² dependence, which would make the field larger closer to the center. Inside a uniform sphere the field decreases toward the center.' from version_ins;
-- apphycem-mcq-sv-np1-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-006-v2', 'mcq', 'Field inside a long charged cylinder', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A long solid insulating cylinder of radius 0.040 m carries a uniform volume charge density ρ = 3.0 µC/m³. Far from its ends, what is the electric field magnitude at a distance of 0.020 m from its axis? (ε₀ = 8.85×10⁻¹² C²/N·m²)', null, md5('apphycem-mcq-sv-np1-006-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6.8×10³ N/C', false, 'This is ρr/ε₀, which drops the factor 2 in the denominator. The ratio of enclosed charge ρπr²L to lateral area 2πrL is ρr/2.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.3×10³ N/C', false, 'This uses ρr/(3ε₀), the interior result for a sphere. For a cylinder the enclosed charge is ρπr²L and the Gaussian area is 2πrL, giving ρr/(2ε₀).' from version_ins
union all select gen_random_uuid(), id, 'C', '3.4×10³ N/C', true, 'Use a coaxial cylinder of radius r and length L: E(2πrL) = ρπr²L/ε₀, so E = ρr/(2ε₀) = (3.0×10⁻⁶)(0.020)/(2 × 8.85×10⁻¹²) ≈ 3.4×10³ N/C.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.36×10⁴ N/C', false, 'This uses the outside formula ρR²/(2ε₀r) with r = 0.020 m. The point is inside the cylinder, where only the charge within r is enclosed.' from version_ins;
-- apphycem-mcq-sv-np1-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-006-v3', 'mcq', 'Field in a sphere with non-uniform charge density', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid insulating sphere of radius R = 0.20 m has a volume charge density that increases linearly with distance from the center, ρ(r) = ρ₀(r/R), where ρ₀ = 8.0 µC/m³. What is the electric field magnitude at r = 0.10 m? (ε₀ = 8.85×10⁻¹² C²/N·m²)', null, md5('apphycem-mcq-sv-np1-006-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.1×10⁴ N/C', true, 'q_enc = ∫ρ(r′)4πr′² dr′ from 0 to r = (4πρ₀/R)∫r′³dr′ = πρ₀r⁴/R. Gauss''s law gives E = q_enc/(4πε₀r²) = ρ₀r²/(4ε₀R) = (8.0×10⁻⁶)(0.010)/(4 × 8.85×10⁻¹² × 0.20) ≈ 1.1×10⁴ N/C.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.5×10⁴ N/C', false, 'This takes the density at r as uniform inside radius r, q_enc = ρ(r)(4/3)πr³. The density changes with radius, so the enclosed charge must be integrated; it is πρ₀r⁴/R.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.0×10⁴ N/C', false, 'This uses ρ₀ as a uniform density throughout, giving ρ₀r/(3ε₀). The density at the center is zero, and it is only ρ₀/2 at r = R/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.5×10⁴ N/C', false, 'This integrates r′³ as r⁴ instead of r⁴/4, so the enclosed charge is four times too large. The correct integral gives ρ₀r²/(4ε₀R).' from version_ins;
-- apphycem-mcq-sv-np1-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-009-v1', 'mcq', 'Where excess charge sits on a conductor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid copper sphere is given an excess charge and then left isolated until all charges are at rest. Where is the excess charge located?', null, md5('apphycem-mcq-sv-np1-009-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Concentrated at the center of the sphere', false, 'Charge at the center would create a field throughout the metal. Free charges repel each other and move to the outer surface until the interior field is zero.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Half on the surface and half in the interior', false, 'Any excess charge in the interior would produce a nonzero field inside the conductor. All of the excess charge ends up on the surface.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Entirely on the outer surface', true, 'In equilibrium the field inside the metal is zero, so Gauss''s law gives zero enclosed charge for any Gaussian surface inside the conductor. The excess charge therefore sits on the outer surface.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Spread uniformly throughout the volume', false, 'A uniform volume distribution would produce a nonzero field inside. In equilibrium the field in the metal must be zero, which requires the excess charge to be on the surface.' from version_ins;
-- apphycem-mcq-sv-np1-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-009-v2', 'mcq', 'Induced charges on a shell with a cavity', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A neutral, thick conducting spherical shell has a +5.0 nC point charge at the center of its hollow cavity. The system is in electrostatic equilibrium. What charge is on the shell''s inner surface and what charge is on its outer surface?', null, md5('apphycem-mcq-sv-np1-009-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Inner surface 0; outer surface +5.0 nC', false, 'This puts the charge on the outer surface without a matching induced charge inside. A Gaussian surface inside the metal would then enclose +5.0 nC, giving a nonzero field in the conductor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Inner surface −5.0 nC; outer surface +5.0 nC', true, 'The field inside the conducting material is zero, so a Gaussian surface within the metal must enclose zero net charge. The inner surface carries −5.0 nC to cancel the central +5.0 nC, and charge neutrality of the shell puts +5.0 nC on the outer surface.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Inner surface −5.0 nC; outer surface 0', false, 'The inner surface charge is right, but the shell is neutral, so its total charge must stay zero. The outer surface must carry +5.0 nC.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Inner surface 0; outer surface 0', false, 'The shell is neutral overall, but the central charge induces separation. Zero field in the metal requires −5.0 nC on the inner surface, which leaves +5.0 nC on the outer surface.' from version_ins;
-- apphycem-mcq-sv-np1-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-009-v3', 'mcq', 'Fields around a charged shell holding a charge', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A point charge of +5.0 nC sits at the center of a thick conducting spherical shell with inner radius 0.10 m and outer radius 0.20 m. The shell carries a net charge of −3.0 nC and is in electrostatic equilibrium. What are the electric field magnitudes at r = 0.15 m (inside the conducting material) and at r = 0.30 m, with the direction at r = 0.30 m?', null, md5('apphycem-mcq-sv-np1-009-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'At 0.15 m: 0; at 0.30 m: 0', false, 'The interior value is right, but the conductor does not shield the region outside it from the net enclosed charge. With +2.0 nC enclosed, the field at 0.30 m is 2.0×10² N/C.' from version_ins
union all select gen_random_uuid(), id, 'B', 'At 0.15 m: 0; at 0.30 m: 2.0×10² N/C radially outward', true, 'The field inside the conducting material is zero. Outside, only the net enclosed charge +5.0 − 3.0 = +2.0 nC matters: E = (9.0×10⁹)(2.0×10⁻⁹)/(0.30)² = 2.0×10² N/C, directed outward.' from version_ins
union all select gen_random_uuid(), id, 'C', 'At 0.15 m: 0; at 0.30 m: 5.0×10² N/C radially outward', false, 'The interior value is right, but this counts only the central +5.0 nC. The shell''s −3.0 nC is inside the Gaussian surface at 0.30 m, so the enclosed charge is +2.0 nC.' from version_ins
union all select gen_random_uuid(), id, 'D', 'At 0.15 m: 2.0×10³ N/C; at 0.30 m: 2.0×10² N/C, both radially outward', false, 'The 0.30 m value is right, but a point inside the conducting material cannot have a field. The shell''s inner surface carries −5.0 nC that cancels the central charge''s field there.' from version_ins;
-- apphycem-mcq-sv-np1-010-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-010-v2', 'mcq', 'Charge from flux through one cube face', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A point charge is at the center of a cube. The electric flux through one face of the cube is 150 N·m²/C. What is the value of the charge? (ε₀ = 8.85×10⁻¹² C²/N·m²)', null, md5('apphycem-mcq-sv-np1-010-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.22 nC', false, 'This divides the face flux by 6 instead of multiplying. The total flux is larger than the flux through one face.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.3 nC', false, 'This applies Gauss''s law to the single face, q = ε₀Φ. Gauss''s law uses the flux through the whole closed surface, which is six times larger.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.0 nC', true, 'By symmetry the total flux through the cube is six times the flux through one face, 900 N·m²/C. Gauss''s law gives q = ε₀Φ_total = (8.85×10⁻¹²)(900) ≈ 8.0 nC.' from version_ins
union all select gen_random_uuid(), id, 'D', '17 nC', false, 'This uses Φ = q/(4πε₀), giving q = 4πε₀Φ for the face flux. Gauss''s law has Φ_total = q/ε₀ with no factor of 4π.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-np1-006-v1','apphycem-mcq-sv-np1-006-v2','apphycem-mcq-sv-np1-006-v3','apphycem-mcq-sv-np1-009-v1','apphycem-mcq-sv-np1-009-v2','apphycem-mcq-sv-np1-009-v3','apphycem-mcq-sv-np1-010-v2']) and status='draft')<>7 then raise exception 'chunk 7: expected 7 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-np1-006-v1','apphycem-mcq-sv-np1-006-v2','apphycem-mcq-sv-np1-006-v3','apphycem-mcq-sv-np1-009-v1','apphycem-mcq-sv-np1-009-v2','apphycem-mcq-sv-np1-009-v3','apphycem-mcq-sv-np1-010-v2']))<>28 then raise exception 'chunk 7: choice rows'; end if;
end $$;
commit;
