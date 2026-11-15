# Paywall sample access: backend design spec and RPC contract (2026-11-08)

**STATUS:** CURRENT (design spec and RPC contract; implemented and tested on Development 2026-11-08 on branch
`claude/paywall-backend-sample-access-95ac1a`: migration `20261108201632_paywall_sample_access`, `sample-try` v1,
`attempt-response` v50, `student-session-items` v48; both switches off; Codex QA round 1 (2026-11-09) found two
defects, both fixed on Development the same day: migration `20261109131921_paywall_sample_access_qa_fixes`,
`attempt-response` v51/v52, integration test 22 checks; Codex round 2 verdict: both reproduced-fixed, no open QA
findings; serving alignment `20261109171915` on Development; Production ledger `20261109174046` plus the label-mirror patch applied 2026-11-09, APPROVAL-0207 §8). **Production: dark apply executed 2026-11-09 under `APPROVAL-0207` step A** (ledger `20261109155919`/`20261109155941`, `sample-try` v1, `attempt-response` v45, `student-session-items` v47, both switches off). **Step B executed 2026-11-09 ~20:15 UTC ("Approve step B, flip now", APPROVAL-0207 §9): both backend switches ON for a hidden-link small group, typed-answer FRQ; app publish pending.** QA record: `docs/qa/QA_PACKET_PAYWALL_SAMPLE_BACKEND_2026_11_08.md` §7–§8.
**Tier:** Hard-Gate (access control, payments adjacency, minors' data).
**Owner:** David Bloom. **Author:** Claude (backend/entitlement session), from the plan David approved in chat
on 2026-11-08.
**Governs:** the backend and entitlement logic of
[`PAYWALL_CHANGE_PLAN_2026_10_31.md`](PAYWALL_CHANGE_PLAN_2026_10_31.md) §3–§5, §7–§9 (Phase 1 "detailed design",
then Phase 2 "Development backend"). It does not authorize any Production change.
**Related:** `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` D18 (BYOQ identity-agnostic) and O5;
`DECISION-0057`/`DECISION-0068` (BYOQ is unscored, no row in the graded pipeline); `DECISION-0089`/`DECISION-0117`
(answer-key direct reads closed); `DECISION-0126` (seven-day card trial rules); `tasks/WORK-SUBJECT-ACCESS.md`
(subject access before study, Production 2026-11-02); `qa/MCQ_ENTITLEMENT_BLOCK_2026_10_27.md`.

**Update 2026-11-08 (later the same day):** David approved P1–P8 in chat ("I approve P1-8"), recorded as
`DECISION-0134`. Every rule marked **PROPOSED** below is therefore **DECIDED** at its stated default; the markers are
kept as the audit trail of what was proposed and what the implementation already followed. The one reading to
note: P6 listed three options for uploaded-FRQ grading (§11); the approval is read as option **(a)** (ship the
Cramapple-FRQ path first, design uploaded-FRQ grading separately, out-of-unit uploads refused), since that is the
default the build follows. Rules marked **Confirmed** cite the plan's §8 record (D1–D5, D8–D10).

---

## 0. Summary

1. **The sample is not an entitlement tier.** Every existing access check (`has_study_subject_access`,
   `authorize_grading_access`, Open Hand, dashboard) treats *any* active `app.subject_entitlements` row as full
   subject access. A `sample` row there would open the whole subject (all units, unlimited FRQs, More help) unless
   every one of those checks became tier-aware. Instead the sample is a **scoped grant** in its own tables
   (`app.sample_grants`, `app.sample_consumptions`), and only three gates are taught about it: subject study
   access (admission), attempt creation (allowance + unit), and grading authorization (clock + grace). Everything
   else stays closed by default. `grant_sample_access` from the original draft becomes `app.claim_sample_try`.
2. **The anonymous first MCQ lives in `app.sample_tries`**, keyed by a hashed random token the browser holds. It is
   graded deterministically on the server (one MCQ, one correct choice), never through the graded pipeline, and
   never exposes `mcq_choices.is_correct` until an answer is recorded. Nothing personal is stored (IP as HMAC,
   attribution allow-list only).
3. **Handoff is one transaction**: `claim_sample_try` (authenticated) verifies the token, checks eligibility,
   creates the grant, then imports the answered try as a real `learning_session` + `attempt` + `response_version` +
   `grading_results` row. The 72-hour clock starts at that commit and at no other moment. A failed import leaves no
   grant and no clock.
4. **Allowances are consumed at server-recorded attempt start**, once per content item (re-attempts of the same item
   never double-count; a technical retry resumes the same attempt). 8 MCQ including the imported first one; 1 FRQ.
5. **Clock and grace are fixed timestamps** on the grant: `expires_at = activated_at + 72h`,
   `grace_ends_at = expires_at + 72h`. New questions need phase `active`; an attempt started before `expires_at` may
   be graded until `grace_ends_at`. Nothing extends either.
6. **Read-only feedback survives expiry**: `get_question_experience` uses a readback check that accepts any sample
   grant for the subject regardless of phase. Serving new items and creating attempts do not.
7. **Trial precedence**: when any regular entitlement (`trial`/`paid`/`beta`) becomes active for the user, the
   sample grant is marked `superseded` (terminal). Cancelling the trial later revokes trial access through the
   unchanged `DECISION-0126` functions and does **not** revive sample practice. Trial functions are untouched.
8. **Flag `SAMPLE_ACCESS_ENABLED` defaults off** at both layers (edge env and `app.config`), with a separate
   `sample_access_honor_existing` switch, a documented rollback procedure, and a down-migration.
9. **Student-uploaded FRQ grading is a blocker, not a backend task**: BYOQ items are unscored by `DECISION-0057`/
   `DECISION-0068` and carry no rubric. The shared allowance and the contract slot are reserved; grading an uploaded
   FRQ needs an owner decision and its own design (§11).

---

## 1. Current state the design builds on (verified 2026-11-08 unless noted)

| Fact | Where verified |
| --- | --- |
| `app.subject_entitlements.access_tier` check is `('beta','paid','trial')`; `all_subjects` column exists; unique `(user_id, subject_id, access_tier, source)` | Development `pg_constraint`, `information_schema` |
| `app.has_study_subject_access(uuid,text)` returns true for staff roles or any active entitlement row; `has_study_pack_access` wraps it; `require_learning_session_subject_access` trigger, `get_question_experience` gate, `get_study_topic_point_guides` all route through it | `supabase/migrations/20261031143302_subject_access_before_study.sql` |
| **Development does not yet have that migration** (latest Development ledger version `20261025155645`; Production recorded it as `20261104125832`). Development `student-session-items` is v47 (2026-10-16), `session-event` v43, `attempt-response` v49, `evaluate-attempt` v62 | Development `supabase_migrations.schema_migrations`, `supabase functions list` |
| `app.authorize_grading_access(user, attempt, operation, request_id)` returns `'entitled'` or raises `grading_access:entitlement_required`; called by `evaluate-attempt` (`GRADING_ENTITLEMENTS_ENABLED`) and `attempt-response` submit | Development function body; both edge functions |
| MCQs are graded deterministically in `evaluate-attempt` (`routing.target === 'mcq_rule'`, no model spend); FRQs reserve spend through `app.reserve_model_usage` against `OPENAI_DAILY_CAP_USD` | `evaluate-attempt/index.ts` 1853–1900 |
| The live MCQ chain is `create_attempt → save_response → submit_response → evaluate-attempt`; `create_attempt` and `save_response` are deliberately not entitlement-gated; attempts are inserted by the service role with `status='draft'` | `attempt-response/index.ts` 116–127, 466–600; app `src/lib/live-practice-mcq/grade.ts` |
| `app.attempts` triggers: `trg_refuse_attempt_on_teaching_item` (Open Hand unscored), `attempts_prevent_client_grading_truth_update` (UPDATE only), hint rollup | Development `pg_trigger` |
| `learning_sessions.entry_path` check: `recommend, topic, check_work, bring_question, recommendation, self_guided_topic, self_guided_format`; `practice_format` includes `mcq`; `session_mode` in `quick/focused/buckle_down` | Development `pg_constraint` |
| `grading_results` requires `request_id` (unique), `request_hash`, `operation`, `status`, `points_available`, `criterion_results`, `confidence`, `model_id`, `prompt_version` | Development columns |
| Item → unit resolution is `app.content_item_topic_resolution` (primary, validated/authored cell joined to `taxonomy_topics.unit_number`) | Development view definition |
| Photo-answer ops (`attach_capture`, `propose_transcript`, `confirm_transcript`) exist in `attempt-response`, gated by `FRQ_PHOTO_SUBJECTS` (default `none` = admins only) and the daily caps `FRQ_PHOTO_DAILY_CAP_USD`/`FRQ_TRANSCRIPT_DAILY_RUNS` | `_shared/frq-photo-rollout.ts`, `attempt-response/index.ts` |
| BYOQ (`byoq` function) is identity-agnostic (anonymous `owner_key` + recognition on sign-in), returns `scoring: {scored:false}` always, and must not touch attempts/grading | `byoq/index.ts` 11–14, 388–420, 653 |
| Trial uniqueness is per **email hash** (`app.trial_consumed_emails`, `trial_email_consumed`); trial access rows are `access_tier='trial', source='stripe_trial_v1'`; `trial_cancel` → `trial_set_trial_access(o,'revoked',now())` | `20261018191924_task0077_card_trial_orders.sql` |
| Attribution allow-list and `ad_tracking_allowed` rule live in `_shared/trial-contract.ts` (`sanitizeAdAttribution`); `trial_orders.ad_attribution` stores it | `trial-contract.ts`, `20261026120000_ad_attribution_on_trial_orders.sql` |
| Public endpoints rate-limit per IP-HMAC through `app.record_public_endpoint_hit` (fails open, logged) | `_shared/public-rate-limit.ts`, `20261015210000_public_endpoint_rate_limit.sql` |
| New auth users get `app.profiles` with `role='student'` (`handle_new_user`); a new student has **no** entitlement and therefore no study access today | baseline 495–510; `has_study_subject_access` |
| `app.config (config_key, config_value jsonb, is_public, …)` exists with zero rows; `app.feature_flag_assignments (feature_key, user_id, enabled, expires_at, …)` exists | Development columns |

**Production content availability for the sample (read-only count, 2026-11-08, published practice MCQs with a
primary unit, not Open Hand teaching, not hand-drawn; targeted-drill FRQs excluding `photo_required`):** every
active subject has at least one unit with ≥ 20 MCQs and ≥ 4 FRQs, but many later units do not (e.g. Biology
units 4–8 hold 5–7 MCQs each, Calculus BC units 7–8 hold 1–2, Chemistry units 4–9 hold 4–7). Units with fewer than
8 eligible MCQs or 0 eligible FRQs cannot deliver the promised sample. §6.2 therefore makes unit availability a
server-side list, not a client assumption. Full table in the QA packet.

---

## 2. Data model (new objects, schema `app`)

All tables: RLS enabled and forced, `revoke all from public, anon, authenticated`, full grants to `service_role`.
Students read their state only through the `public.get_sample_access_state()` RPC. No table stores an email
address, a name, or a raw IP.

### 2.1 `app.sample_tries` — the anonymous first MCQ

| column | type | notes |
| --- | --- | --- |
| `id` | uuid pk | |
| `token_hash` | text unique, `^[0-9a-f]{64}$` | sha256 of the browser's random `try_token`; the token itself is never stored |
| `subject_id` | uuid fk subjects | |
| `exam_pack_version_id` | uuid fk | the subject's selectable pack at start |
| `unit_number` | integer | chosen by the student (Confirmed D1) |
| `content_item_version_id` | uuid fk | the served MCQ |
| `ip_hmac` | text | HMAC of caller IP (same key as public rate limiting) |
| `attribution` | jsonb | `sanitizeAdAttribution` output only |
| `served_at` | timestamptz | |
| `answer_expires_at` | timestamptz | `served_at + 24h` (**PROPOSED**) |
| `answered_at`, `picked_choice_key`, `is_correct`, `points_earned` | | set once by `sample_try_answer` |
| `claim_expires_at` | timestamptz | `answered_at + 7 days` (**PROPOSED**) |
| `supersedes_try_id` | uuid | set when a switch replaced an unanswered try |
| `switch_count` | integer default 0 | carried forward on switch |
| `claimed_by_user_id`, `claimed_at`, `grant_id` | | set by `claim_sample_try` |
| `status` | text | `served`, `answered`, `superseded`, `expired`, `claimed` |

### 2.2 `app.sample_grants` — one per student

| column | notes |
| --- | --- |
| `id` uuid pk; `user_id` uuid **unique** fk profiles | one sample per user id |
| `email_hash` text | `app.trial_email_hash(email)` at claim time; mirrored into `app.sample_consumed_emails` |
| `subject_id`, `exam_pack_version_id`, `unit_number` | locked at claim |
| `try_id` uuid fk sample_tries | provenance of the first MCQ |
| `activated_at` timestamptz not null | the clock start (Confirmed D5) |
| `expires_at` timestamptz not null | `activated_at + interval '72 hours'`, stored, never recomputed |
| `grace_ends_at` timestamptz not null | `expires_at + interval '72 hours'` (Confirmed D10) |
| `mcq_allowance` int default 8, `frq_allowance` int default 1 | (Confirmed D2, D4) |
| `status` text | `active`, `superseded`, `revoked` |
| `superseded_at`, `superseded_by` (`trial`/`paid`/`beta`), `revoked_at`, `revoked_reason` | |
| `attribution` jsonb | copied from the try (preserved across identity change) |
| `learning_session_id` uuid | the session the first MCQ was imported into |

Derived, never stored: **phase** = `app.sample_grant_phase(g)` →
`'superseded'`/`'revoked'` by status, else `'active'` while `now() < expires_at`, `'grace'` while
`now() < grace_ends_at`, else `'expired'`. When `app.sample_access_enabled()` is false and
`sample_access_honor_existing` is false, phase is `'disabled'` for every grant (§9).

### 2.3 `app.sample_consumptions` — allowance ledger

| column | notes |
| --- | --- |
| `id`; `grant_id` fk | |
| `kind` text `mcq`/`frq` | `attempt_mode='mcq'` → `mcq`; `frq`/`quantitative` → `frq` |
| `source` text `cramapple`/`byoq` | `byoq` reserved (§11) |
| `content_item_id` uuid, `content_item_version_id` uuid | null only for `byoq` |
| `byoq_item_id` uuid | reserved, null today |
| `first_attempt_id` uuid | the attempt that consumed it |
| `started_at` timestamptz | server time of consumption |
| `grace_deadline` timestamptz | copied from `grant.grace_ends_at` at consumption (fixed) |
| `grading_request_ids` text[] default '{}' | distinct grading request ids seen (§5.4 cap) |
| `transcript_runs` int default 0 | photo extraction runs (§7) |
| unique `(grant_id, kind, content_item_id)`; unique `(grant_id, byoq_item_id)` | re-attempts never double-count |

### 2.4 `app.sample_consumed_emails` — `email_hash` pk, `user_id`, `consumed_at` (one sample per email).

### 2.5 `app.config` rows (inserted by the migration, both **false**)

`sample_access_enabled` (admission + claims), `sample_access_honor_existing` (**true** by default: existing grants
keep their clocks when admission is turned off; set false to stop grading for sample students too). Helper
`app.sample_access_enabled()` / `app.sample_honor_existing()` read them with `coalesce(.., false/true)`.

### 2.6 Constraint change

`learning_sessions_entry_path_check` gains `'sample'`, so the imported session is distinguishable in reporting and
the session-sweep. No other existing constraint changes.

---

## 3. Anonymous first MCQ (plan §3, §5 "bounded anonymous MCQ attempt")

Edge function **`sample-try`** (new; `verify_jwt=false`; CORS like other public functions). Every database effect is
a `security definer` SQL function executable by `service_role` only, so the rules are testable in SQL and the TS
layer only validates, rate-limits and shapes responses.

### 3.1 Operations

| op | input | effect / output |
| --- | --- | --- |
| `list_units` | `subject_key` | `app.sample_unit_availability(subject_key)` → `[{unit_number, unit_title, mcq_available, frq_available, eligible}]`; `eligible = mcq_available >= 8 and frq_available >= 1` (§6.2). No token needed. |
| `start` | `subject_key`, `unit_number`, optional `try_token`, optional `ad_attribution` | see 3.2. Returns `{try_token (only on a new try), try_id, answer_expires_at, question}` |
| `answer` | `try_token`, `choice_key` | see 3.3. Returns `{feedback, register_to_save: true}` |
| `status` | `try_token` | `{status, subject_key, unit_number, answered, claimable_until, feedback?}` |

`question` = `{content_item_version_id, content_item_id, title, stem, stimulus, topic: {topic_code, topic_title,
unit_number}, choices: [{choice_key, choice_text}]}`. **Never** `is_correct`, `rationale`, `explanation`, or
`prompt_json` before the answer (`DECISION-0089`/`0117` stay closed; the service role reads `mcq_choices`, the
anonymous caller only ever receives shaped output).

### 3.2 `start` rules

1. Flag: `SAMPLE_ACCESS_ENABLED` env **and** `app.sample_access_enabled()` must be true → else `503 sample_disabled`.
2. Rate limit (`PUBLIC_ENDPOINT_LIMITS.sampleTry`): **PROPOSED** 60 starts/hour per IP-HMAC (a classroom on one
   NAT), 2 000/hour global; `429 rate_limited` with `Retry-After`. Fails open like the other public limits.
3. Subject must be active with one selectable pack; unit must be `eligible` per `list_units` → else
   `409 sample_unit_unavailable` with the availability list so the app can offer another unit.
4. Resume / switch (**PROPOSED** anonymous allowance; plan §7 row 1):
   - token present, try `served` and unexpired, same subject/unit → return the same try (resume after reload).
   - token present, try `served`, different subject/unit → the old try becomes `superseded`, a new one is
     created with `switch_count + 1`; at `switch_count >= 3` → `409 switch_limit_reached`.
   - token present, try `answered` (unclaimed) → `409 register_required` with the stored feedback summary. One
     complete anonymous experience per token; a second free question requires registration (plan D3).
   - token present but unknown/expired → treated as absent (new try, new token).
5. Item selection `app.select_sample_mcq(exam_pack_version_id, unit_number, exclude_item_ids)`: published MCQ,
   published version, primary unit = requested unit, not in `open_hand_teaching_items` (unreleased), not
   `prompt_json.hand_drawn`, exactly one correct choice, **no stimulus image** (**PROPOSED**: avoids signing media
   for an anonymous caller), random order by `md5(id || seed)`.
6. Store the try with `ip_hmac` and sanitized attribution. Return the plaintext token once.

### 3.3 `answer` rules

1. Flag and rate limit (same bucket, counts as a hit).
2. Try must be `served` and `now() < answer_expires_at` → else `410 try_expired` (start again).
3. `choice_key` must be one of the item's keys → else `400 invalid_choice`.
4. Idempotent: an `answered` try returns the stored feedback; a different `choice_key` on an answered try returns
   `409 already_answered` **with** the stored feedback (the first answer is final, as in the signed-in chain).
5. Grade: `is_correct = (picked = the one correct key)`, `points_earned ∈ {0,1}`.
6. Feedback = `{picked_choice_key, earned, possible: 1, choices: [{choice_key, choice_text, is_correct,
   rationale}], explanation}` — the same shape as `public.get_graded_mcq_feedback` so the app renders one component.

### 3.4 What the try is not

Not an `app.attempts` row, not a `learning_session`, not a grading_results row, not a BYOQ item, not a profile. It
cannot be submitted to `evaluate-attempt`. It never carries email, name, or device id.

---

## 4. Handoff to the registering student (plan §5 "secure, retry-safe handoff")

### 4.1 Registration: the sample needs its own sign-up step (corrected 2026-11-09)

**Correction.** The 2026-11-08 text said registration was "unchanged (existing code sign-in)". That was wrong for a
new visitor: the marketing `/login` sends codes with `signInWithOtp({ shouldCreateUser: false })` (existing accounts
only) and its "Create an account" link goes to `/checkout`; until now accounts were created only by the Stripe
webhook (`inviteUserByEmail` / `createUser` after payment, `DECISION-0090`, `TASK-0060`). So "Register to save" had
no path that did not end in checkout — David hit this on the live `/sample` test. The app therefore adds an in-app
email-code step (`ap-prep-blueprint` #52): `signInWithOtp({ email, shouldCreateUser: true })` → `verifyOtp({ type:
'email', token })` → `claim_sample_try(p_try_token)`.

**What the backend relies on, verified read-only against Production Auth config on 2026-11-09:** sign-ups enabled
(`disable_signup=false`), email provider on, no auto-confirm, 6-digit codes valid 3600 s, the "Confirm sign up"
template carries `{{ .Token }}` and no confirmation link, custom SMTP (Resend, sender "Cramapple"), 30 auth
emails per hour project-wide (`rate_limit_email_sent` / `rate_limit_otp`). The Auth **send-email hook is disabled**
and no `send-auth-email` deployment is involved; Supabase Auth sends the code itself from the dashboard templates
(see the auth-template memory: Invite / Magic Link / Confirm sign up by account state; one email per minute per
address). Nothing here is a backend code change: `handle_new_user` creates the `student` profile on the
`auth.users` insert exactly as for a webhook-created user, and `claim_sample_try` only needs `auth.uid()`.

**Rules that still hold.** Nothing in registration starts a clock (the grant activates on claim, §4.2). An email
that has already consumed a sample is refused at claim (`sample:already_sampled`, §8), so a sign-up alone grants
nothing. The 30/hour project-wide email limit is shared with trial/checkout mail — enough for the hidden-link
group, a watch item before any wider link (plan §6).

**Alternative considered, not chosen for the first activation:** a server-side registration edge function
(service role `createUser` + `generateLink` for the code, like the webhook) would let the backend own the
consumed-email check *before* the account exists and keep client code off the admin path, but it adds a public
endpoint with its own rate limit and HMAC and duplicates what Supabase Auth already does. Client OTP sign-up is
the smaller change and is what Production is configured for; revisit only if abuse (accounts created, never
claimed) shows up in the watch list.

### 4.2 `public.claim_sample_try(p_try_token text) → jsonb` (authenticated RPC)

Wraps `app.claim_sample_try(auth.uid(), sha256(token))`. One transaction, in this order:

1. `app.sample_access_enabled()` → else `sample:disabled`.
2. Advisory lock on the user id (serialises double-clicks and two tabs).
3. Resolve the try by hash: missing → `sample:try_not_found`; `claimed` by this user → **return the existing grant
   state (idempotent replay)**; claimed by someone else → `sample:try_claimed_elsewhere`; not `answered` →
   `sample:try_not_answered` (the plan saves the *answer*; an unanswered try has nothing to save — **PROPOSED**);
   `now() >= claim_expires_at` → `sample:try_claim_expired`.
4. Eligibility (**PROPOSED**, resolves plan §5 "one per email vs one per user ID"):
   - profile role must be `student` → else `sample:not_student`;
   - no `sample_grants` row for the user → else `sample:already_sampled`;
   - `email_hash` not in `sample_consumed_emails` → else `sample:email_already_sampled`;
   - no `subject_entitlements` row for the user in **any** status → else `sample:not_eligible_prior_access`
     (an existing/returning customer, including a lapsed trial, is not a new visitor);
   - `app.trial_email_consumed(email)` false → else `sample:not_eligible_prior_trial`.
   Both keys apply together: one sample per user id **and** one per email hash. Changed emails: the hash is taken
   at claim time from `auth.users.email`; a later email change does not create new eligibility because the user-id
   row persists. Existing users without entitlements (e.g. reviewers) are excluded by the role check.
5. Insert `sample_grants` (`activated_at = now()`, both deadlines stored) and `sample_consumed_emails`.
6. Import the first MCQ as real study data (service-definer writes, bypassing the app's RPC ownership rules):
   `profiles.active_exam_pack_version_id := try.exam_pack_version_id`; insert `learning_sessions`
   (`entry_path='sample'`, `session_mode='quick'`, `practice_format='mcq'`, `available_minutes=10`,
   `status='active'`) — the subject-access trigger passes because the grant now exists; `append` ordinal 1 =
   the try's item; insert `attempts` (`status='graded'`, `submitted_at=try.answered_at`, `graded_at=now()`,
   `score_points`, `score_possible=1`, `assistance_state='independent'`) — the attempt-insert gate (§5.1)
   consumes MCQ allowance #1; insert `response_versions` (`response_text=picked key`, `is_submitted=true`);
   insert `grading_results` (`request_id='sample-try:'||try.id`, `operation='grade_initial_attempt'`,
   `status='graded'`, `points_available=1`, `criterion_results=[{criterion_key:'mcq_correct_choice',…}]`,
   `confidence='high'`, `model_id='sample_try_deterministic'`, `prompt_version='sample-try-v1'`).
7. Mark the try `claimed`; write an `audit_events` row (`action='sample.claim'`).
8. Return `get_sample_access_state()`.

Any failure in 5–7 raises and rolls back **everything**: no grant, no clock, no partial session (plan §5 "must not
produce duplicate attempts, lost feedback or premature timers"). The client retries the same call; step 3 makes the
retry a replay once committed.

### 4.3 What the first MCQ looks like afterwards

`get_question_experience(learning_session_id, 1)` returns the imported attempt with `mcqFeedback` from
`get_graded_mcq_feedback` and `resume.action='review_feedback'`. `servedItems` has one entry. The counter shows
`1/1`; the app appends later items to the same session through the normal `student-session-items` call.

---

## 5. Access gates for a sample student

A "sample-only" user is one with a `sample_grants` row and **no** active regular entitlement for that subject.
Regular entitlements always win; the sample code paths are reached only when the existing checks would deny.

### 5.1 Attempt creation — `app.sample_gate_attempt_insert()` (BEFORE INSERT trigger on `app.attempts`)

```
if staff role or active regular entitlement for the attempt's subject → return new   (unchanged behaviour)
if no sample grant for the user → return new                                           (unchanged: create isn't gated)
lock the grant row
phase <> 'active' → raise sample:grace_no_new_questions | sample:expired | sample:superseded | sample:disabled
item's primary unit (content_item_topic_resolution) is null or <> grant.unit_number → raise sample:item_outside_unit
item is photo_required → raise sample:item_not_included   (human-reviewed items are not in the sample; PROPOSED)
kind := mcq | frq
insert sample_consumptions (grant, kind, item) on conflict do nothing
if a row was inserted and count(kind) > allowance → raise sample:mcq_allowance_exhausted | sample:frq_allowance_exhausted
```

Server start time = `sample_consumptions.started_at`; `grace_deadline = grant.grace_ends_at` is copied so a later
change to the grant cannot move it. A second attempt on the same item (the live chain never creates one, but a
retried `create_attempt` whose first response was lost could) hits `on conflict do nothing` and consumes nothing.
Parallel open attempts on different items each consume once; "started" is the attempt insert, not the first
`save_response`. Errors use `errcode 42501` with message `sample:<code>`; `attempt-response` maps them to
`403 {error: code, access: "sample"}` (§8).

### 5.2 Grading authorization — `app.authorize_grading_access` (extended)

```
regular entitlement → 'entitled'                                           (unchanged)
consumption c for (user's grant, attempt's content_item_id) exists:
  phase 'active'                                      → ok
  phase 'grace' and now() < c.grace_deadline          → ok      (started before expires_at by construction)
  phase 'expired'/'superseded'/'revoked'/'disabled'   → raise grading_access:sample_expired | sample_superseded | sample_disabled
  operation not in ('submit_response','grade_initial_attempt') → raise grading_access:sample_operation_not_included
  grade_initial_attempt with a new request_id when array_length(grading_request_ids) >= 3
                                                      → raise grading_access:sample_grading_limit_reached   (PROPOSED cap)
  else append request_id, return 'sample' | 'sample_grace'
no consumption → raise grading_access:entitlement_required                (unchanged)
```

`evaluate-attempt` and `attempt-response` already map `grading_access:<code>` to `403 {error: code}`, so the new
codes surface typed without edge changes to that regex. Retries of a failed grade reuse the chain's attempt and a
fresh idempotency key; three distinct grading requests per sample FRQ is generous for genuine transient failures and
bounds model spend.

### 5.3 Subject study access (admission) — `app.has_study_subject_access` (extended)

Adds `or app.sample_study_access(_user_id, _subject_key)` = grant for that subject with phase `'active'`. This is
what lets the sample student select the subject, start/resume the imported session, be served items, and read
`get_study_topic_point_guides` — but **only** while `active`. In `grace` the student cannot start a session or be
served new items; they can still read back and finish started attempts (§5.2, §5.4).

Unit restriction on guides: `public.get_study_topic_point_guides` raises `sample:unit_locked` when a sample-only
caller requests a unit other than the grant's; with `_unit_number` null it substitutes the grant's unit.

### 5.4 Readback — `app.has_study_readback_access(user, version)` (new) used by `get_question_experience`

`has_study_pack_access(...) or exists (sample grant for the pack's subject in any status/phase)`. The body of
`get_question_experience` is patched by anchor replacement (same technique as `20261031143302`) so saved feedback
stays readable after expiry (Confirmed D8) and during grace. The RPC only ever returns items already in
`learning_session_items`, so readback cannot be used to pull new questions.

### 5.5 Serving — `student-session-items`

`checkStudyPackAccess` already denies outside `active`. New: `app.sample_serving_scope(user, exam_pack_version_id)`
returns `{unit_number, mcq_remaining, frq_remaining, consumed_item_ids}` for a sample-only user (null otherwise).
The handler filters the selected rows to that unit via `content_item_topic_resolution`, drops `photo_required` and
already-consumed items, keeps at most `mcq_remaining` MCQs and `frq_remaining` FRQs, and adds
`sample: {unit_number, mcq_remaining, frq_remaining}` to the response so the queue never shows a question the
attempt gate would refuse. When nothing remains the response carries `queue_exhausted_reason: 'sample_allowance'`.

### 5.6 Sessions

`start_home_learning_session_for_user` / `session_start` work for the grant's pack while `active`
(`has_study_pack_access` true). The imported session is reused by the "reused_active" branch. During `grace`,
`session_start` and `session_resume` deny with `entitlement_required`; the app must open the question page by
`learning_session_id` from `get_sample_access_state().in_progress` and use `attempt-response`/`evaluate-attempt`
directly, which the grading gate admits. **PROPOSED** (not implemented in this slice): extend `session-event`
`session_resume` to accept grace for a session holding an in-progress sample attempt.

---

## 6. Subject/unit rules

### 6.1 Lock

Subject and unit are fixed on the grant at claim. Switching after activation is **behind the card trial** (plan §4
"Other subjects/units after sample selection"). **PROPOSED**: no switch allowance at all after claim; the anonymous
switch allowance (§3.2.4) is the only switching.

### 6.2 Availability

`app.sample_unit_availability(subject_key)` counts eligible MCQs/FRQs per unit with the §3.2.5 predicate (FRQs:
published targeted-drill FRQs not `photo_required`). A unit is `eligible` only when it can deliver the full promise
(≥ 8 MCQs, ≥ 1 FRQ). `start` refuses ineligible units. Per the Production count in §1, that excludes many later
units today; the app shows the list rather than assuming unit 1 only.

---

## 7. Photo answer within the sample FRQ (plan §5 caps)

- The sample FRQ photo flow is the existing `attach_capture → propose_transcript → confirm_transcript → submit`
  path. It depends on `FRQ_PHOTO_SUBJECTS` including the subject (currently `none` everywhere). Enabling it is a
  release step outside this spec.
- `app.sample_take_photo_run(p_user_id, p_attempt_id)` (service only): returns `'not_sample'` for regular
  entitlement holders; for a sample consumption increments `transcript_runs` and raises
  `sample:extraction_limit_reached` beyond **3** runs per sample FRQ (**PROPOSED**; a retake and one re-extraction
  after a bad photo fit inside it). `attempt-response` calls it before `propose_transcript`; a `sample:*` error is a
  typed 403, and any other failure of the call fails **closed** with `503 sample_photo_check_failed` (the first
  build logged and continued, which would have run extraction uncapped; Codex QA finding 2, fixed 2026-11-09,
  `attempt-response` v51).
- Grading runs are capped by §5.2 (3 distinct requests). Model spend stays under the existing daily caps
  (`FRQ_PHOTO_DAILY_CAP_USD`, `FRQ_TRANSCRIPT_DAILY_RUNS`, `OPENAI_DAILY_CAP_USD`).
- IP caps: anonymous `sample-try` is per-IP (classroom-tolerant numbers above). Authenticated photo operations
  are per user and per sample FRQ, so a school NAT shares no cap there. There is deliberately no per-IP cap on
  `claim_sample_try` (an RPC has no reliable caller IP); eligibility (§4.2.4) bounds it to one claim per
  user/email.

---

## 8. Typed access-denial path (plan §5, `qa/MCQ_ENTITLEMENT_BLOCK_2026_10_27.md`)

All sample refusals are **typed and distinct from transient failures**:

| Layer | Code | HTTP | Meaning / app action |
| --- | --- | --- | --- |
| `attempt-response` create_attempt | `sample:grace_no_new_questions`, `sample:expired`, `sample:superseded`, `sample:disabled`, `sample:item_outside_unit`, `sample:item_not_included`, `sample:mcq_allowance_exhausted`, `sample:frq_allowance_exhausted` | 403 `{error, access:'sample', state}` | show the upgrade sheet (card trial / parent handoff) with the state's deadlines; keep saved feedback |
| `attempt-response` submit / `evaluate-attempt` | `grading_access:sample_expired`, `sample_superseded`, `sample_disabled`, `sample_operation_not_included`, `sample_grading_limit_reached` | 403 `{error}` | same sheet; the drafted answer stays on the attempt |
| `attempt-response` propose_transcript | `sample:extraction_limit_reached` | 403 | offer typing the answer instead |
| `claim_sample_try` | `sample:disabled`, `try_not_found`, `try_claimed_elsewhere`, `try_not_answered`, `try_claim_expired`, `not_student`, `already_sampled`, `email_already_sampled`, `not_eligible_prior_access`, `not_eligible_prior_trial` | RPC error, errcode 42501 | explain and route to the card trial; never a generic "save failed" |
| `sample-try` | `sample_disabled`, `rate_limited`, `sample_unit_unavailable`, `register_required`, `switch_limit_reached`, `try_expired`, `already_answered`, `invalid_choice` | 503/429/409/410/400 | typed, with the availability list or stored feedback where stated |
| existing | `entitlement_required` (403), `subject_access:entitlement_required` (42501) | unchanged | unchanged |

`state` in the 403 body is the §10.3 object, so the app does not need a second call to render the deadline.

---

## 9. Flag and rollback (plan §5 "a flag alone is not a complete rollback spec")

| Switch | Default | Off means |
| --- | --- | --- |
| env `SAMPLE_ACCESS_ENABLED` on `sample-try` | `false` | the public function returns `503 sample_disabled` for every op (no new tries, no answers) |
| `app.config.sample_access_enabled` | `false` | `sample_try_start/answer` and `claim_sample_try` raise `sample:disabled`; SQL paths cannot be used around the edge flag |
| `app.config.sample_access_honor_existing` | `true` | when **false**, every grant's phase is `disabled`: no new attempts, no grading, serving denied; **readback of saved feedback and the imported first MCQ stay available** (promised feedback is never withdrawn) |

**Rollback levels**
1. *Stop admissions*: set both `sample_access_enabled` switches false. Existing students finish their 72h/grace.
2. *Stop everything except reading*: additionally set `sample_access_honor_existing=false`.
3. *Remove the feature*: `supabase/migrations/down/…_paywall_sample_access_down.sql` drops the trigger, restores the
   pre-change bodies of `has_study_subject_access`, `authorize_grading_access`, `get_study_topic_point_guides`
   and `get_question_experience` (from `pg_get_functiondef` snapshots the up-migration stores in
   `app.config` under `sample_access_prior_definitions`), drops the four tables, and restores the `entry_path`
   check. Readback of already-imported attempts survives because they are ordinary rows; the subject-access gate
   then denies them until the student has an entitlement (documented loss, acceptable only at level 3).

Both config rows are also read by `get_sample_access_state()` so the app can hide the entry point.

---

## 10. API / RPC contract for the app session

### 10.1 Public edge function `POST /functions/v1/sample-try` (anon key, no JWT)

Request `{operation, subject_key?, unit_number?, try_token?, choice_key?, ad_attribution?}`.
Responses `{status:'ok', operation, result}` or `{error, ...}` with the codes in §8.

Response shapes **as deployed** (corrected 2026-11-09 from the live function after the app session found the
first draft of this list showed a flattened `result`; the app parses the shapes below):

- `list_units` → `result: {subject_key, units: [{unit_number, unit_title, mcq_available, frq_available, eligible}]}`
- `start` → `result: {outcome: 'created'|'resumed', try_token: string|null, try}` — `try_token` is a string only
  when `outcome='created'` (a new token was issued) and `null` on `resumed`. An answered token → `409 {error:
  'register_required', try}`; a claimed one → `409 {error:'already_claimed', try}`.
- `answer` → `result: {outcome: 'answered'|'replayed', try, register_to_save: true}`.
- `status` → `result: {try}`; an unknown token gives `result.try = {status:'not_found'}`.

`try` is the `app.sample_try_view` object: `{try_id, status, subject_key, exam_pack_version_id, unit_number,
served_at, answer_expires_at, answered_at, claim_expires_at, switch_count, question, feedback}`. `question`
(`{content_item_version_id, content_item_id, title, stem, stimulus, topic:{topic_code, topic_title, unit_number},
choices:[{choice_key, choice_text}]}`) is present only while the try is `served`; `feedback`
(`{content_item_version_id, picked_choice_key, earned, possible, choices:[{choice_key, choice_text, is_correct,
rationale}], explanation}`) is `null` until answered.

The app keeps `try_token` in `sessionStorage`/`localStorage` and sends it to `claim_sample_try` after sign-in.
Attribution: pass the same `ad_attribution` object the checkout already builds (`ad_tracking_allowed`,
`anon_id`, `first_touch`, `last_touch`).

### 10.2 Authenticated RPCs (`supabase.rpc(...)` with the user's JWT)

| RPC | Params | Returns |
| --- | --- | --- |
| `public.claim_sample_try(p_try_token text)` | plaintext token | §10.3 state (grant created or replayed) |
| `public.get_sample_access_state()` | — | §10.3 state (`has_grant:false` when none) |
| existing `public.get_question_experience(p_learning_session_id, p_ordinal)` | | unchanged shape; now readable for sample students in every phase |
| existing `public.get_study_subject_keys()`, `set_active_exam_pack_version`, `complete_onboarding`, `get_study_topic_point_guides` | | true/allowed for the grant's subject while phase `active` |

### 10.3 `sample_access_state` object

```json
{
  "enabled": true,                       // both config switches
  "honor_existing": true,
  "has_grant": true,
  "grant": {
    "id": "uuid",
    "subject_key": "ap-statistics", "exam_pack_version_id": "uuid", "unit_number": 2,
    "status": "active",                  // active | superseded | revoked
    "phase": "active",                   // active | grace | expired | superseded | revoked | disabled
    "activated_at": "…", "expires_at": "…", "grace_ends_at": "…",
    "now": "…",                          // server time, for countdowns
    "mcq": {"total": 8, "used": 3, "remaining": 5},
    "frq": {"total": 1, "used": 0, "remaining": 1},
    "learning_session_id": "uuid",       // the imported first-MCQ session
    "in_progress": [                     // consumed items whose attempt is not yet graded
      {"kind": "frq", "content_item_version_id": "uuid", "attempt_id": "uuid",
       "started_at": "…", "grace_deadline": "…", "transcript_runs": 1}
    ],
    "superseded_by": null
  },
  "offer_context": {
    "has_regular_entitlement": false,
    "trial_email_consumed": false,       // app.trial_email_consumed(auth email)
    "attribution": {"ad_tracking_allowed": true, "first_touch": {...}, "last_touch": {...}}
  }
}
```

`offer_context.attribution` is the try's sanitized attribution, so the upgrade sheet and the `trial_start`
checkout can forward the same object (plan §5 "preserve attribution and promotion"). Pricing/promo eligibility
remains the checkout's `buildTrialQuote` (not duplicated here).

### 10.4 Edge-function changes visible to the app

- `attempt-response` 403 bodies for `sample:*` carry `access:'sample'` and `state`.
- `student-session-items` response gains `sample: {unit_number, mcq_remaining, frq_remaining} | null` and
  `queue_exhausted_reason: 'sample_allowance'` when the filtered queue is empty.

### 10.5 Analytics hooks (not events; the instrumentation contract is the app session's)

Server rows that an analytics contract can read: `sample_tries` (start/answer/switch/claim with `attribution`),
`sample_grants.activated_at`, `sample_consumptions.started_at`, `audit_events` `sample.claim`. The first MCQ is one
row across identities (the try row links to the grant), so it is never double-counted.

---

## 10.6 Serving alignment (added 2026-11-09, migration `20261109171915_paywall_sample_serving_alignment`)

The app session's Development smoke ("Round 3", `docs/qa/PAYWALL_APP_DEV_SMOKE_2026_11_09.md`) found that the app's
normal practice entry serves through `student-session-items` **mode `unit_gated`**, which reads
`app.student_course_positions` (default unit 1) and the production selector `public.select_student_practice_items`
(validated serving labels, `home_release_manifest.allowed_unit_numbers`). Verified read-only on Production and fixed:

1. **`claim_sample_try` sets the course position** to the grant unit (`source='confirmed'`, upsert on the primary
   key). Without it a unit-2+ grant was served nothing, and Physics 2 / Physics C E&M (units start at 9 / 8) raised
   `unit_serving:unit_not_in_subject`.
2. **The imported first-MCQ session is format-less** (`practice_format null`, fingerprint `10:sample`). With
   `'mcq'` the unit-gated selector returned zero rows (Statistics: 0 vs 50). FRQ attempts still need a
   `targeted_drill` session (`create_attempt` enforces `practice_format_mismatch`); the app starts one.
3. **`sample_unit_availability` counts what serving delivers.** When the pack has validated serving labels,
   `app.sample_serving_deliverable` applies the **same filters as `public.select_student_practice_items`**
   (latest version then published; active validated label whose hash matches `app.taxonomy_relevant_hash`;
   `max_required_unit <= position`; unit in `home_release_manifest.allowed_unit_numbers`; mcq/quantitative or
   short/long `targeted_drill` FRQ; not a teaching item) restricted to items with a topic resolution in the unit, then
   the sample's own rules (no image stimulus, not hand-drawn, one correct choice; FRQ not `photo_required`). It is a
   mirror, not a call: calling the selector per unit was wrong (its 51-row page sorted by label unit dropped unit-N
   items — Calculus AB Unit 1 showed 4 of its 10) and slow (~250 ms a page, 3.8 s per subject); the mirror runs in
   ~45 ms per unit. A migration-time **drift guard** compares the selector's definition md5 (`026a108b…`) and refuses
   to apply if the selector changed, so the mirror cannot silently diverge; Codex also compares the two on
   Production. Each row carries `basis: 'serving' | 'content'`; `'content'` applies only where a pack has no serving
   labels (Development today), so the fallback is visible, never silent. Production preview 2026-11-09: **all 31
   content-eligible units stay eligible** on the serving basis (the earlier "Calc AB Unit 1 drops to 4" was the
   paging artefact). The anonymous first MCQ (`select_sample_mcq`) draws from the same deliverable set.

Development cannot walk the unit-gated path (no serving labels there); the ordinary path and the SQL suite cover
the sample rules, and Production is checked read-only.

---

## 11. Student-uploaded FRQ as the sample FRQ — blocker (plan D4, §3 "both question sources")

The plan confirms the student may choose a Cramapple FRQ **or** upload their own for the one graded FRQ. The
backend has no path to grade an uploaded question: BYOQ returns `scoring:{scored:false}` by `DECISION-0057`, keeps
no rubric, and must not create graded-pipeline rows by `DECISION-0068`. Grading an uploaded FRQ means generating a
rubric from the student's photo and grading against it — a new capability with its own quality, cost and
answer-leakage review.

This spec therefore **reserves** the allowance semantics (`sample_consumptions.source='byoq'`,
`byoq_item_id`, unique per grant) and the contract slot (`claim_sample_frq_source(byoq_item_id)` → today raises
`sample:byoq_grading_not_available`, flag `SAMPLE_BYOQ_FRQ_ENABLED` default false), and asks David to decide
(**PROPOSED** options): (a) ship the sample with the Cramapple-FRQ path first and design uploaded-FRQ grading
separately; (b) treat an uploaded question as "photo of my answer to my own question" with unscored transcript
review only (not a graded FRQ, so it would not consume the allowance); (c) commission the rubric-generation design
now. The out-of-unit upload question (plan §3) only arises under (c): **PROPOSED** when it does, an uploaded
question whose confirmed unit differs from the grant's unit consumes the allowance only if David accepts
cross-unit uploads; the default would be to refuse with `sample:item_outside_unit` and let the student re-confirm
the unit.

BYOQ's identity-agnostic policy (D18, `DECISION-0077`) is untouched by this spec.

---

## 12. Trial transition and cancellation precedence (plan §5 last bullet)

- Trigger `app.sample_supersede_on_entitlement` (AFTER INSERT OR UPDATE OF status, ends_at ON
  `subject_entitlements`): when a row for the user has `status='active'`, has not ended (`ends_at` null or in the
  future), and `access_tier in ('trial','paid','beta')`, mark the user's `active` sample grant `superseded`
  (`superseded_by = access_tier`). The start date does not matter: a scheduled (future-start) entitlement is
  still a purchase or trial, so it supersedes at insert; the first build required `starts_at <= now()`, which let
  the sample revive after a future-start row ended (Codex QA finding 1, fixed 2026-11-09 by migration
  `20261109131921_paywall_sample_access_qa_fixes`). Scope is the user, not the subject: a trial for another subject
  also ends the sample (**PROPOSED**; a trialling student has the full product).
- `trial_activate`, `trial_cancel`, `trial_set_trial_access`, `trial_convert` are **not modified**. Cancellation
  revokes the trial rows exactly as `DECISION-0126` says; the sample grant stays `superseded` (terminal), so a
  cancelled trial never restores sample practice. Saved feedback readback (§5.4) remains.
- Precedence when both exist at the same instant: regular entitlement wins in every gate; the sample branch is
  only evaluated when the regular check denies.
- Sample eligibility and trial eligibility stay separate: a sample never consumes `trial_consumed_emails`, and
  `claim_sample_try` only *reads* `trial_email_consumed`.

---

## 13. Minors' data

The anonymous path stores: a hashed token, an IP HMAC, allow-listed UTM/click fields (click ids only with
`ad_tracking_allowed`), subject/unit, item id, choice, timestamps. No email, name, age, or free text. Registration
collects what the existing sign-in collects. The plan's §7 note stands: this path needs an explicit review against
the existing privacy/counsel work before Production; this spec records what is stored so that review can be done.

---

## 14. Owner items P1–P8 — DECIDED 2026-11-08 (`DECISION-0134`)

All eight were approved at the proposed default by David in chat on 2026-11-08 ("I approve P1-8"). The table is
kept as written when it was proposed; "Proposed default" is now the decided rule. P6 is read as option (a) of §11.

| # | Item | Proposed default (now decided) |
| --- | --- | --- |
| P1 | Anonymous repeat/switching | one answered try per token; switch subject/unit up to 3 times while unanswered; try answerable for 24h, claimable for 7 days |
| P2 | Attempt start / consumption | consumed at server attempt insert, once per content item; 3 grading requests and 3 extraction runs per sample FRQ |
| P3 | Eligibility | one per user id **and** per email hash; any prior entitlement row or consumed trial email disqualifies; students only |
| P4 | Trial precedence | any active regular entitlement supersedes the sample permanently; cancellation never revives it |
| P5 | Unit rules | no subject/unit switch after claim; unit eligible only with ≥ 8 MCQs and ≥ 1 non-photo FRQ; `photo_required` and image-stimulus items excluded from the sample |
| P6 | Uploaded FRQ | blocker §11: choose (a)/(b)/(c); out-of-unit uploads refused by default |
| P7 | Rollback | two config switches + down migration (§9); readback never withdrawn |
| P8 | Grace resume | `session_resume` during grace left as a follow-up; app uses `learning_session_id` from state |

---

## 15. Implementation plan (Development only)

1. Bring Development to `main`: apply `20261031143302_subject_access_before_study.sql` (Production has it) and
   deploy `student-session-items`, `session-event`, `attempt-response`, `evaluate-attempt` from this branch.
2. Migration `paywall_sample_access` (tables, config rows, functions, triggers, patched bodies, grants) +
   `down/` script. Local file renamed to the version Development records.
3. Edge: new `sample-try`; `attempt-response` (sample error mapping, photo-run guard); `student-session-items`
   (serving scope).
4. Tests: `supabase/tests/sample_access.integration.sql` (Development, transaction-rollback, exits with a single
   `SAMPLE_ACCESS_TESTS_PASSED` notice), `sample-try/index_test.ts`, additions to `attempt-response` and
   `student-session-items` handler tests; `deno test` per `minimal-ci.yml`.
5. QA packet for Codex: `docs/qa/QA_PACKET_PAYWALL_SAMPLE_BACKEND_2026_11_08.md`.
6. Draft PR to `main`, not merged.
