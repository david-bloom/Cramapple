# No-card trial: Production dark verification (2026-11-10, ~03:15 UTC)

**Scope:** release packet step 2 (`docs/product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md`). Production project `pcntajvbdfqhbeewmdry`, trial switch false. **Read-only**: SQL reads and rolled-back function calls only; no data, config, function, secret or Lovable change. Requested by David ("run the dark verification on production"). Run by the paywall-to-prod session. All items below are *verified* unless marked otherwise.

## Result: PASS, nothing found that blocks the next step

| Check | Result |
| --- | --- |
| Ledger | Four trial versions present and equal to the files on main: `20261110022023`, `…041`, `…049`, `…059`. |
| Switches | `cardless_trial_enabled=false`, `trial_daily_grading_cap=40`, `sample_access_enabled=false` (`APPROVAL-0211`). |
| Dark state of data | `trial_v2` entitlements 0, `trial_grading_log` 0, `trial_v2` consumed emails 0, `trial_started` outbox events from `trial_v2` 0. Legacy trial rows still 21 (unchanged count). |
| Function bodies | `get_trial_state` b93d59c9…, `start_subject_trial` 912a8ce9…, `get_my_learning_sessions` 33bee628… are identical to Development's. `authorize_grading_access` 58a13d1c…, `has_study_subject_access` 960c6b21…, `claim_sample_try` c2660562… same as before `APPROVAL-0211`. |
| Privileges | New public RPCs: `anon` cannot execute, `authenticated` can. `app.trial_grading_log`: RLS enabled and forced. |
| `get_trial_state()` as a paid student | `superseded`, no blocked reason. |
| `get_trial_state()` as a student with no entitlements | `blocked` / `disabled`. |
| `start_subject_trial('ap-biology', …)` as that student | refused with `trial:disabled`; nothing written. |
| Grading path, existing students | `authorize_grading_access` for 4 real paid students' attempts returned `entitled`; no row written to `trial_grading_log`. |
| Sample | `claim_sample_try` raises `sample:disabled` (see `APPROVAL-0211`). |
| Security advisor | No ERROR-level findings. New INFO `rls_enabled_no_policy` for `app.trial_grading_log` (intended: service-role only, same as the sample tables). New WARN `authenticated_security_definer_function_executable` for `get_trial_state`, `start_subject_trial`, `get_my_learning_sessions`: the same accepted pattern as 25 existing RPCs; each checks `auth.uid()` inside. |

## Not verified (do not read this as covered)
- **Legacy trial student's grading path:** no active legacy trial student with an attempt exists in Production, so that branch ("trial_v1 / card trial rows: unchanged behaviour") was not exercised. The paid and fresh-student branches were.
- **Trial-account grading and the 40/day cap in Production:** impossible while the switch is false; covered only by the Development suites.
- **Checkout, Stripe, edge functions, the anonymous `sample-try` endpoint, and every signed-in browser state:** not called. The app is still the old build with the trial flag off (publish state unverified).
- **Real email-code sign-up and the 30/hour auth email cap:** release step 5.

## Next
Step 3 (app flag PR and Lovable publish) needs David's approval and, for the PR, his merge. The self-test switch (step 4) needs its own approval.
