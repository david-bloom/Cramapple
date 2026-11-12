begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.4-a-v3','apbio-mcq-b6-h-1.4-b','apbio-mcq-b6-sv-h-1.4-b-v1','apbio-mcq-b6-sv-h-1.4-b-v2','apbio-mcq-b6-sv-h-1.4-b-v3','apbio-mcq-b6-h-1.5-a','apbio-mcq-b6-sv-h-1.5-a-v1','apbio-mcq-b6-sv-h-1.5-a-v2','apbio-mcq-b6-sv-h-1.5-a-v3'])) then raise exception 'chunk 4 already loaded'; end if;
end $$;
-- apbio-mcq-b6-sv-h-1.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.4-a-v3', 'mcq', 'explain enzyme specificity toward glucose polymers by the orientation of the glycosidic linkage. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two unknown polymers, P and Q, are each made only of glucose. Polymer P is hydrolyzed by cellulase but not by amylase. Polymer Q is hydrolyzed by amylase but not by cellulase. Which conclusion is best supported?', null, md5('apbio-mcq-b6-sv-h-1.4-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P has alpha-1,4 linkages and Q has beta-1,4 linkages.', false, 'This reverses the assignments, since cellulase cuts beta-1,4 links and amylase cuts alpha-1,4 links.' from version_ins
union all select gen_random_uuid(), id, 'B', 'P and Q have identical structures, because both are made only of glucose.', false, 'Identical monomers do not mean identical structure, as the different enzyme results show different linkages.' from version_ins
union all select gen_random_uuid(), id, 'C', 'P and Q differ because P contains a different monomer than Q.', false, 'The stem states both are made only of glucose, so the monomers are the same.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P has beta-1,4 linkages like cellulose and Q has alpha-1,4 linkages like starch, so they differ in linkage orientation.', true, 'Correct: Each enzyme cuts one linkage orientation, so the opposite results show that the two polymers have different glycosidic linkages despite identical monomers.' from version_ins;
-- apbio-mcq-b6-h-1.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.4-b', 'mcq', 'relate branching of a glucose polymer to the number of chain ends and the rate of glucose release.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two storage polymers each contain 10,000 glucose units. Polymer L is unbranched and has one end where glucose is removed. Polymer H has a branch about every 10 glucose units, which gives it about 1,001 chain ends. An enzyme removes glucose only from the ends of chains, one unit at a time, and each end is processed at the same rate. How does the initial rate of glucose release from H compare with that from L?', null, md5('apbio-mcq-b6-h-1.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About the same, because both polymers contain 10,000 glucose units.', false, 'The total number of glucose units is the same, but the enzyme acts on ends, so the rate depends on how many ends are available.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 1,000 times faster, because H has about 1,001 ends for the enzyme to act on, compared with 1 end in L.', true, 'Correct: Rate scales with the number of ends: 1,001 ends versus 1 end gives about 1,000 times the initial rate.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 10 times faster, because H has a branch every 10 units.', false, 'The branch spacing of 10 units is not the ratio of ends, and 10,000 units with a branch every 10 give about 1,000 ends.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 10 times slower, because branching makes H more compact.', false, 'Branching increases the number of ends, so a compact shape does not slow release at each end.' from version_ins;
-- apbio-mcq-b6-sv-h-1.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.4-b-v1', 'mcq', 'relate branching of a glucose polymer to the number of chain ends and the rate of glucose release. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Muscle glycogen has a branch about every 10 glucose units, while plant amylopectin has a branch about every 25 units. A 5,000-unit molecule of each has one more chain end than its number of branches (glycogen about 501 ends, amylopectin about 201 ends). Assuming an enzyme removes glucose only from chain ends at equal rates per end, how does the initial release rate from glycogen compare with that from amylopectin?', null, md5('apbio-mcq-b6-sv-h-1.4-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 0.4 times as fast, because the glycogen is more compact.', false, 'This is the reciprocal of the ratio and treats more ends as slowing release.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 25 times faster, because glycogen has 25 minus 10 more branches.', false, 'Subtracting the branch spacings does not give the ratio of ends, which is 501 to 201.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 2.5 times faster for glycogen, in proportion to the number of ends.', true, 'Correct: 501 ends divided by 201 ends is about 2.5, so glycogen is mobilized about 2.5 times faster.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The same, because both molecules contain 5,000 glucose units.', false, 'Equal glucose content does not make the rates equal, because the enzyme acts at ends and the polymers have different numbers of ends.' from version_ins;
-- apbio-mcq-b6-sv-h-1.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.4-b-v2', 'mcq', 'relate branching of a glucose polymer to the number of chain ends and the rate of glucose release. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mutant mouse cannot make the enzyme that creates branch points in glycogen, so its glycogen is long and mostly unbranched. During a short burst of intense running, the mouse''s glycogen supply is the same size as in a normal mouse. Which outcome is most likely?', null, md5('apbio-mcq-b6-sv-h-1.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Faster release of glucose, because longer chains are easier for enzymes to process.', false, 'Fewer ends means fewer sites for the enzyme, so longer chains do not speed release.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Slower release of glucose during the burst, because there are fewer chain ends where enzymes can remove glucose.', true, 'Correct: Rapid glucose release depends on many ends, and unbranched glycogen has far fewer ends, so mobilization is slower for a short burst.' from version_ins
union all select gen_random_uuid(), id, 'C', 'No difference, because the amount of stored glucose determines the release rate.', false, 'The stem says the amount of stored glucose is equal, but release rate depends on how many ends are available, not on total amount.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Release of fructose, because unbranched chains are converted to a different sugar.', false, 'Removing branches does not convert glucose into another sugar; the monomer stays glucose.' from version_ins;
-- apbio-mcq-b6-sv-h-1.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.4-b-v3', 'mcq', 'relate branching of a glucose polymer to the number of chain ends and the rate of glucose release. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A polysaccharide of 8,000 glucose units has a branch about every 12 units (about 667 chain ends). A mutation shortens the spacing to a branch about every 6 units (about 1,333 chain ends). If an enzyme removes glucose from ends at a constant rate per end, how does the initial release rate change?', null, md5('apbio-mcq-b6-sv-h-1.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It roughly doubles, in proportion to the number of ends.', true, 'Correct: Ends increase from about 667 to about 1,333, which is a factor of two, so the release rate roughly doubles.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is halved, because shorter branches hold less glucose.', false, 'More branches means more ends, so the release rate rises rather than falls.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is unchanged, because the same 8,000 units are present.', false, 'Total glucose is unchanged but rate depends on the number of ends.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It rises about sixfold, because the spacing changed from 12 to 6 units.', false, 'Halving the spacing doubles the number of ends, so the rate changes by a factor of about two, not six.' from version_ins;
-- apbio-mcq-b6-h-1.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.5-a', 'mcq', 'predict how a lipid''s polar and nonpolar regions determine its arrangement in water.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Equal amounts of three lipids are added to separate tubes of water and shaken. Phospholipid: forms a cloudy mixture of tiny sacs, each enclosing a droplet of water. Triglyceride: forms oily droplets that merge into a layer on top and shows no ordered structure. Which statement best explains why the triglyceride does not assemble like the phospholipid?', null, md5('apbio-mcq-b6-h-1.5-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The triglyceride has a larger mass than the phospholipid, so it sinks.', false, 'The triglyceride floats on top, which shows it is less dense than water, so mass is not the cause.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The triglyceride has fewer fatty acid tails than the phospholipid, so it cannot form droplets.', false, 'A triglyceride has three fatty acid tails and a phospholipid has two, so the triglyceride does not have fewer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The triglyceride is hydrophilic, so it dissolves completely in water.', false, 'If the triglyceride were hydrophilic it would dissolve, but the observed layer of merged droplets shows it is hydrophobic.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The triglyceride has no polar head group, so the whole molecule is nonpolar and is excluded from water, whereas the phospholipid has a polar phosphate-containing head and nonpolar tails.', true, 'Correct: A triglyceride is entirely nonpolar, so it separates from water as a layer, but a phospholipid is amphipathic and its polar head faces water while tails face each other.' from version_ins;
-- apbio-mcq-b6-sv-h-1.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.5-a-v1', 'mcq', 'predict how a lipid''s polar and nonpolar regions determine its arrangement in water. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Phospholipids are mixed with water to form small vesicles, each with a bilayer wall surrounding a water-filled interior. A water-soluble blue dye and a nonpolar red dye are added to the mixture, and the vesicles are then separated and examined. Which result is most likely?', null, md5('apbio-mcq-b6-sv-h-1.5-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The blue dye is in the bilayer interior and the red dye is in the water-filled interior.', false, 'This reverses the placement, as a polar dye would not be found among nonpolar tails.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The blue dye is in the water-filled interior and the surrounding water, and the red dye is in the nonpolar fatty acid region of the bilayer.', true, 'Correct: Polar molecules stay in water, while a nonpolar dye dissolves among the hydrophobic fatty acid tails in the middle of the bilayer.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both dyes are in the water-filled interior, because they are small molecules.', false, 'A nonpolar dye is not soluble in water, so it would not remain in the aqueous interior.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither dye associates with the vesicle, because dyes cannot cross a bilayer.', false, 'A nonpolar dye can dissolve in the hydrophobic interior of the bilayer, so it does associate with the vesicles.' from version_ins;
-- apbio-mcq-b6-sv-h-1.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.5-a-v2', 'mcq', 'predict how a lipid''s polar and nonpolar regions determine its arrangement in water. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tube holds a layer of olive oil above a layer of water, and a small amount of phospholipid is added and the tube is shaken. Tiny oil droplets form and remain suspended in the water. Which arrangement of the phospholipid molecules at the surface of an oil droplet best explains the stable droplets?', null, md5('apbio-mcq-b6-sv-h-1.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fatty acid tails face the oil inside the droplet and phosphate heads face the surrounding water.', true, 'Correct: The tails are nonpolar and stay in oil, while the polar heads contact water, which makes the droplets stable and keeps them from merging.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Phosphate heads face the oil and fatty acid tails face the water.', false, 'Polar heads would not favor contact with nonpolar oil, and tails would not favor contact with water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Phospholipids lie flat on the droplet with heads and tails both facing the water.', false, 'Tails are nonpolar, so they would not be exposed to water by lying flat.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Phospholipids are dissolved in the oil as individual molecules and do not reach the surface.', false, 'Phospholipids are amphipathic and accumulate at the oil-water interface rather than dissolving entirely in the oil.' from version_ins;
-- apbio-mcq-b6-sv-h-1.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.5-a-v3', 'mcq', 'predict how a lipid''s polar and nonpolar regions determine its arrangement in water. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Phospholipids are dissolved in a nonpolar liquid, hexane, and a few drops of water are added. Small spherical structures form, each trapping a tiny water droplet. Which arrangement best explains the structures?', null, md5('apbio-mcq-b6-sv-h-1.5-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Phosphate heads face the hexane and tails surround the water droplet.', false, 'Heads are polar and would avoid hexane, and tails would not surround water.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Phosphate heads face the water droplet in the center and fatty acid tails extend into the hexane.', true, 'Correct: In a nonpolar solvent the polar heads cluster around the water and the tails extend into the hexane, the reverse of the arrangement in water.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Phospholipids form a double layer with water on both sides of it.', false, 'A bilayer with water on both sides forms in water, but here the surrounding liquid is hexane.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Phospholipids join the water droplet by covalent bonds between the tails and the water molecules.', false, 'The interactions are hydrogen bonds between heads and water and hydrophobic effects, not covalent bonds between tails and water.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.4-a-v3','apbio-mcq-b6-h-1.4-b','apbio-mcq-b6-sv-h-1.4-b-v1','apbio-mcq-b6-sv-h-1.4-b-v2','apbio-mcq-b6-sv-h-1.4-b-v3','apbio-mcq-b6-h-1.5-a','apbio-mcq-b6-sv-h-1.5-a-v1','apbio-mcq-b6-sv-h-1.5-a-v2','apbio-mcq-b6-sv-h-1.5-a-v3']) and status='draft')<>9 then raise exception 'chunk 4: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-sv-h-1.4-a-v3','apbio-mcq-b6-h-1.4-b','apbio-mcq-b6-sv-h-1.4-b-v1','apbio-mcq-b6-sv-h-1.4-b-v2','apbio-mcq-b6-sv-h-1.4-b-v3','apbio-mcq-b6-h-1.5-a','apbio-mcq-b6-sv-h-1.5-a-v1','apbio-mcq-b6-sv-h-1.5-a-v2','apbio-mcq-b6-sv-h-1.5-a-v3']))<>36 then raise exception 'chunk 4: expected 36 choices'; end if;
end $$;
commit;
