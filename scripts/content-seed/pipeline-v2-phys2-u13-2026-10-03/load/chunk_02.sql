begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-006-v1','apphy2-mcq-sv-006-v2','apphy2-mcq-sv-006-v3','apphy2-mcq-sv-007-v1','apphy2-mcq-sv-007-v2','apphy2-mcq-sv-007-v3','apphy2-mcq-sv-008-v1','apphy2-mcq-sv-008-v2','apphy2-mcq-sv-008-v3','apphy2-mcq-sv-009-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy2-mcq-sv-006-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-006-v1', 'mcq', 'Two equal negative charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical negative point charges are placed one directly above the other on a vertical line. At the midpoint between them, the electric field is', null, md5('apphy2-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'directed away from both charges, toward the sides', false, 'Fields of negative charges point toward the charges, and at the midpoint they point along the vertical line, not sideways. They also cancel there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'twice the field of a single charge, directed upward', false, 'This adds the magnitudes as if both fields pointed the same way. They point toward opposite charges, so they subtract to zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'zero', true, 'Each charge produces a field of the same magnitude at the midpoint, directed toward that charge because the charges are negative. The two fields point in opposite directions and cancel, so the net field is zero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'directed toward the upper charge', false, 'The upper charge''s field does point toward it, but the lower charge''s field of equal size points toward the lower charge. The two cancel rather than one winning.' from version_ins;
-- apphy2-mcq-sv-006-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-006-v2', 'mcq', 'Zero-field point between unequal charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A +Q point charge and a +4Q point charge are fixed 0.90 m apart on a line. At what distance from the +Q charge, between the two charges, is the net electric field zero?', null, md5('apphy2-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.60 m', false, 'A point 0.60 m from the +Q charge is only 0.30 m from the +4Q charge, where the stronger charge''s field is far larger. The null point has to lie nearer the weaker charge.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.30 m', true, 'Between like charges the fields point in opposite directions. Setting kQ/x² = k(4Q)/(0.90 − x)² gives (0.90 − x) = 2x, so x = 0.30 m, closer to the smaller charge.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.45 m', false, 'The midpoint would work only for equal charges. With +4Q on one side, its field at the midpoint is four times stronger and the net field is not zero there.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.18 m', false, 'This makes the field vary as 1/r, giving x/(0.90 − x) = 1/4. The field falls as 1/r², so the distance ratio is 1 : 2, not 1 : 4.' from version_ins;
-- apphy2-mcq-sv-006-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-006-v3', 'mcq', 'Field on the perpendicular bisector', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical +2.0 μC point charges lie on the x-axis at x = −0.30 m and x = +0.30 m. What is the net electric field at the point (0, +0.40 m)? Use k = 9.0 × 10⁹ N·m²/C².', null, md5('apphy2-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.6 × 10⁴ N/C, pointing in the +y direction', false, 'This uses the factor 0.30/0.50 (the x-over-hypotenuse ratio) for the y component. The y component uses 0.40/0.50, giving 1.15 × 10⁵ N/C.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Zero, because the charges are identical', false, 'Symmetry cancels only the components along the x-axis. The y components both point away from the charges, upward, and add.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.2 × 10⁵ N/C, pointing in the +y direction', true, 'Each charge is 0.50 m away and produces kq/r² = 7.2 × 10⁴ N/C. The x components cancel by symmetry. Each y component is 7.2 × 10⁴ × (0.40/0.50) = 5.76 × 10⁴ N/C, so the net field is 1.15 × 10⁵ ≈ 1.2 × 10⁵ N/C along +y.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.4 × 10⁵ N/C, pointing in the +y direction', false, 'This adds the two full magnitudes, 2 × 7.2 × 10⁴. The fields are not parallel at this point, so only their y components, which are 0.80 of each magnitude, add.' from version_ins;
-- apphy2-mcq-sv-007-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-007-v1', 'mcq', 'Two resistors in parallel', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two resistors, 4.0 Ω and 12 Ω, are connected in parallel. What is their equivalent resistance?', null, md5('apphy2-mcq-sv-007-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.0 Ω', false, 'This averages the two resistances. Parallel combinations are found with reciprocals, and the result must be smaller than either resistor.' from version_ins
union all select gen_random_uuid(), id, 'B', '48 Ω', false, 'This multiplies the resistances. The product over the sum, 48/16, would give the answer; the product alone has the wrong units and size.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.0 Ω', true, 'For parallel resistors 1/R = 1/4.0 + 1/12 = 3/12 + 1/12 = 4/12, so R = 3.0 Ω. This is less than the smaller resistor, as expected when a second path is added.' from version_ins
union all select gen_random_uuid(), id, 'D', '16 Ω', false, 'This is the series sum. In parallel the charge can take either branch, so the equivalent resistance is less than 4.0 Ω.' from version_ins;
-- apphy2-mcq-sv-007-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-007-v2', 'mcq', 'Three parallel resistors', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three resistors of 10 Ω, 15 Ω and 30 Ω are connected in parallel across a battery. What is their equivalent resistance?', null, md5('apphy2-mcq-sv-007-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.0 Ω', true, '1/R = 1/10 + 1/15 + 1/30 = 3/30 + 2/30 + 1/30 = 6/30, so R = 5.0 Ω, smaller than every individual resistor.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.20 Ω', false, 'The sum of reciprocals is 6/30 = 0.20 S, but that is the reciprocal of the resistance. It must be inverted to get 5.0 Ω.' from version_ins
union all select gen_random_uuid(), id, 'C', '55 Ω', false, 'This adds the three resistances, which gives the series combination. Parallel branches give a smaller equivalent resistance than any single resistor.' from version_ins
union all select gen_random_uuid(), id, 'D', '18 Ω', false, 'This averages the three resistances (55/3 ≈ 18). A parallel combination is not an average, and it must be below the smallest resistor, 10 Ω.' from version_ins;
-- apphy2-mcq-sv-007-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-007-v3', 'mcq', 'Series-parallel network', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6.0 Ω resistor is connected in series with a parallel pair made of a 6.0 Ω resistor and a 3.0 Ω resistor. What is the equivalent resistance of the whole network?', null, md5('apphy2-mcq-sv-007-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15 Ω', false, 'This adds all three resistors as if they were in series. The two resistors in the pair share the current between two paths, so their combined resistance is lower.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 Ω', true, 'The parallel pair gives 1/R = 1/6.0 + 1/3.0 = 1/2.0, so R = 2.0 Ω. This is in series with the 6.0 Ω resistor, so R_eq = 6.0 + 2.0 = 8.0 Ω.' from version_ins
union all select gen_random_uuid(), id, 'C', '10.5 Ω', false, 'This averages the pair as 4.5 Ω and adds 6.0 Ω. The pair''s equivalent resistance comes from reciprocals and is 2.0 Ω.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.5 Ω', false, 'This puts all three resistors in parallel: 1/6 + 1/6 + 1/3 = 2/3. The 6.0 Ω resistor is in series with the pair, not parallel to it.' from version_ins;
-- apphy2-mcq-sv-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-008-v1', 'mcq', 'Heating coil resistance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A heating coil plugged into a 120 V outlet carries a steady 5.0 A current. What is the resistance of the coil?', null, md5('apphy2-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '115 Ω', false, 'Subtracts the current from the voltage, 120 − 5.0 = 115. Ohm''s law relates the quantities by division, not subtraction, so R = 120/5.0 = 24 Ω.' from version_ins
union all select gen_random_uuid(), id, 'B', '600 Ω', false, 'Multiplies voltage by current, 120 × 5.0 = 600. That product is the power in watts (P = IΔV), not the resistance.' from version_ins
union all select gen_random_uuid(), id, 'C', '24 Ω', true, 'Ohm''s law gives R = ΔV/I = 120 V / 5.0 A = 24 Ω.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.042 Ω', false, 'Divides current by voltage, 5.0/120 = 0.042, which is the inverse of the resistance. Resistance is the potential difference divided by the current: 120/5.0 = 24 Ω.' from version_ins;
-- apphy2-mcq-sv-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-008-v2', 'mcq', 'Current through a resistor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 45 Ω resistor is connected across the terminals of an ideal 9.0 V battery. What is the current in the resistor?', null, md5('apphy2-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '405 A', false, 'Multiplies voltage by resistance, 9.0 × 45 = 405. Solving ΔV = IR for I requires dividing both sides by R, so I = ΔV/R = 0.20 A; the product of voltage and resistance has no meaning as a current.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.0 A', false, 'Divides resistance by voltage, 45/9.0 = 5.0, which is the inverse of the current. Current is the potential difference divided by the resistance: 9.0/45 = 0.20 A.' from version_ins
union all select gen_random_uuid(), id, 'C', '36 A', false, 'Subtracts the voltage from the resistance, 45 − 9.0 = 36. Ohm''s law uses a ratio, not a difference, so I = 9.0/45 = 0.20 A.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.20 A', true, 'Ohm''s law gives I = ΔV/R = 9.0 V / 45 Ω = 0.20 A.' from version_ins;
-- apphy2-mcq-sv-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-008-v3', 'mcq', 'Ohmic resistor at higher voltage', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An ohmic resistor carries 0.30 A when the potential difference across it is 1.5 V. What current does it carry when the potential difference across it is raised to 6.0 V?', null, md5('apphy2-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.8 A', false, 'Adds the 4.5 V increase to the old current as if the quantities add: 0.30 + 4.5 = 4.8. Current scales by the same factor as the voltage (6.0/1.5 = 4), giving 1.2 A.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.30 A', false, 'Assumes the current stays fixed when the voltage changes. With constant resistance, quadrupling the potential difference quadruples the current.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.2 A', true, 'An ohmic resistor has constant resistance, R = 1.5 V / 0.30 A = 5.0 Ω. At 6.0 V the current is I = 6.0/5.0 = 1.2 A, so current is directly proportional to potential difference.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.075 A', false, 'Treats current as inversely proportional to voltage, 0.30 × 1.5/6.0 = 0.075 A. For an ohmic resistor I = ΔV/R, so a larger potential difference gives a larger current.' from version_ins;
-- apphy2-mcq-sv-009-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-009-v1', 'mcq', 'Initial current into capacitor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 12 V battery, a 400 Ω resistor, a switch and an uncharged 50 μF capacitor are connected in series. Just after the switch is closed, what is the current in the circuit?', null, md5('apphy2-mcq-sv-009-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Very large, because nothing in the circuit limits the current', false, 'Correctly sees the capacitor offers no opposition, but forgets that the resistor is still in series with it. The 400 Ω resistor limits the current to 12/400 = 30 mA.' from version_ins
union all select gen_random_uuid(), id, 'B', '30 mA', true, 'An uncharged capacitor has zero potential difference across it, so at this instant it acts like a wire and the full 12 V appears across the resistor: I = 12 V / 400 Ω = 0.030 A = 30 mA.' from version_ins
union all select gen_random_uuid(), id, 'C', '15 mA', false, 'Assumes the capacitor takes half of the battery voltage at the start. An uncharged capacitor has no potential difference across it, so the resistor gets all 12 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 mA', false, 'Treats the capacitor as a gap in the circuit. That describes the capacitor after a long time, when it is fully charged and the current has stopped, not the first instant.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-006-v1','apphy2-mcq-sv-006-v2','apphy2-mcq-sv-006-v3','apphy2-mcq-sv-007-v1','apphy2-mcq-sv-007-v2','apphy2-mcq-sv-007-v3','apphy2-mcq-sv-008-v1','apphy2-mcq-sv-008-v2','apphy2-mcq-sv-008-v3','apphy2-mcq-sv-009-v1']) and status='draft')<>10 then raise exception 'chunk 2: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.content_key = any (array['apphy2-mcq-sv-006-v1','apphy2-mcq-sv-006-v2','apphy2-mcq-sv-006-v3','apphy2-mcq-sv-007-v1','apphy2-mcq-sv-007-v2','apphy2-mcq-sv-007-v3','apphy2-mcq-sv-008-v1','apphy2-mcq-sv-008-v2','apphy2-mcq-sv-008-v3','apphy2-mcq-sv-009-v1']))<>40 then raise exception 'chunk 2: choice rows'; end if;
end $$;
commit;
