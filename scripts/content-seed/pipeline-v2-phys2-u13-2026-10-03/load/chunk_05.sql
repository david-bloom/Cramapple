begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-027-v1','apphy2-mcq-sv-027-v2','apphy2-mcq-sv-027-v3','apphy2-mcq-sv-028-v1','apphy2-mcq-sv-028-v2','apphy2-mcq-sv-028-v3','apphy2-mcq-sv-029-v1','apphy2-mcq-sv-029-v2','apphy2-mcq-sv-030-v1','apphy2-mcq-sv-030-v2'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphy2-mcq-sv-027-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-027-v1', 'mcq', 'Current tripled in a resistor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The current through a fixed resistor is tripled. The power dissipated in the resistor becomes', null, md5('apphy2-mcq-sv-027-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'three times as great', false, 'Treats power as proportional to current. With R fixed, P = I²R depends on the square of the current.' from version_ins
union all select gen_random_uuid(), id, 'B', 'nine times as great', true, 'For fixed R, P = I²R, so tripling the current multiplies the power by 3² = 9.' from version_ins
union all select gen_random_uuid(), id, 'C', 'six times as great', false, 'Multiplies the factor 3 by 2 instead of squaring it. The dependence is I², so the factor is 3² = 9.' from version_ins
union all select gen_random_uuid(), id, 'D', 'unchanged', false, 'Assumes the resistor''s power is fixed because its resistance is fixed. The power P = I²R changes when the current changes.' from version_ins;
-- apphy2-mcq-sv-027-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-027-v2', 'mcq', 'Heater on a lower voltage', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A heating element of fixed resistance dissipates 360 W when connected to a 120 V source. How much power does it dissipate when connected to a 60 V source?', null, md5('apphy2-mcq-sv-027-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '360 W', false, 'Assumes the 360 W rating is fixed for the device. The power depends on the voltage applied across the fixed resistance.' from version_ins
union all select gen_random_uuid(), id, 'B', '180 W', false, 'Treats power as proportional to voltage, so halving V halves P. With fixed R, P = V²/R depends on the square of V.' from version_ins
union all select gen_random_uuid(), id, 'C', '1440 W', false, 'Multiplies by 4 instead of dividing by 4, as if power rose when the voltage fell. At fixed R, lowering V lowers P by the square of the ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', '90 W', true, 'R = V²/P = (120)²/360 = 40 Ω. At 60 V, P = V²/R = 3600/40 = 90 W. Halving the voltage cuts the power to one quarter.' from version_ins;
-- apphy2-mcq-sv-027-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-027-v3', 'mcq', 'Series resistors power comparison', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 12 Ω resistor and a 4.0 Ω resistor are connected in series to an ideal battery. Which resistor dissipates more power, and by what factor?', null, md5('apphy2-mcq-sv-027-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 4.0 Ω resistor, three times as much as the 12 Ω resistor', false, 'Uses P = V²/R as if both resistors had the same voltage across them, which is true only in parallel. In series the same current passes through both while the voltage divides, and P = I²R gives more power to the larger resistance.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The 12 Ω resistor, three times as much as the 4.0 Ω resistor', true, 'In series the same current I passes through both, so P = I²R makes power proportional to resistance: 12/4.0 = 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both dissipate equal power, since they carry the same current', false, 'The currents are equal, but power is I²R, so the resistor with the larger resistance dissipates more.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 12 Ω resistor, nine times as much as the 4.0 Ω resistor', false, 'Squares the resistance ratio. With the same current, P = I²R is proportional to R itself, not R², so the ratio is 3, not 9.' from version_ins;
-- apphy2-mcq-sv-028-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-028-v1', 'mcq', 'Loop rule for an unknown resistor', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A single series loop contains a 15 V ideal battery, a 4.0 Ω resistor, and a second resistor R. The current in the loop is 2.0 A. Applying the loop rule, what is R?', null, md5('apphy2-mcq-sv-028-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.5 Ω', true, 'Traversing from the battery''s negative to positive terminal gives +15 V; each resistor gives −IR. So 15 − (2.0)(4.0) − (2.0)R = 0, and R = 7.0/2.0 = 3.5 Ω.' from version_ins
union all select gen_random_uuid(), id, 'B', '11.5 Ω', false, 'Adds the 8.0 V drop across the 4.0 Ω resistor to the emf: (15 + 8.0)/2.0 = 11.5 Ω. The resistors are potential drops, so they enter with the opposite sign to the battery''s rise.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.5 Ω', false, 'Subtracts the resistance (4.0) from the emf as if it were a voltage, (15 − 4.0)/2.0. The drop across the 4.0 Ω resistor is IR = 8.0 V.' from version_ins
union all select gen_random_uuid(), id, 'D', '7.5 Ω', false, 'Applies the loop rule to the battery and R alone, 15/2.0, ignoring the potential drop across the 4.0 Ω resistor in the same loop.' from version_ins;
-- apphy2-mcq-sv-028-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-028-v2', 'mcq', 'Two opposing batteries', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 12 V ideal battery and a 5.0 V ideal battery are connected in series with a 7.0 Ω resistor in a single loop. The batteries are oriented so that their positive terminals are joined to each other. What is the current in the loop?', null, md5('apphy2-mcq-sv-028-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0 A', false, 'Assumes opposing batteries cancel completely. They cancel only if their emfs are equal; here a net 7.0 V remains to drive current through the resistor.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.0 A', true, 'Going around the loop, one battery is traversed from − to + (+12 V) and the other from + to − (−5.0 V). The loop rule gives 12 − 5.0 − I(7.0) = 0, so I = 1.0 A.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.4 A', false, 'Adds the two emfs, (12 + 5.0)/7.0. Because the positive terminals face each other, the batteries oppose, and the second battery is a potential drop for the loop traversal.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.7 A', false, 'Uses only the 12 V battery, 12/7.0, and ignores the opposing 5.0 V battery. Its potential change must appear in the loop equation.' from version_ins;
-- apphy2-mcq-sv-028-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-028-v3', 'mcq', 'Potential partway around a loop', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 24 V ideal battery, a 10 Ω resistor, and a 30 Ω resistor form a single series loop carrying 0.60 A. The battery''s negative terminal is defined as 0 V. Point P lies between the two resistors, reached by going from the negative terminal through the battery to its positive terminal and then through the 10 Ω resistor. What is the electric potential at P?', null, md5('apphy2-mcq-sv-028-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 V', true, 'Passing through the battery from − to + raises the potential to +24 V. Through the 10 Ω resistor in the direction of current it drops by IR = (0.60)(10) = 6.0 V, so V_P = 24 − 6.0 = 18 V.' from version_ins
union all select gen_random_uuid(), id, 'B', '30 V', false, 'Adds the 6.0 V resistor drop to the battery''s 24 V. Moving through a resistor along the current direction lowers the potential.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.0 V', false, 'Reports the potential drop across the 10 Ω resistor as if it were the potential at P. The potential at P is the 24 V starting level minus that drop.' from version_ins
union all select gen_random_uuid(), id, 'D', '12 V', false, 'Assumes the potential halfway around the loop is half the emf. The drops are proportional to the resistances (6.0 V and 18 V), so P sits at 24 − 6.0 = 18 V.' from version_ins;
-- apphy2-mcq-sv-029-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-029-v1', 'mcq', 'Current into a three-wire junction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three wires meet at a junction. Currents of 4.5 A and 2.5 A leave the junction through two of the wires. What is the current in the third wire, which carries charge into the junction?', null, md5('apphy2-mcq-sv-029-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.0 A', true, 'Charge cannot accumulate at the junction, so the current in equals the total current out: 4.5 + 2.5 = 7.0 A.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.5 A', false, 'Averages the two outgoing currents. The junction rule is a sum of currents, and the incoming current must equal the total outflow.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.5 A', false, 'Matches only the larger outgoing current and leaves out the 2.5 A that also leaves. The incoming current must supply both.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.0 A', false, 'Subtracts the two outgoing currents. Both leave the junction, so they both count toward the total that must be supplied by the incoming wire.' from version_ins;
-- apphy2-mcq-sv-029-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-029-v2', 'mcq', 'Four-wire junction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At a node in a circuit board, four leads are joined. Leads delivering 3.0 A and 1.2 A bring charge in, and another lead removes 2.5 A. The last lead carries charge away from the node. What current does the last lead carry?', null, md5('apphy2-mcq-sv-029-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.2 A', false, 'Equates the unknown with the total incoming current and forgets that 2.5 A already leaves through another lead. Only the remainder leaves through the last lead.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.7 A', true, 'Total in is 3.0 + 1.2 = 4.2 A. Total out must equal this, so the last lead carries 4.2 − 2.5 = 1.7 A away from the node.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.7 A', false, 'Adds all three known currents without regard to direction. Currents entering and leaving appear on opposite sides of ΣI_in = ΣI_out.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.7 A', false, 'Treats the 1.2 A as leaving the node. Then 3.0 A in against 1.2 + 2.5 = 3.7 A out leaves a 0.7 A shortfall, which would mean charge enters through the last lead instead of leaving. The 1.2 A is delivered to the node and belongs on the incoming side, giving 4.2 − 2.5 = 1.7 A.' from version_ins;
-- apphy2-mcq-sv-030-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-030-v1', 'mcq', 'Instant after closing the switch', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 12 V ideal battery, a 2.0 kΩ resistor, and an uncharged capacitor are connected in series, and the switch is closed at t = 0. What is the current in the circuit immediately after the switch closes?', null, md5('apphy2-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.7×10² A', false, 'Inverts Ohm''s law, computing R/V = 2000/12. The current is V/R = 12/2000 A.' from version_ins
union all select gen_random_uuid(), id, 'B', '0 mA', false, 'Applies the long-time behavior (capacitor blocks current) to the first instant. An uncharged capacitor passes charge freely at t = 0.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.8 mA', false, 'Applies the 63% time-constant fraction, which describes how the capacitor''s charge rises, to the current. At t = 0 the full 12 V is across the resistor.' from version_ins
union all select gen_random_uuid(), id, 'D', '6.0 mA', true, 'An uncharged capacitor has no potential difference across it and acts like a wire at t = 0, so the whole 12 V appears across the resistor: I = 12 V / 2000 Ω = 6.0 mA.' from version_ins;
-- apphy2-mcq-sv-030-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'f584ab0d-114a-4520-9649-42e3e9a2fd22', 'apphy2-mcq-sv-030-v2', 'mcq', 'Capacitor voltage at steady state', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 12 V ideal battery is connected in series with a 4.0 Ω resistor. That resistor leads to a parallel combination of an 8.0 Ω resistor and an initially uncharged capacitor. After a very long time, what is the potential difference across the capacitor?', null, md5('apphy2-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12 V', false, 'Assumes the capacitor charges to the full battery emf. A capacitor in parallel with a resistor reaches only the potential difference across that resistor, because the series 4.0 Ω resistor still carries current and drops 4.0 V.' from version_ins
union all select gen_random_uuid(), id, 'B', '8.0 V', true, 'At steady state the capacitor carries no current, so the circuit is a 12 V battery driving the 4.0 Ω and 8.0 Ω resistors in series: I = 12/12 = 1.0 A. The capacitor is in parallel with the 8.0 Ω resistor, so its potential difference is (1.0)(8.0) = 8.0 V.' from version_ins
union all select gen_random_uuid(), id, 'C', '0 V', false, 'Treats the capacitor as a wire, which describes only its behavior at t = 0 when it is uncharged. After a long time it holds charge and acts as an open circuit.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.0 V', false, 'Reports the drop across the 4.0 Ω resistor. The capacitor is in parallel with the 8.0 Ω resistor, not the 4.0 Ω resistor.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and content_key = any (array['apphy2-mcq-sv-027-v1','apphy2-mcq-sv-027-v2','apphy2-mcq-sv-027-v3','apphy2-mcq-sv-028-v1','apphy2-mcq-sv-028-v2','apphy2-mcq-sv-028-v3','apphy2-mcq-sv-029-v1','apphy2-mcq-sv-029-v2','apphy2-mcq-sv-030-v1','apphy2-mcq-sv-030-v2']) and status='draft')<>10 then raise exception 'chunk 5: expected 10 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and ci.content_key = any (array['apphy2-mcq-sv-027-v1','apphy2-mcq-sv-027-v2','apphy2-mcq-sv-027-v3','apphy2-mcq-sv-028-v1','apphy2-mcq-sv-028-v2','apphy2-mcq-sv-028-v3','apphy2-mcq-sv-029-v1','apphy2-mcq-sv-029-v2','apphy2-mcq-sv-030-v1','apphy2-mcq-sv-030-v2']))<>40 then raise exception 'chunk 5: choice rows'; end if;
end $$;
commit;
