-- Assign a balanced packet of 20 existing draft AP Statistics FRQs to Jill.
--
-- The packet is pinned to exact content/version IDs so reruns are stable.
-- It spans all nine modules, with 4 easy, 6 medium, 6 hard, and 4 very-hard
-- items; 8 are long-form and 12 are short-form. No new content is created.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-jill-statistics-20-frq-packet-20260728')
);

create temporary table packet_versions (
  content_item_id uuid primary key,
  content_item_version_id uuid unique not null,
  content_key text unique not null,
  module integer not null,
  difficulty text not null,
  form text not null
) on commit drop;

insert into packet_versions (
  content_item_id,
  content_item_version_id,
  content_key,
  module,
  difficulty,
  form
)
values
  ('43780d98-4cea-432e-86d7-182baf4d422c', '969da4c3-4033-41c4-9e5b-6c0f1bd8d2e9', 'STATS-MOD1-E002',       1, 'easy',      'short'),
  ('2d8d4d3d-1af7-4f45-b32e-93e8c9f03ce0', '51ce37e5-a082-4d9a-a4e4-99ffcfa2cfb1', 'STATS-MOD1-E003',       1, 'easy',      'short'),
  ('d2affbe0-2481-4f00-8054-d42ff6398b27', 'b2f2de47-2c10-4b83-bf97-89cdfd695e18', 'STATS-MOD1-M001',       1, 'medium',    'short'),
  ('d2ac22b2-f075-41df-a05d-897aa44f436b', 'd6ba3ec9-ea9c-40ba-8a32-d6ffc434eef6', 'APSTAT-MOD3-H001-INV',  2, 'hard',      'long'),
  ('3a187fa6-d745-463a-be2b-49579aa87a84', '882d7377-1634-46a9-88c8-a46680c837db', 'APSTAT-MOD3-E002',      3, 'easy',      'short'),
  ('07edc710-16bb-4c09-b7d2-789cdc5a9926', '299d0b85-df9c-4c8b-9167-16bc9e6ffc76', 'STATS-MOD3-M007',       3, 'medium',    'short'),
  ('e053bb22-4805-44ab-9003-36b2e93987ab', '6b9658e9-13f6-4a34-a915-da53e6f48631', 'APSTAT-MOD4-H001-INV',  3, 'hard',      'long'),
  ('af82b114-64dc-4161-a900-4e6de29ab303', 'f112c2b6-7101-4fb9-bee4-94d2c90ef8c4', 'STATS-MOD4-E005',       4, 'easy',      'short'),
  ('40c0226d-ff9d-4927-8c72-75b1cdbc2dd2', 'd3e72356-38fa-4cc7-aab9-1ee19f635e20', 'APSTAT-MOD4-M001',      4, 'medium',    'short'),
  ('c620d7d3-1a93-49ac-8d81-654c7767125f', 'b0d3059b-0072-44d5-8543-eb16cc79a17b', 'APSTAT-MOD5-H001-INV',  4, 'hard',      'long'),
  ('6a376f40-6f50-42b9-b478-27f91cd92aa1', 'acf20fc2-bc25-42e9-9068-fea69c26c89c', 'APSTAT-MOD5-M001',      5, 'medium',    'short'),
  ('a067f214-64d3-48f4-b267-c41ce5fc5e5d', 'c93a7c33-587b-48dc-9aaf-929e9e3cccc0', 'APSTAT-MOD6-H002-INV',  5, 'hard',      'long'),
  ('5808c609-bc29-476a-a404-afa15124ebf3', '0d1808ac-8b62-472d-abcb-1d7edd5184ab', 'APSTAT-MOD6-M002',      6, 'medium',    'short'),
  ('d070712f-9e57-4a0b-8af1-ef22b932dd3d', 'bf471ada-e35b-4d63-b27d-d9aba40722ca', 'APSTAT-MOD6-H001',      6, 'hard',      'long'),
  ('858bd0a0-8cc0-4190-8851-b7a72cc48fd7', '0a04a0da-aaa6-4d91-9e09-f32513874482', 'APSTAT-MOD7-M001',      7, 'medium',    'short'),
  ('3f20d449-1279-4637-90ef-8477e31fd2fb', '22037762-19b8-449e-bb66-d81c459f0da5', 'APSTAT-MOD7-H001',      7, 'hard',      'long'),
  ('81398adf-90eb-497f-84e0-f72dee95f744', '3a28acdf-56b7-47a1-9f68-df33ff08e480', 'APSTAT-MOD8-H001',      8, 'very_hard', 'long'),
  ('9a362081-5e12-468f-a46a-5e985f6e37f9', 'a41d0427-cd87-4d42-8ff9-136aa8eb3def', 'APSTAT-MOD8-VH001',     8, 'very_hard', 'long'),
  ('12a2800a-74db-4309-a8b5-2fb022e258f9', '730795da-b4d2-4ef1-a2b6-183bd52da415', 'STATS-MOD9-VH001',      9, 'very_hard', 'short'),
  ('36f12e75-f731-4822-aaa2-e71b6b0332e4', 'c7a3c8b7-cfa4-4caa-9837-c0911068367b', 'STATS-MOD9-VH002',      9, 'very_hard', 'short');

