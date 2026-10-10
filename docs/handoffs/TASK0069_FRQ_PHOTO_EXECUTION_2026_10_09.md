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
| 23:25 | Lovable App frontend built in preview: commit `42c5028e` (feature, 813 tests), follow-up `700965bd` (dark default `none`, reviewer score shown when it arrives, graded-state on the admin page; 834 tests, `tsc` and `vite build` clean). Nothing published. |
| 23:33 | Independent backend review (fresh-context agent): H1 stale confirmation after a retake; H2 propose/confirm overwrite race; M1 trigger-function search_path dropped; M2 reserved `_` keys writable by the owner through PostgREST (`app` is an exposed schema); M3 idempotency replay not actor-scoped; M4 redaction stamped without verifying removal; L1 error mapping; L3 constraint drop by auto-name. All fixed: confirmation now carries the photo digest and the gate compares it (H1); writes go through `app.merge_response_parts()` (H2); `app.response_versions_guard_reserved_parts` trigger (M2); actor-scoped lookup (M3); per-bucket removal verified against the returned list (M4); 409/502 mappings (L1); drop-by-definition in the Production file (L3); search_path restored (M1). L2 (cap read-then-act can overshoot by a few cents under concurrency) accepted. |
| 23:35 | Migrations `frq_photo_responses_hardening` (`20261009233521`) and `merge_response_parts_invoker` (`20261009233645`; the merge function must be SECURITY INVOKER or the reserved-keys trigger refuses it) applied to Development; `attempt-response` redeployed. |
| 23:40 | Development smoke extended (PostgREST forgery refused; retake after confirm re-closes the gate; re-propose is a fresh read; re-confirm succeeds): **all checks pass**. Deno 587/587. |
| 2026-10-10 ~00:10 | **Codex QA: Fail / Blocked** (`docs/qa/QA_TASK0069_CODEX_2026_10_09.md`): P1-a confirmation not content-bound; P1-b retake/submit TOCTOU; P2-a `photo_required` typed-submit bypass; P2-b redaction false success; P3 no boundary tests. All verified (and P2-a found wider: hand-drawn items served to every student). |
| 00:23 | Remediation: migration `20261010002322_frq_photo_submission_integrity` (content digest, `app.confirm_response_transcript`, submission guard trigger inside the submit transaction) applied to Development; `attempt-response`, `student-session-items`, `evaluate-attempt` deployed; `FRQ_PHOTO_SUBJECTS=ap-statistics` on Development. Integration test 8/8, race test both orderings, smoke all checks, Deno 596/596. Lovable `e8c11dce` (server-driven flag, no typed path for `photo_required`, new codes; 838 tests). Record: `docs/qa/QA_TASK0069_REMEDIATION_2026_10_09.md`. Awaiting Codex re-QA. |
| 2026-10-10 | **Codex re-QA: Pass** (all five findings resolved; Deno 596/596, integrity 8/8, race 7/7, smoke all checks). One non-blocking P3: the legacy `submit-response` wrapper returned 500 for the two new refusal codes; fixed (mapped to 409). It is not in the deploy set. Branch brought up to date with `main` (FRQ gap fill, `APPROVAL-0143`); merge was clean; Deno 596/596 on the merged tree. **Ready for David's merge of PR #397**, which is the Production go-ahead for the runbook below. |

## What is built (backend, this repo)

| Piece | Where |
| --- | --- |
| Content model, publish gate, criteria kinds, live selector | `supabase/migrations/20261009230917_frq_photo_responses_content.sql` |
| Redaction, retention selector, immutability guard, `SAME_DEVICE` | `supabase/migrations/20261009230918_frq_photo_responses_attachments.sql` |
| Phone-declared access path wins | `supabase/migrations/20261009231314_capture_access_path_phone_reported.sql` |
| Hardening after review: atomic `merge_response_parts`, reserved-keys trigger, search_path | `supabase/migrations/20261009233521_frq_photo_responses_hardening.sql`, `20261009233645_merge_response_parts_invoker.sql` |
| Submission integrity (Codex QA remediation): content digest, confirm function, guard trigger | `supabase/migrations/20261010002322_frq_photo_submission_integrity.sql` |
| Server-side rollout (`FRQ_PHOTO_SUBJECTS`) and redaction sequence | `supabase/functions/_shared/frq-photo-rollout.ts`, `_shared/attachment-redaction.ts` (+ tests) |
| Database and race tests | `supabase/tests/task0069_submission_integrity.integration.sql`, `scripts/frq_photo_race_test.py` |
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

