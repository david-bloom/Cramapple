begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-2.10-a','apbio-mcq-b5-sv-h-2.10-a-v1','apbio-mcq-b5-sv-h-2.10-a-v2','apbio-mcq-b5-sv-h-2.10-a-v3','apbio-mcq-b5-h-2.10-b','apbio-mcq-b5-sv-h-2.10-b-v1','apbio-mcq-b5-sv-h-2.10-b-v2','apbio-mcq-b5-sv-h-2.10-b-v3'])) then raise exception 'chunk 9 already loaded'; end if;
end $$;
-- apbio-mcq-b5-h-2.10-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.10-a', 'mcq', 'interpret molecular sequence, antibiotic, or genome data as evidence for the endosymbiotic origin of mitochondria and ch', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher compares the gene for ribosomal RNA found in the mitochondria of a yeast cell with three other sequences. The mitochondrial gene is 80% identical to the equivalent gene of a purple bacterium, 55% identical to the equivalent gene of an archaeon, and 52% identical to the yeast''s own nuclear gene for ribosomal RNA. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.10-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mitochondria arose from the nucleus by infolding of the nuclear envelope.', false, 'A nuclear origin would predict mitochondrial genes most similar to nuclear genes, but the similarity to the nucleus is the lowest of the three.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mitochondria are archaeal in origin, because 55% identity is the highest similarity to an archaeon.', false, '55% is a lower similarity than the 80% shared with the bacterium, so the data do not point to an archaeal origin of mitochondria.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mitochondrial genes are more similar to those of bacteria than to those of the host''s nucleus, which supports an origin from an engulfed bacterium.', true, 'Correct: The mitochondrial sequence is much closer to a bacterial sequence (80%) than to the host nuclear sequence (52%) or an archaeal sequence (55%), the pattern predicted if mitochondria descended from a bacterium taken up by a host cell.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The similarity is the result of the bacterium having been derived from mitochondria.', false, 'The bacterium is a free-living cell, and the data cannot show that it came from an organelle; the usual direction is the reverse.' from version_ins;
-- apbio-mcq-b5-sv-h-2.10-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.10-a-v1', 'mcq', 'interpret molecular sequence, antibiotic, or genome data as evidence for the endosymbiotic origin of mitochondria and ch (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The antibiotic chloramphenicol blocks protein synthesis by bacterial ribosomes but does not block protein synthesis by the cytosolic ribosomes of eukaryotic cells. When added to isolated mitochondria from rat liver, it stops mitochondrial protein synthesis, while protein synthesis in the cytosol of the same cells is unaffected. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.10-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mitochondrial ribosomes are similar to bacterial ribosomes, which is consistent with a bacterial ancestor.', true, 'Correct: Mitochondrial ribosomes share the drug sensitivity of bacterial ribosomes but not of the cell''s cytosolic ribosomes, supporting a bacterial origin for mitochondria.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mitochondria are made in the nucleus, which is why they respond to the antibiotic.', false, 'Where mitochondria are made does not explain why their ribosomes are drug sensitive, and a nuclear origin would predict the same behavior as cytosolic ribosomes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mitochondria do not carry out protein synthesis, so the observed change must be due to ATP depletion.', false, 'The experiment measures protein synthesis in mitochondria and shows that they carry it out, because it is blocked by the drug.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cytosolic ribosomes of the rat cells are bacterial in origin, since they are unaffected.', false, 'The cytosolic ribosomes are unaffected, which shows they differ from bacterial ribosomes rather than resembling them.' from version_ins;
-- apbio-mcq-b5-sv-h-2.10-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.10-a-v2', 'mcq', 'interpret molecular sequence, antibiotic, or genome data as evidence for the endosymbiotic origin of mitochondria and ch (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Chloroplast DNA from a spinach leaf is a single circular molecule not bound to histones, and chloroplasts multiply by dividing in two inside the cell. The nuclear DNA of the same cells is in linear chromosomes bound to histones. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.10-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The chloroplast genome shows that chloroplasts arose from the nucleus by infolding of the nuclear envelope.', false, 'A nuclear origin would predict a chromosome like the nuclear one, but the chloroplast genome is circular and has no histones.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The chloroplast genome resembles a bacterial chromosome, which is consistent with a bacterial origin.', true, 'Correct: A circular, histone-free chromosome and reproduction by binary fission resemble prokaryotes, supporting an origin from an engulfed bacterium.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Circular DNA shows that chloroplasts were originally viruses that infected the cell.', false, 'Nothing in the data suggests a virus, and circular DNA that is organized like a bacterial chromosome points to a bacterium.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The data show that chloroplasts encode every gene needed to make their own proteins.', false, 'The data describe the form of the DNA and say nothing about whether it contains every gene needed, and many chloroplast proteins are encoded in the nucleus.' from version_ins;
-- apbio-mcq-b5-sv-h-2.10-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.10-a-v3', 'mcq', 'interpret molecular sequence, antibiotic, or genome data as evidence for the endosymbiotic origin of mitochondria and ch (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Many proteins found in mitochondria are encoded by genes in the nucleus. Sequence comparison shows that these nuclear genes are more similar to genes of a group of free-living bacteria than to most other nuclear genes. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.10-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Some genes from the bacterial ancestor of mitochondria moved to the host nucleus over evolutionary time.', true, 'Correct: Nuclear genes whose closest relatives are bacterial genes are consistent with transfer of genes from the endosymbiont''s genome to the nucleus, which explains the host dependence of mitochondria.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mitochondria are still fully independent of the nucleus.', false, 'Mitochondria import many proteins encoded in the nucleus, so they depend on the nucleus and are not fully independent.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The nuclear genes were acquired recently from the bacteria in the cell''s food.', false, 'No information about food is given, and the bacterial-type genes are specifically those encoding mitochondrial proteins, consistent with transfer from the organelle''s ancestor.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mitochondria did not originate from bacteria, because most of their proteins are made from nuclear genes.', false, 'Transfer of genes to the nucleus is expected from an endosymbiont and does not argue against a bacterial origin.' from version_ins;
-- apbio-mcq-b5-h-2.10-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.10-b', 'mcq', 'sort organelles by proposed origin (endosymbiosis or membrane infolding) from a table of features.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A biologist lists features of four organelles from a plant cell. Organelle W has two membranes, a circular DNA molecule, ribosomes similar in size to bacterial ribosomes, and divides by splitting in two. Organelle X has a single membrane that is continuous with the nuclear envelope, has no DNA, and has ribosomes attached to its outer surface. Organelle Y has two membranes, a circular DNA molecule, bacterial-sized ribosomes, and a pigment, and divides by splitting in two. Organelle Z has a single membrane, no DNA, an acidic interior with hydrolytic enzymes, and buds from the Golgi complex. Which statement best matches current models of how these organelles arose?', null, md5('apbio-mcq-b5-h-2.10-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'All four arose by endosymbiosis, because all are surrounded by membranes.', false, 'Being surrounded by a membrane is common to all organelles and is not evidence for endosymbiosis; the other features are what distinguish W and Y.' from version_ins
union all select gen_random_uuid(), id, 'B', 'W and Y arose from engulfed bacteria, while X and Z arose from the cell''s own membrane system.', true, 'Correct: Two membranes together with their own circular DNA, bacterial-sized ribosomes, and fission-type division indicate an endosymbiotic origin (W and Y). A single membrane, continuity with the nuclear envelope, and no genome indicate organelles derived from the cell''s own endomembrane system (X and Z).' from version_ins
union all select gen_random_uuid(), id, 'C', 'X and Z arose by endosymbiosis, because they contain ribosomes or enzymes, while W and Y arose by infolding.', false, 'This reverses the assignment, because the features of an independent genome and division by splitting are those of W and Y.' from version_ins
union all select gen_random_uuid(), id, 'D', 'W and X arose by endosymbiosis, because both have ribosomes, while Y and Z arose by infolding.', false, 'The ribosomes on X are attached to its surface and are the cell''s cytosolic ones, and X is continuous with the nuclear envelope, so it is not endosymbiotic.' from version_ins;
-- apbio-mcq-b5-sv-h-2.10-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.10-b-v1', 'mcq', 'sort organelles by proposed origin (endosymbiosis or membrane infolding) from a table of features. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student claims that the nucleus must have arisen by endosymbiosis because it is surrounded by two membranes. Which observation about the nucleus best argues against the claim?', null, md5('apbio-mcq-b5-sv-h-2.10-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The nuclear envelope has pores, which bacteria do not have.', false, 'Pores are a feature of the nuclear envelope but do not indicate whether it formed by infolding or engulfment of a bacterium.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The nucleus contains DNA, which mitochondria and chloroplasts also contain.', false, 'DNA is present in both the nucleus and in organelles of endosymbiotic origin, so its presence does not help refute the claim.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The nucleus is larger than a typical bacterial cell.', false, 'Size alone does not show origin, and some bacteria are large.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The nuclear envelope is continuous with the endoplasmic reticulum, and the nucleus has no independent genome or machinery for dividing by fission.', true, 'Correct: Continuity with the ER suggests derivation from the cell''s own membranes by infolding, and an endosymbiont would be expected to retain its own genome and divide independently; the nucleus does neither.' from version_ins;
-- apbio-mcq-b5-sv-h-2.10-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.10-b-v2', 'mcq', 'sort organelles by proposed origin (endosymbiosis or membrane infolding) from a table of features. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A single-celled eukaryote contains a cyanobacterium-like body inside its cytoplasm. The body has a circular genome of about one million base pairs, one third the size of its free-living relatives'' genomes, and cannot survive outside the host. The host nucleus encodes some of the body''s proteins, and the body divides in step with the host cell. Which statement best fits these observations?', null, md5('apbio-mcq-b5-sv-h-2.10-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The body is a pathogen that has evolved a larger genome than its relatives.', false, 'The genome is smaller than those of free-living relatives, not larger, and the body is described as integrated into the host.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The body arose from the host''s endoplasmic reticulum by infolding.', false, 'The body has its own circular genome and a bacterial-like form, which would not be expected for a structure derived from host membrane.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The body is an example of the origin of mitochondria, because mitochondria also came from cyanobacteria.', false, 'Mitochondria are thought to have descended from an ancestor of proteobacteria, whereas chloroplasts descended from cyanobacteria.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The body resembles an organelle in an early stage of becoming integrated, with gene loss, gene transfer to the host, and host-controlled division.', true, 'Correct: A reduced genome, dependence on the host, host-encoded proteins, and synchronized division are expected as an endosymbiont is integrated into a host cell.' from version_ins;
-- apbio-mcq-b5-sv-h-2.10-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.10-b-v3', 'mcq', 'sort organelles by proposed origin (endosymbiosis or membrane infolding) from a table of features. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant cell has the following structures: mitochondria, chloroplasts, rough endoplasmic reticulum, a Golgi complex, and a large central vacuole. Which statement about the origin of these structures best matches current models?', null, md5('apbio-mcq-b5-sv-h-2.10-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Only the chloroplasts arose by endosymbiosis, because mitochondria arose by infolding of the plasma membrane.', false, 'Mitochondria also have a double membrane, a circular genome, and bacterial-type ribosomes, so they are included in the endosymbiotic group.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mitochondria, chloroplasts, and the central vacuole arose by endosymbiosis, because all contain fluid.', false, 'A vacuole has a single membrane and no genome, and containing fluid is not evidence of an endosymbiotic origin.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mitochondria and chloroplasts arose by endosymbiosis, while the endoplasmic reticulum, Golgi complex, and vacuole are part of the cell''s own endomembrane system.', true, 'Correct: Mitochondria and chloroplasts have their own genomes and bacteria-like features, matching an endosymbiotic origin, whereas the ER, Golgi complex, and vacuole belong to the interconnected endomembrane system that is attributed to infolding.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All five arose by endosymbiosis, because all are specialized compartments inside the cell.', false, 'Being a compartment does not indicate endosymbiosis, since the endomembrane compartments lack their own genomes.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-2.10-a','apbio-mcq-b5-sv-h-2.10-a-v1','apbio-mcq-b5-sv-h-2.10-a-v2','apbio-mcq-b5-sv-h-2.10-a-v3','apbio-mcq-b5-h-2.10-b','apbio-mcq-b5-sv-h-2.10-b-v1','apbio-mcq-b5-sv-h-2.10-b-v2','apbio-mcq-b5-sv-h-2.10-b-v3']) and status='draft')<>8 then raise exception 'chunk 9: expected 8 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-h-2.10-a','apbio-mcq-b5-sv-h-2.10-a-v1','apbio-mcq-b5-sv-h-2.10-a-v2','apbio-mcq-b5-sv-h-2.10-a-v3','apbio-mcq-b5-h-2.10-b','apbio-mcq-b5-sv-h-2.10-b-v1','apbio-mcq-b5-sv-h-2.10-b-v2','apbio-mcq-b5-sv-h-2.10-b-v3']))<>32 then raise exception 'chunk 9: expected 32 choices'; end if;
end $$;
commit;
