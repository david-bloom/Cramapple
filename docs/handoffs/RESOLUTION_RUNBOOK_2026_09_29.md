# Resolution Runbook — opened 2026-09-29

**Purpose:** an ordered, executable plan for everything left open by the 2026-09-29 session, written
so a new session does **not** have to reconstruct what the last one knew. Every step states its
precondition, the exact command, how to tell it worked, and how to undo it.

**Read with:** `docs/handoffs/SESSION_CLOSE_2026_09_29_MCQ_FEEDBACK_AND_SKILL_WORK.md` (what
happened and why). This file is the *what to do next*.

> **Status at close of the execution session (2026-09-29, evening).** Step 1 is done (PR #272). Step
> 1b is done: a Production grading hotfix, APPROVAL-0062. Step 2 passed on Dev; the Production run is
> still David's. Step 3 (TASK-0051) passed its live Dev end-to-end, but **independent QA set it
> Blocked**. Any signed-in student can read answer keys directly from `content_item_versions`
> (finding F1). F1 is now **TASK-0056** (DECISION-0089, launch-gating), in PR #278. Do not take the
> TASK-0051 Production gate until TASK-0056 lands and a fresh QA passes. Full close-out:
> `docs/handoffs/SESSION_CLOSE_2026_09_29_RUNBOOK_EXECUTION.md`.

---

## 0. Facts you need before touching anything

| Thing | Value |
|---|---|
| Production project ref | `pcntajvbdfqhbeewmdry` |
| Development project ref | `wmgjsdkphcyhngaffbqf` |
| Supabase CLI link (`supabase/.temp/project-ref`) | **Dev**, not Prod — always pass `--project-ref` explicitly |
| Prod publishable key | `sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT` |
| Dev publishable key | `sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt` |
| Secret key | `.secrets.env` → `SUPABASE_SECRET_KEY`. **Production only** (verified: Dev 401, Prod 200). There is **no Dev secret key on this machine.** |
| Frontend | Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e` (app) — **not in this repo** |

**Do not `source .secrets.env`.** Its `OPENAI_API_KEY=` line has a leading space, so the shell tries
to execute the value. Parse it instead:

```bash
K=$(grep '^SUPABASE_SECRET_KEY=' .secrets.env | cut -d= -f2- | tr -d ' "')
```

Secret keys are **not JWTs**. Send them as the `apikey` header. Sending one only as
`Authorization: Bearer` authenticates as anon and the call silently under-reads.

---

## STEP 1 — Merge PR #272 (skill dimension + five recovered migrations)

**Priority: do this first.** Production already carries the effects of this branch; `main` does not.
Until it merges, the schema cannot be rebuilt from source and a `supabase db push` is unsafe.

**Precondition:** CI green. The branch was brought up to date with `main` on 2026-09-29; if `main`
has moved again the merge will report `BEHIND`, which is not a conflict — update and re-push:

```bash
git checkout claude/task-0050-statistics-phase-b && git merge origin/main && git push
```

> If that errors with `already used by worktree`, the branch is checked out in a scratchpad worktree
> from the previous session. Either `cd` to the path in the error, or `git worktree remove <path>`
> first. A fresh session usually will not have this.

**Do it:**

```bash
gh pr checks 272 && gh pr merge 272 --merge --delete-branch
```

**Verify:** the five migration files are on `main` and each maps to a version Production recorded.

```bash
git checkout main && git pull && ls supabase/migrations/ | grep 20260929
```

Expect exactly these, and **no** `20260929113000_*`:
`20260929034129_open_hand_entitlement_scoped_contract.sql`,
`20260929071941_task0050_apstats_phase_b_skill_codes.sql`,
`20260929102858_task0050_apcalcab_topic_pass.sql`,
`20260929102917_task0050_move_bc_only_items_from_apcalcab.sql`,
`20260929103749_taxonomy_scope_selftest.sql`,
`20260929110501_task0050_apcalcab_phase_a_grid.sql`.

**No Production write happens here.** These migrations are already applied; a recorded version is a
no-op for `db push`.

**Done 2026-09-29** — merged as `13bb2ba`. All five files were checked against Production's ledger
before the merge: four are byte-identical, and `110501` is the recorded SQL with a comment-only
header added.

---

## STEP 1b — Production grading hotfix (done 2026-09-29, `APPROVAL-0062`)

`evaluate-attempt` v67 read `app.open_hand_scoring_exclusions`, which did not exist in Production,
so every graded submission would have returned 500. Fixed by creating that table alone
(`20260929130754_open_hand_scoring_exclusions_table_only.sql`) in Dev and Prod, with the same
ledger version in both. Details: TASK-0051 § "Production hotfix". **Step 2 was not runnable
before this fix** — it would have failed at grading.

---

## STEP 2 — Run the student submit-to-grade smoke test

**Owner: David.** He said he will run it *immediately before handing the app to test students*. Do
not run it earlier "to be safe" — see the warning below.

**Why it exists:** no brand-new student has ever been taken from signup to a graded answer against a
deployed environment. `evaluate-attempt` v67 (the new MCQ feedback) is live in Production but
**nobody has submitted a wrong answer through it.** `TASK-0053`'s verification criterion is
deliberately unticked for this reason.

**Development run — PASSED 2026-09-29 (18:33 UTC), run by David.** This is the first time a brand-new
student has gone from signup to a graded wrong answer on a deployed environment. The distractor
chosen got its authored rationale back ("Not quite. Look again at the choice you picked: Predicted the
intercept, ignoring the explanatory variable…"), scored zero, and did not get the retired
placeholder. Dev runs the same `evaluate-attempt` bundle as Production v67. The test student was
deleted afterwards and SQL confirmed nothing was left. **The Production run below is still David's,
immediately before test students.**

Before that run, PR #270 fixed five calls in the script that didn't match the deployed code.
Submission goes through `attempt-response` `submit_response`: Production has no `submit-response`
function. Grading is `grade_initial_attempt`. It also fixed a `check()` bug that would have printed
ALL CHECKS PASSED after stopping early.

**Precondition:** PR #270 merged (done 2026-09-29).

```bash
SMOKE_URL=https://pcntajvbdfqhbeewmdry.supabase.co \
SMOKE_PUBLISHABLE_KEY=sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT \
SMOKE_SECRET_KEY=$(grep '^SUPABASE_SECRET_KEY=' .secrets.env | cut -d= -f2- | tr -d ' "') \
node scripts/student_grade_smoke.mjs
```

**Expect:** `ALL CHECKS PASSED`, and a printed block headed `--- what the student reads ---`
containing the authored rationale for the distractor it chose. It fails if the retired placeholder
("published correct answer") comes back, or if the feedback does not contain that rationale.

> ⚠️ **This writes to Production.** It creates a real auth user, a learning session, an attempt, a
> response and a `grading_results` row. The email is `smoke+grade-<timestamp>@cramapple.test`. It
> does **not** clean up after itself — deliberately, so the run is inspectable. Every synthetic
> student counts against the "zero real students" invariant used for analysis, so delete it when
> done.

**Cleanup:**

```bash
K=$(grep '^SUPABASE_SECRET_KEY=' .secrets.env | cut -d= -f2- | tr -d ' "')
# find the user id
curl -s "https://pcntajvbdfqhbeewmdry.supabase.co/auth/v1/admin/users?per_page=200" \
  -H "apikey: $K" -H "authorization: Bearer $K" | grep -o '"id":"[^"]*","[^"]*email":"smoke+grade[^"]*"'
# then, per id:
curl -s -X DELETE "https://pcntajvbdfqhbeewmdry.supabase.co/auth/v1/admin/users/<USER_ID>" \
  -H "apikey: $K" -H "authorization: Bearer $K"
```

Confirm the attempt rows are gone afterwards; if any `app.attempts` row survives the auth delete,
remove it by `user_id` before declaring cleanup complete.

**Running it on Dev** (done 2026-09-29, passed). David's Mac now has `SUPABASE_DEV_SECRET_KEY` in
`.secrets.env`. Swap `SMOKE_URL`/`SMOKE_PUBLISHABLE_KEY` to the Dev values in §0, and read the key
without sourcing the file:
`SMOKE_SECRET_KEY="$(grep '^SUPABASE_DEV_SECRET_KEY=' .secrets.env | cut -d= -f2- | tr -d ' "')"`.
Dev has no `start-trial` function, so the script grants the subject directly and prints a note
saying so.

---

## STEP 3 — Open Hand (TASK-0051, then TASK-0052)

Not started as of 2026-09-29. **Order matters: 0051 before 0052.**

- `docs/tasks/TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md` — backend. Remaining: live end-to-end
  (view key → submit → expect 409), fresh independent QA, then the Production Hard Gate.
- `docs/tasks/TASK-0052-OPEN-HAND-FRONTEND-WIRING.md` — Lovable rewire. **Blocked on 0051.** This is
  the change that first exposes real answer keys to real students.

Two things the task file records that are easy to get wrong:
- The **RPC**, not the edge function, is the security boundary (`get_open_hand_item` is granted to
  `authenticated`).
- A wired, dormant answer-key path **already exists** in the frontend (`?loop=plate` enables it and
  persists to `localStorage`). Per DECISION-0087 that override must be removed, and
  `open-hand-item` deleted — replaced, not adapted.

---

## STEP 4 — TASK-0055, migration ledger reconciliation

**Not launch gating.** Do after launch unless a `db push` is needed sooner, in which case do it
first — a push today is unsafe.

**Reproduce the finding** (read-only):

```sql
-- against Production
select count(*) from supabase_migrations.schema_migrations where version >= '20260901';
```

```bash
git ls-tree -r --name-only origin/main supabase/migrations/ \
  | sed 's|.*/||; s|_.*||' | grep -E '^[0-9]{14}$' | awk '$0>="20260901"' | sort -u | wc -l
```

On 2026-09-29 these were **185** and **113** — at least 72 migrations exist only in Production.

**Drift runs the other way too.** Development's ledger does not record PR #272's five migrations
(`20260929071941`…`110501`). Before `20260929130754` was added, the newest version it recorded was
`20260929034129`. Those five were applied to Production only, so Dev is missing the skill-dimension
data and `app.taxonomy_scope_selftest()`. Reconciliation should cover Prod→Dev as well as
Prod→repo.

**Recovery recipe** (this is how PR #272's five were recovered, verbatim and byte-exact):

1. The SQL lives in `supabase_migrations.schema_migrations.statements`.
2. That schema is **not exposed via PostgREST** (`PGRST106`), so read it through the Supabase MCP
   `execute_sql`, not curl.
3. Large payloads blow the context. Force the tool to spill to a file by padding the result, then
   extract with a script rather than transcribing:

```sql
select jsonb_build_object(
  'migrations', (select jsonb_agg(jsonb_build_object('version', version, 'name', name,
      'sql', array_to_string(statements, E'\n')) order by version)
    from supabase_migrations.schema_migrations where version in (...)),
  'pad', repeat('x', 140000))::text;
```

The tool reports a saved path. That file is JSON `{"result": "...."}`; parse the outer object, find
the `[{"bundle":` array inside `result`, then `json.loads` the bundle string.

4. Name each file with the **recorded** version, never a timestamp you chose.
5. Sanity check: the written file's byte count should equal `length(array_to_string(statements,E'\n'))` + 1.

---

## Parked — do not pick up without a reason

- **PR #268** (`taxonomy_source_versions.subject_id`) is a **draft** and **not applied anywhere**.
  It is hardening with **no current consumer**; nothing in the shipping path joins the two subject-key
  namespaces. Its natural trigger is TASK-0054 §A. Park it again if you find yourself there by
  accident.

---

## Traps that have already cost this project time

1. **`apply_migration` writes no local file** and assigns its own version. Always commit a file named
   with the **recorded** version. A mismatch makes the next `db push` re-apply it. This is the cause
   of TASK-0055.
2. **Read the NEWEST migration touching a table**, not the one that created it. On 2026-09-29 I
   reported `content_item_cells.skill_code` nullability as "schema drift"; migration
   `20260927004500` had made topic-only tagging deliberate *and already guarded* the MATCH SIMPLE
   hazard I "discovered".
3. **A `content_item_cells` row means a topic was asserted, not a skill.** `skill_code` is nullable.
   Filter `skill_code is not null` or you will overcount skill labelling — 406 topics vs 304 skills
   (Statistics only) on 2026-09-29.
4. **Subject keys live in two namespaces.** Registry is hyphenated (`ap-statistics`), taxonomy is
   underscored (`ap_statistics`). `replace('_','-')` maps nine of ten and **silently drops Biology**,
   whose registry key is `biology`, not `ap-biology`. Use `app.normalize_student_subject_key()`.
   A miss returns zero rows, which serving reports as "this subject has no content".
5. **Deploying `evaluate-attempt` requires the CLI with an explicit `--workdir`.** The Supabase MCP
   `deploy_edge_function` tool refuses it at 200,000 bytes — that is a **tool** limit, not a platform
   limit, and a previous session propagated the false claim that the function could not be deployed
   at all into three documents.
   ```bash
   supabase functions deploy evaluate-attempt --project-ref pcntajvbdfqhbeewmdry \
     --workdir /Users/davidbloom/Documents/Cramapple.nosync
   ```
6. **A Production deploy is refused by the auto-mode permission classifier** (`[Production Deploy]`).
   That is expected. Stop and get explicit per-action authorization from David rather than looking
   for another route.
7. **A merged-but-unapplied migration is a live hazard**, because the next `db push` runs it
   unreviewed. Apply to Dev, verify, get approval, apply to Prod, *then* merge.

---

## Decisions waiting on David

| # | Question | Where |
|---|---|---|
| 1 | The 34 historical `grading_results` rows still holding the placeholder — leave as an honest record (recommended) or backfill? | TASK-0053 |
| 2 | Is "immediate re-practice" (a similar bite-sized problem after a wrong answer) separately launch gating? It is a serving decision, not a feedback string. | TASK-0053 |
| 3 | Generated per-answer MCQ feedback instead of the four-shape rotation — worth the cost and latency? Revisit if Orly says the rotation reads mechanical. | TASK-0053 |
| 4 | Grain for reference content's skill link — topic, or topic × skill cell? | TASK-0054 |
| 5 | AP Physics C: E&M is short 14 topics in both brief tables — author now, or mark the subject partial? | TASK-0054 |
| 6 | The pre-v2 re-authoring batch against the CED fact packs, open since 2026-08-21 — run it or formally retire it? | TASK-0054 |
| 7 | `content_item_cells_validation_check` requires a human `validated_by`, so a model-consensus `validated` is rejected by the database. Relax the CHECK, or use a synthetic profile? | TASK-0050 / DECISION-0085 |
| 8 | How far back should ledger recovery go, and should the CI check block or warn? | TASK-0055 |
