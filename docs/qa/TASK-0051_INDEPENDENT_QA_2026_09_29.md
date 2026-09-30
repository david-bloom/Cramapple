# TASK-0051 — Independent QA (Open Hand: one gated answer-key path)

STATUS: CURRENT
DATE: 2026-09-29
ROLE: QA Agent (fresh context, not the implementing session). Proposes findings only; approves nothing.
TASK: `docs/tasks/TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md` · DECISION-0086 · APPROVAL-0061 / APPROVAL-0062
ENVIRONMENTS: Development `wmgjsdkphcyhngaffbqf` (reads plus rolled-back test writes) · Production `pcntajvbdfqhbeewmdry` (read-only SQL only)

## Verdict: **BLOCKED**

The RPC does what it says. `public.get_open_hand_item` enforced every access rule I threw at it, and
`evaluate-attempt`'s exclusion check is keyed on the item, runs before any answer table is read, and fails
closed. The table hotfix matches between Dev and Production.

The block comes from the claim the task is built on: **"The RPC is the only path to a key."** That is false.
Any signed-in user can read MCQ answer keys directly through PostgREST, with no entitlement check and no
exclusion row, from three places the task never examined: `content_item_versions.canonical_answer_1/2`,
`.explanation`, and `.item_package_payload` (`mcq_form.options[].correct`). This predates TASK-0051, but it
makes the scoring-exclusion guarantee meaningless: a student can read a key without Open Hand and still be
scored. **The same grants, policies and data are live in Production today.** Until that is closed, the
Production gate (last Verification item) should not proceed, and the exposure is launch-relevant on its own.

What was blocked in this QA run (see F7): this container's egress proxy replaces the caller's
`Authorization` header on the Dev host, so no real-JWT HTTP call could be made. The access matrix therefore
ran as SQL with `role` and `request.jwt.claims` set per case (the same mechanism PostgREST uses), inside
transactions that were always rolled back. The implementer's e2e script could not be independently
reproduced past the point where it first needs a user JWT.

---

## Findings (most severe first)

### F1 — BLOCKER · Answer keys are readable directly, outside the atomic disclose-and-exclude path

**What.** `authenticated` holds column-level `SELECT` on `app.content_item_versions` columns that carry
the answer: `canonical_answer_1`, `canonical_answer_2`, `explanation` and `item_package_payload`. RLS policy
`content_item_versions_select_published` returns every published version. The `app` schema is exposed
through PostgREST, and a `security_invoker` view `public.content_item_versions` re-exposes
`canonical_answer_1/2` and `explanation` in the always-exposed `public` schema. Neither path checks
entitlement or writes an exclusion.

**Evidence — Dev, executed as `authenticated` with a real student's `sub`** (rolled-back DO block, cases 17–21):

| Query as student `cd84a912…` | Result |
| --- | --- |
| `select … from app.content_item_versions` | OK: 211 published rows, **50 with a non-empty `explanation`** |
| `… where item_package_payload->'mcq_form'->'options' @> '[{"correct":true}]'` | OK: **203 versions expose which option is correct** |
| `select explanation from public.content_item_versions` | OK: 50 rows (the public view path) |
| Item `806f9b1d…`: `explanation`, and the option with `correct=true` | Returned the worked answer and the correct option's text |
| `select is_correct` / `rationale` from `app.mcq_choices` or `public.mcq_choices` | `42501 permission denied` (this boundary holds) |
| `select span_text from app.canonical_answer_spans` | `42501 permission denied` (holds) |

PostgREST exposure on Dev, by HTTP: `Accept-Profile: nosuchschema` →
`PGRST106 "Only the following schemas are exposed: public, graphql_public, app"`.

**Evidence — Production, read-only SQL:**

```sql
-- column grants to authenticated on app.content_item_versions
canonical_answer_1, canonical_answer_2, explanation, help_text, item_package_payload
-- public views: content_item_versions (security_invoker, authenticated=select), mcq_choices, frq_criteria
-- policies on app.content_item_versions: content_item_versions_select_published (+ reviewer, admin)
-- published data carrying the key:
canonical_answer_1 not null:  928 published versions  (380 MCQ, e.g. "A"; 548 FRQ model answers)
explanation non-empty:        391
item_package_payload correct: 203
frq_criteria rows (published): 2,896 (evidence_requirements / accepted_variants / minimum_fix)
```

