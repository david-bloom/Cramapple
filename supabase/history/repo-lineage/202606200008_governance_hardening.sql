-- Hardening for the content-governance release path.
-- Resolves the audit-event shape mismatch, adds production validation guards,
-- and closes the service-role write and RLS gaps called out in review.

begin;

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- Audit events
-- ---------------------------------------------------------------------------

alter table app.audit_events
  add column if not exists audit_event_id text,
  add column if not exists occurred_at timestamptz,
  add column if not exists actor_type text,
  add column if not exists actor_id text,
  add column if not exists prior_event_id text,
  add column if not exists request_id text,
  add column if not exists reason_code text,
  add column if not exists metadata jsonb not null default '{}'::jsonb,
  add column if not exists event_sha256 text;

-- Backfill legacy rows only when the old schema columns exist.
-- On fresh projects, audit_events is created with the new schema (no 'id',
-- 'actor_user_id', etc.), so the table is empty and the UPDATE is a no-op
-- semantically — but Postgres would reject the column references at parse time.
-- Using EXECUTE defers resolution to runtime after the existence check.
do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'app'
      and table_name   = 'audit_events'
      and column_name  = 'id'
  ) then
    execute $sql$
      update app.audit_events
      set
        audit_event_id = coalesce(audit_event_id, id::text),
        occurred_at    = coalesce(occurred_at, created_at),
        actor_type     = coalesce(actor_type, 'human'),
        actor_id       = coalesce(actor_id, coalesce(actor_user_id::text, subject_user_id::text, 'system')),
        request_id     = coalesce(request_id, payload ->> 'request_id'),
        reason_code    = coalesce(reason_code, action),
        metadata       = coalesce(metadata, payload, '{}'::jsonb),
        event_sha256   = coalesce(
          event_sha256,
          encode(digest(coalesce(payload::text, ''), 'sha256'), 'hex')
        )
      where audit_event_id is null
         or occurred_at    is null
         or actor_type     is null
         or actor_id       is null
         or request_id     is null
         or reason_code    is null
         or event_sha256   is null
    $sql$;
  end if;
end;
$$;

alter table app.audit_events
  alter column audit_event_id set not null,
  alter column occurred_at set not null,
  alter column actor_type set not null,
  alter column actor_id set not null,
  alter column event_sha256 set not null;

create unique index if not exists audit_events_request_id_unique
  on app.audit_events (request_id)
  where request_id is not null;

-- ---------------------------------------------------------------------------
-- Enums / checks for governance tables
-- ---------------------------------------------------------------------------

alter table app.source_records
  add constraint source_records_provenance_status_check
    check (provenance_status in ('draft', 'verified', 'superseded', 'withdrawn')),
  add constraint source_records_refresh_class_check
    check (refresh_class in (
      'EXAM',
      'RIGHTS',
      'SCIENCE_STABLE',
      'SCIENCE_VOLATILE',
      'LINK_ONLY',
      'PROVIDER_POLICY'
    ));

alter table app.rights_records
  add constraint rights_records_rights_status_check
    check (rights_status in (
      'cramapple_owned',
      'public_domain',
      'licensed',
      'written_permission',
      'link_only',
      'internal_reference_only',
      'restricted',
      'disputed',
      'unknown'
    ));

alter table app.artifact_versions
  add constraint artifact_versions_artifact_type_check
    check (artifact_type in (
      'exam_fact',
      'taxonomy_node',
      'question',
      'stimulus',
      'asset',
      'lesson',
      'explanation',
      'hint',
      'misconception',
      'intervention',
      'transfer_item',
      'delayed_retrieval_item',
      'rubric',
      'criterion',
      'accepted_variant',
      'contradiction',
      'sample_response',
      'calibration_case',
      'teaching_policy',
      'grading_policy',
      'prompt',
      'model_configuration',
      'validator_policy'
    )),
  add constraint artifact_versions_risk_class_check
    check (risk_class in ('R0', 'R1', 'R2', 'R3')),
  add constraint artifact_versions_change_class_check
    check (change_class in ('C0', 'C1', 'C2', 'C3'));

alter table app.artifact_state_events
  add constraint artifact_state_events_prior_state_check
    check (
      prior_state is null
      or prior_state in (
        'draft',
        'in_review',
        'approved',
        'published',
        'suspended',
        'superseded',
        'retired',
        'withdrawn'
      )
    ),
  add constraint artifact_state_events_new_state_check
    check (
      new_state in (
        'draft',
        'in_review',
        'approved',
        'published',
        'suspended',
        'superseded',
        'retired',
        'withdrawn'
      )
    );

alter table app.author_qualifications
  add constraint author_qualifications_status_check
    check (status in ('pending', 'active', 'suspended', 'expired', 'revoked'));

alter table app.author_commissions
  add constraint author_commissions_status_check
    check (status in ('pending', 'active', 'delivered', 'closed', 'cancelled'));

alter table app.validator_qualifications
  add constraint validator_qualifications_type_check
    check (qualification_type in (
      'teaching',
      'grading',
      'ap_reader_teaching',
      'ap_reader_grading',
      'lead_teaching',
      'lead_grading',
      'source_steward',
      'rights_reviewer',
      'release_approver'
    )),
  add constraint validator_qualifications_status_check
    check (status in ('pending', 'active', 'suspended', 'expired', 'revoked'));

