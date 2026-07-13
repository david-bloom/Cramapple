-- TASK-0017 P0 regression: a failure after serving-state updates must roll the
-- entire publication statement back. Run against a disposable/local database
-- after migrations, never against Dev or Production.

begin;

do $$
declare
  v_actor_id uuid;
  v_exam_id uuid := gen_random_uuid();
  v_exam_pack_version_id uuid := gen_random_uuid();
  v_content_item_id uuid := gen_random_uuid();
  v_content_version_id uuid := gen_random_uuid();
  v_source_version_id uuid := gen_random_uuid();
  v_rights_record_id uuid := gen_random_uuid();
  v_grading_suite_version_id uuid := gen_random_uuid();
  v_security_suite_version_id uuid := gen_random_uuid();
  v_grading_run_id uuid := gen_random_uuid();
  v_security_run_id uuid := gen_random_uuid();
  v_release_count_before bigint;
  v_manifest_count_before bigint;
  v_publication_count_before bigint;
  v_failed boolean := false;
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
  values (v_exam_id, 'TASK0017-ATOMIC', 'TASK-0017 Atomic Test', 'Test');

  insert into app.exam_pack_versions (
    id, exam_pack_id, school_year, official_exam_date, status
  ) values (
    v_exam_pack_version_id, v_exam_id, '2098-99', date '2099-05-01', 'draft'
  );

  insert into app.content_items (
    id, exam_pack_version_id, content_key, item_type, title, status
  ) values (
    v_content_item_id, v_exam_pack_version_id, 'atomic-rollback', 'mcq',
    'Atomic rollback fixture', 'draft'
  );

  insert into app.content_item_versions (
    id, content_item_id, version_num, stem, content_hash, status, review_status
  ) values (
    v_content_version_id, v_content_item_id, 1, 'Fixture stem',
    repeat('a', 64), 'draft', 'question_review_approved'
  );

  insert into app.source_records (
    source_id, source_version_id, version_sequence, title, publisher,
    source_type, scope_statement, content_sha256, authority_tier,
    refresh_class, next_refresh_due_at, provenance_status
  ) values (
    gen_random_uuid(), v_source_version_id, 1, 'Fixture source', 'Cramapple',
    'internal', 'Atomic publication regression fixture', repeat('b', 64), 1,
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
      array[v_content_version_id], 'local', 'deterministic', now(), 'passed'),
    (v_security_run_id, v_security_suite_version_id,
      array[v_content_version_id], 'local', 'deterministic', now(), 'passed');

  select count(*) into v_release_count_before from app.release_candidates;
  select count(*) into v_manifest_count_before from app.exam_pack_manifests;
  select count(*) into v_publication_count_before from app.publication_events;

  begin
    perform app.publish_content_item_version_atomic(jsonb_build_object(
      'content_item_version_id', v_content_version_id,
      -- Deliberately invalid. The RPC checks this after release/manifest and
      -- serving-state writes, so the raised exception proves rollback.
      'artifact_version_id', gen_random_uuid(),
      'actor_id', v_actor_id,
      'exam_pack_version_id', v_exam_pack_version_id,
      'content_key', 'atomic-rollback',
      'school_year', '2098-99',
      'source_version_ids', to_jsonb(array[v_source_version_id]),
      'rights_record_ids', to_jsonb(array[v_rights_record_id]),
      'validation_run_ids', to_jsonb(array[v_grading_run_id, v_security_run_id]),
      'validator_policy_version_id', gen_random_uuid(),
      'teaching_policy_version_id', gen_random_uuid(),
      'grading_policy_version_id', gen_random_uuid(),
      'approved_by', to_jsonb(array[v_actor_id]),
      'environment', 'local'
    ));
  exception
    when others then
      if sqlerrm not like '%publish_content:artifact_version_not_found%' then
        raise;
      end if;
      v_failed := true;
  end;

  if not v_failed then
    raise exception 'task0017_expected_late_publish_failure';
  end if;
  if (select status from app.content_items where id = v_content_item_id) <> 'draft' then
    raise exception 'task0017_content_item_was_published_after_failure';
  end if;
  if (select status from app.content_item_versions where id = v_content_version_id) <> 'draft' then
    raise exception 'task0017_content_version_was_published_after_failure';
  end if;
  if (select count(*) from app.release_candidates) <> v_release_count_before
     or (select count(*) from app.exam_pack_manifests) <> v_manifest_count_before
     or (select count(*) from app.publication_events) <> v_publication_count_before then
    raise exception 'task0017_release_records_survived_failed_transaction';
  end if;
end;
$$;

rollback;
