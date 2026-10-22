-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: Production-only tables and their supporting objects, rebuilt on Development from
-- Production's live catalogs (pg_attribute, pg_constraint, pg_indexes, pg_policies, grants, 2026-10-22).
-- Sources on Production's ledger: gold_set_verification (20260803120000) and its follow-ups,
-- question_reports (20260806013726), content_taxonomy_validation_decisions (20260824130055),
-- content_item_difficulty (20260924130018). None of these has a migration file on main.
-- Also: the http extension (Production: 1.6 in extensions) and the ci_servable_items_reader login
-- role (Production: login, noinherit, schema usage on app and public, execute on the census
-- functions). The role is created without a password; CI credentials are environment config.
-- Idempotent.

create extension if not exists http with schema extensions;

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'ci_servable_items_reader') then
    create role ci_servable_items_reader login noinherit;
  end if;
end $$;
grant usage on schema app to ci_servable_items_reader;
grant usage on schema public to ci_servable_items_reader;

-- gold-set reader workflow (ruling 1: frozen review area; parity only)
create table if not exists app.gold_set_answers (
  gold_set_answer_id uuid not null default gen_random_uuid(),
  set_key text not null,
  content_item_version_id uuid not null,
  answer_type text not null,
  answer_text text not null,
  writer_family text not null,
  script jsonb not null,
  script_hash text not null,
  route text not null,
  item_content_hash text not null,
  created_at timestamp with time zone not null default now(),
  is_fixture boolean not null default false,
  constraint gold_set_answers_pkey primary key (gold_set_answer_id),
  constraint gold_set_answers_content_item_version_id_fkey foreign key (content_item_version_id) references app.content_item_versions(id) on delete restrict,
  constraint gold_set_answers_answer_text_check check ((char_length(btrim(answer_text)) > 0)),
  constraint gold_set_answers_answer_type_check check ((answer_type = any (array['A1'::text, 'A2'::text, 'A3'::text, 'A4'::text, 'A5'::text, 'A6'::text, 'A7'::text, 'A8'::text]))),
  constraint gold_set_answers_route_check check ((route = any (array['provisional_accept'::text, 'reader_queue'::text]))),
  constraint gold_set_answers_script_object_check check ((jsonb_typeof(script) = 'object'::text)),
  constraint gold_set_answers_set_key_check check ((set_key = any (array['A'::text, 'B'::text, 'C'::text]))),
  constraint gold_set_answers_writer_family_check check ((writer_family = any (array['anthropic'::text, 'google'::text, 'moonshot'::text, 'deepseek'::text, 'bank'::text])))
);
comment on column app.gold_set_answers.writer_family is 'Protocol R1/R2: never openai. A1 answers come from the bank (canonical_answer_1).';
comment on column app.gold_set_answers.is_fixture is 'QA scaffolding, not part of any gold set. Excluded from admin aggregate views; still visible to the reviewer it is assigned to.';
create index if not exists gold_set_answers_real_idx on app.gold_set_answers using btree (gold_set_answer_id) where (not is_fixture);
create index if not exists gold_set_answers_version_idx on app.gold_set_answers using btree (content_item_version_id);
alter table app.gold_set_answers enable row level security;
alter table app.gold_set_answers force row level security;
grant select, insert, update, delete on app.gold_set_answers to service_role;

create table if not exists app.gold_set_elements (
  gold_set_element_id uuid not null default gen_random_uuid(),
  frq_criterion_id uuid not null,
  content_item_version_id uuid not null,
  element_index integer not null,
  element_label text not null,
  confirmed_by uuid,
  confirmed_at timestamp with time zone,
  created_at timestamp with time zone not null default now(),
  constraint gold_set_elements_pkey primary key (gold_set_element_id),
  constraint gold_set_elements_unique_index unique (frq_criterion_id, element_index),
  constraint gold_set_elements_confirmed_by_fkey foreign key (confirmed_by) references app.profiles(user_id),
  constraint gold_set_elements_content_item_version_id_fkey foreign key (content_item_version_id) references app.content_item_versions(id) on delete restrict,
  constraint gold_set_elements_frq_criterion_id_fkey foreign key (frq_criterion_id) references app.frq_criteria(id) on delete cascade,
  constraint gold_set_elements_confirmation_check check (((confirmed_by is null) = (confirmed_at is null))),
  constraint gold_set_elements_index_check check ((element_index > 0)),
  constraint gold_set_elements_label_check check ((char_length(btrim(element_label)) > 0))
);
create index if not exists gold_set_elements_version_idx on app.gold_set_elements using btree (content_item_version_id, element_index);
alter table app.gold_set_elements enable row level security;
alter table app.gold_set_elements force row level security;
grant select, insert, update, delete on app.gold_set_elements to service_role;

