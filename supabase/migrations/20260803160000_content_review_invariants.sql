-- Content-review integrity: prevent the reopen-a-decided-assignment class, and
-- detect the invariant breaks that no trigger can prevent.
--
-- WHY. On 2026-08-02 nine assignments were found reset to 'pending' on top of an
-- immutable decision, corrected in place, and the writer that produced them was
-- not fixed. On 2026-08-03 the same class reappeared at 36 rows across five
-- reviewers and presented as "Abdul Hanan cannot submit anything". Both times it
-- was silent until a reviewer complained.
--
-- Two layers here, because they do different jobs:
--   1. A trigger that makes the specific class impossible.
--   2. A scheduled check that reports the invariants a trigger cannot enforce
--      (historical rows, and breaks arriving through other tables).

begin;

-- ── Layer 1: prevention ──────────────────────────────────────────────────────
--
-- Reopening a decided assignment never achieves what the caller intends. The
-- submission trigger refuses a second decision on the same (item version,
-- reviewer, stage), so the row cannot be resubmitted — it just strands the
-- reviewer behind `assignment_locked` on an item they can open but never close.
-- An already-reviewed item must be skipped by a packet, not reset.

create or replace function app.prevent_reopen_decided_assignment()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  if new.status in ('pending', 'in_progress')
     and old.status not in ('pending', 'in_progress')
     and exists (
       select 1 from app.content_review_decisions d
       where d.content_review_assignment_id = new.content_review_assignment_id
     )
  then
    raise exception using
      errcode = 'P0001',
      message = 'review_assignment:cannot_reopen_decided',
      detail = format(
        'assignment %s already carries a decision; skip it instead of resetting it',
        new.content_review_assignment_id
      );
  end if;
  return new;
end;
$$;

-- Deliberately only blocks the transition INTO an open state. Rows already in the
-- broken state stay updatable, so a repair script can still close them.
create trigger tg_content_review_assignments_no_reopen_decided
  before update of status on app.content_review_assignments
  for each row execute function app.prevent_reopen_decided_assignment();

-- ── Layer 2: detection ───────────────────────────────────────────────────────

create table app.content_review_invariant_violations (
  violation_id uuid primary key default gen_random_uuid(),
  check_key text not null,
  subject_id uuid not null,
  detail jsonb not null default '{}'::jsonb,
  first_detected_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  resolved_at timestamptz,
  constraint content_review_invariant_violations_unique
    unique (check_key, subject_id)
);

create index content_review_invariant_violations_open_idx
  on app.content_review_invariant_violations (check_key, resolved_at)
  where resolved_at is null;

alter table app.content_review_invariant_violations enable row level security;
alter table app.content_review_invariant_violations force row level security;
revoke all on app.content_review_invariant_violations
  from public, anon, authenticated;
grant select, insert, update on app.content_review_invariant_violations
  to service_role;

create or replace function app.check_content_review_invariants()
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_found integer;
  v_resolved integer;
begin
  create temporary table _cri_current (
    check_key text not null,
    subject_id uuid not null,
    detail jsonb not null
  ) on commit drop;

  -- The recurring class: an open assignment that already carries a decision.
  -- The trigger above should keep this empty; a hit means something reached the
  -- state by a path the trigger does not cover.
  insert into _cri_current
  select 'open_assignment_with_decision', a.content_review_assignment_id,
         jsonb_build_object('reviewer_id', a.reviewer_id, 'status', a.status,
                            'content_item_version_id', a.content_item_version_id)
  from app.content_review_assignments a
  where a.status in ('pending', 'in_progress')
    and exists (
      select 1 from app.content_review_decisions d
      where d.content_review_assignment_id = a.content_review_assignment_id
    );

  -- The inverse: a closed assignment with no decision backing it.
  insert into _cri_current
  select 'submitted_assignment_without_decision', a.content_review_assignment_id,
         jsonb_build_object('reviewer_id', a.reviewer_id,
                            'content_item_version_id', a.content_item_version_id)
  from app.content_review_assignments a
  where a.status = 'submitted'
    and not exists (
      select 1 from app.content_review_decisions d
      where d.content_review_assignment_id = a.content_review_assignment_id
    );

  -- A decision attributed to someone other than the assignee. Blocked on insert
  -- since the atomic-lock fix; historical rows predate it. Baseline 3 rows at
  -- 2026-08-03.
  insert into _cri_current
  select 'decision_reviewer_mismatch', d.content_review_decision_id,
         jsonb_build_object('decision_reviewer', d.reviewer_id,
                            'assignment_reviewer', a.reviewer_id,
                            'assignment_id', a.content_review_assignment_id)
  from app.content_review_decisions d
  join app.content_review_assignments a
    on a.content_review_assignment_id = d.content_review_assignment_id
  where d.reviewer_id is distinct from a.reviewer_id;

  -- Work queued against content that has since been retired. The 2026-08-02
  -- withdrawal migration was meant to drain these. Baseline 3 rows at 2026-08-03.
  insert into _cri_current
  select 'open_assignment_on_retired_content', a.content_review_assignment_id,
         jsonb_build_object('reviewer_id', a.reviewer_id, 'content_key', ci.content_key)
  from app.content_review_assignments a
  join app.content_item_versions civ on civ.id = a.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  where a.status in ('pending', 'in_progress')
    and ci.status = 'retired';

  insert into app.content_review_invariant_violations (check_key, subject_id, detail)
  select c.check_key, c.subject_id, c.detail from _cri_current c
  on conflict (check_key, subject_id) do update
    set last_seen_at = pg_catalog.now(),
        detail = excluded.detail,
        resolved_at = null;

  get diagnostics v_found = row_count;

  update app.content_review_invariant_violations v
  set resolved_at = pg_catalog.now()
  where v.resolved_at is null
    and not exists (
      select 1 from _cri_current c
      where c.check_key = v.check_key and c.subject_id = v.subject_id
    );

  get diagnostics v_resolved = row_count;

  return jsonb_build_object(
    'checked_at', pg_catalog.now(),
    'open_violations', (
      select coalesce(jsonb_object_agg(check_key, n), '{}'::jsonb) from (
        select check_key, count(*) n
        from app.content_review_invariant_violations
        where resolved_at is null group by 1
      ) s
    ),
    'seen_this_run', v_found,
    'newly_resolved', v_resolved
  );
end;
$$;

revoke all on function app.check_content_review_invariants()
  from public, anon, authenticated;
grant execute on function app.check_content_review_invariants() to service_role;

-- Admin-readable report, so this is inspectable without service_role.
create or replace function public.content_review_invariant_report()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if not exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'check_key', check_key, 'subject_id', subject_id, 'detail', detail,
      'first_detected_at', first_detected_at, 'last_seen_at', last_seen_at)
      order by first_detected_at desc)
    from app.content_review_invariant_violations
    where resolved_at is null
  ), '[]'::jsonb);
end;
$$;

revoke all on function public.content_review_invariant_report() from public, anon;
grant execute on function public.content_review_invariant_report() to authenticated;

-- 06:05 UTC daily — after the overnight window, before the working day, so a
-- break introduced by an evening packet script is visible the next morning.
select cron.schedule(
  'content-review-invariants',
  '5 6 * * *',
  $cron$select app.check_content_review_invariants();$cron$
);

commit;
