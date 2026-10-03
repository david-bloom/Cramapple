begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-005-v1','apchem-mcq-sv-005-v2','apchem-mcq-sv-005-v3','apchem-mcq-sv-006-v1','apchem-mcq-sv-006-v2','apchem-mcq-sv-006-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-005-v1 (seed apchem-mcq-005)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-005-v1', 'mcq', 'He and Kr kinetic energy', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 298 K, a sample of He gas and a sample of Kr gas are compared. Which statement correctly compares the particles in the two samples?', null, md5('apchem-mcq-sv-005-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average kinetic energies are equal, and He particles have the greater average speed.', true, 'Average kinetic energy depends only on Kelvin temperature, so both samples have the same average KE at 298 K. Since KE = 1/2 mv^2, equal KE with a smaller mass (He) requires a greater speed. He particles are faster on average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The average kinetic energies are equal, and Kr particles have the greater average speed.', false, 'Correctly states that average KE is the same, but then reverses the mass-speed relationship. With KE = 1/2 mv^2 held equal, the heavier Kr particles must move more slowly than He particles, not faster.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The Kr particles have the greater average kinetic energy because each particle has a greater mass.', false, 'Treats mass alone as determining kinetic energy. At the same Kelvin temperature the average KE of the two gases is identical; the greater mass of Kr is offset by its lower speed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The He particles have the greater average kinetic energy because they move faster on average.', false, 'Equates greater speed with greater kinetic energy while ignoring mass. Average KE is set by temperature alone and is identical for the two samples; He is faster only because its particles are lighter.' from version_ins
;
-- apchem-mcq-sv-005-v2 (seed apchem-mcq-005)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-005-v2', 'mcq', 'Ranking gas speeds at 400 K', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Samples of Ne, N₂, and Cl₂ gas are all at 400 K. Which ranking of average particle speeds, from greatest to least, is correct?', null, md5('apchem-mcq-sv-005-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cl₂ > N₂ > Ne', false, 'Lists the gases in order of decreasing molar mass (Cl₂ 71, N₂ 28, Ne 20 g/mol). This reverses the inverse relation between mass and speed: at equal average KE the heavier particles are slower, so Cl₂ is the slowest, not the fastest.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ne > N₂ > Cl₂', true, 'At the same temperature all particles have the same average kinetic energy, so average speed varies inversely with the square root of particle mass. Molar masses are Ne 20 g/mol, N₂ 28 g/mol, Cl₂ 71 g/mol, so the lightest (Ne) is fastest and the heaviest (Cl₂) is slowest.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ne = N₂ = Cl₂', false, 'Reasons that equal temperature means equal particle speed. Equal temperature gives equal average kinetic energy, not equal speed; with different masses the speeds differ (v is proportional to 1/sqrt(m) at fixed KE).' from version_ins
union all select gen_random_uuid(), id, 'D', 'N₂ = Cl₂ > Ne', false, 'Reasons that diatomic molecules carry more energy because they contain two atoms, so they must outrun a monatomic gas. The average translational KE depends only on temperature, not on atom count, and the much heavier Cl₂ is slower than Ne.' from version_ins
;
-- apchem-mcq-sv-005-v3 (seed apchem-mcq-005)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-005-v3', 'mcq', 'H₂ versus O₂ speed ratio', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 300 K, a sample of H₂ (molar mass 2.0 g/mol) and a sample of O₂ (molar mass 32 g/mol) are compared. Which statement correctly compares the average particle speeds?', null, md5('apchem-mcq-sv-005-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H₂ particles are 4 times as fast as O₂ particles.', true, 'Equal temperature means equal average KE: 1/2 m(H2)v(H2)^2 = 1/2 m(O2)v(O2)^2. Then v(H2)/v(O2) = sqrt(m(O2)/m(H2)) = sqrt(32/2.0) = sqrt(16) = 4.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H₂ particles are 16 times as fast as O₂ particles.', false, 'Uses the mass ratio 32/2.0 = 16 directly as the speed ratio. Since KE depends on v squared, the speed ratio is the square root of the mass ratio, sqrt(16) = 4, not 16.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H₂ particles are one-fourth as fast as O₂ particles.', false, 'Takes the square root correctly but inverts the ratio, sqrt(2.0/32) = 1/4, which would make the lighter H₂ the slower gas. The lighter particles must move faster to carry the same average KE.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H₂ and O₂ particles have the same average speed.', false, 'Takes equal temperature to mean equal speed. Equal temperature gives equal average kinetic energy; speeds differ because the masses differ (speed ratio 4).' from version_ins
;
-- apchem-mcq-sv-006-v1 (seed apchem-mcq-006)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-006-v1', 'mcq', 'Absorbance after fourfold dilution', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A copper(II) sulfate solution has an absorbance of 0.80 in a 1.0 cm cell. The solution is diluted with water to one-fourth of its original concentration. The absorbance of the diluted solution is approximately

Assume the diluted solution is measured at the same wavelength in the same 1.0 cm cell and remains in the linear Beer-Lambert range.', null, md5('apchem-mcq-sv-006-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.40', false, '0.80 / 2 = 0.40. Divides the absorbance by two instead of by four, as if the concentration had only been halved.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.20', true, 'Correct. With wavelength and path length unchanged, A = epsilon b c shows absorbance is directly proportional to concentration. One-fourth the concentration gives one-fourth the absorbance: 0.80 / 4 = 0.20.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.2', false, '0.80 x 4 = 3.2. Multiplies by the dilution factor instead of dividing, treating the solution as if it had become four times more concentrated.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.80', false, 'Assumes absorbance does not change when the concentration changes. Absorbance is directly proportional to concentration at fixed wavelength and path length, so it must fall to 0.20.' from version_ins
;
-- apchem-mcq-sv-006-v2 (seed apchem-mcq-006)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-006-v2', 'mcq', 'Absorbance in a longer cell', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dye solution has an absorbance of 0.45 at its wavelength of maximum absorbance in a 1.0 cm cell. The same solution is then placed in a 2.0 cm cell and measured at the same wavelength. The absorbance in the 2.0 cm cell is approximately

Assume the solution remains in the linear Beer-Lambert range.', null, md5('apchem-mcq-sv-006-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.225', false, '0.45 / 2 = 0.225. Divides by the path-length factor, treating absorbance as inversely related to path length. A longer path passes light through more absorbing particles, so absorbance increases.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.45', false, '0.45 + 1.0 = 1.45. Adds the 1.0 cm increase in path length to the absorbance instead of multiplying by the factor 2.0/1.0. Absorbance is proportional to b, not shifted by an additive amount, and the units do not match anyway.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.90', true, 'Correct. In A = epsilon b c, concentration and wavelength are unchanged, so absorbance is directly proportional to path length b. Doubling the path from 1.0 cm to 2.0 cm doubles the absorbance: 0.45 x 2 = 0.90.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.45', false, 'Assumes that because the concentration of the solution is unchanged, the absorbance is unchanged. Absorbance also depends directly on path length b, which doubled.' from version_ins
;
-- apchem-mcq-sv-006-v3 (seed apchem-mcq-006)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-006-v3', 'mcq', 'Unknown concentration from absorbance', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 0.020 M standard solution of a colored complex has an absorbance of 0.30. An unknown solution of the same complex has an absorbance of 0.75 under identical conditions. The concentration of the unknown solution is approximately

Assume both solutions are measured at the same wavelength in the same cell and remain in the linear Beer-Lambert range.', null, md5('apchem-mcq-sv-006-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.0080 M', false, '0.020 x (0.30 / 0.75) = 0.0080 M. Inverts the absorbance ratio, as if concentration were inversely proportional to absorbance. The unknown absorbs more strongly than the standard, so it must be more concentrated.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.015 M', false, '0.020 x 0.75 = 0.015 M. Multiplies the standard concentration by the absorbance value itself instead of by the ratio of absorbances. The result is also less than the standard''s 0.020 M even though the unknown absorbs more.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.5 M', false, '0.75 / 0.30 = 2.5. Computes the ratio of absorbances correctly but stops, reporting the ratio as the concentration instead of scaling the standard''s 0.020 M by it.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.050 M', true, 'Correct. With wavelength and path length fixed, A is directly proportional to c, so c(unknown) = 0.020 M x (0.75 / 0.30) = 0.020 M x 2.5 = 0.050 M.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-005-v1','apchem-mcq-sv-005-v2','apchem-mcq-sv-005-v3','apchem-mcq-sv-006-v1','apchem-mcq-sv-006-v2','apchem-mcq-sv-006-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
