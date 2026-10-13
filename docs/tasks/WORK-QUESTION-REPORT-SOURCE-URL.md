# Include the submitted page URL in question-report emails

**Status:** Approved — released to Production; source URL verified in the delivered email
**Owner:** David Bloom / Codex conductor
**Tier:** Standard implementation; Hard-Gate Production release within the approved reporting service
**Date:** 2026-10-13
**Branch:** codex/question-report-source-url (Cramapple backend and ap-prep-blueprint App)
**PR:** https://github.com/david-bloom/Cramapple/pull/431 (backend), https://github.com/david-bloom/ap-prep-blueprint/pull/18 (App)
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
- No database or Loops-template changes were required. Production deployment and final Inbox verification succeeded, as recorded below.

## Release boundaries

Deploy the backward-compatible endpoint before publishing the App. Inspect App main's publication delta so unrelated changes are not included incidentally. Existing More help pause and previously declined Development test-account cleanup remain untouched.

Next action: merge the reviewed slice after GitHub checks, deploy report-question, publish the App, and verify a production report email contains the submitted page URL.

## Production outcome (2026-10-13)

`report-question` version 2 is ACTIVE with JWT verification. App PR #18 merged as `731f848f2c1a87bac1f2b1e4643673cff60aba7d`; PR and merged-main CI passed. The tested head and merged commit have the identical Git tree `77f021a936dd8e9d4ce87ddc6f0c2720e2c79bf7`. Lovable published deployment `b683d735-632d-44c2-8605-4356126f155a`; the actual Production question asset `/assets/question-DAnHaTVe.js` includes sourceUrl/window.location.href capture. The pre-existing report-link alignment was already present in the published baseline; it was not introduced by this slice.

Sent one report from the owner's existing authenticated browser session, on:

`https://app.cramapple.com/question?mode=learn&type=mcq&topic=%222.1%22&from=home`

Optional note: “Production test: include the submitted page URL.” Production receipt `ac3b1c02-2e71-4242-8bcd-c99e700f284e` is sent with one delivery attempt, exact question version `3db368b9-0dea-488c-a96b-aee8e3238160`, and worked-example mode. The email arrived at 10:04 AM America/New_York. Its visible Gmail content preserves the note, authoritative Calculus question and version, and “Submitted from” as a clickable link whose href exactly matches the submitted page above. No student answer or identity is included.

The Gmail connector was temporarily rate-limited, so Inbox verification used the existing authenticated Gmail browser UI and a search for the exact report reference. [Email evidence](../qa/evidence/question-report-email-source-url.png) shows the delivered URL and question. No new account, template, database or credential change was needed.

This follow-up is released and verified. Next owner: David, to use submission links in incoming reports. More help remains paused and the previously declined Development cleanup remains untouched.
