-- TASK-0027: mirror the "Content-review invariants" cluster (5 objects) from
-- Production into Development. Approved by the Product Owner 2026-08-22,
-- completing the governance-critical pair Codex's P1-P4 answer identified
-- alongside the publish-gate cluster (mirrored earlier the same day in
-- 20260822180000_mirror_publish_gate_cluster_into_dev.sql).
--
-- Dev-only in effect: IF NOT EXISTS / OR REPLACE / DROP ... IF EXISTS
-- throughout, so this is a no-op against Production, where all five objects
-- already exist unchanged. Definitions pulled verbatim from Production via
-- pg_get_functiondef/pg_get_triggerdef/pg_get_constraintdef on 2026-08-22.
--
-- Prerequisite gap found and closed: app.content_review_assignments in
-- Development was missing assignment_purpose entirely (the
-- owner-remediation-approval self-assignment path). It is NOT NULL in
-- Production with a default, so adding it here backfills every existing row
-- to 'subject_review' - the default that already describes 100% of
-- Development's content_review_assignments rows today (there is 1 row, a
-- routine subject-review assignment, not an owner-remediation approval).
--
-- app.validator_qualifications, referenced by
-- tg_enforce_content_review_qualification, already exists in both
-- environments - no gap there.

alter table app.content_review_assignments
  add column assignment_purpose text not null default 'subject_review';

alter table app.content_review_assignments
  add constraint content_review_assignments_purpose_check
  check (assignment_purpose = any (array['subject_review', 'owner_remediation_approval']));

create table if not exists app.content_review_invariant_violations (
  violation_id uuid primary key default gen_random_uuid(),
  check_key text not null,
  subject_id uuid not null,
  detail jsonb not null default '{}'::jsonb,
  first_detected_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  resolved_at timestamptz,
  constraint content_review_invariant_violations_unique unique (check_key, subject_id)
);

create index if not exists content_review_invariant_violations_open_idx
  on app.content_review_invariant_violations (check_key, resolved_at)
  where resolved_at is null;

-- Matches Production: RLS enabled, no policy, so only service_role (edge
-- functions / the SECURITY DEFINER functions below) can reach this table.
alter table app.content_review_invariant_violations enable row level security;

create or replace function app.check_content_review_invariants()
returns jsonb
language plpgsql
security definer
set search_path to 'pg_catalog'
as $function$
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
$function$;

create or replace function public.content_review_invariant_report()
returns jsonb
language plpgsql
stable security definer
set search_path to 'pg_catalog'
as $function$
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
$function$;

create or replace function app.prevent_reopen_decided_assignment()
returns trigger
language plpgsql
set search_path to 'pg_catalog'
as $function$
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
$function$;

create or replace function app.tg_enforce_content_review_qualification()
returns trigger
language plpgsql
set search_path to 'app', 'pg_temp'
as $function$
declare
  target_exam_id uuid;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.assignment_purpose = 'owner_remediation_approval' then
    if new.reviewer_id is distinct from new.created_by
       or new.blind_group_id is not null
       or new.review_stage <> 'tutor_question'
       or not exists (
         select 1
           from app.profiles p
          where p.user_id = new.reviewer_id
            and p.role = 'admin'
       )
    then
      raise exception using
        errcode = '23514',
        constraint =
          'content_review_assignments_owner_remediation_approval_check',
        message =
          'owner remediation approval requires a non-blind admin self-assignment';
    end if;
    return new;
  end if;

  select epv.exam_pack_id
    into target_exam_id
    from app.content_item_versions civ
    join app.content_items ci
      on ci.id = civ.content_item_id
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
   where civ.id = new.content_item_version_id;

  if target_exam_id is null then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'content review assignment %s has no resolvable exam scope',
        new.content_review_assignment_id
      );
  end if;

  if not exists (
    select 1
      from app.validator_qualifications vq
     where vq.reviewer_id = new.reviewer_id
       and vq.status = 'active'
       and target_exam_id = any(vq.exam_ids)
       and vq.effective_at <= now()
       and vq.expires_at > now()
  ) then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'reviewer %s lacks an active qualification for exam %s',
        new.reviewer_id,
        target_exam_id
      );
  end if;

  return new;
end;
$function$;

drop trigger if exists content_review_assignment_qualification_on_insert on app.content_review_assignments;
create trigger content_review_assignment_qualification_on_insert
  before insert on app.content_review_assignments
  for each row
  execute function app.tg_enforce_content_review_qualification();

drop trigger if exists content_review_assignment_qualification_on_scope_change on app.content_review_assignments;
create trigger content_review_assignment_qualification_on_scope_change
  before update of reviewer_id, content_item_version_id on app.content_review_assignments
  for each row
  execute function app.tg_enforce_content_review_qualification();

drop trigger if exists tg_content_review_assignments_no_reopen_decided on app.content_review_assignments;
create trigger tg_content_review_assignments_no_reopen_decided
  before update of status on app.content_review_assignments
  for each row
  execute function app.prevent_reopen_decided_assignment();
