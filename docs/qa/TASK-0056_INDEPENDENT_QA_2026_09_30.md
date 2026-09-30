# TASK-0056 — Independent QA (answer-key direct-read exposure)

STATUS: CURRENT
DATE: 2026-09-30
ROLE: QA, fresh context. Not the implementing session, not the session that wrote the brief. Proposes findings only; approves nothing; changed nothing.
BRIEF: `docs/qa/TASK-0056_INDEPENDENT_QA_BRIEF.md`
TASK: `docs/tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md` · `DECISION-0089` · `APPROVAL-0063` (Dev) · `APPROVAL-0064` (Prod)
UNBLOCKS (or not): `TASK-0051`'s Production gate
ENVIRONMENTS: Development `wmgjsdkphcyhngaffbqf` (reads plus rolled-back writes) · Production `pcntajvbdfqhbeewmdry` (read-only)

## Verdict: **BLOCKED**

TASK-0056 did what it set out to do. All seven columns it named — `canonical_answer_1/2`, `explanation`,
`item_package_payload`, and `frq_criteria`'s `evidence_requirements` / `minimum_fix` / `accepted_variants` —
return `42501` or `42703` to a student and to `anon`, on both environments. Inference through `WHERE`,
`ORDER BY` and `GROUP BY` on a column the caller cannot select is denied. Write-side exfiltration is denied.
Error messages carry no row content. `get_review_item_version` gates exactly as specified. `get_open_hand_item`
is correct on Dev and genuinely absent from Production. The F2 `.limit(1)` fix is deployed: Production
`evaluate-attempt` v70 is byte-identical to `main` across all 24 files. The three migrations are recorded on
both environments under their own file versions with MD5s matching the committed files. The execution was good.

The block is that the claim under test is still false. **The same answer key is duplicated in
`app.content_item_versions.prompt_json`, which migration `20260930120200` grants to `authenticated` in its
safe-column list and `20260930120100` projects into `public.content_item_versions`.** On Production today a
signed-in student reads it — including through `public.select_practice_frqs`, the live student FRQ path the
task file logs as a passing verification. This is the same failure mode `TASK-0051` F1 blocked on, one column
over: a key readable with no entitlement check and no `open_hand_scoring_exclusions` row, so a student can
read the answer and still be scored. The guard returns **zero rows on both environments** while this is live.

Three things kept it hidden. The guard is a hardcoded nine-pair list, so it cannot see a tenth column.
Development's `prompt_json` holds no answer content, so the Dev access matrix was structurally incapable of
failing. And the Production verification counted rows returned by `select_practice_frqs` without looking
inside them.

---

## Method, and what to discount

Three independent fresh-context agents ran the brief: two on sections A and B (route enumeration and the
attack matrix) with no knowledge of each other, one on C, D and E. Both A/B agents reached the same BLOCKER
independently, by different routes and with different fixtures. The BLOCKER was then **re-verified directly
by the reconciling session** against Production before this report was written; those queries and results are
in F1 and are the numbers used throughout.

Role testing was done in SQL with `set local role` plus `set local request.jwt.claims` — the mechanism
PostgREST enforces — inside `begin; … rollback;`. Live HTTP with a real JWT was not possible: this
container's egress proxy replaces the `Authorization` header, the same constraint `TASK-0051` QA recorded as
its F7. Production received SELECT statements only; every Dev write was rolled back and leftover state was
checked and found empty. No key, rubric, secret or JWT content appears in this report.

**Discount appropriately:** the agents are models, not subject-matter reviewers. The BLOCKER is verified
first-hand and is arithmetic, not judgement. The MINOR findings are single-agent observations.

---

## Findings

### F1 — BLOCKER · `prompt_json` is an unrevoked duplicate of the answer key, live on Production

**What.** `app.content_item_versions.prompt_json` carries `canonical_answers`, `mcq_choices[].is_correct`,
`mcq_choices[].rationale`, `criteria`, `scoring_contract` and `accepted_variants`. It is `SELECT`-granted to
`authenticated` on the base table **and** on the `public` view.

**Evidence — Production, verified by the reconciling session.**

Grants:

| Route | grantee | privilege |
|---|---|---|
| `app.content_item_versions.prompt_json` | `authenticated` | SELECT |
| `public.content_item_versions.prompt_json` | `authenticated` | SELECT |

Content, over 1,506 published versions (no key contents read):

| Check | Count |
|---|---|
| `prompt_json` contains the **exact string** of the revoked `canonical_answer_1` | **212** |
| `prompt_json` contains the first 60 chars of the revoked `explanation` | **46** |
| has a `canonical_answers` key | 106 |
| contains an `"is_correct"` token | 74 |
| contains `"minimum_fix"` / `"accepted_variants"` / `"evidence_requirements"` | 41 |

