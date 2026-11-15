begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-h-2.5-b','apchem-mcq-b5-sv-h-2.5-b-v1','apchem-mcq-b5-sv-h-2.5-b-v2','apchem-mcq-b5-sv-h-2.5-b-v3','apchem-mcq-b5-h-2.6-a','apchem-mcq-b5-sv-h-2.6-a-v1','apchem-mcq-b5-sv-h-2.6-a-v2','apchem-mcq-b5-sv-h-2.6-a-v3','apchem-mcq-b5-h-2.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apchem-mcq-b5-h-2.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.5-b', 'mcq', 'deduce the number of shared electron pairs between two atoms from the formula by combining the valence electron count an', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Diazene, N₂H₂, has each nitrogen atom bonded to one hydrogen atom and to the other nitrogen atom. In its best Lewis diagram every nitrogen atom has an octet and each hydrogen atom has two electrons. How many electron pairs are shared between the two nitrogen atoms?', null, md5('apchem-mcq-b5-h-2.5-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One pair, a single bond', false, 'A single N–N bond with two lone pairs on each nitrogen requires 14 valence electrons, but only 12 are available.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Three pairs, a triple bond', false, 'A triple bond would use 6 electrons for the N–N link and leave 2 electrons that must sit on one nitrogen as a lone pair, giving that atom 10 electrons, which breaks the octet.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Zero pairs, because the nitrogen atoms are joined only through the hydrogen atoms', false, 'The problem states that each nitrogen is bonded to the other nitrogen, and hydrogen can form only one bond.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Two pairs, a double bond', true, 'Correct: valence electrons = 2(5) + 2(1) = 12. The two N–H bonds use 4 electrons. If the N–N link were a single bond (2 electrons), two lone pairs on each nitrogen would need 8 more electrons, a total of 14, which exceeds 12. With a double bond (4 electrons) and one lone pair on each nitrogen (4 electrons), the total is 4 + 4 + 4 = 12 and every nitrogen has 2 + 4 + 2 = 8 electrons.' from version_ins;
-- apchem-mcq-b5-sv-h-2.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.5-b-v1', 'mcq', 'deduce the number of shared electron pairs between two atoms from the formula by combining the valence electron count an (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the molecule C₂H₂F₂, each carbon atom is bonded to one hydrogen atom, one fluorine atom and the other carbon atom. Every carbon atom has an octet in the best Lewis diagram. How many electron pairs are shared between the two carbon atoms?', null, md5('apchem-mcq-b5-sv-h-2.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One pair, a single bond', false, 'A single C–C bond would leave each carbon with only six electrons, which is short of an octet, and 2 valence electrons would remain unplaced.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Three pairs, a triple bond', false, 'A triple bond would require 6 electrons for the carbon link, but only 4 remain after bonds to H and F and the fluorine lone pairs are drawn.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two pairs, a double bond', true, 'Correct: valence electrons = 2(4) + 2(1) + 2(7) = 24. C–H and C–F bonds use 8 electrons and the fluorine lone pairs use 12, leaving 4 electrons for the C–C link, which is a double bond (check, each carbon has 2 + 2 + 4 = 8 electrons).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Four pairs, because each carbon needs four bonds to the other carbon atom', false, 'Four shared pairs would place 8 electrons between the carbons, more than the 4 available.' from version_ins;
-- apchem-mcq-b5-sv-h-2.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.5-b-v2', 'mcq', 'deduce the number of shared electron pairs between two atoms from the formula by combining the valence electron count an (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In ethyne, C₂H₂, each carbon atom is bonded to one hydrogen atom and to the other carbon atom. Every carbon atom has an octet in the best Lewis diagram. How many electron pairs are shared between the two carbon atoms?', null, md5('apchem-mcq-b5-sv-h-2.5-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One pair, a single bond, with a lone pair on each carbon', false, 'A single bond plus lone pairs would use only 4 + 2 + 4 = 10 electrons, but each carbon would have just 2 + 2 + 2 = 6 electrons, short of an octet.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Two pairs, a double bond', false, 'A double bond would leave each carbon with 2 + 4 = 6 electrons, and 2 valence electrons would be left over.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Three pairs, a triple bond', true, 'Correct: valence electrons = 2(4) + 2(1) = 10. The two C–H bonds use 4 electrons, leaving 6 electrons for the C–C link, which is a triple bond; each carbon then has 2 + 6 = 8 electrons.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Zero pairs, because carbon atoms do not bond to each other', false, 'Carbon atoms readily bond to each other, and the problem states that each carbon is bonded to the other.' from version_ins;
-- apchem-mcq-b5-sv-h-2.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.5-b-v3', 'mcq', 'deduce the number of shared electron pairs between two atoms from the formula by combining the valence electron count an (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In hydrazine, N₂H₄, each nitrogen atom is bonded to two hydrogen atoms and to the other nitrogen atom. Every nitrogen atom has an octet in the best Lewis diagram. How many electron pairs are shared between the two nitrogen atoms?', null, md5('apchem-mcq-b5-sv-h-2.5-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Two pairs, a double bond', false, 'A double bond would need 4 electrons, leaving too few for the lone pairs, and each nitrogen would then exceed eight electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Three pairs, a triple bond', false, 'A triple bond would give each nitrogen 10 electrons or more, which breaks the octet limit for a second-period atom.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two pairs, because every nitrogen must have two bonds to another nitrogen to complete an octet', false, 'Each nitrogen reaches an octet using its two N–H bonds, one N–N bond and a lone pair, so no extra N–N bond is needed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'One pair, a single bond', true, 'Correct: valence electrons = 2(5) + 4(1) = 14. Four N–H bonds use 8 electrons; the N–N single bond uses 2; the remaining 4 electrons are one lone pair on each nitrogen. Each nitrogen then has 4 + 2 + 2 = 8 electrons.' from version_ins;
-- apchem-mcq-b5-h-2.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.6-a', 'mcq', 'use all resonance contributors to predict the average bond order and the average formal charge on equivalent atoms', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The nitrate ion, NO₃⁻, has three equivalent resonance contributors. In each, nitrogen has formal charge +1 and forms one N=O double bond and two N–O single bonds; the doubly bonded oxygen has formal charge 0 and the other two oxygen atoms each have formal charge −1. Which statement describes the real ion?', null, md5('apchem-mcq-b5-h-2.6-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Each N–O bond has bond order 1.5, and each oxygen atom carries −0.5.', false, 'Bond order 1.5 and −0.5 belong to ions with two contributors such as NO₂⁻, but NO₃⁻ has three contributors.' from version_ins
union all select gen_random_uuid(), id, 'B', 'One N–O bond is a double bond and two are single bonds, and the oxygen atoms carry charges of 0, −1 and −1.', false, 'This describes a single contributor, but the real ion is a hybrid in which the three N–O bonds are identical.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Each N–O bond has bond order 4/3, and each oxygen atom carries an average charge of −2/3.', true, 'Correct: the bonds per N–O link total 2 + 1 + 1 = 4 spread over 3 equivalent positions, so the bond order is 4/3. The oxygen charges (0, −1, −1) average to −2/3 per oxygen, and nitrogen stays at +1, so the total is +1 − 2 = −1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Each N–O bond has bond order 1, and each oxygen atom carries −1.', false, 'Three oxygen atoms at −1 plus nitrogen at +1 would give −2 overall, which does not match the −1 charge of the ion.' from version_ins;
-- apchem-mcq-b5-sv-h-2.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.6-a-v1', 'mcq', 'use all resonance contributors to predict the average bond order and the average formal charge on equivalent atoms (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The nitrite ion, NO₂⁻, has two equivalent resonance contributors. In each, nitrogen has formal charge 0, one oxygen forms an N=O double bond with formal charge 0, and the other oxygen forms an N–O single bond with formal charge −1. Which statement describes the real ion?', null, md5('apchem-mcq-b5-sv-h-2.6-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One N–O bond is a double bond and the other is a single bond, and one oxygen carries −1.', false, 'This is one contributor and not the real ion, where both N–O bonds are equal in length and strength.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Each N–O bond has bond order 4/3, and each oxygen atom carries −2/3.', false, '4/3 and −2/3 are the values for an ion with three equivalent contributors such as NO₃⁻ or CO₃²⁻.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Each N–O bond has bond order 2, and each oxygen atom carries −0.5.', false, 'The actual bond order is not 2, because the double bond is shared between both oxygen atoms across the contributors.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Each N–O bond has bond order 1.5, and each oxygen atom carries an average charge of −0.5.', true, 'Correct: the bond order is (2 + 1) ÷ 2 = 1.5, and the oxygen charge averages (0 − 1) ÷ 2 = −0.5; nitrogen remains 0, so the total is −1.' from version_ins;
-- apchem-mcq-b5-sv-h-2.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.6-a-v2', 'mcq', 'use all resonance contributors to predict the average bond order and the average formal charge on equivalent atoms (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The carbonate ion, CO₃²⁻, has three equivalent resonance contributors. In each, carbon has formal charge 0 and forms one C=O double bond and two C–O single bonds; the doubly bonded oxygen has formal charge 0 and the other two oxygen atoms have formal charge −1. Which statement describes the real ion?', null, md5('apchem-mcq-b5-sv-h-2.6-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Each C–O bond has bond order 1.5, and each oxygen atom carries −0.5.', false, 'Bond order 1.5 and −0.5 describe two contributors, but carbonate has three, so the shared double bond is spread over three positions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Each C–O bond has bond order 1, and each oxygen atom carries −1.', false, 'This ignores the double bond altogether, and three oxygen atoms at −1 would give −3 overall, not the −2 charge of the ion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'One C–O bond is a double bond and two are single bonds, and the oxygen atoms carry 0, −1 and −1.', false, 'This describes a single contributor and treats one of the three equivalent oxygen atoms as different from the others.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Each C–O bond has bond order 4/3, and each oxygen atom carries an average charge of −2/3.', true, 'Correct: the bond order is (2 + 1 + 1) ÷ 3 = 4/3, and the oxygen charge averages (0 − 1 − 1) ÷ 3 = −2/3; with carbon at 0, the total is −2.' from version_ins;
-- apchem-mcq-b5-sv-h-2.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.6-a-v3', 'mcq', 'use all resonance contributors to predict the average bond order and the average formal charge on equivalent atoms (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The acetate ion, CH₃COO⁻, has two equivalent resonance contributors. In each, carbon forms either a C=O double bond or a C–O single bond with each oxygen. A single C–O bond is about 143 pm long and a C=O double bond is about 120 pm long. Which statement describes the two C–O bonds in the real ion?', null, md5('apchem-mcq-b5-sv-h-2.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One C–O bond is about 143 pm and the other is about 120 pm, and the ion switches rapidly between them.', false, 'Resonance contributors are not structures that interconvert; the ion is a single hybrid, in which both C–O bonds are identical.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The two C–O bonds are equal in length, with a value between 120 pm and 143 pm, because the real ion is a hybrid of both contributors.', true, 'Correct: the bond order of each C–O bond is (2 + 1) ÷ 2 = 1.5, so the length falls between the single-bond and double-bond values and both are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both C–O bonds are about 143 pm, because the negative charge makes both bonds single.', false, 'The negative charge is shared between the oxygen atoms and does not turn both bonds into single bonds, which would make a bond order of 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both C–O bonds are about 120 pm, because the double bond is always present on both oxygen atoms.', false, 'A bond order of 2 for both bonds would require two double bonds to carbon, which exceeds the bonding of one carbon in this ion.' from version_ins;
-- apchem-mcq-b5-h-2.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.6-b', 'mcq', 'distinguish formal charge from oxidation number for the same atom in the same species', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In the ammonium ion, NH₄⁺, nitrogen forms four single bonds to hydrogen and has no lone pairs. A student states that formal charge and oxidation number are the same quantity. Which choice gives the formal charge and the oxidation number of nitrogen in NH₄⁺?', null, md5('apchem-mcq-b5-h-2.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Formal charge +1, oxidation number +1', false, 'It uses the charge of the ion for both quantities, but oxidation numbers assign shared electrons to the more electronegative atom, which is nitrogen, so nitrogen is negative.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Formal charge −3, oxidation number −3', false, 'It applies the oxidation number to the formal charge, but formal charge splits each shared pair equally, and a nitrogen with four bonds has +1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Formal charge +1, oxidation number −3', true, 'Correct: formal charge = 5 valence electrons − 0 nonbonding electrons − 4 bonds = +1. Oxidation number: hydrogen is +1 (4 × +1 = +4), so N + 4 = +1 gives N = −3.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Formal charge 0, oxidation number −3', false, 'It miscounts the formal charge as zero, which would need three bonds and a lone pair, as in NH₃, not four bonds.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-h-2.5-b','apchem-mcq-b5-sv-h-2.5-b-v1','apchem-mcq-b5-sv-h-2.5-b-v2','apchem-mcq-b5-sv-h-2.5-b-v3','apchem-mcq-b5-h-2.6-a','apchem-mcq-b5-sv-h-2.6-a-v1','apchem-mcq-b5-sv-h-2.6-a-v2','apchem-mcq-b5-sv-h-2.6-a-v3','apchem-mcq-b5-h-2.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-h-2.5-b','apchem-mcq-b5-sv-h-2.5-b-v1','apchem-mcq-b5-sv-h-2.5-b-v2','apchem-mcq-b5-sv-h-2.5-b-v3','apchem-mcq-b5-h-2.6-a','apchem-mcq-b5-sv-h-2.6-a-v1','apchem-mcq-b5-sv-h-2.6-a-v2','apchem-mcq-b5-sv-h-2.6-a-v3','apchem-mcq-b5-h-2.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
