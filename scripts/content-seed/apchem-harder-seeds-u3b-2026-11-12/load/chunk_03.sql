begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.6-a-v2','apchem-mcq-b2-sv-h-3.6-a-v3','apchem-mcq-b2-h-3.6-b','apchem-mcq-b2-sv-h-3.6-b-v1','apchem-mcq-b2-sv-h-3.6-b-v2','apchem-mcq-b2-sv-h-3.6-b-v3','apchem-mcq-b2-h-3.7-a','apchem-mcq-b2-sv-h-3.7-a-v1','apchem-mcq-b2-sv-h-3.7-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apchem-mcq-b2-sv-h-3.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.6-a-v2', 'mcq', 'use compressibility data to find real volume and decide attractions vs particle volume (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 1.00 mol sample of gas in a 0.500 L rigid container at 300 K has a measured pressure of 44 atm. Use R = 0.0821 L·atm/(mol·K). What is the ideal pressure, and what does the comparison show?', null, md5('apchem-mcq-b2-sv-h-3.6-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '49.3 atm; the measured pressure is lower, which points to attractions between the molecules.', true, 'Correct: P(ideal) = 1.00 × 0.0821 × 300 / 0.500 = 49.3 atm; 44 < 49.3, so attractions reduce the force of collisions with the walls.' from version_ins
union all select gen_random_uuid(), id, 'B', '24.6 atm; the measured pressure is higher, which points to the volume of the molecules.', false, '24.6 atm forgets to divide by the 0.500 L volume, which then makes the measured value look high.' from version_ins
union all select gen_random_uuid(), id, 'C', '49.3 atm; the measured pressure is lower, which points to the volume of the molecules.', false, 'The ideal pressure is right, but molecular volume would raise the pressure above ideal, not lower it.' from version_ins
union all select gen_random_uuid(), id, 'D', '12.3 atm; the measured pressure is higher, which points to the volume of the molecules.', false, '12.3 atm multiplies by the volume instead of dividing by it.' from version_ins;
-- apchem-mcq-b2-sv-h-3.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.6-a-v3', 'mcq', 'use compressibility data to find real volume and decide attractions vs particle volume (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.00 mol sample of H₂ in a 1.00 L rigid container at 300 K has a measured pressure of 52.5 atm. Use R = 0.0821 L·atm/(mol·K). What is the ideal pressure, and what does the comparison show?', null, md5('apchem-mcq-b2-sv-h-3.6-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '24.6 atm; the measured pressure is higher, which points to the volume of the molecules.', false, '24.6 atm uses 1.00 mol instead of 2.00 mol.' from version_ins
union all select gen_random_uuid(), id, 'B', '49.3 atm; the measured pressure is higher, which points to the volume of the molecules.', true, 'Correct: P(ideal) = 2.00 × 0.0821 × 300 / 1.00 = 49.3 atm; 52.5 > 49.3, so the finite volume of the molecules leaves less free space and raises the pressure.' from version_ins
union all select gen_random_uuid(), id, 'C', '49.3 atm; the measured pressure is higher, which points to attractions between the molecules.', false, 'Attractions would lower the pressure below the ideal value, not raise it.' from version_ins
union all select gen_random_uuid(), id, 'D', '98.5 atm; the measured pressure is lower, which points to attractions between the molecules.', false, '98.5 atm doubles the amount twice, and the lower-pressure conclusion would not match 52.5 atm anyway.' from version_ins;
-- apchem-mcq-b2-h-3.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.6-b', 'mcq', 'judge which gas sample deviates most from conditions and intermolecular forces', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which sample of gas is expected to deviate most from ideal gas behavior, and why?', null, md5('apchem-mcq-b2-h-3.6-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ar at 600 K and 1.0 atm, because Ar has the largest atoms of the four samples.', false, 'At 600 K and 1 atm the atoms are fast and far apart, so Ar behaves very nearly ideally.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NH₃ at 250 K and 1.0 atm, because it is only about 10 K above its boiling point (240 K) and its molecules attract each other strongly.', true, 'Correct: deviation is greatest when the gas is close to condensing (low T, strong attractions) or at high pressure; H₂ has very weak attractions and ten atm is modest, while Ar at 600 K and CH₄ at 400 K at 1 atm are hot, low-pressure samples.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H₂ at 300 K and 10 atm, because it is at the highest pressure.', false, 'Ten atm is modest, and H₂ has very weak attractions and tiny molecules, so it stays close to ideal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CH₄ at 400 K and 1.0 atm, because CH₄ is nonpolar, so its molecules attract strongly.', false, 'Nonpolar molecules have only weak dispersion forces, and at 400 K and 1 atm CH₄ is far above its boiling point.' from version_ins;
-- apchem-mcq-b2-sv-h-3.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.6-b-v1', 'mcq', 'judge which gas sample deviates most from conditions and intermolecular forces (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Which sample of gas is expected to deviate most from ideal gas behavior, and why?', null, md5('apchem-mcq-b2-sv-h-3.6-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ne at 300 K and 20 atm, because 20 atm is the highest pressure listed.', false, 'Ne attractions are extremely weak, and 20 atm at 300 K does not bring the atoms close enough for large deviations.' from version_ins
union all select gen_random_uuid(), id, 'B', 'N₂ at 500 K and 5.0 atm, because it has the largest number of molecules.', false, 'The number of molecules is not a measure of deviation, and N₂ at 500 K is fast and weakly attracting.' from version_ins
union all select gen_random_uuid(), id, 'C', 'SO₂ at 280 K and 1.0 atm, because it is only about 17 K above its boiling point (263 K) and its polar molecules attract each other.', true, 'Correct: SO₂ is a polar gas just above its boiling point, so its attractions are important; Ne, N₂ and He are weakly attracting and the conditions are far from condensation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'He at 150 K and 1.0 atm, because it is the coldest sample.', false, 'He has the weakest attractions of any gas, and 150 K is far above its boiling point of 4 K.' from version_ins;
-- apchem-mcq-b2-sv-h-3.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.6-b-v2', 'mcq', 'judge which gas sample deviates most from conditions and intermolecular forces (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Carbon dioxide has a critical temperature of 304 K. Under which conditions does CO₂ deviate most from ideal gas behavior, and why?', null, md5('apchem-mcq-b2-sv-h-3.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '500 K and 2.0 atm, because the gas is hot and the molecules are far apart.', false, 'Hot and fairly dilute conditions make CO₂ nearly ideal.' from version_ins
union all select gen_random_uuid(), id, 'B', '400 K and 1.0 atm, because the pressure is lowest at this temperature.', false, 'Low pressure and high temperature give nearly ideal behavior, since the molecules rarely interact.' from version_ins
union all select gen_random_uuid(), id, 'C', '600 K and 0.50 atm, because the molecules are moving fastest.', false, 'Fast molecules at low pressure are the ideal case; fast motion reduces the effect of attractions.' from version_ins
union all select gen_random_uuid(), id, 'D', '310 K and 50 atm, because the molecules are close together and slow enough for attractions to matter, near the point where CO₂ condenses.', true, 'Correct: deviations grow at high pressure and at temperatures near condensation; 310 K is just above the critical temperature and 50 atm packs the molecules together.' from version_ins;
-- apchem-mcq-b2-sv-h-3.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.6-b-v3', 'mcq', 'judge which gas sample deviates most from conditions and intermolecular forces (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ethane (C₂H₆, 30.1 g/mol) boils at 185 K and nitric oxide (NO, 30.0 g/mol) boils at 121 K. Each gas is at 200 K and 1.0 atm. Which statement is correct?', null, md5('apchem-mcq-b2-sv-h-3.6-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NO deviates more, because its lower boiling point means weaker bonds in the molecule.', false, 'Boiling points reflect forces between molecules, not the strength of the bonds inside them.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ethane deviates more, because its higher boiling point shows stronger attractions between molecules, and 200 K is only 15 K above that boiling point.', true, 'Correct: a higher boiling point reflects stronger intermolecular attractions; at 200 K ethane is much closer to condensing than NO.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The two gases deviate equally, because their molar masses are almost the same.', false, 'Equal molar mass does not mean equal intermolecular attractions, and the boiling points differ by 64 K.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither gas deviates, because 1.0 atm is a low pressure.', false, 'Low pressure reduces deviation but does not remove it, and ethane at 200 K is close to condensation.' from version_ins;
-- apchem-mcq-b2-h-3.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.7-a', 'mcq', 'ion concentration after mixing two salt solutions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student mixes 150.0 mL of 0.200 M NaCl(aq) with 100.0 mL of 0.300 M CaCl₂(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of Cl⁻ in the mixture?', null, md5('apchem-mcq-b2-h-3.7-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.360 M', true, 'Correct: mol Cl⁻ = 0.1500 × 0.200 + 2 × 0.1000 × 0.300 = 0.0300 + 0.0600 = 0.0900 mol; total volume 0.2500 L; 0.0900/0.2500 = 0.360 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.240 M', false, '0.240 M counts only one Cl⁻ for each formula unit, so the two Cl⁻ in each CaCl₂ are missed.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.400 M', false, '0.400 M averages the Cl⁻ concentrations of the two solutions (0.200 and 0.600) without weighting by volume.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.600 M', false, '0.600 M is the Cl⁻ concentration of the CaCl₂ solution before mixing, and ignores the NaCl and the dilution.' from version_ins;
-- apchem-mcq-b2-sv-h-3.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.7-a-v1', 'mcq', 'ion concentration after mixing two salt solutions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student mixes 200.0 mL of 0.150 M Na₂SO₄(aq) with 300.0 mL of 0.100 M NaNO₃(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of Na⁺ in the mixture?', null, md5('apchem-mcq-b2-sv-h-3.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.180 M', true, 'Correct: mol Na⁺ = 2 × 0.2000 × 0.150 + 0.3000 × 0.100 = 0.0600 + 0.0300 = 0.0900 mol; total volume 0.5000 L; 0.0900/0.5000 = 0.180 M.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.120 M', false, '0.120 M counts one Na⁺ per formula unit of Na₂SO₄, so the factor of 2 is missed.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.200 M', false, '0.200 M averages the Na⁺ concentrations (0.300 M and 0.100 M) without weighting by volume.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.400 M', false, '0.400 M adds the two Na⁺ concentrations and ignores that mixing dilutes both.' from version_ins;
-- apchem-mcq-b2-sv-h-3.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.7-a-v2', 'mcq', 'ion concentration after mixing two salt solutions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student mixes 100.0 mL of 0.100 M Al(NO₃)₃(aq) with 150.0 mL of 0.200 M KNO₃(aq). Assume the volumes are additive and both salts dissociate completely. What is the concentration of NO₃⁻ in the mixture?', null, md5('apchem-mcq-b2-sv-h-3.7-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.160 M', false, '0.160 M counts one NO₃⁻ per formula unit of Al(NO₃)₃, so the factor of 3 is missed.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.240 M', true, 'Correct: mol NO₃⁻ = 3 × 0.1000 × 0.100 + 0.1500 × 0.200 = 0.0300 + 0.0300 = 0.0600 mol; total volume 0.2500 L; 0.0600/0.2500 = 0.240 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.250 M', false, '0.250 M averages the NO₃⁻ concentrations (0.300 M and 0.200 M) without weighting by volume.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.500 M', false, '0.500 M adds the two NO₃⁻ concentrations and ignores the dilution on mixing.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.6-a-v2','apchem-mcq-b2-sv-h-3.6-a-v3','apchem-mcq-b2-h-3.6-b','apchem-mcq-b2-sv-h-3.6-b-v1','apchem-mcq-b2-sv-h-3.6-b-v2','apchem-mcq-b2-sv-h-3.6-b-v3','apchem-mcq-b2-h-3.7-a','apchem-mcq-b2-sv-h-3.7-a-v1','apchem-mcq-b2-sv-h-3.7-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-sv-h-3.6-a-v2','apchem-mcq-b2-sv-h-3.6-a-v3','apchem-mcq-b2-h-3.6-b','apchem-mcq-b2-sv-h-3.6-b-v1','apchem-mcq-b2-sv-h-3.6-b-v2','apchem-mcq-b2-sv-h-3.6-b-v3','apchem-mcq-b2-h-3.7-a','apchem-mcq-b2-sv-h-3.7-a-v1','apchem-mcq-b2-sv-h-3.7-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