I could not reach the Production host over HTTP to confirm `app` is in its exposed-schema list. The
`public.content_item_versions` view does not depend on that: `public` is always exposed, and the view is
`security_invoker` with the same grants and RLS as Dev.

**Why it blocks TASK-0051.** DECISION-0086 D2 and the task's §6 rest on the RPC being the security
boundary. The task's Development-verification section says *"The RPC is the only path to a key."* The
Verification item "`anon` and `authenticated` still cannot directly select `mcq_choices.is_correct` or
`.rationale`" is literally true, but it is the wrong test: the same key sits one table over. An exclusion
that a student can sidestep by reading `canonical_answer_1` is not a scoring-integrity guarantee.

**Proposed fix (needs David; this is a data-exposure change, not a QA edit):**
1. `revoke select (canonical_answer_1, canonical_answer_2, explanation, item_package_payload) on app.content_item_versions from authenticated;`
   and drop those columns from `public.content_item_versions`, or give the view an explicit safe column
   list. Before revoking, check what student-facing code reads them with a user-scoped client. Edge
   functions use `service_role` and are unaffected.
2. Decide explicitly whether `frq_criteria.evidence_requirements / accepted_variants / minimum_fix` are
   student-visible by design (DECISION-0080 treats the rubric as a pre-submission hint aid). If they are,
   they should go through a path that records hint use, not a raw view.
3. Add a Verification item that lists **every** answer-bearing column (the ones above, plus
   `mcq_choices.is_correct/rationale` and `canonical_answer_spans`) and asserts `authenticated` cannot
   select any of them. Run it on both environments.

### F2 — MEDIUM · `evaluate-attempt` returns 500, not 409, once a student has two exclusion rows for one item

`supabase/functions/evaluate-attempt/index.ts:1367-1373` reads exclusions with
`.eq("user_id").eq("content_item_id").maybeSingle()`. The table's primary key is
`(user_id, content_item_version_id)`, so one student can hold **several rows for the same item**: view v1,
the item is republished (v1 retired, v2 published), then view v2. With more than one row, `maybeSingle()`
returns an error, the handler returns **500 `open_hand_eligibility_check_failed`**, and it keeps doing so
for that student and item permanently.

It fails closed, so integrity holds, but the client sees a server error instead of the documented `409`.
Republishing is routine: Production has **588** items with more than one version (a unique index enforces
at most one *published* version at a time, which is exactly the v1-then-v2 path).

**Fix:** replace `.maybeSingle()` with `.limit(1)` and test `data.length > 0`. Add a unit test with two rows.

### F3 — MEDIUM · Dev still runs a deployed `open-hand-item` (v9) that is not in the repo

`list_edge_functions` on Dev shows `open-hand-item` v9 (ACTIVE, `verify_jwt=true`, created 2026-09-27).
There is no `supabase/functions/open-hand-item` on `main`. Per the task record it is #256's batch function,
which reads `mcq_choices`/`frq_criteria`/`canonical_answer_spans` directly and writes no exclusion. That is
an answer-bearing path outside the RPC on Dev. I confirmed the deployment, not the source.

**Production does not have it** (verified). That meets the task's hard rule. But the Lovable client's
dormant batch caller (`src/lib/open-hand/client.ts`, per the task record) would bind to any function of that
name, so this stays one CLI deploy away from exposure.

**Fix:** carry out the task's own recommendation once David confirms it: delete `open-hand-item` from Dev,
and add the acceptance line that no app code calls `functions.invoke("open-hand-item")`.

### F4 — LOW · The task record is stale or inconsistent in places

- *"Serving side is unaware of exclusions … zero references exist under `supabase/`"* is no longer true.
  `student-session-items` calls `annotateOpenHandExclusions` (`student-session-items/index.ts:738`), which
  marks items `open_hand_excluded: true` and fails closed (every item marked on a lookup error). That is a
  deliberate mark, not a filter. `public.get_home_start_queue` is still unaware. The known negative (an
  excluded item can still be *served*) remains accurate. The sentence claiming zero references should be
  corrected.
