begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.6-b-v1','apchem-mcq-b5-sv-h-2.6-b-v2','apchem-mcq-b5-sv-h-2.6-b-v3','apchem-mcq-b5-h-2.7-a','apchem-mcq-b5-sv-h-2.7-a-v1','apchem-mcq-b5-sv-h-2.7-a-v2','apchem-mcq-b5-sv-h-2.7-a-v3','apchem-mcq-b5-h-2.7-b','apchem-mcq-b5-sv-h-2.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apchem-mcq-b5-sv-h-2.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.6-b-v1', 'mcq', 'distinguish formal charge from oxidation number for the same atom in the same species (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the hydronium ion, H₃O⁺, oxygen forms three single bonds to hydrogen and has one lone pair. Which choice gives the formal charge and the oxidation number of oxygen in H₃O⁺?', null, md5('apchem-mcq-b5-sv-h-2.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Formal charge +1, oxidation number −2', true, 'Correct: formal charge = 6 − 2 − 3 = +1. Oxidation number: 3(+1) + O = +1, so O = −2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Formal charge −2, oxidation number +1', false, 'This swaps the two values, and the formal charge of oxygen with three bonds and a lone pair is +1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Formal charge +1, oxidation number +1', false, 'It uses the ion charge for the oxidation number, but the oxidation number of oxygen bonded to hydrogen is −2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Formal charge −2, oxidation number −2', false, 'It assigns oxygen its usual oxidation number as its formal charge, but formal charge splits the shared electrons equally.' from version_ins;
-- apchem-mcq-b5-sv-h-2.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.6-b-v2', 'mcq', 'distinguish formal charge from oxidation number for the same atom in the same species (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the tetrafluoroborate ion, BF₄⁻, boron forms four single bonds to fluorine and has no lone pairs. Which choice gives the formal charge and the oxidation number of boron in BF₄⁻?', null, md5('apchem-mcq-b5-sv-h-2.6-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Formal charge −1, oxidation number +3', true, 'Correct: formal charge = 3 − 0 − 4 = −1. Oxidation number: 4(−1) + B = −1, so B = +3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Formal charge +3, oxidation number +3', false, 'It treats the two numbers as the same, but formal charge splits the shared pairs equally, so boron has −1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Formal charge −1, oxidation number −1', false, 'It takes the ion charge as both quantities, but fluorine is more electronegative and takes the shared electrons, giving boron +3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Formal charge +3, oxidation number −1', false, 'It reverses the two values, though boron has three valence electrons and four bonds, which gives −1 as formal charge.' from version_ins;
-- apchem-mcq-b5-sv-h-2.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.6-b-v3', 'mcq', 'distinguish formal charge from oxidation number for the same atom in the same species (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In one Lewis diagram of the sulfite ion, SO₃²⁻, sulfur forms three single bonds to oxygen and has one lone pair. Which choice gives the formal charge and the oxidation number of sulfur in this diagram?', null, md5('apchem-mcq-b5-sv-h-2.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Formal charge +1, oxidation number +4', true, 'Correct: formal charge = 6 − 2 − 3 = +1. Oxidation number: 3(−2) + S = −2, so S = +4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Formal charge +4, oxidation number +4', false, 'It uses the oxidation number for the formal charge, but formal charge assigns bonding electrons equally and gives sulfur +1 here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Formal charge +1, oxidation number +1', false, 'It assigns formal charge as the oxidation number, but oxidation numbers give the shared electrons to oxygen, which is more electronegative, so sulfur is +4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Formal charge −2, oxidation number +4', false, 'It takes the ion charge as the formal charge on sulfur, but the charge of the ion is the sum over all four atoms.' from version_ins;
-- apchem-mcq-b5-h-2.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.7-a', 'mcq', 'count sigma and pi bonds and assign hybridization for several atoms in a molecule from its bonding pattern', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Acrylonitrile, H₂C=CH–C≡N, is used to make plastics. Its atoms are bonded as shown: a C=C double bond, a C–C single bond and a C≡N triple bond, with two hydrogen atoms on the first carbon and one on the second. Which statement about its bonding is correct?', null, md5('apchem-mcq-b5-h-2.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has 5 sigma bonds and 4 pi bonds, and the carbon in the C≡N group is sp hybridized.', false, 'It counts the triple bond as three pi bonds, but every multiple bond contains exactly one sigma bond, so the count of sigma bonds is 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has 6 sigma bonds and 3 pi bonds, and the carbon in the C≡N group is sp hybridized.', true, 'Correct: sigma bonds are 3 C–H, 1 C=C, 1 C–C and 1 C≡N, a total of 6; pi bonds are 1 in C=C and 2 in C≡N, a total of 3. The nitrile carbon has 2 electron domains (one single bond and one triple bond), so it is sp; the CH₂ carbon has 3 domains and is sp².' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has 6 sigma bonds and 3 pi bonds, and the carbon in the C≡N group is sp² hybridized.', false, 'The carbon in the nitrile group has two electron domains, not three, so it is sp hybridized and not sp².' from version_ins
union all select gen_random_uuid(), id, 'D', 'It has 6 sigma bonds and 3 pi bonds, and the CH₂ carbon is sp³ hybridized.', false, 'The CH₂ carbon has three electron domains, two C–H bonds and one double bond to carbon, so it is sp² and not sp³.' from version_ins;
-- apchem-mcq-b5-sv-h-2.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.7-a-v1', 'mcq', 'count sigma and pi bonds and assign hybridization for several atoms in a molecule from its bonding pattern (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Propyne, H₃C–C≡C–H, has a methyl carbon bonded to three hydrogen atoms and a C≡C triple bond to a carbon that is bonded to the last hydrogen. Which statement about its bonding is correct?', null, md5('apchem-mcq-b5-sv-h-2.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has 6 sigma bonds and 2 pi bonds, and the methyl carbon is sp³ hybridized while both other carbons are sp hybridized.', true, 'Correct: sigma bonds are 3 C–H (methyl), 1 C–C, 1 C≡C and 1 C–H (terminal), a total of 6; pi bonds are 2 in the triple bond. The methyl carbon has 4 domains (sp³), and the two triple-bonded carbons have 2 domains each (sp).' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has 6 sigma bonds and 2 pi bonds, and the methyl carbon is sp² hybridized.', false, 'The methyl carbon has four single bonds, so it has four electron domains and is sp³, not sp².' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has 5 sigma bonds and 3 pi bonds, and the terminal carbon is sp hybridized.', false, 'It counts 5 sigma bonds, which treats part of the triple bond as pi bonds only, but a triple bond has 1 sigma bond and 2 pi bonds.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It has 6 sigma bonds and 2 pi bonds, and all three carbon atoms are sp hybridized.', false, 'The methyl carbon has four sigma bonds and no pi bonds, so it requires four hybrid orbitals and is sp³.' from version_ins;
-- apchem-mcq-b5-sv-h-2.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.7-a-v2', 'mcq', 'count sigma and pi bonds and assign hybridization for several atoms in a molecule from its bonding pattern (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Acetaldehyde, H₃C–CH=O, has a methyl carbon bonded to a second carbon, which is bonded to one hydrogen atom and double bonded to oxygen. Which statement about its bonding is correct?', null, md5('apchem-mcq-b5-sv-h-2.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has 5 sigma bonds and 2 pi bonds, and the carbonyl carbon is sp hybridized.', false, 'It counts 5 sigma bonds and 2 pi bonds, treating the C=O as two pi bonds, and it assigns sp to a carbon with 3 domains.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has 6 sigma bonds and 1 pi bond, and the carbonyl carbon is sp³ hybridized.', false, 'The sigma and pi counts are correct, but the carbonyl carbon has three electron domains, and sp³ would need four.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has 6 sigma bonds and 1 pi bond, and the carbonyl carbon is sp² hybridized.', true, 'Correct: sigma bonds are 3 C–H (methyl), 1 C–C, 1 C–H and 1 C=O, a total of 6; the C=O double bond has 1 pi bond. The carbonyl carbon has 3 electron domains (C, H, O), so it is sp².' from version_ins
union all select gen_random_uuid(), id, 'D', 'It has 7 sigma bonds and 0 pi bonds, because a double bond counts as two sigma bonds.', false, 'A double bond is one sigma bond plus one pi bond, and not two sigma bonds, so the molecule has 6 sigma bonds and 1 pi bond.' from version_ins;
-- apchem-mcq-b5-sv-h-2.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.7-a-v3', 'mcq', 'count sigma and pi bonds and assign hybridization for several atoms in a molecule from its bonding pattern (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Acetonitrile, H₃C–C≡N, has a methyl carbon bonded to a carbon that has a triple bond to nitrogen. Which statement about its bonding is correct?', null, md5('apchem-mcq-b5-sv-h-2.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It has 5 sigma bonds and 2 pi bonds, and the nitrogen atom is sp hybridized.', true, 'Correct: sigma bonds are 3 C–H, 1 C–C and 1 C≡N, a total of 5; pi bonds are 2. Nitrogen has 2 electron domains (one triple bond and one lone pair), so it is sp hybridized.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It has 5 sigma bonds and 2 pi bonds, and the methyl carbon is sp hybridized.', false, 'The methyl carbon has four sigma bonds and no pi bonds, so it is sp³ and not sp.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It has 4 sigma bonds and 3 pi bonds, and the nitrogen atom is sp hybridized.', false, 'It counts only 4 sigma bonds and 3 pi bonds, which wrongly treats the triple bond as three pi bonds with no sigma bond.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It has 5 sigma bonds and 2 pi bonds, and the nitrogen atom is sp³ hybridized.', false, 'Nitrogen has two electron domains, a bond domain and a lone pair, which needs 2 hybrid orbitals and so is sp and not sp³.' from version_ins;
-- apchem-mcq-b5-h-2.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.7-b', 'mcq', 'use electron-domain repulsion, including the greater repulsion of lone pairs, to explain observed deviations in bond ang', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The H–X–H bond angles are about 109.5° in CH₄, 107° in NH₃ and 104.5° in H₂O. In each molecule the central atom has four electron domains. Which explanation best accounts for the decrease?', null, md5('apchem-mcq-b5-h-2.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nitrogen and oxygen are more electronegative than carbon, so they pull the hydrogen atoms closer together.', false, 'Electronegativity changes bond polarity but does not account for the angle trend through the order of repulsions between domains.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lone pairs are attracted to the hydrogen nuclei and pull the hydrogen atoms toward each other.', false, 'Lone pairs do not attract the hydrogen nuclei, and the angle decreases because the lone pair repels the bonding pairs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A lone pair repels neighboring electron domains more strongly than a bonding pair does, so as lone pairs replace bonding pairs the bonding pairs are pushed closer together.', true, 'Correct: all three have tetrahedral electron-domain geometry (ideal 109.5°); NH₃ has 1 lone pair and H₂O has 2, and the lone pair-bonding pair repulsion exceeds the bonding pair-bonding pair repulsion, compressing the angle.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The central atoms get smaller from carbon to oxygen, so the hydrogen atoms crowd together and the angle must narrow.', false, 'The H–X–H angle in VSEPR is set by repulsions among electron domains and not by the size of the central atom.' from version_ins;
-- apchem-mcq-b5-sv-h-2.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.7-b-v1', 'mcq', 'use electron-domain repulsion, including the greater repulsion of lone pairs, to explain observed deviations in bond ang (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In SF₆ every F–S–F angle between adjacent fluorine atoms is 90°. In BrF₅, which also has six electron domains around the central atom, the angle between the axial fluorine and each basal fluorine is about 85°. Which explanation best accounts for the smaller angle in BrF₅?', null, md5('apchem-mcq-b5-sv-h-2.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Bromine is larger than sulfur, so the fluorine atoms are forced closer together.', false, 'The angle change is explained by repulsion of electron domains and not by the size of the central atom.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fluorine is more electronegative in BrF₅ than in SF₆, so the F atoms pull toward each other.', false, 'The fluorine atoms are the same element in both species and the bond polarity does not set the angle in VSEPR.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The lone pair on bromine attracts the fluorine atoms, which pulls them toward the lone pair and increases the angle.', false, 'Lone pairs repel, not attract, the bonding pairs, and the observed angle gets smaller, not larger.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The lone pair on bromine repels the bonding pairs more strongly than they repel one another, pushing the fluorine atoms away from the lone pair and closer to the axial fluorine.', true, 'Correct: both have octahedral electron-domain geometry; BrF₅ has one lone pair, which repels bonding pairs more strongly than they repel each other and bends the F atoms away from it.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.6-b-v1','apchem-mcq-b5-sv-h-2.6-b-v2','apchem-mcq-b5-sv-h-2.6-b-v3','apchem-mcq-b5-h-2.7-a','apchem-mcq-b5-sv-h-2.7-a-v1','apchem-mcq-b5-sv-h-2.7-a-v2','apchem-mcq-b5-sv-h-2.7-a-v3','apchem-mcq-b5-h-2.7-b','apchem-mcq-b5-sv-h-2.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-sv-h-2.6-b-v1','apchem-mcq-b5-sv-h-2.6-b-v2','apchem-mcq-b5-sv-h-2.6-b-v3','apchem-mcq-b5-h-2.7-a','apchem-mcq-b5-sv-h-2.7-a-v1','apchem-mcq-b5-sv-h-2.7-a-v2','apchem-mcq-b5-sv-h-2.7-a-v3','apchem-mcq-b5-h-2.7-b','apchem-mcq-b5-sv-h-2.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
