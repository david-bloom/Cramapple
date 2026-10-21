# TASK-0078 — Cautious backend refactoring and replay hardening

**Status:** Ready for Review
**Owner:** Fable (independent review); Codex (implementation); David Bloom (Product Owner)
**Tier:** Standard for repository/CI work; Hard-Gate for database, configuration, deployment or function deletion
**Created:** 2026-10-21
**Branch:** `codex/task-0078-checkout-helpers` (final helper stack; parallel SQL/retirement branches listed in handoff)
**PR:** [#520–#531 execution matrix](../handoffs/TASK0078_REFACTOR_EXECUTION_2026_10_21.md); final checkpoint [#531](https://github.com/david-bloom/Cramapple/pull/531)
**Approval State:** David authorized execution in this chat on 2026-10-21: “execute the improved plan”. This authorizes preparing and testing the reviewed repository slices. Database applications, deployments, Development configuration changes and remote function deletion retain the separate, concrete approval gates in the improved plan. No Production write is authorized by this record.

## Governing evidence and scope

Fable's review: [PR #519](https://github.com/david-bloom/Cramapple/pull/519), commit `60858969fc8165ee14487234df3e0c97ba3172e2`, `docs/qa/REFACTOR_PLAN_REVIEW_2026_10_21.md`. The improved plan in the authorizing chat supersedes its unsafe execute-then-detect-collision specification and permissive rollback. Reviewed base: `df39cd09`.

1. Extend Minimal CI to run the existing attempt-response, evaluate-attempt and capture-pairing tests with fixture environment permissions. No live credentials or service calls.
2. Make session/storage handlers testable; preserve hashes, ownership and role checks; define replay ownership and collision semantics before mutation. A post-mutation audit error is not rollback. Include failures between mutation and audit and simultaneous retries in the design and tests. Safe containment or a forward fix takes precedence over restoring unscoped replay.
3. Retire the unused submit-response source after reconfirming callers and deployment inventory. Keep app.submit_response, which the active attempt-response endpoint uses. Remote Development deletion is separately gated.
4. Prepare independently reviewable database slices: submit_response actor scoping; TASK-0063 session-RPC body reconciliation. Compare deployed definitions and dependencies; preserve later security fixes and row locks. No historical migration replay or ledger rewrite. Configuration parity is a separate approved operation.
5. Mechanical helpers, one family per PR: encoding/hashing, input validation, environment access, storage primitives, request metadata, model response envelopes. Preserve existing whitespace, loose/strict UUID, initialization and feature-specific refusal semantics.
6. Pure checkout offer and promotion lookup consolidation. Preserve parent/direct/trial/zero-dollar/legacy policies and Stripe trial/webhook state machines. Development integration verification precedes any Production release.
7. Optional prototype fixes only after backend work: BYOQ memory fallback and inactive attachment control. Do not restructure the separate live frontend or large handlers without a concrete need.

## Required acceptance and QA

- Required tests execute in GitHub CI, not just locally. Tests operate on fakes/fixtures.
- Same actor/key/body replays; another actor never receives the cached result; changed payload conflicts; collisions are detected before irreversible effects.
- Mutation/audit failure and concurrent retry tests prove the stated guarantee. If a safe fix needs a transaction or reservation, prepare that separately; do not claim Edge-only checks eliminate races.
- Keep current hashes and database transaction/submission guards. No permissive hash fallback or broader admin bypass.
- Storage replays reauthorize and return usable freshly signed URLs without storing bearer URLs in audit metadata.
- Each PR records its tests, residual risks, integration state, and rollback/containment. New SQL and deployment payloads remain unapplied until their gates clear.
- Independent QA must review the ready artifacts before Production deployment. No closure as Done without the governing sign-off.

## Execution record

- All required repository slices are committed and pushed as twelve separate PRs; dependency order, exact scope, CI evidence and release gates are in [the execution handoff](../handoffs/TASK0078_REFACTOR_EXECUTION_2026_10_21.md). Optional prototype work is deferred.
- Final helper stack: 336 Deno tests and 10 Python tests pass; all 30 Edge entries type-check. A clean temporary merge rehearsal with the parallel source-retirement/SQL PRs passes the same 336 tests and all 29 retained entry checks. New shared helpers lint clean.
- Actual migration SQL passes disposable Postgres fixtures. Replay includes audit failure/completion/privilege scenarios and eight simultaneous claimants: one claimed, seven pending. Separate submission and session fixtures pass. All source PRs' GitHub Minimal CI and applicable SQL jobs are green; evidence is linked in the handoff.
- Replay acquires a durable reservation before effects; hashes and global keys are unchanged. Pending outcomes never expire automatically. See [release packet](../qa/TASK0078_REPLAY_RELEASE_PACKET.md) for quiescence, reconciliation and containment.
- Deployment state: no task deployment, live migration application, configuration/flag change, remote deletion or main merge/push performed. Independent review, Development verification and separate release approvals remain open. TASK-0063 remains open for its broader outcomes.
- QA Result: Pending independent source review; no live-integration sign-off.
- Next Owner: Fable.
- Next Required Action: Review the exact PR artifacts and release packets, then return findings before any approved Development rehearsal/release decision. This task is not Done.
