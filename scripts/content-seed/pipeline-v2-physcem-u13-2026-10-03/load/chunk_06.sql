begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-np1-002-v1','apphycem-mcq-sv-np1-002-v2','apphycem-mcq-sv-np1-002-v3','apphycem-mcq-sv-np1-003-v1','apphycem-mcq-sv-np1-003-v2','apphycem-mcq-sv-np1-003-v3','apphycem-mcq-sv-np1-004-v1','apphycem-mcq-sv-np1-004-v2','apphycem-mcq-sv-np1-004-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-np1-002-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-002-v1', 'mcq', 'Charge enclosed by a coaxial Gaussian cylinder', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A very long straight thin rod carries a uniform linear charge density λ = 3.0 nC/m. A cylindrical Gaussian surface of radius 0.40 m is coaxial with the rod and has a length of 0.50 m. What is the charge enclosed by this Gaussian surface?', null, md5('apphycem-mcq-sv-np1-002-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 nC', false, 'Charge does not need to lie on the Gaussian surface to count. The rod passes through the cylinder, and the 0.50 m of it inside carries 1.5 nC.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.5 nC', true, 'The enclosed charge is the linear density times the length of rod inside the surface: q_enc = λL = (3.0 nC/m)(0.50 m) = 1.5 nC. The radius of the Gaussian cylinder does not change how much rod it contains.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.0 nC', false, 'This uses the number λ = 3.0 nC/m as if it were a charge. A charge requires multiplying λ by the 0.50 m of rod enclosed, giving 1.5 nC.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.8 nC', false, 'This multiplies λ by the curved area 2πrL = 1.26 m², but λ is charge per unit length, not per unit area. The enclosed charge is λL = 1.5 nC.' from version_ins;
-- apphycem-mcq-sv-np1-002-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-002-v2', 'mcq', 'Charge inside a uniformly charged ball', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid insulating sphere of radius 0.10 m carries a total charge of +8.0 µC spread uniformly through its volume. A concentric spherical Gaussian surface has radius 0.050 m. What charge does this Gaussian surface enclose?', null, md5('apphycem-mcq-sv-np1-002-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.0 µC', false, 'This scales by (r/R)², the ratio of surface areas. Charge is spread through the volume, so the enclosed fraction is (r/R)³ = 1/8.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.0 µC', true, 'With uniform volume density the enclosed charge is proportional to the enclosed volume: q_enc = Q(r/R)³ = (8.0 µC)(0.050/0.10)³ = 1.0 µC.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.0 µC', false, 'This scales the charge by r/R, as if charge were proportional to radius. Volume grows as r³, so the enclosed fraction is (1/2)³, not 1/2.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.0 µC', false, 'This is the whole charge of the sphere. The Gaussian surface lies inside the sphere, so it encloses only the charge within radius 0.050 m.' from version_ins;
-- apphycem-mcq-sv-np1-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-002-v3', 'mcq', 'Enclosed charge between a sphere and a shell', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid insulating sphere of radius 0.10 m has a uniform volume charge density ρ = 3.0 µC/m³. It is surrounded by a concentric thin spherical shell of radius 0.30 m that carries a charge of −9.0 nC. A spherical Gaussian surface of radius 0.20 m is concentric with both. What charge does the Gaussian surface enclose?', null, md5('apphycem-mcq-sv-np1-002-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '101 nC', false, 'This uses the Gaussian radius 0.20 m in place of the sphere''s radius 0.10 m, so it counts charge in a volume that is not charged: ρ(4/3)π(0.20 m)³ ≈ 101 nC.' from version_ins
union all select gen_random_uuid(), id, 'B', '12.6 nC', true, 'Only the solid sphere lies inside radius 0.20 m. Its charge is ρ(4/3)πR³ = (3.0 µC/m³)(4/3)π(0.10 m)³ ≈ 12.6 nC, using the sphere''s own radius R because the density is zero in the gap outside it. The shell at 0.30 m is outside the Gaussian surface.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.6 nC', false, 'This adds the shell''s −9.0 nC to the sphere''s 12.6 nC. The shell lies at 0.30 m, outside the 0.20 m Gaussian surface, so it is not enclosed.' from version_ins
union all select gen_random_uuid(), id, 'D', '88 nC', false, 'This fills the whole region from 0.10 m to 0.20 m with charge density ρ, but the gap between the sphere and the shell carries no charge.' from version_ins;
-- apphycem-mcq-sv-np1-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-003-v1', 'mcq', 'Field from a potential function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Along the x-axis the electric potential is V(x) = 40 − 8.0x², with V in volts and x in meters. What is the x-component of the electric field at x = 2.0 m?', null, md5('apphycem-mcq-sv-np1-003-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+4.0 V/m', false, 'This divides V(2.0 m) = 8.0 V by x = 2.0 m. The field is the slope −dV/dx, not the potential divided by position.' from version_ins
union all select gen_random_uuid(), id, 'B', '+32 V/m', true, 'E_x = −dV/dx = −(−16x) = 16x. At x = 2.0 m this is +32 V/m, positive because the potential is decreasing as x increases.' from version_ins
union all select gen_random_uuid(), id, 'C', '+16 V/m', false, 'This differentiates 8.0x² as 8.0x, leaving 16 at x = 2.0 m. The derivative of x² is 2x, so −dV/dx = 16x = 32 V/m.' from version_ins
union all select gen_random_uuid(), id, 'D', '+8.0 V/m', false, 'V(2.0 m) = 40 − 8.0(4.0) = 8.0 V. That is the potential, not the field. The field is the negative derivative of V, 16x = 32 V/m.' from version_ins;
-- apphycem-mcq-sv-np1-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-003-v2', 'mcq', 'Field from a piecewise potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The electric potential along the x-axis is constant at 10 V for x < 2.0 m, decreases linearly to 4.0 V between x = 2.0 m and x = 5.0 m, and is constant at 4.0 V for x > 5.0 m. What is the electric field in the region 2.0 m < x < 5.0 m?', null, md5('apphycem-mcq-sv-np1-003-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Zero, because V is nonzero there', false, 'The field depends on how the potential changes with position, not on its size. V falls by 6.0 V across the region, so E_x = 2.0 V/m, not zero.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.0 V/m in the +x direction', false, 'This is the total potential drop 6.0 V with no division by the 3.0 m distance. The field magnitude is the slope''s magnitude, 6.0 V/3.0 m = 2.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.50 V/m in the +x direction', false, 'This inverts the slope, using Δx/ΔV = 3.0/6.0 instead of |ΔV|/Δx. The field magnitude is 6.0 V/3.0 m = 2.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.0 V/m in the +x direction', true, 'In this region E_x = −ΔV/Δx = −(4.0 V − 10 V)/(5.0 m − 2.0 m) = +2.0 V/m. The field points in +x, the direction in which the potential falls.' from version_ins;
-- apphycem-mcq-sv-np1-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-003-v3', 'mcq', 'Potential difference from a field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a region of the x-axis the electric field component is E_x = 3.0x², with E_x in V/m and x in meters. What is the potential difference V(2.0 m) − V(0)?', null, md5('apphycem-mcq-sv-np1-003-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+8.0 V', false, 'This has the correct magnitude but omits the minus sign in ΔV = −∫E·dr. The potential falls in the direction the field points, so V(2.0 m) is lower than V(0).' from version_ins
union all select gen_random_uuid(), id, 'B', '−24 V', false, 'This multiplies the field at the endpoint, 3.0(2.0)² = 12 V/m, by the 2.0 m distance. The field is not constant, so the integral must be used; it gives −8.0 V.' from version_ins
union all select gen_random_uuid(), id, 'C', '−12 V', false, 'This differentiates E_x, getting 6.0x = 12 at x = 2.0 m. The potential difference requires integrating the field, which gives −8.0 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '−8.0 V', true, 'ΔV = −∫E_x dx from 0 to 2.0 m = −∫3.0x² dx = −[x³] from 0 to 2.0 m = −8.0 V. The potential decreases along the direction of the field.' from version_ins;
-- apphycem-mcq-sv-np1-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-004-v1', 'mcq', 'Midpoint of two equal positive charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical point charges of +2.0 µC are fixed 0.60 m apart in vacuum. Take V = 0 at infinity. What are the magnitude of the electric field and the electric potential at the midpoint between them?', null, md5('apphycem-mcq-sv-np1-004-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'E = 4.0×10⁵ N/C; V = 1.2×10⁵ V', false, 'This adds the two field magnitudes of 2.0×10⁵ N/C as scalars. Fields are vectors; at the midpoint they point in opposite directions and cancel.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E = 0; V = 1.2×10⁵ V', true, 'The two fields have equal magnitude and opposite directions, so they cancel: E = 0. Potential is a scalar, so the two positive contributions add: V = 2(9.0×10⁹)(2.0×10⁻⁶)/(0.30) = 1.2×10⁵ V.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E = 0; V = 6.0×10⁴ V', false, 'The field is correctly zero, but this counts the potential of only one charge. Both charges contribute 6.0×10⁴ V, so V = 1.2×10⁵ V.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E = 0; V = 0', false, 'The fields cancel as vectors, but potentials do not cancel here. Both charges are positive, so each adds +6.0×10⁴ V and V = 1.2×10⁵ V.' from version_ins;
-- apphycem-mcq-sv-np1-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-004-v2', 'mcq', 'Midpoint of unequal opposite charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A charge of +6.0 nC and a charge of −2.0 nC are fixed 0.40 m apart in vacuum. Take V = 0 at infinity. What are the magnitude and direction of the electric field, and the electric potential, at the midpoint of the line joining them?', null, md5('apphycem-mcq-sv-np1-004-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '9.0×10² N/C toward the −2.0 nC charge; 3.6×10² V', false, 'This applies the scalar rule to the field (subtracting) and the vector-style magnitude rule to the potential (adding magnitudes). The reverse is correct: fields add as vectors, potentials add as signed scalars.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.8×10³ N/C toward the −2.0 nC charge; 1.8×10² V', true, 'Both fields point toward the −2.0 nC charge (away from the positive, toward the negative), so they add: 1350 + 450 = 1.8×10³ N/C. The potentials add as signed scalars: (9.0×10⁹)(6.0 − 2.0)×10⁻⁹/0.20 = 1.8×10² V.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.0×10² N/C toward the −2.0 nC charge; 1.8×10² V', false, 'The potential is right, but the fields were subtracted (1350 − 450). Both point the same way at the midpoint, so they add to 1.8×10³ N/C.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.8×10³ N/C toward the −2.0 nC charge; 3.6×10² V', false, 'The field is right, but the potentials were added as magnitudes. The negative charge contributes a negative potential, so V = 180 V, not 360 V.' from version_ins;
-- apphycem-mcq-sv-np1-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-np1-004-v3', 'mcq', 'Zero-field point and its potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two positive point charges, +1.0 µC and +9.0 µC, are fixed 0.80 m apart on the x-axis in vacuum. Take V = 0 at infinity. At the point between them where the net electric field is zero, what are its distance from the +1.0 µC charge and the electric potential there?', null, md5('apphycem-mcq-sv-np1-004-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.20 m; 0', false, 'The location is right, but a vanishing field does not mean a vanishing potential. Both positive charges contribute positive potential, so V = 1.8×10⁵ V.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.080 m; 2.25×10⁵ V', false, 'This places the zero-field point using a 1/r dependence of the field, which gives x/(0.80 − x) = 1/9. The field falls as 1/r², giving x = 0.20 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.20 m; 1.8×10⁵ V', true, 'Setting k(1.0)/x² = k(9.0)/(0.80 − x)² gives 0.80 − x = 3x, so x = 0.20 m. There V = k(1.0×10⁻⁶/0.20 + 9.0×10⁻⁶/0.60) = 9.0×10⁹(2.0×10⁻⁵) = 1.8×10⁵ V, nonzero because both terms are positive.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.20 m; 4.5×10⁴ V', false, 'This is the potential of the nearer +1.0 µC charge alone. The +9.0 µC charge also contributes, and the two scalars add to 1.8×10⁵ V.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-np1-002-v1','apphycem-mcq-sv-np1-002-v2','apphycem-mcq-sv-np1-002-v3','apphycem-mcq-sv-np1-003-v1','apphycem-mcq-sv-np1-003-v2','apphycem-mcq-sv-np1-003-v3','apphycem-mcq-sv-np1-004-v1','apphycem-mcq-sv-np1-004-v2','apphycem-mcq-sv-np1-004-v3']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-np1-002-v1','apphycem-mcq-sv-np1-002-v2','apphycem-mcq-sv-np1-002-v3','apphycem-mcq-sv-np1-003-v1','apphycem-mcq-sv-np1-003-v2','apphycem-mcq-sv-np1-003-v3','apphycem-mcq-sv-np1-004-v1','apphycem-mcq-sv-np1-004-v2','apphycem-mcq-sv-np1-004-v3']))<>36 then raise exception 'chunk 6: choice rows'; end if;
end $$;
commit;
