-- Add content intake and content-review workflow tables on top of the
-- normalized subject and artifact schema.

begin;

-- ----------------------------
-- Upload intake
-- ----------------------------

create table if not exists app.content_ingest_batches (
  batch_id uuid primary key default gen_random_uuid(),
  subject_id uuid not null references app.subjects(id) on delete restrict,
  exam_pack_version_id uuid references app.exam_pack_versions(id) on delete set null,
  upload_format text not null,
  original_filename text,
  raw_template text not null,
  parsed_template jsonb not null default '{}'::jsonb,
  parser_version text not null default 'ux-002-template-v1',
  parse_status text not null default 'uploaded',
  parse_error text,
  row_count integer not null default 0 check (row_count >= 0),
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_ingest_batches_format_check
    check (upload_format in ('csv', 'json')),
  constraint content_ingest_batches_status_check
    check (parse_status in ('uploaded', 'parsed', 'imported', 'failed'))
);

create trigger content_ingest_batches_set_updated_at
before update on app.content_ingest_batches
for each row execute function app.set_updated_at();

alter table app.content_ingest_batches enable row level security;

create policy "content_ingest_batches_owner_select"
on app.content_ingest_batches
for select
to authenticated
using (created_by = auth.uid());

create policy "content_ingest_batches_owner_write"
on app.content_ingest_batches
for insert
to authenticated
with check (created_by = auth.uid());

create policy "content_ingest_batches_owner_update"
on app.content_ingest_batches
for update
to authenticated
using (created_by = auth.uid())
with check (created_by = auth.uid());

create table if not exists app.content_ingest_rows (
  ingest_row_id uuid primary key default gen_random_uuid(),
  batch_id uuid not null references app.content_ingest_batches(batch_id) on delete cascade,
  row_number integer not null check (row_number >= 1),
  row_key text,
  review_stage text not null,
  question_type text not null,
  stem text not null,
  answer_letter text,
  answer_text text,
  canonical_answer text,
  modules text[] not null default '{}'::text[],
  subtopics text[] not null default '{}'::text[],
  change_request text,
  notes text,
  row_payload jsonb not null default '{}'::jsonb,
  materialized_artifact_version_id uuid references app.artifact_versions(artifact_version_id) on delete set null,
  ingest_status text not null default 'pending',
  ingest_error text,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_ingest_rows_stage_check
    check (review_stage in (
      'tutor-question',
      'tutor-answer',
      'tutor-frq',
      'reader-question',
      'reader-answer'
    )),
  constraint content_ingest_rows_type_check
    check (question_type in ('mcq', 'frq')),
  constraint content_ingest_rows_status_check
    check (ingest_status in ('pending', 'parsed', 'materialized', 'failed'))
);

create trigger content_ingest_rows_set_updated_at
before update on app.content_ingest_rows
for each row execute function app.set_updated_at();

alter table app.content_ingest_rows enable row level security;

create policy "content_ingest_rows_owner_select"
on app.content_ingest_rows
for select
to authenticated
using (
  created_by = auth.uid()
  or exists (
    select 1
    from app.content_ingest_batches b
    where b.batch_id = content_ingest_rows.batch_id
      and b.created_by = auth.uid()
  )
);

create policy "content_ingest_rows_owner_write"
on app.content_ingest_rows
for insert
to authenticated
with check (created_by = auth.uid());

create policy "content_ingest_rows_owner_update"
on app.content_ingest_rows
for update
to authenticated
using (
  created_by = auth.uid()
  or exists (
    select 1
    from app.content_ingest_batches b
    where b.batch_id = content_ingest_rows.batch_id
      and b.created_by = auth.uid()
  )
)
with check (
  created_by = auth.uid()
  or exists (
    select 1
    from app.content_ingest_batches b
    where b.batch_id = content_ingest_rows.batch_id
      and b.created_by = auth.uid()
  )
);

create index if not exists content_ingest_rows_batch_id_idx
  on app.content_ingest_rows (batch_id, row_number);

grant select, insert, update on app.content_ingest_batches to authenticated;
grant select, insert, update on app.content_ingest_rows to authenticated;
grant select, insert, update, delete on app.content_ingest_batches to service_role;
grant select, insert, update, delete on app.content_ingest_rows to service_role;

-- ----------------------------
-- Artifact label projection
-- ----------------------------

create table if not exists app.artifact_label_assignments (
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  content_label_id uuid not null references app.content_labels(id) on delete cascade,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  primary key (artifact_version_id, content_label_id)
);

alter table app.artifact_label_assignments enable row level security;

