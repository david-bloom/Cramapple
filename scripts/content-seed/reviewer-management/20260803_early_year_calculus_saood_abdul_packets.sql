-- Create six "early-year" (Aug-Oct) packets -- one per (subject, reviewer)
-- pair -- splitting all not-yet-published MCQ/FRQ content in Calculus AB
-- Units 1-3, Calculus BC Units 1-3, and Precalculus Units 1-2 evenly between
-- Muhammad Saood and Abdul Hanan (alternating by content_key within each
-- subject so both get a mix of MCQ/FRQ and topics, not a lopsided half).
--
-- Per instruction, reviewer continuity does not matter here: any existing
-- active ('pending'/'in_progress') assignment to someone other than Saood
-- or Abdul (Carlos Eduardo Hutchings: AB pending 14, BC pending 2; Shazia
-- Fazal: Precalculus pending 11) is freed ('skipped') and superseded.
-- Everyone's completed 'submitted' decisions are left untouched.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-early-year-calculus-saood-abdul-packets-20260803'));

create temporary table early_year_calc_targets (
  content_item_version_id uuid primary key,
  content_key text unique not null,
  item_type text not null,
  exam_code text not null,
  exam_pack_id uuid not null,
  reviewer_id uuid not null
) on commit drop;

insert into early_year_calc_targets (content_item_version_id, content_key, item_type, exam_code, exam_pack_id, reviewer_id)
select version_id, content_key, item_type, exam_code, exam_pack_id,
  case when mod(row_number() over (partition by exam_code order by content_key), 2) = 1
    then 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid  -- Muhammad Saood
    else '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid  -- Abdul Hanan
  end
from (
  select civ.id as version_id, ci.content_key, ci.item_type, ep.exam_code, ep.id as exam_pack_id,
    (case
      when raw_tag ~ '^[0-9]+$' then raw_tag::int
      when raw_tag ~ '^unit-[0-9]+' then substring(raw_tag from 'unit-([0-9]+)')::int
      else null
    end) as unit_num
  from app.content_items ci
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  cross join lateral (
    select coalesce(
      civ.prompt_json->>'unit',
      (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1),
      (civ.prompt_json->'modules'->>0)
    ) as raw_tag
  ) rt
  where ep.exam_code in ('ap_calculus_ab','ap_calculus_bc','ap_precalculus')
    and ci.status not in ('retired','published')
    and civ.version_num = (select max(v2.version_num) from app.content_item_versions v2 where v2.content_item_id = ci.id)
) resolved
where (exam_code in ('ap_calculus_ab','ap_calculus_bc') and unit_num between 1 and 3)
   or (exam_code = 'ap_precalculus' and unit_num between 1 and 2);

do $$
declare
  v_ab integer; v_bc integer; v_pc integer; v_total integer;
begin
  select count(*) filter (where exam_code='ap_calculus_ab'),
         count(*) filter (where exam_code='ap_calculus_bc'),
         count(*) filter (where exam_code='ap_precalculus'),
         count(*)
    into v_ab, v_bc, v_pc, v_total
  from early_year_calc_targets;

  if (v_ab, v_bc, v_pc, v_total) <> (46, 34, 55, 135) then
    raise exception 'unexpected_early_year_calculus_pool:ab=%:bc=%:pc=%:total=%', v_ab, v_bc, v_pc, v_total;
  end if;
end
$$;

-- Free any active assignment to a reviewer other than Saood/Abdul.
update app.content_review_assignments cra
set status = 'skipped'
from early_year_calc_targets t
where cra.content_item_version_id = t.content_item_version_id
  and cra.status in ('pending','in_progress')
  and cra.reviewer_id not in ('cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid, '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid);

do $$
declare
  v_other_still_active integer;
begin
  select count(*) into v_other_still_active
  from early_year_calc_targets t
  join app.content_review_assignments cra on cra.content_item_version_id = t.content_item_version_id
  where cra.status in ('pending','in_progress')
    and cra.reviewer_id not in ('cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid, '002e94ca-c634-4086-bea8-37390c0d3edf'::uuid);
  if v_other_still_active <> 0 then
    raise exception 'other_reviewers_still_have_active_early_year_calc_assignments:%', v_other_still_active;
  end if;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, status, review_kind, created_by
)
select gen_random_uuid(), t.content_item_version_id, t.reviewer_id,
  'tutor_question', 'pending', t.item_type, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_calc_targets t
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
  'early-year-' || replace(t.exam_code,'_','-') || '-' ||
    (case when t.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid then 'saood' else 'abdul' end) || '-2026-08-03',
  'Early-year ' || t.exam_code || ' - ' ||
    (case when t.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid then 'Muhammad Saood' else 'Abdul Hanan' end),
  'workflow', 'published', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_calc_targets t
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name, label_type = excluded.label_type, status = excluded.status;

insert into app.content_review_assignment_labels (content_review_assignment_id, content_label_id, created_by)
select cra.content_review_assignment_id, l.id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_calc_targets t
join app.content_review_assignments cra
  on cra.content_item_version_id = t.content_item_version_id
 and cra.reviewer_id = t.reviewer_id
 and cra.status = 'pending'
join app.content_labels l
  on l.exam_pack_id = t.exam_pack_id
 and l.label_key = 'early-year-' || replace(t.exam_code,'_','-') || '-' ||
    (case when t.reviewer_id = 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid then 'saood' else 'abdul' end) || '-2026-08-03'
on conflict do nothing;

do $$
declare
  v_pending integer;
  v_labeled integer;
begin
  select count(*) into v_pending
  from early_year_calc_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = t.reviewer_id
   and cra.status = 'pending';

  select count(distinct t.content_key) into v_labeled
  from early_year_calc_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = t.reviewer_id
   and cra.status = 'pending'
  join app.content_review_assignment_labels al on al.content_review_assignment_id = cra.content_review_assignment_id;

  if (v_pending, v_labeled) <> (135, 135) then
    raise exception 'early_year_calculus_packets_reconciliation_failed:pending=%:labeled=%', v_pending, v_labeled;
  end if;
end
$$;

commit;
