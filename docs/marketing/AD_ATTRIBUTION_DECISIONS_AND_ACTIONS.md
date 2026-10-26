# Ad attribution — decisions and actions log

**STATUS:** Active record (opened 2026-10-26). Append new entries at the bottom of each section; do not rewrite history.
**Owner:** David Bloom. **Design:** [`docs/product/AD_ATTRIBUTION_DESIGN_2026_10_26.md`](../product/AD_ATTRIBUTION_DESIGN_2026_10_26.md).
**Related:** [`REDDIT_CONVERSIONS_API_DAY7_PLAN_2026_10_25.md`](../product/REDDIT_CONVERSIONS_API_DAY7_PLAN_2026_10_25.md) (reuses the stored attribution), TASK-0077 (card trial).

## Goal

Know which channel, and within paid advertising which source, campaign and **ad**, produced visits, trials and day-7 conversions.
Scope now: paid ads (Reddit, Instagram, TikTok, Google, YouTube). Referral (student, tutor) and offline come later.

## Decisions (David, 2026-10-26)

| ID | Decision | Consequence |
| --- | --- | --- |
| M1 | Taxonomy: categories Online/Social, Referral, Offline; channels Reddit, Instagram, TikTok, Google, YouTube; referral = student and tutor/teacher. **Advertising first; referral and offline deferred.** | Only paid channels are built now. |
| M2 | Source of truth: the **database** answers "which ad produced paying customers"; **PostHog** answers top-of-funnel (visit and trial start by source), joined by a stored anonymous id. | `trial_orders.ad_attribution` holds first/last touch + PostHog anon id. |
| M3 (A) | **Store first-party UTMs even when the visitor opted out** of ad tracking. | Opted-out orders keep UTMs, referrer, landing path, creative id; **no ad-platform click ids and no anon id.** |
| M4 (B) | Google ads use `utm_medium=paid_search`; unlabelled Google traffic is organic by referrer. | Channel classifier `channelFor`. |
| M5 (C) | **Pay-now purchases are attributed too**, not only trials. | Source rides in Stripe session metadata (`attr_utm_*`) onto `checkout_started` and `purchase_completed`. |
| M6 | Add app activation events to PostHog (`app_first_session`, `first_question_answered`). | App Lovable prompt. |

## URL convention (every ad link)

`utm_source` = platform (`reddit`, `instagram`, `tiktok`, `google`, `youtube`) · `utm_medium` = `paid_social` or `paid_search` ·
`utm_campaign` = campaign slug · `utm_content` = **ad / creative id** · `utm_term` = ad set or audience (optional).
Click ids are captured automatically: `rdt_cid`, `gclid`/`gbraid`/`wbraid`, `ttclid`, `fbclid`.

## Actions taken

| Date (UTC) | Action | Where | Evidence |
| --- | --- | --- | --- |
| 2026-10-26 | Orientation: confirmed live Reddit pixel (Lovable `5d69b73e`, `b57aeb43`), trial-start click-id capture built in Lovable (`ea24448b`, `9efe203c`); found the backend ignored `ad_attribution` and no order stored a source | read-only | this session |
| 2026-10-26 | Built backend: migration `20261026120000_ad_attribution_on_trial_orders.sql`, strict sanitiser, `trial_start` storage (direct + parent), `trial_converted` and pay-now events carry source, view `app.v_trial_attribution` | branch `claude/ad-attribution-backend` | Deno tests green (588 shared/webhook), `deno check` clean |
| 2026-10-26 | Applied migration and deployed `create-checkout-session`, `create-parent-payment-link`, `stripe-webhook` to **Development** (`wmgjsdkphcyhngaffbqf`) from the branch | Dev | functions v50 / v47 / v56 |
| 2026-10-26 18:51 | **David approved Production.** Applied the migration and deployed the same three functions to **Production** (`pcntajvbdfqhbeewmdry`, ref confirmed). Built from the source Production already ran (commit `43440c98`, verified identical by download) plus only the 6 attribution files, so later TASK-0078 refactors on `main` were **not** shipped | Prod | functions v34 / v12 / v34; view query returns rows |
| 2026-10-26 | Sent Lovable prompts: marketing (click ids, touch bug fixes, channel classifier, attribution on trial and pay-now requests, UTMs on PostHog events) and app (activation events) | Lovable `61dd6602`, `56cae479` | prompts in `docs/handoffs/LOVABLE_PROMPT_AD_ATTRIBUTION_MARKETING_2026_10_26.md`, `..._APP_ACTIVATION_EVENTS_2026_10_26.md` |
| 2026-10-26 | David to review and **publish the Lovable changes himself** | Lovable | pending |

## Open / next

- **PR #567 (Reddit Conversions API day-7, merged to `main` 2026-10-26) coexists with this work.** It stores the Reddit click id in its own `trial_orders.reddit_click_id` column and queues the Reddit conversion; this PR stores the full first/last touch in `ad_attribution`. Both fields are kept in `trial_start` (merge of `main` into this branch, no overlap in columns). Consider later whether the Reddit path should read from `ad_attribution.last_touch` and the flat column be retired.
- Review both Lovable results **by commit SHA**; check on cramapple.com that a tagged ad URL leads to `ad_attribution` on the order and `utm_*` on `trial_converted` (no end-to-end Production `trial_start` has been run yet).
- Deploy skew to remember: Production runs older function source than `main`; Development was deployed from `main`. Diff deployed vs repo before any edge deploy.
- The migration was loaded with `db query`, so it is not in the migration ledger (ledgers are history, DECISION-0128).
- Build PostHog dashboards in the PostHog UI: visit by source → trial start by source (no connector available to Claude).
- Reddit Conversions API: now unblocked on storage; still needs its own decisions D1–D5 and a conversion access token.
- Referral (student, tutor) and offline attribution: not started.
- Governance logs: activity/approval entries for the Production deploy are not yet written.