create policy "artifact_label_assignments_reviewer_write"
on app.artifact_label_assignments
for insert
to authenticated
with check (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.artifact_version_id = artifact_label_assignments.artifact_version_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create policy "artifact_label_assignments_reviewer_update"
on app.artifact_label_assignments
for update
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.artifact_version_id = artifact_label_assignments.artifact_version_id
      and cra.assigned_reviewer_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.artifact_version_id = artifact_label_assignments.artifact_version_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create policy "artifact_label_assignments_reviewer_delete"
on app.artifact_label_assignments
for delete
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.artifact_version_id = artifact_label_assignments.artifact_version_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create index if not exists artifact_label_assignments_label_id_idx
  on app.artifact_label_assignments (content_label_id, artifact_version_id);

-- ----------------------------
-- Tutor / reader review workflow
-- ----------------------------

create table if not exists app.content_review_assignments (
  content_review_assignment_id uuid primary key default gen_random_uuid(),
  ingest_row_id uuid references app.content_ingest_rows(ingest_row_id) on delete set null,
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  review_stage text not null,
  review_kind text not null,
  assigned_reviewer_id uuid not null references app.profiles(user_id),
  assigned_role text not null,
  blind_group_id uuid,
  answer_key text,
  part_key text,
  due_at timestamptz,
  status text not null default 'assigned',
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_review_assignments_stage_check
    check (review_stage in ('question', 'answer', 'canonical_answer', 'difficulty_discussion')),
  constraint content_review_assignments_kind_check
    check (review_kind in ('mcq', 'frq')),
  constraint content_review_assignments_role_check
    check (assigned_role in ('tutor', 'reader')),
  constraint content_review_assignments_status_check
    check (status in ('assigned', 'opened', 'submitted', 'recused', 'expired', 'cancelled'))
);

create trigger content_review_assignments_set_updated_at
before update on app.content_review_assignments
for each row execute function app.set_updated_at();

alter table app.content_review_assignments enable row level security;

create policy "content_review_assignments_reviewer_select"
on app.content_review_assignments
for select
to authenticated
using (
  assigned_reviewer_id = auth.uid()
  or created_by = auth.uid()
);

create policy "content_review_assignments_reviewer_update"
on app.content_review_assignments
for update
to authenticated
using (
  assigned_reviewer_id = auth.uid()
  or created_by = auth.uid()
)
with check (
  assigned_reviewer_id = auth.uid()
  or created_by = auth.uid()
);

create index if not exists content_review_assignments_reviewer_idx
  on app.content_review_assignments (assigned_reviewer_id, status, due_at);

create index if not exists content_review_assignments_artifact_idx
  on app.content_review_assignments (artifact_version_id, review_stage, status);

create table if not exists app.content_review_assignment_labels (
  content_review_assignment_id uuid not null references app.content_review_assignments(content_review_assignment_id) on delete cascade,
  content_label_id uuid not null references app.content_labels(id) on delete cascade,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  primary key (content_review_assignment_id, content_label_id)
);

alter table app.content_review_assignment_labels enable row level security;

create policy "content_review_assignment_labels_reviewer_write"
on app.content_review_assignment_labels
for insert
to authenticated
with check (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create policy "content_review_assignment_labels_reviewer_update"
on app.content_review_assignment_labels
for update
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id
      and cra.assigned_reviewer_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create policy "content_review_assignment_labels_reviewer_delete"
on app.content_review_assignment_labels
for delete
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create index if not exists content_review_assignment_labels_label_idx
  on app.content_review_assignment_labels (content_label_id, content_review_assignment_id);

create table if not exists app.content_review_decisions (
  content_review_decision_id uuid primary key default gen_random_uuid(),
  content_review_assignment_id uuid not null references app.content_review_assignments(content_review_assignment_id) on delete cascade,
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  decision text not null,
  score integer,
  difficulty_label_id uuid references app.content_labels(id) on delete set null,
  concern_codes text[] not null default '{}'::text[],
  rationale text not null,
  change_request text,
  submitted_at timestamptz not null default now(),
  supersedes_content_review_decision_id uuid references app.content_review_decisions(content_review_decision_id) on delete set null,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  constraint content_review_decisions_decision_check
    check (decision in ('approve', 'propose_change', 'reject', 'agree', 'disagree')),
  constraint content_review_decisions_score_check
    check (score is null or score in (1, 2, 3))
);

alter table app.content_review_decisions enable row level security;

create policy "content_review_decisions_reviewer_select"
on app.content_review_decisions
for select
to authenticated
using (
  created_by = auth.uid()
  or exists (
    select 1
    from app.content_review_assignments a
    where a.content_review_assignment_id = content_review_decisions.content_review_assignment_id
      and a.assigned_reviewer_id = auth.uid()
  )
);

create policy "content_review_decisions_reviewer_write"
on app.content_review_decisions
for insert
to authenticated
with check (created_by = auth.uid());

create policy "content_review_decisions_reviewer_update"
on app.content_review_decisions
for update
to authenticated
using (created_by = auth.uid())
with check (created_by = auth.uid());

create index if not exists content_review_decisions_assignment_idx
  on app.content_review_decisions (content_review_assignment_id, submitted_at desc);

grant select, update on app.content_review_assignments to authenticated;
grant select, insert, update on app.content_review_decisions to authenticated;
grant select, insert, update, delete on app.artifact_label_assignments to authenticated;
grant select, insert, update, delete on app.content_review_assignment_labels to authenticated;

grant select, insert, update, delete on app.content_review_assignments to service_role;
grant select, insert, update, delete on app.content_review_assignment_labels to service_role;
grant select, insert, update, delete on app.content_review_decisions to service_role;
grant select, insert, update, delete on app.artifact_label_assignments to service_role;

create policy "artifact_label_assignments_reviewer_select"
on app.artifact_label_assignments
for select
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.artifact_version_id = artifact_label_assignments.artifact_version_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create policy "content_review_assignment_labels_reviewer_select"
on app.content_review_assignment_labels
for select
to authenticated
using (
  exists (
    select 1
    from app.content_review_assignments cra
    where cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

create policy "content_labels_select_assigned_reviewer"
on app.content_labels
for select
to authenticated
using (
  status = 'published'
  or exists (
    select 1
    from app.artifact_label_assignments ala
    join app.content_review_assignments cra
      on cra.artifact_version_id = ala.artifact_version_id
    where ala.content_label_id = content_labels.id
      and cra.assigned_reviewer_id = auth.uid()
  )
);

-- ----------------------------
-- Student workflow bridge
-- ----------------------------

alter table app.attempts
  add column if not exists artifact_version_id uuid;

alter table app.attempts
  add constraint attempts_artifact_version_id_fkey
  foreign key (artifact_version_id) references app.artifact_versions(artifact_version_id) on delete set null;

create index if not exists attempts_artifact_version_id_idx
  on app.attempts (artifact_version_id, submitted_at desc);

commit;
