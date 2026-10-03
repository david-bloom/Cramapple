begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-023-v3','apphy2-mcq-sv-024-v1','apphy2-mcq-sv-024-v2','apphy2-mcq-sv-024-v3','apphy2-mcq-sv-025-v1','apphy2-mcq-sv-025-v2','apphy2-mcq-sv-025-v3','apphy2-mcq-sv-026-v1','apphy2-mcq-sv-026-v2','apphy2-mcq-sv-026-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy2-mcq-sv-023-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-023-v3', 'mcq', 'Free expansion of a gas', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gas fills the left half of an insulated rigid box, and the right half is a vacuum. A partition is removed and the gas spreads through the whole box with no energy entering or leaving. Which statement about this process is correct?', null, md5('apphy2-mcq-sv-023-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The entropy increases only if the gas does work on something while it expands', false, 'No work is needed. The expansion into the vacuum raises entropy even though the gas does no work and the system is isolated.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The entropy rises with no heat flow, and the gas will not spontaneously return to one half', true, 'The molecules can occupy many more arrangements after expanding, so entropy rises in this irreversible process. Entropy can increase without heat flow.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The entropy stays constant because no thermal energy is transferred into or out of the gas', false, 'Links entropy change only to energy transfer. Entropy also increases when energy or matter spreads out, as here, without any heat flow.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The entropy decreases because the gas ends up at a lower pressure than it began with', false, 'Confuses lower pressure with lower disorder. The gas has more accessible arrangements and the isolated system''s entropy can only increase or stay equal.' from version_ins;
-- apphy2-mcq-sv-024-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-024-v1', 'mcq', 'Charged ball touches neutral ball', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical metal balls on insulating stands carry charges of −8.0 nC and 0. The balls are touched together and then separated. What are the final charges on the two balls?', null, md5('apphy2-mcq-sv-024-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '−4.0 nC on each ball', true, 'Net charge is conserved at −8.0 nC. Identical conductors in contact reach the same potential, so each ball ends up with half the total, −4.0 nC.' from version_ins
union all select gen_random_uuid(), id, 'B', '−8.0 nC on each ball', false, 'Copies the charge onto the second ball, which would make the total −16 nC and violate conservation of charge.' from version_ins
union all select gen_random_uuid(), id, 'C', '−8.0 nC and 0, unchanged', false, 'Assumes touching does nothing. The balls form one conductor while touching, so electrons move until the charge is shared equally.' from version_ins
union all select gen_random_uuid(), id, 'D', '−4.0 nC and +4.0 nC', false, 'Has the neutral ball become oppositely charged. Contact between conductors shares charge of the same sign; the neutral ball cannot gain positive charge without a source for it, and the total would be 0 rather than −8.0 nC.' from version_ins;
-- apphy2-mcq-sv-024-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-024-v2', 'mcq', 'Opposite charges on contact', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical conducting spheres carry +9.0 nC and −3.0 nC. They are touched together and then separated. What is the charge on each sphere afterward?', null, md5('apphy2-mcq-sv-024-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+3.0 nC on each sphere', true, 'The total charge is +9.0 + (−3.0) = +6.0 nC and is conserved. Identical spheres share it equally, giving +3.0 nC each.' from version_ins
union all select gen_random_uuid(), id, 'B', '+6.0 nC on each sphere', false, 'Uses the net charge (+6.0 nC) as the charge on each sphere. That would make the total +12 nC, which violates charge conservation; the net must be divided between them.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 on each sphere', false, 'Assumes the opposite charges cancel completely. They cancel only if the magnitudes are equal; here +9.0 nC outweighs −3.0 nC, so +6.0 nC net remains.' from version_ins
union all select gen_random_uuid(), id, 'D', '+4.5 nC and −1.5 nC', false, 'Halves each charge separately and leaves them on their own spheres. Charges mix in contact, and the final charges are equal because the spheres are identical.' from version_ins;
-- apphy2-mcq-sv-024-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-024-v3', 'mcq', 'Sequential contacts with three spheres', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three identical conducting spheres X, Y and Z carry +12 nC, 0 and 0. X touches Y and they are separated. Then Y touches Z and they are separated. What are the final charges on X, Y and Z, in that order?', null, md5('apphy2-mcq-sv-024-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+6.0 nC, +6.0 nC, 0', false, 'Stops after the first contact. The second contact lets Y share its +6.0 nC with Z, so Z does not stay neutral.' from version_ins
union all select gen_random_uuid(), id, 'B', '+4.0 nC each', false, 'Divides the charge equally among all three spheres, as if all touched at once. The contacts happen in sequence, and X never touches Z.' from version_ins
union all select gen_random_uuid(), id, 'C', '+6.0 nC, +3.0 nC, +3.0 nC', true, 'First contact: X and Y share +12 nC, each keeping +6.0 nC. Second contact: Y and Z share Y''s +6.0 nC, each ending with +3.0 nC. X stays at +6.0 nC, and the total is still +12 nC.' from version_ins
union all select gen_random_uuid(), id, 'D', '+6.0 nC, +6.0 nC, +6.0 nC', false, 'Copies Y''s charge onto Z instead of dividing it, making the total +18 nC and violating conservation of charge.' from version_ins;
-- apphy2-mcq-sv-025-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-025-v1', 'mcq', 'Zero potential at a dipole midpoint', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two point charges, +4.0 nC and −4.0 nC, are fixed 0.20 m apart in vacuum. Taking the potential to be zero at infinite distance, what are the electric potential and the electric field at the point midway between them?', null, md5('apphy2-mcq-sv-025-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'V = 0; E ≈ 7.2×10³ N/C toward the positive charge', false, 'The magnitudes are right, but the direction is reversed. The field of a positive charge points away from it and the field of a negative charge points toward it, so at the midpoint the net field points toward the negative charge.' from version_ins
union all select gen_random_uuid(), id, 'B', 'V = 0; E = 0', false, 'Correctly cancels the potentials, but then carries the cancellation over to the field. The two fields point the same way at the midpoint (away from the positive charge and toward the negative charge), so they add rather than cancel.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V ≈ 7.2×10² V; E = 0', false, 'Gets both quantities wrong. It adds the magnitudes of the two potentials (359.6 + 359.6 V) and ignores the negative charge''s sign, then cancels the fields as if they were scalars. Potentials add with sign (giving 0 here) and the fields add as vectors (giving a nonzero total).' from version_ins
union all select gen_random_uuid(), id, 'D', 'V = 0; E ≈ 7.2×10³ N/C toward the negative charge', true, 'Each charge is 0.10 m away. Potential is a scalar, so the +359.6 V and −359.6 V contributions sum to zero. The field is a vector: each charge contributes kq/r² ≈ 3.6×10³ N/C, and both point toward the negative charge, so they add to ≈ 7.2×10³ N/C. Zero potential here does not mean zero field.' from version_ins;
-- apphy2-mcq-sv-025-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-025-v2', 'mcq', 'Field where the potential crosses zero', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a region where the electric field is uniform and points along the x-axis, the potential is +20 V at x = 3.0 cm and −20 V at x = 5.0 cm. What is the electric field at x = 4.0 cm, where the potential is zero?', null, md5('apphy2-mcq-sv-025-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.0×10³ V/m in the +x direction', true, 'The field magnitude is the potential difference divided by the separation: 40 V / 0.020 m = 2.0×10³ V/m. The field points toward decreasing potential, which is +x here. The zero value of potential at x = 4.0 cm plays no role.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.0×10³ V/m in the +x direction', false, 'Divides a single potential value (20 V) by the 2.0 cm separation instead of using the full potential difference of 40 V between the points. The field magnitude is |ΔV|/Δr = 40 V / 0.020 m.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 V/m', false, 'Treats the zero value of the potential at x = 4.0 cm as if it meant no field. The field depends on how fast the potential changes with position (40 V over 2.0 cm), not on the potential value at the point.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.0×10³ V/m in the −x direction', false, 'The magnitude is right but the direction is wrong. Electric field vectors point toward decreasing potential, and the potential falls from +20 V to −20 V as x increases, so the field points in +x.' from version_ins;
-- apphy2-mcq-sv-025-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-025-v3', 'mcq', 'Zero potential between unequal charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A +6.0 nC point charge is fixed at x = 0 and a −2.0 nC point charge is fixed at x = 0.40 m. Taking the potential to be zero at infinite distance, at what position between the charges is the potential zero, and what is the electric field there?', null, md5('apphy2-mcq-sv-025-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'x = 0.30 m; E ≈ 1.2×10³ N/C toward −x', false, 'Finds x = 0.30 m but subtracts the two field magnitudes as if the fields opposed each other. Between a positive and a negative charge both fields point from the positive toward the negative charge (+x), so they add.' from version_ins
union all select gen_random_uuid(), id, 'B', 'x = 0.20 m; E ≈ 1.8×10³ N/C toward +x', false, 'Assumes the zero-potential point is the midpoint. The charges differ in magnitude, so the potentials 6.0/x and 2.0/(0.40 − x) cancel only where the point is closer to the smaller charge, at x = 0.30 m. At the midpoint V is not zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'x = 0.30 m; E = 0', false, 'Finds the zero-potential point correctly but concludes that the field vanishes there. The two fields both point toward +x at this location and add; zero potential only means the scalar contributions cancel.' from version_ins
union all select gen_random_uuid(), id, 'D', 'x = 0.30 m; E ≈ 2.4×10³ N/C toward +x', true, 'Setting 6.0/x = 2.0/(0.40 − x) gives x = 0.30 m. There the +6.0 nC charge (0.30 m away) contributes ≈ 6.0×10² N/C toward +x and the −2.0 nC charge (0.10 m away) contributes ≈ 1.8×10³ N/C toward +x. The fields add to ≈ 2.4×10³ N/C, so zero potential does not give zero field.' from version_ins;
-- apphy2-mcq-sv-026-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-026-v1', 'mcq', 'Proton accelerated through 500 V', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A proton starts from rest and is accelerated by the electric force alone through a potential difference of magnitude 500 V. How much kinetic energy does it gain?', null, md5('apphy2-mcq-sv-026-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.0×10⁻¹⁷ J', true, 'The proton moves toward lower potential, so its potential energy falls by |q|ΔV = (1.6×10⁻¹⁹ C)(500 V) = 8.0×10⁻¹⁷ J. By conservation of energy that is the kinetic energy gained.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.6×10⁻¹⁹ J', false, 'Uses the proton''s charge alone and never multiplies by the 500 V. The energy gained is charge times potential difference, which is 500 eV.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.0×10⁻¹⁷ J', false, 'Puts a factor of 1/2 into the answer, carried over from K = ½mv². The energy gained equals the full change in electric potential energy, |q|ΔV.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.6×10⁻¹⁶ J', false, 'Includes an extra factor of 2. The electric potential energy lost is |q|ΔV = 8.0×10⁻¹⁷ J, and nothing doubles it.' from version_ins;
-- apphy2-mcq-sv-026-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-026-v2', 'mcq', 'Electron speed after 250 V', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An electron starts from rest and is accelerated by the electric force alone through a potential difference of magnitude 250 V. Using e = 1.60×10⁻¹⁹ C and m = 9.11×10⁻³¹ kg, what is its final speed?', null, md5('apphy2-mcq-sv-026-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.3×10⁷ m/s', false, 'Takes the kinetic energy to be 2eΔV, giving v = √(4eΔV/m). The energy gained is eΔV, with no extra factor of two.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.7×10⁶ m/s', false, 'Makes an algebra slip when solving ½mv² = eΔV: it writes v² = eΔV/(2m), leaving the ½ on the wrong side of the equation. The correct step is v² = 2eΔV/m.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.6×10⁶ m/s', false, 'Sets eΔV = mv², dropping the ½ from the kinetic-energy expression. That gives √(eΔV/m) instead of √(2eΔV/m).' from version_ins
union all select gen_random_uuid(), id, 'D', '9.4×10⁶ m/s', true, 'The kinetic energy gained is eΔV = 4.0×10⁻¹⁷ J. Setting ½mv² = eΔV gives v = √(2eΔV/m) = √(8.0×10⁻¹⁷ / 9.11×10⁻³¹) ≈ 9.4×10⁶ m/s.' from version_ins;
-- apphy2-mcq-sv-026-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-026-v3', 'mcq', 'Electron moving to higher potential', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An electron is released from rest at a point where the electric potential is +40 V. With only the electric force acting, it moves to a point where the potential is +140 V. What are the change in the electron''s electric potential energy and its final kinetic energy?', null, md5('apphy2-mcq-sv-026-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ΔU = +1.6×10⁻¹⁷ J; K = +1.6×10⁻¹⁷ J', false, 'Uses a positive charge in ΔU = qΔV. The electron''s charge is −e, so ΔU is negative here. Potential energy and kinetic energy cannot both increase when only the electric force acts.' from version_ins
union all select gen_random_uuid(), id, 'B', 'ΔU = −2.2×10⁻¹⁷ J; K = +2.2×10⁻¹⁷ J', false, 'Uses the final potential (140 V) instead of the potential difference. Only the change, 140 − 40 = 100 V, enters ΔU = qΔV.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ΔU = −1.6×10⁻¹⁷ J; K = +1.6×10⁻¹⁷ J', true, 'ΔV = 140 − 40 = +100 V and q = −e, so ΔU = qΔV = −1.6×10⁻¹⁷ J. Negative charges lose potential energy by moving to higher potential. Conservation of energy gives K = −ΔU = +1.6×10⁻¹⁷ J.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ΔU = −1.6×10⁻¹⁷ J; K = −1.6×10⁻¹⁷ J', false, 'Gets ΔU right but sets K equal to ΔU. Kinetic energy gained is ΔK = −ΔU, and an electron starting from rest cannot end with negative kinetic energy.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-023-v3','apphy2-mcq-sv-024-v1','apphy2-mcq-sv-024-v2','apphy2-mcq-sv-024-v3','apphy2-mcq-sv-025-v1','apphy2-mcq-sv-025-v2','apphy2-mcq-sv-025-v3','apphy2-mcq-sv-026-v1','apphy2-mcq-sv-026-v2','apphy2-mcq-sv-026-v3']) and status='draft')<>10 then raise exception 'chunk 4: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.content_key = any (array['apphy2-mcq-sv-023-v3','apphy2-mcq-sv-024-v1','apphy2-mcq-sv-024-v2','apphy2-mcq-sv-024-v3','apphy2-mcq-sv-025-v1','apphy2-mcq-sv-025-v2','apphy2-mcq-sv-025-v3','apphy2-mcq-sv-026-v1','apphy2-mcq-sv-026-v2','apphy2-mcq-sv-026-v3']))<>40 then raise exception 'chunk 4: choice rows'; end if;
end $$;
commit;
