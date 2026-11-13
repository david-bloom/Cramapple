begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.10-b-v2','apchem-mcq-b2-sv-h-3.10-b-v3','apchem-mcq-b2-h-3.11-a','apchem-mcq-b2-sv-h-3.11-a-v1','apchem-mcq-b2-sv-h-3.11-a-v2','apchem-mcq-b2-sv-h-3.11-a-v3','apchem-mcq-b2-h-3.11-b','apchem-mcq-b2-sv-h-3.11-b-v1','apchem-mcq-b2-sv-h-3.11-b-v2'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apchem-mcq-b2-sv-h-3.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.10-b-v2', 'mcq', 'gas solubility from partial pressure and air composition (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The solubility of CO₂ in water at 25°C is 0.034 M for each 1.0 atm of CO₂ partial pressure. A bottle of soda is sealed with CO₂ at 4.0 atm above the liquid. The bottle is opened and left until the liquid has come to equilibrium with the air, where the CO₂ partial pressure is 4.0 × 10⁻⁴ atm. At the same temperature, what is the final concentration of dissolved CO₂?', null, md5('apchem-mcq-b2-sv-h-3.10-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.136 M', false, '0.136 M is the concentration while the bottle was sealed at 4.0 atm, before the gas escaped.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.4 × 10⁻⁵ M', true, 'Correct: [CO₂] = 0.034 × 4.0 × 10⁻⁴ = 1.4 × 10⁻⁵ M (compared with 0.034 × 4.0 = 0.136 M while sealed).' from version_ins
union all select gen_random_uuid(), id, 'C', '0.034 M', false, '0.034 M is the value for 1.0 atm of CO₂, which is not the CO₂ pressure in air.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.4 × 10⁻³ M', false, '1.4 × 10⁻³ M treats the 0.04% of CO₂ in air as a fraction of 0.04 instead of 0.0004.' from version_ins;
-- apchem-mcq-b2-sv-h-3.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.10-b-v3', 'mcq', 'gas solubility from partial pressure and air composition (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The solubility of N₂ in water at 25°C is 6.1 × 10⁻⁴ M for each 1.0 atm of N₂ partial pressure. Air is 78% N₂. At the surface the total pressure is 1.0 atm. A diver breathes air at a total pressure of 4.0 atm, and body water is assumed to come to equilibrium with the N₂ in the air. By how much does the dissolved N₂ concentration increase compared with the surface?', null, md5('apchem-mcq-b2-sv-h-3.10-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.9 × 10⁻³ M', false, '1.9 × 10⁻³ M is the total concentration at depth, and the concentration already present at the surface was not subtracted.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.8 × 10⁻⁴ M', false, '4.8 × 10⁻⁴ M is the surface concentration, not the increase.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.8 × 10⁻³ M', false, '1.8 × 10⁻³ M treats the air as pure N₂ and ignores that only 78% is N₂.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.4 × 10⁻³ M', true, 'Correct: [N₂] at depth = 6.1 × 10⁻⁴ × 0.78 × 4.0 = 1.9 × 10⁻³ M; at the surface 6.1 × 10⁻⁴ × 0.78 = 4.8 × 10⁻⁴ M; increase = 1.4 × 10⁻³ M.' from version_ins;
-- apchem-mcq-b2-h-3.11-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.11-a', 'mcq', 'photon energy ratio and region-to-transition matching', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A compound absorbs radiation at 3.0 μm (infrared) and at 250 nm (ultraviolet). Which statement correctly compares the two absorptions?', null, md5('apchem-mcq-b2-h-3.11-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 250 nm photons have 12 times the energy of the 3.0 μm photons, and they excite electronic transitions, while the 3.0 μm photons excite bond vibrations.', true, 'Correct: E is proportional to 1/λ, so the energy ratio is 3000 nm / 250 nm = 12; UV photons promote electrons, IR photons change vibrations.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The 3.0 μm photons have 12 times the energy of the 250 nm photons, and they excite electronic transitions.', false, 'Energy is inversely proportional to wavelength, so the longer-wavelength IR photon has the lower energy, not 12 times more.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The 250 nm photons have 144 times the energy of the 3.0 μm photons, and they excite electronic transitions.', false, 'The energy ratio is the wavelength ratio itself, not its square.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 250 nm photons have 12 times the energy of the 3.0 μm photons, and they excite bond vibrations.', false, 'The ratio is right, but the UV photons carry enough energy to promote electrons, while bond vibrations need the smaller energy of IR photons.' from version_ins;
-- apchem-mcq-b2-sv-h-3.11-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.11-a-v1', 'mcq', 'photon energy ratio and region-to-transition matching (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gas absorbs microwave radiation at 3.0 cm and infrared radiation at 3.0 μm. Which statement correctly compares the two absorptions?', null, md5('apchem-mcq-b2-sv-h-3.11-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The microwave photons have 1.0 × 10⁴ times the energy of the IR photons, and they excite molecular vibrations.', false, 'The microwave photon has the longer wavelength, so it has the lower energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The IR photons have 1.0 × 10⁴ times the energy of the microwave photons; the IR absorption changes the rotations and the microwave absorption changes the vibrations.', false, 'Rotational changes take far less energy than vibrational changes, so the smaller microwave photons match rotations.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The IR photons have 1.0 × 10² times the energy of the microwave photons; the IR absorption changes the vibrations and the microwave absorption changes the rotations.', false, 'The energy ratio is the full wavelength ratio of 10⁴, not its square root.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The IR photons have 1.0 × 10⁴ times the energy of the microwave photons; the IR absorption changes the molecular vibrations and the microwave absorption changes the molecular rotations.', true, 'Correct: 3.0 cm / 3.0 μm = 3.0 × 10⁻² m / 3.0 × 10⁻⁶ m = 1.0 × 10⁴; rotational energy changes are smaller than vibrational ones.' from version_ins;
-- apchem-mcq-b2-sv-h-3.11-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.11-a-v2', 'mcq', 'photon energy ratio and region-to-transition matching (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dye absorbs visible light at 500 nm and infrared radiation at 5.0 μm. Which statement correctly compares the two absorptions?', null, md5('apchem-mcq-b2-sv-h-3.11-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 5.0 μm photons have 10 times the energy of the 500 nm photons, and they excite electronic transitions.', false, 'The longer-wavelength IR photon has the lower energy, not 10 times more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The 500 nm photons have 10 times the energy of the 5.0 μm photons, and they excite electronic transitions, while the 5.0 μm photons excite bond vibrations.', true, 'Correct: 5000 nm / 500 nm = 10; visible photons promote electrons, IR photons change vibrations.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The 500 nm photons have 100 times the energy of the 5.0 μm photons, and they excite electronic transitions.', false, 'The energy ratio is the wavelength ratio of 10, not its square.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 500 nm photons have 10 times the energy of the 5.0 μm photons, and they excite bond vibrations, while the 5.0 μm photons excite electronic transitions.', false, 'The ratio is right, but the assignments are reversed, since vibrations need less energy than electronic transitions.' from version_ins;
-- apchem-mcq-b2-sv-h-3.11-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.11-a-v3', 'mcq', 'photon energy ratio and region-to-transition matching (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A molecule absorbs ultraviolet radiation at 200 nm and visible light at 600 nm, and both absorptions are caused by electronic transitions. Which statement is correct?', null, md5('apchem-mcq-b2-sv-h-3.11-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The 200 nm photons have 9.0 times the energy of the 600 nm photons, so the 200 nm absorption involves a larger energy gap.', false, 'The energy ratio equals the wavelength ratio, not its square.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The 600 nm photons have 3.0 times the energy of the 200 nm photons, so the 600 nm absorption involves a larger energy gap.', false, 'The shorter wavelength has the higher energy, so the 600 nm photons carry less, not more.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The 200 nm photons have 3.0 times the energy of the 600 nm photons, so the 200 nm absorption is a vibrational transition.', false, 'The problem states that both absorptions are electronic, and vibrational transitions need IR photons.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The 200 nm photons have 3.0 times the energy of the 600 nm photons, so the 200 nm absorption involves a larger energy gap between electronic levels.', true, 'Correct: 600 nm / 200 nm = 3.0; the photon energy matches the gap between electronic energy levels.' from version_ins;
-- apchem-mcq-b2-h-3.11-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.11-b', 'mcq', 'bond energy per mole versus single-photon energy; intensity misconception', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. A C-H bond has a bond energy of 410 kJ/mol. Which light can break a C-H bond by absorption of a single photon per bond?', null, md5('apchem-mcq-b2-h-3.11-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ultraviolet light at 250 nm, because each photon carries more than 410 kJ per mole of photons.', true, 'Correct: the energy of a mole of photons is 119,600 / λ(nm) kJ/mol: 650 nm gives 184, 450 nm gives 266, 250 nm gives 479, 10 μm gives 12.0; only 250 nm exceeds 410 kJ/mol; the longest wavelength that can break the bond is about 292 nm.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A red laser at 650 nm, because red light is the most intense visible light.', false, 'A 650 nm photon carries only about 184 kJ per mole of photons, and color does not make the energy larger.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A blue laser at 450 nm, because blue light carries the most energy of the visible region.', false, 'A 450 nm photon carries about 266 kJ per mole of photons, which is still below 410 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A very intense infrared source at 10 μm, because it delivers many photons per second.', false, 'Intensity counts photons, but each IR photon at 10 μm carries only about 12 kJ per mole, and photon energies do not add up on one bond.' from version_ins;
-- apchem-mcq-b2-sv-h-3.11-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.11-b-v1', 'mcq', 'bond energy per mole versus single-photon energy; intensity misconception (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. The O-O bond in a peroxide has a bond energy of 142 kJ/mol. Which light can break an O-O bond by absorption of a single photon per bond?', null, md5('apchem-mcq-b2-sv-h-3.11-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Near-infrared light at 950 nm, because it is close to the energy needed.', false, 'A 950 nm photon carries about 126 kJ per mole of photons, which is below 142 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Infrared light at 1.5 μm, because a strong beam provides many photons.', false, 'Many low-energy photons do not combine on a single bond, and each 1.5 μm photon carries about 80 kJ per mole.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Near-infrared light at 780 nm, because each photon carries more than 142 kJ per mole of photons.', true, 'Correct: 780 nm photons carry 153 kJ per mole of photons, above 142 kJ/mol; the threshold is about 843 nm; 950 nm gives 126, 1.5 μm gives 80, 20 μm gives 6.0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Far-infrared light at 20 μm, because infrared radiation is absorbed by bond vibrations.', false, 'Absorption by vibrations does not break the bond, since each 20 μm photon carries only about 6 kJ per mole.' from version_ins;
-- apchem-mcq-b2-sv-h-3.11-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.11-b-v2', 'mcq', 'bond energy per mole versus single-photon energy; intensity misconception (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. The N≡N bond in N₂ has a bond energy of 945 kJ/mol. Which light can break an N≡N bond by absorption of a single photon per bond?', null, md5('apchem-mcq-b2-sv-h-3.11-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Blue light at 450 nm, because it is the highest-energy visible light.', false, 'A 450 nm photon carries about 266 kJ per mole of photons, far below 945 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ultraviolet light at 250 nm, because ultraviolet light breaks bonds.', false, 'A 250 nm photon carries about 479 kJ per mole of photons, which can break a weaker bond but not this triple bond.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ultraviolet light at 150 nm, because it is far into the ultraviolet.', false, 'A 150 nm photon carries about 797 kJ per mole of photons, still below 945 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Far-ultraviolet light at 100 nm, because each photon carries more than 945 kJ per mole of photons.', true, 'Correct: photon energy per mole = 119,600 / λ(nm): 450 nm gives 266, 250 nm gives 479, 150 nm gives 797, 100 nm gives 1196 kJ/mol; the threshold is about 127 nm.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.10-b-v2','apchem-mcq-b2-sv-h-3.10-b-v3','apchem-mcq-b2-h-3.11-a','apchem-mcq-b2-sv-h-3.11-a-v1','apchem-mcq-b2-sv-h-3.11-a-v2','apchem-mcq-b2-sv-h-3.11-a-v3','apchem-mcq-b2-h-3.11-b','apchem-mcq-b2-sv-h-3.11-b-v1','apchem-mcq-b2-sv-h-3.11-b-v2']) and status='draft')<>9 then raise exception 'chunk 7: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-sv-h-3.10-b-v2','apchem-mcq-b2-sv-h-3.10-b-v3','apchem-mcq-b2-h-3.11-a','apchem-mcq-b2-sv-h-3.11-a-v1','apchem-mcq-b2-sv-h-3.11-a-v2','apchem-mcq-b2-sv-h-3.11-a-v3','apchem-mcq-b2-h-3.11-b','apchem-mcq-b2-sv-h-3.11-b-v1','apchem-mcq-b2-sv-h-3.11-b-v2']))<>36 then raise exception 'chunk 7: expected 36 choices'; end if;
end $$;
commit;