create table if not exists app.gold_set_verification_assignments (
  gold_set_verification_assignment_id uuid not null default gen_random_uuid(),
  gold_set_answer_id uuid not null,
  reviewer_id uuid not null,
  seq integer not null,
  status text not null default 'pending'::text,
  assigned_at timestamp with time zone not null default now(),
  submitted_at timestamp with time zone,
  completed_by uuid,
  constraint gold_set_verification_assignments_pkey primary key (gold_set_verification_assignment_id),
  constraint gold_set_verification_assignments_unique_answer unique (reviewer_id, gold_set_answer_id),
  constraint gold_set_verification_assignments_unique_seq unique (reviewer_id, seq) deferrable initially deferred,
  constraint gold_set_verification_assignments_completed_by_fkey foreign key (completed_by) references app.profiles(user_id),
  constraint gold_set_verification_assignments_gold_set_answer_id_fkey foreign key (gold_set_answer_id) references app.gold_set_answers(gold_set_answer_id) on delete cascade,
  constraint gold_set_verification_assignments_reviewer_id_fkey foreign key (reviewer_id) references app.profiles(user_id) on delete cascade,
  constraint gold_set_verification_assignments_seq_check check ((seq > 0)),
  constraint gold_set_verification_assignments_status_check check ((status = any (array['pending'::text, 'submitted'::text, 'flagged_contaminated'::text]))),
  constraint gold_set_verification_assignments_terminal_check check ((((status = 'pending'::text) and (submitted_at is null)) or ((status <> 'pending'::text) and (submitted_at is not null))))
);
comment on column app.gold_set_verification_assignments.completed_by is 'Who actually submitted the marks. Usually equals reviewer_id; differs when an admin completed someone else''s assignment via the CC-marking path.';
create index if not exists gold_set_verification_assignments_queue_idx on app.gold_set_verification_assignments using btree (reviewer_id, status, seq);
alter table app.gold_set_verification_assignments enable row level security;
alter table app.gold_set_verification_assignments force row level security;
grant select, insert, update, delete on app.gold_set_verification_assignments to service_role;

create table if not exists app.gold_set_element_marks (
  gold_set_element_mark_id uuid not null default gen_random_uuid(),
  gold_set_verification_assignment_id uuid not null,
  gold_set_element_id uuid not null,
  present boolean not null,
  evidence_quote text,
  created_at timestamp with time zone not null default now(),
  constraint gold_set_element_marks_pkey primary key (gold_set_element_mark_id),
  constraint gold_set_element_marks_unique_element unique (gold_set_verification_assignment_id, gold_set_element_id),
  constraint gold_set_element_marks_gold_set_element_id_fkey foreign key (gold_set_element_id) references app.gold_set_elements(gold_set_element_id) on delete restrict,
  constraint gold_set_element_marks_gold_set_verification_assignment_id_fkey foreign key (gold_set_verification_assignment_id) references app.gold_set_verification_assignments(gold_set_verification_assignment_id) on delete cascade,
  constraint gold_set_element_marks_evidence_check check (((present and (char_length(btrim(coalesce(evidence_quote, ''::text))) > 0)) or ((not present) and (coalesce(btrim(evidence_quote), ''::text) = ''::text)))),
  constraint gold_set_element_marks_quote_length_check check ((char_length(coalesce(evidence_quote, ''::text)) <= 300))
);
alter table app.gold_set_element_marks enable row level security;
alter table app.gold_set_element_marks force row level security;
grant select, insert on app.gold_set_element_marks to service_role;

