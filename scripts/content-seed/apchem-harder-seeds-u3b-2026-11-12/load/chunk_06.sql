begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.9-b-v1','apchem-mcq-b2-sv-h-3.9-b-v2','apchem-mcq-b2-sv-h-3.9-b-v3','apchem-mcq-b2-h-3.10-a','apchem-mcq-b2-sv-h-3.10-a-v1','apchem-mcq-b2-sv-h-3.10-a-v2','apchem-mcq-b2-sv-h-3.10-a-v3','apchem-mcq-b2-h-3.10-b','apchem-mcq-b2-sv-h-3.10-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apchem-mcq-b2-sv-h-3.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.9-b-v1', 'mcq', 'order of elution or separation sequence from intermolecular forces (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mixture is separated on a column packed with a nonpolar stationary phase, using a polar mobile phase of water and methanol. Compound P is glucose (very polar), compound Q is benzoic acid (moderately polar) and compound R is a long-chain hydrocarbon (nonpolar). Which choice gives the order in which the compounds leave the column and a way to speed up the slowest one?', null, md5('apchem-mcq-b2-sv-h-3.9-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'R, then Q, then P; making the mobile phase more polar would speed up compound P.', false, 'This is the order for a polar stationary phase, and the polar compound is held longest there, not here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P, then Q, then R; making the mobile phase more polar would speed up compound R.', false, 'The order is right, but a more polar mobile phase would hold the nonpolar compound back even more.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P, then Q, then R; making the mobile phase less polar (more methanol) would speed up compound R.', true, 'Correct: a nonpolar stationary phase retains nonpolar compounds, so the polar glucose leaves first and the hydrocarbon last; a less polar mobile phase dissolves the hydrocarbon better and carries it along.' from version_ins
union all select gen_random_uuid(), id, 'D', 'R, then Q, then P; making the mobile phase less polar would speed up compound P.', false, 'The order is the reverse of the one expected for a nonpolar stationary phase.' from version_ins;
-- apchem-mcq-b2-sv-h-3.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.9-b-v2', 'mcq', 'order of elution or separation sequence from intermolecular forces (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mixture of pentane (boiling point 36°C), hexane (69°C) and heptane (98°C) is slowly heated in a fractional distillation setup. Which statement correctly gives the first liquid collected and the reason?', null, md5('apchem-mcq-b2-sv-h-3.9-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Heptane, because its larger molecules have stronger dispersion forces and escape the liquid most easily.', false, 'Stronger dispersion forces hold molecules in the liquid, so heptane has the highest boiling point and leaves last.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Hexane, because it is the middle component and reaches its boiling point first.', false, 'The order of vaporization follows the boiling points and not the position in the mixture, so hexane comes second.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All three together, because the liquids are miscible and cannot be separated by heating.', false, 'Miscible liquids with different boiling points are exactly what distillation separates.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Pentane, because its weaker dispersion forces give it the lowest boiling point, so it vaporizes first.', true, 'Correct: smaller nonpolar molecules have weaker dispersion forces and lower boiling points; the lowest-boiling component vaporizes first and is collected first.' from version_ins;
-- apchem-mcq-b2-sv-h-3.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.9-b-v3', 'mcq', 'order of elution or separation sequence from intermolecular forces (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student has a mixture of sand, dissolved NaCl and water. Which procedure recovers the sand, the salt and the water as separate samples?', null, md5('apchem-mcq-b2-sv-h-3.9-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Evaporate the water, then filter the remaining solids to separate the sand from the salt.', false, 'After evaporation the sand and salt are two dry solids, and filtering does not separate them; the water is also lost.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Filter the mixture to remove the sand, then distill the filtrate so that water is collected and the salt remains.', true, 'Correct: sand is insoluble and is removed by filtration; dissolved ions pass through the paper, and distillation separates water from the salt by boiling point.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Distill the mixture, then filter the distillate to remove the salt.', false, 'Distillation gives pure water in the distillate, which contains no salt to filter, and the sand is still in the flask.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Filter the mixture through paper to remove the dissolved NaCl, then boil the filtrate to recover the sand.', false, 'Dissolved ions pass through filter paper, so filtration cannot remove NaCl, and the sand would be caught on the paper instead.' from version_ins;
-- apchem-mcq-b2-h-3.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.10-a', 'mcq', 'crystallized mass from solubility-temperature data scaled by water mass', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate solubility of KNO₃ in water: 31 g per 100 g of water at 20°C; 85 g per 100 g at 50°C; 110 g per 100 g at 60°C; 170 g per 100 g at 80°C. A solution saturated at 50°C is made with 200 g of water and is then cooled to 20°C. What mass of KNO₃ crystallizes?', null, md5('apchem-mcq-b2-h-3.10-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '54 g', false, '54 g is the difference per 100 g of water (85 - 31), and it was not doubled for 200 g of water.' from version_ins
union all select gen_random_uuid(), id, 'B', '62 g', false, '62 g is the mass that stays dissolved at 20°C, not the mass that crystallizes.' from version_ins
union all select gen_random_uuid(), id, 'C', '170 g', false, '170 g is the total mass that was dissolved at 50°C, and it ignores the KNO₃ that stays in solution at 20°C.' from version_ins
union all select gen_random_uuid(), id, 'D', '108 g', true, 'Correct: dissolved at 50°C = 2 × 85 = 170 g; still dissolved at 20°C = 2 × 31 = 62 g; crystallized = 170 - 62 = 108 g.' from version_ins;
-- apchem-mcq-b2-sv-h-3.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.10-a-v1', 'mcq', 'crystallized mass from solubility-temperature data scaled by water mass (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate solubility of a salt Q in water: 22 g per 100 g of water at 40°C and 54 g per 100 g at 90°C. A solution saturated at 90°C is made with 150 g of water and is then cooled to 40°C. What mass of salt Q crystallizes?', null, md5('apchem-mcq-b2-sv-h-3.10-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '32 g', false, '32 g is the difference per 100 g of water (54 - 22), and it was not scaled for 150 g of water.' from version_ins
union all select gen_random_uuid(), id, 'B', '33 g', false, '33 g is the mass that stays dissolved at 40°C, not the mass that crystallizes.' from version_ins
union all select gen_random_uuid(), id, 'C', '81 g', false, '81 g is the total mass dissolved at 90°C, and it ignores the salt that stays in solution.' from version_ins
union all select gen_random_uuid(), id, 'D', '48 g', true, 'Correct: dissolved at 90°C = 1.5 × 54 = 81 g; still dissolved at 40°C = 1.5 × 22 = 33 g; crystallized = 81 - 33 = 48 g.' from version_ins;
-- apchem-mcq-b2-sv-h-3.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.10-a-v2', 'mcq', 'crystallized mass from solubility-temperature data scaled by water mass (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate solubility of KNO₃ in water: 31 g per 100 g of water at 20°C; 85 g per 100 g at 50°C; 110 g per 100 g at 60°C; 170 g per 100 g at 80°C. A solution is saturated at 20°C using 300 g of water and is then warmed to 60°C. What additional mass of KNO₃ can dissolve to give a saturated solution at 60°C?', null, md5('apchem-mcq-b2-sv-h-3.10-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '79 g', false, '79 g is the difference per 100 g of water (110 - 31), and it was not scaled for 300 g of water.' from version_ins
union all select gen_random_uuid(), id, 'B', '237 g', true, 'Correct: dissolved at 20°C = 3 × 31 = 93 g; capacity at 60°C = 3 × 110 = 330 g; additional = 330 - 93 = 237 g.' from version_ins
union all select gen_random_uuid(), id, 'C', '93 g', false, '93 g is the mass already dissolved at 20°C, not the additional amount.' from version_ins
union all select gen_random_uuid(), id, 'D', '330 g', false, '330 g is the total capacity at 60°C, and it ignores the KNO₃ already in solution.' from version_ins;
-- apchem-mcq-b2-sv-h-3.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.10-a-v3', 'mcq', 'crystallized mass from solubility-temperature data scaled by water mass (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate solubility of KNO₃ in water: 31 g per 100 g of water at 20°C; 85 g per 100 g at 50°C; 110 g per 100 g at 60°C; 170 g per 100 g at 80°C. A solution saturated at 80°C is made with 50.0 g of water and is then cooled to 20°C. What mass of KNO₃ remains dissolved at 20°C?', null, md5('apchem-mcq-b2-sv-h-3.10-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15.5 g', true, 'Correct: at 20°C, 50.0 g of water holds 0.500 × 31 = 15.5 g (69.5 g of the original 85 g crystallizes).' from version_ins
union all select gen_random_uuid(), id, 'B', '31 g', false, '31 g is the solubility per 100 g of water, and it was not scaled to 50.0 g of water.' from version_ins
union all select gen_random_uuid(), id, 'C', '69.5 g', false, '69.5 g is the mass that crystallizes, not the mass that remains dissolved.' from version_ins
union all select gen_random_uuid(), id, 'D', '85 g', false, '85 g is the mass that dissolved in 50.0 g of water at 80°C, before cooling.' from version_ins;
-- apchem-mcq-b2-h-3.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.10-b', 'mcq', 'gas solubility from partial pressure and air composition', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The solubility of O₂ in water at 25°C is 1.3 × 10⁻³ M for each 1.0 atm of O₂ partial pressure. Air is 21% O₂ by volume. Water is in equilibrium with air compressed to a total pressure of 3.0 atm. What is the concentration of dissolved O₂?', null, md5('apchem-mcq-b2-h-3.10-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3.9 × 10⁻³ M', false, '3.9 × 10⁻³ M uses the total pressure of 3.0 atm as if all of the gas were O₂.' from version_ins
union all select gen_random_uuid(), id, 'B', '2.7 × 10⁻⁴ M', false, '2.7 × 10⁻⁴ M is the value for air at 1.0 atm, so the increase to 3.0 atm was ignored.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.2 × 10⁻⁴ M', true, 'Correct: P(O₂) = 0.21 × 3.0 = 0.63 atm; [O₂] = 1.3 × 10⁻³ × 0.63 = 8.2 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'D', '2.1 × 10⁻³ M', false, '2.1 × 10⁻³ M divides the solubility by the partial pressure instead of multiplying.' from version_ins;
-- apchem-mcq-b2-sv-h-3.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.10-b-v1', 'mcq', 'gas solubility from partial pressure and air composition (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The solubility of N₂ in water at 25°C is 6.1 × 10⁻⁴ M for each 1.0 atm of N₂ partial pressure. Air is 78% N₂ by volume. Water is in equilibrium with air at a total pressure of 2.0 atm. What is the concentration of dissolved N₂?', null, md5('apchem-mcq-b2-sv-h-3.10-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1.2 × 10⁻³ M', false, '1.2 × 10⁻³ M uses the total pressure of 2.0 atm as if the gas were pure N₂.' from version_ins
union all select gen_random_uuid(), id, 'B', '4.8 × 10⁻⁴ M', false, '4.8 × 10⁻⁴ M is the value for air at 1.0 atm, so the doubling of the pressure was ignored.' from version_ins
union all select gen_random_uuid(), id, 'C', '9.5 × 10⁻⁴ M', true, 'Correct: P(N₂) = 0.78 × 2.0 = 1.56 atm; [N₂] = 6.1 × 10⁻⁴ × 1.56 = 9.5 × 10⁻⁴ M.' from version_ins
union all select gen_random_uuid(), id, 'D', '3.9 × 10⁻⁴ M', false, '3.9 × 10⁻⁴ M divides the solubility by the partial pressure instead of multiplying.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.9-b-v1','apchem-mcq-b2-sv-h-3.9-b-v2','apchem-mcq-b2-sv-h-3.9-b-v3','apchem-mcq-b2-h-3.10-a','apchem-mcq-b2-sv-h-3.10-a-v1','apchem-mcq-b2-sv-h-3.10-a-v2','apchem-mcq-b2-sv-h-3.10-a-v3','apchem-mcq-b2-h-3.10-b','apchem-mcq-b2-sv-h-3.10-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-sv-h-3.9-b-v1','apchem-mcq-b2-sv-h-3.9-b-v2','apchem-mcq-b2-sv-h-3.9-b-v3','apchem-mcq-b2-h-3.10-a','apchem-mcq-b2-sv-h-3.10-a-v1','apchem-mcq-b2-sv-h-3.10-a-v2','apchem-mcq-b2-sv-h-3.10-a-v3','apchem-mcq-b2-h-3.10-b','apchem-mcq-b2-sv-h-3.10-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
