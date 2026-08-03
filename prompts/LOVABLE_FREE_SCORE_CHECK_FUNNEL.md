# Lovable Build Prompt — Cramapple Free Score Check Funnel

Build the public-to-product acquisition funnel for Cramapple's activation-limited **Free Score Check**. This is not a timed trial. A student receives one initial AP Biology FRQ grade, one guided repair, and one private before-and-after report.

Use the existing Cramapple design system and routes where possible. Do not create or alter database tables, SQL functions, RLS policies, grading logic, Stripe logic, or Edge Functions in Lovable. The backend contract already exists in Supabase.

## Outcome

The visitor should understand the offer, authenticate by email, complete one real FRQ, see criterion-level feedback, repair the highest-value gap once, receive a private report, and encounter a clear one-time AP Biology purchase CTA.

The funnel is successful at `first_response_graded`, not merely email capture. The stronger activation signal is `repair_completed`.

## Routes

Create or update these routes:

```text
/                                  marketing landing page
/free-score-check                  offer explanation and entry
/free-score-check/verify           email OTP or magic-link waiting/return state
/free-score-check/question         initial FRQ response
/free-score-check/feedback         initial grade and minimum repair
/free-score-check/repair           one guided revision
/free-score-check/report           private before-and-after report and purchase CTA
```

All routes except `/` and the entry section of `/free-score-check` require an authenticated Supabase session. A refresh must restore the correct state by calling the `status` operation; do not rely on local state as the offer authority.

## Landing-page offer

Use this primary message:

```text
See what your AP Bio answer would earn.
```

Supporting copy:

```text
Try one original AP Biology FRQ. Get criterion-level feedback, make the smallest repair that could earn the next point, and see your before-and-after report. Free.
```

Primary CTA:

```text
Check my AP Bio FRQ score free
```

Near the CTA, state the limit plainly:

```text
One FRQ score + one repair. No credit card.
```

Do not call this a seven-day trial, free subscription, diagnostic exam, guaranteed AP score, official College Board score, or unlimited grader.

## Email capture and consent

After the CTA, show a focused authentication card:

```text
Save your score check
Enter your email so your work and private report are here when you return.
```

Use Supabase passwordless authentication with email OTP or magic link, following the authentication pattern already present in the app. Preserve the original destination so the student returns to `/free-score-check` after verification.

Required controls:

- email field;
- primary button `Email my sign-in link` or `Send my code`, matching the existing Auth setup;
- required acknowledgement linking Privacy and Terms;
- separate unchecked optional checkbox: `Send me occasional AP study tips and Cramapple updates.`

Authentication permission and marketing consent are separate. Never pre-check marketing consent. Do not create an email/password form if passwordless Auth already exists.

Before navigating away, persist first-touch and last-touch attribution in local storage using only:

```text
utm_source
utm_medium
utm_campaign
utm_content
utm_term
landing_path
referrer_host
reddit_click_id
```

## Backend calls

Invoke the Supabase Edge Function named `free-score-check` with the current access token.

### Start or resume

```json
{
  "operation": "start",
  "privacy_notice_version": "2026-07-20",
  "marketing_email_opt_in": false,
  "first_touch": {},
  "last_touch": {}
}
```

Use the returned IDs exactly. Do not generate an attempt or choose content in the browser. Handle `not_available` and `not_configured` with a calm waitlist state; never fall back to arbitrary content.

### Restore state

```json
{ "operation": "status" }
```

Route by authoritative state:

| State | Route |
|---|---|
| `available` | offer/auth entry |
| `started` | initial question |
| `initial_submitted` | grading progress; poll existing grading result idempotently |
| `initial_graded` | feedback or repair |
| `repair_submitted` | repair grading progress |
| `completed` | report |

### Initial response

Use the returned `attempt_id`, `initial_response_version_id`, `content_item_version_id`, and `rubric_version_id` with the existing response-save, `submit-response`, and `evaluate-attempt` contracts. Use operation `grade_initial_attempt` and a stable UUID idempotency key persisted for that submission.

When the result is `graded` or `uncertain`, call:

```json
{
  "operation": "record_grading_result",
  "grading_result_id": "<uuid>"
}
```

The response supplies `repair_attempt_id` and `repair_response_version_id`. Do not create them in the browser.

### Repair response

Show exactly one repair prompt based on the initial result's `repair_hint`, `highest_value_gap`, or minimum-fix criterion. The student edits a fresh response for the returned repair attempt. Submit and evaluate it with operation `grade_revision` and a separate stable idempotency key. Then call `record_grading_result` with that revision result ID.

If the backend returns `initial_limit_reached`, `repair_limit_reached`, `entitlement_required`, or `operation_not_in_free_offer`, do not retry with a new attempt or ID. Restore status and show the report/purchase state.

