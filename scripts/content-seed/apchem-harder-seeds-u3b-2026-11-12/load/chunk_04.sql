begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.7-a-v3','apchem-mcq-b2-h-3.7-b','apchem-mcq-b2-sv-h-3.7-b-v1','apchem-mcq-b2-sv-h-3.7-b-v2','apchem-mcq-b2-sv-h-3.7-b-v3','apchem-mcq-b2-h-3.8-a','apchem-mcq-b2-sv-h-3.8-a-v1','apchem-mcq-b2-sv-h-3.8-a-v2','apchem-mcq-b2-sv-h-3.8-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apchem-mcq-b2-sv-h-3.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.7-a-v3', 'mcq', 'ion concentration after mixing two salt solutions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student mixes 75.0 mL of 0.200 M MgCl₂(aq) with 125.0 mL of 0.0800 M AlCl₃(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of Cl⁻ in the mixture?', null, md5('apchem-mcq-b2-sv-h-3.7-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.125 M', false, '0.125 M counts one Cl⁻ per formula unit, so the subscripts 2 and 3 are missed.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.320 M', false, '0.320 M averages the Cl⁻ concentrations (0.400 M and 0.240 M) without weighting by volume.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.640 M', false, '0.640 M adds the two Cl⁻ concentrations and ignores the dilution on mixing.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.300 M', true, 'Correct: mol Cl⁻ = 2 × 0.0750 × 0.200 + 3 × 0.125 × 0.0800 = 0.0300 + 0.0300 = 0.0600 mol; total volume 0.2000 L; 0.0600/0.2000 = 0.300 M.' from version_ins;
-- apchem-mcq-b2-h-3.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.7-b', 'mcq', 'two-step serial dilution with final volumes', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stock solution is 0.500 M. A 10.0 mL portion of the stock is diluted with water to a final volume of 100.0 mL (solution 1). Then 20.0 mL of solution 1 is diluted with water to a final volume of 50.0 mL (solution 2). What is the molarity of solution 2?', null, md5('apchem-mcq-b2-h-3.7-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0200 M', true, 'Correct: solution 1 = 0.500 × 10.0/100.0 = 0.0500 M; solution 2 = 0.0500 × 20.0/50.0 = 0.0200 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0500 M', false, '0.0500 M is the concentration of solution 1, and the second dilution was left out.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.200 M', false, '0.200 M applies the second dilution to the 0.500 M stock and skips the first dilution.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.0143 M', false, '0.0143 M treats 50.0 mL as water added, giving 20.0 mL out of 70.0 mL.' from version_ins;
-- apchem-mcq-b2-sv-h-3.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.7-b-v1', 'mcq', 'two-step serial dilution with final volumes (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.20 M stock solution is used. A 5.00 mL portion of stock is diluted to a final volume of 250.0 mL (solution 1). Then 10.0 mL of solution 1 is diluted to a final volume of 100.0 mL (solution 2). What is the molarity of solution 2?', null, md5('apchem-mcq-b2-sv-h-3.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0240 M', false, '0.0240 M is the concentration of solution 1, and the second dilution was left out.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.120 M', false, '0.120 M applies the second dilution to the stock and skips the first dilution.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.00218 M', false, '0.00218 M treats 100.0 mL as water added, giving 10.0 mL out of 110.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.00240 M', true, 'Correct: solution 1 = 1.20 × 5.00/250.0 = 0.0240 M; solution 2 = 0.0240 × 10.0/100.0 = 0.00240 M.' from version_ins;
-- apchem-mcq-b2-sv-h-3.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.7-b-v2', 'mcq', 'two-step serial dilution with final volumes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.400 M stock solution is used. A 25.0 mL portion of stock is diluted to a final volume of 500.0 mL (solution 1). Then 50.0 mL of solution 1 is diluted to a final volume of 200.0 mL (solution 2). What is the molarity of solution 2?', null, md5('apchem-mcq-b2-sv-h-3.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0200 M', false, '0.0200 M is the concentration of solution 1, and the second dilution was left out.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.100 M', false, '0.100 M applies the second dilution to the stock and skips the first dilution.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.00400 M', false, '0.00400 M treats 200.0 mL as water added, giving 50.0 mL out of 250.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.00500 M', true, 'Correct: solution 1 = 0.400 × 25.0/500.0 = 0.0200 M; solution 2 = 0.0200 × 50.0/200.0 = 0.00500 M.' from version_ins;
-- apchem-mcq-b2-sv-h-3.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.7-b-v3', 'mcq', 'two-step serial dilution with final volumes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.00 M stock solution is used. A 1.00 mL portion of stock is diluted to a final volume of 100.0 mL (solution 1). Then 5.00 mL of solution 1 is diluted to a final volume of 250.0 mL (solution 2). What is the molarity of solution 2?', null, md5('apchem-mcq-b2-sv-h-3.7-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.00 × 10⁻⁴ M', true, 'Correct: solution 1 = 2.00 × 1.00/100.0 = 0.0200 M; solution 2 = 0.0200 × 5.00/250.0 = 4.00 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0200 M', false, '0.0200 M is the concentration of solution 1, and the second dilution was left out.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.0400 M', false, '0.0400 M applies the second dilution (5.00/250.0) directly to the 2.00 M stock and skips the first dilution.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.00 × 10⁻³ M', false, '1.00 × 10⁻³ M uses 100.0 mL instead of 250.0 mL as the final volume of the second dilution.' from version_ins;
-- apchem-mcq-b2-h-3.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.8-a', 'mcq', 'what a correct particulate drawing of a dissolved compound must show', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student draws a particulate model of 3 formula units of CaCl₂ dissolved in water. Which description of the drawing is correct?', null, md5('apchem-mcq-b2-h-3.8-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Three Ca²⁺ ions and six Cl⁻ ions, separated; water molecules around each Ca²⁺ point their O atoms toward the ion and water molecules around each Cl⁻ point their H atoms toward the ion.', true, 'Correct: CaCl₂ is an ionic compound that dissociates into 1 Ca²⁺ and 2 Cl⁻ per unit; the partial negative O of water is attracted to cations and the partial positive H is attracted to anions.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Three intact CaCl₂ units, each surrounded by water molecules with the O atoms pointing toward the unit.', false, 'Ionic solids dissociate in water, so the solution has separated ions and not intact units.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Three Ca²⁺ ions and six Cl⁻ ions, separated; water molecules around each Ca²⁺ point their H atoms toward the ion and water molecules around each Cl⁻ point their O atoms toward the ion.', false, 'The orientation is reversed, since the partially negative O atoms are attracted to the positive ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Three Ca²⁺ ions and three Cl⁻ ions, separated; water molecules around each Ca²⁺ point their O atoms toward the ion and around each Cl⁻ point their H atoms toward the ion.', false, 'Each CaCl₂ unit gives two Cl⁻ ions, so three units must show six Cl⁻ for the charges to balance.' from version_ins;
-- apchem-mcq-b2-sv-h-3.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.8-a-v1', 'mcq', 'what a correct particulate drawing of a dissolved compound must show (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student draws a particulate model of 2 formula units of Al(NO₃)₃ dissolved in water. Which description of the drawing is correct?', null, md5('apchem-mcq-b2-sv-h-3.8-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Two Al³⁺ ions, six N atoms and eighteen O atoms, all separated, each surrounded by water molecules.', false, 'The covalent bonds inside nitrate are not broken when the salt dissolves, so N and O atoms are not drawn separately.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Two Al³⁺ ions and six NO₃⁻ ions, separated and with each NO₃⁻ intact; water O atoms point toward the Al³⁺ ions and water H atoms point toward the NO₃⁻ ions.', true, 'Correct: Al(NO₃)₃ gives 1 Al³⁺ and 3 NO₃⁻ per unit; the polyatomic nitrate ion stays intact in solution; water orients O toward cations and H toward anions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two Al³⁺ ions and two NO₃⁻ ions, separated; water O atoms point toward Al³⁺ and H atoms point toward NO₃⁻.', false, 'Each Al(NO₃)₃ unit supplies three nitrate ions, so two units must show six nitrate ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Two Al³⁺ ions and six NO₃⁻ ions, separated; water H atoms point toward the Al³⁺ ions and water O atoms point toward the NO₃⁻ ions.', false, 'The orientation is reversed, since the partially negative O atoms are attracted to the positive Al³⁺.' from version_ins;
-- apchem-mcq-b2-sv-h-3.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.8-a-v2', 'mcq', 'what a correct particulate drawing of a dissolved compound must show (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student draws a particulate model of 4 formula units of Na₂SO₄ dissolved in water. Which description of the drawing is correct?', null, md5('apchem-mcq-b2-sv-h-3.8-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Eight Na⁺ ions, four S atoms and sixteen O atoms, all separated, each surrounded by water molecules.', false, 'Sulfate is a polyatomic ion whose atoms stay bonded together in solution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Four Na⁺ ions and four SO₄²⁻ ions, separated; water O atoms point toward the SO₄²⁻ ions.', false, 'The charges do not balance, since four Na⁺ and four SO₄²⁻ have a net charge of -4, and each unit supplies two Na⁺.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Eight Na⁺ ions and four intact SO₄²⁻ ions, separated; water O atoms point toward the Na⁺ ions and water H atoms point toward the SO₄²⁻ ions.', true, 'Correct: Na₂SO₄ gives 2 Na⁺ and 1 SO₄²⁻ per unit, so 4 units give 8 Na⁺ and 4 SO₄²⁻, with sulfate intact; water O toward Na⁺, water H toward SO₄²⁻.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Four intact Na₂SO₄ units, each surrounded by water molecules hydrogen bonded to the O atoms of the sulfate.', false, 'Na₂SO₄ is ionic and dissociates in water, so intact units would not be drawn.' from version_ins;
-- apchem-mcq-b2-sv-h-3.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.8-a-v3', 'mcq', 'what a correct particulate drawing of a dissolved compound must show (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student draws a particulate model of 4 molecules of glucose, C₆H₁₂O₆, dissolved in water. Glucose is a molecular compound with several O-H groups. Which description of the drawing is correct?', null, md5('apchem-mcq-b2-sv-h-3.8-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Four glucose molecules broken into separate C, H and O atoms spread through the water.', false, 'Dissolving breaks the attractions between molecules and not the covalent bonds inside them.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Four C₆H₁₁O₆⁻ ions and four H⁺ ions, separated, because glucose has O-H groups.', false, 'Glucose is a molecular compound and a nonelectrolyte, so it does not release H⁺ ions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Four intact glucose molecules, separated from each other, each with water molecules hydrogen bonded to its O-H groups.', true, 'Correct: glucose dissolves as intact molecules because its polar O-H groups form hydrogen bonds with water; it does not form ions.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Four glucose molecules clumped into one cluster with water molecules around the outside.', false, 'Dissolved molecules are dispersed individually among the solvent, so a clump would represent undissolved solid.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.7-a-v3','apchem-mcq-b2-h-3.7-b','apchem-mcq-b2-sv-h-3.7-b-v1','apchem-mcq-b2-sv-h-3.7-b-v2','apchem-mcq-b2-sv-h-3.7-b-v3','apchem-mcq-b2-h-3.8-a','apchem-mcq-b2-sv-h-3.8-a-v1','apchem-mcq-b2-sv-h-3.8-a-v2','apchem-mcq-b2-sv-h-3.8-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-sv-h-3.7-a-v3','apchem-mcq-b2-h-3.7-b','apchem-mcq-b2-sv-h-3.7-b-v1','apchem-mcq-b2-sv-h-3.7-b-v2','apchem-mcq-b2-sv-h-3.7-b-v3','apchem-mcq-b2-h-3.8-a','apchem-mcq-b2-sv-h-3.8-a-v1','apchem-mcq-b2-sv-h-3.8-a-v2','apchem-mcq-b2-sv-h-3.8-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
