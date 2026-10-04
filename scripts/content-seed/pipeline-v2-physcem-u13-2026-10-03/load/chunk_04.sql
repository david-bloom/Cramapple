begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-025-v1','apphycem-mcq-sv-025-v2','apphycem-mcq-sv-025-v3','apphycem-mcq-sv-026-v1','apphycem-mcq-sv-026-v2','apphycem-mcq-sv-026-v3','apphycem-mcq-sv-027-v1','apphycem-mcq-sv-027-v2','apphycem-mcq-sv-027-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-025-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-025-v1', 'mcq', 'Net flux with charges inside and outside', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spherical Gaussian surface encloses a +3.0 nC point charge. A second point charge of +5.0 nC lies outside the sphere. What is the net electric flux through the sphere? (ε₀ = 8.85 × 10⁻¹² C²/(N·m²))', null, md5('apphycem-mcq-sv-025-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.4 × 10² N·m²/C', true, 'By Gauss''s law, Φ = q_enc/ε₀ = (3.0 × 10⁻⁹)/(8.85 × 10⁻¹²) ≈ 3.4 × 10² N·m²/C. The outside charge makes field lines that enter and leave the sphere, which adds nothing to the net flux.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.3 × 10² N·m²/C', false, 'This uses the difference, 5.0 − 3.0 = 2.0 nC, treating the outside charge as removing flux. Outside charges add and remove the same flux, so the net effect is zero.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.6 × 10² N·m²/C', false, 'This uses only the outside charge. The outside charge contributes zero net flux, while the enclosed 3.0 nC sets the flux.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.0 × 10² N·m²/C', false, 'This uses the total of both charges, 8.0 nC. Only the enclosed charge counts in Gauss''s law.' from version_ins;
-- apphycem-mcq-sv-025-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-025-v2', 'mcq', 'Point charge near a cube', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A positive point charge sits just outside one face of an imaginary closed cube, not touching it. What is the total electric flux through the entire surface of the cube due to this outside charge?', null, md5('apphycem-mcq-sv-025-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Negative, because the field is strongest at the nearest face', false, 'The inward flux through the near face is largest, but the lines that enter must exit through the other faces. The outward flux through those faces cancels it completely.' from version_ins
union all select gen_random_uuid(), id, 'B', 'q/ε₀, because the charge’s field passes through the surface', false, 'The q/ε₀ result applies to a charge enclosed by the surface. A charge outside is not part of q_enc.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Zero, because each field line entering the cube also leaves it', true, 'Gauss''s law gives Φ = q_enc/ε₀, and no charge is enclosed. The flux is negative through the near face (field lines entering) and positive through the far faces (leaving), and these exactly cancel.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Positive, because the field at the near face points into the cube', false, 'Field lines pointing into the cube give negative flux through that face, and the same lines give positive flux when they leave. The total is zero rather than positive.' from version_ins;
-- apphycem-mcq-sv-025-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-025-v3', 'mcq', 'Adding a charge outside a closed surface', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A charge +Q lies inside a closed surface. A charge −Q is then placed just outside the surface. Compared with the situation before the second charge was added, which statement is correct?', null, md5('apphycem-mcq-sv-025-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The net flux becomes zero because the total charge is zero', false, 'Gauss''s law uses charge enclosed by the surface, not the total in the region. The enclosed charge is still +Q.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The net flux and the field at every surface point are both unchanged', false, 'Net flux is unchanged, but the field at surface points is the vector sum from all charges, and the new charge adds to it. Flux and local field are not the same quantity.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The net flux is unchanged, but the field at points on the surface changes', true, 'Net flux depends only on the enclosed charge, which is still +Q. The new charge still adds its own field at every point on the surface, so the local field changes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The net flux becomes negative because the new charge is negative', false, 'Near the outside −Q the field points toward it, so the flux is outward through the part of the surface nearest that charge and inward elsewhere, and these cancel. The outside charge adds zero net flux, so the net remains +Q/ε₀.' from version_ins;
-- apphycem-mcq-sv-026-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-026-v1', 'mcq', 'Pulling opposite charges apart', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A positive point charge and a negative point charge of equal magnitude are held a short distance apart. An external agent slowly pulls them farther apart. How does the electric potential energy of the two-charge system change?', null, md5('apphycem-mcq-sv-026-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It stays constant, because the charge magnitudes do not change', false, 'U = kq₁q₂/r depends on the separation r as well as on the charges. With r changing, U changes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It increases (becomes less negative)', true, 'For opposite charges U = kq₁q₂/r is negative. Increasing r moves U toward zero from below, so U rises. Equivalently, the agent does positive work against the attractive force.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It decreases, because the charges move away from each other', false, 'Moving apart lowers U only for charges that repel. These charges attract, so separating them takes work from the agent and raises U.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It decreases, because the attractive force does negative work', false, 'The attractive force does negative work as the charges separate, and ΔU = −W_field, so a negative W_field means U increases.' from version_ins;
-- apphycem-mcq-sv-026-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-026-v2', 'mcq', 'Energy change for an attracting pair', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A +3.0 μC point charge and a −2.0 μC point charge are initially 0.30 m apart. They are moved until they are 0.10 m apart. What is the change in the electric potential energy of the pair?', null, md5('apphycem-mcq-sv-026-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.36 J', true, 'ΔU = kq₁q₂(1/r_f − 1/r_i) = (9.0×10⁹)(−6.0×10⁻¹²)(10 − 3.33) ≈ −0.36 J. The attracting pair moves closer, so U becomes more negative.' from version_ins
union all select gen_random_uuid(), id, 'B', '−4.8 J', false, 'This uses a 1/r² dependence, the form of the force. The potential energy of a pair varies as 1/r.' from version_ins
union all select gen_random_uuid(), id, 'C', '−0.27 J', false, 'This divides by the 0.20 m displacement. U depends on the separation at each end of the motion, so U_i is subtracted from U_f.' from version_ins
union all select gen_random_uuid(), id, 'D', '−0.54 J', false, 'This is only the final energy U_f = kq₁q₂/r_f. The change subtracts the initial energy of −0.18 J, which gives −0.36 J.' from version_ins;
-- apphycem-mcq-sv-026-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-026-v3', 'mcq', 'Total energy of three fixed charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three point charges are fixed on a line: +2.0 μC at x = 0, −1.0 μC at x = 0.10 m, and +2.0 μC at x = 0.20 m. What is the total electric potential energy of this three-charge system, taking zero energy when the charges are infinitely far apart?', null, md5('apphycem-mcq-sv-026-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−0.18 J', true, 'Sum over the three pairs: U = (9.0×10⁹)[(2.0)(2.0)/0.20 + 2(2.0)(−1.0)/0.10]×10⁻¹² = (9.0×10⁹)(2.0×10⁻¹¹ − 4.0×10⁻¹¹) = −0.18 J.' from version_ins
union all select gen_random_uuid(), id, 'B', '−0.09 J', false, 'This halves the sum as if every pair were counted twice. In U = Σ kq_iq_j/r_ij each pair appears once, so the total is −0.18 J.' from version_ins
union all select gen_random_uuid(), id, 'C', '−0.36 J', false, 'This counts only the two attracting pairs (−0.36 J) and omits the repelling pair of the two positive charges, which contributes +0.18 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '+0.54 J', false, 'This adds the magnitudes of all three pair terms and ignores that the pairs with the negative charge contribute negative energy.' from version_ins;
-- apphycem-mcq-sv-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-027-v1', 'mcq', 'Potential near a small charged sphere', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Take the electric potential to be zero infinitely far away. What is the electric potential 0.30 m from an isolated point charge of +5.0 nC?', null, md5('apphycem-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '75 V', false, 'This inserts a factor of ½ borrowed from energy expressions. The point-charge potential V = kq/r has no such factor.' from version_ins
union all select gen_random_uuid(), id, 'B', '500 V', false, 'The value kq/r² = 500 is the point-charge field magnitude in N/C. The potential falls off as 1/r, not 1/r².' from version_ins
union all select gen_random_uuid(), id, 'C', '45 V', false, 'kq = 45 V·m has units of volt-meters. Dividing by r = 0.30 m is required and gives 150 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '150 V', true, 'V = kq/r = (9.0×10⁹)(5.0×10⁻⁹)/0.30 = 150 V.' from version_ins;
-- apphycem-mcq-sv-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-027-v2', 'mcq', 'Scaling potential with distance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a distance of 0.10 m from a point charge, the electric potential is −120 V (zero at infinity). What is the potential at 0.40 m from the same charge?', null, md5('apphycem-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−7.5 V', false, 'This divides by 4² = 16, the scaling of the field. The potential scales as 1/r, so the factor is 4.' from version_ins
union all select gen_random_uuid(), id, 'B', '−60 V', false, 'This divides by 2 = √4. V = kq/r changes by the full factor of the distance ratio, 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '−30 V', true, 'For a point charge V = kq/r, so V is inversely proportional to r. Quadrupling the distance divides V by 4, giving −30 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '−480 V', false, 'This multiplies by 4, as if V were proportional to r. Moving away from a point charge brings the potential closer to zero.' from version_ins;
-- apphycem-mcq-sv-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-027-v3', 'mcq', 'Potential difference from integrating the field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fixed point charge of +2.0 nC produces the radial field E = kq/r² directed outward. Evaluating ΔV = −∫E dr along a radial path, how much higher is the potential at r = 0.10 m than at r = 0.40 m?', null, md5('apphycem-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '60 V', false, 'This is kq/Δr = 18/0.30. Integrating 1/r² gives a difference of reciprocals, not the reciprocal of the displacement.' from version_ins
union all select gen_random_uuid(), id, 'B', '135 V', true, 'V(a) − V(b) = kq(1/a − 1/b) = (18 V·m)(10 − 2.5) m⁻¹ = 135 V. The inner point is at the higher potential because the charge is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', '180 V', false, 'This is kq/a, the potential at 0.10 m alone. The potential at 0.40 m is 45 V, not zero, so it must be subtracted.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.7 × 10³ V', false, 'This is kq(1/a² − 1/b²) ≈ 1690, a difference of field values in N/C. The potential difference comes from integrating the field, which leaves 1/r terms.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-025-v1','apphycem-mcq-sv-025-v2','apphycem-mcq-sv-025-v3','apphycem-mcq-sv-026-v1','apphycem-mcq-sv-026-v2','apphycem-mcq-sv-026-v3','apphycem-mcq-sv-027-v1','apphycem-mcq-sv-027-v2','apphycem-mcq-sv-027-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-025-v1','apphycem-mcq-sv-025-v2','apphycem-mcq-sv-025-v3','apphycem-mcq-sv-026-v1','apphycem-mcq-sv-026-v2','apphycem-mcq-sv-026-v3','apphycem-mcq-sv-027-v1','apphycem-mcq-sv-027-v2','apphycem-mcq-sv-027-v3']))<>36 then raise exception 'chunk 4: choice rows'; end if;
end $$;
commit;
