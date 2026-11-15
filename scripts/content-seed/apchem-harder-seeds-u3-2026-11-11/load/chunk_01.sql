begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-h-3.1-a','apchem-mcq-sv-h-3.1-a-v1','apchem-mcq-sv-h-3.1-a-v2','apchem-mcq-sv-h-3.1-a-v3','apchem-mcq-h-3.1-b','apchem-mcq-sv-h-3.1-b-v1','apchem-mcq-sv-h-3.1-b-v2','apchem-mcq-sv-h-3.1-b-v3','apchem-mcq-h-3.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apchem-mcq-h-3.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.1-a', 'mcq', 'Hydrogen bonding versus dispersion forces', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Water (H2O, 18 g/mol) boils at 100°C. Octane (C8H18, 114 g/mol) boils at 126°C even though its molecules cannot hydrogen bond. Which statement best explains why octane has the higher boiling point?', null, md5('apchem-mcq-h-3.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Octane molecules are polar, so dipole-dipole forces add to the dispersion forces between them.', false, 'Octane is nonpolar because its C-H bonds are nearly nonpolar and the molecule is symmetric, so it has no dipole-dipole forces.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The C-H bonds in octane are stronger than the O-H bonds in water, so more energy is needed to boil octane.', false, 'Boiling breaks intermolecular attractions and leaves the covalent bonds inside each molecule intact, so bond strength is not the reason.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Octane molecules have many more electrons and a larger surface area, so the total London dispersion attraction between them exceeds the hydrogen bonding in water.', true, 'Correct: bp octane 126°C, water 100°C; octane is nonpolar, so only London forces act, which grow with electron count and surface area.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Octane forms hydrogen bonds through its many H atoms, and there are more of them than in water.', false, 'Hydrogen bonding needs H bonded to N, O or F, and H atoms bonded to C do not form hydrogen bonds.' from version_ins;
-- apchem-mcq-sv-h-3.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.1-a-v1', 'mcq', 'Hydrogen bonding versus dispersion forces (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Methanol (CH3OH, 32 g/mol) boils at 65°C, while pentane (C5H12, 72 g/mol) boils at 36°C. Pentane has more electrons and stronger dispersion forces, yet methanol boils higher. Which statement best explains this?', null, md5('apchem-mcq-sv-h-3.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The O-H bond in methanol is stronger than the C-H bonds in pentane, so more energy is needed to boil methanol.', false, 'Boiling overcomes attractions between molecules and does not break covalent bonds within them.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Hydrogen bonding between methanol molecules is strong enough to outweigh the greater dispersion forces of pentane.', true, 'Correct: methanol has an O-H group and hydrogen bonds; pentane is nonpolar with only dispersion forces. At these sizes the hydrogen bonds dominate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Pentane molecules are less polarizable than methanol molecules, so their dispersion forces are weaker.', false, 'Pentane has more electrons than methanol and is more polarizable, so its dispersion forces are stronger, not weaker.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Methanol has stronger London dispersion forces than pentane because oxygen is more electronegative than carbon.', false, 'Electronegativity creates dipoles and hydrogen bonds, and it does not make dispersion forces stronger.' from version_ins;
-- apchem-mcq-sv-h-3.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.1-a-v2', 'mcq', 'Hydrogen bonding versus dispersion forces (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The normal boiling points are HF 20°C, HCl -85°C, HBr -67°C and HI -35°C. Which statement best explains this pattern?', null, md5('apchem-mcq-sv-h-3.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The boiling points from HCl to HI rise because the bonds get more polar, and HF is the exception because it is smallest.', false, 'The bonds become less polar from HCl to HI, since electronegativity of the halogen falls, so polarity cannot explain the rise.' from version_ins
union all select gen_random_uuid(), id, 'B', 'HF has the highest boiling point because the H-F bond is the strongest, and the rise from HCl to HI is because those bonds get stronger.', false, 'The H-X bonds get weaker down the group, and boiling does not break them anyway.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The boiling points follow molar mass, so HI should be the highest and HF the lowest, and the HF value is probably in error.', false, 'The HF value is correct, and the exception is explained by hydrogen bonding that molar mass cannot account for.' from version_ins
union all select gen_random_uuid(), id, 'D', 'HF molecules hydrogen bond, which makes it unusually high, while the rise from HCl to HI is due to stronger dispersion forces as the molecules get larger.', true, 'Correct: HF hydrogen bonds; for HCl, HBr, HI the molecules have similar polarity and bp rises with size (dispersion).' from version_ins;
-- apchem-mcq-sv-h-3.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.1-a-v3', 'mcq', 'Hydrogen bonding versus dispersion forces (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 25°C, diethyl ether (CH3CH2OCH2CH3) has a vapor pressure of about 530 torr and 1-butanol (CH3CH2CH2CH2OH) about 7 torr. Both have a molar mass of 74 g/mol. Which statement best explains why 1-butanol has the much lower vapor pressure?', null, md5('apchem-mcq-sv-h-3.1-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1-butanol molecules hydrogen bond through their O-H groups, so the attractions are stronger and fewer molecules escape; diethyl ether has no O-H group.', true, 'Correct: equal molar mass (74 g/mol) so dispersion is similar; 1-butanol has O-H (hydrogen bonds), ether does not, so butanol''s attractions are stronger and its vapor pressure lower.' from version_ins
union all select gen_random_uuid(), id, 'B', '1-butanol has the larger molar mass, so its dispersion forces are much stronger.', false, 'Both molecules have the same molar mass, so dispersion forces are comparable and cannot account for the difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Diethyl ether is nonpolar, so its molecules escape the liquid more easily.', false, 'Diethyl ether is polar because of its bent C-O-C arrangement, so it is not nonpolar.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The C-O bonds in 1-butanol are stronger than those in diethyl ether, so 1-butanol molecules are harder to vaporize.', false, 'Vaporization does not break covalent bonds, so bond strength inside the molecule is not the reason.' from version_ins;
-- apchem-mcq-h-3.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.1-b', 'mcq', 'Polarity and shape at similar molar mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Iodine monochloride (ICl, 162 g/mol) boils at 97°C, while bromine (Br2, 160 g/mol) boils at 59°C. Which statement best explains why ICl boils higher?', null, md5('apchem-mcq-h-3.1-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ICl is ionic, so strong electrostatic attractions act between its ions.', false, 'ICl is a molecular compound with a polar covalent bond, and its particles are molecules, not ions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The I-Cl bond is stronger than the Br-Br bond, so more energy is needed to boil ICl.', false, 'Boiling overcomes forces between molecules and does not break bonds inside them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'ICl forms hydrogen bonds because it contains a very electronegative atom, chlorine.', false, 'Hydrogen bonding requires H bonded to N, O or F and neither ICl nor Br2 contains hydrogen.' from version_ins
union all select gen_random_uuid(), id, 'D', 'ICl is polar, so its molecules attract through dipole-dipole forces in addition to dispersion forces of similar size.', true, 'Correct: both molecules have about the same number of electrons, so dispersion forces are similar; ICl is polar (Cl more electronegative than I) and Br2 is nonpolar.' from version_ins;
-- apchem-mcq-sv-h-3.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.1-b-v1', 'mcq', 'Polarity and shape at similar molar mass (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pentane and neopentane both have the formula C5H12 (72 g/mol). Pentane (a straight chain) boils at 36°C and neopentane (a compact, nearly spherical molecule) boils at 10°C. Which statement best explains the difference?', null, md5('apchem-mcq-sv-h-3.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Pentane has more electrons than neopentane, so its dispersion forces are stronger.', false, 'Both molecules have the same formula and therefore the same number of electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Neopentane is polar, which weakens attractions between its molecules.', false, 'Neopentane is symmetric and nonpolar, and polarity is not what separates these two isomers.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Pentane forms hydrogen bonds along its chain, while neopentane cannot.', false, 'Neither molecule has H bonded to N, O or F, so neither can hydrogen bond.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Pentane molecules have a larger surface area for contact, so London dispersion forces between them are stronger than between compact neopentane molecules.', true, 'Correct: same formula, same number of electrons; the straight chain has more surface contact so stronger dispersion forces.' from version_ins;
-- apchem-mcq-sv-h-3.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.1-b-v2', 'mcq', 'Polarity and shape at similar molar mass (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ammonia (NH3, 17 g/mol) boils at -33°C and phosphine (PH3, 34 g/mol) boils at -88°C. Which statement best explains why NH3 boils higher despite its much smaller molar mass?', null, md5('apchem-mcq-sv-h-3.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The N-H bonds are weaker than the P-H bonds, so NH3 vaporizes at a higher temperature.', false, 'Boiling does not break the covalent N-H bonds, and the N-H bond is actually stronger than P-H.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NH3 molecules hydrogen bond with one another, while PH3 molecules do not hydrogen bond to a significant extent.', true, 'Correct: NH3 has H bonded to N and hydrogen bonds; PH3 does not hydrogen bond to a significant extent, so the hydrogen bonding of NH3 outweighs the greater dispersion forces of the larger PH3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'PH3 is more polar than NH3, so its dipole-dipole forces are stronger.', false, 'N is more electronegative than P, so NH3 is the more polar molecule.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NH3 has the larger London dispersion forces because nitrogen is smaller than phosphorus.', false, 'The smaller molecule has fewer electrons and weaker dispersion forces, not stronger ones.' from version_ins;
-- apchem-mcq-sv-h-3.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.1-b-v3', 'mcq', 'Polarity and shape at similar molar mass (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Propane (CH3CH2CH3, 44 g/mol) boils at -42°C and acetaldehyde (CH3CHO, 44 g/mol) boils at 20°C. Which statement best explains why acetaldehyde has the higher boiling point?', null, md5('apchem-mcq-sv-h-3.1-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Acetaldehyde molecules are polar, so dipole-dipole attractions add to dispersion forces of about the same size as in propane.', true, 'Correct: same molar mass so similar dispersion forces; acetaldehyde has a C=O dipole, propane is nonpolar; neither has an O-H or N-H group for hydrogen bonding.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Acetaldehyde molecules hydrogen bond through the H atom on its carbonyl carbon.', false, 'Hydrogen bonding needs H bonded to N, O or F; the H on the carbonyl carbon is bonded to C.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Acetaldehyde has stronger dispersion forces because it contains oxygen.', false, 'The two molecules have the same molar mass and similar numbers of electrons, so dispersion forces are similar.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Acetaldehyde is a larger molecule than propane, so its dispersion forces are much stronger.', false, 'The two molecules have the same molar mass, so their dispersion forces are about equal, and the difference comes from the dipole of acetaldehyde.' from version_ins;
-- apchem-mcq-h-3.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.2-a', 'mcq', 'Coulomb''s law and ionic melting points', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Magnesium oxide (MgO) melts at 2852°C, whereas sodium chloride (NaCl) melts at 801°C. Which statement best explains why MgO has the much higher melting point?', null, md5('apchem-mcq-h-3.2-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'MgO has covalent bonds between Mg and O, while NaCl has ionic bonds.', false, 'Both are ionic compounds, and the difference is the size of the charges and the ions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'MgO is a network solid, while NaCl is a molecular solid held by dispersion forces.', false, 'Neither solid is a network or a molecular solid, since both are ionic lattices.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The oxide ion has more electrons than the chloride ion, so dispersion forces are much stronger in MgO.', false, 'The oxide ion has fewer electrons than the chloride ion (10 compared with 18), and in any case dispersion forces are minor next to the Coulombic attractions between ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The Mg2+ and O2- ions have larger charges and are smaller than Na+ and Cl-, so the Coulombic attractions in the lattice are much stronger.', true, 'Correct: Coulombic force scales with the product of the charges and falls with distance: (2+)(2-) versus (1+)(1-), and the ions are also smaller.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-h-3.1-a','apchem-mcq-sv-h-3.1-a-v1','apchem-mcq-sv-h-3.1-a-v2','apchem-mcq-sv-h-3.1-a-v3','apchem-mcq-h-3.1-b','apchem-mcq-sv-h-3.1-b-v1','apchem-mcq-sv-h-3.1-b-v2','apchem-mcq-sv-h-3.1-b-v3','apchem-mcq-h-3.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-h-3.1-a','apchem-mcq-sv-h-3.1-a-v1','apchem-mcq-sv-h-3.1-a-v2','apchem-mcq-sv-h-3.1-a-v3','apchem-mcq-h-3.1-b','apchem-mcq-sv-h-3.1-b-v1','apchem-mcq-sv-h-3.1-b-v2','apchem-mcq-sv-h-3.1-b-v3','apchem-mcq-h-3.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
