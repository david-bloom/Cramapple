# TASK-0069 — Hand-Drawn Responses on Every FRQ

**Task ID:** TASK-0069
**Title:** Any student can photograph a handwritten or drawn answer to any FRQ (current or future), confirm what we read from it, and get it graded; image management and retention included
**Owner:** Claude session (implementation). **Product Owner:** David Bloom
**Tier:** Hard-Gate (model processing of student photos, schema migrations, new owner/admin ops, production frontend publish, retention rule)
**Status:** **Ready for Review.** Backend built, independently reviewed (8 findings fixed), applied to Development, Development smoke passes end to end; frontend built in the Lovable App preview (unpublished, dark default); build PR open for David. Codex QA handoff written. Production execution is gated on David's merge of the build PR (his stated go-ahead mechanism).
**Priority:** High
**Created Date:** 2026-10-09
**Approved Date:** 2026-10-09 for the three plan decisions D1, D2 (conditioned), D4 (`APPROVAL-0142`); David then directed "execute the build including Lovable front end work, and move hand drawn responses to production as a PR. I will review and merge the PR." Open plan decisions D3, D5–D8 are taken at the plan's recommended defaults and recorded below as assumptions for his review.
**Branch:** `claude/hand-drawn-frq-build-2026-10-09` (build). Plan and decision records: `claude/hand-drawn-deployment-2026-10-09` (PR #395, docs-only).
**PR:** build PR to be opened from the build branch once the frontend is in preview.
**Design:** `docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md` (governing). Frontend brief as sent: `docs/handoffs/FRQ_PHOTO_FRONTEND_PROMPT_2026_10_09.md`. Execution record: `docs/handoffs/TASK0069_FRQ_PHOTO_EXECUTION_2026_10_09.md`.
**Related:** `TASK-0016` Phase D, `TASK-0020`, `TASK-0025`, `TASK-0038`, `TASK-0068` (code reused), `DECISION-0051`, `DECISION-0059`, `DECISION-0109`, `DECISION-0110`, `DECISION-0111`, `APPROVAL-0142`

## Product Goal

On any FRQ, a student may type, photograph their page, or both. We read the photo into a per-part transcript, the student confirms or completes it ("Is this your answer? Anything we missed?"), and the existing text grader scores the confirmed transcript. Items whose rubric needs a constructed visual require a photo and go to the human grading queue. The photo is preserved, privately, with a retention rule that redacts bytes but keeps the audit row.

## Technical Scope (what this task builds; plan Phases 0, 1 and 3 together)

1. **Content model.** `app.content_items.response_policy` (`typed_only` / `photo_allowed` / `photo_required`), backfilled for all 1,090 published FRQs (40 hand-drawn items → `photo_required`), defaulted on insert by trigger, enforced and auto-corrected at publish. `app.frq_criteria.judgement_kind` (`text` / `image`) backfilled for the hand-drawn items. `select_student_practice_items` returns `response_policy` and serves hand-drawn items (the legacy `/session` selectors keep their TASK-0038 exclusion).
2. **Transcript.** `_shared/drawn-response-extraction.ts` (OpenAI Responses API, `store: false`, closed strict schema with no answer-bearing field, `[unreadable]` / `[see photo: …]` markers, never throws) and `_shared/response-transcript.ts` (parts, confirmation validation, `student_added`, the submit gate). `attempt-response` ops `propose_transcript` (owner; per-student daily cap, feature breaker, shared ledger reservation; reuses a stored proposal for the same photo) and `confirm_transcript` (owner; writes the confirmed text onto the same unsubmitted response version the photo is bound to). `submit_response` refuses a response with a bound photo until its transcript is confirmed (`transcript_confirmation_required`), only while the feature flag is on.
3. **Image management.** Capture, byte validation, EXIF stripping, quality check, and immutable binding are the existing Stage D2 pipeline. New: `SAME_DEVICE` access path (phone as primary device; the phone's declared path now wins in `claim_capture_pairing_upload`), `response_attachments.redacted_at` with a one-time-write guard, `app.redact_response_attachment()`, `app.response_attachments_due_for_redaction(interval)`, and the admin op `redact_attachment` (removes bytes through the Storage API, stamps the row).
4. **Grading.** Unchanged `evaluate-attempt`: the confirmed transcript is the response text. `photo_required` items are not sent to `evaluate-attempt`; they stay `submitted` for the human queue (`list_manual_grading_queue`), whose context now carries the transcript, `student_added` spans, and `judgement_kind` per criterion.
5. **Frontend (Lovable App `56cae479`).** Capture control on the Practice FRQ screen (QR on desktop, same-device camera on phones), the confirm-or-add review screen (DECISION-0110 condition), pending-review state for `photo_required` items, consent copy, admin grading queue and RLS-safe per-attempt page, redact button, PostHog events, feature flag (`?photo=on`, admins always on, subject allow-list).
6. **Verification.** 587 Deno tests (31 new); `scripts/frq_photo_smoke.mjs` drives the deployed functions end to end with a real student and a real admin.

## Assumptions standing in for open decisions (David to confirm or change at review)

- **D3:** flag-gated subject allow-list at launch; first publish dark for students (admins only), then AP Biology + AP Statistics, then all. One env value (`VITE_FRQ_PHOTO_SUBJECTS`) widens it.
- **D5:** 30 transcript reads per student per day; `FRQ_PHOTO_DAILY_CAP_USD` 50; reservation 0.03 USD per read against the shared `OPENAI_DAILY_CAP_USD`, failing closed to "type your answer".
- **D6:** partial grading is NOT built in this slice; `photo_required` items are wholly human-graded, as under `DECISION-0059`; every other FRQ grades automatically from the transcript.
- **D7:** grader stays David alone (`DECISION-0059`).
- **D8:** the Practice FRQ screen hosts capture; the capture component is shared; `/session` is untouched.
- Phase 0's separate `/session-hand-drawn-pilot` route is superseded by the Practice FRQ screen serving `photo_required` items directly; the admin queue and RLS-safe page are ported into the Lovable App as part of this build.
- Multi-page photos, the downscaled derived copy for model calls, and the scheduled retention sweep are deferred follow-ups (the sweep's selector function exists; nothing is due for 24 months).

## Out of Scope

BYOQ; worksheet upload; Engine 4 automated grading of image-judgeable criteria (Phase 2); parent access to photos; privacy-policy text changes.

## Routes / Components / Systems Affected

- Supabase: migrations `20261009230917_frq_photo_responses_content`, `20261009230918_frq_photo_responses_attachments`, `20261009231314_capture_access_path_phone_reported`, `20261009233521_frq_photo_responses_hardening`, `20261009233645_merge_response_parts_invoker` (Development versions); functions `attempt-response`, `student-session-items`, `capture-pairing`; new env `FRQ_PHOTO_RESPONSES_ENABLED`, `FRQ_TRANSCRIPT_MODEL`, `FRQ_TRANSCRIPT_DAILY_RUNS`, `FRQ_PHOTO_DAILY_CAP_USD`, `FRQ_TRANSCRIPT_RESERVED_COST_USD`, `FRQ_TRANSCRIPT_TIMEOUT_MS`.
- Lovable App: `PracticeFrqScreen`, `LivePracticeFrq`, new `ResponseCapture` / `CapturePhoneFlow`, `capture-phone` route, `live-practice-frq/{adapt,photo,photo-review}.ts`, `feature-flags.ts`, `posthog.ts`, `admin.grade-response.index.tsx`, `admin.grade-response.$attemptId.tsx`.

## Data / Security / Integration Impact

Student photos continue to live in the private `learner-uploads` bucket under the owner's namespace; the model receives the metadata-stripped derived copy when one exists, inline, with `store: false`; no URL leaves the system. New ops are owner-only (transcript) or admin-only (redaction) and use the service role behind those checks. The transcript proposal is stored on the student's own response version; `_transcript` never reaches PostgREST for other users because `response_versions` RLS is owner-only. Spend is reserved per call through the shared ledger and fails closed. Redaction keeps the digest for dispute integrity.

## Acceptance Criteria

- [x] Every published FRQ carries `response_policy`; hand-drawn items are `photo_required`; a future FRQ inherits `photo_allowed` and cannot publish without a policy (Development verified).
- [x] A photo bound to a response cannot be submitted until its transcript is confirmed; confirmation writes the response text; the grader scores the confirmed text (Development smoke).
- [x] Same-device capture is recorded as `SAME_DEVICE` (Development smoke).
- [x] An admin can read the grading context with transcript and judgement kinds, and redact a photo; the row survives with its digest; the object is gone (Development smoke).
- [x] Frontend: capture control, confirm-or-add review, pending-review state, admin queue, consent copy, flag — built in preview (Lovable commits `42c5028e`, `700965bd`), 834 vitest passing, `tsc` and `vite build` clean; read against the brief.
- [ ] Production: migrations, secrets, functions, publish; live admin run on `app.cramapple.com` (one typed+photo FRQ graded; one `photo_required` item reaching the queue and graded by David).
- [x] Independent backend review (fresh-context agent, 2026-10-09): two High, four Medium, three Low findings; all but one Low (cap overshoot under concurrency, accepted) fixed and re-verified by the extended smoke.
- [ ] Independent QA (Codex, fresh context) per `docs/handoffs/HANDOFF_TASK0069_CODEX_QA_2026_10_09.md`, before students see it.

## QA Plan

Deno unit tests (schema closure, normalisation, flattening, submit gate, confirmation validation, `response_policy` derivation); `scripts/frq_photo_smoke.mjs` on Development and, after the Production apply, on Production; vitest in the Lovable App for the review-screen rules, the flag, and the adapt default; a browser script (Sol's pattern) on the published app as admin with `?photo=on` before the student default is widened.

## Implementation Summary

See `docs/handoffs/TASK0069_FRQ_PHOTO_EXECUTION_2026_10_09.md` (status log, Development evidence, Production runbook, rollback).

## Test Results

Deno: 587 passed, 0 failed (`deno test --allow-env --allow-read --allow-net supabase/functions`). Development smoke (`scripts/frq_photo_smoke.mjs`, 23:40 UTC): all checks passed, including the PostgREST forgery refusal and the retake-after-confirm gate; the unit-gated serving check is skipped on Development (no labelled, servable FRQs there) and is covered on Production. Lovable App: 834 vitest passing across 92 files, `tsc --noEmit` and `vite build` clean.

## Risks / Issues

- Development cannot exercise unit-gated FRQ serving, so `response_policy` on the served payload is first proven on Production.
- The first Lovable publish ships whatever else is in preview; review the diff at publish time.
- Transcript fidelity on real handwriting is unmeasured beyond the one fixture; the `frq_transcript_confirmed.edited_fields` event is the real number.

## Approval State

**Approval Required:** Yes — Hard Gate. Plan decisions D1/D2/D4: `APPROVAL-0142`. Build and Production: David's merge of the build PR is the stated go-ahead; the Production apply, secrets, function deploys, and Lovable publish are recorded as an `APPROVAL` entry when executed.

## QA Result

Pending (frontend).

## Done Decision

Pending.
