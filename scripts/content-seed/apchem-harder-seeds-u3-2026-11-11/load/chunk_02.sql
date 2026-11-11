begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-sv-h-3.2-a-v1','apchem-mcq-sv-h-3.2-a-v2','apchem-mcq-sv-h-3.2-a-v3','apchem-mcq-h-3.2-b','apchem-mcq-sv-h-3.2-b-v1','apchem-mcq-sv-h-3.2-b-v2','apchem-mcq-sv-h-3.2-b-v3','apchem-mcq-h-3.3-a','apchem-mcq-sv-h-3.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apchem-mcq-sv-h-3.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-a-v1', 'mcq', 'Coulomb''s law and ionic melting points (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Sodium fluoride (NaF) melts at 993°C and sodium iodide (NaI) melts at 661°C. Which statement best explains why NaF melts at the higher temperature?', null, md5('apchem-mcq-sv-h-3.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The fluoride ion has a larger charge than the iodide ion.', false, 'Both halide ions carry a 1- charge, so charge cannot explain the difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NaI is a molecular solid and NaF is an ionic solid.', false, 'Both are ionic solids made of ions in a lattice.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The fluoride ion is smaller than the iodide ion, so the ions are closer together and the Coulombic attraction is stronger.', true, 'Correct: same charges (1+, 1-); the smaller F- gives a smaller interionic distance and stronger attraction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NaF has stronger London dispersion forces because fluorine is more electronegative than iodine.', false, 'Electronegativity does not set the strength of dispersion forces, and ionic attractions dominate over dispersion forces in these solids.' from version_ins;
-- apchem-mcq-sv-h-3.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-a-v2', 'mcq', 'Coulomb''s law and ionic melting points (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Calcium oxide (CaO) melts at 2613°C and potassium chloride (KCl) melts at 770°C. The ionic radii are comparable: K+ 138 pm and Ca2+ 100 pm, Cl- 181 pm and O2- 140 pm. Which statement best explains the large difference?', null, md5('apchem-mcq-sv-h-3.2-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The larger ion charges in CaO (2+ and 2-) lead to much stronger Coulombic attractions than the 1+ and 1- charges in KCl.', true, 'Correct: the charge product is 4 for CaO and 1 for KCl, which outweighs the modest size difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CaO contains covalent network bonds and KCl does not.', false, 'CaO is an ionic solid, not a covalent network solid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ion radii are the only factor, and CaO has the smaller radii, so charge is unimportant.', false, 'Radius matters, but the factor of four in charge product is the dominant difference here.' from version_ins
union all select gen_random_uuid(), id, 'D', 'KCl has more ions per formula unit, so it needs less energy to melt.', false, 'KCl and CaO each have one cation and one anion per formula unit.' from version_ins;
-- apchem-mcq-sv-h-3.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-a-v3', 'mcq', 'Coulomb''s law and ionic melting points (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Potassium chloride (KCl, 770°C) melts lower than sodium chloride (NaCl, 801°C). Which statement best explains why?', null, md5('apchem-mcq-sv-h-3.2-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'K+ has a smaller charge than Na+, so the attraction is weaker.', false, 'Na+ and K+ both carry a 1+ charge, so the charge product is the same in both lattices and cannot explain the difference.' from version_ins
union all select gen_random_uuid(), id, 'B', 'K+ has a larger radius than Na+, so the ions in KCl are farther apart and the Coulombic attraction is weaker.', true, 'Correct: same charges; K+ (138 pm) is larger than Na+ (102 pm), so the interionic distance is greater.' from version_ins
union all select gen_random_uuid(), id, 'C', 'KCl forms covalent bonds, and NaCl does not.', false, 'Both are ionic compounds, and neither forms covalent bonds between ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cl- is larger in KCl than in NaCl, so the lattice is weaker.', false, 'The chloride ion is the same ion in both compounds and has the same size.' from version_ins;
-- apchem-mcq-h-3.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.2-b', 'mcq', 'Structure and properties of network and metallic solids', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Graphite and diamond are both pure carbon. Graphite conducts electricity along its layers, but diamond does not. Which statement best explains why graphite conducts?', null, md5('apchem-mcq-h-3.2-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Graphite contains free ions that move through the solid.', false, 'Graphite is made of neutral atoms, so it contains no ions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Graphite is a metallic solid with a sea of electrons.', false, 'Graphite is a covalent network solid, not a metal, although its electrons are partly delocalized.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Each carbon atom in graphite is bonded to three others in a flat layer, leaving one delocalized electron per atom that can move along the layer.', true, 'Correct: in graphite each carbon bonds to three others, leaving a delocalized p electron; in diamond each carbon bonds to four and has no mobile electrons.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Graphite''s atoms are held together by weak dispersion forces, which allow electrons to pass freely.', false, 'Dispersion forces hold the layers together, but they do not carry charge; conduction is by delocalized electrons within the layers.' from version_ins;
-- apchem-mcq-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-b-v1', 'mcq', 'Structure and properties of network and metallic solids (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Silicon dioxide (SiO2, quartz) melts at about 1700°C, while carbon dioxide (CO2) sublimes at -78°C. Which statement best explains this large difference?', null, md5('apchem-mcq-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The Si-O bond is ionic, while the C-O bond is covalent.', false, 'Both compounds contain polar covalent bonds, and SiO2 is not ionic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'SiO2 has stronger dispersion forces because silicon has more electrons than carbon.', false, 'Dispersion forces are not what holds quartz together, since the covalent network is.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CO2 is polar and SiO2 is nonpolar, so SiO2 melts higher.', false, 'CO2 is nonpolar because it is linear, and polarity is not the reason SiO2 melts higher.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SiO2 is a network solid, so melting requires breaking covalent bonds, while CO2 is a molecular solid that needs only weak intermolecular forces overcome.', true, 'Correct: quartz is a covalent network; CO2 is a molecular solid held by weak dispersion forces.' from version_ins;
-- apchem-mcq-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-b-v2', 'mcq', 'Structure and properties of network and metallic solids (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A hammer strike shatters a crystal of NaCl but only dents a piece of copper. Which statement best explains the difference?', null, md5('apchem-mcq-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Copper has stronger bonds than NaCl, so it cannot shatter.', false, 'NaCl has strong ionic attractions, and brittleness comes from how the lattice responds to shifting, not from weak bonds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'In copper, layers of atoms shift while the mobile electrons keep them bonded, whereas in NaCl a shift puts like-charged ions next to each other and the crystal cracks.', true, 'Correct: metals are malleable because the electron sea keeps attraction when layers slide; ionic crystals are brittle because shifting aligns like charges.' from version_ins
union all select gen_random_uuid(), id, 'C', 'NaCl is a molecular solid, so weak forces let it break apart.', false, 'NaCl is an ionic solid, not a molecular one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Copper contains ions that can rearrange, while NaCl contains neutral atoms.', false, 'This reverses the particles, since NaCl contains ions and copper contains neutral atoms with delocalized electrons.' from version_ins;
-- apchem-mcq-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-b-v3', 'mcq', 'Structure and properties of network and metallic solids (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pure iron is relatively soft, but steel, which contains small carbon atoms in the spaces between iron atoms, is much harder. Which statement best explains why steel is harder?', null, md5('apchem-mcq-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Carbon atoms form ionic bonds with iron, creating a rigid ionic lattice.', false, 'Carbon and iron do not form ionic bonds here, and steel is still a metallic solid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The small carbon atoms sit in spaces between the iron atoms and make it harder for the layers of iron atoms to slide past one another.', true, 'Correct: an interstitial alloy has small atoms in the gaps; they block layer sliding and increase hardness.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Carbon atoms replace iron atoms of similar size, so the metallic bonding is unchanged.', false, 'Replacing atoms of similar size describes a substitutional alloy, whereas steel is interstitial.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Carbon is a nonmetal, so steel is a molecular solid.', false, 'Steel is a metallic solid, and adding a nonmetal does not change it into a molecular solid.' from version_ins;
-- apchem-mcq-h-3.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.3-a', 'mcq', 'Energy during phase changes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure liquid is heated at its normal boiling point, and its temperature stays constant while it boils. Which statement best describes what happens to the added energy at the particle level?', null, md5('apchem-mcq-h-3.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The energy is used to overcome intermolecular attractions, increasing the potential energy of the particles while their average kinetic energy stays the same.', true, 'Correct: temperature is a measure of average kinetic energy; it is constant during the phase change, so energy goes to overcoming attractions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average kinetic energy of the particles increases, which is why the liquid vaporizes.', false, 'Temperature stays constant, so the average kinetic energy does not change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The covalent bonds within each molecule break, which produces the gas.', false, 'Boiling separates molecules from one another and does not break the bonds inside them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The energy is stored in the intermolecular forces, which become stronger as the particles move apart.', false, 'Moving particles apart weakens the intermolecular attractions rather than strengthening them.' from version_ins;
-- apchem-mcq-sv-h-3.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-a-v1', 'mcq', 'Energy during phase changes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ice at 0°C is heated and melts at 0°C, with the temperature remaining at 0°C until it has all melted. Which statement best describes the energy absorbed during melting?', null, md5('apchem-mcq-sv-h-3.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It raises the average kinetic energy of the water molecules.', false, 'The temperature remains constant during melting, so the average kinetic energy is unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It breaks the O-H covalent bonds in each molecule.', false, 'The covalent bonds remain intact, since water is still H2O after melting.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It partly overcomes the hydrogen bonds holding the molecules in fixed positions, raising potential energy with no change in average kinetic energy.', true, 'Correct: constant temperature means constant average kinetic energy; the energy goes into overcoming attractions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It strengthens the hydrogen bonds so that the molecules can flow.', false, 'Hydrogen bonds are partly broken in liquid water, not strengthened.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-sv-h-3.2-a-v1','apchem-mcq-sv-h-3.2-a-v2','apchem-mcq-sv-h-3.2-a-v3','apchem-mcq-h-3.2-b','apchem-mcq-sv-h-3.2-b-v1','apchem-mcq-sv-h-3.2-b-v2','apchem-mcq-sv-h-3.2-b-v3','apchem-mcq-h-3.3-a','apchem-mcq-sv-h-3.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-sv-h-3.2-a-v1','apchem-mcq-sv-h-3.2-a-v2','apchem-mcq-sv-h-3.2-a-v3','apchem-mcq-h-3.2-b','apchem-mcq-sv-h-3.2-b-v1','apchem-mcq-sv-h-3.2-b-v2','apchem-mcq-sv-h-3.2-b-v3','apchem-mcq-h-3.3-a','apchem-mcq-sv-h-3.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