1. Migrations on `pcntajvbdfqhbeewmdry`, in order, through `apply_migration` with the same names (Production records its own versions; note them here): `frq_photo_responses_content`, `frq_photo_responses_attachments`, `capture_access_path_phone_reported`, `frq_photo_responses_hardening`, `merge_response_parts_invoker`, `frq_photo_submission_integrity`. Pre-check: `select count(*) from app.content_items where item_type='frq' and status='published'` (expect 1,090) and after: `response_policy` null count 0, `photo_required` count 40.
2. Secrets on Production: `FRQ_TRANSCRIPT_MODEL=gpt-4.1-mini`; `FRQ_PHOTO_RESPONSES_ENABLED=true` (turns the transcript ops on); leave `FRQ_PHOTO_SUBJECTS` **unset** (= `none`: admins only; hand-drawn items withheld from students). The submission guard in the database is unconditional. Confirm `OPENAI_DAILY_CAP_USD` is set (it is, for BYOQ).
3. Functions (after the migrations: `evaluate-attempt` reads the new `response_policy` column): `supabase functions deploy <fn> --project-ref pcntajvbdfqhbeewmdry --no-verify-jwt --use-api --workdir <repo root>` for `attempt-response`, `student-session-items`, `capture-pairing`, `evaluate-attempt`; compare deployed content with local as TASK-0038/0068 did.
4. Smoke on Production: `scripts/frq_photo_smoke.mjs` with the Production URL/keys and an existing admin (creates one `smoke+frqphoto-*` student; the serving check runs here). Leave the student in place, same as `student_grade_smoke.mjs`.
5. Lovable App publish (David's step unless he delegates): the control follows the server's `photo_enabled`, so the publish is dark for students while `FRQ_PHOTO_SUBJECTS` is unset. Review the publish diff for other sessions' preview edits.
6. Live admin run on `app.cramapple.com` as an admin: one `photo_allowed` FRQ typed+photographed and graded; one `photo_required` item (AP Biology or AP Statistics hand-drawn) photographed, confirmed, reaching `/admin/grade-response`, graded by David, result visible to the student. This is `DECISION-0059` Stage 1 in its new form.
7. Widen: `supabase secrets set FRQ_PHOTO_SUBJECTS=ap-biology,ap-statistics --project-ref pcntajvbdfqhbeewmdry` (no redeploy, no publish); later `all`.

**Rollback:** `supabase secrets set FRQ_PHOTO_SUBJECTS=none --project-ref pcntajvbdfqhbeewmdry` returns to admins-only (hand-drawn items withheld, control hidden); `FRQ_PHOTO_RESPONSES_ENABLED=false` additionally stops the transcript ops. No redeploy either way. The database guard stays (it only refuses unconfirmed photo submissions and typed `photo_required` submissions). Columns and functions stay.

## Frontend (Lovable App `56cae479`, preview only)

Commits `42c5028e` and `700965bd`. New: `src/screens/parts/FrqPhotoPanel.jsx`, `src/components/session/ResponseCapture.tsx`, `src/components/session/CapturePhoneFlow.tsx`, `src/lib/live-practice-frq/photo.ts`, `src/lib/live-practice-frq/photo-review.ts`, `src/routes/admin.grade-response.index.tsx`, tests in `src/lib/live-practice-frq/__tests__/frq-photo.test.ts`. Changed: `PracticeFrqScreen.jsx`, `LivePracticeFrq.jsx`, `adapt.ts`, `grade.ts` (shared `evaluateLiveFrq`, `recordedAttemptFromGradingRow`), `feature-flags.ts` (default `none`), `posthog.ts`, `capture.functions.ts`, `capture-schema.ts`, `capture-phone.tsx`, `admin.grade-response.$attemptId.tsx`, `FeedbackCard.jsx`. Read by Claude against the brief; deviations from the brief: none material (the agent put the row-to-attempt mapping in `grade.ts` to keep `photo.ts` out of the test import graph).

## Open items

- Independent QA by Codex: `docs/handoffs/HANDOFF_TASK0069_CODEX_QA_2026_10_09.md`.
- Independent frontend QA (fresh context) before the student default widens.
- Follow-ups deferred from the plan: multi-page photos; downscaled derived copy for model calls; scheduled retention sweep (needs a function invoker like BYOQ's purge); partial grading for `photo_required` items (Phase 2).
- Development admin `smoke+frqphoto-admin@cramapple.test` exists for smoke runs; delete when no longer needed.
