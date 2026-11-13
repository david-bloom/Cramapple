begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.4-a-v3','apchem-mcq-b4-h-4.4-b','apchem-mcq-b4-sv-h-4.4-b-v1','apchem-mcq-b4-sv-h-4.4-b-v2','apchem-mcq-b4-sv-h-4.4-b-v3','apchem-mcq-b4-h-4.5-a','apchem-mcq-b4-sv-h-4.5-a-v1','apchem-mcq-b4-sv-h-4.5-a-v2','apchem-mcq-b4-sv-h-4.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apchem-mcq-b4-sv-h-4.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.4-a-v3', 'mcq', 'judge which observation is real evidence of a new substance (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student tests four trials on a 5.00 g sample of a white solid with a melting point of 63°C. Which trial describes only a physical change?', null, md5('apchem-mcq-b4-sv-h-4.4-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'After heating in a sealed tube, the mass is still 5.00 g, but the solid now melts at 120°C.', false, 'The same mass but a different melting point means the solid is now a different substance, even though no gas escaped.' from version_ins
union all select gen_random_uuid(), id, 'B', 'After dissolving the solid in water and evaporating the water, 5.00 g of white solid is recovered, and it melts at 63°C.', true, 'Correct: only trial C recovers the original substance with the same mass and melting point; in A, B and D the product has a different melting point, which shows a new substance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'After heating, 1.20 g of an odorous gas is released, and the remaining solid melts at 90°C.', false, 'A released gas and a residue with a different melting point indicate that new substances formed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'After mixing with a clear liquid, a bright yellow solid forms that melts at 98°C.', false, 'A differently colored solid with a new melting point is a new substance formed from the mixing.' from version_ins;
-- apchem-mcq-b4-h-4.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.4-b', 'mcq', 'use energy data to tell breaking intermolecular forces from breaking covalent bonds', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to vaporize 1 mol of H2O(l) at 25°C is 44 kJ. The energy needed to decompose 1 mol of H2O(g) into H2(g) and 1/2 O2(g) is 242 kJ. Which statement best interprets these data?', null, md5('apchem-mcq-b4-h-4.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Vaporization breaks some of the O-H bonds in water, but decomposition breaks every one of them, which takes more energy.', false, 'Vaporization leaves each H2O molecule intact, with all of its O-H bonds unbroken, since only attractions between molecules are overcome.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Vaporization only overcomes intermolecular forces between intact molecules, while decomposition breaks strong covalent O-H bonds and forms new substances.', true, 'Correct: 44 kJ/mol is the scale of intermolecular attractions (hydrogen bonds); 242 kJ/mol is the scale of covalent bond energies.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Decomposition needs more energy because the molecules in a gas are farther apart than in a liquid.', false, 'The distance between molecules in the gas is the result of vaporization and does not make decomposition cost energy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Decomposition must also overcome the hydrogen bonds in the liquid, so it needs the vaporization energy plus extra energy.', false, 'The decomposition data begin with H2O(g), where molecules are already separated, so hydrogen bonds in the liquid are not involved.' from version_ins;
-- apchem-mcq-b4-sv-h-4.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.4-b-v1', 'mcq', 'use energy data to tell breaking intermolecular forces from breaking covalent bonds (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to sublime 1 mol of CO2(s) is about 25 kJ. The energy needed to decompose 1 mol of CO2(g) into C(s) and O2(g) is about 394 kJ. Which statement best interprets these data?', null, md5('apchem-mcq-b4-sv-h-4.4-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sublimation breaks C=O bonds in each molecule, but fewer of them than decomposition.', false, 'Sublimed CO2 is still CO2, so no C=O bonds in the molecules were broken.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Decomposition needs more energy because solid CO2 has stronger intermolecular forces than gaseous CO2.', false, 'Decomposition starts from gaseous CO2, where the intermolecular forces are negligible, so this does not explain the energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both processes break covalent bonds, and the difference is only in how many bonds break.', false, 'Sublimation breaks no covalent bonds, and only the decomposition does so.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sublimation overcomes weak attractions between intact CO2 molecules, but decomposition breaks the C=O bonds within molecules.', true, 'Correct: 25 kJ/mol corresponds to dispersion forces between molecules; 394 kJ/mol corresponds to breaking strong double bonds.' from version_ins;
-- apchem-mcq-b4-sv-h-4.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.4-b-v2', 'mcq', 'use energy data to tell breaking intermolecular forces from breaking covalent bonds (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to melt 1 mol of NaCl(s) is about 28 kJ. The energy needed to convert 1 mol of NaCl(s) into Na(s) and 1/2 Cl2(g) is about 411 kJ. Which statement best interprets these data?', null, md5('apchem-mcq-b4-sv-h-4.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Melting converts Na⁺ ions to Na atoms, but only partly, so less energy is needed than for complete conversion.', false, 'Melting does not change any ions into atoms; the Na⁺ and Cl⁻ ions are still present in the liquid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Melting loosens the lattice but leaves Na⁺ and Cl⁻ ions in the same substance, while the second process changes the ions into Na atoms and Cl2 molecules.', true, 'Correct: molten NaCl is still NaCl made of Na⁺ and Cl⁻, a physical change; producing Na(s) and Cl2(g) is a chemical change requiring electron transfer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both processes produce new substances, and the larger energy change is due to producing a gas.', false, 'Melting does not produce a new substance, so it is a physical change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Melting breaks every ionic bond completely, so the second process must be breaking something else, such as nuclei.', false, 'Nuclei are never broken in chemical processes, and melting does not completely separate the ions, which still attract each other in the liquid.' from version_ins;
-- apchem-mcq-b4-sv-h-4.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.4-b-v3', 'mcq', 'use energy data to tell breaking intermolecular forces from breaking covalent bonds (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The energy needed to sublime 1 mol of I2(s) is about 62 kJ. The energy needed to dissociate 1 mol of I2(g) into 2 I(g) is about 151 kJ. Which statement best interprets these data?', null, md5('apchem-mcq-b4-sv-h-4.4-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sublimation is a chemical change because it needs a large amount of energy.', false, 'The size of the energy alone does not define a chemical change; sublimation gives the same I2 molecules in the gas phase.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sublimation overcomes dispersion forces between intact I2 molecules, while dissociation breaks the I-I covalent bond and forms different particles.', true, 'Correct: sublimation gives I2 molecules in the gas phase; dissociation gives I atoms, a different species.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both processes break I-I bonds, and dissociation requires more energy because the bonds are stronger in the gas.', false, 'Sublimation leaves the I-I bonds intact, and the molecules just separate.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Dissociation is a physical change because the iodine remains iodine.', false, 'The I atoms have different properties from I2 molecules, and the covalent bond is broken, so it is a chemical change.' from version_ins;
-- apchem-mcq-b4-h-4.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.5-a', 'mcq', 'find the limiting reactant from masses, then compute percent yield', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aluminum reacts with chlorine according to 2 Al + 3 Cl2 → 2 AlCl3. A student mixes 5.40 g of Al (26.98 g/mol) with 10.65 g of Cl2 (70.90 g/mol) and collects 11.2 g of AlCl3 (133.33 g/mol). What is the percent yield?', null, md5('apchem-mcq-b4-h-4.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '42.0%', false, 'It uses Al as the limiting reactant (theoretical yield 26.7 g), but Cl2 runs out first.' from version_ins
union all select gen_random_uuid(), id, 'B', '83.9%', true, 'Correct: 5.40 g Al = 0.2001 mol; 10.65 g Cl2 = 0.1502 mol; the Al would need 0.3002 mol Cl2, so Cl2 is limiting. AlCl3 = 0.1502 × 2/3 = 0.1001 mol = 13.35 g; 11.2 ÷ 13.35 = 83.9%.' from version_ins
union all select gen_random_uuid(), id, 'C', '55.9%', false, 'It uses the correct limiting reactant but a 1:1 mole ratio of Cl2 to AlCl3, giving 20.0 g as the theoretical yield.' from version_ins
union all select gen_random_uuid(), id, 'D', '69.8%', false, 'It uses the total mass of the reactants, 16.05 g, as the theoretical yield, which ignores the mole ratio and the limiting reactant.' from version_ins;
-- apchem-mcq-b4-sv-h-4.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.5-a-v1', 'mcq', 'find the limiting reactant from masses, then compute percent yield (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ammonia reacts with oxygen according to 4 NH3 + 5 O2 → 4 NO + 6 H2O. A student mixes 8.50 g of NH3 (17.03 g/mol) with 16.0 g of O2 (32.00 g/mol) and collects 9.60 g of NO (30.01 g/mol). What is the percent yield?', null, md5('apchem-mcq-b4-sv-h-4.5-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '80.0%', true, 'Correct: 8.50 g NH3 = 0.4991 mol; 16.0 g O2 = 0.5000 mol; NH3 would need 0.624 mol O2, so O2 is limiting. NO = 0.5000 × 4/5 = 0.4000 mol = 12.0 g; 9.60 ÷ 12.0 = 80.0%.' from version_ins
union all select gen_random_uuid(), id, 'B', '64.1%', false, 'It takes NH3 as the limiting reactant (theoretical yield 14.98 g), but O2 runs out first.' from version_ins
union all select gen_random_uuid(), id, 'C', '51.2%', false, 'It multiplies the moles of O2 by 5/4 instead of 4/5, inverting the mole ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', '39.2%', false, 'It divides by the total mass of the reactants, which ignores stoichiometry.' from version_ins;
-- apchem-mcq-b4-sv-h-4.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.5-a-v2', 'mcq', 'find the limiting reactant from masses, then compute percent yield (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the thermite reaction Fe2O3 + 2 Al → Al2O3 + 2 Fe, a student mixes 16.0 g of Fe2O3 (159.69 g/mol) with 4.05 g of Al (26.98 g/mol) and obtains 6.70 g of Fe (55.85 g/mol). What is the percent yield of iron?', null, md5('apchem-mcq-b4-sv-h-4.5-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '33.4%', false, 'It divides by the total mass of the two reactants, 20.05 g, which has nothing to do with the iron that can form.' from version_ins
union all select gen_random_uuid(), id, 'B', '59.9%', false, 'It takes Fe2O3 as limiting and counts 2 Fe per Fe2O3 (11.19 g), but Al runs out first.' from version_ins
union all select gen_random_uuid(), id, 'C', '40.0%', false, 'It doubles the moles of Fe formed from the Al, using 2 Fe per Al, which inverts the 1:1 mole ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', '79.9%', true, 'Correct: 16.0 g Fe2O3 = 0.1002 mol; 4.05 g Al = 0.1501 mol; Fe2O3 would need 0.2004 mol Al, so Al is limiting. Fe = 0.1501 mol = 8.38 g; 6.70 ÷ 8.38 = 79.9%.' from version_ins;
-- apchem-mcq-b4-sv-h-4.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.5-a-v3', 'mcq', 'find the limiting reactant from masses, then compute percent yield (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Hydrogen burns in oxygen according to 2 H2 + O2 → 2 H2O. A student mixes 3.00 g of H2 (2.016 g/mol) with 20.0 g of O2 (32.00 g/mol) and collects 19.4 g of H2O (18.02 g/mol). What is the percent yield?', null, md5('apchem-mcq-b4-sv-h-4.5-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '86.1%', true, 'Correct: 3.00 g H2 = 1.488 mol; 20.0 g O2 = 0.625 mol; The O2 needs 1.250 mol H2 and 1.488 mol H2 is available, so O2 is limiting. H2O = 1.250 mol = 22.5 g; 19.4 ÷ 22.5 = 86.1%.' from version_ins
union all select gen_random_uuid(), id, 'B', '72.3%', false, 'It takes H2 as the limiting reactant (26.8 g of water), but O2 runs out first.' from version_ins
union all select gen_random_uuid(), id, 'C', '97.0%', false, 'It compares the mass of water with the mass of O2 only, which ignores the mole ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', '84.3%', false, 'It compares the product with the total mass of the reactants, 23.0 g, which ignores the limiting reactant and the mole ratio.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.4-a-v3','apchem-mcq-b4-h-4.4-b','apchem-mcq-b4-sv-h-4.4-b-v1','apchem-mcq-b4-sv-h-4.4-b-v2','apchem-mcq-b4-sv-h-4.4-b-v3','apchem-mcq-b4-h-4.5-a','apchem-mcq-b4-sv-h-4.5-a-v1','apchem-mcq-b4-sv-h-4.5-a-v2','apchem-mcq-b4-sv-h-4.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-sv-h-4.4-a-v3','apchem-mcq-b4-h-4.4-b','apchem-mcq-b4-sv-h-4.4-b-v1','apchem-mcq-b4-sv-h-4.4-b-v2','apchem-mcq-b4-sv-h-4.4-b-v3','apchem-mcq-b4-h-4.5-a','apchem-mcq-b4-sv-h-4.5-a-v1','apchem-mcq-b4-sv-h-4.5-a-v2','apchem-mcq-b4-sv-h-4.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
