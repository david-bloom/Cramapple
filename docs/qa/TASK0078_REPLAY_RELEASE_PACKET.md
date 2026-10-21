# TASK-0078 replay hardening — release packet

Status: Ready for independent source review; UNAPPLIED database and UNDEPLOYED functions.

## Current task reconciliation, 2026-10-21

This is the existing A2 artifact in PR #521, dependent on A1 #520. It is reconciled with the latest TASK-0078 owner checklist and the two-step CI gate; it is not a second replay implementation. The two new handler suites run in A1's restricted group, without runtime network/read permissions or unrestricted environment access.

The earlier Edge-only specification let a second actor execute an action before the audit insert reported a collision. That cannot undo a session creation or deletion. This prepared source retains the improved plan's durable reservation before effects. Its new service-only SQL remains unapplied and requires independent review and exact release approval; the latest request does not authorize a live migration/deployment. No fallback to mutation-before-collision is introduced.

## Design

The old audit insert follows session creation/storage deletion; detecting a uniqueness error then cannot undo the action. Both handlers now acquire a durable service-only claim BEFORE an action. Existing global key/operation uniqueness and request hashes remain unchanged. The claim RPC checks legacy audit ownership/hash and serializes claims on the same key; another actor or a changed body conflicts before mutation. An unfinished same-actor claim returns `409 operation_outcome_pending`, with no automatic expiry or reclaim. Completion writes the audit result and marks completion in one SQL transaction. The original action remains outside that transaction: if its outcome or audit acknowledgement is uncertain, fail closed and retain the claim. This is containment of ambiguous outcomes, not a claim that external actions roll back.

Storage replay rechecks role/path authorization before re-signing. Signed URLs and upload tokens are not persisted in audit results. Delete replays return only the original result. Session resume/save/end recheck current ownership before returning an audit result.

## Deployment prerequisites and gates

1. Independent review of the migration, handlers, fixture SQL and failure tests.
2. Quiesce affected operations and drain old in-flight requests for rollout: the legacy handlers do not participate in the claim protocol. Do not claim mixed-version writers are protected by the advisory lock.
3. Apply the new migration to Development on approval, deploy both functions, and run controlled fixture journeys. The two updated functions require the migration; if it is absent, they return `503 replay_unavailable` before mutation.
4. Review exact Development artifact/import-graph fingerprints and test evidence before separate Production approval. Apply the migration before the functions, then verify Production artifacts after deployment. No automatic production execution.

## Ambiguous outcome / rollback

Never delete an outstanding claim merely because it is old, and never automatically retry an action under the same key. An operator must establish whether the action happened using the session row/storage state and audit evidence. If the outcome cannot be proved, retain containment and escalate. No automated recovery tool is introduced in this slice.

Containment: disable the affected operation or use a reviewed forward fix. Do not drop the claim table or redeploy legacy unscoped handlers without an explicit risk decision and a reconciled list of pending operations. No ledger rewriting or hash migration is included.

## Evidence

- Twelve request-handler tests cover collision-before-action, owned legacy replay, lost audit acknowledgement, concurrent attempts, authorization, fresh signed URLs and delete replay.
- Disposable Postgres fixture exercises the actual migration's privileges, actor/hash collisions, failure rollback and completion replay. It refuses any database not named `task0078_fixture`.
- Production function/schema behavior remains unchanged until the gates above clear.
