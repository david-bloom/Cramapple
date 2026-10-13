# Question report email — implementation and QA

**Date:** 2026-10-12 (America/New_York)
**Scope:** Owner-requested question-pane report link; separate from the paused More help demo.
**State:** Released to Production; live blank-comment report and owner-inbox delivery verified. Previously declined Development test-account cleanup remains separate.

## Result

The question-pane copy is replaced with “See something wrong or confusing?” on practice, scored/review and unscored learning question states. It opens an accessible modal with optional comment and Send report. Empty comments are accepted. Closing preserves the answer; no navigation or grading/assistance event is triggered.

The browser sends exact question version, explicit session, mode, request UUID and optional comment. It sends no draft, grades, identity or URL. The server validates authentication, disallows anonymous Auth users, checks allowed origins and length limits, and reserves a private receipt atomically. A served question must belong to the caller's session. Session-free worked examples reuse the teaching pool's published-item, active-pack and subject-entitlement/staff access checks. Subject and question text are derived from the database, not trusted browser text.

Loops template `cmv60vlfy0gwl0j0rtl3wqscb` (“11 Question Issue Report”) is published in the existing account. Subject, questionId, question, mode, comment and reportId are the exact variable contract. The server recipient is the existing owner inbox dbloom01@gmail.com; neither destination nor template is student-selectable. Existing LOOPS_SECRET_KEY is present in Development and Production; no secret was copied or rotated.

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

## Verified email and closeout correction (2026-10-13)

The owner explicitly approved the temporary Development test account and then confirmed: “Test email received. Looks good.” He also said there is no additional review and that this is a simple student issue notification service, nothing more. No new database rights were requested or required; the existing access was sufficient.

An authenticated Development request returned 200 with report receipt bafb00b5-aa2a-490d-802e-02568b86f10b. Retrying the identical request returned 200 with the same receipt and no second send. A foreign-session request returned 403. The database showed one sent receipt and one delivery attempt. Gmail message 1a1330b379c0199c was received in the owner's inbox; its plain-text body contained the authoritative Biology question, practice mode, exact question version, QA comment and receipt reference, with no student identity or answers. This verifies provider delivery, not Production publication.

Cleanup was attempted through the Supabase tool and was declined. A read-only closeout check confirmed the temporary Development account/session remain. The local temporary credential/password files were removed; no credential is committed. Scoped cleanup identifiers: Development project wmgjsdkphcyhngaffbqf; QA auth user add78f2f-d524-4b8b-b5c3-4d48fcc0b539; QA session 985583da-aedc-4ca2-b65d-057040f5f922. Do not treat cleanup as completed or work around the declined deletion through another API.

Backend PR #428 and App PR #17 remain draft; no merges, Production migrations/deployments or Lovable publication occurred. Automatic approval review rejected changing the App PR out of draft because it interpreted “there is no review” as forbidding that review/release-state change. This is a tool-action restriction, not an owner-requested product review or a requirement for broader database permissions. The earlier account-creation restriction was resolved by the owner's explicit approval. The earlier inbox-test dependency above is superseded by this verified result.

The owner then requested preserving More help and ending the session. No notification release or cleanup continuation is authorized by that documentation-only closeout. Next continuation should be limited to the requested notification release/cleanup; More help is separately paused.

## Resumption verification (2026-10-13)

Owner restated the simple optional-note reporting request and accepted either email or admin delivery, whichever is easier. Existing email implementation was retained. Read current backend/App PRs and App/Lovable main; the feature remained unmerged and absent from Lovable main. App PR #17 had one import conflict with main's Formula renderer; resolved by preserving both imports and merging current main into the existing feature branch.

App checkpoint `5e2491b62a5a641a17e33d148b74e720f60c1dec`: `npx vitest run` on question-issue-report, question-experience-render, question-design-rules and formula-rendering passes (4 files / 51 tests); `npx tsc --noEmit`, `npm run build` and `git diff --check` pass. Diff against main contains only the report control, report client, existing interactive tests and question-pane wiring. This is a fresh source/build verification, not a new browser or inbox test. Earlier desktop/phone and inbox evidence remains as documented above.

The temporary checkout initially lacked main's new katex dependency. `npm ci` revealed an already-stale npm lockfile; `npm install --ignore-scripts --package-lock=false --no-audit --no-fund` installed declared dependencies for validation without changing committed package/lockfiles. No new product dependencies were introduced.

Production release approval remains pending. No new email, database/secret change, merge, publication or test-account cleanup occurred in this continuation.

## Approved Production release (2026-10-13, verified)

David explicitly approved: “I Approve releasing this to production”. This approval covers the two existing PRs and their reporting-backend/App release. Production project identity was live-verified as Cramapple - Production, `pcntajvbdfqhbeewmdry`.

Applied the two unchanged migration bodies in Production as ledger versions `20261013131208_question_issue_reports` and `20261013131212_question_issue_reports_worked_examples`. Source files were renamed to those actual recorded Production versions; their original Development versions remain documented above and preserved in earlier Git commits. No duplicate migration bodies were added to the current source tree.

Deployed `report-question` version 1 with the CLI's API bundle from the task worktree and explicit Production project ref. Live function is ACTIVE and retains `verify_jwt=true`. Read-only permission checks confirm RLS enabled, anon read denied, authenticated insert/reservation denied, and service-role reservation permitted. Production OPTIONS from `https://app.cramapple.com` returns 200 and the matching allow-origin header.

App PR #17 merged as `ba3305577bc398a8f4c3c88a6e8a2984b95a7d2d`; Lovable reflects that same source. The pre-publication production HTML already includes its Formula asset, confirming the formula renderer was present in the published baseline. The App PR's diff against that current main contains only four report-feature files. App publication and authenticated report verification are next; no test-account creation/cleanup or More help change is included.

Publication and live verification subsequently completed:

- Merged App main CI: success. Lovable deployment `3a048eb0-4f4e-4ce1-be67-27853c84b4d5` initially returned pending, then its actual `app.cramapple.com/question` UI was verified with the new report link and without the old saved-work text.
- Opened a separate tab in the owner's existing authenticated browser session. One optional textarea and Send report were visible; no required category. Sent one report with the note left empty; the UI showed “Thanks — your report has been sent.” No answer was submitted, graded or changed.
- Production receipt `e1c93811-1d03-4cd0-94cf-e97b6efa8845`: question version `f13536f0-6e46-4c8c-84ab-71b49c9fa12b`, `mode=practice`, `subject=ap-calculus-ab`, note length 0, `notification_state=sent`, `delivery_attempts=1`, notified at `2026-10-13 13:16:34 UTC`.
- Gmail message `1a13568619a38891` arrived at `2026-10-13 09:16:35 America/New_York` in the owner's Inbox. Plain text matches the served secant-slope question, exact version, practice mode, “No comment added.” and receipt reference. Student identity and answers are absent.
- Unauthenticated Production POST returns 401. Security advisors show only the expected [RLS-enabled/no-policy informational notice](https://supabase.com/docs/guides/database/database-linter?lint=0008_rls_enabled_no_policy) for this service-only receipt table; no browser grant/policy was opened.
- [Production success screenshot](evidence/question-report-production-success.png) preserves the visible confirmation and surrounding question page. Original Development desktop/375px, retry/no-duplicate and foreign-session evidence remains applicable; no new account or cleanup was needed.

The reporting release is verified. More help remains paused and the previously declined Development cleanup remains untouched.
