begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-h-1.1-a','apbio-mcq-b6-sv-h-1.1-a-v1','apbio-mcq-b6-sv-h-1.1-a-v2','apbio-mcq-b6-sv-h-1.1-a-v3','apbio-mcq-b6-h-1.1-b','apbio-mcq-b6-sv-h-1.1-b-v1','apbio-mcq-b6-sv-h-1.1-b-v2','apbio-mcq-b6-sv-h-1.1-b-v3','apbio-mcq-b6-h-1.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b6-h-1.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.1-a', 'mcq', 'explain a solubility trend in water from the balance of polar and nonpolar parts of a molecule.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chemist measures how much of each straight-chain alcohol dissolves in 100 mL of water at 20°C. Every alcohol has one polar -OH group at the end of a chain of carbon atoms joined by nonpolar C-H and C-C bonds. Ethanol (2 carbons) mixes with water in any proportion, 1-butanol (4 carbons) dissolves to about 7 g, 1-hexanol (6 carbons) to about 0.6 g, and 1-decanol (10 carbons) to less than 0.01 g. Which statement best explains the trend?', null, md5('apbio-mcq-b6-h-1.1-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Longer chains contain more -OH groups, which would make hydrogen bonding with water weaker.', false, 'Every alcohol listed has exactly one -OH group, so the number of -OH groups does not change with chain length.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Longer alcohol molecules are heavier, so they sink out of the water solution before they can dissolve.', false, 'Density is not what limits dissolving; the stem gives solubility values, and a heavier molecule can still dissolve if it bonds well with water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The nonpolar chain cannot form hydrogen bonds with water and disrupts the water''s hydrogen-bond network, and this effect grows with chain length until it outweighs the single -OH group.', true, 'Correct: Each alcohol has just one -OH, so the only thing that changes is the length of the nonpolar tail, which interrupts water-water hydrogen bonds without bonding to water.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water molecules lose their partial charges when they contact long carbon chains, so they stop forming hydrogen bonds with each other.', false, 'Water molecules always keep their partial charges, so the explanation about losing them is not chemistry that occurs.' from version_ins;
-- apbio-mcq-b6-sv-h-1.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.1-a-v1', 'mcq', 'explain a solubility trend in water from the balance of polar and nonpolar parts of a molecule. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Vitamin C has a small carbon ring with four -OH groups and dissolves readily in water. Vitamin A has a long hydrocarbon chain with a single -OH group and dissolves mainly in fats and oils. A person takes large doses of each for several weeks. Excess vitamin C is quickly lost in urine, while vitamin A accumulates in fatty tissue. Which statement best explains the difference?', null, md5('apbio-mcq-b6-sv-h-1.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Vitamin C has more carbon atoms, so it is a larger molecule that the kidneys filter out faster.', false, 'Vitamin A has the longer carbon chain, so it is the larger carbon skeleton, and size does not explain water solubility.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Vitamin A has stronger covalent bonds than vitamin C, so water cannot break the molecule down.', false, 'The difference comes from polarity, not from bond strength, and covalent bonds inside either vitamin are not broken by water here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Vitamin C forms many hydrogen bonds with water and stays dissolved in body fluids, while vitamin A is mostly nonpolar and associates with the nonpolar interior of fat.', true, 'Correct: Many polar -OH groups give vitamin C hydrogen bonds with water, while vitamin A''s long hydrocarbon chain is nonpolar and is excluded from water but compatible with fat.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Vitamin A carries a net negative charge, which attracts it to the fat cells that carry a positive charge.', false, 'The stem describes vitamin A as nonpolar with a single -OH, not as an ion, and fat cells are not positively charged.' from version_ins;
-- apbio-mcq-b6-sv-h-1.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.1-a-v2', 'mcq', 'explain a solubility trend in water from the balance of polar and nonpolar parts of a molecule. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two clear solutions are prepared by dissolving 10 g of table salt (NaCl) in one beaker of water and 10 g of sugar (C12H22O11) in another. A conductivity probe shows that the salt solution conducts electricity well and the sugar solution does not conduct. Both solids dissolve completely. Which statement best explains why the sugar solution does not conduct even though the sugar dissolved?', null, md5('apbio-mcq-b6-sv-h-1.1-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sugar dissolves by forming bonds with water that remove all charge from the water molecules.', false, 'Water molecules keep their partial charges while hydrogen bonding, and conductivity depends on free ions, not on water losing charge.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sugar dissolves because water breaks its covalent bonds into individual atoms, which carry no charge.', false, 'Dissolving sugar does not break covalent bonds within the sugar molecule, so atoms are not released.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sugar is nonpolar, so it dissolves by being trapped between water molecules without any attraction to them.', false, 'Sugar has many polar -OH groups and is not nonpolar, and a nonpolar substance would not dissolve well in water.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sugar stays as intact, uncharged molecules whose many -OH groups form hydrogen bonds with water, so no free ions are produced.', true, 'Correct: Conduction requires free ions; sugar''s polar -OH groups hydrogen bond with water so the molecules disperse intact without becoming ions.' from version_ins;
-- apbio-mcq-b6-sv-h-1.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.1-a-v3', 'mcq', 'explain a solubility trend in water from the balance of polar and nonpolar parts of a molecule. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student shakes olive oil with water in a sealed bottle and sees many tiny oil droplets. After the bottle sits for an hour, the droplets have merged into one layer on top of the water. Which statement best explains why the droplets merge?', null, md5('apbio-mcq-b6-sv-h-1.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Oil molecules form hydrogen bonds with each other, which pulls the droplets together.', false, 'Oil molecules are nonpolar hydrocarbons and have no -OH groups, so they cannot form hydrogen bonds with each other.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Oil molecules are attracted to the partial charges on water molecules and gather at the top.', false, 'Attraction to water''s partial charges would keep oil dispersed and mixed in, the opposite of what is observed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Gravity pulls the oil droplets together because oil has a higher density than water.', false, 'Oil is less dense than water, which is why the oil layer ends up on top, so density does not explain the merging.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water molecules hydrogen bond with one another and exclude the nonpolar oil, so merging reduces the oil surface exposed to water.', true, 'Correct: The nonpolar oil cannot hydrogen bond, so water''s strong self-attraction pushes oil together into the smallest contact area, which is one layer.' from version_ins;
-- apbio-mcq-b6-h-1.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.1-b', 'mcq', 'connect the density data of liquid water and ice to hydrogen-bond arrangement and to survival of aquatic life.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A pond is monitored through a winter. The density of water is 0.9997 g/mL at 10°C, 1.0000 g/mL at 4°C, 0.9999 g/mL at 1°C, and 0.9998 g/mL for liquid water at 0°C. Ice at 0°C has a density of 0.917 g/mL. In midwinter the pond has a layer of ice at the surface, water near 0°C just under the ice, and water at 4°C at the bottom. Which statement best explains the layering and why the fish can survive?', null, md5('apbio-mcq-b6-h-1.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'In ice each molecule is held in an open lattice by stable hydrogen bonds, which makes ice less dense so it floats and insulates the water below, while 4°C water is densest and sinks to the bottom.', true, 'Correct: The data show maximum liquid density at 4°C and a lower density for ice; the hydrogen-bonded open lattice of ice explains why it floats and leaves liquid water beneath.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Water at 4°C has the fewest hydrogen bonds, so it moves downward, and ice forms where bonds are fewest.', false, 'Ice has the most stable hydrogen bonds, not the fewest, and the 4°C water is denser because the molecules are closer together.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ice is less dense because its hydrogen bonds break, spreading the molecules apart, and the surface freezes first because the air is colder.', false, 'Freezing does not break hydrogen bonds; it makes them more stable and fixed, and this explanation reverses the real cause of the lower density.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All water becomes denser as it cools, so the coldest water stays at the bottom and the fish freeze first.', false, 'The density data show that water is densest at 4°C and becomes less dense below that, so the coldest water does not sink to the bottom.' from version_ins;
-- apbio-mcq-b6-sv-h-1.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.1-b-v1', 'mcq', 'connect the density data of liquid water and ice to hydrogen-bond arrangement and to survival of aquatic life. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rigid sealed glass jar is filled completely with 1000 g of liquid water at 0°C and then placed in a freezer. The density of ice is 0.917 g/mL and that of liquid water at 0°C is about 1.00 g/mL. If the jar were able to expand, by about what amount would the volume change when all the water freezes, and why?', null, md5('apbio-mcq-b6-sv-h-1.1-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 8% smaller, because the molecules lose energy and pack more tightly.', false, 'This is the pattern for most substances, but water is unusual because ice occupies more volume than the liquid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 9% larger, because the hydrogen bonds hold the molecules in a fixed open lattice with more space between them.', true, 'Correct: 1000 g divided by 0.917 g/mL is about 1090 mL, which is roughly 9% more than 1000 mL, caused by the open hydrogen-bonded lattice.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No change, because the mass of the water stays the same during freezing.', false, 'Mass is conserved, but volume depends on density, which is lower for ice, so the volume does change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 50% larger, because every molecule forms twice as many covalent bonds in ice.', false, 'Freezing does not form covalent bonds, and the calculation from the densities gives about 9%, not 50%.' from version_ins;
-- apbio-mcq-b6-sv-h-1.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.1-b-v2', 'mcq', 'connect the density data of liquid water and ice to hydrogen-bond arrangement and to survival of aquatic life. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A block of ice at -10°C is heated at a constant rate in an insulated container. The temperature rises steadily to 0°C, then stays at 0°C for several minutes while the heater keeps running, and then rises again once all of the ice has become liquid water. Which statement best explains the flat portion at 0°C?', null, md5('apbio-mcq-b6-sv-h-1.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The added energy breaks the covalent O-H bonds in water molecules, which stops the temperature from rising.', false, 'Melting does not break covalent bonds; water molecules stay as H2O, and only intermolecular hydrogen bonds loosen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The added energy is used to break hydrogen bonds in the ice lattice, so it changes the arrangement of molecules rather than raising their average kinetic energy.', true, 'Correct: A temperature plateau during a phase change shows that energy is being absorbed to disrupt intermolecular hydrogen bonds instead of increasing kinetic energy.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The heater stops transferring energy to the sample while the ice is present.', false, 'The heater keeps running, so energy continues to enter the sample, and the flat temperature means that energy is being used for something other than warming.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Ice and liquid water have identical energies, so no energy is needed to melt the ice.', false, 'If no energy were needed, the ice would melt instantly and there would be no plateau, but melting does require energy.' from version_ins;
-- apbio-mcq-b6-sv-h-1.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.1-b-v3', 'mcq', 'connect the density data of liquid water and ice to hydrogen-bond arrangement and to survival of aquatic life. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A scientist imagines a planet where the solid form of a hypothetical liquid is denser than its liquid, so the solid sinks. Lakes on the planet cool in winter in the same way as lakes on Earth. Which outcome is most likely for the lakes there?', null, md5('apbio-mcq-b6-sv-h-1.1-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Ice would form only at the surface and protect liquid beneath it, as in Earth lakes.', false, 'Surface ice protecting the water below depends on ice being less dense than liquid, which is not true on this planet.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lakes would never freeze, because the liquid always stays warmer than its surroundings.', false, 'Cooling in winter lowers the temperature to the freezing point, so freezing can occur and the lakes can freeze.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Solid would form at the surface, sink, and accumulate on the bottom, so lakes could freeze from the bottom upward and leave little liquid habitat.', true, 'Correct: A solid denser than its liquid sinks, so it collects at the bottom and the lake can freeze solid, unlike Earth lakes where floating ice insulates the liquid water.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The solid would form at the surface and stay there, because surface water is always colder.', false, 'A solid that is denser than the liquid would not float, so it would not remain at the surface.' from version_ins;
-- apbio-mcq-b6-h-1.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.2-a', 'mcq', 'use radioactive element labels to infer which biological molecules incorporate which elements.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Bacteria are grown for several generations in one of two media, each containing a single radioactive element: Medium 1 has radioactive phosphate, and Medium 2 has radioactive sulfate (which cells convert into sulfur-containing amino acids). Cells are then broken open and their molecules separated by type. In Medium 1 cultures, radioactivity is high in DNA and RNA, moderate in the membrane lipid fraction, and negligible in the polypeptide backbone of proteins and in polysaccharides. In Medium 2 cultures, radioactivity is found in proteins but not in DNA, RNA, lipids, or polysaccharides. Which pair of statements best explains the results?', null, md5('apbio-mcq-b6-h-1.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Phosphorus is part of nucleic acids and of the phospholipids in membranes, and sulfur is present in some amino acids but not in nucleic acids or lipids.', true, 'Correct: Phosphorus appears in nucleotides and phospholipids; sulfur appears in cysteine and methionine, so the label pattern identifies P and S.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Medium 1 labels molecules that contain carbon, and Medium 2 labels molecules that contain nitrogen.', false, 'Carbon is found in all four classes of molecules, and a carbon label would therefore appear in polysaccharides and every other fraction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Phosphorus is part of every amino acid, and sulfur is part of the sugar-phosphate backbone of nucleic acids.', false, 'Amino acids do not contain phosphorus in their basic structure, and the nucleic acid backbone contains phosphate rather than sulfur.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both labels reached cells in equal amounts, so the differences are caused by how quickly each fraction was broken down.', false, 'The stem reports high and negligible values in different fractions, which reflects incorporation into particular molecules rather than any difference in breakdown speed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-h-1.1-a','apbio-mcq-b6-sv-h-1.1-a-v1','apbio-mcq-b6-sv-h-1.1-a-v2','apbio-mcq-b6-sv-h-1.1-a-v3','apbio-mcq-b6-h-1.1-b','apbio-mcq-b6-sv-h-1.1-b-v1','apbio-mcq-b6-sv-h-1.1-b-v2','apbio-mcq-b6-sv-h-1.1-b-v3','apbio-mcq-b6-h-1.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-h-1.1-a','apbio-mcq-b6-sv-h-1.1-a-v1','apbio-mcq-b6-sv-h-1.1-a-v2','apbio-mcq-b6-sv-h-1.1-a-v3','apbio-mcq-b6-h-1.1-b','apbio-mcq-b6-sv-h-1.1-b-v1','apbio-mcq-b6-sv-h-1.1-b-v2','apbio-mcq-b6-sv-h-1.1-b-v3','apbio-mcq-b6-h-1.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
