# APPROVAL-0209 — Retire the legacy all-subjects `start-trial` in Production (granted and executed 2026-11-09)

- **Date:** 2026-11-09
- **Decision:** Approved and **executed**. One Production secret: `CARDLESS_TRIAL_RETIRED=true` on the project's edge-function secrets (`pcntajvbdfqhbeewmdry`); the same secret was also set on Development by the backend session (see the correction below).
- **Granted by:** David Bloom (Product Owner), directly in chat in the paywall app/docs session on 2026-11-09: "retire the old all-subjects start-trial in Production". This implements decision D11 (`DECISION-0135` addendum; backend spec `docs/product/FREE_TRIAL_NO_CARD_BACKEND_DESIGN_SPEC_2026_11_09.md` section 10). The backend session had asked for this to be a separate approval made with his direct word; this is it.
- **Tier:** Hard-Gate (entitlements; access control).
- **Numbering check:** on 2026-11-09 `main` ended at APPROVAL-0208 and no branch or open pull request claimed APPROVAL-0209.

## Why
`DECISION-0126` item 12 says the cardless trial is "switched off"; in Production it was only unlinked: `start-trial` v23 stayed live and `CARDLESS_TRIAL_RETIRED` was unset, so any signed-in student could call it and receive a seven-day trial on **every** subject. Production Auth allows email-code sign-up (`disable_signup=false`), so that would have been free for anyone who could receive an email.

## What was done (read back)
- Before: `CARDLESS_TRIAL_RETIRED` not in the secret list; an unauthenticated POST to `start-trial` returned `401 unauthorized`.
- Command (Supabase CLI pinned to the repository and the explicit Production ref): `supabase secrets set CARDLESS_TRIAL_RETIRED=true --project-ref pcntajvbdfqhbeewmdry`.
- After: the secret is listed; an unauthenticated POST returns **`410 {"error":"trial_retired"}`** (the function checks the switch before authentication). Nothing was deployed; no code, migration or other secret changed. No caller exists in the app or the marketing project (searched), and `DECISION-0126` had already removed the marketing links.

## Not changed
**Correction (2026-11-09, same day):** the backend session also set `CARDLESS_TRIAL_RETIRED=true` on **Development** (`wmgjsdkphcyhngaffbqf`) on David's direct word in its session ("Do both"), so `start-trial` answers `410 trial_retired` in both environments. (This record first said Development was unretired; that was true only until the backend session acted.) The card trial (`TRIAL_ADMISSION_ENABLED`), the 72-hour sample switches, existing `trial_v1` rows and every entitlement are untouched. Existing `trial_v1` rows still lapse on their own and still count as a used trial.

## Rollback
`supabase secrets unset CARDLESS_TRIAL_RETIRED --project-ref pcntajvbdfqhbeewmdry` (takes effect when the function next boots). Only do this deliberately: it re-opens the all-subjects cardless trial to any signed-in student.
