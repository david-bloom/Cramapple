begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.7-b-v2','apchem-mcq-b6-sv-h-1.7-b-v3','apchem-mcq-b6-h-1.8-a','apchem-mcq-b6-sv-h-1.8-a-v1','apchem-mcq-b6-sv-h-1.8-a-v2','apchem-mcq-b6-sv-h-1.8-a-v3','apchem-mcq-b6-h-1.8-b','apchem-mcq-b6-sv-h-1.8-b-v1','apchem-mcq-b6-sv-h-1.8-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apchem-mcq-b6-sv-h-1.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.7-b-v2', 'mcq', 'order the radii of isoelectronic ions by using nuclear charge with a fixed electron count, resisting the trends for neut (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider P³⁻, S²⁻, Cl⁻ and Ar, which all have 18 electrons. Which list gives them in order of increasing radius, with the correct reason?', null, md5('apchem-mcq-b6-sv-h-1.7-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P³⁻ < S²⁻ < Cl⁻ < Ar, because atomic radius decreases from left to right across a period.', false, 'This follows the trend for neutral atoms; here all four have 18 electrons, so the one with the fewest protons, P³⁻ (+15), has the largest radius.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ar < Cl⁻ < S²⁻ < P³⁻, because each has the same number of electrons, so the species with the most protons holds them most tightly.', true, 'Correct: All have 18 electrons; nuclear charges are +18 (Ar), +17, +16 and +15, so radius increases Ar < Cl⁻ < S²⁻ < P³⁻.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ar < P³⁻ < S²⁻ < Cl⁻, because a noble gas has a complete outer shell and so is the smallest and the more negative the ion the larger.', false, 'The first part is right but the order of the anions is wrong: with 18 electrons, the ion with the fewest protons is largest, so P³⁻ is the largest, not Cl⁻.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cl⁻ < S²⁻ < P³⁻ < Ar, because neutral atoms have extra electron repulsion that makes them largest.', false, 'Ar has the highest nuclear charge (+18) of the four holding the same 18 electrons, so it is the smallest, not the largest.' from version_ins;
-- apchem-mcq-b6-sv-h-1.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.7-b-v3', 'mcq', 'order the radii of isoelectronic ions by using nuclear charge with a fixed electron count, resisting the trends for neut (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Consider N³⁻, O²⁻, F⁻ and Al³⁺, which all have 10 electrons. Which list gives them in order of decreasing radius, with the correct reason?', null, md5('apchem-mcq-b6-sv-h-1.7-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'N³⁻ > O²⁻ > F⁻ > Al³⁺, because each has the same number of electrons, so the ion with the fewest protons holds them least tightly.', true, 'Correct: All have 10 electrons; nuclear charges are +7, +8, +9 and +13, so radius decreases N³⁻ > O²⁻ > F⁻ > Al³⁺.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Al³⁺ > N³⁻ > O²⁻ > F⁻, because aluminum is the heaviest atom of the four and has the most shells.', false, 'Atomic mass is not the determining factor, and Al³⁺ has lost its n = 3 shell; with 13 protons holding 10 electrons it is the smallest ion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Al³⁺ > F⁻ > O²⁻ > N³⁻, because more protons give a larger ion.', false, 'More protons pull the electrons in more strongly, so Al³⁺ is the smallest and N³⁻ is the largest of the four.' from version_ins
union all select gen_random_uuid(), id, 'D', 'O²⁻ > N³⁻ > F⁻ > Al³⁺, because the ion with the largest charge magnitude is largest only when it is an anion.', false, 'N³⁻ has the largest charge magnitude among the anions, but within the series radius follows the proton count only, so N³⁻ with seven protons is the largest.' from version_ins;
-- apchem-mcq-b6-h-1.8-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.8-a', 'mcq', 'rank the lattice energies of ionic compounds by weighing both ion charges and ion sizes in Coulomb''s law, rather than re', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Lattice energy is proportional to (q₁ × q₂)/d, where d is the distance between ion centers (the sum of the ionic radii). Ionic radii (pm): Li⁺ 76, Na⁺ 102, Mg²⁺ 72, Ca²⁺ 100, F⁻ 133, Cl⁻ 181, O²⁻ 140, S²⁻ 184. Which list shows the compounds in order of increasing lattice energy (weakest first)?', null, md5('apchem-mcq-b6-h-1.8-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CaS < NaCl < MgO < LiF', false, 'This ranks by interionic distance alone (284, 283, 212, 209 pm), ignoring that charges of 2+ and 2− give four times the attraction of 1+ and 1−.' from version_ins
union all select gen_random_uuid(), id, 'B', 'LiF < NaCl < MgO < CaS', false, 'This gets the charge groups right but puts the larger-ion compound as the stronger in each pair; for the same charges, the smaller distance gives the greater lattice energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'NaCl < LiF < CaS < MgO', true, 'Correct: q₁q₂/d: NaCl 1/283 = 0.0035; LiF 1/209 = 0.0048; CaS 4/284 = 0.0141; MgO 4/212 = 0.0189.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NaCl < LiF < MgO < CaS', false, 'This orders the singly charged pair correctly, but in the doubly charged pair MgO (212 pm) has a smaller distance than CaS (284 pm), so MgO has the greater lattice energy.' from version_ins;
-- apchem-mcq-b6-sv-h-1.8-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.8-a-v1', 'mcq', 'rank the lattice energies of ionic compounds by weighing both ion charges and ion sizes in Coulomb''s law, rather than re (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Lattice energy is proportional to (q₁ × q₂)/d, where d is the distance between ion centers (the sum of the ionic radii). Ionic radii (pm): Na⁺ 102, K⁺ 138, Sr²⁺ 118, Ba²⁺ 135, F⁻ 133, Cl⁻ 181, O²⁻ 140. Which list shows the compounds in order of increasing lattice energy (weakest first)?', null, md5('apchem-mcq-b6-sv-h-1.8-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'KCl < NaF < BaO < SrO', true, 'Correct: q₁q₂/d: KCl 1/319 = 0.0031; NaF 1/235 = 0.0043; BaO 4/275 = 0.0145; SrO 4/258 = 0.0155.' from version_ins
union all select gen_random_uuid(), id, 'B', 'KCl < BaO < SrO < NaF', false, 'This ranks by distance alone (319, 275, 258, 235 pm), ignoring that the 2+ and 2− charges of BaO and SrO give four times the attraction of the singly charged compounds.' from version_ins
union all select gen_random_uuid(), id, 'C', 'NaF < KCl < SrO < BaO', false, 'This reverses both pairs, treating a larger distance as a stronger attraction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'KCl < NaF < SrO < BaO', false, 'This ranks the singly charged pair correctly but reverses the pair of oxides: SrO (258 pm) has a shorter distance than BaO (275 pm), so SrO has the greater lattice energy.' from version_ins;
-- apchem-mcq-b6-sv-h-1.8-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.8-a-v2', 'mcq', 'rank the lattice energies of ionic compounds by weighing both ion charges and ion sizes in Coulomb''s law, rather than re (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Lattice energy is proportional to (q₁ × q₂)/d, where d is the distance between ion centers (the sum of the ionic radii). Ionic radii (pm): Na⁺ 102, Mg²⁺ 72, Ca²⁺ 100, Cl⁻ 181, F⁻ 133, O²⁻ 140. Which list shows the compounds NaCl, Na₂O, MgF₂ and CaO in order of increasing lattice energy (weakest first)?', null, md5('apchem-mcq-b6-sv-h-1.8-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NaCl < Na₂O < CaO < MgF₂', false, 'This ranks by distance alone (283, 242, 240, 205 pm), ignoring that the ions in CaO have charges 2+ and 2− while those in MgF₂ have 2+ and 1−.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NaCl < MgF₂ < Na₂O < CaO', false, 'This orders Na₂O and MgF₂ wrongly; they have the same charge product (2), so the smaller distance in MgF₂ (205 pm versus 242 pm) gives the greater lattice energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'NaCl < Na₂O < MgF₂ < CaO', true, 'Correct: q₁q₂/d: NaCl 1/283 = 0.0035; Na₂O 2/242 = 0.0083; MgF₂ 2/205 = 0.0098; CaO 4/240 = 0.0167.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Na₂O < NaCl < MgF₂ < CaO', false, 'This ranks Na₂O below NaCl; Na₂O has a charge product of 2 compared with 1 for NaCl and a smaller distance, so it has the greater lattice energy.' from version_ins;
-- apchem-mcq-b6-sv-h-1.8-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.8-a-v3', 'mcq', 'rank the lattice energies of ionic compounds by weighing both ion charges and ion sizes in Coulomb''s law, rather than re (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Lattice energy is proportional to (q₁ × q₂)/d, where d is the distance between ion centers (the sum of the ionic radii). Ionic radii (pm): Na⁺ 102, Mg²⁺ 72, Ca²⁺ 100, Rb⁺ 152, Cl⁻ 181, Br⁻ 196, S²⁻ 184, Se²⁻ 198. Which list shows the compounds RbBr, NaCl, CaSe and MgS in order of increasing lattice energy (weakest first)?', null, md5('apchem-mcq-b6-sv-h-1.8-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'RbBr < CaSe < NaCl < MgS', false, 'This ranks by distance alone (348, 298, 283, 256 pm), ignoring that CaSe has charges of 2+ and 2− and so four times the charge product of NaCl.' from version_ins
union all select gen_random_uuid(), id, 'B', 'RbBr < NaCl < CaSe < MgS', true, 'Correct: q₁q₂/d: RbBr 1/348 = 0.0029; NaCl 1/283 = 0.0035; CaSe 4/298 = 0.0134; MgS 4/256 = 0.0156.' from version_ins
union all select gen_random_uuid(), id, 'C', 'MgS < CaSe < NaCl < RbBr', false, 'This reverses the whole order, treating a larger distance as giving a stronger attraction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NaCl < RbBr < MgS < CaSe', false, 'This wrongly places RbBr above NaCl and CaSe above MgS; for equal charges the smaller distance gives the larger lattice energy, so NaCl (283 pm) exceeds RbBr (348 pm).' from version_ins;
-- apchem-mcq-b6-h-1.8-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-h-1.8-b', 'mcq', 'combine electron transfer, ionic charges and formula ratios to count ions and transferred electrons in a sample.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of calcium nitride, Ca₃N₂, contains 6.02 × 10²² nitride ions, N³⁻. Which row correctly gives the number of Ca²⁺ ions in the sample and the total number of electrons transferred from calcium atoms to nitrogen atoms when the sample formed?', null, md5('apchem-mcq-b6-h-1.8-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.01 × 10²² Ca²⁺ ions; 8.03 × 10²² electrons.', false, 'This inverts the ratio: the formula Ca₃N₂ has three Ca²⁺ for every two N³⁻, so there are 1.5 times as many Ca²⁺ ions as N³⁻ ions.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.03 × 10²² Ca²⁺ ions; 9.03 × 10²² electrons.', false, 'This counts only one electron per calcium ion; each Ca atom loses two electrons to become Ca²⁺.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.03 × 10²² Ca²⁺ ions; 2.71 × 10²³ electrons.', false, 'This gives each Ca atom three electrons, using the charge of the nitride ion; each Ca atom loses only two.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.03 × 10²² Ca²⁺ ions; 1.81 × 10²³ electrons.', true, 'Correct: Ca²⁺ = 6.02 × 10²² × 3/2 = 9.03 × 10²²; electrons = 2 × 9.03 × 10²² = 1.81 × 10²³ (equals 3 × 6.02 × 10²² gained by N).' from version_ins;
-- apchem-mcq-b6-sv-h-1.8-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.8-b-v1', 'mcq', 'combine electron transfer, ionic charges and formula ratios to count ions and transferred electrons in a sample. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of aluminum oxide, Al₂O₃, contains 1.204 × 10²³ Al³⁺ ions. Which row correctly gives the number of oxide ions, O²⁻, in the sample and the total number of electrons transferred from aluminum atoms to oxygen atoms when the sample formed?', null, md5('apchem-mcq-b6-sv-h-1.8-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8.03 × 10²² O²⁻ ions; 1.61 × 10²³ electrons.', false, 'This inverts the ratio: Al₂O₃ has three O²⁻ for every two Al³⁺, so there are 1.5 times as many O²⁻ ions as Al³⁺ ions.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.81 × 10²³ O²⁻ ions; 3.61 × 10²³ electrons.', true, 'Correct: O²⁻ = 1.204 × 10²³ × 3/2 = 1.81 × 10²³; electrons = 3 × 1.204 × 10²³ = 3.61 × 10²³ (equals 2 × 1.81 × 10²³ gained by O).' from version_ins
union all select gen_random_uuid(), id, 'C', '1.81 × 10²³ O²⁻ ions; 1.81 × 10²³ electrons.', false, 'This counts one electron per oxide ion; each O atom gains two electrons to become O²⁻.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.81 × 10²³ O²⁻ ions; 2.41 × 10²³ electrons.', false, 'This gives each Al atom two electrons, using the charge of the oxide ion; each Al atom loses three.' from version_ins;
-- apchem-mcq-b6-sv-h-1.8-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b6-sv-h-1.8-b-v2', 'mcq', 'combine electron transfer, ionic charges and formula ratios to count ions and transferred electrons in a sample. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of magnesium nitride, Mg₃N₂, contains 1.505 × 10²⁴ ions in total (Mg²⁺ and N³⁻ together). Which row correctly gives the number of Mg²⁺ ions in the sample and the total number of electrons transferred from magnesium atoms to nitrogen atoms when the sample formed?', null, md5('apchem-mcq-b6-sv-h-1.8-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.53 × 10²³ Mg²⁺ ions; 1.51 × 10²⁴ electrons.', false, 'This assumes half of the ions are Mg²⁺; the formula Mg₃N₂ has five ions per formula unit, three of them Mg²⁺.' from version_ins
union all select gen_random_uuid(), id, 'B', '9.03 × 10²³ Mg²⁺ ions; 1.81 × 10²⁴ electrons.', true, 'Correct: Mg²⁺ = 1.505 × 10²⁴ × 3/5 = 9.03 × 10²³; electrons = 2 × 9.03 × 10²³ = 1.81 × 10²⁴.' from version_ins
union all select gen_random_uuid(), id, 'C', '6.02 × 10²³ Mg²⁺ ions; 1.81 × 10²⁴ electrons.', false, 'This uses 2/5 of the ions as Mg²⁺, which is the fraction of nitride ions; the Mg²⁺ ions make up 3/5.' from version_ins
union all select gen_random_uuid(), id, 'D', '9.03 × 10²³ Mg²⁺ ions; 9.03 × 10²³ electrons.', false, 'This counts only one electron per magnesium ion; each Mg atom loses two electrons to become Mg²⁺.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b6-sv-h-1.7-b-v2','apchem-mcq-b6-sv-h-1.7-b-v3','apchem-mcq-b6-h-1.8-a','apchem-mcq-b6-sv-h-1.8-a-v1','apchem-mcq-b6-sv-h-1.8-a-v2','apchem-mcq-b6-sv-h-1.8-a-v3','apchem-mcq-b6-h-1.8-b','apchem-mcq-b6-sv-h-1.8-b-v1','apchem-mcq-b6-sv-h-1.8-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b6-sv-h-1.7-b-v2','apchem-mcq-b6-sv-h-1.7-b-v3','apchem-mcq-b6-h-1.8-a','apchem-mcq-b6-sv-h-1.8-a-v1','apchem-mcq-b6-sv-h-1.8-a-v2','apchem-mcq-b6-sv-h-1.8-a-v3','apchem-mcq-b6-h-1.8-b','apchem-mcq-b6-sv-h-1.8-b-v1','apchem-mcq-b6-sv-h-1.8-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
