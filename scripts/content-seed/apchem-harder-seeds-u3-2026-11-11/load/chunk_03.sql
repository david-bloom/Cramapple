begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-sv-h-3.3-a-v2','apchem-mcq-sv-h-3.3-a-v3','apchem-mcq-h-3.3-b','apchem-mcq-sv-h-3.3-b-v1','apchem-mcq-sv-h-3.3-b-v2','apchem-mcq-sv-h-3.3-b-v3'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apchem-mcq-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-a-v2', 'mcq', 'Energy during phase changes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two liquids, X and Y, are kept at the same temperature. X evaporates much faster than Y. Which statement is best supported?', null, md5('apchem-mcq-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The molecules of X have a greater average kinetic energy than those of Y.', false, 'The liquids are at the same temperature, so their average kinetic energies are equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X has stronger intermolecular forces than Y.', false, 'Stronger intermolecular forces would make X evaporate more slowly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X molecules are held by weaker intermolecular forces, so a larger fraction of them have enough energy to escape, even though the average kinetic energy is the same.', true, 'Correct: same temperature means the same average kinetic energy; weaker attractions let more molecules escape.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Y molecules move faster than X molecules because Y has a lower vapor pressure.', false, 'The speed of a molecule at a given temperature depends on mass, not on its vapor pressure.' from version_ins;
-- apchem-mcq-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-a-v3', 'mcq', 'Energy during phase changes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pure substance is heated at a constant rate from a solid to a gas. The plateau at its boiling point lasts much longer than the plateau at its melting point. Which statement best explains this?', null, md5('apchem-mcq-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'During boiling, the average kinetic energy of the particles is rising, so the temperature is not rising and the stored energy is released as heat.', false, 'The average kinetic energy is constant on a plateau because the temperature is constant, and energy is absorbed rather than released.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The covalent bonds in each molecule break during boiling but not during melting.', false, 'Neither process breaks the covalent bonds inside molecules, since both separate whole molecules from one another.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Boiling requires nearly complete separation of the particles, which means overcoming more of the intermolecular attraction than melting does, so more energy is absorbed at constant temperature.', true, 'Correct: constant heating rate means plateau length is proportional to the energy absorbed; vaporization overcomes more attraction than melting, so ΔHvap is greater than ΔHfus.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Gas particles have stronger intermolecular forces than solid particles, which takes longer to establish.', false, 'Gas particles are far apart and attract one another much less than particles in a solid.' from version_ins;
-- apchem-mcq-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.3-b', 'mcq', 'Particle behavior of gases and liquids', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Helium and xenon gas are each held at 300 K. Which statement about the particles is correct?', null, md5('apchem-mcq-h-3.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Helium and xenon have the same average speed, because they are at the same temperature.', false, 'The average speeds differ, because equal kinetic energy with unequal mass requires unequal speeds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Xenon atoms have the greater average kinetic energy, because they are more massive.', false, 'Average kinetic energy does not depend on mass, only on temperature.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Helium atoms have the greater average kinetic energy, because they are lighter.', false, 'Lighter particles move faster, but they do not have more kinetic energy at the same temperature.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Helium and xenon have the same average kinetic energy, and the helium atoms move faster on average.', true, 'Correct: average kinetic energy depends only on temperature; with KE = (1/2)mv^2 and equal KE, the lighter atoms have the higher speed.' from version_ins;
-- apchem-mcq-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-b-v1', 'mcq', 'Particle behavior of gases and liquids (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two rigid 5.0 L containers are kept at 300 K. One holds 1.0 mol of H2 and the other holds 1.0 mol of CO2. Which statement about the pressures is correct?', null, md5('apchem-mcq-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The pressures are equal, because for an ideal gas the pressure depends on the moles, volume and temperature, not on the identity of the gas.', true, 'Correct: P = nRT/V, which is the same for both containers (about 4.9 atm); the faster, lighter molecules hit more often and the heavier ones hit harder, and the two effects cancel.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The CO2 container has the higher pressure, because its heavier molecules hit the walls harder.', false, 'Heavier molecules move more slowly at the same temperature, and the two effects cancel, so mass does not change the pressure.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The H2 container has the higher pressure, because its molecules move faster.', false, 'Lighter molecules are faster, but they hit the wall with less momentum per collision, and the effects cancel.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The pressures cannot be compared without knowing the molar masses.', false, 'The ideal gas law does not involve molar mass, so the pressures can be compared directly.' from version_ins;
-- apchem-mcq-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-b-v2', 'mcq', 'Particle behavior of gases and liquids (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Of the gases NH3 and H2, which would be expected to deviate more from ideal behavior at low temperature and high pressure, and why?', null, md5('apchem-mcq-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NH3, because its molecules have stronger intermolecular attractions, which become significant when the molecules are close together and slow.', true, 'Correct: NH3 hydrogen bonds and has a larger volume; at low T and high P attractions and particle volume matter more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H2, because its molecules are smaller and are packed more tightly.', false, 'Small molecules with weak attractions behave more ideally, and H2 is the more ideal gas.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H2, because its particles move faster and collide more often.', false, 'Fast-moving particles overcome attractions more easily, so H2 stays closer to ideal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'They deviate equally, because all gases behave ideally at high pressure.', false, 'Real gases deviate most at high pressure and low temperature, so the claim of ideal behavior is false.' from version_ins;
-- apchem-mcq-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-b-v3', 'mcq', 'Particle behavior of gases and liquids (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of gas in a rigid container is heated from 300 K to 600 K. Which statement is correct?', null, md5('apchem-mcq-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average speed of the particles doubles.', false, 'Doubling the temperature doubles the kinetic energy, and the speed rises by only the square root of 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average kinetic energy of the particles doubles, and the average speed increases by a factor of √2.', true, 'Correct: average kinetic energy is proportional to the Kelvin temperature, so it doubles; KE = (1/2)mv², so speed rises by √2.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average kinetic energy of the particles stays the same, because the number of particles is unchanged.', false, 'Average kinetic energy depends on temperature, which changed, and not on the number of particles.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average speed of the particles increases by a factor of 4.', false, 'A factor of 4 is the change in kinetic energy if the speed doubled, which does not follow from doubling the temperature.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-sv-h-3.3-a-v2','apchem-mcq-sv-h-3.3-a-v3','apchem-mcq-h-3.3-b','apchem-mcq-sv-h-3.3-b-v1','apchem-mcq-sv-h-3.3-b-v2','apchem-mcq-sv-h-3.3-b-v3']) and status='draft')<>6 then raise exception 'chunk 3: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-sv-h-3.3-a-v2','apchem-mcq-sv-h-3.3-a-v3','apchem-mcq-h-3.3-b','apchem-mcq-sv-h-3.3-b-v1','apchem-mcq-sv-h-3.3-b-v2','apchem-mcq-sv-h-3.3-b-v3']))<>24 then raise exception 'chunk 3: expected 24 choices'; end if;
end $$;
commit;
