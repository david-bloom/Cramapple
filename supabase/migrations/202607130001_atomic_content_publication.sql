-- TASK-0017 P0: make publication eligibility evidence-derived and publication
-- state changes atomic. This migration is repository-only until separately
-- approved for a target environment.

begin;

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
  v_review_status text;
  v_source_ids uuid[];
  v_rights_ids uuid[];
  v_validation_run_ids uuid[];
  v_approved_by uuid[];
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
    civ.review_status,
    epv.exam_pack_id,
    epv.school_year
  into
    v_content_item_id,
    v_exam_pack_version_id,
    v_content_key,
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

  select coalesce(array_agg(value::uuid), '{}'::uuid[])
  into v_source_ids
  from jsonb_array_elements_text(coalesce(p_request->'source_version_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid), '{}'::uuid[])
  into v_rights_ids
  from jsonb_array_elements_text(coalesce(p_request->'rights_record_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid), '{}'::uuid[])
  into v_validation_run_ids
  from jsonb_array_elements_text(coalesce(p_request->'validation_run_ids', '[]'::jsonb));
  select coalesce(array_agg(value::uuid), '{}'::uuid[])
  into v_approved_by
  from jsonb_array_elements_text(coalesce(p_request->'approved_by', '[]'::jsonb));

  if cardinality(v_source_ids) <> cardinality(array(select distinct unnest(v_source_ids)))
     or cardinality(v_rights_ids) <> cardinality(array(select distinct unnest(v_rights_ids)))
     or cardinality(v_validation_run_ids) <> cardinality(array(select distinct unnest(v_validation_run_ids)))
     or cardinality(v_approved_by) <> cardinality(array(select distinct unnest(v_approved_by))) then
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

  if v_review_status is null or v_review_status not in (
    'question_review_approved', 'difficulty_confirmed', 'mcq_answer_review_complete'
  ) then
    raise exception 'publish_content:content_clearance_gate_failed';
  end if;

  if cardinality(v_validation_run_ids) = 0 or exists (
    select 1
    from unnest(v_validation_run_ids) as requested_run(run_id)
    left join app.validation_runs vr on vr.run_id = requested_run.run_id
    where vr.run_id is null
       or vr.status <> 'passed'
       or vr.completed_at is null
       or not (vr.target_version_ids @> array[v_content_version_id])
  ) then
    raise exception 'publish_content:validation_evidence_failed';
  end if;

  if not exists (
    select 1
    from app.validation_runs vr
    join app.validation_suites vs on vs.suite_version_id = vr.suite_version_id
    where vr.run_id = any(v_validation_run_ids)
      and vr.status = 'passed'
      and vr.completed_at is not null
      and vr.target_version_ids @> array[v_content_version_id]
      and vs.suite_type in ('grading', 'calibration')
  ) then
    raise exception 'publish_content:grading_gate_failed';
  end if;

  if not exists (
    select 1
    from app.validation_runs vr
    join app.validation_suites vs on vs.suite_version_id = vr.suite_version_id
    where vr.run_id = any(v_validation_run_ids)
      and vr.status = 'passed'
      and vr.completed_at is not null
      and vr.target_version_ids @> array[v_content_version_id]
      and vs.suite_type in ('security', 'privacy', 'security_privacy')
  ) then
    raise exception 'publish_content:security_privacy_gate_failed';
  end if;

  if not (v_actor_id = any(v_approved_by)) then
    raise exception 'publish_content:release_approval_missing';
  end if;
  if nullif(p_request->>'validator_policy_version_id', '') is null
     or nullif(p_request->>'teaching_policy_version_id', '') is null
     or nullif(p_request->>'grading_policy_version_id', '') is null then
    raise exception 'publish_content:policy_version_missing';
  end if;

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
    coalesce(nullif(p_request->>'exam_pack_version', ''), '1.0.0'),
    array[v_content_version_id], v_source_ids, v_rights_ids,
    (p_request->>'validator_policy_version_id')::uuid,
    (p_request->>'teaching_policy_version_id')::uuid,
    (p_request->>'grading_policy_version_id')::uuid,
    coalesce((select array_agg(value::uuid) from jsonb_array_elements_text(coalesce(p_request->'prompt_version_ids', '[]'::jsonb))), '{}'::uuid[]),
    coalesce((select array_agg(value::uuid) from jsonb_array_elements_text(coalesce(p_request->'model_configuration_version_ids', '[]'::jsonb))), '{}'::uuid[]),
    v_validation_run_ids,
    coalesce((select array_agg(value::uuid) from jsonb_array_elements_text(coalesce(p_request->'qualification_rule_version_ids', '[]'::jsonb))), '{}'::uuid[]),
    encode(extensions.digest(p_request::text, 'sha256'::text), 'hex'), v_actor_id
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
  set status = 'published', title = coalesce(nullif(p_request->>'title', ''), title)
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
