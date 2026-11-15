begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-h-1.1-a','apchem-mcq-b6-sv-h-1.1-a-v1','apchem-mcq-b6-sv-h-1.1-a-v2','apchem-mcq-b6-sv-h-1.1-a-v3','apchem-mcq-b6-h-1.1-b','apchem-mcq-b6-sv-h-1.1-b-v1','apchem-mcq-b6-sv-h-1.1-b-v2','apchem-mcq-b6-sv-h-1.1-b-v3','apchem-mcq-b6-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apchem-mcq-b6-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.1-a', 'mcq', 'compare the number of atoms of one element across samples given as a mass, an amount in moles, and a particle count.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four samples are described. Molar masses (g/mol): H₂O 18.02, CO₂ 44.01.
Sample 1: 20.0 g of H₂O.
Sample 2: 0.100 mol of Ca₃(PO₄)₂.
Sample 3: 30.0 g of CO₂.
Sample 4: 2.40 × 10²³ molecules of SO₃.
Which sample contains the greatest number of oxygen atoms? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, md5('apchem-mcq-b6-h-1.1-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sample 3, which contains about 1.36 mol of oxygen atoms.', true, 'Correct: Convert each to mol of O atoms: 1.11, 0.800, 2 × (30.0/44.01) = 1.36, and 3 × (2.40 × 10²³/6.022 × 10²³) = 1.20; the largest is sample 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sample 1, because it has the largest amount of substance (1.11 mol) of the four.', false, 'Sample 1 has the most moles of molecules, but each H₂O has only one O atom, so it holds 1.11 mol of O atoms, fewer than sample 3 at 1.36 mol.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sample 2, because each formula unit of Ca₃(PO₄)₂ contains eight oxygen atoms, more than any other formula.', false, 'Sample 2 has the most O atoms per formula unit, but only 0.100 mol of formula units, giving 0.800 mol of O atoms, the fewest of the four.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sample 4, because a count of 2.40 × 10²³ is a number of particles and therefore the largest quantity listed.', false, 'Sample 4 is 0.399 mol of SO₃ with three O atoms each, which is 1.20 mol of O atoms; this is large but still less than sample 3 at 1.36 mol.' from version_ins;
-- apchem-mcq-b6-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.1-a-v1', 'mcq', 'compare the number of atoms of one element across samples given as a mass, an amount in moles, and a particle count. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four samples are described. Molar masses (g/mol): NH₃ 17.03.
Sample 1: 15.0 g of NH₃.
Sample 2: 0.800 mol of C₂H₅OH.
Sample 3: 0.300 mol of C₆H₁₂O₆.
Sample 4: 1.20 × 10²⁴ molecules of H₂SO₄.
Which sample contains the greatest number of hydrogen atoms? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, md5('apchem-mcq-b6-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sample 2, which contains 4.80 mol of hydrogen atoms.', true, 'Correct: Mol of H atoms: 15.0/17.03 × 3 = 2.64; 0.800 × 6 = 4.80; 0.300 × 12 = 3.60; (1.20 × 10²⁴/6.022 × 10²³) × 2 = 3.99; the largest is sample 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sample 1, because ammonia has the lowest molar mass, so 15.0 g contains the most molecules.', false, 'The 15.0 g of NH₃ is 0.881 mol of molecules, but at three H atoms each it gives only 2.64 mol of H atoms, less than sample 2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sample 3, because glucose has twelve hydrogen atoms per molecule, more than any other formula.', false, 'Glucose has the most H per molecule, but 0.300 mol gives only 3.60 mol of H atoms, which is less than the 4.80 mol in sample 2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sample 4, because it is stated as a count of particles and 1.20 × 10²⁴ is the largest number.', false, 'The 1.20 × 10²⁴ molecules are 1.99 mol of H₂SO₄ with two H each, so 3.99 mol of H atoms; this is below sample 2 at 4.80 mol.' from version_ins;
-- apchem-mcq-b6-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.1-a-v2', 'mcq', 'compare the number of atoms of one element across samples given as a mass, an amount in moles, and a particle count. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four samples are described. Molar masses (g/mol): CCl₄ 153.82, AlCl₃ 133.34.
Sample 1: 40.0 g of CCl₄.
Sample 2: 0.500 mol of MgCl₂.
Sample 3: 60.0 g of AlCl₃.
Sample 4: 2.00 × 10²³ molecules of PCl₃.
Which sample contains the greatest number of chlorine atoms? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, md5('apchem-mcq-b6-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sample 1, because CCl₄ has four chlorine atoms per molecule, the most of any formula listed.', false, 'Four Cl per molecule is the most, but 40.0 g is only 0.260 mol of CCl₄, giving 1.04 mol of Cl atoms, less than the 1.35 mol in sample 3.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sample 2, because it is the only sample stated directly in moles, so no conversion is needed to compare it.', false, 'Sample 2 gives 0.500 mol × 2 = 1.00 mol of Cl atoms; the way a quantity is stated does not make it larger, and sample 3 holds 1.35 mol.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sample 4, because each PCl₃ molecule contains three chlorine atoms and phosphorus is heavier than aluminum.', false, 'Sample 4 is 0.332 mol of PCl₃, giving only 0.996 mol of Cl atoms; the mass of the other element does not affect the count of Cl atoms.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sample 3, which contains about 1.35 mol of chlorine atoms.', true, 'Correct: Mol of Cl atoms: 40.0/153.82 × 4 = 1.04; 0.500 × 2 = 1.00; 60.0/133.34 × 3 = 1.35; (2.00 × 10²³/6.022 × 10²³) × 3 = 0.996; the largest is sample 3.' from version_ins;
-- apchem-mcq-b6-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.1-a-v3', 'mcq', 'compare the number of atoms of one element across samples given as a mass, an amount in moles, and a particle count. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four samples are described. Molar masses (g/mol): NH₃ 17.03, NaNO₃ 84.99.
Sample 1: 25.0 g of NH₃.
Sample 2: 0.600 mol of NH₄NO₃.
Sample 3: 50.0 g of NaNO₃.
Sample 4: 4.00 × 10²³ molecules of N₂O₄.
Which sample contains the greatest number of nitrogen atoms? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, md5('apchem-mcq-b6-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sample 2, because NH₄NO₃ contains two nitrogen atoms per formula unit and its amount is given directly in moles.', false, 'The 0.600 mol of NH₄NO₃ gives 1.20 mol of N atoms; two N per formula unit does not offset the smaller number of formula units compared with sample 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sample 3, because the 50.0 g is the largest mass of any compound that contains nitrogen.', false, 'Sample 3 is 0.588 mol of NaNO₃ with one N atom each, so 0.588 mol of N atoms; a large mass does not mean many atoms when the molar mass is large.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sample 4, because N₂O₄ has two nitrogen atoms per molecule and a particle count of the order 10²³.', false, 'Sample 4 is 0.664 mol of N₂O₄, giving 1.33 mol of N atoms, which is close to but smaller than the 1.47 mol in sample 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sample 1, which contains about 1.47 mol of nitrogen atoms.', true, 'Correct: Mol of N atoms: 25.0/17.03 = 1.47; 0.600 × 2 = 1.20; 50.0/84.99 = 0.588; (4.00 × 10²³/6.022 × 10²³) × 2 = 1.33; the largest is sample 1.' from version_ins;
-- apchem-mcq-b6-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.1-b', 'mcq', 'identify an unknown element from the number of atoms of another element in a mass of its compound, using the formula to ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.00 g sample of an unknown alkali-metal carbonate, M₂CO₃, contains 6.54 × 10²² oxygen atoms. Use the molar masses (g/mol) C 12.01, O 16.00, S 32.06, N 14.01, P 30.97, Li 6.94, Na 22.99, K 39.10, Rb 85.47, Mg 24.31, Ca 40.08, Sr 87.62, Ba 137.33. Avogadro''s number = 6.022 × 10²³ mol⁻¹. What is M?', null, md5('apchem-mcq-b6-h-1.1-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Li, because lithium is the lightest alkali metal and the sample is small.', false, 'Li₂CO₃ (73.89 g/mol) would give 5.00/73.89 × 3 × 6.022 × 10²³ = 1.22 × 10²³ O atoms, nearly twice the value observed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Na, because Na₂CO₃ is the most common carbonate and its formula contains three oxygen atoms.', false, 'Na₂CO₃ (105.99 g/mol) would give 8.52 × 10²² O atoms in 5.00 g, which is more than the 6.54 × 10²² observed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Rb, because the sample must contain more than one mole of metal atoms to account for 10²² oxygen atoms.', false, 'Rb₂CO₃ (230.94 g/mol) would give only 3.91 × 10²² O atoms in 5.00 g; also 10²² atoms is far less than one mole, so no such requirement exists.' from version_ins
union all select gen_random_uuid(), id, 'D', 'K, because 6.54 × 10²² O atoms is 0.109 mol of O, so 0.0362 mol of M₂CO₃, a molar mass of 138 g/mol.', true, 'Correct: 6.54 × 10²²/6.022 × 10²³ = 0.1086 mol O; ÷ 3 = 0.03620 mol M₂CO₃; 5.00/0.03620 = 138 g/mol; 138.2 − 60.01 = 78.2 for 2 M, so M = 39.1, potassium.' from version_ins;
-- apchem-mcq-b6-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.1-b-v1', 'mcq', 'identify an unknown element from the number of atoms of another element in a mass of its compound, using the formula to  (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6.00 g sample of an unknown alkali-metal sulfate, M₂SO₄, contains 1.02 × 10²³ oxygen atoms. Use the molar masses (g/mol) C 12.01, O 16.00, S 32.06, N 14.01, P 30.97, Li 6.94, Na 22.99, K 39.10, Rb 85.47, Mg 24.31, Ca 40.08, Sr 87.62, Ba 137.33. Avogadro''s number = 6.022 × 10²³ mol⁻¹. What is M?', null, md5('apchem-mcq-b6-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Li, because a lighter metal gives a smaller molar mass and therefore more oxygen atoms per gram.', false, 'Li₂SO₄ (109.94 g/mol) would give 1.31 × 10²³ O atoms in 6.00 g, which is more than the 1.02 × 10²³ observed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'K, because K₂SO₄ is the sulfate most often used as a standard and contains four oxygen atoms per formula unit.', false, 'K₂SO₄ (174.26 g/mol) would give 8.29 × 10²² O atoms in 6.00 g, which is less than the 1.02 × 10²³ observed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Rb, because a count of 10²³ atoms of oxygen is too large to come from a light metal.', false, 'Rb₂SO₄ (267.00 g/mol) would give only 5.41 × 10²² O atoms in 6.00 g; the number of oxygen atoms depends on the molar mass of the whole formula unit.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Na, because the O count gives 0.0423 mol of M₂SO₄, a molar mass of 142 g/mol, so M = 22.99.', true, 'Correct: 1.02 × 10²³/6.022 × 10²³ = 0.1694 mol O; ÷ 4 = 0.04235 mol; 6.00/0.04235 = 141.7 g/mol; minus 96.06 for SO₄ gives 45.6 for 2 M, so M = 22.8, sodium.' from version_ins;
-- apchem-mcq-b6-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.1-b-v2', 'mcq', 'identify an unknown element from the number of atoms of another element in a mass of its compound, using the formula to  (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 8.00 g sample of an unknown alkaline-earth nitrate, M(NO₃)₂, contains 4.55 × 10²² nitrogen atoms. Use the molar masses (g/mol) C 12.01, O 16.00, S 32.06, N 14.01, P 30.97, Li 6.94, Na 22.99, K 39.10, Rb 85.47, Mg 24.31, Ca 40.08, Sr 87.62, Ba 137.33. Avogadro''s number = 6.022 × 10²³ mol⁻¹. What is M?', null, md5('apchem-mcq-b6-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mg, because Mg(NO₃)₂ has the smallest formula mass, so the sample holds the fewest atoms.', false, 'Mg(NO₃)₂ (148.31 g/mol) would give 8.00/148.31 × 2 × 6.022 × 10²³ = 6.50 × 10²² N atoms, more than observed; a smaller formula mass gives more atoms, not fewer.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ca, because Ca(NO₃)₂ is the nitrate whose count of N atoms is closest to 5 × 10²².', false, 'Ca(NO₃)₂ (164.10 g/mol) would give 5.87 × 10²² N atoms in 8.00 g, which does not match the 4.55 × 10²² observed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sr, because 4.55 × 10²² N atoms is 0.0378 mol of M(NO₃)₂, a molar mass of 212 g/mol.', true, 'Correct: 4.55 × 10²²/6.022 × 10²³ = 0.07556 mol N; ÷ 2 = 0.03778 mol; 8.00/0.03778 = 211.8 g/mol; minus 124.02 for 2 NO₃ gives 87.7, strontium.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ba, because dividing the N atoms by two formula units gives a metal mass near 137 g/mol.', false, 'Ba(NO₃)₂ (261.35 g/mol) would give 3.69 × 10²² N atoms in 8.00 g; the factor of two relates N atoms to formula units, not to the molar mass of the metal.' from version_ins;
-- apchem-mcq-b6-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.1-b-v3', 'mcq', 'identify an unknown element from the number of atoms of another element in a mass of its compound, using the formula to  (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.00 g sample of an unknown alkali-metal phosphate, M₃PO₄, contains 4.54 × 10²² oxygen atoms. Use the molar masses (g/mol) C 12.01, O 16.00, S 32.06, N 14.01, P 30.97, Li 6.94, Na 22.99, K 39.10, Rb 85.47, Mg 24.31, Ca 40.08, Sr 87.62, Ba 137.33. Avogadro''s number = 6.022 × 10²³ mol⁻¹. What is M?', null, md5('apchem-mcq-b6-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Li, because Li₃PO₄ has the smallest formula mass and four oxygen atoms per formula unit.', false, 'Li₃PO₄ (115.79 g/mol) would give 4.00/115.79 × 4 × 6.022 × 10²³ = 8.32 × 10²² O atoms, almost twice the observed number.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Na, because Na₃PO₄ is a common phosphate and three metal atoms balance one phosphate ion.', false, 'Na₃PO₄ (163.94 g/mol) would give 5.88 × 10²² O atoms in 4.00 g, which is more than the 4.54 × 10²² observed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'K, because the O count gives 0.0188 mol of M₃PO₄, a molar mass of 212 g/mol, so M = 39.1.', true, 'Correct: 4.54 × 10²²/6.022 × 10²³ = 0.07539 mol O; ÷ 4 = 0.01885 mol; 4.00/0.01885 = 212.2 g/mol; minus 94.97 for PO₄ gives 117.2 for 3 M, so M = 39.1, potassium.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Rb, because the unknown metal must be heavy to account for the small number of oxygen atoms.', false, 'Rb₃PO₄ (351.38 g/mol) would give only 2.74 × 10²² O atoms in 4.00 g, fewer than observed.' from version_ins;
-- apchem-mcq-b6-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.2-a', 'mcq', 'interpret the molecular-ion peaks of a diatomic element, where each element''s isotope abundances must be recovered from ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The mass spectrum of a sample of chlorine gas, Cl₂, shows three peaks from singly charged Cl₂⁺ ions: m/z 70 (relative height 9), m/z 72 (relative height 6) and m/z 74 (relative height 1). The only isotopes are ³⁵Cl and ³⁷Cl. Treat isotope masses as equal to their mass numbers. What is the average atomic mass of chlorine in this sample?', null, md5('apchem-mcq-b6-h-1.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '35.5, because the 70 : 72 : 74 heights of 9 : 6 : 1 correspond to 75% ³⁵Cl and 25% ³⁷Cl.', true, 'Correct: p² = 9/16 so the fraction of ³⁵Cl is 0.75 and of ³⁷Cl is 0.25 (check: 2pq = 6/16); average = 35(0.75) + 37(0.25) = 35.5.' from version_ins
union all select gen_random_uuid(), id, 'B', '71.0, because it is the weighted average of the three peak positions.', false, 'The weighted average of the peaks is 71.0, but that is the average mass of a Cl₂ molecule; the atomic mass is half of it.' from version_ins
union all select gen_random_uuid(), id, 'C', '36.0, because the average of the two isotope masses, 35 and 37, is 36.', false, 'A simple average of 35 and 37 ignores abundance; the 9 : 6 : 1 pattern shows ³⁵Cl is far more abundant, so the average must be closer to 35.' from version_ins
union all select gen_random_uuid(), id, 'D', '35.0, because the tallest peak at m/z 70 corresponds to the most abundant isotope.', false, 'The tallest peak is ³⁵Cl₂, but 25% of the atoms are ³⁷Cl, which raises the average above 35.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-h-1.1-a','apchem-mcq-b6-sv-h-1.1-a-v1','apchem-mcq-b6-sv-h-1.1-a-v2','apchem-mcq-b6-sv-h-1.1-a-v3','apchem-mcq-b6-h-1.1-b','apchem-mcq-b6-sv-h-1.1-b-v1','apchem-mcq-b6-sv-h-1.1-b-v2','apchem-mcq-b6-sv-h-1.1-b-v3','apchem-mcq-b6-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-h-1.1-a','apchem-mcq-b6-sv-h-1.1-a-v1','apchem-mcq-b6-sv-h-1.1-a-v2','apchem-mcq-b6-sv-h-1.1-a-v3','apchem-mcq-b6-h-1.1-b','apchem-mcq-b6-sv-h-1.1-b-v1','apchem-mcq-b6-sv-h-1.1-b-v2','apchem-mcq-b6-sv-h-1.1-b-v3','apchem-mcq-b6-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
