# Handoff to Codex — TASK-0069 Hand-Drawn Responses on Every FRQ: what was built, and the QA brief

**Date:** 2026-10-09. **From:** Claude (implementing session). **To:** Codex (independent QA, fresh context). **Product Owner:** David Bloom.
**Status of the work at handoff:** backend built, applied to Development and smoke-tested end to end; frontend built in the Lovable App preview (unpublished); Production execution gated on David's merge of the build PR.

Read `docs/team_charter/CRAMAPPLE_SESSION_START.md` and start with the tier-first rules in `prompts/CODEX_NEW_SESSION_PROMPT.md`. This is **Hard-Gate** work. You are the **QA Agent**: you propose findings and a recommended verdict, you may set the task `Blocked`, and you must not publish, deploy, migrate, merge, or mark anything `Done` (`docs/team_charter/AI_COLLABORATION_RULES.md` §QA Agent).

```text
Task:
- TASK-0069 — Hand-Drawn Responses on Every FRQ

Prompts Included:
- [ ] Implementation Agent
- [x] QA Agent
- [ ] UX / Prompt Agent

Current Source:
- Task doc: docs/tasks/TASK-0069-HAND-DRAWN-RESPONSES-EVERY-FRQ.md
- Related docs: docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md (governing plan);
  docs/handoffs/TASK0069_FRQ_PHOTO_EXECUTION_2026_10_09.md (what is built, Development evidence, Production runbook, rollback);
  docs/handoffs/FRQ_PHOTO_FRONTEND_PROMPT_2026_10_09.md (the frontend brief, verbatim);
  DECISION-0109 / DECISION-0110 / DECISION-0111 and APPROVAL-0142 in docs/activity_log/
- Relevant history: TASK-0038 (the pilot; its Phase 3/4 frontend never reached the Lovable App), TASK-0025, TASK-0016 Phase D, DECISION-0051, DECISION-0059
- Latest commits reviewed: backend branch claude/hand-drawn-frq-build-2026-10-09 (this repo); Lovable App 56cae479 commit 42c5028e (feature) plus one follow-up commit (dark default, reviewer score display, graded-state in admin page) — read the execution record's status log for the final SHA
- Branch / PR: claude/hand-drawn-frq-build-2026-10-09; build PR to be opened from it (merge = David's Production go-ahead). Plan/records PR: #395 (docs-only)
- Uncommitted / unpushed state: none expected; verify with git status on the branch

Approval State:
- Approved: plan decisions D1 (same-device capture), D2 (mandatory transcript confirmation with a confirm-or-add-missing-content prompt), D4 (retention by redaction) — APPROVAL-0142; David's direction to build and present Production as a PR
- Not approved: plan decisions D3, D5–D8 (built at the plan's recommended defaults, listed as assumptions in the task record); Production apply; Lovable publish; Done
- Required before execution of anything in Production: David's PR merge; an APPROVAL entry when the runbook runs

Live / Tool State:
- Environments checked: Development (wmgjsdkphcyhngaffbqf) — migrations applied, functions deployed, flag on, smoke passes; Production (pcntajvbdfqhbeewmdry) — read-only checks only, nothing applied
- Services checked: Supabase (Dev/Prod), Lovable App preview (code read by commit), OpenAI via the shared ledger (Dev)
- Not checked / unavailable: unit-gated FRQ serving on Development (no labelled, servable FRQs there); the frontend against a live backend (the Lovable preview and the published app both point at Production Supabase, where the backend is not yet deployed); a real phone

Files / Systems Affected:
- Docs: task record, execution record, frontend brief, INDEX row, plan pointer
- Code: supabase/functions/attempt-response/index.ts; supabase/functions/_shared/{drawn-response-extraction,response-transcript,student-item-delivery,capture-pairing}.ts (+ tests); supabase/functions/capture-pairing/index.ts; scripts/frq_photo_smoke.mjs (+ fixture)
- Data/schema: supabase/migrations/20261009230917_frq_photo_responses_content.sql, 20261009230918_frq_photo_responses_attachments.sql, 20261009231314_capture_access_path_phone_reported.sql
- Integrations: OpenAI Responses API (gpt-4.1-mini) through app.reserve_model_usage; Supabase Storage (learner-uploads)
- Frontend/routes (Lovable App): PracticeFrqScreen/LivePracticeFrq, parts/FrqPhotoPanel.jsx, components/session/{ResponseCapture,CapturePhoneFlow}.tsx, routes/capture-phone.tsx, lib/live-practice-frq/{adapt,photo,photo-review,grade}.ts, lib/feature-flags.ts, lib/posthog.ts, lib/capture.functions.ts, lib/capture-schema.ts, routes/admin.grade-response.index.tsx, routes/admin.grade-response.$attemptId.tsx, components/feedback/FeedbackCard.jsx
- Other: new function secrets FRQ_PHOTO_RESPONSES_ENABLED, FRQ_TRANSCRIPT_MODEL (and optional caps)

Open Risks / Blockers:
- P1: the served payload's response_policy and the whole frontend flow are unexercised against a live backend until Production is applied; the Development smoke proves the function contract, not the screen
- P1: the first Lovable publish will carry other sessions' preview edits; the publish diff must be reviewed
- P2: transcript fidelity on real handwriting is measured on one fixture only; the frq_transcript_confirmed.edited_fields event is the real number
- P2: multi-page photos, a downscaled model copy, the scheduled retention sweep, and partial grading are deferred (plan follow-ups)
- Pending owner decisions: D3, D5–D8 (defaults in use); the Production go-ahead (PR merge)

Do Not Touch:
- Scope exclusions: BYOQ (separate tables and screens, DECISION-0068); /session's legacy CaptureItem path; marketing site
- Deferred features: see P2 above
- Hard gates: no Production writes of any kind, no Lovable publish, no secrets changes, no migrations, no merges, no git stash in the shared repo (use the worktree or a fresh clone)

Next Expected Output:
- QA report at docs/qa/QA_TASK0069_CODEX_2026_10_09.md with a recommended verdict (Pass / Fail) and findings labelled P1/P2/P3, each with evidence label (Observed / Code-reviewed / Inferred / Untested)
- Required files to update: the task record's "QA Result" and "Test Results" fields (proposed), and status to Blocked if QA cannot proceed
- Required evidence: command transcripts for the Deno suite and the Development smoke; file:line references for code findings; the Lovable commit SHA reviewed; screenshots only if a browser run was possible
```

