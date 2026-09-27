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

*(none from this pass — see Closed below)*

## 2. Closed

### IDG-1 — `attempts.confidence_level` / `result_summary` write-path bug — still open, numbers re-confirmed
- **Evidence (2026-09-27):** `count(confidence_level)` = 0/108, `count(result_summary)` = 0/108 in
  `app.attempts`. Matches the 2026-09-26/27 audit exactly — no drift.
- **Status:** Not closed, just re-verified live. The write-path bug (`evaluate-attempt/index.ts`
  ~L1512-1520, ~L2176-2183 writes both on `graded` status but nothing lands) still needs a diagnosis
  pass — out of scope for this read-only audit slice.

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

---

## Not yet run (full Phase 0, per the schema plan)

- **Item 2 — FK integrity** (orphan queries across all nine tables): not run this pass.
- **Item 3 — Index health** (`pg_stat_user_indexes`, missing FK indexes): not run this pass.
- **Item 4 — Naming/typing consistency** audit: not run this pass (the `student_cell_state_id`-vs-`id`
  inconsistency is already known and tracked as the schema plan's open decision #4).
- **Item 5b/5c — table-split rationality** for `grading_results.criterion_results` (jsonb) vs.
  `attempt_criterion_results` (rows), and `student_memory_events` vs. `grading_results` hint-copy
  fields: not run this pass.
- **Item 6 — code-path coverage grep** for the partial columns above: not run this pass.

This pass only re-verified the plan doc's headline numbers against live Production (no drift found) and
closed one of the five open decisions (`attempt_responses`). The remaining Phase 0 items are still real,
un-started work — do not read this file as "Phase 0 done."
