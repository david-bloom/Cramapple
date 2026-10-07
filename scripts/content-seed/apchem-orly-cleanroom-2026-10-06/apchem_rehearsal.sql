begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-orly-cleanroom-publish-20261006'));
do $$ begin
  if exists (select 1 from app.content_items where content_key = any (array['apchem-mcq-orly-f1-v1','apchem-mcq-orly-f1-v2','apchem-mcq-orly-f1-v3','apchem-mcq-orly-f2-v1','apchem-mcq-orly-f2-v2','apchem-mcq-orly-f2-v3','apchem-mcq-orly-f3-v1','apchem-mcq-orly-f3-v2','apchem-mcq-orly-f3-v3','apchem-mcq-orly-f5-v1','apchem-mcq-orly-f5-v2','apchem-mcq-orly-f5-v3','apchem-mcq-orly-f6-v1','apchem-mcq-orly-f6-v2','apchem-mcq-orly-f6-v3','apchem-mcq-orly-f7-v1','apchem-mcq-orly-f7-v2','apchem-mcq-orly-f7-v3','apchem-mcq-orly-f8-v1','apchem-mcq-orly-f8-v2','apchem-mcq-orly-f8-v3'])) then raise exception 'already loaded'; end if;
end $$;
-- apchem-mcq-orly-f1-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f1-v1', 'mcq', 'Empirical formula of a ceramic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Silicon nitride, a hard ceramic used in bearings, is a pure compound of silicon and nitrogen. Elemental analysis shows it is 60.06% silicon and 39.94% nitrogen by mass. What is the empirical formula of the compound? (Molar masses: Si = 28.09 g/mol, N = 14.01 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f1-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SiN', false, 'Finds the correct mole ratio Si : N = 1 : 1.333 but rounds 1.333 to 1, giving SiN. A ratio near 1.33 must be multiplied by 3, not rounded.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Si₃N₄', true, 'In 100.00 g: Si = 60.06 g ÷ 28.09 g/mol = 2.138 mol; N = 39.94 g ÷ 14.01 g/mol = 2.851 mol. Dividing by the smaller amount gives Si : N = 1 : 1.333. Because 1.333 is about 4/3, multiply both by 3 to get 3 : 4, so the empirical formula is Si₃N₄.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Si₄N₃', false, 'Divides molar mass by mass instead of mass by molar mass: Si = 28.09 ÷ 60.06 = 0.4677 and N = 14.01 ÷ 39.94 = 0.3508, so Si : N = 1.333 : 1 = 4 : 3, giving Si₄N₃. The inverted division flips the ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Si₃N₂', false, 'Treats the mass ratio as the mole ratio: 60.06 : 39.94 = 1.504 : 1, about 3 : 2, giving Si₃N₂. The masses must first be converted to moles.' from version_ins;
-- apchem-mcq-orly-f1-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f1-v2', 'mcq', 'Empirical formula from element masses', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of a pure compound of aluminum and carbon is decomposed, and the sample is found to contain 3.238 g of aluminum and 1.081 g of carbon. What is the empirical formula of the compound? (Molar masses: Al = 26.98 g/mol, C = 12.01 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f1-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Al₃C', false, 'Treats the mass ratio as the mole ratio: 3.238 g : 1.081 g = 2.995 : 1, about 3 : 1, giving Al₃C. Grams of each element must be converted to moles first.' from version_ins
union all select gen_random_uuid(), id, 'B', 'AlC', false, 'Finds the correct mole ratio Al : C = 1.333 : 1 but rounds 1.333 to 1, giving AlC. A ratio near 1.33 must be multiplied by 3.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Al₃C₄', false, 'Finds the correct 4 : 3 ratio but writes the subscripts on the wrong elements, giving Al₃C₄. Al has the larger number of moles, so it takes the subscript 4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Al₄C₃', true, 'Al = 3.238 g ÷ 26.98 g/mol = 0.1200 mol; C = 1.081 g ÷ 12.01 g/mol = 0.09001 mol. Dividing by the smaller amount gives Al : C = 1.333 : 1. Multiplying by 3 gives 4 : 3, so the empirical formula is Al₄C₃.' from version_ins;
-- apchem-mcq-orly-f1-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f1-v3', 'mcq', 'Empirical formula from lab data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In an analysis of a pure oxide of gallium, a student determines that one sample of the compound contains 2.789 g of gallium and 0.955 g of oxygen. Based on these data, what is the empirical formula of the compound? (Molar masses: Ga = 69.72 g/mol, O = 16.00 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f1-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ga₃O', false, 'Treats the mass ratio as the mole ratio: 2.789 g : 0.955 g = 2.92 : 1, about 3 : 1, giving Ga₃O. The masses must be converted to moles first.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ga₂O₃', true, 'Ga = 2.789 g ÷ 69.72 g/mol = 0.04000 mol; O = 0.955 g ÷ 16.00 g/mol = 0.0597 mol. Dividing by the smaller amount gives Ga : O = 1 : 1.49, which is within experimental error of 1 : 1.5. Multiplying by 2 gives 2 : 3, so the empirical formula is Ga₂O₃.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ga₃O₂', false, 'Divides molar mass by mass: Ga = 69.72 ÷ 2.789 = 25.00 and O = 16.00 ÷ 0.955 = 16.75, so Ga : O = 1.49 : 1, about 3 : 2, giving Ga₃O₂. The inverted division flips the ratio.' from version_ins
union all select gen_random_uuid(), id, 'D', 'GaO', false, 'Finds the correct mole ratio Ga : O = 1 : 1.49 but rounds 1.49 to 1, giving GaO. A ratio near 1.5 must be multiplied by 2, not rounded.' from version_ins;
-- apchem-mcq-orly-f2-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f2-v1', 'mcq', 'Formula from one element percent', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A colorless liquid used in making optical fibers is a pure compound that contains only germanium and chlorine. The compound is 33.87% germanium by mass. What is the empirical formula of the compound? (Molar masses: Ge = 72.63 g/mol, Cl = 35.45 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f2-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'GeCl', false, 'Assumes that a compound of two elements must have a 1 : 1 ratio, giving GeCl. The percent data give a 1 : 4 mole ratio.' from version_ins
union all select gen_random_uuid(), id, 'B', 'GeCl₆', false, 'Does not subtract to find the chlorine percent and uses 100 g as the mass of chlorine: Cl = 100 g ÷ 35.45 g/mol = 2.821 mol; Ge = 33.87 g ÷ 72.63 g/mol = 0.4663 mol; Cl : Ge = 6.049 : 1, about 6 : 1, giving GeCl₆. The chlorine mass in 100 g of compound is only 66.13 g.' from version_ins
union all select gen_random_uuid(), id, 'C', 'GeCl₄', true, 'The chlorine percent is 100.00% − 33.87% = 66.13%. In 100.00 g: Ge = 33.87 g ÷ 72.63 g/mol = 0.4663 mol; Cl = 66.13 g ÷ 35.45 g/mol = 1.865 mol. Cl : Ge = 4.000 : 1, so the empirical formula is GeCl₄.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ge₂Cl₈', false, 'Ge₂Cl₈ has the same 1 : 4 ratio as GeCl₄, so it could be a molecular formula, but it is not the lowest whole-number ratio and so is not the empirical formula.' from version_ins;
-- apchem-mcq-orly-f2-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f2-v2', 'mcq', 'Empirical formula, not a multiple', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure compound that contains only antimony and chlorine is 59.28% chlorine by mass. What is the empirical formula of the compound? (Molar masses: Sb = 121.76 g/mol, Cl = 35.45 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f2-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'SbCl₂', false, 'Does not subtract to find the antimony percent and uses 100 g as the mass of antimony: Sb = 100 g ÷ 121.76 g/mol = 0.8213 mol; Cl = 59.28 g ÷ 35.45 g/mol = 1.672 mol; Cl : Sb = 2.036 : 1, about 2 : 1, giving SbCl₂. The antimony mass in 100 g of compound is only 40.72 g.' from version_ins
union all select gen_random_uuid(), id, 'B', 'SbCl', false, 'Assumes that a compound of two elements must have a 1 : 1 ratio, giving SbCl. The percent data give a 1 : 5 mole ratio.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sb₂Cl₁₀', false, 'Sb₂Cl₁₀ has the same 1 : 5 ratio as SbCl₅, so it is a possible molecular formula, but it is not the lowest whole-number ratio and so is not the empirical formula.' from version_ins
union all select gen_random_uuid(), id, 'D', 'SbCl₅', true, 'The antimony percent is 100.00% − 59.28% = 40.72%. In 100.00 g: Sb = 40.72 g ÷ 121.76 g/mol = 0.3344 mol; Cl = 59.28 g ÷ 35.45 g/mol = 1.672 mol. Cl : Sb = 5.000 : 1, so the empirical formula is SbCl₅.' from version_ins;
-- apchem-mcq-orly-f2-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f2-v3', 'mcq', 'Molecular formula of a boron hydride', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gaseous compound that contains only boron and hydrogen is 21.86% hydrogen by mass. The molar mass of the compound is 27.67 g/mol. What is the molecular formula of the compound? (Molar masses: B = 10.81 g/mol, H = 1.008 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f2-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'B₂H₆', true, 'The boron percent is 100.00% − 21.86% = 78.14%. In 100.00 g: B = 78.14 g ÷ 10.81 g/mol = 7.229 mol; H = 21.86 g ÷ 1.008 g/mol = 21.69 mol. H : B = 3.000 : 1, so the empirical formula is BH₃ (13.83 g/mol). 27.67 ÷ 13.83 = 2.00, so the molecular formula is B₂H₆.' from version_ins
union all select gen_random_uuid(), id, 'B', 'BH₃', false, 'Stops at the empirical formula BH₃. Its molar mass is 13.83 g/mol, half the stated 27.67 g/mol, so the molecular formula is the whole-number multiple B₂H₆; the empirical and molecular formulas are not the same here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'B₃H₇', false, 'Does not subtract to find the boron percent and uses 100 g as the mass of boron: B = 100 g ÷ 10.81 g/mol = 9.251 mol; H = 21.86 g ÷ 1.008 g/mol = 21.69 mol; H : B = 2.344 : 1, about 7 : 3, giving B₃H₇. The boron mass in 100 g of compound is only 78.14 g.' from version_ins
union all select gen_random_uuid(), id, 'D', 'B₂H₂', false, 'Assumes a 1 : 1 ratio because there are two elements: BH has a molar mass of 11.82 g/mol, and 27.67 ÷ 11.82 = 2.34, which is rounded to 2, giving B₂H₂. The percent data give a 1 : 3 ratio, not 1 : 1.' from version_ins;
-- apchem-mcq-orly-f3-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f3-v1', 'mcq', 'Oxygen atoms in a nitrate salt', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chemist measures out a sample of barium nitrate, Ba(NO₃)₂, that contains 2.00 mol of the compound. How many moles of oxygen atoms does the sample contain? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, '{}'::jsonb, md5('apchem-mcq-orly-f3-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.00 mol', false, 'Reports the moles of formula units of barium nitrate (2.00 mol) rather than the moles of oxygen atoms they contain.' from version_ins
union all select gen_random_uuid(), id, 'B', '12.0 mol', true, 'Each formula unit of Ba(NO₃)₂ contains 2 nitrate ions, each with 3 O atoms, so 6 O atoms per formula unit. 2.00 mol × 6 = 12.0 mol of O atoms.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.00 mol', false, 'Ignores the subscript 2 outside the parentheses and counts only 3 O atoms per formula unit: 2.00 mol × 3 = 6.00 mol.' from version_ins
union all select gen_random_uuid(), id, 'D', '7.23 × 10²⁴ mol', false, 'Finds 12.0 mol of O atoms and then multiplies by Avogadro''s number, 12.0 × 6.022 × 10²³ = 7.23 × 10²⁴, but labels the result in moles. That number is the count of O atoms, not an amount in moles.' from version_ins;
-- apchem-mcq-orly-f3-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f3-v2', 'mcq', 'Atoms in a fertilizer salt', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fertilizer sample contains 0.250 mol of ammonium hydrogen phosphate, (NH₄)₂HPO₄. Which of the following statements about the atoms in the sample is correct? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, '{}'::jsonb, md5('apchem-mcq-orly-f3-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample contains 2.00 mol of H atoms.', false, 'Counts hydrogen only in the two ammonium ions (8 H per formula unit) and misses the H in HPO₄²⁻: 0.250 mol × 8 = 2.00 mol.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample contains 2.25 mol of H atoms.', true, 'Each formula unit has 2 NH₄⁺ ions (8 H) and 1 HPO₄²⁻ ion (1 H), for 9 H atoms. 0.250 mol × 9 = 2.25 mol of H atoms. (For comparison: N = 0.500 mol, P = 0.250 mol, O = 1.00 mol.)' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample contains 0.250 mol of N atoms.', false, 'Ignores the subscript 2 outside (NH₄) and counts 1 N atom per formula unit: 0.250 mol × 1 = 0.250 mol. The correct amount is 0.250 × 2 = 0.500 mol of N atoms.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample contains 6.02 × 10²³ mol of O atoms.', false, 'Finds 0.250 mol × 4 = 1.00 mol of O atoms, then multiplies by Avogadro''s number to get 6.02 × 10²³ but keeps the unit mol. That number is the count of O atoms; the amount is 1.00 mol.' from version_ins;
-- apchem-mcq-orly-f3-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f3-v3', 'mcq', 'Atom counts in calcium phosphate', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of calcium phosphate, Ca₃(PO₄)₂, contains 0.120 mol of the compound. Which of the following statements about the sample is correct? (Avogadro''s number = 6.022 × 10²³ mol⁻¹)', null, '{}'::jsonb, md5('apchem-mcq-orly-f3-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample contains 2.89 × 10²³ O atoms.', false, 'Ignores the subscript 2 outside the parentheses and counts 4 O per formula unit: 0.120 × 4 = 0.480 mol; 0.480 × 6.022 × 10²³ = 2.89 × 10²³ O atoms.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sample contains 7.23 × 10²² Ca atoms.', false, 'Converts moles of formula units to particles, 0.120 × 6.022 × 10²³ = 7.23 × 10²², and reports it as Ca atoms. Each formula unit has 3 Ca atoms, so the sample has 0.360 mol Ca = 2.17 × 10²³ Ca atoms.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample contains 1.45 × 10²³ mol of P atoms.', false, 'Finds 0.120 × 2 = 0.240 mol of P atoms, then multiplies by Avogadro''s number to get 1.45 × 10²³ but labels it in moles. That number is the count of P atoms; the amount is 0.240 mol.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample contains 5.78 × 10²³ O atoms.', true, 'Each formula unit contains 2 phosphate ions × 4 O = 8 O atoms. 0.120 mol × 8 = 0.960 mol O; 0.960 mol × 6.022 × 10²³ mol⁻¹ = 5.78 × 10²³ O atoms.' from version_ins;
-- apchem-mcq-orly-f5-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f5-v1', 'mcq', 'Mixture percent from sodium analysis', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 5.00 g sample is a mixture of sodium sulfate, Na₂SO₄ (molar mass 142.04 g/mol), and potassium chloride, KCl (molar mass 74.55 g/mol). Elemental analysis shows that the sample contains 0.0300 mol of sodium atoms. What is the percent by mass of Na₂SO₄ in the sample? (Na = 22.99 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f5-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '85.2%', false, 'Forgets the subscript 2 on Na, so takes mol Na₂SO₄ = 0.0300 mol: 0.0300 mol × 142.04 g/mol = 4.261 g; 4.261 g ÷ 5.00 g × 100 = 85.2%.' from version_ins
union all select gen_random_uuid(), id, 'B', '13.8%', false, 'Reports the percent of the element, not the component: 0.0300 mol × 22.99 g/mol = 0.690 g Na; 0.690 g ÷ 5.00 g × 100 = 13.8%.' from version_ins
union all select gen_random_uuid(), id, 'C', '42.6%', true, 'Only Na₂SO₄ contains sodium, and each formula unit has 2 Na. mol Na₂SO₄ = 0.0300 mol ÷ 2 = 0.0150 mol; mass = 0.0150 mol × 142.04 g/mol = 2.131 g; percent = 2.131 g ÷ 5.00 g × 100 = 42.6%.' from version_ins
union all select gen_random_uuid(), id, 'D', '22.4%', false, 'Uses the molar mass of the wrong component (KCl): 0.0150 mol × 74.55 g/mol = 1.118 g; 1.118 g ÷ 5.00 g × 100 = 22.4%.' from version_ins;
-- apchem-mcq-orly-f5-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f5-v2', 'mcq', 'Mixture percent from calcium mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.50 g sample of a powder is a mixture of calcium carbonate, CaCO₃ (molar mass 100.09 g/mol), and sodium chloride, NaCl (molar mass 58.44 g/mol). Elemental analysis shows that the sample contains 1.00 g of calcium. What is the percent by mass of CaCO₃ in the sample? (Ca = 40.08 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f5-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '32.4%', false, 'Uses the molar mass of the wrong component (NaCl): 0.02495 mol × 58.44 g/mol = 1.458 g; 1.458 g ÷ 4.50 g × 100 = 32.4%.' from version_ins
union all select gen_random_uuid(), id, 'B', '40.0%', false, 'Divides by the mass of the component instead of the whole sample: 1.00 g Ca ÷ 2.497 g CaCO₃ × 100 = 40.0% (this is the percent of Ca in CaCO₃, not the percent of CaCO₃ in the sample).' from version_ins
union all select gen_random_uuid(), id, 'C', '22.2%', false, 'Reports the percent of the element, not the component: 1.00 g Ca ÷ 4.50 g × 100 = 22.2%.' from version_ins
union all select gen_random_uuid(), id, 'D', '55.5%', true, 'Only CaCO₃ contains calcium (1 Ca per formula unit). mol Ca = 1.00 g ÷ 40.08 g/mol = 0.02495 mol = mol CaCO₃; mass CaCO₃ = 0.02495 mol × 100.09 g/mol = 2.497 g; percent = 2.497 g ÷ 4.50 g × 100 = 55.5%.' from version_ins;
-- apchem-mcq-orly-f5-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f5-v3', 'mcq', 'Purity of a copper ore', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An 8.00 g sample of a copper ore is a mixture of copper(I) sulfide, Cu₂S (molar mass 159.17 g/mol), and rock that contains no copper. Elemental analysis shows that the sample contains 2.20 g of copper. What is the purity of the ore, expressed as the percent by mass of Cu₂S in the sample? (Cu = 63.55 g/mol)', null, '{}'::jsonb, md5('apchem-mcq-orly-f5-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '68.9%', false, 'Forgets the subscript 2 on Cu, so takes mol Cu₂S = 0.03462 mol: 0.03462 mol × 159.17 g/mol = 5.510 g; 5.510 g ÷ 8.00 g × 100 = 68.9%.' from version_ins
union all select gen_random_uuid(), id, 'B', '27.5%', false, 'Reports the percent of the element, not the component: 2.20 g Cu ÷ 8.00 g × 100 = 27.5%.' from version_ins
union all select gen_random_uuid(), id, 'C', '34.4%', true, 'Only Cu₂S contains copper, with 2 Cu per formula unit. mol Cu = 2.20 g ÷ 63.55 g/mol = 0.03462 mol; mol Cu₂S = 0.03462 ÷ 2 = 0.01731 mol; mass Cu₂S = 0.01731 mol × 159.17 g/mol = 2.755 g; purity = 2.755 g ÷ 8.00 g × 100 = 34.4%.' from version_ins
union all select gen_random_uuid(), id, 'D', '79.9%', false, 'Divides by the mass of the component instead of the whole sample: 2.20 g Cu ÷ 2.755 g Cu₂S × 100 = 79.9% (the percent of Cu in Cu₂S).' from version_ins;
-- apchem-mcq-orly-f6-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f6-v1', 'mcq', 'Nitrate ion from two salts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student dissolves 0.0200 mol of sodium nitrate, NaNO₃, and 0.0150 mol of calcium nitrate, Ca(NO₃)₂, in water and adds water until the total volume of the solution is 250.0 mL. Both solids dissociate completely. What is the concentration of nitrate ion, NO₃⁻, in the solution?', null, '{}'::jsonb, md5('apchem-mcq-orly-f6-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.200 M', true, 'mol NO₃⁻ = 0.0200 mol (1 per NaNO₃) + 2 × 0.0150 mol (2 per Ca(NO₃)₂) = 0.0500 mol; [NO₃⁻] = 0.0500 mol ÷ 0.2500 L = 0.200 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.140 M', false, 'Ignores the 2 NO₃⁻ per Ca(NO₃)₂: (0.0200 + 0.0150) mol ÷ 0.2500 L = 0.140 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.100 M', false, 'Averages the two nitrate concentrations instead of adding moles: NaNO₃ gives 0.0200 ÷ 0.2500 = 0.0800 M and Ca(NO₃)₂ gives 0.0300 ÷ 0.2500 = 0.120 M; (0.0800 + 0.120) ÷ 2 = 0.100 M.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.00 × 10⁻⁴ M', false, 'Uses 250.0 mL as if it were 250.0 L: 0.0500 mol ÷ 250.0 = 2.00 × 10⁻⁴ M.' from version_ins;
-- apchem-mcq-orly-f6-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f6-v2', 'mcq', 'Potassium ion from two phosphates', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solution is prepared by dissolving 2.55 g of potassium phosphate, K₃PO₄ (molar mass 212.27 g/mol), and 1.64 g of sodium phosphate, Na₃PO₄ (molar mass 163.94 g/mol), in water and diluting to a total volume of 250.0 mL. Both solids dissociate completely. What is the concentration of potassium ion, K⁺, in the solution?', null, '{}'::jsonb, md5('apchem-mcq-orly-f6-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0481 M', false, 'Ignores the 3 K⁺ per K₃PO₄: 0.01201 mol ÷ 0.2500 L = 0.0481 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0721 M', false, 'Averages the K⁺ concentration supplied by K₃PO₄ (0.144 M) with that supplied by Na₃PO₄ (0 M) instead of adding moles of K⁺: (0.144 + 0) ÷ 2 = 0.0721 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.44 × 10⁻⁴ M', false, 'Uses 250.0 mL as if it were 250.0 L: 0.03604 mol ÷ 250.0 = 1.44 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.144 M', true, 'Only K₃PO₄ supplies K⁺, 3 per formula unit. mol K₃PO₄ = 2.55 g ÷ 212.27 g/mol = 0.01201 mol; mol K⁺ = 3 × 0.01201 = 0.03604 mol; [K⁺] = 0.03604 mol ÷ 0.2500 L = 0.144 M. The Na₃PO₄ adds phosphate but no K⁺.' from version_ins;
-- apchem-mcq-orly-f6-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f6-v3', 'mcq', 'Ammonium ion from two salts', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student dissolves 2.64 g of ammonium sulfate, (NH₄)₂SO₄ (molar mass 132.15 g/mol), and 0.800 g of ammonium nitrate, NH₄NO₃ (molar mass 80.05 g/mol), in water and adds water until the total volume of the solution is 350.0 mL. Both solids dissociate completely. What is the concentration of ammonium ion, NH₄⁺, in the solution?', null, '{}'::jsonb, md5('apchem-mcq-orly-f6-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.143 M', true, 'mol (NH₄)₂SO₄ = 2.64 g ÷ 132.15 g/mol = 0.019977 mol, giving 2 × 0.019977 = 0.039955 mol NH₄⁺; mol NH₄NO₃ = 0.800 g ÷ 80.05 g/mol = 0.009994 mol, giving 0.009994 mol NH₄⁺. Total NH₄⁺ = 0.04995 mol; [NH₄⁺] = 0.04995 mol ÷ 0.3500 L = 0.143 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.114 M', false, 'Counts NH₄⁺ from (NH₄)₂SO₄ only and leaves out the NH₄NO₃: 0.03995 mol ÷ 0.3500 L = 0.114 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0856 M', false, 'Ignores the 2 NH₄⁺ per (NH₄)₂SO₄: (0.01998 + 0.009994) mol ÷ 0.3500 L = 0.0856 M.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0714 M', false, 'Averages the two ammonium concentrations instead of adding moles: (NH₄)₂SO₄ gives 0.1142 M and NH₄NO₃ gives 0.02855 M; (0.1142 + 0.02855) ÷ 2 = 0.0714 M.' from version_ins;
-- apchem-mcq-orly-f7-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f7-v1', 'mcq', 'Measurement needed for molar mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student plans to find the molar mass of an unknown gas using PV = nRT. The student weighs an evacuated rigid glass flask whose internal volume has been calibrated as 0.5000 L, fills the flask with the gas, measures the absolute pressure of the gas with a pressure sensor attached to the flask, and weighs the filled flask. The gas is dry, and no liquid is present in the flask at any time. Which additional measurement is needed to calculate the molar mass of the gas?', null, '{}'::jsonb, md5('apchem-mcq-orly-f7-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The outside height and diameter of the flask', false, 'The outside dimensions only describe the apparatus; the internal volume needed for V is already calibrated, so these dimensions are not needed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The vapor pressure of water at room temperature', false, 'The gas is dry and no water was used, so no water vapor contributes a partial pressure. With only one gas in the flask, P_total = P_gas, and the measured pressure is already the pressure of the gas.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The temperature of the gas in the flask', true, 'M = mRT/(PV). The mass of gas comes from the two weighings, V is the calibrated 0.5000 L, and P is the measured absolute pressure, so the only missing quantity is T (measured, then converted to kelvins).' from version_ins
union all select gen_random_uuid(), id, 'D', 'The thickness of the flask''s glass wall', false, 'The glass thickness only describes the apparatus; the internal volume is already known, so this measurement plays no part in the calculation.' from version_ins;
-- apchem-mcq-orly-f7-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f7-v2', 'mcq', 'Quantity not needed for molar mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student finds the molar mass of a gas from a small cylinder using a gas-tight syringe. The student weighs the empty syringe with its plunger pushed fully in, draws gas from the cylinder into the syringe, closes the tip, and weighs the filled syringe. The plunger slides freely, so the gas in the syringe is at the barometric pressure. The gas is dry, and no liquid is present. The student records: the mass of the empty syringe; the mass of the filled syringe; the gas volume read from the syringe''s printed scale; the room temperature in degrees Celsius; the barometric pressure; and the length of the syringe barrel. Which recorded quantity could be left out without affecting the calculated molar mass?', null, '{}'::jsonb, md5('apchem-mcq-orly-f7-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The volume read from the printed scale, because the volume can be found from the length of the barrel', false, 'The scale reading is V in PV = nRT. The barrel length alone cannot give the volume (the cross-sectional area is not recorded); this treats a measurement that only describes the apparatus as the necessary one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The barometric pressure, because the pressure of the gas must instead be found by subtracting the vapor pressure of water', false, 'The gas is dry and no water was used, so no water vapor contributes a partial pressure. With only one gas in the syringe, P_total = P_gas, so the barometric pressure is the gas pressure and is needed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The length of the syringe barrel, because the gas volume is read directly from the printed scale', true, 'M = mRT/(PV): m comes from the two weighings, V from the printed scale, T from the room temperature (converted to kelvins), and P is the barometric pressure. The barrel length only describes the apparatus and is not used.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The room temperature, because a temperature recorded in degrees Celsius cannot be used in PV = nRT', false, 'The temperature is needed; a Celsius reading is used after converting it to kelvins (T = °C + 273.15). Substituting the Celsius value directly would be the error, not recording it.' from version_ins;
-- apchem-mcq-orly-f7-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f7-v3', 'mcq', 'Using total pressure over water', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student releases 0.520 g of a gas from a pressurized can and collects it in an inverted graduated tube that starts out full of water, at 22.0°C. The student then raises or lowers the tube until the pressure of the gas mixture trapped in it matches the barometric pressure, 0.9921 atm, and reads a gas volume of 0.2340 L. Water vapor in the tube contributes a partial pressure equal to the vapor pressure of water, 0.0261 atm at 22.0°C. In the calculation, the student uses 0.9921 atm as the pressure of the collected gas in PV = nRT (R = 0.08206 L·atm/(mol·K)). How does this error affect the calculated molar mass of the gas?', null, '{}'::jsonb, md5('apchem-mcq-orly-f7-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is unchanged, because the water vapor is part of the collected gas, so the barometric pressure is the correct pressure to use.', false, 'The 0.520 g is the mass of the gas released from the can only; water vapor adds to the total pressure but not to that mass, so the gas''s partial pressure, P_gas = P_total − P_water, not the total pressure, must be used.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is too high, because using the total pressure instead of the gas''s partial pressure makes the calculated number of moles of gas too large.', false, 'Correctly sees that n is too large but reverses the effect on M: M = m/n, so a larger n gives a smaller M, not a larger one.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is too low, because using the total pressure instead of the gas''s partial pressure makes the calculated number of moles of gas too large.', true, 'P_gas = P_total − P_water = 0.9921 − 0.0261 = 0.9660 atm. Using 0.9921 atm makes n = PV/RT too large, and since M = m/n with m fixed, M comes out too low. Correct: M = (0.520)(0.08206)(295.15) ÷ [(0.9660)(0.2340)] = 55.7 g/mol; with the error: (0.520)(0.08206)(295.15) ÷ [(0.9921)(0.2340)] = 54.3 g/mol.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It cannot be determined unless the inside diameter of the graduated tube is also known.', false, 'The volume is read directly from the graduated tube; the tube''s diameter only describes the apparatus and is not needed to judge the effect.' from version_ins;
-- apchem-mcq-orly-f8-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f8-v1', 'mcq', 'Drying a sample to constant mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'To find the percent by mass of water in a sample of damp sand, a student heats the sample in a crucible, lets it cool, and weighs it, repeating the heating-and-cooling cycle. The masses of the crucible and sand after the first three cycles are 24.815 g, 24.702 g, and 24.668 g. What should the student do next?', null, '{}'::jsonb, md5('apchem-mcq-orly-f8-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Heat, cool, and weigh the crucible and sand again, repeating until two successive masses agree closely', true, 'The mass is still falling (by 0.113 g, then 0.034 g), so water is still being driven off. Heating to constant mass, when successive weighings agree, shows that all the water has been removed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Discard the sample and repeat the experiment with a sample of a different starting mass', false, 'Nothing is wrong with the sample size; the measurement simply has not reached constant mass. More heating cycles, not a new starting mass, are needed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Use the average of the three recorded masses as the final mass', false, 'Averaging masses from cycles that have not converged includes masses of sand that still held water, giving a final mass that is too high.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Use 24.668 g as the final mass, because it is the lowest mass recorded', false, '24.668 g is only the lowest mass so far; because the masses have not yet agreed, some water may remain, and the true final mass may be lower.' from version_ins;
-- apchem-mcq-orly-f8-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f8-v2', 'mcq', 'Percent water from drying data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student wants to find the percent by mass of water in a sample of barium sulfate powder that is still damp with water. The empty crucible has a mass of 16.420 g, and the crucible with the damp sample has a mass of 19.870 g. After three cycles of heating, cooling, and weighing, the masses of the crucible and sample are 19.402 g, 19.355 g, and 19.353 g. Which conclusion is best supported by these data?', null, '{}'::jsonb, md5('apchem-mcq-orly-f8-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'No percent of water can be stated until the experiment is repeated with a larger starting mass.', false, 'The successive masses already agree, so the measurement is complete; the starting mass does not need to change.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The damp sample was 15.0% water by mass.', true, 'The last two masses (19.355 g and 19.353 g) agree, so constant mass was reached; final mass = 19.353 g. Sample mass = 19.870 − 16.420 = 3.450 g; water lost = 19.870 − 19.353 = 0.517 g; percent water = 0.517 ÷ 3.450 × 100 = 15.0%.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The damp sample was 14.5% water by mass.', false, 'Averages all three heated masses, including the first, which had not converged: average = 19.370 g; water lost = 19.870 − 19.370 = 0.500 g; 0.500 ÷ 3.450 × 100 = 14.5%.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The calculated value is 15.0% water by mass, but the true value is probably lower, because any water not driven off would make the calculated percent too high.', false, 'Reverses the effect of incomplete heating: water left in the sample makes the final mass too high and the mass lost too small, so the calculated percent water would be too low, not too high. Also, the data show constant mass was reached.' from version_ins;
-- apchem-mcq-orly-f8-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-orly-f8-v3', 'mcq', 'Stopping before constant mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 6.000 g sample of sodium chloride crystals wet with acetone is placed in a dish of mass 31.250 g and warmed in a drying oven to drive off the acetone, then cooled and weighed. After three warming-and-cooling cycles the masses of the dish and sample are 36.402 g, 36.237 g, and 36.198 g. The student stops here and uses 36.198 g as the final mass to calculate the percent by mass of acetone in the wet sample, obtaining 17.5%. How does the student''s result most likely compare with the true percent by mass of acetone?', null, '{}'::jsonb, md5('apchem-mcq-orly-f8-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It cannot be judged unless the experiment is repeated with a different starting mass of wet crystals.', false, 'The problem is that constant mass was not reached, which is fixed by more warming-and-weighing cycles on the same sample, not by a different starting mass; the most likely direction of the error can already be judged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is accurate, because 36.198 g is the lowest mass recorded and is therefore the final mass.', false, 'The lowest mass is not the final mass until successive weighings agree; the last decrease (0.039 g) shows acetone was still leaving.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is too high, because acetone remaining in the crystals is counted as part of the mass lost.', false, 'Reverses the direction: acetone that remains stays in the weighed mass, so it is NOT counted as lost; the mass lost and the calculated percent are too small, not too large.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is too low, because the masses were still decreasing, so some acetone probably remained and the mass lost was too small.', true, 'Mass before warming = 31.250 + 6.000 = 37.250 g; acetone lost = 37.250 − 36.198 = 1.052 g; 1.052 ÷ 6.000 × 100 = 17.5%. The masses fell by 0.165 g and then 0.039 g, so constant mass was not reached. Any acetone still present makes the final mass too high and the mass lost too small, so 17.5% is lower than the true percent.' from version_ins;

create temporary table lab (content_key text primary key, topic text, req int[], pu int, difficulty text, skill text, skill_status text, tier text, po_topic boolean, family text) on commit drop;
insert into lab values

('apchem-mcq-orly-f1-v1','1.3',array[1]::int[],1,'Easy','2.D','validated','4of4',false,'F1'),
('apchem-mcq-orly-f1-v2','1.3',array[1]::int[],1,'Medium','2.D','validated','3of4',false,'F1'),
('apchem-mcq-orly-f1-v3','1.3',array[1]::int[],1,'Hard','2.D','validated','3of4',false,'F1'),
('apchem-mcq-orly-f2-v1','1.3',array[1]::int[],1,'Easy','2.D','validated','3of4',false,'F2'),
('apchem-mcq-orly-f2-v2','1.3',array[1]::int[],1,'Medium','2.D','validated','3of4',false,'F2'),
('apchem-mcq-orly-f2-v3','1.3',array[1]::int[],1,'Hard','2.D','provisional_model','2of4',false,'F2'),
('apchem-mcq-orly-f3-v1','1.1',array[1]::int[],1,'Easy','5.F','validated','4of4',false,'F3'),
('apchem-mcq-orly-f3-v2','1.1',array[1]::int[],1,'Medium','5.F','validated','4of4',false,'F3'),
('apchem-mcq-orly-f3-v3','1.1',array[1]::int[],1,'Hard','5.F','validated','4of4',false,'F3'),
('apchem-mcq-orly-f5-v1','1.4',array[1]::int[],1,'Easy','5.F','validated','4of4',false,'F5'),
('apchem-mcq-orly-f5-v2','1.4',array[1]::int[],1,'Medium','5.F','validated','4of4',false,'F5'),
('apchem-mcq-orly-f5-v3','1.4',array[1]::int[],1,'Hard','5.F','validated','4of4',false,'F5'),
('apchem-mcq-orly-f6-v1','3.7',array[1,3]::int[],3,'Easy','5.F','validated','4of4',false,'F6'),
('apchem-mcq-orly-f6-v2','3.7',array[1,3]::int[],3,'Medium','5.F','validated','4of4',true,'F6'),
('apchem-mcq-orly-f6-v3','3.7',array[1,3]::int[],3,'Hard','5.F','validated','4of4',false,'F6'),
('apchem-mcq-orly-f7-v1','3.4',array[1,3]::int[],3,'Easy','5.A','validated','4of4',false,'F7'),
('apchem-mcq-orly-f7-v2','3.4',array[1,3]::int[],3,'Medium','5.A','validated','4of4',false,'F7'),
('apchem-mcq-orly-f7-v3','3.4',array[1,3]::int[],3,'Hard','5.C','validated','4of4',false,'F7'),
('apchem-mcq-orly-f8-v1','1.4',array[1]::int[],1,'Easy','5.B','validated','3of4',false,'F8'),
('apchem-mcq-orly-f8-v2','1.4',array[1]::int[],1,'Medium','5.F','validated','4of4',false,'F8'),
('apchem-mcq-orly-f8-v3','1.4',array[1]::int[],1,'Hard','5.C','validated','4of4',false,'F8');
create temporary table expd (content_key text primary key, h text) on commit drop;
insert into expd values ('apchem-mcq-orly-f1-v1','c10d8e053121739fb2a0b523295b2aca'),('apchem-mcq-orly-f1-v2','6e51e32f3f087472566a89f71e66dbe0'),('apchem-mcq-orly-f1-v3','2a23e39a235c43bc9f6b8cf70ee460e1'),('apchem-mcq-orly-f2-v1','91dc3f203b61144d4b4d76a833aa0eb8'),('apchem-mcq-orly-f2-v2','b5c1f812977e27b3c017998f5cbb3ee9'),('apchem-mcq-orly-f2-v3','f7c356c5cc34a5c2fcd437b3e3096ca1'),('apchem-mcq-orly-f3-v1','995ec7a47ef67aa935e1832da9c46897'),('apchem-mcq-orly-f3-v2','834c65f5ce28fe46d2b9cc7981fb05d7'),('apchem-mcq-orly-f3-v3','0dbdc9419a31728059e33bc02514e917'),('apchem-mcq-orly-f5-v1','cecc26559798bd9cfb902400902368a4'),('apchem-mcq-orly-f5-v2','e49e44fe852d15078075344acd7fcaa2'),('apchem-mcq-orly-f5-v3','81e7ef7dad134640fe06f554497849b4'),('apchem-mcq-orly-f6-v1','010fc632d56310b1b08d4f6a1286b2d0'),('apchem-mcq-orly-f6-v2','376b48287bba1c471885cb5aa1417c75'),('apchem-mcq-orly-f6-v3','ce54f35058c5c28e751930e36463d7fd'),('apchem-mcq-orly-f7-v1','e83309ddb992447f729e6dbb3c4a4581'),('apchem-mcq-orly-f7-v2','b495288126c1e5a09b0fa67ca5524681'),('apchem-mcq-orly-f7-v3','67c07c3befca3122fef20f7a29db0aa9'),('apchem-mcq-orly-f8-v1','12264f9f550cfb443803b7b71879c1e1'),('apchem-mcq-orly-f8-v2','a223b8b4a35e88e513d5cf59879bd444'),('apchem-mcq-orly-f8-v3','d0ec4af06b0f33ad8c65859c25441869');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id, gen_random_uuid() skill_vd
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status='draft'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1 and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>21 then raise exception 'expected 21 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c' and tt.topic_code=tgt.topic)) then raise exception 'unknown topic'; end if;
 if exists (select 1 from tgt where skill is not null and not exists (select 1 from app.taxonomy_cells c where c.taxonomy_source_version='cbe3116f-6ef5-410c-b535-e9fb711c4c2c' and c.topic_code=tgt.topic and c.skill_code=tgt.skill)) then raise exception 'skill not in grid'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id join expd e on e.content_key=t.content_key
     group by t.content_key, civ.stem, e.h having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=e.h) z)<>21 then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) from tgt where civ.id=tgt.version_id;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'Orly pooled-practice clean-room items (DECISION-0098), published on Product Owner chat approval 2026-10-06 (APPROVAL-0126). Clean-room authoring from scrubbed family specs; author verify scripts; independent re-derivation of every key; two-model blind solve + rationale audit (gpt-5.6-sol, deepseek-v4-pro-0813) with patch rounds re-checked in full; CED scope check; topic probe. Batch: scripts/content-seed/apchem-orly-cleanroom-2026-10-06/README.md',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','approval_0126_po_chat','qa_date','2026-10-06','content_key',content_key,'family',family),
 md5(jsonb_build_object('approval','APPROVAL-0126','content_key',content_key,'version',version_id)::text), 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 when civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct) then 'canonical letter mismatch'
 when civ.stem ~ E'\n\\s*A[\\.\\)]\\s' then 'embedded choice list'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, rationale, confidence, proposal_run)
select version_id, difficulty, 'calibrated_judgement', 'Authored band from the clean-room family spec (v1 easy, v2 medium, v3 hard); DECISION-0096 requires a band on every published MCQ.', 'medium', 'orly-cleanroom-2026-10-06' from tgt;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req, (select max(u) from unnest(req) u), pu, array[]::text[], 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional', 'provisional_model', 'apchem_orly_cleanroom_2026_10_06',
 jsonb_build_object('origin','clean_room_original','topic',topic,'family',family,'units_source', case when po_topic then 'Product Owner chat 2026-10-06 set topic 3.7 (checkers split 3.7/4.5)' else 'blind topic probe gpt-5.6-sol + deepseek-v4-pro-0813, 2 samples each; unit agreement' end,'report','scripts/content-seed/apchem-orly-cleanroom-2026-10-06'),
 'orly-cleanroom-labeling-2026-10-06', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', case when po_topic then 'chat_review' else 'automated_spot_check' end, pu, req,
 case when po_topic then 'Product Owner chat 2026-10-06 (APPROVAL-0126): "Approve 3.7".' else 'Product Owner chat approval 2026-10-06 (APPROVAL-0126). Two blind checkers (gpt-5.6-sol, deepseek-v4-pro-0813) placed the item in this unit (DECISION-0066).' end from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, topic, null, true, 'validated', 'apchem_orly_cleanroom_2026_10_06_topic',
 case when po_topic then 'Product Owner chat 2026-10-06 (topic 3.7)' else 'orly-cleanroom topic probe 2026-10-06 (gpt-5.6-sol + deepseek-v4-pro-0813, 2 samples each)' end, case when po_topic then 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid end, now(), gen_random_uuid() from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, topic, skill, false, skill_status, 'skill_orly_cleanroom_4voter_2026_10_06:'||tier,
 'orly-cleanroom skills 2026-10-06 (4 voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash; validated at >=3 of 4)', null,
 case when skill_status='validated' then now() end, case when skill_status='validated' then skill_vd end from tgt where skill is not null;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' and content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>21 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>21 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated'; if n<>21 then raise exception 'topic cell count %', n; end if;
  select count(*) into n from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id; if n<>21 then raise exception 'difficulty count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%, skill_cells=%, difficulty=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apchem_orly_cleanroom_2026_10_06' and label_status='validated'), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary), (select count(*) from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id); end $$;
rollback;