Read as a **real Production student** (`0183db49…`, `set local role authenticated`, rolled back, read-only):

| Query | Result |
|---|---|
| `public.content_item_versions where prompt_json ? 'canonical_answers'` | **OK 106 rows** |
| `app.content_item_versions where prompt_json::text ~ '"is_correct"'` | **OK 74 rows** |
| `public.select_practice_frqs(<bio pack>,'targeted_drill',500)` leaking answer/rubric tokens | **OK 12 of 50 served items** |
| `app.mcq_choices.is_correct`, same session (control) | **42501** |

One A/B agent additionally confirmed value-level identity on 5 of 5 sampled items
(`prompt_json->'canonical_answers'->>0 = canonical_answer_1`, lengths pairing `1/1`, `304/304`, `96/96` —
MCQ letter keys and full FRQ model answers). Sample item id `0107c7cf-3cdd-4dac-8c15-68afd51abc50`.

**Why it matters.** It defeats all three `DECISION-0089` decisions at once — the key is readable, `explanation`
is readable pre-submission, and rubric criteria are readable with nothing recorded. It re-opens exactly the
hole `TASK-0051` F1 identified, which is the reason that task is Blocked. The last row above is the one that
matters most: this is not a theoretical route, it is what the live FRQ serving function hands the client.

**Proposed fix.** Revoke `prompt_json` from `authenticated`/`anon`, drop it from `public.content_item_versions`,
and replace the pass-through in the `select_*` functions with a whitelisted presentation projection
(`parts`, `stimuli`, `calculator_mode`, `total_points`, `accessibility`) rather than the whole document.
Longer term, stop writing answer material into the document that is also the serving payload.
**Decides: David** — Production grant and view change.

### F2 — BLOCKER · `select_unit_gated_practice_items` is SECURITY DEFINER and returns `prompt_json`

**What.** `public.select_unit_gated_practice_items` is `SECURITY DEFINER` and its `RETURNS TABLE` includes
`prompt_json`. Being DEFINER, **it survives a column revoke** — F1's grant fix alone does not close it.
`public.select_practice_frqs` and `public.select_hand_drawn_pilot_items` also return `prompt_json`; those are
SECURITY INVOKER, so the grant fix does close them, but all three need re-testing afterwards.

**Evidence — Production, as a real student:** 43 rows returned with non-null `prompt_json`, 1 carrying
answer-bearing keys. The function's only subject gate is a check against the caller's
`profiles.active_exam_pack_version_id`, and `has_column_privilege('authenticated','app.profiles','active_exam_pack_version_id','UPDATE')`
is **true** — so a student can repoint it at another subject's pack. When `auth.uid()` is null the subject
gate is skipped entirely; harmless on Production, where `anon` has no EXECUTE, but see F8.

**Proposed fix.** Drop `prompt_json` from the return type of all three, or return a sanitised projection.
Add an explicit `auth.uid() is null → raise` rather than relying on the role grant. **Decides: David.**

### F3 — MAJOR · The guard is a regression detector for a hardcoded list, not a leak detector

`scripts/qa/answer_key_exposure_guard.sql` returned **0 rows on Production and 0 rows on Development** at the
moment F1 was live and exploitable. Its `protected` CTE is a literal nine-pair list; `prompt_json` is not on
it, and neither are `help_text`, `item_package_schema_version`, `app.gold_set_answers` or
`app.content_item_checks`.

Four evasion shapes were built on Dev inside rolled-back transactions:

| # | Technique | Guard | Exploitable as built? |
|---|---|---|---|
| E1 | `select *` view over a protected table | **caught** (4 rows) | yes |
| E2 | View aliasing protected columns (`canonical_answer_1 as study_note`) | **caught** (4 rows) | yes — aliasing defeats nothing, `pg_depend` keys on attnum |
| E3 | Ungated SECURITY DEFINER function returning a protected column | **missed** | **yes** — returned an `explanation` of 49 characters to `authenticated` |
| E4 | New answer-bearing column on a protected table | **missed** | no — blocked by `…120200`'s explicit column grant, not by the guard |
| E5 | Two-hop view (`public` view → ungranted `app` view → protected table) | **missed** | **yes** — 220 rows, 59 non-empty explanations, 212 item packages |

The guard's own header recommends replacing a view with "a SECURITY DEFINER function with its own gate" —
which is precisely the shape it cannot see (E3). Neither live environment contains an instance of the missed
shapes today: a recursive `pg_depend` walk to depth 5 over all views in `public`/`app`/`graphql_public`
returned 0 rows on both, and a `pg_proc` scan found only the three intentionally gated RPCs.

