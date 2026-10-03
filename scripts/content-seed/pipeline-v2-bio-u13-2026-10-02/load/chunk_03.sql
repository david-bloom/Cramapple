begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['APBIO-MCQ-SV-021-v1','APBIO-MCQ-SV-021-v2','APBIO-MCQ-SV-021-v3','APBIO-MCQ-SV-022-v1','APBIO-MCQ-SV-022-v3','APBIO-MCQ-SV-023-v1','APBIO-MCQ-SV-023-v2','APBIO-MCQ-SV-023-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APBIO-MCQ-SV-021-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-021-v1', 'mcq', 'Blocked Golgi-to-membrane vesicles in plasma cells', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Plasma cells secrete antibodies. Antibodies are made by ribosomes on the rough ER, transferred to the Golgi complex for modification, and carried in vesicles from the Golgi complex to the plasma membrane for secretion. A drug blocks the fusion of those Golgi vesicles with the plasma membrane. Which outcome for antibody is most likely in the treated cells?', null, md5('APBIO-MCQ-SV-021-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Antibody is released from the rough ER directly to the outside of the cell, bypassing the blocked Golgi vesicles.', false, 'Antibody is not secreted straight from the rough ER; it must be processed in the Golgi complex and carried in vesicles.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Antibody is no longer made, because ribosomes on the rough ER stop translating when vesicles cannot fuse with the membrane.', false, 'The drug acts on vesicle fusion at the end of the pathway; it does not stop ribosomes from making the protein.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Antibody is still made and enters the Golgi complex and vesicles, but it accumulates inside the cell and little is secreted.', true, 'Synthesis and processing are intact; blocked fusion leaves the antibody in vesicles and little is released.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Antibody is made by ribosomes in the vesicles instead, and the cells secrete it by a different route.', false, 'Ribosomes on the rough ER, not those in transport vesicles, make the antibody, and no alternative route is described.' from version_ins;
-- APBIO-MCQ-SV-021-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-021-v2', 'mcq', 'Drug blocks lysosomal enzyme packaging', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Hydrolytic enzymes that digest worn-out cell components are made by ribosomes on the rough ER, then modified and sorted in the Golgi complex into vesicles that become lysosomes. A drug prevents the Golgi complex from packaging these enzymes into vesicles but does not affect enzyme synthesis. Which outcome is most likely in the treated cells?', null, md5('APBIO-MCQ-SV-021-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The enzymes are no longer made, because the Golgi complex supplies the ribosomes that carry out their synthesis.', false, 'Ribosomes make enzymes independent of the Golgi complex, and the drug is stated not to affect synthesis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The enzymes are digested by the Golgi complex, so worn-out components are broken down faster than in untreated cells.', false, 'The Golgi complex modifies and packages proteins; it does not digest them or speed up breakdown of cell components.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The enzymes are made inside the lysosomes instead, so worn-out components are digested at the normal rate.', false, 'Lysosomal enzymes are made at the rough ER; the lysosome receives them and does not make them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The enzymes are still made, but they do not reach lysosomes, so worn-out cell components are digested less and accumulate.', true, 'Packaging in the Golgi complex is required to deliver enzymes to lysosomes, so digestion falls and material accumulates.' from version_ins;
-- APBIO-MCQ-SV-021-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-021-v3', 'mcq', 'Cell type with extensive rough ER and Golgi', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A biologist examines four cell types for organelles. Cell W secretes large amounts of a protein hormone. Cell X secretes a steroid hormone, which is a lipid. Cell Y contracts and contains many mitochondria. Cell Z stores fat in a large droplet. Protein destined for secretion is made on the rough ER and then processed by the Golgi complex. Which cell would be expected to have the most extensive rough ER and Golgi complex?', null, md5('APBIO-MCQ-SV-021-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cell X, because lipids such as steroids are made on the rough ER and then secreted in vesicles from the Golgi.', false, 'Steroid hormones are lipids made by smooth ER, so Cell X would be expected to have extensive smooth ER, not rough ER.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cell Z, because a large droplet of fat has to be packaged by the Golgi complex before it can be stored.', false, 'Stored fat in a droplet is not made or secreted through the rough ER and Golgi pathway, so this cell has little need for them.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell W, because making and secreting a large amount of protein depends on the rough ER and Golgi complex.', true, 'A cell that secretes a lot of protein needs many ribosomes on rough ER and extensive Golgi processing and packaging.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell Y, because the many mitochondria in the cell supply the protein that the rough ER and Golgi complex store.', false, 'Mitochondria supply ATP and do not make protein for the rough ER and Golgi; a contractile cell does not secrete large amounts of protein.' from version_ins;
-- APBIO-MCQ-SV-022-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-022-v1', 'mcq', 'Chloroplast engulfment evidence', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Evidence supporting the endosymbiotic origin of chloroplasts includes: (1) chloroplasts are surrounded by two membranes, with the inner one resembling a bacterial plasma membrane and the outer one resembling the host''s membrane; (2) chloroplasts have their own circular DNA; (3) chloroplasts have 70S ribosomes like those of bacteria; (4) chloroplasts divide in a way similar to binary fission. Which single piece of evidence most specifically supports the claim that a prokaryote was taken up by a host cell, rather than just showing prokaryote-like features?', null, md5('APBIO-MCQ-SV-022-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The division like binary fission shows that chloroplasts are fully independent prokaryotes that live inside the plant cell.', false, 'Division resembling binary fission shows prokaryote-like reproduction, but chloroplasts rely on the host and are not independent prokaryotes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The circular DNA shows that chloroplasts can still live outside plant cells in the way that free-living bacteria do.', false, 'Circular DNA shows similarity to prokaryotes; it does not show independence, and chloroplasts depend on their host cells.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The 70S ribosomes show that chloroplasts take in whole bacteria from the environment when plant cells divide.', false, 'Ribosome type shows similarity to bacteria; it does not describe uptake of bacteria.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two membranes, with an inner layer like a bacterial plasma membrane and an outer layer like the host, match a prokaryote taken in inside a host membrane.', true, 'The double membrane is the structural result expected if a host cell engulfed a prokaryote in a vesicle.' from version_ins;
-- APBIO-MCQ-SV-022-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-022-v3', 'mcq', 'Antibiotic prediction from endosymbiosis', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Antibiotic Q blocks protein synthesis on 70S ribosomes of bacteria but does not affect the 80S ribosomes found in the cytoplasm of eukaryotic cells. Mitochondria contain their own ribosomes. If mitochondria arose from engulfed bacteria, which result is most likely when human cells in culture are treated with antibiotic Q?', null, md5('APBIO-MCQ-SV-022-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'All protein synthesis stops, because the same ribosome type makes protein in the cytoplasm and in mitochondria.', false, 'This assumes one ribosome type works in both places. If mitochondria arose from bacteria, their ribosomes resemble bacterial 70S ribosomes and differ from the 80S cytoplasmic ribosomes, so antibiotic Q would not stop all protein synthesis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'No protein synthesis is affected, because mitochondria contain no ribosomes and make no protein of their own.', false, 'Mitochondria are stated to have their own ribosomes and they do make some of their own proteins.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Protein synthesis inside mitochondria is inhibited, while protein synthesis on cytoplasmic ribosomes continues.', true, 'If mitochondrial ribosomes resemble bacterial 70S ribosomes, antibiotic Q blocks them but not the cytoplasmic 80S ribosomes.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Protein synthesis on cytoplasmic ribosomes is inhibited, while mitochondrial protein synthesis continues without change.', false, 'This reverses the targets: Q affects 70S ribosomes, the type expected in mitochondria, and spares the cytoplasmic 80S ribosomes.' from version_ins;
-- APBIO-MCQ-SV-023-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-023-v1', 'mcq', 'Channel protein surface chemistry', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A transmembrane channel protein forms a pore through the plasma membrane that lets ions pass. Researchers analyze the R groups of its amino acids. Which description of the protein''s R groups is most consistent with its location and function?', null, md5('APBIO-MCQ-SV-023-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Only nonpolar R groups throughout the protein, since the protein is embedded in the hydrophobic interior of the membrane.', false, 'A pore lined only with nonpolar R groups would not let ions pass; the pore lining must be polar.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Polar R groups on the outer surface that contacts the phospholipid tails, and nonpolar R groups lining the interior of the pore.', false, 'This reverses the arrangement: polar groups are unstable beside hydrophobic tails, and nonpolar groups would hinder the passage of ions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only polar R groups throughout the protein, since the pore carries ions that are dissolved in the water.', false, 'Polar groups on the outer surface would not be stable next to the hydrophobic phospholipid tails.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nonpolar R groups on the outer surface that contacts the phospholipid tails, and polar R groups lining the interior of the pore.', true, 'Nonpolar outer R groups are stable next to hydrophobic tails, while polar R groups lining the pore favor passage of ions and water.' from version_ins;
-- APBIO-MCQ-SV-023-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-023-v2', 'mcq', 'Peripheral protein removed by salt', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers study Protein Q from broken red blood cell membranes. Washing the membranes with a high-salt solution releases Protein Q, and the phospholipid bilayer stays intact. The amino acids on the surface of Protein Q have mostly polar and charged R groups. Which characterization of Protein Q is best supported by these results?', null, md5('APBIO-MCQ-SV-023-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A protein dissolved in the interior of the bilayer, with nonpolar R groups that interact with the surrounding water.', false, 'Nonpolar R groups do not interact favorably with water, and this protein was released from the surface rather than from the interior.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A protein attached to the membrane surface by interactions between its polar R groups and the polar heads of phospholipids or other membrane proteins.', true, 'Easy removal without dissolving the bilayer and a polar surface indicate a surface-associated protein interacting with polar regions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A protein embedded in the bilayer, with nonpolar R groups that touch the hydrophobic tails of the phospholipids.', false, 'An embedded protein with a nonpolar surface would not be released by salt and would require dissolving the bilayer.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A protein spanning the bilayer, with polar R groups on the surface that touches the phospholipid tails.', false, 'Polar R groups are not stable next to hydrophobic tails, and a spanning protein would not be released by salt.' from version_ins;
-- APBIO-MCQ-SV-023-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-023-v3', 'mcq', 'Hydrophobic stretches in membrane protein sequence', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher determines the amino acid sequence of Protein T. Seven separate stretches of about 20 amino acids each have only nonpolar R groups, and the regions between the stretches have mostly polar R groups. Protein T can be removed from membranes only by dissolving the lipid bilayer with a detergent. Which description of Protein T is best supported by these results?', null, md5('APBIO-MCQ-SV-023-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A protein attached to the outside of the membrane, with its nonpolar stretches facing the watery fluid around it.', false, 'Removal requires dissolving the bilayer, so the protein is not simply attached outside, and nonpolar stretches would not face water.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A protein dissolved in the cytoplasm, with its nonpolar stretches facing outward toward the surrounding water.', false, 'Nonpolar stretches facing water are unstable, and the need for detergent shows Protein T is part of the bilayer, not dissolved.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A protein with all of its polar regions buried in the center of the bilayer, among the hydrophobic tails.', false, 'Polar regions are not stable among the hydrophobic tails; the nonpolar stretches belong there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A protein that crosses the bilayer several times, with its nonpolar stretches in the membrane interior and its polar regions outside the bilayer.', true, 'Nonpolar stretches fit among the hydrophobic tails, while polar regions stay in the aqueous environments on either side.' from version_ins;
commit;
