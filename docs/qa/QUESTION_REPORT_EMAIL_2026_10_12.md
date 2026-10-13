# Question report email — implementation and QA

**Date:** 2026-10-12 (America/New_York)
**Scope:** Owner-requested question-pane report link; separate from the paused More help demo.
**State:** Built and tested; Development backend deployed; signed-in inbox check and Production release pending.

## Result

The question-pane copy is replaced with “See something wrong or confusing?” on practice, scored/review and unscored learning question states. It opens an accessible modal with optional comment and Send report. Empty comments are accepted. Closing preserves the answer; no navigation or grading/assistance event is triggered.

The browser sends exact question version, explicit session, mode, request UUID and optional comment. It sends no draft, grades, identity or URL. The server validates authentication, disallows anonymous Auth users, checks allowed origins and length limits, and reserves a private receipt atomically. A served question must belong to the caller's session. Session-free worked examples reuse the teaching pool's published-item, active-pack and subject-entitlement/staff access checks. Subject and question text are derived from the database, not trusted browser text.

Lo​ops template `cmv60vlfy0gwl0j0rtl3wqscb` (“11 Question Issue Report”) is published in the existing account. Subject, questionId, question, mode, comment and reportId are the exact variable contract. The server recipient is the existing owner inbox dbloom01@gmail.com; neither destination nor template is student-selectable. Existing LOOPS_SECRET_KEY is present in Development and Production; no secret was copied or rotated.

Receipts use a per-user transaction lock, 10 new reports/hour, five maximum delivery attempts, 30-second lease, immutable retry payload and the same Loops idempotency key. Retries stop after 23 hours (inside Loops' 24-hour idempotency period). An unconfirmed send never displays success. There is no background retry or schedule.

## Evidence

- App: 109 test files / 1,064 tests pass, including five interactive report-control tests; TypeScript and production build pass.
- Backend: eight handler tests pass; Deno check passes.
- Development database: rolled-back fixture assertions pass for blank comments, ownership, unserved-item denial, concurrent reservation, changed retry payload, retry receipt reuse, already-sent reuse, hourly limit, unentitled teaching denial and entitled session-free teaching reporting. All fixtures roll back.
- Development permissions: anon cannot read; authenticated cannot write receipts or execute reservation RPC; service_role can execute. RLS is enabled; intentionally no browser policies. The advisor's RLS-with-no-policies notice is expected for this service-only table, not grounds for opening client grants.
- Development endpoint rejects unauthenticated POST with 401.
- Browser: desktop modal checked; selecting A, opening and closing retains A. Phone at 375px: document width 375, dialog width 343, no horizontal overflow. Keyboard focus enters the optional comment, and Radix Dialog supplies modal focus/escape behavior.
- Loops UI shows published template and all six dynamic fields; successful real-inbox delivery is not yet claimed.

## Deployment state

Development migrations (recorded under actual ledger versions):
- `20261013015714_question_issue_reports.sql`
- `20261013020239_question_issue_reports_worked_examples.sql`

Development report-question Edge Function deployed with platform JWT verification and server Auth verification. No Production database migration, endpoint deployment or Lovable publish has occurred for this work.

## Remaining boundary

Automatic approval review rejected creating a persistent temporary Development Auth account, password/identity and associated sessions without specific permission. The owner has been asked to authorize a temporary account plus cleanup or use an existing account for the full signed-in send. No such account was created. The unauthenticated check and rollback-only database assertions do not replace inbox certification.

Production publication must also account for other App main changes since its last publish; those are not incidentally authorized by this reporting request. Do not report live completion until the selected release is verified.
