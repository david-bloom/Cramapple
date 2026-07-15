import { compilePlan } from "../subject-harness/compiler.ts";

const subjects=["ap-chemistry","ap-physics-1","ap-physics-2","ap-physics-c-mechanics","ap-physics-c-em"];
const registry=JSON.parse(await Deno.readTextFile("schemas/subject-onboarding/platform-capabilities.v1.json"));
const actor="cda34c9d-80f3-43bb-b359-8413bad3ee2e";
const sql=(value:string)=>`'${value.replaceAll("'","''")}'`;
const rows=[];

for(const subjectKey of subjects){
 const subject=JSON.parse(await Deno.readTextFile(`content/subject-packages/${subjectKey}.subject-package.json`));
 const items=[];
 for await(const entry of Deno.readDir(`content/item-packages/${subjectKey}`)) if(entry.isFile&&entry.name.endsWith(".json")) items.push(JSON.parse(await Deno.readTextFile(`content/item-packages/${subjectKey}/${entry.name}`)));
 items.sort((a,b)=>a.package_id.localeCompare(b.package_id));
 const plan=await compilePlan(subject,items,registry);
 rows.push({subjectKey,packageId:subject.package_id,packageHash:plan.subject_package_sha256,planHash:plan.plan_sha256,approvalId:`APPROVAL-FIVE-SUBJECT-${subjectKey.toUpperCase()}-20260715`});
}

const statements=[
 "begin;",
 `update app.profiles set role='admin',review_queue_scope='all_pending' where user_id=${sql(actor)}::uuid;`,
 `insert into app.governance_role_assignments(actor_id,role_key,decision_id,effective_at,expires_at,created_by) select ${sql(actor)}::uuid,'product-owner','CODEX-FIVE-SUBJECT-HARNESS-USER-DIRECTION-2026-07-15',now(),now()+interval '7 days',${sql(actor)}::uuid where not exists(select 1 from app.governance_role_assignments where actor_id=${sql(actor)}::uuid and role_key='product-owner' and decision_id='CODEX-FIVE-SUBJECT-HARNESS-USER-DIRECTION-2026-07-15');`,
 ...rows.map(row=>`insert into app.execution_approvals(approval_id,environment,scope_key,package_id,package_sha256,plan_sha256,authorized_actor_id,governance_role_assignment_id,approved_by,effective_at,expires_at,status) select ${sql(row.approvalId)},'dev','subject-harness-apply',${sql(row.packageId)},${sql(row.packageHash)},${sql(row.planHash)},${sql(actor)}::uuid,governance_role_assignment_id,${sql(actor)}::uuid,now(),now()+interval '24 hours','active' from app.governance_role_assignments where actor_id=${sql(actor)}::uuid and role_key='product-owner' and decision_id='CODEX-FIVE-SUBJECT-HARNESS-USER-DIRECTION-2026-07-15' on conflict(approval_id) do nothing;`),
 "commit;"
];
await Deno.writeTextFile("/tmp/cramapple-five-subject-authorize.sql",statements.join("\n")+"\n");
await Deno.writeTextFile("/tmp/cramapple-five-subject-plans.json",JSON.stringify(rows,null,2)+"\n");
console.log(JSON.stringify(rows,null,2));
