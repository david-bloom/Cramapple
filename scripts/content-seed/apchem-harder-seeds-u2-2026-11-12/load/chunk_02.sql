begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.2-a-v1','apchem-mcq-b5-sv-h-2.2-a-v2','apchem-mcq-b5-sv-h-2.2-a-v3','apchem-mcq-b5-h-2.2-b','apchem-mcq-b5-sv-h-2.2-b-v1','apchem-mcq-b5-sv-h-2.2-b-v2','apchem-mcq-b5-sv-h-2.2-b-v3','apchem-mcq-b5-h-2.3-a','apchem-mcq-b5-sv-h-2.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apchem-mcq-b5-sv-h-2.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.2-a-v1', 'mcq', 'read bond length (position of the minimum) and bond energy (depth of the minimum) from potential-energy data, without as (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'PE is 0 kJ/mol for separated atoms. A student records PE for two hypothetical diatomic molecules, P₂ and Q₂.
Distance (pm): 90, 105, 120, 135, 150
PE of P₂ (kJ/mol): +350, −40, −250, −390, −310
PE of Q₂ (kJ/mol): −300, −520, −420, −250, −140
Which statement correctly compares the two molecules?', null, md5('apchem-mcq-b5-sv-h-2.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P₂ has the shorter bond, and P₂ has the greater bond energy.', false, 'It assigns both properties to P₂, but P₂ has the minimum at the larger distance and the shallower well.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P₂ has the shorter bond, and Q₂ has the greater bond energy.', false, 'It correctly sees that Q₂ is deeper but reads the distance of P₂ as the shorter one, when its minimum is at 135 pm and not 105 pm.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q₂ has the shorter bond, and Q₂ has the greater bond energy.', true, 'Correct: P₂ has its minimum of −390 kJ/mol at 135 pm and Q₂ has its minimum of −520 kJ/mol at 105 pm, so Q₂ has both the shorter bond and the larger bond energy.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q₂ has the shorter bond, and P₂ has the greater bond energy.', false, 'It correctly places Q₂ at the shorter distance but then claims P₂ is stronger, when the well of P₂ is only 390 kJ/mol deep and the well of Q₂ is 520 kJ/mol deep.' from version_ins;
-- apchem-mcq-b5-sv-h-2.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.2-a-v2', 'mcq', 'read bond length (position of the minimum) and bond energy (depth of the minimum) from potential-energy data, without as (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'PE is 0 kJ/mol for separated atoms. A student records PE for two hypothetical diatomic molecules, U₂ and V₂.
Distance (pm): 80, 100, 120, 140, 160
PE of U₂ (kJ/mol): +120, −210, −150, −80, −40
PE of V₂ (kJ/mol): +900, +120, −300, −460, −380
Which statement correctly compares the two molecules?', null, md5('apchem-mcq-b5-sv-h-2.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'U₂ has the longer bond, and V₂ has the greater bond energy.', false, 'It reverses the lengths, but the minimum of U₂ is at 100 pm, which is shorter than the 140 pm of V₂.' from version_ins
union all select gen_random_uuid(), id, 'B', 'U₂ has the longer bond, and U₂ has the greater bond energy.', false, 'It assigns both properties to U₂, which has the shorter bond and the shallower well.' from version_ins
union all select gen_random_uuid(), id, 'C', 'V₂ has the longer bond, and U₂ has the greater bond energy.', false, 'It uses the rule that a longer bond is a weaker bond, but bond energy is the depth of the well, which is larger for V₂ at 460 kJ/mol than for U₂ at 210 kJ/mol.' from version_ins
union all select gen_random_uuid(), id, 'D', 'V₂ has the longer bond, and V₂ has the greater bond energy.', true, 'Correct: U₂ has its minimum of −210 kJ/mol at 100 pm and V₂ has its minimum of −460 kJ/mol at 140 pm, so V₂ is both longer and stronger.' from version_ins;
-- apchem-mcq-b5-sv-h-2.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.2-a-v3', 'mcq', 'read bond length (position of the minimum) and bond energy (depth of the minimum) from potential-energy data, without as (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'PE is 0 kJ/mol for separated atoms. A student records PE for two hypothetical diatomic molecules, K₂ and L₂.
Distance (pm): 100, 120, 140, 160, 180
PE of K₂ (kJ/mol): +150, −120, −250, −290, −230
PE of L₂ (kJ/mol): +500, −200, −350, −270, −190
Which statement correctly compares the two molecules?', null, md5('apchem-mcq-b5-sv-h-2.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'L₂ has the shorter bond, and L₂ has the greater bond energy.', true, 'Correct: K₂ has its minimum of −290 kJ/mol at 160 pm and L₂ has its minimum of −350 kJ/mol at 140 pm, so L₂ has the shorter bond and the larger bond energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'K₂ has the shorter bond, and L₂ has the greater bond energy.', false, 'It reads the bond length of K₂ as the shorter one, but its minimum is at 160 pm and not at 140 pm.' from version_ins
union all select gen_random_uuid(), id, 'C', 'K₂ has the shorter bond, and K₂ has the greater bond energy.', false, 'It assigns both properties to K₂, which has the longer bond and the shallower well.' from version_ins
union all select gen_random_uuid(), id, 'D', 'L₂ has the shorter bond, and K₂ has the greater bond energy.', false, 'It places L₂ at the shorter distance correctly but says K₂ is stronger, even though the well of L₂ is deeper at 350 kJ/mol against 290 kJ/mol.' from version_ins;
-- apchem-mcq-b5-h-2.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.2-b', 'mcq', 'use a potential-energy curve to predict the direction of the net force and the motion of two atoms released from rest at', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For two hydrogen atoms, PE is 0 kJ/mol when they are far apart. The PE is −436 kJ/mol at the equilibrium distance of 74 pm, −300 kJ/mol at 60 pm, and −300 kJ/mol at 100 pm. Two hydrogen atoms are released from rest when their nuclei are 60 pm apart. Which description is correct?', null, md5('apchem-mcq-b5-h-2.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The net force is repulsive, because electron and nucleus repulsions outweigh attractions inside 74 pm; the atoms move apart, and PE decreases as kinetic energy increases until 74 pm.', true, 'Correct: at 60 pm the PE is higher than the minimum, and PE decreases as the distance increases toward 74 pm, so the net force pushes the atoms apart. The total energy of −300 kJ/mol is below zero, so the atoms remain bound.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The atoms move closer together, because their PE is negative and negative PE means the net force is attractive.', false, 'The sign of the PE does not give the direction of the force, which depends on whether PE falls or rises as the distance changes, and PE falls as the atoms move apart from 60 pm.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The atoms stay at 60 pm, because any distance with negative PE is stable.', false, 'Only the minimum at 74 pm is an equilibrium distance, and at 60 pm the PE is above the minimum so a net force acts.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The atoms separate completely, because repulsion at short distances always exceeds the energy that holds the atoms together.', false, 'The total energy is −300 kJ/mol, which is below zero, so the atoms cannot escape to infinite separation without gaining energy.' from version_ins;
-- apchem-mcq-b5-sv-h-2.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.2-b-v1', 'mcq', 'use a potential-energy curve to predict the direction of the net force and the motion of two atoms released from rest at (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For two nitrogen atoms in N₂, PE is 0 kJ/mol when the atoms are far apart, −945 kJ/mol at the equilibrium distance of 110 pm, and −500 kJ/mol at 150 pm. Two nitrogen atoms are released from rest when their nuclei are 150 pm apart. Which description is correct?', null, md5('apchem-mcq-b5-sv-h-2.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The net force is repulsive, because PE is negative and the atoms are farther apart than at equilibrium.', false, 'At distances greater than the equilibrium distance, attractions between nuclei and electrons outweigh repulsions, so the net force is attractive and not repulsive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The net force is attractive; the atoms move closer together, PE decreases, and kinetic energy increases until the distance is 110 pm.', true, 'Correct: at 150 pm, PE (−500) is above the minimum (−945 at 110 pm), and PE falls as the distance decreases toward 110 pm, so the net force is attractive.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The atoms remain at 150 pm, because the PE there is negative.', false, 'A negative PE alone does not make a distance an equilibrium, and the atoms feel a net force because PE changes with distance at 150 pm.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The atoms drift apart until they are free atoms, because the PE at 150 pm is higher than at 110 pm.', false, 'The total energy of −500 kJ/mol is below zero, so the atoms are bound and cannot separate completely without added energy.' from version_ins;
-- apchem-mcq-b5-sv-h-2.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.2-b-v2', 'mcq', 'use a potential-energy curve to predict the direction of the net force and the motion of two atoms released from rest at (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For two chlorine atoms in Cl₂, PE is 0 kJ/mol when the atoms are far apart, −243 kJ/mol at the equilibrium distance of 199 pm, and −120 kJ/mol at 170 pm. Two chlorine atoms are released from rest when their nuclei are 170 pm apart. Which description is correct?', null, md5('apchem-mcq-b5-sv-h-2.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The atoms move closer together, because PE is negative and the atoms were released from rest.', false, 'Moving closer from 170 pm would raise PE and need energy input, so a released pair moves toward the lower PE at 199 pm, which is farther apart.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The atoms do not move, because the PE at 170 pm is negative and so the atoms are stable.', false, 'Only the equilibrium distance has zero net force, and at 170 pm the atoms feel a net repulsion even though PE is negative.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The atoms fly apart and separate completely, because a distance shorter than 199 pm always means the atoms repel enough to break the bond.', false, 'The total energy of −120 kJ/mol is below zero, so the atoms oscillate about 199 pm without breaking apart.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The net force is repulsive; the atoms move apart, passing through 199 pm with their maximum kinetic energy.', true, 'Correct: at 170 pm the PE (−120) is higher than the minimum (−243 at 199 pm), so PE falls as the atoms separate and the net force is repulsive; the kinetic energy is greatest where PE is lowest, at 199 pm.' from version_ins;
-- apchem-mcq-b5-sv-h-2.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.2-b-v3', 'mcq', 'use a potential-energy curve to predict the direction of the net force and the motion of two atoms released from rest at (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For the H–Br bond, PE is 0 kJ/mol when the atoms are far apart, −366 kJ/mol at the equilibrium distance of 141 pm, and −100 kJ/mol at 220 pm. A hydrogen atom and a bromine atom are released from rest when their nuclei are 220 pm apart. Which description is correct?', null, md5('apchem-mcq-b5-sv-h-2.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The net force is repulsive, because the atoms are farther apart than their equilibrium distance.', false, 'Beyond the equilibrium distance, the attraction between nuclei and electrons outweighs the repulsions, so the force is attractive.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The atoms stay at 220 pm, because they are neutral atoms and exert no net force.', false, 'Neutral atoms still attract through electron and nucleus interactions at these distances, and the PE value of −100 kJ/mol shows the interaction is not zero.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The net force is attractive; the atoms move closer together as PE decreases and kinetic energy increases toward 141 pm.', true, 'Correct: the PE at 220 pm (−100) is above the minimum, and PE falls as the atoms approach 141 pm, so the force is attractive and the atoms speed up as they approach.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The atoms move apart to infinite separation, because the PE at 220 pm is higher than the PE at 141 pm.', false, 'A system with negative total energy cannot separate to infinity, and the lower PE at 141 pm means the atoms move toward it and not away.' from version_ins;
-- apchem-mcq-b5-h-2.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-h-2.3-a', 'mcq', 'apply Coulomb''s law quantitatively, using ion charges and the sum of ionic radii, to compare the strength of ionic attra', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate ionic radii (pm): Mg²⁺ 72, O²⁻ 140, Na⁺ 102, F⁻ 133. Treat the distance between neighboring ions as the sum of the ionic radii. The magnitude of the electrostatic potential energy of a cation-anion pair is proportional to (charge of cation × charge of anion) ÷ distance. About how many times larger is this magnitude for a neighboring Mg²⁺ and O²⁻ pair in MgO than for a neighboring Na⁺ and F⁻ pair in NaF?', null, md5('apchem-mcq-b5-h-2.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 4.4 times larger.', true, 'Correct: MgO distance = 72 + 140 = 212 pm, so 4/212 = 0.01887. NaF distance = 102 + 133 = 235 pm, so 1/235 = 0.004255. Ratio = 0.01887 ÷ 0.004255 = 4.43.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 2.0 times, because the sum of the charges of the ions in MgO is twice the sum in NaF.', false, 'Potential energy depends on the product of the charges and not on their sum, and the distance also differs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 4.9 times larger.', false, 'This value is the ratio of the forces, 4 × (235/212)², because force varies as 1/d², whereas the potential energy varies as 1/d.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 4.0 times, because the charge product is 4 times larger and the distances are almost identical.', false, 'It ignores the smaller distance in MgO, 212 pm against 235 pm, which raises the ratio above the charge-product ratio of 4.' from version_ins;
-- apchem-mcq-b5-sv-h-2.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b5-sv-h-2.3-a-v1', 'mcq', 'apply Coulomb''s law quantitatively, using ion charges and the sum of ionic radii, to compare the strength of ionic attra (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Approximate ionic radii (pm): Ca²⁺ 100, O²⁻ 140, Rb⁺ 152, Br⁻ 196. Treat the distance between neighboring ions as the sum of the ionic radii. The magnitude of the electrostatic potential energy of a cation-anion pair is proportional to (charge of cation × charge of anion) ÷ distance. About how many times larger is this magnitude for a neighboring Ca²⁺ and O²⁻ pair in CaO than for a neighboring Rb⁺ and Br⁻ pair in RbBr?', null, md5('apchem-mcq-b5-sv-h-2.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 8.4 times larger.', false, 'This is the force ratio, 4 × (348/240)², which uses an inverse-square dependence, whereas potential energy depends on 1/d.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 4.0 times, because only the charge product matters and the ions are about the same size.', false, 'It ignores that the RbBr ions are much larger, so the distance in RbBr is 348 pm against 240 pm in CaO.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 5.8 times larger.', true, 'Correct: CaO distance = 100 + 140 = 240 pm, so 4/240 = 0.01667. RbBr distance = 152 + 196 = 348 pm, so 1/348 = 0.002874. Ratio = 5.80.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 2.0 times, because the cation and anion charges in CaO add to 4 and those in RbBr add to 2.', false, 'The energy depends on the product of the charges, 2 × 2 against 1 × 1, and not on their sum, and the distances differ too.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b5-sv-h-2.2-a-v1','apchem-mcq-b5-sv-h-2.2-a-v2','apchem-mcq-b5-sv-h-2.2-a-v3','apchem-mcq-b5-h-2.2-b','apchem-mcq-b5-sv-h-2.2-b-v1','apchem-mcq-b5-sv-h-2.2-b-v2','apchem-mcq-b5-sv-h-2.2-b-v3','apchem-mcq-b5-h-2.3-a','apchem-mcq-b5-sv-h-2.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b5-sv-h-2.2-a-v1','apchem-mcq-b5-sv-h-2.2-a-v2','apchem-mcq-b5-sv-h-2.2-a-v3','apchem-mcq-b5-h-2.2-b','apchem-mcq-b5-sv-h-2.2-b-v1','apchem-mcq-b5-sv-h-2.2-b-v2','apchem-mcq-b5-sv-h-2.2-b-v3','apchem-mcq-b5-h-2.3-a','apchem-mcq-b5-sv-h-2.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
