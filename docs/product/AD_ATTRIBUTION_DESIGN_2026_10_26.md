# Advertising attribution — design (2026-10-26)

**Status:** Backend slices 1 and 4 built (branch `claude/ad-attribution-backend`, tests green). **Applied and deployed to Development and, on David's explicit approval, to Production (2026-10-26 ~18:51 UTC).** Production functions were rebuilt from the exact source Production already ran (commit `43440c98`, verified identical by download) plus only the 6 attribution files, so the later TASK-0078 refactors on `main` were NOT shipped. Migration loaded with `db query`, so it is not in the migration ledger. Marketing/app slices are Lovable work in review.
Marketing and app slices are Lovable prompts (not sent). **Tier:** Hard-Gate for Prod (payments data). **Scope:** paid ads only
(Reddit, Instagram, TikTok, Google, YouTube). Referral and offline come later.
**Related:** `REDDIT_CONVERSIONS_API_DAY7_PLAN_2026_10_25.md` (reuses this storage), `TASK-0077`.

## Goal

Know which channel, and within paid, which source, campaign and **ad**, produced visits, trials and day-7 conversions.

## Principles

1. **The database answers "which ad paid"** (trials and day-7 conversions). Browser tools cannot see day-7 charges.
2. **PostHog answers top of funnel** (visit by source, then trial start by source), joined to the order by a stable anonymous id.
3. Nothing personal: touch fields and a random PostHog id only. No email, name or student id.

## URL convention (every ad link, no exceptions)

| Field | Meaning | Example |
| --- | --- | --- |
| `utm_source` | platform | `reddit`, `instagram`, `tiktok`, `google`, `youtube` |
| `utm_medium` | kind of traffic | `paid_social` (Reddit/Instagram/TikTok/YouTube ads), `paid_search` (Google ads) |
| `utm_campaign` | campaign slug | `bio-cram-2027-05` |
| `utm_content` | **the ad / creative id** | `ad-07-hook-a` |
| `utm_term` | ad set or audience (optional) | `apbio-juniors` |

Click ids are captured automatically when present: `rdt_cid` (Reddit), `gclid`/`gbraid`/`wbraid` (Google), `ttclid` (TikTok), `fbclid` (Meta/Instagram).

## Data

`app.trial_orders.ad_attribution jsonb` (nullable, additive):

```json
{ "ad_tracking_allowed": true, "anon_id": "<PostHog distinct id>",
  "first_touch": {"utm_source": "...", "...": "..."}, "last_touch": {"utm_content": "ad-07", "reddit_click_id": "..."} }
```

If the visitor opted out (stored opt-out or GPC) the order keeps first-party fields (UTMs, referrer, landing path, creative id) but **no ad-platform click ids and no anon id** (decision A, David 2026-10-26).
Pay-now purchases (decision C) carry the same source in Stripe session metadata (`attr_utm_*`), stamped onto `checkout_started` and `purchase_completed`.
`app.v_trial_attribution` flattens it (last touch, first touch fills gaps) for reporting; service role only.
`trial_converted` growth events now carry `utm_*`/`creative_id` from the order.

## Slices

| # | What | Where | Status |
| --- | --- | --- | --- |
| 1 | Migration `20261026120000`, `trial_start` stores sanitised `ad_attribution` (direct + parent), `trial_converted` carries source, tests | backend | **built**, Dev apply ⛔ Prod apply ⛔ |
| 2 | Marketing: send first/last touch + anon id, capture other click ids, fix touch overwrite bugs, add UTMs to `landing_view` and checkout events | Lovable marketing | prompt drafted: `docs/handoffs/LOVABLE_PROMPT_AD_ATTRIBUTION_MARKETING_2026_10_26.md` |
| 3 | App: activation events (first session, first answer) | Lovable app | prompt drafted: `docs/handoffs/LOVABLE_PROMPT_APP_ACTIVATION_EVENTS_2026_10_26.md` |
| 4 | Pay-now purchases get the same attribution (Stripe metadata → `checkout_started`/`purchase_completed`) | backend + marketing | backend built |
| 5 | Reporting: SQL view in use + PostHog funnel (visit → trial start by source) | Supabase / PostHog | view built; PostHog dashboard needs David |
| 6 | Reddit Conversions API reads `ad_attribution` (see its plan) | backend | after 1–2 |

## Rollout order (important)

The live marketing site already sends a flat `ad_attribution` on trial start (Lovable `ea24448b`, `9efe203c`). The old backend ignores it.
Deploy order: **migration → functions → then publish the marketing change**. The new sanitiser still reads the flat `reddit_click_id`.

## Decisions (David, 2026-10-26)

- **A — yes:** store first-party UTMs even when opted out; click ids and anon id only when allowed.
- **B — yes:** Google ads `utm_medium=paid_search`; unlabelled Google traffic is organic by referrer.
- **C — yes:** pay-now purchases attributed too (slice 4 built).
- **D —** PostHog dashboards are built in the PostHog UI; no connector here.

## Rollback

Column and view are additive and unread by charging/access. Stop sending from the frontend and the backend stores `null`.
