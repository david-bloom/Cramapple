# TASK-0078 — Source integration and remaining release gates

Status: Current source handoff; TASK-0078 remains In Progress.
Date: 2026-10-21
Authority: David requested review/merge of eligible Codex PRs and cleanup of branches no longer needed. Fable’s independent reviews are on each PR and in canonical TASK-0078 §2a. This records source integration, not a new deployment authorization.

## Source review and merge results

- #520: both CI commands isolate the environment. The main group has explicit env names and no runtime network/read permission; only five exception suites get broader permissions. #524’s previously reviewed session-RPC migration reached main through this foundation.
- #521: service-only replay claims precede effects. Fable accepted the design; the packet now declares A2 Hard-Gate, names David as reconciliation owner, and supplies a read-only pending-claim query. Pending claims never expire or automatically repeat effects.
- #522: unused submit-response source retired; its dormant QA caller now uses attempt-response. The three Development function deletions were completed and documented earlier, not repeated during source merging.
- #523: actor-scoped submission replay and collision rollback, guarded against unexpected deployed definitions. Migration remains unapplied by this source integration.
- #535: both grade-store failures surface without a score. Same-key recovery commits only the saved grade, then conditionally projects status/score/summary onto a submitted attempt. Projection failures surface a score-free 503 and retry without another model call; a finalized attempt is never overwritten. Fable’s progress-truth gap is closed.
- #536: required review/admin writes and pairing cancellation surface failures. The review-decision deployment freeze remains in force.
- #525–#531: all seven helper source PRs merged, one family per PR. Original parser/refusal/initialization differences remain explicit. Fable’s byte/parameter parity evidence is recorded in each PR body. Checkout-wide documentation was separated from #531 into this docs PR.

A fresh independent read-only QA context recommended source-merge Pass for #535’s recovery follow-up and #521’s release-packet follow-up. Its non-blocking attempt-snapshot fixture concern was then covered with cloned reads and an explicit concurrent-finalizer test (39 evaluate-attempt tests).

## Verification checkpoint

Final integrated tree at #531 head `a6551e80`: **772 restricted + 75 exception Deno tests passed (847 total across all 72 suites)**, plus **10 Python checker tests**. All **29 remaining Edge entry points type-check**. The restricted group has 67 suites and the exception group remains exactly five; no suite is duplicated or omitted. Dedicated GitHub SQL jobs exercise replay concurrency, submission rollback and session-RPC definitions on disposable Postgres only. No live fixture writes or model/Stripe calls were performed by the merge work.

## Release boundaries

- Replay migration must precede both Edge function deployments on each project. Quiesce/drain old writers, rehearse controlled Development journeys, verify exact artifacts and inspect pending claims before reopening traffic. Production needs separate approval.
- Grade/attempt source changes require approved Development deployment and verification, then separate Production approval. Recovery does not backfill memory, mastery, criterion-detail or telemetry.
- Submission SQL requires the approved single-file apply method and Development submit/retry verification. Do not use db push while ledger reconciliation is unresolved.
- Session-RPC Development application was performed separately by Claude under David’s request and recorded in the canonical task; this source merge performed no database operation. Preserve the separately tracked ledger filename reconciliation and Production gate.
- Before any checkout Production deployment: one student and one parent Development checkout in Stripe test mode. No pricing, promotion configuration, webhook or trial-policy change is authorized here.
- Review functions remain frozen for deployment until human review is re-planned. No task closure or launch decision is implied.

## Cleanup

Only clean branches/worktrees whose exact commits are reachable from origin/main are eligible. GitHub deletes merged remote heads. Managed worktrees are archived through the app after verifying clean state, zero unique commits and remote preservation. Unmerged historical scratch/design branches retain unique work and are preserved. Six completed managed worktrees have been archived after successful preflight; the helper and documentation worktrees are eligible after the final checkpoint merges. All fourteen original Codex PR heads are now reachable from main, including #524 via #520. GitHub has deleted their remote head branches. The final local cleanup uses only these verified merged refs, plus the new docs checkpoint. Four older scratch/design branches each retain one unique unmerged commit and are preserved.

The canonical task is [BACKEND-STABILITY-FOLLOW-UPS](../tasks/TASK-0078-BACKEND-STABILITY-FOLLOW-UPS.md). Original execution scope and authorization remain in the [historical scope snapshot](TASK0078_REFACTOR_SCOPE_SNAPSHOT_2026_10_21.md).
