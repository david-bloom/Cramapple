begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-h-2.1-a','apchem-mcq-b5-sv-h-2.1-a-v1','apchem-mcq-b5-sv-h-2.1-a-v2','apchem-mcq-b5-sv-h-2.1-a-v3','apchem-mcq-b5-h-2.1-b','apchem-mcq-b5-sv-h-2.1-b-v1','apchem-mcq-b5-sv-h-2.1-b-v2','apchem-mcq-b5-sv-h-2.1-b-v3','apchem-mcq-b5-h-2.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apchem-mcq-b5-h-2.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.1-a', 'mcq', 'classify the bonding in a solid from a set of property data, resisting a single misleading cue (low melting temperature)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Substance Q is a silvery solid that can be cut with a knife. It conducts electricity as a solid, can be hammered into thin sheets without breaking, and melts at 98°C. A student reasons that the low melting temperature shows that Q consists of separate molecules held together by weak forces. Which statement is best supported by all of the data?', null, md5('apchem-mcq-b5-h-2.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q is a molecular solid, because a low melting temperature always indicates weak attractions between separate molecules.', false, 'Molecular solids do not conduct electricity as solids and are not malleable, so these data contradict a molecular model even though the melting temperature is low.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q is an ionic solid, because its metal atoms have transferred electrons to nonmetal atoms in a lattice.', false, 'Ionic solids are brittle and do not conduct as solids, because their ions are fixed in the lattice.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q is a metallic solid; conduction as a solid and malleability require delocalized electrons shared among metal cations, and the low melting temperature only shows that these attractions are comparatively weak.', true, 'Correct: conduction in the solid state plus malleability point to a sea of delocalized electrons around metal cations, so the bonding is metallic. A low melting temperature is consistent with metallic bonding that is weak, such as in sodium, 98°C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q is a network covalent solid, because covalent bonds between neighboring atoms allow it to conduct as a solid.', false, 'Network covalent solids are very hard with very high melting temperatures, and their electrons are localized in bonds, so they are not malleable.' from version_ins;
-- apchem-mcq-b5-sv-h-2.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.1-a-v1', 'mcq', 'classify the bonding in a solid from a set of property data, resisting a single misleading cue (low melting temperature) (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Substance R is a gray solid that conducts electricity both as a solid and as a liquid. It can be pressed into a new shape without shattering, and it melts at 30°C, just above room temperature. A student argues that because R melts so easily it must be a molecular compound. Which statement is best supported by all of the data?', null, md5('apchem-mcq-b5-sv-h-2.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R is a molecular solid, because substances with melting temperatures near room temperature are always made of small molecules.', false, 'Molecular solids have no mobile charge carriers and cannot conduct as solids, so the conductivity rules out a molecular model despite the low melting temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'R is an ionic solid, because it conducts electricity when it is a liquid.', false, 'Ionic solids conduct only when molten or dissolved, not as solids, and they shatter when struck instead of changing shape.' from version_ins
union all select gen_random_uuid(), id, 'C', 'R is a metallic solid; its delocalized valence electrons explain conduction and shape change, and the low melting temperature simply means the attraction between cations and electrons is relatively weak.', true, 'Correct: conduction as a solid and malleability require mobile delocalized electrons, which identifies metallic bonding; gallium is a real example, melting at about 30°C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R is a network covalent solid, because covalent bonds hold the atoms together in a continuous array that can be reshaped.', false, 'Network covalent solids have very high melting temperatures, and covalent networks are rigid and would fracture rather than be pressed into shape.' from version_ins;
-- apchem-mcq-b5-sv-h-2.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.1-a-v2', 'mcq', 'classify the bonding in a solid from a set of property data, resisting a single misleading cue (low melting temperature) (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Substance S is a colorless crystal that does not conduct electricity as a solid or when molten, is extremely hard, does not dissolve in water, and melts above 1700°C. A student concludes that the high melting temperature shows S is ionic. Which statement is best supported by all of the data?', null, md5('apchem-mcq-b5-sv-h-2.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'S is an ionic solid, because only ionic attractions are strong enough to give a melting temperature above 1700°C.', false, 'An ionic compound would conduct once it is molten because its ions would be free to move, and S does not.' from version_ins
union all select gen_random_uuid(), id, 'B', 'S is a metallic solid, because very hard solids with high melting temperatures contain a sea of delocalized electrons.', false, 'A metallic solid would conduct electricity as a solid, which S does not.' from version_ins
union all select gen_random_uuid(), id, 'C', 'S is a molecular solid, because it is a nonconductor and nonconductors are always made of discrete molecules.', false, 'Molecular solids have weak forces between molecules and melt at low temperatures, so they cannot be extremely hard with a melting temperature above 1700°C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'S is a network covalent solid; each atom is covalently bonded to its neighbors in a continuous three-dimensional array, so there are no mobile ions or electrons and melting requires breaking many covalent bonds.', true, 'Correct: a nonconductor in both solid and molten states has no mobile ions, which rules out ionic bonding; extreme hardness and a very high melting temperature indicate a covalent network, as in quartz or diamond.' from version_ins;
-- apchem-mcq-b5-sv-h-2.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.1-a-v3', 'mcq', 'classify the bonding in a solid from a set of property data, resisting a single misleading cue (low melting temperature) (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Substance T is a white, brittle solid that does not conduct electricity as a solid but conducts well when molten at 650°C. A student concludes that T is a metal because it conducts when molten. Which statement is best supported by all of the data?', null, md5('apchem-mcq-b5-sv-h-2.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T is a metallic solid, because any substance that conducts electricity when molten must contain delocalized electrons.', false, 'A metal would conduct as a solid, and T does not, so molten conductivity alone cannot distinguish metallic from ionic bonding.' from version_ins
union all select gen_random_uuid(), id, 'B', 'T is a network covalent solid, because it is brittle and the melting temperature is high.', false, 'Network covalent solids do not conduct when molten because they have no mobile ions or electrons, whereas T does.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T is a molecular solid, because it is a nonconductor in the solid state.', false, 'Molecular solids do not conduct when molten either, because neutral molecules carry no charge.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T is an ionic solid; its ions are fixed in a lattice in the solid, so it does not conduct, and they become mobile charge carriers when T melts.', true, 'Correct: nonconductor as a solid, brittle, and conducting only when molten is the pattern for an ionic solid; the charge carriers when molten are ions, not electrons.' from version_ins;
-- apchem-mcq-b5-h-2.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.1-b', 'mcq', 'use electronegativity values to determine the direction of bond polarity, including cases where hydrogen is the more ele', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pauling electronegativities: H 2.20, C 2.55, Si 1.90. A student states that in any bond to hydrogen, the hydrogen atom carries the partial positive charge. Which statement correctly gives the partial charge on the hydrogen atom in the C–H bonds of CH₄ and in the Si–H bonds of SiH₄?', null, md5('apchem-mcq-b5-h-2.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hydrogen is δ+ in CH₄ and δ− in SiH₄, because the shared electrons are drawn toward the more electronegative atom in each bond.', true, 'Correct: in C–H the difference is 2.55 − 2.20 = 0.35 with C more electronegative, so H is δ+; in Si–H the difference is 2.20 − 1.90 = 0.30 with H more electronegative, so H is δ−.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Hydrogen is δ+ in both CH₄ and SiH₄, because hydrogen is always the less electronegative partner.', false, 'Hydrogen is not always the less electronegative atom; silicon at 1.90 is less electronegative than hydrogen at 2.20, so the polarity reverses.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Hydrogen carries no partial charge in either molecule, because C, Si and H all form covalent bonds by sharing electrons.', false, 'Sharing electrons does not make the sharing equal, and unequal electronegativities give polar covalent bonds with partial charges.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Hydrogen is δ− in CH₄ and δ+ in SiH₄, because the larger electronegativity difference makes it more negative.', false, 'This reverses both directions, because carbon at 2.55 attracts the shared pair more than hydrogen and hydrogen attracts it more than silicon.' from version_ins;
-- apchem-mcq-b5-sv-h-2.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.1-b-v1', 'mcq', 'use electronegativity values to determine the direction of bond polarity, including cases where hydrogen is the more ele (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pauling electronegativities: H 2.20, B 2.04, N 3.04. Which statement correctly gives the partial charge on the hydrogen atom in BH₃ and in NH₃?', null, md5('apchem-mcq-b5-sv-h-2.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hydrogen is δ+ in both BH₃ and NH₃.', false, 'It assumes that hydrogen is always the positive end, but boron is less electronegative than hydrogen, so the shared pair shifts toward hydrogen in BH₃.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Hydrogen is δ− in BH₃ and δ+ in NH₃.', true, 'Correct: in B–H, H (2.20) is more electronegative than B (2.04), so H is δ−; in N–H, N (3.04) is more electronegative than H (2.20), so H is δ+.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Hydrogen is δ+ in BH₃ and δ− in NH₃.', false, 'This reverses the polarity of both bonds and ignores that nitrogen at 3.04 pulls the shared pair away from hydrogen at 2.20.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Hydrogen is δ− in both BH₃ and NH₃, because hydrogen has only one electron to share.', false, 'The number of valence electrons an atom has does not set bond polarity, and nitrogen attracts the shared electrons more strongly than hydrogen.' from version_ins;
-- apchem-mcq-b5-sv-h-2.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.1-b-v2', 'mcq', 'use electronegativity values to determine the direction of bond polarity, including cases where hydrogen is the more ele (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pauling electronegativities: H 2.20, Na 0.93, Br 2.96. Which statement correctly describes the charge on the hydrogen atom in the compound NaH and in the molecule HBr?', null, md5('apchem-mcq-b5-sv-h-2.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hydrogen is δ+ or positively charged in both NaH and HBr.', false, 'This treats hydrogen as the positive end of every bond, but sodium at 0.93 is far less electronegative than hydrogen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Hydrogen is negatively charged in NaH, and it carries a partial positive charge in HBr.', true, 'Correct: in NaH the electronegativity difference is 2.20 − 0.93 = 1.27 with H more electronegative, so H is the negative end; in HBr, Br at 2.96 is more electronegative than H at 2.20, so H is δ+.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Hydrogen is negatively charged in HBr and positively charged in NaH.', false, 'This reverses both cases, because bromine at 2.96 attracts the shared pair more than hydrogen and hydrogen attracts the electrons more than sodium does.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Hydrogen is neutral in NaH and δ+ in HBr, because only HBr has a difference in electronegativity.', false, 'NaH also has a large electronegativity difference, 1.27, so hydrogen is not neutral there.' from version_ins;
-- apchem-mcq-b5-sv-h-2.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.1-b-v3', 'mcq', 'use electronegativity values to determine the direction of bond polarity, including cases where hydrogen is the more ele (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pauling electronegativities: H 2.20, Ge 2.01, O 3.44. Which statement correctly gives the partial charge on the hydrogen atoms in GeH₄ and in H₂O?', null, md5('apchem-mcq-b5-sv-h-2.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hydrogen is δ+ in both GeH₄ and H₂O, because it is the smallest atom in each molecule.', false, 'Atomic size does not decide polarity, which depends on electronegativity, and germanium at 2.01 is less electronegative than hydrogen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Hydrogen is δ+ in GeH₄ and δ− in H₂O.', false, 'This reverses both bonds, since oxygen is the more electronegative atom in water and hydrogen is the more electronegative atom in GeH₄.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Hydrogen is δ− in GeH₄ and δ+ in H₂O.', true, 'Correct: in Ge–H, H (2.20) exceeds Ge (2.01) so H is δ−; in O–H, O (3.44) exceeds H (2.20) so H is δ+.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Hydrogen is δ− in both GeH₄ and H₂O, because it is bonded to a central atom in each.', false, 'Being bonded to a central atom does not make hydrogen negative, and in water oxygen draws the electrons away from hydrogen.' from version_ins;
-- apchem-mcq-b5-h-2.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.2-a', 'mcq', 'read bond length (position of the minimum) and bond energy (depth of the minimum) from potential-energy data, without as', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Potential energy (PE) is defined as 0 kJ/mol for fully separated atoms. A student records PE for two hypothetical diatomic molecules, X₂ and Y₂, at several internuclear distances.
Distance (pm): 90, 110, 130, 150, 170
PE of X₂ (kJ/mol): +50, −300, −180, −90, −30
PE of Y₂ (kJ/mol): +900, −200, −430, −520, −400
Which statement correctly compares the two molecules?', null, md5('apchem-mcq-b5-h-2.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Y₂ has the longer bond, and Y₂ has the greater bond energy.', true, 'Correct: the minimum for X₂ is −300 kJ/mol at 110 pm and for Y₂ is −520 kJ/mol at 150 pm. Bond length is the distance at the minimum (150 pm > 110 pm, so Y₂ is longer) and bond energy is the depth of the minimum (520 > 300 kJ/mol, so Y₂ is stronger).' from version_ins
union all select gen_random_uuid(), id, 'B', 'X₂ has the longer bond, and X₂ has the greater bond energy.', false, 'It reads both quantities for the wrong molecule; the lowest PE and the larger distance both belong to Y₂.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X₂ has the longer bond, and Y₂ has the greater bond energy.', false, 'It reverses the bond lengths, because the PE minimum of X₂ occurs at the shorter distance, 110 pm.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Y₂ has the longer bond, and X₂ has the greater bond energy.', false, 'It applies the rule that the longer bond must be the weaker one, but bond energy is the depth of the well, and Y₂ has the deeper well at the longer distance.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-h-2.1-a','apchem-mcq-b5-sv-h-2.1-a-v1','apchem-mcq-b5-sv-h-2.1-a-v2','apchem-mcq-b5-sv-h-2.1-a-v3','apchem-mcq-b5-h-2.1-b','apchem-mcq-b5-sv-h-2.1-b-v1','apchem-mcq-b5-sv-h-2.1-b-v2','apchem-mcq-b5-sv-h-2.1-b-v3','apchem-mcq-b5-h-2.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-h-2.1-a','apchem-mcq-b5-sv-h-2.1-a-v1','apchem-mcq-b5-sv-h-2.1-a-v2','apchem-mcq-b5-sv-h-2.1-a-v3','apchem-mcq-b5-h-2.1-b','apchem-mcq-b5-sv-h-2.1-b-v1','apchem-mcq-b5-sv-h-2.1-b-v2','apchem-mcq-b5-sv-h-2.1-b-v3','apchem-mcq-b5-h-2.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
