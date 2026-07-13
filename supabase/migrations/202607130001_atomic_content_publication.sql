-- TASK-0017 P0: make publication eligibility evidence-derived and publication
-- state changes atomic. This migration is repository-only until separately
-- approved for a target environment.

begin;

create schema if not exists extensions;

do $$
declare
  v_extension_schema text;
  v_relocatable boolean;
begin
  select n.nspname, e.extrelocatable
  into v_extension_schema, v_relocatable
  from pg_catalog.pg_extension e
  join pg_catalog.pg_namespace n on n.oid = e.extnamespace
  where e.extname = 'pgcrypto';

  if not found then
    create extension pgcrypto with schema extensions;
  elsif v_extension_schema <> 'extensions' then
    if not v_relocatable then
      raise exception 'publish_content:pgcrypto_not_relocatable_from_%',
        v_extension_schema;
    end if;
    alter extension pgcrypto set schema extensions;
  end if;

  if not exists (
    select 1
    from pg_catalog.pg_proc p
    join pg_catalog.pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'extensions'
      and p.proname = 'digest'
  ) then
    raise exception 'publish_content:extensions_digest_unavailable';
  end if;
end;
$$;

-- H5 replaces this fail-closed stub after the immutable exception schema is
-- installed. Keeping the resolver boundary in P0 avoids any migration-order
-- dependency while ensuring no exception can be inferred before H5 exists.
create or replace function app.has_active_content_clearance_exception(
  p_content_item_version_id uuid
) returns boolean
language sql stable security invoker set search_path = ''
as $$ select false; $$;

-- H3 replaces this compatibility resolver with the typed registry version.
create or replace function app.validation_run_is_current(
  p_run_id uuid, p_content_item_version_id uuid, p_gate_category text default null
) returns boolean
language sql stable security invoker set search_path = '' as $$
  select exists (
    select 1 from app.validation_runs vr
    join app.validation_suites vs on vs.suite_version_id=vr.suite_version_id
    where vr.run_id=p_run_id and vr.status='passed' and vr.completed_at is not null
      and vr.target_version_ids @> array[p_content_item_version_id]
      and (p_gate_category is null or
        (p_gate_category='grading_calibration' and vs.suite_type in ('grading','calibration')) or
        (p_gate_category='security_privacy' and vs.suite_type in ('security','privacy','security_privacy')))
  );
$$;