**Proposed fix.** Add `prompt_json` now. Then make the guard derived rather than listed: resolve view→column
dependencies transitively; flag any `prosecdef` function in an exposed schema referencing a protected
relation, against an explicit allow-list; and add a content-shaped scan for answer-bearing JSON keys in any
`anon`/`authenticated`-readable `jsonb` column. The last is the check that would have caught F1.

### F4 — MAJOR · Development cannot reproduce this class of finding

Dev's `prompt_json` contains **zero** answer-bearing rows (211 versions, 0 with `canonical_answers`,
`is_correct` or rubric tokens); `canonical_answer_1` is null on all 220 Dev versions. The grant and the view
projection are identical, so the hole is structurally present — but the Dev access matrix recorded under
`APPROVAL-0063` **could not have failed**. Any verification of an answer-exposure claim has to run against
Production's data shape, not Dev's.

### F5 — MAJOR · The 24-hour Production log watch is vacuous

Production served **zero** requests carrying an `authenticated` JWT in the 2h13m between the apply and the
check (34 anonymous requests, 0 errors). The pre-apply comparison window had 148 authenticated requests.
Every `authenticator`-role error in the full 24h window is on `public.subjects` or
`public.student_course_positions`, none touching the three protected tables, and the last predates the apply
by five hours.

Column revokes fail closed and quietly — that is the exact failure this watch exists to catch, and it has not
had one chance to fire. **Do not tick it on elapsed time.** Tick it after the live practice session, and only
once the window contains a non-trivial count of authenticated requests. **Decides: David.**

### F6 — MINOR · `explanation` has no post-submission delivery path

`DECISION-0089` item 2 names the grading response as `explanation`'s intended path.
`evaluate-attempt/index.ts` selects it, but `buildEvaluateAttemptResponse` never includes it. The intended
path does not exist. Not a leak — but note F1 means `explanation` text *is* readable pre-submission for 46
Production items, the inverse of the decision.

### F7 — MINOR · Default privileges re-expose anything new in `public`

`pg_default_acl` on both environments grants `arwdDxtm` on new `public` relations to `anon` and
`authenticated`, and EXECUTE on new functions to both. `…120100` handled this correctly with an explicit
`revoke all` — but only because the author remembered. Recommend
`alter default privileges in schema public revoke all on tables from anon, authenticated`.

### F8 — MINOR · Dev/Prod drift makes Dev a permissive proxy

On Dev, `select_unit_gated_practice_items`, `select_practice_frqs` and `select_hand_drawn_pilot_items` are
`anon`-executable; on Production they are not. Dev advisors report
`anon_security_definer_function_executable` for eight functions; Production reports none. Drift in the
direction of more permissive than Production weakens Dev as a QA proxy.

### F9 — MINOR · `public.mcq_choices` grants ALL to `anon` and `authenticated` on both environments

`relacl` is `arwdDxtm` for both roles — Supabase's default re-grant after the `20260827010001` recreate,
which `…120100` fixed on the other two views but not this one. Inert today: the view is `security_invoker`
and `anon` holds no base-table grant, so `select` as `anon` returns `42501`, verified. Worth correcting
because `arwdDxtm` includes INSERT/UPDATE/DELETE. **Decides: David** (Production grant change).

### F10 — MINOR · `public.questions` exposes `rubric` and `answer_choices`, latent

Every column, including `answer_choices`, `rubric` and `teaching_package`, is granted to `anon` and
`authenticated`, with an RLS policy letting any signed-in user read every approved row. Harmless only
because the table is **empty on Production** (0 rows). If it is ever repopulated it is an immediate full-key
leak. Drop the grants or the table.

### F11 — MINOR · Ledger/file mismatch on `20260827010001` (runbook Trap 1)

Both ledgers record `20260827010001`, MD5 `839885b2…`, length 851. The repo has no file at that version — it
has `20260827010000_…` (2892 B), which is in neither ledger. Dev and Prod agree with each other; neither
agrees with a committed file. The three TASK-0056 migrations do **not** have this problem (table below).
Functionally the replay is correct: `public.mcq_choices` no longer projects `is_correct` or `rationale` on
either environment, verified.

### F12 — MINOR · Guard hygiene and rollback completeness

The guard's `canonical_answer_spans` branch uses `to_regclass`, which returns NULL for a missing name instead
of raising — so a rename silently disables that branch, while the nine hardcoded pairs use `::regclass` and
fail loudly. Opposite failure modes in one script. Separately, `…120100`'s rollback is prose rather than
runnable DDL, omits `with (security_invoker = true)` on the recreated views, and predates `…120200` so cannot
state the required reverse order across the three migrations. Assessed, not run.

### F13 — MINOR · Guard CI job is a daily cron against one unnamed database

