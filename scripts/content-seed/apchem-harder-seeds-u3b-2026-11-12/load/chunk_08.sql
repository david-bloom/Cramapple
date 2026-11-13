begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.11-b-v3','apchem-mcq-b2-h-3.12-a','apchem-mcq-b2-sv-h-3.12-a-v1','apchem-mcq-b2-sv-h-3.12-a-v2','apchem-mcq-b2-sv-h-3.12-a-v3','apchem-mcq-b2-h-3.12-b','apchem-mcq-b2-sv-h-3.12-b-v1','apchem-mcq-b2-sv-h-3.12-b-v2','apchem-mcq-b2-sv-h-3.12-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apchem-mcq-b2-sv-h-3.11-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.11-b-v3', 'mcq', 'bond energy per mole versus single-photon energy; intensity misconception (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s, c = 3.00 × 10⁸ m/s and Nₐ = 6.022 × 10²³ /mol. The Cl-Cl bond in Cl₂ has a bond energy of 242 kJ/mol. Which light can break a Cl-Cl bond by absorption of a single photon per bond?', null, md5('apchem-mcq-b2-sv-h-3.11-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Red light at 700 nm, because red light is the lowest-energy visible light and so is gentlest.', false, 'A 700 nm photon carries only about 171 kJ per mole of photons, below 242 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Green light at 550 nm, because green is in the middle of the visible region.', false, 'A 550 nm photon carries about 218 kJ per mole of photons, just below 242 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Blue light at 450 nm, because each photon carries more than 242 kJ per mole of photons.', true, 'Correct: photon energy per mole = 119,600 / λ(nm): 700 nm gives 171, 550 nm gives 218, 450 nm gives 266, 10 μm gives 12.0 kJ/mol; the threshold is about 494 nm.' from version_ins
union all select gen_random_uuid(), id, 'D', 'An intense infrared lamp at 10 μm, because it can deliver the most photons.', false, 'Intensity does not matter, because each 10 μm photon carries only about 12 kJ per mole of photons.' from version_ins;
-- apchem-mcq-b2-h-3.12-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.12-a', 'mcq', 'separate frequency effects (KE, threshold) from intensity effects', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A metal has a threshold frequency of 5.0 × 10¹⁴ s⁻¹. Three lights shine on it: light X has frequency 7.0 × 10¹⁴ s⁻¹ and low intensity; light Y has frequency 6.0 × 10¹⁴ s⁻¹ and 10 times the intensity of X; light Z has frequency 4.0 × 10¹⁴ s⁻¹ and 1000 times the intensity of X. Which statement is correct?', null, md5('apchem-mcq-b2-h-3.12-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Light Z ejects electrons with the largest kinetic energy, because its intensity is the greatest.', false, 'Z is below the threshold frequency, so its photons cannot eject any electron regardless of intensity.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Light Y ejects electrons with the largest kinetic energy, because it is 10 times as intense as X.', false, 'Intensity changes how many electrons are ejected, but the maximum kinetic energy depends only on the frequency.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Light X gives the electrons with the greatest maximum kinetic energy; light Y gives electrons with less, even though it is more intense; light Z ejects no electrons.', true, 'Correct: maximum KE = hν - Φ rises with frequency only; Z is below the threshold, so no photon has enough energy no matter how many arrive.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All three lights eject electrons, because enough intensity can make up for a low frequency.', false, 'An electron absorbs one photon at a time, so many low-energy photons cannot combine to eject it.' from version_ins;
-- apchem-mcq-b2-sv-h-3.12-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.12-a-v1', 'mcq', 'separate frequency effects (KE, threshold) from intensity effects (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A metal has a threshold wavelength of 500 nm. Light P has a wavelength of 400 nm and a low intensity. Light Q has a wavelength of 450 nm and 20 times the intensity of P. Light R has a wavelength of 550 nm and 500 times the intensity of P. Which statement is correct?', null, md5('apchem-mcq-b2-sv-h-3.12-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Light P gives the electrons with the greatest maximum kinetic energy; light Q gives electrons with less, even though it is more intense; light R ejects no electrons.', true, 'Correct: ν = c/λ, so P is 7.5 × 10¹⁴ s⁻¹, Q is 6.7 × 10¹⁴ s⁻¹ and R is 5.5 × 10¹⁴ s⁻¹, against a threshold of 6.0 × 10¹⁴ s⁻¹; R is below the threshold.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Light R ejects electrons with the largest kinetic energy, because its intensity is the greatest.', false, 'R has a wavelength longer than the threshold wavelength, so its photons cannot eject electrons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Light Q ejects electrons with the largest kinetic energy, because both P and Q are above the threshold and Q is more intense.', false, 'Intensity raises the number of electrons and not their maximum kinetic energy, and P has the higher frequency.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All three lights eject electrons, but those from light R have the smallest kinetic energy.', false, 'Light R is below the threshold frequency, so it ejects none.' from version_ins;
-- apchem-mcq-b2-sv-h-3.12-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.12-a-v2', 'mcq', 'separate frequency effects (KE, threshold) from intensity effects (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Light of frequency 8.0 × 10¹⁴ s⁻¹ ejects electrons from a metal with a threshold frequency of 5.0 × 10¹⁴ s⁻¹. Which change would double the number of electrons ejected per second without changing their maximum kinetic energy?', null, md5('apchem-mcq-b2-sv-h-3.12-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Double the frequency of the light at the same intensity.', false, 'Doubling the frequency raises the maximum kinetic energy, so that condition is not met.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Switch to a metal with a lower threshold frequency.', false, 'A lower threshold frequency lowers the work function, which raises the maximum kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Double the intensity of the light at the same frequency.', true, 'Correct: the electron count follows the number of photons, which rises with intensity; the maximum KE depends only on frequency and the metal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Halve the frequency of the light and double its intensity.', false, 'Halving the frequency to 4.0 × 10¹⁴ s⁻¹ goes below the threshold, so no electrons are ejected at all.' from version_ins;
-- apchem-mcq-b2-sv-h-3.12-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.12-a-v3', 'mcq', 'separate frequency effects (KE, threshold) from intensity effects (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two metals are lit with 450 nm light (photon energy 4.4 × 10⁻¹⁹ J). Metal 1 has a work function of 3.0 × 10⁻¹⁹ J and metal 2 has a work function of 4.5 × 10⁻¹⁹ J. Which statement is correct?', null, md5('apchem-mcq-b2-sv-h-3.12-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both metals emit electrons, and the electrons from metal 1 have the higher maximum kinetic energy.', false, 'The photon energy is below the work function of metal 2, so metal 2 emits no electrons.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Metal 1 emits electrons with a maximum kinetic energy of about 4.4 × 10⁻¹⁹ J, and metal 2 emits none.', false, 'The maximum kinetic energy is the photon energy minus the work function, not the photon energy itself.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Metal 1 emits electrons with a maximum kinetic energy of about 1.4 × 10⁻¹⁹ J, and metal 2 emits none whatever the intensity.', true, 'Correct: photon energy = 6.626 × 10⁻³⁴ × 3.00 × 10⁸ / 450 × 10⁻⁹ = 4.4 × 10⁻¹⁹ J; metal 1: KE = 4.4 - 3.0 = 1.4 × 10⁻¹⁹ J; metal 2: 4.4 < 4.5, so the photons are below its threshold.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Metal 1 emits electrons with a maximum kinetic energy of about 1.4 × 10⁻¹⁹ J, and metal 2 also emits at high intensity, with lower kinetic energy.', false, 'Electrons absorb one photon at a time, so a high intensity cannot make up for photons that are too low in energy.' from version_ins;
-- apchem-mcq-b2-h-3.12-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.12-b', 'mcq', 'threshold wavelength from photon energy and KE', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 400 nm ejects electrons from a metal with a maximum kinetic energy of 1.5 × 10⁻¹⁹ J. What is the threshold wavelength of the metal?', null, md5('apchem-mcq-b2-h-3.12-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '573 nm', true, 'Correct: E(photon) = 4.97 × 10⁻¹⁹ J; Φ = 4.97 × 10⁻¹⁹ - 1.5 × 10⁻¹⁹ = 3.47 × 10⁻¹⁹ J; λ₀ = hc/Φ = 573 nm.' from version_ins
union all select gen_random_uuid(), id, 'B', '307 nm', false, '307 nm adds the kinetic energy to the photon energy instead of subtracting it to find the work function.' from version_ins
union all select gen_random_uuid(), id, 'C', '400 nm', false, '400 nm treats the photon energy as the work function, which would leave no kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', '1330 nm', false, '1330 nm converts the kinetic energy itself into a wavelength, and the kinetic energy is not the work function.' from version_ins;
-- apchem-mcq-b2-sv-h-3.12-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.12-b-v1', 'mcq', 'threshold wavelength from photon energy and KE (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 300 nm ejects electrons from a metal with a maximum kinetic energy of 2.0 × 10⁻¹⁹ J. What is the threshold wavelength of the metal?', null, md5('apchem-mcq-b2-sv-h-3.12-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '230 nm', false, '230 nm adds the kinetic energy to the photon energy instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'B', '430 nm', true, 'Correct: E(photon) = 6.63 × 10⁻¹⁹ J; Φ = 6.63 × 10⁻¹⁹ - 2.0 × 10⁻¹⁹ = 4.63 × 10⁻¹⁹ J; λ₀ = hc/Φ = 430 nm.' from version_ins
union all select gen_random_uuid(), id, 'C', '300 nm', false, '300 nm treats the photon energy as the work function, which would leave no kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', '994 nm', false, '994 nm converts the kinetic energy itself into a wavelength.' from version_ins;
-- apchem-mcq-b2-sv-h-3.12-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.12-b-v2', 'mcq', 'threshold wavelength from photon energy and KE (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 250 nm ejects electrons from a metal with a maximum kinetic energy of 3.0 × 10⁻¹⁹ J. What is the threshold wavelength of the metal?', null, md5('apchem-mcq-b2-sv-h-3.12-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '182 nm', false, '182 nm adds the kinetic energy to the photon energy instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'B', '401 nm', true, 'Correct: E(photon) = 7.95 × 10⁻¹⁹ J; Φ = 7.95 × 10⁻¹⁹ - 3.0 × 10⁻¹⁹ = 4.95 × 10⁻¹⁹ J; λ₀ = hc/Φ = 401 nm.' from version_ins
union all select gen_random_uuid(), id, 'C', '250 nm', false, '250 nm treats the photon energy as the work function, which would leave no kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', '663 nm', false, '663 nm converts the kinetic energy itself into a wavelength.' from version_ins;
-- apchem-mcq-b2-sv-h-3.12-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.12-b-v3', 'mcq', 'threshold wavelength from photon energy and KE (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Use h = 6.626 × 10⁻³⁴ J·s and c = 3.00 × 10⁸ m/s. Light of wavelength 500 nm ejects electrons from a metal with a maximum kinetic energy of 8.0 × 10⁻²⁰ J. What is the threshold wavelength of the metal?', null, md5('apchem-mcq-b2-sv-h-3.12-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '626 nm', true, 'Correct: E(photon) = 3.98 × 10⁻¹⁹ J; Φ = 3.98 × 10⁻¹⁹ - 0.80 × 10⁻¹⁹ = 3.18 × 10⁻¹⁹ J; λ₀ = hc/Φ = 626 nm.' from version_ins
union all select gen_random_uuid(), id, 'B', '416 nm', false, '416 nm adds the kinetic energy to the photon energy instead of subtracting it.' from version_ins
union all select gen_random_uuid(), id, 'C', '500 nm', false, '500 nm treats the photon energy as the work function, which would leave no kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', '2490 nm', false, '2490 nm converts the kinetic energy itself into a wavelength.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.11-b-v3','apchem-mcq-b2-h-3.12-a','apchem-mcq-b2-sv-h-3.12-a-v1','apchem-mcq-b2-sv-h-3.12-a-v2','apchem-mcq-b2-sv-h-3.12-a-v3','apchem-mcq-b2-h-3.12-b','apchem-mcq-b2-sv-h-3.12-b-v1','apchem-mcq-b2-sv-h-3.12-b-v2','apchem-mcq-b2-sv-h-3.12-b-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-sv-h-3.11-b-v3','apchem-mcq-b2-h-3.12-a','apchem-mcq-b2-sv-h-3.12-a-v1','apchem-mcq-b2-sv-h-3.12-a-v2','apchem-mcq-b2-sv-h-3.12-a-v3','apchem-mcq-b2-h-3.12-b','apchem-mcq-b2-sv-h-3.12-b-v1','apchem-mcq-b2-sv-h-3.12-b-v2','apchem-mcq-b2-sv-h-3.12-b-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
