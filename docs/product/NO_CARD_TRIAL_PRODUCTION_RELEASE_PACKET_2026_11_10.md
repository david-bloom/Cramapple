# No-card trial: Production release packet (steps 1–2 executed, 2026-11-10)

**Status:** Production dark migrations and verification executed under `APPROVAL-0210` (2026-11-10 02:20–02:23 UTC). `cardless_trial_enabled=false`; no trial access granted. App publish, switch activation, marketing, card-trial cutover and sample retirement remain separate, unapproved steps. The pre-apply table below is historical evidence; see §0a for live post-apply state. Every further step needs David's explicit chat approval and its own APPROVAL record; check main and open PRs before numbering.
**Tier:** Hard-Gate (entitlements, access control, payments adjacency, public pages, minors' data).
**Scope:** take the no-card 7-day single-subject trial (`DECISION-0135`) from Development to Production as the default new-student experience. Companion to `handoffs/SESSION_CLOSE_2026_11_09_CARDLESS_TRIAL_TO_PRODUCTION.md` (state, traps, Codex prompt) and `product/FREE_TRIAL_NO_CARD_CHANGE_PLAN_2026_11_09.md`.
**Labels:** *verified* = observed read-only on 2026-11-10; *reported* = from the handoff.

## 0. Pre-apply readiness (verified 2026-11-10)

| Item | State |
| --- | --- |
| Production ledger | Only the three sample migrations (`20261109155919`, `20261109155941`, `20261109174046`). None of the four trial migrations; no `get_trial_state`, `start_subject_trial`, `get_my_learning_sessions`; no `cardless_trial_enabled` row. |
| Development ledger | Sample plus all four trial migrations (`20261109215704`, `20261109221340`, `20261110011605`, `20261110013137`). `cardless_trial_enabled=false`, `trial_daily_grading_cap=40`. |
| Backend code on `main` | Migrations plus down scripts and tests merged (#609, #611). **No edge function changed**, so no function deploy is needed (diff of `supabase/` across both merges is migrations, `down/` and `tests/` only). |
| Migration anchor check on Production | `app.authorize_grading_access` has exactly one bare `return 'entitled';` anchor, contains the sample branch (`app.sample_grant_phase(v_grant)`), and is not yet patched. Pre-existing prerequisite tables present: `acquisition_profiles`, `growth_event_outbox`, `home_release_manifest`, `trial_consumed_emails`; helper functions `trial_email_consumed`, `trial_email_hash`, `normalize_student_subject_key` present. `app.trial_grading_log` is created by the migration. No `trial_v2` entitlements exist. So the by-anchor patch will apply. |
| Production data context | 21 `access_tier='trial'` rows (legacy trial_v1 / card trials), 3 active paid entitlements. These are untouched; the migration only adds `trial_v2` semantics. |
| Sample | Production `sample_access_enabled=true` (hidden link). Development false. |
| App `main` | Trial UI behind `VITE_CARDLESS_TRIAL` (absent from `.env`, so off); `VITE_SAMPLE_JOURNEY=on`. Lovable publish state of this code: unverified. |
| Independent QA | Completed before `APPROVAL-0210`: 46 trial checks, 10 saved-work checks, two real concurrency races, four-file down/up rehearsal, app TypeScript, 1,350 tests and build. Full evidence in the approval record. |

### 0a. Executed Production dark apply (`APPROVAL-0210`)

David's words: “I approve applying the four no-card trial migrations to Production with the trial switch kept off.” Codex applied the four repository SQL file bodies via Supabase `apply_migration` to explicit Production project `pcntajvbdfqhbeewmdry`; only the outer transaction wrappers were removed for the tool. The connector stamped these Production ledger versions, and the follow-up PR renames the files accordingly:

| Migration | Development ledger | Production ledger |
| --- | --- | --- |
| `cardless_trial_v2` | `20261109215704` | `20261110022023` |
| `get_my_learning_sessions` | `20261109221340` | `20261110022041` |
| `cardless_trial_v2_qa_fixes` | `20261110011605` | `20261110022049` |
| `cardless_trial_v2_email_race` | `20261110013137` | `20261110022059` |

Post-apply: switch false, cap 40, `blocked/disabled` for a fresh ID, zero `trial_v2` grants/hashes/log rows, all three RPCs present, paid grading still `entitled`. `has_study_subject_access`, `has_study_pack_access`, and `claim_sample_try` retain their pre-apply MD5s. The expected security-advisor notices and rollback order are in `APPROVAL-0210`. Development's ledger remains at its earlier versions; `DECISION-0128` prohibits `db push` on both environments and calls for catalog checks instead of ledger parity.

## 1. Order of steps, scope, checks, rollback

Rule across all steps: apply backend before publishing the app (the 2026-11-04 sign-in spinner was a publish ahead of its backend). Switch stays false until step 5.

### Step 1: Production dark migration apply — DONE (`APPROVAL-0210`)
- **Does:** applies the four migrations in order via `apply_migration` (or CLI with `--workdir` pinned to the repo and `--project-ref pcntajvbdfqhbeewmdry`, confirmed with `--debug` before writing). Executed by the backend session, run the files verbatim (never retype SQL).
- **Effect:** adds `trial_v2` functions, `app.trial_grading_log`, config rows (`cardless_trial_enabled=false`, `trial_daily_grading_cap=40`), grading gate patch. No student-visible change while the switch is false; non-trial accounts follow the old path.
- **Pre-checks:** re-run the anchor query in section 0 immediately before; confirm ledger still lacks the four versions; record md5 of `app.authorize_grading_access`, `app.has_study_subject_access`, `app.has_study_pack_access`, `public.claim_sample_try` before.
- **Post-checks:** ledger rows present; rename local files to the stamped versions (feedback: `apply_migration` timestamp drift) or the next `db push` fails; `get_trial_state()` as a non-trial user returns `blocked`/`disabled`; the three function md5s above unchanged except `authorize_grading_access` (intended trial-gate call); `claim_sample_try` md5 unchanged; Supabase security advisor shows no new lint; existing paid students still pass `authorize_grading_access`.
- **Rollback:** `supabase/migrations/down/` in reverse order: `cardless_trial_v2_email_race_down`, `cardless_trial_v2_qa_fixes_down`, `get_my_learning_sessions_down`, `cardless_trial_v2_down` (rehearsed in Development by the backend; Codex re-checking). Safe while no `trial_v2` rows exist.

### Step 2: Dark verification (read-only, same session as step 1) — DONE (`APPROVAL-0210`)
Production, switch false: state function, existing-student grading path, checkout, sample entry all behave as before. Evidence recorded in the APPROVAL record.

### Step 3: App publish (Lovable project `56cae479`, David publishes)
- **Does:** set `VITE_CARDLESS_TRIAL` on in the committed `.env` (small app PR, CI green, David merges), then publish.
- **Pre-check:** step 1 and 2 done; Lovable history noted so the previous publish can be restored.
- **Effect while switch is false:** `/start` shows the server's "off" state; `/home` for existing students unchanged (regression-check signed in as an existing paid user and as the sample claimant).
- **Rollback:** Lovable restore of the prior publish; or unset the flag in a follow-up publish.

### Step 4: Switch on, no marketing link (self-test window)
- **Does:** `cardless_trial_enabled=true` in Production. Global, but only people who know `https://app.cramapple.com/start` can reach it while marketing still points at checkout.
- **Rollback:** set false. Trials already granted keep access until `ends_at`.

### Step 5: Real Production walk (David or a named tester only)
Real email-code sign-up (never done before; Development walks used pre-made users), subject confirmation, practice and graded answers, FRQ saved-work review (`/saved-work`), pay link into checkout, `?subject=` handling. Delete the test account afterwards (FK order). Day-7 expiry can only be rehearsed in Development. Any failure: switch false.

### Step 6: Marketing (Lovable `61dd6602`, send only on David's go-ahead at that moment)
Prompt 1 from `handoffs/LOVABLE_PROMPTS_FREE_TRIAL_NO_CARD_DRAFT_2026_11_09.md`: "Start free trial" buttons (generic and per subject) go to `app.cramapple.com/start[?subject=]` carrying `utm_*`, `promo`, `rdt_cid`. Verify live. Then Prompt 2 last: `VITE_TRIAL_CHECKOUT_ENABLED="false"` and pay-now checkout wording (D4). Rollback: Lovable restore.

### Step 7: Card trial off
`TRIAL_ADMISSION_ENABLED=false` (backend secret). Stops checkout granting the card trial. Reversible by setting true. Last, because it removes the old path.

### Step 8: After launch
Retire the sample (D3); watch auth email volume, grading-cap denials and cost; decide analytics (D6) and nurture (D7) separately.

## 2. Existing users and the old flow
- Paid entitlements take precedence (`superseded`); paid students see no trial UI.
- Legacy trial_v1 and card-trial emails count as a used trial (D6); they see `already_used`/blocked, not a new trial.
- Existing sample claimants keep their grant (`sample_access_honor_existing=true`); a sample claim does not block a trial, but the reverse is refused by live `claim_sample_try` (D12 conflict, below).
- Card-trial code, tables and functions stay deployed, inactive after step 7. Legacy `start-trial` already returns 410 in Production (`APPROVAL-0209`).

## 3. Risks to accept or fix before launch
1. **Auth email cap:** 30 emails/hour project-wide, shared with checkout and sample. An ad burst can exhaust it; a failed code email is the first thing a new student sees. Raise the limit or stage exposure before step 6.
2. **Cost:** full access includes graded FRQs and More help; the 40/day grading cap is the only guard, no spend alert.
3. **Unverified anywhere:** real sign-up path, serving labels during a trial (Development has none), Lovable publication of the trial app code, every signed-in `/home` state.
4. **No analytics:** funnel unmeasurable; Reddit day-7 conversions (`DECISION-0129`) count card charges, so conversion needs redefining.
5. **Notice version rule:** any `YYYY-MM-DD` accepted by design (spec 15.2). David to accept.
6. **Retention:** no retention period stated for trial data; current backend retention applies.

## 4. Decisions needed from David before or during the steps
- **D12 conflict:** amend D12 (recommended, sample is being retired) or change `claim_sample_try`.
- Launch population/timing: all traffic via step 6, or named group first (hold step 6).
- Keep the sample live until the trial ships (D3 says yes, then retire).
- Accept the notice-version rule; checkout price/bundle (D4); conversion metric.

## 5. Records
Steps 1–2 share `APPROVAL-0210`. Further steps each need a separate APPROVAL (Step 3 separate because it is a Lovable publish; Steps 4 and 5 may share; 6; 7), written with scope, who executed, time, evidence and rollback. Add a DECISION only if D12 is amended. Update the INDEX row and the handoff status when each step lands. Docs-only PRs may be merged by the agent when CI is green; code PRs (the `.env` flag PR in the app repo) go to David.
