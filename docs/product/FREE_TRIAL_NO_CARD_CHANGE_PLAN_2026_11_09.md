# Free trial without a card: change plan (DRAFT, 2026-11-09)

**Status:** DRAFT for owner approval. **Nothing here is built, approved for build, deployed or released.** Tier: Hard-Gate (entitlements, access control, payments adjacency, public pages, minors' data).
**Source:** David Bloom, in chat on 2026-11-09 (words below are his).
**Related:** `docs/tasks/TASK-0026-SEVEN-DAY-TRIAL-AND-ENGAGEMENT-PROGRAM.md` (the earlier cardless 7-day trial, retired), `DECISION-0126` (seven-day card trial; item 12 retired the cardless trial), `DECISION-0134` and `PAYWALL_CHANGE_PLAN_2026_10_31.md` (the 72-hour sample), `APPROVAL-0207`.

## 1. What David decided (verbatim)

- "the current experience is the free trial without card. We should preserve the free trial with card for possible future use but it is not active."
- "7 days full access but for a specific subject the student selects."
- Account timing: "Email code on landing."
- The experience: a student lands on cramapple.com and clicks "Start free trial" and lands on `app.cramapple.com/home`, prompted to select their subject. `/home` shows the number of days remaining in the trial and a prompt to pay that links to checkout. Students are prompted to pick a subject to continue the free trial. A student who clicks "Start free trial" on a subject landing page arrives on the student hub with the subject already confirmed.

## 2. How this relates to what already exists

| Existing | Status today | Effect of this plan |
| --- | --- | --- |
| Seven-day **card** trial (`DECISION-0126`, `TASK-0077`): card saved at checkout, charge on day 7 | Live in Production; every checkout gets it | **Preserved but made inactive** behind a switch. Code, tables and functions stay. "Start free trial" no longer goes to checkout. |
| Cardless 7-day trial (`TASK-0026`: `access_tier='trial'`, `app.start_trial`, `start-trial` function, Loops program) | **Retired** by `DECISION-0126` item 12; `trial_v1` rows count as a used trial | **Revived**, changed to **one chosen subject**, not every subject. Needs a new decision that partly supersedes `DECISION-0126` items 1 and 12. |
| 72-hour sample (`DECISION-0134`, `APPROVAL-0207`): 8 MCQs + 1 FRQ, one unit, live behind a hidden link | Switches on in Production, hidden link, no real users yet | **Superseded by this plan once it ships**; recommended to leave dark until then (see decisions). |
| Email-code registration without checkout | Built and verified in a mock only (app PR #52); Production Auth confirmed to allow OTP sign-up | **Reused** as the landing step. |
| Checkout | Shows card-trial wording; Phase 0 found "$39.99 due today" on first paint | Becomes a **pay-now** purchase while the card trial is inactive. Needs a marketing change. |

The earlier cardless trial is the precedent: one `subject_entitlements` row per subject with `access_tier='trial'` and `ends_at = start + 7 days` already gives full access through the existing gates (`authorize_grading_access`, subject access, serving) with no new gate logic. That is the cheapest design and the recommended one; the sample's special gates are not needed for the new trial.

## 3. Target journey

1. **Entry A (generic):** cramapple.com, "Start free trial" -> `app.cramapple.com` start step: email, 6-digit code, account created (no card, no checkout) -> `/home` with a **"Pick your subject"** prompt. The trial clock starts when the subject is confirmed (recommended, see decision D1).
2. **Entry B (subject page):** a subject landing page, "Start free trial", carries the subject -> same email-code step -> `/home` (the student hub) with that **subject already confirmed** and the trial started.
3. **`/home` always shows:** "N days left in your free trial" with the end date and time zone (server timestamp), and a **pay prompt** that links to checkout for the confirmed subject. Before a subject is chosen it shows "Pick a subject to start your 7 days" instead of a counter.
4. **During the trial:** full access to the one chosen subject, as a paying student has. Other subjects are locked with the pay prompt.
5. **Day 7:** access to the subject ends; saved work stays readable; the pay prompt is the way forward (D2).
6. **Pay:** checkout buys the subject (pay-now while the card trial is inactive); a paid entitlement supersedes the trial.

## 4. Changes by system

**Backend (owned by the backend session; Development first):** revive `app.start_trial` as a single-subject call (`p_subject_key`); one trial per student email (and the `trial_v1` and card-trial history counts, D6); `ends_at = start + 7 days`; return `days_remaining`, `ends_at` and `subject_key` in the status the app reads (extend `get-trial-status` or a new read); keep the card-trial functions deployed but unreachable (switch off); decide how `charge-due-trials` and the sample's supersede trigger treat cardless `trial` rows (they have no order, so they must never be charged); add the subject-confirm step (the entitlement is created at confirmation, not at sign-up, if D1 is accepted).
**App (this session, behind a flag, draft PRs):** a start step (reuse the email-code form and Terms/Privacy notice); `/home` subject prompt, days-remaining element and pay prompt; subject-aware arrival (`?subject=`); remove the sample's special gating from the new path; keep `/sample` dark.
**Marketing (Lovable prompts, drafted after approval, sent only on David's go-ahead):** "Start free trial" destinations (generic and per subject) to the app start step with attribution (UTM, promo, click id) carried; `/checkout` as pay-now with no "Total due today" confusion while the card trial is off.
**Analytics and email:** `trial_started` (existing event) with the chosen subject; funnel start -> code sent -> account -> subject confirmed -> first answer -> day 5 -> pay. Day-7 Reddit conversions (`DECISION-0129`) report **card** charges today; a cardless trial changes what "conversion" means and needs its own decision. The Loops lifecycle program (D7) is still open.

## 5. What can be reused from the sample work

The email-code registration form and its error handling; the Terms/Privacy notice; the confirmed Production Auth facts (sign-ups allowed, 6-digit OTP, "Confirm sign up" email carries the code, **30 auth emails per hour project-wide**, shared with checkout mail); the live question-page adapter; the typed-refusal handling pattern. The sample's units, allowances and claim step are **not** reused.

## 6. Decisions needed from David (recommendations given)

| # | Question | Recommendation |
| --- | --- | --- |
| D1 | When does the 7-day clock start: at account creation, or when the subject is confirmed? | When the **subject is confirmed**, so a student who signs up and leaves does not burn days. |
| D2 | What happens at day 7? | Subject locks, saved work stays readable, pay prompt shown; no grace (grace belonged to the card trial). |
| D3 | What happens to the live 72-hour sample? | Leave dark and unlinked, retire after the trial ships. |
| D4 | Checkout while the card trial is inactive: pay-now at the current price, per subject? | Yes; confirm the price and whether a bundle is offered. |
| D5 | Spend: "full access" includes graded FRQs, More help and (if enabled) photo extraction. Cap them, or accept uncapped use for 7 days? | Accept uncapped but add an alert and a per-account daily ceiling as an abuse guard. |
| D6 | One trial per student email: do earlier `trial_v1` and card-trial emails count? | Yes, both count (consistent with `DECISION-0126` item 12). |
| D7 | Nurture emails and the experiment (D6/D7 of the paywall plan) | Out of the first release. |
| D8 | Minors' data: the earlier collection point was approved for the 72-hour sample (N4). Does that approval cover a 7-day full-access trial? | Re-confirm in one line. |

## 7. Phases and gates

0. This plan reviewed; D1 to D8 answered; a new `DECISION` records the supersession of `DECISION-0126` items 1 and 12 and the card-trial switch-off; an `APPROVAL` for Development build.
1. Backend design spec from the backend session (no build until approved).
2. Development build: backend, app, marketing prompts as drafts. No Production change.
3. Independent Codex QA, then a Development walk with a real sign-in.
4. Production: one approval per step (migration, function deploy, switch, Lovable publish), each separately reversible; the card trial is switched off only at the last step.

**Rollback:** the card-trial path stays deployable; turning the new trial off and the card trial back on restores today's behavior. Trials already granted keep their access until `ends_at`.
