-- TASK-0017 H3-H5 repository/local design. No shared-environment application.
begin;

create table app.platform_capabilities (
  capability_kind text not null check (capability_kind in ('renderer','response-modality','grader','calculator')),
  capability_code text not null,
  support_status text not null check (support_status in ('supported','experimental','unsupported','retired')),
  configuration jsonb not null default '{}', effective_at timestamptz not null default now(),
  retired_at timestamptz, primary key (capability_kind, capability_code)
);

insert into app.platform_capabilities(capability_kind, capability_code, support_status) values
  ('renderer','markdown','supported'), ('renderer','math','supported'), ('renderer','table','supported'),
  ('response-modality','choice','supported'), ('response-modality','typed-text','supported'),
  ('response-modality','typed-math','supported'), ('response-modality','table','supported'),
  ('response-modality','graph','experimental'), ('response-modality','drawing','experimental'),
  ('response-modality','file-upload','experimental'), ('grader','mcq-key','supported'),
  ('grader','statistics-frq-rubric','supported'), ('calculator','desmos-built-in','supported'),
  ('calculator','approved-handheld','supported');

create table app.verifier_plugins (
  verifier_plugin_id uuid primary key default gen_random_uuid(), plugin_key text not null unique,
  display_name text not null, created_at timestamptz not null default now()
);
create table app.verifier_plugin_versions (
  verifier_plugin_version_id uuid primary key default gen_random_uuid(),
  verifier_plugin_id uuid not null references app.verifier_plugins(verifier_plugin_id) on delete restrict,
  semantic_version text not null, implementation_ref text not null,
  build_sha256 text not null check (build_sha256 ~ '^[a-f0-9]{64}$'),
  review_status text not null check (review_status in ('draft','approved','rejected','retired')),
  reviewed_by uuid references app.profiles(user_id), reviewed_at timestamptz,
  created_at timestamptz not null default now(), unique(verifier_plugin_id,semantic_version),
  check ((review_status='approved' and reviewed_by is not null and reviewed_at is not null) or review_status<>'approved')
);
create index verifier_plugin_versions_plugin_idx on app.verifier_plugin_versions(verifier_plugin_id);
create index verifier_plugin_versions_reviewed_by_idx on app.verifier_plugin_versions(reviewed_by);

