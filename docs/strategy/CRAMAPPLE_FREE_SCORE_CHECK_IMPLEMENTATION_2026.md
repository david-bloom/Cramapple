# Cramapple Free Score Check: Product, Funnel, and Measurement Contract

**Decision record | July 20, 2026**

> **Superseded 2026-08-15 by TASK-0026 (7-Day Full-Access Trial).** This
> doc's core design principle -- "the offer does not expire after a number of
> days" -- was reversed for the current early-school-year window, in favor of
> a time-boxed, full-catalog, no-usage-cap trial. Retained for history; the
> event taxonomy and privacy rules below are still the ones in force.

## Executive recommendation

Launch a passwordless, activation-limited **Free Score Check** for AP Biology. A student receives:

1. one original AP Biology-style FRQ;
2. one criterion-level initial grade;
3. one guided minimum repair;
4. one private before-and-after score report.

The offer does not expire after a number of days. Its limit is the value consumed. This makes the promise easy to understand, lets a busy student return later, and prevents a nominal “trial” from ending before the product demonstrates its differentiated value.

The primary activation event is `first_response_graded`; the stronger product-value event is `repair_completed`. “Email captured” is necessary for identity and recovery, but it is not activation.

## Why each component exists

| Component | Why it is needed | Build/buy decision |
|---|---|---|
| Supabase passwordless Auth | Associates the limited offer and private report with the correct student without another password | **Build with existing Supabase** |
| Server-side entitlement | Prevents a browser from granting extra grades or creating unlimited free attempts | **Build in Supabase** |
| Existing grading pipeline | Delivers the product proof rather than a marketing-only sample | **Reuse** `submit-response` and `evaluate-attempt` |
| Private report route | Gives the student a durable artifact and a natural upgrade moment | **Build in Lovable** |
| Print-to-PDF | Meets the useful “download” case with almost no vendor or backend overhead | **Build client-side** using print CSS and `window.print()` |
| Google Classroom export | Only useful inside an existing course assignment and adds OAuth scopes, course selection, permissions, and verification | **Defer** |
| PostHog | Shows which sources and creative produce activated students, not just clicks | **Buy/use free tier**; coarse events only |
| Growth event outbox | Preserves server events if PostHog is temporarily unavailable and makes event origin auditable | **Build in Supabase** |

## Email and report decision

Ask for email immediately after the visitor selects **Check my AP Bio FRQ score free** and before displaying the scored question. Use a Supabase magic link or email OTP. The copy should explain the exchange:

> Enter your email to save your score check and come back to your private report.

Authentication email is required to use the offer. Marketing email consent is a separate, unchecked checkbox. Do not bundle the two permissions.

The report lives at `/free-score-check/report` behind authentication. It contains the initial score, criterion-level results, minimum fix, repaired response result, points gained, and next recommended action. Email messages should link back to this route without putting answer text, grade details, or weakness labels in the email.

For MVP, **Download report** opens the browser print dialog with report-only print CSS and a suggested filename of `cramapple-ap-biology-score-check.pdf`. A server-rendered PDF service is unnecessary at this scale. Do not offer a public report link.

Google Classroom is not an MVP export target. Classroom submissions belong to existing `CourseWork`; student attachments require assignment context and OAuth permission, and modification is constrained by the project that created the coursework. A score check is a private study artifact, not an assignment submission. Reconsider only if teachers become an acquisition channel.

## Backend contract built in this repository

Migration `20260720122542_free_score_check_growth_funnel.sql` adds:

- `app.subject_entitlements`: paid and beta access by student and subject;
- `app.acquisition_profiles`: consent plus first- and last-touch attribution, without duplicating email from Auth;
- `app.free_score_checks`: the authoritative one-per-student/subject offer state;
- `app.growth_event_outbox`: allowlisted, retryable coarse funnel events;
- `app.start_free_score_check(...)`: a service-only atomic start/resume RPC;
- `app.authorize_grading_access(...)`: the server-side one-initial/one-repair gate;
- `app.record_free_score_grade(...)`: reconciles a completed grade and prepares the repair attempt atomically.

The migration preserves existing student accounts as the named beta cohort, then closes direct browser creation of new attempts for unentitled users. Free attempts are created only through the server function. This prevents the UI from becoming the entitlement authority.

The `free-score-check` Edge Function supports:

| Operation | Purpose |
|---|---|
| `start` | Creates or resumes the offer and stores consent/attribution |
| `status` | Restores the correct route/state after sign-in or refresh |
| `record_grading_result` | Verifies an existing grade, advances the offer, and creates the repair attempt |
| `report` | Returns the signed-in student's private report contract |

The existing `evaluate-attempt` function now calls the entitlement RPC before grading. The service role remains server-only. RLS allows students to read only their own offer and entitlement rows.

