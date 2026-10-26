# Advertising attribution — design (2026-10-26)

**Status:** Backend slice built on branch `claude/ad-attribution-backend`, tests green, **not applied to any database, not deployed**.
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

If the visitor opted out (stored opt-out or GPC) the order stores only `{"ad_tracking_allowed": false}`.
`app.v_trial_attribution` flattens it (last touch, first touch fills gaps) for reporting; service role only.
`trial_converted` growth events now carry `utm_*`/`creative_id` from the order.

## Slices

| # | What | Where | Status |
| --- | --- | --- | --- |
| 1 | Migration `20261026120000`, `trial_start` stores sanitised `ad_attribution` (direct + parent), `trial_converted` carries source, tests | backend | **built**, Dev apply ⛔ Prod apply ⛔ |
| 2 | Marketing: send first/last touch + anon id, capture other click ids, fix touch overwrite bugs, add UTMs to `landing_view` and checkout events | Lovable marketing | prompt drafted: `docs/handoffs/LOVABLE_PROMPT_AD_ATTRIBUTION_MARKETING_2026_10_26.md` |
| 3 | App: activation events (first session, first answer) | Lovable app | prompt drafted: `docs/handoffs/LOVABLE_PROMPT_APP_ACTIVATION_EVENTS_2026_10_26.md` |
| 4 | Pay-now purchases (`purchase_completed`) get the same attribution | backend + marketing | not started |
| 5 | Reporting: SQL view in use + PostHog funnel (visit → trial start by source) | Supabase / PostHog | view built; PostHog dashboard needs David |
| 6 | Reddit Conversions API reads `ad_attribution` (see its plan) | backend | after 1–2 |

## Rollout order (important)

The live marketing site already sends a flat `ad_attribution` on trial start (Lovable `ea24448b`, `9efe203c`). The old backend ignores it.
Deploy order: **migration → functions → then publish the marketing change**. The new sanitiser still reads the flat `reddit_click_id`.

## Decisions for David

- **A — Opt-out and first-party attribution.** Currently an opted-out visitor stores no source at all (conservative, loses their attribution). Alternative: store UTMs anyway since nothing goes to an ad platform. Needs your/lawyer's call.
- **B — Google paid vs organic.** `utm_medium=paid_search` for ads; unlabelled Google traffic is classified organic by referrer.
- **C — Pay-now purchases** (slice 4): confirm they should be attributed too.
- **D — PostHog dashboards** are built in the PostHog UI; no connector is available here.

## Rollback

Column and view are additive and unread by charging/access. Stop sending from the frontend and the backend stores `null`.
