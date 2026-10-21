# TASK-0078 refactor execution and review handoff

STATUS: CURRENT — repository implementation prepared; independent QA and release pending
DATE: 2026-10-21

## Current task and authority

David authorized “execute the improved plan” after Fable's plan review in [PR #519](https://github.com/david-bloom/Cramapple/pull/519), pinned at `60858969fc8165ee14487234df3e0c97ba3172e2`. [TASK-0078](../tasks/TASK-0078-CAUTIOUS-BACKEND-REFACTOR.md) records the authorized repository work and retained release gates. Remote main was rechecked at `df39cd0901b50f30e457496c9618b357d0cbfab0`; it has not advanced or superseded these slices.

The implementation is committed and pushed as twelve PRs, with each helper family isolated for review. None has been merged. No live migration, function deployment/deletion, configuration/flag change, learner-state mutation or Stripe API operation was performed. Production/Development definitions and deployment inventories were read only.

## PRs and dependency order

| PR | Change | PR base / dependency | Release state |
| --- | --- | --- | --- |
| [#520](https://github.com/david-bloom/Cramapple/pull/520) | Existing attempt-response, evaluate-attempt and capture-pairing suites added to Minimal CI; import-safe capture entry point; task record | `main` | Source review pending |
| [#521](https://github.com/david-bloom/Cramapple/pull/521) | Session/storage replay claims before effects, handler regressions and service-only claim/completion SQL | #520 | Draft; SQL unapplied, functions undeployed |
| [#522](https://github.com/david-bloom/Cramapple/pull/522) | Retire unused submit-response Edge source; preserve active app.submit_response RPC | #520 | Source review pending; remote Development deletion gated |
| [#523](https://github.com/david-bloom/Cramapple/pull/523) | Actor-scope app.submit_response replay; preserve transaction/row locks; collision rollback | #520 | Draft; SQL unapplied |
| [#524](https://github.com/david-bloom/Cramapple/pull/524) | Guarded reconciliation of two deployed session-RPC bodies | #520 | Draft; SQL unapplied; TASK-0063 remains open |
| [#525](https://github.com/david-bloom/Cramapple/pull/525) | Shared hashing and binary Base64 primitives | #521 | Source review pending |
| [#526](https://github.com/david-bloom/Cramapple/pull/526) | Input primitives with explicit whitespace, UUID and number-coercion variants | #525 | Source review pending |
| [#527](https://github.com/david-bloom/Cramapple/pull/527) | Shared required-environment lookup, preserving initialization timing | #526 | Source review pending |
| [#528](https://github.com/david-bloom/Cramapple/pull/528) | Request IP metadata with existing header precedence | #527 | Source review pending |
| [#529](https://github.com/david-bloom/Cramapple/pull/529) | Model response text/usage envelopes, preserving feature-specific refusal handling | #528 | Source review pending |
| [#530](https://github.com/david-bloom/Cramapple/pull/530) | Attachment fingerprint and bind-error primitives | #529 | Source review pending |
| [#531](https://github.com/david-bloom/Cramapple/pull/531) | Trusted checkout offer and active promotion lookup; this consolidated execution record | #530 | Draft; independent payment review and Development integration pending |

Review/merge #520 first, then the parallel #521–#524 slices and helper chain in the order above. Retarget each child only after its parent lands, and rerun checks against current main. Squashing a parent can require restacking its children. Do not merge a child against its old feature base and assume the work reached main. Do not deploy the helper-stack tip before satisfying #521's migration/function gates: it inherits those handlers. If replay is held back, transplant the reviewed mechanical helpers onto a fresh main-based branch and reverify them rather than implicitly releasing replay.

## Important design and scope decisions

- Replay collisions must be detected before session creation or storage deletion. The implementation uses a durable database claim because a later audit uniqueness error cannot undo a committed action. Legacy global key/operation uniqueness and all request hash formulas are preserved.
- An uncertain action or lost audit acknowledgement leaves a pending claim. There is no TTL, automatic reclaim or automatic retry. Operator reconciliation, quiescing old writers during rollout, and safe containment are explicit release requirements. This does not make external actions transactional.
- Storage replays reauthorize and generate fresh signed URLs. Bearer URLs/tokens are not persisted in audit results. Session resume/save/end recheck ownership.
- Submission actor scoping and session-RPC drift repair are separate SQL PRs. Source/security/search-path guards reject changed baselines; no historical migration replay, ledger rewrite or relaxed submission/photo guards.
- Helper extraction preserves callers' differing semantics rather than silently normalizing them: trimmed versus untrimmed strings, loose versus shape-checked UUIDs, number coercion, environment-read timing, and grading's refusal-skipping versus extraction's refusal-stop behavior.
- Checkout retains caller purchase-policy gates, trusted catalog selection, response shapes, parent/direct/trial/zero-dollar/legacy behavior and the trial/webhook state machines. Parent promotion input already maps whitespace-only strings to null; the shared lookup's blank guard preserves reachable behavior. No model/prompt/budget or Stripe configuration changes.
- The optional `web/` prototype fixes were deferred: it is not the live frontend, and there was no need to add frontend behavior to these backend slices. No broad component or state-management rewrite was undertaken. Knip/dead-code cleanup already reached main through #511; rerunning that cleanup is not a prerequisite for these changes. The original stranded branches/worktrees were not deleted or archived in this execution.

## Verification and limits

- Exact Minimal CI Deno command: baseline 255; expanded existing handlers 310; replay tests 322; final helper stack **336 passed, 0 failed**. CI grants fixture environment names explicitly, with no runtime network permission. Python AP Statistics checker: **10 passed**.
- All **30** Edge index entry points type-check on #531's helper stack, which intentionally does not contain the parallel source-retirement PR. A temporary merge rehearsal of #522/#523/#524 into that stack merged without conflicts, passed **336** Deno tests and type-checked all **29 retained** entry points. The rehearsal was aborted; no combined merge was committed.
- New shared helper modules lint clean; diff whitespace check passes. Targeted tests cover encoding boundaries, parsing variants, IP precedence, response/refusal/usage envelopes, storage fingerprint/bind mapping and checkout offer/promotion behavior.
- The actual replay migration passes local disposable Postgres SQL/privilege/failure tests. Eight concurrent claimants produce exactly **one claimed / seven pending**. Handler tests cover actor/hash collision before effects, ambiguous completion, concurrent retries, authorization, fresh signing and delete replay.
- Submission SQL fixture passes owned replay, cross-actor refusal, changed payload and atomic collision rollback. Session-RPC fixture first reproduces the old subject-switch defect, then passes switching, subject-scoped start/replay/reuse and identity/selectability guards.
- Submission/session fixtures require fresh disposable databases. A repeated local run against already-populated fixtures refused existing schemas; resetting only those two synthetic local databases and rerunning passed. No live database was used for tests. Disposable Postgres was stopped at closeout.
- GitHub Minimal CI is green for all twelve source heads. Replay SQL CI is green on #521 and every helper descendant; the separate submission and session SQL workflows are green on #523 and #524. Final source evidence: [#531 Minimal CI](https://github.com/david-bloom/Cramapple/actions/runs/39629802164), [replay SQL](https://github.com/david-bloom/Cramapple/actions/runs/39629802067); [submission SQL](https://github.com/david-bloom/Cramapple/actions/runs/39627984639); [session RPC SQL](https://github.com/david-bloom/Cramapple/actions/runs/39628365434). These prove fixtures, not live integration.

The implementation author performed source checks; this is not independent QA. No Development browser/client/Stripe journey or Production release is certified. TASK-0063's wider retired-pack/session/profile/cleanup outcomes are not implemented or closed by #524. The cause of ledger/body drift is still unknown.

## Release packets and affected files

- [Replay design, rollout, recovery and containment](../qa/TASK0078_REPLAY_RELEASE_PACKET.md): session-event, storage-sign-url, `_shared/operation-replay.ts`, migration `20261021152931_task0078_operation_replay_claims.sql`, handler tests and disposable fixture CI.
- [Submission RPC packet](https://github.com/david-bloom/Cramapple/blob/codex/task-0078-submit-replay-sql/docs/qa/TASK0078_SUBMISSION_RPC_RELEASE_PACKET.md), in #523: migration `20261021153645_task0078_submit_response_actor_replay.sql`, actual-body fixture and CI.
- [Session RPC packet](https://github.com/david-bloom/Cramapple/blob/codex/task-0063-session-rpc-reconciliation/docs/qa/TASK0063_SESSION_RPC_RECONCILIATION_RELEASE_PACKET.md), in #524: migration `20261021153710_task0063_reconcile_session_rpc_bodies.sql`, actual-body fixture, CI and TASK-0063 note.
- [Retirement record](https://github.com/david-bloom/Cramapple/blob/codex/task-0078-retire-submit-response/docs/qa/TASK0078_SUBMIT_RESPONSE_RETIREMENT.md), in #522: inventory/caller evidence and remote-deletion gate.
- Helper families: `_shared/encoding.ts`, `input.ts`, `env.ts`, `request-metadata.ts`, `response-envelope.ts`, `storage-primitives.ts`, `checkout-offer.ts`; narrow caller edits and regression tests are in their respective PR diffs. Minimal CI includes the new deterministic helper suites.

The three parallel release-packet links explicitly target their owning PR branches. This handoff resides on `codex/task-0078-checkout-helpers` in #531; the main checkout remains clean and unchanged. Managed worktrees and all created PRs are attached to the Codex chat.

## Next owner and required action

**Next owner: Fable, independent source review.** Review the PR artifacts, starting with #520 and the #521/#523/#524 SQL and replay boundaries; explicitly assess durable-claim recovery, concurrency/authorization guarantees, later security fixes and checkout behavior preservation. Report findings against exact commit SHAs. David can then approve exact Development applications/deployments, configuration parity and remote Development function deletion if warranted. Production requires its own concrete release review and approval after Development evidence; there is no deployment approval in this handoff.

Do not change flags, apply migrations, rewrite the ledger, delete remote functions, deploy the stack, drop/reclaim pending replay claims, merge/push main or remove the preserved historical work on the strength of this record alone.

Recommended restart prompt:

> Read docs/team_charter/CRAMAPPLE_SESSION_START.md, docs/INDEX.md, TASK-0078 and docs/handoffs/TASK0078_REFACTOR_EXECUTION_2026_10_21.md from PR #531. Independently review PRs #520–#531, respecting their dependency order and separate release gates. Recheck main and deployed-body fingerprints before proposing any release. Report source findings and missing Development evidence; do not apply, deploy, change flags, delete functions or merge main.
