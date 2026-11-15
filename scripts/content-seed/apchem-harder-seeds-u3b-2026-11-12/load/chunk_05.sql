begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-h-3.8-b','apchem-mcq-b2-sv-h-3.8-b-v1','apchem-mcq-b2-sv-h-3.8-b-v2','apchem-mcq-b2-sv-h-3.8-b-v3','apchem-mcq-b2-h-3.9-a','apchem-mcq-b2-sv-h-3.9-a-v1','apchem-mcq-b2-sv-h-3.9-a-v2','apchem-mcq-b2-sv-h-3.9-a-v3','apchem-mcq-b2-h-3.9-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apchem-mcq-b2-h-3.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.8-b', 'mcq', 'compare solutions from drawings by dividing by volume and counting the right particles', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Diagram X represents 100 mL of NaCl(aq) and shows 8 Na⁺ ions and 8 Cl⁻ ions (water not drawn). Diagram Y represents 50 mL of CaCl₂(aq) and shows 3 Ca²⁺ ions and 6 Cl⁻ ions (water not drawn). Which statement correctly compares the solutions?', null, md5('apchem-mcq-b2-h-3.8-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The CaCl₂ solution has the higher concentration of formula units and also the higher concentration of Cl⁻ ions.', false, 'The CaCl₂ solution has more Cl⁻ per mL, but only 0.060 formula units per mL against 0.080 for NaCl.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The NaCl solution has the higher concentration of formula units and also the higher concentration of Cl⁻ ions, because its diagram has more particles.', false, 'Counting particles without dividing by the volume ignores that Y is only 50 mL, so its Cl⁻ concentration is higher.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The NaCl solution has the higher concentration of Cl⁻ ions, because it shows 8 Cl⁻ ions and the CaCl₂ solution shows only 6.', false, 'The number of ions drawn must be divided by the volume represented, and 6 Cl⁻ in 50 mL is more concentrated than 8 Cl⁻ in 100 mL.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The NaCl solution has the higher concentration of formula units, but the CaCl₂ solution has the higher concentration of Cl⁻ ions.', true, 'Correct: formula units per mL: X 8/100 = 0.080, Y 3/50 = 0.060; Cl⁻ per mL: X 8/100 = 0.080, Y 6/50 = 0.120.' from version_ins;
-- apchem-mcq-b2-sv-h-3.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.8-b-v1', 'mcq', 'compare solutions from drawings by dividing by volume and counting the right particles (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Diagram X represents 200 mL of NaBr(aq) and shows 12 Na⁺ ions and 12 Br⁻ ions (water not drawn). Diagram Y represents 100 mL of MgBr₂(aq) and shows 5 Mg²⁺ ions and 10 Br⁻ ions (water not drawn). Which statement correctly compares the solutions?', null, md5('apchem-mcq-b2-sv-h-3.8-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The MgBr₂ solution has the higher concentration of formula units and also the higher concentration of Br⁻ ions.', false, 'MgBr₂ has more Br⁻ per mL, but its formula unit concentration (0.050 per mL) is lower than that of NaBr (0.060 per mL).' from version_ins
union all select gen_random_uuid(), id, 'B', 'The NaBr solution has the higher concentration of Br⁻ ions, because its diagram shows more Br⁻ ions.', false, 'The ion count must be divided by the volume, and 10 Br⁻ in 100 mL is more concentrated than 12 Br⁻ in 200 mL.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two solutions have equal concentrations of Br⁻ ions, because each shows the same number of Br⁻ ions per formula unit.', false, 'NaBr gives one Br⁻ per unit and MgBr₂ gives two, so the Br⁻ concentrations are different.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The NaBr solution has the higher concentration of formula units, but the MgBr₂ solution has the higher concentration of Br⁻ ions.', true, 'Correct: formula units per mL: X 12/200 = 0.060, Y 5/100 = 0.050; Br⁻ per mL: X 12/200 = 0.060, Y 10/100 = 0.100.' from version_ins;
-- apchem-mcq-b2-sv-h-3.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.8-b-v2', 'mcq', 'compare solutions from drawings by dividing by volume and counting the right particles (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Diagram X represents 150 mL of LiCl(aq) and shows 9 Li⁺ ions and 9 Cl⁻ ions (water not drawn). Diagram Y represents 100 mL of AlCl₃(aq) and shows 4 Al³⁺ ions and 12 Cl⁻ ions (water not drawn). Which statement correctly compares the solutions?', null, md5('apchem-mcq-b2-sv-h-3.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The AlCl₃ solution has the higher concentration of formula units and also the higher concentration of Cl⁻ ions.', false, 'AlCl₃ has far more Cl⁻ per mL, but only 0.040 formula units per mL against 0.060 for LiCl.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The LiCl solution has the higher concentration of formula units, but the AlCl₃ solution has the higher concentration of Cl⁻ ions.', true, 'Correct: formula units per mL: X 9/150 = 0.060, Y 4/100 = 0.040; Cl⁻ per mL: X 9/150 = 0.060, Y 12/100 = 0.120.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The LiCl solution has the higher concentration of Cl⁻ ions, because its diagram shows 9 Cl⁻ ions in a larger volume.', false, 'The Cl⁻ concentration is the number of ions divided by the volume, and 12 Cl⁻ in 100 mL is double the 9 Cl⁻ in 150 mL.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The LiCl solution is more concentrated in formula units and in Cl⁻ ions, because 18 particles are drawn against 16.', false, 'Totals of 18 and 16 particles ignore the volumes, and AlCl₃ has the higher Cl⁻ concentration.' from version_ins;
-- apchem-mcq-b2-sv-h-3.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.8-b-v3', 'mcq', 'compare solutions from drawings by dividing by volume and counting the right particles (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Diagram X represents 100 mL of KCl(aq) and shows 10 K⁺ ions and 10 Cl⁻ ions (water not drawn). Diagram Y represents 50 mL of Na₃PO₄(aq) and shows 3 PO₄³⁻ ions and 9 Na⁺ ions (water not drawn). Which statement correctly compares the solutions?', null, md5('apchem-mcq-b2-sv-h-3.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The Na₃PO₄ solution has the higher concentration of formula units and also the higher concentration of cations.', false, 'Na₃PO₄ has more cations per mL, but its formula unit concentration (0.060 per mL) is lower than that of KCl (0.100 per mL).' from version_ins
union all select gen_random_uuid(), id, 'B', 'The KCl solution has the higher concentration of cations, because 10 K⁺ ions are drawn against 9 Na⁺ ions.', false, 'The number of ions drawn must be divided by the volume, and 9 Na⁺ in 50 mL is more concentrated than 10 K⁺ in 100 mL.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The KCl solution has the higher concentration of formula units, but the Na₃PO₄ solution has the higher concentration of cations.', true, 'Correct: formula units per mL: X 10/100 = 0.100, Y 3/50 = 0.060; cations per mL: X 10/100 = 0.100, Y 9/50 = 0.180.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two solutions have equal concentrations of cations, because each diagram shows nearly the same number of cations.', false, 'The diagrams show nearly equal cation counts but represent volumes that differ by a factor of two.' from version_ins;
-- apchem-mcq-b2-h-3.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.9-a', 'mcq', 'Rf from origin-line measurements and polarity comparison', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A paper chromatography strip uses polar paper and a nonpolar solvent. The starting line was drawn 1.5 cm above the bottom edge. After the run, the center of spot X is 4.5 cm above the bottom edge, the center of spot Y is 6.0 cm above it, and the solvent front is 8.5 cm above it. Which statement is correct?', null, md5('apchem-mcq-b2-h-3.9-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The Rf of X is 0.53, and X is more polar than Y.', false, '0.53 divides the height above the bottom edge instead of the distance from the starting line.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The Rf of X is 0.43, and X is more polar than Y.', true, 'Correct: distance moved by X = 4.5 - 1.5 = 3.0 cm; solvent front distance = 8.5 - 1.5 = 7.0 cm; Rf = 3.0/7.0 = 0.43; Y has Rf 4.5/7.0 = 0.64; on polar paper the more polar compound moves less.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The Rf of X is 0.43, and X is less polar than Y.', false, 'On a polar stationary phase the compound that moves less is held more strongly, so X is the more polar one.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The Rf of X is 0.64, and X is more polar than Y.', false, '0.64 is the Rf of spot Y, which was used in place of X.' from version_ins;
-- apchem-mcq-b2-sv-h-3.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.9-a-v1', 'mcq', 'Rf from origin-line measurements and polarity comparison (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A thin-layer plate has a nonpolar stationary phase and a polar solvent. The starting line is 2.0 cm above the bottom edge. After the run, spot P is at 5.0 cm, spot Q is at 8.0 cm, and the solvent front is at 10.0 cm above the bottom edge. Which statement is correct?', null, md5('apchem-mcq-b2-sv-h-3.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The Rf of P is 0.38, and P is less polar than Q.', true, 'Correct: Rf(P) = (5.0 - 2.0)/(10.0 - 2.0) = 0.375; Rf(Q) = 0.75; with a nonpolar stationary phase and polar solvent, the more polar compound travels farther, so P (less travel) is less polar.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The Rf of P is 0.50, and P is less polar than Q.', false, '0.50 divides the height above the bottom edge instead of the distance from the starting line.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The Rf of P is 0.38, and P is more polar than Q.', false, 'The rule from polar paper was applied, but with a nonpolar stationary phase the polar compound travels farther.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The Rf of P is 0.75, and P is less polar than Q.', false, '0.75 is the Rf of spot Q, used in place of P.' from version_ins;
-- apchem-mcq-b2-sv-h-3.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.9-a-v2', 'mcq', 'Rf from origin-line measurements and polarity comparison (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A silica (polar) TLC plate is developed with a nonpolar solvent. The starting line is 1.0 cm above the bottom edge and the solvent front is at 7.0 cm. The spots are at 3.0 cm (compound A), 5.5 cm (compound B) and 2.5 cm (compound C). Which choice lists the compounds from least polar to most polar and gives the Rf of A?', null, md5('apchem-mcq-b2-sv-h-3.9-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'C, A, B; Rf of A = 0.33', false, 'The order is reversed, since on polar silica the most polar compound (C) moves the least.' from version_ins
union all select gen_random_uuid(), id, 'B', 'B, A, C; Rf of A = 0.43', false, 'Rf = 0.43 divides the spot height above the bottom edge (3.0 cm) by the 7.0 cm front distance, mixing the two measurement bases.' from version_ins
union all select gen_random_uuid(), id, 'C', 'B, A, C; Rf of A = 0.33', true, 'Correct: Rf(A) = (3.0 - 1.0)/(7.0 - 1.0) = 0.33; Rf(B) = 0.75 and Rf(C) = 0.25; on polar silica the compound that travels farthest is least polar, so the order is B, A, C.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C, A, B; Rf of A = 0.43', false, 'Both the order and the distance were wrong, because the most polar compound moves least and the starting line was ignored.' from version_ins;
-- apchem-mcq-b2-sv-h-3.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.9-a-v3', 'mcq', 'Rf from origin-line measurements and polarity comparison (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Dye Z is polar. On polar paper the starting line is 1.5 cm above the bottom edge, the dye spot is at 5.0 cm and the solvent front is at 9.0 cm after a run with a mostly nonpolar solvent. A second run uses a more polar solvent mixture. Which choice gives the Rf in the first run and the expected change in the second run?', null, md5('apchem-mcq-b2-sv-h-3.9-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Rf = 0.56; the Rf increases.', false, '0.56 divides by the height above the bottom edge rather than the distance from the starting line.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Rf = 0.56; the Rf decreases.', false, 'Both the Rf value and the direction are wrong, since the more polar solvent helps the polar dye move.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Rf = 0.47; the Rf decreases.', false, 'The Rf is right, but a more polar solvent would not hold a polar dye back; it carries the dye farther.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Rf = 0.47; the Rf increases.', true, 'Correct: Rf = (5.0 - 1.5)/(9.0 - 1.5) = 3.5/7.5 = 0.47; a more polar solvent dissolves the polar dye better and competes with the polar paper for it, so the dye moves farther.' from version_ins;
-- apchem-mcq-b2-h-3.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.9-b', 'mcq', 'order of elution or separation sequence from intermolecular forces', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mixture is loaded on a column packed with polar silica, and nonpolar hexane is passed through. Compound 1 is a hydrocarbon, compound 2 is a ketone (C=O, no O-H group) and compound 3 is an alcohol (O-H group, forms hydrogen bonds). Which choice gives the order in which the compounds leave the column and a way to speed up the slowest one?', null, md5('apchem-mcq-b2-h-3.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1, then 2, then 3; adding a more polar solvent such as ethanol to the mobile phase would speed up compound 3.', true, 'Correct: the polar silica holds the most polar compound longest; the hydrocarbon is not retained and elutes first, the ketone next, the alcohol last; a more polar mobile phase competes with the alcohol for the silica.' from version_ins
union all select gen_random_uuid(), id, 'B', '3, then 2, then 1; adding a more polar solvent such as ethanol would speed up compound 1.', false, 'The order is reversed, since the compound with the strongest attraction to the polar silica (the alcohol) is held longest.' from version_ins
union all select gen_random_uuid(), id, 'C', '1, then 2, then 3; making the mobile phase even less polar would speed up compound 3.', false, 'A less polar solvent competes even less with the polar silica for compound 3, so it would slow compound 3 further.' from version_ins
union all select gen_random_uuid(), id, 'D', '2, then 1, then 3; adding a more polar solvent would speed up compound 3.', false, 'The hydrocarbon has no polar groups to bind to silica, so it is not retained any longer than the ketone.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-h-3.8-b','apchem-mcq-b2-sv-h-3.8-b-v1','apchem-mcq-b2-sv-h-3.8-b-v2','apchem-mcq-b2-sv-h-3.8-b-v3','apchem-mcq-b2-h-3.9-a','apchem-mcq-b2-sv-h-3.9-a-v1','apchem-mcq-b2-sv-h-3.9-a-v2','apchem-mcq-b2-sv-h-3.9-a-v3','apchem-mcq-b2-h-3.9-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-h-3.8-b','apchem-mcq-b2-sv-h-3.8-b-v1','apchem-mcq-b2-sv-h-3.8-b-v2','apchem-mcq-b2-sv-h-3.8-b-v3','apchem-mcq-b2-h-3.9-a','apchem-mcq-b2-sv-h-3.9-a-v1','apchem-mcq-b2-sv-h-3.9-a-v2','apchem-mcq-b2-sv-h-3.9-a-v3','apchem-mcq-b2-h-3.9-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
