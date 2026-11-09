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

The live `sample-try` responses nest everything under `result.try` (`{outcome, try_token, try:{status, unit_number, feedback, question}}`), not the flat shape in spec §10 (`result.question`, `result.feedback`). The app's first wiring would have rendered nothing. Fixed in app PR #47 with parsers and tests that use the real shapes. **The spec should be corrected to match the function** (backend session's file; not edited here).

## Not run

- A real browser walk through the UI against Development (no inbox to receive a sign-in code; the claim was simulated with JWT claims in SQL).
- Questions 2 to 8 through `student-session-items`, the FRQ, grading, photo flow, grace, expiry, trial supersession, the second-account and email refusals, rate limiting (the backend's own QA covers several of these at the SQL and function level).
- Anything in Production.

## Cleanup (verified)

All rows removed: `sample_tries`, `sample_grants`, `sample_consumptions`, `sample_consumed_emails`, imported sessions, attempts, response versions, grading results, audit events and the throwaway `auth.users` row; counts are 0 and `sample_access_enabled` is false. Note for the backend session: `sample_tries` and `sample_grants` reference each other, so cleanup needs `update app.sample_tries set grant_id = null` first, and deleting the user needs `audit_events`, `response_versions.created_by`, attempts and sessions deleted beforehand (the "cascade" does not cover these).
