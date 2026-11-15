begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-5.5-a','apbio-mcq-b5-sv-h-5.5-a-v1','apbio-mcq-b5-sv-h-5.5-a-v2','apbio-mcq-b5-sv-h-5.5-a-v3','apbio-mcq-b5-h-5.5-b','apbio-mcq-b5-sv-h-5.5-b-v1','apbio-mcq-b5-sv-h-5.5-b-v2','apbio-mcq-b5-sv-h-5.5-b-v3','apbio-mcq-b5-h-5.5-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b5-h-5.5-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-5.5-a', 'mcq', 'controlled plasticity experiments', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Researchers propagate genetically identical clones of one flowering plant. Plants in acidic soil make blue flowers, and plants in alkaline soil make pink flowers. When clones are moved to the opposite soil before new buds form, the new flowers match the new soil. Which conclusion is best supported, and what control isolates the environmental cause?', null, md5('apbio-mcq-b5-h-5.5-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The pH treatment permanently changed the allele sequence in every clone; compare only blue plants with unrelated pink plants.', false, 'A reversible new-flower response in clones does not establish a permanent allele change, and unrelated plants confound genotype.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The same genotype has a plastic flower-color phenotype; grow randomized clones in both soils while holding light, water, and age constant.', true, 'Correct: Clonal genotype is held constant while soil pH changes, and new flowers reverse with transfer. That supports an environmentally responsive phenotype rather than an inherited sequence change. Replicated randomized clones with other conditions controlled isolate pH.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The color shift proves blue is a dominant allele; cross two blue plants without controlling soil.', false, 'A cross without a controlled environment does not identify the cause of this reversible response.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The plants have different genotypes because their flowers differ; no environmental control is needed.', false, 'Phenotypic differences among clones need not imply different DNA sequences.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-a-v1', 'mcq', 'controlled plasticity experiments (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Genetically identical insect larvae are randomly assigned to two diets. Adults on diet X have dark wings, and adults on diet Y have light wings; an assay finds the same pigment-gene DNA sequence in both groups. Which follow-up most directly tests whether diet changes expression of that gene rather than selecting a preexisting genotype?', null, md5('apbio-mcq-b5-sv-h-5.5-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Sequence only the dark-winged adults again and assume any RNA difference is inherited.', false, 'Repeating DNA sequencing alone does not test transcription, and one phenotype group cannot reveal a diet contrast.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Mate one dark adult with one light adult and ignore the diets of their offspring.', false, 'Uncontrolled offspring diets cannot separate parental genotype from environmental exposure.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Measure only body mass in the two diet groups because wing expression cannot vary without DNA changes.', false, 'The same DNA sequence can be expressed at different levels in different environments.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Raise new clonal larvae on each diet and compare pigment-gene RNA levels in wing tissue at the same developmental stage.', true, 'Correct: Random assignment of clones holds genotype constant. Measuring pigment-gene RNA in the relevant tissue and stage under each diet tests environment-dependent expression associated with the wing phenotype.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-a-v2', 'mcq', 'controlled plasticity experiments (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two identical plant cuttings grow in full sun or shade. Sun-grown leaves are small and thick; shade-grown leaves are large and thin. New leaves produced after the cuttings exchange light treatments follow the new treatment. Which inference is justified, and which is not?', null, md5('apbio-mcq-b5-sv-h-5.5-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Leaf form is plastic within this genotype; the observations do not show that the cuttings acquired different heritable alleles.', true, 'Correct: The genotype is held constant and newly formed leaves respond to the current light environment after a switch. Existing leaves need not remodel. The data support phenotypic plasticity, not a demonstrated change in inherited sequence.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Sunlight must have rewritten the DNA of every leaf, and the new alleles are inherited by seeds.', false, 'A phenotype shift in new leaves does not establish germline DNA change or inheritance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cuttings originally carried different alleles because their mature leaves differed.', false, 'Identical cuttings from one clone share the same starting genotype.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Because the first leaves remain unchanged, the later leaves cannot be environmentally influenced.', false, 'Developmental timing explains why old leaves persist while new leaves respond to changed light.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-a-v3', 'mcq', 'controlled plasticity experiments (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A clonal fish line develops darker coloration in cool water than in warm water. Fish from both treatments are bred, and their offspring are all reared at the same temperature; the offspring color distributions overlap. Which explanation best fits both generations, and what design feature supports it?', null, md5('apbio-mcq-b5-sv-h-5.5-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cool water permanently mutates the pigment allele in every parent, so all their offspring must remain darker in common water.', false, 'An induced permanent mutation is neither shown nor consistent with the stated common-environment result.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The parental groups must have different genotypes because the parents have different colors.', false, 'Different parental phenotypes do not require different genotypes in a clonal line.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Temperature alters phenotype within the parental genotype; the common offspring temperature removes the parental environmental difference when comparing offspring.', true, 'Correct: The clonal parents share a genotype but differ with rearing temperature. A common environment for offspring removes their environmental contrast, and overlapping distributions do not support a fixed inherited color difference.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Offspring overlap proves that temperature never affected the parents.', false, 'The parental treatment contrast is direct evidence of an environmental effect despite overlap in their offspring.' from version_ins;
-- apbio-mcq-b5-h-5.5-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-5.5-b', 'mcq', 'reaction norm interaction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Clones of genotype A average 10 pigment units in cool water and 20 in warm water. Genotype B averages 12 in cool water and 12 in warm water. Which comparison identifies a genotype-by-environment interaction?', null, md5('apbio-mcq-b5-h-5.5-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'A and B differ in cool water, so only genotype matters and temperature has no effect.', false, 'A changes by 10 units, so temperature clearly matters for at least that genotype.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Warming changes A by +10 units but B by 0, so the environmental effect depends on genotype.', true, 'Correct: A responds to warming by 20−10=10 units; B responds by 12−12=0. Unequal environmental responses are a genotype-by-environment interaction.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Both genotypes were tested twice, so their reaction norms must be parallel.', false, 'Reaction norms are parallel only when their environmental changes are equal.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The average pigment level of both groups is 12, proving no interaction.', false, 'An aggregate average cannot replace comparing the two genotype-specific changes.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-b-v1', 'mcq', 'reaction norm interaction (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A plant height experiment grows two genotypes under low and high nutrients. Genotype A averages 10 cm then 20 cm; genotype B averages 15 cm then 25 cm. Which interpretation of these reaction norms is supported?', null, md5('apbio-mcq-b5-sv-h-5.5-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Both genotypes gain 10 cm, so there are genotype and nutrient effects but no interaction in these mean responses.', true, 'Correct: The nutrient change is +10 cm for A and +10 cm for B, giving parallel reaction norms. B is consistently 5 cm taller and both grow taller with nutrients, but the measured environment effect does not differ by genotype.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The 5-cm difference at low nutrients proves the nutrient effect differs between genotypes.', false, 'A genotype difference at one environment is not an interaction when the environmental changes are equal.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The high-nutrient environment changes the A genotype into the B genotype.', false, 'Nutrient treatment can change growth without changing allele identity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A and B have identical phenotypes in both environments, so neither genotype nor nutrients matter.', false, 'The stated means differ by genotype and by nutrient level.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-b-v2', 'mcq', 'reaction norm interaction (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a pigment trait, genotype A averages 20 units in low light and 10 in high light; genotype B averages 10 in low light and 20 in high light. What does the reversal of genotype ranking imply?', null, md5('apbio-mcq-b5-sv-h-5.5-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Light has no effect because the combined mean is 15 units in both environments.', false, 'Equal pooled means can hide opposite genotype-specific responses.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The response to light depends on genotype: A changes −10 and B changes +10, a crossing interaction.', true, 'Correct: A changes from 20 to 10 (−10) while B changes from 10 to 20 (+10). The opposite slopes and ranking reversal show a genotype-by-environment interaction even though pooled means match.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A is intrinsically higher than B in every environment because it is higher in low light.', false, 'The ranking reverses under high light, so A is not higher than B in every environment.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The genotypes must have exchanged their alleles when moved between light treatments.', false, 'Phenotypic response need not involve allele exchange.' from version_ins;
-- apbio-mcq-b5-sv-h-5.5-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-sv-h-5.5-b-v3', 'mcq', 'reaction norm interaction (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Clonal genotype C makes 8 enzyme units at 18°C and 8 at 28°C. Clonal genotype D makes 8 units at 18°C and 20 at 28°C. Which result best distinguishes plasticity from a genotype difference that is fixed across both temperatures?', null, md5('apbio-mcq-b5-sv-h-5.5-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'D changes by +12 units while C changes by 0; D is plastic over this interval and the temperature effect depends on genotype.', true, 'Correct: Within-genotype comparison shows C has zero response and D gains 12 units. Their reaction norms differ, so D shows plasticity over the tested interval and the environmental effect depends on genotype.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both genotypes are equally plastic because they match at 18°C.', false, 'Matching in one environment does not imply matching responses across environments.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Only genotype can affect enzyme level, because temperature cannot change DNA sequence.', false, 'Temperature may alter expression or activity without changing DNA sequence.' from version_ins
union all select gen_random_uuid(), id, 'D', 'C and D must be the same genotype because they share an 8-unit phenotype at 18°C.', false, 'Equal phenotype under one condition does not establish identical genotype.' from version_ins;
-- apbio-mcq-b5-h-5.5-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b5-h-5.5-c', 'mcq', 'environmental cues and expression', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Eggs from one reptile clutch are randomly assigned to two incubation temperatures. All embryos have the same measured alleles at a candidate sex-associated locus. The colder group is mostly one sex, while the warmer group is mostly the other. Which conclusion and follow-up best distinguish an environmental developmental cue from inherited allele differences?', null, md5('apbio-mcq-b5-h-5.5-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Temperature must have replaced the candidate allele in all warm embryos; no replication is needed.', false, 'Phenotype association does not prove DNA replacement, and replication is needed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The clutch contains only one genotype, so any sex difference must be random and cannot involve temperature.', false, 'Shared measured alleles do not rule out environment-dependent developmental pathways.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Incubation temperature is associated with sex phenotype within this clutch; replicate the split-clutch treatment across more clutches while genotyping parents and offspring.', true, 'Correct: Randomized incubation temperature within a clutch reduces genetic confounding, and matched measured alleles make a simple allele difference less likely. Repeating across clutches with genotype data tests a temperature-dependent developmental outcome.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sex of the adult parents alone establishes that the embryo temperature has no developmental effect.', false, 'Parental sex does not test the manipulated incubation condition.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b5-h-5.5-a','apbio-mcq-b5-sv-h-5.5-a-v1','apbio-mcq-b5-sv-h-5.5-a-v2','apbio-mcq-b5-sv-h-5.5-a-v3','apbio-mcq-b5-h-5.5-b','apbio-mcq-b5-sv-h-5.5-b-v1','apbio-mcq-b5-sv-h-5.5-b-v2','apbio-mcq-b5-sv-h-5.5-b-v3','apbio-mcq-b5-h-5.5-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b5-h-5.5-a','apbio-mcq-b5-sv-h-5.5-a-v1','apbio-mcq-b5-sv-h-5.5-a-v2','apbio-mcq-b5-sv-h-5.5-a-v3','apbio-mcq-b5-h-5.5-b','apbio-mcq-b5-sv-h-5.5-b-v1','apbio-mcq-b5-sv-h-5.5-b-v2','apbio-mcq-b5-sv-h-5.5-b-v3','apbio-mcq-b5-h-5.5-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
