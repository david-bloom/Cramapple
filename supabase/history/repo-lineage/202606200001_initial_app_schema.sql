-- Cramapple production schema, RLS, and core application tables.
-- Fresh production project: pcntajvbdfqhbeewmdry

begin;

create extension if not exists pgcrypto;

create schema if not exists app;

comment on schema app is 'Cramapple application schema';

-- Keep updated_at current for rows that support it.
create or replace function app.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ----------------------------
-- Profiles and roles
-- ----------------------------

create table if not exists app.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role text not null default 'student',
  timezone text,
  locale text,
  onboarding_completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_role_check
    check (role in ('student', 'content_author', 'validator', 'support', 'admin'))
);

create trigger profiles_set_updated_at
before update on app.profiles
for each row execute function app.set_updated_at();

create or replace function app.prevent_profile_role_change()
returns trigger
language plpgsql
as $$
begin
  if coalesce(current_setting('request.jwt.claim.role', true), '') <> 'service_role'
     and new.role <> old.role then
    raise exception 'role changes are server-side only';
  end if;
  return new;
end;
$$;

create trigger profiles_prevent_role_change
before update on app.profiles
for each row execute function app.prevent_profile_role_change();

alter table app.profiles enable row level security;

create policy "profiles_select_own"
on app.profiles
for select
to authenticated
using (auth.uid() = user_id);

create policy "profiles_update_own"
on app.profiles
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create or replace function app.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = app, public
as $$
begin
  insert into app.profiles (user_id, full_name, role)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'full_name', ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ),
    'student'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function app.handle_new_user();

-- ----------------------------
-- Exam packs
-- ----------------------------

create table if not exists app.exam_packs (
  id uuid primary key default gen_random_uuid(),
  exam_code text not null unique,
  exam_name text not null,
  subject text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger exam_packs_set_updated_at
before update on app.exam_packs
for each row execute function app.set_updated_at();

alter table app.exam_packs enable row level security;

create policy "exam_packs_select_published"
on app.exam_packs
for select
to authenticated
using (true);

create table if not exists app.exam_pack_versions (
  id uuid primary key default gen_random_uuid(),
  exam_pack_id uuid not null references app.exam_packs(id) on delete cascade,
  school_year text not null,
  official_exam_date date not null,
  status text not null,
  source_uri text,
  source_published_at date,
  released_at timestamptz,
  retired_at timestamptz,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint exam_pack_versions_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint exam_pack_versions_unique unique (exam_pack_id, school_year)
);

create trigger exam_pack_versions_set_updated_at
before update on app.exam_pack_versions
for each row execute function app.set_updated_at();

alter table app.exam_pack_versions enable row level security;

create policy "exam_pack_versions_select_published"
on app.exam_pack_versions
for select
to authenticated
using (status = 'published');

-- ----------------------------
-- Labels
-- ----------------------------

create table if not exists app.content_labels (
  id uuid primary key default gen_random_uuid(),
  exam_pack_id uuid not null references app.exam_packs(id) on delete cascade,
  label_key text not null,
  label_name text not null,
  label_type text not null,
  status text not null default 'draft',
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_labels_type_check
    check (label_type in ('topic', 'unit', 'skill', 'difficulty', 'workflow')),
  constraint content_labels_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint content_labels_unique unique (exam_pack_id, label_key)
);

create trigger content_labels_set_updated_at
before update on app.content_labels
for each row execute function app.set_updated_at();

alter table app.content_labels enable row level security;

create policy "content_labels_select_published"
on app.content_labels
for select
to authenticated
using (status = 'published');

-- ----------------------------
-- Content items and versions
-- ----------------------------

create table if not exists app.content_items (
  id uuid primary key default gen_random_uuid(),
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete cascade,
  content_key text not null,
  item_type text not null,
  title text not null,
  status text not null default 'draft',
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_items_type_check
    check (item_type in ('mcq', 'frq', 'quantitative')),
  constraint content_items_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint content_items_unique_key unique (exam_pack_version_id, content_key)
);

create trigger content_items_set_updated_at
before update on app.content_items
for each row execute function app.set_updated_at();

alter table app.content_items enable row level security;

create policy "content_items_select_published"
on app.content_items
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.exam_pack_versions epv
    where epv.id = content_items.exam_pack_version_id
      and epv.status = 'published'
  )
);

create table if not exists app.content_item_versions (
  id uuid primary key default gen_random_uuid(),
  content_item_id uuid not null references app.content_items(id) on delete cascade,
  version_num integer not null,
  stem text not null,
  stimulus text,
  prompt_json jsonb not null default '{}'::jsonb,
  explanation text,
  help_text text,
  content_hash text not null,
  status text not null default 'draft',
  approved_at timestamptz,
  approved_by uuid references app.profiles(user_id),
  published_at timestamptz,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint content_item_versions_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint content_item_versions_unique unique (content_item_id, version_num)
);

