# TASK-0051 — Open Hand: One Gated Answer-Key Path

**Status:** Approved to execute in Development. Production Hard-Gated.
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

## Severity context — do not let this get re-escalated or forgotten

Step 0 established that **no student-facing exposure exists today**: `open-hand-item` is deployed in
Dev with **no caller**, the Open Hand screens are demo-only components fed local sample content with
no network call, Dev's exclusions table holds 0 rows, and Production has no `open-hand-item` at all.

The gap becomes real **the moment the plate loop is wired to live data**, which is what
`PLATE_LOOP_BUILD_PLAN_2026_09_27.md` sets out to do. **The exclusion mechanism must land in the
same change as that wiring, not as a follow-up.** That is the one scheduling constraint here.

## Verification

- [ ] Amended RPC applied to Development; entitlement-scoped access confirmed; staff/QA path
      confirmed to view without writing an exclusion row.
- [ ] Anonymous, unentitled, retired-pack and unpublished-item calls all confirmed to fail.
- [ ] Called twice for the same student/item: same key returned, exactly one exclusion row.
- [ ] **One load of the Open Hand screen writes exactly N exclusions, where N = the number of items
      whose key was actually returned** — the guard against the list-endpoint pool burn (item 5).
- [ ] A student calling `public.get_open_hand_item` **directly** via PostgREST, bypassing the edge
      function, is subject to the same entitlement check and the same exclusion write (item 6).
- [ ] Staff/QA caller: key returned, **no** exclusion row written.
- [ ] Known negative, recorded whether or not it is fixed here: an excluded item can still be
      **served** by `student-session-items` / `get_home_start_queue`, so the student meets the `409`
      only after submitting.
- [ ] Dev/Production object parity checked explicitly (table columns, function signature, grants).
- [ ] `anon` and `authenticated` still cannot directly select `mcq_choices.is_correct` or
      `.rationale`.
- [ ] End-to-end, as one sequence: view an item's key through Open Hand, submit an attempt on that
      same item, assert `409 open_hand_item_not_scorable`.
- [ ] Negative case: an item never viewed in Open Hand still scores normally.
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
