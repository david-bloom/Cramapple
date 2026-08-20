# TASK-0016 Phase D Stage D2 — Independent QA Review, Round 4 (2026-08-20)

**Reviewed:** backend `5ce92ec` (code `89c6aa7`, on `worktree-agent-ac9429c5f676cfd4f`) and
frontend `668a2cd` (`phase-d2-qr-capture-rebuild`) — rework pass 2, responding to Round 3's N1-N4
(must) and N6/N7/N8/N11/N14 (should). Neither merged, pushed, or deployed. Method: full diff read
against `c45b838`/`b01d3b0`, the new migration read against both `20260818011720` and live
Production's actual function body, a read-only `EXPLAIN` on Dev to settle lock ordering
empirically, both suites re-run, deployment discipline reconfirmed via `gh`/live Supabase queries.

## Bottom line: HOLD FOR FURTHER REWORK — one blocking item, narrowly scoped (3 files)

Eight of nine claimed fixes hold up under adversarial re-testing. **N7 — the shared-function
change flagged as this round's highest risk — is not safe as written**: its writability guard
introduces a lock-order inversion against the deployed `app.submit_response`, and its new error
code is mapped in only one of the function's two callers. Both fixes are small and mechanical.

## Disposition of the claimed fixes

| # | Verdict | Note |
|---|---|---|
| N1 (redemption off-by-one) | **FIXED** | Boundary re-derived: exactly 5 submits allowed, 6th refused before any upload URL. Only writer of the counter is the locked claim function. |
| N2 (`keepOpen` derivation) | **FIXED** | Traced all three verdict legs (assessed/technical/unavailable); the `unavailable` leg correctly still consumes with no retake prompt. |
| N3 (double-submit lock) | **FIXED**, dead end gone | `handleCommit` now awaits and routes failures to a real, enabled retry screen — but see S2/S3, new problems on the newly-reachable failure path. |
| N4 (retryable validation codes) | **FIXED** | All 8 retryable codes route correctly; dead-capability codes correctly excluded either direction. |
| N6 (desktop technical-failure split) | **FIXED** | Sign-upload/bind failures now marked, "use this photo" correctly suppressed, `failure_class` correctly clears on a clean retake. |
| N7 (shared-function guard) | **PARTIAL — not safe as written** | See blocking finding B1 below. |
| N8 (test-fake fidelity) | **FIXED**, residual gaps | Fake still has no locking model — which is exactly why B1 slipped through a green suite. |
| N11 (misconfigured-checker visibility) | **FIXED** | Logs cleanly, no PII, reasoning sound. |
| N14 (doc accuracy) | **PARTIAL** | Line count now correct; "seven callable" functions is wrong (5 callable + 2 trigger functions). |

## New findings

### Blocking

**B1 — the N7 guard inverts lock order against the deployed `submit_response`, a real deadlock on
the exact race it exists to close.** Empirically verified via `EXPLAIN` on Dev: the new guard
locks `response_versions` then `attempts`; the deployed `submit_response` locks `attempts` then
`response_versions`. A desktop commit racing a phone capture submit can deadlock; Postgres kills
one side. If the victim is the bind, the student sees a "technical failure" screen for what
should be a clean "already submitted" message. If the victim is `submit_response`, **the
student's answer submission itself fails** — a capture-feature bug breaking core submission, the
same class of cross-feature hazard Round 1's F3 (budget leak) was about. Each capture submit
takes this lock twice (original + derived-copy bind), so it also serializes binds per attempt.
Fix: match `submit_response`'s lock order (attempts, then response_versions) — a one-statement
change in the new migration, nothing else needs to move.

### Serious

**S1 — the shared-function's new error code is mapped in only one of its two callers.** The
already-deployed `attempt-response`'s `mapAttachCaptureError` was not updated for the new
`response_not_writable` condition — falls to a 500 default instead of the correct 409. Since the
migration deploys independently of any edge-function code, applying it silently changes live
`attach_capture`'s behavior with no accompanying fix.

**S2 — N3's error channel is boolean-only, so every submit failure (including legitimate,
expected ones) is now misclassified as "our bug."** A real `attempt_not_editable` refusal gets
generic "something went wrong on our side" copy and a bug-log entry — the exact failure-cause
conflation DECISION-0051 exists to prevent, reintroduced on a new path.

**S3 — retry after a lost submit-response can double-submit, and the student can get looped on an
error for an answer that actually went through**, since the idempotency key is minted fresh per
retry rather than cached per (attempt, response version).

### Lower severity

L1 (an annotation-write failure is now entirely silent, no log); L2 (2 of 8 retryable codes show
copy that contradicts their own retryable screen); L3 (harmless failure_class/terminal-state
precedence quirk); L4 (a legitimate derived-copy refusal gets logged as a bug); L5 (N14's
"seven callable" claim is wrong; the blanket "lint clean" claim is true only for changed files —
5 pre-existing, unrelated `math-verifier.ts` lint issues exist); L6 (paid-call bound is now ≤5,
not ≤4 — a stale number elsewhere); L7 (no test pins N3's actual UI recovery behavior).

## Regression check and deployment discipline

Confirmed: the diff touches no part of the prior migration (byte-identical), so single-use CAS,
RLS/grants, the append-only guard, cross-user denial, and the TOCTOU guard all still hold. Suites
reproduce exactly (backend 290/290, frontend 232/232, all lint/typecheck clean). Deployment
discipline verified clean: neither commit on any remote (`gh`/`git branch -r --contains`);
neither migration applied to Dev or Production; `bind_response_attachment` confirmed
byte-identical (matching `md5(prosrc)`) on both live projects; no `capture-pairing` function
deployed to either.

## What's left to clear it

**Must fix:** B1 (reorder the guard's lock acquisition), S1 (map the new error code in
`attempt-response`'s error handler too). **Should fix or explicitly record:** S2, S3, L1, L2, L5.
With B1/S1 fixed and S2/S3 addressed or recorded, this is expected to merge.
