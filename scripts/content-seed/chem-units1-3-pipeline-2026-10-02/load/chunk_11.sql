begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-036-v1','apchem-mcq-sv-036-v2','apchem-mcq-sv-036-v3','apchem-mcq-sv-037-v1','apchem-mcq-sv-037-v2','apchem-mcq-sv-037-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-036-v1 (seed apchem-mcq-036)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-036-v1', 'mcq', 'Dye concentration from absorbance', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spectrophotometer set to the wavelength of maximum absorbance gives an absorbance of 0.360 for a dye solution in a cuvette with a 1.00 cm path length. The molar absorptivity of the dye at this wavelength is 2.40 x 10^4 M^-1 cm^-1. What is the molar concentration of the dye?', null, md5('apchem-mcq-sv-036-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.60 x 10^-1 M', false, 'Incorrect. This reports the absorbance value 0.360 as the concentration, ignoring ε and b entirely.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.67 x 10^4 M', false, 'Incorrect. This computes εb/A = (2.40 x 10^4)(1.00)/0.360 = 6.67 x 10^4, which inverts the correct rearrangement of A = εbc.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.64 x 10^3 M', false, 'Incorrect. This multiplies A by ε and b (0.360 x 2.40 x 10^4 x 1.00 = 8.64 x 10^3) instead of dividing A by εb.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.50 x 10^-5 M', true, 'Correct. Rearranging A = εbc gives c = A/(εb) = 0.360/[(2.40 x 10^4 M^-1 cm^-1)(1.00 cm)] = 1.50 x 10^-5 M.' from version_ins
;
-- apchem-mcq-sv-036-v2 (seed apchem-mcq-036)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-036-v2', 'mcq', 'Concentration in a longer cuvette', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chemist measures a solution of a colored complex ion in a cuvette with a 2.00 cm path length at the complex''s wavelength of maximum absorbance and records an absorbance of 0.425. At this wavelength the molar absorptivity of the complex is 8.50 x 10^2 M^-1 cm^-1. What is the concentration of the complex?', null, md5('apchem-mcq-sv-036-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.00 x 10^-4 M', false, 'Incorrect. This divides A by ε only (0.425/850 = 5.00 x 10^-4) and ignores the 2.00 cm path length, so the result is twice the correct value.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.50 x 10^-4 M', true, 'Correct. c = A/(εb) = 0.425/[(8.50 x 10^2 M^-1 cm^-1)(2.00 cm)] = 0.425/1.70 x 10^3 = 2.50 x 10^-4 M.' from version_ins
union all select gen_random_uuid(), id, 'C', '1.00 x 10^-3 M', false, 'Incorrect. This multiplies by the path length instead of dividing by it: c = Ab/ε = (0.425)(2.00)/850 = 1.00 x 10^-3 M.' from version_ins
union all select gen_random_uuid(), id, 'D', '4.00 x 10^3 M', false, 'Incorrect. This computes εb/A = (850)(2.00)/0.425 = 4.00 x 10^3, inverting the correct rearrangement of A = εbc.' from version_ins
;
-- apchem-mcq-sv-036-v3 (seed apchem-mcq-036)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-036-v3', 'mcq', 'Solve for path length', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.50 x 10^-5 M solution of an organic dye has an absorbance of 0.600 at its wavelength of maximum absorbance, where its molar absorptivity is 1.20 x 10^4 M^-1 cm^-1. What is the path length of the cuvette used?', null, md5('apchem-mcq-sv-036-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.500 cm', false, 'Incorrect. This computes εc/A = 0.300/0.600 = 0.500, inverting the correct rearrangement of A = εbc.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.00 x 10^-5 cm', false, 'Incorrect. This divides A by ε only (0.600/1.20 x 10^4 = 5.00 x 10^-5) and leaves out the concentration c.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.180 cm', false, 'Incorrect. This multiplies A by ε and c (0.600 x 0.300 = 0.180) instead of dividing A by εc.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.00 cm', true, 'Correct. Rearranging A = εbc gives b = A/(εc) = 0.600/[(1.20 x 10^4 M^-1 cm^-1)(2.50 x 10^-5 M)] = 0.600/0.300 = 2.00 cm.' from version_ins
;
-- apchem-mcq-sv-037-v1 (seed apchem-mcq-037)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-037-v1', 'mcq', 'Blue versus red laser', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A blue laser pointer emits photons of wavelength 450 nm, and a red laser pointer emits photons of wavelength 650 nm. Which statement correctly compares the energy of a single photon from each laser and justifies the comparison?', null, md5('apchem-mcq-sv-037-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A blue photon has more energy than a red photon because its shorter wavelength corresponds to a higher frequency, and photon energy is directly proportional to frequency (E = hν).', true, 'Correct. From c = λν, a shorter wavelength means a higher frequency, and E = hν shows photon energy is directly proportional to frequency. The 450 nm photon therefore has more energy than the 650 nm photon.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A red photon has more energy than a blue photon because its longer wavelength corresponds to a lower frequency, and photon energy is inversely proportional to frequency.', false, 'Incorrect. The wavelength-frequency relationship is right, but photon energy is directly proportional to frequency (E = hν), not inversely. The lower-frequency red photon has less energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A blue photon has more energy than a red photon because it has a shorter wavelength, and photon energy is directly proportional to wavelength.', false, 'Incorrect. The ranking is right but the justification is wrong: energy is proportional to frequency and inversely proportional to wavelength (E = hc/λ). Direct proportionality to wavelength would give the red photon more energy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two photons have equal energy because both lasers emit visible light that travels at 3.00 x 10^8 m/s in a vacuum.', false, 'Incorrect. Both do travel at c in a vacuum, but speed does not set photon energy; their different frequencies (c/λ) give different energies E = hν.' from version_ins
;
-- apchem-mcq-sv-037-v2 (seed apchem-mcq-037)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-037-v2', 'mcq', 'X-ray versus microwave photon', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dental X-ray machine produces photons of wavelength about 0.1 nm, and a household microwave oven produces photons of wavelength about 12 cm. Assume the microwave oven''s beam is far more intense (it delivers more total energy each second) than the X-ray beam. Which statement correctly compares the energy of a single photon of each type?', null, md5('apchem-mcq-sv-037-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A single microwave photon carries more energy than a single X-ray photon, because a 12 cm wave is physically larger than a 0.1 nm wave and larger waves carry more energy.', false, 'Incorrect. Energy per photon increases with frequency, not with the physical size of the wave. The longer-wavelength microwave has a much lower frequency and therefore a much lower photon energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A single microwave photon carries more energy than a single X-ray photon, because the microwave beam is more intense and delivers more total energy.', false, 'Incorrect. Intensity depends on how many photons arrive per second as well as the energy per photon. A more intense beam of low-energy photons can still have a lower energy per photon than a weak beam of high-energy photons.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A single X-ray photon carries more energy than a single microwave photon, because shorter-wavelength radiation travels faster through a vacuum.', false, 'Incorrect. The ranking is right but the reason is wrong: all electromagnetic radiation travels at c in a vacuum. The X-ray photon has more energy because its frequency is greater (E = hν).' from version_ins
union all select gen_random_uuid(), id, 'D', 'A single X-ray photon carries far more energy than a single microwave photon, because its far shorter wavelength means a far greater frequency (c = λν) and E = hν.', true, 'Correct. Using c = λν, the 0.1 nm X-ray photon has a frequency about 10^9 times greater than the 12 cm microwave photon, and E = hν then gives it far greater energy per photon. A beam''s intensity depends on both the number of photons per second and the energy of each photon, so a more intense beam does not mean more energy per photon.' from version_ins
;
-- apchem-mcq-sv-037-v3 (seed apchem-mcq-037)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-037-v3', 'mcq', 'Compare photon given λ and ν', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Photon P has a wavelength of 5.0 x 10^-7 m. Photon Q has a frequency of 4.0 x 10^14 s^-1. (Take the speed of light as 3.0 x 10^8 m/s.) Which statement correctly compares the energies of the two photons?', null, md5('apchem-mcq-sv-037-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The two photons have equal energy, because both travel at 3.0 x 10^8 m/s in a vacuum regardless of wavelength or frequency.', false, 'Incorrect. Equal speed does not imply equal energy; ν = 6.0 x 10^14 s^-1 for P and 4.0 x 10^14 s^-1 for Q, so E = hν differs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Photon Q has more energy, because its given value of 4.0 x 10^14 is numerically far larger than the 5.0 x 10^-7 given for photon P.', false, 'Incorrect. This compares the two numbers directly even though one is a frequency (s^-1) and the other a wavelength (m). They must be converted to a common quantity (ν = c/λ) before comparing energies.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Photon Q has about 1.5 times the energy of photon P, because λ = c/ν = 7.5 x 10^-7 m for Q, which is longer than 5.0 x 10^-7 m for P.', false, 'Incorrect. The conversion λ = c/ν = 7.5 x 10^-7 m is right, but a longer wavelength means a lower frequency and lower energy, so Q has less energy. The ratio 7.5/5.0 = 1.5 is applied to the wrong photon.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Photon P has about 1.5 times the energy of photon Q, because ν = c/λ = 6.0 x 10^14 s^-1 for P, which is greater than 4.0 x 10^14 s^-1 for Q.', true, 'Correct. The frequency of P is ν = c/λ = (3.0 x 10^8 m/s)/(5.0 x 10^-7 m) = 6.0 x 10^14 s^-1. Since E = hν, the energy ratio E_P/E_Q = (6.0 x 10^14)/(4.0 x 10^14) = 1.5.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-036-v1','apchem-mcq-sv-036-v2','apchem-mcq-sv-036-v3','apchem-mcq-sv-037-v1','apchem-mcq-sv-037-v2','apchem-mcq-sv-037-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