-- content_item_difficulty (DECISION-0061)
create table if not exists app.content_item_difficulty (
  content_item_difficulty_id uuid not null default gen_random_uuid(),
  content_item_version_id uuid not null,
  difficulty text not null,
  basis text not null,
  attainment_ratio numeric,
  ratio_source text,
  subject_cut_points jsonb,
  source_value text,
  rationale text,
  confidence text,
  proposal_run text not null,
  created_at timestamp with time zone not null default now(),
  created_by uuid,
  constraint content_item_difficulty_pkey primary key (content_item_difficulty_id),
  constraint content_item_difficulty_content_item_version_id_key unique (content_item_version_id),
  constraint content_item_difficulty_content_item_version_id_fkey foreign key (content_item_version_id) references app.content_item_versions(id) on delete cascade,
  constraint content_item_difficulty_created_by_fkey foreign key (created_by) references app.profiles(user_id),
  constraint content_item_difficulty_basis_check check ((basis = any (array['calibrated_task_verb'::text, 'calibrated_judgement'::text, 'translated'::text, 'normalised_casing'::text, 'undetermined'::text]))),
  constraint content_item_difficulty_confidence_check check (((confidence is null) or (confidence = any (array['high'::text, 'medium'::text, 'low'::text])))),
  constraint content_item_difficulty_difficulty_check check ((difficulty = any (array['Easy'::text, 'Medium'::text, 'Hard'::text])))
);
comment on table app.content_item_difficulty is 'Per-item difficulty: the operative three-level band plus the attainment ratio, cut points and raw prior value it was derived from, so banding stays re-derivable at read time. DECISION-0061.';
create index if not exists content_item_difficulty_band_idx on app.content_item_difficulty using btree (difficulty);
alter table app.content_item_difficulty enable row level security;
drop policy if exists content_item_difficulty_service_all on app.content_item_difficulty;
create policy content_item_difficulty_service_all on app.content_item_difficulty as permissive for all to service_role using (true) with check (true);
grant select, insert, update, delete on app.content_item_difficulty to service_role;

-- content_taxonomy_validation_decisions, plus the FK from content_taxonomy_labels that Production carries
create table if not exists app.content_taxonomy_validation_decisions (
  validation_decision_id uuid not null default gen_random_uuid(),
  content_taxonomy_label_id uuid not null,
  decided_by uuid not null,
  decided_at timestamp with time zone not null default now(),
  decision text not null,
  decision_source text not null default 'ui_review'::text,
  reviewed_primary_unit integer,
  reviewed_required_units integer[],
  notes text,
  created_at timestamp with time zone not null default now(),
  constraint content_taxonomy_validation_decisions_pkey primary key (validation_decision_id),
  constraint content_taxonomy_validation_deci_content_taxonomy_label_id_fkey foreign key (content_taxonomy_label_id) references app.content_taxonomy_labels(content_taxonomy_label_id) on delete cascade,
  constraint content_taxonomy_validation_decisions_decided_by_fkey foreign key (decided_by) references app.profiles(user_id),
  constraint content_taxonomy_validation_decisions_decision_check check ((decision = any (array['confirmed'::text, 'corrected'::text, 'rejected'::text]))),
  constraint content_taxonomy_validation_decisions_decision_source_check check ((decision_source = any (array['chat_review'::text, 'ui_review'::text, 'automated_spot_check'::text])))
);
create index if not exists content_taxonomy_validation_decisions_label_idx on app.content_taxonomy_validation_decisions using btree (content_taxonomy_label_id);
alter table app.content_taxonomy_validation_decisions enable row level security;
drop policy if exists content_taxonomy_validation_decisions_service_all on app.content_taxonomy_validation_decisions;
create policy content_taxonomy_validation_decisions_service_all on app.content_taxonomy_validation_decisions as permissive for all to service_role using (true) with check (true);
grant select, insert, update, delete on app.content_taxonomy_validation_decisions to service_role;
do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'content_taxonomy_labels_validation_decision_id_fkey') then
    alter table app.content_taxonomy_labels
      add constraint content_taxonomy_labels_validation_decision_id_fkey
      foreign key (validation_decision_id) references app.content_taxonomy_validation_decisions(validation_decision_id) on delete restrict;
  end if;
end $$;

-- public.question_reports (student-facing insert policy)
create table if not exists public.question_reports (
  id uuid not null default gen_random_uuid(),
  question_id text not null,
  session_id uuid,
  student_id uuid,
  reason text not null,
  note text,
  status text not null default 'open'::text,
  created_at timestamp with time zone not null default now(),
  constraint question_reports_pkey primary key (id),
  constraint question_reports_reason_check check ((reason = any (array['confusing'::text, 'not_taught_in_unit'::text, 'image_issue'::text, 'calculation_incorrect'::text, 'other'::text]))),
  constraint question_reports_status_check check ((status = any (array['open'::text, 'triaged'::text, 'resolved'::text, 'dismissed'::text])))
);
create index if not exists question_reports_status_created_idx on public.question_reports using btree (status, created_at desc);
alter table public.question_reports enable row level security;
drop policy if exists "Students can report questions" on public.question_reports;
create policy "Students can report questions" on public.question_reports as permissive for insert to authenticated with check (((student_id = auth.uid()) or (student_id is null)));
grant select, insert, update, delete, truncate, references, trigger on public.question_reports to anon, authenticated, service_role;
