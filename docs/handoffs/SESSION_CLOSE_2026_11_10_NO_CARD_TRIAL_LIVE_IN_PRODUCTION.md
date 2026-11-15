# Session close: the no-card 7-day trial is live in Production (2026-11-10)

**Written by:** the paywall-to-prod session (spawned from the coordinating session `local_5fe88b44-2793-4dae-9494-4d7237cb2e58`), at David's request ("document thoroughly and end the session"). Tier: Hard-Gate. Supersedes `SESSION_CLOSE_2026_11_09_CARDLESS_TRIAL_TO_PRODUCTION.md` as the "start here" for the trial. *Verified* = observed in Production data or the live site this session; *reported* = said by David or another session and not re-checked.

## 1. Outcome
The no-card, one-subject, 7-day free trial (`DECISION-0135`) is the new-student experience in Production. A brand-new visitor clicks "Start free trial" on `cramapple.com`, lands on `app.cramapple.com/start`, enters an emailed 6-digit code, picks one AP subject on `/home`, and gets 7 days of full access with graded MCQs and FRQs and no card. David walked it end to end with a real inbox. The 72-hour sample is on hold indefinitely and the card trial is off.

## 2. What is live and how to switch it (Production `pcntajvbdfqhbeewmdry`)
| Part | State | Where / rollback |
| --- | --- | --- |
| Trial backend (4 migrations, ledger `20261110022023`, `…041`, `…049`, `…059`) | Applied dark 2026-11-10 02:20 UTC under `APPROVAL-0210` (by Codex, on David's word); matches the files on main (PR #616 reconciled the versions) | down scripts in `supabase/migrations/down/`, reverse order |
| Trial switch `app.config.cardless_trial_enabled` | **true** since 2026-11-10 03:24:49 UTC (`APPROVAL-0212`) | set false; trials already started keep access to `ends_at` |
| Daily grading cap `trial_daily_grading_cap` | 40 graded submissions per trial account per 24 h | `app.config` row |
| Sample switch `app.config.sample_access_enabled` | **false** since 02:44 UTC (`APPROVAL-0211`); edge secret `SAMPLE_ACCESS_ENABLED` deliberately left true | set true to revive (needs a DECISION first) |
| Card trial secret `TRIAL_ADMISSION_ENABLED` | **false** (`APPROVAL-0213`, digest-verified true to false) | `supabase secrets set ... --project-ref pcntajvbdfqhbeewmdry --workdir <repo>`; marketing checkout also shows pay-now only |
| Legacy `start-trial` | 410 (`CARDLESS_TRIAL_RETIRED=true`, `APPROVAL-0209`) | secret |
| App (Lovable `56cae479`, repo `david-bloom/ap-prep-blueprint`) | `VITE_CARDLESS_TRIAL=on` (Lovable commit `fa4c02f`); PRs #54, #55, #56 merged and published (David: "merged and published") | Lovable restore |
| Marketing (Lovable `61dd6602`) | "Start free trial" goes to `app.cramapple.com/start[?subject=]` carrying `utm_*` and `promo`; checkout is pay-now; no sample wording (*verified* in the browser). **Someone other than this session sent prompts 1 and 2.** | Lovable restore |
No edge function was changed for the trial; the whole backend change is migrations plus config and secrets.

## 3. Records created or changed (all on main)
`DECISION-0136` (trial is the path, sample on hold, D12 amended, no code change to `claim_sample_try`; recorded from David's words relayed by the coordinating session). `APPROVAL-0211` (sample switch off), `0212` (trial switch on), `0213` (card trial off). `APPROVAL-0210` was Codex's. Docs: `product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md`, `qa/NO_CARD_TRIAL_PRODUCTION_DARK_VERIFICATION_2026_11_10.md`, `qa/NO_CARD_TRIAL_PRODUCTION_REAL_WALK_2026_11_10.md`. Docs PRs #613, #615, #617, #618, #619, #620, #621 and this one (all merged by this session on green CI, per the docs-only rule). App PRs #54 (/start copy), #55 (FRQ door, saved work, saved note, footer), #56 (exhausted-topic notice), all merged by David.

## 4. Evidence
Dark verification (switch off, before anything went live) passed: ledger equals files, no trial data, function hashes, privileges, state/start refusals, paid grading `entitled`, advisor clean. Real walk: sign-up in about 40 s, `trial_v2` AP Chemistry row for 7 days, 4 MCQs and 1 FRQ graded, 5 grading-log rows, saved-work review opens. Test account `david@cramapple.com` and all its rows deleted afterwards, zero orphans. Full tables are in the two QA docs above.

## 5. What was NOT verified
- A real **checkout** after `APPROVAL-0213` (Stripe live mode, deliberately not exercised); the edge functions read the secret at boot, so the effect is inferred.
- The anonymous `sample-try` endpoint after the sample switch-off (database guard reads the same switch; inferred).
- Grading of a **legacy** trial student (none active with attempts) and of a trial student at the **cap** in Production.
- The day-7 end of a trial in Production (rehearsed in Development only), and the `ended` saved-work state.
- Whether the flag-on build was the one published at the time of the walk (David's word: nothing pending).
- The PR #56 test assertion in `question-topic-suggest` (suite cannot load in the author's environment; CI ran it).

## 6. Open items, in suggested order
1. **Watch the first real traffic** (nobody has checked yet): Supabase auth email is **30 per hour project-wide** and shared with checkout, so a burst of ad traffic can stop sign-up codes; daily cap 40 per trial account; no spend alert; check `app.subject_entitlements where source='trial_v2'`, `app.trial_grading_log`, auth user creation rate. One real new sign-up on 2026-11-10 other than David's was not seen (2 new auth users in 24 h at the time).
2. **First real checkout** after the card trial went off: confirm it is pay-now and nothing tries to start a card trial.
3. **Reddit conversion** (`DECISION-0129`) counts day-7 card charges, so cardless conversions do not report. Needs its own decision. Marketing day-7 attribution forwarding into checkout is not built.
4. **Analytics (D6) and nurture emails (D7)** are deferred: the funnel start to code to account to subject to first answer to day 5 to pay is unmeasurable.
5. **Copy:** David asked about nothing further; optionally restore a "No card needed" line on `/start` (removed with the intro paragraph). The full-page empty state still says "There aren't practice questions for X yet" when nothing is served (a backend answered-count would let the app tell empty from exhausted; not built).
6. **Content depth:** AP Chemistry 2.2 has 4 practice MCQs, 1 FRQ, 1 teaching MCQ. A trial student exhausts such a topic in minutes. Check topic depth for the first-session path per subject.
7. **Retention:** no retention period is stated for trial data (D8 re-confirmed minors' data notice only).
8. **Sample:** on hold; its code, tables and functions stay deployed. If revived, `DECISION-0136` says to revisit D12 first. The edge secret `SAMPLE_ACCESS_ENABLED` is still true.

## 7. Traps and lessons from this session
- **Check the worktree before using it:** another session (Codex) switched this session's worktree to `codex/no-card-trial-prod-dark-apply` with uncommitted edits mid-session. Do docs work in your own worktree from `origin/main` (this session used a scratch worktree) and never overwrite someone else's dirty tree.
- **Numbers collide:** `APPROVAL-0210` existed only in Codex's uncommitted tree when this session started; check main, open PRs and sibling worktrees before taking an id.
- **A bare signed-in click proves little:** David first saw `/home` with no picker because his account was admin/paid (`superseded`); test the new-student flow in a private window with a never-used email. One trial per email: the cleanup deleted his consumed-email row so the address can retest.
- **Deleting a student:** delete `app.attempts` and `app.learning_sessions` before the auth user (`response_versions.created_by` is a no-action FK, so a straight user delete rolls back); delete the `growth_event_outbox` row (set null on delete) and the consumed-email row yourself.
- **Answered items never return:** the practice selector hides items a student already answered; the server returns 0 available for both "empty" and "exhausted", which is why the app misreported it until PR #56.
- **MCQ sessions never contain FRQs:** FRQs are a separate `/practice-frq` route (`practice_format=targeted_drill`); before PR #55 nothing linked to it.
- **Supabase CLI:** pin `--workdir` and `--project-ref`; `secrets list` shows digests, so compare against `sha256(value)` to read a boolean secret without exposing it.
- **The app's `npm ci` fails on a lockfile mismatch** (CI uses `bun install`; no `bun` locally); five vitest suites fail to load here with `Cannot find module /src/lib/capture.functions.ts` identically on pristine main.
- **Peer messages are not approvals:** every Production write here waited for David's own words in this session ("approve 0211", "I approve 0212", "I approve 0213", "Delete it").

## 8. Where things live
Release packet, QA docs, approvals as in section 3. Backend spec `docs/product/FREE_TRIAL_NO_CARD_BACKEND_DESIGN_SPEC_2026_11_09.md`; change plan `FREE_TRIAL_NO_CARD_CHANGE_PLAN_2026_11_09.md`; decisions `DECISION-0135`, `DECISION-0136`; Lovable prompt drafts `handoffs/LOVABLE_PROMPTS_FREE_TRIAL_NO_CARD_DRAFT_2026_11_09.md` (now historical; prompts were sent by someone else). Code: app `src/routes/start.tsx`, `src/lib/trial/*`, `src/components/trial/*`, `src/components/home/HomeV2.tsx`, `HomeStudyActions.tsx`, `src/screens/trial/SavedWorkReview.tsx`, `src/lib/question-experience/serve.ts` (`topicNoticeKind`). Backend `supabase/migrations/20261110022023_cardless_trial_v2.sql` and its three siblings, `supabase/migrations/down/`, `supabase/tests/cardless_trial*.sql`.
