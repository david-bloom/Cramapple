begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.4-a-v3','apchem-mcq-b6-h-1.4-b','apchem-mcq-b6-sv-h-1.4-b-v1','apchem-mcq-b6-sv-h-1.4-b-v2','apchem-mcq-b6-sv-h-1.4-b-v3','apchem-mcq-b6-h-1.5-a','apchem-mcq-b6-sv-h-1.5-a-v1','apchem-mcq-b6-sv-h-1.5-a-v2','apchem-mcq-b6-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apchem-mcq-b6-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.4-a-v3', 'mcq', 'determine the number of waters of hydration from a heating-to-constant-mass data series, recognizing that only the final (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 3.000 g of a hydrated cobalt(II) chloride, CoCl₂·xH₂O, in a crucible, cooling and weighing it after each heating. The masses after successive heatings are 2.118 g, 1.771 g, 1.640 g, 1.637 g and 1.637 g. Molar masses (g/mol): H₂O 18.02, CoCl₂ 129.84. What is the value of x?', null, md5('apchem-mcq-b6-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3, because the first weighing, 2.118 g, is taken as the anhydrous mass.', false, 'The mass was still falling after 2.118 g, so water remained; using that value gives x = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '5, because the second weighing, 1.771 g, is taken as the anhydrous mass.', false, 'The mass was still decreasing at 1.771 g, so the sample was not yet anhydrous; using it gives x = 5.' from version_ins
union all select gen_random_uuid(), id, 'C', '1, because the mass of water lost divided by the mass of salt is 0.83, which rounds to 1.', false, 'This is a ratio of masses; x is a mole ratio, which needs molar masses: 0.0757 mol of water to 0.01261 mol of CoCl₂ is 6.' from version_ins
union all select gen_random_uuid(), id, 'D', '6, because the constant mass of 1.637 g is the anhydrous salt, so 1.363 g of water is lost per 1.637 g of CoCl₂.', true, 'Correct: m(H₂O) = 3.000 − 1.637 = 1.363 g = 0.07565 mol; n(CoCl₂) = 1.637/129.84 = 0.012607 mol; ratio = 6.00, so x = 6.' from version_ins;
-- apchem-mcq-b6-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.4-b', 'mcq', 'find the mass percent of one component of a two-component mixture of chlorides from the mass of AgCl precipitated, which', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.200 g mixture of NaCl and KCl is dissolved in water and excess AgNO₃(aq) is added, precipitating all of the chloride as AgCl. The precipitate has a mass of 2.561 g. Molar masses (g/mol): NaCl 58.44, KCl 74.55. AgCl = 143.32 g/mol. What is the mass percent of NaCl in the mixture?', null, md5('apchem-mcq-b6-h-1.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40.0%, because 2.561 g of AgCl is 0.01787 mol of Cl⁻ and only a 40.0 : 60.0 mass split of NaCl : KCl satisfies both the total mass and this amount of chloride.', true, 'Correct: n(Cl⁻) = 2.561/143.32 = 0.017869 mol; let m(NaCl) = x: x/58.44 + (1.200 − x)/74.55 = 0.017869, so x = 0.480 g; 0.480/1.200 = 40.0%.' from version_ins
union all select gen_random_uuid(), id, 'B', '46.0%, because that is the percent of the moles of chloride supplied by NaCl, not of the mass.', false, '46.0% is the mole fraction of NaCl (0.00821 of 0.01787 mol); the question asks for a mass percent, which is 0.480 g of 1.200 g.' from version_ins
union all select gen_random_uuid(), id, 'C', '52.8%, because the chloride in the AgCl is 52.8% of the mass of the original mixture.', false, '52.8% is the mass percent of chlorine in the mixture (0.6335 g of 1.200 g), not the mass percent of NaCl.' from version_ins
union all select gen_random_uuid(), id, 'D', '60.0%, because the larger share of the mass belongs to the compound with the higher molar mass.', false, 'The mass split is the other way: NaCl has the lower molar mass and supplies more chloride per gram, so the data require only 40.0% NaCl and 60.0% KCl.' from version_ins;
-- apchem-mcq-b6-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.4-b-v1', 'mcq', 'find the mass percent of one component of a two-component mixture of chlorides from the mass of AgCl precipitated, which (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.500 g mixture of CaCl₂ and NaCl is dissolved in water and excess AgNO₃(aq) is added, precipitating all of the chloride as AgCl. The precipitate has a mass of 3.747 g. Molar masses (g/mol): CaCl₂ 110.98, NaCl 58.44. AgCl = 143.32 g/mol. What is the mass percent of CaCl₂ in the mixture?', null, md5('apchem-mcq-b6-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '22.1%, because that is the fraction of the moles of salts that are CaCl₂.', false, '22.1% is the mole fraction of CaCl₂ (0.00473 mol of 0.02140 mol of salts); the question asks for a mass percent.' from version_ins
union all select gen_random_uuid(), id, 'B', '35.0%, because 3.747 g of AgCl is 0.02614 mol of Cl⁻ and only a 35.0 : 65.0 split of CaCl₂ : NaCl by mass satisfies both the total mass and the chloride amount.', true, 'Correct: n(Cl⁻) = 3.747/143.32 = 0.026145 mol; with m(CaCl₂) = x: 2x/110.98 + (1.500 − x)/58.44 = 0.026145 gives x = 0.525 g; 0.525/1.500 = 35.0%.' from version_ins
union all select gen_random_uuid(), id, 'C', '61.8%, because the chloride in the AgCl is 61.8% of the mixture''s mass.', false, '61.8% is the mass percent of chlorine in the mixture (0.927 g of 1.500 g), not the mass percent of CaCl₂.' from version_ins
union all select gen_random_uuid(), id, 'D', '65.0%, because CaCl₂ contains two chloride ions per formula unit and so must be the larger component.', false, 'The mass split is the other way: only 35.0% CaCl₂ and 65.0% NaCl give 0.02614 mol of chloride; having two Cl per unit does not make it the larger component.' from version_ins;
-- apchem-mcq-b6-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.4-b-v2', 'mcq', 'find the mass percent of one component of a two-component mixture of chlorides from the mass of AgCl precipitated, which (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.900 g mixture of LiCl and KCl is dissolved in water and excess AgNO₃(aq) is added, precipitating all of the chloride as AgCl. The precipitate has a mass of 2.452 g. Molar masses (g/mol): LiCl 42.39, KCl 74.55. AgCl = 143.32 g/mol. What is the mass percent of LiCl in the mixture?', null, md5('apchem-mcq-b6-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '68.2%, because that is the fraction of the moles of salts that are LiCl.', false, '68.2% is the mole fraction of LiCl (0.01168 of 0.01711 mol); the question asks for mass percent.' from version_ins
union all select gen_random_uuid(), id, 'B', '55.0%, because 2.452 g of AgCl is 0.01711 mol of Cl⁻ and only a 55.0 : 45.0 split of LiCl : KCl by mass satisfies both the total mass and the chloride amount.', true, 'Correct: n(Cl⁻) = 2.452/143.32 = 0.017108 mol; with m(LiCl) = x: x/42.39 + (0.900 − x)/74.55 = 0.017108 gives x = 0.495 g; 0.495/0.900 = 55.0%.' from version_ins
union all select gen_random_uuid(), id, 'C', '67.4%, because the chloride in the AgCl is 67.4% of the mixture''s mass.', false, '67.4% is the mass percent of chlorine in the mixture (0.6065 g of 0.900 g), not of LiCl.' from version_ins
union all select gen_random_uuid(), id, 'D', '45.0%, because the smaller mass belongs to the compound with the lower molar mass.', false, 'The mass split is the other way: LiCl has the lower molar mass and supplies more chloride per gram, so it must be the larger part, 55.0%, to give 0.01711 mol of chloride.' from version_ins;
-- apchem-mcq-b6-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.4-b-v3', 'mcq', 'find the mass percent of one component of a two-component mixture of chlorides from the mass of AgCl precipitated, which (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.000 g mixture of MgCl₂ and KCl is dissolved in water and excess AgNO₃(aq) is added, precipitating all of the chloride as AgCl. The precipitate has a mass of 2.412 g. Molar masses (g/mol): MgCl₂ 95.21, KCl 74.55. AgCl = 143.32 g/mol. What is the mass percent of MgCl₂ in the mixture?', null, md5('apchem-mcq-b6-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '39.0%, because that is the fraction of the moles of salts that are MgCl₂.', false, '39.0% is the mole fraction of MgCl₂ (0.00473 of 0.01211 mol of salts); the question asks for a mass percent.' from version_ins
union all select gen_random_uuid(), id, 'B', '59.7%, because the chloride in the AgCl is 59.7% of the mixture''s mass.', false, '59.7% is the mass percent of chlorine in the mixture (0.597 g of 1.000 g), not the mass percent of MgCl₂.' from version_ins
union all select gen_random_uuid(), id, 'C', '55.0%, because the compound with two chloride ions per formula unit must make up the larger share.', false, 'The data give the opposite split: 55.0% would be KCl. With 45.0% MgCl₂ the chloride totals 0.01683 mol; having two Cl per unit does not make MgCl₂ the larger part.' from version_ins
union all select gen_random_uuid(), id, 'D', '45.0%, because 2.412 g of AgCl is 0.01683 mol of Cl⁻ and only a 45.0 : 55.0 split of MgCl₂ : KCl by mass satisfies both the total mass and the chloride amount.', true, 'Correct: n(Cl⁻) = 2.412/143.32 = 0.016829 mol; with m(MgCl₂) = x: 2x/95.21 + (1.000 − x)/74.55 = 0.016829 gives x = 0.450 g; 0.450/1.000 = 45.0%.' from version_ins;
-- apchem-mcq-b6-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.5-a', 'mcq', 'count unpaired electrons for atoms and ions of d-block elements, including the anomalous half-filled and filled configur', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following ground-state species has the greatest number of unpaired electrons?', null, md5('apchem-mcq-b6-h-1.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A Cr atom, [Ar]3d⁵4s¹, which has six unpaired electrons.', true, 'Correct: Cr is the exception to filling order: [Ar]3d⁵4s¹ has six unpaired electrons; Mn and Fe³⁺ each have five and Cu has one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An Mn atom, [Ar]3d⁵4s², which has five unpaired electrons.', false, 'Mn has five unpaired 3d electrons with a paired 4s², so five unpaired; a Cr atom has six because one 4s electron moves into 3d.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An Fe³⁺ ion, [Ar]3d⁵, which has five unpaired electrons.', false, 'Fe³⁺ is 3d⁵ with five unpaired electrons, one fewer than the six in Cr.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A Cu atom, [Ar]3d¹⁰4s¹, which has one unpaired electron.', false, 'Cu has a filled 3d subshell, so only the single 4s electron is unpaired; this is far fewer than Cr.' from version_ins;
-- apchem-mcq-b6-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.5-a-v1', 'mcq', 'count unpaired electrons for atoms and ions of d-block elements, including the anomalous half-filled and filled configur (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following ground-state species has the greatest number of unpaired electrons?', null, md5('apchem-mcq-b6-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'An Mn²⁺ ion, [Ar]3d⁵, which has five unpaired electrons.', false, 'Mn²⁺ has a half-filled 3d subshell with five unpaired electrons, one fewer than Mo, which has six.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An Mo atom, [Kr]4d⁵5s¹, which has six unpaired electrons.', true, 'Correct: Mo follows the Cr pattern: [Kr]4d⁵5s¹ gives six unpaired electrons, more than Mn²⁺ (5), Fe²⁺ (4) or Co (3).' from version_ins
union all select gen_random_uuid(), id, 'C', 'An Fe²⁺ ion, [Ar]3d⁶, which has four unpaired electrons.', false, 'Fe²⁺ is 3d⁶ with one pair and four unpaired electrons, fewer than the six in Mo.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A Co atom, [Ar]3d⁷4s², which has three unpaired electrons.', false, 'Co is 3d⁷4s²; two of the five 3d orbitals are doubly occupied, which leaves three unpaired 3d electrons, far fewer than Mo.' from version_ins;
-- apchem-mcq-b6-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.5-a-v2', 'mcq', 'count unpaired electrons for atoms and ions of d-block elements, including the anomalous half-filled and filled configur (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following ground-state species is diamagnetic, that is, has no unpaired electrons?', null, md5('apchem-mcq-b6-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A Cu²⁺ ion, [Ar]3d⁹, which has one unpaired electron.', false, 'Cu²⁺ is 3d⁹, which has one unpaired electron in the 3d subshell, so it is paramagnetic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A Cu⁺ ion, [Ar]3d¹⁰.', true, 'Correct: Cu is [Ar]3d¹⁰4s¹; removing the 4s electron leaves the filled 3d¹⁰ subshell with all electrons paired.' from version_ins
union all select gen_random_uuid(), id, 'C', 'An Ni²⁺ ion, [Ar]3d⁸, which has two unpaired electrons.', false, 'Ni²⁺ is 3d⁸ with two unpaired electrons, so it is paramagnetic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A V³⁺ ion, [Ar]3d², which has two unpaired electrons.', false, 'V³⁺ is 3d² with the two electrons in different orbitals, so it has two unpaired electrons and is paramagnetic.' from version_ins;
-- apchem-mcq-b6-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.5-a-v3', 'mcq', 'count unpaired electrons for atoms and ions of d-block elements, including the anomalous half-filled and filled configur (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which of the following ground-state species has the greatest number of unpaired electrons?', null, md5('apchem-mcq-b6-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A Cr³⁺ ion, [Ar]3d³, which has three unpaired electrons.', false, 'Cr³⁺ is 3d³ with three unpaired electrons, which is fewer than the five in Fe³⁺.' from version_ins
union all select gen_random_uuid(), id, 'B', 'An Fe³⁺ ion, [Ar]3d⁵, which has five unpaired electrons.', true, 'Correct: Fe is [Ar]3d⁶4s²; the 4s electrons are removed first, then one 3d, leaving the half-filled 3d⁵ with five unpaired electrons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A Co²⁺ ion, [Ar]3d⁷, which has three unpaired electrons.', false, 'Co²⁺ is 3d⁷ with two paired and three unpaired electrons, fewer than the five in Fe³⁺.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A Cu²⁺ ion, [Ar]3d⁹, which has one unpaired electron.', false, 'Cu²⁺ is 3d⁹ with only one unpaired electron.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.4-a-v3','apchem-mcq-b6-h-1.4-b','apchem-mcq-b6-sv-h-1.4-b-v1','apchem-mcq-b6-sv-h-1.4-b-v2','apchem-mcq-b6-sv-h-1.4-b-v3','apchem-mcq-b6-h-1.5-a','apchem-mcq-b6-sv-h-1.5-a-v1','apchem-mcq-b6-sv-h-1.5-a-v2','apchem-mcq-b6-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-sv-h-1.4-a-v3','apchem-mcq-b6-h-1.4-b','apchem-mcq-b6-sv-h-1.4-b-v1','apchem-mcq-b6-sv-h-1.4-b-v2','apchem-mcq-b6-sv-h-1.4-b-v3','apchem-mcq-b6-h-1.5-a','apchem-mcq-b6-sv-h-1.5-a-v1','apchem-mcq-b6-sv-h-1.5-a-v2','apchem-mcq-b6-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
