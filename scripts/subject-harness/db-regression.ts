import { dirname, fromFileUrl } from "jsr:@std/path@1.1.2";
import { canonicalJson, compilePlan, sha256 } from "./compiler.ts";

const here = dirname(fromFileUrl(import.meta.url));
const fixtureRoot = `${here}/../../schemas/subject-onboarding/fixtures`;
const registryPath =
  `${here}/../../schemas/subject-onboarding/platform-capabilities.v1.json`;
const databaseUrl = Deno.args[0];
if (!databaseUrl) {
  throw new Error("usage: db-regression.ts <disposable-database-url>");
}
const read = async (path: string) => JSON.parse(await Deno.readTextFile(path));
const literal = (value: string) => `'${value.replaceAll("'", "''")}'`;
const actor = "00000000-0000-0000-0000-000000000001";
const reviewer = crypto.randomUUID();

async function sql(query: string) {
  const output = await new Deno.Command("psql", {
    args: [
      databaseUrl,
      "--no-psqlrc",
      "--set=ON_ERROR_STOP=1",
      "--tuples-only",
    ],
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  }).spawn();
  const writer = output.stdin.getWriter();
  await writer.write(new TextEncoder().encode(query));
  await writer.close();
  const result = await output.output();
  if (!result.success) throw new Error(new TextDecoder().decode(result.stderr));
  return new TextDecoder().decode(result.stdout).trim();
}

async function sqlOutcome(query: string) {
  const child = new Deno.Command("psql", {
    args: [
      databaseUrl,
      "--no-psqlrc",
      "--set=ON_ERROR_STOP=1",
      "--tuples-only",
    ],
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  }).spawn();
  const writer = child.stdin.getWriter();
  await writer.write(new TextEncoder().encode(query));
  await writer.close();
  return await child.output();
}

async function resign(plan: any) {
  for (const item of plan.items) {
    const unsigned = structuredClone(item.package);
    delete unsigned.provenance.content_sha256;
    item.canonical_json = canonicalJson(unsigned);
    item.content_sha256 = await sha256(item.canonical_json);
    item.package.provenance.content_sha256 = item.content_sha256;
  }
  const unsignedPlan = structuredClone(plan);
  delete unsignedPlan.plan_sha256;
  delete unsignedPlan.plan_canonical_json;
  plan.plan_canonical_json = canonicalJson(unsignedPlan);
  plan.plan_sha256 = await sha256(plan.plan_canonical_json);
  return plan;
}

const registry = await read(registryPath);
const base = await read(
  `${fixtureRoot}/ap-statistics-2026-27.subject-package.json`,
);

const chemistry = structuredClone(base);
chemistry.package_id = "ap-chemistry-scaffold-reconciliation";
chemistry.subject = {
  subject_key: "ap-chemistry",
  display_name: "AP Chemistry",
  existing_subject_key: "ap-chemistry",
};
chemistry.exam_pack = {
  exam_code: "ap_chemistry",
  exam_name: "AP Chemistry",
  school_year: "2025-26",
  official_exam_date: "2026-05-05",
  exam_pack_version: "1.0.0",
};
chemistry.sources[0].source_key = "ap-chemistry-scaffold-source";
chemistry.taxonomy = {
  scheme_key: "ap-chemistry-bespoke",
  scheme_version: "1.0.0",
  nodes: Array.from(
    { length: 9 },
    (_, index) => ({
      node_key: `unit-${index + 1}`,
      node_type: "unit",
      label: `AP Chemistry Unit ${index + 1}`,
      ordinal: index + 1,
      source_refs: ["ap-chemistry-scaffold-source"],
    }),
  ),
};
chemistry.blueprint.taxonomy_weights = chemistry.taxonomy.nodes.map((
  node: any,
) => ({ taxonomy_node_key: node.node_key, minimum: 0, maximum: 1 }));
chemistry.archetypes = [{
  archetype_key: "mcq-four-option",
  version: "1.0.0",
  item_type: "mcq",
  total_points: 1,
  practice_refs: [],
  response_modalities: ["choice"],
}];
chemistry.supersession = { strategy: "none", retire_content_keys: [] };
const chemistryPlan = await compilePlan(chemistry, [], registry);
const tamperedPlan = structuredClone(chemistryPlan);
(tamperedPlan.subject_package.subject as Record<string, unknown>).display_name =
  "Tampered";

