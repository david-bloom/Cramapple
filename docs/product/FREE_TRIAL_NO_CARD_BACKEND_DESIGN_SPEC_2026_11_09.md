# Free trial without a card: backend and entitlement design spec (DRAFT, 2026-11-09)

**STATUS:** CURRENT for Development. Approved: `DECISION-0135` (D1–D8 and the D9–D12 addendum), `APPROVAL-0208` (Development build). **Built and applied to Development 2026-11-09 ~22:00 UTC** (owner in the backend session: "Do both"): migration `20261109215704_cardless_trial_v2.sql`, integration test `supabase/tests/cardless_trial.integration.sql` = 39 checks passed (rolled back); `cardless_trial_enabled` is **false** on Development until the app session asks for its walk. **Production:** only D11 executed (`CARDLESS_TRIAL_RETIRED=true`, `APPROVAL-0209`, recorded by the app/docs session; §10 (a) and §14 conflict 1 are CLOSED); the migration, the trial switch and the card-trial switch-off are NOT in Production. First Development run found one defect in the design: `trial_consumed_emails.source` had a check allowing only `trial_v1`/`stripe_trial_v1`; the migration now widens it to `trial_v2`.
**Tier:** Hard-Gate (entitlements, access control, payments adjacency, minors' data).
**Owner:** David Bloom. **Author:** Claude (backend/entitlement session), at the app/docs session's request, from
`docs/product/FREE_TRIAL_NO_CARD_CHANGE_PLAN_2026_11_09.md` (David's words, D1–D8 not yet answered).
**Governs:** the backend half of the plan: the single-subject trial entitlement, its one-per-email rule, the read the app
needs, how the card trial is made inactive without removal, how the chargers and the sample's supersede logic treat the
new rows, and the spend guards. App routes, copy and Lovable prompts are the app session's.
**Supersedes when approved:** `DECISION-0126` items 1 (trial only at checkout) and 12 (cardless trial retired);
`TASK-0026`'s all-subjects design. Needs a new `DECISION` (next free number is `DECISION-0135` on `main`; check open PRs
before numbering) and an `APPROVAL` for the Development build.

## 0. The design in one paragraph

One row in `app.subject_entitlements` per trial: `access_tier='trial'`, **`source='trial_v2'`**, `all_subjects=false`,
one `subject_id`, `starts_at = now()` at **subject confirmation**, `ends_at = starts_at + 7 days`. Every existing gate
(`app.has_study_subject_access`, `app.authorize_grading_access`, `app.has_study_pack_access`, serving, More help's
subject policy) already admits an active `subject_entitlements` row and denies it after `ends_at`, so the trial needs
**no new gate logic**, exactly as `TASK-0026` found. What is new: a single-subject start RPC with a switch, the
one-per-email check reusing `app.trial_consumed_emails`, a state read for `/home`, a readback allowance after day 7, a
daily grading ceiling for trial rows, and the card trial switched off by its existing `TRIAL_ADMISSION_ENABLED` secret.

## 1. Production today (read-only, 2026-11-09 ~21:30 UTC)

| Fact | Value | Why it matters |
| --- | --- | --- |
| `subject_entitlements.access_tier` check | `beta`, `paid`, `trial` | `trial` already allowed; no DDL on the check. |
| Unique key | `(user_id, subject_id, access_tier, source)` | a new `source='trial_v2'` coexists with `trial_v1` and `stripe_trial_v1` rows. |
| `trial` rows | 20 × `trial_v1` (2 users, all `ends_at` ≤ 2026-09-30, status still `active`), 1 × `stripe_trial_v1` revoked | **status is not the lifecycle signal; `ends_at` is.** Any read must use `ends_at`, never `status='active'`. |
| `app.trial_consumed_emails` | 3 hashes; both `trial_v1` users already hashed (TASK-0077 backfill) | D6 "earlier trials count" is already true in data; the check function exists: `app.trial_email_consumed(p_email)`. |
| `app.trial_orders` | 3 rows (`refunded`, `setup_expired`); no live card trial | switching the card trial off strands nobody. |
| Card-trial switches (secrets, Prod and Dev) | `TRIAL_ADMISSION_ENABLED`, `TRIAL_CHARGES_ENABLED`, `TRIAL_NOTICES_ENABLED`, `TRIAL_CHARGE_WORKER_SECRET`, `TRIAL_TERMS_VERSION` | the "inactive but preserved" switch already exists: `TRIAL_ADMISSION_ENABLED`. |
| `start-trial` edge function | **v23 live in Production**; its retire switch `CARDLESS_TRIAL_RETIRED` is **not set** in Production (nor Development) | **conflict with `DECISION-0126` item 12**: the old all-subjects cardless trial is still callable by any signed-in `student`/`admin` with a JWT (`POST /functions/v1/start-trial`). Only the marketing routes stopped calling it. See §10. |
| `app.start_trial(uuid,jsonb,jsonb,boolean,text)` | live; grants one `trial_v1` row per **active subject** | must not be reused as is; replaced by §3. |
| `charge-due-trials` / `app.trial_claim_due` / `app.trial_sweep` | select only from `app.trial_orders`; the sweep's entitlement extension joins `source='stripe_trial_v1'` **and** `external_reference = order id` | cardless rows have no order and a different source: **they can never be charged or extended by these.** |
| `app.sample_supersede_on_entitlement` | any `active`, not-yet-ended `trial`/`paid`/`beta` row supersedes the user's sample grant | a `trial_v2` insert supersedes a sample grant: intended. |
| Sample switches | `sample_access_enabled=true`, `SAMPLE_ACCESS_ENABLED=true`; 0 tries, 0 grants | D3: nothing to migrate; see §8. |
| `GRADING_ENTITLEMENTS_ENABLED` | set on Prod and Dev | grading caps and the trial ceiling (§7) are enforced only while this stays set. |
| Auth | sign-ups allowed, OTP 6 digits/3600 s, "Confirm sign up" carries `{{ .Token }}`, 30 auth emails/hour project-wide | the landing email-code step works with no dashboard change; the hourly cap is the natural sign-up throttle. |

## 2. Lifecycle and phases (the words the app and the DECISION should use)

| Phase | Definition (server) | Access |
| --- | --- | --- |
| `none` | no `trial_v2` row, email not consumed, switch on | can start |
| `blocked` | no row, but `app.trial_email_consumed(email)` true, or switch off | cannot start; `/home` shows pay prompt only |
| `pending_subject` | account exists, no row yet (same as `none` from the server's view; the app shows "Pick a subject") | nothing until confirmed |
| `active` | row exists and `now() < ends_at` | full access to that one subject |
| `ended` | row exists and `now() >= ends_at` | no serving, no new attempts, no grading; **readback of own work** (§6) |
| `superseded` | a `paid` (or `beta`) row for the same subject is active | regular access; trial row left as history |

The clock starts at **subject confirmation** (D1 recommended = yes). Sign-up creates nothing but the auth user and the
`student` profile (`app.handle_new_user`, unchanged).

## 3. Start: `public.start_subject_trial(p_subject_key text, p_privacy_notice_version text, p_first_touch jsonb default null, p_last_touch jsonb default null) → jsonb`

Authenticated RPC (`grant execute … to authenticated`; `anon` revoked), `security definer`, wraps
`app.start_subject_trial(auth.uid(), …)`. One transaction, in this order:

1. `auth.uid()` null → `not_authenticated` (28000). Profile role not `student` (or `admin` for smoke) → `trial:forbidden` (42501).
2. `app.config.cardless_trial_enabled` not `true` → `trial:disabled` (42501). **New config key, default `false`.**
3. `pg_advisory_xact_lock(hashtextextended('trial_v2:' || user_id, 0))`.
4. Resolve the subject: `app.subjects` by `app.normalize_student_subject_key(p_subject_key)`, `status='active'`, and
   with a servable pack (`app.home_release_manifest` has a row for its current `exam_pack_version_id`) → else
   `trial:subject_unavailable` (22023). The app reads the pickable list from the existing subjects read, not from here.
5. Existing `trial_v2` row for this user (any subject) → **return its state, no write** (idempotent replay; the subject
   cannot be changed — D9 below). If it is for a different subject, add `'replayed_other_subject': true` so the app can
   explain.
6. An active `paid`/`beta` row for this subject → return state with `phase:'superseded'`, write nothing, consume nothing.
7. `app.trial_email_consumed(email)` true (email from `auth.users` for `auth.uid()`) → `trial:already_used` (42501).
   Covers `trial_v1` (backfilled), card-trial orders and earlier `trial_v2` under one rule (D6 = yes).
8. Insert `app.subject_entitlements (user_id, subject_id, access_tier, status, source, starts_at, ends_at, all_subjects)`
   = `(uid, subject, 'trial', 'active', 'trial_v2', now(), now() + interval '7 days', false)`.
9. Insert `app.trial_consumed_emails (email_hash, source, consumed_at)` = `(app.trial_email_hash(email), 'trial_v2', now())`
   (the table's existing shape; `order_id` null).
10. Upsert `app.acquisition_profiles` exactly as `app.start_trial` does today (privacy notice version, first/last touch;
    marketing opt-in **false**, no consent column change — D8 decides whether the N4 notice covers this).
11. Record the growth event the webhook records for card trials (`trial_started`, with `subject_key`, `source:'trial_v2'`)
    through the same table `recordGrowthEvent` writes; the exact table is confirmed at build time, not assumed here.
12. Return `public.get_trial_state()` (§4).

No edge function is needed: the write is one RPC and the app already calls RPCs with the session JWT. The legacy
`start-trial` function is **not** reused (§10).

Typed denials follow the sample's convention: `raise exception 'trial:<code>' using errcode=…`; PostgREST surfaces them
as 4xx with the message, which the app already maps for `sample:*`.

## 4. Read: `public.get_trial_state() → jsonb` (authenticated, stable, security definer)

```
{ phase: 'none'|'blocked'|'active'|'ended'|'superseded',
  can_start: boolean,                      -- phase none and switch on
  blocked_reason: null|'disabled'|'already_used',
  subject_key: text|null, subject_name: text|null,
  starts_at, ends_at: timestamptz|null,
  days_remaining: int|null,                -- ceil((ends_at - now()) / 1 day), floor 0; 7 on the first day
  seconds_remaining: int|null,
  ends_eastern: text|null,                 -- same formatter the card trial uses (DECISION-0126 item 29)
  has_regular_entitlement: boolean,        -- any active paid/beta row for the trial subject
  checkout_subject_key: text|null,         -- the subject the pay prompt should buy (the trial subject)
  server_now: timestamptz }
```

`days_remaining` is computed on the server from `ends_at`; the app never counts days itself. The card trial's
`get-trial-status` function keeps returning `trial_orders` views and is **not** extended: the two trials have different
objects, and a student can legitimately show up in both reads (ended cardless trial, later card trial if it is ever
re-enabled). The app reads `get_trial_state` for `/home`.

## 5. Gates: nothing new for `active`

| Gate | Today | With `trial_v2` |
| --- | --- | --- |
| `app.has_study_subject_access` | active row for the subject (`starts_at <= now() < ends_at`) or sample | admits the one subject; denies every other subject (`subject_access:entitlement_required`), which is the "other subjects locked" behaviour the plan wants |
| `app.authorize_grading_access` | active row → `entitled` | same; plus the daily ceiling in §7 |
| `student-session-items`, serving, More help subject policy | entitlement via the same functions | unchanged |
| `app.sample_supersede_on_entitlement` | fires on the insert | marks any active sample grant `superseded_by='trial'`: intended |
| Checkout → `paid` row | inserted by the Stripe webhook | the `trial_v2` row stays as history; gates OR the rows; `phase` becomes `superseded` |

## 6. Day 7 (D2): deny new work, keep reading

At `ends_at` every gate above denies (no serving, no `create_attempt`, no grading). The plan says saved work stays
readable: today `public.get_question_experience` checks `app.has_study_pack_access`, which would deny an ended trial.
**Entry point (added 2026-11-09 at the app session's request, Development ledger `20261109221340`):**
`public.get_my_learning_sessions(p_subject_key text default null, p_limit int default 20) → jsonb[]` lists the
caller's own sessions that have items, newest activity first: `learningSessionId, subjectKey, subjectName,
examPackVersionId, entryPath, sessionMode, practiceFormat, status, startedAt, endedAt, itemCount, submittedCount,
firstItemType, lastActivityAt, readable`. Not gated on subject access (readback is allowed in every phase);
`readable` = `app.has_study_readback_access` for that session's pack, so a session of a subject the account never
had access to is listed but flagged, and `get_question_experience` still refuses it. Limit floored at 1, capped at 50;
only error `not_authenticated`. Proposal for the read itself: extend **`app.has_study_readback_access`** (the function the sample added for exactly this) so it is also true
when the user has a `trial_v2` row for the pack's subject, regardless of `ends_at`; `get_question_experience` already
consults it. Reading is the student's own `learning_sessions`/`attempts` only. No grace period (grace belongs to the card
trial's charge retry). The pay prompt is the way forward; a later `paid` row re-opens everything.

## 7. Spend and abuse guards (D5)

Full access for 7 days means graded FRQs and More help at the paying student's limits. Existing guards that still apply:
More help's per-user quota and attempt limits (`more_help_quota_and_delivery_fencing`), the public-endpoint rate limits,
`FRQ_PHOTO_*` off (no extraction spend), BYOQ unscored. Added for trial rows only:

- **Daily grading ceiling:** in `app.authorize_grading_access`, when the admitting row is `access_tier='trial'` and
  `source='trial_v2'`, count this user's `grade_initial_attempt`/`grade_revision` authorizations in the last 24 h
  (from `app.grading_results`, or a small `app.trial_grading_counts` table if counting is too slow) and above
  `app.config.trial_daily_grading_cap` (proposed **40**, D10) raise `grading_access:trial_daily_cap` (typed, retry
  tomorrow). Paid/beta rows are untouched.
- **Alert, not a block:** a watch query (trial users by graded attempts per day, top 5) for the first two weeks.
- **Sign-up abuse:** one trial per email hash; 30 auth emails/hour project-wide; the email-change loophole stays an
  accepted risk (`DECISION-0126` item 31). No IP/device fingerprinting.

## 8. The live 72-hour sample (D3)

Recommendation: leave the switches as they are until the cardless trial's own Production activation step, then set
`app.config.sample_access_enabled=false` and `supabase secrets unset SAMPLE_ACCESS_ENABLED` in the same approval
(`sample_access_honor_existing` stays `true` so any grant that did get claimed finishes its 72 h + grace). Nothing in
this spec depends on the sample being on or off; a `trial_v2` row supersedes a sample grant either way. If David wants
the hidden link closed sooner, that is one config update and one secret unset with no code change (`APPROVAL-0207` §9).

## 9. The card trial: inactive, preserved

- **Off switch:** `TRIAL_ADMISSION_ENABLED=false` in Production (today `true`). `create-checkout-session` then takes the
  pay-now path. **Build-time check:** the code at `create-checkout-session/index.ts:123–126` refuses a legacy pay-now
  request "from a buyer who should be on a trial"; confirm that with admission off the server-chosen mode is pay-now and
  no buyer is refused. Development first.
- Keep deployed and unchanged: `charge-due-trials`, `cancel-trial`, `trial-recovery`, `get-trial-status`, all
  `app.trial_*` functions and tables, the Loops IDs, `TRIAL_CHARGES_ENABLED` (irrelevant with no live orders). They never
  see `trial_v2` rows (§1).
- Rollback to today = `TRIAL_ADMISSION_ENABLED=true` and `cardless_trial_enabled=false`.

## 10. The legacy cardless trial: retire for real

`start-trial` v23 is live with `retired=false` because `CARDLESS_TRIAL_RETIRED` was never set. Proposal, in order:
(a) **DONE 2026-11-09 (`APPROVAL-0209`; Production answers 410; Development never had the function deployed, 404):** `supabase secrets set CARDLESS_TRIAL_RETIRED=true` on Production and
Development → the function answers `410 trial_retired` (no deploy; the code reads the secret at start); (b) in this
plan's migration: drop `app.start_trial(uuid,jsonb,jsonb,boolean,text)` and replace it with `app.start_subject_trial`;
(c) later, delete the `start-trial` function folder once the marketing repo is confirmed not to reference it. The 20
`trial_v1` rows stay as history (their `ends_at` has passed; their emails are consumed).

## 11. Migration shape (Development first; one file)

`paywall_cardless_trial_v2`: config keys `cardless_trial_enabled=false`, `trial_daily_grading_cap=40`;
`app.start_subject_trial`, `public.start_subject_trial`, `public.get_trial_state`; `app.has_study_readback_access`
extension; `app.authorize_grading_access` ceiling branch (drift guard: assert the current body's md5 before replacing,
as the sample migration does); drop `app.start_trial` (after (a) in §10); grants (`authenticated` on the two public RPCs
only); down script. No table DDL: `subject_entitlements` and `trial_consumed_emails` already fit.

Integration test (`supabase/tests/cardless_trial.integration.sql`, rollback DO block): start → one row, 7 days,
consumed hash; replay → same state; other subject → replayed_other_subject; second account same email hash → already_used;
`trial_v1` user → already_used; paid row present → superseded, nothing consumed; switch off → disabled; gates admit the
subject and deny another; `ends_at` moved to the past → gates deny, readback true; 41st grading in a day → trial_daily_cap;
`app.trial_sweep()` and `app.trial_claim_due()` leave `trial_v2` rows and return no order; sample grant superseded by the
insert. Edge-function tests only where `create-checkout-session` changes (admission off → pay-now).

## 12. Activation order (each step its own approval, each reversible)

1. Development: migration + tests + Codex QA; app walk against Development.
2. Production, dark: apply the migration (`cardless_trial_enabled=false`), `CARDLESS_TRIAL_RETIRED=true`.
3. Production: `cardless_trial_enabled=true`; Lovable publish of the start step and `/home`.
4. Production: `TRIAL_ADMISSION_ENABLED=false` (card trial inactive) and the marketing "Start free trial" destinations.
5. Production: sample switches off (§8).

## 13. Decisions for David (the plan's D1–D8 plus four from this spec)

| # | Question | This spec's recommendation |
| --- | --- | --- |
| D1 | Clock starts at subject confirmation | yes (§2) |
| D2 | Day 7 | deny new work, keep own-work readback via `has_study_readback_access`, no grace (§6) |
| D3 | Sample | leave on until step 5, then off (§8) |
| D5 | Spend | existing quotas + a trial-only daily grading ceiling with an alert (§7) |
| D6 | Earlier trials count | yes; already true in data via `trial_consumed_emails` (§3 step 7) |
| D8 | Minors' data | the trial stores nothing new beyond `acquisition_profiles` (privacy notice version, first/last touch) and the email hash; re-confirm N4 in one line |
| **D9** | Can a student change the trial subject after confirming? | **No** in the first release (one row, one subject); a change would need a revoke + new row and a rule for the clock. |
| **D10** | Daily grading cap value | **40** graded attempts per 24 h per trial account |
| **D11** | Retire the legacy `start-trial` now with `CARDLESS_TRIAL_RETIRED=true` (one secret, no deploy)? | **Yes**, as its own approval, before anything else in this plan. |
| **D12** | Does a used **sample** block a trial (or a used trial block a sample)? | **No** either way: different offers; a trial supersedes a sample. |

D4 (checkout price/bundle) and D7 (nurture emails) have no backend content here beyond §9.

## 14. Conflicts with the Production state, stated plainly

1. ~~`DECISION-0126` item 12 says the cardless trial is "switched off"; in Production it was only unlinked~~ — CLOSED 2026-11-09 by `APPROVAL-0209` (§10 a).
2. `trial_v1` rows are `status='active'` with past `ends_at`; any report or read that filters on status will overcount
   live trials. This spec's read uses `ends_at` only.
3. The sample is live behind a hidden link while this plan is designed; the two coexist without code conflict (§5, §8).
4. Nothing else conflicts: the gates, the chargers, the email-hash table and the Auth configuration all fit the design
   as they stand.

## 15. Codex merge-gate QA of PR #609 (2026-11-09) and the fixes

| # | Finding (Codex) | Verified | Fix (migration `cardless_trial_v2_qa_fixes`) |
| --- | --- | --- | --- |
| 1 | `start_subject_trial` stored caller-supplied touch JSON and any non-blank notice version | yes, by reading §3 steps 10–11 as built | `app.sanitize_trial_touch`: allow-list `utm_source, utm_medium, utm_campaign, utm_content, utm_term, promo, rdt_cid`, string values only, trimmed to 200 chars, everything else dropped; notice version must match `YYYY-MM-DD` else `trial:invalid_privacy_notice_version` (22023). The app already sends only those keys and `2026-11-09`. |
| 2 | daily ceiling counted then inserted without a per-user lock | yes | `pg_advisory_xact_lock(hashtextextended('trial_grading:'‖user,0))` before the replay check and count; test asserts the lock is held after a counted call (a true two-connection race cannot run inside one SQL test; the lock makes the window serial by construction) |
| 3 | paying account whose email once consumed a trial read `blocked/already_used` | yes | `trial_v2_state`: with no trial row, any active `paid`/`beta` row (any subject) → `phase:'superseded', has_regular_entitlement:true, can_start:false, blocked_reason:null` |
| 4 | no executable down script | yes | `supabase/migrations/down/cardless_trial_v2_down.sql` (reverses the anchor patch, restores the two-clause readback body, drops objects, narrows the source check only when no `trial_v2` hashes exist), `get_my_learning_sessions_down.sql`, `cardless_trial_v2_qa_fixes_down.sql` (restores from the `cardless_trial_prior_definitions` snapshot). Rehearsal on Development: pending the owner's word, recorded in §15.1 when done. |
| 5 | records said Development `start-trial` answers 410 | yes: Development never had the function deployed (404) | records corrected; the Development secret is inert |

### 15.1 Development apply and down rehearsal
Pending.

### 15.2 Second-pass items from the Codex rerun on a42384d7 ("merge after fixes")
1. **Notice version accepts any `YYYY-MM-DD`, not only `2026-11-09`.** Intended. The value is the version of the privacy
   notice the app displayed to the student at the moment of consent, recorded for the audit trail; the app's constant is
   the source of truth. Pinning the backend to one date would turn every notice revision into a backend release and
   would refuse students who loaded the app before a revision shipped. The format check exists to reject arbitrary text,
   not to decide which notice is current. Recorded here as the ruling; no code change.
2. **Daily-ceiling test only asserts the lock is held.** Correct as stated. A single-connection SQL test cannot stage two
   simultaneous graders. The serialisation argument is structural: every counted call takes
   `pg_advisory_xact_lock('trial_grading:'‖user)` before it reads the count, so a second connection for the same user
   waits for the first to commit and then sees its row. The Development rehearsal (§15.1) will add a two-connection
   check if a second Development connection can be opened from this machine (one session holds the lock in an open
   transaction, the other's gate call must block until commit); if it cannot, that is recorded there and the structural
   argument stands.
3. **PR #609 was behind `main` after #608 merged.** Synced (merge commit 210f1ff3); no conflicts.