alter table app.validator_entitlements
  add constraint validator_entitlements_status_check
    check (status in ('active', 'suspended', 'expired', 'revoked'));

alter table app.review_assignments
  add constraint review_assignments_review_type_check
    check (review_type in (
      'source',
      'rights',
      'teaching',
      'grading',
      'accessibility',
      'adjudication',
      'release'
    )),
  add constraint review_assignments_status_check
    check (status in ('assigned', 'opened', 'submitted', 'recused', 'expired', 'cancelled'));

alter table app.review_decisions
  add constraint review_decisions_decision_check
    check (decision in ('approve', 'approve_with_notes', 'changes_required', 'reject', 'abstain'));

alter table app.validation_cases
  add constraint validation_cases_gold_status_check
    check (gold_status in ('draft', 'dual_reviewed', 'adjudicated', 'retired'));

alter table app.validation_runs
  add constraint validation_runs_status_check
    check (status in ('running', 'passed', 'failed', 'invalidated', 'cancelled'));

alter table app.release_candidates
  add constraint release_candidates_release_class_check
    check (release_class in ('patch', 'minor', 'major', 'emergency')),
  add constraint release_candidates_source_gate_check
    check (source_gate in ('pending', 'passed', 'failed')),
  add constraint release_candidates_rights_gate_check
    check (rights_gate in ('pending', 'passed', 'failed')),
  add constraint release_candidates_teaching_gate_check
    check (teaching_gate in ('pending', 'passed', 'failed', 'not_applicable')),
  add constraint release_candidates_grading_gate_check
    check (grading_gate in ('pending', 'passed', 'failed', 'not_applicable')),
  add constraint release_candidates_security_privacy_gate_check
    check (security_privacy_gate in ('pending', 'passed', 'failed', 'not_applicable')),
  add constraint release_candidates_release_gate_check
    check (release_gate in ('pending', 'passed', 'failed'));

alter table app.quality_incidents
  add constraint quality_incidents_status_check
    check (status in ('open', 'contained', 'remediating', 'monitoring', 'closed')),
  add constraint quality_incidents_severity_check
    check (severity in ('S0', 'S1', 'S2', 'S3'));

alter table app.revalidation_cases
  add constraint revalidation_cases_trigger_type_check
    check (trigger_type in (
      'source_change',
      'rights_change',
      'artifact_change',
      'dependency_change',
      'model_change',
      'prompt_change',
      'metric_drift',
      'incident',
      'scheduled_review',
      'reviewer_challenge'
    )),
  add constraint revalidation_cases_required_scope_check
    check (required_scope in ('C0', 'C1', 'C2', 'C3')),
  add constraint revalidation_cases_status_check
    check (status in ('open', 'in_progress', 'passed', 'failed', 'superseded'));

alter table app.publication_events
  add constraint publication_events_outcome_check
    check (outcome in ('succeeded', 'failed', 'blocked'));

-- ---------------------------------------------------------------------------
-- Sequence allocation and index backstops
-- ---------------------------------------------------------------------------

create unique index if not exists artifact_versions_artifact_id_version_sequence_unique
  on app.artifact_versions (artifact_id, version_sequence);

drop index if exists review_assignments_one_active_review_per_artifact_type;
create unique index if not exists review_assignments_one_active_review_per_artifact
  on app.review_assignments (artifact_version_id, review_type)
  where status in ('assigned', 'opened');

create or replace function app.reserve_artifact_version_sequence(p_artifact_id uuid)
returns integer
language plpgsql
security invoker
set search_path = app, public
as $$
declare
  next_sequence integer;
begin
  perform pg_advisory_xact_lock(hashtextextended(p_artifact_id::text, 0));

  select coalesce(max(version_sequence), 0) + 1
    into next_sequence
  from app.artifact_versions
  where artifact_id = p_artifact_id;

  return next_sequence;
end;
$$;

revoke all on function app.reserve_artifact_version_sequence(uuid) from public, anon, authenticated;
grant execute on function app.reserve_artifact_version_sequence(uuid) to service_role;

-- ---------------------------------------------------------------------------
-- Explicit RLS assertions
-- ---------------------------------------------------------------------------

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'source_records',
    'rights_records',
    'artifact_versions',
    'artifact_state_events',
    'provenance_claims',
    'artifact_dependencies',
    'question_coverage_targets',
    'authoring_briefs',
    'author_qualifications',
    'author_commissions',
    'content_rights_releases',
    'originality_attestations',
    'ai_variant_runs',
    'question_use_assignments',
    'validator_qualifications',
    'validator_entitlements',
    'review_assignments',
    'review_decisions',
    'validation_suites',
    'validation_cases',
    'validation_runs',
    'validation_results',
    'release_candidates',
    'exam_pack_manifests',
    'publication_events',
    'quality_incidents',
    'revalidation_cases',
    'audit_events'
  ] loop
    execute format('drop policy if exists deny_authenticated_all on app.%I', table_name);
    execute format(
      'create policy deny_authenticated_all on app.%I for all to authenticated using (false) with check (false)',
      table_name
    );
  end loop;
end
$$;

-- ---------------------------------------------------------------------------
-- Service role write access
-- ---------------------------------------------------------------------------

grant select, insert, update, delete on
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
  app.revalidation_cases
to service_role;

commit;
