# Reddit Conversions API for Day-7 Trial Charges — Plan

**Status:** Decided (`DECISION-0129`: D1 trial conversions only, D2 click id only). Backend slices 1–3 built on branch
`claude/reddit-capi-day7`; not deployed anywhere. **Date:** 2026-10-25. **Tier:** Hard-Gate (payments data, a new outside
recipient, Production deploy). **Related:** `TASK-0077` (card trial), the Reddit Pixel work
(`docs/handoffs/LOVABLE_PROMPT_REDDIT_PIXEL_AND_OPT_OUT_2026_10_25.md`).

## Why

Since the card trial went live, most customers pay on day 7, when the charge worker confirms the order's PaymentIntent
off-session. No browser is involved, so the Reddit Pixel never sees that sale: Reddit learns "started a free trial"
(`SignUp`) but never "paid". Without it, Reddit cannot tell which ads produce paying customers and cannot optimise for them.

## What exists today (checked in `main`, 2026-10-25)

- **The conversion moment is one place:** `app.trial_convert` (SQL), called by `stripe-webhook` on
  `payment_intent.succeeded` for a `trial_conversion` intent. It already records the `trial_converted` growth event.
- **Attribution does not reach card-trial orders.** The marketing site keeps first/last-touch data that can include
  `reddit_click_id` (PostHog allow-list), and the old cardless `start-trial` sent it to the backend
  (`_shared/trial-contract.ts` `sanitizeTouch`). The card-trial `trial_start` calls (`create-checkout-session`,
  `create-parent-payment-link`) send nothing like it, and `app.trial_orders` has no attribution column. **So today a day-7
  conversion has no Reddit click id to report.**
- The pixel sets Reddit's own first-party id cookie (`_rdt_uuid`) on visitors who are not opted out; it can be sent with a
  conversion to improve matching without any personal data.
- The browser opt-out (`cramapple_privacy_optout`) and Global Privacy Control live only in the browser.

## Decided and found (2026-10-25)

- **D1:** trial conversions only. **D2:** click id only, so the `_rdt_uuid` and `ad_attribution` jsonb ideas below are
  dropped: the order stores one column, `trial_orders.reddit_click_id`, and the event sends only the click id, amount,
  currency and the order id as `conversion_id`.
- **Reddit's v3 contract (slice 0, from Reddit's v3 docs mirror and integration guides):**
  `POST https://ads-api.reddit.com/api/v3/pixels/{pixel_id}/conversion_events`, `Authorization: Bearer <conversion access
  token>`, body `{"data": {"events": [{"event_at": <ms>, "action_source": "WEBSITE", "type": {"tracking_type": "PURCHASE"},
  "click_id": "...", "metadata": {"conversion_id": "...", "currency": "USD", "value": 39.99}}]}}`. `event_at` is milliseconds.
  Events must arrive within **7 days** (2 for deduplication). v2's `test_mode` is gone; v3 uses a `test_id` from Events
  Manager → Event Testing. **Not confirmed:** where `test_id` sits; the code puts it in `data` and slice 5 checks it against
  Reddit's Event Testing view. The click id arrives on ad clicks as the `rdt_cid` URL parameter.
- **Built (slices 1–3):** migration `20261025170000_reddit_conversions_day7.sql` (column, outbox, claim function, the same
  `trial_convert` body plus the enqueue; Production and Development `trial_convert` md5 checked equal to the repo first);
  `trial_start` reads `ad_attribution.reddit_click_id` only when `ad_attribution.ad_tracking_allowed === true`
  (`readRedditClickId`); `_shared/reddit-conversions.ts` delivers from the charge worker behind `REDDIT_CONVERSIONS_ENABLED`
  with `REDDIT_CONVERSIONS_ACCESS_TOKEN`, `REDDIT_PIXEL_ID` (default `a2_jws6uftcrlca`) and, off Production,
  `REDDIT_CONVERSIONS_TEST_ID` (required there, so Development traffic never reaches real reporting). Tests: CI step 1 781
  passed, step 2 75 passed; SQL scenarios 97 checks + legacy backfill (§12 covers this).
- **Needed from David before slice 5:** a conversion access token (Events Manager → Conversions API) and a test id (Events
  Manager → Event Testing).

## Design (draft as first written; see the section above where it differs)

### 1. Capture at checkout (marketing, Lovable)

When the student (or the student opening the parent drawer) starts a trial, `trial_start` also sends:

```json
"ad_attribution": {
  "reddit_click_id": "<from the stored touch, if any>",
  "reddit_uuid": "<value of the _rdt_uuid cookie, if any>",
  "ad_tracking_allowed": true
}
```

`ad_tracking_allowed` is `false` whenever `isAdTrackingOptedOut()` is true (stored opt-out or GPC). **When it is false, the page
sends no Reddit ids at all.** Nothing else (no email, no name) is added.

For a parent-link trial the ids come from the student's browser at link creation; the parent's later visit to Stripe adds
nothing.

### 2. Store on the order (backend)

- Migration: `app.trial_orders` gains `ad_attribution jsonb` (nullable). `trial_start` writes it through a strict allow-list
  (`reddit_click_id`, `reddit_uuid`, `ad_tracking_allowed`; strings trimmed and length-capped), only when
  `ad_tracking_allowed === true`; otherwise it stores `{"ad_tracking_allowed": false}`.
