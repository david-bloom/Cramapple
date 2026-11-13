begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.5-a-v1','apchem-mcq-b2-sv-h-3.5-a-v2','apchem-mcq-b2-sv-h-3.5-a-v3','apchem-mcq-b2-h-3.5-b','apchem-mcq-b2-sv-h-3.5-b-v1','apchem-mcq-b2-sv-h-3.5-b-v2','apchem-mcq-b2-sv-h-3.5-b-v3','apchem-mcq-b2-h-3.6-a','apchem-mcq-b2-sv-h-3.6-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apchem-mcq-b2-sv-h-3.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.5-a-v1', 'mcq', 'read speed distributions as fractions of molecules (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 200 K, 15% of the Ar atoms in a sample move more slowly than 150 m/s. The sample is heated to 400 K in a rigid container. Which statement about the heated sample is correct?', null, md5('apchem-mcq-b2-sv-h-3.5-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fewer than 15% move more slowly than 150 m/s, and the average speed doubles.', false, 'Average speed is proportional to the square root of T, so doubling T raises the speed by about 1.41, not 2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'More than 15% move more slowly than 150 m/s, because collisions slow some atoms down.', false, 'More collisions at higher temperature exchange energy but do not change the overall trend, and the average speed rises, so the slow fraction falls.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fewer than 15% move more slowly than 150 m/s, and the average kinetic energy doubles.', true, 'Correct: heating shifts the distribution upward, so the fraction below a fixed low speed falls; average kinetic energy is proportional to T, so it doubles, while the average speed rises only by a factor of √2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Exactly 15% move more slowly than 150 m/s, and the average kinetic energy doubles.', false, 'The slow fraction cannot stay fixed while the whole distribution moves to higher speed.' from version_ins;
-- apchem-mcq-b2-sv-h-3.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.5-a-v2', 'mcq', 'read speed distributions as fractions of molecules (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'He(g) and Ne(g) are in separate containers at the same temperature, 300 K. Which statement correctly compares their speeds?', null, md5('apchem-mcq-b2-sv-h-3.5-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Every He atom moves faster than every Ne atom, because He atoms are lighter.', false, 'The distributions overlap, so the fastest Ne atoms move faster than the slowest He atoms.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A larger fraction of He atoms than Ne atoms moves faster than any chosen high speed, although the distributions overlap so some Ne atoms are faster than some He atoms.', true, 'Correct: equal T gives equal average KE; He is lighter so its distribution is shifted to higher speeds, but both are broad curves that overlap.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The fraction of atoms above any given speed is the same for both gases, because the average kinetic energies are equal.', false, 'Equal average kinetic energy does not give equal speeds, because lighter atoms need a higher speed to have the same energy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A larger fraction of Ne atoms than He atoms moves faster than any chosen speed, because Ne atoms have more momentum.', false, 'Momentum differences do not raise speeds; at equal energy the heavier atoms move more slowly.' from version_ins;
-- apchem-mcq-b2-sv-h-3.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.5-a-v3', 'mcq', 'read speed distributions as fractions of molecules (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The speed distribution of CO₂(g) at 300 K is compared with that of the same sample of CO₂(g) at 600 K. Which description of the 600 K curve, relative to the 300 K curve, is correct?', null, md5('apchem-mcq-b2-sv-h-3.5-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The peak is higher and narrower, because the molecules are more energetic and more alike.', false, 'A wider range of speeds means a lower, broader curve, not a narrower one.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The peak is at the same speed but taller, because more molecules reach that speed.', false, 'The most probable speed rises with temperature, so the peak moves.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The peak is at a higher speed with the same height, and the area is larger because the molecules are more energetic.', false, 'The area under the curve represents the total number of molecules, which does not change when the gas is heated.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The peak is lower, broader and at a higher speed, and the area under the curve is the same.', true, 'Correct: heating moves the most probable speed up, spreads the speeds over a wider range, so the peak lowers; the number of molecules, and so the area, is unchanged.' from version_ins;
-- apchem-mcq-b2-h-3.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.5-b', 'mcq', 'separate collision frequency, momentum per collision and speed in pressure', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two rigid 2.0 L flasks at 300 K each hold 1.0 mol of gas. One holds He and the other holds Ar. Their pressures are equal. Which statement best explains this using kinetic molecular theory?', null, md5('apchem-mcq-b2-h-3.5-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The He atoms are faster, so they hit the walls harder and the pressure should be higher, but Ar atoms are heavier, which makes up the difference.', false, 'The equality does come from a balance between speed and mass, but the pressure is not higher for He, because the two effects exactly cancel; the statement contradicts the given equal pressures.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The He atoms hit the walls more often, but each collision transfers less momentum, so the pressure is the same.', true, 'Correct: same T gives the same average KE; He is lighter and faster, so more collisions per second, each with a smaller momentum change; with equal n, V, T the pressures are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The Ar atoms are heavier, so they have more kinetic energy and make a higher pressure than He.', false, 'The average kinetic energy depends only on temperature, so Ar atoms do not have more kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both gases have the same average speed at the same temperature, so the pressures are equal.', false, 'At the same temperature lighter atoms are faster, so the average speeds are not the same.' from version_ins;
-- apchem-mcq-b2-sv-h-3.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.5-b-v1', 'mcq', 'separate collision frequency, momentum per collision and speed in pressure (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid container of Ne(g) is heated from 300 K to 600 K. The pressure doubles. Which statement best explains the doubling?', null, md5('apchem-mcq-b2-sv-h-3.5-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average speed doubles, so the pressure doubles.', false, 'The average speed rises by √2, not by a factor of 2; the pressure doubles because speed enters twice.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The atoms strike the walls twice as often, with the same momentum per collision.', false, 'The collision frequency rises by √2 only, and the momentum per collision also rises.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The atoms strike the walls about √2 times as often and with about √2 times the momentum per collision.', true, 'Correct: speed ∝ √T, so doubling T raises the speed by √2; collision frequency ∝ speed and momentum per collision ∝ speed, so pressure ∝ speed² ∝ T, which doubles.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The atoms strike the walls at the same rate, but the momentum per collision doubles.', false, 'Faster atoms also reach the walls more often, so the collision rate does not stay the same.' from version_ins;
-- apchem-mcq-b2-sv-h-3.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.5-b-v2', 'mcq', 'separate collision frequency, momentum per collision and speed in pressure (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of gas in a cylinder is compressed to half its volume at constant temperature, and the pressure doubles. Which statement best explains the pressure change?', null, md5('apchem-mcq-b2-sv-h-3.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The average speed of the molecules doubles because the molecules are closer together.', false, 'Speed depends on temperature, and the temperature is constant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The collisions with the walls become twice as frequent per unit area, while the average speed is unchanged.', true, 'Correct: constant T means the same average KE and speed; half the volume means twice the number density, so twice as many collisions per second per unit wall area.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The average kinetic energy of the molecules doubles because work was done on the gas.', false, 'At constant temperature the work is released as heat to the surroundings and the average kinetic energy stays the same.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The momentum transferred per collision doubles because the molecules are squeezed together.', false, 'Momentum per collision depends on the speed and mass, both unchanged here.' from version_ins;
-- apchem-mcq-b2-sv-h-3.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.5-b-v3', 'mcq', 'separate collision frequency, momentum per collision and speed in pressure (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 400 K, samples of He (4.00 g/mol) and CH₄ (16.0 g/mol) are compared. Which choice gives the correct ratios, He to CH₄, for average speed and for average kinetic energy?', null, md5('apchem-mcq-b2-sv-h-3.5-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Speed ratio 4 : 1; kinetic energy ratio 1 : 1', false, 'The speed ratio is the square root of the molar mass ratio, so 4 comes from leaving out the square root.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Speed ratio 2 : 1; kinetic energy ratio 4 : 1', false, 'The kinetic energy depends on temperature only, so squaring the speed ratio while ignoring the masses is wrong.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Speed ratio 2 : 1; kinetic energy ratio 1 : 1', true, 'Correct: average speed ∝ √(1/M), so the ratio is √(16.0/4.00) = 2; average KE depends only on T, so the ratio is 1.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Speed ratio 1 : 1; kinetic energy ratio 1 : 1', false, 'Equal temperature gives equal kinetic energy, not equal speed, because the masses differ.' from version_ins;
-- apchem-mcq-b2-h-3.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-h-3.6-a', 'mcq', 'use compressibility data to find real volume and decide attractions vs particle volume', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 300 K and 100 atm, 1.00 mol of CH₄ has Z = PV/(nRT) = 0.87. Use R = 0.0821 L·atm/(mol·K) and V = Z·nRT/P. What is the measured volume, and what does the result show?', null, md5('apchem-mcq-b2-h-3.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.246 L; CH₄ behaves ideally at this pressure.', false, 'Ideal behavior would give Z = 1.00, and 0.246 L is the ideal volume, not the measured one.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.214 L; attractions between CH₄ molecules pull them closer, so the volume is smaller than the ideal value.', true, 'Correct: ideal V = 1.00 × 0.0821 × 300 / 100 = 0.246 L; real V = 0.87 × 0.246 = 0.214 L; Z < 1 indicates attractions.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.283 L; the volume of the CH₄ molecules makes the volume larger than the ideal value.', false, 'A volume above ideal would need Z greater than 1, which is the sign of particle volume, but Z is 0.87 here.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.214 L; the volume of the CH₄ molecules makes the real volume smaller than the ideal value.', false, 'The number is right, but molecular volume would increase the real volume; the smaller volume comes from attractions.' from version_ins;
-- apchem-mcq-b2-sv-h-3.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b2-sv-h-3.6-a-v1', 'mcq', 'use compressibility data to find real volume and decide attractions vs particle volume (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'At 300 K and 100 atm, 1.00 mol of He has Z = PV/(nRT) = 1.06. Use R = 0.0821 L·atm/(mol·K) and V = Z·nRT/P. What is the measured volume, and what does the result show?', null, md5('apchem-mcq-b2-sv-h-3.6-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0.246 L; He behaves ideally because it is a noble gas.', false, 'A noble gas still deviates at 100 atm, and Z = 1.06 is not 1.' from version_ins
union all select gen_random_uuid(), id, 'B', '0.261 L; the volume of the He atoms themselves becomes significant, so the real volume is larger than the ideal value.', true, 'Correct: ideal V = 0.246 L; real V = 1.06 × 0.246 = 0.261 L; Z > 1 means the finite size of the atoms dominates because He attractions are very weak.' from version_ins
union all select gen_random_uuid(), id, 'C', '0.232 L; attractions between He atoms make the volume smaller than the ideal value.', false, 'A smaller volume would need Z < 1, and He has almost no attractions.' from version_ins
union all select gen_random_uuid(), id, 'D', '0.261 L; attractions between He atoms make the volume larger than the ideal value.', false, 'Attractions pull the molecules together and make the volume smaller, so they cannot explain a larger volume.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b2-sv-h-3.5-a-v1','apchem-mcq-b2-sv-h-3.5-a-v2','apchem-mcq-b2-sv-h-3.5-a-v3','apchem-mcq-b2-h-3.5-b','apchem-mcq-b2-sv-h-3.5-b-v1','apchem-mcq-b2-sv-h-3.5-b-v2','apchem-mcq-b2-sv-h-3.5-b-v3','apchem-mcq-b2-h-3.6-a','apchem-mcq-b2-sv-h-3.6-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b2-sv-h-3.5-a-v1','apchem-mcq-b2-sv-h-3.5-a-v2','apchem-mcq-b2-sv-h-3.5-a-v3','apchem-mcq-b2-h-3.5-b','apchem-mcq-b2-sv-h-3.5-b-v1','apchem-mcq-b2-sv-h-3.5-b-v2','apchem-mcq-b2-sv-h-3.5-b-v3','apchem-mcq-b2-h-3.6-a','apchem-mcq-b2-sv-h-3.6-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
