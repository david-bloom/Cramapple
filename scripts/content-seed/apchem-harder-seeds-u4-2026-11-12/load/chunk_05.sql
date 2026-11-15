begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-h-4.5-b','apchem-mcq-b4-sv-h-4.5-b-v1','apchem-mcq-b4-sv-h-4.5-b-v2','apchem-mcq-b4-sv-h-4.5-b-v3','apchem-mcq-b4-h-4.6-a','apchem-mcq-b4-sv-h-4.6-a-v1','apchem-mcq-b4-sv-h-4.6-a-v2','apchem-mcq-b4-sv-h-4.6-a-v3','apchem-mcq-b4-h-4.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apchem-mcq-b4-h-4.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.5-b', 'mcq', 'use a product''s mass and the mole ratio to find the purity of a reactant', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An impure 5.00 g sample of KClO3 (122.55 g/mol) is heated until it decomposes completely according to 2 KClO3 → 2 KCl + 3 O2. The impurities do not release any gas. The O2 produced has a mass of 1.20 g (32.00 g/mol). What is the mass percent of KClO3 in the sample?', null, md5('apchem-mcq-b4-h-4.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '91.9%', false, 'It uses a 1:1 mole ratio between O2 and KClO3, but 3 O2 form per 2 KClO3.' from version_ins
union all select gen_random_uuid(), id, 'B', '30.6%', false, 'It ignores the coefficient 2 on KClO3 and uses 1 KClO3 per 3 O2, which halves the answer.' from version_ins
union all select gen_random_uuid(), id, 'C', '61.3%', true, 'Correct: 1.20 g O2 = 0.0375 mol; KClO3 = 0.0375 × 2/3 = 0.0250 mol = 3.06 g; 3.06 ÷ 5.00 = 61.3%.' from version_ins
union all select gen_random_uuid(), id, 'D', '24.0%', false, 'It divides the mass of O2 by the mass of the sample, which skips the conversion through moles and the mole ratio.' from version_ins;
-- apchem-mcq-b4-sv-h-4.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.5-b-v1', 'mcq', 'use a product''s mass and the mole ratio to find the purity of a reactant (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An impure 2.25 g sample of aluminum reacts with excess HCl according to 2 Al + 6 HCl → 2 AlCl3 + 3 H2. The impurities do not react. The H2 produced has a mass of 0.150 g (2.016 g/mol). What is the mass percent of Al (26.98 g/mol) in the sample?', null, md5('apchem-mcq-b4-sv-h-4.5-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '89.2%', false, 'It uses a 1:1 mole ratio of Al to H2, but 3 H2 form per 2 Al.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.7%', false, 'It divides the mass of H2 by the mass of the sample, which skips the mole conversion.' from version_ins
union all select gen_random_uuid(), id, 'C', '29.7%', false, 'It uses 1 Al per 3 H2, forgetting the coefficient 2 on Al.' from version_ins
union all select gen_random_uuid(), id, 'D', '59.5%', true, 'Correct: 0.150 g H2 = 0.07440 mol; Al = 0.07440 × 2/3 = 0.04960 mol = 1.338 g; 1.338 ÷ 2.25 = 59.5%.' from version_ins;
-- apchem-mcq-b4-sv-h-4.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.5-b-v2', 'mcq', 'use a product''s mass and the mole ratio to find the purity of a reactant (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An impure 4.20 g sample of NaHCO3 (84.01 g/mol) is heated according to 2 NaHCO3 → Na2CO3 + H2O + CO2. The impurities do not release gas. The CO2 produced has a mass of 0.880 g (44.01 g/mol). What is the mass percent of NaHCO3 in the sample?', null, md5('apchem-mcq-b4-sv-h-4.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '40.0%', false, 'It uses a 1:1 mole ratio, but 2 NaHCO3 form each CO2.' from version_ins
union all select gen_random_uuid(), id, 'B', '80.0%', true, 'Correct: 0.880 g CO2 = 0.0200 mol; NaHCO3 = 2 × 0.0200 = 0.0400 mol = 3.36 g; 3.36 ÷ 4.20 = 80.0%.' from version_ins
union all select gen_random_uuid(), id, 'C', '21.0%', false, 'It divides the mass of CO2 by the mass of the sample, skipping the moles and the mole ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', '20.0%', false, 'It inverts the ratio, using 1 NaHCO3 per 2 CO2, which gives 0.84 g.' from version_ins;
-- apchem-mcq-b4-sv-h-4.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.5-b-v3', 'mcq', 'use a product''s mass and the mole ratio to find the purity of a reactant (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Hydrogen peroxide solution decomposes according to 2 H2O2 → 2 H2O + O2. A 10.00 g sample of the solution produces 0.141 g of O2 (32.00 g/mol). What is the mass percent of H2O2 (34.01 g/mol) in the solution?', null, md5('apchem-mcq-b4-sv-h-4.5-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.41%', false, 'It divides the mass of O2 by the mass of the sample and skips the mole conversion.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.00%', true, 'Correct: 0.141 g O2 = 0.004406 mol; H2O2 = 2 × 0.004406 = 0.008813 mol = 0.2997 g; 0.2997 ÷ 10.00 = 3.00%.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.00%', false, 'It applies the 2:1 ratio twice, which doubles the correct moles of H2O2.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.50%', false, 'It uses a 1:1 ratio between H2O2 and O2, but 2 H2O2 form each O2.' from version_ins;
-- apchem-mcq-b4-h-4.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.6-a', 'mcq', 'find an unknown concentration from titration volumes when the mole ratio is not 1:1', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 25.00 mL sample of H2SO4(aq) is titrated to the equivalence point with 0.2000 M NaOH(aq), which requires 30.00 mL. The reaction is H2SO4 + 2 NaOH → Na2SO4 + 2 H2O. What is the concentration of the H2SO4 solution?', null, md5('apchem-mcq-b4-h-4.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.2400 M', false, 'It assumes a 1:1 mole ratio, but each H2SO4 needs two NaOH.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.1200 M', true, 'Correct: mol NaOH = 0.2000 × 0.03000 = 6.000 × 10⁻³ mol; mol H2SO4 = 3.000 × 10⁻³ mol; M = 3.000 × 10⁻³ ÷ 0.02500 L = 0.1200 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0545 M', false, 'It divides by the total volume of the mixture, 55.00 mL, instead of the 25.00 mL acid sample.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0833 M', false, 'It inverts the volume ratio, calculating 0.2000 × 25.00 ÷ 30.00 and then halving.' from version_ins;
-- apchem-mcq-b4-sv-h-4.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.6-a-v1', 'mcq', 'find an unknown concentration from titration volumes when the mole ratio is not 1:1 (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 20.00 mL sample of Ba(OH)2(aq) is titrated to the equivalence point with 0.1500 M HCl(aq), which requires 28.40 mL. The reaction is Ba(OH)2 + 2 HCl → BaCl2 + 2 H2O. What is the concentration of the Ba(OH)2 solution?', null, md5('apchem-mcq-b4-sv-h-4.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.1065 M', true, 'Correct: mol HCl = 0.1500 × 0.02840 = 4.260 × 10⁻³ mol; mol Ba(OH)2 = 2.130 × 10⁻³ mol; M = 2.130 × 10⁻³ ÷ 0.02000 L = 0.1065 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.2130 M', false, 'It assumes 1:1 stoichiometry and does not halve the moles of acid.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0533 M', false, 'It divides by 2 a second time after already using the 1:2 ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0440 M', false, 'It divides by the total volume, 48.40 mL, instead of the 20.00 mL of base.' from version_ins;
-- apchem-mcq-b4-sv-h-4.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.6-a-v2', 'mcq', 'find an unknown concentration from titration volumes when the mole ratio is not 1:1 (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 25.00 mL sample of H3PO4(aq) is titrated with 0.1000 M NaOH(aq) until both of the first two protons have been neutralized, forming Na2HPO4. This requires 37.50 mL of NaOH. What is the concentration of the H3PO4 solution?', null, md5('apchem-mcq-b4-sv-h-4.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.1500 M', false, 'It uses a 1:1 mole ratio of NaOH to H3PO4, which ignores that two protons react.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0500 M', false, 'It uses 3 NaOH per H3PO4, but the titration stops after two protons.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0750 M', true, 'Correct: mol NaOH = 0.1000 × 0.03750 = 3.750 × 10⁻³ mol; H3PO4 reacts with 2 NaOH to form Na2HPO4, so mol H3PO4 = 1.875 × 10⁻³ mol; M = 1.875 × 10⁻³ ÷ 0.02500 = 0.0750 M.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.2250 M', false, 'It multiplies by the number of protons instead of dividing.' from version_ins;
-- apchem-mcq-b4-sv-h-4.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.6-a-v3', 'mcq', 'find an unknown concentration from titration volumes when the mole ratio is not 1:1 (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 10.00 mL sample of vinegar is diluted to 100.0 mL with water. A 25.00 mL portion of the diluted solution is titrated to the equivalence point with 0.1000 M NaOH, which requires 21.40 mL. The reaction is HC2H3O2 + NaOH → NaC2H3O2 + H2O. What is the concentration of acetic acid in the original, undiluted vinegar?', null, md5('apchem-mcq-b4-sv-h-4.6-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0856 M', false, 'It gives the concentration of the diluted solution and forgets to correct for the dilution.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.214 M', false, 'It divides the moles by 10.00 mL, the volume of vinegar, instead of the 25.00 mL titrated.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.56 M', false, 'It multiplies by 100, using the final volume instead of the dilution factor of 10.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.856 M', true, 'Correct: mol NaOH = 0.1000 × 0.02140 = 2.140 × 10⁻³ mol = mol acid in the 25.00 mL portion; diluted M = 0.0856; the dilution factor is 10, so the vinegar is 0.856 M.' from version_ins;
-- apchem-mcq-b4-h-4.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.6-b', 'mcq', 'predict how a procedural error changes a calculated concentration', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student titrates 25.00 mL of HCl of unknown concentration with standard 0.100 M NaOH from a buret. Before filling, the student rinses the buret with distilled water and leaves the water droplets in it. The titration is otherwise done correctly, and the equivalence point is detected correctly. The student calculates the HCl concentration using 0.100 M for the NaOH. How will the calculated HCl concentration compare with the true value?', null, md5('apchem-mcq-b4-h-4.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It will be too low, because the water neutralizes some of the acid.', false, 'Water is neutral and neutralizes nothing; its effect is to dilute the base.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It will be correct, because water does not contain any acid or base.', false, 'Water does not add acid or base, but it lowers the concentration of the NaOH, and that changes the result.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It will be too high, because the diluted NaOH has a lower concentration than 0.100 M, so more volume is needed and the calculation overestimates the moles of base.', true, 'Correct: water in the buret dilutes the NaOH, so the actual concentration is below 0.100 M. More volume is needed, and calculating with 0.100 M overestimates the moles of NaOH and so the HCl concentration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It will be too low, because less NaOH is needed to reach the equivalence point.', false, 'A diluted base requires more volume, not less, to supply the same number of moles.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-h-4.5-b','apchem-mcq-b4-sv-h-4.5-b-v1','apchem-mcq-b4-sv-h-4.5-b-v2','apchem-mcq-b4-sv-h-4.5-b-v3','apchem-mcq-b4-h-4.6-a','apchem-mcq-b4-sv-h-4.6-a-v1','apchem-mcq-b4-sv-h-4.6-a-v2','apchem-mcq-b4-sv-h-4.6-a-v3','apchem-mcq-b4-h-4.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-h-4.5-b','apchem-mcq-b4-sv-h-4.5-b-v1','apchem-mcq-b4-sv-h-4.5-b-v2','apchem-mcq-b4-sv-h-4.5-b-v3','apchem-mcq-b4-h-4.6-a','apchem-mcq-b4-sv-h-4.6-a-v1','apchem-mcq-b4-sv-h-4.6-a-v2','apchem-mcq-b4-sv-h-4.6-a-v3','apchem-mcq-b4-h-4.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
