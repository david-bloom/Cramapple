# Interaction Data Gaps — Running List

STATUS: living tracker | STARTED: 2026-09-27 | OWNER: unassigned

Phase 0 output per `docs/product/STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md`. One row per
finding, evidence query + count, moved to **§2 Closed** when resolved. Nothing deleted.

**How to use this file**
- Every count is read-only against **Cramapple – Production** (`pcntajvbdfqhbeewmdry`) unless stated.
- This first pass is **partial** — see "Not yet run" at the bottom. Do not treat this as a completed
  Phase 0; it re-confirms the plan doc's own numbers and closes one open decision, nothing more.

---

## 1. Open

(IDG-5 and IDG-1 moved to §2 Closed, 2026-09-27 — see below for the live-verification evidence. Nothing
else currently open in this section as of this pass — see "Not yet run" at the bottom for what Phase 0
still hasn't covered.)

## 2. Closed

### IDG-5 — CLOSED, 2026-09-27: `attempts`' entire grading-truth update was silently failing on every real attempt
- **Symptom (2026-09-27):** Not just `confidence_level`/`result_summary` (IDG-1) — **every** column the
  post-grading `attempts.update()` writes is 0% populated: `status` is only ever `draft`/`submitted`
  (never `graded`/`uncertain`), `graded_at`/`score_points`/`score_possible` are null on all 104 rows.
  Meanwhile `grading_results` (a separate table, updated two lines earlier in the same function)
  genuinely has real scores — grading itself works. `updated_at` is byte-identical to `submitted_at` on
  every recent attempt: the row has never once been touched by any UPDATE since creation.
- **Mechanism:** `app.attempts` carries a trigger, `attempts_prevent_client_grading_truth_update`, that
  raises an exception on exactly these columns (`score_points`, `score_possible`, `graded_at`,
  `confidence_level`, `result_state`, `result_summary`, or a `status` transition into
  `graded`/`uncertain`) **unless** `current_setting('request.jwt.claim.role', true) = 'service_role'`.
  `evaluate-attempt/index.ts`'s `.update()` call for this never captured `{ error }` — a Postgres
  exception here is silently swallowed by `@supabase/supabase-js` (it returns `{ error }`, it does not
  throw), consistent with the code visibly containing the right update and it never landing.
- **Diagnosis, in three steps, 2026-09-27 — the real cause was narrower than the first hypothesis:**
  1. Dashboard check: the edge-function secret `SUPABASE_SERVICE_ROLE_KEY` is the newer, non-JWT
     `sb_secret_...` format. First hypothesis: PostgREST can't decode a role claim from a non-JWT key.
  2. David repointed the custom `SERVICE_ROLE_KEY` secret at a genuine, correctly-scoped, unexpired
     legacy `service_role` JWT. **This alone did not fix it** — a throwaway Dev/Prod diagnostic function
     (deployed and deleted the same session) proved the JWT decoded correctly (`role: "service_role"`,
     right project ref) and PostgREST verified it fine, yet `current_setting('request.jwt.claim.role',
     true)` still returned `<null>`. That ruled out the key-format hypothesis.
  3. The same diagnostic checked `current_setting('request.jwt.claims', true)` (JSON) and
     `current_setting('role', true)` instead: both were correct (`role: "service_role"` in each). **The
     real bug: this project's current PostgREST version no longer populates the deprecated per-claim
     GUC (`request.jwt.claim.role`) at all, for any caller, JWT or not** — it only sets the consolidated
     JSON `request.jwt.claims` and switches the actual Postgres session role. The trigger was checking a
     GUC that could never be true for anyone, key format was never the issue.
- **Fix applied, 2026-09-27:** migration `20260927200000_fix_grading_truth_role_check.sql` rewrites
  `app.prevent_client_grading_truth_update()` to check `coalesce(current_setting('role', true), '') <>
  'service_role'` instead of the deprecated JWT-claim GUC — the actual, reliable signal PostgREST sets.
  Applied to Dev then Production. **Verified both directions on both environments** before considering
  it done: a scratch attempts row (inserted and deleted by the test, never real data) could be updated
  by the service-role client (previously impossible) and was still correctly rejected for an anon-key
  client (`permission denied for schema app`) — the security boundary is intact, not weakened.
  `_shared/supabase.ts`'s key precedence was left at its original default (prefer the reserved
  `SUPABASE_SERVICE_ROLE_KEY`) after confirming that key was never actually the problem — no reason to
  add a dependency on a manually-managed, Supabase-labeled-deprecated legacy JWT for something the SQL
  fix alone resolves. David's `SERVICE_ROLE_KEY` custom secret still holds the legacy JWT he set; it's
  harmless and unused (a dead fallback again), no action needed on it either way.
