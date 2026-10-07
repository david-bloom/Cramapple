# TASK-0060 — UX Monitoring Phase A: Development Repair and Verification

STATUS: IN PROGRESS

**Task ID:** TASK-0060  
**Title:** Repair Development analytics delivery and establish low-noise product-health signals  
**Owner:** Main Conductor / ChatGPT  
**Tier:** Hard-Gate  
**Status:** In Progress  
**Priority:** High  
**Created Date:** 2026-10-03  
**Approved Date:** 2026-10-03  
**Branch:** `chatgpt/task-0060-phase-a-closeout`  
**PR:** TBD  
**Product Goal:** Make the minimal Cramapple conversion/product-health monitoring path trustworthy before any Production instrumentation change.  
**Technical Scope:** Development-only frontend PostHog call-site repair; Development `first_response_graded` diagnosis/repair; derive study/return from existing Supabase data where possible; Development E2E verification; durable evidence.  
**Out of Scope:** Production deployment/configuration/secrets, PostHog replay/autocapture, Clarity changes, AI research interview implementation, new student-data collection.  
**Routes / Components / Systems Affected:** Lovable marketing frontend; Supabase Development; PostHog; canonical monitoring documentation.  
**Data / Security / Integration Impact:** Analytics only; coarse funnel signals. No answers, grades, names, email, school data, or transcript content may enter PostHog.  
**Approval State:** Explicit owner approval in Cramapple Project chat on 2026-10-03 for Development repair + E2E. Production remains a hard gate.  
**QA Result:** Pending  
**Done Decision:** Pending

## Acceptance Criteria

- `checkout_viewed` cannot race PostHog initialization.
- canonical marketing homepage emits `landing_view` only through the explicit allowlisted wrapper.
- Development frontend analytics runtime/key path is verified without exposing key material.
- `first_response_graded` call site is reconciled against current Development behavior and emits for a genuinely first graded response.
- study-start and later-day-return definitions use existing Supabase data if reliable; no new event is added merely for convenience.
- a Development E2E produces observable evidence through the intended pipeline.
- autocapture, automatic pageviews/pageleave, and PostHog session recording remain disabled.
- no Production changes occur without a new explicit Production/configuration approval.

## Implementation checkpoint — 2026-10-03

### Frontend diagnosis

Lovable marketing project `61dd6602-6991-4561-b418-e988bb7c8a0b` showed two independent issues:

1. The preview/build environment inspected by Lovable had no `VITE_POSTHOG_KEY`, so `initPostHog()` exited without loading the SDK.
2. `checkout_viewed` fired directly in a child effect. React effect ordering allowed it to run before root initialization, silently dropping the event even if a key were later present.

`landing_view` had an active call site on `/trial` but not on the canonical marketing homepage.

### Frontend code repair completed, not published

Lovable commit: `19c2521a91943546ded51fc8bbbaae4dddcff99a`.

Changes:
- `src/routes/checkout.index.tsx`: `checkout_viewed` now awaits `initPostHog()`.
- `src/routes/index.tsx`: canonical homepage now emits `landing_view` after `initPostHog()` with allowlisted `route: "/"`.
- `src/lib/posthog-events.test.ts`: focused allowlist/privacy tests.
- no key/env/host/Clarity/publish/deploy change.

Lovable reported clean typecheck and 34/34 tests passing. Diff was independently inspected through the connector and matches the requested scope.

### `first_response_graded` diagnosis

Current Development `evaluate-attempt` version 35 contains the intended call site. For a student result with status `graded` or `uncertain`, it counts prior graded/uncertain results across the student's attempts and calls `recordGrowthEvent` with dedupe key `first_response_graded:<user_id>` only when none exist.

Development data shows:
- 5 users have at least one `graded` / `uncertain` `grading_results` row.
- 4 of those users have no matching `first_response_graded` outbox row.
- the Development growth outbox has historical rows but none inspected were delivered to PostHog.

This indicates the present blocker is not absence of the current call-site code. It is a combination of historical grades predating the call site and Development analytics delivery configuration. Do not backfill historical users into PostHog as part of the E2E; test with a genuinely first graded response.

### Study and return from Supabase

Existing `app.learning_sessions` is sufficient for v1 product-health measurement without a new PostHog event:

- **study started:** user has a `learning_sessions.started_at` row.
- **returned later:** user has learning sessions on at least two distinct calendar dates.

At the Development audit point there were 6 users with started sessions, 7 sessions total, and 0 users with sessions on 2+ distinct dates. This is valid low-volume data, not a reason to manufacture a return event.

For activation, `grading_results.status in ('graded','uncertain')` joined through `attempts.user_id` is the durable Supabase source; `attempts.graded_at` is not reliable for historical Development rows and should not be used as the sole activation source.

### Remaining blocker to E2E

A Development PostHog project/runtime key must be configured for both:
- the Lovable Development preview/build (`VITE_POSTHOG_KEY`), and
- Supabase Development Edge Functions (`POSTHOG_PROJECT_API_KEY`).

The current connected tools can inspect Lovable code and Supabase functions/data but do not expose a safe Development environment-variable/secret setter. No key values will be copied from Production or surfaced in chat.

After the Development key path is configured, run:
1. homepage preview → verify exactly one `landing_view`;
2. checkout preview → verify exactly one `checkout_viewed`;
3. a new Development student's first grading → verify one `first_response_graded` outbox row and successful delivery;
4. verify no automatic `$pageview`, autocapture, or session-recording data;
5. query Supabase for study-start and later-day-return counts;
6. record evidence here and in the monitoring spec.



## Closeout verification — 2026-10-06

- Frontend environment tagging is active in PostHog for both Development and Production traffic.
- A fresh direct Development checkout smoke test created one unpaid test checkout and wrote a `checkout_started` row tagged `environment=development`.
- The fresh Development row remained undelivered with zero delivery attempts. The shared relay was updated in Development to recognize the PostHog secret naming conventions used across the project.
- Lovable marketing and student previews currently point at Production Supabase. The marketing preview also uses live Stripe configuration. Therefore Lovable preview is not a valid Development E2E surface and was not used for the successful Development checkout smoke test.
- No Development graded/uncertain result exists in the last seven days. The genuinely-first `first_response_graded` E2E therefore has not occurred and was not fabricated.
- Current study/return evidence: 6 users started study, 7 started sessions, 0 users returned on 2+ distinct dates.

### Remaining closeout conditions

1. A fresh Development backend event must demonstrate successful PostHog delivery after the compatibility deployment.
2. A genuinely new Development student's first graded response must produce and deliver exactly one `first_response_graded` tagged `environment=development`.

Production was not changed as part of this closeout attempt.