Before deployment, an administrator must update the private config row `growth.free_score_check.v1` with an approved, published, Cramapple-owned FRQ `content_item_version_id`, its `rubric_version_id`, and `enabled: true`. The default is deliberately disabled so production fails closed.

## Event taxonomy: where it is built and how it fires

There are two event origins. This is intentional: the browser knows page interactions; the backend knows whether value or money actually occurred.

| Event | Trigger location | Exact trigger | Destination |
|---|---|---|---|
| `landing_view` | Marketing frontend | Once per landing-page load after analytics consent | PostHog browser SDK |
| `demo_started` | Marketing frontend | First play/interaction with the FRQ demo | PostHog browser SDK |
| `signup_started` | Marketing frontend | Email form is submitted, before OTP outcome | PostHog browser SDK |
| `trial_started` | `free-score-check` Edge Function | `start_free_score_check` returns a durable offer ID | Supabase outbox, then PostHog |
| `first_response_graded` | `free-score-check` Edge Function | A ready initial grading result is verified and recorded | Supabase outbox, then PostHog |
| `repair_completed` | `free-score-check` Edge Function | A ready revision result is verified and offer state becomes `completed` | Supabase outbox, then PostHog |
| `returned_day_2`, `returned_day_7` | Scheduled server job, later phase | Authenticated return falls in defined elapsed-time windows | Supabase outbox, then PostHog |
| `checkout_started` | Checkout-creation server function | Stripe Checkout Session is created | Supabase outbox, then PostHog |
| `purchase_completed` | Stripe webhook only | Verified successful Stripe payment grants subject entitlement | Supabase outbox, then PostHog |
| `referral_shared` | Authenticated frontend through referral endpoint | Server creates/validates a referral share | Supabase outbox, then PostHog |
| `referred_trial_started` | Free-score backend | Referred user receives a durable offer ID | Supabase outbox, then PostHog |
| `referred_purchase` | Stripe webhook | Referred purchaser completes verified payment | Supabase outbox, then PostHog |

Identity rule: marketing-page events begin with PostHog's anonymous ID. After successful Supabase authentication, call `posthog.identify(user.id)` and preserve UTMs in the `start` request. Never identify with email.

Privacy rule: PostHog may receive subject, offer, source, campaign, landing path, and commercial value bucket. It must not receive answer text, criterion evidence, exact grade, weakness/error labels, school, uploaded work, name, or email. Session replay remains off on auth, student, grading, report, and checkout routes.

## TikTok creative: one format

Use one 9:16 video, about 12–18 seconds:

1. Show an original AP Biology FRQ.
2. Show a plausible student answer.
3. Highlight the phrase that fails to earn the point.
4. Replace it with the minimum repair.
5. Show the point change and end card: **Check one AP Bio FRQ free.**

Voiceover:

> This answer sounds right, but it misses the mechanism. Add this one sentence, and now it earns the point. Check one AP Bio FRQ free with Cramapple.

Do not add a talking head, trend montage, feature list, or multiple questions. The proof is the repair.

## Can TikTok target `#apbio` for teens?

No—not as under-18 interest/behavior targeting. TikTok's June 2026 policy removes audiences and interests/behaviors when an ad group includes US users under 18. TikTok does permit US search keywords for under-18 audiences, so test search terms such as `AP Biology`, `AP Bio FRQ`, and `AP Bio exam` if the selected campaign placement supports Search Ads. Use `#apbio` in the organic caption and creative metadata for context/discovery, not as the paid teen-audience definition.

At the approved $250 starting budget, Reddit remains the first paid acquisition test. The TikTok video is the organic creative test and can become paid later after the activated-score-check CAC is known.

## Launch gates

Do not buy traffic until all of the following pass:

- one approved published FRQ is configured and the offer flag is enabled;
- magic-link/OTP return works on mobile;
- a student cannot obtain a second initial grade or second repair with a new request ID;
- beta/paid entitlements still allow normal practice;
- report data is inaccessible when signed out or signed in as another user;
- print-to-PDF is readable at US Letter and mobile widths;
- PostHog shows the browser-to-server funnel without private learning fields;
- Reddit click-through retains first-touch UTMs through authentication;
- the Stripe webhook, when introduced, is the only authority for `purchase_completed`.

## Sources used for current platform decisions

- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Supabase Edge Function secrets](https://supabase.com/docs/guides/functions/secrets)
- [TikTok advertising restrictions for people under 18](https://ads.tiktok.com/help/article/about-advertising-to-people-under-the-age-of-18?lang=en)
- [Google Classroom coursework and student submissions](https://developers.google.com/workspace/classroom/guides/manage-coursework)

