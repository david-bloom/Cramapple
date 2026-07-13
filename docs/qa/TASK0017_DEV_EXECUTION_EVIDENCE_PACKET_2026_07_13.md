# TASK-0017 Dev Execution and Evidence Packet

**Status:** Proposed — awaiting separate Dev migration approval ID
**Date:** 2026-07-13
**Task:** TASK-0017 / DECISION-0039
**Scope:** Execution plan only; this packet has not been applied to Dev or Production

## Approval boundary

Execution must stop unless all of the following are recorded immediately before the window:

1. a Product Owner Dev migration approval with a unique `APPROVAL-NNNN`;
2. the exact approved branch and commit SHA;
3. explicit Dev project reference independently confirmed by the operator;
4. confirmation that no Production project is linked or targeted; and
5. named executor, reviewer, start time, and rollback owner.

Production is a distinct Hard Gate. A Dev approval ID cannot authorize Production migration, Edge deployment, or content publication. This packet does not authorize any content publication in any environment.

## Approved-artifact candidates

The eventual approval must pin hashes for:

- `supabase/migrations/202607130001_atomic_content_publication.sql`;
- `supabase/functions/admin-content/index.ts`;
- `supabase/functions/admin-content/publication-request.ts`;
- both TASK-0017 SQL regressions; and
- the Edge↔RPC contract test.

Repository/local evidence is attached at:

- `docs/qa/evidence/TASK0017_P0_POST_APPROVAL_SQL_2026_07_13.log`;
- `docs/qa/evidence/TASK0017_EDGE_RPC_CONTRACT_2026_07_13.log`.

## Preflight — read-only

Capture into the execution log before any mutation:

1. target project ref, database host fingerprint, current migration list, current Edge Function version, branch/SHA, UTC timestamp, and approval ID;
2. pgcrypto extension schema and `to_regprocedure('extensions.digest(text,text)')`;
3. definition, owner, grants, and dependencies for any existing `app.publish_content_item_version_atomic(jsonb)`;
4. row counts/status distributions for content items/versions, release candidates, manifests, publication events, validation suites/runs, sources, and rights;
5. duplicate/orphan checks for the exact evidence tables used by the RPC;
6. confirmation that a passed exact-target grading/calibration run and a passed exact-target security/privacy run can be represented; and
7. current `admin-content` request contract. The typed manifest input must contain both `grading_calibration_validation_run_ids` and `security_privacy_validation_run_ids`.

Stop on a project-ref mismatch, missing approval, unresolved extension dependency, schema mismatch, failed preflight query, or unclassified migration drift.

## Required execution order

The order is non-negotiable because the new Edge caller depends on the RPC:

1. **Open a publication maintenance window.** No operator may invoke publish during migration/deployment. Draft authoring/review may continue only if separately assessed safe.
2. **Apply the RPC migration first.** Apply only the approved migration to the explicitly named Dev project.
3. **Verify the database before Edge deployment.** Confirm:
   - migration recorded once;
   - `pgcrypto` resides in `extensions` and `extensions.digest(text,text)` resolves;
   - function is `SECURITY INVOKER` with an empty fixed search path;
   - `anon`/`authenticated` lack execute and `service_role` has execute;
   - canonical manifest hash changes only when canonical content/evidence/version relations change;
   - rollback and exact-version tests pass in an approved isolated transaction/fixture strategy without durable Dev test rows.
4. **Deploy `admin-content` second.** Pin the approved Edge source SHA. Do not deploy other functions in the same command/batch.
5. **Run the Edge↔RPC smoke test.** Use dedicated Dev-only fixture identities and a transaction/cleanup plan. Prove the caller supplies source, rights, the two typed validation-run categories, approved_by, and all three policy IDs. Confirm the RPC resolves actual suite types/pass state/exact target itself.
6. **Run negative smoke tests.** Missing source, rights, either validation category, a policy version, wrong target, failed/invalidated run, stale source, expired rights, non-admin actor, duplicate evidence, and late artifact failure must all fail closed without serving/release residue.
7. **Close the maintenance window only after reviewer sign-off.** Record hashes, outputs, row-count deltas, Edge version, and final Dev verdict.

No smoke fixture may use AP Chemistry content or publish Chemistry. No Biology/Statistics student content is published by this execution packet.

## Canonical manifest-hash evidence

The migration no longer hashes arbitrary request JSON. It computes a deterministic JSONB payload over:

- schema version, exam ID, academic year, and exam-pack semantic version;
- ordered content relation containing ordinal, exact `content_item_version_id`, content-key snapshot, and stored canonical content SHA-256;
- sorted source, rights, validation-run, prompt, model-configuration, and qualification-rule version IDs; and
- exact validator, teaching, and grading policy-version IDs.

Audit-only/request-only values such as actor, title override, environment, transaction ID, reason code, approval array, and smoke-test ID are excluded. The positive-path SQL regression independently reconstructs and compares the expected hash.

## Rollback decision tree

### Migration fails before commit

- PostgreSQL transaction rolls back automatically.
- Do not deploy the Edge Function.
- Keep publication maintenance window active until the reviewer confirms the prior database definition/grants are unchanged.

### Migration succeeds; Edge not deployed

- Leave the additive/replacement RPC in place; it is unused by the prior Edge code and is service-role-only.
- Do not attempt a destructive down migration merely to restore absence.
- Keep publication blocked until the execution owner chooses either remediation/retry under the same approved scope or closes the window with an incident note.

### Edge deployment fails or smoke tests fail

- Do not redeploy an older non-atomic publication implementation as a functional rollback.
- Disable/operationally block publish operations and retain the verified RPC while diagnosing.
- If the immediately preceding deployed Edge version is independently proven to use the same atomic RPC contract, redeploy that exact version; otherwise use a fail-closed build that rejects `publish` while leaving draft operations explicitly assessed.
- Record any attempted publication request and prove zero serving/release residue.

### New Edge succeeds but later defect appears

- Close publication operations immediately.
- Redeploy the last verified atomic/fail-closed Edge version.
- Keep the RPC and evidence rows; do not delete manifests/publication events.
- If a content version was activated, restore the exact prior immutable manifest/version through a separately approved rollback publication event. Never infer `latest` or mutate the failed manifest.

### Schema rollback

This P0 migration replaces a function and normalizes pgcrypto into Supabase's expected `extensions` schema. A down migration may restore a previously captured safe function definition only if that definition is atomic and approved. It must never restore the original non-atomic path. Moving pgcrypto out of `extensions` is prohibited unless a separately reviewed dependency analysis and approval explicitly require it.

## Required evidence bundle after authorized Dev execution

- approval record and target confirmation;
- branch/SHA and SHA-256 for every applied/deployed artifact;
- complete migration output and migration-list before/after;
- pgcrypto schema/signature query;
- function definition, search path, owner, and privilege query;
- both SQL regression outputs;
- Edge↔RPC positive and negative outputs;
- row-count/state snapshots before/after;
- Edge deployment version and logs;
- deviations/incidents and rollback actions; and
- proposed Dev verdict. A Dev pass does not authorize Production.

## Current disposition

Packet prepared only. Dev migration approval ID: **not assigned**. Dev execution: **not performed**. Production execution/publication: **not authorized and not performed**.