create trigger content_item_versions_set_updated_at
before update on app.content_item_versions
for each row execute function app.set_updated_at();

alter table app.content_item_versions enable row level security;

create policy "content_item_versions_select_published"
on app.content_item_versions
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    where ci.id = content_item_versions.content_item_id
      and ci.status = 'published'
      and epv.status = 'published'
  )
);

create table if not exists app.mcq_choices (
  id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade,
  choice_key text not null,
  choice_text text not null,
  is_correct boolean not null default false,
  rationale text,
  created_at timestamptz not null default now(),
  constraint mcq_choices_unique unique (content_item_version_id, choice_key)
);

alter table app.mcq_choices enable row level security;

create policy "mcq_choices_select_published"
on app.mcq_choices
for select
to authenticated
using (
  exists (
    select 1
    from app.content_item_versions civ
    join app.content_items ci on ci.id = civ.content_item_id
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    where civ.id = mcq_choices.content_item_version_id
      and civ.status = 'published'
      and ci.status = 'published'
      and epv.status = 'published'
  )
);

create table if not exists app.frq_criteria (
  id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade,
  criterion_key text not null,
  learner_facing_text text not null,
  points_possible integer not null,
  evidence_requirements text,
  minimum_fix text,
  accepted_variants jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  constraint frq_criteria_points_check check (points_possible > 0),
  constraint frq_criteria_unique unique (content_item_version_id, criterion_key)
);

alter table app.frq_criteria enable row level security;

create policy "frq_criteria_select_published"
on app.frq_criteria
for select
to authenticated
using (
  exists (
    select 1
    from app.content_item_versions civ
    join app.content_items ci on ci.id = civ.content_item_id
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    where civ.id = frq_criteria.content_item_version_id
      and civ.status = 'published'
      and ci.status = 'published'
      and epv.status = 'published'
  )
);

create table if not exists app.content_item_labels (
  content_item_id uuid not null references app.content_items(id) on delete cascade,
  content_label_id uuid not null references app.content_labels(id) on delete cascade,
  primary key (content_item_id, content_label_id)
);

alter table app.content_item_labels enable row level security;

create policy "content_item_labels_select_published"
on app.content_item_labels
for select
to authenticated
using (
  exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    where ci.id = content_item_labels.content_item_id
      and ci.status = 'published'
      and epv.status = 'published'
  )
);

-- ----------------------------
-- Sessions and attempts
-- ----------------------------

create table if not exists app.learning_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  entry_path text not null,
  session_mode text not null,
  available_minutes integer not null,
  status text not null default 'active',
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint learning_sessions_entry_path_check
    check (entry_path in ('recommend', 'topic', 'check_work', 'bring_question')),
  constraint learning_sessions_session_mode_check
    check (session_mode in ('quick', 'focused', 'buckle_down')),
  constraint learning_sessions_status_check
    check (status in ('active', 'completed', 'archived'))
);

create trigger learning_sessions_set_updated_at
before update on app.learning_sessions
for each row execute function app.set_updated_at();

alter table app.learning_sessions enable row level security;

create policy "learning_sessions_owner_select"
on app.learning_sessions
for select
to authenticated
using (auth.uid() = user_id);

create policy "learning_sessions_owner_insert"
on app.learning_sessions
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "learning_sessions_owner_update"
on app.learning_sessions
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create table if not exists app.attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  learning_session_id uuid references app.learning_sessions(id) on delete set null,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  content_item_version_id uuid not null references app.content_item_versions(id),
  attempt_mode text not null,
  status text not null default 'draft',
  assistance_state text not null default 'independent',
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  graded_at timestamptz,
  score_points integer,
  score_possible integer,
  confidence_level text,
  result_state text,
  result_summary text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint attempts_mode_check
    check (attempt_mode in ('mcq', 'frq', 'quantitative')),
  constraint attempts_status_check
    check (status in ('draft', 'submitted', 'grading', 'graded', 'uncertain', 'failed')),
  constraint attempts_assistance_check
    check (assistance_state in ('independent', 'coached', 'exam_practice'))
);

create trigger attempts_set_updated_at
before update on app.attempts
for each row execute function app.set_updated_at();

alter table app.attempts enable row level security;

create policy "attempts_owner_select"
on app.attempts
for select
to authenticated
using (auth.uid() = user_id);

create policy "attempts_owner_insert"
on app.attempts
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "attempts_owner_update_draft"
on app.attempts
for update
to authenticated
using (auth.uid() = user_id and status in ('draft', 'failed'))
with check (auth.uid() = user_id);

