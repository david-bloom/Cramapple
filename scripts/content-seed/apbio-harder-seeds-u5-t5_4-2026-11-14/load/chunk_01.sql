begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-h-5.4-a','apbio-mcq-b4-sv-h-5.4-a-v1','apbio-mcq-b4-sv-h-5.4-a-v2','apbio-mcq-b4-sv-h-5.4-a-v3','apbio-mcq-b4-h-5.4-b','apbio-mcq-b4-sv-h-5.4-b-v1','apbio-mcq-b4-sv-h-5.4-b-v2','apbio-mcq-b4-sv-h-5.4-b-v3','apbio-mcq-b4-h-5.4-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b4-h-5.4-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-5.4-a', 'mcq', 'linked-gene recombination data', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A testcross of an AB/ab heterozygote yields 40 AB, 40 ab, 10 Ab, and 10 aB offspring. Which marker classes are recombinant, and what is the estimated map distance between A and B?', null, md5('apbio-mcq-b4-h-5.4-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'AB and ab; (40+40)/100=80 map units.', false, 'The frequent AB and ab classes are parental, not recombinant.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ab and aB; (10+10)/100=20 map units.', true, 'Correct: The common parental arrangements are AB and ab. Recombinant classes are Ab and aB, totaling 20 of 100 offspring, so recombination frequency is 20% and estimated distance is 20 map units.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ab and aB; 10/100=10 map units because only one recombinant class counts.', false, 'Both reciprocal recombinant classes contribute to the numerator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four classes; 100/100=100 map units.', false, 'Parental offspring are not counted as recombination products.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-a-v1', 'mcq', 'linked-gene recombination data (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a testcross of CD/cd, counts are CD=70, cd=70, Cd=30, and cD=30. What is the recombination frequency, and which observation argues against independent assortment of these markers?', null, md5('apbio-mcq-b4-sv-h-5.4-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '70%; the parental classes are the recombinant categories.', false, 'The 70% is the parental share, not the recombinant share.' from version_ins
union all select gen_random_uuid(), id, 'B', '50%; four phenotypic classes always imply independent assortment.', false, 'Four classes can occur even for linked genes; their frequencies matter.' from version_ins
union all select gen_random_uuid(), id, 'C', '15%; only one of the two reciprocal recombinant classes should be counted.', false, 'Both reciprocal recombinant classes must be included.' from version_ins
union all select gen_random_uuid(), id, 'D', '30%; the two parental classes total 140/200, substantially more than the 60/200 recombinant offspring.', true, 'Correct: The parental classes CD and cd are most frequent. Recombination frequency=(30+30)/200=30%. A 1:1:1:1 testcross would give 50% recombinant; here parental combinations predominate, consistent with linkage.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-a-v2', 'mcq', 'linked-gene recombination data (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two linked genes are 10 map units apart. A testcross of EF/ef produces 400 offspring. If recombinant classes occur equally often and sampling matches expectation, how many Ef and eF offspring should be expected?', null, md5('apbio-mcq-b4-sv-h-5.4-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20 Ef and 20 eF; 10% of 400 is 40 recombinant offspring split evenly.', true, 'Correct: Ten map units corresponds to 10% recombinant offspring: 0.10×400=40 total. The reciprocal recombinant classes Ef and eF are equal under the stated assumption, so each has 20.' from version_ins
union all select gen_random_uuid(), id, 'B', '40 Ef and 40 eF; 10% applies separately to each class.', false, 'This doubles the total recombinant fraction to 20%.' from version_ins
union all select gen_random_uuid(), id, 'C', '180 Ef and 180 eF; these are the parental class counts.', false, 'The common EF and ef parental classes together account for the other 360 offspring.' from version_ins
union all select gen_random_uuid(), id, 'D', '100 Ef and 100 eF; independent assortment is assumed despite the 10-map-unit distance.', false, 'Independent assortment predicts 50% recombinants and conflicts with the stated 10-map-unit distance.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-a-v3', 'mcq', 'linked-gene recombination data (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A testcross of GH/gh yields 200 GH, 200 gh, 50 Gh, and 50 gH offspring. A student says the genes must assort independently because four classes appear. Which response uses the data correctly?', null, md5('apbio-mcq-b4-sv-h-5.4-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The recombinant share is 400/500=80%, so the genes cannot be linked.', false, 'This counts common parental classes as recombinants.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The four observed classes alone establish a 1:1:1:1 ratio and independent assortment.', false, 'The class counts are 200:200:50:50, far from 1:1:1:1.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The recombinant share is 100/500=20%, corresponding to about 20 map units; the parental excess supports linkage.', true, 'Correct: GH and gh are parental (400 total); Gh and gH are recombinant (100 total). Their fraction is 100/500=0.20, not the 0.50 expected for independently assorting markers in this testcross. Four classes do not imply equal frequencies.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Map distance is 50 units because there are 50 offspring in each rare class.', false, 'Map units reflect a percentage of total offspring, not the raw count in one class.' from version_ins;
-- apbio-mcq-b4-h-5.4-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-5.4-b', 'mcq', 'codominance and incomplete dominance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Pure-breeding red and white flowers produce uniformly pink F1 flowers. The F1 plants self-pollinate, and 200 F2 plants grow under identical conditions. Under a single-locus model, which pattern and mechanism predict the F2 phenotypes?', null, md5('apbio-mcq-b4-h-5.4-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'About 150 red and 50 white; red is completely dominant.', false, 'Complete dominance would make F1 red, not pink.' from version_ins
union all select gen_random_uuid(), id, 'B', 'About 50 red, 100 pink, and 50 white; incomplete dominance makes the heterozygote intermediate.', true, 'Correct: An intermediate pink F1 heterozygote indicates incomplete dominance. A heterozygote self-cross gives 1 RR:2 RW:1 WW, yielding 50 red:100 pink:50 white among 200 F2 plants.' from version_ins
union all select gen_random_uuid(), id, 'C', 'About 50 red, 100 flowers showing distinct red and white patches, and 50 white; codominance is shown by pink blending.', false, 'Codominance expresses both parental phenotypes distinctly, rather than blending them into pink.' from version_ins
union all select gen_random_uuid(), id, 'D', 'About 100 red and 100 white; heterozygotes cannot occur in F2.', false, 'Selfing heterozygotes produces heterozygous F2 offspring.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-b-v1', 'mcq', 'codominance and incomplete dominance (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A fish has two alleles for a surface marker: M makes an M antigen and N makes an N antigen. MN fish show both antigens. Two MN fish mate. Which phenotype fraction and inheritance pattern are expected among offspring?', null, md5('apbio-mcq-b4-sv-h-5.4-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'One half show both antigens; codominance gives MM:MN:NN=1:2:1.', true, 'Correct: Both parental antigens in MN demonstrate codominance. MN×MN yields MM, MN, MN, NN, so 2/4=1/2 display both antigens.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Three quarters show only M antigen; M is completely dominant.', false, 'The heterozygote displays N as well, contradicting complete M dominance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'One half show an intermediate antigen rather than both; this is incomplete dominance.', false, 'The stem says both distinct antigens are present, not one blended intermediate product.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All show both antigens because each parent expresses both.', false, 'Segregation creates MM and NN offspring as well as MN.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-b-v2', 'mcq', 'codominance and incomplete dominance (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a plant, RR flowers are solid red, WW flowers are solid white, and RW flowers have separate red and white patches. If RW is crossed with WW, what offspring phenotypes and genetic explanation are expected?', null, md5('apbio-mcq-b4-sv-h-5.4-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Half pink and half white; the two colors blend in the heterozygote, showing incomplete dominance.', false, 'Pink blending is not the observed RW phenotype.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Half patched and half white; the heterozygote separately expresses both alleles, showing codominance.', true, 'Correct: RW produces R and W gametes; WW produces only W. Offspring are half RW with both-color patches and half WW white. Distinct simultaneous expression is codominance.' from version_ins
union all select gen_random_uuid(), id, 'C', 'All patched; the W allele cannot be inherited from two parents.', false, 'Half the offspring receive W from both parents and are white.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Three quarters patched and one quarter white; a heterozygote self-cross is being performed.', false, 'RW×WW is a testcross-like cross, not RW×RW.' from version_ins;
-- apbio-mcq-b4-sv-h-5.4-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-5.4-b-v3', 'mcq', 'codominance and incomplete dominance (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An enzyme activity trait has one locus: HH individuals average 100 units, LL individuals 0 units, and HL individuals 50 units in the same environment. An HL individual is crossed with an LL individual. Which expectation and interpretation follow?', null, md5('apbio-mcq-b4-sv-h-5.4-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Half the offspring average 50 units and half 0 units; the heterozygote is intermediate, consistent with incomplete dominance.', true, 'Correct: HL makes H and L gametes equally; LL makes L gametes. Offspring are half HL (50 units) and half LL (0 units). The intermediate heterozygote phenotype is the stated incomplete-dominance pattern.' from version_ins
union all select gen_random_uuid(), id, 'B', 'All offspring average 50 units; all inherit H from the HL parent.', false, 'An HL parent passes its L allele to half its offspring, making LL offspring rather than all HL.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Half the offspring express separate 100-unit and 0-unit enzymes; the 50-unit measurement proves codominance.', false, 'The 50-unit aggregate phenotype is intermediate; the stem does not report separate simultaneous products.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Three quarters average 100 units and one quarter 0 units; H is completely dominant.', false, 'This cross is HL×LL, which gives a 1:1 genotype ratio, not 3:1.' from version_ins;
-- apbio-mcq-b4-h-5.4-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-h-5.4-c', 'mcq', 'maternal organelle inheritance', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A beetle mother carries a mixture of normal and variant mitochondria. Her sons and daughters differ in flight ability, and measurements find different fractions of variant mitochondria among siblings. In the reciprocal cross, a variant-carrying father and a mother with only normal mitochondria produce offspring with only normal mitochondrial DNA. Which mechanism explains both the parent-of-origin pattern and the variable severity among the first mother’s offspring?', null, md5('apbio-mcq-b4-h-5.4-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The father transmits mitochondria only to daughters, while independent assortment of nuclear chromosomes changes severity.', false, 'The reciprocal cross shows no paternal variant transmission, and organelle assortment is not limited to daughters.' from version_ins
union all select gen_random_uuid(), id, 'B', 'A single autosomal dominant allele from either parent is inherited by exactly half the offspring and directly sets each variant-mitochondria fraction.', false, 'A nuclear allele does not account for the observed variable fractions of variant mitochondrial DNA and the lack of paternal transmission.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mitochondria ordinarily enter through the egg, and random assortment of her mixed mitochondria can give offspring different variant fractions.', true, 'Correct: The absence of paternal variant mitochondrial DNA supports ordinary maternal organelle transmission. The mother is heteroplasmic, so random distribution of normal and variant mitochondria into eggs and early cells can produce siblings with different variant fractions and phenotypic severity.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Crossing over between homologous nuclear chromosomes creates the mitochondrial DNA fractions in eggs and sperm equally.', false, 'Nuclear crossing over changes linked nuclear alleles; it neither produces the observed mitochondrial fractions nor equal paternal transmission.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-h-5.4-a','apbio-mcq-b4-sv-h-5.4-a-v1','apbio-mcq-b4-sv-h-5.4-a-v2','apbio-mcq-b4-sv-h-5.4-a-v3','apbio-mcq-b4-h-5.4-b','apbio-mcq-b4-sv-h-5.4-b-v1','apbio-mcq-b4-sv-h-5.4-b-v2','apbio-mcq-b4-sv-h-5.4-b-v3','apbio-mcq-b4-h-5.4-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-h-5.4-a','apbio-mcq-b4-sv-h-5.4-a-v1','apbio-mcq-b4-sv-h-5.4-a-v2','apbio-mcq-b4-sv-h-5.4-a-v3','apbio-mcq-b4-h-5.4-b','apbio-mcq-b4-sv-h-5.4-b-v1','apbio-mcq-b4-sv-h-5.4-b-v2','apbio-mcq-b4-sv-h-5.4-b-v3','apbio-mcq-b4-h-5.4-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
