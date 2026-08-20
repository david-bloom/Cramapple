# Claude Execution Prompt — TASK-0016 Phase D Stage D2, Rework Pass 3 (small)

Repo: `Cramapple` (backend, branch `worktree-agent-ac9429c5f676cfd4f`, currently at `5ce92ec`) and
`exam-buddy-wireframe` (frontend, branch `phase-d2-qr-capture-rebuild`, currently at `668a2cd`).
Same discipline as all prior rounds: no merge, push, deploy, or migration apply.

## What this is

A small, targeted rework pass. Round 4 QA
(`docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_QA_REVIEW_ROUND4_2026_08_20.md` — read
it in full first) found this feature very close: 8 of 9 claimed fixes from rework pass 2 hold up,
but one blocking item and a few smaller ones remain. This should be a 3-file change, not a
redesign.

## Must fix

1. **B1 — lock-order inversion between the new `bind_response_attachment` guard and the deployed
   `submit_response`, a real, empirically-confirmed deadlock.** The new migration
   (`20260819120100_bind_response_attachment_writable_guard.sql`) locks `response_versions` then
   `attempts`; `submit_response` (in `20260731160000_schema_baseline.sql`) locks `attempts` then
   `response_versions`. Reorder the new guard's lock acquisition to match `submit_response`'s order
   (attempts first, then response_versions) — or scope the lock to only what's actually needed
   (`for update of rv` if the attempt row doesn't need locking). Verify via `EXPLAIN` on Dev
   (read-only, no execution) that the lock order now matches, the way Round 4 verified the
   original inversion.
2. **S1 — the new error code isn't mapped in the other caller.** `attempt-response`'s
   `mapAttachCaptureError` needs a case for the new `response_not_writable` condition (and ideally
   `response_not_found` too, if that's also newly reachable) returning the correct 409, matching
   what `capture-pairing`'s `mapBindError` already does. Without this, applying the migration alone
   changes live `attach_capture` behavior with no accompanying fix — these two should land together
   or the migration shouldn't go out first.

## Should fix or explicitly accept and record

3. **S2 — `handleCommit`'s new failure path is boolean-only, so a legitimate refusal (e.g.
   `attempt_not_editable`, `response_already_submitted`) is misclassified as a technical bug** (the
   error is thrown as a generic string, falls to `classifyCaptureError`'s technical default). Have
   `submitCapturedResponse` surface the actual error code so `handleCommit` can route it through the
   real classification instead of always assuming "our fault."
4. **S3 — a lost-response retry after a submit failure isn't idempotent**, because the idempotency
   key is minted fresh inside the retry callback rather than cached per (attempt, response
   version). Cache the key so a retry replays the recorded result instead of risking a double-submit
   or looping the student on an error for an answer that already went through.
5. **L1** (an annotation-write failure is now silent — add a log line), **L2** (2 of 8 retryable
   codes have copy that contradicts their own retryable screen — add the missing
   `messageForBlockedCode` cases), **L5** (N14's doc still says "seven callable" functions — it's 5
   callable + 2 trigger functions; also the blanket "lint clean" claim should be scoped to changed
   files, since 5 pre-existing unrelated lint issues exist elsewhere in `_shared`).

## Explicitly out of scope

Everything Round 3 already deferred (N5, N9, N10, N12, N13, the F13 orphan gap) plus L3, L4, L6,
L7 from Round 4 (all noted as cosmetic/non-load-bearing) — don't touch these without new
direction.

## Process requirements

- No push, merge, deploy, migration apply, or live database mutation beyond read-only
  verification.
- No Monitor tool / async background-wait pattern on your own work — synchronous Bash with
  timeouts only.
- Update `docs/research/grading_phase_d_spatial_2026_07_27/{CURRENT_STATE.md,DECISIONS_AND_BLOCKERS.md}`
  item 8 yourself as part of this pass.
- After this pass: Round 5 QA. Do not declare this mergeable on your own account — three
  consecutive independent reviews is the established practice here, not a formality to skip once
  a pass "feels" clean.

## Final report

For B1 and S1: what changed, file/line, and how you verified it (the `EXPLAIN` re-check for B1
specifically). For S2-L5: same, or your recorded reasoning if deferred. Actual test pass/fail
counts. Confirm deployment discipline maintained.
