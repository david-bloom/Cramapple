begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-008-v1','apchem-mcq-sv-008-v2','apchem-mcq-sv-008-v3','apchem-mcq-sv-029-v1','apchem-mcq-sv-029-v2','apchem-mcq-sv-029-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-008-v1 (seed apchem-mcq-008)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-008-v1', 'mcq', 'Gas volume after compression', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of gas occupies 6.0 L at 3.0 atm. At constant temperature and fixed amount of gas, its volume at 9.0 atm is', null, md5('apchem-mcq-sv-008-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18 L', false, 'V2 = V1 x P2/P1 = 6.0 x 9.0/3.0 = 18 L. Treats volume as directly proportional to pressure, inverting the pressure ratio. Compressing a gas by raising P cannot increase its volume.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.0 L', false, 'Repeats the initial volume, assuming volume is unaffected by the pressure change. Volume is inversely proportional to pressure at constant T and n, so tripling P cuts V to one-third.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.0 L', false, 'Reads the 9.0 given in the problem (the final pressure in atm) as the final volume. Boyle''s law gives V2 = P1V1/P2 = 2.0 L.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.0 L', true, 'At constant T and n, P1V1 = P2V2, so V2 = P1V1/P2 = (3.0 atm)(6.0 L)/(9.0 atm) = 2.0 L.' from version_ins
;
-- apchem-mcq-sv-008-v2 (seed apchem-mcq-008)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-008-v2', 'mcq', 'Syringe plunger withdrawn', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A syringe holds 12 mL of air at 2.0 atm. The plunger is slowly pulled back at constant temperature until the pressure of the trapped air is 0.50 atm. Assuming the amount of air does not change, the volume of the air at 0.50 atm is', null, md5('apchem-mcq-sv-008-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.50 mL', false, 'Reads the 0.50 given in the problem (the final pressure in atm) as the final volume. Boyle''s law gives V2 = P1V1/P2 = 48 mL.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.0 mL', false, 'V2 = V1 x P2/P1 = 12 x 0.50/2.0 = 3.0 mL. Treats volume as directly proportional to pressure, so a pressure decrease wrongly shrinks the gas. Pulling the plunger back expands the gas, so V must increase.' from version_ins
union all select gen_random_uuid(), id, 'C', '12 mL', false, 'Repeats the initial volume, assuming the volume does not change when the pressure drops. At constant T and n, volume is inversely proportional to pressure and must increase fourfold.' from version_ins
union all select gen_random_uuid(), id, 'D', '48 mL', true, 'At constant T and n, P1V1 = P2V2, so V2 = P1V1/P2 = (2.0 atm)(12 mL)/(0.50 atm) = 48 mL.' from version_ins
;
-- apchem-mcq-sv-008-v3 (seed apchem-mcq-008)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-008-v3', 'mcq', 'Pressure after isothermal compression', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of gas has a volume of 5.0 L at a pressure of 1.0 atm. It is compressed to 2.0 L at constant temperature with no gas added or removed. The final pressure of the gas is', null, md5('apchem-mcq-sv-008-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.0 atm', false, 'Repeats the initial pressure, assuming pressure is unaffected by the volume change. Pressure is inversely proportional to volume at constant T and n.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.40 atm', false, 'P2 = P1 x V2/V1 = 1.0 x 2.0/5.0 = 0.40 atm. Treats pressure as directly proportional to volume, so shrinking the volume wrongly lowers the pressure. Compression raises pressure.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.0 atm', false, 'Reads the 2.0 given in the problem (the final volume in L) as the final pressure. Boyle''s law gives P2 = P1V1/V2 = 2.5 atm.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.5 atm', true, 'At constant T and n, P1V1 = P2V2, so P2 = P1V1/V2 = (1.0 atm)(5.0 L)/(2.0 L) = 2.5 atm.' from version_ins
;
-- apchem-mcq-sv-029-v1 (seed apchem-mcq-029)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-029-v1', 'mcq', 'Boiling points of similar-mass liquids', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Of the following liquids, which is expected to have the highest normal boiling point?', null, md5('apchem-mcq-sv-029-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CH₃CH₂CH₃', false, 'CH₃CH₂CH₃ is nonpolar, so only London dispersion forces act between its molecules. Its similar molar mass does not make up for the lack of hydrogen bonding, so it boils lower than CH₃CH₂OH.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CH₃OCH₃', false, 'CH₃OCH₃ has nearly the same molar mass as CH₃CH₂OH and is polar, but all of its hydrogen atoms are bonded to carbon, so it cannot hydrogen-bond with itself. Its attractions are weaker than those of the alcohol.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CH₃CH₂OH', true, 'CH₃CH₂OH molecules contain an O–H group, so they hydrogen-bond to one another in addition to having dispersion and dipole-dipole attractions. Hydrogen bonding is the strongest of the intermolecular forces among these molecules, so more energy is needed to vaporize it and it boils highest.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CH₃CH₂F', false, 'CH₃CH₂F is polar, but its hydrogen atoms are bonded to carbon, not to F, so it cannot form hydrogen bonds with itself. Having both H and F in the molecule does not create a hydrogen bond; only dipole-dipole and dispersion forces act.' from version_ins
;
-- apchem-mcq-sv-029-v2 (seed apchem-mcq-029)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-029-v2', 'mcq', 'Why HF boils above HCl', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Hydrogen fluoride has a much higher normal boiling point than hydrogen chloride. Which statement best explains this difference?', null, md5('apchem-mcq-sv-029-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Hydrogen bonds form between HF molecules and are stronger than the attractions between HCl molecules.', true, 'In HF the hydrogen is bonded to fluorine, so one molecule''s H is attracted to a lone pair on F of a neighboring molecule (hydrogen bonding). This is a stronger intermolecular force than the dipole-dipole and dispersion forces between HCl molecules, so more energy is needed to vaporize HF.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The H–F bond is stronger than the H–Cl bond, so more energy is needed to vaporize HF.', false, 'Bond strength is an intramolecular property. Boiling does not break H–F or H–Cl covalent bonds; it overcomes the forces between molecules. Bond energy does not explain the boiling-point difference.' from version_ins
union all select gen_random_uuid(), id, 'C', 'HF has the greater molar mass, so its London dispersion forces are stronger than those in HCl.', false, 'HF (20 g/mol) is lighter than HCl (36.5 g/mol) and has fewer electrons, so its dispersion forces are weaker, not stronger. The higher boiling point of HF comes from hydrogen bonding.' from version_ins
union all select gen_random_uuid(), id, 'D', 'HCl is nonpolar, so only weak London dispersion forces act between HCl molecules.', false, 'HCl is polar because Cl is more electronegative than H, so dipole-dipole forces act between HCl molecules in addition to dispersion forces. The key difference is that HF molecules can also hydrogen-bond.' from version_ins
;
-- apchem-mcq-sv-029-v3 (seed apchem-mcq-029)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-029-v3', 'mcq', 'Highest boiling hydride or gas', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 1 atm, which of these substances is expected to condense at the highest temperature?', null, md5('apchem-mcq-sv-029-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NH₃', true, 'NH₃ has hydrogen atoms bonded to nitrogen, so its molecules hydrogen-bond with one another. This strong intermolecular attraction means NH₃ condenses at the highest temperature of the four.' from version_ins
union all select gen_random_uuid(), id, 'B', 'GeH₄', false, 'GeH₄ has the greatest molar mass and electron count, so it has the strongest dispersion forces of the four. But it is nonpolar and cannot hydrogen-bond, and its dispersion forces are not enough to exceed the hydrogen bonding in NH₃.' from version_ins
union all select gen_random_uuid(), id, 'C', 'N₂', false, 'N₂ contains nitrogen but no hydrogen, so no hydrogen bonds can form. It is a small nonpolar molecule held only by weak dispersion forces and has the lowest boiling point of the four.' from version_ins
union all select gen_random_uuid(), id, 'D', 'PH₃', false, 'PH₃ has H bonded to P, which is not N, O, or F and is too weakly polarized for hydrogen bonding. Its molecules attract through dipole-dipole and dispersion forces, which are weaker than the hydrogen bonds in NH₃.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-008-v1','apchem-mcq-sv-008-v2','apchem-mcq-sv-008-v3','apchem-mcq-sv-029-v1','apchem-mcq-sv-029-v2','apchem-mcq-sv-029-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
