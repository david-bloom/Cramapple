# Include the submitted page URL in question-report emails

**Status:** Approved — implementation verified; release in progress
**Owner:** David Bloom / Codex conductor
**Tier:** Standard implementation; Hard-Gate Production release within the approved reporting service
**Date:** 2026-10-13
**Branch:** codex/question-report-source-url (Cramapple backend and ap-prep-blueprint App)
**PR:** Pending creation
**Related:** WORK-QUESTION-REPORT-EMAIL; original released backend PR #428 and App PR #17

## Owner request and authorization

David requested: “on the email I need the URL from which the form was submitted so I can find the right question”. This explicitly adds source-page URL to the approved live reporting email. Continue the existing reporting release authorization and deliver this bounded correction; no new student form, account, access policy, email provider, or database migration is needed.

The original reporting task's prohibition on emailing URLs is amended only for the question-page URL and its documented route parameters. Student answers, grades, identity, authentication parameters and URL fragments remain excluded.

## Behavior

The browser captures the submitted page URL on the first Send click and keeps it in the immutable retry payload. Keep only question-route parameters: mode, type, session, ordinal, topic, unit, subject, from and worked. Strip fragments and unrelated query parameters before transmission. Backend independently requires HTTPS, one of the established App/Preview hosts, the /question path, no credentials or port, and at most 2,048 input characters.

The email includes “Submitted from: <URL>” beneath the optional comment, using the existing template's comment display field. The note stored in the private receipt stays unchanged; URL is email context rather than a new database field. Older published clients that omit the URL remain compatible. Existing authenticated question ownership, delivery receipts, rate limits and provider idempotency remain intact.

This is the actual source-page URL, not a new cross-student question permalink. Current /question serving depends on the signed-in account; exact question text/version ID remain in the email for identification if opening the source route serves a different question.

## Verification

- Backend: 11 handler tests pass, including source transmission, unchanged note, preserved question parameters, secret-fragment/query removal and invalid-host/path rejection. Deno check passes.
- App: 7 focused tests pass, including source capture, immutable retry after the browser URL changes, unchanged optional-note behavior and URL sanitation. TypeScript, build and diff checks pass.
- No database or Loops-template changes are required. Production deployment and final Inbox verification are in progress.

## Release boundaries

Deploy the backward-compatible endpoint before publishing the App. Inspect App main's publication delta so unrelated changes are not included incidentally. Existing More help pause and previously declined Development test-account cleanup remain untouched.

Next action: merge the reviewed slice after GitHub checks, deploy report-question, publish the App, and verify a production report email contains the submitted page URL.
