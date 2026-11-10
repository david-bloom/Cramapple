# Session close and handover: no-card free trial, moving to Production (2026-11-09/10)

> **Current status (2026-11-10 02:23 UTC):** this handover is the pre-release snapshot. Backend PR #611 and app PR #53 are merged. Independent Codex QA passed the Development SQL suites, concurrency tests, app tests/build and rolled-back four-file down/up rehearsal. David approved the Production dark apply in this chat; all four migrations are applied under `APPROVAL-0210`, with `cardless_trial_enabled=false` and no `trial_v2` grants. See `docs/product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md` for the current step order and ledger mapping. App publish, trial activation, marketing and card-trial switch-off remain separate Hard Gates.

**Purpose:** a new session starts from this file to take the no-card, single-subject, 7-day free trial from "built and verified in Development" to Production. Read this first, then the records in section 9. Tier: Hard-Gate (entitlements, access control, payments adjacency, public pages, minors' data).
**Written by:** the app-and-docs session (`paywall-app-docs-cdd3b5`). The backend session (`Paywall backend & entitlement (Dev)`, id `local_ce4201ba-8e39-49c3-b1c5-c914fd1c149d`) owns migrations and edge functions and may still be addressable.
**Status labels:** *verified* = I observed it; *reported* = another session said it and I did not re-check; *inferred* = reasoning only.

## 1. What the product is (David's decisions, 2026-11-09)

- "The current experience is the free trial without card. We should preserve the free trial with card for possible future use but it is not active."
- "7 days full access but for a specific subject the student selects." Account timing: "Email code on landing."
- Journey: cramapple.com "Start free trial" lands on `app.cramapple.com/start` (email, 6-digit code, no card) then `/home` with a subject prompt, a days-remaining element and a pay prompt linking to checkout. A subject landing page's "Start free trial" arrives at the hub with that subject confirmed.
- Recorded as `DECISION-0135` (D1-D8 approved at the recommendations; D9-D12 addendum). D1 clock starts at subject confirmation; D2 subject locks at day 7, saved work stays readable, pay prompt; D3 the 72-hour sample stays dark and is retired after the trial ships; D4 checkout is pay-now while the card trial is off; D5 uncapped use with a guard; D6 `trial_v1` and card-trial emails count as a used trial; D7 no nurture emails in the first release; D8 minors' data re-confirmed; D9 no subject change after confirming; D10 daily grading ceiling 40 per trial account per 24 hours; D11 retire legacy `start-trial`; D12 a used sample does not block a trial and the reverse.

## 2. State of every moving part (as of 2026-11-10 ~01:45 UTC)

| Part | State |
| --- | --- |
| Docs PR #608 (Cramapple) | **Merged** 2026-11-09T22:49Z (merge `01711baf`). |
| App PR #53 (`ap-prep-blueprint`, `claude/cardless-trial-app`) | **Merged by David** 2026-11-10T01:26:01Z (merge commit `a812100d`), including the pending-grading read-only fix (head `ede07268`). **This merge happened before the final Codex rerun passed.** `VITE_CARDLESS_TRIAL` is absent from `.env`, so the trial UI is off by default (*verified* by Codex and by me earlier). Not Lovable-published as far as I know (*unverified*; check the Lovable project `56cae479` history). |
| Backend PR #609 (Cramapple) | **Merged by David** 2026-11-10T01:34:34Z at head `dca09bd6` (merge `83b5756d`), which is the Vercel review agent's head and **does not include the backend session's latest fixes**. Main therefore has the agent's in-place edit of the applied QA-fixes migration (same guard, but the file no longer matches the Development ledger) and spec §8/§11 text prescribing a `claim_sample_try` change. The fixes are in **open PR #611** (head `dba743c1`, code PR for David): the email-race migration `20261110013137`, the restored `20261110011605` text, spec §14 conflict 4 and §15.3. The backend spec is on main. |
| Development database (`wmgjsdkphcyhngaffbqf`) | *Reported* by the backend session: all three trial migrations applied (`20261109215704`, `20261109221340`, QA-fixes ledger `20261110011605`), 46-check and 10-check suites pass, a real two-connection race passed (second grader blocked 4,658 ms on the per-user lock, denied at cap 1; script `supabase/tests/cardless_trial_race.sh`), down scripts rehearsed and re-applied, left clean (switch false, cap 40, no test rows). |
| Production database (`pcntajvbdfqhbeewmdry`) | **No trial migration, no switch.** Codex confirmed none of the three migrations are in Production (*verified* by Codex 2026-11-09). The only trial-related Production change is `CARDLESS_TRIAL_RETIRED=true` (`APPROVAL-0209`; legacy `start-trial` returns 410 in Production; the function was never deployed to Development, which returns 404). |
| Marketing site (Lovable `61dd6602`, no GitHub repo) | **Unchanged.** "Start free trial" still goes to `/checkout`, which shows card-trial wording and "$39.99 due today". `VITE_TRIAL_CHECKOUT_ENABLED="true"`. Prompts are drafted and **not sent**: `docs/handoffs/LOVABLE_PROMPTS_FREE_TRIAL_NO_CARD_DRAFT_2026_11_09.md`. |
| 72-hour sample | Live in Production behind a hidden link, switches on under `APPROVAL-0207` step B (executed by the backend session on David's direct word, 2026-11-09). Typed-answer FRQ, no analytics, no emails. App side (PR #49-#52 family) merged; publish was David's step. Per D3 it is to be retired once the trial ships. |
| Independent QA | Codex merge-gate rounds 1-2 produced findings, all fixed except as noted in section 6. **The third rerun (heads #609 `dba743c1`, #53 `ede07268`) has NOT been run.** A copy-paste prompt was given to David in chat; its text is section 10. |

## 3. Architecture in one page

- **Entitlement model:** one row per student in `app.subject_entitlements` with `access_tier='trial'`, `source='trial_v2'`, `ends_at = confirmed_at + 7 days`, created at subject confirmation. Existing gates (`authorize_grading_access`, subject access, serving) give full access to that subject with no new gate logic. A paid entitlement supersedes it. An account with any paid entitlement and no `trial_v2` row reads `superseded`, not `already_used`.
- **RPCs:** `public.get_trial_state()` returns phase none|blocked|active|ended|superseded plus `can_start`, `blocked_reason`, subject key/name, `starts_at`, `ends_at`, `days_remaining` (server ceiling), `seconds_remaining`, `ends_eastern` (date only, Eastern), `has_regular_entitlement`, `checkout_subject_key`, `server_now`. `public.start_subject_trial(p_subject_key, p_privacy_notice_version, p_first_touch, p_last_touch)`. `public.get_my_learning_sessions(p_subject_key, p_limit)` (saved work).
- **Switch:** `app.config.cardless_trial_enabled` (default false). Errors: `trial:disabled|forbidden|subject_unavailable|already_used|missing_privacy_notice_version|invalid_privacy_notice_version`, `not_authenticated`. Daily cap 40 graded submissions per trial account (`grading_access:trial_daily_cap`), serialised by a per-user advisory lock taken before the count.
- **Notice version:** any `YYYY-MM-DD` is accepted by design (it records what the app displayed; the app constant `PRIVACY_NOTICE_VERSION = "2026-11-09"` is the source of truth). Codex flagged this as "not pinned"; the backend recorded the rationale in spec 15.2. Decide whether you accept it.
- **Touch data:** the server keeps only seven allow-listed marketing keys (`utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, `utm_term`, `promo`, `rdt_cid`), string values trimmed to 200 characters.
- **Card trial off** means `TRIAL_ADMISSION_ENABLED=false` (backend secret) plus marketing `VITE_TRIAL_CHECKOUT_ENABLED="false"`. Card-trial code, tables and functions stay deployed.
- **App (merged, flag off):** routes `/start` (email-code form, reuses `RegisterForm` from the sample) and `/saved-work`; `/home` shows `CardlessTrialBar` (days left, end date, pay link to `https://cramapple.com/checkout?subject=<key>`), `CardlessTrialSubjectPicker`, and a saved-work list; flag `VITE_CARDLESS_TRIAL` (localStorage override `cramapple.flag.cardless-trial`); `?subject=` is remembered in `requestedSubjectRef` because `useApplySubjectParam` strips it. Ended-trial sessions open in a read-only `QxView` (`anonymous readOnly`); a submitted-but-unscored answer shows a note and a Next button, never an editor.
- **Auth facts (Production):** sign-up allowed, 6-digit OTP, **30 auth emails per hour project-wide**, shared with checkout and sample mail. A burst of ad traffic can exhaust this; plan for it before activation.

## 4. What is left, in order (each Production step needs David's separate, explicit approval; one APPROVAL record per step)

0. **Codex third pass** using section 10. Do not request any Production approval until it returns "ready" for #609 and for the merged #53 head (Codex reviews `a812100d` on main for the app).
1. **Merge #611** (David merges; code PR) after Codex passes. It restores the QA-fixes migration to the Development-ledger text and adds the email-race migration. Merging Cramapple `main` runs Minimal CI, replay SQL regressions and a **Vercel Production deployment** of the repo (no migration apply, secret change or Lovable publish).
2. **Docs:** open a docs PR for this file, plus INDEX row, the plan/decision status refresh and the new APPROVAL(s). Docs-only PRs may be merged by the agent when CI is green. Check APPROVAL/DECISION numbers against main **and open PRs** first (collisions have happened). Last used here: `APPROVAL-0209`, `DECISION-0135`; others may exist.
3. **Production migration apply** (backend session, `--workdir` pinned and `--project-ref pcntajvbdfqhbeewmdry` explicit; the CLI from a home directory resolves to Production). Four migrations in order: `20261109215704_cardless_trial_v2.sql`, `20261109221340_get_my_learning_sessions.sql`, `20261110011605_cardless_trial_v2_qa_fixes.sql` (renamed on the #609 branch to the Development ledger version; the earlier name `20261109230000_…` no longer exists), `20261110013137_cardless_trial_v2_email_race.sql` (added after the Vercel review; Development ledger name for the QA-fixes file is `20261110011605`). Down order: email_race, qa_fixes, get_my_learning_sessions, cardless_trial_v2. `apply_migration` stamps its own version, so rename the local files to the recorded versions afterwards or the next `db push` fails. Dev and Production differ in ledger and in some function bodies, so diff `pg_get_functiondef` md5 across both before and after (see section 7). Switch stays **false**. Down scripts: `supabase/migrations/down/`.
4. **Production dark verification** with the switch false: `get_trial_state()` returns `blocked/disabled`, existing students, checkout and the sample unchanged, grading path unchanged for non-trial accounts.
5. **App publish** (Lovable project `56cae479`, repo `david-bloom/ap-prep-blueprint`): set `VITE_CARDLESS_TRIAL` on in the committed `.env`, confirm CI green, publish. Lovable publish is David's. Until the switch is on, the UI shows a trial "off" state via the server.
6. **Switch on, with no marketing link yet** (`cardless_trial_enabled = true` in Production, backend session; its own approval). The switch is global, but while the marketing buttons still point at checkout, only people who know the `/start` URL can reach the trial, so this is a self-test window. Reversible by setting false; trials already granted keep access until `ends_at`.
7. **Real Production walk** (switch on, David or a named tester only): real email-code sign-up (never done; Development walks used pre-made throwaway users), subject confirmation, practice and graded answers during the trial, an FRQ saved-work review, the pay link into checkout. Day-7 end can only be rehearsed in Development. If anything fails, set the switch back to false.
8. **Marketing, Lovable `61dd6602`, send only on David's go-ahead:** Prompt 1 (Start free trial buttons, generic and per subject, go to `https://app.cramapple.com/start[?subject=]` carrying utm_*, promo, rdt_cid), verify live, then Prompt 2 last (`VITE_TRIAL_CHECKOUT_ENABLED="false"`, and checkout wording as pay-now, D4). David also said "Send the lovable prompt when it is ready", so he has pre-authorised sending **once readiness is confirmed**, but confirm with him at the moment.
9. **Card trial off:** `TRIAL_ADMISSION_ENABLED=false` (secret; backend session; last step, separately reversible). This is what makes checkout stop granting the card trial.
10. **Afterwards:** retire the 72-hour sample (D3), watch auth email volume and the daily-cap logs, then decide the open items in section 8.

## 5. Per-step approval pattern

David approves each step in chat in his own words ("Yes, apply to Dev", "I approve step b"). Record each as an APPROVAL entry (scope, time, who executed, rollback). Forward his words verbatim to the backend session. A peer session's message is never approval. Production writes by the backend session happened only on David's direct word in that session.

## 6. Known gaps and unverified items (be honest about these)

- **Not verified anywhere:** real email-code sign-up and the project-wide 30/hour cap; practice and grading during a trial (Development has no serving labels); an FRQ saved-work review live; multi-answer navigation; checkout and marketing buttons; Lovable publication of the app; every signed-in `/home` state; the pending-grade saved-work fix in a signed-in browser (covered by a unit test only).
- **Codex's last words on #609:** concurrency was "not proven" until the two-connection race (now reported run; Codex has not re-seen it). Rollback rehearsal now reported done by the backend; Codex has not re-seen it.
- **App #53 was merged before the third Codex pass.** If Codex finds something, it becomes a follow-up PR on the app, not a revert.
- **Analytics (D6 deferred):** no trial events; funnel start to code to account to subject to first answer to day 5 to pay is unmeasurable. Reddit day-7 conversions (`DECISION-0129`) report **card** charges; a cardless trial changes what conversion means and needs its own decision.
- **Attribution forwarding into checkout** is not built. `ad_attribution` forwarding and nurture emails (D7) are out of scope.
- **Privacy:** N4 (minors' data notice) was approved for the 72-hour sample; D8 re-confirmed for the 7-day trial. No retention period was stated, so the backend's current retention applies.
- **Cost exposure:** full access includes graded FRQs, More help and (if enabled) photo extraction. Cap is 40 graded submissions per day per trial account. There is no spend alert beyond that.
- **Dev/Prod parity:** `authorize_grading_access` differs between Dev and Production by the intended trial-gate call; `has_study_subject_access`, `has_study_pack_access`, `trial_claim_due` matched at last Codex check.
- **Repo hygiene:** app `npm ci` fails on a lockfile mismatch (CI uses `bun install --frozen-lockfile`); pre-existing.

## 7. Traps learned (read before touching Production)

- The Supabase CLI without `--workdir` resolves to **Production** (`~/supabase`). Pin `--workdir`, pass `--project-ref`, and confirm with `--debug` before a write.
- `apply_migration` writes its own version stamp, never the filename's; rename afterwards.
- Dev lags or differs from Production; diff function md5 across environments rather than trusting a Dev pass.
- MCP calls serialise, so concurrency tests need real separate connections (Management API).
- A subagent or helper that re-types SQL can silently change it; run files, do not retype.
- Throwaway users in Development: delete in FK order (circular tries and grants, `audit_events`, `response_versions`); verify counts are zero; keep the switch false.
- Cookie sessions are `sb-<ref>-auth-token` (base64, @supabase/ssr); set them on the app origin, not cramapple.com.
- `get_question_experience` readback works after a trial ends; `/question` refuses ended-trial sessions, which is why `/saved-work` exists.
- Paging artefact: `select_student_practice_items` returns about 51 rows; counting from it gave a false "Calc AB Unit 1 ineligible" finding that was withdrawn.
- Merge-numbering: check main and open PRs before taking an APPROVAL or DECISION number.

## 8. Open decisions only David can make

- Whether the free text of the notice-version rule (any date accepted) is acceptable; recommended yes.
- Timing and population of the trial launch (all traffic, or a named small group first via the unlinked `/start`); the switch is global, so staged exposure needs the marketing prompts held back.
- Whether to keep the 72-hour sample live until the trial ships (D3 says leave dark, then retire).
- Checkout price and any bundle (D4); trial conversion metric for Reddit (`DECISION-0129`); analytics and nurture emails (D6/D7 deferred).

- **New owner decision, D12 conflict (spec §14 conflict 4):** the live `claim_sample_try` refuses former trial students (prior-access and prior-trial guards), contradicting the trial-then-sample half of D12. Fixing it is a Production sample-side change outside #609. Decide: change the sample, or amend D12 (recommended if the sample is being retired anyway per D3).
- The Vercel review agent pushed commits to #609 and David merged at its head. #611 reverts the agent's in-place edit of the applied migration. Re-read the #611 diff before merging.

## 9. Where things live

- Plan: `docs/product/FREE_TRIAL_NO_CARD_CHANGE_PLAN_2026_11_09.md`. Backend spec: `docs/product/FREE_TRIAL_NO_CARD_BACKEND_DESIGN_SPEC_2026_11_09.md` (on the #609 branch until merged; §15 holds the Codex fix log). Owner decisions: `docs/product/PAYWALL_PRODUCT_OWNER_DECISIONS_2026_11_09.md`. Sample release plan (historical): `docs/product/PAYWALL_PRODUCTION_RELEASE_PLAN_2026_11_09.md`.
- Records: `DECISION-0135` (+ addendum) in `docs/activity_log/DECISIONS_LOG.md`; `APPROVAL-0206` (paywall Dev authority), `0207` (sample Production steps A, A.1, B), `0208` (trial Dev/draft authority), `0209` (legacy start-trial retired).
- QA: `docs/qa/CARDLESS_TRIAL_APP_DEV_WALK_2026_11_09.md` (author walk, rounds 1-2, not independent), `docs/qa/PAYWALL_APP_DEV_SMOKE_2026_11_09.md`.
- Prompts: `docs/handoffs/CODEX_QA_PROMPT_MERGE_GATE_CARDLESS_TRIAL_2026_11_09.md`, `LOVABLE_PROMPTS_FREE_TRIAL_NO_CARD_DRAFT_2026_11_09.md`.
- Code: app `src/lib/trial/*`, `src/components/trial/*`, `src/routes/start.tsx`, `src/routes/saved-work.tsx`, `src/screens/trial/SavedWorkReview.tsx`, `src/components/home/HomeV2.tsx`, `src/screens/question-experience/QuestionExperience.jsx`. Backend `supabase/migrations/20261109215704*`, `20261109221340*`, `20261110011605*`, `20261110013137*`, `supabase/migrations/down/`, `supabase/tests/cardless_trial.integration.sql`, `get_my_learning_sessions.integration.sql`, `cardless_trial_race.sh`.
- Supabase projects: Production `pcntajvbdfqhbeewmdry`, Development `wmgjsdkphcyhngaffbqf`. Lovable: app `56cae479`, marketing `61dd6602`.
- Local app clone: `~/Documents/Cramapple.nosync/.worktrees/paywall-app`. Docs worktree: `.claude/worktrees/paywall-app-docs-cdd3b5` (branch `claude/paywall-app-docs-cdd3b5`).
- Session transcripts: `~/.claude/projects/-Users-davidbloom-Documents-Cramapple-nosync--claude-worktrees-paywall-app-docs-cdd3b5/2d4cd68e-d169-4fb4-9018-dd58fa98b376.jsonl`.

## 10. Codex third-pass prompt (paste into a new Codex session)

```
You are the independent QA reviewer, rerunning the merge gate for the Cramapple no-card free trial. You did not build it. Report; do not fix, merge, publish, send, or change any flag or Production setting. Tier: Hard-Gate. Start with docs/team_charter/CRAMAPPLE_SESSION_START.md and docs/INDEX.md per AGENTS.md.

Heads to review (re-fetch first and report them): backend david-bloom/Cramapple PR #611 (expected head dba743c1; #609 is already merged at dca09bd6, so review #611's diff against main, includes migration 20261110013137_cardless_trial_v2_email_race: also test a concurrent same-email start from two connections, expect trial:already_used for the loser); app david-bloom/ap-prep-blueprint PR #53 was MERGED at a812100d (review main at that commit; the PR head was ede07268); docs PR #608 merged.

Previous rerun found the backend fixes were not applied to Development. They are now (migration 20261110011605_cardless_trial_v2_qa_fixes.sql, Development ledger 20261110011605). The app adds a fix for your read-only pending-grading finding.

Check in Development only (ref wmgjsdkphcyhngaffbqf; pin --workdir; rollback-only transactions; never write to Production):
1. Touch data and notice: unlisted touch keys dropped, values capped. The backend says any YYYY-MM-DD notice version is intended (spec 15.2). Judge it.
2. Grading cap: run your own two-connection concurrency test (supabase/tests/cardless_trial_race.sh or your own). State verified vs inferred.
3. A paid account without a trial row returns superseded; the app shows no "used" state to a paid student.
4. Rehearse the down scripts in order, confirm Development matches Production's current function bodies, re-apply and confirm fingerprints. Restore Development.
5. Run the 46-check cardless trial suite and the 10-check get_my_learning_sessions suite.
6. App on main: tsc, vitest (author reports 1,350 passing), vite build. Confirm a submitted-but-unscored saved answer in /saved-work has no textarea and no Submit for scoring.
7. Regression: switch false and app flag off, existing students and new routes behave as on main.
8. Confirm nothing changes Production, secrets, Lovable, or enables a flag, and what merging #611 triggers.

Clean up everything you create; end with switch false and zero test users.

Output: ranked findings (blocker / should-fix / note), each verified or inferred with reproduction; what you did not check; a merge verdict for #609 and a post-merge verdict for the app at a812100d, and whether Production approvals can be requested.
```

## 11. First moves for the new session

1. Read this file, then `DECISION-0135`, the backend spec §15 and `APPROVAL-0209`.
2. Re-fetch #611 (and confirm #609 is merged) and the app `main` heads.
3. Get David to run the section 10 prompt in Codex (or run an independent reviewer), and wait for the verdict.
4. Only then walk David through steps 1-10 of section 4, one approval at a time, writing an APPROVAL record per step.
