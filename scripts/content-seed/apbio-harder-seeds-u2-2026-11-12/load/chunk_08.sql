begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.8-b-v3','apbio-mcq-b5-h-2.9-a','apbio-mcq-b5-sv-h-2.9-a-v1','apbio-mcq-b5-sv-h-2.9-a-v2','apbio-mcq-b5-sv-h-2.9-a-v3','apbio-mcq-b5-h-2.9-b','apbio-mcq-b5-sv-h-2.9-b-v1','apbio-mcq-b5-sv-h-2.9-b-v2','apbio-mcq-b5-sv-h-2.9-b-v3'])) then raise exception 'chunk 8 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-2.8-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.8-b-v3', 'mcq', 'predict the effects on membrane area, vesicle supply, and secretion when endocytosis or exocytosis is blocked. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Macrophages ingest bacteria by phagocytosis. When a drug that blocks actin polymerization is added, the macrophages still bind bacteria to receptors on their surface but fail to engulf them. Which conclusion is best supported?', null, md5('apbio-mcq-b5-sv-h-2.8-b-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Binding of bacteria to the membrane requires actin, because binding fails when actin is blocked.', false, 'The macrophages still bind bacteria in the drug-treated state, so binding does not require actin.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Phagocytosis is a form of passive diffusion, so the drug has no effect on it.', false, 'Phagocytosis is an active, energy-requiring bulk transport process and is clearly affected by the drug.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Binding does not require actin, but extension of the membrane around the particle to form a vesicle requires actin filaments.', true, 'Correct: Binding still occurs, so receptors work, but engulfment fails, which shows that the cytoskeleton is required for reshaping the membrane to enclose the particle.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Actin filaments digest the bacteria after they are ingested.', false, 'Digestion is carried out by enzymes in lysosomes, and the observed defect occurs before ingestion.' from version_ins;
-- apbio-mcq-b5-h-2.9-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.9-a', 'mcq', 'calculate how confining molecules in a small compartment raises their concentration and the rate of a concentration-depe', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cell of volume 4,000 cubic micrometers makes 1.2 × 10⁵ molecules of intermediate I, which are used by an enzyme in a membrane-bound compartment of volume 200 cubic micrometers. Assume the reaction rate is proportional to the concentration of I. How does confining the molecules in the compartment compare with having the same molecules spread through the whole cell?', null, md5('apbio-mcq-b5-h-2.9-a'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The compartment makes 20 times as many molecules of I, so the reaction is 20 times faster.', false, 'Confinement does not create molecules, because the number of molecules of I stays at 1.2 × 10⁵ and only the concentration changes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The reaction rate is the same, because the number of molecules of I is the same in both cases.', false, 'Rate depends on concentration, not on the total number of molecules, and the concentration is 20 times higher.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The concentration of I is 20 times higher, so the reaction is about 20 times faster than if the same molecules were spread through the whole cell.', true, 'Correct: Spread through the cell, 1.2 × 10⁵ molecules in 4,000 cubic micrometers is 30 per cubic micrometer; in 200 cubic micrometers it is 600 per cubic micrometer. The ratio is 20, so a reaction proportional to [I] is about 20 times faster.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The compartment lowers the activation energy of the reaction by a factor of 20, which speeds it up.', false, 'A compartment does not change the activation energy of a reaction; enzymes do, and the speedup here results from a higher concentration.' from version_ins;
-- apbio-mcq-b5-sv-h-2.9-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.9-a-v1', 'mcq', 'calculate how confining molecules in a small compartment raises their concentration and the rate of a concentration-depe (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a chloroplast, 3.0 × 10⁵ hydrogen ions are pumped into the thylakoid lumen, which has a volume of 0.2 cubic micrometers. The stroma has a volume of 10 cubic micrometers. Compared with the concentration the same hydrogen ions would have if spread through the stroma, what is the H⁺ concentration in the lumen?', null, md5('apbio-mcq-b5-sv-h-2.9-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '50 times higher, because the volume of the lumen is one fiftieth that of the stroma.', true, 'Correct: 10 / 0.2 = 50, so the same number of ions in 1/50 of the volume has a 50-fold higher concentration.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The same, because the number of ions is the same.', false, 'The number of ions is the same, but the volume is different, and concentration is the number divided by the volume.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 50 times lower, because the lumen is smaller.', false, 'This inverts the relationship, because a smaller volume gives a higher concentration.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 1.7 times higher, which is the logarithm of 50.', false, 'The logarithm of 50 relates to the change in pH units, not to the ratio of concentrations.' from version_ins;
-- apbio-mcq-b5-sv-h-2.9-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.9-a-v2', 'mcq', 'calculate how confining molecules in a small compartment raises their concentration and the rate of a concentration-depe (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a muscle cell, 2.0 × 10⁸ calcium ions are moved into the sarcoplasmic reticulum, which occupies 5% of the cell volume. Compared with the concentration the same calcium ions would have if they were spread through the entire cell volume, the concentration in the sarcoplasmic reticulum is how much greater?', null, md5('apbio-mcq-b5-sv-h-2.9-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '5 times, because the compartment occupies 5% of the volume.', false, 'Using 5 treats the percentage as the factor, but the factor is the reciprocal of the volume fraction, 1 divided by 0.05.' from version_ins
union all select gen_random_uuid(), id, 'B', '95 times, because 95% of the cell volume is excluded.', false, 'The excluded fraction of the volume does not give the fold change in concentration.' from version_ins
union all select gen_random_uuid(), id, 'C', '20 times, because the compartment is one twentieth of the cell volume.', true, 'Correct: 5% of the volume is 1/20, so the concentration is 1 / 0.05 = 20 times higher than if the ions were spread through the whole cell.' from version_ins
union all select gen_random_uuid(), id, 'D', 'It is the same, because moving ions into a compartment does not change their concentration.', false, 'Concentration is the amount divided by the volume, so moving ions into a smaller space raises it.' from version_ins;
-- apbio-mcq-b5-sv-h-2.9-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.9-a-v3', 'mcq', 'calculate how confining molecules in a small compartment raises their concentration and the rate of a concentration-depe (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme and its substrate are both found at 10 times higher concentration inside a lysosome than they would be if the same molecules were spread through the cytoplasm. Assume the reaction rate is proportional to the product of the enzyme concentration and the substrate concentration. How does the rate in the lysosome compare with the rate that would occur in the cytoplasm?', null, md5('apbio-mcq-b5-sv-h-2.9-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '10 times higher, because the concentration of each is 10 times higher.', false, 'This counts the increase of only one of the two reactants, whereas both concentrations rise by a factor of 10.' from version_ins
union all select gen_random_uuid(), id, 'B', '20 times higher, because the two increases add together.', false, 'The rate depends on the product, not the sum, so the effects multiply rather than add.' from version_ins
union all select gen_random_uuid(), id, 'C', '100 times higher, because the rate depends on the product of the two concentrations.', true, 'Correct: Rate is proportional to [E][S]; each factor is 10 times greater, so the rate is 10 × 10 = 100 times greater.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The same, because the lysosome does not change the number of molecules.', false, 'The rate depends on concentration rather than on the total number of molecules, and both concentrations are higher.' from version_ins;
-- apbio-mcq-b5-h-2.9-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-2.9-b', 'mcq', 'assign organelles to fractions of a centrifuged homogenate from the biochemical activities in each fraction.', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Liver tissue is homogenized and separated by centrifugation into four fractions. Fraction 1 contains 85% of the cell''s DNA, in linear chromosomes, and little other activity. Fraction 2 carries out most of the oxygen consumption and ATP synthesis when given pyruvate and also contains 8% of the DNA, as small circular molecules. Fraction 3 contains hydrolytic enzymes with an activity optimum at pH 5. Fraction 4 consists of tiny closed vesicles that have ribosomes on their outer surface and make proteins that enter the vesicle interior. Which assignment is best supported?', null, md5('apbio-mcq-b5-h-2.9-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fraction 1, nuclei; fraction 2, mitochondria; fraction 3, lysosomes; fraction 4, rough ER fragments.', true, 'Correct: Linear chromosomes indicate nuclei. Oxygen use with ATP synthesis plus a small circular genome indicates mitochondria. Acid hydrolases indicate lysosomes. Ribosome-studded vesicles that make proteins for their interior are fragments of rough ER.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fraction 1, mitochondria; fraction 2, nuclei; fraction 3, lysosomes; fraction 4, rough ER fragments.', false, 'This swaps the first two fractions, but the linear nuclear chromosomes are in fraction 1 and the circular DNA is in the fraction that consumes oxygen.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fraction 1, nuclei; fraction 2, mitochondria; fraction 3, rough ER fragments; fraction 4, lysosomes.', false, 'This swaps the last two, but hydrolytic enzymes with an acid optimum are lysosomal, and ribosome-studded vesicles are rough ER.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fraction 1, nuclei; fraction 2, lysosomes; fraction 3, mitochondria; fraction 4, rough ER fragments.', false, 'The fraction that makes ATP using oxygen is mitochondria, while the acid hydrolases belong to lysosomes, so these two are swapped.' from version_ins;
-- apbio-mcq-b5-sv-h-2.9-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.9-b-v1', 'mcq', 'assign organelles to fractions of a centrifuged homogenate from the biochemical activities in each fraction. (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A spinach leaf homogenate is separated into four fractions. Fraction 1 contains 80% of the chlorophyll and produces oxygen in light. Fraction 2 contains 90% of the DNA, in linear chromosomes bound to histones. Fraction 3 consumes oxygen in the dark when given NADH and also contains a small circular DNA. Fraction 4 contains the enzyme catalase, which breaks down hydrogen peroxide, and has no DNA. Which assignment is best supported?', null, md5('apbio-mcq-b5-sv-h-2.9-b-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fraction 1, mitochondria; fraction 2, nuclei; fraction 3, chloroplasts; fraction 4, peroxisomes.', false, 'Chlorophyll and oxygen production in light belong to chloroplasts, not mitochondria, so these two are swapped.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fraction 1, chloroplasts; fraction 2, nuclei; fraction 3, mitochondria; fraction 4, peroxisomes.', true, 'Correct: Chlorophyll and light-driven oxygen production indicate chloroplasts; linear histone-bound chromosomes indicate nuclei; dark oxygen consumption with a circular genome indicates mitochondria; catalase with no DNA indicates peroxisomes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fraction 1, chloroplasts; fraction 2, nuclei; fraction 3, peroxisomes; fraction 4, mitochondria.', false, 'Dark oxygen consumption with a circular genome indicates mitochondria, and catalase indicates peroxisomes, so these two are swapped.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fraction 1, chloroplasts; fraction 2, mitochondria; fraction 3, nuclei; fraction 4, peroxisomes.', false, 'DNA in linear chromosomes with histones is the nuclear genome, and a small circular DNA with oxygen consumption indicates mitochondria, so these two are swapped.' from version_ins;
-- apbio-mcq-b5-sv-h-2.9-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.9-b-v2', 'mcq', 'assign organelles to fractions of a centrifuged homogenate from the biochemical activities in each fraction. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pancreatic tissue is homogenized and separated into four fractions. Fraction 1 contains most of the DNA. Fraction 2 consists of closed vesicles studded with ribosomes on the outside that synthesize digestive enzyme precursors. Fraction 3 consists of stacked, flattened sacs that attach carbohydrate groups to proteins and sort them. Fraction 4 consists of membrane-bound granules packed with finished digestive enzymes that are released when the cell is stimulated. Which assignment is best supported?', null, md5('apbio-mcq-b5-sv-h-2.9-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fraction 2, Golgi complex; fraction 3, rough ER; fraction 4, lysosomes.', false, 'The ribosome-studded vesicles are rough ER, and the sacs that modify and sort proteins are the Golgi complex, so these two are swapped.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fraction 2, rough ER; fraction 3, Golgi complex; fraction 4, secretory granules.', true, 'Correct: Ribosome-studded vesicles making proteins are rough ER; stacked sacs that modify and sort proteins are the Golgi complex; granules that store finished enzymes for release are secretory granules.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fraction 2, rough ER; fraction 3, secretory granules; fraction 4, Golgi complex.', false, 'Stacked sacs that modify and sort proteins are the Golgi complex, and granules that store enzymes for release are secretory granules, so these two are swapped.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fraction 2, rough ER; fraction 3, Golgi complex; fraction 4, lysosomes.', false, 'Lysosomes contain hydrolytic enzymes for intracellular digestion and are not described as releasing their contents when the cell is stimulated.' from version_ins;
-- apbio-mcq-b5-sv-h-2.9-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-2.9-b-v3', 'mcq', 'assign organelles to fractions of a centrifuged homogenate from the biochemical activities in each fraction. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Skeletal muscle is homogenized and separated into four fractions. Fraction 1 contains most of the DNA, in linear chromosomes. Fraction 2 consumes oxygen and makes ATP when given pyruvate. Fraction 3 consists of membrane vesicles that take up Ca²⁺ using an ATP-driven pump. Fraction 4 is the soluble liquid fraction, which contains the enzymes of glycolysis and has no membranes. Which assignment is best supported?', null, md5('apbio-mcq-b5-sv-h-2.9-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Fraction 2, mitochondria; fraction 3, smooth ER (sarcoplasmic reticulum); fraction 4, cytosol.', true, 'Correct: Oxygen consumption with ATP synthesis is mitochondria; membrane vesicles that pump Ca²⁺ using ATP are smooth ER (sarcoplasmic reticulum); a soluble fraction with no membranes is cytosol.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Fraction 2, nuclei; fraction 3, cytosol; fraction 4, smooth ER.', false, 'The DNA-rich linear chromosomes are in fraction 1, so fraction 2, which makes ATP using oxygen, cannot be nuclei.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Fraction 2, mitochondria; fraction 3, cytosol; fraction 4, smooth ER.', false, 'A membrane-free soluble fraction cannot be the vesicles that pump Ca²⁺, so fractions 3 and 4 are swapped.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Fraction 2, smooth ER (sarcoplasmic reticulum); fraction 3, mitochondria; fraction 4, cytosol.', false, 'The fraction making ATP with oxygen is mitochondria, so the two membrane fractions are swapped.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-2.8-b-v3','apbio-mcq-b5-h-2.9-a','apbio-mcq-b5-sv-h-2.9-a-v1','apbio-mcq-b5-sv-h-2.9-a-v2','apbio-mcq-b5-sv-h-2.9-a-v3','apbio-mcq-b5-h-2.9-b','apbio-mcq-b5-sv-h-2.9-b-v1','apbio-mcq-b5-sv-h-2.9-b-v2','apbio-mcq-b5-sv-h-2.9-b-v3']) and status='draft')<>9 then raise exception 'chunk 8: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-2.8-b-v3','apbio-mcq-b5-h-2.9-a','apbio-mcq-b5-sv-h-2.9-a-v1','apbio-mcq-b5-sv-h-2.9-a-v2','apbio-mcq-b5-sv-h-2.9-a-v3','apbio-mcq-b5-h-2.9-b','apbio-mcq-b5-sv-h-2.9-b-v1','apbio-mcq-b5-sv-h-2.9-b-v2','apbio-mcq-b5-sv-h-2.9-b-v3']))<>36 then raise exception 'chunk 8: expected 36 choices'; end if;
end $$;
commit;
