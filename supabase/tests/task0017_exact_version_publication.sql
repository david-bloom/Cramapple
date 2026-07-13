-- TASK-0017 P0 positive-path regression: publication must select the exact
-- requested content_item_version_id, even when a newer draft version exists.
-- Run only against a disposable/local database after migrations.

begin;

do $$
declare
  v_actor_id uuid;
  v_exam_id uuid := gen_random_uuid();
  v_exam_pack_version_id uuid := gen_random_uuid();
  v_content_item_id uuid := gen_random_uuid();
  v_prior_version_id uuid := gen_random_uuid();
  v_requested_version_id uuid := gen_random_uuid();
  v_newer_draft_version_id uuid := gen_random_uuid();
  v_artifact_version_id uuid := gen_random_uuid();
  v_source_version_id uuid := gen_random_uuid();
  v_rights_record_id uuid := gen_random_uuid();
  v_grading_suite_version_id uuid := gen_random_uuid();
  v_security_suite_version_id uuid := gen_random_uuid();
  v_grading_run_id uuid := gen_random_uuid();
  v_security_run_id uuid := gen_random_uuid();
  v_validator_policy_version_id uuid := gen_random_uuid();
  v_teaching_policy_version_id uuid := gen_random_uuid();
  v_grading_policy_version_id uuid := gen_random_uuid();
  v_result jsonb;
  v_manifest_id uuid;
  v_release_candidate_id uuid;
  v_expected_manifest_sha256 text;
  v_manifest_relation_ok boolean;
