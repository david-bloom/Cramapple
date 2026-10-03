begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-032-v1','apchem-mcq-sv-032-v2','apchem-mcq-sv-032-v3','apchem-mcq-sv-033-v1','apchem-mcq-sv-033-v2','apchem-mcq-sv-033-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-032-v1 (seed apchem-mcq-032)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-032-v1', 'mcq', 'Pressure of argon in a tank', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid 5.00 L tank holds 0.250 mol of argon gas at 47°C. What is the pressure of the gas? (R = 0.08206 L*atm/(mol*K))', null, md5('apchem-mcq-sv-032-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.193 atm', false, 'Incorrect: this results from using T = 47 (the Celsius value) instead of 320 K: (0.250)(0.08206)(47) / 5.00 = 0.193 atm. The ideal gas law requires kelvin.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.25 atm', false, 'Incorrect: this results from using n = 1 mol rather than 0.250 mol: (1)(0.08206)(320) / 5.00 = 5.25 atm, so the given amount of gas was ignored.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.31 atm', true, 'Correct: convert 47°C to 320 K. Then P = nRT/V = (0.250 mol)(0.08206 L*atm/(mol*K))(320 K) / 5.00 L = 6.565 / 5.00 = 1.31 atm.' from version_ins
union all select gen_random_uuid(), id, 'D', '32.8 atm', false, 'Incorrect: this results from multiplying by volume instead of dividing: (0.250)(0.08206)(320)(5.00) = 32.8 atm, inverting the dependence of P on V.' from version_ins
;
-- apchem-mcq-sv-032-v2 (seed apchem-mcq-032)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-032-v2', 'mcq', 'Moles of gas in a flask', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 4.00 L flask contains a sample of nitrogen gas at 1.50 atm and 127°C. How many moles of nitrogen gas are in the flask? (R = 0.08206 L*atm/(mol*K))', null, md5('apchem-mcq-sv-032-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.576 mol', false, 'Incorrect: this results from using T = 127 (the Celsius value) instead of 400 K: 6.00 / [(0.08206)(127)] = 0.576 mol. The ideal gas law requires kelvin.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.0150 mol', false, 'Incorrect: this results from leaving out the gas constant, n = PV/T: 6.00 / 400 = 0.0150 mol. R is needed to link the units of pressure and volume to moles and kelvin.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.183 mol', true, 'Correct: convert 127°C to 400 K. Then n = PV/RT = (1.50 atm)(4.00 L) / [(0.08206 L*atm/(mol*K))(400 K)] = 6.00 / 32.82 = 0.183 mol.' from version_ins
union all select gen_random_uuid(), id, 'D', '5.47 mol', false, 'Incorrect: this results from inverting the rearrangement, n = RT/PV: (0.08206)(400) / 6.00 = 5.47 mol, placing P and V in the denominator when solving for n.' from version_ins
;
-- apchem-mcq-sv-032-v3 (seed apchem-mcq-032)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-032-v3', 'mcq', 'Volume of a gas sample', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A flexible container holds 0.800 mol of helium gas at 2.50 atm and 25°C. What is the volume of the container? (R = 0.08206 L*atm/(mol*K))', null, md5('apchem-mcq-sv-032-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '7.83 L', true, 'Correct: convert 25°C to 298 K. Then V = nRT/P = (0.800 mol)(0.08206 L*atm/(mol*K))(298 K) / 2.50 atm = 19.56 / 2.50 = 7.83 L.' from version_ins
union all select gen_random_uuid(), id, 'B', '48.9 L', false, 'Incorrect: this results from multiplying by pressure instead of dividing: (0.800)(0.08206)(298)(2.50) = 48.9 L, which treats V as proportional to P when it is inversely proportional.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.128 L', false, 'Incorrect: this results from inverting the expression, V = P/(nRT): 2.50 / [(0.800)(0.08206)(298)] = 0.128 L, which puts nRT in the denominator.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.656 L', false, 'Incorrect: this results from using T = 25 (the Celsius value) instead of 298 K: (0.800)(0.08206)(25) / 2.50 = 0.656 L. The ideal gas law requires kelvin.' from version_ins
;
-- apchem-mcq-sv-033-v1 (seed apchem-mcq-033)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-033-v1', 'mcq', 'Hydrogen and carbon dioxide at one temperature', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Samples of H2(g) and CO2(g) are in separate flasks at 300 K. Which statement about the molecules in the two samples is correct?', null, md5('apchem-mcq-sv-033-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average kinetic energy and the average speed are both the same for the two samples because the temperatures are the same.', false, 'Incorrect: the average kinetic energy is the same, but KE = 1/2 mv² links speed to mass, so particles of different mass with equal KE have different speeds. Equal temperature does not mean equal speed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The CO2 molecules have the greater average kinetic energy because they are more massive, and they move faster on average.', false, 'Incorrect: average kinetic energy is determined by temperature alone, not by mass, so it cannot differ between the samples at the same temperature. The heavier CO2 molecules actually move more slowly on average.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average kinetic energy is the same for both samples, and the H2 molecules move faster on average than the CO2 molecules.', true, 'Correct: average kinetic energy depends only on absolute temperature, so it is the same for H2 and CO2 at 300 K. Since KE = 1/2 mv², the much less massive H2 molecules (2 g/mol versus 44 g/mol) must have a greater average speed to have the same average kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The H2 molecules have the greater average kinetic energy because they move faster, so the two samples are at different temperatures.', false, 'Incorrect: this reverses the logic. The temperatures are given as equal, so the average kinetic energies are equal; the higher speed of H2 is a consequence of its smaller mass, not a sign of greater kinetic energy.' from version_ins
;
-- apchem-mcq-sv-033-v2 (seed apchem-mcq-033)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-033-v2', 'mcq', 'Doubling the Kelvin temperature', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid container holds helium gas at 300 K. The gas is heated to 600 K. Which statement correctly describes the change in the average kinetic energy and the average speed of the helium atoms?', null, md5('apchem-mcq-sv-033-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average kinetic energy doubles, and the average speed also doubles.', false, 'Incorrect: if the speed doubled, the kinetic energy (proportional to v²) would increase by a factor of 4, not 2. The average speed increases only by √2, about 1.4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average kinetic energy increases by a factor of about 1.4, and the average speed increases by a factor of about 1.4.', false, 'Incorrect: the average kinetic energy is directly proportional to the Kelvin temperature, so doubling T doubles it. The factor of √2 applies to the speed, not to the kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average kinetic energy doubles, and the average speed stays the same because the mass of each atom is unchanged.', false, 'Incorrect: the kinetic energy increases, and with the mass fixed the only way to increase 1/2 mv² is to increase v. The speed increases by about 1.4.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average kinetic energy doubles, and the average speed increases by a factor of about 1.4.', true, 'Correct: average kinetic energy is directly proportional to Kelvin temperature, so doubling T from 300 K to 600 K doubles the average kinetic energy. Because KE = 1/2 mv² and the mass of a He atom is unchanged, speed is proportional to the square root of KE, so the average speed increases by √2, about 1.4.' from version_ins
;
-- apchem-mcq-sv-033-v3 (seed apchem-mcq-033)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-033-v3', 'mcq', 'Helium and argon in one vessel', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid vessel at 400 K contains a mixture of helium (4.0 g/mol) and argon (40 g/mol). Which statement about the gases is correct?', null, md5('apchem-mcq-sv-033-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average kinetic energy is the same for both gases, and the helium atoms move about 3 times faster on average than the argon atoms.', true, 'Correct: both gases are at 400 K, so their average kinetic energies are equal. With equal KE = 1/2 mv², the ratio of speeds is the square root of the inverse mass ratio: sqrt(40/4.0) = sqrt(10) ≈ 3.2, so helium atoms move about 3 times faster.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Because both gases are in the same vessel at the same temperature, they have the same average kinetic energy and the same average speed.', false, 'Incorrect: the average kinetic energy is equal, but KE = 1/2 mv² requires the lighter helium atoms to move faster than the heavier argon atoms, by a factor of about 3. Sharing a vessel makes temperatures equal, not speeds.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The argon atoms have about 10 times the average kinetic energy of the helium atoms, and the two gases have the same average speed.', false, 'Incorrect: average kinetic energy depends only on temperature, so the two gases have equal average kinetic energy. The speeds differ, with helium faster; they are not equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average kinetic energy is the same for both gases, and the helium atoms move about 10 times faster on average than the argon atoms.', false, 'Incorrect: the equal kinetic energy is right, but speed is not inversely proportional to mass. Because KE = 1/2 mv², the speed ratio is the square root of the mass ratio, sqrt(10) ≈ 3.2, not 10.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-032-v1','apchem-mcq-sv-032-v2','apchem-mcq-sv-032-v3','apchem-mcq-sv-033-v1','apchem-mcq-sv-033-v2','apchem-mcq-sv-033-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