`.github/workflows/servable-items-check.yml` runs the guard on `schedule: "0 9 * * *"` and
`workflow_dispatch` only, against a single `SERVABLE_ITEMS_CHECK_DB_URL` secret. Nothing in the repo says
which environment that is, and there is no second job. A migration reintroducing a leak can merge and stay
live up to 24 hours, and only one environment is watched.

### F14 — MINOR · `…120200` applied to Dev slightly beyond `APPROVAL-0063`'s enumerated scope

`APPROVAL-0063` lists three items; `…120200` is a fourth migration, written after the guard showed
`…120100`'s revokes were no-ops, and recorded in the log as "Same scope." Noted for completeness, not
disputed: the log is transparent, the change is squarely within item (3)'s intent, it is Dev-only, and
`APPROVAL-0064` names all three versions explicitly for Production. Nothing beyond `APPROVAL-0063`/`0064`
was found on either environment.

---

## What passed

| Check | Dev | Prod |
|---|---|---|
| Seven named columns, student and `anon` | `42501`/`42703` | `42501`/`42703` |
| `public` view columns removed | `42703` | `42703` |
| Inference via `WHERE` / `ORDER BY` / `GROUP BY` on protected columns | denied | denied |
| Write-side exfiltration (`UPDATE … SET (select protected)`) | `42501` | not run (read-only) |
| Error messages echo row content | no | no |
| `get_review_item_version`: student / unassigned / assigned / admin / `anon` | 0 / 0 / 1 / 1 / `42501` | 0 / 0 / 1 / 1 / `42501` |
| `get_open_hand_item` absent from Production | present (correct) | **absent** ✔ |
| Open Hand: unentitled refused, entitled gets key + exactly 1 exclusion row | ✔ | n/a |
| `evaluate-attempt` v70 vs `main` | — | **24/24 files byte-identical** |
| `public.mcq_choices` no longer projects `is_correct`/`rationale` | ✔ | ✔ |
| Views reaching a protected column at any hop (recursive, depth 5) | 0 | 0 |
| `pg_graphql` / `graphql_public` surface | not installed | not installed |
| Storage buckets (`content-assets`, `validation-artifacts`, `learner-uploads`) | gated | gated |
| `byoq` (`verify_jwt=false`) references to the item bank | none | none |

### Migration ledger vs committed files

| Version | File MD5 | Dev ledger | Prod ledger | Match |
|---|---|---|---|---|
| `20260930120000` | `0ea08da6…` | `0ea08da6…` | `0ea08da6…` | ✅ |
| `20260930120100` | `b5937120…` | `b5937120…` | `b5937120…` | ✅ |
| `20260930120200` | `3b4bc8a2…` | `3b4bc8a2…` | `3b4bc8a2…` | ✅ |

No renames. The task's claim holds exactly as stated.

---

## Not verified

- **Live HTTP with real JWTs.** The container's egress proxy replaces the `Authorization` header (TASK-0051
  QA F7). All role testing was SQL-level with `role` + `request.jwt.claims`, which is the boundary PostgREST
  enforces, but it is not the HTTP surface itself.
- **`evaluate-attempt` returning 409 end to end.** Needs an HTTP call and a graded submit; the brief forbids
  a smoke test creating a real student. Verified by reading the deployed v70 source.
- **Admin flows on Dev.** No admin exists on Dev (`0` rows in `app.profiles where role='admin'`).
- **Practice FRQ / unit-gated serving on Dev.** No published practice-format FRQ; the unit-gated call returned
  `22023 subject_taxonomy_unavailable`. Data gaps, not permission errors.
- **Browser click-through** of student practice, graded submit and the reviewer portal. No browser route from
  this container.
- **Which database the CI guard targets, and whether its first post-apply run was green.** The secret is not
  readable from the repo and `gh` is unavailable here.
- **Lovable client code** (project `56cae479`) — database-side routes only were enumerated.

---

## Recommendation on TASK-0051's Production gate

**Do not open it.** `TASK-0051` is Blocked because a student can read a key outside the atomic
disclose-and-exclude path. That is still true on Production, through `prompt_json` (F1) and through a
SECURITY DEFINER function that no grant change will close (F2). Deploying `get_open_hand_item` now would ship
a metered door beside an open window, and would make things worse in one specific way: the exclusion row
implies a scoring-integrity guarantee that is not enforceable while F1 stands.

Before re-gating: close `prompt_json` on the table, the view and all three `select_*` functions; add the
content-shaped check to the guard and confirm it goes **red** against today's Production state before the fix
and green after; and re-run the verification against Production data rather than Dev (F4). Then re-run this
matrix. **David decides on each — all three are Production grant or view changes.**

Neither `TASK-0056`'s status nor `TASK-0051`'s was changed by this QA. That belongs to the implementing
session and to David.
