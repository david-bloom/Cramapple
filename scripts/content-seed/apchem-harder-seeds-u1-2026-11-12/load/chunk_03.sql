begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.3-a-v2','apchem-mcq-b6-sv-h-1.3-a-v3','apchem-mcq-b6-h-1.3-b','apchem-mcq-b6-sv-h-1.3-b-v1','apchem-mcq-b6-sv-h-1.3-b-v2','apchem-mcq-b6-sv-h-1.3-b-v3','apchem-mcq-b6-h-1.4-a','apchem-mcq-b6-sv-h-1.4-a-v1','apchem-mcq-b6-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apchem-mcq-b6-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.3-a-v2', 'mcq', 'find a molecular formula from combustion-analysis masses, obtaining oxygen by difference and then scaling the empirical  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.200 g sample of a compound that contains only carbon, hydrogen and oxygen is burned completely in excess oxygen, producing 1.789 g of CO₂ and 0.549 g of H₂O. The molar mass of the compound is 118.1 g/mol. Relative atomic masses (g/mol): C 12.01, H 1.008, O 16.00. Molar masses of CO₂ = 44.01 g/mol and H₂O = 18.02 g/mol. What is the molecular formula of the compound?', null, md5('apchem-mcq-b6-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₂H₃O₂, because it is the simplest whole-number ratio of the elements.', false, 'C₂H₃O₂ has a molar mass of 59.04 g/mol, half of the 118.1 g/mol given, so it is the empirical formula and not the molecular formula.' from version_ins
union all select gen_random_uuid(), id, 'B', 'C₄H₃O₄, because only one hydrogen atom per H₂O molecule is counted in the hydrogen total.', false, 'Each H₂O contains two H atoms from the sample, so n(H) = 0.0609 mol, which is 1.5 times n(C); C₄H₃O₄ shows only 3 H for 4 C.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C₈H₁₂, because the products give a C : H ratio of 2 : 3 and oxygen is not included in the ratio.', false, 'This ignores oxygen: m(O) = 1.200 − 0.4882 − 0.0614 = 0.650 g, which is 0.0406 mol; C₈H₁₂ has no oxygen and does not match the 118.1 g/mol molar mass.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C₄H₆O₄, because the empirical formula is C₂H₃O₂ (59.04 g/mol) and 118.1 divided by 59.04 is 2.', true, 'Correct: n(C) = 1.789/44.01 = 0.04065; n(H) = 2 × 0.549/18.02 = 0.06094; m(O) = 1.200 − 0.4882 − 0.0614 = 0.6504 g = 0.04065 mol; ratio 2 : 3 : 2; 118.1/59.04 = 2.' from version_ins;
-- apchem-mcq-b6-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.3-a-v3', 'mcq', 'find a molecular formula from combustion-analysis masses, obtaining oxygen by difference and then scaling the empirical  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.900 g sample of a compound that contains only carbon, hydrogen and oxygen is burned completely in excess oxygen, producing 0.880 g of CO₂ and 0.180 g of H₂O. The molar mass of the compound is 90.0 g/mol. Relative atomic masses (g/mol): C 12.01, H 1.008, O 16.00. Molar masses of CO₂ = 44.01 g/mol and H₂O = 18.02 g/mol. What is the molecular formula of the compound?', null, md5('apchem-mcq-b6-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C₂H₂O₄, because the empirical formula is CHO₂ (45.02 g/mol) and 90.0 divided by 45.02 is 2.', true, 'Correct: n(C) = 0.880/44.01 = 0.02000; n(H) = 2 × 0.180/18.02 = 0.01998; m(O) = 0.900 − 0.2402 − 0.0201 = 0.6397 g = 0.03998 mol; ratio 1 : 1 : 2; 90.0/45.02 = 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CHO₂, because it is the simplest ratio of the elements in the sample.', false, 'CHO₂ has a molar mass of 45.02 g/mol, half of the 90.0 g/mol given; it is the empirical formula, not the molecular formula.' from version_ins
union all select gen_random_uuid(), id, 'C', 'C₂HO₄, because each H₂O is taken to contain one H atom from the sample.', false, 'Each H₂O contains two H atoms from the sample, so n(H) = 0.0200 mol, equal to n(C), not half of it as C₂HO₄ shows.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C₇H₇, because the products give a C : H ratio of 1 : 1 and oxygen is left out of the formula.', false, 'Leaving out oxygen ignores 0.640 g of the sample (0.0400 mol of O found by difference); C₇H₇ has no oxygen at all.' from version_ins;
-- apchem-mcq-b6-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.3-b', 'mcq', 'explain why a measured empirical formula deviates from the expected one, using the mass change on forming a nitride vers', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 0.486 g of magnesium ribbon strongly in an open crucible until it stops glowing, then weighs the product: 0.790 g. Assuming all of the mass gained is oxygen, the student calculates 0.304 g of O (0.0190 mol) combined with 0.0200 mol of Mg, a Mg : O mole ratio of 1.05 : 1 instead of 1 : 1. When a little water is added to the cooled white product, a gas with an ammonia odor is released and no gray metal remains. Which explanation is most consistent with all of the data?', null, md5('apchem-mcq-b6-h-1.3-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Some magnesium did not react and remained as metal, so the product mass is too small.', false, 'Unreacted Mg would also lower the mass gain, but the observation of no gray metal rules it out and it would not release an ammonia-smelling gas.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The product absorbed water vapor from the air, which added mass and made the apparent oxygen too high.', false, 'Extra mass from water would increase the calculated O and give a Mg : O ratio below 1 : 1, the opposite of the 1.05 : 1 found.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Some of the magnesium reacted with N₂ to form Mg₃N₂, which gains less mass per mole of Mg than MgO, so the calculated O is too low.', true, 'Correct: Mg₃N₂ adds 14.01 × 2/3 = 9.3 g per mole of Mg versus 16.00 g for MgO, so a mixed product weighs less than MgO (0.806 g expected); water on a nitride gives NH₃.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Some magnesium formed MgO₂, a peroxide, which adds more oxygen per mole of Mg than MgO.', false, 'A peroxide would add extra oxygen and give a Mg : O ratio below 1 : 1; it also would not release ammonia on adding water.' from version_ins;
-- apchem-mcq-b6-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.3-b-v1', 'mcq', 'explain why a measured empirical formula deviates from the expected one, using the mass change on forming a nitride vers (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 0.802 g of calcium metal strongly in air until the reaction is complete, then weighs the white product: 1.102 g. Assuming all of the mass gained is oxygen, the student calculates 0.300 g of O (0.0188 mol) combined with 0.0200 mol of Ca, a Ca : O mole ratio of 1.07 : 1 instead of 1 : 1. A small portion of the product added to dilute acid produces no bubbles of hydrogen gas, and moist red litmus paper held over the product after adding water turns blue. Which explanation is most consistent with all of the data?', null, md5('apchem-mcq-b6-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Some calcium remained unreacted as metal, so less mass was gained than expected.', false, 'Unreacted Ca would produce H₂ bubbles in dilute acid; none were seen, and it would not turn litmus paper blue.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Some calcium reacted with N₂ to form Ca₃N₂, which gains less mass per mole of Ca than CaO, so the calculated O is too low.', true, 'Correct: Ca₃N₂ adds 9.3 g of N per mole of Ca versus 16.00 g for CaO, so less mass is gained; no H₂ in acid means no Ca metal, and NH₃ (basic) turns red litmus blue.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Some CaO reacted with CO₂ in the air to form CaCO₃, which adds extra mass.', false, 'CaCO₃ would add more mass than CaO, raising the calculated O and giving a ratio below 1 : 1; it would also not produce a basic gas.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Some CaO reacted with water vapor in the air to form Ca(OH)₂, which adds mass.', false, 'Ca(OH)₂ adds more mass per Ca than CaO, which would also give a ratio below 1 : 1 and would not release a gas that turns litmus paper blue.' from version_ins;
-- apchem-mcq-b6-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.3-b-v2', 'mcq', 'explain why a measured empirical formula deviates from the expected one, using the mass change on forming a nitride vers (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 1.750 g of strontium metal strongly in air until the reaction is complete, then weighs the white product: 2.056 g. Assuming all of the mass gained is oxygen, the student calculates 0.306 g of O (0.0191 mol) combined with 0.0200 mol of Sr, a Sr : O mole ratio of 1.04 : 1 instead of 1 : 1. The product contains no shiny metal when it is broken open, and warming it with a little water produces a gas that turns moist red litmus paper blue. Which explanation is most consistent with all of the data?', null, md5('apchem-mcq-b6-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Some strontium did not react and remained as metal inside the product.', false, 'Unreacted Sr would be visible as shiny metal when the product is broken open; none was seen, and metal alone would not give a basic gas with water.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Some strontium reacted with N₂ to form Sr₃N₂, which gains less mass per mole of Sr than SrO, so the calculated O is too low.', true, 'Correct: Sr₃N₂ adds 9.3 g of N per mole of Sr versus 16.00 g for SrO, so the product is lighter than 2.07 g; the basic gas (NH₃) is evidence of a nitride.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The product absorbed moisture, forming Sr(OH)₂, which adds mass.', false, 'Added mass from hydroxide would raise the calculated O and give a ratio below 1 : 1, opposite to what was found.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Some SrO reacted with CO₂ in the air to form SrCO₃, which adds extra mass.', false, 'SrCO₃ adds more mass per Sr than SrO, raising the calculated O and giving a ratio below 1 : 1, and it would not release a basic gas with water.' from version_ins;
-- apchem-mcq-b6-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.3-b-v3', 'mcq', 'explain why a measured empirical formula deviates from the expected one, using the mass change on forming a nitride vers (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 0.347 g of lithium metal (0.0500 mol) strongly in air until the reaction is complete, then weighs the white product: 0.722 g. Assuming all of the mass gained is oxygen, the student calculates 0.375 g of O (0.0234 mol) and a Li : O mole ratio of 2.13 : 1 instead of the 2 : 1 expected for Li₂O. A portion of the product added to water produces no bubbles of hydrogen, and moist red litmus paper held above the mixture turns blue. Which explanation is most consistent with all of the data?', null, md5('apchem-mcq-b6-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Some lithium did not react and remained as metal, so the mass gain is too small.', false, 'Unreacted Li would react with water to produce hydrogen bubbles, which were not seen, and a metal does not release a gas that turns litmus blue.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Some Li₂O reacted with water vapor in the air to form LiOH, which adds mass.', false, 'LiOH adds more mass per Li than Li₂O does, raising the calculated O and lowering the Li : O ratio below 2 : 1; it also releases no basic gas.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Some lithium reacted with N₂ to form Li₃N, which gains less mass per mole of Li than Li₂O, so the calculated O is too low.', true, 'Correct: Li₃N adds 14.01/3 = 4.67 g per mole of Li versus 8.00 g for Li₂O, so the mixed product (0.722 g) is lighter than pure Li₂O (0.747 g); water on a nitride gives NH₃.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Some lithium formed Li₂O₂, a peroxide, which has more oxygen per mole of Li than Li₂O.', false, 'A peroxide would add extra oxygen and give a Li : O ratio below 2 : 1, the opposite of 2.13 : 1; it also would not release a basic gas with water.' from version_ins;
-- apchem-mcq-b6-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.4-a', 'mcq', 'determine the number of waters of hydration from a heating-to-constant-mass data series, recognizing that only the final', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 3.000 g of a hydrated copper(II) sulfate, CuSO₄·xH₂O, in a crucible, cooling and weighing it after each heating. The masses after successive heatings are 2.250 g, 2.067 g, 1.925 g, 1.918 g and 1.918 g. Molar masses (g/mol): H₂O 18.02, CuSO₄ 159.61. What is the value of x?', null, md5('apchem-mcq-b6-h-1.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3, because the first weighing, 2.250 g, gives 0.750 g of water lost for 2.250 g of CuSO₄.', false, 'The first weighing is not constant, so water remained in the sample; using 2.250 g as the anhydrous mass gives x = 3 but the mass was still decreasing.' from version_ins
union all select gen_random_uuid(), id, 'B', '4, because the second weighing, 2.067 g, is close enough to the anhydrous mass.', false, 'The mass was still falling after 2.067 g; the sample was constant only at 1.918 g, and using 2.067 g gives x = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '1, because the mass of water lost, 1.082 g, divided by the mass of anhydrous salt, 1.918 g, is about 0.56, which rounds to 1.', false, 'This is a ratio of masses; x is a ratio of moles, which requires dividing each mass by its molar mass: 0.0600 mol water to 0.01202 mol CuSO₄ is about 5.' from version_ins
union all select gen_random_uuid(), id, 'D', '5, because the constant mass of 1.918 g is the anhydrous salt, so 1.082 g of water is lost per 1.918 g of CuSO₄.', true, 'Correct: m(H₂O) = 3.000 − 1.918 = 1.082 g = 0.06005 mol; n(CuSO₄) = 1.918/159.61 = 0.01202 mol; ratio = 4.997, so x = 5.' from version_ins;
-- apchem-mcq-b6-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.4-a-v1', 'mcq', 'determine the number of waters of hydration from a heating-to-constant-mass data series, recognizing that only the final (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 2.500 g of a hydrated magnesium sulfate, MgSO₄·xH₂O, in a crucible, cooling and weighing it after each heating. The masses after successive heatings are 1.564 g, 1.317 g, 1.224 g, 1.221 g and 1.221 g. Molar masses (g/mol): H₂O 18.02, MgSO₄ 120.37. What is the value of x?', null, md5('apchem-mcq-b6-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7, because the constant mass of 1.221 g is the anhydrous salt, so 1.279 g of water is lost per 1.221 g of MgSO₄.', true, 'Correct: m(H₂O) = 2.500 − 1.221 = 1.279 g = 0.07099 mol; n(MgSO₄) = 1.221/120.37 = 0.010144 mol; ratio = 7.00, so x = 7.' from version_ins
union all select gen_random_uuid(), id, 'B', '4, because the first weighing, 1.564 g, is taken as the anhydrous mass.', false, 'The first weighing was well before the mass stopped changing; using 1.564 g as the anhydrous mass gives x = 4.' from version_ins
union all select gen_random_uuid(), id, 'C', '6, because the second weighing, 1.317 g, is taken as the anhydrous mass.', false, 'The mass was still decreasing after 1.317 g, so water remained; using that value gives x = 6, not the full hydrate.' from version_ins
union all select gen_random_uuid(), id, 'D', '1, because the mass of water lost divided by the mass of salt is 1.05, which rounds to 1.', false, 'This divides masses; x is a mole ratio, which needs the molar masses: 0.0710 mol of water to 0.01014 mol of MgSO₄ is 7.' from version_ins;
-- apchem-mcq-b6-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.4-a-v2', 'mcq', 'determine the number of waters of hydration from a heating-to-constant-mass data series, recognizing that only the final (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats 3.500 g of a hydrated sodium carbonate, Na₂CO₃·xH₂O, in a crucible, cooling and weighing it after each heating. The masses after successive heatings are 2.318 g, 1.733 g, 1.305 g, 1.296 g and 1.296 g. Molar masses (g/mol): H₂O 18.02, Na₂CO₃ 105.99. What is the value of x?', null, md5('apchem-mcq-b6-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3, because the first weighing, 2.318 g, is taken as the anhydrous mass.', false, 'The mass was still decreasing, so 2.318 g still contained water; treating it as anhydrous gives x = 3.' from version_ins
union all select gen_random_uuid(), id, 'B', '6, because the second weighing, 1.733 g, is taken as the anhydrous mass.', false, 'The mass kept falling after 1.733 g, so water remained; treating it as anhydrous gives x = 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '2, because the mass of water lost divided by the mass of salt is 1.7, which rounds to 2.', false, 'This ratio of masses is not x; the mole ratio needs the molar masses: 0.1223 mol of water to 0.01223 mol of Na₂CO₃ gives 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '10, because the constant mass of 1.296 g is the anhydrous salt, so 2.204 g of water is lost per 1.296 g of Na₂CO₃.', true, 'Correct: m(H₂O) = 3.500 − 1.296 = 2.204 g = 0.12234 mol; n(Na₂CO₃) = 1.296/105.99 = 0.012227 mol; ratio = 10.0, so x = 10.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.3-a-v2','apchem-mcq-b6-sv-h-1.3-a-v3','apchem-mcq-b6-h-1.3-b','apchem-mcq-b6-sv-h-1.3-b-v1','apchem-mcq-b6-sv-h-1.3-b-v2','apchem-mcq-b6-sv-h-1.3-b-v3','apchem-mcq-b6-h-1.4-a','apchem-mcq-b6-sv-h-1.4-a-v1','apchem-mcq-b6-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-sv-h-1.3-a-v2','apchem-mcq-b6-sv-h-1.3-a-v3','apchem-mcq-b6-h-1.3-b','apchem-mcq-b6-sv-h-1.3-b-v1','apchem-mcq-b6-sv-h-1.3-b-v2','apchem-mcq-b6-sv-h-1.3-b-v3','apchem-mcq-b6-h-1.4-a','apchem-mcq-b6-sv-h-1.4-a-v1','apchem-mcq-b6-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
