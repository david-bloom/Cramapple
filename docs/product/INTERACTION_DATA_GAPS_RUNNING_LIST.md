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

### IDG-5 — HIGH-CONFIDENCE, UNCONFIRMED: `attempts`' entire grading-truth update silently fails on every real attempt
- **Evidence (2026-09-27):** Not just `confidence_level`/`result_summary` (IDG-1) — **every** column
  the post-grading `attempts.update()` writes is 0% populated: `status` is only ever `draft`/`submitted`
  (never `graded`/`uncertain`), `graded_at`/`score_points`/`score_possible` are null on all 104 rows.
  Meanwhile `grading_results` (a separate table, updated by a separate call two lines earlier in the
  same function) genuinely has real scores — grading itself works. For the 8 most-recently-submitted
  attempts, `updated_at` is byte-identical to `submitted_at`: the row has **never once been touched**
  by any UPDATE since creation, consistent with every attempt of this write being rejected outright
  (not merely writing a null value).
- **Leading hypothesis, not confirmed:** `app.attempts` carries a trigger,
  `attempts_prevent_client_grading_truth_update`, that raises an exception on exactly these columns
  (`score_points`, `score_possible`, `graded_at`, `confidence_level`, `result_state`, `result_summary`,
  or a `status` transition into `graded`/`uncertain`) **unless**
  `current_setting('request.jwt.claim.role', true) = 'service_role'`. `evaluate-attempt/index.ts`'s
  `.update()` call for this never captured `{ error }` — a Postgres exception here would be silently
  swallowed by `@supabase/supabase-js` (it returns `{ error }`, it does not throw), which is exactly
  consistent with the code visibly containing the right update and it still never landing. If this
  project's `SUPABASE_SERVICE_ROLE_KEY` edge-function secret is the newer, non-JWT `sb_secret_...`
  format rather than the legacy JWT (see `[[feedback_supabase_secret_key_headers]]` — a documented
  gotcha in this exact project), `request.jwt.claim.role` would never resolve to `service_role` for
  these calls, and the trigger would reject every single one — the exact symptom observed. **Could not
  confirm from here**: Postgres/edge logs only retain 24h and the most recent real attempt was
  2026-09-23 (4 days outside that window), and reading the actual secret value is out of bounds for
  this session. Did **not** guess a fix (e.g. touching the trigger or the key) without confirmation —
  that trigger is a deliberate security boundary (`DECISION-0068`'s discussion of this same function).
- **Fixed today, narrowly:** both `attempts.update()` call sites (deterministic and model-graded paths)
  now capture `{ error }` and `console.error("attempts_grading_truth_update_failed", { attempt_id,
  route, error, code })` instead of silently discarding it. This does not fix the underlying cause — it
  makes the next real grading event's logs conclusive instead of silent. Deployed to Dev then Production.
- **Next step, requires either:** (a) a real attempt graded on live Production (same blocker as launch
  plan item 3 — needs David or a handed-over test account) with the resulting edge function logs
  checked for `attempts_grading_truth_update_failed`, or (b) someone with dashboard access confirming
  the `SUPABASE_SERVICE_ROLE_KEY` secret's format directly.
- **Practical impact today:** low for grading itself (`grading_results` is the actual source of truth
  per `project_engine_rollout_status_2026_09_20` memory and this plan's own Phase 0 evidence table) —
  but real, ongoing impact on anything reading `attempts.status`/`graded_at`/`score_points` directly,
  and on `DECISION-0074` mastery capture: `evaluate-attempt` derives `assistance_state` and calls
  `persistCellState` using the **in-memory** `attempt` object from before this failed write, so mastery
  counting itself is unaffected by this specific bug — but a dashboard or downstream job querying
  `attempts` directly for grading status would see every attempt as permanently `submitted`, never
  `graded`.

### IDG-1 — `attempts.confidence_level` / `result_summary` write-path bug — still open, numbers re-confirmed
- **Evidence (2026-09-27):** `count(confidence_level)` = 0/108, `count(result_summary)` = 0/108 in
  `app.attempts`. Matches the 2026-09-26/27 audit exactly — no drift.
- **Status:** Superseded by the broader IDG-5 finding above — this isn't two isolated dead columns, it's
  the entire update silently failing. Error logging shipped; root cause still needs live confirmation.

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
