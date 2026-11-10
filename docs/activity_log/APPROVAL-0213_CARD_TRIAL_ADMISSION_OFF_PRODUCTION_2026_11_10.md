# APPROVAL-0213 — Card trial off: Production secret `TRIAL_ADMISSION_ENABLED=false` (granted and executed 2026-11-10)

- **Status:** **Granted by David in chat ("I approve 0213", 2026-11-10) and executed** by the paywall-to-prod session.
- **Tier:** Hard-Gate (payments adjacency, entitlements).
- **Basis:** `DECISION-0135` (card trial preserved but inactive; checkout pay-now, D4); release packet step 7. Preceded by `APPROVAL-0212` (no-card trial switch on) and the live marketing pivot (buttons to `app.cramapple.com/start`, pay-now checkout wording).

## Scope
One Supabase edge secret in Production (`pcntajvbdfqhbeewmdry`), read by `create-checkout-session` and `create-parent-payment-link` (`Deno.env.get("TRIAL_ADMISSION_ENABLED") === "true"`). Off means checkout is pay-now as before (TASK-0077 plan §8 rollback path). Card-trial code, tables and functions stay deployed. No migration, deploy, Stripe or Lovable change.

## Execution record
- **Pinned:** `supabase secrets ... --project-ref pcntajvbdfqhbeewmdry --workdir <repo>` (the CLI without `--workdir` resolves to Production anyway; both pinned explicitly).
- **Before (verified):** the digest of `TRIAL_ADMISSION_ENABLED` equalled sha256("true") (`b5bea41b…`), i.e. the value was `true`.
- **Write:** `supabase secrets set TRIAL_ADMISSION_ENABLED=false` finished successfully.
- **After (verified):** the digest now equals sha256("false") (`fcbcf165…`). `CARDLESS_TRIAL_RETIRED` and `TRIAL_TERMS_VERSION` digests unchanged.
- **Not tested:** no live checkout was created (Stripe live mode; deliberately not exercised). Edge functions read the secret at boot, so effect is expected on the next cold start; **inferred, not observed**. Watch the first real checkout.

## Rollback
`supabase secrets set TRIAL_ADMISSION_ENABLED=true --project-ref pcntajvbdfqhbeewmdry --workdir <repo>`. Also requires the marketing checkout to offer the card trial again (it currently shows pay-now only), so rollback of the secret alone does not bring the card trial back.
