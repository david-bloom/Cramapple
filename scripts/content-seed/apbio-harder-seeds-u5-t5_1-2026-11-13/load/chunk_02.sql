begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b1-sv-h-5.1-c-v1','apbio-mcq-b1-sv-h-5.1-c-v2','apbio-mcq-b1-sv-h-5.1-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b1-sv-h-5.1-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-c-v1', 'mcq', 'compare mitosis and meiosis using observed products (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A researcher disables a protein needed to keep sister centromeres joined through the first division of meiosis. In a normal control, homologs separate first and sisters separate in the second division. What observation would most directly reveal that the mutant failed to follow the normal meiotic sequence?', null, md5('apbio-mcq-b1-sv-h-5.1-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Homologous chromosomes pair during prophase I before they separate.', false, 'Homolog pairing is an expected normal event and does not reveal loss of sister cohesion.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Two haploid cells are present after the first cytokinesis, each with duplicated chromosomes.', false, 'Attached sisters after meiosis I indicate the protein''s role was maintained, not lost.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Four haploid cells are present after two divisions, each with unduplicated chromosomes.', false, 'Four unduplicated haploid products describe the normal endpoint and do not directly show premature sister separation.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Sister chromatids separate during the first division instead of remaining attached while homologs move apart.', true, 'Correct: The protein''s specified role is sister cohesion in meiosis I; losing it permits premature sister separation, violating the observed order.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-c-v2', 'mcq', 'compare mitosis and meiosis using observed products (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid parent cell makes two daughter cells in culture. Each daughter has the same number of chromosome sets as the parent and received one chromatid from each replicated chromosome. A separate germ cell makes four cells, each with one chromosome set. Which event explains the set-number difference?', null, md5('apbio-mcq-b1-sv-h-5.1-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'The cultured cell separated homologs in mitosis, whereas the germ cell separated sisters in meiosis I.', false, 'Mitosis segregates sisters; meiosis I segregates homologs, the reverse of this choice.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The germ cell replicated DNA between its two divisions, restoring two chromosome sets in each product.', false, 'No S phase occurs between meiosis I and II, and replication would not explain haploid products.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cultured cell paired homologs and crossed them over, while the germ cell skipped chromosome separation.', false, 'Meiotic products require chromosome separation; homolog pairing is associated with meiosis I, not ordinary mitosis.' from version_ins
union all select gen_random_uuid(), id, 'D', 'The germ cell separated homologous chromosomes in its first division, whereas the cultured cell separated sister chromatids in a single mitotic division.', true, 'Correct: Homolog segregation reduces chromosome sets in meiosis I; sister segregation alone in mitosis preserves the original set number.' from version_ins;
-- apbio-mcq-b1-sv-h-5.1-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b1-sv-h-5.1-c-v3', 'mcq', 'compare mitosis and meiosis using observed products (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A microscopy study compares two divisions of the same germ-cell lineage. After division 1, each cell has one homolog from every pair but its sister chromatids are still joined. After division 2, sister chromatids are separate. Why can division 2 occur without another S phase and still produce gametes?', null, md5('apbio-mcq-b1-sv-h-5.1-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Division 1 has already separated sister chromatids, so division 2 only replicates the homologs.', false, 'The observation explicitly says sisters remain joined after division 1; replication is not division 2''s role.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Each post-division-1 cell is diploid, so division 2 must remove an entire homolog pair from each cell.', false, 'One homolog per pair means the post-I cells are haploid, and meiosis II separates sisters rather than homolog pairs.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Each chromosome already has two chromatids after division 1, so division 2 partitions those sisters into haploid cells with unduplicated chromosomes.', true, 'Correct: Meiosis I leaves sisters attached in haploid cells. Meiosis II distributes existing chromatids; no new DNA synthesis is required.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Gametes are made by fusing the two cells from division 1 before division 2 begins.', false, 'Cell fusion would restore diploidy and is not part of meiosis II.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b1-sv-h-5.1-c-v1','apbio-mcq-b1-sv-h-5.1-c-v2','apbio-mcq-b1-sv-h-5.1-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b1-sv-h-5.1-c-v1','apbio-mcq-b1-sv-h-5.1-c-v2','apbio-mcq-b1-sv-h-5.1-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
