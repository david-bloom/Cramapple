# Fable review of the backend refactor plan (2026-10-21)

**Verdict: the plan is directionally sound but mis-ranked and partly aimed at code that is not running.** Its central
finding (replay results handed back without an ownership check) is real on three of the seven replay paths, but with
the live client it is a defense-in-depth gap, not an exploitable one. Its second slice (reconciling two submission
endpoints) is mostly moot because `submit-response` is not deployed to Production and nothing calls it. Its sixth slice
(the `web/` prototype) is not on any serving path. The contract verification it asked for turned up two things the plan
did not have: Production's session RPCs do not match two migrations the ledger says are applied, and the repository's CI
does not run the edge-function tests the plan wants to rely on.

**Status:** review complete; revised sequencing proposed; no implementation approved.
**Date:** 2026-10-21. **Reviewer:** Claude (Fable 5.1). **Reviewed against:** Cramapple `main` at `df39cd09`;
live app `david-bloom/ap-prep-blueprint` at `e73445d` (local clone `.worktrees/cramapple-app`); Production Supabase
`pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`. The plan under review was pasted into the session by David;
its authoring context is not in the repo.
**Scope:** read-only. No code, migration, deployment, secret or Lovable change was made. This document, an index row and
an activity-log entry are the only proposed repository changes.
**Tier of the work it recommends:** Standard for the edge-function slices; Hard-Gate for anything touching the database
or Production.

**Evidence convention.** **Verified** means read in the pinned source, downloaded from the deployed function store,
or returned by a read-only query against the named project. **Inferred** means a conclusion drawn from verified facts.
**Not verified** means not demonstrated by this session. A finding from source review is not a report of an incident.

---

## 1. Caller and contract matrix (plan step 1, delivered)

### 1.1 Edge functions in scope

| Function | Production | Development | Live-app callers (ap-prep-blueprint `e73445d`) | Replay store | Lookup scoped to actor? | Ownership checked before replay? |
| --- | --- | --- | --- | --- | --- | --- |
| `session-event` | v51, deployed 2026-08-03, **byte-identical to `main`** (source last changed 2026-07-30) | v40, created 2026-06-22, never redeployed; legacy build the CLI cannot download | `use-grade-practice.ts`, `live-practice-mcq/session.ts`, `runtime-context-client.ts`; operations used: `session_start`, `session_resume`, `session_end`, `session_save` | `app.audit_events` keyed `(request_id, reason_code)` | **No** | **No.** The replay lookup (`index.ts:81-109`) runs before the `session.user_id !== profileId` check (`:361`). `session_start` has no session to own, so a cross-actor replay would return another user's new session row. |
| `storage-sign-url` | v46, deployed 2026-09-23, byte-identical to `main`; Dev bundle hash identical | same hash as Production | `use-signed-asset-url.ts` (reviewer routes; `use-session-items.ts` only for admin/content_author, students get 403), `attempt-response-client.ts` sign_upload (reachable only via `/hand-drawn-pilot`). Production audit: `sign_download` 55 rows, last 2026-08-13; `sign_upload` **0 rows ever** | `app.audit_events` | **No** | **Yes.** Role/bucket (`canAccessBucket`) and learner-path ownership run at `:112-125`, the replay lookup at `:130`. The stored result omits `signed_url`/`token`, so a replay returns a 200 with no usable URL. |
| `attempt-response` | v42, deployed 2026-10-10, `index.ts` byte-identical to `main`; two bundled `_shared` files are older than `main` (`growth-events.ts` lacks the five TASK-0077 trial event names and the PostHog key fallbacks; `grading-feedback.ts` lacks `stripStrayControlChars`) | same bundle hash as Production | `use-session.ts`, `use-grade-practice.ts`, `attempt-response-client.ts`, `admin.grade-response`; all ten operations used | Edge: `app.audit_events` for every operation except `submit_response`; `submit_response` delegates to the `app.submit_response` RPC | Edge: **Yes** (`.eq("actor_id", actorId)`, TASK-0069 review M3). RPC: **No** | Edge: yes. RPC: **No**, see 1.2 |
| `submit-response` | **not deployed** | v40, created 2026-06-22, never redeployed; legacy build | **none** (0 references outside tests) | `app.submit_response` RPC | n/a | n/a |
| `evaluate-attempt` | v81; bundle hash identical to Development | same | `use-grade-practice.ts`, `runtime-context-client.ts` | `app.grading_results.request_id` (unique) | No | **Yes.** Attempt ownership 403 at `:1308` precedes the lookup at `:1420`. |
| `admin-content` | v43 | v41 | admin only | `app.audit_events` | No | admin-only function; not in scope |

