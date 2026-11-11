begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-sv-h-3.3-a-v2','apchem-mcq-sv-h-3.3-a-v3','apchem-mcq-h-3.3-b','apchem-mcq-sv-h-3.3-b-v1','apchem-mcq-sv-h-3.3-b-v2','apchem-mcq-sv-h-3.3-b-v3'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apchem-mcq-sv-h-3.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-a-v2', 'mcq', 'Energy during phase changes (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two liquids, X and Y, are kept at the same temperature. X evaporates much faster than Y. Which statement is best supported?', null, md5('apchem-mcq-sv-h-3.3-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The molecules of X have a greater average kinetic energy than those of Y.', false, 'The liquids are at the same temperature, so their average kinetic energies are equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'X has stronger intermolecular forces than Y.', false, 'Stronger intermolecular forces would make X evaporate more slowly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X molecules are held by weaker intermolecular forces, so a larger fraction of them have enough energy to escape, even though the average kinetic energy is the same.', true, 'Correct: same temperature means the same average kinetic energy; weaker attractions let more molecules escape.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Y molecules move faster than X molecules because Y has a lower vapor pressure.', false, 'The speed of a molecule at a given temperature depends on mass, not on its vapor pressure.' from version_ins;
-- apchem-mcq-sv-h-3.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-a-v3', 'mcq', 'Energy during phase changes (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Solid water (ice) is less dense than liquid water. Which statement best explains this at the particle level?', null, md5('apchem-mcq-sv-h-3.3-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The molecules in ice move faster than those in liquid water, so they take up more space.', false, 'Molecules in a solid vibrate in fixed positions and move less than those in a liquid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ice contains fewer molecules per mole than liquid water.', false, 'A mole is a fixed number of molecules in any phase.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The molecules in ice are held in an open, hexagonal arrangement by hydrogen bonds, which keeps them farther apart on average than in liquid water.', true, 'Correct: hydrogen bonding in ice fixes an open lattice; in liquid water the molecules pack more closely.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Hydrogen bonds in ice are weaker than those in liquid water, so the molecules sit farther apart.', false, 'Hydrogen bonds are present in both phases, and in ice each molecule is held in a fixed open network, so it is not that they are weaker.' from version_ins;
-- apchem-mcq-h-3.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-h-3.3-b', 'mcq', 'Particle behavior of gases and liquids', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Helium and xenon gas are each held at 300 K. Which statement about the particles is correct?', null, md5('apchem-mcq-h-3.3-b'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Helium and xenon have the same average speed, because they are at the same temperature.', false, 'The average speeds differ, because equal kinetic energy with unequal mass requires unequal speeds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Xenon atoms have the greater average kinetic energy, because they are more massive.', false, 'Average kinetic energy does not depend on mass, only on temperature.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Helium atoms have the greater average kinetic energy, because they are lighter.', false, 'Lighter particles move faster, but they do not have more kinetic energy at the same temperature.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Helium and xenon have the same average kinetic energy, and the helium atoms move faster on average.', true, 'Correct: average kinetic energy depends only on temperature; with KE = (1/2)mv^2 and equal KE, the lighter atoms have the higher speed.' from version_ins;
-- apchem-mcq-sv-h-3.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-b-v1', 'mcq', 'Particle behavior of gases and liquids (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of gas is compressed into a container one tenth its original volume while temperature is held constant. A liquid, by contrast, hardly changes volume under the same pressure. Which statement best explains the difference?', null, md5('apchem-mcq-sv-h-3.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The particles of a gas are far apart with mostly empty space between them, while the particles of a liquid are nearly in contact.', true, 'Correct: gases are mostly empty space; liquid particles are in contact.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Gas particles shrink when compressed, while liquid particles do not.', false, 'The particles themselves do not change size, and only the distance between them changes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Gas particles have no mass, so they can be squeezed.', false, 'Gas particles have mass, and it is the empty space between them that allows compression.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Liquid particles do not move, so they cannot be compressed.', false, 'Liquid particles move constantly, and they resist compression because they are already in contact.' from version_ins;
-- apchem-mcq-sv-h-3.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-b-v2', 'mcq', 'Particle behavior of gases and liquids (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Of the gases NH3 and H2, which would be expected to deviate more from ideal behavior at low temperature and high pressure, and why?', null, md5('apchem-mcq-sv-h-3.3-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'NH3, because its molecules have stronger intermolecular attractions, which become significant when the molecules are close together and slow.', true, 'Correct: NH3 hydrogen bonds and has a larger volume; at low T and high P attractions and particle volume matter more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H2, because its molecules are smaller and are packed more tightly.', false, 'Small molecules with weak attractions behave more ideally, and H2 is the more ideal gas.' from version_ins
union all select gen_random_uuid(), id, 'C', 'H2, because its particles move faster and collide more often.', false, 'Fast-moving particles overcome attractions more easily, so H2 stays closer to ideal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'They deviate equally, because all gases behave ideally at high pressure.', false, 'Real gases deviate most at high pressure and low temperature, so the claim of ideal behavior is false.' from version_ins;
-- apchem-mcq-sv-h-3.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-sv-h-3.3-b-v3', 'mcq', 'Particle behavior of gases and liquids (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drop of food coloring placed in a glass of water spreads out much more slowly than a drop of perfume vapor spreads through a still room. Which statement best explains the difference?', null, md5('apchem-mcq-sv-h-3.3-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Gas particles move faster than liquid particles because they have a higher temperature.', false, 'Both samples are at about room temperature, so the difference is not temperature.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The particles in a gas are far apart and move freely, so they mix through the available space faster than the closely packed particles of a liquid.', true, 'Correct: gas particles have more space and fewer collisions per distance than liquid particles.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Liquid particles do not move, and so only diffuse because water currents carry them.', false, 'Liquid particles move, but frequent collisions with neighbors slow their net motion.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Perfume has stronger intermolecular forces than food coloring.', false, 'The comparison is of phase, not of the relative strength of the forces in two specific substances.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-sv-h-3.3-a-v2','apchem-mcq-sv-h-3.3-a-v3','apchem-mcq-h-3.3-b','apchem-mcq-sv-h-3.3-b-v1','apchem-mcq-sv-h-3.3-b-v2','apchem-mcq-sv-h-3.3-b-v3']) and status='draft')<>6 then raise exception 'chunk 3: expected 6 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-sv-h-3.3-a-v2','apchem-mcq-sv-h-3.3-a-v3','apchem-mcq-h-3.3-b','apchem-mcq-sv-h-3.3-b-v1','apchem-mcq-sv-h-3.3-b-v2','apchem-mcq-sv-h-3.3-b-v3']))<>24 then raise exception 'chunk 3: expected 24 choices'; end if;
end $$;
commit;
