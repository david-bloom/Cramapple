# Session close — marketing attribution and referral program (2026-10-29)

**Task:** marketing and marketing-analytics working session for David (started from a parent session). **Next owner:** David, then the next marketing session.

## 1. Current task
Know which channel, source and ad sent traffic, trials and conversions (paid ads first: Reddit, Instagram, TikTok, Google, YouTube); then define a self-serve referral program for students and tutors.

## 2. What changed
- **Attribution backend live in Production** (`APPROVAL-0203`): `app.trial_orders.ad_attribution`, view `app.v_trial_attribution`; `create-checkout-session`, `create-parent-payment-link`, `stripe-webhook` carry the source on `checkout_started`, `purchase_completed`, `trial_converted`. Opted-out visitors store first-party fields only. PR #568 merged.
- **Lovable marketing and app work** reviewed by commit SHA: attribution capture, `channel` property, ad_attribution sent on trial start and pay-now, app activation events. Follow-up fix `a29a07f0` (Stripe/accounts.google.com referrers, junk first-touch) sent; publish not confirmed.
- **Docs:** `marketing/AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md` (M1–M6), `product/AD_ATTRIBUTION_DESIGN_2026_10_26.md`, two Lovable prompts, and `marketing/REFERRAL_PLATFORM_VENDOR_CHECKLIST_2026_10_26.md` (referral requirements, copy, 19-row demo scorecard; PR #569 merged). `DECISION-0130` records the referral program.

## 3. Verified
Local Deno suite 596 pass at merge; migration and deploys succeeded on both projects; PRs #568 and #569 merged. Reddit pixel live and sending only the event name and pixel id (2026-10-25).

## 4. Open
- **One tagged production trial**, for example `?utm_source=reddit&utm_medium=paid_social&utm_campaign=qa&utm_content=ad-qa-02`, in an opted-in browser; then inspect the order's `ad_attribution` and the PostHog event properties.
- Publish Lovable marketing `a29a07f0` (last known unpublished).
- **PostHog dashboards** (visit by source, trial start by source) are built in the PostHog UI; there is no connector.
- **Referral:** vendor demos using the scorecard (GrowSurf, Referral Factory, Partnero); Q11 (lawyer), Q12 (tutor-link friend discount), Q13 (referrer name on landing page).
- **Reddit CAPI** (`DECISION-0129`): D3–D5 and the conversion access token; whether PR #567's migration is in Production is unconfirmed.
- Reddit Events Manager "Invalid click ID" (`test_inspection`): believed a Reddit test event; unconfirmed.

## 5. Blockers and risks
Production functions were deployed from Production's own source, so Development and Production still differ on TASK-0078 refactors. Referral cash payouts and student referrers raise tax and minors questions that need the lawyer before launch. The click id is stored twice (`reddit_click_id` and `ad_attribution`) but reported once; no double counting.

## 6. Files
Created: the docs above, `supabase/migrations/20261026120000_ad_attribution_on_trial_orders.sql`, `APPROVAL-0203`, this handoff. Changed: `supabase/functions/_shared/trial-contract.ts`, `trial-checkout.ts`, the two checkout functions, `stripe-webhook/*` and tests.

## 7. Commands and results
`supabase db query --linked --workdir … -f` migration to Development and Production (success); `supabase functions deploy … --no-verify-jwt --use-api` for three functions on both projects (success); Deno tests 596 pass; `gh pr create`/merge for #568, #569.

## 8. Approval state
Production migration and function deploy approved and executed (`APPROVAL-0203`). Lovable publishes were done by David. No further owner approval is needed to verify with a tagged trial. Reddit delivery and any referral vendor purchase still need owner approval.

## 9. Next step
David publishes `a29a07f0` and runs one tagged trial; the next session inspects that order (read-only) and the PostHog events. Then vendor demos for referral.

## 10. Do not touch
David's two untracked Reddit files if still untracked in the main checkout; the Reddit Conversions API outbox and flag `REDDIT_CONVERSIONS_ENABLED` until D3–D5 are answered; do not run `supabase db push`; always pin `--workdir` (the CLI in `~` links Production); do not buy or contact a referral vendor without David.

**Restart note:** best single next action is the tagged production trial.