- Function versions have moved. Production `evaluate-attempt` is **v68** and Dev is **v34** (the record says
  v67/v33), with the same `ezbr_sha256` `5bd994f2…` in both. So Dev and Production still run the same
  bundle, which is the claim that matters.
- Production `student-session-items` (v27, `f3e6ebb3…`) and Dev (v18, `c13586ab…`) differ, so the
  exclusion annotation is not verified as live in Production. That is harmless while Production has no RPC.

### F5 — LOW · The hotfix is the table section plus one statement

`20260929130754` equals the table section of `20260929034129` (from `create table if not exists` to the
`grant select … to service_role`) **byte-for-byte**, plus a trailing `notify pgrst, 'reload schema';`.
"Nothing else" is off by that one line. It is harmless. Both ledgers record `20260929130754` with
identical statement hashes (`md5 = 61bfd3b0fce9dec3057cbd92ba8031b8` on Dev and on Production).

### F6 — INFO · Advisors (Dev)

Findings that touch these objects:
- `rls_enabled_no_policy` INFO on `open_hand_scoring_exclusions` (1 of 22): intentional. RLS is forced with no
  policy, so it is deny-all. Only `service_role` has `SELECT`. Verified: a student's `SELECT` and `DELETE`
  on the table both get `42501`.
- `authenticated_security_definer_function_executable` WARN on `get_open_hand_item` (1 of 16): required by
  DECISION-0086. It does **not** appear in the `anon` list, and an anon call returns
  `42501 permission denied for function`.
- `unindexed_foreign_keys` INFO on `open_hand_scoring_exclusions` (`content_item_id`,
  `content_item_version_id`): neither index leads with those columns, so cascade deletes from items or
  versions scan the table. This is negligible at current size. **Not mentioned in the task record.**
  Optional fix: add indexes if the table grows.
- `multiple_permissive_policies` / `auth_rls_initplan` on `content_item_versions`, `mcq_choices` and
  `frq_criteria`: pre-existing performance findings, not introduced here.

Not advisor findings, but worth recording: `learning_session_id … on delete restrict` means any future
deletion of a learning session that has an exclusion row will fail. Account deletion cascades from
`auth.users`, so it is unaffected. `grade-frq` (Production v28) grades the legacy
`public.student_attempts`/`public.questions` model, not `app.content_items`, so it is not an exclusion
bypass for this content model.

### F7 — INFO (test gap) · Live-JWT checks could not run from this QA environment

The Dev-host credential injection **replaces** the caller's `Authorization` header:
- `GET /auth/v1/user` with a fresh student's access token returned no user;
- `POST /rest/v1/rpc/get_open_hand_item` with that token returned `28000 not_authenticated`, i.e.
  `auth.uid()` was NULL, so the request ran as `service_role`, not as the student;
- `student-session-items` with the token returned `401 unauthorized`.

So "anonymous refused" and every per-user case could not be exercised over HTTP from here. They were
exercised at SQL level (below). The implementer's live run (David's Mac, 16/16 passing) remains the only
real-JWT evidence. **Not tested at all:** PostgREST `GET` against the volatile RPC (expected to fail,
because the transaction is read-only) and `Prefer: tx=rollback` (expected to be ignored under Supabase's
default `db-tx-end=commit`). Both would need a real JWT; a rollback that kept the key but dropped the
exclusion would defeat the atomicity guarantee. **Proposed:** add both to `open_hand_e2e_dev.mjs` and run
them from a machine with an unproxied route.

---

## What was verified, and how

### 1. Security boundary — `get_open_hand_item` (Dev)

Definition check (`pg_proc`): one overload `get_open_hand_item(uuid,uuid)`, `SECURITY DEFINER`, owner
`postgres`, `search_path=pg_catalog`, volatile, ACL
`{postgres=X, authenticated=X, service_role=X}` (no `anon`, no `PUBLIC`). Every relation in the body is
schema-qualified. The staff check reads `app.profiles.role` for `auth.uid()`. There is no caller-supplied
flag, and the function has no parameter that could carry one.

