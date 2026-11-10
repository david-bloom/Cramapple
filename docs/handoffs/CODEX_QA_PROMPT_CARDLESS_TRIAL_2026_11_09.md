# Codex QA prompt: cardless 7-day one-subject trial, app + backend (2026-11-09)

Paste everything below the line into a new Codex session. The author does not QA its own work.

---

You are the independent QA reviewer for the Cramapple cardless 7-day, one-subject free trial. You did not build it. Report; do not fix, merge, publish, send, or change anything outside Development. Tier: Hard-Gate (entitlements, access control, payments adjacency, public pages, minors' data). Start with `AGENTS.md` and `docs/INDEX.md`; do not scan the repo broadly. Authority: `DECISION-0135` (+ addendum D9-D12), `APPROVAL-0208` (Development/draft only), `APPROVAL-0209` (legacy `start-trial` retired in Production: `CARDLESS_TRIAL_RETIRED=true`). No Production write of any kind; pin `--workdir` and the Development ref `wmgjsdkphcyhngaffbqf` for every Supabase CLI call.

## What to review
1. **App** (draft PR, `david-bloom/ap-prep-blueprint` #53, branch `claude/cardless-trial-app`): `src/lib/trial/cardless*.ts`, `src/components/trial/Cardless*.tsx`, `src/routes/start.tsx`, the edits in `src/components/home/HomeV2.tsx`, `src/routes/_ux.home.tsx` and `src/screens/question-experience/QuestionExperience.jsx`. All behind `VITE_CARDLESS_TRIAL=on` (default off).
2. **Backend** (Cramapple PR #609): `supabase/migrations/20261109221500_cardless_trial_v2.sql`, `supabase/tests/cardless_trial.integration.sql`, spec `docs/product/FREE_TRIAL_NO_CARD_BACKEND_DESIGN_SPEC_2026_11_09.md` (applied to Development as ledger `20261109215704`).
3. **Docs:** `docs/product/FREE_TRIAL_NO_CARD_CHANGE_PLAN_2026_11_09.md`, `docs/qa/CARDLESS_TRIAL_APP_DEV_WALK_2026_11_09.md` (author-run, do not trust), `docs/handoffs/LOVABLE_PROMPTS_FREE_TRIAL_NO_CARD_DRAFT_2026_11_09.md`.

## Known limits (confirm they are disclosed; do not re-report as new)
No real email-code sign-up was run; Development has no serving labels (the unit-gated queue is empty there); the daily cap, practice and grading during the trial were not exercised; the after-day-7 "Your saved work" list is built against `get_my_learning_sessions` (backend migration `20261109224500`, may not be applied to Development yet: check, and if it is, verify the list and that each link opens the saved session through `get_question_experience`); marketing buttons and checkout are unchanged and the Lovable prompts are unsent.

## Checks
**A. Contract fidelity.** App vs `get_trial_state` and `start_subject_trial`: field names, phases, typed errors (`trial:disabled|forbidden|subject_unavailable|already_used|missing_privacy_notice_version`, `not_authenticated`, `grading_access:trial_daily_cap`), idempotent replay and `replayed_other_subject`. The app must never count days or format dates itself; confirm.
**B. Access control (the core risk).** With a Development user: a trial row must admit exactly one subject and nothing else (serving, `attempt-response`, `evaluate-attempt`, More help, `get_study_subject_keys`, `student-session-items` for another subject), and deny everything after `ends_at` (use `ends_at`, never `status`; `trial_v1` rows are `status='active'` with past `ends_at`). Try to obtain a second subject, a second trial (same email in another casing/alias, second account), a subject change after confirming (D9), or an extended `ends_at`. Confirm cardless rows can never be charged or extended by `charge-due-trials`, `trial_claim_due` or the sweep, and that the sample supersede trigger behaves as intended. Confirm the grading daily ceiling (40) and its denial.
**C. Legacy path.** `start-trial` in Production returns `410 trial_retired` (read-only unauthenticated POST) and nothing in the app or marketing calls it; Development too.
**D. Registration and data.** `/start` (404 with the flag off): email code with `shouldCreateUser:true`; what is stored (`acquisition_profiles`, email hash, `trial_consumed_emails`), allow-listed marketing parameters only, privacy notice version = the notice's date; Terms/Privacy notice shown at the point of collection; minors' data review against `DECISION-0135` D8. Abuse: auth email cap is 30 per hour project-wide and shared with checkout mail; what happens when it is hit.
**E. UI.** `/home` for each state (none/picker, active, ended, already used, disabled, superseded) at 375px and desktop, keyboard and focus, no horizontal overflow, no copy that says "card", "charged" or a price. Confirm the ended state is honest: it says saved work is still readable, and the "Your saved work" list links only sessions with `readable=true` and answers; a session of another subject must not appear.
**F. Shared-code safety.** The edits in `QuestionExperience.jsx` (`submitFailureMessage`) and `HomeV2.tsx`/`_ux.home.tsx` must not change behavior for any account when the flag is off, and for non-trial accounts when it is on. Run `tsc`, `vitest`, `vite build`.
**G. Rollback.** Switch off (`app.config.cardless_trial_enabled=false`) returns `trial:disabled`/`blocked`; existing trials keep access until `ends_at`; the card trial path is untouched. Rehearse in Development only.
**H. Docs vs reality.** Every claim in the walk record: verify or mark unverified.

## Output
Ranked findings (blocker / should-fix / note), each verified or inferred, with reproduction and `file:line`; what you did not check; one verdict for the app PR, one for the backend PR, and one release verdict (ready to request Production approvals / not ready, shortest list of what remains). Separate missing build scope from defects.
