begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-001-v1','apphycem-mcq-sv-001-v2','apphycem-mcq-sv-001-v3','apphycem-mcq-sv-005-v1','apphycem-mcq-sv-005-v2','apphycem-mcq-sv-005-v3','apphycem-mcq-sv-006-v1','apphycem-mcq-sv-006-v2','apphycem-mcq-sv-006-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycem-mcq-sv-001-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-001-v1', 'mcq', 'Flux through a cube around a point charge', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A point charge of +3.0 nC sits at the center of a closed cube with 0.10 m edges. What is the net electric flux through the entire surface of the cube?', null, md5('apphycem-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '56 N·m²/C', false, 'This divides the total flux by the six faces of the cube. That is the flux through one face; the question asks for the whole closed surface, whose flux is Q/ε₀ ≈ 3.4 × 10² N·m²/C.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.7 × 10⁻²⁰ N·m²/C', false, 'This multiplies Q by ε₀. Gauss''s law divides the enclosed charge by ε₀, so the flux is about 3.4 × 10² N·m²/C.' from version_ins
union all select gen_random_uuid(), id, 'C', '27 N·m²/C', false, 'This is kQ with k = 9.0 × 10⁹ N·m²/C², which omits the factor 4π. Since 1/ε₀ = 4πk, the flux is Q/ε₀ = 4πkQ, about 3.4 × 10² N·m²/C.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.4 × 10² N·m²/C', true, 'By Gauss''s law the net flux through any closed surface is Q_enc/ε₀ = (3.0 × 10⁻⁹ C)/(8.85 × 10⁻¹² C²/N·m²) ≈ 3.4 × 10² N·m²/C. The edge length does not enter.' from version_ins;
-- apphycem-mcq-sv-001-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-001-v2', 'mcq', 'Net flux with charges inside and outside', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A closed surface encloses a +5.0 μC charge and a −2.0 μC charge. A +6.0 μC charge lies just outside the surface. What is the net electric flux through the surface?', null, md5('apphycem-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.4 × 10⁵ N·m²/C', true, 'Only enclosed charge counts: Q_enc = +5.0 μC − 2.0 μC = +3.0 μC, so Φ = Q_enc/ε₀ = 3.0 × 10⁻⁶/8.85 × 10⁻¹² ≈ 3.4 × 10⁵ N·m²/C. The outside charge produces field lines that enter and leave the surface, with zero net flux.' from version_ins
union all select gen_random_uuid(), id, 'B', '7.9 × 10⁵ N·m²/C', false, 'This adds the magnitudes (5.0 + 2.0) μC = 7.0 μC. Charge is a signed quantity, so the negative charge subtracts: Q_enc = 3.0 μC and Φ ≈ 3.4 × 10⁵ N·m²/C.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.6 × 10⁵ N·m²/C', false, 'This counts only the +5.0 μC charge and leaves out the enclosed −2.0 μC charge. Every enclosed charge counts, so Q_enc = 3.0 μC and Φ ≈ 3.4 × 10⁵ N·m²/C.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.0 × 10⁶ N·m²/C', false, 'This adds the outside charge: (5.0 − 2.0 + 6.0) μC = 9.0 μC. The outside charge contributes zero net flux, so Q_enc = 3.0 μC and Φ ≈ 3.4 × 10⁵ N·m²/C.' from version_ins;
-- apphycem-mcq-sv-001-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-001-v3', 'mcq', 'Moving charges around a Gaussian surface', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A closed surface encloses a +4.0 μC charge at its center. A +4.0 μC charge sits outside the surface. The inside charge is moved to a spot near the surface (still inside), and the outside charge is moved closer to the surface (still outside). What happens to the net electric flux through the surface?', null, md5('apphycem-mcq-sv-001-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It stays the same only if the inside charge returns to the center', false, 'Gauss''s law holds for any charge position inside the surface. Symmetry is only needed to pull E out of the integral for calculation, not for the net flux to equal Q_enc/ε₀.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It increases, because the field at the surface is stronger', false, 'Net flux depends only on the enclosed charge, not on the field strength at the surface. Moving the charges makes the field stronger at some points of the surface and weaker at others, and the external charge''s field lines enter and leave, so its net contribution stays zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It stays the same', true, 'Net flux is Q_enc/ε₀, and Q_enc is still +4.0 μC. Moving charges changes how the flux is distributed over the surface and changes the field there, but not the net flux.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It decreases, because part of the surface is now closer to the charge', false, 'Part of the surface now has a larger flux per area, but the surface elsewhere has smaller flux, and the net total remains Q_enc/ε₀.' from version_ins;
-- apphycem-mcq-sv-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-005-v1', 'mcq', 'Field from a linear potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In one region the electric potential is V(x) = (5.0 V/m)x + 2.0 V. What is the x-component of the electric field at x = 1.0 m?', null, md5('apphycem-mcq-sv-005-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+5.0 V/m', false, 'This is the slope of V without the minus sign. The field points toward lower potential, so E_x = −dV/dx = −5.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'B', '7.0 V/m', false, 'This is the value of the potential at x = 1.0 m, V = 5.0 + 2.0 = 7.0 V. The field depends on the slope of V, not its value, so E_x = −5.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.0 V/m', false, 'This takes the constant term of the formula as the field. A constant added to V does not affect E; only the slope matters, so E_x = −5.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'D', '−5.0 V/m', true, 'E_x = −dV/dx = −5.0 V/m, because the field points toward decreasing potential and V increases with x here.' from version_ins;
-- apphycem-mcq-sv-005-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-005-v2', 'mcq', 'Field from a quadratic potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The electric potential along the x-axis is V(x) = 3.0x² − 4.0x, with V in volts and x in meters. What is E_x at x = 2.0 m?', null, md5('apphycem-mcq-sv-005-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−12.0 V/m', false, 'This differentiates only the 3.0x² term and drops the −4.0x term''s contribution of −4.0. The full derivative is 6.0x − 4.0 = 8.0, so E_x = −8.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'B', '−8.0 V/m', true, 'E_x = −dV/dx = −(6.0x − 4.0) = −(12.0 − 4.0) = −8.0 V/m at x = 2.0 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '−4.0 V/m', false, 'This uses the value V(2.0 m) = 4.0 V with a minus sign. The field is the negative derivative of V, not the negative of V itself: E_x = −8.0 V/m.' from version_ins
union all select gen_random_uuid(), id, 'D', '−2.0 V/m', false, 'This is −V/x = −4.0/2.0, a ratio rather than a derivative. For a nonlinear V(x) the field is −dV/dx = −8.0 V/m.' from version_ins;
-- apphycem-mcq-sv-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-005-v3', 'mcq', 'Field in each region of a potential profile', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The potential along the x-axis consists of straight-line segments: V = 10 V at x = 0, V = 2 V at x = 0.20 m, and V = 11 V at x = 0.50 m. Which choice gives E_x in each segment?', null, md5('apphycem-mcq-sv-005-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+10 V/m for 0 < x < 0.20 m, then +22 V/m for 0.20 m < x < 0.50 m', false, 'These are the ratios V/x at the segment ends (2/0.20 and 11/0.50). The field is the negative of the slope of V in each segment, −ΔV/Δx, not the ratio of V to position.' from version_ins
union all select gen_random_uuid(), id, 'B', '+40 V/m for 0 < x < 0.20 m, then −30 V/m for 0.20 m < x < 0.50 m', true, 'Each segment''s field is −ΔV/Δx. First segment: −(2 − 10)/0.20 = +40 V/m. Second segment: −(11 − 2)/0.30 = −30 V/m.' from version_ins
union all select gen_random_uuid(), id, 'C', '−2 V/m throughout', false, 'This uses only the net change from x = 0 to x = 0.50 m, −(11 − 10)/0.50. The potential has different slopes in the two segments, so the field differs between them.' from version_ins
union all select gen_random_uuid(), id, 'D', '+30 V/m for 0 < x < 0.20 m, then −40 V/m for 0.20 m < x < 0.50 m', false, 'This pairs the magnitudes with the wrong segments. The steep 8 V drop over 0.20 m gives +40 V/m in the first segment; the 9 V rise over 0.30 m has slope +30 V/m, so the field is −30 V/m in the second.' from version_ins;
-- apphycem-mcq-sv-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-006-v1', 'mcq', 'Field where the potential is constant', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a certain region of space the electric potential has the same value, 8.0 V, at every point. What is the electric field in that region?', null, md5('apphycem-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Zero', true, 'Field is related to the rate of change of V with position, E_x = −dV/dx. A constant potential has zero derivative everywhere, so E is zero even though V is not zero.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 V/m in the direction of increasing x', false, 'This sets the field equal to the potential value. E depends on how V changes with position, not on V itself, and V does not change here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nonzero and directed toward the lower-potential side', false, 'Direction toward lower potential applies only where V changes. With V constant there is no lower side, so no field exists.' from version_ins
union all select gen_random_uuid(), id, 'D', '−(8.0 V)/x, falling off with position', false, 'This treats the field as −V/x. The field is the negative derivative of V, which is zero when V does not vary.' from version_ins;
-- apphycem-mcq-sv-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-006-v2', 'mcq', 'Locating zero field from a potential function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The potential along the x-axis is V(x) = 4.0x² − 16x + 12, with V in volts and x in meters. At what position is E_x equal to zero?', null, md5('apphycem-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 1.0 m', false, 'This is the smaller root of V(x) = 0 (4x² − 16x + 12 = 0). The field is zero where dV/dx = 0, not where V = 0.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 2.0 m', true, 'E_x = −dV/dx = −(8.0x − 16). This is zero when 8.0x = 16, so x = 2.0 m, the minimum of V.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 4.0 m', false, 'This sets 4.0x − 16 = 0, forgetting the factor of 2 produced by differentiating 4.0x². The derivative is 8.0x − 16, which vanishes at x = 2.0 m.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0', false, 'This assumes the field vanishes at the origin. At x = 0, dV/dx = −16 V/m, so E_x = +16 V/m there.' from version_ins;
-- apphycem-mcq-sv-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '841a88cc-773c-44e5-97fa-6504f8667689', 'apphycem-mcq-sv-006-v3', 'mcq', 'Field between a maximum and a minimum of V', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A smooth potential V(x) has a local maximum at x = 1.0 m and a local minimum at x = 3.0 m, with no other stationary points between them. Which statement about E_x is correct?', null, md5('apphycem-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'E_x is zero at both points and negative between them', false, 'The sign between the points is wrong. With no other stationary points, V falls with increasing x from the maximum to the minimum, so dV/dx is negative and E_x = −dV/dx is positive there, not negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'E_x is most positive at x = 1.0 m and most negative at x = 3.0 m', false, 'This guesses that E_x peaks where V peaks and bottoms where V bottoms. Because E_x = −dV/dx and the slope of V is zero at both extrema, E_x is zero there; between them V decreases, so E_x is positive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'E_x is nonzero at both points because V is not zero there', false, 'Whether V is zero has no bearing on E. At both extremes the slope of V is zero, so E_x = 0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E_x is zero at both points and positive between them', true, 'At a maximum and a minimum dV/dx = 0, so E_x = 0 at both. Between them V decreases with x, so dV/dx < 0 and E_x = −dV/dx > 0.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and content_key = any (array['apphycem-mcq-sv-001-v1','apphycem-mcq-sv-001-v2','apphycem-mcq-sv-001-v3','apphycem-mcq-sv-005-v1','apphycem-mcq-sv-005-v2','apphycem-mcq-sv-005-v3','apphycem-mcq-sv-006-v1','apphycem-mcq-sv-006-v2','apphycem-mcq-sv-006-v3']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and ci.content_key = any (array['apphycem-mcq-sv-001-v1','apphycem-mcq-sv-001-v2','apphycem-mcq-sv-001-v3','apphycem-mcq-sv-005-v1','apphycem-mcq-sv-005-v2','apphycem-mcq-sv-005-v3','apphycem-mcq-sv-006-v1','apphycem-mcq-sv-006-v2','apphycem-mcq-sv-006-v3']))<>36 then raise exception 'chunk 1: choice rows'; end if;
end $$;
commit;
