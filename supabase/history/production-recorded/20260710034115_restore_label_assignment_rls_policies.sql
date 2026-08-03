-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260710034115
-- recorded name: restore_label_assignment_rls_policies
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Restore RLS policies for label assignment tables flagged by advisors.
--
-- These tables are granted to authenticated callers and are used by the
-- reviewer/content-authoring surfaces, so "RLS enabled with zero policies" is
-- not a definer-RPC-only design. It silently blocks API access. Keep the access
-- narrow: content authors/admins can manage artifact labels; reviewers can see
-- and manage labels only for their own review assignments.

-- ── app.artifact_label_assignments ──────────────────────────────────────────

alter table app.artifact_label_assignments enable row level security;

grant select, insert, update, delete on app.artifact_label_assignments
  to authenticated;
grant select, insert, update, delete on app.artifact_label_assignments
  to service_role;

drop policy if exists artifact_label_assignments_staff_select
  on app.artifact_label_assignments;
drop policy if exists artifact_label_assignments_staff_insert
  on app.artifact_label_assignments;
drop policy if exists artifact_label_assignments_staff_update
  on app.artifact_label_assignments;
drop policy if exists artifact_label_assignments_staff_delete
  on app.artifact_label_assignments;

create policy artifact_label_assignments_staff_select
on app.artifact_label_assignments
for select
to authenticated
using (
  exists (
    select 1
    from app.profiles p
    where p.user_id = (select auth.uid())
      and p.role in ('admin', 'content_author')
  )
);

create policy artifact_label_assignments_staff_insert
on app.artifact_label_assignments
for insert
to authenticated
with check (
  exists (
    select 1
    from app.profiles p
    where p.user_id = (select auth.uid())
      and p.role in ('admin', 'content_author')
  )
);

create policy artifact_label_assignments_staff_update
on app.artifact_label_assignments
for update
to authenticated
using (
  exists (
    select 1
    from app.profiles p
    where p.user_id = (select auth.uid())
      and p.role in ('admin', 'content_author')
  )
)
with check (
  exists (
    select 1
    from app.profiles p
    where p.user_id = (select auth.uid())
      and p.role in ('admin', 'content_author')
  )
);

create policy artifact_label_assignments_staff_delete
on app.artifact_label_assignments
for delete
to authenticated
using (
  exists (
    select 1
    from app.profiles p
    where p.user_id = (select auth.uid())
      and p.role in ('admin', 'content_author')
  )
);

-- ── app.content_review_assignment_labels ────────────────────────────────────

create table if not exists app.content_review_assignment_labels (
  content_review_assignment_id uuid not null
    references app.content_review_assignments(content_review_assignment_id)
    on delete cascade,
  content_label_id uuid not null references app.content_labels(id)
    on delete cascade,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  primary key (content_review_assignment_id, content_label_id)
);

alter table app.content_review_assignment_labels enable row level security;

grant select, insert, update, delete on app.content_review_assignment_labels
  to authenticated;
grant select, insert, update, delete on app.content_review_assignment_labels
  to service_role;

create index if not exists content_review_assignment_labels_label_idx
  on app.content_review_assignment_labels (
    content_label_id,
    content_review_assignment_id
  );

drop policy if exists content_review_assignment_labels_reviewer_select
  on app.content_review_assignment_labels;
drop policy if exists content_review_assignment_labels_reviewer_insert
  on app.content_review_assignment_labels;
drop policy if exists content_review_assignment_labels_reviewer_update
  on app.content_review_assignment_labels;
drop policy if exists content_review_assignment_labels_reviewer_delete
  on app.content_review_assignment_labels;

create policy content_review_assignment_labels_reviewer_select
on app.content_review_assignment_labels
for select
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id =
      content_review_assignment_labels.content_review_assignment_id
      and (
        cra.reviewer_id = (select auth.uid())
        or cra.created_by = (select auth.uid())
        or exists (
          select 1
          from app.profiles p
          where p.user_id = (select auth.uid())
            and p.role = 'admin'
        )
      )
  )
);

create policy content_review_assignment_labels_reviewer_insert
on app.content_review_assignment_labels
for insert
to authenticated
with check (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id =
      content_review_assignment_labels.content_review_assignment_id
      and cra.status in ('pending', 'in_progress')
      and (
        cra.reviewer_id = (select auth.uid())
        or cra.created_by = (select auth.uid())
        or exists (
          select 1
          from app.profiles p
          where p.user_id = (select auth.uid())
            and p.role = 'admin'
        )
      )
  )
);

create policy content_review_assignment_labels_reviewer_update
on app.content_review_assignment_labels
for update
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id =
      content_review_assignment_labels.content_review_assignment_id
      and cra.status in ('pending', 'in_progress')
      and (
        cra.reviewer_id = (select auth.uid())
        or cra.created_by = (select auth.uid())
        or exists (
          select 1
          from app.profiles p
          where p.user_id = (select auth.uid())
            and p.role = 'admin'
        )
      )
  )
)
with check (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id =
      content_review_assignment_labels.content_review_assignment_id
      and cra.status in ('pending', 'in_progress')
      and (
        cra.reviewer_id = (select auth.uid())
        or cra.created_by = (select auth.uid())
        or exists (
          select 1
          from app.profiles p
          where p.user_id = (select auth.uid())
            and p.role = 'admin'
        )
      )
  )
);

create policy content_review_assignment_labels_reviewer_delete
on app.content_review_assignment_labels
for delete
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id =
      content_review_assignment_labels.content_review_assignment_id
      and cra.status in ('pending', 'in_progress')
      and (
        cra.reviewer_id = (select auth.uid())
        or cra.created_by = (select auth.uid())
        or exists (
          select 1
          from app.profiles p
          where p.user_id = (select auth.uid())
            and p.role = 'admin'
        )
      )
  )
);

commit;
