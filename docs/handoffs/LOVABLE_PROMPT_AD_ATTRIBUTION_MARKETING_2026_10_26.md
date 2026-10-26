# Lovable prompt — ad attribution (marketing, 2026-10-26)

**Project:** "New Cramapple Marketing" `61dd6602-6991-4561-b418-e988bb7c8a0b`. **Not sent.** Deploy order: backend migration + functions first, then publish.
Design: `docs/product/AD_ATTRIBUTION_DESIGN_2026_10_26.md`.

```text
Improve ad attribution on the marketing site. Do not change copy, layout, styling, Stripe, Supabase settings or the Reddit pixel events. Do not publish.

1. src/lib/attribution.ts
   - Capture these extra query params into the touch, using these keys: gclid, gbraid, wbraid, ttclid, fbclid (same names), plus creative_id from the "creative_id" param. Keep rdt_cid -> reddit_click_id.
   - Fix two bugs: (a) LAST must only be overwritten when the new page load carries at least one tracking param (any utm_*, click id, referral_code) OR an external referrer_host that is not cramapple.com; otherwise keep the existing LAST. (b) FIRST must only be written when the touch has at least one tracking param or an external referrer_host; a bare direct visit must not lock FIRST as empty.
   - Add a pure function channelFor(touch) returning one of: "paid_social", "paid_search", "organic_search", "referral", "direct", "other". paid_* when utm_medium starts with "paid"; organic_search when referrer_host is google/bing/duckduckgo/yahoo and no utm_medium; referral for any other external referrer; direct when nothing.

2. src/lib/reddit-pixel.ts adAttributionForCheckout()
   - Keep the shape { ad_tracking_allowed } and when allowed return { ad_tracking_allowed: true, anon_id, first_touch, last_touch } where first_touch and last_touch are the stored touches (only the allowed keys), omitting empty objects, and anon_id is window.posthog?.get_distinct_id?.() when it is a string. When opted out or GPC, return only { ad_tracking_allowed: false }. Keep sending it only on student and parent trial_start requests.

3. PostHog: attach the last touch to landing_view and to every captureCheckout event as properties utm_source, utm_medium, utm_campaign, utm_content and referrer_host (all already allow-listed) plus a new allow-listed property "channel" (value from channelFor). Respect the same opt-out: when ad tracking is opted out or GPC, omit these properties. Do not add click ids or landing_path to PostHog.

4. Tests: LAST not overwritten by a bare internal load; FIRST not locked by a bare direct visit; each click id is captured; channelFor cases; adAttributionForCheckout shape for allowed/opted-out/GPC; PostHog events carry the properties and omit them when opted out; no email or other field leaks.

Reply with files changed and test results.
```
