begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b3-h-5.3-a','apbio-mcq-b3-sv-h-5.3-a-v1','apbio-mcq-b3-sv-h-5.3-a-v2','apbio-mcq-b3-sv-h-5.3-a-v3','apbio-mcq-b3-h-5.3-b','apbio-mcq-b3-sv-h-5.3-b-v1','apbio-mcq-b3-sv-h-5.3-b-v2','apbio-mcq-b3-sv-h-5.3-b-v3','apbio-mcq-b3-h-5.3-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b3-h-5.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-h-5.3-a', 'mcq', 'conditional two-locus genotype probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two genes A/a and B/b are on different chromosomes. In an AaBb × AaBb cross, an offspring has both dominant phenotypes (A_B_). What is the probability that this offspring is AaBb?', null, md5('apbio-mcq-b3-h-5.3-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4; the unconditional probability of AaBb is 1/4.', false, 'This ignores the information that the offspring is already known to have both dominant phenotypes.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/9; among the 9/16 offspring with both dominant phenotypes, 4/16 are AaBb.', true, 'Correct: Independent segregation gives P(AaBb)=1/2×1/2=1/4=4/16 and P(A_B_)=3/4×3/4=9/16. Conditioning yields (4/16)/(9/16)=4/9.' from version_ins
union all select gen_random_uuid(), id, 'C', '9/16; this is the probability of the observed phenotype, not the conditional genotype.', false, 'This is the frequency of the conditioning phenotype rather than the requested genotype given that phenotype.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/9; each dominant phenotype forces a homozygous dominant genotype.', false, 'Dominant phenotypes include both homozygotes and heterozygotes; they do not force homozygosity.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-a-v1', 'mcq', 'conditional two-locus genotype probability (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Genes A/a and B/b segregate independently. In an AaBb × Aabb cross, a randomly selected offspring has phenotype A_bb. What is the probability that the offspring genotype is Aabb?', null, md5('apbio-mcq-b3-sv-h-5.3-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/2; half of all offspring are Aa before conditioning on the A_ phenotype.', false, 'The unconditional Aa frequency must be divided by the 3/4 chance of A_.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/4; this treats the A and B genotypes as two independent heterozygote probabilities after conditioning.', false, 'The given recessive b phenotype fixes bb, so another factor of 1/2 should not be applied.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3; this counts the AA share among A_ offspring instead of the Aa share.', false, 'Only one of the three dominant-A genotype parts is AA; two are Aa.' from version_ins
union all select gen_random_uuid(), id, 'D', '2/3; among A_ offspring, two thirds are Aa, and bb is already specified.', true, 'Correct: At A, Aa×Aa gives AA:Aa:aa=1:2:1, so P(Aa|A_)=2/3. At B, Bb×bb can yield bb, and the observed bb phenotype fixes that genotype. Thus P(Aabb|A_bb)=2/3.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-a-v2', 'mcq', 'conditional two-locus genotype probability (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two independently assorting genes are crossed as AaBb × aaBb. An offspring has phenotype A_B_. What is the conditional probability that it is AaBb?', null, md5('apbio-mcq-b3-sv-h-5.3-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2/3; A_ forces Aa in this cross, while two of the three B_ genotype parts are Bb.', true, 'Correct: At A, the aa parent contributes a, so an A_ offspring must be Aa. At B, Bb×Bb gives BB:Bb:bb=1:2:1, and P(Bb|B_)=2/3. Therefore P(AaBb|A_B_)=2/3.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2; this uses the unconditional probability of Bb.', false, 'B_ is known, so its Bb probability is 2/3 rather than the unconditional 1/2.' from version_ins
union all select gen_random_uuid(), id, 'C', '1/3; this selects BB rather than Bb among B_ offspring.', false, 'One third of B_ offspring are BB; the requested genotype has Bb.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/4; this multiplies two unconditional heterozygote probabilities.', false, 'Conditioning makes A_ deterministically Aa here, so an extra 1/2 factor is wrong.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-a-v3', 'mcq', 'conditional two-locus genotype probability (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Two genes assort independently in an AaBb × AaBb cross. Among offspring that show both dominant phenotypes (A_B_), what fraction has genotype AABb?', null, md5('apbio-mcq-b3-sv-h-5.3-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/8; this is the unconditional chance of AABb.', false, 'The phenotype has been observed, so divide the unconditional genotype chance by 9/16.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/9; this is the conditional chance of AaBb, a different genotype.', false, 'AaBb has twice as many heterozygote possibilities as the requested AABb genotype.' from version_ins
union all select gen_random_uuid(), id, 'C', '2/9; P(AABb)=1/4×1/2=2/16 and P(A_B_)=9/16.', true, 'Correct: P(AABb)=P(AA)P(Bb)=1/4×1/2=1/8=2/16. The observed A_B_ phenotype occurs 9/16 of the time, so P(AABb|A_B_)=2/9.' from version_ins
union all select gen_random_uuid(), id, 'D', '1/9; this assumes that both dominant phenotypes force AA and BB.', false, 'A dominant phenotype does not uniquely identify a homozygous dominant genotype.' from version_ins;
-- apbio-mcq-b3-h-5.3-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-h-5.3-b', 'mcq', 'testcross chi-square decision', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 30, 20, 27, 23 (total 100). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?', null, md5('apbio-mcq-b3-h-5.3-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'χ²=7.815 by definition; the data prove that the genes assort independently.', false, 'The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model.' from version_ins
union all select gen_random_uuid(), id, 'B', 'χ²=2.32, below 7.815; fail to reject the 1:1:1:1 null model.', true, 'Correct: Expected count per class is 100/4=25. Sum (observed−25)²/25 over the four classes to get χ²=2.32. This is below the given 3-df critical value 7.815, so fail to reject the equal-classes null model; this test does not prove a particular biological cause.' from version_ins
union all select gen_random_uuid(), id, 'C', 'χ²=2.32, below 7.815; reject the 1:1:1:1 null model.', false, 'The numerical statistic is correct, but the decision direction is reversed relative to the critical value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The four observed counts must be exactly equal or Mendel’s segregation law is disproved.', false, 'Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-b-v1', 'mcq', 'testcross chi-square decision (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 40, 10, 30, 20 (total 100). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?', null, md5('apbio-mcq-b3-sv-h-5.3-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'χ²=20.0, above 7.815; reject the 1:1:1:1 null model.', true, 'Correct: Expected count per class is 100/4=25. Sum (observed−25)²/25 over the four classes to get χ²=20.0. This is above the given 3-df critical value 7.815, so reject the equal-classes null model; this test does not prove a particular biological cause.' from version_ins
union all select gen_random_uuid(), id, 'B', 'χ²=7.815 by definition; the data prove that the genes assort independently.', false, 'The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model.' from version_ins
union all select gen_random_uuid(), id, 'C', 'χ²=20.0, above 7.815; fail to reject the 1:1:1:1 null model.', false, 'The numerical statistic is correct, but the decision direction is reversed relative to the critical value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The four observed counts must be exactly equal or Mendel’s segregation law is disproved.', false, 'Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-b-v2', 'mcq', 'testcross chi-square decision (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 24, 16, 22, 18 (total 80). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?', null, md5('apbio-mcq-b3-sv-h-5.3-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'χ²=7.815 by definition; the data prove that the genes assort independently.', false, 'The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model.' from version_ins
union all select gen_random_uuid(), id, 'B', 'χ²=2.00, below 7.815; fail to reject the 1:1:1:1 null model.', true, 'Correct: Expected count per class is 80/4=20. Sum (observed−20)²/20 over the four classes to get χ²=2.00. This is below the given 3-df critical value 7.815, so fail to reject the equal-classes null model; this test does not prove a particular biological cause.' from version_ins
union all select gen_random_uuid(), id, 'C', 'χ²=2.00, below 7.815; reject the 1:1:1:1 null model.', false, 'The numerical statistic is correct, but the decision direction is reversed relative to the critical value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The four observed counts must be exactly equal or Mendel’s segregation law is disproved.', false, 'Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.' from version_ins;
-- apbio-mcq-b3-sv-h-5.3-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-sv-h-5.3-b-v3', 'mcq', 'testcross chi-square decision (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A dihybrid testcross for two genes on different chromosomes predicts four equally frequent phenotypes. Observed counts are 36, 4, 30, 10 (total 80). At α=0.05, the chi-square critical value with 3 degrees of freedom is 7.815. Which calculation and conclusion are justified?', null, md5('apbio-mcq-b3-sv-h-5.3-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'χ²=35.6, above 7.815; reject the 1:1:1:1 null model.', true, 'Correct: Expected count per class is 80/4=20. Sum (observed−20)²/20 over the four classes to get χ²=35.6. This is above the given 3-df critical value 7.815, so reject the equal-classes null model; this test does not prove a particular biological cause.' from version_ins
union all select gen_random_uuid(), id, 'B', 'χ²=7.815 by definition; the data prove that the genes assort independently.', false, 'The critical value is a threshold, not a statistic computed from these observations; failure to reject cannot prove a model.' from version_ins
union all select gen_random_uuid(), id, 'C', 'χ²=35.6, above 7.815; fail to reject the 1:1:1:1 null model.', false, 'The numerical statistic is correct, but the decision direction is reversed relative to the critical value.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The four observed counts must be exactly equal or Mendel’s segregation law is disproved.', false, 'Sampling variation can create unequal observed counts even when the 1:1:1:1 model is true.' from version_ins;
-- apbio-mcq-b3-h-5.3-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b3-h-5.3-c', 'mcq', 'pedigree two-child probability', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'For a fully penetrant autosomal trait, two unaffected parents have an affected child. Assume no new mutation and independent outcomes for later births. What is the probability that, among their next two children, exactly one affected? Explain the parents’ inferred genotypes.', null, md5('apbio-mcq-b3-h-5.3-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '1/4; only one birth needs to be considered despite the question asking about two.', false, 'This uses a one-child probability or drops one of the possible two-child orders.' from version_ins
union all select gen_random_uuid(), id, 'B', '1/2; the affected child shows that one parent must be homozygous recessive.', false, 'The parents are unaffected, so neither can be aa under complete penetrance; both are Aa.' from version_ins
union all select gen_random_uuid(), id, 'C', '3/8; both parents must be heterozygous carriers (Aa × Aa), so each birth has a 1/4 affected chance.', true, 'Correct: Unaffected parents of an affected aa child must both carry a: Aa×Aa. Each later child independently has P(affected)=1/4 and P(unaffected)=3/4. For exactly one affected among two children, the binomial/complement calculation gives 3/8.' from version_ins
union all select gen_random_uuid(), id, 'D', '0; two unaffected parents cannot have a child with a recessive trait.', false, 'Recessive inheritance allows unaffected carriers to have affected offspring.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b3-h-5.3-a','apbio-mcq-b3-sv-h-5.3-a-v1','apbio-mcq-b3-sv-h-5.3-a-v2','apbio-mcq-b3-sv-h-5.3-a-v3','apbio-mcq-b3-h-5.3-b','apbio-mcq-b3-sv-h-5.3-b-v1','apbio-mcq-b3-sv-h-5.3-b-v2','apbio-mcq-b3-sv-h-5.3-b-v3','apbio-mcq-b3-h-5.3-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b3-h-5.3-a','apbio-mcq-b3-sv-h-5.3-a-v1','apbio-mcq-b3-sv-h-5.3-a-v2','apbio-mcq-b3-sv-h-5.3-a-v3','apbio-mcq-b3-h-5.3-b','apbio-mcq-b3-sv-h-5.3-b-v1','apbio-mcq-b3-sv-h-5.3-b-v2','apbio-mcq-b3-sv-h-5.3-b-v3','apbio-mcq-b3-h-5.3-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