Self-escalation: `authenticated` has column `UPDATE` on `app.profiles.role`, but trigger
`profiles_prevent_role_change` blocks it unless `request.jwt.claim.role = 'service_role'`. Tested (case 04):
`ERR P0001 role changes are server-side only`.

**Access matrix.** Every case ran inside a DO block that ends in `raise exception`, so nothing persisted.
Each call set `role` and `request.jwt.claims` to the named caller. Fixtures: student `cd84a912…`
(role `student`, no active entitlement), tutor `b28945b2…`, AP Statistics item `806f9b1d…`, draft
version `4fdb2817…`, foreign session `210d4771…` (owner ≠ student, checked), other-subject item
`f7368cb5…`.

| # | Case | Result |
| --- | --- | --- |
| 01 | `anon` | `42501 permission denied for function get_open_hand_item` |
| 02 | Unentitled student | `42501 open_hand:entitlement_required` |
| 03 | Unentitled student with spoofed `user_role:"admin"` / `app_metadata.role:"admin"` claims | `42501 open_hand:entitlement_required` |
| 04 | Student `UPDATE app.profiles SET role='tutor'` | `P0001 role changes are server-side only` |
| 05 | Tutor, no entitlement | OK, `exclusion_recorded:false`, `scoring_eligible:false`; **0** exclusion rows for tutor |
| 06 | Student whose only entitlement has expired (`ends_at` < now) | `42501 open_hand:entitlement_required` |
| 07 | Entitled student + foreign `learning_session_id` | `42501 open_hand:session_not_accessible`; **0** exclusion rows written |
| 08 | Entitled student, draft version | `42501 open_hand:item_not_accessible` |
| 09 | Entitled student, pack `retired_at` set (in-transaction) | `42501 open_hand:item_not_accessible` |
| 10 | Entitled student | OK, `exclusion_recorded:true`, 4 choices / 1 correct; second call OK; **exactly 1** row, `content_item_id` set, `learning_session_id` null |
| 11 | Entitled for AP Stats, item in another subject | `42501 open_hand:entitlement_required` |
| 12 | Student `SELECT` / `DELETE` on `app.open_hand_scoring_exclusions` | `42501` both |

After-state SQL (Dev): `subject_entitlements` for the fixture student = 0; `open_hand_scoring_exclusions` =
0 rows; AP Stats `retired_at` = null; fixture role = `student`.

Other `authenticated`-executable functions touching answer tables (`pg_proc` scan of `public`/`app`):
only `get_open_hand_item` and `get_review_mcq_choices`. The latter is gated on an active review assignment
or `role='admin'`, read from `app.profiles`.

### 2. Scoring integrity — `evaluate-attempt` and serving

- Order of reads before the exclusion check (`index.ts:1246-1383`): auth/profile, `prompt_versions`,
  `attempts`, `response_versions`, `content_item_versions.content_item_id`. None of these is
  answer-bearing. The first answer-bearing reads (`content_item_versions` full row, `frq_criteria`,
  `mcq_choices`) come after the `409` return.
- Keyed on `content_item_id`, resolved server-side from the version id, so republishing does not reset it. ✔
- Fails closed: a failed version lookup or exclusion read returns 500 and grading does not proceed. ✔ (See F2 for the multi-row case.)
- An idempotent replay of a grade recorded *before* the exclusion now returns 409. Acceptable.
- Serving: `annotateOpenHandExclusions` is keyed on `content_item_id` and fails closed. It is a mark, not a
  filter, by design (see F4).

### 3. Hotfix and Dev/Production parity (read-only SQL on both)

| Object | Dev | Production |
| --- | --- | --- |
| Columns | `user_id` NN, `content_item_version_id` NN, `learning_session_id` NULL, `disclosed_at` NN `now()`, `content_item_id` NN | identical |
| Constraints | PK `(user_id, content_item_version_id)`; FKs: user→auth.users CASCADE, version CASCADE, item CASCADE, session RESTRICT | identical |
| Indexes | pkey; `open_hand_scoring_exclusions_user_item_idx (user_id, content_item_id)` | identical |
| RLS | enabled + forced, 0 policies | identical |
| ACL | `postgres=arwdDxtm, service_role=r` | same, plus `content_reviewer=r` (pre-existing `app` default privilege; zero rows under forced RLS, as the task record says) |
| Rows | 0 | 0 |
| `get_open_hand_item` | 1 overload | **none** ✔ |
| Ledger | `20260928023843`, `20260929034129`, `20260929130754` | `20260929130754` only ✔ |
| `open-hand-item` edge function | **deployed v9** (F3) | **absent** ✔ |

