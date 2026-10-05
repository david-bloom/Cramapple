# TASK-0051 — Open Hand: One Gated Answer-Key Path

**Status:** Blocked (independent QA, 2026-09-29) — any signed-in user can read MCQ answer keys directly

> **Update 2026-10-05 — OWNER OVERRIDE (`DECISION-0097` / `APPROVAL-0121`).** David overrode this gate. `public.get_open_hand_item` is now live in Production (ledger version `20260929034129`), verified with no rows written: anon refused, unentitled refused, staff served without an exclusion, `anon`/`public` cannot execute, `mcq_choices.is_correct`/`.rationale` still not selectable. Still open and still owned: fresh independent QA, F3, the excluded-item serving gap, the staff live path, and the per-load exclusion count (TASK-0052).
>
> **Update 2026-09-30:** F1 is fixed in Development and Production by TASK-0056 (`APPROVAL-0063`/`0064`; guard clean on both). F2 (`.limit(1)`) is deployed to Production (`evaluate-attempt` v70). F3 (Dev `open-hand-item` v9) is still open. Status stays Blocked until a **fresh** independent QA re-runs TASK-0051 + TASK-0056.
through PostgREST (`content_item_versions.canonical_answer_1/2`, `.explanation`, `.item_package_payload`;
live in Production too), so "the RPC is the only path to a key" is false and the scoring exclusion can be
sidestepped. The Production gate should not proceed until that is closed. See
`docs/qa/TASK-0051_INDEPENDENT_QA_2026_09_29.md` (F1). _Previously: Approved to execute in Development.
Production Hard-Gated._
**Tier:** Hard-Gate
**Owner:** TBD (single agent, single branch)
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Decision:** `DECISION-0086` (supersedes the competing designs)
**Approval:** `APPROVAL-0061`
**Plan:** `docs/product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`
**Supersedes:** the TASK-0050 label previously carried by `codex/task-0049-open-hand-answer-key`
(TASK-0050 now belongs to the skill-dimension rollout). That branch has now renumbered twice; this
is its final number.
**Area:** Open Hand / answer-key exposure / scoring integrity

## Outcome

One gated path by which a student may see a full answer key, which atomically records that they saw
it and permanently prevents them being scored on that exact content item version — replacing two
competing half-implementations with a single one.

## Decisions this implements (`DECISION-0086`)

- **D1 (c) — Access is entitlement-scoped, with a mandatory exclusion write.** Any authenticated
  user holding an active entitlement for the item's subject may view, on a servable pack. Staff/QA
  roles may view **and are exempt from the exclusion write** — excluding a reviewer from scoring is
  meaningless.
- **D2 (a) — Unify on the RPC.** `open-hand-item` calls `public.get_open_hand_item` rather than
  reading answer tables directly, so the exclusion insert and the key read happen in one statement
  and no window exists in which a student has seen the key without an exclusion row.
- **D3 — This work is TASK-0051.**

## What has to change, and why it is not just plumbing

The existing RPC implements **D1 (a)**, not D1 (c). Adopting D1 (c) requires amending it:

