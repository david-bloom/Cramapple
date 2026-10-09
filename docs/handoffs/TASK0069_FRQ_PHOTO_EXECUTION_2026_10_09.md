# TASK-0069 execution record — hand-drawn responses on every FRQ

**Status:** Live record, updated as the build proceeds. Plan: `docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md`. Task: `docs/tasks/TASK-0069-HAND-DRAWN-RESPONSES-EVERY-FRQ.md`. Branch: `claude/hand-drawn-frq-build-2026-10-09`.

## Status log

| When (UTC) | What |
| --- | --- |
| 2026-10-09 ~22:00 | David: "execute the build including Lovable front end work, and move hand drawn responses to production as a PR. I will review and merge the PR." |
| 22:10–23:05 | Backend written: migrations, `_shared/drawn-response-extraction.ts` (+ 13 tests), `_shared/response-transcript.ts` (+ 8 tests), `attempt-response` ops `propose_transcript` / `confirm_transcript` / `redact_attachment`, submit gate, `get_manual_grading_context` extended, `response_policy` on `RenderItem` (+ test), `SAME_DEVICE` access path. |
| 23:09 | Migrations applied to Development (`20261009230917`, `20261009230918`); `attempt-response`, `student-session-items`, `capture-pairing` deployed to Development; `FRQ_PHOTO_RESPONSES_ENABLED=true`, `FRQ_TRANSCRIPT_MODEL=gpt-4.1-mini` set on Development. |
| 23:12 | First Development smoke: 24 pass; access path recorded `QR` (two causes: `isPairingAccessPath` hard-coded two values; `claim_capture_pairing_upload` kept the first value and `describe_capture` had already stamped `QR`). |
| 23:13 | Fixes: `isPairingAccessPath` reads the constant; `describe_capture` accepts a declared `access_path`; migration `20261009231314_capture_access_path_phone_reported` (phone's declared path wins). Applied to Development; `capture-pairing` redeployed. |
| 23:19 | Frontend brief sent to the Lovable App agent (`docs/handoffs/FRQ_PHOTO_FRONTEND_PROMPT_2026_10_09.md`). |
| 23:30 | Development smoke: **all checks pass** (serving check skipped on Development by design). |

## What is built (backend, this repo)

| Piece | Where |
| --- | --- |
| Content model, publish gate, criteria kinds, live selector | `supabase/migrations/20261009230917_frq_photo_responses_content.sql` |
| Redaction, retention selector, immutability guard, `SAME_DEVICE` | `supabase/migrations/20261009230918_frq_photo_responses_attachments.sql` |
| Phone-declared access path wins | `supabase/migrations/20261009231314_capture_access_path_phone_reported.sql` |
| Transcript reader (model call, schema, prompt, normalisation) | `supabase/functions/_shared/drawn-response-extraction.ts`, `_test.ts` |
| Confirmation rules, submit gate, `student_added` | `supabase/functions/_shared/response-transcript.ts`, `_test.ts` |
| Ops and gate | `supabase/functions/attempt-response/index.ts` (`propose_transcript`, `confirm_transcript`, `redact_attachment`, submit gate, extended `get_manual_grading_context`) |
| Serving payload | `supabase/functions/_shared/student-item-delivery.ts` (`response_policy`, `deriveResponsePolicy`), test updated |
| Capture | `supabase/functions/_shared/capture-pairing.ts` (`PAIRING_ACCESS_PATHS`), `supabase/functions/capture-pairing/index.ts` (`describe_capture` accepts `access_path`) |
| Smoke | `scripts/frq_photo_smoke.mjs`, fixture `scripts/frq-photo-smoke/fixtures/answer-page.png` |

Environment variables (function secrets): `FRQ_PHOTO_RESPONSES_ENABLED` (default off), `FRQ_TRANSCRIPT_MODEL` (default `OPENAI_MODEL`, then `gpt-4.1-mini`), `FRQ_TRANSCRIPT_TIMEOUT_MS` (45 000), `FRQ_TRANSCRIPT_RESERVED_COST_USD` (0.03), `FRQ_TRANSCRIPT_DAILY_RUNS` (30 per student), `FRQ_PHOTO_DAILY_CAP_USD` (50), and the required shared `OPENAI_DAILY_CAP_USD` (fail closed) and `OPENAI_API_KEY`.

## Development evidence (2026-10-09 23:30 UTC)

`scripts/frq_photo_smoke.mjs` against `wmgjsdkphcyhngaffbqf` with a new student and the Development admin `smoke+frqphoto-admin@cramapple.test` (created for this task; role set server-side):

- serving: skipped (Development has no labelled, servable FRQs; `select_student_practice_items` also references `app.taxonomy_relevant_hash`, absent on Development) — a published FRQ read directly carries `response_policy = photo_allowed` after the backfill;
- `create_attempt` → `save_response` (draft) → `mint_pairing` → `describe_capture` / `create_capture_upload` with `SAME_DEVICE` → signed PUT → `submit_capture` (quality `acceptable`); token records `SAME_DEVICE`;
- `submit_response` before confirmation → 409 `transcript_confirmation_required`;
- `propose_transcript` → `proposed` in ~3.3 s on `gpt-4.1-mini`, warnings `["visual_elements"]`, text matches the fixture page; a second call is served from the stored proposal;
- `confirm_transcript` refuses an unknown part (422), accepts the parts with one added line, records `student_added` for that part;
- `submit_response` → 200; `evaluate-attempt` → `uncertain` 0/1 on the (deliberately mismatched) item, with a `grading_results` row for the confirmed response version whose text contains the added line;
- admin `get_manual_grading_context` → `response_source = photo_transcript`, `transcript_parts`, `transcript_confirmed_at`, criteria with `judgement_kind`; queue does not list the graded attempt;
- student `redact_attachment` → 403; admin → 200; row has `redacted_at` and its digest; Storage GET returns 400/404.

Deno: `587 passed | 0 failed`.

## Production runbook (after David merges the build PR; each step is Hard-Gate and is recorded in an APPROVAL entry when run)

1. Migrations on `pcntajvbdfqhbeewmdry`, in order, through `apply_migration` with the same names (Production records its own versions; note them here): `frq_photo_responses_content`, `frq_photo_responses_attachments`, `capture_access_path_phone_reported`. Pre-check: `select count(*) from app.content_items where item_type='frq' and status='published'` (expect 1,090) and after: `response_policy` null count 0, `photo_required` count 40.
2. Secrets on Production: `FRQ_TRANSCRIPT_MODEL=gpt-4.1-mini`; `FRQ_PHOTO_RESPONSES_ENABLED=true` (this turns the submit gate and the transcript ops on; the student-facing control is still governed by the frontend flag). Confirm `OPENAI_DAILY_CAP_USD` is set (it is, for BYOQ).
3. Functions: `supabase functions deploy <fn> --project-ref pcntajvbdfqhbeewmdry --no-verify-jwt --use-api --workdir <repo root>` for `attempt-response`, `student-session-items`, `capture-pairing`; compare deployed content with local as TASK-0038/0068 did.
4. Smoke on Production: `scripts/frq_photo_smoke.mjs` with the Production URL/keys and an existing admin (creates one `smoke+frqphoto-*` student; the serving check runs here). Leave the student in place, same as `student_grade_smoke.mjs`.
5. Lovable App publish (David's step unless he delegates): first publish dark for students (`VITE_FRQ_PHOTO_SUBJECTS` default `none`; admins and `?photo=on` only). Review the publish diff for other sessions' preview edits.
6. Live admin run on `app.cramapple.com` with `?photo=on`: one `photo_allowed` FRQ typed+photographed and graded; one `photo_required` item (AP Biology or AP Statistics hand-drawn) photographed, confirmed, reaching `/admin/grade-response`, graded by David, result visible to the student. This is `DECISION-0059` Stage 1 in its new form.
7. Widen: set `VITE_FRQ_PHOTO_SUBJECTS=ap-biology,ap-statistics` (or change the default) and publish; later `all`.

**Rollback:** `supabase secrets set FRQ_PHOTO_RESPONSES_ENABLED=false --project-ref pcntajvbdfqhbeewmdry` (no redeploy): transcript ops refuse with `feature_disabled`, the submit gate is inert, the frontend hides the control on that code. Columns and functions stay. The selector change (hand-drawn items served to Practice) is independent of the flag; if it must be reverted, re-apply the 2026-10-08 selector body.

## Open items

- Frontend build in progress (Lovable agent). Tests, `tsc`, and `vite build` are part of the brief.
- Independent frontend QA (fresh context) before the student default widens.
- Follow-ups deferred from the plan: multi-page photos; downscaled derived copy for model calls; scheduled retention sweep (needs a function invoker like BYOQ's purge); partial grading for `photo_required` items (Phase 2).
- Development admin `smoke+frqphoto-admin@cramapple.test` exists for smoke runs; delete when no longer needed.
