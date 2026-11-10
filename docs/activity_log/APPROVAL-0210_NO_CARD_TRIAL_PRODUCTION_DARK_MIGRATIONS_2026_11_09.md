# APPROVAL-0210 — No-card trial Production dark migrations (granted and executed 2026-11-09 ET)

- **Granted by:** David Bloom, Product Owner, in this Codex chat: “I approve applying the four no-card trial migrations to Production with the trial switch kept off.”
- **Scope:** Production Supabase project `pcntajvbdfqhbeewmdry`; apply the four reviewed no-card trial migrations in order and verify them with `app.config.cardless_trial_enabled=false`. Tier: Hard-Gate.
- **Executed by:** Codex, 2026-11-10 02:20–02:23 UTC (2026-11-09 21:20–21:23 ET), through the Supabase `apply_migration` connector with the Production project ID explicit. Each migration was loaded from its repository file; only the outer `begin;` / `commit;` lines were removed because `apply_migration` owns the transaction. No SQL was retyped.
- **Not approved or done:** turning on the trial switch, changing the app or marketing flags, Lovable publication, changing the card-trial secret, retiring the sample, a real signup or purchase.

## Pre-apply checks

- Production had none of the four trial ledger rows, no trial state/start RPCs, no `cardless_trial_enabled` key, and no `trial_v2` entitlements. The grading function had exactly one `return 'entitled';` patch anchor and the sample branch. Required tables and helper functions were present.
- Function MD5s before apply: `app.authorize_grading_access` `5a14fb89f0e9349cda3a89d52341d609`; `app.has_study_subject_access` `960c6b2183b6cdc8e7b1090eed11f8a4`; `app.has_study_pack_access` `29ca6b2e67fef0e5d276c1fd0df7093b`; `public.claim_sample_try(text)` `c26605620f5589e9b89154a8cb33731b`.
- Independent Development QA immediately before this approval: 46 trial checks and 10 saved-work checks passed in rollback-only suites; real two-connection same-email and grading-cap races passed; fixtures were deleted; a four-file down/up rehearsal passed in one rolled-back transaction. App main `a812100d` passed TypeScript, 1,350 Vitest tests and build. The grading function's down-state differs from Production by one comment only.

## Applied files and Production ledger

| Order | Reviewed file at apply time | Production ledger version | Name |
| --- | --- | --- | --- |
| 1 | `20261109215704_cardless_trial_v2.sql` | `20261110022023` | `cardless_trial_v2` |
| 2 | `20261109221340_get_my_learning_sessions.sql` | `20261110022041` | `get_my_learning_sessions` |
| 3 | `20261110011605_cardless_trial_v2_qa_fixes.sql` | `20261110022049` | `cardless_trial_v2_qa_fixes` |
| 4 | `20261110013137_cardless_trial_v2_email_race.sql` | `20261110022059` | `cardless_trial_v2_email_race` |

The files were renamed in the follow-up repository PR to the Production ledger versions under `DECISION-0128`. Development keeps its earlier ledger versions; `supabase db push` is prohibited for both environments by that decision. Check live catalog state, not ledger equality, for parity.

## Dark verification

- `cardless_trial_enabled=false`, `trial_daily_grading_cap=40`; all three RPCs exist. A fresh user ID reads `phase=blocked`, `blocked_reason=disabled`. Zero `trial_v2` entitlements, consumed-email hashes and grading-log rows.
- `app.authorize_grading_access` changed to MD5 `58a13d1c36457be68c2b97c6e3a08bea` with the intended trial gate. `app.has_study_subject_access`, `app.has_study_pack_access` and `public.claim_sample_try(text)` retained their pre-apply MD5s. One existing paid attempt returned `entitled`; no trial grading row was written.
- `app.trial_grading_log` has RLS and neither `anon` nor `authenticated` table SELECT. The three public RPCs have `authenticated` EXECUTE and no `anon` EXECUTE.
- The Supabase security advisor reported expected new notices: [RLS enabled with no policy](https://supabase.com/docs/guides/database/database-linter?lint=0008_rls_enabled_no_policy) for the private log table, and [authenticated security-definer functions](https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable) for the three deliberately authenticated RPCs. Their ownership and switch checks were covered by Development QA; no broader advisor baseline was captured before apply.
- No app flag, marketing link, checkout setting, sample switch or card-trial secret was changed in this step. Real Production email-code and signed-in trial walks remain for later approvals.

## Rollback

While no `trial_v2` rows exist, the reviewed down scripts can reverse the four migrations in this order: `cardless_trial_v2_email_race_down.sql`, `cardless_trial_v2_qa_fixes_down.sql`, `get_my_learning_sessions_down.sql`, `cardless_trial_v2_down.sql`. The order was rehearsed in Development. A Production rollback is a separate Hard-Gate action unless an incident requires the owner's direction. The trial switch remains false meanwhile.
