-- Create four "early-year" (Aug-Oct) packets, one per Physics subject, for
-- all not-yet-published MCQ/FRQ content in Units 1-3 (Physics 1 and C:
-- Mechanics) or the first three units as taught (Physics 2: 9-11; C: E&M:
-- 8-10), and assign the whole pool to Ghazanfar Ali.
--
-- Verified before writing: 0 of these 203 items already have 2 distinct
-- qualified-tutor 'approve' decisions, so all genuinely need an assignment.
-- David's prior 'withdrawn' rows and Muhammad Saood's prior 'submitted'
-- decisions on this content are left untouched -- this only ensures Ali
-- holds a live 'pending' assignment on every item (reopening his own 10
-- prior 'submitted' items on Physics 1 back to pending, same as his existing
-- 17 pending items there).

begin;

select pg_advisory_xact_lock(hashtext('cramapple-early-year-physics-ali-packets-20260803'));

create temporary table early_year_physics_targets (
  content_item_version_id uuid primary key,
  content_key text unique not null,
  item_type text not null,
  exam_code text not null,
  exam_pack_id uuid not null
) on commit drop;

insert into early_year_physics_targets (content_item_version_id, content_key, item_type, exam_code, exam_pack_id)
select civ.id, ci.content_key, ci.item_type, ep.exam_code, ep.id
from app.content_items ci
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.content_item_versions civ on civ.content_item_id = ci.id
where ep.exam_code in ('ap_physics_1','ap_physics_2','ap_physics_c_mechanics','ap_physics_c_em')
  and ci.status not in ('retired','published')
  and civ.version_num = (select max(v2.version_num) from app.content_item_versions v2 where v2.content_item_id = ci.id)
  and (
    (ep.exam_code = 'ap_physics_1' and (case
      when coalesce(civ.prompt_json->>'unit', (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1), nullif(civ.prompt_json->'modules'->>0,'AP Statistics')) ~ '^[0-9]+$'
        then (coalesce(civ.prompt_json->>'unit', (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1), nullif(civ.prompt_json->'modules'->>0,'AP Statistics')))::int
      when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^unit-[0-9]+' then substring(coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) from 'unit-([0-9]+)')::int
      else null end) between 1 and 3)
    or
    (ep.exam_code = 'ap_physics_c_mechanics' and (case
      when coalesce(civ.prompt_json->>'unit', (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1), nullif(civ.prompt_json->'modules'->>0,'AP Statistics')) ~ '^[0-9]+$'
        then (coalesce(civ.prompt_json->>'unit', (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1), nullif(civ.prompt_json->'modules'->>0,'AP Statistics')))::int
      when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^unit-[0-9]+' then substring(coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) from 'unit-([0-9]+)')::int
      else null end) between 1 and 3)
    or
    (ep.exam_code = 'ap_physics_2' and (case
      when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^[0-9]+$' then (coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)))::int
      when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^unit-[0-9]+' then substring(coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) from 'unit-([0-9]+)')::int
      else null end) between 9 and 11)
    or
    (ep.exam_code = 'ap_physics_c_em' and (case
      when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^[0-9]+$' then (coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)))::int
      when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^unit-[0-9]+' then substring(coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) from 'unit-([0-9]+)')::int
      else null end) between 8 and 10)
  );

do $$
declare
  v_p1 integer; v_p2 integer; v_cm integer; v_cem integer; v_total integer;
begin
  select count(*) filter (where exam_code='ap_physics_1'),
         count(*) filter (where exam_code='ap_physics_2'),
         count(*) filter (where exam_code='ap_physics_c_mechanics'),
         count(*) filter (where exam_code='ap_physics_c_em'),
         count(*)
    into v_p1, v_p2, v_cm, v_cem, v_total
  from early_year_physics_targets;

  if (v_p1, v_p2, v_cm, v_cem, v_total) <> (51, 49, 51, 52, 203) then
    raise exception 'unexpected_early_year_physics_pool:p1=%:p2=%:cm=%:cem=%:total=%', v_p1, v_p2, v_cm, v_cem, v_total;
  end if;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, status, review_kind, created_by
)
select gen_random_uuid(), t.content_item_version_id, '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid,
  'tutor_question', 'pending', t.item_type, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_physics_targets t
on conflict (content_item_version_id, reviewer_id, review_stage)
where content_item_version_id is not null
-- Never re-open an assignment the reviewer has already decided. Decisions are
-- immutable and the same (item version, reviewer, stage) triple cannot carry a
-- second one, so resetting such a row to 'pending' does not re-open it — it
-- strands the reviewer behind `review_submission:assignment_locked` on an item
-- they cannot resubmit. Already-reviewed items must be skipped by a packet.
-- (Repair for the rows this produced on 2026-08-03:
--  scripts/content-seed/reviewer-qa-remediation/20260803_orphaned_pending_assignment_repair.sql)
do update set status = 'pending'
where app.content_review_assignments.status <> 'submitted'
  and not exists (
    select 1 from app.content_review_decisions d
    where d.content_review_assignment_id
        = app.content_review_assignments.content_review_assignment_id
  );

insert into app.content_labels (exam_pack_id, label_key, label_name, label_type, status, created_by)
select distinct t.exam_pack_id,
  'early-year-' || replace(t.exam_code,'_','-') || '-ali-2026-08-03',
  'Early-year ' || t.exam_code || ' - Ghazanfar Ali',
  'workflow', 'published', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_physics_targets t
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name, label_type = excluded.label_type, status = excluded.status;

insert into app.content_review_assignment_labels (content_review_assignment_id, content_label_id, created_by)
select cra.content_review_assignment_id, l.id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_physics_targets t
join app.content_review_assignments cra
  on cra.content_item_version_id = t.content_item_version_id
 and cra.reviewer_id = '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
 and cra.status = 'pending'
join app.content_labels l
  on l.exam_pack_id = t.exam_pack_id
 and l.label_key = 'early-year-' || replace(t.exam_code,'_','-') || '-ali-2026-08-03'
on conflict do nothing;

do $$
declare
  v_pending integer;
  v_labeled integer;
begin
  select count(*) into v_pending
  from early_year_physics_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
   and cra.status = 'pending';

  select count(distinct t.content_key) into v_labeled
  from early_year_physics_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = '8328a005-eea2-4f0a-a540-8fe739f88be8'::uuid
   and cra.status = 'pending'
  join app.content_review_assignment_labels al on al.content_review_assignment_id = cra.content_review_assignment_id;

  if (v_pending, v_labeled) <> (203, 203) then
    raise exception 'early_year_physics_packets_reconciliation_failed:pending=%:labeled=%', v_pending, v_labeled;
  end if;
end
$$;

commit;