1. **Access predicate.** Replace "owns an active learning session containing the item" with "holds
   an active entitlement for the item's subject, on a servable pack" (`status='published' AND
   retired_at IS NULL`, subject itself active — `SUBJECT_SERVABILITY_CRITERIA.md` criterion 6).
2. **Staff/QA bypass.** The RPC today has *no* admin bypass, by deliberate design. D1 (c) adds one,
   scoped to view-only, and those callers must skip the exclusion insert.
3. **Schema change — `learning_session_id` is `NOT NULL`.** Verified in Dev 2026-09-29:
   `app.open_hand_scoring_exclusions` is `(user_id, content_item_version_id, learning_session_id,
   disclosed_at)`, all `NOT NULL`. Under entitlement-scoped access a caller may have no learning
   session at all, so the insert cannot satisfy that column. **Recommend making it nullable** —
   record the session when one exists, null otherwise — since decoupling from session ownership is
   the entire point of D1 (c). The alternative, continuing to require a session, collapses D1 (c)
   back into D1 (a) in practice.
4. **Payload parity — and `canonical_answer_spans` is answer-bearing.** `get_open_hand_item` returns
   `canonical_answers`, `mcq_choices` and `frq_criteria` only (migration lines 98-135), but
   `open-hand-item` also reads `canonical_answer_spans` directly and returns it as
   `credited_response_spans` (`index.ts:254-262`, `357-362`). Spans are credited-response text: they
   **must move into the RPC**, or they remain an answer-bearing read outside the atomic path with no
   exclusion write — which would defeat the whole change. Only `topic_explainers` and
   `topic_point_briefs` are non-answer-bearing and may stay as direct reads.

5. **Shape mismatch — `open-hand-item` is a LIST endpoint; the RPC is single-item. This needs a
   contract decision, and getting it wrong burns the content pool.** `open-hand-item` returns up to
   50 items per call (`DEFAULT_LIMIT = 20`, `MAX_LIMIT = 50`, lines 47-48; `.slice(0, limit)` at 366).
   `get_open_hand_item` takes one `content_item_version_id` and writes one exclusion. If the function
   simply loops the RPC across a listed page, **every screen load permanently excludes ~20 items for
   that student** — AP Biology has only 43 MCQs with keys, so two Open Hand loads would exclude its
   entire MCQ pool from ever being scored.
   **Recommended contract:** the list step returns **no answer content** (reuse the already-stripped
   `student-session-items` shape), and the answer key is fetched **one item at a time** via the RPC at
   the moment the student opens that item. This changes the endpoint's response shape, so it needs
   David's confirmation before implementation — it is a frontend contract change, not an internal
   refactor.

6. **The RPC — not the edge function — is the real security boundary, and the unified call cannot
   work as literally specified.** Verified: the RPC keys everything on `auth.uid()` (migration line
   41, raising `not_authenticated` at 49), while `open-hand-item` builds a **service-role** client
   (`index.ts:116`), under which `auth.uid()` is NULL — so "the function calls the RPC" fails on the
   very first call. Either forward the caller's JWT through a user-scoped client, or add a
   `p_user_id` parameter executable by `service_role` only.
   Separately, the RPC is granted `execute` to **`authenticated`** (migration 144-145), so any student
   can call it directly through PostgREST and bypass the edge function entirely. Therefore:
   - the entitlement predicate **and** the staff/QA exemption must be enforced **inside the RPC**,
     reading the role from `app.profiles` (precedent: `20260824040000_reviewer_mcq_answer_key_rpc.sql:54-55`);
   - the exemption must **never** be a caller-supplied flag;
   - direct RPC calls are in scope and must be tested, not treated as out-of-band.
   The plan's earlier description of the edge function as "the ONE place answer content is exposed"
   is false while that grant stands.

7. **Exclusion is keyed to `content_item_version_id`, and versions get superseded.** A re-publish
   mints a new version id, and attempts carry a client-supplied `content_item_version_id`
   (`attempt-response/index.ts:410, 526`) — so a student excluded on v1 becomes scorable on v2 of the
   same question. **Recommend also storing `content_item_id` and checking on item id** in
   `evaluate-attempt` (one extra join, still before any answer table is read). Needs David's
   confirmation, since it is a deliberate tightening of the stated contract ("that exact content item
   version").

## Deployment path (there is no bundle blocker)

An earlier draft of this task claimed `evaluate-attempt` could not be deployed because its import
closure exceeds a 200,000-byte limit. **That was wrong** — corrected 2026-09-29 after independent
review. The limit belongs to the Supabase **MCP `deploy_edge_function` tool**, not the platform:
`evaluate-attempt` was deployed to Dev and Production via the **CLI** on 2026-09-27, reaching
Production v61 (`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md:1057-1061`), and Production is on v66 today.

**Deploy with:** `supabase functions deploy evaluate-attempt --project-ref <id> --workdir
/Users/davidbloom/Documents/Cramapple.nosync`. The `--workdir` flag is required — the CLI's default
detection fails silently in this checkout, which has no `supabase/config.toml`. **Do not** refactor
the function to satisfy the MCP tool's limit, and do not use that tool for this function.

## Severity context — CORRECTED 2026-09-29. The caller already exists.

**An earlier version of this section said "no student-facing exposure exists today" because
`open-hand-item` had "no caller." That was wrong.** Verified at Lovable HEAD (`56cae479`):

- `src/lib/open-hand/client.ts` calls `supabase.functions.invoke("open-hand-item", …)` on the
  **superseded batch contract**, typed to receive `is_correct`, `rationale`, `criteria` and
  `credited_response_spans`.
- `src/lib/practice-entry.ts` sends Home's "start practice" to **`/open-hand-mcq`** when the plate-loop
  flag is on; `src/lib/feature-flags.ts` turns that flag on from **`?loop=plate` in the URL** and
  **persists it to `localStorage`**. `/open-hand-mcq` is also reachable by typing it.
- The app points at **Production** Supabase.

So the batch, no-exclusion path is **wired and dormant**, rendering an error only because
`open-hand-item` does not exist in Production. It is not "unwired work."

**Operational consequence — the hard rule for this task.** Deploying **any** function named
`open-hand-item` that returns the batch answer-key shape to Production would immediately expose answer
keys with no exclusion recorded, reachable by URL. #256's P4 step (1) instructed exactly that; it is
annotated as superseded on this branch.

**Recommended resolution (needs Product Owner confirmation — see Open items):** delete the
`open-hand-item` edge function altogether and have the front end call `public.get_open_hand_item`
directly. Its only non-answer payload (`topic_explainers`, `topic_point_briefs`) is already fetched by
the app through `fetchTopicGuides`, so the function adds nothing the RPC does not. Deleting it removes
the dormant batch caller **at the source**, removes one deploy from the Production gate, and lets #256
close outright rather than with a pointer. An acceptance line should assert that no code in the app
imports `functions.invoke("open-hand-item")`.

The wiring itself remains `TASK-0052`.

## Development verification — RUN 2026-09-29

Migration applied to Development as `20260929034129_open_hand_entitlement_scoped_contract`. The file
was renamed from `20260929120000` to match the version Development recorded (MCP `apply_migration`
stamps its own). It sorts after every Production-applied migration, so a plain `db push` will pick it
up, and it is self-sufficient — Production needs only this file, not the superseded
`20260928023843`.

**Schema, verified by query:** `learning_session_id` nullable YES; `content_item_id` NOT NULL;
**exactly one** function overload, signature `(p_content_item_version_id uuid,
p_learning_session_id uuid)` — no PostgREST ambiguity; zero `anon`/`authenticated` grants on the
table.

**Access matrix, executed against Development by simulating `auth.uid()` through the JWT-claims GUC —
i.e. exercising the direct-PostgREST path, not the edge function:**

| Case | Result |
| --- | --- |
| Anonymous | `REFUSED not_authenticated` |
| Entitled student | `OK` — key returned (4 choices, `is_correct` present), `exclusion_recorded=true` |
| Unentitled student | `REFUSED open_hand:entitlement_required` |
| Staff (`tutor`) | `OK` — key returned, **`exclusion_recorded=false`**, no row written |
| Same entitled student, second call | `OK`, and still **exactly one** exclusion row (idempotent) |
| Unknown / unpublished item | `REFUSED open_hand:item_not_accessible` |
| Foreign `learning_session_id` | `REFUSED open_hand:session_not_accessible` |

The single written row carried the correct `content_item_id` and a **null** `learning_session_id`,
confirming entitlement-scoped access works with no session — the point of D1(c).

**Ordinary answer-key boundary unchanged:** `authenticated` may still select only `choice_key`,
`choice_text`, `content_item_version_id`, `created_at`, `id` on `app.mcq_choices` — **not**
`is_correct`, **not** `rationale`. `anon` has no grant at all. The RPC is the only path to a key.

**Advisors run.** Two findings touch this work, both intentional and both matching the pre-existing
pattern: `rls_enabled_no_policy` INFO on `open_hand_scoring_exclusions` (1 of 22 such private tables
— RLS forced with no policy is deny-all, and only `service_role` holds `select`), and
`authenticated_security_definer_function_executable` WARN on `get_open_hand_item` (1 of 16 — required
by `DECISION-0086`, since the RPC *is* the boundary students call). Notably `get_open_hand_item` does
**not** appear in the `anon`-executable list.

**Test data cleaned up:** the one exclusion row created during verification was deleted; the table is
back to 0 rows.

**Unit tests:** `student-item-delivery` 42/42 (3 new, including the fail-closed path and the
key-allowlist updated for `open_hand_excluded`), `student-session-items` 26/26, `evaluate-attempt` 3/3
with the table-order assertion extended to prove the item-resolution read touches nothing
answer-bearing. `deno check` clean on both functions.

**Not yet done:** the end-to-end sequence through the deployed edge functions (view a key, then submit
an attempt on that same item, assert `409`). That needs the functions deployed to Development and a
real user JWT; the SQL-level matrix above proves the RPC half but not `evaluate-attempt`'s refusal in
a live request.

## Production hotfix — exclusions table created ahead of this task (2026-09-29, `APPROVAL-0062`)

`evaluate-attempt` v67 (TASK-0053's MCQ-feedback deploy) went to Production from a `main` that
already carried this task's exclusion check, but the table it reads existed only in Development.
Every graded Production submission would have returned 500 `open_hand_eligibility_check_failed`
(zero attempts had arrived, so nobody was affected). Fixed by
`20260929130754_open_hand_scoring_exclusions_table_only.sql`: this task's table section, verbatim,
and nothing else. Applied to Development (no-op) and Production; both ledgers record
`20260929130754`, and the recorded SQL hashes identically to the file.

State after the hotfix:

- **Production has the table but not `public.get_open_hand_item`.** Nothing answer-bearing shipped.
  The table is empty, so `evaluate-attempt` finds no exclusion and grades normally.
- Table parity Dev = Prod on columns, constraints, indexes, forced RLS and the `service_role` grant.
  One environment difference is pre-existing and harmless: Production's `app` schema has a default
  privilege granting `SELECT` to a `content_reviewer` role (100 of 104 `app` tables carry it; the
  role does not exist in Dev). Forced RLS with no policy gives that role zero rows.
- **`20260929034129` can no longer reach Production through `db push`.** Its header says it "sorts
  after every Production-applied migration, so a plain `db push` picks it up." That stopped being
  true when PR #272's migrations (`20260929071941`…`110501`) were recorded in Production. It now
  needs a direct apply followed by the recorded-version rename (runbook Trap 1), or
  `--include-all` once TASK-0055 makes `db push` safe. Its table section is a no-op on top of the
  hotfix.

## Live Development end-to-end — PASSED 2026-09-29

`scripts/open_hand_e2e_dev.mjs`, run by David from his Mac against Development, all 16 checks
passed. A brand-new confirmed student with a real JWT, entitled to AP Statistics:

- read item A's key by calling `public.get_open_hand_item` **directly through PostgREST** (not via
  any edge function), got the key and `exclusion_recorded=true`, and exactly one exclusion row was
  written;
- created, saved and submitted an MCQ attempt on item A, and `evaluate-attempt` refused it with
  **409 `open_hand_item_not_scorable`**;
- did the same on item B, never viewed, which graded normally (200, one `grading_results` row);
- read item A's key again and still had exactly one exclusion row.

Dev's function logs confirm it independently: `evaluate-attempt` 409 at 16:56:28 UTC, then 200 at
16:56:32. The script deleted the student and every row it created. A SQL check afterwards found no
test users, exclusions, entitlements or attempts left.

Dev ran `evaluate-attempt` v33, the same bundle hash as Production v67 and `main`, so this also
exercises the code live in Production (minus the RPC, which Production does not have yet).

Still open, not proven by this run: staff/QA live path, the unentitled/anonymous refusals as live
calls (proven at SQL level above), the Open Hand screen's per-load exclusion count (a frontend
check, TASK-0052), parity, advisors, independent QA, and the Production gate.

## Verification

- [ ] Amended RPC applied to Development; entitlement-scoped access confirmed; staff/QA path
      confirmed to view without writing an exclusion row.
- [ ] Anonymous, unentitled, retired-pack and unpublished-item calls all confirmed to fail.
- [x] Called twice for the same student/item: same key returned, exactly one exclusion row.
- [ ] **One load of the Open Hand screen writes exactly N exclusions, where N = the number of items
      whose key was actually returned** — the guard against the list-endpoint pool burn (item 5).
- [x] A student calling `public.get_open_hand_item` **directly** via PostgREST, bypassing the edge
      function, is subject to the same entitlement check and the same exclusion write (item 6).
- [ ] Staff/QA caller: key returned, **no** exclusion row written.
- [ ] Known negative, recorded whether or not it is fixed here: an excluded item can still be
      **served** by `student-session-items` / `get_home_start_queue`, so the student meets the `409`
      only after submitting.
- [ ] Dev/Production object parity checked explicitly (table columns, function signature, grants).
- [ ] `anon` and `authenticated` still cannot directly select `mcq_choices.is_correct` or
      `.rationale`.
- [x] End-to-end, as one sequence: view an item's key through Open Hand, submit an attempt on that
      same item, assert `409 open_hand_item_not_scorable`.
- [x] Negative case: an item never viewed in Open Hand still scores normally.
- [ ] Database advisors run; any new INFO/WARN explained.
- [ ] Fresh independent QA in a new context, not a continuation of the implementing session.
- [ ] Production: migration + both function deploys, as one coherent change, on David's explicit
      approval.

## Serving side is unaware of exclusions (named follow-up, not silently deferred)

Neither `student-session-items` nor `public.get_home_start_queue`
(`20260927211624_home_start_queue_rpc.sql`) consults `open_hand_scoring_exclusions` — zero references
exist under `supabase/`. So an excluded item can still be **served**: the student answers it, submits,
and only then gets the `409`. The attempt stays `status='submitted'` with no `grading_results` row,
and a retry loop would hit the `409` repeatedly. Integrity holds; the product experience does not.

Either add a `not exists (... open_hand_scoring_exclusions ...)` filter to both selectors, or record
it as an explicit follow-up **plus** a frontend `409`-handling requirement in the plate-loop plan. At
minimum it goes in the verification checklist as a known negative. Do not let this pass unnamed.

## Branch handling

Consolidate onto a single branch; merge `main` in first (the codex branch is 30+ commits behind).
Close the losing PR with a pointer rather than deleting it — closing does not delete the head branch,
only merging does.

**The two branches touch disjoint files and merge into `main` with zero conflicts.** That is the
hazard, not the comfort: nothing will force a reviewer to look. The codex branch carries nine changed
files and only four are Open Hand code. Explicit disposition required for the rest:

| Item | Disposition |
| --- | --- |
| `be31f102` "structured content-block contract for topic briefs and Learn More" (257 lines across `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`, `TOPIC_LEARN_MORE_BRIEFS_2026_08_20.md`, `docs/INDEX.md`) | **Split into its own PR.** Its own commit message calls it a separate workstream; it is unrelated to Open Hand and must not ride in on this merge. |
| `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` — codex marks O5 and O9 "RESOLVED, TASK-0050" and describes the **D1(a)** contract as the resolution; D17 cross-references TASK-0050 | **Rewrite before merge.** All three are wrong under `DECISION-0086`. Cite TASK-0051 / DECISION-0086 and mark "in progress, Production gated" — not "RESOLVED". |
| `docs/tasks/TASK-0050-OPEN-HAND-ANSWER-KEY.md` | **Delete**, folding its history into this file. Its filename does **not** collide with main's `TASK-0050-SKILL-DIMENSION-ROLLOUT.md`, so git will happily keep both and `main` would end up with two TASK-0050 records. |
| `TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md` (+6 lines pointing at the old filename) | Fix the pointer to TASK-0051. |
| #256's `index_test.ts` | Mocks direct table reads; after item 6 it must be **rewritten**, so "carry the tests across" is only partly true. Its `minimal-ci.yml` wiring survives only if the test file does. |
| #256's `PLATE_LOOP_BUILD_PLAN_2026_09_27.md` P4 — "deploy `open-hand-item` to Production (additive, read-only)" | **Rewrite that sentence when carrying it across.** Left as-is it reads as a standing instruction to do the one thing §6 forbids. |
| `docs/INDEX.md` | Add rows for this task and the resolution plan; the docs branch currently adds none. |

## Migration hazards

- The codex migration `20260928023843_open_hand_answer_key_contract.sql` sorts **before** eight
  migrations already applied to Production (`20260928130000` … `20260928191213`). `supabase db push`
  skips files older than the remote's last migration unless `--include-all`.
- Its `create table` is **not idempotent**, and Dev already holds the D1(a) objects while Production
  holds none — so Dev and Production need different handling, not the same file replayed.
- The amendment this task requires changes the function's parameters, and `create or replace` cannot
  drop or rename parameters: it needs an explicit `drop function public.get_open_hand_item(uuid, uuid)`
  first, or a second overload appears and PostgREST calls become ambiguous.
- Add a Dev/Production object-parity check to verification rather than assuming the two match.
