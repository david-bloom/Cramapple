# APPROVAL-0203 — Ad attribution: apply `ad_attribution` migration and deploy three functions to Production (executed 2026-10-26)

- **Date:** 2026-10-26 (Development first, then Production; Production at about 18:51 UTC / 2:51 PM EDT).
- **Granted by:** David Bloom (Product Owner), in session: "Approved: apply the migration and deploy the three functions to Production (pcntajvbdfqhbeewmdry), confirming the ref first."
- **Related:** `docs/marketing/AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md` (M1–M6); `docs/product/AD_ATTRIBUTION_DESIGN_2026_10_26.md`; PR #568 (merged); PR #567 / `DECISION-0129` (Reddit Conversions API, coexists). Tier: Hard-Gate (payments data, Production).
- **Why:** to learn which channel, source and ad produced trials and conversions (owner goal, 2026-10-26).

## Scope

- **Migration** `supabase/migrations/20261026120000_ad_attribution_on_trial_orders.sql`: adds nullable `app.trial_orders.ad_attribution jsonb` and the view `app.v_trial_attribution` (granted to `service_role` only). Additive. Applied to Development and Production with `supabase db query --linked --workdir … -f <abs path>`; it is therefore **not in the migration ledger** (consistent with `DECISION-0128`: ledgers are history).
- **Functions deployed to Production:** `create-checkout-session`, `create-parent-payment-link`, `stripe-webhook`.
- **Source:** Production's own deployed source (Production was older than `main`; it matched commit `43440c98`) plus only the attribution changes, **not** `main`. This avoided shipping unapproved TASK-0078 refactors. Development was deployed from a `main`-based branch, so Development and Production differ on those refactors.
- **Project ref** confirmed with `--debug` before each write; `--workdir` pinned (the CLI in `~` resolves to Production).
- Version numbers and bundle hashes were **not recorded** in this session.

## Behaviour shipped

Opted-in visitors: UTMs, referrer host, landing path, creative id, ad-platform click ids and an anonymous id are stored on the order. Opted-out visitors: first-party fields only, no click ids, no anonymous id. Pay-now carries the source in Stripe session metadata. `checkout_started`, `purchase_completed` and `trial_converted` carry the source. No new outside recipient, no email or name added.

## Verified

- Local Deno suite at the merge point: 596 tests pass.
- Migration and deploys reported success on both projects.

## Not verified

- **No live tagged trial has been run in Production** yet, so no real order's `ad_attribution` has been inspected. Needs David to publish Lovable marketing commit `a29a07f0` (last known unpublished) and run one tagged trial.
- Whether PR #567's migration `20261025155645_reddit_conversions_day7.sql` is in Production (my query returned no output).

## Rollback

Redeploy the three functions from the previous Production bundles (commit `43440c98` source). The column and view are additive and harmless if unused.

## Remaining owner approvals

None for this change. Reddit Conversions API delivery still needs `DECISION-0129` D3–D5 and a conversion access token.
