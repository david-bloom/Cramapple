begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-5.4-c-v1','apbio-mcq-b4-sv-h-5.4-c-v2','apbio-mcq-b4-sv-h-5.4-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b4-sv-h-5.4-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-c-v1', 'mcq', 'maternal organelle inheritance (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant has a chloroplast DNA variant that makes seedlings pale. A pale seed parent is pollinated by a green plant; in a reciprocal cross, a green seed parent receives pollen from a pale plant. Assume chloroplasts enter the embryo through the ovule, not pollen. Which reciprocal outcome supports organelle inheritance?', null, md5('apbio-mcq-b4-sv-h-5.4-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Seedlings follow the pollen parent: green first and pale in the reciprocal cross.', false, 'Pollen is explicitly excluded as a chloroplast source in this model.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both crosses give a 3:1 pale:green ratio expected for a dominant nuclear allele.', false, 'A 3:1 nuclear ratio is not predicted by ovule-only organelle transmission.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Every seedling is pale because either parent can supply chloroplasts equally.', false, 'The two parents do not contribute chloroplasts equally under the stated mechanism.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Seedlings follow the seed parent: pale in the first cross and green in the reciprocal cross.', true, 'Correct: The stated ovule-only chloroplast transmission makes the chloroplast genotype of the seed parent decisive. Reversing which plant supplies the ovule reverses the seedling phenotype.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-c-v2', 'mcq', 'maternal organelle inheritance (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A homoplasmic mitochondrial variant in a mammal produces a measurable metabolic defect. An affected daughter of an affected mother mates with an unaffected male. Assume full penetrance and usual maternal organelle transmission. What is predicted for her children, and why does her affected brother have a different transmission risk?', null, md5('apbio-mcq-b4-sv-h-5.4-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Only her daughters inherit the variant, and her brother passes it to his sons.', false, 'Mitochondrial inheritance is maternal for sons and daughters, not mother-to-daughter only.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Half her children inherit it by Mendelian segregation of one nuclear allele.', false, 'The modeled allele is mitochondrial rather than a segregating nuclear heterozygote.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Her children are unaffected because the variant skips one generation.', false, 'The stated assumptions provide no generation-skipping mechanism.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Her children of either sex inherit the variant; her brother does not pass his mitochondrial DNA to offspring because sperm ordinarily do not transmit mitochondria.', true, 'Correct: A daughter receives the maternal variant and supplies mitochondria to her own eggs; under homoplasmy and full penetrance all her children inherit it regardless of sex. Her brother can inherit it but ordinarily does not transmit it through sperm.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-c-v3', 'mcq', 'maternal organelle inheritance (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In reciprocal fish crosses, all daughters and sons of variant-carrying mothers show a mitochondrial trait, while no offspring of variant-carrying fathers do. A student proposes a fully penetrant X-linked dominant nuclear allele. Which observation most directly challenges that proposal?', null, md5('apbio-mcq-b4-sv-h-5.4-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'All sons of affected mothers are affected; this alone rules out every X-linked model.', false, 'Affected sons of mothers can occur under X-linked inheritance too, so that fact alone does not rule it out.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The phenotype appears in both sexes; any trait present in both sexes must be autosomal.', false, 'Sex-linked traits can appear in both sexes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Affected sons and daughters both track the mother, and affected fathers transmit to neither sex; maternal organelle transmission explains the reciprocal asymmetry.', true, 'Correct: The complete absence of paternal transmission to daughters as well as sons, together with transmission from variant-carrying mothers to both sexes, is the reciprocal-cross pattern expected for maternally inherited mitochondria. An affected father would transmit a fully penetrant X-linked dominant allele to every daughter, contradicting the observation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'No affected father has an affected son; this proves an X-linked allele rather than an organelle allele.', false, 'Father-to-son absence also occurs for X-linked traits, but the decisive pattern includes father-to-daughter absence and maternal transmission to both sexes.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-5.4-c-v1','apbio-mcq-b4-sv-h-5.4-c-v2','apbio-mcq-b4-sv-h-5.4-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-sv-h-5.4-c-v1','apbio-mcq-b4-sv-h-5.4-c-v2','apbio-mcq-b4-sv-h-5.4-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
