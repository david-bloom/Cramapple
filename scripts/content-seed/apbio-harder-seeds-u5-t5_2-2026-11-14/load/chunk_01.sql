begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-h-5.2-a','apbio-mcq-b2-sv-h-5.2-a-v1','apbio-mcq-b2-sv-h-5.2-a-v2','apbio-mcq-b2-sv-h-5.2-a-v3','apbio-mcq-b2-h-5.2-b','apbio-mcq-b2-sv-h-5.2-b-v1','apbio-mcq-b2-sv-h-5.2-b-v2','apbio-mcq-b2-sv-h-5.2-b-v3','apbio-mcq-b2-h-5.2-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b2-h-5.2-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-5.2-a', 'mcq', 'independent assortment probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An organism has 3 homologous chromosome pairs. Ignore crossing over and assume each pair orients independently at meiosis I. What is the chance that one gamete gets a specified maternal-or-paternal homolog from every pair, and which meiotic event creates these possible combinations?', null, md5('apbio-mcq-b2-h-5.2-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/3; sister chromatids separate at anaphase II to create 3 equiprobable assortments.', false, 'Meiosis II separates sisters; the number of whole-homolog configurations is exponential in homolog-pair count, not equal to that count.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/8; random orientation of homologous pairs at metaphase I creates 8 equiprobable whole-chromosome assortments.', true, 'Correct: Each of the 3 pairs has two independent maternal/paternal choices, giving 2^3=8 combinations and probability (1/2)^3=1/8 for one specified combination. The source of these whole-chromosome combinations is independent assortment at meiosis I; crossing over is excluded.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/16; random fertilization doubles the possible homolog assortments within one gamete.', false, 'Fertilization combines two gametes but does not change the probability for a specified assortment in one gamete.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/8; crossing over in prophase I is required to create the 8 whole-chromosome assortments.', false, 'The numerical probability is right, but the mechanism is wrong: independent orientation creates these combinations without crossing over.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-a-v1', 'mcq', 'independent assortment probability (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An organism has 4 homologous chromosome pairs. Ignore crossing over and assume each pair orients independently at meiosis I. What is the chance that one gamete gets a specified maternal-or-paternal homolog from every pair, and which meiotic event creates these possible combinations?', null, md5('apbio-mcq-b2-sv-h-5.2-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4; sister chromatids separate at anaphase II to create 4 equiprobable assortments.', false, 'Meiosis II separates sisters; the number of whole-homolog configurations is exponential in homolog-pair count, not equal to that count.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/32; random fertilization doubles the possible homolog assortments within one gamete.', false, 'Fertilization combines two gametes but does not change the probability for a specified assortment in one gamete.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/16; crossing over in prophase I is required to create the 16 whole-chromosome assortments.', false, 'The numerical probability is right, but the mechanism is wrong: independent orientation creates these combinations without crossing over.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/16; random orientation of homologous pairs at metaphase I creates 16 equiprobable whole-chromosome assortments.', true, 'Correct: Each of the 4 pairs has two independent maternal/paternal choices, giving 2^4=16 combinations and probability (1/2)^4=1/16 for one specified combination. The source of these whole-chromosome combinations is independent assortment at meiosis I; crossing over is excluded.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-a-v2', 'mcq', 'independent assortment probability (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An organism has 5 homologous chromosome pairs. Ignore crossing over and assume each pair orients independently at meiosis I. What is the chance that one gamete gets a specified maternal-or-paternal homolog from every pair, and which meiotic event creates these possible combinations?', null, md5('apbio-mcq-b2-sv-h-5.2-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/32; random orientation of homologous pairs at metaphase I creates 32 equiprobable whole-chromosome assortments.', true, 'Correct: Each of the 5 pairs has two independent maternal/paternal choices, giving 2^5=32 combinations and probability (1/2)^5=1/32 for one specified combination. The source of these whole-chromosome combinations is independent assortment at meiosis I; crossing over is excluded.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/5; sister chromatids separate at anaphase II to create 5 equiprobable assortments.', false, 'Meiosis II separates sisters; the number of whole-homolog configurations is exponential in homolog-pair count, not equal to that count.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/64; random fertilization doubles the possible homolog assortments within one gamete.', false, 'Fertilization combines two gametes but does not change the probability for a specified assortment in one gamete.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/32; crossing over in prophase I is required to create the 32 whole-chromosome assortments.', false, 'The numerical probability is right, but the mechanism is wrong: independent orientation creates these combinations without crossing over.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-a-v3', 'mcq', 'independent assortment probability (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An organism has 6 homologous chromosome pairs. Ignore crossing over and assume each pair orients independently at meiosis I. What is the chance that one gamete gets a specified maternal-or-paternal homolog from every pair, and which meiotic event creates these possible combinations?', null, md5('apbio-mcq-b2-sv-h-5.2-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/6; sister chromatids separate at anaphase II to create 6 equiprobable assortments.', false, 'Meiosis II separates sisters; the number of whole-homolog configurations is exponential in homolog-pair count, not equal to that count.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/128; random fertilization doubles the possible homolog assortments within one gamete.', false, 'Fertilization combines two gametes but does not change the probability for a specified assortment in one gamete.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/64; random orientation of homologous pairs at metaphase I creates 64 equiprobable whole-chromosome assortments.', true, 'Correct: Each of the 6 pairs has two independent maternal/paternal choices, giving 2^6=64 combinations and probability (1/2)^6=1/64 for one specified combination. The source of these whole-chromosome combinations is independent assortment at meiosis I; crossing over is excluded.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/64; crossing over in prophase I is required to create the 64 whole-chromosome assortments.', false, 'The numerical probability is right, but the mechanism is wrong: independent orientation creates these combinations without crossing over.' from version_ins;
-- apbio-mcq-b2-h-5.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-5.2-b', 'mcq', 'linked-marker crossover inference', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two linked markers are on one homolog as AB and on the other as ab. After meiosis, a researcher identifies gametes with AB, ab, Ab, and aB. Which gametes require an exchange between nonsister chromatids in the interval between the markers, and when can that exchange occur?', null, md5('apbio-mcq-b2-h-5.2-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'AB and ab; crossing over during prophase I is required to preserve the original combinations.', false, 'Those are the parental marker combinations, which can be inherited without recombination.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ab and aB; crossing over between nonsister chromatids during prophase I can create these new combinations.', true, 'Correct: The original chromosome arrangements are AB and ab. A crossover between the loci on nonsister chromatids during prophase I can exchange the second marker, producing Ab and aB. Independent separation alone preserves the linked arrangements.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ab and aB; separation of sister chromatids during meiosis II creates the new combinations without exchange.', false, 'Sister-chromatid separation sorts existing chromatids; it does not exchange linked alleles between homologs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four gamete classes; random fertilization creates their allele combinations inside a single gamete.', false, 'Fertilization combines already formed gametes and cannot create new allele arrangements inside one gamete.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-b-v1', 'mcq', 'linked-marker crossover inference (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two linked markers are on one homolog as CD and on the other as cd. After meiosis, a researcher identifies gametes with CD, cd, Cd, and cD. Which gametes require an exchange between nonsister chromatids in the interval between the markers, and when can that exchange occur?', null, md5('apbio-mcq-b2-sv-h-5.2-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Cd and cD; crossing over between nonsister chromatids during prophase I can create these new combinations.', true, 'Correct: The original chromosome arrangements are CD and cd. A crossover between the loci on nonsister chromatids during prophase I can exchange the second marker, producing Cd and cD. Independent separation alone preserves the linked arrangements.' from version_ins
union all select gen_random_uuid(), id, 'B', 'CD and cd; crossing over during prophase I is required to preserve the original combinations.', false, 'Those are the parental marker combinations, which can be inherited without recombination.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Cd and cD; separation of sister chromatids during meiosis II creates the new combinations without exchange.', false, 'Sister-chromatid separation sorts existing chromatids; it does not exchange linked alleles between homologs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four gamete classes; random fertilization creates their allele combinations inside a single gamete.', false, 'Fertilization combines already formed gametes and cannot create new allele arrangements inside one gamete.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-b-v2', 'mcq', 'linked-marker crossover inference (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two linked markers are on one homolog as EF and on the other as ef. After meiosis, a researcher identifies gametes with EF, ef, Ef, and eF. Which gametes require an exchange between nonsister chromatids in the interval between the markers, and when can that exchange occur?', null, md5('apbio-mcq-b2-sv-h-5.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'EF and ef; crossing over during prophase I is required to preserve the original combinations.', false, 'Those are the parental marker combinations, which can be inherited without recombination.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ef and eF; crossing over between nonsister chromatids during prophase I can create these new combinations.', true, 'Correct: The original chromosome arrangements are EF and ef. A crossover between the loci on nonsister chromatids during prophase I can exchange the second marker, producing Ef and eF. Independent separation alone preserves the linked arrangements.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Ef and eF; separation of sister chromatids during meiosis II creates the new combinations without exchange.', false, 'Sister-chromatid separation sorts existing chromatids; it does not exchange linked alleles between homologs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four gamete classes; random fertilization creates their allele combinations inside a single gamete.', false, 'Fertilization combines already formed gametes and cannot create new allele arrangements inside one gamete.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-b-v3', 'mcq', 'linked-marker crossover inference (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two linked markers are on one homolog as GH and on the other as gh. After meiosis, a researcher identifies gametes with GH, gh, Gh, and gH. Which gametes require an exchange between nonsister chromatids in the interval between the markers, and when can that exchange occur?', null, md5('apbio-mcq-b2-sv-h-5.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Gh and gH; crossing over between nonsister chromatids during prophase I can create these new combinations.', true, 'Correct: The original chromosome arrangements are GH and gh. A crossover between the loci on nonsister chromatids during prophase I can exchange the second marker, producing Gh and gH. Independent separation alone preserves the linked arrangements.' from version_ins
union all select gen_random_uuid(), id, 'B', 'GH and gh; crossing over during prophase I is required to preserve the original combinations.', false, 'Those are the parental marker combinations, which can be inherited without recombination.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Gh and gH; separation of sister chromatids during meiosis II creates the new combinations without exchange.', false, 'Sister-chromatid separation sorts existing chromatids; it does not exchange linked alleles between homologs.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four gamete classes; random fertilization creates their allele combinations inside a single gamete.', false, 'Fertilization combines already formed gametes and cannot create new allele arrangements inside one gamete.' from version_ins;
-- apbio-mcq-b2-h-5.2-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-h-5.2-c', 'mcq', 'division-specific nondisjunction', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid cell normally makes gametes with n=4 chromosomes. Four gametes from one meiosis have chromosome counts 5, 5, 3, and 3. Assuming a single nondisjunction event, which division failed, and how does the pattern support the inference?', null, md5('apbio-mcq-b2-h-5.2-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nondisjunction of sister chromatids in meiosis II; two gametes should still have 4 chromosomes.', false, 'Meiosis II nondisjunction leaves two normal gametes, which are absent here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing over in prophase I; exchanging chromosome segments creates the count differences.', false, 'Crossing over changes allele combinations, not the number of chromosomes in each gamete.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Nondisjunction of one homologous pair in meiosis I; all four gametes are abnormal, two n+1 and two n−1.', true, 'Correct: Failure of homologs to separate in meiosis I puts both homologs in one daughter cell and neither in the other. Normal meiosis II then yields two 5-chromosome and two 3-chromosome gametes, matching all four observations.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Normal independent assortment; random orientation of homologs creates the count differences.', false, 'Normal meiosis gives four n-chromosome gametes, not the observed two high and two low counts.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-h-5.2-a','apbio-mcq-b2-sv-h-5.2-a-v1','apbio-mcq-b2-sv-h-5.2-a-v2','apbio-mcq-b2-sv-h-5.2-a-v3','apbio-mcq-b2-h-5.2-b','apbio-mcq-b2-sv-h-5.2-b-v1','apbio-mcq-b2-sv-h-5.2-b-v2','apbio-mcq-b2-sv-h-5.2-b-v3','apbio-mcq-b2-h-5.2-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-h-5.2-a','apbio-mcq-b2-sv-h-5.2-a-v1','apbio-mcq-b2-sv-h-5.2-a-v2','apbio-mcq-b2-sv-h-5.2-a-v3','apbio-mcq-b2-h-5.2-b','apbio-mcq-b2-sv-h-5.2-b-v1','apbio-mcq-b2-sv-h-5.2-b-v2','apbio-mcq-b2-sv-h-5.2-b-v3','apbio-mcq-b2-h-5.2-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