create table app.deterministic_check_types (
  check_type_key text primary key, runner_kind text not null check (runner_kind in ('declarative','reviewed-plugin')),
  parameter_contract jsonb not null,
  verifier_plugin_version_id uuid references app.verifier_plugin_versions(verifier_plugin_version_id) on delete restrict,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
insert into app.deterministic_check_types(check_type_key,runner_kind,parameter_contract,active) values
  ('numeric-tolerance','declarative','{"required":["absolute"],"properties":{"absolute":"number"},"additional_properties":false}',true),
  ('expression-equivalence','reviewed-plugin','{}',false),
  ('keyword-evidence','declarative','{"required":["keywords"],"properties":{"keywords":"array"},"additional_properties":false}',true),
  ('choice-key','declarative','{"required":["choice"],"properties":{"choice":"string"},"additional_properties":false}',true),
  ('table-shape','declarative','{"required":["rows","columns"],"properties":{"rows":"number","columns":"number"},"additional_properties":false}',true),
  ('graph-feature','reviewed-plugin','{}',false);

create or replace function app.enforce_reviewed_verifier_plugin()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  if new.runner_kind='reviewed-plugin' and new.active and not exists(
    select 1 from app.verifier_plugin_versions vpv
    where vpv.verifier_plugin_version_id=new.verifier_plugin_version_id and vpv.review_status='approved'
  ) then raise exception 'verifier_plugin:approved_version_required'; end if;
  if new.runner_kind='declarative' and new.verifier_plugin_version_id is not null then
    raise exception 'verifier_plugin:declarative_check_cannot_pin_plugin';
  end if;
  return new;
end; $$;
create trigger deterministic_check_types_enforce_plugin before insert or update
  on app.deterministic_check_types for each row execute function app.enforce_reviewed_verifier_plugin();
create index deterministic_check_types_plugin_idx on app.deterministic_check_types(verifier_plugin_version_id)
  where verifier_plugin_version_id is not null;

create table app.validation_suite_types (
  suite_type_key text primary key, display_name text not null,
  gate_category text not null check (gate_category in ('source','rights','content_clearance','grading_calibration','security_privacy','release_approval')),
  target_kinds text[] not null, waiver_policy text not null check (waiver_policy in ('never','product-owner-exception')),
  active_from timestamptz not null default now(), retired_at timestamptz
);
insert into app.validation_suite_types values
  ('schema','Schema','content_clearance',array['content-version'],'product-owner-exception',now(),null),
  ('content-correctness','Content correctness','content_clearance',array['content-version'],'product-owner-exception',now(),null),
  ('answer-rubric-consistency','Answer/rubric consistency','content_clearance',array['content-version'],'product-owner-exception',now(),null),
  ('grading','Grading','grading_calibration',array['content-version'],'never',now(),null),
  ('calibration','Calibration','grading_calibration',array['content-version'],'never',now(),null),
  ('regression','Regression','content_clearance',array['content-version','exam-pack-version'],'product-owner-exception',now(),null),
  ('security','Security','security_privacy',array['content-version','manifest','deployment'],'never',now(),null),
  ('privacy','Privacy','security_privacy',array['content-version','manifest','deployment'],'never',now(),null),
  ('security-privacy','Security/privacy','security_privacy',array['content-version','manifest','deployment'],'never',now(),null);

alter table app.validation_suites add column if not exists suite_type_key text references app.validation_suite_types(suite_type_key),
  add column if not exists input_contract_version text,
  add column if not exists runner_kind text,
  add column if not exists deterministic_configuration jsonb,
  add column if not exists expected_target_kind text,
  add column if not exists supersedes_suite_version_id uuid references app.validation_suites(suite_version_id) on delete restrict;
update app.validation_suites set suite_type_key = replace(lower(suite_type),'_','-')
where suite_type_key is null and replace(lower(suite_type),'_','-') in (select suite_type_key from app.validation_suite_types);
create or replace function app.assign_validation_suite_type_key()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  new.suite_type_key := coalesce(new.suite_type_key,replace(lower(new.suite_type),'_','-'));
  if not exists(select 1 from app.validation_suite_types where suite_type_key=new.suite_type_key and retired_at is null) then
    raise exception 'validation_suite:unregistered_type:%',new.suite_type;
  end if;
  return new;
end; $$;
create trigger validation_suites_assign_type before insert or update of suite_type,suite_type_key
  on app.validation_suites for each row execute function app.assign_validation_suite_type_key();
create index validation_suites_type_idx on app.validation_suites(suite_type_key);
create index validation_suites_supersedes_idx on app.validation_suites(supersedes_suite_version_id)
  where supersedes_suite_version_id is not null;

alter table app.validation_runs add column if not exists target_kind text,
  add column if not exists runner_build text,
  add column if not exists evidence_uri text,
  add column if not exists evidence_sha256 text,
  add column if not exists invalidated_at timestamptz,
  add column if not exists invalidation_reason text;
update app.validation_runs vr set target_kind='content-version'
where target_kind is null and cardinality(target_version_ids)>0
  and not exists(select 1 from unnest(vr.target_version_ids) x(id)
    left join app.content_item_versions c on c.id=x.id where c.id is null);
alter table app.validation_runs alter column target_kind set default 'content-version';

create view app.validation_suite_versions with (security_invoker = true) as
select suite_version_id, suite_id, suite_type_key, name, exam_id, input_contract_version,
  runner_kind, deterministic_configuration, expected_target_kind, content_sha256,
  supersedes_suite_version_id, created_at, created_by
from app.validation_suites;

-- A suite version's meaning is historical evidence and cannot be rewritten.
create trigger validation_suites_reject_immutable_mutation before update or delete on app.validation_suites
  for each row execute function app.reject_immutable_record_mutation();

create or replace function app.validation_run_is_current(
  p_run_id uuid, p_content_item_version_id uuid, p_gate_category text default null
) returns boolean language sql stable security invoker set search_path = '' as $$
  select exists (
    select 1 from app.validation_runs vr
    join app.validation_suites vs on vs.suite_version_id=vr.suite_version_id
    join app.validation_suite_types vst on vst.suite_type_key=vs.suite_type_key
    where vr.run_id=p_run_id and vr.status='passed' and vr.completed_at is not null
      and vr.invalidated_at is null and vr.target_kind='content-version'
      and vst.retired_at is null
      and (vs.expected_target_kind is null or vs.expected_target_kind='content-version')
      and 'content-version'=any(vst.target_kinds)
      and vr.target_version_ids @> array[p_content_item_version_id]
      and (p_gate_category is null or vst.gate_category=p_gate_category)
  );
$$;

create table app.calibration_evidence_records (
  calibration_evidence_record_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete restrict,
  validation_run_id uuid not null references app.validation_runs(run_id) on delete restrict,
  profile_version text not null, gold_item_count integer not null check(gold_item_count>0),
  adjudicated_gold_item_count integer not null check(adjudicated_gold_item_count>=0),
  metrics jsonb not null, evidence_uri text not null, evidence_sha256 text not null check(evidence_sha256 ~ '^[a-f0-9]{64}$'),
  status text not null check(status in ('passed','failed','invalidated')),
  created_at timestamptz not null default now(), created_by uuid not null references app.profiles(user_id),
  check(adjudicated_gold_item_count<=gold_item_count), unique(content_item_version_id,validation_run_id,profile_version)
);
create index calibration_evidence_content_idx on app.calibration_evidence_records(content_item_version_id);
create index calibration_evidence_run_idx on app.calibration_evidence_records(validation_run_id);
create index calibration_evidence_created_by_idx on app.calibration_evidence_records(created_by);

create or replace function app.calibration_requirement_satisfied(p_content_item_version_id uuid)
returns boolean language sql stable security invoker set search_path='' as $$
  with requirement as (
    select coalesce((spa.package_payload#>>'{verification,gold_set_required}')::boolean,false) required,
      coalesce((spa.package_payload#>>'{verification,minimum_gold_items}')::int,0) minimum_gold_items,
      spa.package_payload#>>'{verification,profile_version}' profile_version
    from app.item_package_applications ipa join app.subject_package_applications spa
      on spa.subject_package_application_id=ipa.subject_package_application_id
    where ipa.content_item_version_id=p_content_item_version_id limit 1
  )
  select case when not exists(select 1 from app.content_item_versions where id=p_content_item_version_id) then false
  when not exists(select 1 from requirement) then true else (select not requirement.required or exists(
    select 1 from app.calibration_evidence_records c
    where c.content_item_version_id=p_content_item_version_id and c.profile_version=requirement.profile_version
      and c.status='passed' and c.gold_item_count>=requirement.minimum_gold_items
      and c.adjudicated_gold_item_count>=requirement.minimum_gold_items
      and app.validation_run_is_current(c.validation_run_id,p_content_item_version_id,'grading_calibration')
  ) from requirement) end;
$$;

create table app.review_policy_versions (
  review_policy_version_id uuid primary key default gen_random_uuid(),
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete restrict,
  semantic_version text not null, required_capabilities text[] not null,
  independence_required boolean not null, minimum_reviewers integer not null check (minimum_reviewers > 0),
  policy_sha256 text not null check (policy_sha256 ~ '^[a-f0-9]{64}$'),
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  unique(exam_pack_version_id,semantic_version)
);
create index review_policy_versions_created_by_idx on app.review_policy_versions(created_by);

create table app.qualification_evidence_records (
  qualification_evidence_record_id uuid primary key default gen_random_uuid(),
  evidence_type text not null check(evidence_type in ('credential','work-sample','training','assessment','attestation')),
  evidence_uri text not null, evidence_sha256 text not null check(evidence_sha256 ~ '^[a-f0-9]{64}$'),
  status text not null check(status in ('verified','rejected','expired','revoked')),
  effective_at timestamptz not null, expires_at timestamptz not null,
  verified_by uuid not null references app.profiles(user_id), verified_at timestamptz not null,
  created_at timestamptz not null default now(), check(expires_at>effective_at)
);
create index qualification_evidence_verified_by_idx on app.qualification_evidence_records(verified_by);

create table app.reviewer_capability_assignments (
  reviewer_capability_assignment_id uuid primary key default gen_random_uuid(),
  reviewer_id uuid not null references app.profiles(user_id) on delete restrict,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete restrict,
  review_policy_version_id uuid not null references app.review_policy_versions(review_policy_version_id) on delete restrict,
  capability_code text not null,
  effective_at timestamptz not null, expires_at timestamptz not null,
  status text not null check (status='active'),
  assignment_sha256 text not null check(assignment_sha256 ~ '^[a-f0-9]{64}$'),
  granted_by uuid not null references app.profiles(user_id), created_at timestamptz not null default now(),
  check (expires_at > effective_at),
  unique(reviewer_id,review_policy_version_id,capability_code,assignment_sha256)
);
create index reviewer_capability_assignments_reviewer_idx on app.reviewer_capability_assignments(reviewer_id);
create index reviewer_capability_assignments_granted_by_idx on app.reviewer_capability_assignments(granted_by);
create index reviewer_capability_assignments_pack_idx on app.reviewer_capability_assignments(exam_pack_version_id);
create index reviewer_capability_assignments_policy_idx on app.reviewer_capability_assignments(review_policy_version_id);

create table app.reviewer_capability_evidence (
  reviewer_capability_assignment_id uuid not null references app.reviewer_capability_assignments(reviewer_capability_assignment_id) on delete restrict,
  qualification_evidence_record_id uuid not null references app.qualification_evidence_records(qualification_evidence_record_id) on delete restrict,
  primary key(reviewer_capability_assignment_id,qualification_evidence_record_id)
);
create index reviewer_capability_evidence_record_idx on app.reviewer_capability_evidence(qualification_evidence_record_id);

create table app.reviewer_capability_revocations (
  reviewer_capability_revocation_id uuid primary key default gen_random_uuid(),
  reviewer_capability_assignment_id uuid not null unique references app.reviewer_capability_assignments(reviewer_capability_assignment_id) on delete restrict,
  reason text not null check(length(btrim(reason))>0), revoked_at timestamptz not null default now(),
  revoked_by uuid not null references app.profiles(user_id)
);
create index reviewer_capability_revocations_revoked_by_idx on app.reviewer_capability_revocations(revoked_by);

create or replace function app.validate_reviewer_capability_assignment()
returns trigger language plpgsql security invoker set search_path='' as $$
declare v_pack uuid; v_expected text; begin
  select exam_pack_version_id into v_pack from app.review_policy_versions
    where review_policy_version_id=new.review_policy_version_id;
  if v_pack is distinct from new.exam_pack_version_id then raise exception 'reviewer_capability:policy_pack_mismatch'; end if;
  v_expected:=encode(extensions.digest(concat_ws('|',new.reviewer_id,new.exam_pack_version_id,
    new.review_policy_version_id,new.capability_code,new.effective_at,new.expires_at,new.granted_by),'sha256'),'hex');
  if new.assignment_sha256<>v_expected then raise exception 'reviewer_capability:assignment_hash_mismatch'; end if;
  return new;
end; $$;
create trigger reviewer_capability_assignments_validate before insert on app.reviewer_capability_assignments
  for each row execute function app.validate_reviewer_capability_assignment();

create or replace function app.provision_reviewer_capability(
  p_reviewer_id uuid,p_policy_version_id uuid,p_capability_code text,p_evidence_ids uuid[],
  p_effective_at timestamptz,p_expires_at timestamptz,p_granted_by uuid
) returns uuid language plpgsql security invoker set search_path='' as $$
declare v_pack uuid; v_id uuid; v_hash text; begin
  select exam_pack_version_id into v_pack from app.review_policy_versions
    where review_policy_version_id=p_policy_version_id and p_capability_code=any(required_capabilities);
  if not found then raise exception 'reviewer_capability:policy_capability_not_found'; end if;
  if cardinality(p_evidence_ids)=0 or exists(select 1 from unnest(p_evidence_ids) x(id)
    left join app.qualification_evidence_records e on e.qualification_evidence_record_id=x.id
    where e.status is distinct from 'verified' or e.effective_at>now() or e.expires_at<=now())
  then raise exception 'reviewer_capability:verified_evidence_required'; end if;
  v_hash:=encode(extensions.digest(concat_ws('|',p_reviewer_id,v_pack,p_policy_version_id,
    p_capability_code,p_effective_at,p_expires_at,p_granted_by),'sha256'),'hex');
  insert into app.reviewer_capability_assignments(reviewer_id,exam_pack_version_id,review_policy_version_id,
    capability_code,effective_at,expires_at,status,assignment_sha256,granted_by)
  values(p_reviewer_id,v_pack,p_policy_version_id,p_capability_code,p_effective_at,p_expires_at,'active',v_hash,p_granted_by)
  on conflict(reviewer_id,review_policy_version_id,capability_code,assignment_sha256) do nothing
  returning reviewer_capability_assignment_id into v_id;
  if v_id is null then select reviewer_capability_assignment_id into v_id from app.reviewer_capability_assignments
    where reviewer_id=p_reviewer_id and review_policy_version_id=p_policy_version_id
      and capability_code=p_capability_code and assignment_sha256=v_hash; end if;
  insert into app.reviewer_capability_evidence(reviewer_capability_assignment_id,qualification_evidence_record_id)
    select v_id,id from unnest(p_evidence_ids) x(id) on conflict do nothing;
  return v_id;
end; $$;

create table app.eligibility_evaluations (
  eligibility_evaluation_id uuid primary key default gen_random_uuid(), target_kind text not null,
  target_id uuid not null, policy_version_id uuid, eligible boolean not null,
  reason_codes text[] not null, evidence_record_ids uuid[] not null,
  evaluated_at timestamptz not null default now(), evaluated_by uuid references app.profiles(user_id)
);
create index eligibility_evaluations_target_idx on app.eligibility_evaluations(target_kind,target_id,evaluated_at desc);

create table app.governance_role_assignments (
  governance_role_assignment_id uuid primary key default gen_random_uuid(),
  actor_id uuid not null references app.profiles(user_id) on delete restrict,
  role_key text not null check (role_key in ('product-owner')),
  decision_id text not null, effective_at timestamptz not null, expires_at timestamptz,
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id)
);
create index governance_role_assignments_actor_idx on app.governance_role_assignments(actor_id,role_key);
create index governance_role_assignments_created_by_idx on app.governance_role_assignments(created_by);

create table app.execution_approvals (
  approval_id text primary key, environment text not null check(environment in ('dev','production')),
  scope_key text not null check(scope_key='subject-harness-apply'),
  package_id text not null, package_sha256 text not null check(package_sha256 ~ '^[a-f0-9]{64}$'),
  plan_sha256 text not null check(plan_sha256 ~ '^[a-f0-9]{64}$'),
  authorized_actor_id uuid not null references app.profiles(user_id),
  governance_role_assignment_id uuid not null references app.governance_role_assignments(governance_role_assignment_id) on delete restrict,
  approved_by uuid not null references app.profiles(user_id), effective_at timestamptz not null,
  expires_at timestamptz not null, status text not null check(status='active'), created_at timestamptz not null default now(),
  check(expires_at>effective_at)
);
create index execution_approvals_role_idx on app.execution_approvals(governance_role_assignment_id);
create index execution_approvals_approved_by_idx on app.execution_approvals(approved_by);
create index execution_approvals_actor_idx on app.execution_approvals(authorized_actor_id);
create table app.execution_approval_revocations (
  execution_approval_revocation_id uuid primary key default gen_random_uuid(), approval_id text not null unique
    references app.execution_approvals(approval_id) on delete restrict,
  reason text not null check(length(btrim(reason))>0), revoked_at timestamptz not null default now(),
  revoked_by uuid not null references app.profiles(user_id)
);
create index execution_approval_revocations_by_idx on app.execution_approval_revocations(revoked_by);
create table app.execution_approval_consumptions (
  execution_approval_consumption_id uuid primary key default gen_random_uuid(), approval_id text not null unique
    references app.execution_approvals(approval_id) on delete restrict,
  subject_package_application_id uuid not null unique references app.subject_package_applications(subject_package_application_id) on delete restrict,
  consumed_at timestamptz not null default now(), consumed_by uuid not null references app.profiles(user_id)
);
create index execution_approval_consumptions_by_idx on app.execution_approval_consumptions(consumed_by);

create table app.content_clearance_exceptions (
  exception_id uuid primary key default gen_random_uuid(), exception_type text not null check (exception_type='content-clearance'),
  scope_type text not null check (scope_type in ('content-version','manifest','exam-pack-version')),
  scope_id uuid not null, approved_by uuid not null references app.profiles(user_id),
  governance_role_assignment_id uuid not null references app.governance_role_assignments(governance_role_assignment_id) on delete restrict,
  approved_at timestamptz not null default now(), rationale text not null check(length(btrim(rationale))>0),
  evidence_record_ids uuid[] not null check(cardinality(evidence_record_ids)>0),
  effective_at timestamptz not null, expires_at timestamptz not null,
  supersedes_exception_id uuid references app.content_clearance_exceptions(exception_id) on delete restrict,
  created_by uuid not null references app.profiles(user_id), created_at timestamptz not null default now(),
  check(expires_at > effective_at)
);
create index content_clearance_exceptions_scope_idx on app.content_clearance_exceptions(scope_type,scope_id,expires_at);
create index content_clearance_exceptions_approved_by_idx on app.content_clearance_exceptions(approved_by);
create index content_clearance_exceptions_role_idx on app.content_clearance_exceptions(governance_role_assignment_id);
create index content_clearance_exceptions_supersedes_idx on app.content_clearance_exceptions(supersedes_exception_id)
  where supersedes_exception_id is not null;
create index content_clearance_exceptions_created_by_idx on app.content_clearance_exceptions(created_by);

create table app.content_clearance_exception_revocations (
  revocation_event_id uuid primary key default gen_random_uuid(),
  exception_id uuid not null references app.content_clearance_exceptions(exception_id) on delete restrict,
  reason text not null, revoked_at timestamptz not null default now(),
  revoked_by uuid not null references app.profiles(user_id), unique(exception_id)
);
create index content_clearance_exception_revocations_revoked_by_idx on app.content_clearance_exception_revocations(revoked_by);

create or replace function app.has_active_content_clearance_exception(
  p_content_item_version_id uuid
) returns boolean
language sql stable security invoker set search_path = '' as $$
  select app.active_content_clearance_exception_id(p_content_item_version_id) is not null;
$$;

create or replace function app.active_content_clearance_exception_id(
  p_content_item_version_id uuid
) returns uuid language sql stable security invoker set search_path='' as $$
  select cce.exception_id
  from app.content_clearance_exceptions cce
  join app.governance_role_assignments gra
    on gra.governance_role_assignment_id=cce.governance_role_assignment_id
   and gra.actor_id=cce.approved_by and gra.role_key='product-owner'
   and gra.effective_at<=now() and (gra.expires_at is null or gra.expires_at>now())
  where cce.scope_type='content-version' and cce.scope_id=p_content_item_version_id
    and cce.exception_type='content-clearance'
    and cce.effective_at<=now() and cce.expires_at>now()
    and not exists (select 1 from app.content_clearance_exception_revocations r where r.exception_id=cce.exception_id)
    and not exists (select 1 from app.content_clearance_exceptions newer where newer.supersedes_exception_id=cce.exception_id)
  order by cce.approved_at desc,cce.exception_id limit 1;
$$;

alter table app.exam_pack_manifests add column if not exists content_clearance_exception_id uuid
  references app.content_clearance_exceptions(exception_id) on delete restrict;
create index exam_pack_manifests_clearance_exception_idx on app.exam_pack_manifests(content_clearance_exception_id)
  where content_clearance_exception_id is not null;

create or replace function app.enforce_typed_manifest_validation()
returns trigger language plpgsql security invoker set search_path = '' as $$
declare v_content_version uuid; v_exception uuid; v_payload jsonb; v_expected text;
begin
  if exists (
    select 1 from unnest(new.validation_run_ids) requested(run_id)
    left join app.validation_runs vr on vr.run_id=requested.run_id
    left join app.validation_suites vs on vs.suite_version_id=vr.suite_version_id
    left join app.validation_suite_types vst on vst.suite_type_key=vs.suite_type_key
    where vst.suite_type_key is null or vst.retired_at is not null or vr.invalidated_at is not null
      or vr.target_kind is distinct from 'content-version'
      or (vs.expected_target_kind is not null and vs.expected_target_kind<>'content-version')
  ) then raise exception 'publish_content:untyped_validation_evidence'; end if;
  if not exists (
    select 1 from app.validation_runs vr join app.validation_suites vs on vs.suite_version_id=vr.suite_version_id
    join app.validation_suite_types vst on vst.suite_type_key=vs.suite_type_key
    where vr.run_id=any(new.validation_run_ids) and vst.gate_category='grading_calibration'
  ) then raise exception 'publish_content:typed_grading_gate_failed'; end if;
  if not exists (
    select 1 from app.validation_runs vr join app.validation_suites vs on vs.suite_version_id=vr.suite_version_id
    join app.validation_suite_types vst on vst.suite_type_key=vs.suite_type_key
    where vr.run_id=any(new.validation_run_ids) and vst.gate_category='security_privacy'
  ) then raise exception 'publish_content:typed_security_privacy_gate_failed'; end if;
  foreach v_content_version in array new.artifact_version_ids loop
    if exists(select 1 from unnest(new.validation_run_ids) r(run_id)
      where not app.validation_run_is_current(r.run_id,v_content_version,null)) then
      raise exception 'publish_content:validation_target_or_invalidation_failed';
    end if;
  end loop;
  if cardinality(new.artifact_version_ids)=1 then
    v_exception:=app.active_content_clearance_exception_id(new.artifact_version_ids[1]);
    new.content_clearance_exception_id:=v_exception;
  end if;
  select jsonb_build_object('schema_version','1.0.0','exam_id',new.exam_id,'school_year',new.school_year,
    'exam_pack_version',new.exam_pack_version,'content_versions',jsonb_agg(jsonb_build_object(
      'ordinal',member.ordinality,'content_item_version_id',civ.id,'content_key_snapshot',ci.content_key,
      'content_sha256',civ.content_hash) order by member.ordinality),
    'source_version_ids',to_jsonb(new.source_version_ids),'rights_record_ids',to_jsonb(new.rights_record_ids),
    'validator_policy_version_id',new.validator_policy_version_id,'teaching_policy_version_id',new.teaching_policy_version_id,
    'grading_policy_version_id',new.grading_policy_version_id,'prompt_version_ids',to_jsonb(new.prompt_version_ids),
    'model_configuration_version_ids',to_jsonb(new.model_configuration_version_ids),
    'validation_run_ids',to_jsonb(new.validation_run_ids),'qualification_rule_version_ids',to_jsonb(new.qualification_rule_version_ids),
    'content_clearance_exception_id',new.content_clearance_exception_id)
    into v_payload from unnest(new.artifact_version_ids) with ordinality member(id,ordinality)
    join app.content_item_versions civ on civ.id=member.id join app.content_items ci on ci.id=civ.content_item_id;
  v_expected:=encode(extensions.digest(v_payload::text,'sha256'),'hex');
  if new.manifest_sha256<>v_expected then raise exception 'publish_content:manifest_hash_mismatch'; end if;
  return new;
end; $$;
create trigger exam_pack_manifests_typed_validation before insert on app.exam_pack_manifests
for each row execute function app.enforce_typed_manifest_validation();

create or replace function app.project_manifest_content_versions()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  if cardinality(new.artifact_version_ids) <> cardinality(array(select distinct unnest(new.artifact_version_ids))) then
    raise exception 'publish_content:duplicate_manifest_content_version';
  end if;
  if exists (select 1 from unnest(new.artifact_version_ids) member(content_version_id)
    left join app.content_item_versions civ on civ.id=member.content_version_id where civ.id is null) then
    raise exception 'publish_content:legacy_manifest_member_unresolved';
  end if;
  if exists(select 1 from unnest(new.artifact_version_ids) member(id)
    where exists(select 1 from app.content_item_versions c where c.id=member.id)
      and exists(select 1 from app.artifact_versions a where a.artifact_version_id=member.id)) then
    raise exception 'publish_content:legacy_manifest_member_ambiguous';
  end if;
  insert into app.exam_pack_manifest_content_versions(manifest_id,ordinal,content_item_version_id,
    content_key_snapshot,content_sha256,created_by)
  select new.manifest_id,member.ordinality,civ.id,ci.content_key,civ.content_hash,new.created_by
  from unnest(new.artifact_version_ids) with ordinality member(id,ordinality)
  join app.content_item_versions civ on civ.id=member.id
  join app.content_items ci on ci.id=civ.content_item_id order by member.ordinality;
  return new;
end; $$;
create trigger exam_pack_manifests_project_content_versions after insert on app.exam_pack_manifests
for each row execute function app.project_manifest_content_versions();
create trigger exam_pack_manifests_reject_immutable_mutation before update or delete on app.exam_pack_manifests
  for each row execute function app.reject_immutable_record_mutation();

create or replace function app.content_publication_gate_status(
  p_content_version_id uuid,p_source_ids uuid[],p_rights_ids uuid[],p_validation_run_ids uuid[],
  p_actor_id uuid,p_approved_by uuid[],p_validator_policy_version_id uuid,
  p_teaching_policy_version_id uuid,p_grading_policy_version_id uuid
) returns jsonb language plpgsql stable security invoker set search_path='' as $$
declare v_source boolean; v_rights boolean; v_clearance boolean; v_validation boolean;
  v_grading boolean; v_calibration boolean; v_security boolean; v_release boolean;
  v_unique boolean; v_exception uuid; v_reasons text[]:='{}'; v_review text;
begin
  v_unique:=cardinality(coalesce(p_source_ids,'{}'))=cardinality(array(select distinct unnest(coalesce(p_source_ids,'{}'))))
    and cardinality(coalesce(p_rights_ids,'{}'))=cardinality(array(select distinct unnest(coalesce(p_rights_ids,'{}'))))
    and cardinality(coalesce(p_validation_run_ids,'{}'))=cardinality(array(select distinct unnest(coalesce(p_validation_run_ids,'{}'))))
    and cardinality(coalesce(p_approved_by,'{}'))=cardinality(array(select distinct unnest(coalesce(p_approved_by,'{}'))));
  select review_status into v_review from app.content_item_versions where id=p_content_version_id;
  v_source:=v_unique and cardinality(coalesce(p_source_ids,'{}'))>0 and not exists(select 1 from unnest(coalesce(p_source_ids,'{}')) x(id)
    left join app.source_records s on s.source_version_id=x.id where s.source_version_id is null
      or s.provenance_status<>'verified' or s.next_refresh_due_at<=now());
  v_rights:=v_unique and cardinality(coalesce(p_rights_ids,'{}'))>0 and not exists(select 1 from unnest(coalesce(p_rights_ids,'{}')) x(id)
    left join app.rights_records r on r.rights_record_id=x.id where r.rights_record_id is null
      or not r.source_version_id=any(p_source_ids)
      or r.rights_status not in ('cramapple_owned','public_domain','licensed','written_permission')
      or (r.license_expires_at is not null and r.license_expires_at<=now()) or r.next_review_due_at<=now()
      or (r.legal_approval_required and r.legal_approval_id is null))
    and not exists(select 1 from unnest(p_source_ids) s(id) where not exists(select 1 from app.rights_records r
      where r.rights_record_id=any(p_rights_ids) and r.source_version_id=s.id
        and r.rights_status in ('cramapple_owned','public_domain','licensed','written_permission')
        and (r.license_expires_at is null or r.license_expires_at>now()) and r.next_review_due_at>now()
        and (not r.legal_approval_required or r.legal_approval_id is not null)));
  v_exception:=app.active_content_clearance_exception_id(p_content_version_id);
  v_clearance:=coalesce(v_review in ('question_review_approved','difficulty_confirmed','mcq_answer_review_complete'),false) or v_exception is not null;
  v_validation:=v_unique and cardinality(coalesce(p_validation_run_ids,'{}'))>0 and not exists(select 1 from unnest(coalesce(p_validation_run_ids,'{}')) r(id)
    where not app.validation_run_is_current(r.id,p_content_version_id,null));
  v_grading:=exists(select 1 from unnest(p_validation_run_ids) r(id)
    where app.validation_run_is_current(r.id,p_content_version_id,'grading_calibration'));
  v_calibration:=app.calibration_requirement_satisfied(p_content_version_id);
  v_security:=exists(select 1 from unnest(p_validation_run_ids) r(id)
    where app.validation_run_is_current(r.id,p_content_version_id,'security_privacy'));
  v_release:=v_unique and p_actor_id=any(coalesce(p_approved_by,'{}')) and p_validator_policy_version_id is not null
    and p_teaching_policy_version_id is not null and p_grading_policy_version_id is not null
    and exists(select 1 from app.profiles where user_id=p_actor_id and role='admin');
  if not v_unique then v_reasons:=array_append(v_reasons,'evidence.duplicate_identifier'); end if;
  if not v_source then v_reasons:=array_append(v_reasons,'source.failed'); end if;
  if not v_rights then v_reasons:=array_append(v_reasons,'rights.failed'); end if;
  if not v_clearance then v_reasons:=array_append(v_reasons,'content_clearance.failed'); end if;
  if not v_validation then v_reasons:=array_append(v_reasons,'validation.failed'); end if;
  if not v_grading then v_reasons:=array_append(v_reasons,'grading.failed'); end if;
  if not v_calibration then v_reasons:=array_append(v_reasons,'calibration.failed'); end if;
  if not v_security then v_reasons:=array_append(v_reasons,'security_privacy.failed'); end if;
  if not v_release then v_reasons:=array_append(v_reasons,'release_approval.failed'); end if;
  return jsonb_build_object('content_version_id',p_content_version_id,'source',v_source,'rights',v_rights,
    'content_clearance',v_clearance,'content_clearance_exception_id',v_exception,'validation',v_validation,
    'grading',v_grading,'calibration',v_calibration,'security_privacy',v_security,'release_approval',v_release,
    'evidence_identifiers_unique',v_unique,'eligible',cardinality(v_reasons)=0,'reason_codes',to_jsonb(v_reasons));
end;
$$;

create or replace function app.content_publication_gate_status(p_request jsonb)
returns jsonb language sql stable security invoker set search_path='' as $$
  select app.content_publication_gate_status(
    nullif(p_request->>'content_item_version_id','')::uuid,
    array(select value::uuid from jsonb_array_elements_text(coalesce(p_request->'source_version_ids','[]'))),
    array(select value::uuid from jsonb_array_elements_text(coalesce(p_request->'rights_record_ids','[]'))),
    array(select value::uuid from jsonb_array_elements_text(coalesce(p_request->'validation_run_ids','[]'))),
    nullif(p_request->>'actor_id','')::uuid,
    array(select value::uuid from jsonb_array_elements_text(coalesce(p_request->'approved_by','[]'))),
    nullif(p_request->>'validator_policy_version_id','')::uuid,
    nullif(p_request->>'teaching_policy_version_id','')::uuid,
    nullif(p_request->>'grading_policy_version_id','')::uuid
  );
$$;

create or replace function app.evaluate_reviewer_eligibility(
  p_policy_version_id uuid, p_reviewer_id uuid, p_author_ids uuid[] default '{}')
returns jsonb language plpgsql security invoker set search_path = '' as $$
declare v_policy app.review_policy_versions%rowtype; v_missing text[]; v_evidence_ids uuid[]; v_eligible boolean; v_reasons text[]; begin
  select * into v_policy from app.review_policy_versions where review_policy_version_id=p_policy_version_id;
  if not found then v_reasons:=array['policy.not_found'];
  elsif v_policy.independence_required and p_reviewer_id=any(p_author_ids) then v_reasons:=array['reviewer.independence_failed'];
  else
  select coalesce(array_agg(capability), '{}') into v_missing from unnest(v_policy.required_capabilities) capability
  where not exists (select 1 from app.reviewer_capability_assignments r
    where r.reviewer_id=p_reviewer_id and r.capability_code=capability and r.status='active'
      and r.exam_pack_version_id=v_policy.exam_pack_version_id and r.review_policy_version_id=p_policy_version_id
      and r.effective_at<=now() and r.expires_at>now()
      and not exists(select 1 from app.reviewer_capability_revocations x where x.reviewer_capability_assignment_id=r.reviewer_capability_assignment_id)
      and exists(select 1 from app.reviewer_capability_evidence link join app.qualification_evidence_records e
        on e.qualification_evidence_record_id=link.qualification_evidence_record_id
        where link.reviewer_capability_assignment_id=r.reviewer_capability_assignment_id and e.status='verified'
          and e.effective_at<=now() and e.expires_at>now()));
  v_reasons:=case when cardinality(v_missing)>0 then array(select 'capability.missing:'||x from unnest(v_missing) x) else '{}'::text[] end;
  end if;
  v_eligible:=cardinality(v_reasons)=0;
  select coalesce(array_agg(distinct link.qualification_evidence_record_id),'{}') into v_evidence_ids
  from app.reviewer_capability_assignments r join app.reviewer_capability_evidence link
    on link.reviewer_capability_assignment_id=r.reviewer_capability_assignment_id
  where r.reviewer_id=p_reviewer_id and r.review_policy_version_id=p_policy_version_id;
  insert into app.eligibility_evaluations(target_kind,target_id,policy_version_id,eligible,reason_codes,evidence_record_ids,evaluated_by)
  values('reviewer',p_reviewer_id,p_policy_version_id,v_eligible,v_reasons,v_evidence_ids,p_reviewer_id);
  return jsonb_build_object('eligible',v_eligible,'reason_codes',to_jsonb(v_reasons),'evidence_record_ids',to_jsonb(v_evidence_ids));
end; $$;

create or replace function app.evaluate_review_team_eligibility(
  p_policy_version_id uuid,p_reviewer_ids uuid[],p_author_ids uuid[] default '{}')
returns jsonb language plpgsql security invoker set search_path='' as $$
declare v_min int; v_eligible int:=0; v_reviewer uuid; v_result jsonb; begin
  select minimum_reviewers into v_min from app.review_policy_versions where review_policy_version_id=p_policy_version_id;
  if not found then return jsonb_build_object('eligible',false,'reason_codes',jsonb_build_array('policy.not_found')); end if;
  if cardinality(p_reviewer_ids)<>cardinality(array(select distinct unnest(p_reviewer_ids))) then
    return jsonb_build_object('eligible',false,'reason_codes',jsonb_build_array('reviewer.duplicate'));
  end if;
  foreach v_reviewer in array p_reviewer_ids loop
    v_result:=app.evaluate_reviewer_eligibility(p_policy_version_id,v_reviewer,p_author_ids);
    if (v_result->>'eligible')::boolean then v_eligible:=v_eligible+1; end if;
  end loop;
  return jsonb_build_object('eligible',v_eligible>=v_min,'eligible_reviewers',v_eligible,'minimum_reviewers',v_min,
    'reason_codes',case when v_eligible>=v_min then '[]'::jsonb else jsonb_build_array('team.minimum_reviewers_not_met') end);
end; $$;

create or replace function app.enforce_content_review_assignment_eligibility()
returns trigger language plpgsql security invoker set search_path='' as $$
declare v_policy uuid; v_result jsonb; begin
  select rp.review_policy_version_id into v_policy
  from app.item_package_applications ipa
  join app.subject_package_applications spa on spa.subject_package_application_id=ipa.subject_package_application_id
  join app.review_policy_versions rp on rp.exam_pack_version_id=spa.exam_pack_version_id
    and rp.semantic_version=spa.package_payload#>>'{review_policy,policy_version}'
  where ipa.content_item_version_id=new.content_item_version_id;
  if v_policy is null then return new; end if;
  v_result:=app.evaluate_reviewer_eligibility(v_policy,new.reviewer_id,
    array(select created_by from app.content_item_versions where id=new.content_item_version_id and created_by is not null));
  if not (v_result->>'eligible')::boolean then
    raise exception 'review_assignment:reviewer_ineligible:%',v_result->'reason_codes';
  end if;
  return new;
end; $$;
do $$ begin
  if to_regclass('app.content_review_assignments') is not null then
    execute 'drop trigger if exists content_review_assignments_enforce_harness_eligibility on app.content_review_assignments';
    execute 'create trigger content_review_assignments_enforce_harness_eligibility before insert or update of reviewer_id,content_item_version_id on app.content_review_assignments for each row execute function app.enforce_content_review_assignment_eligibility()';
  end if;
end $$;

create or replace function app.apply_subject_package_atomic(
  p_compiled_plan jsonb,
  p_actor_id uuid,
  p_environment text,
  p_approval_id text default null
) returns jsonb
language plpgsql security invoker set search_path = '' as $$
declare
  v_subject_package jsonb := p_compiled_plan->'subject_package';
  v_subject_id uuid; v_exam_pack_id uuid; v_exam_pack_version_id uuid;
  v_scheme_id uuid; v_scheme_version_id uuid; v_policy_id uuid;
  v_subject_key text := v_subject_package#>>'{subject,subject_key}';
  v_operation text := v_subject_package->>'operation';
  v_exam_code text := v_subject_package#>>'{exam_pack,exam_code}';
  v_school_year text := v_subject_package#>>'{exam_pack,school_year}';
  v_package_hash text := p_compiled_plan->>'subject_package_sha256';
  v_plan_hash text := p_compiled_plan->>'plan_sha256';
  v_application_id uuid; v_archetype jsonb; v_node jsonb; v_item_plan jsonb;
  v_archetype_id uuid; v_archetype_version_id uuid; v_parent_id uuid;
  v_item jsonb; v_item_id uuid; v_item_version_id uuid; v_node_id uuid;
  v_item_hash text; v_db_hash text; v_capability jsonb; v_kind text;
begin
  if p_environment not in ('local','dev','production') then
    raise exception 'subject_harness:environment_required';
  end if;
  if p_environment in ('dev','production') and not exists(
    select 1 from app.execution_approvals ea join app.governance_role_assignments gra
      on gra.governance_role_assignment_id=ea.governance_role_assignment_id
    where ea.approval_id=p_approval_id and ea.environment=p_environment and ea.scope_key='subject-harness-apply'
      and ea.package_id=v_subject_package->>'package_id' and ea.package_sha256=v_package_hash
      and ea.plan_sha256=v_plan_hash and ea.authorized_actor_id=p_actor_id
      and ea.status='active' and ea.effective_at<=now() and ea.expires_at>now()
      and gra.role_key='product-owner' and gra.actor_id=ea.approved_by
      and gra.effective_at<=now() and (gra.expires_at is null or gra.expires_at>now())
      and not exists(select 1 from app.execution_approval_revocations r where r.approval_id=ea.approval_id)
      and (not exists(select 1 from app.execution_approval_consumptions c where c.approval_id=ea.approval_id)
        or exists(select 1 from app.execution_approval_consumptions c join app.subject_package_applications spa
          on spa.subject_package_application_id=c.subject_package_application_id
          where c.approval_id=ea.approval_id and spa.package_id=ea.package_id and spa.package_sha256=ea.package_sha256
            and spa.plan_sha256=ea.plan_sha256 and spa.environment=ea.environment and c.consumed_by=ea.authorized_actor_id))
  ) then
    raise exception 'subject_harness:authoritative_approval_required';
  end if;
  if not exists (select 1 from app.profiles where user_id=p_actor_id and role='admin') then
    raise exception 'subject_harness:admin_actor_required';
  end if;
  if v_operation not in ('create-subject','create-exam-pack-version') then
    raise exception 'subject_harness:invalid_operation';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(
    'subject-package:'||p_environment||':'||(v_subject_package->>'package_id'),0));
  if (p_compiled_plan->>'subject_package_canonical_json')::jsonb <> v_subject_package
    or encode(extensions.digest(p_compiled_plan->>'subject_package_canonical_json','sha256'),'hex') <> v_package_hash
    or (p_compiled_plan->>'taxonomy_canonical_json')::jsonb <> v_subject_package->'taxonomy'
    or encode(extensions.digest(p_compiled_plan->>'taxonomy_canonical_json','sha256'),'hex') <> p_compiled_plan->>'taxonomy_sha256'
    or (p_compiled_plan->>'review_policy_canonical_json')::jsonb <> v_subject_package->'review_policy'
    or encode(extensions.digest(p_compiled_plan->>'review_policy_canonical_json','sha256'),'hex') <> p_compiled_plan->>'review_policy_sha256'
    or (p_compiled_plan->>'plan_canonical_json')::jsonb <> (p_compiled_plan-'plan_sha256'-'plan_canonical_json')
    or encode(extensions.digest(p_compiled_plan->>'plan_canonical_json','sha256'),'hex') <> v_plan_hash
  then raise exception 'subject_harness:compiled_plan_hash_mismatch'; end if;
  if v_subject_package#>>'{exam_pack,official_exam_date}' !~ ('^' || (split_part(v_school_year,'-',1)::int + 1)::text || '-') then
    raise exception 'subject_harness:exam_date_academic_year_mismatch';
  end if;

  -- Recheck every declared platform capability at the trusted boundary.
  for v_capability in select value from jsonb_array_elements(
    jsonb_build_array(
      jsonb_build_object('kind','renderer','values',v_subject_package#>'{capabilities,required_renderers}'),
      jsonb_build_object('kind','response-modality','values',v_subject_package#>'{capabilities,required_response_modalities}'),
      jsonb_build_object('kind','grader','values',v_subject_package#>'{capabilities,required_graders}'),
      jsonb_build_object('kind','calculator','values',coalesce(v_subject_package#>'{capabilities,calculator_modes}','[]'::jsonb))
    )
  ) loop
    v_kind := v_capability->>'kind';
    if exists (
      select 1 from jsonb_array_elements_text(v_capability->'values') requested(code)
      left join app.platform_capabilities pc on pc.capability_kind=v_kind and pc.capability_code=requested.code
      where pc.capability_code is null or pc.support_status <> 'supported'
    ) then raise exception 'subject_harness:capability_preflight_failed:%', v_kind; end if;
  end loop;

  if v_operation='create-exam-pack-version' then
    select id into v_subject_id from app.subjects where subject_key=v_subject_package#>>'{subject,existing_subject_key}' for update;
    if not found or v_subject_key <> v_subject_package#>>'{subject,existing_subject_key}' then
      raise exception 'subject_harness:existing_subject_not_found';
    end if;
  else
    if exists(select 1 from app.subjects where subject_key=v_subject_key)
      and not exists(select 1 from app.subject_package_applications
        where package_id=v_subject_package->>'package_id' and package_sha256=v_package_hash and environment=p_environment)
    then raise exception 'subject_harness:create_subject_already_exists'; end if;
    insert into app.subjects(subject_key,display_name,status)
    values(v_subject_key,v_subject_package#>>'{subject,display_name}','active')
    on conflict(subject_key) do update set display_name=app.subjects.display_name
    returning id into v_subject_id;
  end if;

  insert into app.exam_packs(exam_code,exam_name,subject_id)
  values(v_exam_code,v_subject_package#>>'{exam_pack,exam_name}',v_subject_id)
  on conflict(exam_code) do update set exam_name=excluded.exam_name
    where app.exam_packs.subject_id=excluded.subject_id
  returning id into v_exam_pack_id;
  if v_exam_pack_id is null then raise exception 'subject_harness:exam_code_subject_conflict'; end if;

  insert into app.exam_pack_versions(exam_pack_id,school_year,official_exam_date,status,source_uri,exam_pack_semver,created_by)
  values(v_exam_pack_id,v_school_year,(v_subject_package#>>'{exam_pack,official_exam_date}')::date,'draft',
    (v_subject_package#>'{sources,0}'->>'uri'),v_subject_package#>>'{exam_pack,exam_pack_version}',p_actor_id)
  on conflict(exam_pack_id,school_year) do update set
    official_exam_date=excluded.official_exam_date,
    exam_pack_semver=coalesce(app.exam_pack_versions.exam_pack_semver,excluded.exam_pack_semver)
  where app.exam_pack_versions.status='draft'
  returning id into v_exam_pack_version_id;
  if v_exam_pack_version_id is null then raise exception 'subject_harness:published_pack_is_immutable'; end if;
  if not exists(select 1 from app.exam_pack_versions where id=v_exam_pack_version_id
    and exam_pack_semver=v_subject_package#>>'{exam_pack,exam_pack_version}') then
    raise exception 'subject_harness:exam_pack_semver_conflict';
  end if;

  -- Stable IDs reconcile; immutable versions must match their canonical hash.
  insert into app.taxonomy_schemes(exam_pack_version_id,scheme_key,created_by)
  values(v_exam_pack_version_id,v_subject_package#>>'{taxonomy,scheme_key}',p_actor_id)
  on conflict(exam_pack_version_id,scheme_key) do update set scheme_key=excluded.scheme_key
  returning taxonomy_scheme_id into v_scheme_id;
  insert into app.taxonomy_scheme_versions(taxonomy_scheme_id,semantic_version,schema_version,definition_sha256,created_by)
  values(v_scheme_id,v_subject_package#>>'{taxonomy,scheme_version}',v_subject_package->>'schema_version',
    p_compiled_plan->>'taxonomy_sha256',p_actor_id)
  on conflict(taxonomy_scheme_id,semantic_version) do nothing returning taxonomy_scheme_version_id into v_scheme_version_id;
  if v_scheme_version_id is null then
    select taxonomy_scheme_version_id into v_scheme_version_id from app.taxonomy_scheme_versions
    where taxonomy_scheme_id=v_scheme_id and semantic_version=v_subject_package#>>'{taxonomy,scheme_version}'
      and definition_sha256=p_compiled_plan->>'taxonomy_sha256';
    if not found then raise exception 'subject_harness:taxonomy_version_hash_conflict'; end if;
  end if;

  for v_node in select value from jsonb_array_elements(v_subject_package#>'{taxonomy,nodes}') loop
    insert into app.taxonomy_node_versions(taxonomy_scheme_version_id,node_key,node_type,label,ordinal,source_refs,legacy_refs,node_sha256,created_by)
    values(v_scheme_version_id,v_node->>'node_key',v_node->>'node_type',v_node->>'label',(v_node->>'ordinal')::int,
      array(select jsonb_array_elements_text(coalesce(v_node->'source_refs','[]'))),
      array(select jsonb_array_elements_text(coalesce(v_node->'legacy_refs','[]'))),
      encode(extensions.digest((v_node-'node_sha256')::text,'sha256'),'hex'),p_actor_id)
    on conflict(taxonomy_scheme_version_id,node_key) do nothing;
  end loop;
  for v_node in select value from jsonb_array_elements(v_subject_package#>'{taxonomy,nodes}')
    where value ? 'parent_key' loop
    select taxonomy_node_version_id into v_node_id from app.taxonomy_node_versions
      where taxonomy_scheme_version_id=v_scheme_version_id and node_key=v_node->>'node_key';
    select taxonomy_node_version_id into v_parent_id from app.taxonomy_node_versions
      where taxonomy_scheme_version_id=v_scheme_version_id and node_key=v_node->>'parent_key';
    if v_parent_id is null then raise exception 'subject_harness:taxonomy_parent_not_found'; end if;
    insert into app.taxonomy_node_relations(taxonomy_scheme_version_id,from_node_version_id,to_node_version_id,relation_type,created_by)
      values(v_scheme_version_id,v_node_id,v_parent_id,'parent',p_actor_id) on conflict do nothing;
  end loop;

  for v_archetype in select value from jsonb_array_elements(v_subject_package->'archetypes') loop
    insert into app.item_archetypes(exam_pack_id,archetype_key,item_type,created_by)
    values(v_exam_pack_id,v_archetype->>'archetype_key',v_archetype->>'item_type',p_actor_id)
    on conflict(exam_pack_id,archetype_key) do update set archetype_key=excluded.archetype_key
    returning archetype_id into v_archetype_id;
    if not exists(select 1 from app.item_archetypes where archetype_id=v_archetype_id and item_type=v_archetype->>'item_type') then
      raise exception 'subject_harness:archetype_item_type_conflict';
    end if;
    v_db_hash := encode(extensions.digest(v_archetype::text,'sha256'),'hex');
    insert into app.item_archetype_versions(archetype_id,semantic_version,total_points,definition,content_sha256,created_by)
    values(v_archetype_id,v_archetype->>'version',(v_archetype->>'total_points')::int,v_archetype,v_db_hash,p_actor_id)
    on conflict(archetype_id,semantic_version) do nothing;
    if not exists(select 1 from app.item_archetype_versions where archetype_id=v_archetype_id
      and semantic_version=v_archetype->>'version' and content_sha256=v_db_hash) then
      raise exception 'subject_harness:archetype_version_hash_conflict';
    end if;
  end loop;

  insert into app.review_policy_versions(exam_pack_version_id,semantic_version,required_capabilities,
    independence_required,minimum_reviewers,policy_sha256,created_by)
  values(v_exam_pack_version_id,v_subject_package#>>'{review_policy,policy_version}',
    array(select jsonb_array_elements_text(v_subject_package#>'{review_policy,required_capabilities}')),
    (v_subject_package#>>'{review_policy,independence_required}')::boolean,
    coalesce((v_subject_package#>>'{review_policy,minimum_reviewers}')::int,1),
    p_compiled_plan->>'review_policy_sha256',p_actor_id)
  on conflict(exam_pack_version_id,semantic_version) do nothing returning review_policy_version_id into v_policy_id;
  if v_policy_id is null then
    select review_policy_version_id into v_policy_id from app.review_policy_versions
      where exam_pack_version_id=v_exam_pack_version_id and semantic_version=v_subject_package#>>'{review_policy,policy_version}'
        and policy_sha256=p_compiled_plan->>'review_policy_sha256';
    if not found then raise exception 'subject_harness:review_policy_hash_conflict'; end if;
  end if;

  if exists(select 1 from app.subject_package_applications where package_id=v_subject_package->>'package_id'
    and environment=p_environment and package_sha256<>v_package_hash) then
    raise exception 'subject_harness:package_id_hash_conflict';
  end if;
  insert into app.subject_package_applications(package_id,package_schema_version,operation,package_payload,subject_id,
    exam_pack_version_id,package_sha256,plan_sha256,environment,approval_id,applied_by)
  values(v_subject_package->>'package_id',v_subject_package->>'schema_version',v_operation,v_subject_package,v_subject_id,
    v_exam_pack_version_id,v_package_hash,v_plan_hash,p_environment,p_approval_id,p_actor_id)
  on conflict(package_id,environment) do nothing returning subject_package_application_id into v_application_id;
  if v_application_id is null then
    select subject_package_application_id into v_application_id from app.subject_package_applications
      where package_id=v_subject_package->>'package_id' and package_sha256=v_package_hash and environment=p_environment;
    if not found then raise exception 'subject_harness:package_id_hash_conflict'; end if;
  end if;
  if p_environment in ('dev','production') then
    insert into app.execution_approval_consumptions(approval_id,subject_package_application_id,consumed_by)
      values(p_approval_id,v_application_id,p_actor_id) on conflict(approval_id) do nothing;
    if not exists(select 1 from app.execution_approval_consumptions where approval_id=p_approval_id
      and subject_package_application_id=v_application_id and consumed_by=p_actor_id)
    then raise exception 'subject_harness:approval_replay_conflict'; end if;
  end if;

  for v_item_plan in select value from jsonb_array_elements(p_compiled_plan->'items') order by value#>>'{package,package_id}' loop
    v_item := v_item_plan->'package'; v_item_hash := v_item_plan->>'content_sha256';
    perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(
      'item-package:'||p_environment||':'||(v_item->>'package_id'),0));
    if (v_item_plan->>'canonical_json')::jsonb <> (v_item #- '{provenance,content_sha256}') then
      raise exception 'subject_harness:canonical_item_payload_mismatch';
    end if;
    if encode(extensions.digest(v_item_plan->>'canonical_json','sha256'),'hex') <> v_item_hash then
      raise exception 'subject_harness:item_hash_mismatch';
    end if;
    if exists(
      select 1 from jsonb_path_query(v_item,'$.parts.**.response_modalities[*]') modality
      left join app.platform_capabilities pc on pc.capability_kind='response-modality'
        and pc.capability_code=trim(both '"' from modality::text)
      where pc.capability_code is null or pc.support_status<>'supported'
        or not (v_subject_package#>'{capabilities,required_response_modalities}') ? trim(both '"' from modality::text)
    ) then raise exception 'subject_harness:item_response_modality_preflight_failed'; end if;
    if exists(
      select 1 from jsonb_array_elements(coalesce(v_item->'stimuli','[]')) stimulus
      cross join lateral (select case stimulus->>'kind' when 'text' then 'markdown' when 'table' then 'table'
        when 'dataset' then 'table' when 'formula' then 'math' when 'image' then 'image' when 'chart' then 'chart' end) needed(code)
      left join app.platform_capabilities pc on pc.capability_kind='renderer' and pc.capability_code=needed.code
      where needed.code is null or pc.support_status is distinct from 'supported'
        or not (v_subject_package#>'{capabilities,required_renderers}') ? needed.code
    ) then raise exception 'subject_harness:item_stimulus_renderer_preflight_failed'; end if;
    if exists(
      select 1 from jsonb_path_query(v_item,'$.parts.**.criteria[*].deterministic_checks[*]') chk
      left join app.deterministic_check_types dct on dct.check_type_key=chk->>'check_type' and dct.active
      left join app.verifier_plugin_versions vpv on vpv.verifier_plugin_version_id=dct.verifier_plugin_version_id
      where dct.check_type_key is null or (dct.runner_kind='reviewed-plugin' and vpv.review_status is distinct from 'approved')
        or (dct.parameter_contract->>'additional_properties')::boolean=false and exists(
          select 1 from jsonb_object_keys(coalesce(chk->'parameters','{}')) k
          where not (dct.parameter_contract->'properties' ? k))
        or exists(select 1 from jsonb_array_elements_text(coalesce(dct.parameter_contract->'required','[]')) required(k)
          where not (coalesce(chk->'parameters','{}') ? required.k))
        or exists(select 1 from jsonb_object_keys(coalesce(chk->'parameters','{}')) k
          where dct.parameter_contract->'properties' ? k
            and jsonb_typeof(chk->'parameters'->k)<>dct.parameter_contract#>>array['properties',k])
    ) then raise exception 'subject_harness:deterministic_check_registry_failed'; end if;
    if exists(select 1 from app.item_package_applications ipa
      where ipa.environment=p_environment and ipa.package_id=v_item->>'package_id' and ipa.package_sha256<>v_item_hash)
    then raise exception 'subject_harness:item_package_id_hash_conflict'; end if;
    select iav.archetype_version_id into v_archetype_version_id from app.item_archetype_versions iav
    join app.item_archetypes ia on ia.archetype_id=iav.archetype_id
    where ia.exam_pack_id=v_exam_pack_id and ia.archetype_key=v_item#>>'{archetype_ref,archetype_key}'
      and iav.semantic_version=v_item#>>'{archetype_ref,version}';
    if not found then raise exception 'subject_harness:archetype_ref_not_found'; end if;
    insert into app.content_items(exam_pack_version_id,content_key,item_type,title,status,created_by)
    values(v_exam_pack_version_id,v_item->>'content_key',v_item->>'item_type',v_item->>'content_key','draft',p_actor_id)
    on conflict(exam_pack_version_id,content_key) do update set title=app.content_items.title
    returning id into v_item_id;
    insert into app.content_item_versions(content_item_id,version_num,stem,prompt_json,content_hash,status,created_by,
      item_package_schema_version,item_package_payload,item_package_sha256,archetype_version_id)
    values(v_item_id,(v_item->>'content_version')::int,v_item#>>'{parts,0,prompt}',v_item,v_item_hash,'draft',p_actor_id,
      v_item->>'schema_version',v_item,v_item_hash,v_archetype_version_id)
    on conflict(content_item_id,version_num) do nothing returning id into v_item_version_id;
    if v_item_version_id is null then
      select id into v_item_version_id from app.content_item_versions where content_item_id=v_item_id
        and version_num=(v_item->>'content_version')::int and item_package_sha256=v_item_hash;
      if not found then raise exception 'subject_harness:item_version_hash_conflict'; end if;
    end if;
    for v_node in select value from jsonb_array_elements(v_item->'taxonomy_refs') loop
      select tnv.taxonomy_node_version_id into v_node_id from app.taxonomy_node_versions tnv
      join app.taxonomy_scheme_versions tsv on tsv.taxonomy_scheme_version_id=tnv.taxonomy_scheme_version_id
      join app.taxonomy_schemes ts on ts.taxonomy_scheme_id=tsv.taxonomy_scheme_id
      where ts.exam_pack_version_id=v_exam_pack_version_id and ts.scheme_key=v_node->>'scheme_key'
        and tsv.semantic_version=v_node->>'scheme_version' and tnv.node_key=v_node->>'node_key';
      if not found then raise exception 'subject_harness:taxonomy_ref_not_found'; end if;
      insert into app.content_version_taxonomy_assignments(content_item_version_id,taxonomy_node_version_id,
        assignment_role,provenance,created_by) values(v_item_version_id,v_node_id,
        case when v_node->>'node_key' like 'practice-%' then 'practice' else 'primary' end,
        jsonb_build_object('package_id',v_item->>'package_id'),p_actor_id) on conflict do nothing;
    end loop;
    insert into app.item_package_applications(subject_package_application_id,environment,package_id,package_sha256,
      content_item_version_id,applied_by) values(v_application_id,p_environment,v_item->>'package_id',v_item_hash,v_item_version_id,p_actor_id)
      on conflict(environment,package_id) do nothing;
    if not exists(select 1 from app.item_package_applications where environment=p_environment
      and package_id=v_item->>'package_id' and package_sha256=v_item_hash and content_item_version_id=v_item_version_id)
    then raise exception 'subject_harness:item_package_id_hash_conflict'; end if;
  end loop;
  return jsonb_build_object('application_id',v_application_id,'subject_id',v_subject_id,
    'exam_pack_version_id',v_exam_pack_version_id,'state','applied');
end; $$;

revoke all on function app.apply_subject_package_atomic(jsonb,uuid,text,text) from public,anon,authenticated;
grant execute on function app.apply_subject_package_atomic(jsonb,uuid,text,text) to service_role;

do $$ declare v_table regclass; begin foreach v_table in array array[
  'app.platform_capabilities'::regclass,'app.verifier_plugins'::regclass,'app.verifier_plugin_versions'::regclass,
  'app.deterministic_check_types'::regclass,'app.validation_suite_types'::regclass,
  'app.calibration_evidence_records'::regclass,
  'app.review_policy_versions'::regclass,'app.qualification_evidence_records'::regclass,
  'app.reviewer_capability_assignments'::regclass,'app.reviewer_capability_evidence'::regclass,
  'app.reviewer_capability_revocations'::regclass,
  'app.eligibility_evaluations'::regclass,'app.governance_role_assignments'::regclass,
  'app.execution_approvals'::regclass,'app.execution_approval_revocations'::regclass,
  'app.execution_approval_consumptions'::regclass,'app.content_clearance_exceptions'::regclass,
  'app.content_clearance_exception_revocations'::regclass
] loop execute format('create trigger reject_immutable_mutation before update or delete on %s for each row execute function app.reject_immutable_record_mutation()',v_table); end loop; end; $$;

alter table app.platform_capabilities enable row level security;
alter table app.verifier_plugins enable row level security;
alter table app.verifier_plugin_versions enable row level security;
alter table app.deterministic_check_types enable row level security;
alter table app.validation_suite_types enable row level security;
alter table app.calibration_evidence_records enable row level security;
alter table app.review_policy_versions enable row level security;
alter table app.qualification_evidence_records enable row level security;
alter table app.reviewer_capability_assignments enable row level security;
alter table app.reviewer_capability_evidence enable row level security;
alter table app.reviewer_capability_revocations enable row level security;
alter table app.eligibility_evaluations enable row level security;
alter table app.governance_role_assignments enable row level security;
alter table app.execution_approvals enable row level security;
alter table app.execution_approval_revocations enable row level security;
alter table app.execution_approval_consumptions enable row level security;
alter table app.content_clearance_exceptions enable row level security;
alter table app.content_clearance_exception_revocations enable row level security;

revoke all on app.platform_capabilities,app.verifier_plugins,app.verifier_plugin_versions,
  app.deterministic_check_types,app.validation_suite_types,app.calibration_evidence_records,
  app.validation_suite_versions,app.review_policy_versions,app.qualification_evidence_records,
  app.reviewer_capability_assignments,app.reviewer_capability_evidence,app.reviewer_capability_revocations,
  app.eligibility_evaluations,app.governance_role_assignments,app.execution_approvals,
  app.execution_approval_revocations,app.execution_approval_consumptions,app.content_clearance_exceptions,
  app.content_clearance_exception_revocations from public,anon,authenticated;
grant select on app.platform_capabilities,app.verifier_plugins,app.verifier_plugin_versions,
  app.deterministic_check_types,app.validation_suite_types,
  app.validation_suite_versions to service_role;
grant select,insert on app.calibration_evidence_records,app.review_policy_versions,app.qualification_evidence_records,
  app.reviewer_capability_assignments,app.reviewer_capability_evidence,app.reviewer_capability_revocations,
  app.eligibility_evaluations,app.governance_role_assignments,app.execution_approvals,
  app.execution_approval_revocations,app.execution_approval_consumptions,app.content_clearance_exceptions,
  app.content_clearance_exception_revocations to service_role;
revoke all on function app.evaluate_reviewer_eligibility(uuid,uuid,uuid[]) from public,anon,authenticated;
grant execute on function app.evaluate_reviewer_eligibility(uuid,uuid,uuid[]) to service_role;
revoke all on function app.evaluate_review_team_eligibility(uuid,uuid[],uuid[]) from public,anon,authenticated;
grant execute on function app.evaluate_review_team_eligibility(uuid,uuid[],uuid[]) to service_role;
revoke all on function app.provision_reviewer_capability(uuid,uuid,text,uuid[],timestamptz,timestamptz,uuid) from public,anon,authenticated;
grant execute on function app.provision_reviewer_capability(uuid,uuid,text,uuid[],timestamptz,timestamptz,uuid) to service_role;
revoke all on function app.has_active_content_clearance_exception(uuid) from public,anon,authenticated;
grant execute on function app.has_active_content_clearance_exception(uuid) to service_role;
revoke all on function app.active_content_clearance_exception_id(uuid) from public,anon,authenticated;
grant execute on function app.active_content_clearance_exception_id(uuid) to service_role;
revoke all on function app.calibration_requirement_satisfied(uuid) from public,anon,authenticated;
grant execute on function app.calibration_requirement_satisfied(uuid) to service_role;
revoke all on function app.content_publication_gate_status(uuid,uuid[],uuid[],uuid[],uuid,uuid[],uuid,uuid,uuid) from public,anon,authenticated;
grant execute on function app.content_publication_gate_status(uuid,uuid[],uuid[],uuid[],uuid,uuid[],uuid,uuid,uuid) to service_role;
revoke all on function app.content_publication_gate_status(jsonb) from public,anon,authenticated;
grant execute on function app.content_publication_gate_status(jsonb) to service_role;
revoke all on function app.enforce_content_review_assignment_eligibility() from public,anon,authenticated;

commit;
