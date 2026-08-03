-- Assign Gulgeldi Darrynow a 20-question AP Chemistry comparison packet.
--
-- Every version was previously reviewed and submitted by Muhammad Zeeshan.
-- The packet contains 16 MCQs and 4 FRQs, covers all four difficulty bands,
-- and includes examples of Zeeshan's approve, approve-with-edits, and
-- disapprove outcomes. Zeeshan's assignments and decisions are not modified.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-gulgeldi-ap-chemistry-20-comparison-20260729')
);

create temporary table packet_versions (
  content_item_id uuid primary key,
  content_item_version_id uuid unique not null,
  content_key text unique not null,
  item_type text not null,
  difficulty text not null
) on commit drop;

insert into packet_versions (
  content_item_id,
  content_item_version_id,
  content_key,
  item_type,
  difficulty
)
values
  -- Four FRQs, one from each difficulty band.
  ('51d3c624-9c4d-4a4c-a9d0-beb2687595a7', 'd8d7751b-fd46-4dc8-b468-13549dcc9a7e', 'apchem-frq-l-001', 'frq', 'Easy'),
  ('ab93560b-7ca0-47bd-a3eb-472ed128b334', '1859edc2-7dcf-488c-bd3a-827ebd0fac1f', 'apchem-sfrq-024', 'frq', 'Medium'),
  ('140127b4-5225-4186-add7-af57b0cf136f', 'c88b50a9-8398-4199-9d20-5b5d9ea7313d', 'apchem-sfrq-005', 'frq', 'Hard'),
  ('797a4515-b9eb-49bc-9a26-dec105f8b04d', 'eb3bcc60-27cc-4272-8e62-f14fc274c462', 'apchem-sfrq-010', 'frq', 'Very Hard'),

  -- Sixteen MCQs.
  ('618a74d7-c784-422d-9973-478ed1a3539c', 'ef24ffeb-aac0-4f6e-bcf2-981d491660c3', 'apchem-mcq-001', 'mcq', 'Easy'),
  ('14e5cb25-7d02-42a9-856a-79cb777b31e1', '23f03c83-ccd9-427f-ad6d-c28ff48eff93', 'apchem-mcq-002', 'mcq', 'Easy'),
  ('1f23293a-2e3d-4d80-bc30-ae7430de5f69', '3dfce0f0-e9db-4329-a644-b99f80eb0741', 'apchem-mcq-003', 'mcq', 'Easy'),
  ('90ab901e-2cae-454c-92e7-2e70736c98a0', '7ccab975-237f-416e-94d5-849d5c7e99e2', 'apchem-mcq-005', 'mcq', 'Easy'),
  ('b4b288d8-0c4b-4e61-8810-b69e23a2da4d', 'e611231b-bc1f-4db3-a5e3-8c7c63cf0b45', 'apchem-mcq-006', 'mcq', 'Medium'),
  ('bfc233c8-149d-4a2b-b0d0-1728aeb3a5d0', 'f387a58e-b963-4c64-94c2-e8e3201a918a', 'apchem-mcq-007', 'mcq', 'Medium'),
  ('c654cab9-2e7b-4d46-8657-5caa1d5efbe0', '43d5558c-744d-41ca-9e83-eedf6e6d1add', 'apchem-mcq-008', 'mcq', 'Medium'),
  ('fc1665c7-e799-48ac-b87f-715ac2528508', 'c5b49ad8-9764-4ded-b73b-f6bbf8d612a0', 'apchem-mcq-009', 'mcq', 'Medium'),
  ('8fc6b3f8-986e-4505-9753-3f855e7a30c2', 'd99a02b1-d931-4bfb-babe-69bcd837c5fd', 'apchem-mcq-010', 'mcq', 'Medium'),
  ('d0b7ce87-4c87-4b9a-985e-7f184af91078', '8ec51ec4-8fb5-4faf-a956-379b95452e89', 'apchem-mcq-011', 'mcq', 'Medium'),
  ('2138f053-3974-4645-b6aa-41a837e5d58f', 'dd2bfd72-20d3-471b-b40b-c8efd19536eb', 'apchem-mcq-014', 'mcq', 'Hard'),
  ('36c027bb-fc2c-4ae2-8fb3-927bc11f30cd', 'e47eb90a-bc6a-4f7e-a10c-3b7b4a66a9ef', 'apchem-mcq-015', 'mcq', 'Hard'),
  ('681dfe5d-ff4d-4e1e-8ecc-aad47575ab23', '1c65cbef-2352-4274-b12e-05f781c3a9e7', 'apchem-mcq-016', 'mcq', 'Hard'),
  ('8feea5f3-5cbc-4e40-97f0-e06841ba35d6', '929ceb4a-04ba-4b56-9378-d31a9edd4677', 'apchem-mcq-017', 'mcq', 'Hard'),
  ('6c029045-e649-4514-9c52-aa20ae11e0b8', 'f9c6c0a5-0c48-4711-b019-cbeb5262ab32', 'apchem-mcq-019', 'mcq', 'Very Hard'),
  ('acd1c13a-8fe4-4cbc-acbe-e6d350fbfe7b', 'd0dd07a3-dca9-44ef-b113-5cba234a6332', 'apchem-mcq-020', 'mcq', 'Very Hard');

