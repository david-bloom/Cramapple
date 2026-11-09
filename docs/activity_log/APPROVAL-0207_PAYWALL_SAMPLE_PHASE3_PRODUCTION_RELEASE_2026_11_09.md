# APPROVAL-0207 — Paywall sample access, Phase 3: Production dark apply (step A, APPROVED and EXECUTED 2026-11-09) and activation (step B, NOT GRANTED)

- **Status:** **Step A approved by David in chat ("Approve step A", 2026-11-09) and executed the same day; see §6.**
  **Step B is not approved**; its preconditions are in §3. Prepared 2026-11-09 by the backend/entitlement
  session at David's request ("Yes, draft it") after Codex QA round 2 closed the backend findings.
- **Tier:** Hard-Gate (Production access control, payments adjacency, public endpoint, minors' data).
- **Plan gate:** `docs/product/PAYWALL_CHANGE_PLAN_2026_10_31.md` §9 Phase 3: "Production changes behind
  disabled flag, then activation for the approved test population — explicit release approvals per step."
- **Related:** `APPROVAL-0206` (Development-only authority), `DECISION-0134` (P1–P8), spec
  `docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md` (§9 rollback, §10 contract, §11 blocker), QA packet
  `docs/qa/QA_PACKET_PAYWALL_SAMPLE_BACKEND_2026_11_08.md` (§7–§8 Codex verdicts), backend PRs #595/#597 (merged),
  app PRs #45/#47 (`ap-prep-blueprint`, merged, flag off, never run against a live backend).
- **Numbering check (2026-11-09):** `main` ends at APPROVAL-0206 and DECISION-0134; no open pull request or remote
  branch claims APPROVAL-0207.

## 0. Readiness summary (what is true today)

| Area | State | Evidence |
| --- | --- | --- |
| Backend code | On `main`, two Codex QA rounds, no open findings | QA packet §7–§8 |
| Production backend | **Nothing applied.** 0 `sample_*` migrations, functions or tables; `app.config` has no `sample*` keys | read-only query 2026-11-09 |
| Production anchors for the migration | **Match exactly** what the migration was built against: `app.has_study_subject_access` md5 `d4a20f88…`, `app.authorize_grading_access` `52101195…`, `public.get_study_topic_point_guides` `6f9d56a1…` equal Development's pre-change snapshots; `get_question_experience` still carries the `has_study_pack_access` anchor; `entry_path` check is the pre-change list | read-only queries, both projects |
| Production function drift | `attempt-response` v44 and `student-session-items` v46 downloaded and diffed against `main`: **every differing line is the sample change** (plus `_shared/student-item-delivery.ts` gaining `sample_scope`). Deploying from `main` ships nothing else | `supabase functions download`, `diff` |
| App | PR #47 wired to the contract behind `VITE_SAMPLE_JOURNEY` (off). App session ran one anonymous→claim smoke on Development 2026-11-09 (its own report); backend-only HTTP walk done the same day (QA packet §9). Still no app-driven full walk. FRQ source choice / photo / transcript confirm **not wired**. No analytics events | PR #47 description |
| Content | Units 1–3 reliably eligible per subject in Production; later units mostly not; the app reads availability live | plan Phase 0 audit, spec §1 |
| Open product work | D6 experiment design, D7 nurture emails, §13 minors'-data/privacy review not performed | plan §8, spec §13 |

**Verdict offered to David:** step A (dark apply) is low-risk and can be approved on its own; step B (activation)
should not be approved until the preconditions in §3 are met.

## 1. Step A — dark apply to Production (switches off; no student-visible change)

### 1.1 What would change

1. Migration `supabase/migrations/20261108201632_paywall_sample_access.sql` applied via `apply_migration`
   (Production will stamp its own version; the ledger row name `paywall_sample_access` is what to look for). It
   creates four `app.sample_*` tables (RLS forced, service_role only), config rows
   `sample_access_enabled=false`, `sample_access_honor_existing=true`, snapshots the four prior definitions
   into `app.config.sample_access_prior_definitions`, redefines `app.has_study_subject_access` (adds
   `or app.sample_study_access(...)`), `app.authorize_grading_access` (sample branch after the regular check),
   `public.get_study_topic_point_guides` (unit lock for sample users only), anchor-patches
   `public.get_question_experience` (readback widening), adds the BEFORE INSERT trigger on `app.attempts` and the
   AFTER trigger on `app.subject_entitlements`, widens `learning_sessions.entry_path` to accept `'sample'`, and
   adds public RPCs `claim_sample_try`, `get_sample_access_state`, `claim_sample_frq_source` (always refuses).
2. Migration `supabase/migrations/20261109131921_paywall_sample_access_qa_fixes.sql` (future-start supersede).
3. Deploy from `main` with `--project-ref pcntajvbdfqhbeewmdry --workdir <repo>`: `sample-try` (new,
   `--no-verify-jwt`, env `SAMPLE_ACCESS_ENABLED` **not set** → every call answers `503 sample_disabled`),
   `attempt-response` v44→next, `student-session-items` v46→next (both `verify_jwt` unchanged).
4. Required secret: `PUBLIC_RATE_LIMIT_HMAC_KEY` must already exist on Production (it does for the other public
   endpoints); confirm before deploying `sample-try`.

### 1.2 Behaviour while dark (why step A is safe)

- With no grant rows and both switches off, every redefined function takes its regular branch first; the sample
  branch is reached only when the regular check denies **and** a grant row exists — there are none.
- The attempt trigger passes through for anyone with regular access or without a grant (every current user).
- The entitlement trigger runs on every `subject_entitlements` insert/update (234 active rows today, Stripe webhook
  and trial flows write here). It performs one `update app.sample_grants … where user_id = new.user_id and
  status='active'`, which touches zero rows while dark. It is `security definer`, plain SQL, no external call.
- `get_question_experience` readback widening admits only sample grants (none) in addition to today's rule.
- `sample-try` is public but returns 503 on every op until the env flag is set; rate limiting applies regardless.
- Production has **no** Development-only `task0078_align_*` migrations involved; the two files above are the only
  schema change.

### 1.3 Pre-write checks (run read-only, record results here before applying)

1. `list_projects` / `--debug` shows `pcntajvbdfqhbeewmdry`; the CLI `--workdir` is pinned to the repo
   (the home-dir link is Production, the repo `.temp` link is Development — do not rely on either).
2. The three md5s in §0 still equal `d4a20f88187872d70333a3ef1d92ad19`, `521011954748b35e44f524a5e8ba647a`,
   `6f9d56a142674ee77e380cd75c3390a4`; `get_question_experience` still contains `has_study_pack_access`;
   `entry_path` check unchanged. If any differs, **stop**: the migration's anchor patch would fail or, worse,
   overwrite a newer body.
3. `main` function sources diffed against downloaded Production bundles show only the sample change (re-run; the
   2026-11-09 result is in §0).
4. Ledger shows no `paywall_sample%` rows yet.

### 1.4 Verification after the write

- Ledger: two `paywall_sample%` rows. `app.config`: `sample_access_enabled=false`, `honor_existing=true`,
  `sample_access_prior_definitions` has five keys. Four `sample_*` tables, 0 rows each.
- Grants: `anon`/`authenticated` have **no** execute on any `app.sample_*` function and no table grants;
  `authenticated` can execute `public.claim_sample_try`, `public.get_sample_access_state`,
  `public.claim_sample_frq_source`; `anon` cannot.
- Behaviour: pick one entitled real student (by `user_id`, not row count) and confirm `has_study_subject_access`
  and `authorize_grading_access` return the same as before; `get_sample_access_state()` under a simulated JWT
  returns `has_grant=false`; `POST /functions/v1/sample-try {op:'list_units'}` returns `503 sample_disabled`.
- Functions: `attempt-response` and `student-session-items` answer a normal entitled flow (create attempt, serve
  items) unchanged; a `student-session-items` response for a regular student carries `sample: null`.
- Security advisor: no new warnings on the four tables (RLS forced) or the new functions.

### 1.5 Rollback for step A

- Functions: redeploy the previous bundles (Production's own v44 / v46 source was downloaded 2026-11-09 and equals
  `main` minus the sample change; `sample-try` can simply be deleted).
- Schema: `supabase/migrations/down/paywall_sample_access_down.sql` restores the snapshotted bodies, drops the
  triggers, functions, tables, config rows and the widened `entry_path` check. With zero sample rows this loses
  nothing. Delete the two ledger rows if the down script is run.

## 2. Step B — activation for the approved test population (separate approval)

### 2.1 What would change

1. Set env `SAMPLE_ACCESS_ENABLED=true` on `sample-try` (Production secret; redeploy picks it up).
2. `update app.config set config_value='true' where config_key='sample_access_enabled'`.
3. Lovable publish of the app with `VITE_SAMPLE_JOURNEY` on (the marketing `/try` entry and any Reddit landing
   links are the marketing session's scope, not this record's).
4. Population: the plan's "approved test population" is **undefined**. Options for David: all anonymous visitors
   (the switches are global), or a marketing-side gate (only the `/try` link exposes the entry). The backend has no
   per-cohort switch; adding one is a small follow-up if wanted.

### 2.2 Rollback levels (spec §9)

1. Stop admissions: both `sample_access_enabled` switches false (students in progress finish their 72h + grace).
2. Stop everything but reading: also `sample_access_honor_existing=false`.
3. Remove: step A's down script (readback of imported first MCQs then falls under the normal subject gate).

### 2.3 Watch list for the first week

`sample_tries` per day and per IP-HMAC (classroom bursts vs abuse), `sample:*` refusal counts by code from
function logs, claims per day, `sample_consumptions` per grant, `sample_grading_limit_reached` and
`extraction_limit_reached` counts, `sample_photo_check_failed` 503s (should be ~0), supersede events
(`superseded_by`), and the public-rate-limit `sample-try` hits.

## 3. Preconditions David should require before approving step B

1. **End-to-end run on Development** — backend half DONE 2026-11-09 by the backend session over real HTTP (QA packet §9); the app-driven run and independent Codex QA of it are still open: both Development switches on, app clone pointed at
   Development, walk anonymous MCQ → register → `claim_sample_try` → 7 further MCQs → one Cramapple FRQ graded →
   grace → expiry → read-only feedback, then switches back off and test rows removed. Codex QA of that run.
2. **App completes the Cramapple-FRQ path** (pick, answer, grade) so the "8 MCQs + 1 FRQ" offer is deliverable;
   the uploaded-FRQ picker stays hidden (DECISION-0134 P6 = option a; backend RPC refuses).
3. **Analytics contract implemented** or explicitly deferred (plan §6 experiment, D6).
4. **Minors'-data / privacy check** of spec §13 (what `sample_tries` and `sample_consumed_emails` store; retention).
5. **D7 nurture emails** decided or explicitly out of the first activation.
6. **Grace resume (P8)**: app opens the question page by `learning_session_id` from the state; confirm it works, or
   accept that grace students cannot resume via `session_resume`.
7. Step A verified in Production for at least one normal day of traffic with no regressions.
8. **Photo-answer flags decided.** The plan promises a *photo-answer* FRQ, but `FRQ_PHOTO_RESPONSES_ENABLED` and
   `FRQ_PHOTO_SUBJECTS` are off in Production (and Development), so a sample student could not photograph their
   answer even with every switch above on. Before step B David either (a) approves enabling the photo flow for the
   sample subjects in Production — a separate Hard-Gate approval covering `attempt-response`'s transcript ops,
   `capture-pairing`, the model spend caps and `DECISION-0110`/`0111` retention — or (b) accepts a typed-answer
   FRQ for the first activation and the app copy says so. The sample caps (3 extraction runs) only matter under (a).

## 4. Explicitly not covered by this record

Any change to the seven-day card trial (`DECISION-0126`), BYOQ policy (`DECISION-0077`), answer-key reads
(`DECISION-0089`/`0117`), pricing or checkout, emails or Loops sends, PostHog schema, or Reddit ads.

## 5. Decision record (to be filled by David)

- **Step A (dark apply):** ☑ **approved** — 2026-11-09, David Bloom in chat: "Approve step A". Execution record in §6. Step A.1 (serving alignment) approved and executed the same day, §8.
- **Step B (activation):** ☐ approved / ☐ declined — date, words, population:

## 6. Step A execution record (2026-11-09, Production `pcntajvbdfqhbeewmdry`)

**Authority:** David Bloom in chat, "Approve step A". Executed by the backend/entitlement session.

**Pre-write checks (§1.3), all passed before the first write:** ledger had no `paywall_sample%` row; md5s
`d4a20f88…` / `52101195…` / `6f9d56a1…` unchanged; `get_question_experience` anchor present;
`entry_path` check pre-change; no `sample_*` objects or config keys; dependencies present
(`record_public_endpoint_hit`, `normalize_student_subject_key`, `open_hand_teaching_items`,
`content_item_topic_resolution`); `supabase/` on the branch identical to `origin/main`; Production function
bundles v44/v46 differ from `main` only by the sample change. `PUBLIC_RATE_LIMIT_HMAC_KEY` is **not** set on
Production; `sample-try` falls back to the service-role key for the IP HMAC exactly as the other six public
endpoints do (shared `_shared/public-rate-limit.ts`), so no new secret was created.

**Writes:**
1. `apply_migration paywall_sample_access` → Production ledger `20261109155919 paywall_sample_access`
   (file `20261108201632_paywall_sample_access.sql`, body passed without its `begin;`/`commit;`).
2. `apply_migration paywall_sample_access_qa_fixes` → `20261109155941 paywall_sample_access_qa_fixes`
   (file `20261109131921_…`).
3. `supabase functions deploy` from `main` with `--project-ref pcntajvbdfqhbeewmdry --workdir <repo>`:
   `sample-try` v1 (`--no-verify-jwt`), `attempt-response` v44→**v45**, `student-session-items` v46→**v47**.
   No secret or config switch touched: `SAMPLE_ACCESS_ENABLED` unset, `app.config.sample_access_enabled=false`.

**Verified after the writes (read-only):**
- Ledger shows both rows; `app.config`: `sample_access_enabled=false`, `sample_access_honor_existing=true`,
  `sample_access_prior_definitions` holds 5 keys. Four `sample_*` tables, 0 rows each, RLS enabled and forced,
  no `anon`/`authenticated` table grants; no `anon`/`authenticated` execute on any `app.sample_*` function;
  `authenticated` can execute the three public RPCs, `anon` cannot. Both triggers present; `entry_path` accepts
  `'sample'`; `get_question_experience` patched to `has_study_readback_access`; the supersede trigger has no
  `starts_at` condition.
- **Fidelity:** every sample-related function body in Production equals Development's byte for byte except four
  plpgsql bodies (`authorize_grading_access`, `claim_sample_try`, `sample_gate_attempt_insert`,
  `sample_try_start`) whose only difference is inline `--` comments that Development's copy lacks; with comments
  and whitespace stripped the md5s are identical. The down script's snapshot is the Production body.
- **Regular students unchanged:** 33 entitled student–subject pairs are all admitted by the live
  `has_study_subject_access`, none via the sample branch; the 4 unentitled student profiles are not admitted to
  `ap-statistics`. `sample-try list_units` with the anon key → `503 {"error":"sample_disabled"}`;
  `attempt-response` and `student-session-items` without a JWT → 401. Downloaded Production bundles of all three
  functions are byte-identical to `main`.

**Owner check:** David confirmed in chat on 2026-11-09, after the deploy, that a normal signed-in study flow still
renders on the live app ("Confirmed, renders"). **Not verified:** the security advisor was not re-run.

**Rollback (unchanged from §1.5):** redeploy v44 / v46 (Production's own source, saved by download 2026-11-09),
delete `sample-try`; `supabase/migrations/down/paywall_sample_access_down.sql` plus removal of the two ledger rows.

## 7. Post-step-A checks (2026-11-09, later the same day)

- Security advisor on Production re-run: no new lint category and no ERROR; the four sample tables sit in the
  pre-existing INFO "RLS enabled, no policy" list with the other service-role-only tables, and the three public RPCs
  in the pre-existing WARN "authenticated can execute SECURITY DEFINER" list with every other public RPC.
- Production traffic in the 90 minutes after the deploy: 0 attempts, 0 sessions, 0 entitlement writes — too quiet
  to count as the "day of dark traffic" (precondition 7); nothing failed because nothing ran.
- Development: `GRADING_ENTITLEMENTS_ENABLED` was missing (Production has it), so Development's edge functions
  had never enforced `authorize_grading_access`; set to `true` on Development 2026-11-09. Backend end-to-end over
  HTTP passed (QA packet §9). Codex prompt for the independent pass:
  `docs/qa/CODEX_QA_PROMPT_PAYWALL_SAMPLE_PRODUCTION_2026_11_09.md`.

## 8. Step A.1 — serving-alignment migration to Production (APPROVED and EXECUTED 2026-11-09)

The app session's Round 3 smoke found three serving mismatches in the dark backend (QA packet §10): the claim set
no course position (unit-2+ grants and Physics 2 / C E&M would serve nothing through the app's unit-gated entry),
the imported session's `practice_format='mcq'` returns zero rows from the unit-gated selector, and availability
over-counted what serving delivers (Calculus AB Unit 1: 4 vs 10). Fix: migration
`20261109171915_paywall_sample_serving_alignment.sql` — three function bodies (`claim_sample_try`,
`sample_unit_availability`, `select_sample_mcq`) and two helpers; no table change; applied to Development, SQL suite
22 checks green. **Production apply needs David's words** (same pre-write checks as §1.3 plus: Production
`select_student_practice_items` md5 unchanged since 2026-11-09, `home_release_manifest` present for every active
pack). Still dark after apply; still no student-visible change.

- **Step A.1:** ☑ **approved** — 2026-11-09, David Bloom in chat: "Approve step A.1".

**Execution (2026-11-09, Production `pcntajvbdfqhbeewmdry`).** Pre-write checks: no `paywall_sample_serving_alignment`
ledger row; `public.select_student_practice_items` md5 `026a108b…` identical on Production and Development;
every active subject's selectable pack has a `home_release_manifest` row; `student_course_positions` primary key
`(user_id, exam_pack_version_id)`; 0 sample rows; `sample_access_enabled=false`. Write: `apply_migration
paywall_sample_serving_alignment` → ledger **`20261109174046`** (file `20261109171915_…`). Verified after: the five
function bodies (`claim_sample_try`, `sample_unit_availability`, `select_sample_mcq`, `sample_pack_has_serving_labels`,
`sample_serving_deliverable`) have comment-stripped md5s identical to Development's; no `anon`/`authenticated`
execute on the two new helpers; `sample_unit_availability` reports `basis:'serving'` for every active subject;
Calculus AB Unit 1 → `mcq_available 4, frq_available 7, eligible false`; Physics 2 → units 9, 10, 11 eligible;
30 eligible units product-wide (31 before, Calc AB U1 the one removed); the first-MCQ pick for Calc AB Unit 2 is in
the deliverable set; still 0 sample rows, switch still false. Still dark; no student-visible change.

