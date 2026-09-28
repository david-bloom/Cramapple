# TASK-0049 — Wire the `app.attempt_criterion_results` Writer

**Task ID:** TASK-0049
**Title:** Give `app.attempt_criterion_results` its first writer; stop leaving per-criterion grading
detail only as jsonb inside `grading_results`
**Owner:** Claude (this session, `claude/task-0049-vax3al`)
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Implemented, not verified — needs a live-attempt check before Done
**Priority:** Medium — a real, long-flagged gap, not launch-blocking for Oct 2
**Created Date:** 2026-09-28

## Independent-execution note

David asked for an independent attempt at "task 0049" to run in parallel with, and be comparable to,
a separate Claude execution of the same instruction — without either run influencing the other. This
session did not read any other in-flight session's notes, branch, or scratch output before choosing
scope, and stays on its own branch (`claude/task-0049-vax3al`), unmerged, so this write-up and diff are
available for comparison without being visible to a parallel run unless someone deliberately opens
this branch.

## How this scope was chosen

No `docs/tasks/TASK-0049-*.md` existed at session start (`TASK-0048` was the highest-numbered task on
`main`, status "Planned — not started"). Rather than invent a task, this session read the repo's own
current-priority chain (`docs/team_charter/CRAMAPPLE_SESSION_START.md` →
`docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` →
`docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` → `TASK-0048`) to find the largest genuinely
closeable gap available **from inside this repo, without touching a live/shared system**:

- `TASK-0048` Workstreams 3–6 (Pulse/Independence aggregation, Stage A/B frontend, `experienceStage`
  wiring) all live in `home-snapshot.ts` / `TopicHome.tsx` — confirmed via `list_repos`/`get_project`
  that these files are not in this git repository at all; they're Lovable-managed source for project
  `56cae479` ("New Cramapple App"). Lovable has no branch/worktree isolation the way this repo does —
  a `send_message` edit there changes the live, shared app directly. Editing it from an "independent,
  non-influencing, comparable" session would do the opposite of what was asked, so it was ruled out.
- `app.attempt_criterion_results` "has 0 rows — nothing writes to it, though all 78 `grading_results`
  rows carry criterion JSON" is called out as an open gap in
  `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (plan 4 row) and in `ACTIVITY_LOG.md`'s 2026-09-23
  work-order-F handoff ("Task chip open"). It is entirely git-repo scope
  (`supabase/functions/evaluate-attempt/index.ts`), and a prior migration
  (`20260731160400_criterion_partially_earned_status.sql`) explicitly widened the table's `status`
  CHECK **in anticipation of this exact wiring** — its own comment says "this migration is therefore
  not unblocking anything right now; it exists so the constraint does not become a silent landmine the
  first time that table is wired up." This is that wiring.

## Product Goal

`app.attempt_criterion_results` is the row-level table a reviewer/analytics/mastery-detail query would
actually want (one row per attempt × criterion: status, points, evidence, minimum-fix) instead of
reaching into `grading_results.criterion_results` jsonb every time. It has existed since the schema
baseline with RLS, grants, and a student-owner SELECT policy already in place — only the writer was
missing.

## Technical Scope

`supabase/functions/evaluate-attempt/index.ts`:

1. Added `persistAttemptCriterionResults(service, attemptId, criteria, evaluatorVersion)` — a
   best-effort, swallowed-on-failure helper (same posture as the existing
   `persistGradingTelemetry`: a row-level detail write must never be able to fail a grade). Maps each
   `OutputCriterion` (`criterion_key`, `status`, `points_awarded`, `evidence_quote`,
   `decision_explanation`, `minimum_fix`) 1:1 onto the table's columns — the shapes already matched
   exactly, no new normalization needed — and upserts on `(attempt_id, criterion_key)`, the table's
   existing unique index, so a re-grade of the same attempt replaces its prior per-criterion rows
   instead of hitting the constraint.
2. Called it at both sites that currently write `grading_results.criterion_results` for a resolved
   item:
   - The MCQ / rule-based path (`isMcq` branch), right after that path's own telemetry write, with
     `evaluator_version: "rule-based-mcq"`.
   - The general FRQ/LLM/symbolic/shadow-review convergence point (the single `grading_results`
     update all non-MCQ routing targets funnel into), with `evaluator_version: routedModelId` — the
     same value already stamped onto `grading_results.model_id` for that row, so the two tables trace
     to the same evaluator identity.
3. No migration needed — the table, its columns, RLS, grants, and the `partially_earned`-inclusive
   CHECK all already exist and already accept every status this code can produce.

## Out of Scope (and why)

- **Backfilling history.** The 78 existing `grading_results` rows' `criterion_results` jsonb is not
  replayed into the new table. That's a separate, explicit decision (a one-time backfill script) that
  should be proposed on its own, not folded into "add the writer."
- **`TASK-0048` Workstreams 3–6.** Lovable-hosted, out of this repo's write surface — see above.
- **Any change to `grading_results` itself**, the grading routes, or the deterministic/shadow logic —
  this only adds a second, best-effort write next to work that already happens; it changes no grading
  outcome.

## Verification status — be honest about what this session could and could not check

This sandbox has no `deno` binary (network egress to `deno.land` is denied by the environment's proxy
policy) and no live Supabase project credentials for a real end-to-end grade. Per this repo's own
stated method ("verify against live systems, don't infer from reading code or plans" —
`APP_LAUNCH_READINESS_INDEX_2026_09_26.md`), this task is **not** Done by that bar yet. What was
actually done:

- Read both call sites' surrounding code in full before editing, including the two existing analogous
  jsonb writes (`grading_results.criterion_results`) the new rows are meant to mirror, to confirm field
  names and types line up with the table's columns without transformation.
- Confirmed `service_role` already holds `SELECT, INSERT, DELETE, UPDATE` on
  `app.attempt_criterion_results` (schema baseline) — no new grant required.
- Confirmed the unique index `attempt_criterion_results_one_criterion_per_attempt` on
  `(attempt_id, criterion_key)` exists and is what `onConflict: "attempt_id,criterion_key"` targets.
- Manually re-read the diff for syntax and type-shape correctness in place of a `deno check` run.

**Not done, and this is the actual next step for whoever picks this up:** run `deno check` and the
existing `evaluate-attempt` test suite, then grade one real attempt (MCQ and FRQ, ideally in Dev first)
and confirm a matching row lands in `app.attempt_criterion_results` with the right `status`/
`points_awarded`/`evaluator_version`.

## Acceptance Criteria

- [x] `persistAttemptCriterionResults` added, best-effort, upserts on `(attempt_id, criterion_key)`.
- [x] Wired into the MCQ/rule-based grading path.
- [x] Wired into the FRQ/LLM/symbolic/shadow-review convergence path.
- [ ] `deno check` clean (not run in this sandbox — see Verification status).
- [ ] Existing `evaluate-attempt` test suite still green (not run in this sandbox).
- [ ] A real graded attempt (Dev, then Production) produces a matching
      `app.attempt_criterion_results` row — not yet verified live.

## Comparison notes for David

If a separate Claude (or Codex) session also ran "task 0049" independently, the useful diff to compare
is: **which gap each session chose**, and **whether each stayed inside git-branch-isolated scope or
touched a live/shared system** (Lovable, Production Supabase) while claiming independence. This session
deliberately picked the smallest real, git-scoped, previously-flagged gap it could find and left it
unmerged and unverified-live rather than guess at correctness against a production grading path it
could not test.
