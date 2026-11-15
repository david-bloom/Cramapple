begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-5.5-c-v1','apbio-mcq-b5-sv-h-5.5-c-v2','apbio-mcq-b5-sv-h-5.5-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b5-sv-h-5.5-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-c-v1', 'mcq', 'environmental cues and expression (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Genetically similar mice receive either a high or low UV exposure. Skin cells in the high-UV group express more melanin-synthesis RNA and contain more melanin, but germline genotypes are unchanged. Which mechanism and prediction best fit these observations?', null, md5('apbio-mcq-b5-sv-h-5.5-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'UV rewrites a germline pigment allele in every exposed mouse, so all descendants must be darker.', false, 'The stem explicitly says germline genotypes are unchanged.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The measured RNA difference proves the mice had different pigment DNA before exposure.', false, 'Expression levels can differ even when the underlying DNA sequence is the same.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Melanin concentration cannot change unless the number of chromosomes changes.', false, 'Pigment production can change through regulation without a chromosome-number change.' from version_ins
union all select gen_random_uuid(), id, 'D', 'UV exposure changes skin-cell expression and pigment phenotype; offspring raised without UV need not inherit the darker acquired skin.', true, 'Correct: Higher UV is associated with elevated pigment-pathway RNA in skin and more melanin without a stated germline sequence change. A somatic environmental response is not automatically inherited by offspring in a common environment.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-c-v2', 'mcq', 'environmental cues and expression (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two groups of genetically identical arctic mammals experience long or short daylight in controlled rooms with equal food and temperature. New coats grow brown in long days and white in short days. After the light schedules switch, newly grown coats match the new schedule. Which mechanism is most consistent?', null, md5('apbio-mcq-b5-sv-h-5.5-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Each short-day animal acquired a new white-fur allele that disappears when days lengthen.', false, 'A reversible response to light does not demonstrate alleles appearing and disappearing.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The two groups necessarily had different inherited coat-color genotypes despite being identical clones.', false, 'The premise fixes genotype across the groups.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Food shortage caused the white coat, even though food was held equal between groups.', false, 'Food is controlled and cannot explain the contrast in this experiment.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Photoperiod acts as an environmental cue that changes coat-color expression in the same genotype; the reversal argues against fixed new coat-color alleles.', true, 'Correct: Only day length differs initially, and newly grown coats respond to the switched schedule. That supports a reversible, environmentally cued expression program in a shared genotype.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-c-v3', 'mcq', 'environmental cues and expression (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A yeast clone produces mating pheromone only when it senses cells of the opposite mating type nearby. When those cells are removed, pheromone RNA falls; reintroducing them raises RNA again. What does this reversible result show, and what comparison isolates the cue?', null, md5('apbio-mcq-b5-sv-h-5.5-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The yeast clone switches to a new inherited mating-type allele whenever another cell approaches.', false, 'A reversible transcriptional response does not require or demonstrate an inherited allele switch.' from version_ins
union all select gen_random_uuid(), id, 'B', 'RNA changes prove the cultures had different genotypes before treatment, so environmental controls are unnecessary.', false, 'The clonal premise and reversible response support a regulated phenotype rather than preexisting genotype differences.' from version_ins
union all select gen_random_uuid(), id, 'C', 'One genotype can alter expression with its social environment; compare replicate clone cultures with and without opposite-type cells under otherwise matched conditions.', true, 'Correct: The same clone shows reversible RNA changes with presence of the opposite mating type. Matched replicate cultures differing only in that cue can test environmental regulation of expression.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The pheromone is produced constitutively, because a gene cannot be turned on and off by a cue.', false, 'Genes can be regulated by environmental signals and need not be constitutively expressed.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-sv-h-5.5-c-v1','apbio-mcq-b5-sv-h-5.5-c-v2','apbio-mcq-b5-sv-h-5.5-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-sv-h-5.5-c-v1','apbio-mcq-b5-sv-h-5.5-c-v2','apbio-mcq-b5-sv-h-5.5-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
