# Claude Execution Prompt — TASK-0016 Phase D Stage D2, Rework Pass 2

Repo: `Cramapple` (backend, this checkout) and `exam-buddy-wireframe` (frontend, at
`/Users/davidbloom/Documents/exam-buddy-wireframe`). Backend rework continues on branch
`worktree-agent-ac9429c5f676cfd4f` (currently at `c45b838`); frontend on
`phase-d2-qr-capture-rebuild` (currently at `b01d3b0`). Do not merge, push, deploy, or apply the
migration — same discipline as both prior rounds.

## What this is

A second rework pass on TASK-0016 Phase D Stage D2 (QR hand-drawn capture MVP). Lineage: Round 1
QA (2026-08-19) found 6 blocking + 8 serious + several lower-severity issues → Round 1 rework
(2026-08-20) fixed all 15 → **Round 3 QA (2026-08-20) found the Round-1 rework close but not
clean**: 4 new must-fix issues (two of them caused by the rework itself), plus 5 recommended
fixes. Full findings: `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_QA_REVIEW_ROUND3_2026_08_20.md`
— read it in full before starting. `DECISIONS_AND_BLOCKERS.md` item 8 has the running summary.

## Must fix

1. **N1 — redemption-budget off-by-one.** `claim_capture_pairing_upload` checks
   `redemption_attempts &gt;= p_max_attempts` before incrementing; `evaluatePairingUsability`
   checks it after. Reconcile so the 5th upload URL and the 5th submit agree — a student should
   never be allowed to upload a photo that will then be refused. Add a boundary test.
2. **N2 — `keepOpen` must key on the quality verdict, not on whether a bookkeeping write
   succeeded.** Currently `captureQualityState` (which drives `keepOpen`) only updates
   `if (!updateError)`, so a failed `response_attachments.capture_quality_state` write silently
   consumes a capability that should stay open for retake, while `failure_class` still says
   `image_quality`. Derive `keepOpen` from `qualityOutcome.disposition`/`kind` directly.
3. **N3 — give `handleCommit` a real failure path.** The synchronous double-submit guard
   (`committedRef`) is correct and should stay, but currently nothing ever clears
   `committedRef`/`committing` on a submit failure, and `onSubmitted` is fire-and-forget with no
   error channel back to `CaptureItem`. Await the submit, route failures into the existing
   `handleError` funnel, and reset the guard/spinner state on failure so the student isn't
   permanently stuck on a disabled "Submitting…" with no way forward.
4. **N4 — route retryable server-side validation failures to a screen with a retake button.**
   `capture_too_large`, `capture_too_small`, `capture_signature_unrecognized`,
   `capture_media_type_mismatch`, `capture_dimensions_invalid`, `capture_digest_mismatch`, and
   `capture_object_changed` all currently classify as `blocked` (the buttonless screen), whose own
   copy says "take a new photo" with no way to do so — same dead-end shape as the HEIC case F10
   already fixed. Route this set to the existing `unsupported_file`-style retryable screen instead
   (or give `blocked` a retake path when the capability is still live).

## Should fix or explicitly accept and record (state your reasoning either way)

5. **N11** — `keepOpen`'s dependency on the quality-check budget being configured and unexhausted
   means F1's fix silently doesn't apply when `OPENAI_DAILY_CAP_USD` is unset or the cap is hit —
   reverting to consume-on-first-submit with no signal to anyone. Either make this loud (fail the
   request, or flag it) or decouple `keepOpen` from the checker being live.
6. **N6** — persist `failure_class` on the sign-upload-failure and bind-failure paths too (not
   just the quality-check technical-failure path), so the desktop split DECISION-0051 requires
   actually covers all three technical-failure sources — or explicitly narrow the documented claim
   to "quality-check failures only" if you choose not to extend it.
7. **N7** — add an `is_submitted`/attempt-status check inside `bind_response_attachment` itself
   (under its existing row lock), so the "an open capability can't corrupt an already-submitted
   response" guarantee is enforced by the database, not by a multi-second check-then-act window at
   the edge-function level. Verify against live Production's actual function body before changing
   it (Round 3 confirmed today's version has no such check at all).
8. **N8** — fix the test fake: `append_capture_pairing_event`'s fake must model the real row-locked
   max+1 sequence logic (it currently reproduces the pre-fix unlocked-count approach, so it can't
   actually catch a regression there), and add coverage for `claim_capture_pairing_upload`'s
   `expired`/`rejected` caller branches and the same-path idempotency short-circuit — none of
   which are currently tested despite being cited as fixed.
9. **N14** — update `QR_MVP_IMPLEMENTATION.md` (or explicitly mark it superseded) so its line
   counts and function-count claims match the current code — this is the second review in a row
   to flag this doc as stale.

## Explicitly out of scope for this pass (already recorded, don't attempt without new direction)

N5 (multi-slot supersede unrecoverable — latent, frontend hardcodes `"slot-1"`), N9
(`FALLBACK_DIRECT` access-path now unreachable — cosmetic), N10 (inconsistent error codes for one
condition — cosmetic), N12 (F7's erasure trap isn't actually cleared one level up — pre-existing,
not introduced by either rework round), N13 (idempotency short-circuit trusts path identity, not
object digest), the F13 orphan-attachment gap (latent while `evaluate-attempt` ignores
`response_attachments`), and the full Round-1 lower-severity list. Also out of scope: the
`human_review_pending`-with-nothing-to-resolve-it product question — that needs an owner decision,
not more engineering, before any real student reaches this flow.

## Process requirements

- Same deployment discipline as both prior rounds: no push, no merge, no deploy, no migration
  apply, no live database mutation beyond read-only verification queries.
- Do not use the Monitor tool or any async/background-wait pattern on your own work — prior
  agents this program stalled doing this. Use synchronous Bash with explicit timeouts.
- Update `docs/research/grading_phase_d_spatial_2026_07_27/{CURRENT_STATE.md,DECISIONS_AND_BLOCKERS.md}`
  item 8 and `QR_MVP_IMPLEMENTATION.md` yourself as part of this pass — don't leave that for the
  next reviewer to discover is stale again (this is exactly what N14 flagged).
- After this pass, the next step is another independent QA round (Round 4) — do not declare this
  mergeable on your own account, regardless of how confident the fixes feel.

## Final report

For each of N1–N4 (must-fix) and N6/N7/N8/N11/N14 (should-fix, with your decision if deferred):
what changed, file/line, and how you verified it (test added, or manual trace — say which). Test
results (actual pass/fail counts, not just "passed"). Confirm deployment discipline maintained.
List anything you found but did not fix, and why.