Also in source but absent from Production: `content-intake`, `send-auth-email` (both outside this plan's scope).
Development additionally carries functions with no source directory (`grade-frq`, `open-hand-item`,
`byoq-smoke-runner`, `byoq-ip-echo`).

### 1.2 Database replay paths

| Path | Production body | Development body | Replay key | Actor-scoped? | Notes |
| --- | --- | --- | --- | --- | --- |
| `app.submit_response(…)` | matches the schema baseline (`md5 024e412a`) | logically identical, comment and whitespace differences only (`md5 f15074ff`) | `audit_events (request_id, reason_code='submit_response')` | **No.** Both probes (pre-lock and post-lock) run before the `v_attempt.user_id <> p_actor_id` check | Returns `{attempt_id, response_version_id, status, submitted_at}` on replay. The hash the two Edge callers compute differs (`submit-response` hashes four fields; `attempt-response` hashes the whole body), so the same key sent through the other endpoint is a 409. Only one of those endpoints is deployed. |
| `app.start_home_learning_session_for_user(…)` | **2026-07-31 body** (`md5 de584bfd`): uses `home_exam_pack_is_eligible`, raises `active_session_wrong_subject` | 2026-08-21 body (`md5 dbc35186`): uses `exam_pack_version_is_selectable`, reuses only same-subject sessions | `learning_sessions (user_id, start_idempotency_key)` + fingerprint | **Yes** | Called only by `session-event` for `entry_path='recommend'` without a non-MCQ format. 13 `authoritative_home_start` audit rows ever; 0 `learning_sessions` rows carry a start key today; the last `recommend` session is dated 2026-07-29. Dormant path. |
| `app.record_manual_grade(…)` | identical to Development and `main` | same | `grading_results.request_id` unique | Edge lookup is scoped; admin-only | fine |
| `app.question_issue_reports`, `app.more_help_receipts` (`report-question`, `more-help`) | applied | applied | `unique (user_id, request_id)` | **Yes** | The correct pattern already exists in the repo (migrations `20261013131208`, `20261014001227`). |

### 1.3 Environment facts that change the plan

| Fact | Evidence | Why it matters |
| --- | --- | --- |
| `GRADING_ENTITLEMENTS_ENABLED` is set on Production and its digest equals `sha256("true")`; it is **not set on Development** | `supabase secrets list` on both projects; `printf true | shasum -a 256` | The submit-time entitlement gate is on in Production and off in Development. Development cannot reproduce Production's submit behaviour until the flag is set there. |
| `FRQ_PHOTO_SUBJECTS` is unset on Production, set on Development | same | The photo/transcript requirements the plan wants tested are dark in Production (TASK-0069 state). |
| Production's `supabase_migrations.schema_migrations` lists `20260821011843` and `20260821014327`, but neither migration's function bodies are present | ledger query; `pg_proc` bodies for `app.start_home_learning_session_for_user` and `public.set_active_exam_pack_version` match the 2026-07-31 versions; `20260821050000` (leak fix) **is** present and identical to Development | The ledger cannot be used as proof of Production behaviour, exactly as the plan warned. The missing `set_active_exam_pack_version` body is the one that removes the `active_session_blocks_subject_switch` refusal that TASK-0063 documents as a live student-facing defect. |
| Minimal CI runs a fixed allowlist of 22 Deno test files. `attempt-response/index_test.ts`, `evaluate-attempt/index_test.ts` and `capture-pairing/index_test.ts` are **not** in it | `.github/workflows/minimal-ci.yml:36-62` | The entitlement-gate tests pass locally (9 of 9 with `--allow-env`) but gate nothing. Any "required test" in the plan is inert until the allowlist is extended. |
| `session-event`, `storage-sign-url` and `submit-response` have no tests and call `Deno.serve` at module load | directory listings | They cannot be unit-tested without the `handle(req, deps)` extraction `attempt-response` already uses. |
| `app.audit_events` is readable by `service_role` only; `authenticated` is denied by policy | `pg_policies`, RLS on | A signed-in user cannot read another user's idempotency key from the database. |
| Every live-app key is `crypto.randomUUID()`; Production audit rows show 0 non-UUID keys for session operations and 2 (old) for attempt operations | `runtime-context-client.ts:61`, `attempt-response-client.ts:95`; audit query | Cross-actor replay requires guessing a 122-bit random value. |
| The only client-side retry that reuses a key is the capture submit (`use-session.ts` S3 single-slot cache, keyed per attempt and response version); every other call mints a fresh key | `use-session.ts:971-1033` | "Historical retries" live only for the page session that minted them. |
| `web/` builds and its tests pass today (`vite` 8.3.3, `@vitejs/plugin-react` 6.1.2) | `npm test`, `npm run build` in `web/` on 2026-10-21 | The 2026-10-15 security review's open item 5 (`web/` cannot install or build) is resolved by PR #470's follow-ups; the prototype is not the live app. |

---

## 2. Findings, checked one by one

### F1. Confirmed, hardening, not an incident: three replay paths return a cached result without an actor check

`session-event` (all four operations), `storage-sign-url` (all three modes) and the `app.submit_response` RPC look up
`audit_events` by `(request_id, reason_code)` only. `attempt-response`'s own lookup was scoped on 2026-10-09 and the
newer tables use `unique (user_id, request_id)`, so the codebase already knows the right shape; these three predate it.

**Exposure (inferred):** to receive another user's cached result, a caller must present that user's key and reproduce
the same request hash. Keys are random UUIDs, never leave the client except in the request, and are stored in a table
clients cannot read. The worst case for `session-event` is one `learning_sessions` row (ids, mode, minutes, timestamps),
for `storage-sign-url` a bucket and path with no URL, for `submit_response` four fields the attacker already supplied.
No grades, transcripts or photos are reachable this way. Fix it, but as a Standard-tier hardening slice with the
rest of the replay clean-up, not as an emergency.

### F2. Confirmed, functional: audit-row insert failures are swallowed in `session-event` and `storage-sign-url`

Both functions `await` the `audit_events` insert without reading its error (`session-event/index.ts:112-139`,
`storage-sign-url/index.ts:170-311`). The side effect (session created, URL signed) commits; the replay record does not.
A later retry re-executes rather than replays. With random keys the unique index never trips today, but once lookups are
actor-scoped a cross-actor collision will trip it, so the insert error must be handled in the same change.

### F3. Confirmed, functional: a `storage-sign-url` replay returns no URL

The stored result deliberately drops `signed_url` and `token` (`:240-249`, `:291-300`), so a same-key retry gets
`{bucket, path, expires_in}` and cannot upload or download. The live client never retries with the same key, so this is
latent. Re-signing on replay is safe (signing is read-only) and is the right behaviour.

### F4. Overstated: the "two submission endpoints" problem

`submit-response` is not on Production, is a 2026-06-22 legacy build on Development, and has no caller in the live app.
It lacks the submit-time entitlement gate `attempt-response` added on 2026-09-20 not by policy but because it was never
touched again except for error-code mapping (2026-10-09). The right reconciliation is **retirement** (delete the source
directory and the Development function), not a shared submission command. Hash-transition design, alias tests and
cross-endpoint retry tests then have nothing to protect.

### F5. Not confirmed as intentional: entitlement differences

The `attempt-response` gate is deliberate and documented in its own comment block (`index.ts:100-123`). The absence of a
gate in `submit-response` is neglect of dead code (F4). The Development/Production flag difference (1.3) is unrecorded
and makes Development a weaker test bed than the plan assumes.

### F6. New, student-facing: Production runs 2026-07-31 session RPC bodies under a 2026-08-21 ledger

See 1.3. Two consequences: Home starts on Production still require `home_exam_pack_is_eligible` and refuse when any
active session exists on a different subject; and `set_active_exam_pack_version` still raises
`active_session_blocks_subject_switch`, which is the TASK-0063 symptom. The fix for TASK-0063's second required outcome
already exists on `main` as migration `20260821011843`; it just never reached Production's function store. This needs a
rehearsal on Development and a Hard-Gate approval, and it is more valuable to students than any slice in the plan.

### F7. New, process: CI does not run the tests the plan depends on

See 1.3. Extending the allowlist (and the `--allow-env` list, which must grow to cover `OPENAI_API_KEY`,
`FRQ_PHOTO_RESPONSES_ENABLED`, `FRQ_PHOTO_SUBJECTS`, `GRADING_ENTITLEMENTS_ENABLED` for `attempt-response`) is a
prerequisite for every "required test" in the plan, and is a docs/CI-only change that can land first.

### F8. Confirmed, mechanical: helper duplication

Files defining their own copy (tests excluded): `asString` 22, `sha256Hex` 11, `asUuid` 10, `btoa`/Base64 6,
`x-forwarded-for` parsing 4, `asInteger` 2. Two different UUID regexes are in use (`session-event` accepts any 36
characters of hex and dashes; `submit-response`/`attempt-response` require the 8-4-4-4-12 shape), which confirms the
plan's warning that UUID tightening is a behaviour change. `storage-paths.ts` and `storage-access.ts` already exist as
the extracted, tested form; `storage-sign-url` still carries its own inline copies of both path checks.

### F9. Confirmed, limited: payment-rule duplication

`promotionDiscount` is copied between `create-checkout-session` (`:111-123`) and `create-parent-payment-link`
(`:58-67`); `resolveOffer` and `unknown_subject_keys` handling exist in both with different shapes.
`create-post-purchase-addon` is already a three-line re-export of `_shared/addon-checkout.ts`, and the trial path already
has `trial-promo.ts` with `evaluatePromotion`/`choosePromotion`. The plan's slice 5 is right to extract the pure offer
and price selection first and to keep webhook and trial idempotency out of it; it is smaller than the plan implies.

### F10. Confirmed but low priority: `web/` prototype defects

`content/byoq.js` swallows the storage write error, then `getByoqItem` re-reads storage, so a BYOQ item created while
storage is unavailable is lost and `QuestionRoute` redirects to `/`. `PracticeByoqFrqScreen.jsx:88` carries
`onAttach={() => {}}`. The claim that `verify-screens.mjs` holds stale assertions is **not verified**: its 1440×900
assertions match the prototype's own README rule, and running it needs Playwright Chromium, which this session did not
do. None of this reaches a student: the live app is the Lovable project, and its BYOQ items are server-side rows.

---

## 3. The four questions the plan asked Fable to challenge

1. **Does replay protection cover both Edge and database paths?** No. Edge: two of the four student-facing functions
   are unscoped (`session-event`, `storage-sign-url`); `attempt-response` and `evaluate-attempt` are safe by scoping or
   by ordering. Database: `app.submit_response` is unscoped; the home-session RPC and the newer receipt tables are
   scoped. The fix list is exactly those three, plus F2 which the plan's wording ("reject cross-actor collisions
   safely") requires but which it did not identify as a separate defect.
2. **Do historical retries survive the proposed submission transition?** Yes if the fix adds `actor_id` to the
   **lookup** and leaves every hash formula alone, which is what this review recommends. A retry by the same actor with
   the same key and body still matches. The only client retry that reuses a key lives for one page session, so even a
   hash change would strand at most the submits in flight during the deploy minute. Do not version hashes; there is
   nothing to migrate.
3. **Are the entitlement differences intentional?** The gate in `attempt-response` is. The missing gate in
   `submit-response` is not a decision, it is dead code (F4). The flag difference between Development and Production is
   unrecorded (F5).
4. **Does prototype refactoring warrant priority over live-backend work?** No. `web/` is not on a serving path, builds
   today, and its three defects affect only someone running the prototype locally. Put it last, or drop it.

---

## 4. Revised plan

Ordered by student impact and by how much each slice de-risks the next. Each slice is one PR with the scope, evidence
and rollback recorded in the PR body; database and Production steps keep their separate approval gates.

| # | Slice | Tier | What changes | Rollback / containment |
| --- | --- | --- | --- | --- |
| 0 | **This review and a task record** | Docs | Land this document; open `TASK-0078` with slices 1-6 as its checklist | n/a |
| 1 | **CI runs the edge-function tests** | Docs/CI | Add `attempt-response`, `evaluate-attempt`, `capture-pairing` test files and the missing `--allow-env` names to `minimal-ci.yml`; confirm green on an otherwise empty PR | Revert the workflow file |
| 2 | **Replay ownership, Edge only** (the plan's recommended first scope, narrowed) | Standard | Extract `handleSessionEvent(req, deps)` and `handleStorageSignUrl(req, deps)` behind `import.meta.main` (the `attempt-response` pattern); add `.eq("actor_id", actorId)` to both lookups; read the insert error and return `409 idempotency_conflict` when the unique index trips; re-sign on `storage-sign-url` replay instead of returning the stripped result. **No hash changes.** Tests (fake service, as in `attempt-response/index_test.ts`): same actor + same body replays; different actor + same key is not served; same actor + changed body is 409; insert collision is 409 not 200; admin follows the same rule (an admin's key is the admin's). Deploy to Development, then Production on approval | Redeploy from `df39cd09`. That restores the unscoped lookup, which is acceptable because F1 is not exploitable with random keys; the plan's "rollback must not restore unsafe behaviour" bar is met by that fact, not by a forward-only design |
| 3 | **Retire `submit-response`** | Standard + Dev function delete | Delete `supabase/functions/submit-response/`; delete the Development function; note in the PR that Production never had it. Drop plan items 3's shared command, alias matrix and hash-transition work | Restore the directory from git; nothing to redeploy |
| 4 | **Database: scope `app.submit_response` and reconcile the session RPCs** | Hard-Gate | One migration: add `and actor_id = p_actor_id::text` to both probes in `app.submit_response`; map the resulting unique violation to `submit_response:idempotency_conflict`. A second migration re-applies the `20260821011843` and `20260821014327` bodies to Production after a Development rehearsal, with a decision record that says why the ledger and the bodies disagreed. Verify by `md5(prosrc)` on both projects, not by the ledger. Also set `GRADING_ENTITLEMENTS_ENABLED=true` on Development so it matches Production | `create or replace` back to the baseline body; ledger untouched |
| 5 | **Mechanical helper consolidation** | Standard | One PR per family: `sha256Hex`/Base64; `asString`/`asInteger`/`asUuid` with the **loose** UUID regex kept where it is used today and the strict one where it is; `storage-sign-url` switched to `_shared/storage-paths.ts`; IP extraction kept out of `_shared/byoq.ts`. Byte-parity tests per helper | Revert the PR |
| 6 | **Payments: pure offer and price selection** | Standard, Stripe test mode on Development | Extract `resolveOffer` and `promotionDiscount` into `_shared`; keep webhook and trial idempotency untouched; tests from the plan's list | Revert the PR; no data change |
| 7 | **`web/` prototype** (optional) | Micro | Memory-backed fallback in `content/byoq.js`; remove the no-op `onAttach`; run `verify:screens` once before claiming anything about its assertions | n/a |

**Dropped from the plan:** the versioned-hash transition, the cross-endpoint retry matrix and the field-alias matrix
(all made unnecessary by slice 3); treating the replay fix as needing a forward-only rollback (see slice 2); the
large-handler extraction of `attempt-response` as a goal in itself (do it only where a slice needs a testable seam).

**Kept from the plan unchanged:** preserve `FOR UPDATE` locking and the submission guard trigger; keep entitlement
policy changes out of mechanical PRs; independent review before any Production deploy; one operation family per PR.

---

## 5. Slice 2 specification (ready to execute on approval)

**Files:** `supabase/functions/session-event/index.ts`, `supabase/functions/storage-sign-url/index.ts`, new
`index_test.ts` and `_test_setup.ts` beside each, `.github/workflows/minimal-ci.yml`.

**session-event**
- `loadIdempotentResult(service, requestId, requestHash, operation, actorId)`: add `.eq("actor_id", actorId)`.
- `recordSessionEvent`: capture `{ error }` from the insert; on error throw `new Error("idempotency_conflict")` when
  `error.code === "23505"`, else rethrow. Map `idempotency_conflict` to 409 in the catch block's client-error set.
- Wrap the body in `export async function handleSessionEvent(req, deps = {})` with `deps.requireProfile` and
  `deps.service` overrides; keep `Deno.serve` under `if (import.meta.main)`.

**storage-sign-url**
- Same lookup change and insert-error handling.
- On a matching replay for `sign_upload`/`sign_download`, call the signer again and return a fresh URL with the stored
  `bucket`/`path`/`expires_in`; `sign_delete` keeps returning the stored `{deleted: true}`.
- Replace the inline `isSafeStoragePath`/`ownsLearnerPath` with the `_shared/storage-paths.ts` imports (byte-identical
  logic, already tested).

**Tests** (both functions): same-actor replay returns the original result; different actor with the same key and body
falls through to execution and, on the simulated unique violation, returns 409; same actor with a changed body returns
409; `storage-sign-url` replay carries a `signed_url`; admin is scoped like any other actor; the existing ownership and
role refusals still fire before any replay lookup.

**Evidence to attach to the PR:** `deno test` output; Development deploy fingerprint; a Development run of each
operation twice with the same key (second response identical for `session-event`; second response carries a new URL
for `storage-sign-url`); Production fingerprint equal to Development's before the Production deploy is approved.

---

## 6. Questions for David

1. Retire `submit-response` (slice 3) rather than reconcile it? Recommendation: yes.
2. Re-apply the two 2026-08-21 migration bodies to Production (slice 4) under a new approval, or record that Production
   intentionally runs the July bodies? Recommendation: re-apply; it also closes part of TASK-0063.
3. Set `GRADING_ENTITLEMENTS_ENABLED=true` on Development so rehearsals match Production?
4. Open `TASK-0078` with slices 1-6 now and leave slice 7 out of it?

---

## 7. Evidence appendix

- Function store comparison: `supabase functions download <name> --project-ref pcntajvbdfqhbeewmdry --workdir
  <scratch>` for `session-event`, `storage-sign-url`, `attempt-response`; `diff` against `main` = 0 lines for each
  `index.ts`. Development's `session-event` and `submit-response` returned `expected multipart response, got
  application/octet-stream` (legacy build format) and could not be compared.
- Production function versions and dates: `session-event` v51 (updated 2026-08-03), `storage-sign-url` v46
  (2026-09-23), `attempt-response` v42 (2026-10-10), `evaluate-attempt` v81; `submit-response` absent.
- RPC bodies: `select proname, md5(prosrc) from pg_proc …` on both projects; bodies read in full for
  `submit_response`, `start_home_learning_session_for_user`, `record_manual_grade`, `authorize_grading_access`,
  `set_active_exam_pack_version`, `end_active_learning_session`, `sweep_learning_sessions`.
- Ledger: `select version from supabase_migrations.schema_migrations where version in (…)` on both projects.
- Audit usage: `select reason_code, count(*), count(distinct actor_id), max(occurred_at) from app.audit_events where
  request_id is not null group by 1` on Production (session_start 276 rows / 9 actors; session_resume 230 / 2;
  session_end 122 / 5; create_attempt 114 / 9; save_response 90 / 6; submit_response 88 / 6; sign_download 55 / 2,
  last 2026-08-13; session_save 45 / 1; no `sign_upload` rows).
- Sessions: `select entry_path, practice_format, status, count(*), count(start_idempotency_key) from
  app.learning_sessions group by 1,2,3` on Production: 0 rows carry a start key; last `recommend` row 2026-07-29.
- Access control on `app.audit_events`: policies `audit_events_service_only` (SELECT, service_role) and
  `deny_authenticated_all`; RLS on.
- Secrets: `supabase secrets list --project-ref <ref>` on both projects (names and digests only).
- Live-app call sites: `grep` over `src/` of the clone for each function name and for `operation: "…"` /
  `mode: "…"` literals; `functions.invoke` targets.
- Local test run: `deno test --allow-env supabase/functions/attempt-response/index_test.ts` → 9 passed. Without the
  extra env names it fails at module load (under CI's exact list the first missing name is
  `GRADING_ENTITLEMENTS_ENABLED`, then `OPENAI_API_KEY` and others; correction from
  `TEST_GATE_INVENTORY_2026_10_21.md`, re-run 2026-10-21), which is why it is absent from CI's narrower
  `--allow-env` list.
- `web/`: `npm test` (grade tests pass) and `npm run build` (succeeds) on 2026-10-21.