create or replace function app.publish_content_item_version_atomic(p_request jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_content_version_id uuid;
  v_artifact_version_id uuid;
  v_actor_id uuid;
  v_content_item_id uuid;
  v_exam_pack_version_id uuid;
  v_exam_id uuid;
  v_school_year text;
  v_content_key text;
  v_content_sha256 text;
  v_review_status text;
  v_source_ids uuid[];
  v_rights_ids uuid[];
  v_validation_run_ids uuid[];
  v_approved_by uuid[];
  v_prompt_version_ids uuid[];
  v_model_configuration_version_ids uuid[];
  v_qualification_rule_version_ids uuid[];
  v_validator_policy_version_id uuid;
  v_teaching_policy_version_id uuid;
  v_grading_policy_version_id uuid;
  v_exam_pack_version text;
  v_manifest_payload jsonb;
  v_manifest_sha256 text;
  v_release_candidate_id uuid := gen_random_uuid();
  v_manifest_id uuid := gen_random_uuid();
  v_prior_state text;
begin
  v_content_version_id := nullif(p_request->>'content_item_version_id', '')::uuid;
  v_artifact_version_id := nullif(p_request->>'artifact_version_id', '')::uuid;
  v_actor_id := nullif(p_request->>'actor_id', '')::uuid;
  v_exam_pack_version_id := nullif(p_request->>'exam_pack_version_id', '')::uuid;
  v_content_key := nullif(p_request->>'content_key', '');

  if v_content_version_id is null then
    raise exception 'publish_content:missing_content_item_version_id';
  end if;
  if v_actor_id is null then
    raise exception 'publish_content:missing_actor_id';
  end if;

  select
    civ.content_item_id,
    ci.exam_pack_version_id,
    ci.content_key,
    civ.content_hash,
    civ.review_status,
    epv.exam_pack_id,
    epv.school_year
  into
    v_content_item_id,
    v_exam_pack_version_id,
    v_content_key,
    v_content_sha256,
    v_review_status,
    v_exam_id,
    v_school_year
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  where civ.id = v_content_version_id
  for update of civ, ci;

  if not found then
    raise exception 'publish_content:content_version_not_found';
  end if;
  if nullif(p_request->>'exam_pack_version_id', '')::uuid is distinct from v_exam_pack_version_id then
    raise exception 'publish_content:exam_pack_version_mismatch';
  end if;
  if nullif(p_request->>'content_key', '') is distinct from v_content_key then
    raise exception 'publish_content:content_key_mismatch';
  end if;
  if nullif(p_request->>'school_year', '') is distinct from v_school_year then
    raise exception 'publish_content:school_year_mismatch';
  end if;

  if not exists (
    select 1 from app.profiles p
    where p.user_id = v_actor_id and p.role = 'admin'
  ) then
    raise exception 'publish_content:release_gate_failed';
  end if;

  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_source_ids
  from jsonb_array_elements_text(coalesce(p_request->'source_version_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_rights_ids
  from jsonb_array_elements_text(coalesce(p_request->'rights_record_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_validation_run_ids
  from jsonb_array_elements_text(coalesce(p_request->'validation_run_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_approved_by
  from jsonb_array_elements_text(coalesce(p_request->'approved_by', '[]'::jsonb));
  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_prompt_version_ids
  from jsonb_array_elements_text(coalesce(p_request->'prompt_version_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_model_configuration_version_ids
  from jsonb_array_elements_text(coalesce(p_request->'model_configuration_version_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid order by value::uuid), '{}'::uuid[])
  into v_qualification_rule_version_ids
  from jsonb_array_elements_text(coalesce(p_request->'qualification_rule_version_ids', '[]'::jsonb));

  v_validator_policy_version_id := nullif(p_request->>'validator_policy_version_id', '')::uuid;
  v_teaching_policy_version_id := nullif(p_request->>'teaching_policy_version_id', '')::uuid;
  v_grading_policy_version_id := nullif(p_request->>'grading_policy_version_id', '')::uuid;
  v_exam_pack_version := coalesce(
    nullif(p_request->>'exam_pack_version', ''),
    '1.0.0'
  );

  if cardinality(v_source_ids) <> cardinality(array(select distinct unnest(v_source_ids)))
     or cardinality(v_rights_ids) <> cardinality(array(select distinct unnest(v_rights_ids)))
     or cardinality(v_validation_run_ids) <> cardinality(array(select distinct unnest(v_validation_run_ids)))
     or cardinality(v_approved_by) <> cardinality(array(select distinct unnest(v_approved_by)))
     or cardinality(v_prompt_version_ids) <> cardinality(array(select distinct unnest(v_prompt_version_ids)))
     or cardinality(v_model_configuration_version_ids) <> cardinality(array(select distinct unnest(v_model_configuration_version_ids)))
     or cardinality(v_qualification_rule_version_ids) <> cardinality(array(select distinct unnest(v_qualification_rule_version_ids))) then
    raise exception 'publish_content:duplicate_evidence_identifier';
  end if;

  if cardinality(v_source_ids) = 0 or exists (
    select 1
    from unnest(v_source_ids) as requested_source(source_version_id)
    left join app.source_records sr
      on sr.source_version_id = requested_source.source_version_id
    where sr.source_version_id is null
       or sr.provenance_status <> 'verified'
       or sr.next_refresh_due_at <= now()
  ) then
    raise exception 'publish_content:source_gate_failed';
  end if;

  if cardinality(v_rights_ids) = 0 or exists (
    select 1
    from unnest(v_rights_ids) as requested_right(rights_record_id)
    left join app.rights_records rr
      on rr.rights_record_id = requested_right.rights_record_id
    where rr.rights_record_id is null
       or not (rr.source_version_id = any(v_source_ids))
       or rr.rights_status not in (
         'cramapple_owned', 'public_domain', 'licensed', 'written_permission'
       )
       or (rr.license_expires_at is not null and rr.license_expires_at <= now())
       or rr.next_review_due_at <= now()
       or (rr.legal_approval_required and rr.legal_approval_id is null)
  ) or exists (
    select 1
    from unnest(v_source_ids) as requested_source(source_version_id)
    where not exists (
      select 1
      from app.rights_records rr
      where rr.rights_record_id = any(v_rights_ids)
        and rr.source_version_id = requested_source.source_version_id
        and rr.rights_status in (
          'cramapple_owned', 'public_domain', 'licensed', 'written_permission'
        )
        and (rr.license_expires_at is null or rr.license_expires_at > now())
        and rr.next_review_due_at > now()
        and (not rr.legal_approval_required or rr.legal_approval_id is not null)
    )
  ) then
    raise exception 'publish_content:rights_gate_failed';
  end if;

  if (v_review_status is null or v_review_status not in (
    'question_review_approved', 'difficulty_confirmed', 'mcq_answer_review_complete'
  )) and not app.has_active_content_clearance_exception(v_content_version_id) then
    raise exception 'publish_content:content_clearance_gate_failed';
  end if;

  if cardinality(v_validation_run_ids) = 0 or exists (
    select 1 from unnest(v_validation_run_ids) requested_run(run_id)
    where not app.validation_run_is_current(requested_run.run_id,v_content_version_id,null)
  ) then
    raise exception 'publish_content:validation_evidence_failed';
  end if;

  if not exists (select 1 from unnest(v_validation_run_ids) r(run_id)
    where app.validation_run_is_current(r.run_id,v_content_version_id,'grading_calibration')) then
    raise exception 'publish_content:grading_gate_failed';
  end if;

  if not exists (select 1 from unnest(v_validation_run_ids) r(run_id)
    where app.validation_run_is_current(r.run_id,v_content_version_id,'security_privacy')) then
    raise exception 'publish_content:security_privacy_gate_failed';
  end if;

  if not (v_actor_id = any(v_approved_by)) then
    raise exception 'publish_content:release_approval_missing';
  end if;
  if v_validator_policy_version_id is null
     or v_teaching_policy_version_id is null
     or v_grading_policy_version_id is null then
    raise exception 'publish_content:policy_version_missing';
  end if;

  -- Canonical manifest hash: deterministic ordered content-relation rows and
  -- exact evidence/policy version references only. Request/audit metadata such
  -- as transaction_id, reason_code, title, actor, and environment is excluded.
  v_manifest_payload := jsonb_build_object(
    'schema_version', '1.0.0',
    'exam_id', v_exam_id,
    'school_year', v_school_year,
    'exam_pack_version', v_exam_pack_version,
    'content_versions', jsonb_build_array(jsonb_build_object(
      'ordinal', 1,
      'content_item_version_id', v_content_version_id,
      'content_key_snapshot', v_content_key,
      'content_sha256', v_content_sha256
    )),
    'source_version_ids', to_jsonb(v_source_ids),
    'rights_record_ids', to_jsonb(v_rights_ids),
    'validator_policy_version_id', v_validator_policy_version_id,
    'teaching_policy_version_id', v_teaching_policy_version_id,
    'grading_policy_version_id', v_grading_policy_version_id,
    'prompt_version_ids', to_jsonb(v_prompt_version_ids),
    'model_configuration_version_ids',
      to_jsonb(v_model_configuration_version_ids),
    'validation_run_ids', to_jsonb(v_validation_run_ids),
    'qualification_rule_version_ids',
      to_jsonb(v_qualification_rule_version_ids)
  );
  v_manifest_sha256 := encode(
    extensions.digest(v_manifest_payload::text, 'sha256'::text),
    'hex'
  );

  insert into app.release_candidates (
    release_candidate_id, exam_id, school_year, proposed_version,
    release_class, manifest_id, source_gate, rights_gate, teaching_gate,
    grading_gate, security_privacy_gate, release_gate, blocking_findings,
    created_by
  ) values (
    v_release_candidate_id, v_exam_id, v_school_year,
    coalesce(nullif(p_request->>'proposed_version', ''), '1.0.0'),
    coalesce(nullif(p_request->>'release_class', ''), 'minor'),
    v_manifest_id, 'passed', 'passed', 'passed', 'passed', 'passed', 'passed',
    '{}'::uuid[], v_actor_id
  );

  insert into app.exam_pack_manifests (
    manifest_id, exam_id, school_year, exam_pack_version,
    artifact_version_ids, source_version_ids, rights_record_ids,
    validator_policy_version_id, teaching_policy_version_id,
    grading_policy_version_id, prompt_version_ids,
    model_configuration_version_ids, validation_run_ids,
    qualification_rule_version_ids, manifest_sha256, created_by
  ) values (
    v_manifest_id, v_exam_id, v_school_year,
    v_exam_pack_version,
    array[v_content_version_id], v_source_ids, v_rights_ids,
    v_validator_policy_version_id,
    v_teaching_policy_version_id,
    v_grading_policy_version_id,
    v_prompt_version_ids,
    v_model_configuration_version_ids,
    v_validation_run_ids,
    v_qualification_rule_version_ids,
    v_manifest_sha256, v_actor_id
  );

  update app.content_item_versions
  set status = 'retired', published_at = null
  where content_item_id = v_content_item_id
    and id <> v_content_version_id
    and status = 'published';

  update app.content_item_versions
  set status = 'published', published_at = now()
  where id = v_content_version_id;

  update app.content_items
  set status = 'published'
  where id = v_content_item_id;

  if v_artifact_version_id is not null then
    if not exists (
      select 1 from app.artifact_versions av
      where av.artifact_version_id = v_artifact_version_id
    ) then
      raise exception 'publish_content:artifact_version_not_found';
    end if;
    v_prior_state := app.project_artifact_state(v_artifact_version_id);
    insert into app.artifact_state_events (
      artifact_version_id, prior_state, new_state, reason_code,
      evidence_record_ids, changed_by, created_by
    ) values (
      v_artifact_version_id, v_prior_state, 'published',
      coalesce(nullif(p_request->>'reason_code', ''), 'publish_requested'),
      v_validation_run_ids, v_actor_id, v_actor_id
    );
  end if;

  insert into app.publication_events (
    release_candidate_id, manifest_id, environment, prior_manifest_id,
    action, approved_by, executed_by, transaction_id, smoke_test_run_id,
    outcome, created_by
  ) values (
    v_release_candidate_id, v_manifest_id,
    coalesce(nullif(p_request->>'environment', ''), 'production'),
    nullif(p_request->>'prior_manifest_id', '')::uuid,
    'publish', v_approved_by, v_actor_id,
    coalesce(nullif(p_request->>'transaction_id', ''), gen_random_uuid()::text),
    nullif(p_request->>'smoke_test_run_id', '')::uuid,
    'succeeded', v_actor_id
  );

  return jsonb_build_object(
    'content_item_version_id', v_content_version_id,
    'artifact_version_id', v_artifact_version_id,
    'release_candidate_id', v_release_candidate_id,
    'manifest_id', v_manifest_id,
    'state', 'published'
  );
end;
$$;

revoke all on function app.publish_content_item_version_atomic(jsonb) from public;
revoke all on function app.publish_content_item_version_atomic(jsonb) from anon;
revoke all on function app.publish_content_item_version_atomic(jsonb) from authenticated;
grant execute on function app.publish_content_item_version_atomic(jsonb) to service_role;

commit;
