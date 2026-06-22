-- Full content-governance logical model for production content operations.

begin;

create extension if not exists pgcrypto;

create table if not exists app.source_records (
  source_id uuid not null,
  source_version_id uuid primary key default gen_random_uuid(),
  version_sequence integer not null check (version_sequence >= 1),
  title text not null check (char_length(title) between 1 and 500),
  publisher text not null check (char_length(publisher) between 1 and 300),
  authors text[] not null default '{}'::text[],
  source_type text not null,
  canonical_uri text,
  publication_date date,
  source_update_date date,
  retrieved_at timestamptz not null default now(),
  effective_from date,
  effective_to date,
  exam_id uuid,
  school_year text,
  scope_statement text not null check (char_length(scope_statement) between 1 and 2000),
  source_excerpt_locator text,
  stored_object_id uuid,
  content_sha256 text not null,
  authority_tier integer not null check (authority_tier in (1, 2, 3, 4)),
  refresh_class text not null,
  next_refresh_due_at timestamptz not null,
  supersedes_source_version_id uuid references app.source_records(source_version_id) on delete set null,
  provenance_status text not null default 'draft',
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.source_records enable row level security;

create table if not exists app.rights_records (
  rights_record_id uuid primary key default gen_random_uuid(),
  source_version_id uuid not null references app.source_records(source_version_id) on delete cascade,
  rights_status text not null,
  permitted_uses text[] not null default '{}'::text[],
  prohibited_uses text[] not null default '{}'::text[],
  territory text[] not null default '{}'::text[],
  audience_restrictions text[] not null default '{}'::text[],
  license_or_permission_id text,
  license_effective_at timestamptz,
  license_expires_at timestamptz,
  attribution_required boolean not null default false,
  attribution_text text,
  reviewed_by uuid references app.profiles(user_id),
  reviewed_at timestamptz not null default now(),
  legal_approval_required boolean not null default false,
  legal_approval_id uuid,
  next_review_due_at timestamptz not null,
  notes text,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.rights_records enable row level security;

create table if not exists app.artifact_versions (
  artifact_id uuid not null,
  artifact_version_id uuid primary key default gen_random_uuid(),
  artifact_type text not null,
  exam_id uuid not null,
  school_year text not null,
  version_sequence integer not null check (version_sequence >= 1),
  semantic_version text not null,
  language text not null,
  payload_schema_version text not null,
  payload jsonb not null,
  payload_sha256 text not null,
  risk_class text not null,
  change_class text not null,
  change_summary text not null check (char_length(change_summary) between 1 and 2000),
  change_rationale text not null check (char_length(change_rationale) between 1 and 4000),
  authored_by uuid[] not null default '{}'::uuid[],
  authored_at timestamptz not null default now(),
  predecessor_version_id uuid references app.artifact_versions(artifact_version_id) on delete set null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.artifact_versions enable row level security;

create table if not exists app.artifact_state_events (
  artifact_state_event_id uuid primary key default gen_random_uuid(),
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  prior_state text,
  new_state text not null,
  reason_code text not null,
  evidence_record_ids uuid[] not null default '{}'::uuid[],
  changed_by uuid references app.profiles(user_id),
  changed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.artifact_state_events enable row level security;

create or replace function app.project_artifact_state(p_artifact_version_id uuid)
returns text
language sql
stable
as $$
  select coalesce(
    (
      select ase.new_state
      from app.artifact_state_events ase
      where ase.artifact_version_id = p_artifact_version_id
      order by ase.changed_at desc, ase.artifact_state_event_id desc
      limit 1
    ),
    'draft'
  );
$$;

create table if not exists app.provenance_claims (
  claim_id uuid primary key default gen_random_uuid(),
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  claim_path text not null,
  claim_text text not null check (char_length(claim_text) between 1 and 4000),
  claim_kind text not null,
  source_version_ids uuid[] not null default '{}'::uuid[],
  derivation text not null,
  formula text,
  assumptions text[] not null default '{}'::text[],
  confidence text not null,
  verified_by uuid references app.profiles(user_id),
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.provenance_claims enable row level security;

create table if not exists app.artifact_dependencies (
  dependency_id uuid primary key default gen_random_uuid(),
  from_artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  to_artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  dependency_type text not null,
  impact_mode text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.artifact_dependencies enable row level security;

create table if not exists app.question_coverage_targets (
  coverage_target_id uuid primary key default gen_random_uuid(),
  exam_id uuid not null,
  subject_id uuid not null,
  scope_type text not null,
  taxonomy_scope_id uuid not null,
  school_year text not null,
  mcq_target integer not null default 0 check (mcq_target >= 0),
  short_frq_prompt_target integer not null default 0 check (short_frq_prompt_target >= 0),
  long_frq_prompt_target integer not null default 0 check (long_frq_prompt_target >= 0),
  required_skill_ids uuid[] not null default '{}'::uuid[],
  required_representation_types text[] not null default '{}'::text[],
  required_difficulty_bands text[] not null default '{}'::text[],
  approved_by uuid[] not null default '{}'::uuid[],
  effective_at timestamptz not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.question_coverage_targets enable row level security;

create table if not exists app.authoring_briefs (
  brief_id uuid primary key default gen_random_uuid(),
  brief_version_id uuid not null unique,
  exam_id uuid not null,
  school_year text not null,
  taxonomy_scope_ids uuid[] not null default '{}'::uuid[],
  assessable_skill_target_ids uuid[] not null default '{}'::uuid[],
  task_verbs text[] not null default '{}'::text[],
  question_form text not null,
  intended_use text not null,
  intended_difficulty text not null,
  approved_source_version_ids uuid[] not null default '{}'::uuid[],
  stimulus_requirements jsonb not null default '{}'::jsonb,
  reasoning_requirements jsonb not null default '{}'::jsonb,
  accessibility_requirements jsonb not null default '{}'::jsonb,
  prohibited_similarities text[] not null default '{}'::text[],
  deliverable_schema_version text not null,
  brief_sha256 text not null,
  approved_by uuid[] not null default '{}'::uuid[],
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.authoring_briefs enable row level security;

create table if not exists app.author_qualifications (
  author_qualification_id uuid primary key default gen_random_uuid(),
  author_id uuid not null references app.profiles(user_id) on delete cascade,
  exam_ids uuid[] not null default '{}'::uuid[],
  school_years text[] not null default '{}'::text[],
  taxonomy_scope_ids uuid[] not null default '{}'::uuid[],
  evidence_record_ids uuid[] not null default '{}'::uuid[],
  qualification_policy_version_id uuid not null,
  effective_at timestamptz not null,
  expires_at timestamptz not null,
  status text not null,
  suspension_reason text,
  granted_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.author_qualifications enable row level security;

create table if not exists app.author_commissions (
  commission_id uuid primary key default gen_random_uuid(),
  brief_version_id uuid not null,
  author_id uuid not null references app.profiles(user_id) on delete cascade,
  author_qualification_id uuid not null references app.author_qualifications(author_qualification_id) on delete restrict,
  agreement_record_id uuid not null,
  compensation_terms_record_id uuid not null,
  commissioned_deliverables text[] not null default '{}'::text[],
  assigned_at timestamptz not null default now(),
  due_at timestamptz not null,
  status text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.author_commissions enable row level security;

create table if not exists app.content_rights_releases (
  release_id uuid primary key default gen_random_uuid(),
  author_or_seller_id uuid not null references app.profiles(user_id),
  commission_id uuid references app.author_commissions(commission_id) on delete set null,
  covered_artifact_ids uuid[] not null default '{}'::uuid[],
  compensation_record_id uuid not null,
  ownership_mode text not null,
  rights_granted text[] not null default '{}'::text[],
  worldwide boolean not null default true,
  perpetual boolean not null default true,
  originality_warranty boolean not null default true,
  no_conflicting_rights_warranty boolean not null default true,
  source_and_asset_disclosure_required boolean not null default true,
  restricted_material_prohibited boolean not null default true,
  further_payment_required boolean not null default false,
  signed_by_creator uuid not null references app.profiles(user_id),
  signed_by_cramapple uuid not null references app.profiles(user_id),
  signed_at timestamptz not null default now(),
  agreement_sha256 text not null,
  counsel_approved_template_version_id uuid not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.content_rights_releases enable row level security;

create table if not exists app.originality_attestations (
  attestation_id uuid primary key default gen_random_uuid(),
  commission_id uuid not null references app.author_commissions(commission_id) on delete cascade,
  artifact_version_ids uuid[] not null default '{}'::uuid[],
  independently_authored boolean not null,
  no_official_or_third_party_adaptation boolean not null,
  no_restricted_material_use boolean not null,
  prior_publication_or_assignment_disclosed boolean not null,
  factual_source_version_ids uuid[] not null default '{}'::uuid[],
  asset_rights_record_ids uuid[] not null default '{}'::uuid[],
  disclosed_collaborator_ids uuid[] not null default '{}'::uuid[],
  disclosed_tools text[] not null default '{}'::text[],
  statement text not null,
  signed_by uuid not null references app.profiles(user_id),
  signed_at timestamptz not null default now(),
  attestation_sha256 text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.originality_attestations enable row level security;

create table if not exists app.ai_variant_runs (
  variant_run_id uuid primary key default gen_random_uuid(),
  base_artifact_version_ids uuid[] not null default '{}'::uuid[],
  content_rights_release_ids uuid[] not null default '{}'::uuid[],
  authoring_brief_version_id uuid not null,
  prompt_version_id uuid not null references app.prompt_versions(id) on delete restrict,
  model_configuration_version_id uuid not null,
  parameter_payload jsonb not null default '{}'::jsonb,
  invariant_requirements jsonb not null default '{}'::jsonb,
  permitted_changes jsonb not null default '{}'::jsonb,
  approved_source_version_ids uuid[] not null default '{}'::uuid[],
  generated_candidate_version_ids uuid[] not null default '{}'::uuid[],
  run_input_sha256 text not null,
  run_output_sha256 text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  holdout_policy_version_id uuid,
  holdout_result text not null default 'pending'
);

alter table app.ai_variant_runs enable row level security;

create table if not exists app.question_use_assignments (
  use_assignment_id uuid primary key default gen_random_uuid(),
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  use_class text not null,
  population_scope jsonb,
  exposure_summary jsonb not null default '{}'::jsonb,
  decision_record_ids uuid[] not null default '{}'::uuid[],
  effective_at timestamptz not null default now(),
  ended_at timestamptz,
  replaced_by_artifact_version_id uuid references app.artifact_versions(artifact_version_id) on delete set null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.question_use_assignments enable row level security;

create table if not exists app.validator_qualifications (
  qualification_id uuid primary key default gen_random_uuid(),
  reviewer_id uuid not null references app.profiles(user_id) on delete cascade,
  qualification_type text not null,
  exam_ids uuid[] not null default '{}'::uuid[],
  school_years text[] not null default '{}'::text[],
  taxonomy_scope_ids uuid[] not null default '{}'::uuid[],
  artifact_types text[] not null default '{}'::text[],
  environment_scope text[] not null default '{}'::text[],
  evidence_record_ids uuid[] not null default '{}'::uuid[],
  qualification_policy_version_id uuid not null,
  granted_by uuid not null references app.profiles(user_id),
  granted_at timestamptz not null default now(),
  effective_at timestamptz not null,
  expires_at timestamptz not null,
  status text not null,
  suspension_reason text,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.validator_qualifications enable row level security;

create table if not exists app.validator_entitlements (
  entitlement_id uuid primary key default gen_random_uuid(),
  reviewer_id uuid not null references app.profiles(user_id) on delete cascade,
  qualification_id uuid not null references app.validator_qualifications(qualification_id) on delete cascade,
  allowed_actions text[] not null default '{}'::text[],
  exam_ids uuid[] not null default '{}'::uuid[],
  artifact_types text[] not null default '{}'::text[],
  assignment_ids uuid[] not null default '{}'::uuid[],
  environment_scope text[] not null default '{}'::text[],
  effective_at timestamptz not null,
  expires_at timestamptz not null,
  granted_by uuid not null references app.profiles(user_id),
  status text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.validator_entitlements enable row level security;

create table if not exists app.review_assignments (
  assignment_id uuid primary key default gen_random_uuid(),
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  review_type text not null,
  required_qualification_id uuid not null references app.validator_qualifications(qualification_id) on delete restrict,
  assigned_reviewer_id uuid not null references app.profiles(user_id),
  blind_group_id uuid,
  assigned_at timestamptz not null default now(),
  due_at timestamptz not null,
  status text not null,
  conflict_attestation boolean not null default false,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.review_assignments enable row level security;

create table if not exists app.review_decisions (
  review_decision_id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references app.review_assignments(assignment_id) on delete cascade,
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  checklist_version_id uuid not null,
  decision text not null,
  blocker_codes text[] not null default '{}'::text[],
  non_blocking_codes text[] not null default '{}'::text[],
  criterion_results jsonb not null default '{}'::jsonb,
  rationale text not null check (char_length(rationale) between 1 and 8000),
  submitted_at timestamptz not null default now(),
  decision_sha256 text not null,
  supersedes_review_decision_id uuid references app.review_decisions(review_decision_id) on delete set null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.review_decisions enable row level security;

create table if not exists app.validation_suites (
  suite_id uuid primary key default gen_random_uuid(),
  suite_version_id uuid not null unique,
  name text not null,
  exam_id uuid not null,
  suite_type text not null,
  coverage_requirements jsonb not null default '{}'::jsonb,
  case_ids uuid[] not null default '{}'::uuid[],
  split text not null,
  content_sha256 text not null,
  approved_by uuid[] not null default '{}'::uuid[],
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.validation_suites enable row level security;

create table if not exists app.validation_cases (
  case_id uuid primary key default gen_random_uuid(),
  case_version_id uuid not null unique,
  case_type text not null,
  input_payload jsonb not null default '{}'::jsonb,
  expected_payload jsonb not null default '{}'::jsonb,
  source_artifact_version_ids uuid[] not null default '{}'::uuid[],
  gold_status text not null,
  sensitivity text not null,
  content_sha256 text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.validation_cases enable row level security;

create table if not exists app.validation_runs (
  run_id uuid primary key default gen_random_uuid(),
  suite_version_id uuid not null references app.validation_suites(suite_version_id) on delete cascade,
  target_version_ids uuid[] not null default '{}'::uuid[],
  environment text not null,
  runner_type text not null,
  prompt_version_id uuid references app.prompt_versions(id) on delete set null,
  model_configuration_version_id uuid,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  status text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.validation_runs enable row level security;

create table if not exists app.validation_results (
  result_id uuid primary key default gen_random_uuid(),
  run_id uuid not null references app.validation_runs(run_id) on delete cascade,
  case_version_id uuid not null references app.validation_cases(case_version_id) on delete cascade,
  output_payload jsonb not null default '{}'::jsonb,
  expected_comparison jsonb not null default '{}'::jsonb,
  metric_values jsonb not null default '{}'::jsonb,
  error_codes text[] not null default '{}'::text[],
  reviewer_decision_ids uuid[] not null default '{}'::uuid[],
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.validation_results enable row level security;

create table if not exists app.release_candidates (
  release_candidate_id uuid primary key default gen_random_uuid(),
  exam_id uuid not null,
  school_year text not null,
  proposed_version text not null,
  release_class text not null,
  manifest_id uuid,
  source_gate text not null,
  rights_gate text not null,
  teaching_gate text not null,
  grading_gate text not null,
  security_privacy_gate text not null,
  release_gate text not null,
  blocking_findings uuid[] not null default '{}'::uuid[],
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now()
);

alter table app.release_candidates enable row level security;

create table if not exists app.exam_pack_manifests (
  manifest_id uuid primary key default gen_random_uuid(),
  exam_id uuid not null,
  school_year text not null,
  exam_pack_version text not null,
  artifact_version_ids uuid[] not null default '{}'::uuid[],
  source_version_ids uuid[] not null default '{}'::uuid[],
  rights_record_ids uuid[] not null default '{}'::uuid[],
  validator_policy_version_id uuid not null,
  teaching_policy_version_id uuid not null,
  grading_policy_version_id uuid not null,
  prompt_version_ids uuid[] not null default '{}'::uuid[],
  model_configuration_version_ids uuid[] not null default '{}'::uuid[],
  validation_run_ids uuid[] not null default '{}'::uuid[],
  qualification_rule_version_ids uuid[] not null default '{}'::uuid[],
  manifest_sha256 text not null,
  generated_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.exam_pack_manifests enable row level security;

create table if not exists app.publication_events (
  publication_event_id uuid primary key default gen_random_uuid(),
  release_candidate_id uuid not null references app.release_candidates(release_candidate_id) on delete cascade,
  manifest_id uuid not null references app.exam_pack_manifests(manifest_id) on delete cascade,
  environment text not null,
  prior_manifest_id uuid references app.exam_pack_manifests(manifest_id) on delete set null,
  action text not null,
  approved_by uuid[] not null default '{}'::uuid[],
  executed_by uuid references app.profiles(user_id),
  executed_at timestamptz not null default now(),
  transaction_id text not null,
  smoke_test_run_id uuid,
  outcome text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.publication_events enable row level security;

create table if not exists app.quality_incidents (
  incident_id uuid primary key default gen_random_uuid(),
  severity text not null,
  detected_at timestamptz not null default now(),
  detected_by uuid references app.profiles(user_id),
  affected_version_ids uuid[] not null default '{}'::uuid[],
  affected_manifest_ids uuid[] not null default '{}'::uuid[],
  category text not null,
  evidence jsonb not null default '{}'::jsonb,
  containment_action jsonb not null default '{}'::jsonb,
  status text not null,
  incident_commander_id uuid references app.profiles(user_id),
  root_cause text,
  closed_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.quality_incidents enable row level security;

create table if not exists app.revalidation_cases (
  revalidation_id uuid primary key default gen_random_uuid(),
  trigger_type text not null,
  trigger_record_id uuid not null,
  affected_version_ids uuid[] not null default '{}'::uuid[],
  impact_graph_snapshot jsonb not null default '{}'::jsonb,
  required_scope text not null,
  required_gates text[] not null default '{}'::text[],
  due_at timestamptz not null,
  status text not null,
  disposition_manifest_id uuid references app.exam_pack_manifests(manifest_id) on delete set null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

alter table app.revalidation_cases enable row level security;

create table if not exists app.audit_events (
  audit_event_id text primary key,
  occurred_at timestamptz not null,
  actor_type text not null,
  actor_id text not null,
  action text not null,
  object_type text not null,
  object_id text not null,
  prior_event_id text,
  request_id text,
  reason_code text,
  metadata jsonb not null default '{}'::jsonb,
  event_sha256 text not null,
  created_at timestamptz not null default now()
);

alter table app.audit_events enable row level security;

create or replace function app.refresh_artifact_state()
returns trigger
language plpgsql
as $$
begin
  return null;
end;
$$;

create unique index if not exists source_records_source_id_version_sequence_unique
  on app.source_records (source_id, version_sequence);

create unique index if not exists rights_records_one_per_source_version
  on app.rights_records (source_version_id);

create unique index if not exists validation_suites_suite_version_unique
  on app.validation_suites (suite_version_id);

create unique index if not exists validation_cases_case_version_unique
  on app.validation_cases (case_version_id);

create unique index if not exists review_assignments_one_active_review_per_artifact_type
  on app.review_assignments (artifact_version_id, review_type, assigned_reviewer_id, assigned_at);

create index if not exists artifact_state_events_artifact_version_id_idx
  on app.artifact_state_events (artifact_version_id, changed_at desc);

create index if not exists review_assignments_artifact_version_id_idx
  on app.review_assignments (artifact_version_id, status);

create index if not exists review_decisions_assignment_id_idx
  on app.review_decisions (assignment_id, submitted_at desc);

create index if not exists validator_qualifications_reviewer_id_idx
  on app.validator_qualifications (reviewer_id, status);

create index if not exists validator_entitlements_reviewer_id_idx
  on app.validator_entitlements (reviewer_id, status);

grant usage on schema app to authenticated, service_role;

grant select on
  app.source_records,
  app.rights_records,
  app.artifact_versions,
  app.artifact_state_events,
  app.provenance_claims,
  app.artifact_dependencies,
  app.question_coverage_targets,
  app.authoring_briefs,
  app.author_qualifications,
  app.author_commissions,
  app.content_rights_releases,
  app.originality_attestations,
  app.ai_variant_runs,
  app.question_use_assignments,
  app.validator_qualifications,
  app.validator_entitlements,
  app.review_assignments,
  app.review_decisions,
  app.validation_suites,
  app.validation_cases,
  app.validation_runs,
  app.validation_results,
  app.release_candidates,
  app.exam_pack_manifests,
  app.publication_events,
  app.quality_incidents,
  app.revalidation_cases,
  app.audit_events
to service_role;

commit;
