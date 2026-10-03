begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['APBIO-MCQ-SV-005-v1','APBIO-MCQ-SV-005-v3','APBIO-MCQ-SV-008-v1','APBIO-MCQ-SV-008-v2','APBIO-MCQ-SV-008-v3','APBIO-MCQ-SV-014-v1','APBIO-MCQ-SV-014-v2','APBIO-MCQ-SV-016-v1'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- APBIO-MCQ-SV-005-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-005-v1', 'mcq', 'Yeast permease and sugar isomers', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Galactose and glucose are monosaccharides that both have the molecular formula C6H12O6, but one hydroxyl group is oriented differently, so the two molecules have different three-dimensional shapes. A permease in the plasma membrane of yeast cells imports galactose far more slowly than it imports glucose. Which statement best explains why the permease can distinguish between the two sugars?', null, md5('APBIO-MCQ-SV-005-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The sugars contain different elements, so the permease binds glucose because it carries more atoms of carbon than galactose does.', false, 'Both sugars are C6H12O6, so they contain exactly the same numbers of every element; the proposed difference in atoms does not exist.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The sugars contain the same atoms in different arrangements, so their shapes differ and only glucose fits the binding site of the permease well.', true, 'The same atoms arranged differently give each sugar a distinct three-dimensional shape, and a transport protein binds the shape that fits its binding site.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Galactose is a lipid with a hydrophobic backbone, so the permease cannot move it through the membrane as quickly as glucose.', false, 'Galactose is a carbohydrate, not a lipid; it has many hydroxyl groups and is polar, so its identity as a monosaccharide matches glucose.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The sugars are joined by different types of covalent bonds, so the permease recognizes the sugar that has the stronger bonds.', false, 'Each sugar is a single monosaccharide; there are no bonds joining separate subunits, so bond type between monomers cannot explain the difference.' from version_ins;
-- APBIO-MCQ-SV-005-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-005-v3', 'mcq', 'Same amino acids different order', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two tripeptides are made from the same three amino acids, alanine, glycine, and serine, but in the order Ala-Gly-Ser in one and Ser-Gly-Ala in the other. An antibody binds the first peptide strongly and the second one very weakly. Which statement best explains why the antibody can tell the two peptides apart?', null, md5('APBIO-MCQ-SV-005-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The peptides have different total masses because order changes atoms, so the antibody binds the peptide with the greater mass.', false, 'Rearranging the order of the same amino acids does not change the number or kind of atoms, so the masses are equal.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The peptides have the same composition but different sequences, so the groups are arranged differently in space and fit the antibody differently.', true, 'Sequence order changes which R groups sit where, giving a different three-dimensional shape and surface for antibody binding.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The peptides contain different amino acids, so the antibody binds the peptide that has the larger number of different R groups.', false, 'Both peptides contain exactly the same three amino acids; only the order differs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The peptides use different kinds of covalent linkages between subunits, so the antibody binds the one with peptide bonds.', false, 'Both peptides are linked by peptide bonds; the linkage type is identical.' from version_ins;
-- APBIO-MCQ-SV-008-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-008-v1', 'mcq', 'Surface leucine causes aggregation', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A mutation in a bacterial enzyme replaces a serine (polar, uncharged) on the protein''s surface with leucine (nonpolar, hydrophobic). The mutant enzyme folds normally and remains active, but in water its molecules clump together into large aggregates, whereas the normal enzyme stays dispersed. Which best explains why the mutant molecules aggregate?', null, md5('APBIO-MCQ-SV-008-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The leucine side chains form peptide bonds with neighboring enzyme molecules, joining the proteins into one large covalent polymer.', false, 'Peptide bonds form only between the amino group and carboxyl group of amino acids during translation; R groups do not form them with other proteins.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The exposed nonpolar leucine side chains on separate molecules associate with each other to avoid water, linking the molecules through hydrophobic interactions.', true, 'Hydrophobic side chains exposed on the surface cluster together away from water, so separate protein molecules stick together.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The leucine side chains form strong hydrogen bonds with water, which pulls the molecules together into aggregates.', false, 'Nonpolar side chains cannot form hydrogen bonds with water; serine, the polar residue that was replaced, could.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The leucine substitution adds a negative charge, so the neighboring molecules are attracted to each other by ionic bonds.', false, 'Leucine''s side chain is nonpolar and uncharged, so it contributes no charge and no ionic attraction.' from version_ins;
-- APBIO-MCQ-SV-008-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-008-v2', 'mcq', 'Loss of ionic attraction between subunits', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two subunits of a dimeric enzyme normally associate at an interface where aspartate 40 (negatively charged) on subunit A sits next to lysine 112 (positively charged) on subunit B. A mutation replaces lysine 112 with glutamate (negatively charged). The mutant subunits fold correctly but no longer form stable dimers. Which best explains the loss of dimer formation?', null, md5('APBIO-MCQ-SV-008-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The attraction between opposite charges is lost and the two negatively charged side chains now repel each other at the interface.', true, 'Replacing the positive lysine with negative glutamate removes the ionic attraction and creates electrostatic repulsion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mutation breaks the peptide bond at position 112, so the subunit is cut in two and cannot reach the interface.', false, 'The substitution changes an R group only; the peptide bonds of the backbone remain intact and the subunit folds correctly.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Glutamate is nonpolar, so it moves into the core of the subunit and no longer faces the interface where it could bind.', false, 'Glutamate has a charged carboxyl side chain and is polar; it would not be buried like a nonpolar residue.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The glutamate side chain forms a disulfide bond with aspartate 40, which locks the surface of subunit B in the wrong shape.', false, 'Glutamate and aspartate contain no sulfur, so neither can take part in a disulfide bond; disulfide bonds require cysteines.' from version_ins;
-- APBIO-MCQ-SV-008-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-008-v3', 'mcq', 'Buried hydrophobic residue replaced by charged residue', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a small globular enzyme, valine at position 73 is normally buried in the interior of the folded protein, surrounded by other nonpolar side chains. A mutation replaces valine 73 with aspartate, which has a negatively charged side chain. The mutant protein folds poorly and loses most of its activity at body temperature. Which best explains this effect?', null, md5('APBIO-MCQ-SV-008-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The negative charge of aspartate forms hydrogen bonds that are stronger than hydrophobic interactions and so improve stability.', false, 'A mismatch of a charged group in a nonpolar core lowers stability; the mutant is less stable, not more.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Aspartate cannot form peptide bonds, so the polypeptide chain is cut at position 73 and the enzyme is shorter than normal.', false, 'Aspartate has the same amino and carboxyl groups as other amino acids and forms peptide bonds normally.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A charged side chain placed in the nonpolar interior cannot interact favorably with the surrounding nonpolar groups, destabilizing the folded tertiary structure.', true, 'Charged groups are unstable in a hydrophobic core, so the protein''s tertiary structure is disrupted.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The aspartate substitution changes the primary structure only, and primary structure has no effect on folding of the polypeptide.', false, 'The sequence of amino acids determines how the chain folds; changing one residue can alter tertiary structure.' from version_ins;
-- APBIO-MCQ-SV-014-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-014-v1', 'mcq', 'Cell classification with flagellum and chloroplast', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two cells from a pond sample are examined by electron microscopy. Cell 1 is about 1 μm long, has a circular chromosome in a nucleoid region, 70S ribosomes, a flagellum, and no membrane-bound organelles. Cell 2 is about 15 μm long, has a nucleus, 80S ribosomes, chloroplasts, mitochondria, and a cellulose cell wall. Which conclusion is most directly supported by the observations?', null, md5('APBIO-MCQ-SV-014-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both cells are prokaryotic because both are single cells living in the same pond and cannot be classified by structure.', false, 'Cells can be classified by structural features such as a nucleus, organelles, and ribosome type; habitat does not determine the cell type.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cell 1 is eukaryotic because it has a flagellum, which is a structure found only in cells that contain membrane-bound organelles.', false, 'Prokaryotes can have flagella; a flagellum does not indicate eukaryotic classification.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell 1 is prokaryotic because it lacks a nucleus and membrane-bound organelles, and Cell 2 is eukaryotic because it has both.', true, 'Absence of a nucleus and of membrane-bound organelles marks a prokaryote (ribosomes are not membrane-bound organelles), and presence of a nucleus and membrane-bound organelles marks a eukaryote.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell 2 is prokaryotic because it has a cell wall, and a cell wall is a feature that only prokaryotes possess.', false, 'Plants, fungi, and algae are eukaryotes with cell walls, so a wall does not indicate prokaryote status.' from version_ins;
-- APBIO-MCQ-SV-014-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-014-v2', 'mcq', 'Large prokaryote and small eukaryote', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher compares two cells. Cell 1 is about 100 μm in diameter, has circular DNA free in the cytoplasm, 70S ribosomes, and no nucleus or other membrane-bound organelles. Cell 2 is about 8 μm in diameter, has a nucleus, mitochondria, 80S ribosomes, and a chitin cell wall. Which conclusion about the cells is most directly supported by the observations?', null, md5('APBIO-MCQ-SV-014-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both cells are prokaryotic because both have ribosomes and DNA, which are the only structures all cells need.', false, 'Ribosomes and DNA occur in both types; the nucleus, organelles, and 80S ribosomes show Cell 2 is eukaryotic.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Cell 1 is eukaryotic because its larger diameter shows that it must contain a nucleus and organelles to support its size.', false, 'Size does not determine classification; Cell 1 lacks a nucleus and organelles, so it is prokaryotic.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cell 2 is prokaryotic because its small size and its cell wall are characteristics found only in prokaryotic cells.', false, 'Cell 2 has a nucleus and mitochondria, which define it as eukaryotic; small size and cell walls occur in both types.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cell 1 is prokaryotic and Cell 2 is eukaryotic, because internal structure and not cell size separates the two types.', true, 'Absence of a nucleus and organelles defines Cell 1 as prokaryotic despite its large size; Cell 2 has a nucleus and organelles.' from version_ins;
-- APBIO-MCQ-SV-016-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'APBIO-MCQ-SV-016-v1', 'mcq', 'Potato core mass change in sucrose', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A student weighs a potato core, places it in 0.6 M sucrose for one hour, and reweighs it. The core''s mass falls from 5.0 g to 4.3 g, a change of -14%, and the tissue feels limp. A core placed in distilled water instead gains mass and feels firm. Which best explains the limp tissue in 0.6 M sucrose?', null, md5('APBIO-MCQ-SV-016-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sucrose entered the cells through the cell wall and replaced the cytoplasm, so the cells lost mass through exchange of sugar.', false, 'Sucrose is a large solute that does not freely cross the membrane; the mass loss reflects water leaving the cells.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Water left the cells by osmosis because the sucrose solution was hypertonic, so turgor pressure fell and the tissue became limp.', true, 'Net water moved out down its gradient, cytoplasm lost volume, and the loss of turgor made the tissue limp.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cells stopped using osmosis in sucrose, so the tissue lost mass through evaporation rather than through water movement.', false, 'The measured loss arises from net osmosis out of the cells; sucrose does not switch osmosis off.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Water entered the cells until the cell wall burst, which released fluid into the solution and lowered the mass.', false, 'Water left the cells in the hypertonic solution; water entry produces firm tissue, not bursting.' from version_ins;
commit;