## What this work is, in one paragraph

Any FRQ now declares a `response_policy`. On the Practice FRQ screen a student may type, photograph their page, or both. The photo is captured through the existing Stage D2 pipeline (QR from a desktop, or the phone's own camera when the phone is the primary device), bound immutably to an unsubmitted response version, and read by a vision model into a per-part transcript. The student sees "Is this your answer?" with every part editable, prompts for anything unreadable or missing, and "Anything we missed? Add it so we can score your whole answer and show you what to fix." Only after they confirm can the response be submitted; the existing text grader then scores the confirmed transcript. Items whose rubric needs a constructed visual (`photo_required`, the 40 hand-drawn items) are not auto-graded; they wait in the admin queue, whose grading page now shows the transcript and which criteria need the picture. Photos are retained privately and, under the retention rule, redacted (bytes removed, audit row kept) rather than deleted.

## How to run things

- **Deno tests:** from the repo root, `deno test --allow-env --allow-read --allow-net supabase/functions` (expect 587 passed at handoff).
- **Development smoke:** `SMOKE_URL=https://wmgjsdkphcyhngaffbqf.supabase.co SMOKE_PUBLISHABLE_KEY=sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt SMOKE_SECRET_KEY="$(grep '^SUPABASE_DEV_SECRET_KEY=' .secrets.env | cut -d= -f2- | tr -d ' "')" node scripts/frq_photo_smoke.mjs`. The `.secrets.env` file is in the repo root checkout (git-ignored); never print its contents. Admin checks need `SMOKE_ADMIN_EMAIL` / `SMOKE_ADMIN_PASSWORD` for an existing Development admin (profile roles cannot be set through REST); without them those checks are skipped, which is acceptable for your run. The run creates one `smoke+frqphoto-*` student and costs about one cent of model spend.
- **Frontend code:** read by commit through the Lovable project (`56cae479-f7c9-4988-b536-56538c38ee4e`), not from this repo. Do not send Lovable messages; report what you would change.
- **Live browser run:** only possible after the Production runbook has run and the App is published. If the execution record's status log does not show that, record every browser scenario as **Untested: Production not applied** and do the code-level QA.

## Recommended Prompt for QA Agent

"""
You are the independent QA Agent for TASK-0069 (hand-drawn responses on every FRQ) in the Cramapple repository. Start a fresh context: read docs/team_charter/CRAMAPPLE_SESSION_START.md, then docs/handoffs/HANDOFF_TASK0069_CODEX_QA_2026_10_09.md (this packet), the task record, the plan, and the execution record it names. Work on branch claude/hand-drawn-frq-build-2026-10-09 in a worktree or fresh clone; never git stash in the shared checkout. You may run tests and the Development smoke; you must not deploy, migrate, publish, change secrets, merge, or write to Production.

Produce docs/qa/QA_TASK0069_CODEX_2026_10_09.md with: the commit SHAs reviewed (backend and Lovable), each finding as P1/P2/P3 with an evidence label (Observed / Code-reviewed / Inferred / Untested) and a file:line or step reference, and a recommended verdict Pass or Fail. P1 = a student can be graded on an unconfirmed read, a cross-user read or write, a lost photo, a Production-breaking migration, or a dark-launch leak (students see the control before the flag is widened). P2 = wrong behaviour on a reachable path or a misleading screen. P3 = quality.

Check, in this order:

1. Submit gate (DECISION-0110 item 1). In supabase/functions/attempt-response/index.ts and _shared/response-transcript.ts: with FRQ_PHOTO_RESPONSES_ENABLED on, a response version with a current original attachment and no _confirmed_at must be refused by submit_response with 409 transcript_confirmation_required; confirm_transcript must only ever write to an unsubmitted version owned by the caller; propose_transcript must refuse another user's attempt (403), an admin's own-behalf call is fine, and a redacted attachment (409). Try to construct a sequence that grades a stale transcript (propose → confirm → retake photo → submit) and say whether the current code allows it.

2. Schema and prompt safety. In _shared/drawn-response-extraction.ts: confirm the JSON schema is closed and has no field that could carry a correct answer, score, or rubric; confirm the prompt never receives the rubric or canonical answer (trace what attempt-response passes in); confirm a page_blank or failed read cannot block the student (they must still be able to type and confirm).

3. Spend. Confirm every model call reserves through app.reserve_model_usage and completes on every path, that a missing OPENAI_DAILY_CAP_USD fails closed, and that the per-student daily cap and the feature breaker are enforced before any download or model call.

4. Migrations. Read the three migration files against the live Development schema: the content_items trigger default and the publish-gate rewrite (does a hand-drawn item publish as photo_required; does an FRQ with null policy refuse); the response_attachments immutability trigger still blocks every other column and allows redacted_at exactly once; the capture_pairing_tokens check-constraint swap; the dropped and recreated select_student_practice_items (same grants, same body plus response_policy, hand-drawn exclusion removed only here). State whether applying them to Production in order is safe and what the pre- and post-checks should be.

5. Serving. In _shared/student-item-delivery.ts: deriveResponsePolicy and the key-allowlist test; confirm prompt_json never flows further than before. Note that Development cannot serve unit-gated FRQs and say what the Production check must be.

6. Run the Deno suite and the Development smoke; paste the summary lines. If the smoke fails, diagnose before reporting.

7. Frontend, by reading the Lovable App source at the commit named in the execution record: FrqPhotoPanel.jsx, ResponseCapture.tsx, CapturePhoneFlow.tsx, lib/live-practice-frq/{photo,photo-review}.ts, PracticeFrqScreen.jsx, LivePracticeFrq.jsx, feature-flags.ts, the two admin routes, posthog.ts. Verify: the review screen shows the four DECISION-0110 prompts (unreadable, empty part, "Anything we missed?", and the see-photo note) and every field is editable; photo_required items never call evaluate-attempt and show the pending-review state, then the reviewer's marks when a grading_results row appears; the flag default is "none" (dark) with admins and ?photo=on enabled; the typed Submit cannot create a second attempt once a photo slot exists; the consent copy is present; no PostHog property carries answer text, image data, or ids; SAME_DEVICE is passed on both describe and upload; the admin page uses get_manual_grading_context (no direct table reads) and offers "Submit grade" only for status submitted. Report deviations from docs/handoffs/FRQ_PHOTO_FRONTEND_PROMPT_2026_10_09.md.

8. If, and only if, the execution record's status log says Production was applied and the App published, run the live scenarios on https://app.cramapple.com as an admin with ?photo=on at 1280×720 and 375×812: (a) a photo_allowed AP Statistics FRQ, photographed via the same-device button with any page of your own handwriting with no name on it, review, confirm, graded result with the photo thumbnail; (b) retake after a blurry photo; (c) a photo_required item reaching /admin/grade-response, graded there, result visible to the student; (d) a non-admin student account on an allow-listed subject does NOT see the control while the default is "none". Otherwise record each as Untested: Production not applied.

Do not fix anything. Do not publish or deploy. Finish with the recommended verdict and the single most important thing David should know.
"""
