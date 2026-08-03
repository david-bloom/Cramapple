-- Create an "early-year" (Aug-Oct, Units 1-3: Chemistry of Life, Cells,
-- Cellular Energetics) packet for AP Biology's not-yet-published MCQ/FRQ
-- content (9 MCQ + 8 FRQ, verified count), and ensure Sarah Sohail holds a
-- pending assignment on every one of them, labeled into the new packet.
--
-- 13/17 already had a live pending assignment to Sarah (dual-blind paired
-- with Adil Abbasi on most, untouched by this script). The remaining 4 FRQs
-- had Sarah's decision already `submitted` (APBIO-FRQ-S-003/004/013/019) --
-- this script gives her a fresh pending assignment on those 4 too so the
-- whole packet is uniformly hers, without touching her prior decisions or
-- anyone else's assignments.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-early-year-biology-sarah-packet-20260803'));

create temporary table early_year_bio_targets (
  content_item_id uuid,
  content_item_version_id uuid primary key,
  content_key text unique not null,
  item_type text not null
) on commit drop;

insert into early_year_bio_targets (content_item_id, content_item_version_id, content_key, item_type)
select ci.id, civ.id, ci.content_key, ci.item_type
from app.content_items ci
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.content_item_versions civ on civ.content_item_id = ci.id
where ep.exam_code = 'ap_biology'
  and ci.status not in ('retired','published')
  and civ.version_num = (select max(v2.version_num) from app.content_item_versions v2 where v2.content_item_id = ci.id)
  and (case
        when coalesce(
               civ.prompt_json->>'unit',
               (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1),
               nullif(nullif(civ.prompt_json->'modules'->>0, 'AP Statistics'), 'AP Biology')
             ) ~ '^[0-9]+$'
        then (coalesce(
               civ.prompt_json->>'unit',
               (select tr->>'node_key' from jsonb_array_elements(coalesce(civ.prompt_json->'taxonomy_refs','[]'::jsonb)) tr where tr->>'node_key' like 'unit-%' limit 1),
               nullif(nullif(civ.prompt_json->'modules'->>0, 'AP Statistics'), 'AP Biology')
             ))::int
        else null
      end) between 1 and 3;

do $$
declare
  v_mcq integer;
  v_frq integer;
begin
  select count(*) filter (where item_type='mcq'), count(*) filter (where item_type='frq')
    into v_mcq, v_frq
  from early_year_bio_targets;

  if (v_mcq, v_frq) <> (9, 8) then
    raise exception 'unexpected_early_year_biology_pool:mcq=%:frq=%', v_mcq, v_frq;
  end if;
end
$$;

-- Ensure Sarah holds a pending assignment on every target item. A unique
-- constraint on (content_item_version_id, reviewer_id, review_stage) means
-- she can only have one row per item at this stage regardless of status --
-- reopen it to 'pending' where it already exists (e.g. her prior 'submitted'
-- decision on 4 of these FRQs), otherwise insert fresh.
insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, status, review_kind, created_by
)
select gen_random_uuid(), t.content_item_version_id, 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid,
  'tutor_question', 'pending', t.item_type, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_bio_targets t
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

do $$
declare
  v_pending_to_sarah integer;
begin
  select count(*) into v_pending_to_sarah
  from early_year_bio_targets t
  join app.content_review_assignments cra on cra.content_item_version_id = t.content_item_version_id
  where cra.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
    and cra.status = 'pending';

  if v_pending_to_sarah <> 17 then
    raise exception 'expected_all_17_items_pending_to_sarah_after_backfill:found=%', v_pending_to_sarah;
  end if;
end
$$;

insert into app.content_labels (
  exam_pack_id, label_key, label_name, label_type, status, created_by
) values (
  '9dac6d66-5cf4-4a3e-a8cd-4adb7f681023'::uuid,
  'early-year-biology-sarah-2026-08-03',
  'Early-year AP Biology (Units 1-3) - Sarah Sohail',
  'workflow',
  'published',
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name,
    label_type = excluded.label_type,
    status = excluded.status;

insert into app.content_review_assignment_labels (
  content_review_assignment_id, content_label_id, created_by
)
select cra.content_review_assignment_id, l.id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_bio_targets t
join app.content_review_assignments cra
  on cra.content_item_version_id = t.content_item_version_id
 and cra.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
 and cra.status = 'pending'
join app.content_labels l
  on l.exam_pack_id = '9dac6d66-5cf4-4a3e-a8cd-4adb7f681023'::uuid
 and l.label_key = 'early-year-biology-sarah-2026-08-03'
on conflict do nothing;

do $$
declare
  v_labeled integer;
begin
  select count(distinct t.content_key)
  into v_labeled
  from early_year_bio_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = 'c1d12a8d-1489-4f90-990f-2f1ae2d54199'::uuid
   and cra.status = 'pending'
  join app.content_review_assignment_labels al on al.content_review_assignment_id = cra.content_review_assignment_id
  join app.content_labels l on l.id = al.content_label_id
  where l.label_key = 'early-year-biology-sarah-2026-08-03';

  if v_labeled <> 17 then
    raise exception 'early_year_biology_packet_reconciliation_failed:labeled=%', v_labeled;
  end if;
end
$$;

commit;
