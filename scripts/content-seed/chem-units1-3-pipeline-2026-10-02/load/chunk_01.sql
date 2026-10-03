begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-001-v1','apchem-mcq-sv-001-v2','apchem-mcq-sv-001-v3','apchem-mcq-sv-021-v1','apchem-mcq-sv-021-v2','apchem-mcq-sv-021-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-001-v1 (seed apchem-mcq-001)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-001-v1', 'mcq', 'Moles of carbon dioxide', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A technician collects 4.40 g of carbon dioxide (44.0 g mol⁻¹) from a fermentation vessel. How many moles of CO₂ were collected?', null, md5('apchem-mcq-sv-001-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.157 mol', false, 'Uses 28.0 g mol⁻¹ (the molar mass of CO, omitting one oxygen atom from CO₂) as the divisor: 4.40 ÷ 28.0 = 0.157. CO₂ has two oxygen atoms, so M = 12.0 + 2(16.0) = 44.0.' from version_ins
union all select gen_random_uuid(), id, 'B', '194 mol', false, 'Multiplies mass by molar mass instead of dividing: 4.40 × 44.0 = 193.6, which rounds to 194. Multiplying gives g² mol⁻¹, not moles.' from version_ins
union all select gen_random_uuid(), id, 'C', '10.0 mol', false, 'Inverts the ratio and divides molar mass by mass: 44.0 ÷ 4.40 = 10.0. The result is not a mole quantity because the units do not reduce to mol.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.100 mol', true, 'Correct: n = m/M = 4.40 g ÷ 44.0 g mol⁻¹ = 0.100 mol. Grams cancel, leaving moles, reported to three significant figures.' from version_ins
;
-- apchem-mcq-sv-001-v2 (seed apchem-mcq-001)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-001-v2', 'mcq', 'Mass of sodium chloride needed', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student needs 0.400 mol of sodium chloride (58.5 g mol⁻¹) to prepare a saline solution. What mass of NaCl should be weighed out?', null, md5('apchem-mcq-sv-001-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '23.4 g', true, 'Correct: m = nM = 0.400 mol × 58.5 g mol⁻¹ = 23.4 g. Moles cancel, leaving grams, to three significant figures.' from version_ins
union all select gen_random_uuid(), id, 'B', '14.2 g', false, 'Multiplies by only 35.5 g mol⁻¹, the atomic mass of chlorine, as if NaCl contained only the Cl: 0.400 × 35.5 = 14.2. The molar mass of NaCl is 23.0 + 35.5 = 58.5.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.00684 g', false, 'Divides moles by molar mass instead of multiplying: 0.400 ÷ 58.5 = 0.00684. This reverses the conversion direction (it treats the problem as mass-to-moles).' from version_ins
union all select gen_random_uuid(), id, 'D', '146 g', false, 'Inverts the ratio, giving molar mass divided by moles: 58.5 ÷ 0.400 = 146.25, which rounds to 146. The units come out as g mol⁻² rather than grams.' from version_ins
;
-- apchem-mcq-sv-001-v3 (seed apchem-mcq-001)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-001-v3', 'mcq', 'Mass from particle count', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sealed flask contains 1.204 × 10²⁴ molecules of ammonia, NH₃ (17.0 g mol⁻¹). What is the mass of the ammonia in the flask? (Avogadro''s number is 6.022 × 10²³ mol⁻¹.)', null, md5('apchem-mcq-sv-001-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.05 × 10²⁵ g', false, 'Multiplies the number of molecules by 17.0 directly (1.204 × 10²⁴ × 17.0 = 2.05 × 10²⁵) without dividing by Avogadro''s number, so molecules are never converted to moles.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.00 g', false, 'Stops after converting particles to moles and reports 2.00 (moles) as if it were grams, skipping the molar-mass step.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.50 g', false, 'Converts to 2.00 mol correctly but then divides molar mass by moles (17.0 ÷ 2.00 = 8.50) instead of multiplying them.' from version_ins
union all select gen_random_uuid(), id, 'D', '34.0 g', true, 'Correct: n = (1.204 × 10²⁴) ÷ (6.022 × 10²³ mol⁻¹) = 2.00 mol, then m = nM = 2.00 mol × 17.0 g mol⁻¹ = 34.0 g.' from version_ins
;
-- apchem-mcq-sv-021-v1 (seed apchem-mcq-021)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-021-v1', 'mcq', 'Moles of ethanol', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of pure ethanol (C₂H₅OH, molar mass = 46.07 g/mol) has a mass of 23.0 g. How many moles of ethanol does the sample contain?', null, md5('apchem-mcq-sv-021-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.250 mol', false, 'Incorrect. This divides by twice the molar mass (2 × 46.07 = 92.14), as if the sample were a dimer or the formula mass were counted twice: 23.0 ÷ 92.14 = 0.250.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.00 mol', false, 'Incorrect. This inverts the calculation, dividing molar mass by mass: 46.07 ÷ 23.0 = 2.00.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.499 mol', true, 'Correct. Moles = mass ÷ molar mass = 23.0 g ÷ 46.07 g/mol = 0.499 mol.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.765 mol', false, 'Incorrect. This divides by 30.07 g/mol, the molar mass of C₂H₆, because the oxygen atom''s mass (16.00) was left out of the formula mass: 23.0 ÷ 30.07 = 0.765.' from version_ins
;
-- apchem-mcq-sv-021-v2 (seed apchem-mcq-021)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-021-v2', 'mcq', 'Moles of aluminum atoms', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A strip of pure aluminum foil (Al, molar mass = 26.98 g/mol) has a mass of 13.5 g. How many moles of aluminum atoms does the foil contain?', null, md5('apchem-mcq-sv-021-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '364 mol', false, 'Incorrect. This multiplies mass by molar mass instead of dividing: 13.5 × 26.98 = 364.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.500 mol', true, 'Correct. Moles = mass ÷ molar mass = 13.5 g ÷ 26.98 g/mol = 0.500 mol.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.04 mol', false, 'Incorrect. This divides by 13, the atomic number of Al, instead of its molar mass: 13.5 ÷ 13 = 1.04.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.00 mol', false, 'Incorrect. This inverts the calculation, dividing molar mass by mass: 26.98 ÷ 13.5 = 2.00.' from version_ins
;
-- apchem-mcq-sv-021-v3 (seed apchem-mcq-021)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-021-v3', 'mcq', 'Moles of oxygen gas', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sealed cylinder holds 8.00 g of pure oxygen gas (O₂, molar mass = 32.00 g/mol). How many moles of O₂ does the cylinder contain?', null, md5('apchem-mcq-sv-021-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.250 mol', true, 'Correct. Moles = mass ÷ molar mass = 8.00 g ÷ 32.00 g/mol = 0.250 mol.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.00 mol', false, 'Incorrect. This inverts the calculation, dividing molar mass by mass: 32.00 ÷ 8.00 = 4.00.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.500 mol', false, 'Incorrect. This divides by 16.00 g/mol, the molar mass of a single O atom, ignoring that O₂ is diatomic: 8.00 ÷ 16.00 = 0.500.' from version_ins
union all select gen_random_uuid(), id, 'D', '256 mol', false, 'Incorrect. This multiplies mass by molar mass instead of dividing: 8.00 × 32.00 = 256.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-001-v1','apchem-mcq-sv-001-v2','apchem-mcq-sv-001-v3','apchem-mcq-sv-021-v1','apchem-mcq-sv-021-v2','apchem-mcq-sv-021-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
