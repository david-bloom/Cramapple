begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-2.1-a','apbio-mcq-b5-sv-h-2.1-a-v1','apbio-mcq-b5-sv-h-2.1-a-v2','apbio-mcq-b5-sv-h-2.1-a-v3','apbio-mcq-b5-h-2.1-b','apbio-mcq-b5-sv-h-2.1-b-v1','apbio-mcq-b5-sv-h-2.1-b-v2','apbio-mcq-b5-sv-h-2.1-b-v3','apbio-mcq-b5-h-2.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b5-h-2.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.1-a', 'mcq', 'locate a defect in the endomembrane secretory pathway from the order and timing of radioactive label.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells that secrete a protein hormone are given a brief pulse of radioactive amino acids and then transferred to nonradioactive medium. In normal cells the label appears in the rough ER after 2 minutes, in the Golgi complex after 15 minutes, in vesicles near the plasma membrane after 30 minutes, and outside the cell after 60 minutes. In cells treated with drug X, label is present in the rough ER at 2 minutes and is still found only in the rough ER at 15, 30, and 60 minutes, with none detected in the Golgi complex or outside the cell. Which step does drug X most likely block?', null, md5('apbio-mcq-b5-h-2.1-a'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Translation of the hormone on ribosomes, because the hormone cannot be made without it.', false, 'Label appears in the rough ER at 2 minutes, which shows the hormone was synthesized, so translation was not blocked.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fusion of secretory vesicles with the plasma membrane, which releases the protein from the cell.', false, 'A block at the plasma membrane would let label build up in secretory vesicles, but none is seen beyond the rough ER.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Modification of the protein inside the Golgi complex, which prepares it for release.', false, 'A Golgi modification block would leave label piled up in the Golgi complex, yet no label ever reaches it.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Budding or transport of vesicles that carry the protein from the rough ER to the Golgi complex.', true, 'Correct: Label does enter the rough ER at 2 minutes, so the protein is made and enters the ER; it never reaches the Golgi complex, so the first step that fails is ER-to-Golgi vesicle transport.' from version_ins;
-- apbio-mcq-b5-sv-h-2.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.1-a-v1', 'mcq', 'locate a defect in the endomembrane secretory pathway from the order and timing of radioactive label. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pancreatic cells that secrete digestive enzymes are given a brief pulse of radioactive amino acids and then chased in nonradioactive medium. In normal cells the label is found in the rough ER at 3 minutes, the Golgi complex at 20 minutes, and vesicles near the plasma membrane at 40 minutes, and the enzymes are detected outside the cell at 70 minutes. In cells treated with drug Y, label is found in the rough ER, the Golgi complex, and a large number of vesicles clustered beneath the plasma membrane at 40 and 70 minutes, but none is detected outside the cell. Which step does drug Y most likely block?', null, md5('apbio-mcq-b5-sv-h-2.1-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Movement of vesicles from the rough ER to the Golgi complex.', false, 'Label reaches the Golgi complex and later vesicles, so ER-to-Golgi transport still works.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sorting of the enzymes into vesicles at the Golgi complex.', false, 'Vesicles carrying label do form and travel to the cell edge, so sorting and budding from the Golgi complex are intact.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fusion of the secretory vesicles with the plasma membrane.', true, 'Correct: Label travels through the rough ER, Golgi complex, and vesicles at the cell edge, then stalls just before release, so the final step, vesicle fusion with the plasma membrane (exocytosis), is blocked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Entry of newly made enzymes into the rough ER.', false, 'Label is found in the rough ER at the normal time, so the enzymes still enter it.' from version_ins;
-- apbio-mcq-b5-sv-h-2.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.1-a-v2', 'mcq', 'locate a defect in the endomembrane secretory pathway from the order and timing of radioactive label. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cultured plasma cells secrete antibody. Label from a pulse of radioactive amino acids reaches the rough ER at 2 minutes and the Golgi complex at 15 minutes in both normal cells and mutant cells. In normal cells label then appears in vesicles at 30 minutes and outside the cell at 60 minutes. In mutant cells the label remains in the Golgi complex at 30 and 60 minutes, and no labeled vesicles are seen. Which defect best explains the mutant cells?', null, md5('apbio-mcq-b5-sv-h-2.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Vesicles cannot form from the Golgi complex, so the antibody cannot leave it.', true, 'Correct: Label reaches the Golgi complex at the normal time (so earlier steps work) but never appears in vesicles or outside; the first failed step is formation of vesicles at the Golgi complex.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The ribosomes cannot attach to the rough ER, so antibody is made in the cytoplasm.', false, 'Label reaches the rough ER and then the Golgi complex normally, so synthesis and ER entry are working.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Vesicles cannot bud from the ER, so the antibody never reaches the Golgi complex.', false, 'Label does arrive in the Golgi complex at 15 minutes, so ER-to-Golgi transport is intact.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The plasma membrane lacks proteins that bind secretory vesicles.', false, 'A plasma membrane defect would cause labeled vesicles to accumulate near the membrane, but no labeled vesicles are seen.' from version_ins;
-- apbio-mcq-b5-sv-h-2.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.1-a-v3', 'mcq', 'locate a defect in the endomembrane secretory pathway from the order and timing of radioactive label. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pancreatic beta cells secrete insulin. In mutant cells, the timing of radioactive label is the same as in normal cells: rough ER at 2 minutes, Golgi complex at 15 minutes, secretory vesicles at 30 minutes, and outside the cell at 60 minutes. However, the insulin released by mutant cells lacks the carbohydrate and other chemical changes that normal insulin has. Which statement best explains the results?', null, md5('apbio-mcq-b5-sv-h-2.1-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Vesicle transport from the rough ER to the Golgi complex is blocked in the mutant cells.', false, 'Label reaches the Golgi complex and leaves the cell at the normal times, so ER-to-Golgi transport is not blocked.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Exocytosis is blocked, so insulin builds up in vesicles inside the mutant cells.', false, 'Insulin is released at the normal time, so exocytosis works.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ribosomes in the mutant cells make the protein too slowly, so it cannot be modified.', false, 'The timing of label entering the rough ER is normal, so synthesis speed does not explain the missing modifications.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Transport between compartments works, but the enzymes that modify the protein as it moves through the ER and Golgi complex are defective.', true, 'Correct: Label reaches every compartment and leaves the cell on schedule, so trafficking is intact; the released protein is chemically unmodified, which points to defective modifying enzymes.' from version_ins;
-- apbio-mcq-b5-h-2.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.1-b', 'mcq', 'match a drug or mutation affecting one cytoskeletal element to the cellular process it disrupts.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug disassembles microtubules in cultured fibroblasts but does not affect actin filaments or intermediate filaments. After treatment, researchers observe that (1) the cells stay attached to the dish and keep most of their shape, (2) membrane-bound vesicles accumulate near the center of the cell rather than being distributed through it, and (3) in cells that begin to divide, the chromosomes do not separate into two groups. Which conclusion is best supported?', null, md5('apbio-mcq-b5-h-2.1-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Microtubules serve as tracks for motor proteins that move vesicles, and they form the spindle that separates chromosomes.', true, 'Correct: Loss of microtubules leaves shape and attachment largely intact, but vesicle distribution and chromosome separation fail, which are the two microtubule functions of transport tracks and spindle.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Microtubules supply the main mechanical strength that keeps the cell from tearing under stress.', false, 'Mechanical strength comes mainly from intermediate filaments, and the cells here keep their shape without microtubules.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Microtubules form the contractile ring that pinches the dividing cell in two.', false, 'The contractile ring is made of actin filaments, and the observed failure is in chromosome separation rather than pinching.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Microtubules are the structures on which ribosomes assemble polypeptides.', false, 'Ribosomes assemble polypeptides using mRNA and are not built on microtubules.' from version_ins;
-- apbio-mcq-b5-sv-h-2.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.1-b-v1', 'mcq', 'match a drug or mutation affecting one cytoskeletal element to the cellular process it disrupts. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug blocks actin polymerization in dividing cultured cells but leaves microtubules unaffected. Treated cells form normal spindles and separate their chromosomes into two nuclei, but the cell does not pinch in two, and many cells end up with two nuclei. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Actin filaments form the contractile ring that divides the cytoplasm, and this step is separate from chromosome separation.', true, 'Correct: Chromosome separation succeeded (two nuclei form), while cytoplasmic division failed, so actin is required for cytokinesis but not for spindle-based chromosome movement.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Chromosome separation depends on actin filaments rather than on the spindle.', false, 'Chromosomes separated normally in the treated cells, so this step does not depend on actin.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The spindle is made of actin, and its normal formation caused the two nuclei.', false, 'The spindle is made of microtubules and formed normally even though actin polymerization was blocked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Actin filaments carry vesicles to the plasma membrane, so vesicle delivery stopped.', false, 'The observed defect is failure to divide the cytoplasm, not a failure of vesicle delivery, which the data do not measure.' from version_ins;
-- apbio-mcq-b5-sv-h-2.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.1-b-v2', 'mcq', 'match a drug or mutation affecting one cytoskeletal element to the cellular process it disrupts. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mutation in the motor protein kinesin is found in a mouse neuron line. In the mutant neurons, vesicles filled with neurotransmitter accumulate in the cell body and are rare at the axon terminal. The cell body, the nucleus, and the ability of the neurons to divide in culture are all normal. Which explanation best fits the observations?', null, md5('apbio-mcq-b5-sv-h-2.1-b-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Intermediate filaments are missing, so the axon cannot hold its shape.', false, 'A lack of intermediate filaments would affect cell strength and shape, not vesicle movement, and no shape defect is described.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The Golgi complex cannot package neurotransmitter into vesicles in the mutant cells.', false, 'Vesicles do form in the cell body, so packaging by the Golgi complex works.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Kinesin moves cargo along microtubule tracks, so vesicles cannot be carried down the long axon.', true, 'Correct: Vesicles form (they accumulate in the cell body) but fail to reach the terminal, which matches a defect in microtubule-based motor transport rather than packaging.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The mutant cells cannot form a contractile ring, so vesicles are trapped in the cell body.', false, 'The contractile ring acts only in cell division, and the neurons divide normally in culture.' from version_ins;
-- apbio-mcq-b5-sv-h-2.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.1-b-v3', 'mcq', 'match a drug or mutation affecting one cytoskeletal element to the cellular process it disrupts. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Skin cells from a patient lack functional keratin, a protein that forms intermediate filaments. In culture, the cells divide at a normal rate, move vesicles normally, and form normal spindles. When the culture dish is stretched slightly, however, many of the cells rupture. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.1-b-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Keratin filaments are the tracks on which motor proteins move vesicles.', false, 'Vesicle movement is normal in the patient cells, and the tracks for motor proteins are microtubules.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Keratin is needed to form the spindle, so the cells cannot divide under stress.', false, 'Spindles form normally and the cells divide at a normal rate, so keratin is not needed for division.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cells without keratin cannot synthesize proteins, which weakens the plasma membrane.', false, 'Nothing in the data shows a defect in protein synthesis, and ribosomes do not depend on keratin.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Intermediate filaments give cells mechanical strength so that they resist stretching.', true, 'Correct: Division, vesicle transport, and spindle formation are normal, while stretch resistance fails, which isolates the role of intermediate filaments as mechanical support.' from version_ins;
-- apbio-mcq-b5-h-2.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.2-a', 'mcq', 'use supply proportional to surface area and demand proportional to volume to predict whether a cell of a given size can ', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher models a cube-shaped cell of edge length s (in micrometers). Oxygen uptake is proportional to the surface area, at 0.5 units per square micrometer per minute, and oxygen use is proportional to the volume, at 0.1 units per cubic micrometer per minute. The cell surface area is 6s² and the volume is s³. Using these rates, oxygen supply is 3s² and oxygen demand is 0.1s³. Which prediction follows from the model?', null, md5('apbio-mcq-b5-h-2.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A cell with s = 36 micrometers can absorb only about 83% of the oxygen it uses, because supply divided by demand equals 30 divided by s.', true, 'Correct: Supply/demand = 3s²/0.1s³ = 30/s. At s = 36 this is 0.833, about 83%. At s = 25 it is 1.2 (supply exceeds demand), and at s = 40 it is 0.75. Doubling s halves the ratio.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A cell with s = 25 micrometers cannot meet its oxygen demand, because larger cells always have less total surface area.', false, 'Surface area increases with size (as s squared); at s = 25 the ratio is 1.2, so the demand is still met.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A cell with s = 40 micrometers meets its demand with oxygen to spare, because surface area grows faster than volume.', false, 'Volume grows faster than surface area (s cubed versus s squared), so at s = 40 the ratio is only 0.75 and demand is not met.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A cell that doubles its edge length doubles the ratio of supply to demand, so larger cells meet their needs more easily.', false, 'Doubling the edge length quadruples supply but multiplies demand by eight, which halves the ratio.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-2.1-a','apbio-mcq-b5-sv-h-2.1-a-v1','apbio-mcq-b5-sv-h-2.1-a-v2','apbio-mcq-b5-sv-h-2.1-a-v3','apbio-mcq-b5-h-2.1-b','apbio-mcq-b5-sv-h-2.1-b-v1','apbio-mcq-b5-sv-h-2.1-b-v2','apbio-mcq-b5-sv-h-2.1-b-v3','apbio-mcq-b5-h-2.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-h-2.1-a','apbio-mcq-b5-sv-h-2.1-a-v1','apbio-mcq-b5-sv-h-2.1-a-v2','apbio-mcq-b5-sv-h-2.1-a-v3','apbio-mcq-b5-h-2.1-b','apbio-mcq-b5-sv-h-2.1-b-v1','apbio-mcq-b5-sv-h-2.1-b-v2','apbio-mcq-b5-sv-h-2.1-b-v3','apbio-mcq-b5-h-2.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
