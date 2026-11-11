begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-h-4.1-a','apbio-mcq-b4-sv-h-4.1-a-v1','apbio-mcq-b4-sv-h-4.1-a-v2','apbio-mcq-b4-sv-h-4.1-a-v3','apbio-mcq-b4-h-4.1-b','apbio-mcq-b4-sv-h-4.1-b-v1','apbio-mcq-b4-sv-h-4.1-b-v2','apbio-mcq-b4-sv-h-4.1-b-v3','apbio-mcq-b4-h-4.2-a'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b4-h-4.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.1-a', 'mcq', 'classify signaling type (juxtacrine/paracrine/autocrine/endocrine) from experimental results', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers study how cell type X signals to target cells T in culture. (1) When X cells are mixed with T cells and touch them, T cells turn on gene Y. (2) When medium in which X cells grew for 24 hours is added to a separate dish of T cells, gene Y stays off. (3) When X and T cells share a dish but are separated by a porous membrane that lets proteins pass but prevents cell contact, gene Y stays off. (4) When T cells are treated with an antibody that blocks their receptor, touching X cells no longer turns on gene Y. Which best classifies the signaling from X to T?', null, md5('apbio-mcq-b4-h-4.1-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Contact-dependent (juxtacrine) signaling, because a signal on the surface of X binds the receptor on T only when the cells touch.', true, 'Correct: the response needs direct contact (results 1 to 3), and a receptor on T is required (result 4), so a membrane-bound signal on X binds a receptor on T.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Paracrine signaling, because X releases a diffusible signal that acts on nearby T cells.', false, 'A diffusible signal would have crossed the porous membrane and would have worked in the conditioned medium, and neither of those turned on gene Y.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Endocrine signaling, because X releases a signal that travels through the fluid to distant T cells.', false, 'A signal carried in fluid would also have worked in the conditioned medium and across the porous membrane.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Autocrine signaling, because X cells respond to a signal they make themselves.', false, 'Autocrine signals act on the cell that makes them, but here it is the T cells that respond and only when touched.' from version_ins;
-- apbio-mcq-b4-sv-h-4.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.1-a-v1', 'mcq', 'classify signaling type (juxtacrine/paracrine/autocrine/endocrine) from experimental results (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a developing tissue, a small group of cells secretes protein P. Cells within about 100 µm of the group turn on gene G, including cells that do not touch the group. Cells farther than 200 µm away do not respond. Protein P is broken down by enzymes in the extracellular fluid within minutes. When the group of cells is transplanted to a new site, cells within 100 µm of the graft turn on gene G. Which best classifies this signaling?', null, md5('apbio-mcq-b4-sv-h-4.1-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Endocrine signaling, because a secreted protein travels to target cells in other parts of the body.', false, 'Endocrine signals are carried by the bloodstream to distant tissues, and here P is degraded locally and acts over 100 µm only.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Paracrine signaling, because a short-lived secreted signal acts only on nearby cells.', true, 'Correct: nearby cells respond without touching, the response falls to zero with distance, and P is degraded quickly, which describes a local diffusible signal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Contact-dependent signaling, because the responding cells must be in direct membrane contact with the group.', false, 'Cells that do not touch the group still respond, so direct contact is not required.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Autocrine signaling, because the cells that secrete P are the ones that respond to it.', false, 'The responding cells are neighbors of the signaling group, so the signal acts on other cells and not just on the cells that make it.' from version_ins;
-- apbio-mcq-b4-sv-h-4.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.1-a-v2', 'mcq', 'classify signaling type (juxtacrine/paracrine/autocrine/endocrine) from experimental results (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A tumor cell line makes growth factor G and has receptors for it. Single cells plated one per well, far from any other cell, still divide in medium with no added growth factor. Adding an antibody that binds and neutralizes G to the medium stops their division, and so does an antibody that blocks the G receptor. Which best classifies the signaling that drives division in these cells?', null, md5('apbio-mcq-b4-sv-h-4.1-a-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Paracrine signaling, because G acts on nearby cells.', false, 'Paracrine signaling needs a different nearby cell to receive the signal, and each well has only one cell.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Autocrine signaling, because the cell makes a signal that binds its own receptors.', true, 'Correct: each well holds only one cell, so the signal can only come from the cell itself and act on the same cell''s receptor; blocking either G or its receptor stops division.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Contact-dependent signaling, because G is attached to the membrane of the neighboring cell.', false, 'There is no neighboring cell to touch, since each cell is alone in its well.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Endocrine signaling, because G is carried through fluid to target cells.', false, 'Endocrine signaling involves a distant target cell reached by the bloodstream, and no such cell exists in a culture well.' from version_ins;
-- apbio-mcq-b4-sv-h-4.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.1-a-v3', 'mcq', 'classify signaling type (juxtacrine/paracrine/autocrine/endocrine) from experimental results (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A gland is removed from a rat, and the rat''s liver cells stop breaking down glycogen. When a piece of the gland is transplanted under the skin of the ear, 20 cm from the liver, glycogen breakdown resumes. Skin cells next to the graft, which lack the receptor for the gland''s hormone, show no response. Which statement best explains these results?', null, md5('apbio-mcq-b4-sv-h-4.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The hormone acts as an autocrine signal, so only the gland cells in the graft respond to it.', false, 'The response is seen in liver cells far from the graft, so the signal acts on cells other than the ones that make it.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The hormone acts as a paracrine signal, so the response depends on how close the target cells are to the graft.', false, 'The liver is 20 cm from the graft and still responds, and nearby skin cells do not, so distance from the source does not decide the response.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The hormone acts as an endocrine signal: it travels in the blood to distant cells, and only cells with the receptor respond.', true, 'Correct: the graft is far from the liver yet restores the response, so the signal travels through the blood; neighboring skin cells without the receptor do not respond, so the receptor determines which cells respond.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The hormone acts through direct cell-to-cell contact, so the graft must have grown into the liver.', false, 'The graft is under the skin of the ear and responds across 20 cm, so contact between the graft and liver cells is not possible.' from version_ins;
-- apbio-mcq-b4-h-4.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.1-b', 'mcq', 'separate ligand binding from cell response using a results table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ligand L binds a single receptor protein, R, which an antibody test shows is present on the surface of cell types 1, 2 and 4. Cell type 3 does not make R. A researcher adds L at the same concentration to each type.
Cell type | Labeled L bound | Response to L
1 | high | breaks down glycogen
2 | high | opens an ion channel
3 | none | none
4 | high | none
Which conclusion is best supported by all four rows?', null, md5('apbio-mcq-b4-h-4.1-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The structure of L alone determines the response, so L should cause the same response in every cell that binds it.', false, 'Cell types 1 and 2 bind the same ligand yet respond differently, so the ligand''s structure does not fix the response.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Binding to R is necessary but not sufficient: the response depends on the transduction proteins and effectors each cell type has, so the same ligand and receptor can give different responses or none.', true, 'Correct: type 3 shows no binding and no response; types 1, 2 and 4 all bind L to the same receptor R yet respond in three different ways, so the response must depend on the cell''s downstream components.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell type 4 must lack receptor R, because a cell that binds a ligand but does not respond has no receptor.', false, 'The antibody test shows type 4 has R and it binds L strongly, so the receptor is present and a downstream defect is the more likely cause.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell types 1 and 2 must have different receptors for L, because they respond to L in different ways.', false, 'The stem states that the same receptor protein R is present on both types, so different responses cannot be explained by different receptors.' from version_ins;
-- apbio-mcq-b4-sv-h-4.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.1-b-v1', 'mcq', 'separate ligand binding from cell response using a results table (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher engineers three cell lines to make the same receptor protein, R, at the same level. Each line is exposed to the same concentration of ligand L.
Cell line | Origin | Response to L
1 | liver | breaks down glycogen
2 | neuron | opens an ion channel
3 | skin fibroblast | begins dividing
Which statement best explains why one ligand and one receptor produce three responses?', null, md5('apbio-mcq-b4-sv-h-4.1-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'L enters each cell and decides which genes to turn on, because the response depends on the structure of the ligand.', false, 'L acts by binding the receptor and the stem gives no evidence that it enters the cells, and the same ligand structure gives three different responses.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The receptor R changes its structure in each cell line so that it binds a different part of L.', false, 'The same receptor protein is made in all three lines, so no new binding site or structure is needed to explain the differences.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cells differ in the number of L molecules that reached them, since only the amount of ligand determines the type of response.', false, 'The same concentration of L was added to every line, so the amount of ligand does not differ among them.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Each cell line has its own set of signal transduction proteins and effectors, so the same receptor activation leads to different responses.', true, 'Correct: ligand, receptor and ligand concentration are identical in the three lines, so the differences must lie downstream, in each cell''s own transduction components and effectors.' from version_ins;
-- apbio-mcq-b4-sv-h-4.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.1-b-v2', 'mcq', 'separate ligand binding from cell response using a results table (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cell line K binds labeled ligand L as strongly as a normal cell line does, yet shows no response. K lacks protein P, a cytoplasmic kinase that normally acts after receptor activation. When the gene for P is added to K, the cells respond to L. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'P is the receptor for L, because the response appeared only after P was supplied.', false, 'K already bound L normally before P was added, so a receptor was present, and P is a cytoplasmic kinase and not a surface receptor.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The receptor in K works, but the cells lacked a downstream component, P, needed to relay the signal to a response.', true, 'Correct: normal binding shows the receptor and reception step are intact; supplying P restores the response, so the missing piece was a downstream transduction component.' from version_ins
union all select gen_random_uuid(), id, 'C', 'K could not bind L, so the original lack of response was caused by missing ligand binding.', false, 'The stem says K binds L as strongly as a normal line does, so binding was not the problem.' from version_ins
union all select gen_random_uuid(), id, 'D', 'P makes the ligand L, so adding P supplied the signal that K had been missing.', false, 'L was supplied by the researcher in every test, and P is a signaling kinase that does not make ligands.' from version_ins;
-- apbio-mcq-b4-sv-h-4.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.1-b-v3', 'mcq', 'separate ligand binding from cell response using a results table (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Three cell lines were tested with ligand L. In a second test, a membrane-permeable drug that directly activates the downstream kinase of the pathway was added in place of L.
Cell line | Labeled L bound | Response to L | Response to the drug
1 | high | high | high
2 | none | none | high
3 | high | none | none
Which statement is best supported?', null, md5('apbio-mcq-b4-sv-h-4.1-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cell line 3 lacks the receptor, since it does not respond to L.', false, 'Line 3 binds L strongly, so the receptor is present, and its failure to respond to the drug as well points downstream.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cell line 2 lacks a functional receptor for L but has an intact downstream pathway, while cell line 3 has a receptor but a defect downstream.', true, 'Correct: line 2 does not bind L yet responds when the pathway is activated directly, so reception is the failed step; line 3 binds L but does not respond even to the drug, so the defect lies downstream.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell line 2 has a defect in transduction, since it gives no response to L.', false, 'Line 2 responds to the drug, so its transduction machinery works, and the missing step is binding of L.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell line 1 shows that receptors are never needed, since the drug alone can produce its response.', false, 'The drug is an artificial bypass, and in a normal cell the pathway is turned on by ligand binding to the receptor, as the response of line 1 to L shows.' from version_ins;
-- apbio-mcq-b4-h-4.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.2-a', 'mcq', 'use an experiment to decide receptor location and whether the response needs gene expression', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Ligand M is a 30-kDa protein. When M is added to the medium around liver cells, glycogen breakdown begins within 20 seconds. When M is microinjected directly into the cytoplasm of a liver cell, there is no response. The protein-synthesis inhibitor cycloheximide does not change the response to M added outside the cell, but a PKA inhibitor abolishes the response. Which conclusion is best supported?', null, md5('apbio-mcq-b4-h-4.2-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'M binds a receptor on the cell surface, and the response is relayed by proteins already in the cytoplasm, such as PKA, without new protein synthesis.', true, 'Correct: a response to outside M but not to injected M places the receptor at the plasma membrane; cycloheximide has no effect, so no new proteins are needed; the PKA inhibitor blocks the response, so PKA relays the signal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'M enters the cell, binds an intracellular receptor, and acts as a transcription factor that produces new proteins within seconds.', false, 'Injecting M into the cytoplasm gave no response, which an intracellular receptor would not predict, and the response needs no new protein synthesis.' from version_ins
union all select gen_random_uuid(), id, 'C', 'M binds a membrane receptor, but the response needs newly synthesized proteins, and cycloheximide did not block them because it acts too slowly.', false, 'The response arises within 20 seconds and cycloheximide had no effect on it, so no newly made proteins are needed.' from version_ins
union all select gen_random_uuid(), id, 'D', 'M enters the cell through a channel and directly activates PKA, which then breaks down glycogen.', false, 'If M acted directly on PKA inside the cell, injecting it would have caused a response, and it did not.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-h-4.1-a','apbio-mcq-b4-sv-h-4.1-a-v1','apbio-mcq-b4-sv-h-4.1-a-v2','apbio-mcq-b4-sv-h-4.1-a-v3','apbio-mcq-b4-h-4.1-b','apbio-mcq-b4-sv-h-4.1-b-v1','apbio-mcq-b4-sv-h-4.1-b-v2','apbio-mcq-b4-sv-h-4.1-b-v3','apbio-mcq-b4-h-4.2-a']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-h-4.1-a','apbio-mcq-b4-sv-h-4.1-a-v1','apbio-mcq-b4-sv-h-4.1-a-v2','apbio-mcq-b4-sv-h-4.1-a-v3','apbio-mcq-b4-h-4.1-b','apbio-mcq-b4-sv-h-4.1-b-v1','apbio-mcq-b4-sv-h-4.1-b-v2','apbio-mcq-b4-sv-h-4.1-b-v3','apbio-mcq-b4-h-4.2-a']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
