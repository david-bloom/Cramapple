# TASK-0078 — Cautious backend refactoring and replay hardening

> Historical implementation scope and authorization snapshot. The current canonical checklist is [TASK-0078 backend stability follow-ups](TASK-0078-BACKEND-STABILITY-FOLLOW-UPS.md). Current A1 evidence is [the two-step CI record](../qa/TASK0078_A1_TWO_STEP_CI_2026_10_21.md); counts below describe the original checkpoint.

**Status:** Superseded — historical scope snapshot
**Owner:** Codex (implementation); David Bloom (Product Owner)
**Tier:** Standard for repository/CI work; Hard-Gate for database, configuration, deployment or function deletion
**Created:** 2026-10-21
**Branch:** `codex/task-0078-refactor-ci` (first slice; subsequent slices record their own PR)
**PR:** Pending
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

- First action: CI baseline and environment-permission characterization.
- Deployment state: no task deployment, migration application, configuration change or remote deletion performed.
- Test Results: Expanded Minimal CI Deno command: 310 passed, 0 failed, with an explicit environment-name allowlist and no runtime network permission. Importing capture-pairing initially attempted to start a server; its entry point now uses the existing import.meta.main pattern from attempt-response and evaluate-attempt. Existing Minimal CI baseline: 255 passed.
- QA Result: Pending independent review.
- Next Owner: Codex, repository implementation and local verification.
