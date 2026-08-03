-- Create an "early-year" (Aug-Oct, Units 1-2: One-Variable Data/Collecting
-- Data, Probability/Random Variables) packet for AP Statistics's not-yet-
-- published MCQ/FRQ content (38 items, verified count), and assign the
-- whole pool to Shazia Fazal. Jill Schmidlkofer's single active pending
-- assignment within this scope (APSTATS-SFRQ-003) is freed ('skipped') per
-- instruction that she has other work -- her other Statistics work outside
-- this early-year scope, and everyone's completed 'submitted' decisions
-- (Jill's, Shazia's own, David's), are untouched.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-early-year-statistics-shazia-packet-20260803'));

create temporary table early_year_stats_targets (
  content_item_version_id uuid primary key,
  content_key text unique not null,
  item_type text not null
) on commit drop;

insert into early_year_stats_targets (content_item_version_id, content_key, item_type)
select civ.id, ci.content_key, ci.item_type
from app.content_items ci
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.content_item_versions civ on civ.content_item_id = ci.id
where ep.exam_code = 'ap_statistics'
  and ci.status not in ('retired','published')
  and civ.version_num = (select max(v2.version_num) from app.content_item_versions v2 where v2.content_item_id = ci.id)
  and (case
        when coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)) ~ '^[0-9]+$'
          then (coalesce(civ.prompt_json->>'unit', (civ.prompt_json->'modules'->>0)))::int
        else null
      end) between 1 and 2;

do $$
declare
  v_total integer;
begin
  select count(*) into v_total from early_year_stats_targets;
  if v_total <> 38 then
    raise exception 'unexpected_early_year_statistics_pool:total=%', v_total;
  end if;
end
$$;

-- Free Jill's one active assignment within this scope.
update app.content_review_assignments cra
set status = 'skipped'
from early_year_stats_targets t
where cra.content_item_version_id = t.content_item_version_id
  and cra.reviewer_id = '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
  and cra.status = 'pending';

do $$
declare
  v_jill_still_pending integer;
begin
  select count(*) into v_jill_still_pending
  from early_year_stats_targets t
  join app.content_review_assignments cra on cra.content_item_version_id = t.content_item_version_id
  where cra.reviewer_id = '0a5909f7-f50b-486a-a31f-4fc3cc47e039'::uuid
    and cra.status = 'pending';
  if v_jill_still_pending <> 0 then
    raise exception 'jill_still_has_pending_early_year_stats:%', v_jill_still_pending;
  end if;
end
$$;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, status, review_kind, created_by
)
select gen_random_uuid(), t.content_item_version_id, '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid,
  'tutor_question', 'pending', t.item_type, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_stats_targets t
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
values (
  'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid,
  'early-year-statistics-shazia-2026-08-03',
  'Early-year AP Statistics (Units 1-2) - Shazia Fazal',
  'workflow', 'published', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
)
on conflict (exam_pack_id, label_key) do update
set label_name = excluded.label_name, label_type = excluded.label_type, status = excluded.status;

insert into app.content_review_assignment_labels (content_review_assignment_id, content_label_id, created_by)
select cra.content_review_assignment_id, l.id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from early_year_stats_targets t
join app.content_review_assignments cra
  on cra.content_item_version_id = t.content_item_version_id
 and cra.reviewer_id = '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
 and cra.status = 'pending'
join app.content_labels l
  on l.exam_pack_id = 'ff732d79-b274-44c5-8beb-cd27f5f5219e'::uuid
 and l.label_key = 'early-year-statistics-shazia-2026-08-03'
on conflict do nothing;

do $$
declare
  v_pending integer;
  v_labeled integer;
begin
  select count(*) into v_pending
  from early_year_stats_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and cra.status = 'pending';

  select count(distinct t.content_key) into v_labeled
  from early_year_stats_targets t
  join app.content_review_assignments cra
    on cra.content_item_version_id = t.content_item_version_id
   and cra.reviewer_id = '1e6f9c8e-d6ad-4b39-b33b-b31a93020945'::uuid
   and cra.status = 'pending'
  join app.content_review_assignment_labels al on al.content_review_assignment_id = cra.content_review_assignment_id;

  if (v_pending, v_labeled) <> (38, 38) then
    raise exception 'early_year_statistics_packet_reconciliation_failed:pending=%:labeled=%', v_pending, v_labeled;
  end if;
end
$$;

commit;