const tamperResult = await sql(`do $$ begin
  begin
    perform app.apply_subject_package_atomic(${
  literal(JSON.stringify(tamperedPlan))
}::jsonb,${literal(actor)}::uuid,'local',null);
    raise exception 'TRUST:tampered_plan_was_accepted';
  exception when others then
    if sqlerrm not like 'subject_harness:compiled_plan_hash_mismatch%' then raise; end if;
  end;
end $$; select 'CANONICAL_PLAN_TAMPER_REJECTED';`);

const chemistryResult = await sql(`
select app.apply_subject_package_atomic(${
  literal(JSON.stringify(chemistryPlan))
}::jsonb,${literal(actor)}::uuid,'local',null);
do $$ declare v_pack uuid; v_count int; begin
  select epv.id into v_pack from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id
    where ep.exam_code='ap_chemistry' and epv.school_year='2025-26';
  if v_pack is null then raise exception 'AC4:chemistry_scaffold_not_reconciled'; end if;
  select count(*) into v_count from app.taxonomy_node_versions n join app.taxonomy_scheme_versions sv on sv.taxonomy_scheme_version_id=n.taxonomy_scheme_version_id
    join app.taxonomy_schemes s on s.taxonomy_scheme_id=sv.taxonomy_scheme_id where s.exam_pack_version_id=v_pack;
  if v_count<>9 then raise exception 'AC4:chemistry_taxonomy_count_%',v_count; end if;
  if exists(select 1 from app.content_items where exam_pack_version_id=v_pack and status='published') then raise exception 'AC4:chemistry_content_published'; end if;
end $$;
select 'CHEMISTRY_SCAFFOLD_PASS';`);

const created = structuredClone(base);
created.package_id = "rollback-create-subject-fixture";
created.operation = "create-subject";
created.subject = {
  subject_key: "rollback-fixture",
  display_name: "Rollback Fixture",
};
created.exam_pack = {
  exam_code: "rollback_fixture",
  exam_name: "Rollback Fixture",
  school_year: "2026-27",
  official_exam_date: "2027-05-01",
  exam_pack_version: "1.0.0",
};
created.sources[0].source_key = "rollback-fixture-source";
created.taxonomy = {
  scheme_key: "rollback-fixture-taxonomy",
  scheme_version: "1.0.0",
  nodes: [{
    node_key: "unit-1",
    node_type: "unit",
    label: "Fixture Unit",
    ordinal: 1,
    source_refs: ["rollback-fixture-source"],
  }],
};
created.blueprint.taxonomy_weights = [{
  taxonomy_node_key: "unit-1",
  minimum: 0,
  maximum: 1,
}];
created.archetypes = [{
  archetype_key: "mcq-four-option",
  version: "1.0.0",
  item_type: "mcq",
  total_points: 1,
  practice_refs: [],
  response_modalities: ["choice"],
}];
created.supersession = { strategy: "none", retire_content_keys: [] };
const createPlan = await compilePlan(created, [], registry);
const createResult = await sql(`begin;
select app.apply_subject_package_atomic(${
  literal(JSON.stringify(createPlan))
}::jsonb,${literal(actor)}::uuid,'local',null);
do $$ begin if not exists(select 1 from app.subjects where subject_key='rollback-fixture') then raise exception 'AC5:create_subject_missing'; end if; end $$;
rollback;
do $$ begin if exists(select 1 from app.subjects where subject_key='rollback-fixture') then raise exception 'AC5:rollback_failed'; end if; end $$;
select 'CREATE_SUBJECT_ROLLBACK_PASS';`);