do $$
declare
  v_total integer;
  v_modules integer;
  v_easy integer;
  v_medium integer;
  v_hard integer;
  v_very_hard integer;
  v_long integer;
  v_short integer;
  v_invalid integer;
  v_preassigned integer;
  v_qualified boolean;
begin
  select
    count(*),
    count(distinct module),
    count(*) filter (where difficulty = 'easy'),
    count(*) filter (where difficulty = 'medium'),
    count(*) filter (where difficulty = 'hard'),
    count(*) filter (where difficulty = 'very_hard'),
    count(*) filter (where form = 'long'),
    count(*) filter (where form = 'short')
  into
    v_total, v_modules, v_easy, v_medium, v_hard, v_very_hard, v_long, v_short
  from packet_versions;

  if (v_total, v_modules, v_easy, v_medium, v_hard, v_very_hard, v_long, v_short)
     <> (20, 9, 4, 6, 6, 4, 8, 12) then
    raise exception
      'Statistics packet distribution changed: total %, modules %, difficulty %/%/%/%, form %/%',
      v_total, v_modules, v_easy, v_medium, v_hard, v_very_hard, v_long, v_short;
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
  left join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.id is null
     or civ.id is null
     or ci.content_key <> pv.content_key
     or ci.item_type <> 'frq'
     or ci.status <> 'draft'
     or civ.status <> 'draft'
     or civ.prompt_json->>'module' <> pv.module::text
     or civ.prompt_json->>'difficulty' <> pv.difficulty
     or civ.prompt_json->>'form' <> pv.form
     or ep.exam_code <> 'ap_statistics';

  if v_invalid <> 0 then
    raise exception
      'Statistics packet contains % missing, changed, non-draft, or metadata-mismatched versions',
      v_invalid;
  end if;

  select count(*)
  into v_preassigned
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.review_stage = 'tutor_question';

  if v_preassigned <> 0 then
    raise exception
      'Statistics packet is no longer unassigned: found % existing tutor-question assignments',
      v_preassigned;
  end if;

  select exists (
    select 1
    from app.validator_qualifications vq
    where vq.reviewer_id =
      '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
      and vq.status = 'active'
      and 'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid = any(vq.exam_ids)
      and vq.effective_at <= now()
      and vq.expires_at > now()
  )
  into v_qualified;

  if not v_qualified then
    raise exception 'Jill does not have an active AP Statistics qualification';
  end if;
end
$$;

insert into app.content_review_assignments (
  content_item_version_id,
  reviewer_id,
  review_stage,
  review_kind,
  status,
  created_by
)
select
  pv.content_item_version_id,
  '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid,
  'tutor_question',
  'frq',
  'pending',
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
  'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid,
  'jill-statistics-20-frq-review-2026-07-28',
  'Jill Statistics 20-FRQ review',
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
 and a.reviewer_id = '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
 and a.review_stage = 'tutor_question'
join app.content_labels l
  on l.exam_pack_id = 'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid
 and l.label_key = 'jill-statistics-20-frq-review-2026-07-28';

do $$
declare
  v_assignments integer;
  v_pending integer;
  v_labeled integer;
  v_assigned_items integer;
  v_assigned_versions integer;
begin
  select
    count(*),
    count(*) filter (where a.status = 'pending')
  into v_assignments, v_pending
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
   and a.review_stage = 'tutor_question'
   and a.review_kind = 'frq';

  select count(*)
  into v_labeled
  from packet_versions pv
  join app.content_review_assignments a
    on a.content_item_version_id = pv.content_item_version_id
   and a.reviewer_id = '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
   and a.review_stage = 'tutor_question'
  join app.content_review_assignment_labels al
    on al.content_review_assignment_id = a.content_review_assignment_id
  join app.content_labels l
    on l.id = al.content_label_id
   and l.label_key = 'jill-statistics-20-frq-review-2026-07-28';

  select count(*)
  into v_assigned_items
  from packet_versions pv
  join app.content_items ci on ci.id = pv.content_item_id
  where ci.status = 'assigned';

  select count(*)
  into v_assigned_versions
  from packet_versions pv
  join app.content_item_versions civ on civ.id = pv.content_item_version_id
  where civ.status = 'assigned';

  if (v_assignments, v_pending, v_labeled, v_assigned_items, v_assigned_versions)
     <> (20, 20, 20, 20, 20) then
    raise exception
      'Statistics packet reconciliation failed: assignments %, pending %, labeled %, assigned items %, assigned versions %',
      v_assignments, v_pending, v_labeled, v_assigned_items, v_assigned_versions;
  end if;
end
$$;

commit;
