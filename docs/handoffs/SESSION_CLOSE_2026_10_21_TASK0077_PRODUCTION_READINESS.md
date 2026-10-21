# Session Close — TASK-0077 Production Readiness (2026-10-19 to 2026-10-21)

**Task:** `TASK-0077` seven-day card trial. **Tier:** Hard-Gate. **Product Owner:** David Bloom. **Closed at David's request.**
**Read with:** `docs/tasks/TASK-0077-PRODUCTION-RUNBOOK.md` (what to run next) and `docs/tasks/TASK-0077-SEVEN-DAY-CARD-TRIAL.md`
(full QA and deploy history). A second session closed the same day:
`SESSION_CLOSE_2026_10_20_TASK0077_TRIAL_QA_SANDBOX_AND_LOOPS.md` (Loops, templates, American spelling).

## Where things stand

- **Code:** all merged. Cramapple PR #507 → release commit **`3616edff`** (its functions are identical to `43440c98`, which Codex
  signed off with no findings). App: ap-prep-blueprint #37, #38, #39 merged, app `main` = `c0c0f2d`, **not published**.
  Marketing Lovable `61dd6602` holds the trial checkout plus the 2026-10-20 fixes (`f9a5e637`), **not published**, gated by
  `VITE_TRIAL_CHECKOUT_ENABLED` (unset).
- **Development:** QA rounds 3–5 deployed (migrations `20261020224101`, `20261020233210`, `20261020235937`); trial admission,
  charges and notices **on** in Stripe test mode; workers scheduled.
- **Production:** **nothing deployed.** Pre-flight steps 1–5 of the runbook passed on 2026-10-20/21 (results in the runbook).
  Production also lacks the Loops email foundation (TASK-0060), which the runbook ships first.
- **Codex:** four review rounds in this session (`0b6301f2`, `fb1ace39`, `cfbd59b1`, `43440c98`); F1–F7 fixed and closed. Codex's own limit: code and local-test sign-off, not the hosted
  rollout or launch gates.

## What this session did

1. **Readiness audit.** Found Production behind `main` (no Loops outbox, no email worker), that `main`'s webhook throws on unknown
   event types (so the five new Stripe live events go on only after the new webhook), and that the parent's only cancel path is
   the Loops trial-started email.
2. **Marketing checkout fixes** (Lovable `f9a5e637`): promo in trial mode, frozen checkout on a failed quote, card-form wording,
   `409 trial_required`, return-page polling. Verified on the preview against Development.
3. **Sandbox journeys on Development:** 3D Secure (F), dispute (G), signed-in Account cancel (D) passed; late setup (H) failed and
   led to the round-3 fix; recovery-page count checked live (J, round 4) and per-event dedupe checked in the database (round 5).
4. **Fixes for Codex's reviews** of `0b6301f2`, `fb1ace39` and `cfbd59b1` (`43440c98` came back clean): completed-session restart, late setup cleanup, refusal cleanup, day-7
   access gap, notice retries (stored payload), cleanup race, recovery attempts counted per failed Stripe event, once per event.
5. **App PR #39:** recovery Payment Element mounted with `wallets.link = "never"` (proved on a sandbox probe that Link was the
   source of Bank, Klarna and "fast checkout").
6. **Housekeeping:** cancelled Development orders `a80f04cc`, `e7fa3ec1` (no emails to the e2e inboxes); branch cleanup in both
   repos; PR #508 landed stranded records (the Production-applied `20261010160000` migration, APPROVAL-0151, DECISION-0114,
   APPROVAL-0163 close); runbook written (`docs/tasks/TASK-0077-PRODUCTION-RUNBOOK.md`).

## Corrections made during the session

- I first reported "235 passed" for the CI Deno command; my copy left out two test files. The full command ran 252 at
  `fb1ace39`, now 255. Recorded in the task record.
- I first wrote "five" trial migrations for Production; it is six. I first wrote 20 `LOOPS_TRIAL_*` ids; it is 19 plus the
  parent trial request. Both corrected in the runbook.

## Waiting on David

- Decisions **D1–D5** in the runbook (D1: no per-person admission allowlist exists, so the $1 live trial is effectively the launch).
- Stripe live: **Save** the Terms/Privacy URLs on Public details; turn on **Radar for saved payment methods**.
- Production first sign-in with a brand-new account (code email).
- Lawyer review of the trial Terms, mandates (`trial-mandate-v4`) and notice emails, or a decision to launch without it.
- Confirm the Loops templates live in the same workspace as Production's `LOOPS_SECRET_KEY`.

## Loose ends

- Two live `checkout.session.expired` events from 2026-10-06 sit `failed` in Production's webhook ledger (no customer effect,
  cause unknown); the runbook's step 3.6 checks the new webhook processes an expiry.
- Development only: Stripe's return URL drops `backend=dev`, so a fresh-tab return page asks Production.
- Marketing: no "finishing your trial" message for `409 trial_setup_completing` yet (runbook step 5.1 option).
- ap-prep-blueprint `qa/ascii-math-*` branches (TASK-0075) kept for David's call. An empty untracked file named `-` sits in
  `/Users/davidbloom/Documents/Cramapple-trial-impl` (not made by either trial session).
- Account deletion is blocked while a learner has any trial order (needs design).

## Prompt for the next session

```text
Start a Cramapple session to take the TASK-0077 seven-day card trial to Production.

Read first, in this order:
1. docs/team_charter/CRAMAPPLE_SESSION_START.md
2. docs/tasks/TASK-0077-PRODUCTION-RUNBOOK.md   (the plan you will execute; every step marked ⛔ needs my approval at the time)
3. docs/handoffs/SESSION_CLOSE_2026_10_21_TASK0077_PRODUCTION_READINESS.md
4. docs/tasks/TASK-0077-SEVEN-DAY-CARD-TRIAL.md  (history; read the "Production rollout" and "Codex sign-off" sections)

State on 2026-10-21: all code merged (Cramapple release commit 3616edff; app main c0c0f2d). Nothing is on Production.
Pre-flight passed. Production is project pcntajvbdfqhbeewmdry; always pass --project-ref and --workdir to the CLI.

Before doing anything on Production:
- Re-run the runbook's pre-flight (section 1) and stop if anything differs from what it records.
- Ask me for decisions D1–D5 and for the status of preconditions 0.4–0.7 (Stripe Save + Radar, Production first sign-in,
  lawyer review, Loops workspace). Do not assume earlier answers.
Then walk the runbook one step at a time, asking for approval before each ⛔ step, recording each result (and each
Production migration version) in the runbook and task record as you go.
```
