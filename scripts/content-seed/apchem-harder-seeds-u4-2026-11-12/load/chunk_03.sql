begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.3-a-v2','apchem-mcq-b4-sv-h-4.3-a-v3','apchem-mcq-b4-h-4.3-b','apchem-mcq-b4-sv-h-4.3-b-v1','apchem-mcq-b4-sv-h-4.3-b-v2','apchem-mcq-b4-sv-h-4.3-b-v3','apchem-mcq-b4-h-4.4-a','apchem-mcq-b4-sv-h-4.4-a-v1','apchem-mcq-b4-sv-h-4.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apchem-mcq-b4-sv-h-4.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.3-a-v2', 'mcq', 'draw the product mixture from a particle count using the mole ratio and conservation of atoms (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle drawing of the reactant mixture shows 3 CH4 molecules and 4 O2 molecules in a sealed container. The reaction CH4 + 2 O2 → CO2 + 2 H2O then goes to completion. Which description of the final mixture is correct?', null, md5('apchem-mcq-b4-sv-h-4.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2 CO2 molecules, 4 H2O molecules and 1 CH4 molecule', true, 'Correct: 4 O2 reacts with 2 CH4, giving 2 CO2 and 4 H2O, leaving 1 CH4. Atoms: C = 2 + 1 = 3; H = 8 + 4 = 12; O = 4 + 4 = 8.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 CO2 molecules and 6 H2O molecules', false, '3 CO2 and 6 H2O would need 12 O atoms, but only 8 are present because O2 is limiting.' from version_ins
union all select gen_random_uuid(), id, 'C', '2 CO2 molecules, 4 H2O molecules and 2 CH4 molecules', false, '2 CH4 left over would give 4 carbon atoms in total, but only 3 were present.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 CO2 molecules, 2 H2O molecules and 1 CH4 molecule', false, '2 H2O gives only 8 H atoms in total, but 12 were present, so hydrogen is not conserved.' from version_ins;
-- apchem-mcq-b4-sv-h-4.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.3-a-v3', 'mcq', 'draw the product mixture from a particle count using the mole ratio and conservation of atoms (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle drawing of the reactant mixture shows 6 SO2 molecules and 5 O2 molecules in a sealed container. The reaction 2 SO2 + O2 → 2 SO3 then goes to completion. Which description of the final mixture is correct?', null, md5('apchem-mcq-b4-sv-h-4.3-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '6 SO3 molecules and no other molecules', false, 'This treats all the O2 as used up, but SO2 is the limiting reactant and 2 O2 remain.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 SO3 molecules and 4 O2 molecules', false, '6 SO3 and 4 O2 contain 26 O atoms, but only 22 were present.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 SO3 molecules and 5 O2 molecules', false, '6 SO3 and 5 O2 would mean no O2 was consumed, but 6 SO3 contain O atoms that came from it, giving 28 O atoms instead of 22.' from version_ins
union all select gen_random_uuid(), id, 'D', '6 SO3 molecules and 2 O2 molecules', true, 'Correct: 6 SO2 needs 3 O2 and makes 6 SO3, leaving 5 - 3 = 2 O2. Oxygen atoms: 18 + 4 = 22 = 12 + 10.' from version_ins;
-- apchem-mcq-b4-h-4.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.3-b', 'mcq', 'decide which quantities are conserved in a particle-level representation of a reaction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sealed, rigid container holds 4 H2 molecules and 2 O2 molecules. They react completely according to 2 H2 + O2 → 2 H2O. Which statement correctly compares the contents before and after the reaction?', null, md5('apchem-mcq-b4-h-4.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The total number of molecules and the total mass are the same, but the number of atoms changes.', false, 'The number of molecules is not conserved, since 6 molecules form 4, and atoms are conserved instead.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The total number of molecules and the total number of atoms are the same, but the total mass changes.', false, 'Mass is conserved because the number of each kind of atom is conserved, so mass does not change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The number of molecules, the number of atoms of each element and the total mass all change because a new substance forms.', false, 'Forming a new substance rearranges atoms but never changes how many atoms of each element there are or their total mass.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The total number of atoms of each element and the total mass are the same, but the number of molecules changes from 6 to 4.', true, 'Correct: before, 6 molecules containing 8 H and 4 O atoms; after, 4 H2O molecules containing 8 H and 4 O atoms. The mass is the same.' from version_ins;
-- apchem-mcq-b4-sv-h-4.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.3-b-v1', 'mcq', 'decide which quantities are conserved in a particle-level representation of a reaction (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid container at constant temperature holds 4 CO molecules and 2 O2 molecules at a pressure P0. They react completely according to 2 CO + O2 → 2 CO2. What is the pressure after the reaction, if all species are gases?', null, md5('apchem-mcq-b4-sv-h-4.3-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P0, because mass and atoms are conserved.', false, 'Pressure depends on the number of gas molecules, which is not conserved, even though mass and atoms are.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.5 P0, because 4 CO2 molecules are formed from the reactants.', false, 'It divides in the wrong direction, treating the number of molecules as rising from 4 to 6.' from version_ins
union all select gen_random_uuid(), id, 'C', '(2/3) P0, because the number of gas molecules falls from 6 to 4.', true, 'Correct: before, 6 gas molecules; after, 4 CO2 molecules. At constant V and T, pressure is proportional to the number of molecules, so P = (4/6) P0.' from version_ins
union all select gen_random_uuid(), id, 'D', '(1/2) P0, because the 2 O2 molecules and 2 of the CO molecules disappear.', false, 'After the reaction only the 4 CO2 molecules remain, so the ratio of molecules is 4 to 6, and not 1 to 2; no CO is left over because the 4 CO and 2 O2 react in exactly the 2:1 ratio.' from version_ins;
-- apchem-mcq-b4-sv-h-4.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.3-b-v2', 'mcq', 'decide which quantities are conserved in a particle-level representation of a reaction (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sealed rigid container holds 6 H2O2 molecules, which decompose completely according to 2 H2O2 → 2 H2O + O2. Which statement about the contents after the reaction is correct?', null, md5('apchem-mcq-b4-sv-h-4.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'There are 6 molecules, because the number of molecules is conserved in a reaction.', false, 'The number of molecules is not conserved, since 2 H2O2 make 3 molecules.' from version_ins
union all select gen_random_uuid(), id, 'B', 'There are 9 molecules and the total number of atoms is 24, unchanged.', true, 'Correct: 6 H2O2 gives 6 H2O + 3 O2 = 9 molecules; atoms before 6 × 4 = 24; after 6 × 3 + 3 × 2 = 24.' from version_ins
union all select gen_random_uuid(), id, 'C', 'There are 9 molecules and the total number of atoms is 30.', false, 'The extra 6 atoms are counted from nothing, but atoms are conserved in a chemical reaction.' from version_ins
union all select gen_random_uuid(), id, 'D', 'There are 12 molecules, because each H2O2 gives one H2O and one O2.', false, 'Each pair of H2O2 gives two H2O and one O2, so each H2O2 gives one H2O and only half an O2.' from version_ins;
-- apchem-mcq-b4-sv-h-4.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.3-b-v3', 'mcq', 'decide which quantities are conserved in a particle-level representation of a reaction (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A beaker holds a solution with 5 Ag⁺, 5 NO3⁻, 3 Na⁺ and 3 Cl⁻ ions (represented as particles). AgCl is insoluble and NaNO3 is soluble. Which description of the mixture after the precipitation is correct?', null, md5('apchem-mcq-b4-sv-h-4.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5 AgCl(s) with 3 Na⁺ and 5 NO3⁻ in solution', false, 'It forms 5 AgCl, but only 3 Cl⁻ are present, so no more than 3 can form.' from version_ins
union all select gen_random_uuid(), id, 'B', '3 AgCl(s) with 2 Ag⁺, 3 Na⁺ and 5 NO3⁻ in solution', true, 'Correct: only 3 Cl⁻ are available, so 3 AgCl form and 2 Ag⁺ remain. The solution has charge +2 + 3 = +5 and -5, so it is neutral.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 AgCl(s) with 2 Ag⁺, 3 Na⁺ and 2 NO3⁻ in solution', false, 'It removes 3 nitrate ions without a reason, leaving a solution with +5 charge and only -2 charge.' from version_ins
union all select gen_random_uuid(), id, 'D', '3 AgCl(s), 3 NaNO3(s), and 2 Ag⁺ and 2 NO3⁻ in solution', false, 'NaNO3 is soluble and its ions are spectators, so it does not form a solid.' from version_ins;
-- apchem-mcq-b4-h-4.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.4-a', 'mcq', 'judge which observation is real evidence of a new substance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student records four separate observations. Which one is the strongest evidence that a chemical change occurred?', null, md5('apchem-mcq-b4-h-4.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'White crystals stirred into water disappear, and the temperature of the water drops by 3°C.', false, 'Dissolving can absorb heat, but the crystals can be recovered unchanged on evaporation, so a temperature change alone does not show a new substance.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A colorless liquid is heated to boiling; the vapor is condensed, and the collected liquid has the same boiling point as the original liquid.', false, 'The condensed liquid has the same boiling point, which shows it is the same substance as before.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A blue solid melts to a deep blue liquid at 110°C and solidifies back to the same blue solid when cooled.', false, 'A color-preserving melting and refreezing returns the identical solid, so only a change of state occurred.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A shiny gray metal ribbon burns in air with a bright white flame, leaving a white powder that is heavier than the ribbon and does not conduct electricity.', true, 'Correct: only C produces a substance with properties different from the starting material (metal to nonconducting powder). A is dissolving, B is a boiling and condensing cycle, and D is melting and freezing.' from version_ins;
-- apchem-mcq-b4-sv-h-4.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.4-a-v1', 'mcq', 'judge which observation is real evidence of a new substance (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student heats a white solid and records the observations below. Which observation, if made, would show that a chemical change occurred?', null, md5('apchem-mcq-b4-sv-h-4.4-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The heated solid releases a gas that turns limewater cloudy, and the residue has a different melting point and a lower mass than the original solid.', true, 'Correct: a new gas and a residue with a different melting point show new substances formed; A, B and C each recover the same substance.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The solid melts at 80°C, and the cooled liquid solidifies to a white solid that again melts at 80°C.', false, 'Repeated melting at the same temperature shows the substance did not change, only its state.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The solid dissolves in water, and after the water evaporates the recovered solid has the same mass and the same melting point as before.', false, 'The recovered solid has the same properties, so dissolving was physical.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The solid sublimes onto a cold surface as crystals that have the same melting point as the original solid.', false, 'Sublimation is a change of state and the crystals keep their melting point, so the same substance remains.' from version_ins;
-- apchem-mcq-b4-sv-h-4.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.4-a-v2', 'mcq', 'judge which observation is real evidence of a new substance (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which process involves breaking covalent bonds within molecules, and is therefore a chemical change?', null, md5('apchem-mcq-b4-sv-h-4.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Heating sugar until it chars into black carbon and water vapor', true, 'Correct: charring forms new substances (carbon and water) from sucrose, so covalent bonds in sucrose break. B, C and D only overcome forces between intact molecules.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Dissolving sugar in water so the sucrose molecules separate from one another', false, 'Dissolved sucrose molecules are still intact molecules of sucrose, held to water by intermolecular forces.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Boiling water to steam', false, 'Boiling water separates intact H2O molecules without breaking O-H bonds.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Melting an ice cube', false, 'Melting ice loosens hydrogen bonds between water molecules and leaves the molecules unchanged.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.3-a-v2','apchem-mcq-b4-sv-h-4.3-a-v3','apchem-mcq-b4-h-4.3-b','apchem-mcq-b4-sv-h-4.3-b-v1','apchem-mcq-b4-sv-h-4.3-b-v2','apchem-mcq-b4-sv-h-4.3-b-v3','apchem-mcq-b4-h-4.4-a','apchem-mcq-b4-sv-h-4.4-a-v1','apchem-mcq-b4-sv-h-4.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-sv-h-4.3-a-v2','apchem-mcq-b4-sv-h-4.3-a-v3','apchem-mcq-b4-h-4.3-b','apchem-mcq-b4-sv-h-4.3-b-v1','apchem-mcq-b4-sv-h-4.3-b-v2','apchem-mcq-b4-sv-h-4.3-b-v3','apchem-mcq-b4-h-4.4-a','apchem-mcq-b4-sv-h-4.4-a-v1','apchem-mcq-b4-sv-h-4.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
