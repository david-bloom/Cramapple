# Question-pane issue reports with email

**Status:** Approved — released to Production; live report and inbox delivery verified
**Owner:** David Bloom / Codex conductor
**Tier:** Standard implementation; Hard-Gate release
**Date:** 2026-10-12
**Branch:** codex/question-report-email (Cramapple backend and ap-prep-blueprint App)
**PR:** https://github.com/david-bloom/Cramapple/pull/428 (backend), https://github.com/david-bloom/ap-prep-blueprint/pull/17 (App)
**Production approval:** David Bloom, 2026-10-13: “I Approve releasing this to production”. This follows the explicit request to approve merging/releasing these two PRs, the reporting backend and App publication.

## Authorization

David requested replacing “Submitted answers are saved. What you are typing now is not” with “See something wrong or confusing?” and receiving an email identifying the current subject/question. Optional comments are authorized; comments must never be required. This is separate from the paused More help demo.

## Scope and acceptance

- Replace the current question-pane status text with the exact requested clickable copy.
- Offer reporting on MCQ/FRQ question states, preserving the answer and page.
- Let students send with no category selection or comment; optional bounded comment.
- Email the existing owner inbox (dbloom01@gmail.com) through the existing Loops service with authoritative subject, exact content-version ID, question text, mode and optional comment.
- Verify authentication and ownership of the served question; keep email credentials and recipient selection server-side.
- Prevent double sends, constrain report frequency, and show honest retry/error states.
- Do not email typed answers, grades, student identity, tokens or arbitrary page query strings.
- Validate desktop/mobile placement and a controlled inbox delivery before claiming live completion.

## Baseline evidence

App main/Lovable checkpoint 89888d6; text in src/screens/question-experience/QuestionExperience.jsx. Older ReportQuestionButton inserts into public.question_reports without email; this table exists in Production but not Development. Existing Loops transactional service is the relevant canonical email path. docs/INDEX.md has no current question-report notification entry; TASK-0061 and the transactional-email migration document are the nearest references. Primary Cramapple checkout has unrelated dirty work; isolated task branches are used.

## Release boundary

Implementation is authorized by the owner's explicit request. No claim of successful publication, delivery or Done until actual end-to-end evidence. Production publication must account for pending unrelated App changes; do not publish those as an incidental part of this task.

## Implementation checkpoint

See `docs/qa/QUESTION_REPORT_EMAIL_2026_10_12.md` for exact tests and deployment evidence. App tests/build/typecheck and backend handler/database checks passed. Development and Production signed-in inbox delivery are verified. The Production release is complete, as recorded below.

## Owner confirmation and session end (2026-10-13)

The owner approved the test account, confirmed receipt of the correct notification email, and specified no additional review and simple notification-only scope. See the QA record’s closeout correction: one delivery, no duplicate retry, foreign-session rejection, cleanup declined/account remains, local credentials removed. Both PRs remain draft and Production is unchanged. No new database rights were requested. The More help documentation-only closeout does not resume this separate release.

## Resumed session (2026-10-13)

David requested starting a session for this exact feature, emphasizing a simple notification with an optional note. Asked whether email or the admin portal was preferred, he answered: “email or the admin portal- whichever is easier.” Continue the already-built email path; no category selection or new admin workflow is needed.

The existing App PR conflicted with main's new Formula import. The conflict was resolved by retaining both imports and merging App main `2bb35c6825b84691f8e6d701601a6d1f0cfff9be` into the existing feature branch. App checkpoint: `5e2491b62a5a641a17e33d148b74e720f60c1dec`. The diff against current main remains the four report-feature files only. Focused report/question rendering/design/formula tests: 4 files, 51 tests pass; TypeScript and build pass. No lockfile changes were made. Initial dependency checks encountered the existing stale npm lockfile; installing declared dependencies without changing lockfiles enabled validation.

The session-start request alone did not authorize Production. David subsequently explicitly approved release on October 13, as recorded in the header. Next action: apply the two reporting migrations and deploy report-question before merging/publishing the App; verify the publication delta and live report flow. Keep the separate More help demo paused and leave the previously declined test-account cleanup untouched.

## Production outcome (2026-10-13)

Production migrations are recorded under `20261013131208` and `20261013131212`, with identical bodies to the Development migrations. `report-question` v1 is active with JWT verification. App PR #17 merged as `ba3305577bc398a8f4c3c88a6e8a2984b95a7d2d`, its main CI passed, and Lovable publication `3a048eb0-4f4e-4ce1-be67-27853c84b4d5` is live on `app.cramapple.com`.

Verified the actual signed-in Production question page: the old notice is gone, the report link opens one optional-comment form, and a blank-comment send succeeds. Receipt `e1c93811-1d03-4cd0-94cf-e97b6efa8845` is sent with exactly one delivery attempt; Gmail message `1a13568619a38891` arrived in the owner's inbox with the authoritative Calculus question and “No comment added.” No student answer/identity appears in the email. Screenshot and complete evidence are in the QA record.

Release scope is complete. Next owner: David, to receive ordinary student reports and decide any content fixes. The declined Development test-account cleanup remains separately open; More help remains paused. No further deployment approval is needed for the release just completed.

## Source-page URL follow-up

David subsequently requested including the URL from which the form was submitted. This amends the original URL exclusion only for sanitized question-route context. See [WORK-QUESTION-REPORT-SOURCE-URL](WORK-QUESTION-REPORT-SOURCE-URL.md) for the bounded follow-up, active branch and verification.
