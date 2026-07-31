-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124936
-- recorded name: content_review_workflow
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Content review workflow: assignments and immutable decisions.
-- Supersedes the review tables from 202606230003 with corrected FKs to content_item_versions.

begin;

drop table if exists app.content_review_decisions cascade;
drop table if exists app.content_review_assignments cascade;

create table app.content_review_assignments (
  id                      uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  reviewer_id             uuid not null
    references app.profiles(user_id) on delete cascade,
  review_stage            text not null,
  blind_group_id          uuid,
  status                  text not null default 'pending',
  assigned_at             timestamptz not null default now(),
  due_at                  timestamptz,
  created_at              timestamptz not null default now(),
  created_by              uuid references app.profiles(user_id),
  constraint cra_stage_check check (review_stage in (
    'tutor_question', 'tutor_answer', 'tutor_frq_canonical', 'reader_question'
  )),
  constraint cra_status_check check (status in (
    'pending', 'in_progress', 'submitted', 'skipped'
  )),
  constraint cra_unique_active_assignment
    unique (content_item_version_id, reviewer_id, review_stage)
);

create index cra_reviewer_status_idx on app.content_review_assignments (reviewer_id, status);
create index cra_version_stage_idx on app.content_review_assignments (content_item_version_id, review_stage);
create index cra_blind_group_idx on app.content_review_assignments (blind_group_id) where blind_group_id is not null;

alter table app.content_review_assignments enable row level security;

create policy "cra_reviewer_select_own"
  on app.content_review_assignments for select to authenticated
  using (reviewer_id = auth.uid());

create policy "cra_service_all"
  on app.content_review_assignments for all to service_role
  using (true) with check (true);


create table app.content_review_decisions (
  id                      uuid primary key default gen_random_uuid(),
  assignment_id           uuid not null references app.content_review_assignments(id) on delete cascade,
  content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade,
  reviewer_id             uuid not null references app.profiles(user_id) on delete cascade,
  supersedes_id           uuid references app.content_review_decisions(id) on delete set null,
  review_stage            text not null,
  tutor_score             integer,
  difficulty_label        text,
  diagnostic_flag         boolean not null default false,
  concern_codes           text[] not null default '{}',
  note                    text,
  topic_selections        jsonb,
  answer_key              text,
  answer_approval         text,
  canonical_decision      text,
  reader_decision         text,
  decision_payload        jsonb not null default '{}'::jsonb,
  decision_hash           text not null,
  submitted_at            timestamptz not null default now(),
  created_at              timestamptz not null default now(),
  created_by              uuid references app.profiles(user_id),
  constraint crd_stage_check check (review_stage in (
    'tutor_question', 'tutor_answer', 'tutor_frq_canonical', 'reader_question'
  )),
  constraint crd_tutor_score_check check (tutor_score is null or tutor_score in (1, 2, 3)),
  constraint crd_difficulty_check check (difficulty_label is null or difficulty_label in (
    'Easy', 'Moderately easy', 'Medium', 'Hard', 'Very hard'
  )),
  constraint crd_answer_key_check check (answer_key is null or answer_key in ('A', 'B', 'C', 'D')),
  constraint crd_answer_approval_check check (answer_approval is null or answer_approval in ('approved', 'rejected')),
  constraint crd_canonical_decision_check check (canonical_decision is null or canonical_decision in ('approved', 'rejected', 'edited')),
  constraint crd_reader_decision_check check (reader_decision is null or reader_decision in ('agree', 'disagree'))
);

create index crd_assignment_submitted_idx on app.content_review_decisions (assignment_id, submitted_at desc);
create index crd_reviewer_submitted_idx on app.content_review_decisions (reviewer_id, submitted_at desc);
create index crd_version_stage_idx on app.content_review_decisions (content_item_version_id, review_stage);
create index crd_supersedes_idx on app.content_review_decisions (supersedes_id) where supersedes_id is not null;

alter table app.content_review_decisions enable row level security;

create policy "crd_reviewer_select_own"
  on app.content_review_decisions for select to authenticated
  using (reviewer_id = auth.uid());

create policy "crd_reviewer_insert_own"
  on app.content_review_decisions for insert to authenticated
  with check (reviewer_id = auth.uid());

create policy "crd_service_all"
  on app.content_review_decisions for all to service_role
  using (true) with check (true);


create or replace function app.prevent_review_decision_mutation()
returns trigger
language plpgsql
as $$
begin
  raise exception
    'content_review_decisions rows are immutable after insert (id: %). '
    'To supersede a decision, insert a new row with supersedes_id referencing this row.',
    old.id;
end;
$$;

create trigger content_review_decisions_immutable
before update or delete on app.content_review_decisions
for each row execute function app.prevent_review_decision_mutation();


grant usage on schema app to authenticated, service_role;

grant select on app.content_review_assignments to authenticated;
grant select, insert on app.content_review_decisions to authenticated;

grant select, insert, update, delete on
  app.content_review_assignments,
  app.content_review_decisions
to service_role;

commit;
