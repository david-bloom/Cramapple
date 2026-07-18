-- Keep non-operational compiler advisories outside the signed execution plan.
-- The original trusted-boundary function compared the signed plan against the
-- complete transport envelope, so every normal compiler result was rejected.
-- Preserve the reviewed implementation under a private versioned name and
-- expose a narrow wrapper that removes only the advisory transport field.

-- Reconcile the trusted registry with the compiler's backward-compatible
-- declarative parameter aliases. The wrapper below still requires one complete
-- accepted shape, so an empty parameter object cannot pass the DB boundary.
drop trigger if exists reject_immutable_mutation
  on app.deterministic_check_types;

update app.deterministic_check_types
set parameter_contract = '{
  "required": [],
  "properties": {"choice": "string", "correct_key": "string"},
  "additional_properties": false
}'::jsonb
where check_type_key = 'choice-key';

update app.deterministic_check_types
set parameter_contract = '{
  "required": [],
  "properties": {
    "absolute": "number",
    "expected_value": "number",
    "tolerance": "number",
    "unit": "string"
  },
  "additional_properties": false
}'::jsonb
where check_type_key = 'numeric-tolerance';

create trigger reject_immutable_mutation
before update or delete on app.deterministic_check_types
for each row execute function app.reject_immutable_record_mutation();

alter function app.apply_subject_package_atomic(jsonb, uuid, text, text)
  rename to apply_subject_package_atomic_v1;

create function app.apply_subject_package_atomic(
  p_compiled_plan jsonb,
  p_actor_id uuid,
  p_environment text,
  p_approval_id text default null
) returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if p_compiled_plan ? 'advisories'
    and jsonb_typeof(p_compiled_plan->'advisories') <> 'array'
  then
    raise exception 'subject_harness:invalid_advisories_envelope';
  end if;

  if exists (
    select 1
    from jsonb_path_query(
      p_compiled_plan,
      '$.items[*].package.parts.**.criteria[*].deterministic_checks[*]'
    ) check_definition
    where check_definition->>'check_type' = 'choice-key'
      and not (
        coalesce(check_definition->'parameters', '{}'::jsonb) ? 'choice'
        or coalesce(check_definition->'parameters', '{}'::jsonb) ? 'correct_key'
      )
  ) then
    raise exception 'subject_harness:choice_key_parameter_required';
  end if;

  if exists (
    select 1
    from jsonb_path_query(
      p_compiled_plan,
      '$.items[*].package.parts.**.criteria[*].deterministic_checks[*]'
    ) check_definition
    where check_definition->>'check_type' = 'numeric-tolerance'
      and not (
        coalesce(check_definition->'parameters', '{}'::jsonb) ? 'absolute'
        or (
          coalesce(check_definition->'parameters', '{}'::jsonb) ? 'expected_value'
          and coalesce(check_definition->'parameters', '{}'::jsonb) ? 'tolerance'
        )
      )
  ) then
    raise exception 'subject_harness:numeric_tolerance_parameter_required';
  end if;

  return app.apply_subject_package_atomic_v1(
    p_compiled_plan - 'advisories',
    p_actor_id,
    p_environment,
    p_approval_id
  );
end;
$$;

revoke all on function app.apply_subject_package_atomic(jsonb, uuid, text, text)
  from public, anon, authenticated;
grant execute on function app.apply_subject_package_atomic(jsonb, uuid, text, text)
  to service_role;

revoke all on function app.apply_subject_package_atomic_v1(jsonb, uuid, text, text)
  from public, anon, authenticated;
grant execute on function app.apply_subject_package_atomic_v1(jsonb, uuid, text, text)
  to service_role;

-- Allow the governed subject harness to adopt an exact, pre-existing draft
-- content version. This is intentionally narrower than a general upsert:
-- only an untouched draft whose canonical payload and hash already match the
-- incoming ItemPackage can acquire the immutable package snapshot fields.

create or replace function app.adopt_matching_draft_item_package()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_existing app.content_item_versions%rowtype;
  v_has_review_decision boolean := false;
begin
  if new.item_package_sha256 is null or new.item_package_payload is null then
    return new;
  end if;

  select * into v_existing
  from app.content_item_versions
  where content_item_id = new.content_item_id
    and version_num = new.version_num
  for update;

  if not found then
    return new;
  end if;

  if to_regclass('app.content_review_decisions') is not null then
    execute 'select exists (
      select 1 from app.content_review_decisions
      where content_item_version_id = $1
    )'
    into v_has_review_decision
    using v_existing.id;
  end if;

  if v_existing.item_package_sha256 is not null
    or v_existing.status <> 'draft'
    or v_existing.review_status is not null
    or to_jsonb(v_existing)->>'approved_at' is not null
    or to_jsonb(v_existing)->>'published_at' is not null
    or v_existing.content_hash is distinct from new.item_package_sha256
    or v_existing.prompt_json is distinct from new.item_package_payload
    or exists (
      select 1 from app.content_review_assignments assignment
      where assignment.content_item_version_id = v_existing.id
    )
    or v_has_review_decision
    or exists (
      select 1 from app.exam_pack_manifests manifest
      where v_existing.id = any(manifest.artifact_version_ids)
    )
    or exists (
      select 1 from app.exam_pack_manifest_content_versions relation
      where relation.content_item_version_id = v_existing.id
    )
  then
    return new;
  end if;

  update app.content_item_versions
  set item_package_schema_version = new.item_package_schema_version,
      item_package_payload = new.item_package_payload,
      item_package_sha256 = new.item_package_sha256,
      archetype_version_id = new.archetype_version_id,
      updated_at = now()
  where id = v_existing.id;

  -- Skip the attempted duplicate insert. The atomic apply function resolves the
  -- now-managed canonical row by its package hash and continues normally.
  return null;
end;
$$;

drop trigger if exists content_item_versions_adopt_matching_draft_package
  on app.content_item_versions;
create trigger content_item_versions_adopt_matching_draft_package
before insert on app.content_item_versions
for each row execute function app.adopt_matching_draft_item_package();

revoke all on function app.adopt_matching_draft_item_package() from public, anon, authenticated;
grant execute on function app.adopt_matching_draft_item_package() to service_role;
