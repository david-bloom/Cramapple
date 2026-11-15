# APPROVAL-0212 — No-card trial: Production `cardless_trial_enabled=true` for the self-test window (granted and executed 2026-11-10)

- **Status:** **Granted by David in chat ("I approve 0212", 2026-11-10) and executed 03:24:49 UTC** by the paywall-to-prod session.
- **Tier:** Hard-Gate (entitlements, public endpoint, minors' data).
- **Basis:** `DECISION-0135`, `DECISION-0136`; release packet step 4 (`docs/product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md`); dark verification `docs/qa/NO_CARD_TRIAL_PRODUCTION_DARK_VERIFICATION_2026_11_10.md` (pass, minutes earlier, switch false and no trial data).

## Scope
One config row in Production (`pcntajvbdfqhbeewmdry`): `update app.config set config_value='true'::jsonb, updated_at=now() where config_key='cardless_trial_enabled' and config_value::text='false'`. No migration, deploy, secret or Lovable change. The switch is global; marketing buttons were not changed by this session, so reach is whoever knows `app.cramapple.com/start` (self-test window). The app flag `VITE_CARDLESS_TRIAL=on` was already committed (Lovable `fa4c02f`, 2026-11-10 03:01 UTC); David reports no pending Lovable publishes.

## Execution record
- **Before:** `cardless_trial_enabled=false`; `trial_v2` entitlements 0, grading log 0 (dark verification).
- **Write:** returned one row, `updated_at` 2026-11-10 03:24:49 UTC.
- **After (verified, rolled-back calls):** fresh student with no entitlements: `get_trial_state` = `none`, `can_start=true`. Paid student: `superseded`, `can_start=false`. Admin account: `superseded`, `can_start=false`. `trial_v2` entitlements 0, grading log 0 (no trial started), `sample_access_enabled=false`.
- **Not tested here:** a real email-code sign-up and trial start (release step 5, David or a named tester), the daily cap, checkout.

## Observation, same session (not a defect)
David, signed in, clicked "Start free trial" on cramapple.com and landed on `/home` with no subject selection. By design: `/start` redirects any signed-in visitor to `/home`, and the subject picker only shows when `get_trial_state.can_start` is true, which is false for accounts with a regular entitlement or the admin role (`superseded`). A signed-out browser (private window) is needed to see `/start` and the picker. Source: app `src/routes/start.tsx`, `HomeV2.tsx` (`trialCanStart`).

## Rollback
`update app.config set config_value='false'::jsonb where config_key='cardless_trial_enabled'`. Trials already started keep access until their `ends_at`.