- **Also fixed, independent of the trigger fix:** both `attempts.update()` call sites in
  `evaluate-attempt/index.ts` (deterministic and model-graded paths) now capture `{ error }` and
  `console.error("attempts_grading_truth_update_failed", ...)` instead of silently discarding it — extra
  defense so a future recurrence of this class of bug (a different trigger, another GUC deprecation)
  surfaces in logs instead of silently vanishing again.
- **Checked for the same bug class elsewhere:** searched every function in `app`/`public` for
  `request.jwt.claim` — found exactly one other hit, `app.prevent_profile_role_change`. Read directly:
  it checks `current_user <> 'service_role' AND coalesce(current_setting('request.jwt.claim.role',
  true), '') <> 'service_role' AND ...` — the `current_user` check already short-circuits correctly for
  a real service-role connection, so this one was never actually broken. No other occurrences found.
- **Practical impact:** low in retrospect for grading itself (`grading_results` was always the real
  source of truth, per `project_engine_rollout_status_2026_09_20` memory) but this was a real, silent
  gap in `attempts.status`/`graded_at`/`score_points` for every graded attempt ever.
- **Live-verified, 2026-09-27 (new session):** David submitted a real answer at `app.cramapple.com`
  (topic `1.13`) and it graded. Queried Production directly: attempt `d7663902-a06f-4423-8471-706fd4765d8e`
  shows `status`/`result_state` both `"graded"`, `graded_at` set ~1.5s after `submitted_at`,
  `score_points: 0`/`score_possible: 1` — the fix now confirmed on real HTTP traffic, not just the
  scratch-row DB test.

### IDG-1 — CLOSED, 2026-09-27: `attempts.confidence_level` / `result_summary` write-path bug
- **Evidence (2026-09-27, same session as IDG-5's diagnosis):** `count(confidence_level)` = 0/108,
  `count(result_summary)` = 0/108 in `app.attempts`. Matches the 2026-09-26/27 audit exactly — no drift.
- **Status:** Was superseded by, and closed together with, the broader IDG-5 fix — this was never two
  isolated dead columns, it was the entire update silently failing.
- **Live-verified, 2026-09-27 (new session):** the same real attempt above (`d7663902-...`) shows
  `confidence_level: "high"` and `result_summary: "Not quite. Review the selected answer against the
  published choices."` — both columns populate correctly on real traffic now.

## 2. Closed

### IDG-2 — `attempts.assistance_state` still non-discriminating
- **Evidence (2026-09-27):** `count(distinct assistance_state)` = 1 across 108 rows. Confirms the
  mechanism exists but the client always sends the same value (`independent`).
- **Status:** Confirmed, unchanged from prior finding. Fix is Phase 1 item 1 (`attempt_assistance_events`),
  hard-gated on David's hint-definition-boundary decision — see that plan's Open Decisions §1.

### IDG-3 — `grading_results.shadow_result` / `predicted_label` / `stage_timings` — re-confirmed partial/dead
- **Evidence (2026-09-27):** `shadow_result` 0/83 (dormant by design, Engine 3 not active). `predicted_label`
  22/83, `stage_timings` 44/83 — both still partial, matches prior finding exactly.
- **Status:** Not a data decision (per the plan). `shadow_result` needs David's roadmap call (open
  decision #2 in the schema plan); the other two need the skipping code path named (Phase 0 item 6,
  not run this pass).

### IDG-4 — Open decision #3 (schema plan): `attempt_responses` can be frozen/retired — **RESOLVED, retire it**
- **Evidence (2026-09-27):** `select count(*) from app.attempt_responses` → **0 rows, table-wide**, not
  just "less used than `response_versions`" as the plan's Phase 0 item 5a framed the question.
  `response_versions` has 91 rows and is the only response-content table anything writes to today.
- **Answer to schema plan's open decision #3:** yes, freeze/retire `attempt_responses`. No live path
  writes to it at all — this is a clean migration-era duplicate, not a judgment call. Recommend a
  Phase 2 migration to rename it `_deprecated_attempt_responses` for one release then drop, per that
  plan's own Phase 2 process. Not executed in this pass (that's Phase 2 work, sequenced after the rest
  of Phase 0) — flagging the answer so it isn't re-litigated.