### 4–5. Live Dev runs

- `scripts/open_hand_e2e_dev.mjs` as written: stops at check 0 (`401 Invalid API key`) because its
  `Authorization: Bearer <placeholder>` header defeats the injected credential.
- Copy at `tmp/qa_task0051/e2e_copy.mjs` (not committed; the only change removes the `apikey` and
  `Authorization` headers from service calls): passed checks 0–5 (created a student, signed in, granted an
  entitlement, set the active pack, started a session), then failed at `student-session-items → 401` for
  the reason in F7. Cleanup passed.
- Post-run SQL (Dev): 0 `smoke+oh-%` / `qa+%` users, 0 entitlements with source `smoke_test_task0051`,
  0 exclusion rows, 0 orphaned `learning_sessions` or `attempts`.

### 6. Known-negative and open items in the task record

- **Serving isn't aware of exclusions.** Named and accurate in substance; the wording is stale (F4).
- **List-endpoint pool burn (item 5).** Accurately named and correctly left unticked. It stays inert only
  while no batch `open-hand-item` exists in Production (currently true) and matters again the moment one is
  deployed (F3).
- **TASK-0052 dependencies.** Named correctly (frontend wiring, 409 handling, per-load exclusion count).
- **Missing from the record:** F1 (launch-relevant on its own), F2, and the FK-index note in F6.

---

## Verification items I would tick

| Item | Tick? | Basis |
| --- | --- | --- |
| Amended RPC on Dev; entitlement-scoped; staff/QA view without exclusion | **Yes** | SQL-level matrix cases 02, 05, 10 (live JWT not possible here, F7) |
| Anonymous, unentitled, retired-pack, unpublished calls fail | **Yes** | Cases 01, 02, 09, 08 (+ expired entitlement 06, other subject 11, foreign session 07) |
| Called twice → one exclusion row | Yes (already ticked) | Reproduced, case 10 |
| One Open Hand load writes exactly N exclusions | **No** | Frontend, TASK-0052 |
| Direct PostgREST call gets same entitlement check and write | Yes (already ticked) | Reproduced at SQL level; the live proof is the implementer's run |
| Staff/QA: key returned, no exclusion row | **Yes** | Case 05 |
| Known negative (served-but-409) recorded | **Yes** | Recorded; wording needs correcting (F4) |
| Dev/Production object parity | **Yes** | §3 table |
| `anon`/`authenticated` cannot select `mcq_choices.is_correct`/`.rationale` | **Yes, literally, and insufficient** | Cases 13–15. **Add a new blocking item for F1.** |
| End-to-end view → submit → 409 | Leave as ticked on the implementer's evidence | **Not independently reproduced** (F7) |
| Never-viewed item scores normally | Same as above | Not independently reproduced |
| Advisors run; new INFO/WARN explained | **Yes** | F6 |
| Fresh independent QA | **Yes, with findings** | This document |
| Production: migration + deploys on David's approval | **No** | Blocked on F1 |

**New item proposed:** *"No answer-bearing column (`content_item_versions.canonical_answer_1/2`,
`.explanation`, `.item_package_payload`; `mcq_choices.is_correct/.rationale`; `canonical_answer_spans`;
and, if so decided, `frq_criteria` rubric fields) is selectable by `authenticated` or `anon` through any
exposed schema or view, on Dev and Production."*

## Housekeeping

- No code, migrations or deploys were changed. The only writes were on Dev: one e2e student (deleted by
  the script), one probe user (deleted), and SQL test writes inside rolled-back transactions. The SQL
  after-state is recorded above.
- Test scripts live under `tmp/qa_task0051/` and are not committed.