begin
  select user_id into v_actor_id
  from app.profiles
  where role = 'admin'
  order by created_at
  limit 1;

  if v_actor_id is null then
    raise exception 'task0017_test_requires_seeded_admin_profile';
  end if;

  insert into app.exam_packs (id, exam_code, exam_name, subject)
  values (v_exam_id, 'TASK0017-EXACT', 'TASK-0017 Exact Version Test', 'Test');

  insert into app.exam_pack_versions (
    id, exam_pack_id, school_year, official_exam_date, status
  ) values (
    v_exam_pack_version_id, v_exam_id, '2098-99', date '2099-05-01', 'draft'
  );

  insert into app.content_items (
    id, exam_pack_version_id, content_key, item_type, title, status
  ) values (
    v_content_item_id, v_exam_pack_version_id, 'exact-version', 'mcq',
    'Exact version fixture', 'published'
  );

  insert into app.content_item_versions (
    id, content_item_id, version_num, stem, content_hash, status,
    review_status, published_at
  ) values
    (v_prior_version_id, v_content_item_id, 1, 'Previously published stem',
      repeat('1', 64), 'published', 'question_review_approved', now()),
    (v_requested_version_id, v_content_item_id, 2, 'Approved requested stem',
      repeat('2', 64), 'draft', 'question_review_approved', null),
    (v_newer_draft_version_id, v_content_item_id, 3, 'Newer unapproved draft',
      repeat('3', 64), 'draft', null, null);

  insert into app.artifact_versions (artifact_version_id)
  values (v_artifact_version_id);

  insert into app.source_records (
    source_id, source_version_id, version_sequence, title, publisher,
    source_type, scope_statement, content_sha256, authority_tier,
    refresh_class, next_refresh_due_at, provenance_status
  ) values (
    gen_random_uuid(), v_source_version_id, 1, 'Fixture source', 'Cramapple',
    'internal', 'Exact-version publication fixture', repeat('b', 64), 1,
    'EXAM', now() + interval '1 day', 'verified'
  );

  insert into app.rights_records (
    rights_record_id, source_version_id, rights_status, next_review_due_at
  ) values (
    v_rights_record_id, v_source_version_id, 'cramapple_owned',
    now() + interval '1 day'
  );

  insert into app.validation_suites (
    suite_version_id, name, exam_id, suite_type, split, content_sha256
  ) values
    (v_grading_suite_version_id, 'Fixture grading', v_exam_id, 'grading',
      'validation', repeat('c', 64)),
    (v_security_suite_version_id, 'Fixture security', v_exam_id,
      'security_privacy', 'validation', repeat('d', 64));

  insert into app.validation_runs (
    run_id, suite_version_id, target_version_ids, environment, runner_type,
    completed_at, status
  ) values
    (v_grading_run_id, v_grading_suite_version_id,
      array[v_requested_version_id], 'local', 'deterministic', now(), 'passed'),
    (v_security_run_id, v_security_suite_version_id,
      array[v_requested_version_id], 'local', 'deterministic', now(), 'passed');

  v_result := app.publish_content_item_version_atomic(jsonb_build_object(
    'content_item_version_id', v_requested_version_id,
    'artifact_version_id', v_artifact_version_id,
    'actor_id', v_actor_id,
    'exam_pack_version_id', v_exam_pack_version_id,
    'content_key', 'exact-version',
    'school_year', '2098-99',
    'source_version_ids', to_jsonb(array[v_source_version_id]),
    'rights_record_ids', to_jsonb(array[v_rights_record_id]),
    'validation_run_ids', to_jsonb(array[v_grading_run_id, v_security_run_id]),
    'validator_policy_version_id', v_validator_policy_version_id,
    'teaching_policy_version_id', v_teaching_policy_version_id,
    'grading_policy_version_id', v_grading_policy_version_id,
    'approved_by', to_jsonb(array[v_actor_id]),
    'environment', 'local'
  ));

  v_manifest_id := (v_result->>'manifest_id')::uuid;
  v_release_candidate_id := (v_result->>'release_candidate_id')::uuid;
  v_expected_manifest_sha256 := encode(extensions.digest(
    jsonb_build_object(
      'schema_version', '1.0.0',
      'exam_id', v_exam_id,
      'school_year', '2098-99',
      'exam_pack_version', '1.0.0',
      'content_versions', jsonb_build_array(jsonb_build_object(
        'ordinal', 1,
        'content_item_version_id', v_requested_version_id,
        'content_key_snapshot', 'exact-version',
        'content_sha256', repeat('2', 64)
      )),
      'source_version_ids', to_jsonb(array[v_source_version_id]),
      'rights_record_ids', to_jsonb(array[v_rights_record_id]),
      'validator_policy_version_id', v_validator_policy_version_id,
      'teaching_policy_version_id', v_teaching_policy_version_id,
      'grading_policy_version_id', v_grading_policy_version_id,
      'prompt_version_ids', '[]'::jsonb,
      'model_configuration_version_ids', '[]'::jsonb,
      'validation_run_ids', to_jsonb(
        array(select unnest(array[v_grading_run_id, v_security_run_id]) order by 1)
      ),
      'qualification_rule_version_ids', '[]'::jsonb
    )::text,
    'sha256'::text
  ), 'hex');

  if (v_result->>'content_item_version_id')::uuid <> v_requested_version_id then
    raise exception 'task0017_rpc_returned_wrong_content_version';
  end if;
  if (select status from app.content_items where id = v_content_item_id) <> 'published' then
    raise exception 'task0017_content_item_not_published';
  end if;
  if (select status from app.content_item_versions where id = v_requested_version_id) <> 'published'
     or (select published_at from app.content_item_versions where id = v_requested_version_id) is null then
    raise exception 'task0017_requested_version_not_published';
  end if;
  if (select status from app.content_item_versions where id = v_prior_version_id) <> 'retired'
     or (select published_at from app.content_item_versions where id = v_prior_version_id) is not null then
    raise exception 'task0017_prior_version_not_retired';
  end if;
  if (select status from app.content_item_versions where id = v_newer_draft_version_id) <> 'draft'
     or (select published_at from app.content_item_versions where id = v_newer_draft_version_id) is not null then
    raise exception 'task0017_newer_draft_was_published_or_mutated';
  end if;
  if (select artifact_version_ids from app.exam_pack_manifests where manifest_id = v_manifest_id)
       <> array[v_requested_version_id] then
    raise exception 'task0017_manifest_did_not_pin_exact_version';
  end if;
  if (select manifest_sha256 from app.exam_pack_manifests where manifest_id = v_manifest_id)
       <> v_expected_manifest_sha256 then
    raise exception 'task0017_manifest_hash_is_not_canonical';
  end if;
  if to_regclass('app.exam_pack_manifest_content_versions') is not null then
    execute 'select exists (select 1 from app.exam_pack_manifest_content_versions
      where manifest_id=$1 and ordinal=1 and content_item_version_id=$2
        and content_key_snapshot=''exact-version'')'
      into v_manifest_relation_ok using v_manifest_id,v_requested_version_id;
    if not v_manifest_relation_ok then
      raise exception 'task0017_manifest_relation_did_not_pin_exact_version';
    end if;
  end if;
  if not exists (
    select 1
    from pg_catalog.pg_extension e
    join pg_catalog.pg_namespace n on n.oid = e.extnamespace
    where e.extname = 'pgcrypto'
      and n.nspname = 'extensions'
  ) or to_regprocedure('extensions.digest(text,text)') is null then
    raise exception 'task0017_extensions_digest_not_resolved';
  end if;
  if not exists (
    select 1 from app.release_candidates rc
    where rc.release_candidate_id = v_release_candidate_id
      and rc.manifest_id = v_manifest_id
  ) then
    raise exception 'task0017_release_candidate_missing';
  end if;
  if not exists (
    select 1 from app.publication_events pe
    where pe.release_candidate_id = v_release_candidate_id
      and pe.manifest_id = v_manifest_id
      and pe.outcome = 'succeeded'
  ) then
    raise exception 'task0017_publication_event_missing';
  end if;
  if app.project_artifact_state(v_artifact_version_id) <> 'published' then
    raise exception 'task0017_artifact_state_not_published';
  end if;
  if to_regclass('app.execution_approvals') is not null then
    begin
      update app.exam_pack_manifests set manifest_sha256=repeat('0',64) where manifest_id=v_manifest_id;
      raise exception 'task0017_manifest_parent_mutation_was_accepted';
    exception when others then
      if sqlerrm not like 'immutable_record:update_not_allowed%' then raise; end if;
    end;
    begin
      update app.validation_suites set content_sha256=repeat('0',64)
        where suite_version_id=v_grading_suite_version_id;
      raise exception 'task0017_validation_suite_mutation_was_accepted';
    exception when others then
      if sqlerrm not like 'immutable_record:update_not_allowed%' then raise; end if;
    end;
    update app.validation_runs set invalidated_at=now(),invalidation_reason='regression'
      where run_id=v_grading_run_id;
    if app.validation_run_is_current(v_grading_run_id,v_requested_version_id,'grading_calibration') then
      raise exception 'task0017_invalidated_validation_failed_open';
    end if;
  end if;
end;
$$;

rollback;
