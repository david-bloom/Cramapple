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

- Twelve request-handler tests cover collision-before-action, owned legacy replay, lost audit acknowledgement, concurrent attempts, authorization, fresh signed URLs and delete replay. After integration with the current A1 gate: 701 restricted + 72 exception tests pass in the exact clean-environment commands (773 total).
- Disposable Postgres fixture exercises the actual migration's privileges, actor/hash collisions, failure rollback and completion replay. It refuses any database not named `task0078_fixture`.
- Production function/schema behavior remains unchanged until the gates above clear.

## Fable merge-review follow-up: pending-claim reconciliation

A2 is Hard-Gate: one claims table and two service-only RPCs plus coordinated Edge deploys. Source merge does not apply SQL or authorize a release. Each call adds claim/completion RPC round trips around its effect. Fable independently accepted this design on PR #521 (2026-10-21).

Accountable release/reconciliation owner: David Bloom, Product Owner. The release conductor must inspect pending claims after draining writers, before reopening traffic and after controlled verification. This query is read-only; age is a triage aid, never proof of failure or permission to reclaim:

```sql
select c.request_id, c.operation, c.actor_id, c.created_at,
       now() - c.created_at as age,
       a.object_type, a.object_id, a.metadata->'result' as recorded_result
from app.operation_replay_claims c
left join app.audit_events a
  on a.request_id = c.request_id and a.reason_code = c.operation
where c.completed_at is null
order by c.created_at, c.request_id, c.operation;
```

Investigate each key against function logs and the relevant session/storage state. Results can contain private object identifiers: inspect only in an authorized operator environment. Do not expose claim tokens or signed URLs. A proven matching committed audit record can inform a separately reviewed completion repair; a missing audit row cannot prove the effect did not happen. Never delete or expire a claim, reconstruct an outcome, or retry the external effect automatically. Unprovable outcomes stay contained and escalate to David for a specific repair decision. No repair writes are part of this packet.

The older cautious-refactor task is a historical scope snapshot only; the canonical BACKEND-STABILITY-FOLLOW-UPS task owns all current state.
