# Paywall sample: app-side Development smoke record (2026-11-09)

**Author-run smoke, NOT independent QA.** Development only (`wmgjsdkphcyhngaffbqf`); no Production call of any kind except one read-only `app.sample_unit_availability` count (see the owner-decisions doc, N3). Authority: `APPROVAL-0206`; the backend session agreed to the window in chat.
**Switches:** `SAMPLE_ACCESS_ENABLED=true` (edge secret, Supabase CLI pinned to the Development ref) and `app.config.sample_access_enabled=true`, both **restored to off** afterwards. Confirmed dark: `sample-try` returns `{"error":"sample_disabled"}`.

## What was run and observed (verified)

| Step | Result |
| --- | --- |
| `list_units`, ap-statistics | Unit 1 eligible (199 MCQs, 1 FRQ); Units 2, 3, 5 ineligible |
| `start` on an ineligible unit | `409 sample_unit_unavailable` with the unit list |
| `start`, unit 1 | question served; **no** `is_correct`, rationale or explanation in the response |
| `answer` | feedback returned with per-choice `is_correct` and rationale |
| second `answer` with a different choice | `already_answered`, stored feedback returned in the body |
| `start` again with the answered token | `register_required`, stored feedback returned |
| Throwaway Development user, `claim_sample_try` (as `authenticated`, via simulated JWT claims, not a real sign-in) | grant `active`, 72h expiry and 144h grace timestamps, MCQ 1/8 used, FRQ 0/1, `learning_session_id` set |
| claim replay | same grant id (idempotent) |
| `get_sample_access_state` | matches the claim result |
| `get_question_experience(session, 1)` | readable; `resume.action = review_feedback` |

## Bug found and fixed by this smoke

The live `sample-try` responses nest everything under `result.try` (`{outcome, try_token, try:{status, unit_number, feedback, question}}`), not the flat shape in spec §10 (`result.question`, `result.feedback`). The app's first wiring would have rendered nothing. Fixed in app PR #48 (draft; the earlier merged #47 still carries the flat-shape code, dark behind the flag) with parsers and tests that use the real shapes. The spec was corrected to match the function in Cramapple PR #600 (§10.1).

## Not run

- A real browser walk through the UI against Development (no inbox to receive a sign-in code; the claim was simulated with JWT claims in SQL).
- Questions 2 to 8 through `student-session-items`, the FRQ, grading, photo flow, grace, expiry, trial supersession, the second-account and email refusals, rate limiting (the backend's own QA covers several of these at the SQL and function level).
- Anything in Production.

## Cleanup (verified)

All rows removed: `sample_tries`, `sample_grants`, `sample_consumptions`, `sample_consumed_emails`, imported sessions, attempts, response versions, grading results, audit events and the throwaway `auth.users` row; counts are 0 and `sample_access_enabled` is false. Note for the backend session: `sample_tries` and `sample_grants` reference each other, so cleanup needs `update app.sample_tries set grant_id = null` first, and deleting the user needs `audit_events`, `response_versions.created_by`, attempts and sessions deleted beforehand (the "cascade" does not cover these).

## Update after the backend session's end-to-end (2026-11-09)

The sample FRQ cannot be attempted inside the imported first-MCQ session (`practice_format` is `mcq`, so `409 practice_format_mismatch`). It must start a new session via `session-event` `session_start` with `entry_path:'topic'`, `session_mode:'quick'`, `practice_format:'targeted_drill'`, admitted while the grant is active, and create the FRQ attempt there. The app's "Start my free-response question" button previously linked into the MCQ session (a guess); it is now **disabled with "Coming soon"** until the real flow is built and QA'd. Development now also has `GRADING_ENTITLEMENTS_ENABLED=true`, so grading caps (3 requests, no revision) apply there as in Production.

## Round 3: signed-in Development API run and Production read-only serving check (author-run, not independent QA)

Development only for writes (throwaway password user, all rows deleted afterwards; switches off; edge secret unset; verified `sample_disabled`). Production: read-only SQL only.

**Verified in Development with a real signed-in session (password grant on the throwaway user, calls made with curl, not through the app UI):**
- `claim_sample_try` through PostgREST with a real JWT: grant active, MCQ 1/8 used, FRQ 0/1.
- `session-event session_start` exactly as the app's normal practice entry sends it for an FRQ (`entry_path:'self_guided_format'`, `practice_format:'targeted_drill'`, quick, 10 minutes): accepted for a sample student.
- Format-less MCQ serving via `student-session-items` (no `mode`): served exactly the 7 remaining questions; `sample` block matches the grant; seven further `create_attempt` calls succeeded.
- The ninth MCQ: `403 {error:'sample:mcq_allowance_exhausted', access:'sample', state:{...}}`. After that the queue returns zero items with `reason:'sample_allowance'`. The app's refusal helper matches both strings.

**Findings for the backend session (verified unless marked):**
1. **Unit-gated serving does not fit sample grants.** The app's normal practice entry calls `student-session-items` with `mode:'unit_gated'`. That branch uses the student's `student_course_positions.unit_id`, defaulting to **1**, and the claim does not set a position. (a) **Physics 2 (units 9-11) and Physics C E&M (units 8-10):** calling `public.select_student_practice_items` with current unit 1 raises `unit_serving:unit_not_in_subject` (verified on Production, called directly, not through the edge function). (b) For a grant in unit 2 or later, the selector at position 1 excludes items whose `max_required_unit` is above 1, so the sample scope filter has nothing to keep **(inferred; Development has no serving labels, so this cannot be reproduced there)**. A claim-time course position equal to the grant unit would fix both; that is the backend's call.
2. **The imported first-MCQ session has `practice_format='mcq'`, and the unit-gated selector returns zero rows for that format** (Production, Statistics: 0 rows with `_practice_format='mcq'`, 50 with null). The app therefore starts a new, format-less session for later MCQs instead of continuing the imported one.
3. **Unit-gated serving counts are lower than the sample availability counts.** With the course position set to the grant unit (Production, read-only), serveable MCQs per eligible unit are enough everywhere except **Calculus AB Unit 1: 4 serveable vs 10 counted as available** (the sample needs 7 after the first). The other 30 eligible units serve 13 or more. Availability should count what serving can deliver.
4. **Development cannot exercise the app's unit-gated path**: the selector returns 0 for every format there (no serving labels), so a real browser walk against Development will show an empty queue for MCQs and FRQs even though the sample logic is correct.

The app now sends **both** later MCQs and the FRQ through the normal practice entry (new session each), and leaves the question page for `/sample` on any typed `sample:*` refusal, `grading_access:sample_*` refusal, or `sample_allowance` empty queue. **Not verified through the app UI**: these flows have not been rendered in a browser against any environment.
