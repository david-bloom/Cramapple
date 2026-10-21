# TASK-0078 A4 — Grade persistence and same-key recovery

Status: Ready for Review; Fable review remediated, recovery follow-up QA pending
Date: 2026-10-21
Branch: `codex/task-0078-grade-write-failures`
PR: [#535](https://github.com/david-bloom/Cramapple/pull/535), depends on A1 [#520](https://github.com/david-bloom/Cramapple/pull/520)
Tier: Standard; no deployment or schema change

David's ruling 4 requires both final grade writes to fail the request and requires an explicit same-key retry policy. This supersedes this PR's earlier checkpoint that deliberately left retry unresolved.

## Retry decision

**A retry re-attempts the saved database write; it does not re-grade.** Re-running the model against the same request key would reuse an already-terminal model-usage reservation, so this implementation avoids another model call or billing/accounting change.

Both final store sites inspect `{data,error}`. A database error, transport failure or zero updated rows logs a safe request/route/error code and returns HTTP 500 `grade_store_failed`, without a score. The handler attempts a conditional checkpoint on the still-processing row: status `failed`, stable failure reason, and a versioned private `raw_model_response` envelope containing the original update payload. The envelope preserves the original provider response nested inside that payload. No computed grade is exposed before the typed grade columns commit.

A matching same-key/body retry validates that envelope and conditionally applies exactly the pending update, fenced by the row's `updated_at`, status and failure reason. Concurrent retries admit one writer; a loser reads its committed result. The response follows existing stored-result replay semantics and strips `raw_model_response` and `shadow_result`. There is no new record, model request, usage reservation, hash, entitlement policy, or automatic regrading. A changed body conflicts; a different learner still fails ownership checks before the replay lookup. Corrupt checkpoints and identity-changing payloads fail closed.

If the original grade committed but its acknowledgement was lost, the checkpoint's `status=processing` predicate cannot downgrade it. A later retry returns that committed grade. If checkpoint persistence also fails, the response says `retryable:false` and `reconciliation_required:true`. Recent in-flight rows retain 202; once their last update is older than max(10 minutes, twice the configured provider timeout plus one minute), replays return 503 `grading_reconciliation_required` with no score. Missing timestamps also require reconciliation. This deadline never reclaims the row or authorizes another model call. Legacy stuck rows without a checkpoint require operator recovery.

Recovery uses the existing private JSON column and updated_at trigger; no migration is introduced. Before returning a final stored-result replay, the handler projects the saved grade onto a still-`submitted` attempt: status, graded time, score, confidence, summary and derived assistance. The conditional update never overwrites a finalized attempt. Error, transport failure or an unexplained zero-row update returns 503 `attempt_grade_store_failed` without a score; the next same-key retry repeats only the projection. This also handles a lost grade acknowledgement or a crash between grade persistence and attempt persistence. Memory, mastery, criterion detail and telemetry remain outside recovery; historical repairs remain separate. The live app currently maps non-2xx responses to its generic grading-failed/retry state.

## Evidence and release state

The evaluate-attempt suite passes **38 tests**: existing 14 plus 24 new persistence/recovery cases across MCQ, LLM and shadow paths. Cases cover initial errors/zero rows/transport, success, concurrent recovery, repeated write failure, acknowledged grade with lost reply, checkpoint failure followed by stale 503, changed body, cross-user refusal and corrupt private payloads. Fake provider calls are restored in finally; tests assert no extra provider call on retries. No live model call or spend.

A1's exact clean-environment two-step workflow passes **713 restricted + 72 exception tests, 785 total** on this PR. A fresh read-only check on both Production and Development confirms authenticated/anonymous users cannot select raw_model_response (authenticated also cannot select shadow_result), service_role can update it, and the grading_results_set_updated_at trigger is enabled. These checks inspected privileges/trigger metadata only; no learner rows were read or written. Handler type-check and request-suite lint pass. No live migration, deployment, flag change or main merge occurred. Next owner: independent reviewer/conductor. Review private-column isolation, timestamp fencing, unchanged request hashes and recovery limits before approving a Development release; Production remains separately gated.
