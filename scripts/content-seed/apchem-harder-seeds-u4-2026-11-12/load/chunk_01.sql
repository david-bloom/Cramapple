begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-h-4.1-a','apchem-mcq-b4-sv-h-4.1-a-v1','apchem-mcq-b4-sv-h-4.1-a-v2','apchem-mcq-b4-sv-h-4.1-a-v3','apchem-mcq-b4-h-4.1-b','apchem-mcq-b4-sv-h-4.1-b-v1','apchem-mcq-b4-sv-h-4.1-b-v2','apchem-mcq-b4-sv-h-4.1-b-v3','apchem-mcq-b4-h-4.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apchem-mcq-b4-h-4.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.1-a', 'mcq', 'account for a mass change in an open system by identifying the gas that enters or leaves', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 2.00 g of magnesium ribbon strongly in an open crucible until it has all been converted to a white solid, MgO. The white solid has a mass of 3.32 g. Which statement best explains the mass change?', null, md5('apchem-mcq-b4-h-4.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mass is not conserved in this reaction because energy was released as heat and light.', false, 'The energy released as heat and light is far too small to change the measured mass, and the law of conservation of mass holds for all chemical reactions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Magnesium atoms became heavier when they turned into Mg²⁺ ions, because an ion has more mass than its atom.', false, 'An ion differs from its atom by electrons only, which have negligible mass, so the ion is no heavier.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Water vapor from the air condensed onto the hot crucible, and its mass accounts for the 1.32 g gain.', false, 'The crucible is far above 100°C, so water cannot condense, and the gain matches exactly one oxygen atom per magnesium atom in MgO.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Oxygen gas from the air combined with the magnesium, and the 1.32 g gain is the mass of oxygen that reacted, so the total mass of matter is conserved.', true, 'Correct: 2.00 g ÷ 24.31 g/mol = 0.0823 mol Mg gives 0.0823 mol MgO = 3.32 g. The gain, 3.32 - 2.00 = 1.32 g, equals 0.0823 mol × 16.00 g/mol of oxygen atoms.' from version_ins;
-- apchem-mcq-b4-sv-h-4.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.1-a-v1', 'mcq', 'account for a mass change in an open system by identifying the gas that enters or leaves (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 6.18 g of green copper(II) carbonate, CuCO3, in an open crucible. It turns into black copper(II) oxide, CuO, with a mass of 3.98 g. Which statement best explains the mass decrease?', null, md5('apchem-mcq-b4-sv-h-4.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A gas, CO2, formed and escaped into the air, and its mass is the 2.20 g difference.', true, 'Correct: 6.18 g ÷ 123.56 g/mol = 0.0500 mol CuCO3 gives 0.0500 mol CuO = 3.98 g and 0.0500 mol CO2 = 2.20 g; 6.18 - 3.98 = 2.20 g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mass was destroyed when the bonds in CuCO3 were broken.', false, 'Breaking bonds rearranges the same atoms and does not destroy mass; the atoms that left are in the escaping gas.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The heat from the burner carried away mass equal to the 2.20 g difference.', false, 'Heat is energy supplied to the sample and does not carry off matter with a mass of 2.20 g.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Copper atoms evaporated from the crucible while it was heated.', false, 'Copper is not volatile at these temperatures, and the CuO left behind holds all of the original copper.' from version_ins;
-- apchem-mcq-b4-sv-h-4.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.1-a-v2', 'mcq', 'account for a mass change in an open system by identifying the gas that enters or leaves (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student burns 1.12 g of iron wool in air and collects 1.60 g of rust-colored Fe2O3. Which statement is consistent with the law of conservation of mass?', null, md5('apchem-mcq-b4-sv-h-4.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The product contains 0.48 g of oxygen that came from the air, so the mass of iron plus the mass of oxygen that reacted equals the mass of Fe2O3.', true, 'Correct: 1.12 g ÷ 55.85 g/mol = 0.0201 mol Fe gives 0.0100 mol Fe2O3 = 1.60 g; the oxygen is 1.60 - 1.12 = 0.48 g = 0.015 mol O2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Iron atoms were converted into heavier atoms when the iron was heated, which raised the mass by 0.48 g.', false, 'A chemical reaction does not change one element into another, so the iron atoms keep their mass.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The heat added 0.48 g of mass to the iron, which is why the product weighs more than the reactant.', false, 'Heat is energy and its mass equivalent is far too small to measure, so it cannot account for 0.48 g.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Conservation of mass applies only to closed containers, so the extra 0.48 g in the open crucible is not accounted for by any reactant.', false, 'Conservation of mass applies to every reaction, and in an open system the air is simply an unweighed reactant.' from version_ins;
-- apchem-mcq-b4-sv-h-4.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.1-a-v3', 'mcq', 'account for a mass change in an open system by identifying the gas that enters or leaves (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student places 2.10 g of NaHCO3 and an excess of vinegar in an open flask on a balance. As the CO2 bubbles away, the balance reading falls by 1.10 g. If the same reaction were run in a sealed, rigid flask on the same balance, what change in balance reading would be observed?', null, md5('apchem-mcq-b4-sv-h-4.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A decrease of 1.10 g, the same as in the open flask.', false, 'In the open flask the CO2 leaves the balance, but in a sealed flask it cannot, so the reading does not drop.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A decrease of 1.10 g, because gases have no mass and the CO2 does not count.', false, 'Gases are matter and have mass; the 1.10 g loss in the open flask is exactly the mass of the CO2 that escaped.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No change, because the CO2 stays inside the flask and the total mass of everything on the balance is conserved.', true, 'Correct: 2.10 g ÷ 84.01 g/mol = 0.0250 mol NaHCO3 gives 0.0250 mol CO2 = 1.10 g. In a sealed flask all products remain on the balance, so the total mass is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An increase of 1.10 g, because the trapped gas adds to the mass.', false, 'The trapped CO2 came from the reactants already in the flask, so no new mass is added.' from version_ins;
-- apchem-mcq-b4-h-4.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.1-b', 'mcq', 'choose the balanced combustion equation that matches the stated products, checking every atom', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ethanol, C2H5OH, burns completely in excess oxygen to form only carbon dioxide and water. Which equation, written with the smallest whole-number coefficients, correctly represents this reaction?', null, md5('apchem-mcq-b4-h-4.1-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C2H5OH + 2 O2 → 2 CO + 3 H2O', false, 'The equation is balanced, but CO is the product of incomplete combustion and the problem states that only CO2 and H2O form.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C2H5OH + 2 O2 → 2 CO2 + 3 H2O', false, 'It forgets the oxygen atom already in ethanol, leaving 5 O atoms on the left and 7 on the right.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C2H5OH + 3 O2 → 2 CO2 + 3 H2O', true, 'Correct: left side C 2, H 6, O 1 + 6 = 7; right side C 2, H 6, O 4 + 3 = 7. Balanced and the products are CO2 and H2O.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C2H5OH + 3 O2 → 2 CO2 + 3 H2O2', false, 'Changing the subscript of water to make H2O2 changes the substance, and the equation still has 7 O atoms on the left and 10 on the right.' from version_ins;
-- apchem-mcq-b4-sv-h-4.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.1-b-v1', 'mcq', 'choose the balanced combustion equation that matches the stated products, checking every atom (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Methanol, CH3OH, burns completely in excess oxygen to form only CO2 and H2O. Which equation, written with the smallest whole-number coefficients, is correct?', null, md5('apchem-mcq-b4-sv-h-4.1-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CH3OH + O2 → CO2 + 2 H2O', false, 'It has 3 O atoms on the left and 4 on the right, so oxygen is not balanced.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 CH3OH + 2 O2 → 2 CO + 4 H2O', false, 'The equation is balanced, but it produces CO, which is not the complete-combustion product stated.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 CH3OH + 3 O2 → 2 CO2 + 4 H2O', true, 'Correct: left side C 2, H 8, O 2 + 6 = 8; right side C 2, H 8, O 4 + 4 = 8.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CH3OH + 2 O2 → CO2 + 2 H2O', false, 'It counts only the oxygen from O2, forgetting the O atom in methanol, which leaves 5 O atoms on the left and 4 on the right.' from version_ins;
-- apchem-mcq-b4-sv-h-4.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.1-b-v2', 'mcq', 'choose the balanced combustion equation that matches the stated products, checking every atom (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ethane, C2H6, burns completely in excess oxygen to form only CO2 and H2O. Which equation, written with the smallest whole-number coefficients, is correct?', null, md5('apchem-mcq-b4-sv-h-4.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C2H6 + 3 O2 → 2 CO2 + 3 H2O', false, 'Carbon and hydrogen are balanced, but the right side has 7 O atoms and the left only 6.' from version_ins
union all select gen_random_uuid(), id, 'B', '2 C2H6 + 5 O2 → 4 CO + 6 H2O', false, 'It is balanced, but CO is not the complete-combustion product.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 C2H6 + 7 O2 → 4 CO2 + 6 H2O', true, 'Correct: left side C 4, H 12, O 14; right side C 4, H 12, O 8 + 6 = 14.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C2H6 + 7 O2 → 2 CO2 + 3 H2O', false, 'It keeps the coefficient 7 for O2 from the doubled equation without doubling the other coefficients, leaving 14 O atoms on the left and 7 on the right.' from version_ins;
-- apchem-mcq-b4-sv-h-4.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.1-b-v3', 'mcq', 'choose the balanced combustion equation that matches the stated products, checking every atom (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Glucose, C6H12O6, is oxidized completely in the body to form only CO2 and H2O. Which equation, written with the smallest whole-number coefficients, is correct?', null, md5('apchem-mcq-b4-sv-h-4.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C6H12O6 + 6 O2 → 6 CO2 + 12 H2O', false, 'It doubles the water to balance hydrogen from only the glucose and gets 18 O atoms on the left and 24 on the right.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C6H12O6 + 3 O2 → 6 CO + 6 H2O', false, 'It is balanced, but CO is not the stated product of complete oxidation.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C6H12O6 + 9 O2 → 6 CO2 + 6 H2O', false, 'It uses too much O2, giving 24 O atoms on the left and 18 on the right.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C6H12O6 + 6 O2 → 6 CO2 + 6 H2O', true, 'Correct: left side C 6, H 12, O 6 + 12 = 18; right side C 6, H 12, O 12 + 6 = 18.' from version_ins;
-- apchem-mcq-b4-h-4.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.2-a', 'mcq', 'write the net ionic equation when every ion in the mixture takes part in a precipitate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous Ba(OH)2 and aqueous CuSO4 are mixed. Both BaSO4 and Cu(OH)2 are insoluble in water. Which is the net ionic equation for the reaction?', null, md5('apchem-mcq-b4-h-4.2-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ba²⁺(aq) + SO4²⁻(aq) → BaSO4(s)', false, 'It shows only one of the two precipitates, but Cu²⁺ and OH⁻ also leave the solution as Cu(OH)2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cu²⁺(aq) + 2 OH⁻(aq) → Cu(OH)2(s)', false, 'It shows only the copper(II) hydroxide, but Ba²⁺ and SO4²⁻ also leave the solution as BaSO4.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ba(OH)2(aq) + CuSO4(aq) → BaSO4(s) + Cu(OH)2(s)', false, 'It is the molecular equation, which writes the soluble reactants as formula units rather than as ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ba²⁺(aq) + 2 OH⁻(aq) + Cu²⁺(aq) + SO4²⁻(aq) → BaSO4(s) + Cu(OH)2(s)', true, 'Correct: every dissolved ion forms a solid, so there are no spectator ions and all four ions appear on the left.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-h-4.1-a','apchem-mcq-b4-sv-h-4.1-a-v1','apchem-mcq-b4-sv-h-4.1-a-v2','apchem-mcq-b4-sv-h-4.1-a-v3','apchem-mcq-b4-h-4.1-b','apchem-mcq-b4-sv-h-4.1-b-v1','apchem-mcq-b4-sv-h-4.1-b-v2','apchem-mcq-b4-sv-h-4.1-b-v3','apchem-mcq-b4-h-4.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-h-4.1-a','apchem-mcq-b4-sv-h-4.1-a-v1','apchem-mcq-b4-sv-h-4.1-a-v2','apchem-mcq-b4-sv-h-4.1-a-v3','apchem-mcq-b4-h-4.1-b','apchem-mcq-b4-sv-h-4.1-b-v1','apchem-mcq-b4-sv-h-4.1-b-v2','apchem-mcq-b4-sv-h-4.1-b-v3','apchem-mcq-b4-h-4.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
