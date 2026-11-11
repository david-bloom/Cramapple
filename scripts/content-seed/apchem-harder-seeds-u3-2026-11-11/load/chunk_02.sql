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
  select gen_random_uuid(), id, 1, 'Four solids were tested. W conducts electricity as a solid, melts at 1085°C, and can be hammered flat. X does not conduct as a solid but conducts when molten, melts at 801°C, and shatters when struck. Y does not conduct in either state, melts near 3500°C, and is extremely hard. Z does not conduct in either state, melts at −57°C, and is soft. Which choice correctly identifies the type of each solid in the order W, X, Y, Z?', null, md5('apchem-mcq-h-3.2-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Metallic, molecular, covalent network, ionic', false, 'X conducts when molten, which an ionic solid does and a molecular solid does not, and Z with a very low melting point is molecular, not ionic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Covalent network, ionic, metallic, molecular', false, 'Conducting as a solid points to a metal, and an extremely hard solid with a very high melting point is a network solid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Metallic, ionic, covalent network, molecular', true, 'Correct: conducting as a solid and malleable means metallic; conducting only when molten and brittle means ionic; very hard with a very high melting point and no conduction means covalent network; low melting point, soft and no conduction means molecular.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Metallic, ionic, molecular, covalent network', false, 'Y is extremely hard with a melting point near 3500°C, which fits a network solid, while Z melts at −57°C, which fits a molecular solid.' from version_ins;
-- apchem-mcq-sv-h-3.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-b-v1', 'mcq', 'Structure and properties of network and metallic solids (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Solid P conducts electricity as a solid, melts above 3500°C, and is soft and flaky, with layers that slide easily. Solid Q conducts in no state, melts at 1710°C, and is hard and brittle. Which description of P is best supported?', null, md5('apchem-mcq-sv-h-3.2-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A metallic solid, because it conducts electricity in the solid state.', false, 'A metal is malleable and does not flake, and a melting point above 3500°C with soft flaking layers fits graphite, a network solid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A molecular solid, because it is soft and flaky.', false, 'Molecular solids have low melting points, so a melting point above 3500°C rules this out.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An ionic solid, because its melting point is very high.', false, 'Ionic solids do not conduct as solids, since their ions are fixed in the lattice.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A covalent network solid whose electrons are delocalized within its layers, which explains the conduction and the very high melting point.', true, 'Correct: P is a covalent network solid with layers (graphite): strong covalent bonds in the layers give a very high melting point, delocalized electrons carry current, and weak forces between layers make it soft.' from version_ins;
-- apchem-mcq-sv-h-3.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-b-v2', 'mcq', 'Structure and properties of network and metallic solids (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A crystalline solid K melts at 2800°C and shatters when struck. It does not conduct electricity as a solid but does conduct when melted. Which statement best explains why K shatters instead of bending?', null, md5('apchem-mcq-sv-h-3.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Its delocalized electrons cannot move, so the layers lock together and do not slide.', false, 'Ionic solids contain no delocalized electrons, since their ions are held in a lattice and do not conduct as solids.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A shift of the layers places ions of the same charge next to each other, and the repulsion splits the crystal.', true, 'Correct: K is ionic (non-conducting solid, conducting melt, high mp); displacement of a layer aligns like charges, which repel.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Weak intermolecular forces between molecules allow the crystal to break apart easily.', false, 'A melting point of 2800°C is far too high for a molecular solid held by intermolecular forces.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Its covalent bonds are directional, so the lattice is rigid and cannot bend.', false, 'K conducts when molten, which a covalent network solid does not do, so K is ionic rather than covalent.' from version_ins;
-- apchem-mcq-sv-h-3.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.2-b-v3', 'mcq', 'Structure and properties of network and metallic solids (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Brass (copper with zinc atoms of similar size in place of some copper atoms) and steel (iron with small carbon atoms between the iron atoms) are both harder than the pure metals. Which statement is correct?', null, md5('apchem-mcq-sv-h-3.2-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Brass is an interstitial alloy and steel is a substitutional alloy, and both are harder because the bonds become ionic.', false, 'This reverses the two types, and alloys are still held by metallic bonding, not ionic bonding.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Brass is a substitutional alloy and steel is an interstitial alloy; in both, the added atoms disrupt the regular layers and make it harder for them to slide.', true, 'Correct: Zn replaces Cu (similar size) in brass, so substitutional; C fits between Fe atoms in steel, so interstitial; added atoms hinder sliding of layers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both are substitutional alloys, since each contains more than one element in a metallic lattice.', false, 'Steel''s carbon atoms are small and sit in gaps, which is interstitial, so not all alloys are substitutional.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both are interstitial alloys, and both are harder because the added atoms form covalent molecules.', false, 'Brass''s zinc atoms replace copper atoms of a similar size, and neither alloy forms covalent molecules.' from version_ins;
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