const governanceResult = await sql(`
  do $$ declare v_policy uuid; v_pack uuid; v_item uuid; v_result jsonb; v_role uuid; v_exception uuid;
    v_evidence uuid; v_assignment uuid; v_capability text; begin
  insert into app.profiles(user_id,full_name,role) values(${
  literal(reviewer)
}::uuid,'H4 Regression Reviewer','validator');
  select review_policy_version_id into v_policy from app.review_policy_versions limit 1;
  v_result:=app.evaluate_reviewer_eligibility(v_policy,${
  literal(reviewer)
}::uuid,'{}');
  if (v_result->>'eligible')::boolean then raise exception 'H4:missing_evidence_failed_open'; end if;
  select exam_pack_version_id into v_pack from app.review_policy_versions where review_policy_version_id=v_policy;
  insert into app.qualification_evidence_records(evidence_type,evidence_uri,evidence_sha256,status,effective_at,expires_at,verified_by,verified_at)
    values('assessment','urn:test:h4',repeat('a',64),'verified',now()-interval '1 day',now()+interval '1 day',${
  literal(actor)
}::uuid,now())
    returning qualification_evidence_record_id into v_evidence;
  foreach v_capability in array (select required_capabilities from app.review_policy_versions where review_policy_version_id=v_policy) loop
    v_assignment:=app.provision_reviewer_capability(${
  literal(reviewer)
}::uuid,v_policy,v_capability,array[v_evidence],
      now()-interval '1 day',now()+interval '1 day',${literal(actor)}::uuid);
  end loop;
  v_result:=app.evaluate_reviewer_eligibility(v_policy,${
  literal(reviewer)
}::uuid,'{}');
  if not (v_result->>'eligible')::boolean then raise exception 'H4:qualified_reviewer_not_eligible'; end if;
  if not (app.evaluate_review_team_eligibility(v_policy,array[${
  literal(reviewer)
}::uuid],'{}')->>'eligible')::boolean
    then raise exception 'H4:minimum_reviewer_team_failed'; end if;
  insert into app.reviewer_capability_revocations(reviewer_capability_assignment_id,reason,revoked_by)
    values(v_assignment,'Regression revocation',${literal(actor)}::uuid);
  v_result:=app.evaluate_reviewer_eligibility(v_policy,${
  literal(reviewer)
}::uuid,'{}');
  if (v_result->>'eligible')::boolean then raise exception 'H4:revoked_capability_failed_open'; end if;
  if (select count(*)<3 from app.eligibility_evaluations where target_id=${
  literal(reviewer)
}::uuid)
    then raise exception 'H4:eligibility_evaluations_not_persisted'; end if;
  select id into v_item from app.content_item_versions where item_package_payload is not null limit 1;
  insert into app.governance_role_assignments(actor_id,role_key,decision_id,effective_at,created_by)
    values(${
  literal(actor)
}::uuid,'product-owner','DECISION-0040',now()-interval '1 day',${
  literal(actor)
}::uuid) returning governance_role_assignment_id into v_role;
  insert into app.content_clearance_exceptions(exception_type,scope_type,scope_id,approved_by,governance_role_assignment_id,rationale,evidence_record_ids,effective_at,expires_at,created_by)
    values('content-clearance','content-version',v_item,${
  literal(actor)
}::uuid,v_role,'Local H5 regression',array[gen_random_uuid()],now()-interval '1 minute',now()+interval '1 day',${
  literal(actor)
}::uuid)
    returning exception_id into v_exception;
  if not app.has_active_content_clearance_exception(v_item) then raise exception 'H5:valid_exception_not_resolved'; end if;
  insert into app.content_clearance_exception_revocations(exception_id,reason,revoked_by) values(v_exception,'Regression revocation',${
  literal(actor)
}::uuid);
  if app.has_active_content_clearance_exception(v_item) then raise exception 'H5:revoked_exception_failed_open'; end if;
end $$;
select 'H4_H5_FAIL_CLOSED_PASS';`);