### Report

```json
{ "operation": "report" }
```

Render only the authenticated response. Never cache it publicly or put report details in query parameters.

## Question experience

- Show one original, approved AP Biology FRQ from the existing published content views.
- Keep the answer area calm and focused; no chat UI.
- Autosave the draft through the existing response contract.
- Show progress as `1. Answer`, `2. Repair`, `3. Report`.
- Before submission, explain: `This uses your one free score.`
- Disable duplicate submit while the idempotent request is running.
- If grading is delayed, state that the answer is saved and allow safe refresh/resume.

Do not call an AI provider directly from the browser. Do not display internal prompts, raw model responses, confidence plumbing, or canonical answers before submission.

## Initial feedback

Lead with the points earned out of points available, qualified as Cramapple feedback rather than an official AP score. Then show:

- criteria earned;
- criteria not yet earned;
- evidence from the student's answer;
- the single highest-value gap;
- the minimum repair most likely to earn the next point;
- button: `Make the repair`.

Do not overwhelm the student with a complete lesson or multiple repair choices. The product proof is the smallest useful correction.

## Report

The private report should contain:

1. `Your AP Biology score check`;
2. initial points earned / available;
3. the criterion-level initial feedback;
4. the minimum repair attempted;
5. repaired points earned / available;
6. points gained, when supported by the two results;
7. concise next action;
8. the qualification: `Cramapple practice feedback—not an official AP score.`

Primary report actions:

- `Unlock full AP Biology — $39.99` (one-time purchase; use the existing price source if it is dynamic);
- `Download report`;
- secondary `Return to Cramapple`.

Implement download with report-only print CSS and `window.print()`. Use Letter-friendly margins, preserve criterion status labels in grayscale, hide navigation/buttons during print, and set the document title temporarily so the suggested PDF filename is `cramapple-ap-biology-score-check.pdf`.

Do not add Google Classroom export, a public share URL, social sharing of results, or email content containing the private report.

## PostHog implementation

Install or reuse the PostHog browser SDK only on consented marketing pages. Disable autocapture and session replay for authentication and every `/free-score-check/*` route. Explicitly capture:

```text
landing_view     once per landing load after consent
demo_started     first demo interaction only
signup_started   email form submission, before OTP outcome
```

After successful authentication, call `posthog.identify(user.id)`—never email. The backend already emits `trial_started`, `first_response_graded`, and `repair_completed`; do not duplicate those from the browser.

Allowed browser properties are coarse acquisition fields, subject key, offer name, route, and creative ID. Never send answer text, exact score, criteria, weakness labels, school, upload metadata, name, or email to PostHog. Add a development assertion or wrapper that rejects forbidden property names.

## Visual direction

Follow Cramapple's existing warm, serious academic visual language: warm off-white background, deep green accents, restrained cards, strong readable typography, and generous spacing. The experience should feel credible and efficient, not gamified.

- Mobile-first at 390px.
- Clear keyboard focus and semantic headings.
- Status cannot depend on color alone.
- Respect reduced motion.
- No confetti, streaks, fake countdown, cartoon mascot, chat bubbles, or guaranteed-score language.
- Keep the main action visible without sticky overlays covering the answer.

## Error and resume behavior

- Auth expired: retain non-sensitive route intent and return to passwordless sign-in.
- Network failure: preserve draft and stable idempotency key; offer retry.
- `report_not_ready`: route to the authoritative in-progress state.
- `not_available` / `not_configured`: show a waitlist-style message and log an operational error, not a broken question.
- `uncertain` grading result: show the qualified feedback supplied by the backend; never invent certainty.
- Another tab advances state: `status` wins and the stale tab routes forward.

## Acceptance tests

1. A new student can authenticate and receive exactly one server-created initial attempt.
2. Refreshing at every route resumes the authoritative state.
3. Reusing the same idempotency key returns the same grade; a new key cannot obtain a second free initial grade.
4. A repair cannot be graded before the initial grade is recorded.
5. A new key cannot obtain a second free repair grade.
6. Another authenticated user cannot read the student's score-check state or report.
7. Marketing consent remains optional and unchecked.
8. The report prints cleanly to PDF without navigation or controls.
9. PostHog contains no answer, grade, criterion, email, name, school, or upload data.
10. `trial_started`, `first_response_graded`, and `repair_completed` appear once each from the backend.
11. The production offer fails closed until a published FRQ and rubric are configured.
12. Existing beta students retain normal practice access through their beta entitlement.

## Out of scope

- Google Classroom export;
- public report sharing;
- parent portal;
- multiple free questions or retries;
- timed trial logic;
- TikTok or Reddit pixel installation beyond the approved PostHog event layer;
- Stripe product or webhook changes;
- backend/schema edits from Lovable.
