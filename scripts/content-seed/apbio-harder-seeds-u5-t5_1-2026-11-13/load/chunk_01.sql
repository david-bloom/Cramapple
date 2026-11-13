begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b1-h-5.1-a','apbio-mcq-b1-sv-h-5.1-a-v1','apbio-mcq-b1-sv-h-5.1-a-v2','apbio-mcq-b1-sv-h-5.1-a-v3','apbio-mcq-b1-h-5.1-b','apbio-mcq-b1-sv-h-5.1-b-v1','apbio-mcq-b1-sv-h-5.1-b-v2','apbio-mcq-b1-sv-h-5.1-b-v3','apbio-mcq-b1-h-5.1-c'])) then raise exception 'chunk 1 already loaded'; end if;
end $$;
-- apbio-mcq-b1-h-5.1-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-h-5.1-a', 'mcq', 'infer meiotic phase and consequence from chromosome behavior', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid cell has completed DNA replication. In a micrograph, homologous chromosomes are paired at the cell equator, and the two sister chromatids of each chromosome remain attached. If the spindle pulls each homolog toward a different pole, which event and immediate outcome are shown?', null, md5('apbio-mcq-b1-h-5.1-a'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Metaphase II followed by separation of sister chromatids; each resulting cell has both homologs.', false, 'Meiosis II begins with no homologous pairs in one cell; sisters separate there, not paired homologs.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Metaphase I followed by separation of homologs; each resulting cell has one replicated chromosome from each pair.', true, 'Correct: Paired homologs at one plate identify meiosis I. Anaphase I moves homologs, not sisters, yielding two haploid cells whose chromosomes remain replicated.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mitosis followed by separation of homologs; each resulting cell has half the original chromosome number.', false, 'Mitosis separates sister chromatids and maintains chromosome number per daughter cell.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Anaphase II followed by separation of homologs; each resulting cell has two chromatids from every pair.', false, 'Anaphase II separates sisters after homologs were divided in meiosis I; it does not retain two chromatids per resulting chromosome.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-a-v1', 'mcq', 'infer meiotic phase and consequence from chromosome behavior (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher marks the centromere of each sister chromatid in one diploid cell. After the first cytokinesis, two cells contain one homolog from each original pair, but each chromosome still consists of two attached chromatids. Which next step directly creates four cells with one chromatid per chromosome?', null, md5('apbio-mcq-b1-sv-h-5.1-a-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Pairing of homologs during prophase I, followed by the first cytokinesis.', false, 'Homolog pairing precedes the first division and cannot convert the observed two cells into four cells with single chromatids.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Separation of homologs during anaphase I, followed by the second cytokinesis.', false, 'Homologs have already separated; repeating that step would not split attached sister chromatids.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Another round of DNA replication, followed by chromosome separation in mitosis.', false, 'Meiosis II has no intervening DNA replication; replication would add rather than remove attached chromatids.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Separation of sister chromatids during anaphase II, followed by the second cytokinesis.', true, 'Correct: The observed two cells are after meiosis I. Meiosis II separates attached sisters and the second cytokinesis yields four haploid cells.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-a-v2', 'mcq', 'infer meiotic phase and consequence from chromosome behavior (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a cell from a sexually reproducing diploid organism, spindle fibers pull the two sister chromatids of each chromosome toward opposite poles. The cell already contains only one member of each homologous pair. Which interpretation fits both observations?', null, md5('apbio-mcq-b1-sv-h-5.1-a-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cell is in anaphase II; homologs separated in the previous division and sister chromatids are now separating.', true, 'Correct: One homolog per pair indicates the reductional division has occurred; active sister separation is anaphase II.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The cell is in anaphase I; homologous pairs are being pulled apart for the first time.', false, 'Anaphase I moves homologs while sister centromeres remain attached.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cell is in metaphase I; homologous pairs are aligned but no chromosomes are moving.', false, 'Metaphase I aligns paired homologs in a diploid cell and does not pull sisters apart.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The cell is in mitosis; its two daughters will necessarily be diploid like the original parent cell.', false, 'Mitosis also separates sisters, but this cell is already haploid after the first meiotic division, so diploid daughters do not follow.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-a-v3', 'mcq', 'infer meiotic phase and consequence from chromosome behavior (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Four nuclei form after a diploid germ cell divides twice, with DNA replicated only before the first division. In the first division, sister chromatids stay together while homologs separate. Which description of the second division is consistent with the final four nuclei?', null, md5('apbio-mcq-b1-sv-h-5.1-a-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The original diploid cell separates homologs again, producing four diploid nuclei with replicated chromosomes.', false, 'Homolog separation has already occurred and the original cell no longer exists after the first division.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Each haploid cell replicates DNA again and then separates homologous pairs, producing four diploid nuclei.', false, 'No replication occurs between meiotic divisions, and each haploid cell has only one homolog per pair.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Each of the two haploid cells separates sister chromatids, producing four haploid nuclei with unduplicated chromosomes.', true, 'Correct: Meiosis I reduces homolog number in each cell; without another replication, meiosis II separates sisters and produces four haploid nuclei.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The two haploid cells fuse before separating sister chromatids, producing four genetically identical diploid nuclei.', false, 'Fusion would restore diploidy and is not part of the second meiotic division.' from version_ins;
-- apbio-mcq-b1-h-5.1-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-h-5.1-b', 'mcq', 'track chromosome and chromatid counts across divisions', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A germ cell has 2n=6 chromosomes. DNA replicates once before meiosis, and no chromosomes are lost. Immediately after meiosis I, what does each of the two cells contain, and what will each contain after meiosis II? Count a chromosome by its centromere.', null, md5('apbio-mcq-b1-h-5.1-b'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'After meiosis I: 6 chromosomes and 6 chromatids; after meiosis II: 3 chromosomes and 3 chromatids.', false, 'This counts both post-I cells together rather than each one; one post-I cell has only three centromeres.' from version_ins
union all select gen_random_uuid(), id, 'B', 'After meiosis I: 3 chromosomes and 6 chromatids; after meiosis II: 3 chromosomes and 3 chromatids.', true, 'Correct: Homolog separation halves chromosome number from 6 to 3 but keeps sisters joined (6 chromatids). Sister separation yields 3 unduplicated chromosomes per gamete.' from version_ins
union all select gen_random_uuid(), id, 'C', 'After meiosis I: 3 chromosomes and 3 chromatids; after meiosis II: 3 chromosomes and 6 chromatids.', false, 'Meiosis I does not separate sisters, and meiosis II does not replicate DNA.' from version_ins
union all select gen_random_uuid(), id, 'D', 'After meiosis I: 6 chromosomes and 12 chromatids; after meiosis II: 6 chromosomes and 6 chromatids.', false, 'This retains the diploid chromosome number in every product despite homolog separation.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-b-v1', 'mcq', 'track chromosome and chromatid counts across divisions (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid organism has 2n=8. A student counts chromosomes by centromeres and measures DNA as chromatids. Compare one cell at metaphase I with one cell at metaphase II, assuming normal separation and no additional replication. Which pair of counts is expected?', null, md5('apbio-mcq-b1-sv-h-5.1-b-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Metaphase I: 8 chromosomes, 16 chromatids; metaphase II: 4 chromosomes, 8 chromatids.', true, 'Correct: Replication doubles chromatids, not centromeres. Meiosis I halves centromeres per cell but leaves each chromosome duplicated.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Metaphase I: 16 chromosomes, 16 chromatids; metaphase II: 8 chromosomes, 8 chromatids.', false, 'This treats each chromatid as a chromosome at metaphase I and fails to account for attached sisters at metaphase II.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Metaphase I: 8 chromosomes, 8 chromatids; metaphase II: 4 chromosomes, 4 chromatids.', false, 'Both metaphase stages occur before sister separation, so each chromosome has two chromatids.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Metaphase I: 8 chromosomes, 16 chromatids; metaphase II: 8 chromosomes, 16 chromatids.', false, 'The first division separates homologs; a metaphase-II cell is haploid, with four chromosomes rather than eight.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-b-v2', 'mcq', 'track chromosome and chromatid counts across divisions (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid cell with 2n=10 enters meiosis after DNA replication. A technician counts five chromosomes per cell immediately after the first division. If the second division proceeds normally, which count and cell number should the technician record at the end?', null, md5('apbio-mcq-b1-sv-h-5.1-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Four cells, each with ten chromosomes containing one chromatid each.', false, 'Meiosis II does not restore the original diploid chromosome count per cell.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Four cells, each with five chromosomes containing one chromatid each.', true, 'Correct: Meiosis I produces two haploid cells with five duplicated chromosomes each; meiosis II separates sisters, making four cells with five unduplicated chromosomes each.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two cells, each with five chromosomes containing two chromatids each.', false, 'This describes the state after meiosis I, not the end of meiosis II.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Four cells, each with five chromosomes containing two chromatids each.', false, 'Sister chromatids separate during meiosis II, so the final chromosomes each have one chromatid.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-b-v3', 'mcq', 'track chromosome and chromatid counts across divisions (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid plant has 2n=12. A premeiotic cell has completed S phase. Its four final meiotic products are analyzed separately. Assuming normal meiosis, which change in chromosome and chromatid count occurs from the premeiotic cell to any one final product?', null, md5('apbio-mcq-b1-sv-h-5.1-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'From 12 chromosomes/24 chromatids to 6 chromosomes/6 chromatids.', true, 'Correct: S phase duplicates chromatids without changing 12 centromeres; meiosis I halves homolog count, and meiosis II separates sisters, leaving six single-chromatid chromosomes.' from version_ins
union all select gen_random_uuid(), id, 'B', 'From 24 chromosomes/24 chromatids to 12 chromosomes/12 chromatids.', false, 'A replicated chromatid is not a separate chromosome while sisters share a centromere; each gamete is haploid.' from version_ins
union all select gen_random_uuid(), id, 'C', 'From 12 chromosomes/12 chromatids to 6 chromosomes/12 chromatids.', false, 'The premeiotic cell has already undergone S phase, and final gametes have separated sister chromatids.' from version_ins
union all select gen_random_uuid(), id, 'D', 'From 12 chromosomes/24 chromatids to 12 chromosomes/12 chromatids.', false, 'Final meiotic products have half the original chromosome count, not the diploid count.' from version_ins;
-- apbio-mcq-b1-h-5.1-c
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-h-5.1-c', 'mcq', 'compare mitosis and meiosis using observed products', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid cell line is filmed through division. In trial X, paired homologs align at one plate; after two divisions there are four haploid cells. In trial Y, individual duplicated chromosomes align; after one division there are two diploid cells. Which inference best explains the difference?', null, md5('apbio-mcq-b1-h-5.1-c'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'X is mitosis because homolog pairing yields identical daughters; Y is meiosis because one division makes diploid gametes.', false, 'Homolog pairing is characteristic of meiosis I, and mitosis does not make four haploid products.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Both are meiosis because every division uses a spindle; the number of products depends only on cell size.', false, 'Both use spindles, but spindle use alone does not explain reductional versus equational outcomes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'X is meiosis because homologs segregate before sisters; Y is mitosis because sisters segregate in one division without reducing ploidy.', true, 'Correct: Paired homolog alignment and reduction plus a second division diagnose meiosis; one sister-separation division preserving ploidy diagnoses mitosis.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Both are mitosis because chromosomes align at a plate in each trial.', false, 'Alignment occurs in both processes, but homolog pairing and product ploidy distinguish them.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b1-h-5.1-a','apbio-mcq-b1-sv-h-5.1-a-v1','apbio-mcq-b1-sv-h-5.1-a-v2','apbio-mcq-b1-sv-h-5.1-a-v3','apbio-mcq-b1-h-5.1-b','apbio-mcq-b1-sv-h-5.1-b-v1','apbio-mcq-b1-sv-h-5.1-b-v2','apbio-mcq-b1-sv-h-5.1-b-v3','apbio-mcq-b1-h-5.1-c']) and status='draft')<>9 then raise exception 'chunk 1: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b1-h-5.1-a','apbio-mcq-b1-sv-h-5.1-a-v1','apbio-mcq-b1-sv-h-5.1-a-v2','apbio-mcq-b1-sv-h-5.1-a-v3','apbio-mcq-b1-h-5.1-b','apbio-mcq-b1-sv-h-5.1-b-v1','apbio-mcq-b1-sv-h-5.1-b-v2','apbio-mcq-b1-sv-h-5.1-b-v3','apbio-mcq-b1-h-5.1-c']))<>36 then raise exception 'chunk 1: expected 36 choices'; end if;
end $$;
commit;
