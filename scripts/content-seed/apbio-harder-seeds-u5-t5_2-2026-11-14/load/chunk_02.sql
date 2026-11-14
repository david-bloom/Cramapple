begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-5.2-c-v1','apbio-mcq-b2-sv-h-5.2-c-v2','apbio-mcq-b2-sv-h-5.2-c-v3'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apbio-mcq-b2-sv-h-5.2-c-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-c-v1', 'mcq', 'division-specific nondisjunction (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid cell normally makes gametes with n=6 chromosomes. Four gametes from one meiosis have chromosome counts 6, 6, 7, and 5. Assuming a single nondisjunction event, which division failed, and how does the pattern support the inference?', null, md5('apbio-mcq-b2-sv-h-5.2-c-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nondisjunction of homologous chromosomes in meiosis I; all four gametes should have abnormal counts.', false, 'Meiosis I nondisjunction produces no normal gametes from that meiosis, but two are observed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing over in prophase I; exchanging chromosome segments creates the count differences.', false, 'Crossing over changes genetic combinations without this n±1 chromosome-count pattern.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Normal independent assortment; random orientation of homologs creates the count differences.', false, 'Normal meiosis gives four n-chromosome gametes, not one high and one low count.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nondisjunction of sister chromatids in meiosis II; two gametes are normal and the others are n+1 and n−1.', true, 'Correct: Normal homolog separation in meiosis I creates two n-chromosome cells. If sister chromatids fail to separate in one meiosis II cell, its gametes are 7 and 5; the other cell produces two normal 6-chromosome gametes.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-c-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-c-v2', 'mcq', 'division-specific nondisjunction (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid cell normally makes gametes with n=8 chromosomes. Four gametes from one meiosis have chromosome counts 9, 9, 7, and 7. Assuming a single nondisjunction event, which division failed, and how does the pattern support the inference?', null, md5('apbio-mcq-b2-sv-h-5.2-c-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Nondisjunction of sister chromatids in meiosis II; two gametes should still have 8 chromosomes.', false, 'Meiosis II nondisjunction leaves two normal gametes, which are absent here.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Crossing over in prophase I; exchanging chromosome segments creates the count differences.', false, 'Crossing over changes allele combinations, not the number of chromosomes in each gamete.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Normal independent assortment; random orientation of homologs creates the count differences.', false, 'Normal meiosis gives four n-chromosome gametes, not the observed two high and two low counts.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Nondisjunction of one homologous pair in meiosis I; all four gametes are abnormal, two n+1 and two n−1.', true, 'Correct: Failure of homologs to separate in meiosis I puts both homologs in one daughter cell and neither in the other. Normal meiosis II then yields two 9-chromosome and two 7-chromosome gametes, matching all four observations.' from version_ins;
-- apbio-mcq-b2-sv-h-5.2-c-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b2-sv-h-5.2-c-v3', 'mcq', 'division-specific nondisjunction (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A diploid organism normally makes gametes with n=10 chromosomes. One abnormal meiosis produced gametes with 10, 10, 11, and 9 chromosomes. If each gamete separately fuses with a normal 10-chromosome gamete, which zygote chromosome counts result, and which division most likely had one nondisjunction event?', null, md5('apbio-mcq-b2-sv-h-5.2-c-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '20, 20, 21, and 19; a meiosis I homolog nondisjunction leaves two normal gametes.', false, 'The zygote counts are right, but meiosis I nondisjunction would make all four gametes abnormal.' from version_ins
union all select gen_random_uuid(), id, 'B', '10, 10, 11, and 9; fertilization does not change chromosome number.', false, 'The normal partner contributes 10 more chromosomes to each zygote.' from version_ins
union all select gen_random_uuid(), id, 'C', '20, 20, 21, and 19; a meiosis II sister-chromatid nondisjunction leaves two normal gametes and one n+1/n−1 pair.', true, 'Correct: Normal fertilization adds 10 chromosomes to each gamete, yielding 20, 20, 21, and 19. The two normal gametes and one high/low pair identify nondisjunction of sister chromatids in one meiosis II cell, not failure of homologs in meiosis I.' from version_ins
union all select gen_random_uuid(), id, 'D', '21, 21, 19, and 19; meiosis II nondisjunction makes all four gametes abnormal.', false, 'The two normal gametes rule out a single meiosis I nondisjunction and yield two normal 20-chromosome zygotes.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b2-sv-h-5.2-c-v1','apbio-mcq-b2-sv-h-5.2-c-v2','apbio-mcq-b2-sv-h-5.2-c-v3']) and status='draft')<>3 then raise exception 'chunk 2: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b2-sv-h-5.2-c-v1','apbio-mcq-b2-sv-h-5.2-c-v2','apbio-mcq-b2-sv-h-5.2-c-v3']))<>12 then raise exception 'chunk 2: expected 12 choices'; end if;
end $$;
commit;
