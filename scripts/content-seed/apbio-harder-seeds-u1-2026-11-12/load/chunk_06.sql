begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.6-b-v1','apbio-mcq-b6-sv-h-1.6-b-v2','apbio-mcq-b6-sv-h-1.6-b-v3','apbio-mcq-b6-h-1.7-a','apbio-mcq-b6-sv-h-1.7-a-v1','apbio-mcq-b6-sv-h-1.7-a-v2','apbio-mcq-b6-sv-h-1.7-a-v3','apbio-mcq-b6-h-1.7-b','apbio-mcq-b6-sv-h-1.7-b-v1'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apbio-mcq-b6-sv-h-1.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.6-b-v1', 'mcq', 'infer whether a nucleic acid is DNA or RNA, and whether it is double-stranded, from base composition. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A sample of double-stranded DNA from a fish is found to contain 18% thymine. What percentage of the bases is cytosine?', null, md5('apbio-mcq-b6-sv-h-1.6-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '32%', true, 'Correct: A = T = 18%, so A + T = 36%; the remaining 64% is G + C, with G = C, so cytosine is 32%.' from version_ins
union all select gen_random_uuid(), id, 'B', '18%', false, '18% is the percentage of thymine and adenine, and cytosine pairs with guanine rather than thymine.' from version_ins
union all select gen_random_uuid(), id, 'C', '64%', false, '64% is the total of G plus C, and cytosine is only half of this.' from version_ins
union all select gen_random_uuid(), id, 'D', '82%', false, '82% is 100 minus thymine and does not account for the pairing of A with T.' from version_ins;
-- apbio-mcq-b6-sv-h-1.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.6-b-v2', 'mcq', 'infer whether a nucleic acid is DNA or RNA, and whether it is double-stranded, from base composition. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A nucleic acid from a virus particle has the base composition adenine 20%, thymine 30%, guanine 25%, and cytosine 25%. Which conclusion is best supported?', null, md5('apbio-mcq-b6-sv-h-1.6-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'It is single-stranded DNA, because it contains thymine but the percentage of A does not equal T.', true, 'Correct: Thymine means DNA, and A is not equal to T, so the molecule is not fully base paired and is probably single-stranded.' from version_ins
union all select gen_random_uuid(), id, 'B', 'It is double-stranded DNA, because it contains thymine.', false, 'Double-stranded DNA would have equal A and T, but here they differ, so the molecule is probably not fully paired.' from version_ins
union all select gen_random_uuid(), id, 'C', 'It is RNA, because the percentages of adenine and thymine are different.', false, 'RNA contains uracil instead of thymine, and this sample contains thymine.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is double-stranded RNA, because G equals C.', false, 'RNA would contain uracil rather than thymine, so the presence of thymine rules out RNA.' from version_ins;
-- apbio-mcq-b6-sv-h-1.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.6-b-v3', 'mcq', 'infer whether a nucleic acid is DNA or RNA, and whether it is double-stranded, from base composition. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A nucleic acid sample has adenine 25%, uracil 25%, guanine 25%, and cytosine 25%. A student concludes it must be a double-stranded RNA. Which response is best?', null, md5('apbio-mcq-b6-sv-h-1.6-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sample is RNA because it contains uracil, but equal percentages alone do not prove it is double-stranded.', true, 'Correct: Uracil identifies RNA, but a single strand can have these percentages by chance, so double-strandedness cannot be proven from composition alone.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student is correct, because equal percentages prove pairing between strands.', false, 'A single strand could contain equal amounts of the four bases, so equal percentages are consistent with pairing but do not prove it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The sample must be DNA, because the percentages are equal.', false, 'DNA contains thymine, not uracil, so uracil rules out DNA.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sample must be single-stranded, because RNA is never double-stranded.', false, 'Some RNA viruses have double-stranded genomes, so RNA is not always single-stranded.' from version_ins;
-- apbio-mcq-b6-h-1.7-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.7-a', 'mcq', 'link denaturation treatments to the levels of protein structure that are altered.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme is heated to 95°C for 5 minutes and cooled to 25°C. Before heating, the enzyme is active, the amino acid sequence is determined, and a measurement finds that 40% of the chain is in alpha helices. After heating and cooling, activity is zero, the amino acid sequence is unchanged, the molecular mass is unchanged, and helices account for 5% of the chain. Which statement best explains the results?', null, md5('apbio-mcq-b6-h-1.7-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Heating broke peptide bonds, which changed the amino acid sequence.', false, 'The sequence is the same after heating, so peptide bonds were not broken.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Heating disrupted hydrogen bonds and other weak interactions that maintain secondary and tertiary structure, but left the covalent peptide bonds and primary structure intact.', true, 'Correct: Unchanged sequence and mass show that peptide bonds were not broken, while loss of helices and activity shows the folded structure was disrupted.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Heating changed the gene that codes for the enzyme, so a new protein was made.', false, 'Heating a purified protein does not change genes or make a new protein, and no DNA is present in the sample.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Heating removed amino acids from the chain, which lowered the helix content.', false, 'The unchanged molecular mass shows that no amino acids were removed.' from version_ins;
-- apbio-mcq-b6-sv-h-1.7-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.7-a-v1', 'mcq', 'link denaturation treatments to the levels of protein structure that are altered. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A purified enzyme is dissolved in a high concentration of urea, which disrupts hydrogen bonds and hydrophobic interactions but not peptide bonds, and the enzyme loses all activity. The urea is then slowly removed by dialysis, and 90% of the activity returns. Which conclusion is best supported?', null, md5('apbio-mcq-b6-sv-h-1.7-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The primary structure contains the information needed for the chain to refold into its functional shape once the denaturing agent is removed.', true, 'Correct: Peptide bonds and sequence were never altered, so the chain refolded using the information in its amino acid sequence once the conditions allowed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Urea broke peptide bonds, which formed again when the urea was removed.', false, 'Urea does not break covalent peptide bonds, so nothing needs to reform.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The enzyme had been permanently damaged, because activity can never return after denaturation.', false, 'In this experiment activity returned to 90%, so denaturation was reversible.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Urea changed the amino acid sequence, and dialysis restored the original sequence.', false, 'Urea does not change the order of amino acids, so no restoration of sequence was needed.' from version_ins;
-- apbio-mcq-b6-sv-h-1.7-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.7-a-v2', 'mcq', 'link denaturation treatments to the levels of protein structure that are altered. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student boils an egg. The clear liquid egg white, which is mostly the protein albumin dissolved in water, becomes an opaque white solid. The student claims the heat must have changed the protein''s amino acid sequence. Which response is best supported?', null, md5('apbio-mcq-b6-sv-h-1.7-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The student is correct, because heat rearranges amino acids in the polypeptide.', false, 'Heat does not rearrange the order of amino acids, which are joined by strong covalent peptide bonds.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The student is correct, because heat converts the protein into fat.', false, 'Heat does not convert protein into fat, since the chemical composition of a protein stays amino acid based.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The student is incorrect, because heat unfolds the protein and exposes hydrophobic regions, which lets the chains stick together and form a solid, while the sequence stays the same.', true, 'Correct: Cooking denatures albumin by disrupting weak interactions; exposed hydrophobic regions cause aggregation, and the primary structure stays unchanged.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The student is incorrect, because heat has no effect on proteins at cooking temperatures.', false, 'The egg white changes visibly at cooking temperatures, which shows that proteins are affected.' from version_ins;
-- apbio-mcq-b6-sv-h-1.7-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.7-a-v3', 'mcq', 'link denaturation treatments to the levels of protein structure that are altered. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A stomach enzyme works best at pH 2 but is inactive at pH 8. A related intestinal enzyme works best at pH 8 and is inactive at pH 2. Sequencing shows each enzyme has the same amino acid sequence at pH 2 and at pH 8. Which statement best explains why changing the pH can inactivate an enzyme without changing its sequence?', null, md5('apbio-mcq-b6-sv-h-1.7-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Changing pH changes the charges on acidic and basic R groups, which alters ionic and hydrogen-bond interactions and therefore the folded shape.', true, 'Correct: Protonation or deprotonation of R groups changes their charge, disrupting the interactions that hold the tertiary structure, while the sequence remains the same.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Changing pH breaks peptide bonds and shortens the polypeptide.', false, 'The sequence is unchanged at both pH values, so peptide bonds are intact.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Changing pH alters the genes that code for the enzyme.', false, 'Genes are not present in the purified enzyme and pH does not change the protein''s sequence.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Changing pH removes the carbon backbone from the protein.', false, 'The polypeptide backbone remains intact, and the pH changes only the charges on R groups.' from version_ins;
-- apbio-mcq-b6-h-1.7-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-h-1.7-b', 'mcq', 'deduce the number and linkage of polypeptide subunits (quaternary structure) from gel data.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A protein has a mass of 120 kDa in its native form. On a gel containing a detergent that separates subunits held by noncovalent interactions and unfolds each chain but does not break covalent bonds, the protein gives a single band at 60 kDa. When a reducing agent that breaks disulfide bonds is also added, the protein gives a single band at 30 kDa. Which structure is best supported?', null, md5('apbio-mcq-b6-h-1.7-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One polypeptide of 120 kDa, because the detergent cut it into pieces.', false, 'The detergent used does not cut peptide bonds, so a single 120 kDa chain would give a 120 kDa band.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Four identical 30 kDa polypeptides linked by disulfide bonds into a single unit.', false, 'If all four were linked by disulfide bonds, the band without reducing agent would be 120 kDa.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Four 30 kDa polypeptides, in which pairs are joined by disulfide bonds and the two pairs are held together by noncovalent interactions.', true, 'Correct: The 60 kDa bands show two pairs linked by covalent disulfide bonds, and the 30 kDa band after reduction shows each pair is two 30 kDa chains, giving four chains.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Two different polypeptides of 60 kDa and 30 kDa that are held together by noncovalent interactions.', false, 'Only one band size appears under each condition, so the sample does not contain a second type of polypeptide.' from version_ins;
-- apbio-mcq-b6-sv-h-1.7-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.7-b-v1', 'mcq', 'deduce the number and linkage of polypeptide subunits (quaternary structure) from gel data. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A protein has a native mass of 64 kDa. A gel with detergent but no reducing agent shows two bands of 16 kDa, containing different polypeptides in a 1:1 ratio (equal amounts of each). Adding a reducing agent does not change the pattern. Which structure is best supported?', null, md5('apbio-mcq-b6-sv-h-1.7-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A single polypeptide of 64 kDa cut by the detergent into four pieces.', false, 'The detergent does not cleave covalent peptide bonds, so a single 64 kDa polypeptide would stay intact.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Two 32 kDa polypeptides joined by disulfide bonds.', false, 'The gel shows 16 kDa bands, not 32 kDa, and the reducing agent changed nothing, so disulfide links are not present.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Four identical 16 kDa polypeptides joined by disulfide bonds.', false, 'The gel shows two different polypeptides, so the four chains are not all identical.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Four polypeptides, two of each of two types, held together by noncovalent interactions with no interchain disulfide bonds.', true, 'Correct: Four 16 kDa chains add to 64 kDa, the pattern is unchanged by the reducing agent so there are no interchain disulfides, and the two bands show two kinds of chain.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.6-b-v1','apbio-mcq-b6-sv-h-1.6-b-v2','apbio-mcq-b6-sv-h-1.6-b-v3','apbio-mcq-b6-h-1.7-a','apbio-mcq-b6-sv-h-1.7-a-v1','apbio-mcq-b6-sv-h-1.7-a-v2','apbio-mcq-b6-sv-h-1.7-a-v3','apbio-mcq-b6-h-1.7-b','apbio-mcq-b6-sv-h-1.7-b-v1']) and status='draft')<>9 then raise exception 'chunk 6: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-sv-h-1.6-b-v1','apbio-mcq-b6-sv-h-1.6-b-v2','apbio-mcq-b6-sv-h-1.6-b-v3','apbio-mcq-b6-h-1.7-a','apbio-mcq-b6-sv-h-1.7-a-v1','apbio-mcq-b6-sv-h-1.7-a-v2','apbio-mcq-b6-sv-h-1.7-a-v3','apbio-mcq-b6-h-1.7-b','apbio-mcq-b6-sv-h-1.7-b-v1']))<>36 then raise exception 'chunk 6: expected 36 choices'; end if;
end $$;
commit;
