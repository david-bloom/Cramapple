# TASK-0016 Phase D Stage D2 — QR Capture Rework, Pass 2 (2026-08-20)

**What this is.** The second rework pass, addressing Round-3 QA
(`QR_MVP_QA_REVIEW_ROUND3_2026_08_20.md`, verdict HOLD FOR FURTHER REWORK — "close, not a
redesign"). Round 3 confirmed all 15 Round-1 findings genuinely fixed by rework pass 1, but found
two fixes only conditionally correct and one (F9) that traded its fix for a new dead end. This pass
fixes the must-fix set (N1–N4) and the recommended set (N6, N7, N8, N11, N14). N5, N9, N10, N12,
N13 and the F13 orphan-attachment gap were explicitly left out of scope per the rework prompt.

**Reworked commits (neither merged, pushed, or deployed):**

- Backend `worktree-agent-ac9429c5f676cfd4f` @ `5ce92ec` (rework pass 2: `89c6aa7` code +
  `5ce92ec` the N14 doc), on top of pass-1 `c45b838`.
- Frontend `phase-d2-qr-capture-rebuild` @ `668a2cd`, on top of pass-1 `b01d3b0`, in
  `exam-buddy-wireframe`.

**Deployment/mutation discipline, re-verified this pass:** neither pass-2 commit is on any remote
(`git branch -r --contains` → 0). Live read-only Production query confirmed **0** of
`{20260819120000_capture_pairing, 20260819120100_bind_response_attachment_writable_guard}` applied
and **0** capture functions present in `pg_proc`; `bind_response_attachment` on live Prod still has
no `is_submitted` check (the N7 target). Nothing applied, deployed, or merged.

---

## Must-fix

**N1 — redemption-budget off-by-one.** `claim_capture_pairing_upload` gates the budget by checking
`redemption_attempts >= max` *before* incrementing (so `redemption_attempts` legitimately reaches
`max` after the max-th claim), but `evaluatePairingUsability` refused the submit at
`redemption_attempts >= max` — so the 5th photo uploaded and then its submit 409'd, orphaning the
bytes (`max=5` behaved like 4). **Fix:** `evaluatePairingUsability` now refuses only at
`redemption_attempts > max`; the claim gate owns the budget and the submit gate agrees. The
`_shared` boundary test was corrected (0..max allowed, max+1 refused) and a full 5-retake handler
cycle test added (`index_test.ts`: all five submit, sixth claim refused before upload).
`_shared/capture-pairing.ts`.

**N2 — `keepOpen` keyed on a bookkeeping write, not the verdict.** `captureQualityState` (which
drives `keepOpen`) only advanced `if (!updateError)` on the best-effort `response_attachments`
annotation write, so a failed annotation silently reverted a retake-eligible capture to
consume-on-first-submit — reinstating the F1 dead end while `failure_class` still said
`image_quality`. **Fix:** `captureQualityState` and `keepOpen` are derived from
`qualityOutcome.disposition`/`kind` directly, before and independent of the annotation write; the
token's authoritative state is written by the finalise RPC regardless. Test with a forced
annotation-write failure (`updateAttachmentShouldFail`) asserting the capability stays `uploaded`.
`index.ts`.

**N3 — F9's double-submit guard permanently locked every control on submit failure.** The
synchronous `committedRef` guard was correct, but nothing cleared it (or `committing`) on failure
and `onSubmitted` was fire-and-forget, so any submit failure stranded the student on a disabled
"Submitting…". **Fix:** `onSubmitted` now returns `void | boolean | Promise<...>`; `handleCommit`
awaits it and, on a rejected promise or an explicit `false`, clears the guard/spinner and routes
the error through the existing `handleError` funnel. `SessionFrame` returns
`submitCapturedResponse`'s promise (which resolves `false` on a non-ok submit) instead of `void`.
`CaptureItem.tsx`, `SessionFrame.tsx`.

**N4 — six other retryable server-side validation refusals hit the buttonless screen.** Only the
client-side HEIC case was routed to the retryable screen; `capture_too_large`, `capture_too_small`,
`capture_signature_unrecognized`, `capture_media_type_mismatch`, `capture_dimensions_invalid`,
`capture_digest_mismatch`, and `capture_object_changed` still hit the buttonless `blocked` screen
whose copy says "take a new photo" with no way to. **Fix:** a `RETRYABLE_CAPTURE_CODES` set +
`isRetryableCaptureError()` routes these to the retryable `unsupported_file` screen; dead-capability
refusals (expired/used/cancelled/attempts-exhausted/response-submitted) stay on `blocked` because a
fresh QR on the desktop — not a retake — is what fixes those. Contract test added.
`capture-schema.ts`, `capture-phone.tsx`.

## Recommended (fixed)

**N6 — desktop split covered only quality-check technical failures.** `failure_class` was only
persisted at finalise, so sign-upload (502) and bind (500) failures returned the class to the phone
but never to the token. **Fix:** a `markTokenTechnicalFailure` helper persists
`failure_class='technical'` on the token on both paths, and the desktop phase machine now returns
`capture_problem` when `failure_class==='technical'` even before a photo is bound (with the "use
this photo" button shown only when an attachment actually exists). `index.ts`, `CaptureItem.tsx`.

**N7 — "open capability can't corrupt a submitted response" was not DB-enforced.** Confirmed on live
Production that `bind_response_attachment` had no `is_submitted` check — the guarantee rested on an
edge-function check-then-act window (download + validate + fingerprint + vision call all sit between
the check and the bind). **Fix:** new migration `20260819120100_bind_response_attachment_writable_guard.sql`
does `create or replace` on `bind_response_attachment` (body copied verbatim from
`20260818011720`, grants preserved and re-stated) adding an `is_submitted = false and attempt.status
in ('draft','failed')` check under its existing row lock, raising `attach_capture:response_not_writable`.
Now enforced for both callers (the capture bridge and authenticated `attach_capture`).
`mapBindError` maps the new code → 409 `response_already_submitted`. Fake bind models the guard; a
race test (`beforeBind` flips `is_submitted` mid-request) asserts the bind refuses and nothing is
written.

**N8 — test-fake fidelity.** `append_capture_pairing_event`'s fake now uses row-locked-style
`max(sequence)+1` (was `count+1`), with a gap regression test that would fail under the old formula;
the fake `bind_response_attachment` models the N7 writability guard; added tests for the F6
`expired`/`rejected` caller branches (state committed, 409 returned) and the same-path idempotency
short-circuit (recorded result returned, nothing re-bound). `index_test.ts`.

**N11 — F1's fix silently absent when the quality checker is unavailable.** With
`OPENAI_DAILY_CAP_USD` unset the check is unconditionally `unavailable`, making `keepOpen` always
false. **Fix:** an unavailable check now logs a `capture_quality_unavailable` audit event flagging
the misconfiguration case (key present, no cap), so the checker silently not running is visible.
Recorded reasoning: with no verdict there is no basis to prompt a retake, so accepting the photo
as-is is correct — the fix makes the *misconfiguration* loud rather than forcing a request failure
that would break the documented best-effort contract. `index.ts`.

**N14 — stale build doc.** `QR_MVP_IMPLEMENTATION.md` (on the branch) now carries a SUPERSEDED
banner with corrected counts (index.ts 1,100→1,708 lines; "three functions"→seven callable, plus
the N7 guard) pointing to this record and `QR_MVP_REWORK_2026_08_20.md`.

## Explicitly deferred (recorded, not attempted this pass)

N5 (multi-slot supersede unrecoverable — latent, frontend hardcodes `"slot-1"`), N9
(`FALLBACK_DIRECT` unreachable — cosmetic), N10 (two error codes for one condition — cosmetic), N12
(F7's erasure trap not cleared one level up — pre-existing, `response_attachments`' own immutability
guard blocks parent deletes), N13 (idempotency short-circuit trusts path, not digest), the F13
orphan-attachment gap (latent while `evaluate-attempt` ignores `response_attachments`), and the
Round-1 lower-severity list. The `human_review_pending`-with-nothing-to-resolve-it product question
remains an owner decision, not engineering.

## Test summary

- Backend: `deno test` — 260 `_shared` + 30 handler = **290 pass, 0 fail**; `deno check` +
  `deno lint` clean.
- Frontend: `vitest` — **232 pass**; `tsc --noEmit` + `vite build` clean.

## Next step

A **Round-4 independent QA** of `5ce92ec`/`668a2cd` — do not self-certify as mergeable. Prompt:
`prompts/CLAUDE_TASK0016_PHASE_D2_QR_CAPTURE_INDEPENDENT_QA_ROUND4_2026_08_20.md`.
