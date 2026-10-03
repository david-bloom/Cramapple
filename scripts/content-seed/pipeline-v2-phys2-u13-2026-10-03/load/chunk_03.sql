begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-009-v2','apphy2-mcq-sv-009-v3','apphy2-mcq-sv-021-v1','apphy2-mcq-sv-021-v2','apphy2-mcq-sv-021-v3','apphy2-mcq-sv-022-v1','apphy2-mcq-sv-022-v2','apphy2-mcq-sv-022-v3','apphy2-mcq-sv-023-v1','apphy2-mcq-sv-023-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy2-mcq-sv-009-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-009-v2', 'mcq', 'Resistor voltage after long time', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An uncharged capacitor in series with a resistor is connected to an ideal 9.0 V battery. After a time much longer than the time constant, what is the potential difference across the resistor?', null, md5('apphy2-mcq-sv-009-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 V', false, 'Adds the capacitor''s final 9.0 V to the original 9.0 V across the resistor. The loop rule requires the two potential differences to sum to the battery''s 9.0 V, so they can never total 18 V.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.0 V', false, 'This is the resistor''s voltage at the first instant, when the uncharged capacitor acts like a wire. After a long time the current has dropped to zero, so the resistor no longer has a potential difference.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.5 V', false, 'Splits the battery voltage equally between the two elements, as if they shared it for every time. The split changes with time and ends with the capacitor at 9.0 V and the resistor at 0 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '0 V', true, 'After a long time the capacitor is fully charged and carries no current. With zero current, the resistor has ΔV = IR = 0, and the capacitor holds all 9.0 V.' from version_ins;
-- apphy2-mcq-sv-009-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-009-v3', 'mcq', 'Discharge current at start', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 50 μF capacitor charged to 20 V is connected at t = 0 across a 2.0 kΩ resistor. What is the current in the resistor immediately after the connection is made?', null, md5('apphy2-mcq-sv-009-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.7 mA', false, 'Applies the 37% discharge fraction to the initial current. That fraction is the value reached after one time constant, not the value at t = 0, when the current is the full 10 mA.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 mA', false, 'Treats the charged capacitor as an open circuit that blocks current. A capacitor behaves that way only in the steady state of charging; here its stored potential difference drives current through the resistor.' from version_ins
union all select gen_random_uuid(), id, 'C', '10 mA', true, 'At t = 0 the capacitor still has its full 20 V, so it acts like a 20 V source across the resistor: I = 20 V / 2.0 kΩ = 10 mA.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.3 mA', false, 'Applies the 63% charging fraction to the initial current. The time-constant percentages describe how charge changes over one time constant, not the current at t = 0, which is the maximum value of 10 mA.' from version_ins;
-- apphy2-mcq-sv-021-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-021-v1', 'mcq', 'Tripling gas in a rigid tank', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Extra helium is pumped into a rigid sealed tank held at constant temperature until it contains three times as many atoms as before. The gas pressure becomes', null, md5('apphy2-mcq-sv-021-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'unchanged, because the tank volume does not change', false, 'Assumes pressure depends only on volume. Pressure also depends on how many atoms strike the walls, so adding atoms at fixed V and T raises it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'nine times the original', false, 'Squares the factor of three. The ideal gas law is linear in N, so the pressure changes by exactly the factor 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'three times the original', true, 'With V and T fixed, PV = Nk_BT shows P is directly proportional to N, so tripling N triples the pressure.' from version_ins
union all select gen_random_uuid(), id, 'D', 'one-third of the original', false, 'Takes pressure to be inversely proportional to the number of atoms. At fixed volume and temperature, more atoms means more wall collisions, so the pressure rises.' from version_ins;
-- apphy2-mcq-sv-021-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-021-v2', 'mcq', 'Heating a sealed gas sample', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sealed rigid flask of ideal gas at 27 °C has a pressure of 2.0 atm. The flask is heated to 177 °C. What is the new pressure?', null, md5('apphy2-mcq-sv-021-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.5 atm', false, 'Squares the temperature ratio, 2.0 × (450/300)² = 4.5. Pressure is directly proportional to T, not to T².' from version_ins
union all select gen_random_uuid(), id, 'B', '1.3 atm', false, 'Inverts the temperature ratio, 2.0 × 300/450 = 1.3. Heating a fixed amount of gas in a rigid flask increases the pressure, it does not decrease it.' from version_ins
union all select gen_random_uuid(), id, 'C', '13 atm', false, 'Uses the Celsius temperatures in the ratio: 2.0 × 177/27 = 13. The ideal gas law requires absolute (kelvin) temperature.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.0 atm', true, 'At constant V and N, P is proportional to the kelvin temperature. Converting with T = T_C + 273, T rises from 27 + 273 = 300 K to 177 + 273 = 450 K, so P = 2.0 atm × 450/300 = 3.0 atm.' from version_ins;
-- apphy2-mcq-sv-021-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-021-v3', 'mcq', 'Compressing a leaking gas', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gas sample is compressed to one-third of its original volume at constant temperature while half of its molecules leak out through a valve. The final pressure compared with the original pressure is', null, md5('apphy2-mcq-sv-021-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'one-sixth as large', false, 'Multiplies N and V factors instead of dividing: (1/2)(1/3) = 1/6. Pressure is proportional to N divided by V, so a smaller volume raises it.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.5 times as large', true, 'P = Nk_BT/V, so P scales with N/V at fixed T. The factor is (1/2)/(1/3) = 1.5.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.0 times as large', false, 'Treats the loss of half the molecules as if it doubled the pressure, 3 × 2 = 6. Removing molecules reduces the number of wall collisions, so it lowers the pressure.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.0 times as large', false, 'Accounts for the compression (factor 3) but forgets that half the molecules left. Losing half the molecules cuts the pressure by half, giving 3 × 1/2 = 1.5.' from version_ins;
-- apphy2-mcq-sv-022-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-022-v1', 'mcq', 'Doubled temperature difference', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical copper bars have the same length and cross-section. One bar has a 40 K temperature difference between its ends and the other has an 80 K difference. How does the steady conduction rate in the second bar compare with that in the first?', null, md5('apphy2-mcq-sv-022-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'half as large', false, 'Reverses the dependence, as if a larger temperature difference slowed the transfer. Energy flows faster when the temperature difference is larger.' from version_ins
union all select gen_random_uuid(), id, 'B', 'twice as large', true, 'The conduction rate kAΔT/L is directly proportional to ΔT when k, A and L are equal, so doubling ΔT doubles the rate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'the same, because the bars are made of the same copper', false, 'Notes that k is equal but ignores that ΔT differs. The rate depends on ΔT as well as on k, so the two rates are not equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'four times as large', false, 'Squares the factor of two. Conduction rate is linear in ΔT, not quadratic.' from version_ins;
-- apphy2-mcq-sv-022-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-022-v2', 'mcq', 'Thicker glass pane', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A window pane loses thermal energy by conduction at a steady rate. It is replaced by a pane of the same glass and area that is twice as thick, with the same temperatures on its two faces. The new conduction rate is', null, md5('apphy2-mcq-sv-022-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'one-fourth as large as before', false, 'Squares the effect of thickness. The dependence on L is inverse to the first power, giving a factor of 1/2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'twice as large as before', false, 'Treats thickness as if it were directly proportional to the rate, the way area is. Thickness is in the denominator, so more thickness slows the conduction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'half as large as before', true, 'Rate = kAΔT/L, so the rate is inversely proportional to thickness L. Doubling L halves the rate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'unchanged, because the glass and temperatures are the same', false, 'Overlooks that the rate also depends on the length of the conduction path. Material and temperature difference match, but the thickness differs.' from version_ins;
-- apphy2-mcq-sv-022-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-022-v3', 'mcq', 'Comparing two rods', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Rod X has thermal conductivity k, cross-sectional area A and length L. Rod Y has thermal conductivity 3k, cross-sectional area A/2 and length 3L. Both have the same temperature difference between their ends. The steady conduction rate in Y compared with X is', null, md5('apphy2-mcq-sv-022-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'the same', false, 'Cancels the factor 3 in k against the factor 3 in L but forgets to include the halved area, which still halves the rate.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.5 times as large', false, 'Multiplies by the length factor instead of dividing: 3 × 3 × 1/2 = 4.5. Length is in the denominator of kAΔT/L.' from version_ins
union all select gen_random_uuid(), id, 'C', 'half as large', true, 'Rate is proportional to kA/L. For Y this is (3k)(A/2)/(3L) = (1/2)(kA/L), which is half the rate in X.' from version_ins
union all select gen_random_uuid(), id, 'D', 'twice as large', false, 'Inverts the overall ratio, 2 instead of 1/2. Greater length and smaller area both lower the rate, and together they outweigh the extra conductivity.' from version_ins;
-- apphy2-mcq-sv-023-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-023-v1', 'mcq', 'Ice melting in warm water', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An ice cube is dropped into warm water inside a perfectly insulated container. The system eventually reaches a uniform temperature with the ice melted. Over the whole process, the total entropy of the contents', null, md5('apphy2-mcq-sv-023-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'stays constant, because the total energy is conserved', false, 'Confuses conservation of energy with conservation of entropy. Energy is conserved here, but entropy is not conserved in an irreversible process; it increases.' from version_ins
union all select gen_random_uuid(), id, 'B', 'decreases, because the ice becomes liquid water at a single temperature', false, 'Equates uniformity with order. Reaching a uniform temperature is the maximum-entropy state, and the isolated system''s total entropy cannot decrease.' from version_ins
union all select gen_random_uuid(), id, 'C', 'increases', true, 'The system is isolated and goes irreversibly toward thermal equilibrium, where entropy is greatest. Energy spreads from the warm water into the ice, so total entropy increases.' from version_ins
union all select gen_random_uuid(), id, 'D', 'decreases for the water and increases for the ice, so the total is zero', false, 'Treats entropy changes as always canceling. The spreading of energy raises the ice''s entropy by more than it lowers the warm water''s, so the total is positive.' from version_ins;
-- apphy2-mcq-sv-023-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-023-v2', 'mcq', 'Freezer and the second law', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water placed in a running freezer turns to ice, so the water''s own entropy decreases. Which statement best explains why this does not violate the second law of thermodynamics?', null, md5('apphy2-mcq-sv-023-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Entropy only changes for gases, so the water''s entropy cannot really change', false, 'Entropy is a property of any system''s configuration, including liquids and solids. It does change when water freezes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Freezing removes the water''s energy, so the energy is destroyed and entropy no longer matters', false, 'Energy is not destroyed; it is transferred to the surroundings. That transfer is what makes the entropy of the surroundings rise.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Entropy of any object can never decrease, so the water must actually gain entropy as it freezes', false, 'The law restricts isolated systems, not every individual object. A non-isolated object can lose entropy when energy leaves it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The water is not isolated; energy leaves it and raises the entropy of the surroundings by at least as much', true, 'The second law applies to the total entropy of an isolated system. The water plus the freezer''s surroundings together do not decrease in entropy, so a local decrease is allowed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-009-v2','apphy2-mcq-sv-009-v3','apphy2-mcq-sv-021-v1','apphy2-mcq-sv-021-v2','apphy2-mcq-sv-021-v3','apphy2-mcq-sv-022-v1','apphy2-mcq-sv-022-v2','apphy2-mcq-sv-022-v3','apphy2-mcq-sv-023-v1','apphy2-mcq-sv-023-v2']) and status='draft')<>10 then raise exception 'chunk 3: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.content_key = any (array['apphy2-mcq-sv-009-v2','apphy2-mcq-sv-009-v3','apphy2-mcq-sv-021-v1','apphy2-mcq-sv-021-v2','apphy2-mcq-sv-021-v3','apphy2-mcq-sv-022-v1','apphy2-mcq-sv-022-v2','apphy2-mcq-sv-022-v3','apphy2-mcq-sv-023-v1','apphy2-mcq-sv-023-v2']))<>40 then raise exception 'chunk 3: choice rows'; end if;
end $$;
commit;