### IDG-6 — Phase 0 item 2 (FK integrity): zero orphans; three pre-existing UUID columns lack a declared FK
- **Evidence (2026-09-27):** Ran all five orphan checks the plan names (`grading_results` without
  `attempts`, `response_versions` without an attempt, `attempt_criterion_results` without a matching
  `grading_results` attempt, `session_target_items` without `session_targets`, `student_cell_state`
  referencing a missing topic/skill) plus the same check for the new `attempt_assistance_events` table
  — **zero orphans on all six.**
- **Declared-FK sweep** across all `_id` columns on the plan's nine tables plus the two new Phase 1
  tables found three real, pre-existing gaps (none introduced by today's migrations, which are fully
  FK'd): `grading_results.rubric_version_id`, `student_cell_state.last_attempt_id`, and
  `student_cell_state.last_session_id` carry no FK constraint. The first two are informational/audit
  pointers rather than relational integrity the app depends on (`last_attempt_id` is an idempotency
  stamp, not a live join target) — flagging per the plan's own bar, not proposing to add them
  unilaterally, since retrofitting a FK onto live columns needs a data-integrity check first.

### IDG-7 — Phase 0 item 3 (index health): no actionable finding pre-launch
- **Evidence (2026-09-27):** The three named hot predicates only partially match deployed indexes —
  `attempts` has `(user_id, exam_pack_version_id, submitted_at)`, not `(user_id,
  content_item_version_id)`; `student_cell_state` has `(user_id, next_due_at) WHERE next_due_at IS NOT
  NULL` plus the full `(user_id, taxonomy_source_version, topic_code, skill_code)` unique key (which
  covers `cell-state-persist.ts`'s actual read pattern); `response_versions` has `(attempt_id,
  version_number)`, not `(attempt_id, created_at)`. Every `idx_scan` in `app` is currently 0 and every
  index is under 48 kB — **expected and uninformative pre-launch** (zero real student traffic per
  `project_production_zero_real_students`), not a finding. Per the plan's own words, this check is
  meant to **re-run quarterly after launch**; doing anything with today's zero-scan numbers would be
  guessing from no signal. Not actioned.

### IDG-8 — Phase 0 item 5b (table-split rationality): `attempt_criterion_results` is a second dead table, same shape as `attempt_responses`
- **Evidence (2026-09-27):** `grep -rn "attempt_criterion_results"` across `supabase/functions/` finds
  **zero writers** — no edge function ever inserts into it. `grading_results.criterion_results` (jsonb)
  is what `evaluate-attempt/index.ts` actually writes on every grade (`criterion_results:
  finalResult.criteria` / `finalPayload.criteria`, both call sites). `select count(*) from
  app.attempt_criterion_results` → **0 rows, table-wide.**
- **Answer:** `grading_results.criterion_results` is the sole source of truth; `attempt_criterion_results`
  is a second migration-era duplicate exactly like `attempt_responses` (IDG-4) — same recommendation
  (rename-then-drop in Phase 2), not executed here.

### IDG-9 — Phase 0 item 5c (table-split rationality): `student_memory_events.last_action_hint`/`last_repair_hint` is a legitimate read-model, not a stray duplicate
- **Evidence (2026-09-27):** `_shared/student-memory.ts`'s `buildGradingMemoryState` is the one named
  writer, and every field on that state object follows the same `last_*` rolling-snapshot convention
  (`last_attempt_id`, `last_session_id`, `last_result_state`, …) — this is a deliberate, documented
  per-student running-memory summary consumed for recommendation/coaching context, not a second raw
  copy of `grading_results.action_hint`/`repair_hint` competing for "source of truth." **Passes the
  plan's own bar** ("the copy is documented as a read-model with a named writer") as-is. No action.

---

## Not yet run (full Phase 0, per the schema plan)

- **Item 4 — Naming/typing consistency** audit beyond spot-checking today's own two new tables (both
  clean: `id uuid` PK convention, `timestamptz` throughout, `text + CHECK` enums — no new inconsistency
  introduced). The pre-existing `student_cell_state_id`-vs-`id` naming split is already tracked as the
  schema plan's own open decision #4; not re-litigated here.

This pass re-verified the plan doc's headline numbers (no drift), closed the `attempt_responses` open
decision (IDG-4), ran the FK-integrity and index-health checks (IDG-6/7), resolved both table-split
questions (IDG-8/9), and surfaced one new, high-confidence but unconfirmed production bug (IDG-5: the
`attempts` grading-truth update appears to silently fail on every real attempt — error logging shipped,
root cause needs a live grading event to confirm). Only Phase 0 item 4's full sweep (beyond today's own
new tables) remains genuinely un-run.
