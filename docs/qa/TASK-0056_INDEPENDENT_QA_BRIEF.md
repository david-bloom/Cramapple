# TASK-0056 — Independent QA Brief (Answer-Key Direct-Read Exposure)

STATUS: CURRENT (brief for a session that has not started)
ROLE: QA Agent in a **fresh context**. Not the implementing session, not the session that wrote this brief.
Proposes findings only; approves nothing; changes nothing.
TASK: `docs/tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md` · `DECISION-0089` · `APPROVAL-0063` (Dev) · `APPROVAL-0064` (Prod)
UNBLOCKS: `TASK-0051`'s Production gate (`docs/qa/TASK-0051_INDEPENDENT_QA_2026_09_29.md` verdict was BLOCKED on F1)
ENVIRONMENTS: Development `wmgjsdkphcyhngaffbqf` (reads plus **rolled-back** test writes) · Production `pcntajvbdfqhbeewmdry` (**read-only SQL only**)

## What you are checking

The claim under test: **"No student or anonymous caller can read an answer key except through an intended
path."** Intended paths are `public.get_open_hand_item` (records a scoring exclusion) and the grading
response from `evaluate-attempt` (service role, after submission).

The previous QA (TASK-0051) blocked because the task's central claim, "the RPC is the only path to a key",
was false, and the implementer had tested the path they built rather than the paths that existed. **Do not
re-verify what the task says it did. Try to read a key by every route you can think of, then compare with
the claim.** The implementer's guard query is evidence about the implementer's model of the problem, not
about the database.

## Read first (only these)

1. `docs/tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md` (field classification table; execution logs)
2. `docs/qa/TASK-0051_INDEPENDENT_QA_2026_09_29.md` (the §1 rolled-back SQL method; copy it)
3. `scripts/qa/answer_key_exposure_guard.sql`
4. `supabase/migrations/20260930120000_…`, `…120100_…`, `…120200_task0056_…`
5. `docs/handoffs/RESOLUTION_RUNBOOK_2026_09_29.md` traps 1, 6, 7 only

Do not read `docs/research`, `docs/teaching`, `prompts`, `tmp`, `output`. Do not `source .secrets.env`.

## Hard rules

- **Production: read-only SQL.** No `apply_migration`, no deploy, no data writes, no smoke test (it leaves a
  real student record). Any test that needs a write runs on Dev inside a transaction that is always rolled back.
- Dev host: a cloud container's egress proxy can replace `Authorization` headers, so real-JWT HTTP calls
  may be impossible. If so, use SQL with `set local role authenticated` and
  `set local request.jwt.claims` (the mechanism PostgREST uses), inside `begin … rollback`. Say which you used.
- Never paste a secret or a JWT into a report. Never print an actual answer key into a committed file;
  record *that* it was readable, the row count, and one item id.
- Report only what you executed. If a check could not be run, list it under **Not verified**, do not infer a pass.

## Method: enumerate, then attack

### A. Enumerate every route to answer-bearing data (do this before any pass/fail)

Build your own list independently of the guard's `protected` CTE, then compare. At minimum:

1. Every table/view/matview in `public`, `app`, `graphql_public` that `anon` or `authenticated` can
   `SELECT` (table- **or** column-level), and every column of each that could carry an answer, rubric, rationale or
   worked solution. Include columns the task never names: `prompt_json`, `help_text`, `frq_form`,
   `item_package_payload` siblings, `authoring_briefs`, `content_item_checks`, `content_item_labels`,
   `canonical_answer_spans`, anything with `answer`, `key`, `correct`, `rubric`, `rationale`, `solution`,
   `explanation`, `minimum_fix`, `accepted` in its name.
