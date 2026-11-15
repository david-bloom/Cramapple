begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.6-b-v1','apbio-mcq-b4-sv-h-4.6-b-v2','apbio-mcq-b4-sv-h-4.6-b-v3'])) then raise exception 'chunk 6 already loaded'; end if;
end $$;
-- apbio-mcq-b4-sv-h-4.6-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.6-b-v1', 'mcq', 'link loss of a checkpoint protein to cell-cycle behavior using data (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The Rb protein binds the transcription factor E2F in G1 and prevents E2F from turning on S-phase genes. Growth factor signaling leads to phosphorylation of Rb, which releases E2F. A cell line has no functional Rb. The cells are grown without growth factor. Which result is predicted?', null, md5('apbio-mcq-b4-sv-h-4.6-b-v1'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'S-phase genes stay off until growth factor is added, because E2F also needs the growth factor.', false, 'In this pathway growth factor acts by phosphorylating Rb, and without Rb that step is not needed.' from version_ins
union all select gen_random_uuid(), id, 'B', 'S-phase genes are off in these cells, because Rb is needed to make E2F.', false, 'Rb binds E2F and does not make it, so losing Rb frees E2F and does not remove it.' from version_ins
union all select gen_random_uuid(), id, 'C', 'The cells arrest in G2, because Rb acts only at the G2 checkpoint.', false, 'The stem places Rb''s role at the control of S-phase genes in G1, and not at G2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'E2F is free and S-phase genes are expressed, so the cells can enter S phase without growth factor.', true, 'Correct: Rb normally holds E2F inactive; without Rb, E2F is released regardless of growth factor, so S-phase genes can be turned on and cells can pass the G1 checkpoint.' from version_ins;
-- apbio-mcq-b4-sv-h-4.6-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.6-b-v2', 'mcq', 'link loss of a checkpoint protein to cell-cycle behavior using data (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Normal fibroblasts (N) and tumor cells (T) are grown in culture. At low density they divide at the same rate. At high density, 95% of N cells are in G1 or G0 and stop dividing, but 30% of the T cells are still in S phase and the cells pile into layers. Adding 10 times more growth factor does not restart the N cells at high density. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.6-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'T cells divide faster than N cells at all densities.', false, 'The stem states that the rates are the same at low density.' from version_ins
union all select gen_random_uuid(), id, 'B', 'N cells stop at high density because they ran out of growth factor.', false, 'Adding 10 times more growth factor did not restart the N cells, so lack of growth factor is not the cause.' from version_ins
union all select gen_random_uuid(), id, 'C', 'T cells at high density are in G0, which lets them pile up.', false, '30% of the T cells are in S phase, so they are cycling and are not in G0.' from version_ins
union all select gen_random_uuid(), id, 'D', 'T cells do not respond to the signals that normally stop the cycle at high density, while N cells do.', true, 'Correct: the two lines act the same at low density but differ at high density, so T cells have lost response to the stop signals; the extra growth factor shows N cells did not stop for lack of it.' from version_ins;
-- apbio-mcq-b4-sv-h-4.6-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b4-sv-h-4.6-b-v3', 'mcq', 'link loss of a checkpoint protein to cell-cycle behavior using data (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A drug that prevents spindle formation is added to cells. In normal cells, 85% stop with condensed chromosomes and no anaphase. In cells that lack Mad2, a spindle checkpoint protein, most cells leave mitosis within 1.5 hours with unaligned chromosomes and produce daughter cells with abnormal chromosome numbers. Which conclusion is best supported?', null, md5('apbio-mcq-b4-sv-h-4.6-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mad2 is needed to condense chromosomes, because the cells lacking it have abnormal chromosome numbers.', false, 'Chromosomes condense in both groups, and the problem is how they are divided.' from version_ins
union all select gen_random_uuid(), id, 'B', 'The spindle checkpoint normally delays anaphase until the chromosomes are attached to the spindle, so cells without Mad2 divide with misaligned chromosomes.', true, 'Correct: normal cells wait before anaphase when the spindle is missing; cells lacking Mad2 do not wait and divide anyway, producing cells with the wrong number of chromosomes.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mad2 is needed to build the spindle, because the drug blocks spindle formation in the cells lacking Mad2.', false, 'The drug prevents spindle formation in both groups, so the missing spindle comes from the drug and not from the loss of Mad2.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mad2 drives cells through anaphase, because cells without Mad2 leave mitosis more slowly.', false, 'Cells lacking Mad2 leave mitosis sooner, within 1.5 hours, and not more slowly.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b4-sv-h-4.6-b-v1','apbio-mcq-b4-sv-h-4.6-b-v2','apbio-mcq-b4-sv-h-4.6-b-v3']) and status='draft')<>3 then raise exception 'chunk 6: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b4-sv-h-4.6-b-v1','apbio-mcq-b4-sv-h-4.6-b-v2','apbio-mcq-b4-sv-h-4.6-b-v3']))<>12 then raise exception 'chunk 6: expected 12 choices'; end if;
end $$;
commit;
