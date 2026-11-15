begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.2-a-v1','apbio-mcq-b6-sv-h-1.2-a-v2','apbio-mcq-b6-sv-h-1.2-a-v3','apbio-mcq-b6-h-1.2-b','apbio-mcq-b6-sv-h-1.2-b-v1','apbio-mcq-b6-sv-h-1.2-b-v2','apbio-mcq-b6-sv-h-1.2-b-v3','apbio-mcq-b6-h-1.3-a','apbio-mcq-b6-sv-h-1.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b6-sv-h-1.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.2-a-v1', 'mcq', 'use radioactive element labels to infer which biological molecules incorporate which elements. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A virus consists of a protein coat surrounding a DNA genome. Two batches of the virus are grown in bacteria: batch 1 in medium with radioactive sulfur, and batch 2 in medium with radioactive phosphorus. Purified virus from each batch is then used to infect new bacteria. After infection, the bacteria are separated from the empty coats, and radioactivity is measured in the bacterial pellet. Which result is expected?', null, md5('apbio-mcq-b6-sv-h-1.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both batches give a strongly radioactive pellet, because sulfur and phosphorus are both in DNA.', false, 'DNA does not contain sulfur, so a sulfur label could not be found in the DNA that entered the bacteria.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Batch 1 gives a strongly radioactive pellet, because DNA contains sulfur and enters the bacteria.', false, 'Sulfur is in some amino acids of the coat protein, not in DNA, so the sulfur label stays with the coats.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Batch 2 gives a strongly radioactive pellet, because DNA contains phosphorus and enters the bacteria, while the sulfur-labeled coats stay outside.', true, 'Correct: DNA carries phosphorus but no sulfur, and in this experiment the DNA enters the cells while the protein coats remain outside, so the phosphorus label is found in the pellet.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Neither batch gives a radioactive pellet, because the labeled elements are lost when the virus replicates.', false, 'The labeled DNA entering the cells is a physical part of the infection, so its phosphorus label remains measurable in the pellet.' from version_ins;
-- apbio-mcq-b6-sv-h-1.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.2-a-v2', 'mcq', 'use radioactive element labels to infer which biological molecules incorporate which elements. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Algae are grown for several generations in a medium whose only nitrogen source is a heavy isotope of nitrogen (15N). The cells are then broken open and the following molecules are purified and compared with those from algae grown in normal nitrogen: triglycerides, cellulose, proteins, and DNA. Which purified molecules are expected to be heavier than normal?', null, md5('apbio-mcq-b6-sv-h-1.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Triglycerides and DNA, because both store energy and information in long chains.', false, 'Triglycerides contain only carbon, hydrogen, and oxygen, so they would not take up the heavy nitrogen label even though they store energy.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cellulose and proteins, because both are structural polymers.', false, 'Cellulose is a polymer of glucose containing no nitrogen, so structural function does not determine nitrogen content.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All four molecules, because every biological molecule contains nitrogen.', false, 'Carbohydrates and triglycerides contain no nitrogen, so not every molecule would be heavier.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Proteins and DNA, because amino acids and nucleotide bases contain nitrogen, whereas triglycerides and cellulose do not.', true, 'Correct: Nitrogen is in the amino group of amino acids and in the bases of nucleotides, but triglycerides and cellulose contain only carbon, hydrogen, and oxygen.' from version_ins;
-- apbio-mcq-b6-sv-h-1.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.2-a-v3', 'mcq', 'use radioactive element labels to infer which biological molecules incorporate which elements. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Yeast cells are given radioactive phosphate for one hour. The cells are then separated into four purified molecule groups: ATP, DNA, phospholipids, and the glucose in the medium that was taken up by the cells. Which groups should contain the label?', null, md5('apbio-mcq-b6-sv-h-1.2-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'ATP, DNA, and phospholipids, because each contains phosphate groups.', true, 'Correct: ATP, DNA backbones, and phospholipid heads each contain phosphate, while glucose is made of only carbon, hydrogen, and oxygen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'DNA only, because phosphate is used only for genetic information.', false, 'Phosphate is also in ATP and in the heads of phospholipids, so the label would not be limited to DNA.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Glucose and phospholipids, because they supply energy and phosphate to the cell.', false, 'Glucose has no phosphorus, so it could not carry a phosphate label, even though cells use it as a fuel.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four groups, because glucose is converted into phosphate by the cell.', false, 'Cells do not convert glucose into phosphate, because phosphorus is an element that cannot be made from carbon, hydrogen, and oxygen.' from version_ins;
-- apbio-mcq-b6-h-1.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.2-b', 'mcq', 'assign macromolecule classes from elemental composition data.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A laboratory analyzes four purified biological samples and reports the percent by mass of each element. Sample W: carbon 40.0, hydrogen 6.7, oxygen 53.3. Sample X: carbon 77, hydrogen 12, oxygen 11. Sample Y: carbon 52, hydrogen 7, oxygen 23, nitrogen 16, sulfur 2. Sample Z: carbon 35, hydrogen 4, oxygen 33, nitrogen 19, phosphorus 9. Which assignment of samples to macromolecule class is best supported?', null, md5('apbio-mcq-b6-h-1.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'W is a carbohydrate, X is a lipid, Y is a protein, and Z is a nucleic acid.', true, 'Correct: W has the 1:2:1 ratio of C:H:O in carbohydrates, X is very low in oxygen like a fat, sulfur in Y fits protein, and nitrogen plus phosphorus in Z fits a nucleic acid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'W is a protein, X is a nucleic acid, Y is a carbohydrate, and Z is a lipid.', false, 'Carbohydrates and lipids contain no nitrogen, so Y with 16 percent nitrogen cannot be a carbohydrate and Z cannot be a lipid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'W is a lipid, X is a carbohydrate, Y is a protein, and Z is a nucleic acid.', false, 'The sample with almost no oxygen is the lipid and the sample with a 1:2:1 ratio of carbon, hydrogen, and oxygen is the carbohydrate, which reverses W and X.' from version_ins
union all select gen_random_uuid(), id, 'D', 'W is a carbohydrate, X is a lipid, Y is a nucleic acid, and Z is a protein.', false, 'Phosphorus is part of the sugar-phosphate backbone of nucleic acids and is not part of the amino acids in proteins, so Y and Z are reversed.' from version_ins;
-- apbio-mcq-b6-sv-h-1.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.2-b-v1', 'mcq', 'assign macromolecule classes from elemental composition data. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four samples are analyzed. Sample Q: carbon 63, hydrogen 10, oxygen 21, nitrogen 2, phosphorus 4. Sample R: carbon 36, hydrogen 4, oxygen 33, nitrogen 19, phosphorus 8. Sample S: carbon 53, hydrogen 7, oxygen 24, nitrogen 15, sulfur 1. Sample T: carbon 44.4, hydrogen 6.2, oxygen 49.4. Which assignment is best supported?', null, md5('apbio-mcq-b6-sv-h-1.2-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Q is a nucleic acid, R is a phospholipid, S is a protein, and T is a polysaccharide.', false, 'Nucleic acids have a high nitrogen percentage from their bases, whereas the low nitrogen and high carbon in Q fits a phospholipid, so the pair is reversed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Q is a phospholipid, R is a nucleic acid, S is a protein, and T is a polysaccharide.', true, 'Correct: Q has high carbon with a little nitrogen and phosphorus (a phospholipid head with long carbon chains), R has high nitrogen with phosphorus (nucleic acid), S has nitrogen and sulfur (protein), and T is C:H:O near 1:2:1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Q is a protein, R is a nucleic acid, S is a phospholipid, and T is a polysaccharide.', false, 'Sample S contains sulfur but no phosphorus and is a better match for protein, while Q with high carbon and phosphorus is not a protein.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Q is a phospholipid, R is a protein, S is a nucleic acid, and T is a lipid.', false, 'T has hydrogen and oxygen in about a 2:1 ratio like a carbohydrate, and lipids have much less oxygen.' from version_ins;
-- apbio-mcq-b6-sv-h-1.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.2-b-v2', 'mcq', 'assign macromolecule classes from elemental composition data. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A purified polypeptide from a bacterium is analyzed and found to contain carbon, hydrogen, oxygen, and nitrogen, but no sulfur. A student concludes that the sample cannot be a protein because "all proteins contain sulfur." Which response is best?', null, md5('apbio-mcq-b6-sv-h-1.2-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student is correct, because sulfur forms the peptide bonds that join amino acids.', false, 'Peptide bonds form between a carboxyl carbon and an amino nitrogen and contain no sulfur.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student is correct, because the nitrogen in the sample shows that it is a nucleic acid instead.', false, 'Nucleic acids contain phosphorus, and the lack of phosphorus here suggests it is not a nucleic acid; nitrogen alone does not separate the classes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student is incorrect, because sulfur is in the amino group of every amino acid.', false, 'The amino group contains nitrogen and hydrogen, and sulfur appears only in the R groups of a few amino acids.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student is incorrect, because sulfur is found only in the R groups of the amino acids cysteine and methionine, so a protein lacking those amino acids has no sulfur.', true, 'Correct: Only two of the 20 amino acids, cysteine and methionine, contain sulfur, so a polypeptide without them can lack sulfur and remain a protein.' from version_ins;
-- apbio-mcq-b6-sv-h-1.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.2-b-v3', 'mcq', 'assign macromolecule classes from elemental composition data. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A lipid extract from a cell membrane is analyzed and found to contain carbon, hydrogen, oxygen, phosphorus, and a small amount of nitrogen. A fat extract from a seed contains only carbon, hydrogen, and oxygen. Which statement best explains the difference between the two extracts?', null, md5('apbio-mcq-b6-sv-h-1.2-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The membrane lipid is a triglyceride, and the seed fat is a phospholipid.', false, 'This is reversed, because triglycerides lack phosphorus and the seed fat with only carbon, hydrogen, and oxygen matches a triglyceride.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The nitrogen and phosphorus in the membrane lipid come from its long hydrocarbon chains.', false, 'Hydrocarbon chains are made of carbon and hydrogen only, so they cannot be the source of nitrogen or phosphorus.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The membrane lipid is a phospholipid with a phosphate-containing head group, often with a nitrogen-containing group, whereas a triglyceride has only glycerol and fatty acids.', true, 'Correct: Phospholipid heads add phosphate and often a nitrogenous group such as choline, whereas triglycerides consist only of glycerol and fatty acids, which contain only C, H, and O.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The membrane lipid contains amino acids, which a seed fat lacks.', false, 'A membrane lipid does not contain amino acids or peptide bonds, and its nitrogen comes from a small head group.' from version_ins;
-- apbio-mcq-b6-h-1.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.3-a', 'mcq', 'account for the mass of water lost in dehydration synthesis when calculating the mass of a polymer.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A linear polysaccharide is built by dehydration synthesis from 12 glucose monomers. Each free glucose molecule has a molar mass of 180 g/mol, and each water molecule released has a molar mass of 18 g/mol. What is the molar mass of the polymer?', null, md5('apbio-mcq-b6-h-1.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1962 g/mol, because 11 bonds form and 11 water molecules are released.', true, 'Correct: 12 x 180 = 2160 g/mol for the monomers; a linear chain of 12 has 11 bonds, so subtract 11 x 18 = 198, giving 1962 g/mol.' from version_ins
union all select gen_random_uuid(), id, 'B', '2160 g/mol, because the polymer has the same mass as its 12 monomers added together.', false, 'This ignores that each dehydration reaction releases a water molecule, so the polymer is lighter than its monomers.' from version_ins
union all select gen_random_uuid(), id, 'C', '1944 g/mol, because one water molecule is released for each of the 12 monomers.', false, 'A linear chain of 12 monomers has 11 bonds, not 12, so only 11 waters are lost.' from version_ins
union all select gen_random_uuid(), id, 'D', '2358 g/mol, because each bond that forms adds one water molecule to the polymer.', false, 'Dehydration synthesis removes water from the monomers rather than adding it, so this reverses the direction of the mass change.' from version_ins;
-- apbio-mcq-b6-sv-h-1.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.3-a-v1', 'mcq', 'account for the mass of water lost in dehydration synthesis when calculating the mass of a polymer. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cell links 10 amino acids, with an average molar mass of 120 g/mol each, into a linear polypeptide. Each peptide bond formed releases one water molecule (18 g/mol). What is the molar mass of the polypeptide?', null, md5('apbio-mcq-b6-sv-h-1.3-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1200 g/mol', false, 'This is the sum of the free amino acids and ignores the water that leaves with each peptide bond.' from version_ins
union all select gen_random_uuid(), id, 'B', '1020 g/mol', false, 'This subtracts 10 waters (180), but a linear chain of 10 amino acids has only 9 peptide bonds.' from version_ins
union all select gen_random_uuid(), id, 'C', '1038 g/mol', true, 'Correct: 10 x 120 = 1200 g/mol; 9 peptide bonds release 9 x 18 = 162 g/mol of water, so the polypeptide is 1200 - 162 = 1038 g/mol.' from version_ins
union all select gen_random_uuid(), id, 'D', '1362 g/mol', false, 'This adds 162 to the monomer total, which treats dehydration synthesis as adding water rather than removing it.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.2-a-v1','apbio-mcq-b6-sv-h-1.2-a-v2','apbio-mcq-b6-sv-h-1.2-a-v3','apbio-mcq-b6-h-1.2-b','apbio-mcq-b6-sv-h-1.2-b-v1','apbio-mcq-b6-sv-h-1.2-b-v2','apbio-mcq-b6-sv-h-1.2-b-v3','apbio-mcq-b6-h-1.3-a','apbio-mcq-b6-sv-h-1.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-sv-h-1.2-a-v1','apbio-mcq-b6-sv-h-1.2-a-v2','apbio-mcq-b6-sv-h-1.2-a-v3','apbio-mcq-b6-h-1.2-b','apbio-mcq-b6-sv-h-1.2-b-v1','apbio-mcq-b6-sv-h-1.2-b-v2','apbio-mcq-b6-sv-h-1.2-b-v3','apbio-mcq-b6-h-1.3-a','apbio-mcq-b6-sv-h-1.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