create table if not exists app.attempt_responses (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  part_key text not null,
  response_text text,
  response_json jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint attempt_responses_unique unique (attempt_id, part_key)
);

create trigger attempt_responses_set_updated_at
before update on app.attempt_responses
for each row execute function app.set_updated_at();

alter table app.attempt_responses enable row level security;

create policy "attempt_responses_owner_select"
on app.attempt_responses
for select
to authenticated
using (
  exists (
    select 1
    from app.attempts a
    where a.id = attempt_responses.attempt_id
      and a.user_id = auth.uid()
  )
);

create policy "attempt_responses_owner_write_draft"
on app.attempt_responses
for insert
to authenticated
with check (
  exists (
    select 1
    from app.attempts a
    where a.id = attempt_responses.attempt_id
      and a.user_id = auth.uid()
      and a.status in ('draft', 'failed')
  )
);

create policy "attempt_responses_owner_update_draft"
on app.attempt_responses
for update
to authenticated
using (
  exists (
    select 1
    from app.attempts a
    where a.id = attempt_responses.attempt_id
      and a.user_id = auth.uid()
      and a.status in ('draft', 'failed')
  )
)
with check (
  exists (
    select 1
    from app.attempts a
    where a.id = attempt_responses.attempt_id
      and a.user_id = auth.uid()
      and a.status in ('draft', 'failed')
  )
);

create table if not exists app.attempt_criterion_results (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  criterion_key text not null,
  status text not null,
  points_awarded integer not null default 0,
  evidence_quote text,
  decision_explanation text,
  minimum_fix text,
  evaluator_version text not null,
  created_at timestamptz not null default now(),
  constraint attempt_criterion_results_status_check
    check (status in ('earned', 'not_yet_earned', 'unable_to_determine', 'not_applicable'))
);

alter table app.attempt_criterion_results enable row level security;

create policy "criterion_results_owner_select"
on app.attempt_criterion_results
for select
to authenticated
using (
  exists (
    select 1
    from app.attempts a
    where a.id = attempt_criterion_results.attempt_id
      and a.user_id = auth.uid()
  )
);

create table if not exists app.progress_snapshots (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  snapshot_kind text not null,
  snapshot_json jsonb not null,
  source_version text,
  generated_at timestamptz not null default now(),
  constraint progress_snapshots_kind_check
    check (snapshot_kind in ('daily', 'weekly', 'on_demand'))
);

alter table app.progress_snapshots enable row level security;

create policy "progress_snapshots_owner_select"
on app.progress_snapshots
for select
to authenticated
using (auth.uid() = user_id);

create table if not exists app.audit_events (
  id uuid primary key default gen_random_uuid(),
  actor_user_id uuid references app.profiles(user_id),
  subject_user_id uuid references app.profiles(user_id),
  object_type text not null,
  object_id uuid,
  action text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table app.audit_events enable row level security;

create policy "audit_events_service_only"
on app.audit_events
for select
to service_role
using (true);

-- ----------------------------
-- Grants
-- ----------------------------

grant usage on schema app to authenticated, service_role;

grant select on
  app.exam_packs,
  app.exam_pack_versions,
  app.content_labels,
  app.content_items,
  app.content_item_versions,
  app.mcq_choices,
  app.frq_criteria,
  app.content_item_labels,
  app.learning_sessions,
  app.attempts,
  app.attempt_responses,
  app.attempt_criterion_results,
  app.progress_snapshots
to authenticated;

grant select, update on app.profiles to authenticated;
grant select, insert, update on app.learning_sessions to authenticated;
grant select, insert, update on app.attempts to authenticated;
grant select, insert, update on app.attempt_responses to authenticated;

grant select, insert, update, delete on app.profiles to service_role;
grant select, insert, update, delete on app.exam_packs to service_role;
grant select, insert, update, delete on app.exam_pack_versions to service_role;
grant select, insert, update, delete on app.content_labels to service_role;
grant select, insert, update, delete on app.content_items to service_role;
grant select, insert, update, delete on app.content_item_versions to service_role;
grant select, insert, update, delete on app.mcq_choices to service_role;
grant select, insert, update, delete on app.frq_criteria to service_role;
grant select, insert, update, delete on app.content_item_labels to service_role;
grant select, insert, update, delete on app.learning_sessions to service_role;
grant select, insert, update, delete on app.attempts to service_role;
grant select, insert, update, delete on app.attempt_responses to service_role;
grant select, insert, update, delete on app.attempt_criterion_results to service_role;
grant select, insert, update, delete on app.progress_snapshots to service_role;
grant select, insert, update, delete on app.audit_events to service_role;

commit;