- It rides with the order already used for the trial; no new personal data is collected.

### 3. Queue at conversion (same transaction)

- New table `app.ad_conversion_outbox` (service-role only, RLS forced): `id`, `order_id` (unique), `platform` = `'reddit'`,
  `event_type` = `'Purchase'`, `value_cents`, `currency`, `event_at`, `payload` (the allow-listed ids), `attempts`,
  `next_attempt_at`, `delivered_at`, `last_error`, `needs_review`.
- `app.trial_convert` inserts one row **in the same transaction as the conversion**, and only when the order's
  `ad_attribution.ad_tracking_allowed = true` and it has a click id or uuid. The conversion itself never waits on Reddit and
  never fails because of it.
- `conversion_id` = the trial order id, so a retry or a replay is deduplicated by Reddit as well as by the unique `order_id`.

### 4. Deliver (worker)

- Delivered by the existing charge worker run (`charge-due-trials`, every 5 minutes, already scheduled through Vault) in its own
  try/catch after charging, behind `REDDIT_CONVERSIONS_ENABLED`. No new cron job or Vault entry.
- One HTTPS call per row to Reddit's Conversions API with a **conversion access token** from Reddit Events Manager, stored as
  the secret `REDDIT_CONVERSIONS_ACCESS_TOKEN` (never in git). Body, per event: `event_at`, `event_type.tracking_type =
  "Purchase"`, `click_id`, `user.uuid`, `event_metadata.{conversion_id, value_decimal, currency}`. **No email, phone, IP
  address or user agent** (David's choice to confirm; see D2). Development always sends `test_mode: true`.
- Backoff on failure (5 min → 6 h), `needs_review` after 8 tries; 4xx other than 429 goes straight to review. Delivery
  never retries past Reddit's accepted event age (verify the limit; events are sent within minutes, so this only matters for
  long outages).
- **Refunds:** Reddit has no refund event. A refunded conversion stays reported; note it in the ads reporting.

### 5. Pay-now purchases

Already sent by the pixel from the browser (`Purchase` on the success page). Not sent again server-side in this change, to
avoid double counting. (Optional later: send both with the same `conversion_id` so Reddit deduplicates.)

## Slices

| # | What | Where | Gate |
| --- | --- | --- | --- |
| 0 | Confirm the current Reddit Conversions API contract (endpoint, version, ids it takes, auth, field names, `test_mode`, event-age limit) from Reddit's docs; confirm on cramapple.com that the pixel sets the `_rdt_uuid` cookie and that ad clicks arrive with `rdt_cid`; get a conversion access token | David + Claude | none |
| 1 | Migration: `trial_orders.ad_attribution`, `app.ad_conversion_outbox`, `trial_convert` enqueue; SQL tests | backend | Dev, then Prod ⛔ |
| 2 | `trial_start` accepts and allow-lists `ad_attribution` (direct + parent); tests | backend | Dev |
| 3 | Delivery in the charge worker, flag + secret, `test_mode` on Development; tests with a mocked Reddit | backend | Dev |
| 4 | Marketing sends `ad_attribution` from the stored touch + `_rdt_uuid`, nothing when opted out; tests | Lovable | publish ⛔ |
| 5 | Development check: a sandbox trial with a fake `rdt_cid` → day-7 shift → conversion → one outbox row → one `test_mode` call accepted by Reddit's test events view | Dev | — |
| 6 | Codex review of slices 1–4 | Codex | — |
| 7 | Production: migration, functions, secret, `REDDIT_CONVERSIONS_ENABLED=true`; confirm the next real conversion appears in Reddit Events Manager | Prod | ⛔ each step |

## Decisions for David

- **D1 — Scope.** Trial conversions only (recommended), or also pay-now purchases server-side with deduplication.
- **D2 — Matching data.** Click id + Reddit's own cookie id only (recommended, nothing personal), or also hashed email
  and IP/user agent (better match rate, but personal data of mostly-minor students; needs the lawyer).
- **D3 — Opt-outs after checkout.** The opt-out lives in the browser, so a visitor who opts out after starting a trial is not
  known to the server and their day-7 conversion would still be sent. Accept, or add a server-side opt-out (an account
  setting) later.
- **D4 — Under-16s.** The same legal question as the pixel: California needs opt-in to share data of under-16s for ads.
  Until the lawyer answers, this change sends only what the pixel already sends plus the conversion amount.
- **D5 — Privacy Policy.** Name Reddit's Conversions API alongside the pixel.

## Rollback

`REDDIT_CONVERSIONS_ENABLED=false` stops delivery at once; rows keep queueing harmlessly and can be discarded. The
migration is additive. Nothing in conversion, charging, access or email depends on this path.

## Slice 4 — marketing (sent to Lovable 2026-10-25, not published)

Found in marketing `b57aeb43`: `src/lib/attribution.ts` reads `rdt_cid` into first/last touch, but `captureTouch()` is not
called on the homepage or `/ap-biology-prep`, and no trial-start request sends it. The prompt asks Lovable to call
`captureTouch()` once per page load in `__root.tsx`, add `adAttributionForCheckout()` to `src/lib/reddit-pixel.ts` (no click
id when the visitor opted out or sends Global Privacy Control), and send `ad_attribution` only with the two `trial_start`
calls. Review the commit before David publishes.
