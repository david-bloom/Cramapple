begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-h-3.4-a','apchem-mcq-b2-sv-h-3.4-a-v1','apchem-mcq-b2-sv-h-3.4-a-v2','apchem-mcq-b2-sv-h-3.4-a-v3','apchem-mcq-b2-h-3.4-b','apchem-mcq-b2-sv-h-3.4-b-v1','apchem-mcq-b2-sv-h-3.4-b-v2','apchem-mcq-b2-sv-h-3.4-b-v3','apchem-mcq-b2-h-3.5-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apchem-mcq-b2-h-3.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.4-a', 'mcq', 'change two gas variables at once (T in kelvin, V) and combine the ratios', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gas in a cylinder with a movable piston is at 1.0 atm, 300 K and 4.0 L. It is heated to 600 K while the piston is moved so that the volume becomes 8.0 L. No gas enters or leaves. What is the final pressure?', null, md5('apchem-mcq-b2-h-3.4-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4.0 atm', false, '4.0 atm treats the doubled volume as if it also raised the pressure, so both factors of 2 are multiplied together.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.0 atm', false, '2.0 atm accounts for the temperature increase only and ignores the larger volume, which lowers the pressure.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.25 atm', false, '0.25 atm inverts the temperature relation as well, as if a hotter gas had a lower pressure.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.0 atm', true, 'Correct: P₂ = P₁ × (T₂/T₁) × (V₁/V₂) = 1.0 × 2 × 0.5 = 1.0 atm; the doubling of temperature is cancelled by the doubling of volume.' from version_ins;
-- apchem-mcq-b2-sv-h-3.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.4-a-v1', 'mcq', 'change two gas variables at once (T in kelvin, V) and combine the ratios (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gas at 2.0 atm and 27°C occupies 3.0 L in a cylinder with a movable piston. It is heated to 177°C and the piston is pushed in until the volume is 2.4 L. No gas leaves. What is the final pressure?', null, md5('apchem-mcq-b2-sv-h-3.4-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.5 atm', false, '2.5 atm accounts for the volume compression only and ignores that the gas was heated.' from version_ins
union all select gen_random_uuid(), id, 'B', '3.0 atm', false, '3.0 atm accounts for the temperature increase only and ignores the compression.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.75 atm', true, 'Correct: T₁ = 300 K and T₂ = 450 K, so P₂ = 2.0 × (450/300) × (3.0/2.4) = 2.0 × 1.5 × 1.25 = 3.75 atm.' from version_ins
union all select gen_random_uuid(), id, 'D', '16 atm', false, '16 atm uses the Celsius temperatures 177 and 27 instead of kelvin, which overstates the temperature ratio.' from version_ins;
-- apchem-mcq-b2-sv-h-3.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.4-a-v2', 'mcq', 'change two gas variables at once (T in kelvin, V) and combine the ratios (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 12.0 L sample of gas at 1.50 atm and 27°C is compressed to 4.0 L while it is cooled to -73°C. No gas leaves. What is the final pressure?', null, md5('apchem-mcq-b2-sv-h-3.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.0 atm', true, 'Correct: T₁ = 300 K and T₂ = 200 K, so P₂ = 1.50 × (200/300) × (12.0/4.0) = 1.50 × 0.667 × 3 = 3.0 atm.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.0 atm', false, '1.0 atm uses only the temperature ratio and forgets that the volume fell to one third.' from version_ins
union all select gen_random_uuid(), id, 'C', '4.5 atm', false, '4.5 atm uses only the volume ratio and forgets that cooling lowers the pressure.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.75 atm', false, '0.75 atm inverts the volume ratio and the temperature ratio, so the pressure falls when the gas is compressed.' from version_ins;
-- apchem-mcq-b2-sv-h-3.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.4-a-v3', 'mcq', 'change two gas variables at once (T in kelvin, V) and combine the ratios (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gas at 3.0 atm, 400 K and 6.0 L is allowed to expand to 9.0 L while its temperature is lowered to 300 K. No gas enters or leaves. What is the final pressure?', null, md5('apchem-mcq-b2-sv-h-3.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.25 atm', false, '2.25 atm accounts for the cooling only and ignores the expansion, which also lowers the pressure.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.0 atm', false, '2.0 atm accounts for the expansion only and ignores the cooling.' from version_ins
union all select gen_random_uuid(), id, 'C', '3.4 atm', false, '3.4 atm applies the volume ratio upside down (9.0/6.0), so it says the pressure rises when the gas expands.' from version_ins
union all select gen_random_uuid(), id, 'D', '1.5 atm', true, 'Correct: P₂ = 3.0 × (300/400) × (6.0/9.0) = 3.0 × 0.75 × 0.667 = 1.5 atm.' from version_ins;
-- apchem-mcq-b2-h-3.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.4-b', 'mcq', 'partial pressure in a mixture from moles, not mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid 10.0 L vessel at 300 K holds 4.0 g of H₂ (2.0 g/mol) and 32.0 g of O₂ (32.0 g/mol). Use R = 0.0821 L·atm/(mol·K). What is the partial pressure of O₂?', null, md5('apchem-mcq-b2-h-3.4-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2.46 atm', true, 'Correct: n(O₂) = 32.0/32.0 = 1.00 mol; P = nRT/V = 1.00 × 0.0821 × 300 / 10.0 = 2.46 atm. (n(H₂) = 2.0 mol, total pressure 7.39 atm.).' from version_ins
union all select gen_random_uuid(), id, 'B', '6.57 atm', false, '6.57 atm uses the mass fraction of O₂ (32/36) of the total pressure, but pressure fractions follow mole fractions, and H₂ has twice as many moles.' from version_ins
union all select gen_random_uuid(), id, 'C', '7.39 atm', false, '7.39 atm is the total pressure of both gases, not the share due to O₂.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.69 atm', false, '3.69 atm assumes the two gases split the pressure equally, which would need equal numbers of moles.' from version_ins;
-- apchem-mcq-b2-sv-h-3.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.4-b-v1', 'mcq', 'partial pressure in a mixture from moles, not mass (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid 5.00 L tank at 350 K holds 8.0 g of He (4.0 g/mol) and 28.0 g of N₂ (28.0 g/mol). Use R = 0.0821 L·atm/(mol·K). What is the partial pressure of N₂?', null, md5('apchem-mcq-b2-sv-h-3.4-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5.75 atm', true, 'Correct: n(He) = 2.0 mol and n(N₂) = 1.0 mol; P(N₂) = 1.0 × 0.0821 × 350 / 5.00 = 5.75 atm (total 17.2 atm).' from version_ins
union all select gen_random_uuid(), id, 'B', '17.2 atm', false, '17.2 atm is the total pressure of the mixture, not the part due to N₂.' from version_ins
union all select gen_random_uuid(), id, 'C', '13.4 atm', false, '13.4 atm uses the mass fraction of N₂ (28/36), but N₂ is only one third of the moles.' from version_ins
union all select gen_random_uuid(), id, 'D', '8.62 atm', false, '8.62 atm splits the total pressure equally between the two gases.' from version_ins;
-- apchem-mcq-b2-sv-h-3.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.4-b-v2', 'mcq', 'partial pressure in a mixture from moles, not mass (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid vessel at 300 K holds 2.0 g of H₂ (2.0 g/mol) and 16.0 g of CH₄ (16.0 g/mol). Which comparison of the partial pressures is correct?', null, md5('apchem-mcq-b2-sv-h-3.4-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CH₄ has a partial pressure 8 times that of H₂, because its mass is 8 times as large.', false, 'Pressure follows the number of moles, not the mass, and the mass ratio of 8 is cancelled by the molar mass ratio of 8.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H₂ has the greater partial pressure, because its molecules are faster.', false, 'H₂ molecules are faster, but they are also lighter, so each collision transfers less momentum, and the effects cancel at equal moles.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The partial pressures are essentially equal, because each gas is present at about 1 mol.', true, 'Correct: n(H₂) = 2.0/2.0 = 1.0 mol and n(CH₄) = 16.0/16.0 = 1.0 mol; same T and V, so equal partial pressures.' from version_ins
union all select gen_random_uuid(), id, 'D', 'H₂ has the greater partial pressure, because lighter molecules take up less space.', false, 'In an ideal gas the molecular size is ignored, so the size of the molecules does not set the partial pressure.' from version_ins;
-- apchem-mcq-b2-sv-h-3.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.4-b-v3', 'mcq', 'partial pressure in a mixture from moles, not mass (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid container holds 7.0 g of N₂ (28 g/mol) and 4.0 g of He (4.0 g/mol). The total pressure is 3.00 atm. What is the partial pressure of He?', null, md5('apchem-mcq-b2-sv-h-3.4-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.09 atm', false, '1.09 atm uses the mass fraction of He (4/11) as the pressure fraction, instead of the mole fraction.' from version_ins
union all select gen_random_uuid(), id, 'B', '1.50 atm', false, '1.50 atm splits the total pressure equally between the two gases.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.60 atm', false, '0.60 atm is the partial pressure of N₂, the other gas, so the wrong gas was chosen.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.40 atm', true, 'Correct: n(N₂) = 7.0/28 = 0.25 mol; n(He) = 4.0/4.0 = 1.0 mol; mole fraction of He = 1.0/1.25 = 0.80; P(He) = 0.80 × 3.00 = 2.40 atm.' from version_ins;
-- apchem-mcq-b2-h-3.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.5-a', 'mcq', 'read speed distributions as fractions of molecules', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of N₂(g) at 300 K has 10% of its molecules moving faster than 700 m/s. The sample is heated to 450 K in a rigid container. Which statement about the heated sample is correct?', null, md5('apchem-mcq-b2-h-3.5-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'More than 10% of the molecules move faster than 700 m/s, and some molecules still move more slowly than the average speed at 300 K.', true, 'Correct: raising T shifts the whole distribution to higher speeds, so the fraction above a fixed speed grows; the distribution still has a low-speed tail, so some molecules are slower than the old average.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fewer than 10% of the molecules move faster than 700 m/s, because the distribution becomes broader and flatter.', false, 'A broader and flatter curve still has more area at high speeds, so the fraction above 700 m/s grows with temperature.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Exactly 10% of the molecules move faster than 700 m/s, because that fraction depends only on the gas, not on temperature.', false, 'The fraction above a fixed speed depends strongly on temperature, because only the average kinetic energy scales simply.' from version_ins
union all select gen_random_uuid(), id, 'D', 'More than 10% of the molecules move faster than 700 m/s, and no molecule moves more slowly than the average speed at 300 K.', false, 'Temperature raises the average, but the distribution always keeps a tail of slow molecules, so a few molecules are still slower than the old average.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-h-3.4-a','apchem-mcq-b2-sv-h-3.4-a-v1','apchem-mcq-b2-sv-h-3.4-a-v2','apchem-mcq-b2-sv-h-3.4-a-v3','apchem-mcq-b2-h-3.4-b','apchem-mcq-b2-sv-h-3.4-b-v1','apchem-mcq-b2-sv-h-3.4-b-v2','apchem-mcq-b2-sv-h-3.4-b-v3','apchem-mcq-b2-h-3.5-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-h-3.4-a','apchem-mcq-b2-sv-h-3.4-a-v1','apchem-mcq-b2-sv-h-3.4-a-v2','apchem-mcq-b2-sv-h-3.4-a-v3','apchem-mcq-b2-h-3.4-b','apchem-mcq-b2-sv-h-3.4-b-v1','apchem-mcq-b2-sv-h-3.4-b-v2','apchem-mcq-b2-sv-h-3.4-b-v3','apchem-mcq-b2-h-3.5-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
