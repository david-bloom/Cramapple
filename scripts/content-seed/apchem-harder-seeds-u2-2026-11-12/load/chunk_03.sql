begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.3-a-v2','apchem-mcq-b5-sv-h-2.3-a-v3','apchem-mcq-b5-h-2.3-b','apchem-mcq-b5-sv-h-2.3-b-v1','apchem-mcq-b5-sv-h-2.3-b-v2','apchem-mcq-b5-sv-h-2.3-b-v3','apchem-mcq-b5-h-2.4-a','apchem-mcq-b5-sv-h-2.4-a-v1','apchem-mcq-b5-sv-h-2.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apchem-mcq-b5-sv-h-2.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.3-a-v2', 'mcq', 'apply Coulomb''s law quantitatively, using ion charges and the sum of ionic radii, to compare the strength of ionic attra (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate ionic radii (pm): Al³⁺ 54, O²⁻ 140, K⁺ 138, Br⁻ 196. Treat the distance between neighboring ions as the sum of the ionic radii. The magnitude of the electrostatic potential energy of a cation-anion pair is proportional to (charge of cation × charge of anion) ÷ distance. About how many times larger is this magnitude for a neighboring Al³⁺ and O²⁻ pair in Al₂O₃ than for a neighboring K⁺ and Br⁻ pair in KBr?', null, md5('apchem-mcq-b5-sv-h-2.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 6.0 times, because the charge product is 6 times larger.', false, 'It leaves out the distance, but the ions in Al₂O₃ are much closer, 194 pm against 334 pm, which raises the ratio well above 6.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 17.8 times larger.', false, 'This is the force ratio, 6 × (334/194)², since force depends on 1/d² while potential energy depends on 1/d.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 2.5 times, because the charges in Al₂O₃ add to 5 and those in KBr add to 2.', false, 'Energy depends on the product of the charges, 3 × 2 against 1 × 1, and not on their sum.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 10.3 times larger.', true, 'Correct: Al₂O₃ distance = 54 + 140 = 194 pm, so 6/194 = 0.03093. KBr distance = 138 + 196 = 334 pm, so 1/334 = 0.002994. Ratio = 10.33.' from version_ins;
-- apchem-mcq-b5-sv-h-2.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.3-a-v3', 'mcq', 'apply Coulomb''s law quantitatively, using ion charges and the sum of ionic radii, to compare the strength of ionic attra (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate ionic radii (pm): Ba²⁺ 135, O²⁻ 140, Cs⁺ 167, I⁻ 220. Treat the distance between neighboring ions as the sum of the ionic radii. The magnitude of the electrostatic potential energy of a cation-anion pair is proportional to (charge of cation × charge of anion) ÷ distance. About how many times larger is this magnitude for a neighboring Ba²⁺ and O²⁻ pair in BaO than for a neighboring Cs⁺ and I⁻ pair in CsI?', null, md5('apchem-mcq-b5-sv-h-2.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 7.9 times larger.', false, 'This is the force ratio, 4 × (387/275)², which treats the force law as the energy law.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 5.6 times larger.', true, 'Correct: BaO distance = 135 + 140 = 275 pm, so 4/275 = 0.01455. CsI distance = 167 + 220 = 387 pm, so 1/387 = 0.002584. Ratio = 5.63.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 2.0 times, because the charges in BaO add to 4 and those in CsI add to 2.', false, 'Potential energy depends on the product of the charges, 4 against 1, and not on their sum, and the distance also differs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 4.0 times, because the ion sizes do not change the result.', false, 'It ignores the distance, but the ions in CsI are far apart at 387 pm against 275 pm in BaO, so the ratio exceeds 4.' from version_ins;
-- apchem-mcq-b5-h-2.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.3-b', 'mcq', 'explain electrical conductivity data for an ionic compound in terms of mobile charged particles in the lattice, liquid a', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student tests the electrical conductivity of sodium chloride in three forms and records the results.
Solid NaCl crystals: no current
Molten NaCl at 801°C: large current
NaCl dissolved in water: large current
Which explanation is consistent with all three results?', null, md5('apchem-mcq-b5-h-2.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'In the solid, the ions are present but cannot carry charge; when NaCl melts, its ions are converted to Na and Cl atoms that share delocalized electrons.', false, 'Ions do not convert to atoms with delocalized electrons on melting, since the liquid still consists of Na⁺ and Cl⁻ ions, and this describes metallic bonding.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ions are held in fixed positions by strong attractions in the solid and cannot move; melting or dissolving frees them, and the mobile ions carry the current.', true, 'Correct: conduction needs mobile charge carriers. Na⁺ and Cl⁻ are present in the solid but fixed in the lattice; in the liquid or solution they can move.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ionic bonds exist only in solution, so the solid contains neutral atoms and the ions form only when the compound melts or dissolves.', false, 'The solid is already made of Na⁺ and Cl⁻ ions in a lattice, so ions do not form only on melting or dissolving.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The electrons in solid NaCl are held tightly by chloride ions, and heating or dissolving the solid lets those electrons move freely as the current.', false, 'The current in molten or dissolved NaCl is carried by moving ions, not by free electrons, and the electrons stay on their ions.' from version_ins;
-- apchem-mcq-b5-sv-h-2.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.3-b-v1', 'mcq', 'explain electrical conductivity data for an ionic compound in terms of mobile charged particles in the lattice, liquid a (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student measures the conductivity of calcium chloride, CaCl₂, in three forms and records the results.
Solid CaCl₂: no current
Molten CaCl₂ at 772°C: large current
CaCl₂ dissolved in water: large current
Which explanation is consistent with all three results?', null, md5('apchem-mcq-b5-sv-h-2.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'In the solid, the Ca²⁺ and Cl⁻ ions are locked in lattice positions and cannot move; as a liquid or in solution they can move, and the moving ions carry the charge.', true, 'Correct: conductivity requires mobile charged particles; the ions are fixed in the solid and free to move in the liquid and in solution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Melting transforms the CaCl₂ lattice into a metal, and the delocalized electrons of the metal carry the current.', false, 'Molten CaCl₂ is a liquid of Ca²⁺ and Cl⁻ ions and does not become a metal, so there is no sea of electrons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ca²⁺ and Cl⁻ ions exist only after the solid is dissolved or melted, when the solid separates into neutral atoms.', false, 'The solid already consists of Ca²⁺ and Cl⁻ ions, and dissolving or melting only frees them to move.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The current in the liquid and solution is carried by electrons that are released as the ionic bonds break.', false, 'The electrons stay with the chloride and calcium ions, and the charge is carried by the ions themselves.' from version_ins;
-- apchem-mcq-b5-sv-h-2.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.3-b-v2', 'mcq', 'explain electrical conductivity data for an ionic compound in terms of mobile charged particles in the lattice, liquid a (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student measures electrical conductivity of three samples.
Copper metal, solid: large current
Potassium bromide, KBr, solid: no current
Potassium bromide, KBr, molten at 734°C: large current
Which statement about the charge carriers in these samples is consistent with all three results?', null, md5('apchem-mcq-b5-sv-h-2.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'In solid KBr the electrons are delocalized, as in copper, but they are blocked by the potassium ions until the KBr melts.', false, 'Ionic solids do not have delocalized electrons, and the nonconduction of solid KBr is due to ions being fixed in the lattice.' from version_ins
union all select gen_random_uuid(), id, 'B', 'In copper the current is carried by mobile electrons, in molten KBr by mobile ions, and in solid KBr neither electrons nor ions are free to move.', true, 'Correct: copper conducts through delocalized electrons, molten KBr conducts through mobile K⁺ and Br⁻ ions, and solid KBr has ions fixed in a lattice with localized electrons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'In copper and in molten KBr the current is carried by moving ions, but solid KBr contains no ions.', false, 'The metal conducts through delocalized electrons, not ions, and solid KBr does contain K⁺ and Br⁻ ions that are simply fixed in place.' from version_ins
union all select gen_random_uuid(), id, 'D', 'In all three samples the current is carried by electrons, but solid KBr has too few electrons to carry a current.', false, 'Molten KBr conducts through ions and not electrons, and the number of electrons in solid KBr is not the reason for its nonconduction.' from version_ins;
-- apchem-mcq-b5-sv-h-2.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.3-b-v3', 'mcq', 'explain electrical conductivity data for an ionic compound in terms of mobile charged particles in the lattice, liquid a (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student compares two solutions, each prepared by dissolving 0.10 mol of a solid in 1.0 L of water.
Sodium chloride solution: large current
Sucrose, C₁₂H₂₂O₁₁, solution: almost no current
Which statement best explains this difference?', null, md5('apchem-mcq-b5-sv-h-2.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sodium chloride solid is held together by hydrogen bonds, which make its solution conduct, whereas sucrose has no hydrogen bonds.', false, 'Sodium chloride is held together by attractions between ions and not by hydrogen bonds, and sucrose actually forms hydrogen bonds with water.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sucrose molecules are too large to move through water, but sodium chloride particles are small enough to carry charge.', false, 'The size of the particles does not determine conductivity, and the sucrose molecules do move through water but carry no charge.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sodium chloride separates into mobile Na⁺ and Cl⁻ ions that carry charge, whereas sucrose dissolves as neutral molecules that carry no net charge.', true, 'Correct: NaCl(s) → Na⁺(aq) + Cl⁻(aq) gives charged carriers; sucrose dissolves without ionizing, so the particles are neutral.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sodium chloride releases free electrons into the water, whereas sucrose keeps all of its electrons.', false, 'Conduction in solution is carried by ions and not by free electrons, which are not released when NaCl dissolves.' from version_ins;
-- apchem-mcq-b5-h-2.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.4-a', 'mcq', 'use atomic radii to identify the type of alloy and explain the change in hardness at the particle level', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure metal M (atomic radius 150 pm) is soft and very malleable. A small amount of element Z (atomic radius 62 pm) is mixed into molten M, and the cooled alloy is harder and less malleable than pure M. Which particle-level explanation best accounts for this change?', null, md5('apchem-mcq-b5-h-2.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Atoms of Z take the places of atoms of M in the lattice, and because they are slightly different in size they bond covalently with M atoms.', false, 'Substitutional alloys form when the atoms have similar radii, but Z is far smaller than M, so it cannot replace an M atom in the lattice.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Atoms of Z fit into the spaces between M atoms and interfere with the sliding of layers of M atoms past one another.', true, 'Correct: radii differ by more than about 15 percent (62 vs 150 pm), so Z is small enough to occupy interstitial sites between the M atoms. These interstitial atoms block layers from sliding, which raises hardness and lowers malleability.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Atoms of Z remove delocalized electrons from M atoms, so the alloy is held together by ionic bonds.', false, 'The alloy remains metallic, with delocalized electrons shared among the atoms, and Z does not remove electrons to form an ionic compound.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Atoms of Z are much smaller than M atoms, so they pack the lattice more loosely, letting layers of M slide more easily.', false, 'Small atoms in the interstices fill space between M atoms and make sliding harder, not easier.' from version_ins;
-- apchem-mcq-b5-sv-h-2.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.4-a-v1', 'mcq', 'use atomic radii to identify the type of alloy and explain the change in hardness at the particle level (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure metal J (atomic radius 128 pm) is soft and malleable. It is melted with a metal L (atomic radius 134 pm) in a 7:3 ratio, and the cooled alloy is harder than pure J while still conducting electricity well. Which particle-level explanation best accounts for these observations?', null, md5('apchem-mcq-b5-sv-h-2.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Atoms of L fit into the empty spaces between J atoms, which blocks layers from sliding and removes the delocalized electrons.', false, 'Interstitial sites are filled by much smaller atoms, and L at 134 pm is slightly larger than J, so it cannot fit into the gaps, and delocalized electrons are not removed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Atoms of L and J form ionic bonds, and the ionic lattice is rigid, which explains the hardness.', false, 'Two metals do not transfer electrons to form ions, so the alloy is held together by metallic bonding.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Atoms of L are nearly the same size as J atoms, so the alloy has exactly the same hardness as pure J.', false, 'Similar size makes a substitutional alloy possible, but the small mismatch distorts the layers and measurably increases hardness, as in brass.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Atoms of L replace some J atoms in the lattice; their slightly different size distorts the regular layers and makes sliding more difficult, while the delocalized electrons still conduct.', true, 'Correct: radii of 128 and 134 pm differ by about 5 percent, so L replaces J in the lattice (substitutional alloy), and the shared delocalized electrons still conduct.' from version_ins;
-- apchem-mcq-b5-sv-h-2.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.4-a-v2', 'mcq', 'use atomic radii to identify the type of alloy and explain the change in hardness at the particle level (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure metal T (atomic radius 140 pm) is melted with a small amount of element N (atomic radius 55 pm). The resulting alloy is harder than pure T and shows less malleability. Which particle-level explanation best accounts for these observations?', null, md5('apchem-mcq-b5-sv-h-2.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Atoms of N are small enough to sit in the gaps between T atoms, and these interstitial atoms hinder layers of T atoms from sliding past each other.', true, 'Correct: a radius of 55 pm is much smaller than 140 pm, so N occupies interstitial sites; blocking of layer sliding raises hardness.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Atoms of N replace atoms of T in the lattice, and their equal charge keeps the layers aligned.', false, 'N is far too small to replace T atoms in a metal lattice, and a substitutional alloy needs similar radii.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Atoms of N bond to T atoms through hydrogen bonds, which make the alloy harder.', false, 'Hydrogen bonds are intermolecular attractions between molecules and are not the explanation for hardness in a metallic alloy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Atoms of N make the T atoms smaller, so the whole lattice contracts and becomes brittle like an ionic solid.', false, 'The T atoms keep their size, and the alloy is held together by metallic bonding, not ionic bonding.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.3-a-v2','apchem-mcq-b5-sv-h-2.3-a-v3','apchem-mcq-b5-h-2.3-b','apchem-mcq-b5-sv-h-2.3-b-v1','apchem-mcq-b5-sv-h-2.3-b-v2','apchem-mcq-b5-sv-h-2.3-b-v3','apchem-mcq-b5-h-2.4-a','apchem-mcq-b5-sv-h-2.4-a-v1','apchem-mcq-b5-sv-h-2.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-sv-h-2.3-a-v2','apchem-mcq-b5-sv-h-2.3-a-v3','apchem-mcq-b5-h-2.3-b','apchem-mcq-b5-sv-h-2.3-b-v1','apchem-mcq-b5-sv-h-2.3-b-v2','apchem-mcq-b5-sv-h-2.3-b-v3','apchem-mcq-b5-h-2.4-a','apchem-mcq-b5-sv-h-2.4-a-v1','apchem-mcq-b5-sv-h-2.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
