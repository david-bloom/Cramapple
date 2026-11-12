begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.7-b-v2','apbio-mcq-b6-sv-h-1.7-b-v3'])) then raise exception 'chunk 7 already loaded'; end if;
end $$;
-- apbio-mcq-b6-sv-h-1.7-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.7-b-v2', 'mcq', 'deduce the number and linkage of polypeptide subunits (quaternary structure) from gel data. (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A protein has a native mass of 90 kDa. A gel with detergent shows a single band at 90 kDa whether or not a reducing agent is added. Which conclusion is best supported?', null, md5('apbio-mcq-b6-sv-h-1.7-b-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Three 30 kDa chains linked by disulfide bonds.', false, 'Disulfide-linked chains would run at a smaller size after the reducing agent was added, and no change was seen.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Three 30 kDa chains held by noncovalent interactions.', false, 'Noncovalent subunits would separate in the detergent and give a smaller band.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Two polypeptides of 45 kDa held together by noncovalent interactions.', false, 'Two 45 kDa chains held noncovalently would give a 45 kDa band in the detergent.' from version_ins
union all select gen_random_uuid(), id, 'D', 'A single polypeptide of 90 kDa, with no quaternary structure.', true, 'Correct: The protein stays at its native mass under conditions that separate noncovalently or disulfide-linked chains, so it is one polypeptide.' from version_ins;
-- apbio-mcq-b6-sv-h-1.7-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', 'apbio-mcq-b6-sv-h-1.7-b-v3', 'mcq', 'deduce the number and linkage of polypeptide subunits (quaternary structure) from gel data. (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'An antibody has a native mass of 150 kDa. On a gel with detergent but no reducing agent it gives one band at 150 kDa. With a reducing agent, it gives two bands at 50 kDa and 25 kDa, and the 50 kDa band is twice as intense by mass as the 25 kDa band. Which structure is best supported?', null, md5('apbio-mcq-b6-sv-h-1.7-b-v3'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Four identical 37.5 kDa polypeptides joined by noncovalent interactions.', false, 'The bands observed are 50 and 25 kDa, not 37.5 kDa, and the 150 kDa band without reducer shows covalent linkage.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Two 50 kDa chains and two 25 kDa chains linked by disulfide bonds.', true, 'Correct: Without reducer the whole molecule stays together, so chains are covalently linked; the reducing agent releases 50 and 25 kDa chains, and 2 x 50 + 2 x 25 = 150 kDa.' from version_ins
union all select gen_random_uuid(), id, 'C', 'One 150 kDa polypeptide that breaks when the reducing agent is added.', false, 'A single polypeptide is not broken by a reducing agent, which cleaves disulfide bonds rather than peptide bonds.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Three polypeptides of 50 kDa each held together by noncovalent interactions.', false, 'Three 50 kDa chains would add to 150 kDa, but this ignores the 25 kDa band and a noncovalent assembly would separate in detergent.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and content_key = any (array['apbio-mcq-b6-sv-h-1.7-b-v2','apbio-mcq-b6-sv-h-1.7-b-v3']) and status='draft')<>2 then raise exception 'chunk 7: expected 2 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key = any (array['apbio-mcq-b6-sv-h-1.7-b-v2','apbio-mcq-b6-sv-h-1.7-b-v3']))<>8 then raise exception 'chunk 7: expected 8 choices'; end if;
end $$;
commit;
