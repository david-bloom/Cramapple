begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-002-v1','apphy2-mcq-sv-002-v2','apphy2-mcq-sv-002-v3','apphy2-mcq-sv-003-v1','apphy2-mcq-sv-003-v2','apphy2-mcq-sv-003-v3','apphy2-mcq-sv-004-v1','apphy2-mcq-sv-004-v2','apphy2-mcq-sv-004-v3','apphy2-mcq-sv-005-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy2-mcq-sv-002-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-002-v1', 'mcq', 'Gas compressed in a water bath', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of ideal gas in a cylinder is slowly compressed by a piston while the cylinder sits in a large water bath that keeps the gas at a constant temperature. What is the change in the gas''s internal energy during the compression?', null, md5('apphy2-mcq-sv-002-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Zero', true, 'The internal energy of an ideal gas depends only on its temperature (for a monatomic gas U = 3/2 nRT). The temperature is constant, so ΔU = 0 even though work is done on the gas and energy leaves it as heat.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Negative, because the gas gives energy to the water', false, 'The gas does release energy as heat, but the piston supplies an equal amount as work. The two cancel, and with constant temperature ΔU stays at zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Equal to the work done on the gas', false, 'That would require Q = 0, which is an adiabatic process. In this isothermal compression heat flows out to the bath, so ΔU = 0 while W is nonzero.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Positive, because the piston does work on the gas', false, 'Work done on the gas does add energy, but here the water bath removes exactly as much energy as heat as the piston adds as work (Q = −W), so the net change is ΔU = Q + W = 0, not a positive value.' from version_ins;
-- apphy2-mcq-sv-002-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-002-v2', 'mcq', 'Heat absorbed in isothermal expansion', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of 2.0 mol of a monatomic ideal gas at 300 K expands slowly at constant temperature. During the expansion the gas does 1200 J of work on its surroundings. How much energy does the gas absorb as heat?', null, md5('apphy2-mcq-sv-002-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1200 J released', false, 'This takes the work done on the gas as +1200 J. The gas does the work, so W = −1200 J, and Q = ΔU − W = +1200 J, meaning energy flows in, not out.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 J, because the temperature does not change', false, 'A constant temperature means ΔU = 0, not Q = 0. Q = 0 is the adiabatic case. Here the gas must absorb 1200 J to replace the energy it gives up as work.' from version_ins
union all select gen_random_uuid(), id, 'C', '7500 J absorbed', false, 'This evaluates 3/2 nRT = 1.5 × 2.0 × 8.31 × 300 ≈ 7500 J, the total internal energy, rather than a change. The internal energy does not change here, so Q equals the work done by the gas, 1200 J.' from version_ins
union all select gen_random_uuid(), id, 'D', '1200 J absorbed', true, 'Temperature is constant, so ΔU = 0. By the first law ΔU = Q + W with W = −1200 J (work done on the gas is negative when the gas expands), so Q = +1200 J: the gas absorbs 1200 J.' from version_ins;
-- apphy2-mcq-sv-002-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-002-v3', 'mcq', 'Internal energy change when expanding at constant pressure', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A monatomic ideal gas expands slowly at a constant pressure of 1.0 × 10⁵ Pa from 0.020 m³ to 0.060 m³. What is the change in the gas''s internal energy?', null, md5('apphy2-mcq-sv-002-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+10000 J', false, 'This is the heat absorbed, Q = ΔU + W = 6000 + 4000 = 10000 J, not the change in internal energy. ΔU is only the 6000 J part that raises the temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', '+4000 J', false, 'This is the work done by the gas, PΔV = (1.0 × 10⁵)(0.040) = 4000 J. Internal energy for a monatomic gas is 3/2 PV, so ΔU is 1.5 times that work.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 J, because the gas is ideal', false, 'Only an isothermal process leaves an ideal gas''s internal energy unchanged. Here PV triples, so T triples and ΔU = 3/2 nRΔT is positive.' from version_ins
union all select gen_random_uuid(), id, 'D', '+6000 J', true, 'For a monatomic ideal gas U = 3/2 nRT = 3/2 PV, so at constant pressure ΔU = 3/2 PΔV = 1.5 × (1.0 × 10⁵)(0.040) = 6000 J. The temperature triples, so internal energy rises.' from version_ins;
-- apphy2-mcq-sv-003-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-003-v1', 'mcq', 'Cooling coffee', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cup of hot coffee left on a table cools to room temperature, and the room air warms by a tiny amount. Energy never flows spontaneously the other way, from the cooler air into the hotter coffee. What best explains this?', null, md5('apphy2-mcq-sv-003-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The coffee''s own entropy can never decrease, and cooling lowers it', false, 'The coffee is not isolated. Its entropy does decrease as it loses energy, and that is allowed because the entropy of the air rises by more. Only the total must not decrease.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The reverse flow would lower the combined entropy of the coffee and the air', true, 'The second law says the entropy of an isolated system does not decrease. Energy spreading from hot to cold raises the combined entropy; energy flowing the other way would concentrate it and lower the total, so it does not happen spontaneously.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The reverse flow would fail to conserve the total energy', false, 'Energy would be conserved in either direction: what the coffee gains the air loses. Conservation of energy does not pick a direction; the entropy change does.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Energy can spread out only in processes that are fully reversible', false, 'Entropy increases most clearly in irreversible processes such as heat flow across a temperature difference. Total entropy stays constant only when every process is reversible.' from version_ins;
-- apphy2-mcq-sv-003-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-003-v2', 'mcq', 'Two blocks reaching equilibrium', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A copper block at 80°C and a copper block at 20°C are placed in contact inside a sealed, insulated box and left until their temperatures match. Which statement about the entropy of the two blocks together is correct?', null, md5('apphy2-mcq-sv-003-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It stayed constant, because the total energy is conserved', false, 'The total energy is constant, but entropy is a different quantity. Spreading energy across a temperature difference is irreversible, so the entropy rises.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It decreased, because the energy is now spread evenly', false, 'Even spreading is the more probable, higher-entropy state. Entropy measures the tendency of energy to disperse, so a more dispersed distribution means more entropy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It increased and is largest once the temperatures are equal', true, 'The box is isolated, so total entropy cannot decrease. Energy spreads from the hot block to the cold block until they are at the same temperature, which is the state of maximum entropy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It decreased in the hot block, so the total must have decreased', false, 'The hot block''s entropy does fall, but the cold block''s entropy rises by a larger amount. The total for the isolated pair increases.' from version_ins;
-- apphy2-mcq-sv-003-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-003-v3', 'mcq', 'Freezer making ice', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water in a tray at 15°C freezes into ice in a household freezer. The water''s entropy decreases as it loses energy. Which statement is consistent with the second law of thermodynamics?', null, md5('apphy2-mcq-sv-003-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The process is impossible, because no system''s entropy can ever decrease', false, 'Only an isolated system''s entropy cannot decrease. A system that exchanges energy with its surroundings can lose entropy if the surroundings gain at least as much.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The water''s entropy stays constant, because freezing is reversible', false, 'Freezing in a freezer is driven by a temperature difference and is not reversible. The water''s entropy does decrease, and the room''s rises by more.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The total entropy drops, because the freezer does work to remove energy', false, 'The electrical work does not reduce total entropy. The freezer releases more energy to the room than it removes, and the room''s entropy increase outweighs the water''s decrease.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The freezer''s surroundings gain entropy by at least as much as the water loses', true, 'The water and tray are not an isolated system. Energy leaving the water enters the room, and the room''s entropy gain is at least as large as the water''s loss, so the total entropy does not decrease.' from version_ins;
-- apphy2-mcq-sv-004-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-004-v1', 'mcq', 'Field from force on negative test charge', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A small test charge of −3.0 nC is placed at point P and feels an electric force of 9.0 × 10⁻⁶ N pointing west. What are the magnitude and direction of the electric field at P?', null, md5('apphy2-mcq-sv-004-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.7 × 10⁻¹⁴ N/C, east', false, 'This multiplies the force by the charge, 9.0 × 10⁻⁶ × 3.0 × 10⁻⁹. The field is the force divided by the charge.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.0 × 10³ N/C, east', true, 'The field is the force per unit charge, E = F/|q| = 9.0 × 10⁻⁶ / 3.0 × 10⁻⁹ = 3.0 × 10³ N/C. The field points the way a positive charge would be pushed, which is opposite to the force on this negative charge, so it points east.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.3 × 10⁻⁴ N/C, east', false, 'This divides the charge by the force, 3.0 × 10⁻⁹ / 9.0 × 10⁻⁶, inverting the ratio. The field is force divided by charge, which gives 3.0 × 10³ N/C.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.0 × 10³ N/C, west', false, 'The magnitude is right, but the field direction is defined by the force on a positive test charge. This test charge is negative, so the field is opposite to the force it feels.' from version_ins;
-- apphy2-mcq-sv-004-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-004-v2', 'mcq', 'Force on a charge in a downward field', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a region of uniform electric field of magnitude 400 N/C pointing straight up, a particle with charge −5.0 μC is placed at rest. What force does the field exert on the particle?', null, md5('apphy2-mcq-sv-004-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Zero, since the field acts only on positive charges', false, 'An electric field exerts a force on any charge. The force on a negative charge has the same magnitude as on a positive one but points opposite to the field.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 × 10⁷ N, downward', false, 'This divides the field by the charge, 400 / 5.0 × 10⁻⁶. Force is the product of charge and field.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.0 × 10⁻³ N, downward', true, 'The force on a charge is F = qE, so |F| = (5.0 × 10⁻⁶)(400) = 2.0 × 10⁻³ N. The field direction is the force direction on a positive charge, so a negative charge is pushed the opposite way, downward.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.0 × 10⁻³ N, upward', false, 'The magnitude is right, but a negative charge is pushed opposite to the field. The upward direction would apply to a positive charge.' from version_ins;
-- apphy2-mcq-sv-004-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-004-v3', 'mcq', 'Net field between opposite charges', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A +4.0 μC point charge and a −4.0 μC point charge sit 0.40 m apart on a horizontal line, with the positive charge on the left. What is the electric field at the midpoint between them? Use k = 9.0 × 10⁹ N·m²/C².', null, md5('apphy2-mcq-sv-004-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.8 × 10⁶ N/C, pointing right', true, 'Each charge is 0.20 m from the midpoint and produces a field of kq/r² = (9.0 × 10⁹)(4.0 × 10⁻⁶)/(0.20)² = 9.0 × 10⁵ N/C. The field points away from the positive charge and toward the negative one, both rightward, so the fields add to 1.8 × 10⁶ N/C.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.0 × 10⁵ N/C, pointing right', false, 'This is the field of only one of the two charges. Both charges contribute at the midpoint, and their equal rightward fields sum to twice this value.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Zero, because the charges have equal magnitudes', false, 'Cancellation happens for equal charges of the same sign. With opposite signs the individual fields at the midpoint point the same way, so they add.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.8 × 10⁶ N/C, pointing left', false, 'The magnitude is right, but the direction is reversed. The field points away from the positive charge on the left, so it points right toward the negative charge.' from version_ins;
-- apphy2-mcq-sv-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-005-v3', 'mcq', 'Separating a proton and an electron', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A proton and an electron are held 1.0 nm apart and then slowly pulled to 2.0 nm apart. What is the change in the electric potential energy of the pair? Use k = 8.99 × 10⁹ N·m²/C² and e = 1.6 × 10⁻¹⁹ C.', null, md5('apphy2-mcq-sv-005-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '+1.2 × 10⁻¹⁹ J', true, 'The pair energy is U = −ke²/r. At 1.0 nm it is −2.3 × 10⁻¹⁹ J and at 2.0 nm it is −1.15 × 10⁻¹⁹ J. Final minus initial is +1.2 × 10⁻¹⁹ J: the energy rises because opposite charges are pulled apart against attraction.' from version_ins
union all select gen_random_uuid(), id, 'B', '−2.3 × 10⁻¹⁹ J', false, 'This is the initial potential energy at 1.0 nm, not the change. The change is the final value (−1.15 × 10⁻¹⁹ J) minus the initial one.' from version_ins
union all select gen_random_uuid(), id, 'C', '−1.2 × 10⁻¹⁹ J', false, 'The potential energy gets less negative, not more. Its magnitude shrinks, but the value increases, so the change is positive. A positive amount of work is done pulling the attracting charges apart.' from version_ins
union all select gen_random_uuid(), id, 'D', '+2.3 × 10⁻¹⁹ J', false, 'This is ke²/Δr with Δr = 1.0 nm, which treats the change in separation as the distance in the formula. Potential energy depends on r itself, so the difference U(2.0 nm) − U(1.0 nm) must be taken.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-002-v1','apphy2-mcq-sv-002-v2','apphy2-mcq-sv-002-v3','apphy2-mcq-sv-003-v1','apphy2-mcq-sv-003-v2','apphy2-mcq-sv-003-v3','apphy2-mcq-sv-004-v1','apphy2-mcq-sv-004-v2','apphy2-mcq-sv-004-v3','apphy2-mcq-sv-005-v3']) and status='draft')<>10 then raise exception 'chunk 1: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.content_key = any (array['apphy2-mcq-sv-002-v1','apphy2-mcq-sv-002-v2','apphy2-mcq-sv-002-v3','apphy2-mcq-sv-003-v1','apphy2-mcq-sv-003-v2','apphy2-mcq-sv-003-v3','apphy2-mcq-sv-004-v1','apphy2-mcq-sv-004-v2','apphy2-mcq-sv-004-v3','apphy2-mcq-sv-005-v3']))<>40 then raise exception 'chunk 1: choice rows'; end if;
end $$;
commit;
