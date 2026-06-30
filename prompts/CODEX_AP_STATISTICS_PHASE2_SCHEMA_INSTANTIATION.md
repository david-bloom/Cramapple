# Codex Execution Prompt — TASK-0013 Phase 2: AP Statistics Schema Instantiation

**Cleared to execute.** David authorized this migration on 2026-06-30
(`DECISION-0032`, `APPROVAL-0025`), satisfying the Database Migrations Hard
Gate (`STANDING_APPROVAL_LANES.md` Lane 3) separately from Phase 0's
task-level approval. Scope is exactly as drafted below — no broader
migration authority is granted.

## Context

`docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` Phase 2 originally described
this as creating an `exam_pack` and a `taxonomy_scheme` for AP Statistics.
Schema review found there is no separate `taxonomy_scheme` table —
that was aspirational language in
`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §6, not yet built. The real
implementation is `app.content_labels`, keyed off `exam_pack_id`, with a
generic `label_type` (`topic`/`unit`/`skill`/`difficulty`/`workflow`,
`supabase/migrations/202606200001_initial_app_schema.sql:160`). So this
phase is simpler than originally scoped: it's additive seed data, the same
shape as `supabase/migrations/202606200003_seed_ap_biology_exam_pack.sql`,
not new infrastructure.

`app.subjects` already exists
(`supabase/migrations/202606230002_subjects_normalization.sql`) and
`app.exam_packs.subject_id` already has an FK to it. `evaluate-attempt`
already reads `exam_packs.exam_name` per-row (PR #20) — once this migration
lands, AP Statistics grades through the exact same code path as AP Biology
with no further code change, per that PR's note on where Phase 2 plugs in.

## Goal

One additive migration that makes AP Statistics a real, resolvable subject
in the schema — with zero impact on AP Biology data or behavior.

## Scope

1. Insert one row into `app.subjects`: `subject_key = 'ap-statistics'` (or
   whatever key is consistent with how the existing `'biology'` row reads —
   check it first, don't assume), `display_name = 'AP Statistics'`,
   `status = 'active'`.
2. Insert one row into `app.exam_packs`: `exam_code` (pick something
   parallel to `'ap_biology'`, e.g. `'ap_statistics'`), `exam_name = 'AP
   Statistics'`, `subject_id` pointing at the new subjects row. Insert a
   corresponding `app.exam_pack_versions` row — `status` should be
   `'draft'`, not `'published'`, since there's no content yet
   (`evaluate-attempt` already gates on `examPackVersion.status ===
   'published'`, so this is the natural way to keep AP Statistics
   unreachable by real grading traffic until Phase 4 content actually
   exists and someone deliberately publishes it).
3. Insert `app.content_labels` rows, `label_type = 'unit'`, one per AP
   Statistics unit (1–9), using the per-unit MCQ/FRQ counts recorded in
   `TASK-0013-AP-STATISTICS-LAUNCH.md`'s Approval State section as the
   basis for `label_name` (e.g. unit number + whatever short name you can
   responsibly infer is the College Board AP Statistics unit topic — if
   you're not confident of the official unit names, use a placeholder like
   `"AP Statistics Unit 3"` rather than guessing at official College Board
   unit titles, since those may carry rights/sourcing implications per
   `CONTENT_GOVERNANCE_AND_VALIDATION.md`). `status = 'draft'` for all of
   them — Orly reviews and publishes per the task's delegation table.
4. Write the migration to be idempotent on rerun (`on conflict do
   update`/`do nothing`, matching the pattern in
   `202606200003_seed_ap_biology_exam_pack.sql` and
   `202606230002_subjects_normalization.sql`), wrapped in `begin`/`commit`.
5. Confirm via `EXPLAIN` or a dry read (not a live apply — you likely don't
   have a connected Postgres instance in this environment either; if so,
   say so explicitly rather than claiming verification you didn't do) that
   the migration only inserts, touches no existing AP Biology row, and
   every constraint (unique keys, status checks, FK targets) is satisfied
   by the literal values you're inserting.

## Out of Scope

- Publishing the exam pack or any content_labels row — `status: 'draft'`
  only. Publishing is a separate, later decision (Phase 4/6 territory).
- Any actual AP Statistics question/FRQ/MCQ content — that's Phase 4,
  Orly's lane, not this migration.
- Touching `app.exam_packs.subject` (the old free-text column) — leave it
  as-is; reconciling it with `subject_id` was flagged as a Phase 2 cleanup
  note by QA on PR #20, but is not required to ship this migration and
  shouldn't block it.
- Any code change to `evaluate-attempt`/`grade-frq` — Phase 1 already made
  them subject-driven; this phase is data-only.

## Required Evidence on Completion

- The migration file.
- Confirmation (or explicit statement of inability to confirm, if no live
  DB is reachable) that it's idempotent and additive-only.
- A short note confirming the exact `subject_key`/`exam_code` values chosen
  and why, so Orly and David can sanity-check them before any publish
  decision.

## Do Not Touch

- Production environment, secrets, deployment config.
- Any row belonging to the existing AP Biology exam pack.
- `status` fields beyond `'draft'` for anything new in this migration.

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...`, referencing `TASK-0013`,
ready for the same independent QA pattern used on PR #20/#21 — fresh-context
review, verify from source, Pass/Fail with file:line findings.
