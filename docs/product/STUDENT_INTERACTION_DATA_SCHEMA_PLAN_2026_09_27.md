# Student Interaction Data — Schema Audit, Extension, and Pruning Plan

**Status:** Plan, approved to document; **not yet executed** — no migrations, no code changes
**Owner:** unassigned
**Date:** 2026-09-27
**Author:** Fable (plan drafted per David's request), reviewed by Claude, amended by Fable in response
to two review concerns (both accepted)
**Related:** `DECISION-0074` (mastery rule); `docs/product/CONTENT_GAPS_RUNNING_LIST.md` (the content-gap
tracker this plan's Phase 0 output is modeled on); `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`
(this plan is filed under that launch plan's mastery-derivation item, #20/`DECISION-0074`)

## Purpose

David asked for a plan to (1) confirm the existing student-interaction data schema is rational,
efficient, aligned with the current database, and well implemented; (2) add data the product needs
but doesn't capture today, in the same schema/conventions as existing student-interaction data; and
(3) eliminate dead columns. This document is that plan. It does not implement anything.

## Starting evidence (from the 2026-09-26/27 live audit)

Currently captured, across nine `app`-schema tables in Production (`pcntajvbdfqhbeewmdry`):

- **Response content:** `attempt_responses` (older path), `response_versions` (versioned, with
  `parent_response_version_id` revision lineage), `response_attachments` (drawn/photo files, sha256,
  capture quality)
- **Correctness/scoring:** `attempts.score_points/score_possible/result_state`,
  `grading_results.points_earned/points_available/predicted_label/confidence/uncertainty_reason/
  criterion_results/highest_value_gap`, `attempt_criterion_results` (per-rubric-criterion status,
  evidence_quote, decision_explanation, minimum_fix)
- **Timing:** `attempts.started_at/submitted_at/graded_at`, `grading_results.latency_ms`,
  `grading_results.stage_timings`
- **Hint usage:** `attempts.assistance_state` (CHECK `independent|coached|exam_practice`, set
  client-side at attempt creation; `_shared/cell-state.ts` zeroes evidence weight when `assisted` —
  the mechanism exists, it's just non-discriminating today because the client always sends
  `independent`), `grading_results.action_hint/repair_hint` (these are post-grading feedback hints,
  not pre-submission hint requests)
- **Retry/repair:** `response_versions.parent_response_version_id` (a chain exists, but nothing tags
  *why* a new version was created)
- **Item metadata at attempt time:** `attempts.content_item_version_id`, `exam_pack_version_id`;
  `grading_results.rubric_version_id`, `prompt_version`, `model_id`, `evaluator_version`
- **Session/recommendation context:** `learning_sessions`, `session_targets`/`session_target_items`
  (provenance/fallback), `student_cell_state` (topic_code, skill_code, tier, fragile,
  weighted_evidence, last_event, last_weight, next_due_at, due_reason), `student_memory_events`

**Correction found during this planning pass:** `attempts.confidence_level` and `result_summary` are
**not dead columns** as the initial live-data pass characterized them. `evaluate-attempt/index.ts`
(~lines 1512-1520 and ~2176-2183) writes both on the `graded` status update. 0/108 populated in
Production means the write path isn't being reached, or is failing silently — **a bug to diagnose in
Phase 0**, not a column to drop in Phase 2. Also: `confidence_level` is *grader* confidence by code
intent and must not be repurposed as the new student self-report field (see Phase 1 item 4).

**Confirmed genuinely dead or non-discriminating:**
- `attempts.assistance_state` — populated but always the same value (mechanism exists, unused signal)
- `grading_results.shadow_result` — 0/83, dormant **by design** (Engine 3 symbolic_ecf shadow mode not
  active on this traffic) — this is a product-roadmap question, not a data-cleanliness one
- `grading_results.predicted_label` (22/83) / `stage_timings` (44/83) — partial, not fully dead

**Needed but not captured:**
1. Hint timing (before-submit vs. after-submit) and count per attempt — required to enforce
   `DECISION-0074`'s "no hint use prior to submission" mastery rule; `student_cell_state` cannot audit
   this today.
2. Item-type mix (MCQ vs. FRQ) per counted mastery evidence — `student_cell_state` has no way to
   verify the "2 MCQ + 1 FRQ" rule was actually satisfied per cell.
3. Active engagement/time-on-task — only wall-clock start→submit exists.
4. Student confidence self-report — a column with this name exists but is grader-owned and unused
   for this purpose.
5. Retry-reason tagging — can't distinguish a repair-prompt-triggered retry from a voluntary edit.
6. Recommendation/next-best-action provenance — no dedicated log of why the recommender chose an item.

## Phase 0 — Live audit

**Size:** M, ~2-3 days. **Produces:** `docs/product/INTERACTION_DATA_GAPS_RUNNING_LIST.md`, modeled on
`CONTENT_GAPS_RUNNING_LIST.md` (one row per finding, evidence query + count, moved to a Closed section
when resolved, nothing deleted), plus a per-table scorecard.

All checks run as read-only SQL against Production, results pasted as evidence:

1. **Population rates, re-verified live** for every column on the nine tables
   (`count(col)/count(*)`, `count(distinct col)`) — not assumed from this doc's summary, which will
   already be a few days stale by the time this runs. Bucket each column: dead (0), non-discriminating
   (1 distinct value), partial (<80%, must be path-explained), live.
2. **FK integrity:** `information_schema.referential_constraints` for the nine tables, plus orphan
   queries the other direction (`grading_results` without `attempts`, `response_versions` without an
   attempt, `attempt_criterion_results` without a `grading_results`, `session_target_items` without a
   `session_targets`, `student_cell_state` referencing a missing topic/skill). **Pass = zero orphans
   and every cross-table UUID has a declared FK.**
3. **Index health:** `pg_stat_user_indexes` (never-scanned indexes), missing indexes on FK columns and
   on hot predicates (`attempts(user_id, content_item_version_id)`,
   `student_cell_state(user_id, subject_id, next_due_at)`, `response_versions(attempt_id, created_at)`).
   **Pass = every FK indexed; no unused index over 1 MB kept without a reason row.** Re-run quarterly
   after launch, including against any tables Phase 1 adds.
4. **Naming/typing consistency:** PK style (`id` vs. `<table>_id` — `student_cell_state_id` already
   diverges from `attempts.id`), `timestamptz` everywhere for time, `text + CHECK` for enums (repo
   convention) vs. free text, jsonb only where the schema is genuinely open. Any new inconsistency
   fails; existing ones become tracker rows with a "rename or accept" decision.
5. **Table-split rationality** — three specific questions:
   a. `attempt_responses` vs. `response_versions` — is any live path still writing `attempt_responses`?
      If not, it's a migration-era duplicate.
   b. `grading_results.criterion_results` (jsonb) vs. `attempt_criterion_results` (rows) — the same
      data twice; which is the source of truth, which reads it?
   c. `student_memory_events.last_action_hint/last_repair_hint` vs. `grading_results.action_hint/
      repair_hint` — denormalized copy, or diverging?
   Pass bar: each fact stored once, or the copy is documented as a read-model with a named writer.
6. **Code-path coverage:** for each partial column (`predicted_label`, `stage_timings`, and the
   `confidence_level`/`result_summary` write-path bug above), name the function/branch that skips it.
   `grep -rn` in `supabase/functions/`, plus a `list_migrations` diff against Dev (the Dev ledger is
   known-unreliable per prior sessions — don't trust it alone).

**"Rational and efficient" pass bar:** every column is either live, partial-with-a-named-path, or on
the elimination list; zero orphans; every FK indexed; one writer per fact.

## Phase 1 — Additive schema

**Size:** M-L. **Depends on:** Phase 0 items 1 and 5, **and** the `DECISION-0074` hint-boundary
addendum below (hard gate on items 1-2 specifically, see Amendment 2).

Convention: migrations under `supabase/migrations/<ts>_interaction_data_*.sql`, `app` schema,
`text + CHECK` enums, `timestamptz`, FK to `attempts.id` on delete cascade, RLS mirroring `attempts`.
**Indexes ship in the same migration as the DDL, not a follow-up** (Amendment 1) — a later add is
exactly the kind of Dev/Prod drift this repo has already been burned by.

| Need | Landing | Why |
| --- | --- | --- |
| 1. Hint timing/count | New table `app.attempt_assistance_events` (`attempt_id`, `event_kind` CHECK, `occurred_at`, `relative_to_submission` CHECK `before\|after` computed at write from `attempts.submitted_at`, `hint_ordinal`, `source`, **and** `counts_toward_hint_rule boolean` populated at write from a new config table `app.assistance_event_policy (event_kind, disqualifies_mastery, effective_from)` — see Amendment 2). Derive `attempts.assistance_state` from this on submit instead of trusting the client; add `pre_submit_hint_count int` on `attempts` as a denormalized read-model. | Per-event granularity matches `attempt_criterion_results`'s pattern; the rollup keeps `cell-state.ts`'s `assisted` gate working with one line changed. Decoupling the CHECK'd `event_kind` from the boolean that actually drives mastery means a future policy change is a data update, not a schema migration. |
| 2. Item-type mix per cell | On `student_cell_state`: `mastery_mcq_correct_count int not null default 0`, `mastery_frq_full_count int not null default 0`, `mastery_reached_at timestamptz`. Counted only when `pre_submit_hint_count = 0`. | Matches the existing scalar-rollup style (`weighted_evidence`, `last_weight`); the events log is the audit trail, the cell row is the fast path. |
| 3. Active time | On `attempts`: `active_ms int`, `idle_ms int` (client heartbeat, capped; `submitted_at - started_at` remains the wall clock). | One fact per attempt; no new table needed. |
| 4. Student confidence | New column `attempts.student_confidence text CHECK (low\|medium\|high)`, set at submit. **Does not reuse `confidence_level`** (grader-owned by code intent — see Phase 2). | Avoids the ambiguity a shared column would create. |
| 5. Retry reason | `response_versions.revision_reason text CHECK (repair_prompt\|voluntary_edit\|reopen\|resubmit_after_capture_fail)`, nullable for historical rows. | Lives with the lineage it explains. |
| 6. Recommendation provenance | New table `app.recommendation_decisions` (`learning_session_id`, `session_target_item_id`, `chosen_content_item_version_id`, `user_id` — denormalized, see index note, `reason_kind` CHECK, `reason_detail jsonb`, `candidate_count`, `ranker_version`, `decided_at`). | `session_targets.provenance/fallback` are too sparse; a decision needs its own row with a ranker version, matching `grading_results.evaluator_version`'s pattern. |

**Index plan (Amendment 1, both tables get `created_at default now()` and RLS mirroring `attempts`):**

`app.attempt_assistance_events`
- `(attempt_id, occurred_at)` — primary read: rebuild `pre_submit_hint_count`/derived
  `assistance_state` at submit, and audit a single attempt's timeline. Covers the FK.
- `(attempt_id) where relative_to_submission = 'before'` — partial index for the `DECISION-0074` gate
  query; small, and it's the one predicate mastery derivation actually runs.
- No index on `event_kind` or `source` alone — low cardinality, always filtered by `attempt_id` first.
- `occurred_at` alone deferred until an analytics read pattern exists (Phase 0 item 3 would flag it
  unused otherwise).

`app.recommendation_decisions`
- `(learning_session_id, decided_at)` — session replay ("why did this session get these items").
  Covers the FK.
- `(session_target_item_id)` — unique, one decision per planned item; doubles as an FK index.
- `(chosen_content_item_version_id, decided_at)` — the content-side read ("how often and why is this
  item recommended"). Covers the FK.
- `(user_id, decided_at)` — requires denormalizing `user_id` onto the row (recommended, mirrors
  `attempts.user_id` so RLS doesn't need a join through `learning_sessions`).
- No GIN index on `reason_detail jsonb` at launch; `reason_kind` (text CHECK) is the filterable field.

Write amplification from three indexes on an append-only table is acceptable at Cramapple's current
row counts. Phase 0 item 3 re-runs quarterly and drops anything `pg_stat_user_indexes` shows as never
scanned.

## Phase 2 — Dead-column elimination

**Size:** S-M. **Depends on:** Phase 0.

Process per column: (1) live re-query the day of the migration, not this doc's numbers; (2) `grep -rn`
across `supabase/functions/`, `supabase/migrations/`, and note that some views (e.g. `progress_dashboard_v1`,
`free_score_check`) select `assistance_state` directly — check the Lovable frontend source too; (3)
rename to `_deprecated_<col>` for one release, then drop.

Expected outcomes:
- `result_summary` — fix the write path (Phase 0 finding); keep.
- `confidence_level` — fix the write path; **rename to `grader_confidence`** to remove the ambiguity
  Phase 1 item 4 would otherwise create. This rename must land **before** `student_confidence` ships,
  to avoid a window with two ambiguously-named confidence columns.
- `assistance_state` — keep, re-sourced from the new events table (Phase 1).
- `shadow_result` — **not a data decision.** Needs David to say whether Engine 3 shadow mode is on the
  roadmap. If yes, keep with a tracker row explaining the dormancy; if no, drop with the Engine 3 code
  path.
- `predicted_label`, `stage_timings` — make the skipping path populate them, or document why it's
  intentionally null; not candidates for dropping as currently understood.

## Sequencing

Phase 0 first, in full. After that:
- **Hard gate, per Amendment 2:** Phase 1 items 1 (`attempt_assistance_events`) and 2 (mastery counters
  on `student_cell_state`) cannot start until David answers the hint-definition-boundary question
  below, recorded as a `DECISION-0074` addendum in `DECISIONS_LOG.md`.
- Phase 1 items 3-6 and Phase 2 are parallelizable once Phase 0 is closed, independent of that gate.
- The `confidence_level`→`grader_confidence` rename (Phase 2) must precede `student_confidence`
  shipping (Phase 1 item 4), to avoid the two-confidence window.
- Frontend heartbeat/hint-event emission is a separate Lovable change that gates items 1 and 3 going
  *live* for real students, not the migration itself.

## Open decisions — David only

1. **Hint-definition boundary (hard gate, blocks Phase 1 items 1-2 specifically — not grouped with
   the items below):** which in-attempt events count as "hint use before submission" for mastery
   purposes under `DECISION-0074`? Candidates: explicit hint request, worked-solution reveal,
   topic-guide open, formula-sheet open, calculator/tool open, re-reading the stem after a wrong MCQ
   pick. **Why this can't wait:** the schema's own CHECK constraint is cheap to widen later (drop and
   re-add, no backfill) — the real risk is which events increment `pre_submit_hint_count` and therefore
   zero `student_cell_state`'s evidence weight. If an event is logged now and later ruled
   non-disqualifying, every mastery count written in the interim needs a recompute from the events
   log; if it's *not* logged now and later ruled disqualifying, that history is unrecoverable. The
   design mitigation (logging the superset of candidate events behind a policy-table boolean, see
   Phase 1 item 1) shrinks the ongoing cost of getting this wrong, but the *initial* policy rows still
   have to be right before real students generate evidence.
2. `shadow_result` / Engine 3 shadow mode — roadmap or retire?
3. Whether `attempt_responses` can be frozen/retired (needs Phase 0 item 5a's evidence first).
4. Accept the `student_cell_state_id`-vs-`id` PK naming inconsistency, or rename now while row counts
   are still small?
5. Whether an `idle_ms` client heartbeat is acceptable telemetry (privacy/complexity), or wall-clock
   timing is sufficient for launch.

None of decisions 2-5 blocks a schema shape and they can be answered on David's own timeline; decision
1 blocks Phase 1 items 1-2 specifically and should be answered before that migration is written.