2. Every function in `public`/`app` executable by `anon`/`authenticated` that returns those columns
   (SECURITY DEFINER especially). Check `select_practice_frqs`, `select_unit_gated_practice_items`,
   `get_review_mcq_choices`, `get_review_item_version`, any `cm_d19_*`, `get_*_feedback`, and anything the
   app calls per `src/lib/*.ts` in Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`. Read return
   types and bodies. A function that returns `prompt_json` or `item_package_payload` wholesale is a route.
3. Views that embed a protected column **through an expression, join, or `select *`**, in any exposed schema.
4. Storage buckets (item images, `learner-uploads`, any bucket holding item packages or answer PDFs) and
   their policies. Signed URL creation for objects outside the caller's scope.
5. Edge functions with `verify_jwt = false` that read answer columns with the service role and return them
   (`open-hand-item`, `student-session-items`, `attempt-response`, `byoq`, `review-queue`, anything new).
   Check what they return to a caller who is not entitled.
6. Realtime / `graphql_public` / `pg_graphql` introspection, if enabled, as separate read paths.
7. Default privileges: does a future table or view in `app`/`public` grant to `anon`/`authenticated`
   automatically? The migration comment says Supabase re-grants ALL on recreated views; confirm no view was missed.

### B. Attack matrix (Dev, as `anon`, as a signed-in **student**, as an **unassigned reviewer**, as an **assigned reviewer**, as **admin**)

For each role and each route from A, record: query, result (`OK n rows` / `42501` / `42703` / `0 rows`).
Expected for the classification table in the task: every "never" and "recorded hint" field returns `42501`
or `42703` for `anon`, student, and unassigned reviewer. The reviewer function must return exactly one row
for an assigned reviewer and admin, zero for others.

Then the harder cases:

- **Inference, not just reads.** Can a student learn the key by filtering on a protected column they cannot
  select (`where canonical_answer_1 = 'A'`, `order by`, `count(*)` grouped by a protected column, a
  PostgREST `?canonical_answer_1=eq.A` filter)? Postgres denies a column in `WHERE` without `SELECT`
  privilege, but confirm on both environments, including through the `public` views.
- **Error-message leakage.** Do errors from failed queries or RPCs echo row content?
- **`RETURNING` and `INSERT … SELECT` / `UPDATE … RETURNING`** on tables the student may write
  (attempts, responses) that join to answer tables.
- **Timing/state:** does anything reveal the key *before* submission that the task says is post-submission
  only (`explanation`)? Check the grading response too: is `explanation` returned only after a graded submit?
- **Open Hand:** entitled student gets the key and one exclusion row; unentitled student is refused; a
  second call does not double-count; the item is then refused for scoring (409 from `evaluate-attempt`).
  `get_open_hand_item` exists on **Dev only**. Confirm it does not exist on Production and that nothing
  else references it there.
- **F2 (`.maybeSingle()` → `.limit(1)`):** student with exclusion rows for two versions of one item gets 409,
  not 500. Confirm Production `evaluate-attempt` v70 matches `main` (the task says 24 files byte-identical:
  spot-check three, do not take the count on trust).

### C. Regression: legitimate flows still work

Column revokes fail closed and quietly. Prior sessions found callers whose errors were swallowed
(`graded-feedback.ts`, `review.functions.ts`), so a break shows as an empty screen, not an error.

- Student, Dev: load practice MCQ, load practice FRQ, submit an MCQ and get a graded response with
  feedback text, load a topic brief. Watch the **network tab / API logs** for 400/403/42501/42703, not just
  the UI.
- Reviewer, Dev: open an assigned item that is in-progress **and** one already submitted/closed
  (the fallback path in `getReviewTask` is the one that broke). Unassigned reviewer must be refused.
- Admin: content inventory (`loadContentInventory`) still loads.
- Production (read-only): pull the last 24h of edge/API logs and count 400/401/403 and Postgres
  `permission denied` / `column … does not exist` on `content_item_versions`, `frq_criteria`, `mcq_choices`,
  `get_review_item_version`. Compare with a same-length window **before** the apply
  (the apply is recorded in the task file; use the ledger timestamp). Any *new* error class is a finding.
  Exclude the pre-existing failures the task already lists (`get_graded_choice_feedback`,
  `get_chosen_distractor_rationale` do not exist; `fetchRevealedKey` already fails).

### D. The guard itself

- Run `scripts/qa/answer_key_exposure_guard.sql` on Dev and Production. Expect no rows.
- Then **try to fool it**: on Dev, inside a rolled-back transaction, add a `select *` view over a protected
  table, a view that aliases a protected column, a SECURITY DEFINER function returning one, a column added
  to a protected table. State which the guard catches and which it misses. A guard that only checks
  the columns it already knows is a regression detector, not a leak detector; say so if that is the case.
- Check `.github/workflows/servable-items-check.yml`: does `answer-key-exposure-guard` run against Production,
  and does it fail loudly on a row? Was its first post-apply run green?

### E. Records and hygiene

- Migration ledger vs files, both environments: MD5 of each `supabase_migrations.schema_migrations.statements`
  body for the three TASK-0056 versions equals the committed file (runbook Trap 1). The task says the versions match
  on Dev and Prod with no renames; verify, do not assume.
- `20260827010001` (the Dev replay of the `mcq_choices` view fix): confirm Dev and Prod `public.mcq_choices`
  no longer project `is_correct`/`rationale`.
- Advisors (`get_advisors` security) on both: list anything new since the apply, especially SECURITY DEFINER
  functions in exposed schemas and views without `security_invoker`. The task lists
  `app.cm_d19_release_template` / `app.cm_d19_revoke_template_release` as executable by `anon`/`authenticated`;
  check whether they are still, and whether that matters now.
- The task file's own dates (2026-09-30) and approval numbers: confirm `APPROVAL-0063/0064` exist in
  `docs/activity_log/APPROVALS_LOG.md` and say what they cover. Anything executed beyond that scope is a finding.
- Rollback: the migration header records how to restore. Confirm it is complete enough to use (do **not** run it).

## Known, not findings (don't re-report)

- `get_graded_choice_feedback` and `get_chosen_distractor_rationale` are not built; the UI shows a labelled
  placeholder (homework-help "Ask for help" surface, not Practice MCQ).
- `help_text` is classified student-visible on purpose (generic coaching, 254 published versions).
- `mcq_choices.is_correct/rationale` and `canonical_answer_spans` were already `42501` before this task.
- TASK-0055 ledger drift (72+ Prod-only migrations) and `db push` being unsafe.
- No real student has ever been graded in Production; absence of exploitation in the logs is not evidence
  of safety, only of no use so far.

## Output

Write `docs/qa/TASK-0056_INDEPENDENT_QA_<date>.md` in the format of the TASK-0051 report:

1. **Verdict:** `PASS`, `PASS WITH FINDINGS`, or `BLOCKED`, with a two-paragraph reason.
2. **Findings**, most severe first, each with: what, evidence (query and result, row counts, never key
   contents), why it matters, proposed fix, and *who* must decide. Severity: BLOCKER = a student or `anon`
   can read a key/rubric/explanation before submission by any route; MAJOR = a legitimate flow breaks;
   MINOR = hygiene or guard blind spots.
3. **Access matrix** (role × route × result) for both environments.
4. **Not verified**, with the reason for each (proxy, no data, no permission).
5. **Recommendation** on `TASK-0051`'s Production gate. You recommend; David decides.

Open a docs-only PR from a fresh branch. Do not merge it. Do not update the TASK-0056 status yourself:
the implementing session and David own that.