do $$
declare
  v_total integer;
  v_mcq integer;
  v_frq integer;
  v_easy integer;
  v_medium integer;
  v_hard integer;
  v_very_hard integer;
  v_invalid integer;
  v_zeeshan_reviewed integer;
  v_score_1 integer;
  v_score_2 integer;
  v_score_3 integer;
  v_gulgeldi_existing integer;
  v_qualified boolean;
begin
  select
    count(*),
    count(*) filter (where item_type = 'mcq'),
    count(*) filter (where item_type = 'frq'),
    count(*) filter (where difficulty = 'Easy'),
    count(*) filter (where difficulty = 'Medium'),
    count(*) filter (where difficulty = 'Hard'),
    count(*) filter (where difficulty = 'Very Hard')
  into
    v_total, v_mcq, v_frq,
    v_easy, v_medium, v_hard, v_very_hard
  from packet_versions;

  if (v_total, v_mcq, v_frq, v_easy, v_medium, v_hard, v_very_hard)
     <> (20, 16, 4, 5, 7, 5, 3) then
    raise exception
      'Chemistry packet distribution changed: total %, MCQ %, FRQ %, difficulty %/%/%/%',
      v_total, v_mcq, v_frq, v_easy, v_medium, v_hard, v_very_hard;
  end if;

  select count(*)
  into v_invalid
  from packet_versions pv
  left join app.content_items ci
    on ci.id = pv.content_item_id
  left join app.content_item_versions civ
    on civ.id = pv.content_item_version_id
   and civ.content_item_id = ci.id
  left join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  where ci.id is null
     or civ.id is null
     or ci.content_key <> pv.content_key
     or ci.item_type <> pv.item_type
     or civ.prompt_json->>'difficulty' <> pv.difficulty
     or epv.exam_pack_id <> 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid;

  if v_invalid <> 0 then
    raise exception
      'Chemistry packet contains % missing or metadata-mismatched versions',
      v_invalid;
  end if;

  select
    count(*),
    count(*) filter (where d.tutor_score = 1),
    count(*) filter (where d.tutor_score = 2),
    count(*) filter (where d.tutor_score = 3)
  into v_zeeshan_reviewed, v_score_1, v_score_2, v_score_3
  from packet_versions pv
  join app.content_review_decisions d
    on d.content_item_version_id = pv.content_item_version_id
   and d.reviewer_id = '806b0a0e-8431-4aa5-ad71-b803a1792145'::uuid
   and d.review_stage = 'tutor_question';

  if v_zeeshan_reviewed <> 20
     or v_score_1 = 0
     or v_score_2 = 0
     or v_score_3 = 0 then
    raise exception
      'Comparison invariant failed: Zeeshan reviews %, score distribution %/%/%',
      v_zeeshan_reviewed, v_score_1, v_score_2, v_score_3;
  end if;

  select count(*)
  into v_gulgeldi_existing
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
   and a.review_stage = 'tutor_question';

  if v_gulgeldi_existing <> 0 then
    raise exception
      'Gulgeldi already has % assignments from the intended packet',
      v_gulgeldi_existing;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id =
      '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
      and vq.status = 'active'
      and 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid = any(vq.exam_ids)
      and vq.effective_at <= now()
      and vq.expires_at > now()
  )
  into v_qualified;

  if not v_qualified then
    raise exception 'Gulgeldi Darrynow does not have an active AP Chemistry qualification';
  end if;
end
$$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  assignment_purpose,
  created_by
)
select
  pv.content_item_version_id,
  '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid,
  'tutor_question',
  pv.item_type,
  'pending',
  'subject_review',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv;

insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status,
  created_by
)
values (
  'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid,
  'gulgeldi-ap-chemistry-20-comparison-2026-07-29',
  'Gulgeldi AP Chemistry 20-question review',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id,
  content_label_id,
  created_by
)
select
  a.content_review_assignment_id,
  l.id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from packet_versions pv
join app.content_review_assignments a
  on a.content_item_version_id = pv.content_item_version_id
 and a.reviewer_id = '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
 and a.review_stage = 'tutor_question'
join app.content_labels l
  on l.exam_pack_id = 'bfb1b3d3-21b4-49c5-b2f6-6b5b6ed16afe'::uuid
 and l.label_key = 'gulgeldi-ap-chemistry-20-comparison-2026-07-29';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_labeled integer;
  v_overlap integer;
begin
  select
    count(*),
    count(*) filter (where a.status = 'pending')
  into v_assignments, v_pending
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
   and a.review_stage = 'tutor_question'
   and a.review_kind = pv.item_type
   and a.assignment_purpose = 'subject_review';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '119817d1-96c9-4cbc-8fdc-4962e03b1b12'::uuid
   and a.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = a.content_review_assignment_id
  join app.content_labels l
    on l.id = al.content_label_id
   and l.label_key =
     'gulgeldi-ap-chemistry-20-comparison-2026-07-29';

  select count(*)
  into v_overlap
  from packet_versions pv
  where exists (
    select 1
    from app.content_review_decisions d
    where d.content_item_version_id = pv.content_item_version_id
      and d.reviewer_id =
        '806b0a0e-8431-4aa5-ad71-b803a1792145'::uuid
      and d.review_stage = 'tutor_question'
  );

  if (v_assignments, v_pending, v_labeled, v_overlap)
     <> (20, 20, 20, 20) then
    raise exception
      'Chemistry comparison reconciliation failed: assignments %, pending %, labeled %, Zeeshan overlap %',
      v_assignments, v_pending, v_labeled, v_overlap;
  end if;
end
$$;

commit;
