begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-h-3.13-a','apchem-mcq-b2-sv-h-3.13-a-v1','apchem-mcq-b2-sv-h-3.13-a-v2','apchem-mcq-b2-sv-h-3.13-a-v3','apchem-mcq-b2-h-3.13-b','apchem-mcq-b2-sv-h-3.13-b-v1','apchem-mcq-b2-sv-h-3.13-b-v2','apchem-mcq-b2-sv-h-3.13-b-v3'])) then raise exception 'chunk 9 already loaded'; end if;
end $$;
-- apchem-mcq-b2-h-3.13-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.13-a', 'mcq', 'calibration data plus undoing dilutions (and path length)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A calibration set for a colored complex, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.160 at 2.0 × 10⁻⁵ M, 0.320 at 4.0 × 10⁻⁵ M, 0.480 at 6.0 × 10⁻⁵ M and 0.640 at 8.0 × 10⁻⁵ M. A 5.00 mL sample of an unknown solution is diluted with water to a final volume of 50.0 mL. The diluted solution has an absorbance of 0.400 in the same cuvette. What is the concentration of the original unknown solution?', null, md5('apchem-mcq-b2-h-3.13-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.0 × 10⁻⁵ M', false, '5.0 × 10⁻⁵ M is the concentration in the diluted solution, and the dilution factor was not applied.' from version_ins
union all select gen_random_uuid(), id, 'B', '5.5 × 10⁻⁴ M', false, '5.5 × 10⁻⁴ M treats 50.0 mL as the volume of water added, giving a total of 55.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'C', '5.0 × 10⁻⁴ M', true, 'Correct: the slope is 0.160 / 2.0 × 10⁻⁵ = 8.0 × 10³ M⁻¹; diluted c = 0.400 / 8.0 × 10³ = 5.0 × 10⁻⁵ M; original = 5.0 × 10⁻⁵ × (50.0/5.00) = 5.0 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'D', '5.0 × 10⁻⁶ M', false, '5.0 × 10⁻⁶ M divides by the dilution factor instead of multiplying by it.' from version_ins;
-- apchem-mcq-b2-sv-h-3.13-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.13-a-v1', 'mcq', 'calibration data plus undoing dilutions (and path length) (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A calibration set for a dye, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.120 at 1.0 × 10⁻⁵ M, 0.240 at 2.0 × 10⁻⁵ M, 0.360 at 3.0 × 10⁻⁵ M and 0.480 at 4.0 × 10⁻⁵ M. A 2.00 mL sample of an unknown solution is diluted with water to a final volume of 25.0 mL. The diluted solution has an absorbance of 0.288 in the same cuvette. What is the concentration of the original unknown solution?', null, md5('apchem-mcq-b2-sv-h-3.13-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.00 × 10⁻⁴ M', true, 'Correct: the slope is 0.120 / 1.0 × 10⁻⁵ = 1.2 × 10⁴ M⁻¹; diluted c = 0.288 / 1.2 × 10⁴ = 2.4 × 10⁻⁵ M; original = 2.4 × 10⁻⁵ × (25.0/2.00) = 3.00 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.4 × 10⁻⁵ M', false, '2.4 × 10⁻⁵ M is the concentration in the diluted solution, and the dilution factor was not applied.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.24 × 10⁻⁴ M', false, '3.24 × 10⁻⁴ M treats 25.0 mL as the volume of water added, giving a total of 27.0 mL.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.9 × 10⁻⁶ M', false, '1.9 × 10⁻⁶ M divides by the dilution factor instead of multiplying by it.' from version_ins;
-- apchem-mcq-b2-sv-h-3.13-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.13-a-v2', 'mcq', 'calibration data plus undoing dilutions (and path length) (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A calibration set for a complex, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.200 at 5.0 × 10⁻⁵ M, 0.400 at 1.0 × 10⁻⁴ M, 0.600 at 1.5 × 10⁻⁴ M and 0.800 at 2.0 × 10⁻⁴ M. A 10.0 mL sample of an unknown solution is diluted with water to a final volume of 100.0 mL. The diluted solution is measured in a 2.00 cm cuvette and has an absorbance of 0.560. What is the concentration of the original unknown solution?', null, md5('apchem-mcq-b2-sv-h-3.13-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.4 × 10⁻³ M', false, '1.4 × 10⁻³ M uses the 1.00 cm calibration slope directly and ignores that the sample was measured in a cuvette twice as long.' from version_ins
union all select gen_random_uuid(), id, 'B', '7.0 × 10⁻⁴ M', true, 'Correct: the slope for 1.00 cm is 4.0 × 10³ M⁻¹ (that is, ε·1.00 cm); with b = 2.00 cm, c = 0.560 / (4.0 × 10³ × 2.00) = 7.0 × 10⁻⁵ M; original = 7.0 × 10⁻⁵ × (100.0/10.0) = 7.0 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'C', '7.0 × 10⁻⁵ M', false, '7.0 × 10⁻⁵ M is the concentration in the diluted solution, and the dilution factor was not applied.' from version_ins
union all select gen_random_uuid(), id, 'D', '7.7 × 10⁻⁴ M', false, '7.7 × 10⁻⁴ M treats 100.0 mL as the volume of water added, giving a total of 110.0 mL.' from version_ins;
-- apchem-mcq-b2-sv-h-3.13-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.13-a-v3', 'mcq', 'calibration data plus undoing dilutions (and path length) (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A calibration set for a complex, measured at its wavelength of maximum absorbance in a 1.00 cm cuvette, gives these absorbances: 0.150 at 1.0 × 10⁻⁵ M, 0.300 at 2.0 × 10⁻⁵ M, 0.450 at 3.0 × 10⁻⁵ M and 0.600 at 4.0 × 10⁻⁵ M. A 1.00 mL sample of an unknown solution is diluted to a final volume of 100.0 mL. Then 10.0 mL of that solution is diluted to a final volume of 50.0 mL. The final solution has an absorbance of 0.375 in the same cuvette. What is the concentration of the original unknown solution?', null, md5('apchem-mcq-b2-sv-h-3.13-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.25 × 10⁻² M', true, 'Correct: the slope is 0.150 / 1.0 × 10⁻⁵ = 1.5 × 10⁴ M⁻¹; final c = 0.375 / 1.5 × 10⁴ = 2.5 × 10⁻⁵ M; original = 2.5 × 10⁻⁵ × (50.0/10.0) × (100.0/1.00) = 1.25 × 10⁻² M.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.5 × 10⁻⁵ M', false, '2.5 × 10⁻⁵ M is the concentration of the final solution, and neither dilution was undone.' from version_ins
union all select gen_random_uuid(), id, 'C', '2.5 × 10⁻³ M', false, '2.5 × 10⁻³ M undoes only the first dilution (factor 100) and leaves out the second dilution.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.25 × 10⁻⁴ M', false, '1.25 × 10⁻⁴ M undoes only the second dilution (factor 5) and leaves out the first dilution.' from version_ins;
-- apchem-mcq-b2-h-3.13-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.13-b', 'mcq', 'absorbance linear versus percent transmittance logarithmic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A colored solution in a 1.00 cm cuvette transmits 50.0% of the light at its wavelength of maximum absorbance (A = 0.301, using A = -log₁₀ T). The concentration is then tripled and the same cuvette and wavelength are used. What percent of the light is transmitted?', null, md5('apchem-mcq-b2-h-3.13-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16.7%', false, '16.7% divides the transmittance by 3, but the transmittance changes exponentially with concentration and not linearly.' from version_ins
union all select gen_random_uuid(), id, 'B', '12.5%', true, 'Correct: A is proportional to c, so A = 3 × 0.301 = 0.903; T = 10⁻⁰·⁹⁰³ = 0.125, or 12.5%.' from version_ins
union all select gen_random_uuid(), id, 'C', '25.0%', false, '25.0% is the transmittance for a doubled concentration, so the factor of 3 was treated as 2.' from version_ins
union all select gen_random_uuid(), id, 'D', '33%', false, '33% multiplies the transmittance by two thirds, which is not the relationship in the Beer-Lambert law.' from version_ins;
-- apchem-mcq-b2-sv-h-3.13-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.13-b-v1', 'mcq', 'absorbance linear versus percent transmittance logarithmic (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solution in a 2.00 cm cuvette transmits 25.0% of the light at its wavelength of maximum absorbance (A = 0.602, using A = -log₁₀ T). The same solution is then placed in a 1.00 cm cuvette. What percent of the light is transmitted?', null, md5('apchem-mcq-b2-sv-h-3.13-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '12.5%', false, '12.5% halves the transmittance, but a shorter path lets more light through, and the relation is logarithmic.' from version_ins
union all select gen_random_uuid(), id, 'B', '37.5%', false, '37.5% takes half of the 75% of light absorbed and reports it as the percent transmitted.' from version_ins
union all select gen_random_uuid(), id, 'C', '62.5%', false, '62.5% halves the percent absorbed (75% to 37.5%) and subtracts from 100%, but absorbance, not percent absorbed, is proportional to path length.' from version_ins
union all select gen_random_uuid(), id, 'D', '50.0%', true, 'Correct: A is proportional to path length, so A = 0.602 / 2 = 0.301; T = 10⁻⁰·³⁰¹ = 0.500, or 50.0%.' from version_ins;
-- apchem-mcq-b2-sv-h-3.13-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.13-b-v2', 'mcq', 'absorbance linear versus percent transmittance logarithmic (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solution in a 1.00 cm cuvette transmits 10.0% of the light at its wavelength of maximum absorbance (A = 1.000, using A = -log₁₀ T). The solution is diluted to one quarter of its original concentration and measured in the same cuvette. What percent of the light is transmitted?', null, md5('apchem-mcq-b2-sv-h-3.13-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.5%', false, '2.5% divides the transmittance by 4, which is the wrong direction, since dilution lets more light through.' from version_ins
union all select gen_random_uuid(), id, 'B', '40%', false, '40% multiplies the transmittance by 4, but the transmittance changes exponentially with concentration.' from version_ins
union all select gen_random_uuid(), id, 'C', '77.5%', false, '77.5% divides the percent absorbed (90%) by 4 and subtracts the result from 100%, but absorbance is proportional to concentration, not the percent absorbed.' from version_ins
union all select gen_random_uuid(), id, 'D', '56%', true, 'Correct: A is proportional to c, so A = 1.000 / 4 = 0.250; T = 10⁻⁰·²⁵⁰ = 0.562, or 56%.' from version_ins;
-- apchem-mcq-b2-sv-h-3.13-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.13-b-v3', 'mcq', 'absorbance linear versus percent transmittance logarithmic (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A solution in a 1.00 cm cuvette transmits 60.0% of the light at its wavelength of maximum absorbance (A = 0.222, using A = -log₁₀ T). The concentration is increased to 4 times its original value and measured in the same cuvette. What percent of the light is transmitted?', null, md5('apchem-mcq-b2-sv-h-3.13-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15%', false, '15% divides the transmittance by 4, but the transmittance changes exponentially with concentration.' from version_ins
union all select gen_random_uuid(), id, 'B', '36%', false, '36% squares the transmittance, which corresponds to doubling the concentration and not to quadrupling it.' from version_ins
union all select gen_random_uuid(), id, 'C', '13%', true, 'Correct: A = 4 × 0.222 = 0.888; T = 10⁻⁰·⁸⁸⁸ = 0.129, or about 13%.' from version_ins
union all select gen_random_uuid(), id, 'D', '25%', false, '25% takes one quarter of the incident light and ignores the 60% that was already transmitted.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-h-3.13-a','apchem-mcq-b2-sv-h-3.13-a-v1','apchem-mcq-b2-sv-h-3.13-a-v2','apchem-mcq-b2-sv-h-3.13-a-v3','apchem-mcq-b2-h-3.13-b','apchem-mcq-b2-sv-h-3.13-b-v1','apchem-mcq-b2-sv-h-3.13-b-v2','apchem-mcq-b2-sv-h-3.13-b-v3']) and status='draft')<>8 then raise exception 'chunk 9: expected 8 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-h-3.13-a','apchem-mcq-b2-sv-h-3.13-a-v1','apchem-mcq-b2-sv-h-3.13-a-v2','apchem-mcq-b2-sv-h-3.13-a-v3','apchem-mcq-b2-h-3.13-b','apchem-mcq-b2-sv-h-3.13-b-v1','apchem-mcq-b2-sv-h-3.13-b-v2','apchem-mcq-b2-sv-h-3.13-b-v3']))<>32 then raise exception 'chunk 9: expected 32 choices'; end if;
end $$;
commit;