const trustBoundaryPlan: any = structuredClone(
  await compilePlan(base, [
    await read(`${fixtureRoot}/ap-statistics-q1.item-package.json`),
  ], registry),
);
trustBoundaryPlan.items[0].package.parts[0].response_modalities = ["drawing"];
await resign(trustBoundaryPlan);
const trustBoundaryResult = await sql(`do $$ begin
  begin perform app.apply_subject_package_atomic(${
  literal(JSON.stringify(trustBoundaryPlan))
}::jsonb,${literal(actor)}::uuid,'local',null);
    raise exception 'TRUST:item_modality_bypass_accepted';
  exception when others then if sqlerrm not like 'subject_harness:item_response_modality_preflight_failed%' then raise; end if; end;
end $$; select 'DB_ITEM_CAPABILITY_FAIL_CLOSED_PASS';`);

const policyConflict = structuredClone(chemistry);
policyConflict.review_policy.required_capabilities.push(
  "conflicting-capability",
);
const policyConflictPlan = await compilePlan(policyConflict, [], registry);
const policyConflictResult = await sql(`do $$ begin
  begin perform app.apply_subject_package_atomic(${
  literal(JSON.stringify(policyConflictPlan))
}::jsonb,${literal(actor)}::uuid,'local',null);
    raise exception 'TRUST:policy_conflict_accepted';
  exception when others then if sqlerrm not like 'subject_harness:review_policy_hash_conflict%' then raise; end if; end;
end $$; select 'REVIEW_POLICY_CONFLICT_PASS';`);

const approvalResult = await sql(`do $$ begin
  begin perform app.apply_subject_package_atomic(${
  literal(JSON.stringify(chemistryPlan))
}::jsonb,${literal(actor)}::uuid,'dev','ARBITRARY-ID');
    raise exception 'TRUST:arbitrary_approval_accepted';
  exception when others then if sqlerrm not like 'subject_harness:authoritative_approval_required%' then raise; end if; end;
end $$; select 'AUTHORITATIVE_APPROVAL_FAIL_CLOSED_PASS';`);

const immutabilityResult = await sql(`do $$ declare v_item uuid; begin
  select id into v_item from app.content_item_versions where item_package_sha256 is not null limit 1;
  begin update app.content_item_versions set stem='tampered' where id=v_item;
    raise exception 'TRUST:canonical_item_mutation_accepted';
  exception when others then if sqlerrm not like 'subject_harness:item_package_snapshot_immutable%' then raise; end if; end;
end $$; select 'CANONICAL_ITEM_IMMUTABILITY_PASS';`);

const concurrentA = structuredClone(created);
concurrentA.package_id = "concurrent-create-subject";
concurrentA.subject = {
  subject_key: "concurrent-fixture",
  display_name: "Concurrent A",
};
concurrentA.exam_pack.exam_code = "concurrent_fixture";
concurrentA.exam_pack.exam_name = "Concurrent Fixture";
const concurrentB = structuredClone(concurrentA);
concurrentB.subject.display_name = "Concurrent B";
const [planA, planB] = await Promise.all([
  compilePlan(concurrentA, [], registry),
  compilePlan(concurrentB, [], registry),
]);
const concurrentQuery = (plan: any) =>
  `select app.apply_subject_package_atomic(${
    literal(JSON.stringify(plan))
  }::jsonb,${literal(actor)}::uuid,'local',null);`;
const concurrentResults = await Promise.all([
  sqlOutcome(concurrentQuery(planA)),
  sqlOutcome(concurrentQuery(planB)),
]);
if (concurrentResults.filter((result) => result.success).length !== 1) {
  throw new Error(
    `concurrent package identity expected one winner; statuses=${
      concurrentResults.map((r) => r.code).join(",")
    }`,
  );
}
const concurrencyResult = "CONCURRENT_PACKAGE_IDENTITY_PASS";

console.log(
  [
    tamperResult,
    chemistryResult,
    createResult,
    governanceResult,
    trustBoundaryResult,
    policyConflictResult,
    approvalResult,
    immutabilityResult,
    concurrencyResult,
  ].join("\n"),
);
