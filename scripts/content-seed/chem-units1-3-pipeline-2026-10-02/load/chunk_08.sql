begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-030-v1','apchem-mcq-sv-030-v2','apchem-mcq-sv-030-v3','apchem-mcq-sv-031-v1','apchem-mcq-sv-031-v2','apchem-mcq-sv-031-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-030-v1 (seed apchem-mcq-030)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-030-v1', 'mcq', 'Ethanol versus dimethyl ether', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ethanol (CH3CH2OH) and dimethyl ether (CH3OCH3) are isomers, so each has a molar mass of 46 g/mol. Ethanol boils at 78°C, whereas dimethyl ether boils at -24°C. Which statement best explains this difference?', null, md5('apchem-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ethanol has an H atom bonded to O, so its molecules hydrogen bond to one another; the H atoms in dimethyl ether are bonded only to C.', true, 'Correct: ethanol''s O-H group lets the H of one molecule be attracted to the O of a neighboring molecule (hydrogen bonding). Dimethyl ether is polar but has no H bonded to N, O, or F, so it has only dipole-dipole forces plus London dispersion forces. Because the molar masses (and so the dispersion forces) are the same, the extra hydrogen bonding explains ethanol''s much higher boiling point.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Every H atom in dimethyl ether can hydrogen bond, but the O-H hydrogen bonds in ethanol are considerably stronger.', false, 'Incorrect: hydrogen bonding requires H covalently bonded to N, O, or F. The H atoms in dimethyl ether are all bonded to C, so dimethyl ether cannot act as a hydrogen-bond donor, and its molecules do not hydrogen bond with one another.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ethanol has much stronger London dispersion forces because its molecules are larger and more polarizable than those of dimethyl ether.', false, 'Incorrect: the two compounds are isomers with identical molar mass and the same number of electrons, so their dispersion forces are comparable. Size cannot account for a 100°C difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Dimethyl ether is nonpolar, so it has only London dispersion forces, whereas the polar ethanol also has dipole-dipole forces.', false, 'Incorrect: the C-O-C unit of dimethyl ether is bent, so its bond dipoles do not cancel and the molecule is polar. It therefore has dipole-dipole forces as well; the real difference is that only ethanol can hydrogen bond.' from version_ins
;
-- apchem-mcq-sv-030-v2 (seed apchem-mcq-030)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-030-v2', 'mcq', 'Why water boils higher than H2S', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'H2O has a molar mass of 18 g/mol, and H2S has a molar mass of 34 g/mol. Even so, H2O boils at 100°C while H2S boils at -60°C. Which statement best explains why H2O has the much higher boiling point?', null, md5('apchem-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H2O molecules form hydrogen bonds with one another because H is bonded to O, whereas H2S has no H bonded to N, O, or F.', true, 'Correct: each H2O molecule has H atoms bonded directly to O, so molecules attract each other through hydrogen bonds, which are much stronger than the dipole-dipole and London dispersion forces that are all H2S can offer (S is not N, O, or F). The strong intermolecular hydrogen bonding must be overcome in boiling, giving H2O the higher boiling point even though its dispersion forces are weaker.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Boiling H2O requires breaking the O-H covalent bonds, which are stronger than the S-H bonds in H2S.', false, 'Incorrect: boiling is a physical change in which the molecules stay intact; only intermolecular attractions are overcome, not the covalent bonds inside each molecule. Comparing bond strengths therefore does not explain boiling points.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H2S has the larger molar mass, so its molecules attract one another more strongly and H2S should have the higher boiling point.', false, 'Incorrect: this contradicts the data, since H2O has the higher boiling point. Larger molar mass does strengthen dispersion forces, but the hydrogen bonding in H2O outweighs that effect, so molar mass alone is not a reliable predictor.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H2O has the stronger London dispersion forces because oxygen is more electronegative than sulfur.', false, 'Incorrect: dispersion forces depend on the size and polarizability of the electron cloud, and sulfur''s larger electron cloud makes H2S more polarizable, so H2S has the stronger dispersion forces. Electronegativity does not set dispersion strength.' from version_ins
;
-- apchem-mcq-sv-030-v3 (seed apchem-mcq-030)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-030-v3', 'mcq', 'Methylamine versus ethane', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Methylamine (CH3NH2, 31 g/mol) boils at -6°C, while ethane (CH3CH3, 30 g/mol) boils at -89°C. Which statement best explains why methylamine has the higher boiling point?', null, md5('apchem-mcq-sv-030-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ethane has C-H bonds that form hydrogen bonds, but the N-H hydrogen bonds in methylamine are considerably stronger than these.', false, 'Incorrect: hydrogen bonding requires H bonded to N, O, or F. The C-H bonds in ethane are essentially nonpolar and cannot form hydrogen bonds, so ethane has only dispersion forces.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The N-H covalent bonds in methylamine must be broken when it boils, and these are much stronger than the C-C bond in ethane.', false, 'Incorrect: boiling does not break covalent bonds; it separates intact molecules by overcoming intermolecular forces. The covalent bond strengths inside the molecules are not what determine boiling point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Methylamine has a slightly greater molar mass than ethane, so its London dispersion forces are much stronger than those of ethane.', false, 'Incorrect: 31 g/mol versus 30 g/mol is a negligible difference (both molecules even have 18 electrons), so the dispersion forces are essentially equal and cannot explain a boiling-point difference of over 80°C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Methylamine molecules hydrogen bond through their N-H groups, whereas ethane molecules are held together only by London dispersion forces.', true, 'Correct: methylamine has H atoms bonded directly to N, so the N-H hydrogen of one molecule is attracted to the lone pair on N of another (hydrogen bonding), in addition to dipole-dipole and dispersion forces. Ethane is nonpolar and has only London dispersion forces. The two molar masses are nearly equal, so the hydrogen bonding accounts for the large boiling-point difference.' from version_ins
;
-- apchem-mcq-sv-031-v1 (seed apchem-mcq-031)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-031-v1', 'mcq', 'Hard, nonconducting, high melting solid', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solid is very hard and brittle and melts above 1,700°C. It does not conduct electricity as a solid, and it does not conduct electricity when molten. What type of solid is this sample most likely to be?', null, md5('apchem-mcq-sv-031-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A metallic solid, such as tungsten metal', false, 'Incorrect: metallic solids can have very high melting points, but their delocalized electrons make them conduct in the solid and molten states, and they are malleable rather than brittle. This sample is nonconducting and brittle.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A molecular solid, such as solid carbon dioxide', false, 'Incorrect: molecular solids do not conduct in either state, but they are held together by weak intermolecular forces and so are soft and melt at low temperatures. A melting point above 1,700°C is not consistent with a molecular solid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An ionic solid, such as magnesium oxide', false, 'Incorrect: ionic solids are hard, brittle and high-melting and do not conduct as solids, but the mobile ions in the molten state conduct electricity. This sample does not conduct when molten, which rules out an ionic solid.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A network solid, such as silicon carbide', true, 'Correct: in a covalent network solid such as silicon carbide every atom is held in a continuous lattice by directional covalent bonds, so the solid is very hard and brittle and has a very high melting point. There are no ions and no delocalized electrons, so it does not conduct electricity as a solid or as a liquid.' from version_ins
;
-- apchem-mcq-sv-031-v2 (seed apchem-mcq-031)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-031-v2', 'mcq', 'Brittle solid that conducts when molten', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A white crystalline solid shatters when struck with a hammer and melts at 801°C. The solid does not conduct electricity, but it conducts electricity well after it is melted. What type of solid is this sample most likely to be?', null, md5('apchem-mcq-sv-031-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An ionic solid, such as sodium chloride', true, 'Correct: ions are fixed in the rigid lattice of an ionic solid, so there are no mobile charge carriers and the solid does not conduct. Melting frees the ions to move, so the liquid conducts. Strong Coulombic attractions between ions give a high melting point, and displacing layers of the lattice brings like charges together, so the crystal is brittle and shatters.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A metallic solid, such as copper', false, 'Incorrect: metals conduct electricity in the solid state because of delocalized valence electrons and are malleable, not brittle. This sample is nonconducting as a solid and shatters.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A covalent network solid, such as quartz', false, 'Incorrect: network solids such as quartz are also brittle, high-melting and nonconducting as solids, but they stay nonconducting when molten because the atoms are bonded, not ionized. A sample that conducts after melting contains mobile ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A molecular solid, such as sucrose', false, 'Incorrect: molecular solids have weak intermolecular forces and melt at low temperatures, and the liquid contains neutral molecules that do not carry charge. A melting point of 801°C and conductivity in the liquid are both inconsistent with a molecular solid.' from version_ins
;
-- apchem-mcq-sv-031-v3 (seed apchem-mcq-031)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-031-v3', 'mcq', 'Soft low-melting nonconductor', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A yellow solid is soft, melts at 119°C, and dissolves in nonpolar solvents. It does not conduct electricity as a solid or as a liquid. What type of solid is this sample most likely to be?', null, md5('apchem-mcq-sv-031-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An ionic solid, such as potassium bromide', false, 'Incorrect: ionic solids have strong ion-ion attractions, so they are hard and brittle with high melting points, and the molten liquid conducts electricity because ions can move. A soft solid with mp 119°C that does not conduct as a liquid is not ionic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A covalent network solid, such as diamond', false, 'Incorrect: network solids such as diamond are nonconducting, but they are extremely hard and have very high melting points because a continuous lattice of covalent bonds must be broken. A soft solid melting at 119°C is not a network solid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A molecular solid, such as solid sulfur', true, 'Correct: a molecular solid consists of discrete covalently bonded molecules held together by weak intermolecular forces. Little energy is needed to separate the molecules, so it is soft and has a low melting point. It contains neither ions nor delocalized electrons, so it does not conduct as a solid or a liquid, and nonpolar molecules dissolve in nonpolar solvents.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A metallic solid, such as lead', false, 'Incorrect: metals have delocalized electrons that conduct electricity in both the solid and liquid states. Because this sample does not conduct in either state, it is not a metal.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-030-v1','apchem-mcq-sv-030-v2','apchem-mcq-sv-030-v3','apchem-mcq-sv-031-v1','apchem-mcq-sv-031-v2','apchem-mcq-sv-031-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
