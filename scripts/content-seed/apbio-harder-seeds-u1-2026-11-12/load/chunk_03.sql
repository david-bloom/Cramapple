begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.3-a-v2','apbio-mcq-b6-sv-h-1.3-a-v3','apbio-mcq-b6-h-1.3-b','apbio-mcq-b6-sv-h-1.3-b-v1','apbio-mcq-b6-sv-h-1.3-b-v2','apbio-mcq-b6-sv-h-1.3-b-v3','apbio-mcq-b6-h-1.4-a','apbio-mcq-b6-sv-h-1.4-a-v1','apbio-mcq-b6-sv-h-1.4-a-v2'])) then raise exception 'chunk 3 already loaded'; end if;
end $$;
-- apbio-mcq-b6-sv-h-1.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.3-a-v2', 'mcq', 'account for the mass of water lost in dehydration synthesis when calculating the mass of a polymer. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear polymer has a measured molar mass of 2658 g/mol. It was made by dehydration synthesis from identical monomers, each with a molar mass of 150 g/mol, and one water molecule (18 g/mol) was released for each bond. How many monomers does the polymer contain?', null, md5('apbio-mcq-b6-sv-h-1.3-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '18', false, 'Dividing 2658 by 150 gives about 17.7, which ignores the water lost in forming the bonds.' from version_ins
union all select gen_random_uuid(), id, 'B', '22', false, '22 monomers would give 22 x 150 - 21 x 18 = 2922 g/mol, which is larger than the measured mass.' from version_ins
union all select gen_random_uuid(), id, 'C', '19', false, '19 is the number of bonds in the chain of 20 monomers, not the number of monomers.' from version_ins
union all select gen_random_uuid(), id, 'D', '20', true, 'Correct: For n monomers the mass is 150n - 18(n - 1) = 132n + 18; setting this equal to 2658 gives n = 20.' from version_ins;
-- apbio-mcq-b6-sv-h-1.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.3-a-v3', 'mcq', 'account for the mass of water lost in dehydration synthesis when calculating the mass of a polymer. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear polymer with a molar mass of 3000 g/mol contains 24 monomers. Complete hydrolysis converts it into 24 free monomers by adding water at every bond (18 g/mol per water). What is the total molar mass of the 24 free monomers?', null, md5('apbio-mcq-b6-sv-h-1.3-a-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3000 g/mol, because mass is conserved and the monomers have the same mass as the polymer.', false, 'Hydrolysis adds water, so the products include the mass of the added water and the monomers together weigh more than the polymer.' from version_ins
union all select gen_random_uuid(), id, 'B', '3414 g/mol, because 23 water molecules are added.', true, 'Correct: A chain of 24 monomers has 23 bonds, so hydrolysis adds 23 x 18 = 414 g/mol of water: 3000 + 414 = 3414 g/mol.' from version_ins
union all select gen_random_uuid(), id, 'C', '2586 g/mol, because the monomers are smaller than the polymer.', false, 'This subtracts the water mass, but hydrolysis adds water rather than removing it.' from version_ins
union all select gen_random_uuid(), id, 'D', '3432 g/mol, because 24 water molecules are added.', false, 'This uses 24 bonds, but a linear chain of 24 monomers has only 23 bonds.' from version_ins;
-- apbio-mcq-b6-h-1.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.3-b', 'mcq', 'distinguish true polymers from large molecules built by dehydration synthesis that are not polymers.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four purified samples are completely hydrolyzed and the products are identified. Sample 1 gives only one kind of six-carbon sugar, with many molecules per original molecule. Sample 2 gives many molecules from about 20 kinds of compounds that each have an amino group and a carboxyl group. Sample 3 gives four kinds of compounds, each with a nitrogenous base, a sugar, and phosphate. Sample 4 gives, per original molecule, one three-carbon alcohol and three long-chain fatty acids. Which sample is NOT a polymer made of a long chain of repeating monomers, even though it was assembled by dehydration synthesis?', null, md5('apbio-mcq-b6-h-1.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sample 1, because it contains only one type of monomer.', false, 'A polysaccharide made from one type of monomer is still a polymer, since many identical units are linked by dehydration synthesis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sample 4, because it is assembled from glycerol and three fatty acids rather than a chain of repeating monomers.', true, 'Correct: Samples 1 to 3 break down into many repeating monomers (monosaccharides, amino acids, nucleotides), but a triglyceride is built from one glycerol and three fatty acids.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sample 2, because it contains more than one kind of monomer.', false, 'Proteins are polymers even though they contain about 20 types of amino acid monomers.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sample 3, because its products contain three different parts.', false, 'Each nucleotide has three parts, but nucleic acids are chains of many nucleotide monomers and are polymers.' from version_ins;
-- apbio-mcq-b6-sv-h-1.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.3-b-v1', 'mcq', 'distinguish true polymers from large molecules built by dehydration synthesis that are not polymers. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student says: "A triglyceride is a polymer, because three fatty acids are joined to glycerol by three dehydration reactions and hydrolysis gives smaller units back." Which response is best?', null, md5('apbio-mcq-b6-sv-h-1.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student is partly correct about the reactions, but a triglyceride is not a polymer, because it is not a long chain of repeated similar monomers.', true, 'Correct: Triglycerides do form by dehydration synthesis and break by hydrolysis, but they consist of one glycerol and three fatty acids, which is not a chain of repeating monomers.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student is correct, because any molecule formed by dehydration synthesis is a polymer.', false, 'Dehydration synthesis alone does not make a polymer, since a polymer needs many repeated monomers linked in a chain.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student is incorrect, because triglycerides form without any dehydration synthesis.', false, 'Ester bonds in triglycerides are formed by dehydration synthesis, with release of water.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student is incorrect, because a triglyceride is too small to be a molecule at all.', false, 'A triglyceride is a molecule, and the problem with calling it a polymer is its structure, not whether it is a molecule.' from version_ins;
-- apbio-mcq-b6-sv-h-1.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.3-b-v2', 'mcq', 'distinguish true polymers from large molecules built by dehydration synthesis that are not polymers. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Complete hydrolysis of an unknown large molecule yields about 20 different small compounds. Every one of them contains an amino group and a carboxyl group, differs only in the group attached to the central carbon, and the products contain no phosphorus. Which statement is best supported?', null, md5('apbio-mcq-b6-sv-h-1.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The molecule is a nucleic acid, because the products contain nitrogen.', false, 'Nucleotides contain phosphate and a nitrogenous base, and no phosphorus was found in these products.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The molecule is a protein, a polymer of amino acid monomers joined by peptide bonds.', true, 'Correct: Monomers with an amino group, a carboxyl group, and a variable side chain are amino acids, and polymers of amino acids are proteins.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The molecule is a polysaccharide, because it is large and breaks into small units.', false, 'Monosaccharide monomers contain carbon, hydrogen, and oxygen only, so they lack amino groups.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The molecule is a phospholipid, because the products have both polar and nonpolar groups.', false, 'Phospholipids hydrolyze into glycerol, fatty acids, and a phosphate group, and these products are not amino acids.' from version_ins;
-- apbio-mcq-b6-sv-h-1.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.3-b-v3', 'mcq', 'distinguish true polymers from large molecules built by dehydration synthesis that are not polymers. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cell extract contains a polysaccharide, a polypeptide, a DNA strand, and a triglyceride. Complete hydrolysis of each releases its building blocks. Which pairing of molecule and the products of its hydrolysis is correct?', null, md5('apbio-mcq-b6-sv-h-1.3-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The polysaccharide releases nucleotides.', false, 'Polysaccharides are polymers of monosaccharides, and nucleotides come from nucleic acids.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The polypeptide releases glycerol and fatty acids.', false, 'Polypeptides break down to amino acids, and glycerol and fatty acids come from triglycerides.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The DNA strand releases nucleotides.', true, 'Correct: A nucleic acid is a polymer of nucleotides, so hydrolysis of a DNA strand releases nucleotides.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The triglyceride releases amino acids.', false, 'Triglycerides break down to glycerol and fatty acids, and amino acids come from the hydrolysis of proteins.' from version_ins;
-- apbio-mcq-b6-h-1.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.4-a', 'mcq', 'explain enzyme specificity toward glucose polymers by the orientation of the glycosidic linkage.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme preparation called amylase is added to four glucose-containing substances and incubated. Results: starch (glucose units linked alpha-1,4) is broken into maltose and glucose; glycogen (alpha-1,4 and alpha-1,6 links) is broken into maltose and glucose; maltose (two glucose units linked alpha-1,4) is broken into glucose; and cellulose (glucose units linked beta-1,4) shows no breakdown. Which hypothesis best explains the results?', null, md5('apbio-mcq-b6-h-1.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cellulose contains a monomer other than glucose, so the enzyme cannot recognize it.', false, 'The stem states cellulose consists of glucose units, so a different monomer does not explain the result.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The amylase active site fits alpha-linked glucose, and the beta-1,4 linkage in cellulose has a different orientation that does not fit the active site.', true, 'Correct: All four substances contain glucose, and the enzyme acts on all with alpha linkages but not on beta linkages, so the specificity depends on linkage orientation and active site shape.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cellulose has no covalent bonds between glucose units, so there is nothing for the enzyme to break.', false, 'Cellulose is held together by covalent beta-1,4 glycosidic bonds, and hydrogen bonds between chains are not the bonds linking monomers.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cellulose molecules are too small for the enzyme to bind.', false, 'Cellulose is a very long polymer, so size is not what prevents the enzyme from acting.' from version_ins;
-- apbio-mcq-b6-sv-h-1.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.4-a-v1', 'mcq', 'explain enzyme specificity toward glucose polymers by the orientation of the glycosidic linkage. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cow is fed only grass, whose carbohydrate is mostly cellulose, and it gains weight normally. A second cow receives the same diet along with an antibiotic that kills most of the microorganisms in its rumen, and it loses weight. Mammals do not produce enzymes that cleave beta-1,4 glucose linkages. Which statement best explains the results?', null, md5('apbio-mcq-b6-sv-h-1.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Antibiotics destroy the cow''s own amylase, which digests cellulose.', false, 'Amylase cuts alpha-1,4 links in starch and does not digest cellulose, and antibiotics act on microorganisms.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cellulose in grass is made of amino acids that the antibiotic prevents the cow from absorbing.', false, 'Cellulose is a polymer of glucose, not amino acids, so this describes the wrong molecule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The antibiotic changes cellulose into starch, which the cow cannot digest.', false, 'Antibiotics do not chemically convert cellulose to starch, and the weight loss results from the loss of microbial enzymes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Rumen microorganisms provide enzymes that hydrolyze the beta-1,4 linkages of cellulose, releasing glucose the cow can use.', true, 'Correct: The cow lacks enzymes for beta-1,4 linkages; microbes supply them, and when the microbes are killed the cow cannot release glucose from cellulose.' from version_ins;
-- apbio-mcq-b6-sv-h-1.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.4-a-v2', 'mcq', 'explain enzyme specificity toward glucose polymers by the orientation of the glycosidic linkage. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A person drinks milk and develops digestive distress. The person digests starch and table sugar (sucrose) normally. Milk sugar is lactose, a disaccharide of glucose and galactose joined by a beta-1,4 linkage. Tests show the person''s intestinal cells do not make lactase, the enzyme that cleaves this linkage. Which statement best explains why the person digests starch but not lactose?', null, md5('apbio-mcq-b6-sv-h-1.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Each digestive enzyme fits a particular sugar and linkage, so enzymes for alpha-linked starch and for sucrose cannot substitute for lactase.', true, 'Correct: Enzyme specificity depends on the shape of the active site, so a specific enzyme is required for each linkage and sugar, and lactase is missing here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Lactose is a polysaccharide that is too long for any enzyme to cut.', false, 'Lactose is a disaccharide, and its small size is not what prevents digestion.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The enzymes that digest starch and sucrose can cut any glycosidic bond, so lactose should be digested the same way.', false, 'Enzymes are specific for their substrates, so enzymes for starch and sucrose do not cut the beta-1,4 bond in lactose.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Lactose contains no glucose, so it cannot be hydrolyzed.', false, 'Lactose contains a glucose unit, and the problem is a missing enzyme rather than missing glucose.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.3-a-v2','apbio-mcq-b6-sv-h-1.3-a-v3','apbio-mcq-b6-h-1.3-b','apbio-mcq-b6-sv-h-1.3-b-v1','apbio-mcq-b6-sv-h-1.3-b-v2','apbio-mcq-b6-sv-h-1.3-b-v3','apbio-mcq-b6-h-1.4-a','apbio-mcq-b6-sv-h-1.4-a-v1','apbio-mcq-b6-sv-h-1.4-a-v2']) and status='draft')<>9 then raise exception 'chunk 3: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-sv-h-1.3-a-v2','apbio-mcq-b6-sv-h-1.3-a-v3','apbio-mcq-b6-h-1.3-b','apbio-mcq-b6-sv-h-1.3-b-v1','apbio-mcq-b6-sv-h-1.3-b-v2','apbio-mcq-b6-sv-h-1.3-b-v3','apbio-mcq-b6-h-1.4-a','apbio-mcq-b6-sv-h-1.4-a-v1','apbio-mcq-b6-sv-h-1.4-a-v2']))<>36 then raise exception 'chunk 3: expected 36 choices'; end if;
end $$;
commit;
