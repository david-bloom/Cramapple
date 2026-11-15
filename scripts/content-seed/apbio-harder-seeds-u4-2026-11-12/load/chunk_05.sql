begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-h-4.5-b','apbio-mcq-b4-sv-h-4.5-b-v1','apbio-mcq-b4-sv-h-4.5-b-v2','apbio-mcq-b4-sv-h-4.5-b-v3','apbio-mcq-b4-h-4.6-a','apbio-mcq-b4-sv-h-4.6-a-v1','apbio-mcq-b4-sv-h-4.6-a-v2','apbio-mcq-b4-sv-h-4.6-a-v3','apbio-mcq-b4-h-4.6-b'])) then raise exception 'chunk 5 already loaded'; end if;
end $$;
-- apbio-mcq-b4-h-4.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.5-b', 'mcq', 'infer cell-cycle arrest point from DNA content distribution', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A cultured cell line has 3.0 pg of DNA per cell in G1 and 6.0 pg after DNA replication is complete, until the cell divides. Flow cytometry measures DNA per cell.
Sample | Cells at 3.0 pg | Cells between 3.0 and 6.0 pg | Cells at 6.0 pg
Untreated | 52% | 18% | 30%
24 hours with drug D | 6% | 9% | 85%
Which conclusion is best supported?', null, md5('apbio-mcq-b4-h-4.5-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Drug D arrests cells in G1, before DNA replication begins.', false, 'A G1 arrest would leave most cells at 3.0 pg, and only 6% are there.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Drug D arrests cells during S phase, partway through DNA replication.', false, 'An S-phase arrest would leave most cells between 3.0 and 6.0 pg, and only 9% are there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Drug D lets cells replicate their DNA but arrests them in G2 or mitosis, before the cell divides.', true, 'Correct: most treated cells hold 6.0 pg, so they have completed S phase, and few are at 3.0 pg or in between; they stay at 6.0 pg until division, so they are arrested in G2 or M.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Drug D makes cells leave the cycle and enter G0, in which they hold 6.0 pg of DNA.', false, 'Cells in G0 have not replicated their DNA and would hold 3.0 pg.' from version_ins;
-- apbio-mcq-b4-sv-h-4.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.5-b-v1', 'mcq', 'infer cell-cycle arrest point from DNA content distribution (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A haploid yeast strain has a temperature-sensitive mutation in a gene. DNA content is measured in relative units (1 unit in G1, 2 units after replication).
Sample | Cells at 1 unit | Cells between 1 and 2 units | Cells at 2 units
Permissive temperature | 50% | 20% | 30%
4 hours at restrictive temperature | 92% | 5% | 3%
Which conclusion is best supported about the mutated gene?', null, md5('apbio-mcq-b4-sv-h-4.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The gene product is needed to move from G1 into DNA replication.', true, 'Correct: nearly all mutant cells end up at 1 unit, so they never start DNA replication.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The gene product is needed to complete DNA replication during S phase.', false, 'A defect in completing S phase would leave many cells between 1 and 2 units, and only 5% are there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The gene product is needed to carry out mitosis, so cells pile up with replicated DNA.', false, 'A defect in mitosis would leave cells at 2 units, and only 3% are there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The gene product is needed for cytokinesis, so cells pile up with two nuclei and 2 units of DNA.', false, 'A cytokinesis defect would also leave cells at 2 units or more, and the cells are at 1 unit.' from version_ins;
-- apbio-mcq-b4-sv-h-4.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.5-b-v2', 'mcq', 'infer cell-cycle arrest point from DNA content distribution (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug that blocks nucleotide synthesis is added to cultured cells that hold 3.0 pg of DNA in G1 and 6.0 pg after replication. After 12 hours, flow cytometry shows 8% of cells at 3.0 pg, 87% between 3.0 and 6.0 pg, and 5% at 6.0 pg. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.5-b-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'DNA replication began but cannot be completed, so most cells are stuck partway through S phase.', true, 'Correct: most cells hold intermediate amounts of DNA, so they started to copy their DNA but did not finish, which fits blocked nucleotide synthesis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cells are arrested in G1, before replication starts.', false, 'Cells in G1 hold 3.0 pg, and only 8% are there.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cells are arrested in G2, after replication is complete.', false, 'Cells in G2 hold 6.0 pg, and only 5% are there.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cells are arrested in mitosis, before the cells divide.', false, 'Cells in mitosis also hold 6.0 pg, so the data do not show a mitotic arrest.' from version_ins;
-- apbio-mcq-b4-sv-h-4.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.5-b-v3', 'mcq', 'infer cell-cycle arrest point from DNA content distribution (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells are kept in medium without serum for 4 days. Flow cytometry shows 93% of the cells at 3.0 pg of DNA (the amount in G1 before replication). Twenty hours after serum is added, 40% of the cells are at 3.0 pg, 35% are between 3.0 and 6.0 pg, and 25% are at 6.0 pg. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.5-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The starved cells were arrested before DNA replication (in G1 or G0), and serum let them re-enter the cycle, replicate DNA and move on.', true, 'Correct: starved cells hold only 3.0 pg, so they are in G1 or G0; after serum, many cells hold intermediate or 6.0 pg amounts, which means DNA replication occurred.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The starved cells were arrested in G2, and serum made them divide and enter G1.', false, 'Cells arrested in G2 would hold 6.0 pg, and the starved cells held 3.0 pg.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Serum blocks DNA replication, so the cells between 3.0 and 6.0 pg are damaged.', false, 'Cells between 3.0 and 6.0 pg are copying their DNA, which shows replication happened and was not blocked.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Serum makes cells skip S phase and go directly into mitosis.', false, 'Cells that skip S would not gain DNA, and many cells now have more than 3.0 pg.' from version_ins;
-- apbio-mcq-b4-h-4.6-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.6-a', 'mcq', 'predict effect of nondegradable cyclin using cyclin and CDK dynamics', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In dividing cells, the concentration of the kinase CDK1 stays constant. Cyclin B accumulates during G2, peaks at metaphase, and falls sharply at anaphase. CDK1 kinase activity rises and falls with the amount of cyclin B. A mutant cyclin B cannot be degraded. Which outcome is most likely in cells that make only the mutant cyclin B?', null, md5('apbio-mcq-b4-h-4.6-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cells never enter mitosis, because CDK1 cannot be activated by the mutant cyclin.', false, 'The mutant cyclin builds up like the normal one and activates CDK1, so entry into mitosis is not blocked.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cells enter mitosis normally but cannot complete it, because CDK1 activity stays high after anaphase.', true, 'Correct: cyclin B rises normally, so CDK1 activates and the cells enter mitosis; without degradation of cyclin B, CDK1 stays active and mitosis cannot be completed.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cells skip mitosis and begin another round of DNA replication, because cyclin B is present.', false, 'High cyclin B and CDK1 activity keep cells in mitosis, and they do not move into a new round of replication.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cells divide normally, because the amount of CDK1 and not the amount of cyclin sets the timing.', false, 'CDK1 is constant, and its activity depends on cyclin B, so the cyclin level controls timing.' from version_ins;
-- apbio-mcq-b4-sv-h-4.6-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.6-a-v1', 'mcq', 'predict effect of nondegradable cyclin using cyclin and CDK dynamics (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher measures a cell population through one cell cycle.
Stage | CDK1 protein (relative) | Cyclin B (relative) | CDK1 kinase activity (relative)
G1 | 1.0 | 0.1 | 0.1
S | 1.0 | 0.2 | 0.2
G2 | 1.0 | 0.8 | 0.7
Metaphase | 1.0 | 1.0 | 1.0
After anaphase | 1.0 | 0.1 | 0.1
Which statement best explains why kinase activity changes even though the amount of CDK1 stays the same?', null, md5('apbio-mcq-b4-sv-h-4.6-a-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CDK1 is active only when it is bound to cyclin B, so kinase activity follows the cyclin B level.', true, 'Correct: CDK1 protein is constant at 1.0, while kinase activity tracks the cyclin B column, showing that CDK1 depends on cyclin binding for activity.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CDK1 is made and degraded in each cycle, so its amount follows the activity.', false, 'The table shows CDK1 at 1.0 at every stage, so its amount does not change.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CDK1 activity is independent of cyclin B, and the matching pattern is a coincidence.', false, 'Activity tracks cyclin B closely at every stage, which is not a coincidence.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Cyclin B is an enzyme that phosphorylates targets by itself, and CDK1 only holds it in place.', false, 'Cyclins have no kinase activity of their own, and the kinase is the CDK that cyclin binding activates.' from version_ins;
-- apbio-mcq-b4-sv-h-4.6-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.6-a-v2', 'mcq', 'predict effect of nondegradable cyclin using cyclin and CDK dynamics (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'After DNA damage, a cell makes large amounts of p21, a protein that binds and inhibits cyclin-CDK complexes needed to pass from G1 into S phase. Which result is predicted in the cells with high p21?', null, md5('apbio-mcq-b4-sv-h-4.6-a-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'CDK activity rises and the cells enter S phase faster.', false, 'P21 is an inhibitor, so CDK activity falls and the cells do not enter S phase faster.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CDK activity falls, and the cells arrest in G2 after DNA replication.', false, 'The inhibited complexes act at the G1 to S transition, so cells stop before they replicate DNA, and not after.' from version_ins
union all select gen_random_uuid(), id, 'C', 'CDK activity falls, and the cells arrest in G1 before DNA replication begins.', true, 'Correct: p21 inhibits the cyclin-CDK complexes needed for the G1 to S transition, so the cells stop in G1 before replication.' from version_ins
union all select gen_random_uuid(), id, 'D', 'CDK activity is unchanged, because inhibitors act only on cyclin synthesis.', false, 'P21 binds the cyclin-CDK complexes and lowers their activity directly, so activity does change.' from version_ins;
-- apbio-mcq-b4-sv-h-4.6-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.6-a-v3', 'mcq', 'predict effect of nondegradable cyclin using cyclin and CDK dynamics (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a classic experiment, researchers fused cells at different stages of the cell cycle. When a G1 cell was fused to a cell in S phase, the G1 nucleus began to replicate DNA early. When a G1 cell was fused to a cell in M phase, the G1 nucleus condensed its chromosomes. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.6-a-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cytoplasm of S-phase and M-phase cells contains diffusible regulators that can push a nucleus from G1 into that phase.', true, 'Correct: the G1 nucleus changes behavior after it is exposed to the cytoplasm of the fused partner, which shows that diffusible factors in S and M cells trigger replication and mitosis.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The stage of a cell is set only by the amount of DNA in its nucleus, with no role for cytoplasmic factors.', false, 'A G1 nucleus with unreplicated DNA began to replicate and to condense after fusion, so DNA amount alone does not set the stage.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Regulators of the cell cycle stay inside the nucleus and cannot move between cells.', false, 'The factors acted across the fused cytoplasm, so they were able to move from one nucleus to another.' from version_ins
union all select gen_random_uuid(), id, 'D', 'G1 nuclei hold inhibitors that stop S and M phase from starting.', false, 'The G1 nucleus responded to the signals from the partner cell, so it was not blocking S and M phase.' from version_ins;
-- apbio-mcq-b4-h-4.6-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-4.6-b', 'mcq', 'link loss of a checkpoint protein to cell-cycle behavior using data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Cells with normal p53 (WT) and cells with a mutated p53 gene are grown, and half of each group is exposed to UV light that damages DNA. Twenty-four hours later, researchers measure the percent of cells in G1 and S and the level of p21 protein.
Cells | UV | In G1 | In S | p21 level
WT | no | 60% | 30% | low
WT | yes | 90% | 4% | high
Mutated p53 | no | 60% | 30% | low
Mutated p53 | yes | 58% | 31% | low
Which conclusion is best supported?', null, md5('apbio-mcq-b4-h-4.6-b'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'p53 speeds up the cell cycle, because WT cells have more cells in G1.', false, 'Undamaged WT and mutated cells have the same percent in G1, so p53 does not change cycle speed on its own.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The mutated cells are in G0 after UV exposure, because they show no change.', false, 'Cells in G0 would not be cycling, and 31% of the mutated cells are in S, so they keep dividing.' from version_ins
union all select gen_random_uuid(), id, 'C', 'After DNA damage, p53 raises p21 and holds cells in G1; without p53, damaged cells continue into S phase.', true, 'Correct: without UV the two groups are the same, so p53 does not change the cycle by itself; after UV, only the WT cells raise p21 and arrest in G1, while mutated cells keep going into S phase.' from version_ins
union all select gen_random_uuid(), id, 'D', 'p53 repairs the UV damage directly, which allows the WT cells to enter S phase.', false, 'WT cells enter S phase far less after UV (4% against 30%), so they are held back and not helped to enter, and the data do not show repair.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-h-4.5-b','apbio-mcq-b4-sv-h-4.5-b-v1','apbio-mcq-b4-sv-h-4.5-b-v2','apbio-mcq-b4-sv-h-4.5-b-v3','apbio-mcq-b4-h-4.6-a','apbio-mcq-b4-sv-h-4.6-a-v1','apbio-mcq-b4-sv-h-4.6-a-v2','apbio-mcq-b4-sv-h-4.6-a-v3','apbio-mcq-b4-h-4.6-b']) and status='draft')<>9 then raise exception 'chunk 5: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-h-4.5-b','apbio-mcq-b4-sv-h-4.5-b-v1','apbio-mcq-b4-sv-h-4.5-b-v2','apbio-mcq-b4-sv-h-4.5-b-v3','apbio-mcq-b4-h-4.6-a','apbio-mcq-b4-sv-h-4.6-a-v1','apbio-mcq-b4-sv-h-4.6-a-v2','apbio-mcq-b4-sv-h-4.6-a-v3','apbio-mcq-b4-h-4.6-b']))<>36 then raise exception 'chunk 5: expected 36 choices'; end if;
end $$;
commit;
